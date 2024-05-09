1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13     function createPair(address tokenA, address tokenB) external returns (address pair);
14     function setFeeTo(address) external;
15     function setFeeToSetter(address) external;
16 }
17 
18 interface IUniswapV2Pair {
19     event Approval(address indexed owner, address indexed spender, uint value);
20     event Transfer(address indexed from, address indexed to, uint value);
21 
22     function name() external pure returns (string memory);
23     function symbol() external pure returns (string memory);
24     function decimals() external pure returns (uint8);
25     function totalSupply() external view returns (uint);
26     function balanceOf(address owner) external view returns (uint);
27     function allowance(address owner, address spender) external view returns (uint);
28 
29     function approve(address spender, uint value) external returns (bool);
30     function transfer(address to, uint value) external returns (bool);
31     function transferFrom(address from, address to, uint value) external returns (bool);
32 
33     function DOMAIN_SEPARATOR() external view returns (bytes32);
34     function PERMIT_TYPEHASH() external pure returns (bytes32);
35     function nonces(address owner) external view returns (uint);
36 
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38 
39     event Mint(address indexed sender, uint amount0, uint amount1);
40     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
41     event Swap(
42         address indexed sender,
43         uint amount0In,
44         uint amount1In,
45         uint amount0Out,
46         uint amount1Out,
47         address indexed to
48     );
49     event Sync(uint112 reserve0, uint112 reserve1);
50 
51     function MINIMUM_LIQUIDITY() external pure returns (uint);
52     function factory() external view returns (address);
53     function token0() external view returns (address);
54     function token1() external view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56     function price0CumulativeLast() external view returns (uint);
57     function price1CumulativeLast() external view returns (uint);
58     function kLast() external view returns (uint);
59 
60     function mint(address to) external returns (uint liquidity);
61     function burn(address to) external returns (uint amount0, uint amount1);
62     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
63     function skim(address to) external;
64     function sync() external;
65 
66     function initialize(address, address) external;
67 }
68 
69 interface IUniswapV2Router01 {
70     function factory() external pure returns (address);
71     function WETH() external pure returns (address);
72 
73     function addLiquidity(
74         address tokenA,
75         address tokenB,
76         uint amountADesired,
77         uint amountBDesired,
78         uint amountAMin,
79         uint amountBMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountA, uint amountB, uint liquidity);
83     function addLiquidityETH(
84         address token,
85         uint amountTokenDesired,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline
90     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
91     function removeLiquidity(
92         address tokenA,
93         address tokenB,
94         uint liquidity,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline
99     ) external returns (uint amountA, uint amountB);
100     function removeLiquidityETH(
101         address token,
102         uint liquidity,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external returns (uint amountToken, uint amountETH);
108     function removeLiquidityWithPermit(
109         address tokenA,
110         address tokenB,
111         uint liquidity,
112         uint amountAMin,
113         uint amountBMin,
114         address to,
115         uint deadline,
116         bool approveMax, uint8 v, bytes32 r, bytes32 s
117     ) external returns (uint amountA, uint amountB);
118     function removeLiquidityETHWithPermit(
119         address token,
120         uint liquidity,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline,
125         bool approveMax, uint8 v, bytes32 r, bytes32 s
126     ) external returns (uint amountToken, uint amountETH);
127     function swapExactTokensForTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external returns (uint[] memory amounts);
134     function swapTokensForExactTokens(
135         uint amountOut,
136         uint amountInMax,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external returns (uint[] memory amounts);
141     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
142         external
143         payable
144         returns (uint[] memory amounts);
145     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
146         external
147         returns (uint[] memory amounts);
148     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
149         external
150         returns (uint[] memory amounts);
151     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
152         external
153         payable
154         returns (uint[] memory amounts);
155 
156     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
157     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
158     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
159     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
160     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
161 }
162 
163 interface IUniswapV2Router02 is IUniswapV2Router01 {
164     function removeLiquidityETHSupportingFeeOnTransferTokens(
165         address token,
166         uint liquidity,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline
171     ) external returns (uint amountETH);
172     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
173         address token,
174         uint liquidity,
175         uint amountTokenMin,
176         uint amountETHMin,
177         address to,
178         uint deadline,
179         bool approveMax, uint8 v, bytes32 r, bytes32 s
180     ) external returns (uint amountETH);
181 
182     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
183         uint amountIn,
184         uint amountOutMin,
185         address[] calldata path,
186         address to,
187         uint deadline
188     ) external;
189     function swapExactETHForTokensSupportingFeeOnTransferTokens(
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external payable;
195     function swapExactTokensForETHSupportingFeeOnTransferTokens(
196         uint amountIn,
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external;
202 }
203 
204 interface IERC20 {
205     function totalSupply() external view returns (uint256);
206     function balanceOf(address account) external view returns (uint256);
207     function transfer(address recipient, uint256 amount) external returns (bool);
208     function allowance(address owner, address spender) external view returns (uint256);
209     function approve(address spender, uint256 amount) external returns (bool);
210     function transferFrom(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) external returns (bool);
215    
216     event Transfer(address indexed from, address indexed to, uint256 value);
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 interface IERC20Metadata is IERC20 {
221     function name() external view returns (string memory);
222     function symbol() external view returns (string memory);
223     function decimals() external view returns (uint8);
224 }
225 
226 library Address {
227     function isContract(address account) internal view returns (bool) {
228         return account.code.length > 0;
229     }
230 
231     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         (bool success, ) = recipient.call{value: amount}("");
235         return success;
236     }
237 
238     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
240     }
241 
242     function functionCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     function functionCallWithValue(
251         address target,
252         bytes memory data,
253         uint256 value
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
256     }
257 
258     function functionCallWithValue(
259         address target,
260         bytes memory data,
261         uint256 value,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         require(address(this).balance >= value, "Address: insufficient balance for call");
265         (bool success, bytes memory returndata) = target.call{value: value}(data);
266         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
267     }
268 
269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
270         return functionStaticCall(target, data, "Address: low-level static call failed");
271     }
272 
273     function functionStaticCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal view returns (bytes memory) {
278         (bool success, bytes memory returndata) = target.staticcall(data);
279         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
280     }
281 
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     function functionDelegateCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
293     }
294 
295     function verifyCallResultFromTarget(
296         address target,
297         bool success,
298         bytes memory returndata,
299         string memory errorMessage
300     ) internal view returns (bytes memory) {
301         if (success) {
302             if (returndata.length == 0) {
303                 // only check isContract if the call was successful and the return data is empty
304                 // otherwise we already know that it was a contract
305                 require(isContract(target), "Address: call to non-contract");
306             }
307             return returndata;
308         } else {
309             _revert(returndata, errorMessage);
310         }
311     }
312 
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             _revert(returndata, errorMessage);
322         }
323     }
324 
325     function _revert(bytes memory returndata, string memory errorMessage) private pure {
326         // Look for revert reason and bubble it up if present
327         if (returndata.length > 0) {
328             // The easiest way to bubble the revert reason is using memory via assembly
329             /// @solidity memory-safe-assembly
330             assembly {
331                 let returndata_size := mload(returndata)
332                 revert(add(32, returndata), returndata_size)
333             }
334         } else {
335             revert(errorMessage);
336         }
337     }
338 }
339 
340 abstract contract Context {
341     function _msgSender() internal view virtual returns (address) {
342         return msg.sender;
343     }
344 
345     function _msgData() internal view virtual returns (bytes calldata) {
346         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
347         return msg.data;
348     }
349 }
350 
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     constructor () {
357         address msgSender = _msgSender();
358         _owner = msgSender;
359         emit OwnershipTransferred(address(0), msgSender);
360     }
361 
362     function owner() public view returns (address) {
363         return _owner;
364     }
365 
366     modifier onlyOwner() {
367         require(_owner == _msgSender(), "Ownable: caller is not the owner");
368         _;
369     }
370 
371     function renounceOwnership() public virtual onlyOwner {
372         emit OwnershipTransferred(_owner, address(0));
373         _owner = address(0);
374     }
375 
376     function transferOwnership(address newOwner) public virtual onlyOwner {
377         require(newOwner != address(0), "Ownable: new owner is the zero address");
378         emit OwnershipTransferred(_owner, newOwner);
379         _owner = newOwner;
380     }
381 }
382 
383 contract ERC20 is Context, IERC20, IERC20Metadata {
384     mapping(address => uint256) private _balances;
385 
386     mapping(address => mapping(address => uint256)) private _allowances;
387 
388     uint256 private _totalSupply;
389 
390     string private _name;
391     string private _symbol;
392 
393     constructor(string memory name_, string memory symbol_) {
394         _name = name_;
395         _symbol = symbol_;
396     }
397 
398     function name() public view virtual override returns (string memory) {
399         return _name;
400     }
401 
402     function symbol() public view virtual override returns (string memory) {
403         return _symbol;
404     }
405 
406     function decimals() public view virtual override returns (uint8) {
407         return 18;
408     }
409 
410     function totalSupply() public view virtual override returns (uint256) {
411         return _totalSupply;
412     }
413 
414     function balanceOf(address account) public view virtual override returns (uint256) {
415         return _balances[account];
416     }
417 
418     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
419         _transfer(_msgSender(), recipient, amount);
420         return true;
421     }
422 
423     function allowance(address owner, address spender) public view virtual override returns (uint256) {
424         return _allowances[owner][spender];
425     }
426 
427     function approve(address spender, uint256 amount) public virtual override returns (bool) {
428         _approve(_msgSender(), spender, amount);
429         return true;
430     }
431 
432     function transferFrom(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) public virtual override returns (bool) {
437         uint256 currentAllowance = _allowances[sender][_msgSender()];
438         if (currentAllowance != type(uint256).max) {
439             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
440             unchecked {
441                 _approve(sender, _msgSender(), currentAllowance - amount);
442             }
443         }
444 
445         _transfer(sender, recipient, amount);
446 
447         return true;
448     }
449 
450     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
452         return true;
453     }
454 
455     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
456         uint256 currentAllowance = _allowances[_msgSender()][spender];
457         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
458         unchecked {
459             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
460         }
461 
462         return true;
463     }
464 
465     function _transfer(
466         address sender,
467         address recipient,
468         uint256 amount
469     ) internal virtual {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _beforeTokenTransfer(sender, recipient, amount);
474 
475         uint256 senderBalance = _balances[sender];
476         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
477         unchecked {
478             _balances[sender] = senderBalance - amount;
479         }
480         _balances[recipient] += amount;
481 
482         emit Transfer(sender, recipient, amount);
483 
484         _afterTokenTransfer(sender, recipient, amount);
485     }
486 
487     function _mint(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _beforeTokenTransfer(address(0), account, amount);
491 
492         _totalSupply += amount;
493         _balances[account] += amount;
494         emit Transfer(address(0), account, amount);
495 
496         _afterTokenTransfer(address(0), account, amount);
497     }
498 
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         uint256 accountBalance = _balances[account];
505         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
506         unchecked {
507             _balances[account] = accountBalance - amount;
508         }
509         _totalSupply -= amount;
510 
511         emit Transfer(account, address(0), amount);
512 
513         _afterTokenTransfer(account, address(0), amount);
514     }
515 
516     function _approve(
517         address owner,
518         address spender,
519         uint256 amount
520     ) internal virtual {
521         require(owner != address(0), "ERC20: approve from the zero address");
522         require(spender != address(0), "ERC20: approve to the zero address");
523 
524         _allowances[owner][spender] = amount;
525         emit Approval(owner, spender, amount);
526     }
527 
528     function _beforeTokenTransfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal virtual {}
533 
534     function _afterTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 }
540 
541 contract BWSM is ERC20, Ownable {
542     using Address for address payable;
543 
544     IUniswapV2Router02 public uniswapV2Router;
545     address public  uniswapV2Pair;
546 
547     mapping (address => bool) private _isExcludedFromFees;
548 
549     uint256 private  liquidityFeeOnBuy;
550     uint256 private  liquidityFeeOnSell;
551 
552     uint256 public  marketingFeeOnBuy;
553     uint256 public  marketingFeeOnSell;
554 
555     uint256 private _totalFeesOnBuy;
556     uint256 private _totalFeesOnSell;
557 
558     uint256 public  walletToWalletTransferFee;
559 
560     address public  marketingWallet;
561     address public  marketingWalletTwo;
562 
563     uint256 public  swapTokensAtAmount;
564     bool    private swapping;
565 
566     bool    public swapEnabled;
567 
568     event ExcludeFromFees(address indexed account, bool isExcluded);
569     event MarketingWalletChanged(address marketingWallet);
570     event MarketingWalletTwoChanged(address marketingWalletTwo);
571     event SwapAndLiquify(uint256 tokensSwapped,uint256 bnbReceived,uint256 tokensIntoLiqudity);
572     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
573     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
574 
575     constructor () ERC20("BABY WALL STREET MEMES", "$BWSM") 
576     {   
577         address router;
578         if (block.chainid == 56) {
579             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
580         } else if (block.chainid == 97) {
581             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
582         } else if (block.chainid == 1 || block.chainid == 5) {
583             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
584         } else {
585             revert();
586         }
587 
588         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
589         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
590             .createPair(address(this), _uniswapV2Router.WETH());
591 
592         uniswapV2Router = _uniswapV2Router;
593         uniswapV2Pair   = _uniswapV2Pair;
594 
595         _approve(address(this), address(uniswapV2Router), type(uint256).max);
596 
597         liquidityFeeOnBuy  = 0;
598         liquidityFeeOnSell = 0;
599 
600         marketingFeeOnBuy  = 0;
601         marketingFeeOnSell = 2;
602 
603         _totalFeesOnBuy    = liquidityFeeOnBuy  + marketingFeeOnBuy;
604         _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
605 
606         walletToWalletTransferFee = 1;
607 
608         marketingWallet = 0xD48480C953De6C62022B0DC61EF9e6682c4B7094;
609         marketingWalletTwo = 0x90573449348cf14e4e9a4bb5050C1F83AEDE4E2E;
610 
611         maxTransactionLimitEnabled = true;
612 
613         _isExcludedFromMaxTxLimit[owner()] = true;
614         _isExcludedFromMaxTxLimit[address(this)] = true;
615         _isExcludedFromMaxTxLimit[address(0xdead)] = true;
616         _isExcludedFromMaxTxLimit[marketingWallet] = true;
617         _isExcludedFromMaxTxLimit[marketingWalletTwo] = true;
618 
619         _isExcludedFromFees[owner()] = true;
620         _isExcludedFromFees[address(0xdead)] = true;
621         _isExcludedFromFees[address(this)] = true;
622         _isExcludedFromFees[marketingWallet] = true;
623         _isExcludedFromFees[marketingWalletTwo] = true;
624 
625         _mint(owner(), 2e9 * (10 ** decimals()));
626         swapTokensAtAmount = totalSupply() / 5_000;
627     
628         maxTransactionAmountBuy     = totalSupply();
629         maxTransactionAmountSell    = totalSupply() * 10 / 1000;
630     
631         tradingEnabled = false;
632         swapEnabled = false;
633     }
634 
635     receive() external payable {
636 
637     }
638 
639     function claimStuckTokens(address token) external onlyOwner {
640         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
641         if (token == address(0x0)) {
642             payable(msg.sender).sendValue(address(this).balance);
643             return;
644         }
645         IERC20 ERC20token = IERC20(token);
646         uint256 balance = ERC20token.balanceOf(address(this));
647         ERC20token.transfer(msg.sender, balance);
648     }
649 
650     function excludeFromFees(address account, bool excluded) external onlyOwner{
651         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
652         _isExcludedFromFees[account] = excluded;
653 
654         emit ExcludeFromFees(account, excluded);
655     }
656 
657     function isExcludedFromFees(address account) public view returns(bool) {
658         return _isExcludedFromFees[account];
659     }
660 
661     function changeMarketingWallet(address _marketingWallet) external onlyOwner{
662         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
663         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
664         marketingWallet = _marketingWallet;
665 
666         emit MarketingWalletChanged(marketingWallet);
667     }
668 
669     function changeMarketingWalletTwo(address _marketingWalletTwo) external onlyOwner{
670         require(_marketingWalletTwo != marketingWalletTwo,"Marketing wallet is already that address");
671         require(_marketingWalletTwo != address(0),"Marketing wallet cannot be the zero address");
672         marketingWalletTwo = _marketingWalletTwo;
673 
674         emit MarketingWalletTwoChanged(marketingWalletTwo);
675     }
676 
677     bool public tradingEnabled;
678 
679     function enableTrading() external onlyOwner{
680         require(!tradingEnabled, "Trading already enabled.");
681         tradingEnabled = true;
682         swapEnabled = true;
683     }
684 
685     function _transfer(address from,address to,uint256 amount) internal  override {
686         require(from != address(0), "ERC20: transfer from the zero address");
687         require(to != address(0), "ERC20: transfer to the zero address");
688         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
689        
690         if (amount == 0) {
691             super._transfer(from, to, 0);
692             return;
693         }
694 
695         if (maxTransactionLimitEnabled) 
696         {
697             if ((from == uniswapV2Pair || to == uniswapV2Pair) &&
698                 !_isExcludedFromMaxTxLimit[from] && 
699                 !_isExcludedFromMaxTxLimit[to]
700             ) {
701                 if (from == uniswapV2Pair) {
702                     require(
703                         amount <= maxTransactionAmountBuy,  
704                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
705                     );
706                 } else {
707                     require(
708                         amount <= maxTransactionAmountSell, 
709                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
710                     );
711                 }
712             }
713         }
714 
715         uint256 contractTokenBalance = balanceOf(address(this));
716 
717         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
718 
719         if (canSwap &&
720             !swapping &&
721             to == uniswapV2Pair &&
722             _totalFeesOnBuy + _totalFeesOnSell > 0 &&
723             swapEnabled
724         ) {
725             swapping = true;
726 
727             uint256 totalFee = _totalFeesOnBuy + _totalFeesOnSell;
728             uint256 liquidityShare = liquidityFeeOnBuy + liquidityFeeOnSell;
729             uint256 marketingShare = marketingFeeOnBuy + marketingFeeOnSell;
730 
731             if (liquidityShare > 0) {
732                 uint256 liquidityTokens = contractTokenBalance * liquidityShare / totalFee;
733                 swapAndLiquify(liquidityTokens);
734             }
735             
736             if (marketingShare > 0) {
737                 uint256 marketingTokens = contractTokenBalance * marketingShare / totalFee;
738                 swapAndSendMarketing(marketingTokens);
739             }          
740 
741             swapping = false;
742         }
743 
744         uint256 _totalFees;
745         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
746             _totalFees = 0;
747         } else if (from == uniswapV2Pair) {
748             _totalFees = _totalFeesOnBuy;
749         } else if (to == uniswapV2Pair) {
750             _totalFees = _totalFeesOnSell;
751         } else {
752             _totalFees = walletToWalletTransferFee;
753         }
754 
755         if (_totalFees > 0) {
756             uint256 fees = (amount * _totalFees) / 100;
757             amount = amount - fees;
758             super._transfer(from, address(this), fees);
759         }
760 
761         super._transfer(from, to, amount);
762     }
763 
764     function setSwapEnabled(bool _enabled) external onlyOwner{
765         require(swapEnabled != _enabled, "swapEnabled already at this state.");
766         swapEnabled = _enabled;
767     }
768 
769     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
770         require(newAmount > totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
771         swapTokensAtAmount = newAmount;
772 
773         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
774     }
775 
776     function swapAndLiquify(uint256 tokens) private {
777         uint256 half = tokens / 2;
778         uint256 otherHalf = tokens - half;
779 
780         uint256 initialBalance = address(this).balance;
781 
782         address[] memory path = new address[](2);
783         path[0] = address(this);
784         path[1] = uniswapV2Router.WETH();
785 
786         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
787             half,
788             0,
789             path,
790             address(this),
791             block.timestamp);
792         
793         uint256 newBalance = address(this).balance - initialBalance;
794 
795         uniswapV2Router.addLiquidityETH{value: newBalance}(
796             address(this),
797             otherHalf,
798             0,
799             0,
800             address(0xdead),
801             block.timestamp
802         );
803 
804         emit SwapAndLiquify(half, newBalance, otherHalf);
805     }
806 
807     function swapAndSendMarketing(uint256 tokenAmount) private {
808         uint256 initialBalance = address(this).balance;
809 
810         address[] memory path = new address[](2);
811         path[0] = address(this);
812         path[1] = uniswapV2Router.WETH();
813 
814         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
815             tokenAmount,
816             0,
817             path,
818             address(this),
819             block.timestamp);
820 
821         uint256 newBalance = address(this).balance - initialBalance;
822 
823         payable(marketingWallet).sendValue(newBalance / 2);
824         payable(marketingWalletTwo).sendValue(address(this).balance - initialBalance);
825 
826         emit SwapAndSendMarketing(tokenAmount, newBalance);
827     }
828 
829     mapping(address => bool) private _isExcludedFromMaxTxLimit;
830     bool    public  maxTransactionLimitEnabled;
831     uint256 public  maxTransactionAmountBuy;
832     uint256 public  maxTransactionAmountSell;
833 
834     event ExcludedFromMaxTransactionLimit(address indexed account, bool isExcluded);
835     event MaxTransactionLimitStateChanged(bool maxTransactionLimit);
836     event MaxTransactionLimitAmountChanged(uint256 maxTransactionAmountBuy, uint256 maxTransactionAmountSell);
837 
838     function setEnableMaxTransactionLimit(bool enable) external onlyOwner {
839         require(enable != maxTransactionLimitEnabled, "Max transaction limit is already set to that state");
840         maxTransactionLimitEnabled = enable;
841 
842         emit MaxTransactionLimitStateChanged(maxTransactionLimitEnabled);
843     }
844 
845     function setMaxTransactionAmounts(uint256 _maxTransactionAmountBuy, uint256 _maxTransactionAmountSell) external onlyOwner {
846         require(
847             _maxTransactionAmountBuy  >= (totalSupply() / (10 ** decimals())) / 1_000 && 
848             _maxTransactionAmountSell >= (totalSupply() / (10 ** decimals())) / 1_000, 
849             "Max Transaction limis cannot be lower than 0.1% of total supply"
850         ); 
851         maxTransactionAmountBuy  = _maxTransactionAmountBuy  * (10 ** decimals());
852         maxTransactionAmountSell = _maxTransactionAmountSell * (10 ** decimals());
853 
854         emit MaxTransactionLimitAmountChanged(maxTransactionAmountBuy, maxTransactionAmountSell);
855     }
856 
857     function excludeFromMaxTransactionLimit(address account, bool exclude) external onlyOwner {
858         require( _isExcludedFromMaxTxLimit[account] != exclude, "Account is already set to that state");
859         require(account != address(this), "Can't set this address.");
860 
861         _isExcludedFromMaxTxLimit[account] = exclude;
862 
863         emit ExcludedFromMaxTransactionLimit(account, exclude);
864     }
865 
866     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
867         return _isExcludedFromMaxTxLimit[account];
868     }
869 }