1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 pragma solidity 0.8.19;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13     function transferFrom(
14         address sender,
15         address recipient,
16         uint256 amount
17     ) external returns (bool);
18    
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 interface IERC20Metadata is IERC20 {
24     function name() external view returns (string memory);
25     function symbol() external view returns (string memory);
26     function decimals() external view returns (uint8);
27 }
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     constructor () {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         emit OwnershipTransferred(_owner, newOwner);
68         _owner = newOwner;
69     }
70 }
71 
72 contract ERC20 is Context, IERC20, IERC20Metadata {
73     mapping(address => uint256) private _balances;
74 
75     mapping(address => mapping(address => uint256)) private _allowances;
76 
77     uint256 private _totalSupply;
78 
79     string private _name;
80     string private _symbol;
81 
82     constructor(string memory name_, string memory symbol_) {
83         _name = name_;
84         _symbol = symbol_;
85     }
86 
87     function name() public view virtual override returns (string memory) {
88         return _name;
89     }
90 
91     function symbol() public view virtual override returns (string memory) {
92         return _symbol;
93     }
94 
95     function decimals() public view virtual override returns (uint8) {
96         return 18;
97     }
98 
99     function totalSupply() public view virtual override returns (uint256) {
100         return _totalSupply;
101     }
102 
103     function balanceOf(address account) public view virtual override returns (uint256) {
104         return _balances[account];
105     }
106 
107     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
108         _transfer(_msgSender(), recipient, amount);
109         return true;
110     }
111 
112     function allowance(address owner, address spender) public view virtual override returns (uint256) {
113         return _allowances[owner][spender];
114     }
115 
116     function approve(address spender, uint256 amount) public virtual override returns (bool) {
117         _approve(_msgSender(), spender, amount);
118         return true;
119     }
120    
121 
122     function transferFrom(
123         address sender,
124         address recipient,
125         uint256 amount
126     ) public virtual override returns (bool) {
127         uint256 currentAllowance = _allowances[sender][_msgSender()];
128         if (currentAllowance != type(uint256).max) {
129             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
130             unchecked {
131                 _approve(sender, _msgSender(), currentAllowance - amount);
132             }
133         }
134 
135         _transfer(sender, recipient, amount);
136 
137         return true;
138     }
139 
140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
142         return true;
143     }
144 
145     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
146         uint256 currentAllowance = _allowances[_msgSender()][spender];
147         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
148         unchecked {
149             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
150         }
151 
152         return true;
153     }
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
177     function _mint(address account, uint256 amount) internal virtual {
178         require(account != address(0), "ERC20: mint to the zero address");
179 
180         _beforeTokenTransfer(address(0), account, amount);
181 
182         _totalSupply += amount;
183         _balances[account] += amount;
184         emit Transfer(address(0), account, amount);
185 
186         _afterTokenTransfer(address(0), account, amount);
187     }
188 
189 
190     function _burn(address account, uint256 amount) internal virtual {
191         require(account != address(0), "ERC20: burn from the zero address");
192 
193         _beforeTokenTransfer(account, address(0), amount);
194 
195         uint256 accountBalance = _balances[account];
196         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
197         unchecked {
198             _balances[account] = accountBalance - amount;
199         }
200         _totalSupply -= amount;
201 
202         emit Transfer(account, address(0), amount);
203 
204         _afterTokenTransfer(account, address(0), amount);
205     }
206 
207     function _approve(
208         address owner,
209         address spender,
210         uint256 amount
211     ) internal virtual {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214 
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _beforeTokenTransfer(
220         address from,
221         address to,
222         uint256 amount
223     ) internal virtual {}
224 
225     function _afterTokenTransfer(
226         address from,
227         address to,
228         uint256 amount
229     ) internal virtual {}
230 }
231 
232 interface IUniswapV2Factory {
233     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
234 
235     function feeTo() external view returns (address);
236     function feeToSetter() external view returns (address);
237     function getPair(address tokenA, address tokenB) external view returns (address pair);
238     function allPairs(uint) external view returns (address pair);
239     function allPairsLength() external view returns (uint);
240     function createPair(address tokenA, address tokenB) external returns (address pair);
241     function setFeeTo(address) external;
242     function setFeeToSetter(address) external;
243 }
244 
245 interface IUniswapV2Pair {
246     event Approval(address indexed owner, address indexed spender, uint value);
247     event Transfer(address indexed from, address indexed to, uint value);
248 
249     function name() external pure returns (string memory);
250     function symbol() external pure returns (string memory);
251     function decimals() external pure returns (uint8);
252     function totalSupply() external view returns (uint);
253     function balanceOf(address owner) external view returns (uint);
254     function allowance(address owner, address spender) external view returns (uint);
255 
256     function approve(address spender, uint value) external returns (bool);
257     function transfer(address to, uint value) external returns (bool);
258     function transferFrom(address from, address to, uint value) external returns (bool);
259 
260     function DOMAIN_SEPARATOR() external view returns (bytes32);
261     function PERMIT_TYPEHASH() external pure returns (bytes32);
262     function nonces(address owner) external view returns (uint);
263 
264     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
265 
266     event Mint(address indexed sender, uint amount0, uint amount1);
267     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
268     event Swap(
269         address indexed sender,
270         uint amount0In,
271         uint amount1In,
272         uint amount0Out,
273         uint amount1Out,
274         address indexed to
275     );
276     event Sync(uint112 reserve0, uint112 reserve1);
277 
278     function MINIMUM_LIQUIDITY() external pure returns (uint);
279     function factory() external view returns (address);
280     function token0() external view returns (address);
281     function token1() external view returns (address);
282     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
283     function price0CumulativeLast() external view returns (uint);
284     function price1CumulativeLast() external view returns (uint);
285     function kLast() external view returns (uint);
286 
287     function mint(address to) external returns (uint liquidity);
288     function burn(address to) external returns (uint amount0, uint amount1);
289     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
290     function skim(address to) external;
291     function sync() external;
292 
293     function initialize(address, address) external;
294 }
295 
296 interface IUniswapV2Router01 {
297     function factory() external pure returns (address);
298     function WETH() external pure returns (address);
299 
300     function addLiquidity(
301         address tokenA,
302         address tokenB,
303         uint amountADesired,
304         uint amountBDesired,
305         uint amountAMin,
306         uint amountBMin,
307         address to,
308         uint deadline
309     ) external returns (uint amountA, uint amountB, uint liquidity);
310     function addLiquidityETH(
311         address token,
312         uint amountTokenDesired,
313         uint amountTokenMin,
314         uint amountETHMin,
315         address to,
316         uint deadline
317     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
318     function removeLiquidity(
319         address tokenA,
320         address tokenB,
321         uint liquidity,
322         uint amountAMin,
323         uint amountBMin,
324         address to,
325         uint deadline
326     ) external returns (uint amountA, uint amountB);
327     function removeLiquidityETH(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountToken, uint amountETH);
335     function removeLiquidityWithPermit(
336         address tokenA,
337         address tokenB,
338         uint liquidity,
339         uint amountAMin,
340         uint amountBMin,
341         address to,
342         uint deadline,
343         bool approveMax, uint8 v, bytes32 r, bytes32 s
344     ) external returns (uint amountA, uint amountB);
345     function removeLiquidityETHWithPermit(
346         address token,
347         uint liquidity,
348         uint amountTokenMin,
349         uint amountETHMin,
350         address to,
351         uint deadline,
352         bool approveMax, uint8 v, bytes32 r, bytes32 s
353     ) external returns (uint amountToken, uint amountETH);
354     function swapExactTokensForTokens(
355         uint amountIn,
356         uint amountOutMin,
357         address[] calldata path,
358         address to,
359         uint deadline
360     ) external returns (uint[] memory amounts);
361     function swapTokensForExactTokens(
362         uint amountOut,
363         uint amountInMax,
364         address[] calldata path,
365         address to,
366         uint deadline
367     ) external returns (uint[] memory amounts);
368     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
369         external
370         payable
371         returns (uint[] memory amounts);
372     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
373         external
374         returns (uint[] memory amounts);
375     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
376         external
377         returns (uint[] memory amounts);
378     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
379         external
380         payable
381         returns (uint[] memory amounts);
382 
383     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
384     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
385     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
386     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
387     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
388 }
389 
390 interface IUniswapV2Router02 is IUniswapV2Router01 {
391     function removeLiquidityETHSupportingFeeOnTransferTokens(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline
398     ) external returns (uint amountETH);
399     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
400         address token,
401         uint liquidity,
402         uint amountTokenMin,
403         uint amountETHMin,
404         address to,
405         uint deadline,
406         bool approveMax, uint8 v, bytes32 r, bytes32 s
407     ) external returns (uint amountETH);
408 
409     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
410         uint amountIn,
411         uint amountOutMin,
412         address[] calldata path,
413         address to,
414         uint deadline
415     ) external;
416     function swapExactETHForTokensSupportingFeeOnTransferTokens(
417         uint amountOutMin,
418         address[] calldata path,
419         address to,
420         uint deadline
421     ) external payable;
422     function swapExactTokensForETHSupportingFeeOnTransferTokens(
423         uint amountIn,
424         uint amountOutMin,
425         address[] calldata path,
426         address to,
427         uint deadline
428     ) external;
429 }
430 
431 
432 //////REDTHEHORSE.sol
433 
434 
435 
436 contract REDTHEHORSE is ERC20, Ownable {
437  
438 
439             
440         uint256 public maxTransactionAmount;
441          uint256 public maxWallet;
442 
443 
444     address public walletAddress = 0xc940719B1D28739b8CB33337433eF0c225E469F8;
445    
446 
447     IUniswapV2Router02 public uniswapV2Router;
448     address public  uniswapV2Pair;
449        uint256 public buyFee  = 2;
450     uint256 public sellFee = 2;
451     
452     address private DEAD = 0x000000000000000000000000000000000000dEaD;
453 
454     bool    private swapping;
455     uint256 public swapTokensAtAmount;
456 
457     mapping (address => bool) private _isExcludedFromFees;
458 
459             event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
460 
461         mapping (address => bool) public automatedMarketMakerPairs;
462 
463 
464 
465     event ExcludeFromFees(address indexed account, bool isExcluded);
466     event FeesUpdated(uint256 buyFee, uint256 sellFee);
467     event walletAddressChanged(address indexed newWallet);
468     event SwapAndSendFee(uint256 tokensSwapped, uint256 ethSend);
469     event SwapTokensAtAmountChanged(uint256 newAmount);
470 
471     constructor () ERC20("REDTHEHORSE", "RTH") 
472     {   
473         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
474         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
475             .createPair(address(this), _uniswapV2Router.WETH());
476 
477         uniswapV2Router = _uniswapV2Router;
478         uniswapV2Pair   = _uniswapV2Pair;
479 
480         _approve(address(this), address(uniswapV2Router), type(uint256).max);
481             _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
482 
483         _isExcludedFromFees[owner()] = true;
484         _isExcludedFromFees[DEAD] = true;
485         
486         _isExcludedFromFees[address(this)] = true;
487 
488         
489         _isExcludedFromFees[walletAddress] = true;
490         
491         _mint(owner(), 1* 1e15 * (10 ** 18));
492         swapTokensAtAmount = 100000000000 * 1e18;
493          maxTransactionAmount = (totalSupply() * 2 / 100); // 2% maxTransactionAmountTxn
494           maxWallet = (totalSupply() * 3 / 100); // 3% max wallet
495 
496 
497     }
498 
499     receive() external payable {
500 
501   	}
502 
503     function claimStuckTokens(address token) external onlyOwner {
504         require(token != address(this), "Owner cannot claim native tokens");
505         if (token == address(0x0)) {
506             payable(msg.sender).transfer(address(this).balance);
507             return;
508         }
509         IERC20 ERC20token = IERC20(token);
510         uint256 balance = ERC20token.balanceOf(address(this));
511         ERC20token.transfer(msg.sender, balance);
512     }
513 
514     function sendETH(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         (bool success, ) = recipient.call{value: amount}("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     function excludeFromFees(address account, bool excluded) external onlyOwner {
522         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
523         _isExcludedFromFees[account] = excluded;
524 
525         emit ExcludeFromFees(account, excluded);
526     }
527 
528     function isExcludedFromFees(address account) public view returns(bool) {
529         return _isExcludedFromFees[account];
530     }
531         function updateMaxTxAmount(uint256 newNum) external onlyOwner {
532            
533             maxTransactionAmount = (newNum * 1e18) + (1 * 1e18) ;
534         }
535         
536         function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
537           
538             maxWallet = (newNum * 1e18) + (1 * 1e18);
539 
540         }
541 
542         function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
543 
544             require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
545             _setAutomatedMarketMakerPair(pair, value);
546         }
547 
548         function _setAutomatedMarketMakerPair(address pair, bool value) private {
549             automatedMarketMakerPairs[pair] = value;
550             emit SetAutomatedMarketMakerPair(pair, value);
551         }
552 
553     function setFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
554         require(_buyFee <= 20, "Marketing fee on buy cannot be more than 20%");
555         require(_sellFee <= 20, "Marketing fee on sell cannot be more than 20%");
556         buyFee  = _buyFee;
557         sellFee = _sellFee;
558         emit FeesUpdated(buyFee, sellFee);
559     }
560 
561     function changeWalletAddress(address _walletAddress) external onlyOwner {
562         walletAddress = _walletAddress;
563         _isExcludedFromFees[walletAddress] = true;
564         emit walletAddressChanged(walletAddress);
565     }
566    
567 
568     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
569         swapTokensAtAmount = newAmount;
570         emit SwapTokensAtAmountChanged(newAmount);
571     }
572 
573     function _transfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal  override {
578         require(from != address(0), "ERC20: transfer from the zero address");
579         require(to != address(0), "ERC20: transfer to the zero address");
580        
581         if(amount == 0) {
582             super._transfer(from, to, 0);
583             return;
584         }
585   if (
586                     from != owner() &&
587 
588                     to != owner() &&
589                     to != address(0) &&
590                     to != address(0xdead) &&
591                     !swapping
592                 ){
593                     //when buy
594                     if (automatedMarketMakerPairs[from] && !_isExcludedFromFees[to]) {
595                             require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
596                             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
597 
598                     }
599                     
600                     //when sell
601                     else if (automatedMarketMakerPairs[to] && !_isExcludedFromFees[from]) {
602                             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
603                     }
604                 }
605 
606 
607 
608 
609         uint256 contractTokenBalance = balanceOf(address(this));
610 
611         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
612 
613         if( canSwap &&
614             !swapping &&
615             to == uniswapV2Pair
616         ) {
617             swapping = true;
618             
619             swapAndSendFee(contractTokenBalance);
620 
621             swapping = false;
622         }
623 
624         bool takeFee = !swapping;
625 
626         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]){
627             takeFee = false;
628         }
629 
630         if(takeFee) {
631             uint256 fees;
632             if(from == uniswapV2Pair) {
633                 fees = amount * buyFee / 100;
634             } else if (to == uniswapV2Pair) {
635                 fees = amount * sellFee / 100;
636             } else {
637                 fees = 0;
638             }
639             amount -= fees;
640             if(fees > 0) {
641                 super._transfer(from, address(this), fees);
642             }
643         }
644 
645         super._transfer(from, to, amount);
646     }
647 
648     function swapAndSendFee(uint256 tokenAmount) private {
649         uint256 initialBalance = address(this).balance;
650 
651         address[] memory path = new address[](2);
652         path[0] = address(this);
653         path[1] = uniswapV2Router.WETH();
654 
655         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
656             tokenAmount,
657             0, // accept any amount of ETH
658             path,
659             address(this),
660             block.timestamp);
661 
662         uint256 newBalance = address(this).balance - initialBalance;
663 
664         sendETH(payable(walletAddress), newBalance);
665 
666         emit SwapAndSendFee(tokenAmount, newBalance);
667     }
668 
669 
670 }