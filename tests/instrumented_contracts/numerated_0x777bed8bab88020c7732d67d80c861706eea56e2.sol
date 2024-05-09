1 // SPDX-License-Identifier: MIT
2 
3 //Awaken
4 
5 
6 //TO 
7 
8 
9 //LET
10 
11 
12 //TREAT
13 
14 
15 //BURN
16 
17 
18 pragma solidity 0.8.17;
19 
20 interface IUniswapV2Factory {
21     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
22 
23     function feeTo() external view returns (address);
24     function feeToSetter() external view returns (address);
25     function getPair(address tokenA, address tokenB) external view returns (address pair);
26     function allPairs(uint) external view returns (address pair);
27     function allPairsLength() external view returns (uint);
28     function createPair(address tokenA, address tokenB) external returns (address pair);
29     function setFeeTo(address) external;
30     function setFeeToSetter(address) external;
31 }
32 
33 interface IUniswapV2Pair {
34     event Approval(address indexed owner, address indexed spender, uint value);
35     event Transfer(address indexed from, address indexed to, uint value);
36 
37     function name() external pure returns (string memory);
38     function symbol() external pure returns (string memory);
39     function decimals() external pure returns (uint8);
40     function totalSupply() external view returns (uint);
41     function balanceOf(address owner) external view returns (uint);
42     function allowance(address owner, address spender) external view returns (uint);
43 
44     function approve(address spender, uint value) external returns (bool);
45     function transfer(address to, uint value) external returns (bool);
46     function transferFrom(address from, address to, uint value) external returns (bool);
47 
48     function DOMAIN_SEPARATOR() external view returns (bytes32);
49     function PERMIT_TYPEHASH() external pure returns (bytes32);
50     function nonces(address owner) external view returns (uint);
51 
52     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
53 
54     event Mint(address indexed sender, uint amount0, uint amount1);
55     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
56     event Swap(
57         address indexed sender,
58         uint amount0In,
59         uint amount1In,
60         uint amount0Out,
61         uint amount1Out,
62         address indexed to
63     );
64     event Sync(uint112 reserve0, uint112 reserve1);
65 
66     function MINIMUM_LIQUIDITY() external pure returns (uint);
67     function factory() external view returns (address);
68     function token0() external view returns (address);
69     function token1() external view returns (address);
70     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
71     function price0CumulativeLast() external view returns (uint);
72     function price1CumulativeLast() external view returns (uint);
73     function kLast() external view returns (uint);
74 
75     function mint(address to) external returns (uint liquidity);
76     function burn(address to) external returns (uint amount0, uint amount1);
77     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
78     function skim(address to) external;
79     function sync() external;
80 
81     function initialize(address, address) external;
82 }
83 
84 interface IUniswapV2Router01 {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87 
88     function addLiquidity(
89         address tokenA,
90         address tokenB,
91         uint amountADesired,
92         uint amountBDesired,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline
97     ) external returns (uint amountA, uint amountB, uint liquidity);
98     function addLiquidityETH(
99         address token,
100         uint amountTokenDesired,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline
105     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
106     function removeLiquidity(
107         address tokenA,
108         address tokenB,
109         uint liquidity,
110         uint amountAMin,
111         uint amountBMin,
112         address to,
113         uint deadline
114     ) external returns (uint amountA, uint amountB);
115     function removeLiquidityETH(
116         address token,
117         uint liquidity,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external returns (uint amountToken, uint amountETH);
123     function removeLiquidityWithPermit(
124         address tokenA,
125         address tokenB,
126         uint liquidity,
127         uint amountAMin,
128         uint amountBMin,
129         address to,
130         uint deadline,
131         bool approveMax, uint8 v, bytes32 r, bytes32 s
132     ) external returns (uint amountA, uint amountB);
133     function removeLiquidityETHWithPermit(
134         address token,
135         uint liquidity,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline,
140         bool approveMax, uint8 v, bytes32 r, bytes32 s
141     ) external returns (uint amountToken, uint amountETH);
142     function swapExactTokensForTokens(
143         uint amountIn,
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external returns (uint[] memory amounts);
149     function swapTokensForExactTokens(
150         uint amountOut,
151         uint amountInMax,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external returns (uint[] memory amounts);
156     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
157         external
158         payable
159         returns (uint[] memory amounts);
160     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
161         external
162         returns (uint[] memory amounts);
163     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
164         external
165         returns (uint[] memory amounts);
166     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
167         external
168         payable
169         returns (uint[] memory amounts);
170 
171     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
172     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
173     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
174     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
175     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
176 }
177 
178 interface IUniswapV2Router02 is IUniswapV2Router01 {
179     function removeLiquidityETHSupportingFeeOnTransferTokens(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountETH);
187     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
188         address token,
189         uint liquidity,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline,
194         bool approveMax, uint8 v, bytes32 r, bytes32 s
195     ) external returns (uint amountETH);
196 
197     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
198         uint amountIn,
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external;
204     function swapExactETHForTokensSupportingFeeOnTransferTokens(
205         uint amountOutMin,
206         address[] calldata path,
207         address to,
208         uint deadline
209     ) external payable;
210     function swapExactTokensForETHSupportingFeeOnTransferTokens(
211         uint amountIn,
212         uint amountOutMin,
213         address[] calldata path,
214         address to,
215         uint deadline
216     ) external;
217 }
218 
219 interface IERC20 {
220     function totalSupply() external view returns (uint256);
221     function balanceOf(address account) external view returns (uint256);
222     function transfer(address recipient, uint256 amount) external returns (bool);
223     function allowance(address owner, address spender) external view returns (uint256);
224     function approve(address spender, uint256 amount) external returns (bool);
225     function transferFrom(
226         address sender,
227         address recipient,
228         uint256 amount
229     ) external returns (bool);
230    
231     event Transfer(address indexed from, address indexed to, uint256 value);
232     event Approval(address indexed owner, address indexed spender, uint256 value);
233 }
234 
235 interface IERC20Metadata is IERC20 {
236     function name() external view returns (string memory);
237     function symbol() external view returns (string memory);
238     function decimals() external view returns (uint8);
239 }
240 
241 library Address {
242     function isContract(address account) internal view returns (bool) {
243         return account.code.length > 0;
244     }
245 
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252 
253     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
255     }
256 
257     function functionCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, 0, errorMessage);
263     }
264 
265     function functionCallWithValue(
266         address target,
267         bytes memory data,
268         uint256 value
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
271     }
272 
273     function functionCallWithValue(
274         address target,
275         bytes memory data,
276         uint256 value,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(address(this).balance >= value, "Address: insufficient balance for call");
280         (bool success, bytes memory returndata) = target.call{value: value}(data);
281         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
282     }
283 
284     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
285         return functionStaticCall(target, data, "Address: low-level static call failed");
286     }
287 
288     function functionStaticCall(
289         address target,
290         bytes memory data,
291         string memory errorMessage
292     ) internal view returns (bytes memory) {
293         (bool success, bytes memory returndata) = target.staticcall(data);
294         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
295     }
296 
297     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
299     }
300 
301     function functionDelegateCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         (bool success, bytes memory returndata) = target.delegatecall(data);
307         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
308     }
309 
310     function verifyCallResultFromTarget(
311         address target,
312         bool success,
313         bytes memory returndata,
314         string memory errorMessage
315     ) internal view returns (bytes memory) {
316         if (success) {
317             if (returndata.length == 0) {
318                 // only check isContract if the call was successful and the return data is empty
319                 // otherwise we already know that it was a contract
320                 require(isContract(target), "Address: call to non-contract");
321             }
322             return returndata;
323         } else {
324             _revert(returndata, errorMessage);
325         }
326     }
327 
328     function verifyCallResult(
329         bool success,
330         bytes memory returndata,
331         string memory errorMessage
332     ) internal pure returns (bytes memory) {
333         if (success) {
334             return returndata;
335         } else {
336             _revert(returndata, errorMessage);
337         }
338     }
339 
340     function _revert(bytes memory returndata, string memory errorMessage) private pure {
341         // Look for revert reason and bubble it up if present
342         if (returndata.length > 0) {
343             // The easiest way to bubble the revert reason is using memory via assembly
344             /// @solidity memory-safe-assembly
345             assembly {
346                 let returndata_size := mload(returndata)
347                 revert(add(32, returndata), returndata_size)
348             }
349         } else {
350             revert(errorMessage);
351         }
352     }
353 }
354 
355 abstract contract Context {
356     function _msgSender() internal view virtual returns (address) {
357         return msg.sender;
358     }
359 
360     function _msgData() internal view virtual returns (bytes calldata) {
361         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
362         return msg.data;
363     }
364 }
365 
366 abstract contract Ownable is Context {
367     address private _owner;
368 
369     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
370 
371     constructor () {
372         address msgSender = _msgSender();
373         _owner = msgSender;
374         emit OwnershipTransferred(address(0), msgSender);
375     }
376 
377     function owner() public view returns (address) {
378         return _owner;
379     }
380 
381     modifier onlyOwner() {
382         require(_owner == _msgSender(), "Ownable: caller is not the owner");
383         _;
384     }
385 
386     function renounceOwnership() public virtual onlyOwner {
387         emit OwnershipTransferred(_owner, address(0));
388         _owner = address(0);
389     }
390 
391     function transferOwnership(address newOwner) public virtual onlyOwner {
392         require(newOwner != address(0), "Ownable: new owner is the zero address");
393         emit OwnershipTransferred(_owner, newOwner);
394         _owner = newOwner;
395     }
396 }
397 
398 contract ERC20 is Context, IERC20, IERC20Metadata {
399     mapping(address => uint256) private _balances;
400 
401     mapping(address => mapping(address => uint256)) private _allowances;
402 
403     uint256 private _totalSupply;
404 
405     string private _name;
406     string private _symbol;
407     string private _TREAT_CONTRACT_ADRESS;
408 
409     constructor(string memory name_, string memory symbol_) {
410         _name = name_;
411         _symbol = symbol_;
412     }
413 
414     function name() public view virtual override returns (string memory) {
415         return _name;
416     }
417 
418     function symbol() public view virtual override returns (string memory) {
419         return _symbol;
420     }
421 
422     function decimals() public view virtual override returns (uint8) {
423         return 18;
424     }
425 
426     function totalSupply() public view virtual override returns (uint256) {
427         return _totalSupply;
428     }
429 
430     function balanceOf(address account) public view virtual override returns (uint256) {
431         return _balances[account];
432     }
433 
434     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
435         _transfer(_msgSender(), recipient, amount);
436         return true;
437     }
438 
439     function allowance(address owner, address spender) public view virtual override returns (uint256) {
440         return _allowances[owner][spender];
441     }
442 
443     function approve(address spender, uint256 amount) public virtual override returns (bool) {
444         _approve(_msgSender(), spender, amount);
445         return true;
446     }
447 
448     function transferFrom(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) public virtual override returns (bool) {
453         uint256 currentAllowance = _allowances[sender][_msgSender()];
454         if (currentAllowance != type(uint256).max) {
455             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
456             unchecked {
457                 _approve(sender, _msgSender(), currentAllowance - amount);
458             }
459         }
460 
461         _transfer(sender, recipient, amount);
462 
463         return true;
464     }
465 
466     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
467         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
468         return true;
469     }
470 
471     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
472         uint256 currentAllowance = _allowances[_msgSender()][spender];
473         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
474         unchecked {
475             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
476         }
477 
478         return true;
479     }
480 
481     function _transfer(
482         address sender,
483         address recipient,
484         uint256 amount
485     ) internal virtual {
486         require(sender != address(0), "ERC20: transfer from the zero address");
487         require(recipient != address(0), "ERC20: transfer to the zero address");
488 
489         _beforeTokenTransfer(sender, recipient, amount);
490 
491         uint256 senderBalance = _balances[sender];
492         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
493         unchecked {
494             _balances[sender] = senderBalance - amount;
495         }
496         _balances[recipient] += amount;
497 
498         emit Transfer(sender, recipient, amount);
499 
500         _afterTokenTransfer(sender, recipient, amount);
501     }
502 
503     function _mint(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: mint to the zero address");
505 
506         _beforeTokenTransfer(address(0), account, amount);
507 
508         _totalSupply += amount;
509         _balances[account] += amount;
510         emit Transfer(address(0), account, amount);
511 
512         _afterTokenTransfer(address(0), account, amount);
513     }
514 
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         unchecked {
523             _balances[account] = accountBalance - amount;
524         }
525         _totalSupply -= amount;
526 
527         emit Transfer(account, address(0), amount);
528 
529         _afterTokenTransfer(account, address(0), amount);
530     }
531 
532     function _approve(
533         address owner,
534         address spender,
535         uint256 amount
536     ) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     function _beforeTokenTransfer(
545         address from,
546         address to,
547         uint256 amount
548     ) internal virtual {}
549 
550     function _afterTokenTransfer(
551         address from,
552         address to,
553         uint256 amount
554     ) internal virtual {}
555 }
556 
557 contract Awakening is ERC20, Ownable {
558     using Address for address payable;
559 
560     IUniswapV2Router02 public uniswapV2Router;
561     address public  uniswapV2Pair;
562 
563     mapping (address => bool) private _isExcludedFromFees;
564 
565     uint256 public  treatBurnFeeOnBuy;
566     uint256 public  treatBurnFeeOnSell;
567 
568     uint256 public  marketingFeeOnBuy;
569     uint256 public  marketingFeeOnSell;
570 
571     uint256 private _totalFeesOnBuy;
572     uint256 private _totalFeesOnSell;
573 
574     uint256 public  walletToWalletTransferFee;
575 
576     address public marketingWallet;
577     address public constant TREAT_CONTRACT_ADRESS =  0xFbD5fD3f85e9f4c5E8B40EEC9F8B8ab1cAAa146b;
578 
579     uint256 public  swapTokensAtAmount;
580     bool    private swapping;
581 
582     bool    public swapEnabled;
583 
584     event ExcludeFromFees(address indexed account, bool isExcluded);
585     event MarketingWalletChanged(address marketingWallet);
586     event UpdateBuyFees(uint256 boneBurnFeeOnBuy, uint256 marketingFeeOnBuy);
587     event UpdateSellFees(uint256 boneBurnFeeOnSell, uint256 marketingFeeOnSell);
588     event UpdateWalletToWalletTransferFee(uint256 walletToWalletTransferFee);
589     event SwapAndLiquify(uint256 tokensSwapped,uint256 bnbReceived,uint256 tokensIntoLiqudity);
590     event SwapAndSendETH(uint256 tokensSwapped, uint256 bnbSend);
591     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
592 
593     constructor () ERC20("Awakening", "WAKEUP") 
594     {   
595         address router;
596         if (block.chainid == 56) {
597             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
598         } else if (block.chainid == 97) {
599             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
600         } else if (block.chainid == 1 || block.chainid == 5) {
601             router = 0x03f7724180AA6b939894B5Ca4314783B0b36b329; // ETH Shibaswap Mainnet
602         } 
603         else {
604             revert();
605         }
606 
607        
608 
609         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
610         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
611             .createPair(address(this), _uniswapV2Router.WETH());
612 
613         uniswapV2Router = _uniswapV2Router;
614         uniswapV2Pair   = _uniswapV2Pair;
615 
616         _approve(address(this), address(uniswapV2Router), type(uint256).max);
617 
618         treatBurnFeeOnBuy  = 12;
619         treatBurnFeeOnSell = 25;
620 
621         marketingFeeOnBuy  = 13;
622         marketingFeeOnSell = 20;           
623 
624         _totalFeesOnBuy    = treatBurnFeeOnBuy  + marketingFeeOnBuy;
625         _totalFeesOnSell   = treatBurnFeeOnSell + marketingFeeOnSell;
626 
627         marketingWallet = 0x163140786a75f861e20Bfe0010F92d1521F001b3;
628 
629         maxWalletLimitEnabled = true;
630         maxTransactionLimitEnabled = true;
631 
632         _isExcludedFromMaxTxLimit[owner()] = true;
633         _isExcludedFromMaxTxLimit[address(this)] = true;
634         _isExcludedFromMaxTxLimit[address(0xdead)] = true;
635         _isExcludedFromMaxTxLimit[marketingWallet] = true;
636         
637         _isExcludedFromMaxWalletLimit[owner()] = true;
638         _isExcludedFromMaxWalletLimit[address(this)] = true;
639         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
640         _isExcludedFromMaxWalletLimit[marketingWallet] = true;
641 
642         _isExcludedFromFees[owner()] = true;
643         _isExcludedFromFees[address(0xdead)] = true;
644         _isExcludedFromFees[address(this)] = true;
645         _isExcludedFromFees[marketingWallet] = true;
646 
647         _mint(owner(), 1e9 * (10 ** decimals()));
648         swapTokensAtAmount = (totalSupply() * 75) / 10000; // 0.75% swap wallet
649 
650         maxTransactionAmountBuy     =  (totalSupply() * 100) / 10000; // 1%
651         maxTransactionAmountSell    =  (totalSupply() * 100) / 10000; // 1
652         maxWalletAmount             =  (totalSupply() * 100) / 10000; // 1%
653 
654         tradingEnabled = false;
655         swapEnabled = false;
656     }
657 
658     receive() external payable {
659 
660   	}
661 
662     function claimStuckTokens(address token) external onlyOwner {
663         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
664         if (token == address(0x0)) {
665             payable(msg.sender).sendValue(address(this).balance);
666             return;
667         }
668         IERC20 ERC20token = IERC20(token);
669         uint256 balance = ERC20token.balanceOf(address(this));
670         ERC20token.transfer(msg.sender, balance);
671     }
672 
673     function excludeFromFees(address account, bool excluded) external onlyOwner{
674         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
675         _isExcludedFromFees[account] = excluded;
676 
677         emit ExcludeFromFees(account, excluded);
678     }
679 
680     function isExcludedFromFees(address account) public view returns(bool) {
681         return _isExcludedFromFees[account];
682     }
683 
684     function changeFees(uint256 _treatBurnFeeOnBuy, uint256 _marketingFeeOnBuy, uint256 _treatBurnFeeOnSell, uint256 _marketingFeeOnSell) external onlyOwner {
685         //buy fees
686         treatBurnFeeOnBuy = _treatBurnFeeOnBuy;
687         marketingFeeOnBuy = _marketingFeeOnBuy;
688         _totalFeesOnBuy   = treatBurnFeeOnBuy + marketingFeeOnBuy;
689         //sell fees
690         treatBurnFeeOnSell = _treatBurnFeeOnSell;
691         marketingFeeOnSell = _marketingFeeOnSell;
692         _totalFeesOnSell   = treatBurnFeeOnSell + marketingFeeOnSell;
693 
694         require(_totalFeesOnBuy + _totalFeesOnSell <= 45, "Total Fees cannot exceed the maximum");
695         require(_totalFeesOnBuy + _totalFeesOnSell <= 45, "Total Fees cannot exceed the maximum");
696         emit UpdateBuyFees(treatBurnFeeOnBuy, marketingFeeOnBuy);
697         emit UpdateSellFees(treatBurnFeeOnSell, marketingFeeOnSell);
698     }
699 
700    
701 
702     function updateMarketingWallet(address _marketingWallet) external onlyOwner{
703         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
704         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
705         marketingWallet = _marketingWallet;
706 
707         emit MarketingWalletChanged(marketingWallet);
708     }
709 
710     bool public tradingEnabled;
711 
712     function enableTrading(bool wake, bool up, bool to, bool Reality) external onlyOwner{
713         require(!tradingEnabled, "Trading already enabled.");
714         
715         if(
716             wake == true &&
717             up == true &&
718             to == true &&
719             Reality == true
720         ){
721 
722             tradingEnabled = true;
723             swapEnabled = true;
724 
725         }
726        
727     }
728 
729 
730     function wakeUpToReality(bool wake, bool up, bool to, bool Reality) external onlyOwner{
731         require(!tradingEnabled, "Trading already enabled.");
732         
733         if(
734             wake == true &&
735             up == true &&
736             to == true &&
737             Reality == true
738         ){
739 
740             tradingEnabled = true;
741             swapEnabled = true;
742 
743         }
744        
745     }
746 
747 
748 
749     function _transfer(address from,address to,uint256 amount) internal  override {
750         require(from != address(0), "ERC20: transfer from the zero address");
751         require(to != address(0), "ERC20: transfer to the zero address");
752         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
753        
754         if (amount == 0) {
755             super._transfer(from, to, 0);
756             return;
757         }
758 
759         if (maxTransactionLimitEnabled) 
760         {
761             if ((from == uniswapV2Pair || to == uniswapV2Pair) &&
762                 !_isExcludedFromMaxTxLimit[from] && 
763                 !_isExcludedFromMaxTxLimit[to]
764             ) {
765                 if (from == uniswapV2Pair) {
766                     require(
767                         amount <= maxTransactionAmountBuy,  
768                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
769                     );
770                 } else {
771                     require(
772                         amount <= maxTransactionAmountSell, 
773                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
774                     );
775                 }
776             }
777         }
778 
779 		uint256 contractTokenBalance = balanceOf(address(this));
780 
781         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
782 
783         if (canSwap &&
784             !swapping &&
785             to == uniswapV2Pair &&
786             _totalFeesOnBuy + _totalFeesOnSell > 0 &&
787             swapEnabled
788         ) {
789             swapping = true;
790 
791             swapAndSendETH(swapTokensAtAmount);
792 
793             swapping = false;
794         }
795 
796         uint256 _totalFees;
797         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
798             _totalFees = 0;
799         } else if (from == uniswapV2Pair) {
800             _totalFees = _totalFeesOnBuy;
801         } else if (to == uniswapV2Pair) {
802             _totalFees = _totalFeesOnSell;
803         } else {
804             _totalFees = 0;
805         }
806 
807         if (_totalFees > 0) {
808             uint256 fees = (amount * _totalFees) / 100;
809             amount = amount - fees;
810             super._transfer(from, address(this), fees);
811         }
812 
813         if (maxWalletLimitEnabled) 
814         {
815             if (!_isExcludedFromMaxWalletLimit[from] && 
816                 !_isExcludedFromMaxWalletLimit[to] &&
817                 to != uniswapV2Pair
818             ) {
819                 uint256 balance  = balanceOf(to);
820                 require(
821                     balance + amount <= maxWalletAmount, 
822                     "MaxWallet: Recipient exceeds the maxWalletAmount"
823                 );
824             }
825         }
826 
827         super._transfer(from, to, amount);
828     }
829 
830     /////////////////////////////////////// SWAP SYSTEM
831 
832     function updateContractSell(bool _enabled) external onlyOwner{
833         
834         swapEnabled = _enabled;
835     }
836 
837     function changeSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
838        
839         swapTokensAtAmount = (totalSupply() * newAmount) / 10000; // 10 = 0.1%; 100 = 1%;
840 
841         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
842     }
843 
844     function swapAndSendETH(uint256 tokenAmount) private {
845         uint256 initialBalance = address(this).balance;
846 
847         address[] memory path = new address[](2);
848         path[0] = address(this);
849         path[1] = uniswapV2Router.WETH();
850 
851         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
852             tokenAmount,
853             0,
854             path,
855             address(this),
856             block.timestamp);
857 
858         uint256 newBalance = address(this).balance - initialBalance;
859         uint256 marketingBalance = newBalance * (marketingFeeOnBuy + marketingFeeOnSell) / (_totalFeesOnBuy + _totalFeesOnSell);
860         uint256 treatBalance = newBalance - marketingBalance;
861 
862         if (marketingBalance > 0){
863             payable(marketingWallet).sendValue(marketingBalance);
864         }
865 
866         if (treatBalance > 0){
867             address[] memory pathTwo = new address[](2);
868             pathTwo[0] = uniswapV2Router.WETH();
869             pathTwo[1] = address(0xFbD5fD3f85e9f4c5E8B40EEC9F8B8ab1cAAa146b);
870 
871             uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: treatBalance}( 
872                 0,
873                 pathTwo,
874                 address(0xdead),
875                 block.timestamp + 300
876             );
877         }
878 
879         emit SwapAndSendETH(tokenAmount, newBalance);
880     }
881 
882     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
883     bool    public maxWalletLimitEnabled;
884     uint256 public maxWalletAmount;
885 
886     event ExcludedFromMaxWalletLimit(address indexed account, bool isExcluded);
887     event MaxWalletLimitStateChanged(bool maxWalletLimit);
888     event MaxWalletLimitAmountChanged(uint256 maxWalletAmount);
889 
890     function setEnableMaxWalletLimit(bool enable) external onlyOwner {
891         require(enable != maxWalletLimitEnabled,"Max wallet limit is already set to that state");
892         maxWalletLimitEnabled = enable;
893 
894         emit MaxWalletLimitStateChanged(maxWalletLimitEnabled);
895     }
896 
897     
898     function excludeFromMaxWallet(address account, bool exclude) external onlyOwner {
899         require( _isExcludedFromMaxWalletLimit[account] != exclude,"Account is already set to that state");
900         _isExcludedFromMaxWalletLimit[account] = exclude;
901 
902         emit ExcludedFromMaxWalletLimit(account, exclude);
903     }
904 
905     function isExcludedFromMaxWalletLimit(address account) public view returns(bool) {
906         return _isExcludedFromMaxWalletLimit[account];
907     }
908 
909 
910     mapping(address => bool) private _isExcludedFromMaxTxLimit;
911     bool    public  maxTransactionLimitEnabled;
912     uint256 public  maxTransactionAmountBuy;
913     uint256 public  maxTransactionAmountSell;
914 
915     event ExcludedFromMaxTransactionLimit(address indexed account, bool isExcluded);
916     event MaxTransactionLimitStateChanged(bool maxTransactionLimit);
917     event MaxTransactionLimitAmountChanged(uint256 maxTransactionAmountBuy, uint256 maxTransactionAmountSell);
918 
919     function setEnableMaxTransactionLimit(bool enable) external onlyOwner {
920         require(enable != maxTransactionLimitEnabled, "Max transaction limit is already set to that state");
921         maxTransactionLimitEnabled = enable;
922 
923         emit MaxTransactionLimitStateChanged(maxTransactionLimitEnabled);
924     }
925 
926     function changeLimits(uint256 _maxTransactionAmountBuy, uint256 _maxTransactionAmountSell, uint256 _maxWalletAmount) external onlyOwner {
927         
928         
929         require(
930             _maxTransactionAmountBuy  >= (totalSupply() / (10 ** decimals())) / 1_000 && 
931             _maxTransactionAmountSell >= (totalSupply() / (10 ** decimals())) / 1_000, 
932             "Max Transaction limis cannot be lower than 0.1% of total supply"
933         ); 
934         maxTransactionAmountBuy  = _maxTransactionAmountBuy  * (10 ** decimals());
935         maxTransactionAmountSell = _maxTransactionAmountSell * (10 ** decimals());
936         
937         require(_maxWalletAmount >= (totalSupply() / (10 ** decimals())) / 100, "Max wallet percentage cannot be lower than 1%");
938         maxWalletAmount = _maxWalletAmount * (10 ** decimals());
939 
940         emit MaxWalletLimitAmountChanged(maxWalletAmount);
941         emit MaxTransactionLimitAmountChanged(maxTransactionAmountBuy, maxTransactionAmountSell);
942     }
943 
944     function excludeFromMaxTransactionLimit(address account, bool exclude) external onlyOwner {
945         require( _isExcludedFromMaxTxLimit[account] != exclude, "Account is already set to that state");
946         _isExcludedFromMaxTxLimit[account] = exclude;
947 
948         emit ExcludedFromMaxTransactionLimit(account, exclude);
949     }
950 
951     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
952         return _isExcludedFromMaxTxLimit[account];
953     }
954 }