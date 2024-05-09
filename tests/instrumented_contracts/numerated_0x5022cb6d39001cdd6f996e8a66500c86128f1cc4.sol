1 /**
2 -Telegram: https://t.me/shiwaportal
3 
4 -Telegram announcememts: https://t.me/shiwaAnnouncements
5 
6 -Website: Https://shiwa.finance
7 
8 -Twitter: https://twitter.com/shiwa_finance
9 
10  __  __  __ __ __    __  ___ 
11  (( \ ||  || || ||    || // \\
12   \\  ||==|| || \\ /\ // ||=||
13  \_)) ||  || ||  \V/\V/  || ||
14                               
15 
16 SHIWA is a project that was born to unite people around the world regardless of their origin, 
17 we are a great community and we will reach everyone. For this reason SHIWA presents our BIG NEWS.
18 
19 SHIWA is going to launch on ETH chain!!! Also we launch with SHIWASWAP.
20 
21 10/17/22 08:00 UTC
22 
23 What's this means?‼️
24 
25 SHIWA will be present in both chains. 🔥
26 
27 How it will work as ecosystem?‼️
28 
29 #SHIWA will continue its journey to create a great ecosystem and uses for the community. 
30 1% of the fees generated in each transaction of the ETH network will be used to buy back and burn SHIWA in 
31 the ETHW network.
32 
33 What can SHIWA holders expect from the ETHW network?‼️
34 
35 Investors who hold SHIWA will see how the team grows the price of SHIWA and how the supply is reduced, 
36 creating greater buying pressure that will cause shiwa's value to grow week by week in ETHW.
37 
38 What about SHIWA on the ETH network?‼️
39 
40 The SHIWA team will continue to work to create a great ecosystem with utility to grow and endure over time, 
41 attracting more investors day by day.
42 
43 */
44 
45 
46 
47 
48 // SPDX-License-Identifier: Unlicensed
49 
50 pragma solidity 0.8.10;
51 
52 interface IERC20 {
53     
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 library SafeMath {
65     
66 
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a + b;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a - b;
73     }
74 
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a * b;
77     }
78     
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a / b;
81     }
82 
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         unchecked {
85             require(b <= a, errorMessage);
86             return a - b;
87         }
88     }
89     
90     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         unchecked {
92             require(b > 0, errorMessage);
93             return a / b;
94         }
95     }
96     
97 }
98 
99 
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         this; 
107         return msg.data;
108     }
109 }
110 
111 
112 library Address {
113     
114     function isContract(address account) internal view returns (bool) {
115         uint256 size;
116         assembly { size := extcodesize(account) }
117         return size > 0;
118     }
119 
120     function sendValue(address payable recipient, uint256 amount) internal {
121         require(address(this).balance >= amount, "Address: insufficient balance");
122         (bool success, ) = recipient.call{ value: amount }("");
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125     
126     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
127       return functionCall(target, data, "Address: low-level call failed");
128     }
129     
130     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, 0, errorMessage);
132     }
133     
134     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137     
138     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141         (bool success, bytes memory returndata) = target.call{ value: value }(data);
142         return _verifyCallResult(success, returndata, errorMessage);
143     }
144     
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148     
149     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
150         require(isContract(target), "Address: static call to non-contract");
151         (bool success, bytes memory returndata) = target.staticcall(data);
152         return _verifyCallResult(success, returndata, errorMessage);
153     }
154 
155 
156     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
158     }
159     
160     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
161         require(isContract(target), "Address: delegate call to non-contract");
162         (bool success, bytes memory returndata) = target.delegatecall(data);
163         return _verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
167         if (success) {
168             return returndata;
169         } else {
170             if (returndata.length > 0) {
171                  assembly {
172                     let returndata_size := mload(returndata)
173                     revert(add(32, returndata), returndata_size)
174                 }
175             } else {
176                 revert(errorMessage);
177             }
178         }
179     }
180 }
181 
182 
183 
184 interface IUniswapV2Factory {
185     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
186     function feeTo() external view returns (address);
187     function feeToSetter() external view returns (address);
188     function getPair(address tokenA, address tokenB) external view returns (address pair);
189     function allPairs(uint) external view returns (address pair);
190     function allPairsLength() external view returns (uint);
191     function createPair(address tokenA, address tokenB) external returns (address pair);
192     function setFeeTo(address) external;
193     function setFeeToSetter(address) external;
194 }
195 
196 interface IUniswapV2Pair {
197     event Approval(address indexed owner, address indexed spender, uint value);
198     event Transfer(address indexed from, address indexed to, uint value);
199     function name() external pure returns (string memory);
200     function symbol() external pure returns (string memory);
201     function decimals() external pure returns (uint8);
202     function totalSupply() external view returns (uint);
203     function balanceOf(address owner) external view returns (uint);
204     function allowance(address owner, address spender) external view returns (uint);
205     function approve(address spender, uint value) external returns (bool);
206     function transfer(address to, uint value) external returns (bool);
207     function transferFrom(address from, address to, uint value) external returns (bool);
208     function DOMAIN_SEPARATOR() external view returns (bytes32);
209     function PERMIT_TYPEHASH() external pure returns (bytes32);
210     function nonces(address owner) external view returns (uint);
211     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
212     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
213     event Swap(
214         address indexed sender,
215         uint amount0In,
216         uint amount1In,
217         uint amount0Out,
218         uint amount1Out,
219         address indexed to
220     );
221     event Sync(uint112 reserve0, uint112 reserve1);
222     function MINIMUM_LIQUIDITY() external pure returns (uint);
223     function factory() external view returns (address);
224     function token0() external view returns (address);
225     function token1() external view returns (address);
226     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
227     function price0CumulativeLast() external view returns (uint);
228     function price1CumulativeLast() external view returns (uint);
229     function kLast() external view returns (uint);
230     function burn(address to) external returns (uint amount0, uint amount1);
231     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
232     function skim(address to) external;
233     function sync() external;
234     function initialize(address, address) external;
235 }
236 
237 interface IUniswapV2Router01 {
238     function factory() external pure returns (address);
239     function WETH() external pure returns (address);
240     function addLiquidity(
241         address tokenA,
242         address tokenB,
243         uint amountADesired,
244         uint amountBDesired,
245         uint amountAMin,
246         uint amountBMin,
247         address to,
248         uint deadline
249     ) external returns (uint amountA, uint amountB, uint liquidity);
250     function addLiquidityETH(
251         address token,
252         uint amountTokenDesired,
253         uint amountTokenMin,
254         uint amountETHMin,
255         address to,
256         uint deadline
257     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
258     function removeLiquidity(
259         address tokenA,
260         address tokenB,
261         uint liquidity,
262         uint amountAMin,
263         uint amountBMin,
264         address to,
265         uint deadline
266     ) external returns (uint amountA, uint amountB);
267     function removeLiquidityETH(
268         address token,
269         uint liquidity,
270         uint amountTokenMin,
271         uint amountETHMin,
272         address to,
273         uint deadline
274     ) external returns (uint amountToken, uint amountETH);
275     function removeLiquidityWithPermit(
276         address tokenA,
277         address tokenB,
278         uint liquidity,
279         uint amountAMin,
280         uint amountBMin,
281         address to,
282         uint deadline,
283         bool approveMax, uint8 v, bytes32 r, bytes32 s
284     ) external returns (uint amountA, uint amountB);
285     function removeLiquidityETHWithPermit(
286         address token,
287         uint liquidity,
288         uint amountTokenMin,
289         uint amountETHMin,
290         address to,
291         uint deadline,
292         bool approveMax, uint8 v, bytes32 r, bytes32 s
293     ) external returns (uint amountToken, uint amountETH);
294     function swapExactTokensForTokens(
295         uint amountIn,
296         uint amountOutMin,
297         address[] calldata path,
298         address to,
299         uint deadline
300     ) external returns (uint[] memory amounts);
301     function swapTokensForExactTokens(
302         uint amountOut,
303         uint amountInMax,
304         address[] calldata path,
305         address to,
306         uint deadline
307     ) external returns (uint[] memory amounts);
308     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
309         external
310         payable
311         returns (uint[] memory amounts);
312     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
313         external
314         returns (uint[] memory amounts);
315     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
316         external
317         returns (uint[] memory amounts);
318     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
319         external
320         payable
321         returns (uint[] memory amounts);
322 
323     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
324     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
325     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
326     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
327     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
328 }
329 
330 interface IUniswapV2Router02 is IUniswapV2Router01 {
331     function removeLiquidityETHSupportingFeeOnTransferTokens(
332         address token,
333         uint liquidity,
334         uint amountTokenMin,
335         uint amountETHMin,
336         address to,
337         uint deadline
338     ) external returns (uint amountETH);
339     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
340         address token,
341         uint liquidity,
342         uint amountTokenMin,
343         uint amountETHMin,
344         address to,
345         uint deadline,
346         bool approveMax, uint8 v, bytes32 r, bytes32 s
347     ) external returns (uint amountETH);
348 
349     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
350         uint amountIn,
351         uint amountOutMin,
352         address[] calldata path,
353         address to,
354         uint deadline
355     ) external;
356     function swapExactETHForTokensSupportingFeeOnTransferTokens(
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     ) external payable;
362     function swapExactTokensForETHSupportingFeeOnTransferTokens(
363         uint amountIn,
364         uint amountOutMin,
365         address[] calldata path,
366         address to,
367         uint deadline
368     ) external;
369 }
370 
371 
372 
373 contract SHIWA is Context, IERC20 { 
374     using SafeMath for uint256;
375     using Address for address;
376 
377     address private _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     function owner() public view virtual returns (address) {
382         return _owner;
383     }
384 
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     function renounceOwnership() public virtual {
391         emit OwnershipTransferred(_owner, address(0));
392         _owner = address(0);
393     }
394 
395     mapping (address => uint256) private _tOwned;
396     mapping (address => mapping (address => uint256)) private _allowances;
397     mapping (address => bool) public _isExcludedFromFee; 
398 
399     address payable public Wallet_Marketing = payable(0x9D38F6581Cb7635CD5bf031Af1E1635b42db74fe); 
400     address payable public Wallet_Dev = payable(0x9D38F6581Cb7635CD5bf031Af1E1635b42db74fe);
401     address payable public constant Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 
402 
403 
404     uint256 private constant MAX = ~uint256(0);
405     uint8 private constant _decimals = 9;
406     uint256 private _tTotal = 10**15 * 10**_decimals;
407     string private constant _name = "SHIWA"; 
408     string private constant _symbol = unicode"SHIWA"; 
409 
410     uint8 private txCount = 0;
411     uint8 private swapTrigger = 10; 
412 
413     uint256 public _Tax_On_Buy = 5;
414     uint256 public _Tax_On_Sell = 5;
415 
416     uint256 public Percent_Marketing = 90;
417     uint256 public Percent_Dev = 0;
418     uint256 public Percent_Burn = 0;
419     uint256 public Percent_AutoLP = 10; 
420 
421     uint256 public _maxWalletToken = _tTotal * 100 / 100;
422     uint256 private _previousMaxWalletToken = _maxWalletToken;
423 
424     uint256 public _maxTxAmount = _tTotal * 100 / 100;  
425     uint256 private _previousMaxTxAmount = _maxTxAmount;
426                                      
427                                      
428     IUniswapV2Router02 public uniswapV2Router;
429     address public uniswapV2Pair;
430     bool public inSwapAndLiquify;
431     bool public swapAndLiquifyEnabled = true;
432     
433     event SwapAndLiquifyEnabledUpdated(bool true_or_false);
434     event SwapAndLiquify(
435         uint256 tokensSwapped,
436         uint256 ethReceived,
437         uint256 tokensIntoLiqudity
438         
439     );
440     
441     modifier lockTheSwap {
442         inSwapAndLiquify = true;
443         _;
444         inSwapAndLiquify = false;
445     }
446     
447     constructor () {
448 
449         _owner = 0x9D38F6581Cb7635CD5bf031Af1E1635b42db74fe;
450         emit OwnershipTransferred(address(0), _owner);
451 
452         _tOwned[owner()] = _tTotal;
453         
454         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
455         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); // Testnet
456         
457         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
458             .createPair(address(this), _uniswapV2Router.WETH());
459         uniswapV2Router = _uniswapV2Router;
460 
461         _isExcludedFromFee[owner()] = true;
462         _isExcludedFromFee[address(this)] = true;
463         _isExcludedFromFee[Wallet_Marketing] = true; 
464         _isExcludedFromFee[Wallet_Burn] = true;
465 
466         emit Transfer(address(0), owner(), _tTotal);
467 
468     }
469 
470     function name() public pure returns (string memory) {
471         return _name;
472     }
473 
474     function symbol() public pure returns (string memory) {
475         return _symbol;
476     }
477 
478     function decimals() public pure returns (uint8) {
479         return _decimals;
480     }
481 
482     function totalSupply() public view override returns (uint256) {
483         return _tTotal;
484     }
485 
486     function balanceOf(address account) public view override returns (uint256) {
487         return _tOwned[account];
488     }
489 
490     function transfer(address recipient, uint256 amount) public override returns (bool) {
491         _transfer(_msgSender(), recipient, amount);
492         return true;
493     }
494 
495     function allowance(address theOwner, address theSpender) public view override returns (uint256) {
496         return _allowances[theOwner][theSpender];
497     }
498 
499     function approve(address spender, uint256 amount) public override returns (bool) {
500         _approve(_msgSender(), spender, amount);
501         return true;
502     }
503 
504     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
505         _transfer(sender, recipient, amount);
506         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
507         return true;
508     }
509 
510     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
512         return true;
513     }
514 
515     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
516         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
517         return true;
518     }
519 
520     receive() external payable {}
521 
522     function _getCurrentSupply() private view returns(uint256) {
523         return (_tTotal);
524     }
525 
526 
527 
528     function _approve(address theOwner, address theSpender, uint256 amount) private {
529 
530         require(theOwner != address(0) && theSpender != address(0), "ERR: zero address");
531         _allowances[theOwner][theSpender] = amount;
532         emit Approval(theOwner, theSpender, amount);
533 
534     }
535 
536     function _transfer(
537         address from,
538         address to,
539         uint256 amount
540     ) private {
541 
542         if (to != owner() &&
543             to != Wallet_Burn &&
544             to != address(this) &&
545             to != uniswapV2Pair &&
546             from != owner()){
547             uint256 heldTokens = balanceOf(to);
548             require((heldTokens + amount) <= _maxWalletToken,"Over wallet limit.");}
549 
550         if (from != owner())
551             require(amount <= _maxTxAmount, "Over transaction limit.");
552 
553 
554         require(from != address(0) && to != address(0), "ERR: Using 0 address!");
555         require(amount > 0, "Token value must be higher than zero.");   
556 
557         if(
558             txCount >= swapTrigger && 
559             !inSwapAndLiquify &&
560             from != uniswapV2Pair &&
561             swapAndLiquifyEnabled 
562             )
563         {  
564             
565             uint256 contractTokenBalance = balanceOf(address(this));
566             if(contractTokenBalance > _maxTxAmount) {contractTokenBalance = _maxTxAmount;}
567             txCount = 0;
568             swapAndLiquify(contractTokenBalance);
569         }
570         
571         bool takeFee = true;
572         bool isBuy;
573         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
574             takeFee = false;
575         } else {
576          
577             if(from == uniswapV2Pair){
578                 isBuy = true;
579             }
580 
581             txCount++;
582 
583         }
584 
585         _tokenTransfer(from, to, amount, takeFee, isBuy);
586 
587     }
588     
589     function sendToWallet(address payable wallet, uint256 amount) private {
590             wallet.transfer(amount);
591 
592         }
593 
594 
595     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
596 
597             uint256 tokens_to_Burn = contractTokenBalance * Percent_Burn / 100;
598             _tTotal = _tTotal - tokens_to_Burn;
599             _tOwned[Wallet_Burn] = _tOwned[Wallet_Burn] + tokens_to_Burn;
600             _tOwned[address(this)] = _tOwned[address(this)] - tokens_to_Burn; 
601 
602             uint256 tokens_to_M = contractTokenBalance * Percent_Marketing / 100;
603             uint256 tokens_to_D = contractTokenBalance * Percent_Dev / 100;
604             uint256 tokens_to_LP_Half = contractTokenBalance * Percent_AutoLP / 200;
605 
606             uint256 balanceBeforeSwap = address(this).balance;
607             swapTokensForBNB(tokens_to_LP_Half + tokens_to_M + tokens_to_D);
608             uint256 BNB_Total = address(this).balance - balanceBeforeSwap;
609 
610             uint256 split_M = Percent_Marketing * 100 / (Percent_AutoLP + Percent_Marketing + Percent_Dev);
611             uint256 BNB_M = BNB_Total * split_M / 100;
612 
613             uint256 split_D = Percent_Dev * 100 / (Percent_AutoLP + Percent_Marketing + Percent_Dev);
614             uint256 BNB_D = BNB_Total * split_D / 100;
615 
616 
617             addLiquidity(tokens_to_LP_Half, (BNB_Total - BNB_M - BNB_D));
618             emit SwapAndLiquify(tokens_to_LP_Half, (BNB_Total - BNB_M - BNB_D), tokens_to_LP_Half);
619 
620             sendToWallet(Wallet_Marketing, BNB_M);
621 
622             BNB_Total = address(this).balance;
623             sendToWallet(Wallet_Dev, BNB_Total);
624 
625             }
626 
627     function swapTokensForBNB(uint256 tokenAmount) private {
628 
629         address[] memory path = new address[](2);
630         path[0] = address(this);
631         path[1] = uniswapV2Router.WETH();
632         _approve(address(this), address(uniswapV2Router), tokenAmount);
633         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
634             tokenAmount,
635             0, 
636             path,
637             address(this),
638             block.timestamp
639         );
640     }
641 
642 
643     function addLiquidity(uint256 tokenAmount, uint256 BNBAmount) private {
644 
645         _approve(address(this), address(uniswapV2Router), tokenAmount);
646         uniswapV2Router.addLiquidityETH{value: BNBAmount}(
647             address(this),
648             tokenAmount,
649             0, 
650             0,
651             Wallet_Burn, 
652             block.timestamp
653         );
654     } 
655 
656     function remove_Random_Tokens(address random_Token_Address, uint256 percent_of_Tokens) public returns(bool _sent){
657         require(random_Token_Address != address(this), "Can not remove native token");
658         uint256 totalRandom = IERC20(random_Token_Address).balanceOf(address(this));
659         uint256 removeRandom = totalRandom*percent_of_Tokens/100;
660         _sent = IERC20(random_Token_Address).transfer(Wallet_Dev, removeRandom);
661 
662     }
663 
664 
665     function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool takeFee, bool isBuy) private {
666         
667         
668         if(!takeFee){
669 
670             _tOwned[sender] = _tOwned[sender]-tAmount;
671             _tOwned[recipient] = _tOwned[recipient]+tAmount;
672             emit Transfer(sender, recipient, tAmount);
673 
674             if(recipient == Wallet_Burn)
675             _tTotal = _tTotal-tAmount;
676 
677             } else if (isBuy){
678 
679             uint256 buyFEE = tAmount*_Tax_On_Buy/100;
680             uint256 tTransferAmount = tAmount-buyFEE;
681 
682             _tOwned[sender] = _tOwned[sender]-tAmount;
683             _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
684             _tOwned[address(this)] = _tOwned[address(this)]+buyFEE;   
685             emit Transfer(sender, recipient, tTransferAmount);
686 
687             if(recipient == Wallet_Burn)
688             _tTotal = _tTotal-tTransferAmount;
689             
690             } else {
691 
692             uint256 sellFEE = tAmount*_Tax_On_Sell/100;
693             uint256 tTransferAmount = tAmount-sellFEE;
694 
695             _tOwned[sender] = _tOwned[sender]-tAmount;
696             _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
697             _tOwned[address(this)] = _tOwned[address(this)]+sellFEE;   
698             emit Transfer(sender, recipient, tTransferAmount);
699 
700             if(recipient == Wallet_Burn)
701             _tTotal = _tTotal-tTransferAmount;
702 
703 
704             }
705 
706     }
707 
708 
709 }