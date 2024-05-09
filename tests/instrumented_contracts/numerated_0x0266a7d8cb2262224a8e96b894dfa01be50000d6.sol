1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.9;
5 
6 
7 interface IERC20 {
8  
9     function totalSupply() external view returns (uint256);
10 
11   
12     function balanceOf(address account) external view returns (uint256);
13 
14  
15     function transfer(address recipient, uint256 amount) external returns (bool);
16 
17    
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20   
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23    
24     function transferFrom(
25         address sender,
26         address recipient,
27         uint256 amount
28     ) external returns (bool);
29 
30  
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     /**
34      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
35      * a call to {approve}. `value` is the new allowance.
36      */
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 
41 interface IERC20Metadata is IERC20 {
42     /**
43      * @dev Returns the name of the token.
44      */
45     function name() external view returns (string memory);
46 
47     /**
48      * @dev Returns the symbol of the token.
49      */
50     function symbol() external view returns (string memory);
51 
52     /**
53      * @dev Returns the decimals places of the token.
54      */
55     function decimals() external view returns (uint8);
56 }
57 
58 /*
59  * @dev Provides information about the current execution context, including the
60  * sender of the transaction and its data. While these are generally available
61  * via msg.sender and msg.data, they should not be accessed in such a direct
62  * manner, since when dealing with meta-transactions the account sending and
63  * paying for execution may not be the actual sender (as far as an application
64  * is concerned).
65  *
66  * This contract is only required for intermediate, library-like contracts.
67  */
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes calldata) {
74         return msg.data;
75     }
76 }
77 
78 
79 contract ERC20 is Context, IERC20, IERC20Metadata {
80     mapping(address => uint256) private _balances;
81 
82     mapping(address => mapping(address => uint256)) private _allowances;
83 
84     uint256 private _totalSupply;
85 
86     string private _name;
87     string private _symbol;
88 
89  
90     constructor(string memory name_, string memory symbol_) {
91         _name = name_;
92         _symbol = symbol_;
93     }
94 
95     /**
96      * @dev Returns the name of the token.
97      */
98     function name() public view virtual override returns (string memory) {
99         return _name;
100     }
101 
102     /**
103      * @dev Returns the symbol of the token, usually a shorter version of the
104      * name.
105      */
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110  
111     function decimals() public view virtual override returns (uint8) {
112         return 18;
113     }
114 
115     /**
116      * @dev See {IERC20-totalSupply}.
117      */
118     function totalSupply() public view virtual override returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123      * @dev See {IERC20-balanceOf}.
124      */
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128 
129     /**
130      * @dev See {IERC20-transfer}.
131      *
132      * Requirements:
133      *
134      * - `recipient` cannot be the zero address.
135      * - the caller must have a balance of at least `amount`.
136      */
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141 
142     /**
143      * @dev See {IERC20-allowance}.
144      */
145     function allowance(address owner, address spender) public view virtual override returns (uint256) {
146         return _allowances[owner][spender];
147     }
148 
149     /**
150      * @dev See {IERC20-approve}.
151      *
152      * Requirements:
153      *
154      * - `spender` cannot be the zero address.
155      */
156     function approve(address spender, uint256 amount) public virtual override returns (bool) {
157         _approve(_msgSender(), spender, amount);
158         return true;
159     }
160 
161     /**
162      * @dev See {IERC20-transferFrom}.
163      *
164      * Emits an {Approval} event indicating the updated allowance. This is not
165      * required by the EIP. See the note at the beginning of {ERC20}.
166      *
167      * Requirements:
168      *
169      * - `sender` and `recipient` cannot be the zero address.
170      * - `sender` must have a balance of at least `amount`.
171      * - the caller must have allowance for ``sender``'s tokens of at least
172      * `amount`.
173      */
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180 
181         uint256 currentAllowance = _allowances[sender][_msgSender()];
182         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
183         unchecked {
184             _approve(sender, _msgSender(), currentAllowance - amount);
185         }
186 
187         return true;
188     }
189 
190     /**
191      * @dev Atomically increases the allowance granted to `spender` by the caller.
192      *
193      * This is an alternative to {approve} that can be used as a mitigation for
194      * problems described in {IERC20-approve}.
195      *
196      * Emits an {Approval} event indicating the updated allowance.
197      *
198      * Requirements:
199      *
200      * - `spender` cannot be the zero address.
201      */
202     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
204         return true;
205     }
206 
207     /**
208      * @dev Atomically decreases the allowance granted to `spender` by the caller.
209      *
210      * This is an alternative to {approve} that can be used as a mitigation for
211      * problems described in {IERC20-approve}.
212      *
213      * Emits an {Approval} event indicating the updated allowance.
214      *
215      * Requirements:
216      *
217      * - `spender` cannot be the zero address.
218      * - `spender` must have allowance for the caller of at least
219      * `subtractedValue`.
220      */
221     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
222         uint256 currentAllowance = _allowances[_msgSender()][spender];
223         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
224         unchecked {
225             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
226         }
227 
228         return true;
229     }
230 
231     /**
232      * @dev Moves `amount` of tokens from `sender` to `recipient`.
233      *
234      * This internal function is equivalent to {transfer}, and can be used to
235      * e.g. implement automatic token fees, slashing mechanisms, etc.
236      *
237      * Emits a {Transfer} event.
238      *
239      * Requirements:
240      *
241      * - `sender` cannot be the zero address.
242      * - `recipient` cannot be the zero address.
243      * - `sender` must have a balance of at least `amount`.
244      */
245     function _transfer(
246         address sender,
247         address recipient,
248         uint256 amount
249     ) internal virtual {
250         require(sender != address(0), "ERC20: transfer from the zero address");
251         require(recipient != address(0), "ERC20: transfer to the zero address");
252 
253         _beforeTokenTransfer(sender, recipient, amount);
254 
255         uint256 senderBalance = _balances[sender];
256         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
257         unchecked {
258             _balances[sender] = senderBalance - amount;
259         }
260         _balances[recipient] += amount;
261 
262         emit Transfer(sender, recipient, amount);
263 
264         _afterTokenTransfer(sender, recipient, amount);
265     }
266 
267     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
268      * the total supply.
269      *
270      * Emits a {Transfer} event with `from` set to the zero address.
271      *
272      * Requirements:
273      *
274      * - `account` cannot be the zero address.
275      */
276     function _mint(address account, uint256 amount) internal virtual {
277         require(account != address(0), "ERC20: mint to the zero address");
278 
279         _beforeTokenTransfer(address(0), account, amount);
280 
281         _totalSupply += amount;
282         _balances[account] += amount;
283         emit Transfer(address(0), account, amount);
284 
285         _afterTokenTransfer(address(0), account, amount);
286     }
287 
288     /**
289      * @dev Destroys `amount` tokens from `account`, reducing the
290      * total supply.
291      *
292      * Emits a {Transfer} event with `to` set to the zero address.
293      *
294      * Requirements:
295      *
296      * - `account` cannot be the zero address.
297      * - `account` must have at least `amount` tokens.
298      */
299     function _burn(address account, uint256 amount) internal virtual {
300         require(account != address(0), "ERC20: burn from the zero address");
301 
302         _beforeTokenTransfer(account, address(0), amount);
303 
304         uint256 accountBalance = _balances[account];
305         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
306         unchecked {
307             _balances[account] = accountBalance - amount;
308         }
309         _totalSupply -= amount;
310 
311         emit Transfer(account, address(0), amount);
312 
313         _afterTokenTransfer(account, address(0), amount);
314     }
315 
316     /**
317      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
318      *
319      * This internal function is equivalent to `approve`, and can be used to
320      * e.g. set automatic allowances for certain subsystems, etc.
321      *
322      * Emits an {Approval} event.
323      *
324      * Requirements:
325      *
326      * - `owner` cannot be the zero address.
327      * - `spender` cannot be the zero address.
328      */
329     function _approve(
330         address owner,
331         address spender,
332         uint256 amount
333     ) internal virtual {
334         require(owner != address(0), "ERC20: approve from the zero address");
335         require(spender != address(0), "ERC20: approve to the zero address");
336 
337         _allowances[owner][spender] = amount;
338         emit Approval(owner, spender, amount);
339     }
340 
341     /**
342      * @dev Hook that is called before any transfer of tokens. This includes
343      * minting and burning.
344      *
345      * Calling conditions:
346      *
347      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
348      * will be transferred to `to`.
349      * - when `from` is zero, `amount` tokens will be minted for `to`.
350      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
351      * - `from` and `to` are never both zero.
352      *
353      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
354      */
355     function _beforeTokenTransfer(
356         address from,
357         address to,
358         uint256 amount
359     ) internal virtual {}
360 
361     /**
362      * @dev Hook that is called after any transfer of tokens. This includes
363      * minting and burning.
364      *
365      * Calling conditions:
366      *
367      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
368      * has been transferred to `to`.
369      * - when `from` is zero, `amount` tokens have been minted for `to`.
370      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
371      * - `from` and `to` are never both zero.
372      *
373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
374      */
375     function _afterTokenTransfer(
376         address from,
377         address to,
378         uint256 amount
379     ) internal virtual {}
380 }
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 abstract contract Ownable is Context {
395     address private _owner;
396 
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor() {
403     }
404 
405     /**
406      * @dev Returns the address of the current owner.
407      */
408     function owner() public view virtual returns (address) {
409         return _owner;
410     }
411 
412     /**
413      * @dev Throws if called by any account other than the owner.
414      */
415     modifier onlyOwner() {
416         require(owner() == _msgSender(), "Ownable: caller is not the owner");
417         _;
418     }
419 
420     /**
421      * @dev Leaves the contract without owner. It will not be possible to call
422      * `onlyOwner` functions anymore. Can only be called by the current owner.
423      *
424      * NOTE: Renouncing ownership will leave the contract without an owner,
425      * thereby removing any functionality that is only available to the owner.
426      */
427     function renounceOwnership() public virtual onlyOwner {
428         _setOwner(address(0));
429     }
430 
431     /**
432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
433      * Can only be called by the current owner.
434      */
435     function transferOwnership(address newOwner) public virtual onlyOwner {
436         require(newOwner != address(0), "Ownable: new owner is the zero address");
437         _setOwner(newOwner);
438     }
439 
440     function _setOwner(address newOwner) internal {
441         address oldOwner = _owner;
442         _owner = newOwner;
443         emit OwnershipTransferred(oldOwner, newOwner);
444     }
445 }
446 
447 /**
448  * @dev Contract module which allows children to implement an emergency stop
449  * mechanism that can be triggered by an authorized account.
450  *
451  * This module is used through inheritance. It will make available the
452  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
453  * the functions of your contract. Note that they will not be pausable by
454  * simply including this module, only once the modifiers are put in place.
455  */
456 abstract contract Pausable is Context {
457     /**
458      * @dev Emitted when the pause is triggered by `account`.
459      */
460     event Paused(address account);
461 
462     /**
463      * @dev Emitted when the pause is lifted by `account`.
464      */
465     event Unpaused(address account);
466 
467     bool private _paused;
468 
469     /**
470      * @dev Initializes the contract in unpaused state.
471      */
472     constructor() {
473         _paused = false;
474     }
475 
476     /**
477      * @dev Returns true if the contract is paused, and false otherwise.
478      */
479     function paused() public view virtual returns (bool) {
480         return _paused;
481     }
482 
483     /**
484      * @dev Modifier to make a function callable only when the contract is not paused.
485      *
486      * Requirements:
487      *
488      * - The contract must not be paused.
489      */
490     modifier whenNotPaused() {
491         require(!paused(), "Pausable: paused");
492         _;
493     }
494 
495     /**
496      * @dev Modifier to make a function callable only when the contract is paused.
497      *
498      * Requirements:
499      *
500      * - The contract must be paused.
501      */
502     modifier whenPaused() {
503         require(paused(), "Pausable: not paused");
504         _;
505     }
506 
507     /**
508      * @dev Triggers stopped state.
509      *
510      * Requirements:
511      *
512      * - The contract must not be paused.
513      */
514     function _pause() internal virtual whenNotPaused {
515         _paused = true;
516         emit Paused(_msgSender());
517     }
518 
519     /**
520      * @dev Returns to normal state.
521      *
522      * Requirements:
523      *
524      * - The contract must be paused.
525      */
526     function _unpause() internal virtual whenPaused {
527         _paused = false;
528         emit Unpaused(_msgSender());
529     }
530 }
531 
532 interface IUniswapV2Pair {
533     event Approval(address indexed owner, address indexed spender, uint value);
534     event Transfer(address indexed from, address indexed to, uint value);
535 
536     function name() external pure returns (string memory);
537     function symbol() external pure returns (string memory);
538     function decimals() external pure returns (uint8);
539     function totalSupply() external view returns (uint);
540     function balanceOf(address owner) external view returns (uint);
541     function allowance(address owner, address spender) external view returns (uint);
542 
543     function approve(address spender, uint value) external returns (bool);
544     function transfer(address to, uint value) external returns (bool);
545     function transferFrom(address from, address to, uint value) external returns (bool);
546 
547     function DOMAIN_SEPARATOR() external view returns (bytes32);
548     function PERMIT_TYPEHASH() external pure returns (bytes32);
549     function nonces(address owner) external view returns (uint);
550 
551     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
552 
553     event Mint(address indexed sender, uint amount0, uint amount1);
554     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
555     event Swap(
556         address indexed sender,
557         uint amount0In,
558         uint amount1In,
559         uint amount0Out,
560         uint amount1Out,
561         address indexed to
562     );
563     event Sync(uint112 reserve0, uint112 reserve1);
564 
565     function MINIMUM_LIQUIDITY() external pure returns (uint);
566     function factory() external view returns (address);
567     function token0() external view returns (address);
568     function token1() external view returns (address);
569     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
570     function price0CumulativeLast() external view returns (uint);
571     function price1CumulativeLast() external view returns (uint);
572     function kLast() external view returns (uint);
573 
574     function mint(address to) external returns (uint liquidity);
575     function burn(address to) external returns (uint amount0, uint amount1);
576     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
577     function skim(address to) external;
578     function sync() external;
579 
580     function initialize(address, address) external;
581 }
582 
583 interface IUniswapV2Factory {
584     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
585 
586     function feeTo() external view returns (address);
587     function feeToSetter() external view returns (address);
588 
589     function getPair(address tokenA, address tokenB) external view returns (address pair);
590     function allPairs(uint) external view returns (address pair);
591     function allPairsLength() external view returns (uint);
592 
593     function createPair(address tokenA, address tokenB) external returns (address pair);
594 
595     function setFeeTo(address) external;
596     function setFeeToSetter(address) external;
597 }
598 
599 interface IUniswapV2Router01 {
600     function factory() external pure returns (address);
601     function WETH() external pure returns (address);
602 
603     function addLiquidity(
604         address tokenA,
605         address tokenB,
606         uint amountADesired,
607         uint amountBDesired,
608         uint amountAMin,
609         uint amountBMin,
610         address to,
611         uint deadline
612     ) external returns (uint amountA, uint amountB, uint liquidity);
613     function addLiquidityETH(
614         address token,
615         uint amountTokenDesired,
616         uint amountTokenMin,
617         uint amountETHMin,
618         address to,
619         uint deadline
620     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
621     function removeLiquidity(
622         address tokenA,
623         address tokenB,
624         uint liquidity,
625         uint amountAMin,
626         uint amountBMin,
627         address to,
628         uint deadline
629     ) external returns (uint amountA, uint amountB);
630     function removeLiquidityETH(
631         address token,
632         uint liquidity,
633         uint amountTokenMin,
634         uint amountETHMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountToken, uint amountETH);
638     function removeLiquidityWithPermit(
639         address tokenA,
640         address tokenB,
641         uint liquidity,
642         uint amountAMin,
643         uint amountBMin,
644         address to,
645         uint deadline,
646         bool approveMax, uint8 v, bytes32 r, bytes32 s
647     ) external returns (uint amountA, uint amountB);
648     function removeLiquidityETHWithPermit(
649         address token,
650         uint liquidity,
651         uint amountTokenMin,
652         uint amountETHMin,
653         address to,
654         uint deadline,
655         bool approveMax, uint8 v, bytes32 r, bytes32 s
656     ) external returns (uint amountToken, uint amountETH);
657     function swapExactTokensForTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external returns (uint[] memory amounts);
664     function swapTokensForExactTokens(
665         uint amountOut,
666         uint amountInMax,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external returns (uint[] memory amounts);
671     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
672         external
673         payable
674         returns (uint[] memory amounts);
675     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
676         external
677         returns (uint[] memory amounts);
678     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
679         external
680         returns (uint[] memory amounts);
681     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
682         external
683         payable
684         returns (uint[] memory amounts);
685 
686     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
687     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
688     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
689     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
690     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
691 }
692 
693 interface IUniswapV2Router02 is IUniswapV2Router01 {
694     function removeLiquidityETHSupportingFeeOnTransferTokens(
695         address token,
696         uint liquidity,
697         uint amountTokenMin,
698         uint amountETHMin,
699         address to,
700         uint deadline
701     ) external returns (uint amountETH);
702     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
703         address token,
704         uint liquidity,
705         uint amountTokenMin,
706         uint amountETHMin,
707         address to,
708         uint deadline,
709         bool approveMax, uint8 v, bytes32 r, bytes32 s
710     ) external returns (uint amountETH);
711 
712     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
713         uint amountIn,
714         uint amountOutMin,
715         address[] calldata path,
716         address to,
717         uint deadline
718     ) external;
719     function swapExactETHForTokensSupportingFeeOnTransferTokens(
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external payable;
725     function swapExactTokensForETHSupportingFeeOnTransferTokens(
726         uint amountIn,
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external;
732 }
733 
734 contract WenLambo is ERC20, Ownable, Pausable {
735 
736     // variables
737     
738     uint256 private initialSupply;
739    
740     uint256 private denominator = 100;
741 
742     uint256 private swapThreshold = 0.0000009 ether; // The contract will only swap to ETH, once the fee tokens reach the specified threshold
743     
744     uint256 private devTaxBuy;
745     uint256 private liquidityTaxBuy;
746    
747     
748     uint256 private devTaxSell;
749     uint256 private liquidityTaxSell;
750     uint256 public maxWallet;
751     
752     address private devTaxWallet;
753     address private liquidityTaxWallet;
754     
755     
756     // Mappings
757     
758     mapping (address => bool) private blacklist;
759     mapping (address => bool) private excludeList;
760    
761     
762     mapping (string => uint256) private buyTaxes;
763     mapping (string => uint256) private sellTaxes;
764     mapping (string => address) private taxWallets;
765     
766     bool public taxStatus = true;
767     
768     IUniswapV2Router02 private uniswapV2Router02;
769     IUniswapV2Factory private uniswapV2Factory;
770     IUniswapV2Pair private uniswapV2Pair;
771     
772     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
773     {
774         initialSupply =_supply * (10**18);
775         maxWallet = initialSupply * 2 / 100; 
776         _setOwner(msg.sender);
777         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
778         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
779         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
780         taxWallets["liquidity"] = address(0);
781         setBuyTax(0,0); //dev tax, liquidity tax
782         setSellTax(1,98); //dev tax, liquidity tax
783         setTaxWallets(0x5A43C4b15475727de2629aA87fe0dCC241d22E2C); 
784         exclude(msg.sender);
785         exclude(address(this));
786         exclude(devTaxWallet);
787         _mint(msg.sender, initialSupply);
788     }
789     
790     
791     uint256 private devTokens;
792     uint256 private liquidityTokens;
793     
794     
795     /**
796      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
797      */
798     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
799         address[] memory sellPath = new address[](2);
800         sellPath[0] = address(this);
801         sellPath[1] = uniswapV2Router02.WETH();
802         
803         if(!isExcluded(from) && !isExcluded(to)) {
804             uint256 tax;
805             uint256 baseUnit = amount / denominator;
806             if(from == address(uniswapV2Pair)) {
807                 tax += baseUnit * buyTaxes["dev"];
808                 tax += baseUnit * buyTaxes["liquidity"];
809                
810                 
811                 if(tax > 0) {
812                     _transfer(from, address(this), tax);   
813                 }
814                 
815                 
816                 devTokens += baseUnit * buyTaxes["dev"];
817                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
818 
819             } else if(to == address(uniswapV2Pair)) {
820                 
821                 tax += baseUnit * sellTaxes["dev"];
822                 tax += baseUnit * sellTaxes["liquidity"];
823                 
824                 
825                 if(tax > 0) {
826                     _transfer(from, address(this), tax);   
827                 }
828                 
829                
830                 devTokens += baseUnit * sellTaxes["dev"];
831                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
832                 
833                 
834                 uint256 taxSum =  devTokens + liquidityTokens;
835                 
836                 if(taxSum == 0) return amount;
837                 
838                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
839                 
840                 if(ethValue >= swapThreshold) {
841                     uint256 startBalance = address(this).balance;
842 
843                     uint256 toSell = devTokens + liquidityTokens / 2 ;
844                     
845                     _approve(address(this), address(uniswapV2Router02), toSell);
846             
847                     uniswapV2Router02.swapExactTokensForETH(
848                         toSell,
849                         0,
850                         sellPath,
851                         address(this),
852                         block.timestamp
853                     );
854                     
855                     uint256 ethGained = address(this).balance - startBalance;
856                     
857                     uint256 liquidityToken = liquidityTokens / 2;
858                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
859                     
860                     
861                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
862                    
863                     
864                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
865                     
866                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
867                         address(this),
868                         liquidityToken,
869                         0,
870                         0,
871                         taxWallets["liquidity"],
872                         block.timestamp
873                     );
874                     
875                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
876                     
877                     if(remainingTokens > 0) {
878                         _transfer(address(this), taxWallets["dev"], remainingTokens);
879                     }
880                     
881                     
882                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
883                    require(success, "transfer to  dev wallet failed");
884                     
885                     
886                     if(ethGained - ( devETH + liquidityETH) > 0) {
887                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
888                         require(success1, "transfer to  dev wallet failed");
889                     }
890 
891                     
892                     
893                     
894                     devTokens = 0;
895                     liquidityTokens = 0;
896                     
897                 }
898                 
899             }
900             
901             amount -= tax;
902             if (to != address(uniswapV2Pair)){
903                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
904             }
905            
906         }
907         
908         return amount;
909     }
910     
911     function _transfer(
912         address sender,
913         address recipient,
914         uint256 amount
915     ) internal override virtual {
916         require(!paused(), "ERC20: token transfer while paused");
917         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
918         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
919         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
920         
921         if(taxStatus) {
922             amount = handleTax(sender, recipient, amount);   
923         }
924 
925         super._transfer(sender, recipient, amount);
926     }
927     
928     /**
929      * @dev Triggers the tax handling functionality
930      */
931     function triggerTax() public onlyOwner {
932         handleTax(address(0), address(uniswapV2Pair), 0);
933     }
934     
935     /**
936      * @dev Pauses transfers on the token.
937      */
938     function pause() public onlyOwner {
939         require(!paused(), "ERC20: Contract is already paused");
940         _pause();
941     }
942 
943     /**
944      * @dev Unpauses transfers on the token.
945      */
946     function unpause() public onlyOwner {
947         require(paused(), "ERC20: Contract is not paused");
948         _unpause();
949     }
950 
951      /**
952      * @dev set max wallet limit per address.
953      */
954 
955     function setMaxWallet (uint256 amount) external onlyOwner {
956         require (amount > 10000, "NO rug pull");
957         maxWallet = amount * 10**18;
958     }
959     
960     /**
961      * @dev Burns tokens from caller address.
962      */
963     function burn(uint256 amount) public onlyOwner {
964         _burn(msg.sender, amount);
965     }
966     
967     /**
968      * @dev Blacklists the specified account (Disables transfers to and from the account).
969      */
970     function enableBlacklist(address account) public onlyOwner {
971         require(!blacklist[account], "ERC20: Account is already blacklisted");
972         blacklist[account] = true;
973     }
974     
975     /**
976      * @dev Remove the specified account from the blacklist.
977      */
978     function disableBlacklist(address account) public onlyOwner {
979         require(blacklist[account], "ERC20: Account is not blacklisted");
980         blacklist[account] = false;
981     }
982     
983     /**
984      * @dev Excludes the specified account from tax.
985      */
986     function exclude(address account) public onlyOwner {
987         require(!isExcluded(account), "ERC20: Account is already excluded");
988         excludeList[account] = true;
989     }
990     
991     /**
992      * @dev Re-enables tax on the specified account.
993      */
994     function removeExclude(address account) public onlyOwner {
995         require(isExcluded(account), "ERC20: Account is not excluded");
996         excludeList[account] = false;
997     }
998     
999     /**
1000      * @dev Sets tax for buys.
1001      */
1002     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
1003         buyTaxes["dev"] = dev;
1004         buyTaxes["liquidity"] = liquidity;
1005        
1006     }
1007     
1008     /**
1009      * @dev Sets tax for sells.
1010      */
1011     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
1012 
1013         sellTaxes["dev"] = dev;
1014         sellTaxes["liquidity"] = liquidity;
1015         
1016     }
1017     
1018     /**
1019      * @dev Sets wallets for taxes.
1020      */
1021     function setTaxWallets(address dev) public onlyOwner {
1022         taxWallets["dev"] = dev;
1023         
1024     }
1025 
1026     function claimStuckTokens(address _token) external onlyOwner {
1027  
1028         if (_token == address(0x0)) {
1029             payable(owner()).transfer(address(this).balance);
1030             return;
1031         }
1032         IERC20 erc20token = IERC20(_token);
1033         uint256 balance = erc20token.balanceOf(address(this));
1034         erc20token.transfer(owner(), balance);
1035     }
1036     
1037     /**
1038      * @dev Enables tax globally.
1039      */
1040     function enableTax() public onlyOwner {
1041         require(!taxStatus, "ERC20: Tax is already enabled");
1042         taxStatus = true;
1043     }
1044     
1045     /**
1046      * @dev Disables tax globally.
1047      */
1048     function disableTax() public onlyOwner {
1049         require(taxStatus, "ERC20: Tax is already disabled");
1050         taxStatus = false;
1051     }
1052     
1053     /**
1054      * @dev Returns true if the account is blacklisted, and false otherwise.
1055      */
1056     function isBlacklisted(address account) public view returns (bool) {
1057         return blacklist[account];
1058     }
1059     
1060     /**
1061      * @dev Returns true if the account is excluded, and false otherwise.
1062      */
1063     function isExcluded(address account) public view returns (bool) {
1064         return excludeList[account];
1065     }
1066     
1067     receive() external payable {}
1068 }