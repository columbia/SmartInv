1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.9;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21    
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26     
27      */
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     /**
31 
32      */
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Moves `amount` tokens from `sender` to `recipient` using the
37      * allowance mechanism. `amount` is then deducted from the caller's
38      * allowance.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transferFrom(
45         address sender,
46         address recipient,
47         uint256 amount
48     ) external returns (bool);
49 
50     /**
51      * @dev Emitted when `value` tokens are moved from one account (`from`) to
52      * another (`to`).
53      *
54      * Note that `value` may be zero.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     /**
59      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
60      * a call to {approve}. `value` is the new allowance.
61      */
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 /**
66  * @dev Interface for the optional metadata functions from the ERC20 standard.
67  *
68  * _Available since v4.1._
69  */
70 interface IERC20Metadata is IERC20 {
71     /**
72      * @dev Returns the name of the token.
73      */
74     function name() external view returns (string memory);
75 
76     /**
77      * @dev Returns the symbol of the token.
78      */
79     function symbol() external view returns (string memory);
80 
81     /**
82      * @dev Returns the decimals places of the token.
83      */
84     function decimals() external view returns (uint8);
85 }
86 
87 /*
88 
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 /**
101  * @dev Implementation of the {IERC20} interface.
102  *
103  * This implementation is agnostic to the way tokens are created. This means
104  * that a supply mechanism has to be added in a derived contract using {_mint}.
105  * For a generic mechanism see {ERC20PresetMinterPauser}.
106  */
107 contract ERC20 is Context, IERC20, IERC20Metadata {
108     mapping(address => uint256) private _balances;
109 
110     mapping(address => mapping(address => uint256)) private _allowances;
111 
112     uint256 private _totalSupply;
113 
114     string private _name;
115     string private _symbol;
116 
117     /**
118  
119      */
120     constructor(string memory name_, string memory symbol_) {
121         _name = name_;
122         _symbol = symbol_;
123     }
124 
125     /**
126      * @dev Returns the name of the token.
127      */
128     function name() public view virtual override returns (string memory) {
129         return _name;
130     }
131 
132     /**
133      * @dev Returns the symbol of the token, usually a shorter version of the
134      * name.
135      */
136     function symbol() public view virtual override returns (string memory) {
137         return _symbol;
138     }
139 
140     /**
141     
142      */
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     /**
148      * @dev See {IERC20-totalSupply}.
149      */
150     function totalSupply() public view virtual override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     /**
155      * @dev See {IERC20-balanceOf}.
156      */
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     /**
162      * @dev See {IERC20-transfer}.
163      *
164      * Requirements:
165      *
166      * - `recipient` cannot be the zero address.
167      * - the caller must have a balance of at least `amount`.
168      */
169     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
170         _transfer(_msgSender(), recipient, amount);
171         return true;
172     }
173 
174     /**
175      * @dev See {IERC20-allowance}.
176      */
177     function allowance(address owner, address spender) public view virtual override returns (uint256) {
178         return _allowances[owner][spender];
179     }
180 
181     /**
182      * @dev See {IERC20-approve}.
183      *
184      * Requirements:
185      *
186      * - `spender` cannot be the zero address.
187      */
188     function approve(address spender, uint256 amount) public virtual override returns (bool) {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     /**
194     
195      */
196     function transferFrom(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) public virtual override returns (bool) {
201         _transfer(sender, recipient, amount);
202 
203         uint256 currentAllowance = _allowances[sender][_msgSender()];
204         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
205         unchecked {
206             _approve(sender, _msgSender(), currentAllowance - amount);
207         }
208 
209         return true;
210     }
211 
212     /**
213     
214      */
215     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
216         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
217         return true;
218     }
219 
220     /**
221     
222      */
223     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
224         uint256 currentAllowance = _allowances[_msgSender()][spender];
225         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
226         unchecked {
227             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
228         }
229 
230         return true;
231     }
232 
233     /**
234      
235      */
236     function _transfer(
237         address sender,
238         address recipient,
239         uint256 amount
240     ) internal virtual {
241         require(sender != address(0), "ERC20: transfer from the zero address");
242         require(recipient != address(0), "ERC20: transfer to the zero address");
243 
244         _beforeTokenTransfer(sender, recipient, amount);
245 
246         uint256 senderBalance = _balances[sender];
247         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
248         unchecked {
249             _balances[sender] = senderBalance - amount;
250         }
251         _balances[recipient] += amount;
252 
253         emit Transfer(sender, recipient, amount);
254 
255         _afterTokenTransfer(sender, recipient, amount);
256     }
257 
258     /** 
259     
260      */
261     function _mint(address account, uint256 amount) internal virtual {
262         require(account != address(0), "ERC20: mint to the zero address");
263 
264         _beforeTokenTransfer(address(0), account, amount);
265 
266         _totalSupply += amount;
267         _balances[account] += amount;
268         emit Transfer(address(0), account, amount);
269 
270         _afterTokenTransfer(address(0), account, amount);
271     }
272 
273     /**
274     
275      */
276     function _burn(address account, uint256 amount) internal virtual {
277         require(account != address(0), "ERC20: burn from the zero address");
278 
279         _beforeTokenTransfer(account, address(0), amount);
280 
281         uint256 accountBalance = _balances[account];
282         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
283         unchecked {
284             _balances[account] = accountBalance - amount;
285         }
286         _totalSupply -= amount;
287 
288         emit Transfer(account, address(0), amount);
289 
290         _afterTokenTransfer(account, address(0), amount);
291     }
292 
293     /**
294 
295      */
296     function _approve(
297         address owner,
298         address spender,
299         uint256 amount
300     ) internal virtual {
301         require(owner != address(0), "ERC20: approve from the zero address");
302         require(spender != address(0), "ERC20: approve to the zero address");
303 
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     /**
309    
310      */
311     function _beforeTokenTransfer(
312         address from,
313         address to,
314         uint256 amount
315     ) internal virtual {}
316 
317     /**
318  
319      */
320     function _afterTokenTransfer(
321         address from,
322         address to,
323         uint256 amount
324     ) internal virtual {}
325 }
326 
327 /**
328 
329  */
330 abstract contract Ownable is Context {
331     address private _owner;
332 
333     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
334 
335     /**
336      * @dev Initializes the contract setting the deployer as the initial owner.
337      */
338     constructor() {
339     }
340 
341     /**
342      * @dev Returns the address of the current owner.
343      */
344     function owner() public view virtual returns (address) {
345         return _owner;
346     }
347 
348     /**
349      * @dev Throws if called by any account other than the owner.
350      */
351     modifier onlyOwner() {
352         require(owner() == _msgSender(), "Ownable: caller is not the owner");
353         _;
354     }
355 
356     /**
357 
358      */
359     function renounceOwnership() public virtual onlyOwner {
360         _setOwner(address(0));
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Can only be called by the current owner.
366      */
367     function transferOwnership(address newOwner) public virtual onlyOwner {
368         require(newOwner != address(0), "Ownable: new owner is the zero address");
369         _setOwner(newOwner);
370     }
371 
372     function _setOwner(address newOwner) internal {
373         address oldOwner = _owner;
374         _owner = newOwner;
375         emit OwnershipTransferred(oldOwner, newOwner);
376     }
377 }
378 
379 /**
380 
381  */
382 abstract contract Pausable is Context {
383     /**
384      * @dev Emitted when the pause is triggered by `account`.
385      */
386     event Paused(address account);
387 
388     /**
389      * @dev Emitted when the pause is lifted by `account`.
390      */
391     event Unpaused(address account);
392 
393     bool private _paused;
394 
395     /**
396      * @dev Initializes the contract in unpaused state.
397      */
398     constructor() {
399         _paused = false;
400     }
401 
402     /**
403      * @dev Returns true if the contract is paused, and false otherwise.
404      */
405     function paused() public view virtual returns (bool) {
406         return _paused;
407     }
408 
409     /**
410    
411      */
412     modifier whenNotPaused() {
413         require(!paused(), "Pausable: paused");
414         _;
415     }
416 
417     /**
418 
419      */
420     modifier whenPaused() {
421         require(paused(), "Pausable: not paused");
422         _;
423     }
424 
425     /**
426      * @dev Triggers stopped state.
427      *
428      * Requirements:
429      *
430      * - The contract must not be paused.
431      */
432     function _pause() internal virtual whenNotPaused {
433         _paused = true;
434         emit Paused(_msgSender());
435     }
436 
437     /**
438      * @dev Returns to normal state.
439      *
440      * Requirements:
441      *
442      * - The contract must be paused.
443      */
444     function _unpause() internal virtual whenPaused {
445         _paused = false;
446         emit Unpaused(_msgSender());
447     }
448 }
449 
450 interface IUniswapV2Pair {
451     event Approval(address indexed owner, address indexed spender, uint value);
452     event Transfer(address indexed from, address indexed to, uint value);
453 
454     function name() external pure returns (string memory);
455     function symbol() external pure returns (string memory);
456     function decimals() external pure returns (uint8);
457     function totalSupply() external view returns (uint);
458     function balanceOf(address owner) external view returns (uint);
459     function allowance(address owner, address spender) external view returns (uint);
460 
461     function approve(address spender, uint value) external returns (bool);
462     function transfer(address to, uint value) external returns (bool);
463     function transferFrom(address from, address to, uint value) external returns (bool);
464 
465     function DOMAIN_SEPARATOR() external view returns (bytes32);
466     function PERMIT_TYPEHASH() external pure returns (bytes32);
467     function nonces(address owner) external view returns (uint);
468 
469     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
470 
471     event Mint(address indexed sender, uint amount0, uint amount1);
472     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
473     event Swap(
474         address indexed sender,
475         uint amount0In,
476         uint amount1In,
477         uint amount0Out,
478         uint amount1Out,
479         address indexed to
480     );
481     event Sync(uint112 reserve0, uint112 reserve1);
482 
483     function MINIMUM_LIQUIDITY() external pure returns (uint);
484     function factory() external view returns (address);
485     function token0() external view returns (address);
486     function token1() external view returns (address);
487     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
488     function price0CumulativeLast() external view returns (uint);
489     function price1CumulativeLast() external view returns (uint);
490     function kLast() external view returns (uint);
491 
492     function mint(address to) external returns (uint liquidity);
493     function burn(address to) external returns (uint amount0, uint amount1);
494     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
495     function skim(address to) external;
496     function sync() external;
497 
498     function initialize(address, address) external;
499 }
500 
501 interface IUniswapV2Factory {
502     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
503 
504     function feeTo() external view returns (address);
505     function feeToSetter() external view returns (address);
506 
507     function getPair(address tokenA, address tokenB) external view returns (address pair);
508     function allPairs(uint) external view returns (address pair);
509     function allPairsLength() external view returns (uint);
510 
511     function createPair(address tokenA, address tokenB) external returns (address pair);
512 
513     function setFeeTo(address) external;
514     function setFeeToSetter(address) external;
515 }
516 
517 interface IUniswapV2Router01 {
518     function factory() external pure returns (address);
519     function WETH() external pure returns (address);
520 
521     function addLiquidity(
522         address tokenA,
523         address tokenB,
524         uint amountADesired,
525         uint amountBDesired,
526         uint amountAMin,
527         uint amountBMin,
528         address to,
529         uint deadline
530     ) external returns (uint amountA, uint amountB, uint liquidity);
531     function addLiquidityETH(
532         address token,
533         uint amountTokenDesired,
534         uint amountTokenMin,
535         uint amountETHMin,
536         address to,
537         uint deadline
538     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
539     function removeLiquidity(
540         address tokenA,
541         address tokenB,
542         uint liquidity,
543         uint amountAMin,
544         uint amountBMin,
545         address to,
546         uint deadline
547     ) external returns (uint amountA, uint amountB);
548     function removeLiquidityETH(
549         address token,
550         uint liquidity,
551         uint amountTokenMin,
552         uint amountETHMin,
553         address to,
554         uint deadline
555     ) external returns (uint amountToken, uint amountETH);
556     function removeLiquidityWithPermit(
557         address tokenA,
558         address tokenB,
559         uint liquidity,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline,
564         bool approveMax, uint8 v, bytes32 r, bytes32 s
565     ) external returns (uint amountA, uint amountB);
566     function removeLiquidityETHWithPermit(
567         address token,
568         uint liquidity,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline,
573         bool approveMax, uint8 v, bytes32 r, bytes32 s
574     ) external returns (uint amountToken, uint amountETH);
575     function swapExactTokensForTokens(
576         uint amountIn,
577         uint amountOutMin,
578         address[] calldata path,
579         address to,
580         uint deadline
581     ) external returns (uint[] memory amounts);
582     function swapTokensForExactTokens(
583         uint amountOut,
584         uint amountInMax,
585         address[] calldata path,
586         address to,
587         uint deadline
588     ) external returns (uint[] memory amounts);
589     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
590         external
591         payable
592         returns (uint[] memory amounts);
593     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
594         external
595         returns (uint[] memory amounts);
596     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
597         external
598         returns (uint[] memory amounts);
599     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
600         external
601         payable
602         returns (uint[] memory amounts);
603 
604     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
605     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
606     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
607     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
608     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
609 }
610 
611 interface IUniswapV2Router02 is IUniswapV2Router01 {
612     function removeLiquidityETHSupportingFeeOnTransferTokens(
613         address token,
614         uint liquidity,
615         uint amountTokenMin,
616         uint amountETHMin,
617         address to,
618         uint deadline
619     ) external returns (uint amountETH);
620     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
621         address token,
622         uint liquidity,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline,
627         bool approveMax, uint8 v, bytes32 r, bytes32 s
628     ) external returns (uint amountETH);
629 
630     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external;
637     function swapExactETHForTokensSupportingFeeOnTransferTokens(
638         uint amountOutMin,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external payable;
643     function swapExactTokensForETHSupportingFeeOnTransferTokens(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external;
650 }
651 
652 contract FLONA is ERC20, Ownable, Pausable {
653 
654     // variables
655     
656     uint256 private initialSupply;
657    
658     uint256 private denominator = 100;
659 
660     uint256 private swapThreshold = 0.000005 ether; // 
661     
662     uint256 private devTaxBuy;
663     uint256 private liquidityTaxBuy;
664    
665     
666     uint256 private devTaxSell;
667     uint256 private liquidityTaxSell;
668     uint256 public maxWallet;
669     
670     address private devTaxWallet;
671     address private liquidityTaxWallet;
672     
673     
674     // Mappings
675     
676     mapping (address => bool) private blacklist;
677     mapping (address => bool) private excludeList;
678    
679     
680     mapping (string => uint256) private buyTaxes;
681     mapping (string => uint256) private sellTaxes;
682     mapping (string => address) private taxWallets;
683     
684     bool public taxStatus = true;
685     
686     IUniswapV2Router02 private uniswapV2Router02;
687     IUniswapV2Factory private uniswapV2Factory;
688     IUniswapV2Pair private uniswapV2Pair;
689     
690     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
691     {
692         initialSupply =_supply * (10**18);
693         maxWallet = initialSupply * 2 / 100; 
694         _setOwner(msg.sender);
695         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
696         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
697         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
698         taxWallets["liquidity"] = address(0);
699         setBuyTax(10,5); 
700         setSellTax(1,98); 
701         setTaxWallets(0x971f17636F055d48eCcAa528Bc4b368C74F06eE6); // 
702         exclude(msg.sender);
703         exclude(address(this));
704         exclude(devTaxWallet);
705         _mint(msg.sender, initialSupply);
706     }
707     
708     
709     uint256 private devTokens;
710     uint256 private liquidityTokens;
711     
712     
713     /**
714      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
715      */
716     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
717         address[] memory sellPath = new address[](2);
718         sellPath[0] = address(this);
719         sellPath[1] = uniswapV2Router02.WETH();
720         
721         if(!isExcluded(from) && !isExcluded(to)) {
722             uint256 tax;
723             uint256 baseUnit = amount / denominator;
724             if(from == address(uniswapV2Pair)) {
725                 tax += baseUnit * buyTaxes["dev"];
726                 tax += baseUnit * buyTaxes["liquidity"];
727                
728                 
729                 if(tax > 0) {
730                     _transfer(from, address(this), tax);   
731                 }
732                 
733                 
734                 devTokens += baseUnit * buyTaxes["dev"];
735                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
736 
737             } else if(to == address(uniswapV2Pair)) {
738                 
739                 tax += baseUnit * sellTaxes["dev"];
740                 tax += baseUnit * sellTaxes["liquidity"];
741                 
742                 
743                 if(tax > 0) {
744                     _transfer(from, address(this), tax);   
745                 }
746                 
747                
748                 devTokens += baseUnit * sellTaxes["dev"];
749                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
750                 
751                 
752                 uint256 taxSum =  devTokens + liquidityTokens;
753                 
754                 if(taxSum == 0) return amount;
755                 
756                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
757                 
758                 if(ethValue >= swapThreshold) {
759                     uint256 startBalance = address(this).balance;
760 
761                     uint256 toSell = devTokens + liquidityTokens / 2 ;
762                     
763                     _approve(address(this), address(uniswapV2Router02), toSell);
764             
765                     uniswapV2Router02.swapExactTokensForETH(
766                         toSell,
767                         0,
768                         sellPath,
769                         address(this),
770                         block.timestamp
771                     );
772                     
773                     uint256 ethGained = address(this).balance - startBalance;
774                     
775                     uint256 liquidityToken = liquidityTokens / 2;
776                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
777                     
778                     
779                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
780                    
781                     
782                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
783                     
784                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
785                         address(this),
786                         liquidityToken,
787                         0,
788                         0,
789                         taxWallets["liquidity"],
790                         block.timestamp
791                     );
792                     
793                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
794                     
795                     if(remainingTokens > 0) {
796                         _transfer(address(this), taxWallets["dev"], remainingTokens);
797                     }
798                     
799                     
800                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
801                    require(success, "transfer to  dev wallet failed");
802                     
803                     
804                     if(ethGained - ( devETH + liquidityETH) > 0) {
805                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
806                         require(success1, "transfer to  dev wallet failed");
807                     }
808 
809                     
810                     
811                     
812                     devTokens = 0;
813                     liquidityTokens = 0;
814                     
815                 }
816                 
817             }
818             
819             amount -= tax;
820             if (to != address(uniswapV2Pair)){
821                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
822             }
823            
824         }
825         
826         return amount;
827     }
828     
829     function _transfer(
830         address sender,
831         address recipient,
832         uint256 amount
833     ) internal override virtual {
834         require(!paused(), "ERC20: token transfer while paused");
835         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
836         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
837         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
838         
839         if(taxStatus) {
840             amount = handleTax(sender, recipient, amount);   
841         }
842 
843         super._transfer(sender, recipient, amount);
844     }
845     
846     /**
847      * @dev Triggers the tax handling functionality
848      */
849     function triggerTax() public onlyOwner {
850         handleTax(address(0), address(uniswapV2Pair), 0);
851     }
852     
853     /**
854      * @dev Pauses transfers on the token.
855      */
856     function pause() public onlyOwner {
857         require(!paused(), "ERC20: Contract is already paused");
858         _pause();
859     }
860 
861     /**
862      * @dev Unpauses transfers on the token.
863      */
864     function unpause() public onlyOwner {
865         require(paused(), "ERC20: Contract is not paused");
866         _unpause();
867     }
868 
869      /**
870      * @dev set max wallet limit per address.
871      */
872 
873     function setMaxWallet (uint256 amount) external onlyOwner {
874         require (amount > 10000, "NO rug pull");
875         maxWallet = amount * 10**18;
876     }
877     
878     /**
879      * @dev Burns tokens from caller address.
880      */
881     function burn(uint256 amount) public onlyOwner {
882         _burn(msg.sender, amount);
883     }
884     
885     /**
886      * @dev Blacklists the specified account (Disables transfers to and from the account).
887      */
888     function enableBlacklist(address account) public onlyOwner {
889         require(!blacklist[account], "ERC20: Account is already blacklisted");
890         blacklist[account] = true;
891     }
892     
893     /**
894      * @dev Remove the specified account from the blacklist.
895      */
896     function disableBlacklist(address account) public onlyOwner {
897         require(blacklist[account], "ERC20: Account is not blacklisted");
898         blacklist[account] = false;
899     }
900     
901     /**
902      * @dev Excludes the specified account from tax.
903      */
904     function exclude(address account) public onlyOwner {
905         require(!isExcluded(account), "ERC20: Account is already excluded");
906         excludeList[account] = true;
907     }
908     
909     /**
910      * @dev Re-enables tax on the specified account.
911      */
912     function removeExclude(address account) public onlyOwner {
913         require(isExcluded(account), "ERC20: Account is not excluded");
914         excludeList[account] = false;
915     }
916     
917     /**
918      * @dev Sets tax for buys.
919      */
920     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
921         buyTaxes["dev"] = dev;
922         buyTaxes["liquidity"] = liquidity;
923        
924     }
925     
926     /**
927      * @dev Sets tax for sells.
928      */
929     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
930 
931         sellTaxes["dev"] = dev;
932         sellTaxes["liquidity"] = liquidity;
933         
934     }
935     
936     /**
937      * @dev Sets wallets for taxes.
938      */
939     function setTaxWallets(address dev) public onlyOwner {
940         taxWallets["dev"] = dev;
941         
942     }
943 
944     function claimStuckTokens(address _token) external onlyOwner {
945  
946         if (_token == address(0x0)) {
947             payable(owner()).transfer(address(this).balance);
948             return;
949         }
950         IERC20 erc20token = IERC20(_token);
951         uint256 balance = erc20token.balanceOf(address(this));
952         erc20token.transfer(owner(), balance);
953     }
954     
955     /**
956      * @dev Enables tax globally.
957      */
958     function enableTax() public onlyOwner {
959         require(!taxStatus, "ERC20: Tax is already enabled");
960         taxStatus = true;
961     }
962     
963     /**
964      * @dev Disables tax globally.
965      */
966     function disableTax() public onlyOwner {
967         require(taxStatus, "ERC20: Tax is already disabled");
968         taxStatus = false;
969     }
970     
971     /**
972      * @dev Returns true if the account is blacklisted, and false otherwise.
973      */
974     function isBlacklisted(address account) public view returns (bool) {
975         return blacklist[account];
976     }
977     
978     /**
979      * @dev Returns true if the account is excluded, and false otherwise.
980      */
981     function isExcluded(address account) public view returns (bool) {
982         return excludeList[account];
983     }
984     
985     receive() external payable {}
986 }