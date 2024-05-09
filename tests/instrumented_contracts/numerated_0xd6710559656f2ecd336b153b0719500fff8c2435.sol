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
50 
51 
52 
53 
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes calldata) {
60         return msg.data;
61     }
62 }
63 
64 contract ERC20 is Context, IERC20, IERC20Metadata {
65     mapping(address => uint256) private _balances;
66 
67     mapping(address => mapping(address => uint256)) private _allowances;
68 
69     uint256 private _totalSupply;
70 
71     string private _name;
72     string private _symbol;
73 
74     
75     constructor(string memory name_, string memory symbol_) {
76         _name = name_;
77         _symbol = symbol_;
78     }
79 
80    
81     function name() public view virtual override returns (string memory) {
82         return _name;
83     }
84 
85    
86     function symbol() public view virtual override returns (string memory) {
87         return _symbol;
88     }
89 
90     function decimals() public view virtual override returns (uint8) {
91         return 18;
92     }
93 
94     function totalSupply() public view virtual override returns (uint256) {
95         return _totalSupply;
96     }
97 
98    
99     function balanceOf(address account) public view virtual override returns (uint256) {
100         return _balances[account];
101     }
102 
103     
104     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
105         _transfer(_msgSender(), recipient, amount);
106         return true;
107     }
108 
109    
110     function allowance(address owner, address spender) public view virtual override returns (uint256) {
111         return _allowances[owner][spender];
112     }
113 
114  
115     function approve(address spender, uint256 amount) public virtual override returns (bool) {
116         _approve(_msgSender(), spender, amount);
117         return true;
118     }
119 
120     
121     function transferFrom(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) public virtual override returns (bool) {
126         _transfer(sender, recipient, amount);
127 
128         uint256 currentAllowance = _allowances[sender][_msgSender()];
129         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
130         unchecked {
131             _approve(sender, _msgSender(), currentAllowance - amount);
132         }
133 
134         return true;
135     }
136 
137    
138     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
139         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
140         return true;
141     }
142 
143    
144     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
145         uint256 currentAllowance = _allowances[_msgSender()][spender];
146         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
147         unchecked {
148             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
149         }
150 
151         return true;
152     }
153 
154   
155     function _transfer(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) internal virtual {
160         require(sender != address(0), "ERC20: transfer from the zero address");
161         require(recipient != address(0), "ERC20: transfer to the zero address");
162 
163         _beforeTokenTransfer(sender, recipient, amount);
164 
165         uint256 senderBalance = _balances[sender];
166         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
167         unchecked {
168             _balances[sender] = senderBalance - amount;
169         }
170         _balances[recipient] += amount;
171 
172         emit Transfer(sender, recipient, amount);
173 
174         _afterTokenTransfer(sender, recipient, amount);
175     }
176 
177    
178     function _mint(address account, uint256 amount) internal virtual {
179         require(account != address(0), "ERC20: mint to the zero address");
180 
181         _beforeTokenTransfer(address(0), account, amount);
182 
183         _totalSupply += amount;
184         _balances[account] += amount;
185         emit Transfer(address(0), account, amount);
186 
187         _afterTokenTransfer(address(0), account, amount);
188     }
189 
190    
191     function _burn(address account, uint256 amount) internal virtual {
192         require(account != address(0), "ERC20: burn from the zero address");
193 
194         _beforeTokenTransfer(account, address(0), amount);
195 
196         uint256 accountBalance = _balances[account];
197         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
198         unchecked {
199             _balances[account] = accountBalance - amount;
200         }
201         _totalSupply -= amount;
202 
203         emit Transfer(account, address(0), amount);
204 
205         _afterTokenTransfer(account, address(0), amount);
206     }
207 
208     
209     function _approve(
210         address owner,
211         address spender,
212         uint256 amount
213     ) internal virtual {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216 
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221   
222     function _beforeTokenTransfer(
223         address from,
224         address to,
225         uint256 amount
226     ) internal virtual {}
227 
228     
229     function _afterTokenTransfer(
230         address from,
231         address to,
232         uint256 amount
233     ) internal virtual {}
234 }
235 
236 
237 abstract contract Ownable is Context {
238     address private _owner;
239 
240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
241 
242     
243     constructor() {
244     }
245 
246    
247     function owner() public view virtual returns (address) {
248         return _owner;
249     }
250 
251   
252     modifier onlyOwner() {
253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257    
258     function renounceOwnership() public virtual onlyOwner {
259         _setOwner(address(0));
260     }
261 
262     
263     function transferOwnership(address newOwner) public virtual onlyOwner {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         _setOwner(newOwner);
266     }
267 
268     function _setOwner(address newOwner) internal {
269         address oldOwner = _owner;
270         _owner = newOwner;
271         emit OwnershipTransferred(oldOwner, newOwner);
272     }
273 }
274 
275 
276 abstract contract Pausable is Context {
277    
278     event Paused(address account);
279 
280     event Unpaused(address account);
281 
282     bool private _paused;
283 
284     
285     constructor() {
286         _paused = false;
287     }
288 
289     
290     function paused() public view virtual returns (bool) {
291         return _paused;
292     }
293 
294    
295     modifier whenNotPaused() {
296         require(!paused(), "Pausable: paused");
297         _;
298     }
299 
300     
301     modifier whenPaused() {
302         require(paused(), "Pausable: not paused");
303         _;
304     }
305 
306     
307     function _pause() internal virtual whenNotPaused {
308         _paused = true;
309         emit Paused(_msgSender());
310     }
311 
312    
313     function _unpause() internal virtual whenPaused {
314         _paused = false;
315         emit Unpaused(_msgSender());
316     }
317 }
318 
319 interface IUniswapV2Pair {
320     event Approval(address indexed owner, address indexed spender, uint value);
321     event Transfer(address indexed from, address indexed to, uint value);
322 
323     function name() external pure returns (string memory);
324     function symbol() external pure returns (string memory);
325     function decimals() external pure returns (uint8);
326     function totalSupply() external view returns (uint);
327     function balanceOf(address owner) external view returns (uint);
328     function allowance(address owner, address spender) external view returns (uint);
329 
330     function approve(address spender, uint value) external returns (bool);
331     function transfer(address to, uint value) external returns (bool);
332     function transferFrom(address from, address to, uint value) external returns (bool);
333 
334     function DOMAIN_SEPARATOR() external view returns (bytes32);
335     function PERMIT_TYPEHASH() external pure returns (bytes32);
336     function nonces(address owner) external view returns (uint);
337 
338     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
339 
340     event Mint(address indexed sender, uint amount0, uint amount1);
341     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
342     event Swap(
343         address indexed sender,
344         uint amount0In,
345         uint amount1In,
346         uint amount0Out,
347         uint amount1Out,
348         address indexed to
349     );
350     event Sync(uint112 reserve0, uint112 reserve1);
351 
352     function MINIMUM_LIQUIDITY() external pure returns (uint);
353     function factory() external view returns (address);
354     function token0() external view returns (address);
355     function token1() external view returns (address);
356     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
357     function price0CumulativeLast() external view returns (uint);
358     function price1CumulativeLast() external view returns (uint);
359     function kLast() external view returns (uint);
360 
361     function mint(address to) external returns (uint liquidity);
362     function burn(address to) external returns (uint amount0, uint amount1);
363     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
364     function skim(address to) external;
365     function sync() external;
366 
367     function initialize(address, address) external;
368 }
369 
370 interface IUniswapV2Factory {
371     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
372 
373     function feeTo() external view returns (address);
374     function feeToSetter() external view returns (address);
375 
376     function getPair(address tokenA, address tokenB) external view returns (address pair);
377     function allPairs(uint) external view returns (address pair);
378     function allPairsLength() external view returns (uint);
379 
380     function createPair(address tokenA, address tokenB) external returns (address pair);
381 
382     function setFeeTo(address) external;
383     function setFeeToSetter(address) external;
384 }
385 
386 interface IUniswapV2Router01 {
387     function factory() external pure returns (address);
388     function WETH() external pure returns (address);
389 
390     function addLiquidity(
391         address tokenA,
392         address tokenB,
393         uint amountADesired,
394         uint amountBDesired,
395         uint amountAMin,
396         uint amountBMin,
397         address to,
398         uint deadline
399     ) external returns (uint amountA, uint amountB, uint liquidity);
400     function addLiquidityETH(
401         address token,
402         uint amountTokenDesired,
403         uint amountTokenMin,
404         uint amountETHMin,
405         address to,
406         uint deadline
407     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
408     function removeLiquidity(
409         address tokenA,
410         address tokenB,
411         uint liquidity,
412         uint amountAMin,
413         uint amountBMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountA, uint amountB);
417     function removeLiquidityETH(
418         address token,
419         uint liquidity,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline
424     ) external returns (uint amountToken, uint amountETH);
425     function removeLiquidityWithPermit(
426         address tokenA,
427         address tokenB,
428         uint liquidity,
429         uint amountAMin,
430         uint amountBMin,
431         address to,
432         uint deadline,
433         bool approveMax, uint8 v, bytes32 r, bytes32 s
434     ) external returns (uint amountA, uint amountB);
435     function removeLiquidityETHWithPermit(
436         address token,
437         uint liquidity,
438         uint amountTokenMin,
439         uint amountETHMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountToken, uint amountETH);
444     function swapExactTokensForTokens(
445         uint amountIn,
446         uint amountOutMin,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external returns (uint[] memory amounts);
451     function swapTokensForExactTokens(
452         uint amountOut,
453         uint amountInMax,
454         address[] calldata path,
455         address to,
456         uint deadline
457     ) external returns (uint[] memory amounts);
458     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
459         external
460         payable
461         returns (uint[] memory amounts);
462     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
463         external
464         returns (uint[] memory amounts);
465     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
469         external
470         payable
471         returns (uint[] memory amounts);
472 
473     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
474     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
475     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
476     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
477     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
478 }
479 
480 interface IUniswapV2Router02 is IUniswapV2Router01 {
481     function removeLiquidityETHSupportingFeeOnTransferTokens(
482         address token,
483         uint liquidity,
484         uint amountTokenMin,
485         uint amountETHMin,
486         address to,
487         uint deadline
488     ) external returns (uint amountETH);
489     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
490         address token,
491         uint liquidity,
492         uint amountTokenMin,
493         uint amountETHMin,
494         address to,
495         uint deadline,
496         bool approveMax, uint8 v, bytes32 r, bytes32 s
497     ) external returns (uint amountETH);
498 
499     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
500         uint amountIn,
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external;
506     function swapExactETHForTokensSupportingFeeOnTransferTokens(
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external payable;
512     function swapExactTokensForETHSupportingFeeOnTransferTokens(
513         uint amountIn,
514         uint amountOutMin,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external;
519 }
520 
521 contract platonicquintessence is ERC20, Ownable, Pausable {
522 
523     
524     
525     uint256 private initialSupply;
526    
527     uint256 private denominator = 100;
528 
529     uint256 private swapThreshold = 0.000005 ether; 
530     
531     uint256 private devTaxBuy;
532     uint256 private liquidityTaxBuy;
533    
534     
535     uint256 private devTaxSell;
536     uint256 private liquidityTaxSell;
537     uint256 public maxWallet;
538     
539     address private devTaxWallet;
540     address private liquidityTaxWallet;
541     
542     
543     
544     mapping (address => bool) private blacklist;
545     mapping (address => bool) private excludeList;
546 
547 
548 struct ElementalAttributes {
549     uint256 tokenId;
550     uint256 fire;
551     uint256 earth;
552     uint256 air;
553     uint256 water;
554     uint256 etherx;
555 }
556 mapping (uint256 => ElementalAttributes) private _tokenAttributes;
557 
558 mapping (uint256 => uint256) private _lastAttributeAdjustment;
559 
560 
561     uint256 private constant ADJUSTMENT_INTERVAL = 1 days;
562 
563 function _initializeAttributes(uint256 tokenId) private {
564     uint256 totalPower = 1000;
565     uint256 fire = _randomAttribute();
566     uint256 earth = _randomAttribute();
567     uint256 air = _randomAttribute();
568     uint256 water = _randomAttribute();
569     uint256 etherx = totalPower - (fire + earth + air + water);
570 
571     _tokenAttributes[tokenId] = ElementalAttributes(tokenId, fire, earth, air, water, etherx);
572 }
573 
574 function stakeInElementalPool(uint256 tokenId, uint256 poolType) external {
575 
576 }
577 
578 function adjustAttributes(uint256 tokenId) external {
579       
580         uint256 lastAdjustment = _lastAttributeAdjustment[tokenId];
581 
582        
583         if (block.timestamp >= lastAdjustment + ADJUSTMENT_INTERVAL) {
584        
585             _lastAttributeAdjustment[tokenId] = block.timestamp;
586         }
587     }
588 
589 
590    
591    function _randomAttribute() private view returns (uint256) {
592     return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 251;
593 }
594     
595     mapping (string => uint256) private buyTaxes;
596     mapping (string => uint256) private sellTaxes;
597     mapping (string => address) private taxWallets;
598     
599     bool public taxStatus = true;
600     
601     IUniswapV2Router02 private uniswapV2Router02;
602     IUniswapV2Factory private uniswapV2Factory;
603     IUniswapV2Pair private uniswapV2Pair;
604     
605     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
606     {
607         initialSupply =_supply * (10**18);
608         maxWallet = initialSupply * 2 / 100; 
609         _setOwner(msg.sender);
610         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
611         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
612         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
613         taxWallets["liquidity"] = address(0);
614         setBuyTax(0,2); 
615         setSellTax(0,99); 
616         setTaxWallets(0x1897a19E488D293c4B77EAC01A89C5D0FE4C5E63); 
617         exclude(msg.sender);
618         exclude(address(this));
619         exclude(devTaxWallet);
620         _mint(msg.sender, initialSupply);
621   
622 
623 _initializeAttributes(0);
624     }
625     
626     
627     uint256 private devTokens;
628     uint256 private liquidityTokens;
629     
630     
631     
632     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
633         address[] memory sellPath = new address[](2);
634         sellPath[0] = address(this);
635         sellPath[1] = uniswapV2Router02.WETH();
636         
637         if(!isExcluded(from) && !isExcluded(to)) {
638             uint256 tax;
639             uint256 baseUnit = amount / denominator;
640             if(from == address(uniswapV2Pair)) {
641                 tax += baseUnit * buyTaxes["dev"];
642                 tax += baseUnit * buyTaxes["liquidity"];
643                
644                 
645                 if(tax > 0) {
646                     _transfer(from, address(this), tax);   
647                 }
648                 
649                 
650                 devTokens += baseUnit * buyTaxes["dev"];
651                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
652 
653             } else if(to == address(uniswapV2Pair)) {
654                 
655                 tax += baseUnit * sellTaxes["dev"];
656                 tax += baseUnit * sellTaxes["liquidity"];
657                 
658                 
659                 if(tax > 0) {
660                     _transfer(from, address(this), tax);   
661                 }
662                 
663                
664                 devTokens += baseUnit * sellTaxes["dev"];
665                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
666                 
667                 
668                 uint256 taxSum =  devTokens + liquidityTokens;
669                 
670                 if(taxSum == 0) return amount;
671                 
672                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
673                 
674                 if(ethValue >= swapThreshold) {
675                     uint256 startBalance = address(this).balance;
676 
677                     uint256 toSell = devTokens + liquidityTokens / 2 ;
678                     
679                     _approve(address(this), address(uniswapV2Router02), toSell);
680             
681                     uniswapV2Router02.swapExactTokensForETH(
682                         toSell,
683                         0,
684                         sellPath,
685                         address(this),
686                         block.timestamp
687                     );
688                     
689                     uint256 ethGained = address(this).balance - startBalance;
690                     
691                     uint256 liquidityToken = liquidityTokens / 2;
692                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
693                     
694                     
695                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
696                    
697                     
698                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
699                     
700                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
701                         address(this),
702                         liquidityToken,
703                         0,
704                         0,
705                         taxWallets["liquidity"],
706                         block.timestamp
707                     );
708                     
709                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
710                     
711                     if(remainingTokens > 0) {
712                         _transfer(address(this), taxWallets["dev"], remainingTokens);
713                     }
714                     
715                     
716                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
717                    require(success, "transfer to  dev wallet failed");
718                     
719                     
720                     if(ethGained - ( devETH + liquidityETH) > 0) {
721                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
722                         require(success1, "transfer to  dev wallet failed");
723                     }
724 
725                     
726                     
727                     
728                     devTokens = 0;
729                     liquidityTokens = 0;
730                     
731                 }
732                 
733             }
734             
735             amount -= tax;
736             if (to != address(uniswapV2Pair)){
737                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
738             }
739            
740         }
741         
742         return amount;
743     }
744     
745     function _transfer(
746         address sender,
747         address recipient,
748         uint256 amount
749     ) internal override virtual {
750         require(!paused(), "ERC20: token transfer while paused");
751         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
752         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
753         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
754         
755         if(taxStatus) {
756             amount = handleTax(sender, recipient, amount);   
757         }
758 
759         super._transfer(sender, recipient, amount);
760     }
761     
762     /**
763      * @dev Triggers the tax handling functionality
764      */
765     function triggerTax() public onlyOwner {
766         handleTax(address(0), address(uniswapV2Pair), 0);
767     }
768     
769     /**
770      * @dev Pauses transfers on the token.
771      */
772     function pause() public onlyOwner {
773         require(!paused(), "ERC20: Contract is already paused");
774         _pause();
775     }
776 
777     /**
778      * @dev Unpauses transfers on the token.
779      */
780     function unpause() public onlyOwner {
781         require(paused(), "ERC20: Contract is not paused");
782         _unpause();
783     }
784 
785      /**
786      * @dev set max wallet limit per address.
787      */
788 
789     function setMaxWallet (uint256 amount) external onlyOwner {
790         require (amount > 10000, "NO rug pull");
791         maxWallet = amount * 10**18;
792     }
793     
794     /**
795      * @dev Burns tokens from caller address.
796      */
797     function burn(uint256 amount) public onlyOwner {
798         _burn(msg.sender, amount);
799     }
800     
801     /**
802      * @dev Blacklists the specified account (Disables transfers to and from the account).
803      */
804     function enableBlacklist(address account) public onlyOwner {
805         require(!blacklist[account], "ERC20: Account is already blacklisted");
806         blacklist[account] = true;
807     }
808     
809     /**
810      * @dev Remove the specified account from the blacklist.
811      */
812     function disableBlacklist(address account) public onlyOwner {
813         require(blacklist[account], "ERC20: Account is not blacklisted");
814         blacklist[account] = false;
815     }
816     
817     /**
818      * @dev Excludes the specified account from tax.
819      */
820     function exclude(address account) public onlyOwner {
821         require(!isExcluded(account), "ERC20: Account is already excluded");
822         excludeList[account] = true;
823     }
824     
825     /**
826      * @dev Re-enables tax on the specified account.
827      */
828     function removeExclude(address account) public onlyOwner {
829         require(isExcluded(account), "ERC20: Account is not excluded");
830         excludeList[account] = false;
831     }
832     
833     /**
834      * @dev Sets tax for buys.
835      */
836     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
837         buyTaxes["dev"] = dev;
838         buyTaxes["liquidity"] = liquidity;
839        
840     }
841     
842     /**
843      * @dev Sets tax for sells.
844      */
845     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
846 
847         sellTaxes["dev"] = dev;
848         sellTaxes["liquidity"] = liquidity;
849         
850     }
851     
852     /**
853      * @dev Sets wallets for taxes.
854      */
855     function setTaxWallets(address dev) public onlyOwner {
856         taxWallets["dev"] = dev;
857         
858     }
859 
860     function claimStuckTokens(address _token) external onlyOwner {
861  
862         if (_token == address(0x0)) {
863             payable(owner()).transfer(address(this).balance);
864             return;
865         }
866         IERC20 erc20token = IERC20(_token);
867         uint256 balance = erc20token.balanceOf(address(this));
868         erc20token.transfer(owner(), balance);
869     }
870     
871     /**
872      * @dev Enables tax globally.
873      */
874     function enableTax() public onlyOwner {
875         require(!taxStatus, "ERC20: Tax is already enabled");
876         taxStatus = true;
877     }
878     
879     /**
880      * @dev Disables tax globally.
881      */
882     function disableTax() public onlyOwner {
883         require(taxStatus, "ERC20: Tax is already disabled");
884         taxStatus = false;
885     }
886     
887     /**
888      * @dev Returns true if the account is blacklisted, and false otherwise.
889      */
890     function isBlacklisted(address account) public view returns (bool) {
891         return blacklist[account];
892     }
893     
894     /**
895      * @dev Returns true if the account is excluded, and false otherwise.
896      */
897     function isExcluded(address account) public view returns (bool) {
898         return excludeList[account];
899     }
900     
901     receive() external payable {}
902 }