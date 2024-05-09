1 /*
2  __       __                                           ______    __                          __                 
3 /  \     /  |                                         /      \  /  |                        /  |                
4 $$  \   /$$ |  ______   _____  ____    ______        /$$$$$$  |_$$ |_     ______    _______ $$ |   __   _______ 
5 $$$  \ /$$$ | /      \ /     \/    \  /      \       $$ \__$$// $$   |   /      \  /       |$$ |  /  | /       |
6 $$$$  /$$$$ |/$$$$$$  |$$$$$$ $$$$  |/$$$$$$  |      $$      \$$$$$$/   /$$$$$$  |/$$$$$$$/ $$ |_/$$/ /$$$$$$$/ 
7 $$ $$ $$/$$ |$$    $$ |$$ | $$ | $$ |$$    $$ |       $$$$$$  | $$ | __ $$ |  $$ |$$ |      $$   $$<  $$      \ 
8 $$ |$$$/ $$ |$$$$$$$$/ $$ | $$ | $$ |$$$$$$$$/       /  \__$$ | $$ |/  |$$ \__$$ |$$ \_____ $$$$$$  \  $$$$$$  |
9 $$ | $/  $$ |$$       |$$ | $$ | $$ |$$       |      $$    $$/  $$  $$/ $$    $$/ $$       |$$ | $$  |/     $$/ 
10 $$/      $$/  $$$$$$$/ $$/  $$/  $$/  $$$$$$$/        $$$$$$/    $$$$/   $$$$$$/   $$$$$$$/ $$/   $$/ $$$$$$$/                                                                                                                                                                                                                                                                                                                                              
11  __i
12 |---|    
13 |[_]|    
14 |:::|    
15 |:::|    
16 `\   \   
17   \_=_\ BB            
18                     --- AMC                                      
19                     -        --                             
20                 --( /     \ )XXXXXXXXXXXXX                   
21             --XXX(   O   O  )XXXXXXXXXXXXXXX-              
22            /XXX(       U     )        XXXXXXX\               
23          /XXXXX(              )--   XXXXXXXXXXX\             
24         /XXXXX/ (      O     )   XXXXXX   \XXXXX\
25         XXXXX/   /            XXXXXX   \   \XXXXX----        
26         XXXXXX  /          XXXXXX         \  ----  -         
27 ---     XXX  /          XXXXXX      \           ---        
28   --  --  /      /\  XXXXXX            /     ---=         
29     -        /    XXXXXX              '--- XXXXXX         
30       --\/XXX\ XXXXXX                      /XXXXX         
31         \XXXXXXXXX                        /XXXXX/
32          \XXXXXX                         /XXXXX/         
33            \XXXXX--  /                -- XXXX/       
34             --XXXXXXX---------------  XXXXX--         
35                \XXXXXXXXXXXXXXXXXXXXXXXX-            
36                  --XXXXXXXXXXXXXXXXXX-
37 |_
38 (O)
39 |#|   NOK
40 '-'   
41 ================================================.
42      .-.   .-.     .--.                         |
43     | OO| | OO|   / _.-' .-.   .-.  .-.   .''.  |
44     |   | |   |   \  '-. '-'   '-'  '-'   '..'  |
45     '^^^' '^^^'    '--'                         |
46 ===============.  .-.  .================.  .-.  |
47                | |   | |                |  '-'  |
48                | |   | |      GME       |       |
49                | ':-:' |                |  .-.  |
50                |  '-'  |                |  '-'  |
51 ==============='       '================'       |
52                                         
53 https://twitter.com/MemeStocksETH
54 https://t.me/MemeStocksEntry
55 
56 */
57 
58 // SPDX-License-Identifier: MIT
59 
60 pragma solidity ^0.8.4;
61 
62 abstract contract Context {
63 
64     function _msgSender() internal view virtual returns (address payable) {
65         return payable(msg.sender);
66     }
67 
68     function _msgData() internal view virtual returns (bytes memory) {
69       
70         return msg.data;
71     }
72 }
73 
74 interface IERC20 {
75 
76     function totalSupply() external view returns (uint256);
77     function balanceOf(address account) external view returns (uint256);
78     function transfer(address recipient, uint256 amount) external returns (bool);
79     function allowance(address owner, address spender) external view returns (uint256);
80     function approve(address spender, uint256 amount) external returns (bool);
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82     event Transfer(address indexed from, address indexed to, uint256 value);
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 library SafeMath {
87 
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91 
92         return c;
93     }
94 
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return sub(a, b, "SafeMath: subtraction overflow");
97     }
98 
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120 
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         return mod(a, b, "SafeMath: modulo by zero");
131     }
132 
133     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b != 0, errorMessage);
135         return a % b;
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     constructor () {
145         address msgSender = _msgSender();
146         _owner = msgSender;
147         emit OwnershipTransferred(address(0), msgSender);
148     }
149 
150     function owner() public view returns (address) {
151         return _owner;
152     }   
153     
154     modifier onlyOwner() {
155         require(_owner == _msgSender(), "Ownable: caller is not the owner");
156         _;
157     }
158     
159     function renounceOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
161         _owner = address(0x000000000000000000000000000000000000dEaD);
162     }
163 
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         emit OwnershipTransferred(_owner, newOwner);
167         _owner = newOwner;
168     }
169 
170 }
171 
172 interface IUniswapV2Factory {
173     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
174 
175     function feeTo() external view returns (address);
176     function feeToSetter() external view returns (address);
177 
178     function getPair(address tokenA, address tokenB) external view returns (address pair);
179     function allPairs(uint) external view returns (address pair);
180     function allPairsLength() external view returns (uint);
181 
182     function createPair(address tokenA, address tokenB) external returns (address pair);
183 
184     function setFeeTo(address) external;
185     function setFeeToSetter(address) external;
186 }
187 
188 interface IUniswapV2Pair {
189     event Approval(address indexed owner, address indexed spender, uint value);
190     event Transfer(address indexed from, address indexed to, uint value);
191 
192     function name() external pure returns (string memory);
193     function symbol() external pure returns (string memory);
194     function decimals() external pure returns (uint8);
195     function totalSupply() external view returns (uint);
196     function balanceOf(address owner) external view returns (uint);
197     function allowance(address owner, address spender) external view returns (uint);
198 
199     function approve(address spender, uint value) external returns (bool);
200     function transfer(address to, uint value) external returns (bool);
201     function transferFrom(address from, address to, uint value) external returns (bool);
202 
203     function DOMAIN_SEPARATOR() external view returns (bytes32);
204     function PERMIT_TYPEHASH() external pure returns (bytes32);
205     function nonces(address owner) external view returns (uint);
206 
207     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
208     
209     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
210     event Swap(
211         address indexed sender,
212         uint amount0In,
213         uint amount1In,
214         uint amount0Out,
215         uint amount1Out,
216         address indexed to
217     );
218     event Sync(uint112 reserve0, uint112 reserve1);
219 
220     function MINIMUM_LIQUIDITY() external pure returns (uint);
221     function factory() external view returns (address);
222     function token0() external view returns (address);
223     function token1() external view returns (address);
224     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
225     function price0CumulativeLast() external view returns (uint);
226     function price1CumulativeLast() external view returns (uint);
227     function kLast() external view returns (uint);
228 
229     function burn(address to) external returns (uint amount0, uint amount1);
230     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
231     function skim(address to) external;
232     function sync() external;
233 
234     function initialize(address, address) external;
235 }
236 
237 interface IUniswapV2Router01 {
238     function factory() external pure returns (address);
239     function WETH() external pure returns (address);
240 
241     function addLiquidity(
242         address tokenA,
243         address tokenB,
244         uint amountADesired,
245         uint amountBDesired,
246         uint amountAMin,
247         uint amountBMin,
248         address to,
249         uint deadline
250     ) external returns (uint amountA, uint amountB, uint liquidity);
251     function addLiquidityETH(
252         address token,
253         uint amountTokenDesired,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline
258     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
259     function removeLiquidity(
260         address tokenA,
261         address tokenB,
262         uint liquidity,
263         uint amountAMin,
264         uint amountBMin,
265         address to,
266         uint deadline
267     ) external returns (uint amountA, uint amountB);
268     function removeLiquidityETH(
269         address token,
270         uint liquidity,
271         uint amountTokenMin,
272         uint amountETHMin,
273         address to,
274         uint deadline
275     ) external returns (uint amountToken, uint amountETH);
276     function removeLiquidityWithPermit(
277         address tokenA,
278         address tokenB,
279         uint liquidity,
280         uint amountAMin,
281         uint amountBMin,
282         address to,
283         uint deadline,
284         bool approveMax, uint8 v, bytes32 r, bytes32 s
285     ) external returns (uint amountA, uint amountB);
286     function removeLiquidityETHWithPermit(
287         address token,
288         uint liquidity,
289         uint amountTokenMin,
290         uint amountETHMin,
291         address to,
292         uint deadline,
293         bool approveMax, uint8 v, bytes32 r, bytes32 s
294     ) external returns (uint amountToken, uint amountETH);
295     function swapExactTokensForTokens(
296         uint amountIn,
297         uint amountOutMin,
298         address[] calldata path,
299         address to,
300         uint deadline
301     ) external returns (uint[] memory amounts);
302     function swapTokensForExactTokens(
303         uint amountOut,
304         uint amountInMax,
305         address[] calldata path,
306         address to,
307         uint deadline
308     ) external returns (uint[] memory amounts);
309     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
310         external
311         payable
312         returns (uint[] memory amounts);
313     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
314         external
315         returns (uint[] memory amounts);
316     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
317         external
318         returns (uint[] memory amounts);
319     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
320         external
321         payable
322         returns (uint[] memory amounts);
323 
324     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
325     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
326     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
327     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
328     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
329 }
330 
331 interface IUniswapV2Router02 is IUniswapV2Router01 {
332     function removeLiquidityETHSupportingFeeOnTransferTokens(
333         address token,
334         uint liquidity,
335         uint amountTokenMin,
336         uint amountETHMin,
337         address to,
338         uint deadline
339     ) external returns (uint amountETH);
340     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
341         address token,
342         uint liquidity,
343         uint amountTokenMin,
344         uint amountETHMin,
345         address to,
346         uint deadline,
347         bool approveMax, uint8 v, bytes32 r, bytes32 s
348     ) external returns (uint amountETH);
349 
350     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
351         uint amountIn,
352         uint amountOutMin,
353         address[] calldata path,
354         address to,
355         uint deadline
356     ) external;
357     function swapExactETHForTokensSupportingFeeOnTransferTokens(
358         uint amountOutMin,
359         address[] calldata path,
360         address to,
361         uint deadline
362     ) external payable;
363     function swapExactTokensForETHSupportingFeeOnTransferTokens(
364         uint amountIn,
365         uint amountOutMin,
366         address[] calldata path,
367         address to,
368         uint deadline
369     ) external;
370 }
371 
372 contract MemeStocks is Context, IERC20, Ownable {
373     
374     using SafeMath for uint256;
375     
376     string private _name = "Meme Stocks";
377     string private _symbol = "B.A.N.G.";
378     uint8 private _decimals = 18;
379 
380     address payable public marketingWallet = payable(0x796ef8EAb4bb6A4B4150F6A8973dDFa3744ee02f);
381     address payable public DeveloperWallet = payable(0x60D3fC7144d162e72098e5AF5eD348276E5b1d43);
382     
383     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
384     address public immutable zeroAddress = 0x0000000000000000000000000000000000000000;
385 
386     mapping (address => uint256) _balances;
387     mapping (address => mapping (address => uint256)) private _allowances;
388     
389     mapping (address => bool) public isExcludedFromFee;
390     mapping (address => bool) public isMarketPair;
391     mapping (address => bool) public blacklist;
392     mapping (address => bool) public isWalletLimitExempt;
393     mapping (address => bool) public isTxLimitExempt;
394 
395     uint256 public _buyLiquidityFee = 1;
396     uint256 public _buyMarketingFee = 3;
397     uint256 public _buyDeveloperFee = 1;
398     
399     uint256 public _sellLiquidityFee = 1;
400     uint256 public _sellMarketingFee = 3;
401     uint256 public _sellDeveloperFee = 1;
402 
403     uint256 public _totalTaxIfBuying;
404     uint256 public _totalTaxIfSelling;
405 
406     uint256 private _totalSupply = 100000 * 10**_decimals;
407 
408     uint256 public minimumTokensBeforeSwap = _totalSupply.mul(1).div(100);   //0.001%
409 
410     uint256 public _maxTxAmount =  _totalSupply.mul(2).div(100);  //2%
411     uint256 public _walletMax =   _totalSupply.mul(2).div(100);   //2%
412 
413     IUniswapV2Router02 public uniswapV2Router;
414     address public uniswapPair;
415     
416     bool inSwapAndLiquify;
417     bool public swapAndLiquifyEnabled = true;
418     bool public swapAndLiquifyByLimitOnly = false;
419 
420     bool public checkWalletLimit = true;
421     bool public EnableTransactionLimit = true;
422 
423     event SwapAndLiquifyEnabledUpdated(bool enabled);
424 
425     event SwapAndLiquify(
426         uint256 tokensSwapped,
427         uint256 ethReceived,
428         uint256 tokensIntoLiqudity
429     );
430     
431     event SwapETHForTokens(
432         uint256 amountIn,
433         address[] path
434     );
435     
436     event SwapTokensForETH(
437         uint256 amountIn,
438         address[] path
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
449         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
450         
451         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
452             .createPair(address(this), _uniswapV2Router.WETH());
453 
454         uniswapV2Router = _uniswapV2Router;
455         
456         _allowances[address(this)][address(uniswapV2Router)] = ~uint256(0);
457 
458         isExcludedFromFee[owner()] = true;
459         isExcludedFromFee[marketingWallet] = true;
460         isExcludedFromFee[DeveloperWallet] = true;
461         isExcludedFromFee[address(this)] = true;
462 
463         isWalletLimitExempt[owner()] = true;
464         isWalletLimitExempt[marketingWallet] = true;
465         isWalletLimitExempt[DeveloperWallet] = true;
466         isWalletLimitExempt[address(uniswapPair)] = true;
467         isWalletLimitExempt[address(this)] = true;
468         
469         isTxLimitExempt[owner()] = true;
470         isTxLimitExempt[marketingWallet] = true;
471         isTxLimitExempt[DeveloperWallet] = true;
472         isTxLimitExempt[address(this)] = true;
473         
474         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
475         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
476 
477         isMarketPair[address(uniswapPair)] = true;
478 
479         _balances[_msgSender()] = _totalSupply;
480         emit Transfer(address(0), _msgSender(), _totalSupply);
481     }
482 
483     function name() public view returns (string memory) {
484         return _name;
485     }
486 
487     function symbol() public view returns (string memory) {
488         return _symbol;
489     }
490 
491     function decimals() public view returns (uint8) {
492         return _decimals;
493     }
494 
495     function totalSupply() public view override returns (uint256) {
496         return _totalSupply;
497     }
498 
499     function balanceOf(address account) public view override returns (uint256) {
500         return _balances[account];
501     }
502 
503     function allowance(address owner, address spender) public view override returns (uint256) {
504         return _allowances[owner][spender];
505     }
506 
507     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
508         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
509         return true;
510     }
511 
512     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
514         return true;
515     }
516 
517     function approve(address spender, uint256 amount) public override returns (bool) {
518         _approve(_msgSender(), spender, amount);
519         return true;
520     }
521 
522     function _approve(address owner, address spender, uint256 amount) private {
523         require(owner != address(0), "ERC20: approve from the zero address");
524         require(spender != address(0), "ERC20: approve to the zero address");
525 
526         _allowances[owner][spender] = amount;
527         emit Approval(owner, spender, amount);
528     }
529 
530     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
531         isMarketPair[account] = newValue;
532     }
533 
534     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
535         isExcludedFromFee[account] = newValue;
536     }
537 
538     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
539         isTxLimitExempt[holder] = exempt;
540     }
541     
542     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
543         isWalletLimitExempt[holder] = exempt;
544     }
545 
546     function enableTxLimit(bool _status) external onlyOwner {
547         EnableTransactionLimit = _status;
548     }
549 
550     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
551         _maxTxAmount = maxTxAmount;
552     }
553 
554     function enableDisableWalletLimit(bool newValue) external onlyOwner {
555        checkWalletLimit = newValue;
556     }
557 
558     function setWalletLimit(uint256 newLimit) external onlyOwner {
559         _walletMax  = newLimit;
560     }
561 
562     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
563         minimumTokensBeforeSwap = newLimit;
564     }
565 
566     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
567         marketingWallet = payable(newAddress);
568     }
569 
570     function setDeveloperWalletAddress(address newAddress) external onlyOwner() {
571         DeveloperWallet = payable(newAddress);
572     }
573 
574     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
575         swapAndLiquifyEnabled = _enabled;
576         emit SwapAndLiquifyEnabledUpdated(_enabled);
577     }
578 
579     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
580         swapAndLiquifyByLimitOnly = newValue;
581     }
582     
583     function getCirculatingSupply() public view returns (uint256) {
584         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
585     }
586 
587     function setBlacklist(address _adr, bool _status) external onlyOwner {
588         blacklist[_adr] = _status;
589     }
590 
591     function transferToAddressETH(address payable recipient, uint256 amount) private {
592         recipient.transfer(amount);
593     }
594     
595     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
596 
597         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
598 
599         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
600 
601         if(newPairAddress == address(0)) //Create If Doesnt exist
602         {
603             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
604                 .createPair(address(this), _uniswapV2Router.WETH());
605         }
606 
607         uniswapPair = newPairAddress; //Set new pair address
608         uniswapV2Router = _uniswapV2Router; //Set new router address
609 
610         isMarketPair[address(uniswapPair)] = true;
611     }
612 
613     function setBuyTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
614         _buyLiquidityFee = _Liquidity;
615         _buyMarketingFee = _Marketing;
616         _buyDeveloperFee = _Developer;
617         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDeveloperFee);
618     }
619 
620     function setSellTaxes(uint _Liquidity, uint _Marketing , uint _Developer) public onlyOwner {
621         _sellLiquidityFee = _Liquidity;
622         _sellMarketingFee = _Marketing;
623         _sellDeveloperFee = _Developer;
624         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDeveloperFee);
625     }
626 
627      //to recieve ETH from uniswapV2Router when swaping
628     receive() external payable {}
629 
630     function transfer(address recipient, uint256 amount) public override returns (bool) {
631         _transfer(_msgSender(), recipient, amount);
632         return true;
633     }
634 
635     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
636         _transfer(sender, recipient, amount);
637         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
638         return true;
639     }
640 
641     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
642 
643         require(sender != address(0), "ERC20: transfer from the zero address");
644         require(recipient != address(0), "ERC20: transfer to the zero address");
645         require(!blacklist[sender] && !blacklist[recipient], "Bot Enemy address Restricted!");
646 
647         if(inSwapAndLiquify)
648         { 
649             return _basicTransfer(sender, recipient, amount); 
650         }
651         else
652         {
653 
654             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTransactionLimit) {
655                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
656             }
657 
658             uint256 contractTokenBalance = balanceOf(address(this));
659             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
660             
661             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
662             {
663                 if(swapAndLiquifyByLimitOnly)
664                     contractTokenBalance = minimumTokensBeforeSwap;
665                 swapAndLiquify(contractTokenBalance);    
666             }
667 
668             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
669 
670             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
671                                          amount : takeFee(sender, recipient, amount);
672 
673             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
674                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Amount Exceed From Max Wallet Limit!!");
675             }
676 
677             _balances[recipient] = _balances[recipient].add(finalAmount);
678 
679             emit Transfer(sender, recipient, finalAmount);
680             return true;
681         }
682         
683     }
684 
685     function rescueStuckedToken(address _token, uint _amount) external onlyOwner {
686         IERC20(_token).transfer(msg.sender,_amount);
687     }
688 
689     function rescueFunds() external onlyOwner {
690         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
691         require(os);
692     }
693 
694     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
695         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
696         _balances[recipient] = _balances[recipient].add(amount);
697         emit Transfer(sender, recipient, amount);
698         return true;
699     }
700 
701     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
702 
703         uint256 totalShares = _totalTaxIfBuying.add(_totalTaxIfSelling);
704 
705         uint256 liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
706         uint256 MarketingShare = _buyMarketingFee.add(_sellMarketingFee);
707         // uint256 DeveloperShare = _buyDeveloperFee.add(_sellDeveloperFee);
708         
709         uint256 tokenForLp = tAmount.mul(liquidityShare).div(totalShares).div(2);
710         uint256 tokenForSwap = tAmount.sub(tokenForLp);
711 
712         uint256 initialBalance =  address(this).balance;
713         swapTokensForEth(tokenForSwap);
714         uint256 recievedBalance =  address(this).balance.sub(initialBalance);
715 
716         uint256 totalETHFee = totalShares.sub(liquidityShare.div(2));
717 
718         uint256 amountETHLiquidity = recievedBalance.mul(liquidityShare).div(totalETHFee).div(2);
719         uint256 amountETHMarketing = recievedBalance.mul(MarketingShare).div(totalETHFee);
720         uint256 amountETHDeveloper = recievedBalance.sub(amountETHLiquidity).sub(amountETHMarketing);
721 
722         if(amountETHMarketing > 0) {
723             payable(marketingWallet).transfer(amountETHMarketing);
724         }
725 
726         if(amountETHDeveloper > 0) {
727             payable(DeveloperWallet).transfer(amountETHDeveloper);
728         }         
729 
730         if(amountETHLiquidity > 0 && tokenForLp > 0) {
731             addLiquidity(tokenForLp, amountETHLiquidity);
732         }
733     }
734     
735     function swapTokensForEth(uint256 tokenAmount) private {
736         // generate the uniswap pair path of token -> weth
737         address[] memory path = new address[](2);
738         path[0] = address(this);
739         path[1] = uniswapV2Router.WETH();
740 
741         _approve(address(this), address(uniswapV2Router), tokenAmount);
742 
743         // make the swap
744         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
745             tokenAmount,
746             0, // accept any amount of ETH
747             path,
748             address(this), // The contract
749             block.timestamp
750         );
751         
752         emit SwapTokensForETH(tokenAmount, path);
753     }
754 
755     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
756         // approve token transfer to cover all possible scenarios
757         _approve(address(this), address(uniswapV2Router), tokenAmount);
758 
759         // add the liquidity
760         uniswapV2Router.addLiquidityETH{value: ethAmount}(
761             address(this),
762             tokenAmount,
763             0, // slippage is unavoidable
764             0, // slippage is unavoidable
765             owner(),
766             block.timestamp
767         );
768     }
769 
770     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
771         
772         uint256 feeAmount = 0;
773         
774         if(isMarketPair[sender]) {
775             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
776         }
777         else if(isMarketPair[recipient]) {
778             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
779         }
780         
781         if(feeAmount > 0) {
782             _balances[address(this)] = _balances[address(this)].add(feeAmount);
783             emit Transfer(sender, address(this), feeAmount);
784         }
785 
786         return amount.sub(feeAmount);
787     }
788 
789     /* AirDrop Function*/
790 
791     function airdrop(address[] calldata _address,uint[] calldata _tokens) external onlyOwner {
792         address account = msg.sender;
793         require(_address.length == _tokens.length,"Error: Mismatch Length");
794         uint tokenCount;
795         for(uint i = 0; i < _tokens.length; i++) {
796             tokenCount += _tokens[i];
797         }
798         require(balanceOf(account) >= tokenCount,"Error: Insufficient Error!!");
799         _balances[account] = _balances[account].sub(tokenCount); 
800         for(uint j = 0; j < _address.length; j++) {
801             _balances[_address[j]] = _balances[_address[j]].add(_tokens[j]);
802             emit Transfer(account, _address[j], _tokens[j]);
803         }
804 
805     }
806 
807     
808 }