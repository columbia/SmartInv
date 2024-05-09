1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.20;
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
33     
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 
38 interface IERC20Metadata is IERC20 {
39 
40     function name() external view returns (string memory);
41 
42   
43     function symbol() external view returns (string memory);
44 
45    
46     function decimals() external view returns (uint8);
47 }
48 
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes calldata) {
56         return msg.data;
57     }
58 }
59 
60 
61 contract ERC20 is Context, IERC20, IERC20Metadata {
62     mapping(address => uint256) private _balances;
63 
64     mapping(address => mapping(address => uint256)) private _allowances;
65 
66     uint256 private _totalSupply;
67 
68     string private _name;
69     string private _symbol;
70 
71     /**
72      * @dev Sets the values for {name} and {symbol}.
73      *
74      * The default value of {decimals} is 18. To select a different value for
75      * {decimals} you should overload it.
76      *
77      * All two of these values are immutable: they can only be set once during
78      * construction.
79      */
80     constructor(string memory name_, string memory symbol_) {
81         _name = name_;
82         _symbol = symbol_;
83     }
84 
85     /**
86      * @dev Returns the name of the token.
87      */
88     function name() public view virtual override returns (string memory) {
89         return _name;
90     }
91 
92     
93     function symbol() public view virtual override returns (string memory) {
94         return _symbol;
95     }
96 
97     
98     function decimals() public view virtual override returns (uint8) {
99         return 18;
100     }
101 
102     /**
103      * @dev See {IERC20-totalSupply}.
104      */
105     function totalSupply() public view virtual override returns (uint256) {
106         return _totalSupply;
107     }
108 
109     /**
110      * @dev See {IERC20-balanceOf}.
111      */
112     function balanceOf(address account) public view virtual override returns (uint256) {
113         return _balances[account];
114     }
115 
116     /**
117      * @dev See {IERC20-transfer}.
118      *
119      * Requirements:
120      *
121      * - `recipient` cannot be the zero address.
122      * - the caller must have a balance of at least `amount`.
123      */
124     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
125         _transfer(_msgSender(), recipient, amount);
126         return true;
127     }
128 
129     /**
130      * @dev See {IERC20-allowance}.
131      */
132     function allowance(address owner, address spender) public view virtual override returns (uint256) {
133         return _allowances[owner][spender];
134     }
135 
136     /**
137      * @dev See {IERC20-approve}.
138      *
139      * Requirements:
140      *
141      * - `spender` cannot be the zero address.
142      */
143     function approve(address spender, uint256 amount) public virtual override returns (bool) {
144         _approve(_msgSender(), spender, amount);
145         return true;
146     }
147 
148     /**
149      * @dev See {IERC20-transferFrom}.
150      *
151      * Emits an {Approval} event indicating the updated allowance. This is not
152      * required by the EIP. See the note at the beginning of {ERC20}.
153      *
154      * Requirements:
155      *
156      * - `sender` and `recipient` cannot be the zero address.
157      * - `sender` must have a balance of at least `amount`.
158      * - the caller must have allowance for ``sender``'s tokens of at least
159      * `amount`.
160      */
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(sender, recipient, amount);
167 
168         uint256 currentAllowance = _allowances[sender][_msgSender()];
169         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
170         unchecked {
171             _approve(sender, _msgSender(), currentAllowance - amount);
172         }
173 
174         return true;
175     }
176 
177     /**
178      * @dev Atomically increases the allowance granted to `spender` by the caller.
179      *
180      * This is an alternative to {approve} that can be used as a mitigation for
181      * problems described in {IERC20-approve}.
182      *
183      * Emits an {Approval} event indicating the updated allowance.
184      *
185      * Requirements:
186      *
187      * - `spender` cannot be the zero address.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
191         return true;
192     }
193 
194     
195     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
196         uint256 currentAllowance = _allowances[_msgSender()][spender];
197         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
198         unchecked {
199             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
200         }
201 
202         return true;
203     }
204 
205   
206     function _transfer(
207         address sender,
208         address recipient,
209         uint256 amount
210     ) internal virtual {
211         require(sender != address(0), "ERC20: transfer from the zero address");
212         require(recipient != address(0), "ERC20: transfer to the zero address");
213 
214         _beforeTokenTransfer(sender, recipient, amount);
215 
216         uint256 senderBalance = _balances[sender];
217         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
218         unchecked {
219             _balances[sender] = senderBalance - amount;
220         }
221         _balances[recipient] += amount;
222 
223         emit Transfer(sender, recipient, amount);
224 
225         _afterTokenTransfer(sender, recipient, amount);
226     }
227 
228     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
229      * the total supply.
230      *
231      * Emits a {Transfer} event with `from` set to the zero address.
232      *
233      * Requirements:
234      *
235      * - `account` cannot be the zero address.
236      */
237     function _mint(address account, uint256 amount) internal virtual {
238         require(account != address(0), "ERC20: mint to the zero address");
239 
240         _beforeTokenTransfer(address(0), account, amount);
241 
242         _totalSupply += amount;
243         _balances[account] += amount;
244         emit Transfer(address(0), account, amount);
245 
246         _afterTokenTransfer(address(0), account, amount);
247     }
248 
249    
250     function _burn(address account, uint256 amount) internal virtual {
251         require(account != address(0), "ERC20: burn from the zero address");
252 
253         _beforeTokenTransfer(account, address(0), amount);
254 
255         uint256 accountBalance = _balances[account];
256         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
257         unchecked {
258             _balances[account] = accountBalance - amount;
259         }
260         _totalSupply -= amount;
261 
262         emit Transfer(account, address(0), amount);
263 
264         _afterTokenTransfer(account, address(0), amount);
265     }
266 
267     
268     function _approve(
269         address owner,
270         address spender,
271         uint256 amount
272     ) internal virtual {
273         require(owner != address(0), "ERC20: approve from the zero address");
274         require(spender != address(0), "ERC20: approve to the zero address");
275 
276         _allowances[owner][spender] = amount;
277         emit Approval(owner, spender, amount);
278     }
279 
280     /**
281      * @dev Hook that is called before any transfer of tokens. This includes
282      * minting and burning.
283      *
284      * Calling conditions:
285      *
286      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
287      * will be transferred to `to`.
288      * - when `from` is zero, `amount` tokens will be minted for `to`.
289      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
290      * - `from` and `to` are never both zero.
291      *
292      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
293      */
294     function _beforeTokenTransfer(
295         address from,
296         address to,
297         uint256 amount
298     ) internal virtual {}
299 
300    
301     function _afterTokenTransfer(
302         address from,
303         address to,
304         uint256 amount
305     ) internal virtual {}
306 }
307 
308 
309 abstract contract Ownable is Context {
310     address private _owner;
311 
312     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
313 
314     /**
315      * @dev Initializes the contract setting the deployer as the initial owner.
316      */
317     constructor() {
318     }
319 
320     /**
321      * @dev Returns the address of the current owner.
322      */
323     function owner() public view virtual returns (address) {
324         return _owner;
325     }
326 
327     /**
328      * @dev Throws if called by any account other than the owner.
329      */
330     modifier onlyOwner() {
331         require(owner() == _msgSender(), "Ownable: caller is not the owner");
332         _;
333     }
334 
335     /**
336      * @dev Leaves the contract without owner. It will not be possible to call
337      * `onlyOwner` functions anymore. Can only be called by the current owner.
338      *
339      * NOTE: Renouncing ownership will leave the contract without an owner,
340      * thereby removing any functionality that is only available to the owner.
341      */
342     function renounceOwnership() public virtual onlyOwner {
343         _setOwner(address(0));
344     }
345 
346     /**
347      * @dev Transfers ownership of the contract to a new account (`newOwner`).
348      * Can only be called by the current owner.
349      */
350     function transferOwnership(address newOwner) public virtual onlyOwner {
351         require(newOwner != address(0), "Ownable: new owner is the zero address");
352         _setOwner(newOwner);
353     }
354 
355     function _setOwner(address newOwner) internal {
356         address oldOwner = _owner;
357         _owner = newOwner;
358         emit OwnershipTransferred(oldOwner, newOwner);
359     }
360 }
361 
362 
363 abstract contract Pausable is Context {
364     /**
365      * @dev Emitted when the pause is triggered by `account`.
366      */
367     event Paused(address account);
368 
369     /**
370      * @dev Emitted when the pause is lifted by `account`.
371      */
372     event Unpaused(address account);
373 
374     bool private _paused;
375 
376     /**
377      * @dev Initializes the contract in unpaused state.
378      */
379     constructor() {
380         _paused = false;
381     }
382 
383     /**
384      * @dev Returns true if the contract is paused, and false otherwise.
385      */
386     function paused() public view virtual returns (bool) {
387         return _paused;
388     }
389 
390     /**
391      * @dev Modifier to make a function callable only when the contract is not paused.
392      *
393      * Requirements:
394      *
395      * - The contract must not be paused.
396      */
397     modifier whenNotPaused() {
398         require(!paused(), "Pausable: paused");
399         _;
400     }
401 
402     /**
403      * @dev Modifier to make a function callable only when the contract is paused.
404      *
405      * Requirements:
406      *
407      * - The contract must be paused.
408      */
409     modifier whenPaused() {
410         require(paused(), "Pausable: not paused");
411         _;
412     }
413 
414   
415     function _pause() internal virtual whenNotPaused {
416         _paused = true;
417         emit Paused(_msgSender());
418     }
419 
420    
421     function _unpause() internal virtual whenPaused {
422         _paused = false;
423         emit Unpaused(_msgSender());
424     }
425 }
426 
427 interface IUniswapV2Pair {
428     event Approval(address indexed owner, address indexed spender, uint value);
429     event Transfer(address indexed from, address indexed to, uint value);
430 
431     function name() external pure returns (string memory);
432     function symbol() external pure returns (string memory);
433     function decimals() external pure returns (uint8);
434     function totalSupply() external view returns (uint);
435     function balanceOf(address owner) external view returns (uint);
436     function allowance(address owner, address spender) external view returns (uint);
437 
438     function approve(address spender, uint value) external returns (bool);
439     function transfer(address to, uint value) external returns (bool);
440     function transferFrom(address from, address to, uint value) external returns (bool);
441 
442     function DOMAIN_SEPARATOR() external view returns (bytes32);
443     function PERMIT_TYPEHASH() external pure returns (bytes32);
444     function nonces(address owner) external view returns (uint);
445 
446     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
447 
448     event Mint(address indexed sender, uint amount0, uint amount1);
449     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
450     event Swap(
451         address indexed sender,
452         uint amount0In,
453         uint amount1In,
454         uint amount0Out,
455         uint amount1Out,
456         address indexed to
457     );
458     event Sync(uint112 reserve0, uint112 reserve1);
459 
460     function MINIMUM_LIQUIDITY() external pure returns (uint);
461     function factory() external view returns (address);
462     function token0() external view returns (address);
463     function token1() external view returns (address);
464     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
465     function price0CumulativeLast() external view returns (uint);
466     function price1CumulativeLast() external view returns (uint);
467     function kLast() external view returns (uint);
468 
469     function mint(address to) external returns (uint liquidity);
470     function burn(address to) external returns (uint amount0, uint amount1);
471     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
472     function skim(address to) external;
473     function sync() external;
474 
475     function initialize(address, address) external;
476 }
477 
478 interface IUniswapV2Factory {
479     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
480 
481     function feeTo() external view returns (address);
482     function feeToSetter() external view returns (address);
483 
484     function getPair(address tokenA, address tokenB) external view returns (address pair);
485     function allPairs(uint) external view returns (address pair);
486     function allPairsLength() external view returns (uint);
487 
488     function createPair(address tokenA, address tokenB) external returns (address pair);
489 
490     function setFeeTo(address) external;
491     function setFeeToSetter(address) external;
492 }
493 
494 interface IUniswapV2Router01 {
495     function factory() external pure returns (address);
496     function WETH() external pure returns (address);
497 
498     function addLiquidity(
499         address tokenA,
500         address tokenB,
501         uint amountADesired,
502         uint amountBDesired,
503         uint amountAMin,
504         uint amountBMin,
505         address to,
506         uint deadline
507     ) external returns (uint amountA, uint amountB, uint liquidity);
508     function addLiquidityETH(
509         address token,
510         uint amountTokenDesired,
511         uint amountTokenMin,
512         uint amountETHMin,
513         address to,
514         uint deadline
515     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
516     function removeLiquidity(
517         address tokenA,
518         address tokenB,
519         uint liquidity,
520         uint amountAMin,
521         uint amountBMin,
522         address to,
523         uint deadline
524     ) external returns (uint amountA, uint amountB);
525     function removeLiquidityETH(
526         address token,
527         uint liquidity,
528         uint amountTokenMin,
529         uint amountETHMin,
530         address to,
531         uint deadline
532     ) external returns (uint amountToken, uint amountETH);
533     function removeLiquidityWithPermit(
534         address tokenA,
535         address tokenB,
536         uint liquidity,
537         uint amountAMin,
538         uint amountBMin,
539         address to,
540         uint deadline,
541         bool approveMax, uint8 v, bytes32 r, bytes32 s
542     ) external returns (uint amountA, uint amountB);
543     function removeLiquidityETHWithPermit(
544         address token,
545         uint liquidity,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline,
550         bool approveMax, uint8 v, bytes32 r, bytes32 s
551     ) external returns (uint amountToken, uint amountETH);
552     function swapExactTokensForTokens(
553         uint amountIn,
554         uint amountOutMin,
555         address[] calldata path,
556         address to,
557         uint deadline
558     ) external returns (uint[] memory amounts);
559     function swapTokensForExactTokens(
560         uint amountOut,
561         uint amountInMax,
562         address[] calldata path,
563         address to,
564         uint deadline
565     ) external returns (uint[] memory amounts);
566     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
567         external
568         payable
569         returns (uint[] memory amounts);
570     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
571         external
572         returns (uint[] memory amounts);
573     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
574         external
575         returns (uint[] memory amounts);
576     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
577         external
578         payable
579         returns (uint[] memory amounts);
580 
581     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
582     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
583     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
584     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
585     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
586 }
587 
588 interface IUniswapV2Router02 is IUniswapV2Router01 {
589     function removeLiquidityETHSupportingFeeOnTransferTokens(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountETH);
597     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline,
604         bool approveMax, uint8 v, bytes32 r, bytes32 s
605     ) external returns (uint amountETH);
606 
607     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
608         uint amountIn,
609         uint amountOutMin,
610         address[] calldata path,
611         address to,
612         uint deadline
613     ) external;
614     function swapExactETHForTokensSupportingFeeOnTransferTokens(
615         uint amountOutMin,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external payable;
620     function swapExactTokensForETHSupportingFeeOnTransferTokens(
621         uint amountIn,
622         uint amountOutMin,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external;
627 }
628 
629 contract BENDERETH is ERC20, Ownable, Pausable {
630 
631     // variables
632     
633     uint256 private initialSupply;
634    
635     uint256 private denominator = 100;
636 
637     uint256 private swapThreshold = 0.0000009 ether; // The contract will only swap to ETH, once the fee tokens reach the specified threshold
638     
639     uint256 private devTaxBuy;
640     uint256 private liquidityTaxBuy;
641    
642     
643     uint256 private devTaxSell;
644     uint256 private liquidityTaxSell;
645     uint256 public maxWallet;
646     
647     address private devTaxWallet;
648     address private liquidityTaxWallet;
649     
650     
651     // Mappings
652     
653 
654     mapping (address => bool) private excludeList;
655    
656     
657     mapping (string => uint256) private buyTaxes;
658     mapping (string => uint256) private sellTaxes;
659     mapping (string => address) private taxWallets;
660     
661     bool public taxStatus = true;
662     
663     IUniswapV2Router02 private uniswapV2Router02;
664     IUniswapV2Factory private uniswapV2Factory;
665     IUniswapV2Pair private uniswapV2Pair;
666     
667     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
668     {
669         initialSupply =_supply * (10**18);
670         maxWallet = initialSupply * 2 / 100; 
671         _setOwner(msg.sender);
672         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
673         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
674         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
675         taxWallets["liquidity"] = address(0);
676         setBuyTax(0,0); //dev tax, liquidity tax
677         setSellTax(1,98); //dev tax, liquidity tax
678         setTaxWallets(0x5fEAaD69B6c9F3C9F6291f4f8A2BE56f436D09Db); 
679         exclude(msg.sender);
680         exclude(address(this));
681         exclude(devTaxWallet);
682         _mint(msg.sender, initialSupply);
683     }
684     
685     
686     uint256 private devTokens;
687     uint256 private liquidityTokens;
688     
689     
690     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
691         address[] memory sellPath = new address[](2);
692         sellPath[0] = address(this);
693         sellPath[1] = uniswapV2Router02.WETH();
694         
695         if(!isExcluded(from) && !isExcluded(to)) {
696             uint256 tax;
697             uint256 baseUnit = amount / denominator;
698             if(from == address(uniswapV2Pair)) {
699                 tax += baseUnit * buyTaxes["dev"];
700                 tax += baseUnit * buyTaxes["liquidity"];
701                
702                 
703                 if(tax > 0) {
704                     _transfer(from, address(this), tax);   
705                 }
706                 
707                 
708                 devTokens += baseUnit * buyTaxes["dev"];
709                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
710 
711             } else if(to == address(uniswapV2Pair)) {
712                 
713                 tax += baseUnit * sellTaxes["dev"];
714                 tax += baseUnit * sellTaxes["liquidity"];
715                 
716                 
717                 if(tax > 0) {
718                     _transfer(from, address(this), tax);   
719                 }
720                 
721                
722                 devTokens += baseUnit * sellTaxes["dev"];
723                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
724                 
725                 
726                 uint256 taxSum =  devTokens + liquidityTokens;
727                 
728                 if(taxSum == 0) return amount;
729                 
730                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
731                 
732                 if(ethValue >= swapThreshold) {
733                     uint256 startBalance = address(this).balance;
734 
735                     uint256 toSell = devTokens + liquidityTokens / 2 ;
736                     
737                     _approve(address(this), address(uniswapV2Router02), toSell);
738             
739                     uniswapV2Router02.swapExactTokensForETH(
740                         toSell,
741                         0,
742                         sellPath,
743                         address(this),
744                         block.timestamp
745                     );
746                     
747                     uint256 ethGained = address(this).balance - startBalance;
748                     
749                     uint256 liquidityToken = liquidityTokens / 2;
750                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
751                     
752                     
753                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
754                    
755                     
756                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
757                     
758                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
759                         address(this),
760                         liquidityToken,
761                         0,
762                         0,
763                         taxWallets["liquidity"],
764                         block.timestamp
765                     );
766                     
767                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
768                     
769                     if(remainingTokens > 0) {
770                         _transfer(address(this), taxWallets["dev"], remainingTokens);
771                     }
772                     
773                     
774                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
775                    require(success, "transfer to  dev wallet failed");
776                     
777                     
778                     if(ethGained - ( devETH + liquidityETH) > 0) {
779                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
780                         require(success1, "transfer to  dev wallet failed");
781                     }
782 
783                     
784                     
785                     
786                     devTokens = 0;
787                     liquidityTokens = 0;
788                     
789                 }
790                 
791             }
792             
793             amount -= tax;
794             if (to != address(uniswapV2Pair)){
795                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
796             }
797            
798         }
799         
800         return amount;
801     }
802     
803     function _transfer(
804         address sender,
805         address recipient,
806         uint256 amount
807     ) internal override virtual {
808         require(!paused(), "ERC20: token transfer while paused");
809         
810         if(taxStatus) {
811             amount = handleTax(sender, recipient, amount);   
812         }
813 
814         super._transfer(sender, recipient, amount);
815     }
816     
817     /**
818      * @dev Triggers the tax handling functionality
819      */
820     function triggerTax() public onlyOwner {
821         handleTax(address(0), address(uniswapV2Pair), 0);
822     }
823     
824     /**
825      * @dev Pauses transfers on the token.
826      */
827     function pause() public onlyOwner {
828         require(!paused(), "ERC20: Contract is already paused");
829         _pause();
830     }
831 
832     /**
833      * @dev Unpauses transfers on the token.
834      */
835     function unpause() public onlyOwner {
836         require(paused(), "ERC20: Contract is not paused");
837         _unpause();
838     }
839 
840      /**
841      * @dev set max wallet limit per address.
842      */
843 
844     function setMaxWallet (uint256 amount) external onlyOwner {
845         require (amount > 10000, "NO rug pull");
846         maxWallet = amount * 10**18;
847     }
848     
849     /**
850      * @dev Burns tokens from caller address.
851      */
852     function burn(uint256 amount) public onlyOwner {
853         _burn(msg.sender, amount);
854     }
855     
856    
857     
858     
859     
860     /**
861      * @dev Excludes the specified account from tax.
862      */
863     function exclude(address account) public onlyOwner {
864         require(!isExcluded(account), "ERC20: Account is already excluded");
865         excludeList[account] = true;
866     }
867     
868     /**
869      * @dev Re-enables tax on the specified account.
870      */
871     function removeExclude(address account) public onlyOwner {
872         require(isExcluded(account), "ERC20: Account is not excluded");
873         excludeList[account] = false;
874     }
875     
876     /**
877      * @dev Sets tax for buys.
878      */
879     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
880         buyTaxes["dev"] = dev;
881         buyTaxes["liquidity"] = liquidity;
882        
883     }
884     
885     /**
886      * @dev Sets tax for sells.
887      */
888     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
889 
890         sellTaxes["dev"] = dev;
891         sellTaxes["liquidity"] = liquidity;
892         
893     }
894     
895     /**
896      * @dev Sets wallets for taxes.
897      */
898     function setTaxWallets(address dev) public onlyOwner {
899         taxWallets["dev"] = dev;
900         
901     }
902 
903     function claimStuckTokens(address _token) external onlyOwner {
904  
905         if (_token == address(0x0)) {
906             payable(owner()).transfer(address(this).balance);
907             return;
908         }
909         IERC20 erc20token = IERC20(_token);
910         uint256 balance = erc20token.balanceOf(address(this));
911         erc20token.transfer(owner(), balance);
912     }
913     
914     /**
915      * @dev Enables tax globally.
916      */
917     function enableTax() public onlyOwner {
918         require(!taxStatus, "ERC20: Tax is already enabled");
919         taxStatus = true;
920     }
921     
922     /**
923      * @dev Disables tax globally.
924      */
925     function disableTax() public onlyOwner {
926         require(taxStatus, "ERC20: Tax is already disabled");
927         taxStatus = false;
928     }
929     
930    
931     
932     /**
933      * @dev Returns true if the account is excluded, and false otherwise.
934      */
935     function isExcluded(address account) public view returns (bool) {
936         return excludeList[account];
937     }
938     
939     receive() external payable {}
940 }