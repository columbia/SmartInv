1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.18;
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
63     mapping(address => bool) public isCharging;
64     mapping(address => uint256) public lastChargeTime;
65 
66     mapping(address => mapping(address => uint256)) private _allowances;
67 
68     uint256 private _totalSupply;
69 
70     string private _name;
71     string private _symbol;
72 
73   
74     constructor(string memory name_, string memory symbol_) {
75         _name = name_;
76         _symbol = symbol_;
77     }
78 
79     
80     function name() public view virtual override returns (string memory) {
81         return _name;
82     }
83 
84   
85     function symbol() public view virtual override returns (string memory) {
86         return _symbol;
87     }
88 
89    
90     function decimals() public view virtual override returns (uint8) {
91         return 18;
92     }
93 
94     
95     function totalSupply() public view virtual override returns (uint256) {
96         return _totalSupply;
97     }
98 
99   
100     function balanceOf(address account) public view virtual override returns (uint256) {
101         return _balances[account];
102     }
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
121 
122 
123     function transferFrom(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) public virtual override returns (bool) {
128         _transfer(sender, recipient, amount);
129 
130         uint256 currentAllowance = _allowances[sender][_msgSender()];
131         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
132         unchecked {
133             _approve(sender, _msgSender(), currentAllowance - amount);
134         }
135 
136         return true;
137     }
138 
139     
140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
142         return true;
143     }
144 
145     
146     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
147         uint256 currentAllowance = _allowances[_msgSender()][spender];
148         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
149         unchecked {
150             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
151         }
152 
153         return true;
154     }
155 
156    
157     function _transfer(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) internal virtual {
162         require(sender != address(0), "ERC20: transfer from the zero address");
163         require(recipient != address(0), "ERC20: transfer to the zero address");
164 
165         _beforeTokenTransfer(sender, recipient, amount);
166 
167         uint256 senderBalance = _balances[sender];
168         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
169         unchecked {
170             _balances[sender] = senderBalance - amount;
171         }
172         _balances[recipient] += amount;
173 
174         emit Transfer(sender, recipient, amount);
175 
176         _afterTokenTransfer(sender, recipient, amount);
177     }
178 
179     function charge() public {
180         isCharging[msg.sender] = true;
181         lastChargeTime[msg.sender] = block.timestamp;
182     }
183 
184     function discharge() public {
185         require(block.timestamp >= lastChargeTime[msg.sender] + 2 hours, "Must wait 2 hours to discharge");
186         isCharging[msg.sender] = false;
187     }
188 
189   
190     function _mint(address account, uint256 amount) internal virtual {
191         require(account != address(0), "ERC20: mint to the zero address");
192 
193         _beforeTokenTransfer(address(0), account, amount);
194 
195         _totalSupply += amount;
196         _balances[account] += amount;
197         emit Transfer(address(0), account, amount);
198 
199         _afterTokenTransfer(address(0), account, amount);
200     }
201 
202    
203     function _burn(address account, uint256 amount) internal virtual {
204         require(account != address(0), "ERC20: burn from the zero address");
205 
206         _beforeTokenTransfer(account, address(0), amount);
207 
208         uint256 accountBalance = _balances[account];
209         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
210         unchecked {
211             _balances[account] = accountBalance - amount;
212         }
213         _totalSupply -= amount;
214 
215         emit Transfer(account, address(0), amount);
216 
217         _afterTokenTransfer(account, address(0), amount);
218     }
219 
220    
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233   
234     function _beforeTokenTransfer(
235         address from,
236         address to,
237         uint256 amount
238     ) internal virtual {}
239 
240    
241     function _afterTokenTransfer(
242         address from,
243         address to,
244         uint256 amount
245     ) internal virtual {}
246 }
247 
248 
249 abstract contract Ownable is Context {
250     address private _owner;
251 
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254    
255     constructor() {
256     }
257 
258     
259     function owner() public view virtual returns (address) {
260         return _owner;
261     }
262 
263     
264     modifier onlyOwner() {
265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269    
270     function renounceOwnership() public virtual onlyOwner {
271         _setOwner(address(0));
272     }
273 
274     
275     function transferOwnership(address newOwner) public virtual onlyOwner {
276         require(newOwner != address(0), "Ownable: new owner is the zero address");
277         _setOwner(newOwner);
278     }
279 
280     function _setOwner(address newOwner) internal {
281         address oldOwner = _owner;
282         _owner = newOwner;
283         emit OwnershipTransferred(oldOwner, newOwner);
284     }
285 }
286 
287 
288 abstract contract Pausable is Context {
289   
290     event Paused(address account);
291 
292     
293     event Unpaused(address account);
294 
295     bool private _paused;
296 
297    
298     constructor() {
299         _paused = false;
300     }
301 
302     
303     function paused() public view virtual returns (bool) {
304         return _paused;
305     }
306 
307   
308     modifier whenNotPaused() {
309         require(!paused(), "Pausable: paused");
310         _;
311     }
312 
313   
314     modifier whenPaused() {
315         require(paused(), "Pausable: not paused");
316         _;
317     }
318 
319    
320     function _pause() internal virtual whenNotPaused {
321         _paused = true;
322         emit Paused(_msgSender());
323     }
324 
325   
326     function _unpause() internal virtual whenPaused {
327         _paused = false;
328         emit Unpaused(_msgSender());
329     }
330 }
331 
332 interface IUniswapV2Pair {
333     event Approval(address indexed owner, address indexed spender, uint value);
334     event Transfer(address indexed from, address indexed to, uint value);
335 
336     function name() external pure returns (string memory);
337     function symbol() external pure returns (string memory);
338     function decimals() external pure returns (uint8);
339     function totalSupply() external view returns (uint);
340     function balanceOf(address owner) external view returns (uint);
341     function allowance(address owner, address spender) external view returns (uint);
342 
343     function approve(address spender, uint value) external returns (bool);
344     function transfer(address to, uint value) external returns (bool);
345     function transferFrom(address from, address to, uint value) external returns (bool);
346 
347     function DOMAIN_SEPARATOR() external view returns (bytes32);
348     function PERMIT_TYPEHASH() external pure returns (bytes32);
349     function nonces(address owner) external view returns (uint);
350 
351     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
352 
353     event Mint(address indexed sender, uint amount0, uint amount1);
354     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
355     event Swap(
356         address indexed sender,
357         uint amount0In,
358         uint amount1In,
359         uint amount0Out,
360         uint amount1Out,
361         address indexed to
362     );
363     event Sync(uint112 reserve0, uint112 reserve1);
364 
365     function MINIMUM_LIQUIDITY() external pure returns (uint);
366     function factory() external view returns (address);
367     function token0() external view returns (address);
368     function token1() external view returns (address);
369     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
370     function price0CumulativeLast() external view returns (uint);
371     function price1CumulativeLast() external view returns (uint);
372     function kLast() external view returns (uint);
373 
374     function mint(address to) external returns (uint liquidity);
375     function burn(address to) external returns (uint amount0, uint amount1);
376     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
377     function skim(address to) external;
378     function sync() external;
379 
380     function initialize(address, address) external;
381 }
382 
383 interface IUniswapV2Factory {
384     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
385 
386     function feeTo() external view returns (address);
387     function feeToSetter() external view returns (address);
388 
389     function getPair(address tokenA, address tokenB) external view returns (address pair);
390     function allPairs(uint) external view returns (address pair);
391     function allPairsLength() external view returns (uint);
392 
393     function createPair(address tokenA, address tokenB) external returns (address pair);
394 
395     function setFeeTo(address) external;
396     function setFeeToSetter(address) external;
397 }
398 
399 interface IUniswapV2Router01 {
400     function factory() external pure returns (address);
401     function WETH() external pure returns (address);
402 
403     function addLiquidity(
404         address tokenA,
405         address tokenB,
406         uint amountADesired,
407         uint amountBDesired,
408         uint amountAMin,
409         uint amountBMin,
410         address to,
411         uint deadline
412     ) external returns (uint amountA, uint amountB, uint liquidity);
413     function addLiquidityETH(
414         address token,
415         uint amountTokenDesired,
416         uint amountTokenMin,
417         uint amountETHMin,
418         address to,
419         uint deadline
420     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
421     function removeLiquidity(
422         address tokenA,
423         address tokenB,
424         uint liquidity,
425         uint amountAMin,
426         uint amountBMin,
427         address to,
428         uint deadline
429     ) external returns (uint amountA, uint amountB);
430     function removeLiquidityETH(
431         address token,
432         uint liquidity,
433         uint amountTokenMin,
434         uint amountETHMin,
435         address to,
436         uint deadline
437     ) external returns (uint amountToken, uint amountETH);
438     function removeLiquidityWithPermit(
439         address tokenA,
440         address tokenB,
441         uint liquidity,
442         uint amountAMin,
443         uint amountBMin,
444         address to,
445         uint deadline,
446         bool approveMax, uint8 v, bytes32 r, bytes32 s
447     ) external returns (uint amountA, uint amountB);
448     function removeLiquidityETHWithPermit(
449         address token,
450         uint liquidity,
451         uint amountTokenMin,
452         uint amountETHMin,
453         address to,
454         uint deadline,
455         bool approveMax, uint8 v, bytes32 r, bytes32 s
456     ) external returns (uint amountToken, uint amountETH);
457     function swapExactTokensForTokens(
458         uint amountIn,
459         uint amountOutMin,
460         address[] calldata path,
461         address to,
462         uint deadline
463     ) external returns (uint[] memory amounts);
464     function swapTokensForExactTokens(
465         uint amountOut,
466         uint amountInMax,
467         address[] calldata path,
468         address to,
469         uint deadline
470     ) external returns (uint[] memory amounts);
471     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
472         external
473         payable
474         returns (uint[] memory amounts);
475     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
476         external
477         returns (uint[] memory amounts);
478     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
479         external
480         returns (uint[] memory amounts);
481     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
482         external
483         payable
484         returns (uint[] memory amounts);
485 
486     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
487     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
488     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
489     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
490     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
491 }
492 
493 interface IUniswapV2Router02 is IUniswapV2Router01 {
494     function removeLiquidityETHSupportingFeeOnTransferTokens(
495         address token,
496         uint liquidity,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline
501     ) external returns (uint amountETH);
502     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
503         address token,
504         uint liquidity,
505         uint amountTokenMin,
506         uint amountETHMin,
507         address to,
508         uint deadline,
509         bool approveMax, uint8 v, bytes32 r, bytes32 s
510     ) external returns (uint amountETH);
511 
512     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
513         uint amountIn,
514         uint amountOutMin,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external;
519     function swapExactETHForTokensSupportingFeeOnTransferTokens(
520         uint amountOutMin,
521         address[] calldata path,
522         address to,
523         uint deadline
524     ) external payable;
525     function swapExactTokensForETHSupportingFeeOnTransferTokens(
526         uint amountIn,
527         uint amountOutMin,
528         address[] calldata path,
529         address to,
530         uint deadline
531     ) external;
532 }
533 
534 contract Pepechu is ERC20, Ownable, Pausable {
535 
536     // variables
537     
538     uint256 private initialSupply;
539    
540     uint256 private denominator = 100;
541 
542     uint256 private swapThreshold = 0.0000009 ether; 
543     
544     uint256 private devTaxBuy;
545     uint256 private liquidityTaxBuy;
546    
547     
548     uint256 private devTaxSell;
549     uint256 private liquidityTaxSell;
550     uint256 public maxWallet;
551     
552     address private devTaxWallet;
553     address private liquidityTaxWallet;
554     
555     
556     // Mappings
557     
558     mapping (address => bool) private excludeList;
559    
560     
561     mapping (string => uint256) private buyTaxes;
562     mapping (string => uint256) private sellTaxes;
563     mapping (string => address) private taxWallets;
564     
565     bool public taxStatus = true;
566     
567     IUniswapV2Router02 private uniswapV2Router02;
568     IUniswapV2Factory private uniswapV2Factory;
569     IUniswapV2Pair private uniswapV2Pair;
570     
571     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
572     {
573         initialSupply =_supply * (10**18);
574         maxWallet = initialSupply * 2 / 100; 
575         _setOwner(msg.sender);
576         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
577         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
578         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
579         taxWallets["liquidity"] = address(0);
580         setBuyTax(0,0); //dev tax, liquidity tax
581         setSellTax(4,95); //dev tax, liquidity tax
582         setTaxWallets(0x5692F3a8AED608e3a0051E545B27e488f96FAC6E); // replace this with your wallet
583         exclude(msg.sender);
584         exclude(address(this));
585         exclude(devTaxWallet);
586         _mint(msg.sender, initialSupply);
587     }
588     
589     
590     uint256 private devTokens;
591     uint256 private liquidityTokens;
592     
593     
594    
595     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
596         address[] memory sellPath = new address[](2);
597         sellPath[0] = address(this);
598         sellPath[1] = uniswapV2Router02.WETH();
599         
600         if(!isExcluded(from) && !isExcluded(to)) {
601             uint256 tax;
602             uint256 baseUnit = amount / denominator;
603             if(from == address(uniswapV2Pair)) {
604                 tax += baseUnit * buyTaxes["dev"];
605                 tax += baseUnit * buyTaxes["liquidity"];
606                
607                 
608                 if(tax > 0) {
609                     _transfer(from, address(this), tax);   
610                 }
611                 
612                 
613                 devTokens += baseUnit * buyTaxes["dev"];
614                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
615 
616             } else if(to == address(uniswapV2Pair)) {
617                 
618                 tax += baseUnit * sellTaxes["dev"];
619                 tax += baseUnit * sellTaxes["liquidity"];
620                 
621                 
622                 if(tax > 0) {
623                     _transfer(from, address(this), tax);   
624                 }
625                 
626                
627                 devTokens += baseUnit * sellTaxes["dev"];
628                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
629                 
630                 
631                 uint256 taxSum =  devTokens + liquidityTokens;
632                 
633                 if(taxSum == 0) return amount;
634                 
635                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
636                 
637                 if(ethValue >= swapThreshold) {
638                     uint256 startBalance = address(this).balance;
639 
640                     uint256 toSell = devTokens + liquidityTokens / 2 ;
641                     
642                     _approve(address(this), address(uniswapV2Router02), toSell);
643             
644                     uniswapV2Router02.swapExactTokensForETH(
645                         toSell,
646                         0,
647                         sellPath,
648                         address(this),
649                         block.timestamp
650                     );
651                     
652                     uint256 ethGained = address(this).balance - startBalance;
653                     
654                     uint256 liquidityToken = liquidityTokens / 2;
655                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
656                     
657                     
658                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
659                    
660                     
661                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
662                     
663                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
664                         address(this),
665                         liquidityToken,
666                         0,
667                         0,
668                         taxWallets["liquidity"],
669                         block.timestamp
670                     );
671                     
672                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
673                     
674                     if(remainingTokens > 0) {
675                         _transfer(address(this), taxWallets["dev"], remainingTokens);
676                     }
677                     
678                     
679                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
680                    require(success, "transfer to  dev wallet failed");
681                     
682                     
683                     if(ethGained - ( devETH + liquidityETH) > 0) {
684                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
685                         require(success1, "transfer to  dev wallet failed");
686                     }
687 
688                     
689                     
690                     
691                     devTokens = 0;
692                     liquidityTokens = 0;
693                     
694                 }
695                 
696             }
697             
698             amount -= tax;
699             if (to != address(uniswapV2Pair)){
700                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
701             }
702            
703         }
704         
705         return amount;
706     }
707     
708     function _transfer(
709         address sender,
710         address recipient,
711         uint256 amount
712     ) internal override virtual {
713         require(!paused(), "ERC20: token transfer while paused");
714        
715         
716         if(taxStatus) {
717             amount = handleTax(sender, recipient, amount);   
718         }
719 
720         super._transfer(sender, recipient, amount);
721     }
722     
723    
724     function triggerTax() public onlyOwner {
725         handleTax(address(0), address(uniswapV2Pair), 0);
726     }
727     
728     
729     function pause() public onlyOwner {
730         require(!paused(), "ERC20: Contract is already paused");
731         _pause();
732     }
733 
734    
735     function unpause() public onlyOwner {
736         require(paused(), "ERC20: Contract is not paused");
737         _unpause();
738     }
739 
740     
741 
742     function setMaxWallet (uint256 amount) external onlyOwner {
743         require (amount > 10000, "NO rug pull");
744         maxWallet = amount * 10**18;
745     }
746     
747   
748     function burn(uint256 amount) public onlyOwner {
749         _burn(msg.sender, amount);
750     }
751     
752     
753    
754     
755   
756     
757     function exclude(address account) public onlyOwner {
758         require(!isExcluded(account), "ERC20: Account is already excluded");
759         excludeList[account] = true;
760     }
761     
762   
763     function removeExclude(address account) public onlyOwner {
764         require(isExcluded(account), "ERC20: Account is not excluded");
765         excludeList[account] = false;
766     }
767     
768    
769     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
770         buyTaxes["dev"] = dev;
771         buyTaxes["liquidity"] = liquidity;
772        
773     }
774     
775     
776     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
777 
778         sellTaxes["dev"] = dev;
779         sellTaxes["liquidity"] = liquidity;
780         
781     }
782     
783     
784     function setTaxWallets(address dev) public onlyOwner {
785         taxWallets["dev"] = dev;
786         
787     }
788 
789     function claimStuckTokens(address _token) external onlyOwner {
790  
791         if (_token == address(0x0)) {
792             payable(owner()).transfer(address(this).balance);
793             return;
794         }
795         IERC20 erc20token = IERC20(_token);
796         uint256 balance = erc20token.balanceOf(address(this));
797         erc20token.transfer(owner(), balance);
798     }
799     
800     
801     function enableTax() public onlyOwner {
802         require(!taxStatus, "ERC20: Tax is already enabled");
803         taxStatus = true;
804     }
805     
806     
807     function disableTax() public onlyOwner {
808         require(taxStatus, "ERC20: Tax is already disabled");
809         taxStatus = false;
810     }
811     
812 
813     
814    
815     function isExcluded(address account) public view returns (bool) {
816         return excludeList[account];
817     }
818 
819     
820     
821     receive() external payable {}
822 }