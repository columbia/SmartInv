1 // SPDX-License-Identifier:MIT
2 pragma solidity ^0.8.10;
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
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address _account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount)
18         external
19         returns (bool);
20     function allowance(address owner, address spender)
21         external
22         view
23         returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(
42         address indexed previousOwner,
43         address indexed newOwner
44     );
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _setOwner(_msgSender());
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any _account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         _setOwner(address(0));
70     }
71 
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(
74             newOwner != address(0),
75             "Ownable: new owner is the zero address"
76         );
77         _setOwner(newOwner);
78     }
79 
80     function _setOwner(address newOwner) private {
81         address oldOwner = _owner;
82         _owner = newOwner;
83         emit OwnershipTransferred(oldOwner, newOwner);
84     }
85 }
86 
87 library SafeMath {
88 
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92 
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103 
104         return c;
105     }
106 
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         return mod(a, b, "SafeMath: modulo by zero");
132     }
133 
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 }
139 
140 interface IUniSwapFactory {
141     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
142     function createPair(address tokenA, address tokenB) external returns (address pair);
143 }
144 
145 interface IUniSwapPair {
146     event Approval(address indexed owner, address indexed spender, uint value);
147     event Transfer(address indexed from, address indexed to, uint value);
148 
149     function name() external pure returns (string memory);
150     function symbol() external pure returns (string memory);
151     function decimals() external pure returns (uint8);
152     function totalSupply() external view returns (uint);
153     function balanceOf(address owner) external view returns (uint);
154     function allowance(address owner, address spender) external view returns (uint);
155 
156     function approve(address spender, uint value) external returns (bool);
157     function transfer(address to, uint value) external returns (bool);
158     function transferFrom(address from, address to, uint value) external returns (bool);
159 
160     function DOMAIN_SEPARATOR() external view returns (bytes32);
161     function PERMIT_TYPEHASH() external pure returns (bytes32);
162     function nonces(address owner) external view returns (uint);
163 
164     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
165     
166     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
167     event Swap(
168         address indexed sender,
169         uint amount0In,
170         uint amount1In,
171         uint amount0Out,
172         uint amount1Out,
173         address indexed to
174     );
175     event Sync(uint112 reserve0, uint112 reserve1);
176 
177     function MINIMUM_LIQUIDITY() external pure returns (uint);
178     function factory() external view returns (address);
179     function token0() external view returns (address);
180     function token1() external view returns (address);
181     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
182     function price0CumulativeLast() external view returns (uint);
183     function price1CumulativeLast() external view returns (uint);
184     function kLast() external view returns (uint);
185 
186     function burn(address to) external returns (uint amount0, uint amount1);
187     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
188     function skim(address to) external;
189     function sync() external;
190 
191     function initialize(address, address) external;
192 }
193 
194 interface IUniSwapRouter {
195     function factory() external pure returns (address);
196     function WETH() external pure returns (address);
197     function addLiquidityETH(
198         address token,
199         uint amountTokenDesired,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
205     function swapExactTokensForETHSupportingFeeOnTransferTokens(
206         uint amountIn,
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external;
212 }
213 
214 contract MPLY is Context, IERC20, Ownable {
215 
216     using SafeMath for uint256;
217 
218     string private _name = "Moonopoly"; // token name
219     string private _symbol = "MPLY"; // token ticker
220     uint8 private _decimals = 18; // token decimals
221 
222     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
223     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
224 
225     uint256 _buyLiquidityFee = 3;
226     uint256 _buyMarketingFee = 2;
227 
228     uint256 _sellLiquidityFee = 8;
229     uint256 _sellMarketingFee = 8;
230 
231     uint256 public totalBuyFee;
232     uint256 public totalSellFee;
233 
234     address public marketingWallet = address(0xc372f1f1299eeD2225f27d12D499608654e1f245);
235     address public liquidityReciever = address(0x9eeFC7E6f44970FfFc4CD140f0afd2c8Ee4CB73E);
236     address private FundsRescueWallet;
237     
238     mapping (address => uint256) _balances;
239     mapping (address => mapping (address => uint256)) private _allowances;
240 
241     mapping (address => bool) public isExcludedFromFee;
242     mapping (address => bool) public isMarketPair;
243     mapping (address => bool) public isWalletLimitExempt;
244     mapping (address => bool) public isTxLimitExempt;
245     mapping (address => bool) public isBot;
246 
247     uint256 private _totalSupply = 50_000_000 * 10**_decimals;
248 
249     uint256 denominator = 100;
250 
251     uint256 public minimumTokensBeforeSwap = 30_000 * 10**_decimals;
252     uint256 public _maxTxAmount =  _totalSupply.mul(1).div(denominator);     //1%
253     uint256 public _walletMax = _totalSupply.mul(1).div(denominator);    //1%
254 
255     bool public transferFeeEnabled = true;
256     uint256 public initalTransferFee = 99; // 99% max fees limit on inital transfer
257     uint256 public launchedAt; 
258     uint256 public snipingTime = 60 seconds; //1 min snipping time
259     bool public trading; 
260 
261     bool public EnableTxLimit = true;
262     bool public checkWalletLimit = true;
263 
264     event SwapAndLiquifyEnabledUpdated(bool enabled);
265 
266     event SwapAndLiquify(
267         uint256 tokensSwapped,
268         uint256 ethReceived,
269         uint256 tokensIntoLiqudity
270     );
271     
272     event SwapTokensForETH(
273         uint256 amountIn,
274         address[] path
275     );
276 
277     modifier onlyGuard() {
278         require(msg.sender == FundsRescueWallet,"Error: Guarded!");
279         _;
280     }
281 
282     IUniSwapRouter public uniswapRouter;
283     address public uniswapPair;
284 
285     bool inSwapAndLiquify;
286     bool public swapAndLiquifyEnabled = true;
287 
288     modifier lockTheSwap {
289         inSwapAndLiquify = true;
290         _;
291         inSwapAndLiquify = false;
292     }
293 
294     constructor() {
295 
296         // //uniswap Swap
297         IUniSwapRouter _dexRouter = IUniSwapRouter(
298             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
299         );
300 
301         uniswapPair = IUniSwapFactory(_dexRouter.factory()).createPair(
302             address(this),
303             _dexRouter.WETH()
304         );
305 
306         uniswapRouter = _dexRouter;
307 
308         _allowances[address(this)][address(uniswapRouter)] = ~uint256(0);
309 
310         FundsRescueWallet = msg.sender;
311 
312         isExcludedFromFee[address(this)] = true;
313         isExcludedFromFee[msg.sender] = true;
314         isExcludedFromFee[address(uniswapRouter)] = true;
315 
316         isWalletLimitExempt[msg.sender] = true;
317         isWalletLimitExempt[address(uniswapPair)] = true;
318         isWalletLimitExempt[address(uniswapRouter)] = true;
319         isWalletLimitExempt[address(this)] = true;
320         
321         isTxLimitExempt[msg.sender] = true;
322         isTxLimitExempt[address(this)] = true;
323         isTxLimitExempt[address(uniswapRouter)] = true;
324 
325         isMarketPair[address(uniswapPair)] = true;
326 
327         totalBuyFee = _buyLiquidityFee.add(_buyMarketingFee);
328         totalSellFee = _sellLiquidityFee.add(_sellMarketingFee);
329 
330         _balances[msg.sender] = _totalSupply;
331         emit Transfer(address(0), msg.sender, _totalSupply);
332     }
333 
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     function symbol() public view returns (string memory) {
339         return _symbol;
340     }
341 
342     function decimals() public view returns (uint8) {
343         return _decimals;
344     }
345 
346     function totalSupply() public view override returns (uint256) {
347         return _totalSupply;
348     }
349 
350     function balanceOf(address account) public view override returns (uint256) {
351        return _balances[account];     
352     }
353 
354     function allowance(address owner, address spender) public view override returns (uint256) {
355         return _allowances[owner][spender];
356     }
357     
358     function getCirculatingSupply() public view returns (uint256) {
359         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
360     }
361 
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
364         return true;
365     }
366 
367     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
369         return true;
370     }
371 
372     function approve(address spender, uint256 amount) public override returns (bool) {
373         _approve(_msgSender(), spender, amount);
374         return true;
375     }
376 
377     function _approve(address owner, address spender, uint256 amount) private {
378         require(owner != address(0), "ERC20: approve from the zero address");
379         require(spender != address(0), "ERC20: approve to the zero address");
380 
381         _allowances[owner][spender] = amount;
382         emit Approval(owner, spender, amount);
383     }
384 
385      //to recieve ETH from uniswapV2Router when swaping
386     receive() external payable {}
387 
388     function transfer(address recipient, uint256 amount) public override returns (bool) {
389         _transfer(_msgSender(), recipient, amount);
390         return true;
391     }
392 
393     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
394         _transfer(sender, recipient, amount);
395         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
396         return true;
397     }
398 
399     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
400 
401         require(sender != address(0), "ERC20: transfer from the zero address");
402         require(recipient != address(0), "ERC20: transfer to the zero address");
403         require(amount > 0, "Transfer amount must be greater than zero");
404         
405         require(!isBot[sender], "ERC20: Bot detected");
406         require(!isBot[msg.sender], "ERC20: Bot detected");
407         require(!isBot[tx.origin], "ERC20: Bot detected");
408 
409         if(inSwapAndLiquify) {
410             return _basicTransfer(sender, recipient, amount);
411         }
412         else {
413 
414             if (!isExcludedFromFee[sender] && !isExcludedFromFee[recipient]) {
415                 require(trading, "ERC20: trading not enable yet");
416 
417                 if (
418                     block.timestamp < launchedAt + snipingTime &&
419                     sender != address(uniswapRouter)
420                 ) {
421                     if (uniswapPair == sender) {
422                         isBot[recipient] = true;
423                     } else if (uniswapPair == recipient) {
424                         isBot[sender] = true;
425                     }
426                 }
427             }
428 
429             uint256 contractTokenBalance = balanceOf(address(this));
430             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
431             
432             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
433             {
434                 swapAndLiquify(contractTokenBalance);
435             }
436 
437             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
438                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
439             } 
440             
441             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
442 
443             uint256 finalAmount = shouldNotTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
444 
445             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
446                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet Limit Exceeded!!");
447             }
448 
449             _balances[recipient] = _balances[recipient].add(finalAmount);
450 
451             emit Transfer(sender, recipient, finalAmount);
452             return true;
453         }
454 
455     }
456 
457     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
458         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
459         _balances[recipient] = _balances[recipient].add(amount);
460         emit Transfer(sender, recipient, amount);
461         return true;
462     }
463     
464     function shouldNotTakeFee(address sender, address recipient) internal view returns (bool) {
465         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
466             return true;
467         }
468         else if (isMarketPair[sender] || isMarketPair[recipient]) {
469             return false;
470         }
471         else {
472             return false;
473         }
474     }
475 
476     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
477         
478         uint feeAmount;
479 
480         unchecked {
481 
482             if(isMarketPair[sender]) { //buy
483                 feeAmount = amount.mul(totalBuyFee).div(denominator);
484             } 
485             else if(isMarketPair[recipient]) { //sell
486                 feeAmount = amount.mul(totalSellFee).div(denominator);
487             }
488             else {
489                 if(transferFeeEnabled) {
490                     feeAmount = amount.mul(initalTransferFee).div(denominator);
491                 }
492             }
493 
494             if(feeAmount > 0) {
495                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
496                 emit Transfer(sender, address(this), feeAmount);
497             }
498 
499             return amount.sub(feeAmount);
500         }
501         
502     }
503 
504     function swapAndLiquify(uint contractBalance) private lockTheSwap {
505 
506         uint256 totalShares = totalBuyFee.add(totalSellFee);
507 
508         if(totalShares == 0) return;
509 
510         uint256 _liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
511         // uint256 _MarketingShare = _buyMarketingFee.add(_sellMarketingFee);
512 
513         uint256 tokensForLP = contractBalance.mul(_liquidityShare).div(totalShares).div(2);
514         uint256 tokensForSwap = contractBalance.sub(tokensForLP);
515 
516         uint256 initialBalance = address(this).balance;
517         swapTokensForEth(tokensForSwap);
518         uint256 amountReceived = address(this).balance.sub(initialBalance);
519 
520         uint256 totalETHFee = totalShares.sub(_liquidityShare.div(2));
521         
522         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShare).div(totalETHFee).div(2);
523         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity);
524 
525         if(amountETHMarketing > 0)
526             payable(marketingWallet).transfer(amountETHMarketing);
527 
528         if(amountETHLiquidity > 0 && tokensForLP > 0)
529             addLiquidity(tokensForLP, amountETHLiquidity);
530     }
531 
532     function swapTokensForEth(uint256 tokenAmount) private {
533         // generate the uniswap pair path of token -> weth
534         address[] memory path = new address[](2);
535         path[0] = address(this);
536         path[1] = uniswapRouter.WETH();
537 
538         _approve(address(this), address(uniswapRouter), tokenAmount);
539 
540         // make the swap
541         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
542             tokenAmount,
543             0, // accept any amount of ETH
544             path,
545             address(this), // The contract
546             block.timestamp
547         );
548         
549         emit SwapTokensForETH(tokenAmount, path);
550     }
551 
552     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
553         // approve token transfer to cover all possible scenarios
554         _approve(address(this), address(uniswapRouter), tokenAmount);
555 
556         // add the liquidity
557         uniswapRouter.addLiquidityETH{value: ethAmount}(
558             address(this),
559             tokenAmount,
560             0, // slippage is unavoidable
561             0, // slippage is unavoidable
562             liquidityReciever,
563             block.timestamp
564         );
565     }
566 
567     function enableSwapAndLiquifiy(bool _status) external onlyOwner {
568         swapAndLiquifyEnabled = _status;
569         emit SwapAndLiquifyEnabledUpdated(_status);
570     }
571 
572     function setSwapThreshold(uint _newLimit) external onlyOwner {
573         minimumTokensBeforeSwap = _newLimit;
574     }
575 
576     function setBuyFee(uint _newLp, uint _newMarketing) external onlyOwner {
577         _buyLiquidityFee = _newLp;
578         _buyMarketingFee = _newMarketing;
579         totalBuyFee = _buyLiquidityFee.add(_buyMarketingFee);
580     }
581 
582     function setSellFee(uint _newLp, uint _newMarketing) external onlyOwner {
583         _sellLiquidityFee = _newLp;
584         _sellMarketingFee = _newMarketing;
585         totalSellFee = _sellLiquidityFee.add(_sellMarketingFee);
586     }
587 
588     function setMarketingWl(address _newWl) external onlyOwner {
589         marketingWallet = _newWl;
590     }
591 
592     function setLiquidityWl(address _newWl) external onlyOwner {
593         liquidityReciever = _newWl;
594     }
595 
596     function startTrading() external onlyOwner {
597         require(!trading, "ERC20: Already Enabled");
598         trading = true;
599         launchedAt = block.timestamp;
600     }
601 
602     //To Rescue Stucked Balance
603     function rescueFunds() external onlyGuard { 
604         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
605         require(os,"Transaction Failed!!");
606     }
607 
608     //To Rescue Stucked Tokens
609     function rescueTokens(IERC20 adr,address recipient,uint amount) external onlyGuard {
610         adr.transfer(recipient,amount);
611     }
612 
613     function addOrRemoveBots(address[] calldata accounts, bool value)
614         external
615         onlyOwner
616     {
617         for (uint256 i = 0; i < accounts.length; i++) {
618             isBot[accounts[i]] = value;
619         }
620     }
621 
622     function disableTransferFee(bool _status) external onlyOwner {
623         transferFeeEnabled = _status;
624     }
625 
626     function enableTxLimit(bool _status) external onlyOwner {
627         EnableTxLimit = _status;
628     }
629 
630     function enableWalletLimit(bool _status) external onlyOwner {
631         checkWalletLimit = _status;
632     }
633 
634     function excludeFromFee(address _adr,bool _status) external onlyOwner {
635         isExcludedFromFee[_adr] = _status;
636     }
637 
638     function excludeWalletLimit(address _adr,bool _status) external onlyOwner {
639         isWalletLimitExempt[_adr] = _status;
640     }
641 
642     function excludeTxLimit(address _adr,bool _status) external onlyOwner {
643         isTxLimitExempt[_adr] = _status;
644     }
645 
646     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
647         _walletMax = newLimit;
648     }
649 
650     function setTxLimit(uint256 newLimit) external onlyOwner() {
651         _maxTxAmount = newLimit;
652     }
653 
654     function setMarketPair(address _pair, bool _status) external onlyOwner {
655         isMarketPair[_pair] = _status;
656     }
657 
658     function setRouter(address _newRouter) external onlyOwner {
659         uniswapRouter = IUniSwapRouter(_newRouter);
660     }
661 
662 }