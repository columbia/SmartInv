1 /**
2 https://twitter.com/shiba_x_erc
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.19;
8 
9 interface IUniswapV2Factory {
10     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
11 
12     function feeTo() external view returns (address);
13     function feeToSetter() external view returns (address);
14     function getPair(address tokenA, address tokenB) external view returns (address pair);
15     function allPairs(uint) external view returns (address pair);
16     function allPairsLength() external view returns (uint);
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20 }
21 
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25 
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32 
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36 
37     function DOMAIN_SEPARATOR() external view returns (bytes32);
38     function PERMIT_TYPEHASH() external pure returns (bytes32);
39     function nonces(address owner) external view returns (uint);
40 
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42 
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
45     event Swap(
46         address indexed sender,
47         uint amount0In,
48         uint amount1In,
49         uint amount0Out,
50         uint amount1Out,
51         address indexed to
52     );
53     event Sync(uint112 reserve0, uint112 reserve1);
54 
55     function MINIMUM_LIQUIDITY() external pure returns (uint);
56     function factory() external view returns (address);
57     function token0() external view returns (address);
58     function token1() external view returns (address);
59     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
60     function price0CumulativeLast() external view returns (uint);
61     function price1CumulativeLast() external view returns (uint);
62     function kLast() external view returns (uint);
63 
64     function mint(address to) external returns (uint liquidity);
65     function burn(address to) external returns (uint amount0, uint amount1);
66     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
67     function skim(address to) external;
68     function sync() external;
69 
70     function initialize(address, address) external;
71 }
72 
73 interface IUniswapV2Router01 {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76 
77     function addLiquidity(
78         address tokenA,
79         address tokenB,
80         uint amountADesired,
81         uint amountBDesired,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline
86     ) external returns (uint amountA, uint amountB, uint liquidity);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95     function removeLiquidity(
96         address tokenA,
97         address tokenB,
98         uint liquidity,
99         uint amountAMin,
100         uint amountBMin,
101         address to,
102         uint deadline
103     ) external returns (uint amountA, uint amountB);
104     function removeLiquidityETH(
105         address token,
106         uint liquidity,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountToken, uint amountETH);
112     function removeLiquidityWithPermit(
113         address tokenA,
114         address tokenB,
115         uint liquidity,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountA, uint amountB);
122     function removeLiquidityETHWithPermit(
123         address token,
124         uint liquidity,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline,
129         bool approveMax, uint8 v, bytes32 r, bytes32 s
130     ) external returns (uint amountToken, uint amountETH);
131     function swapExactTokensForTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external returns (uint[] memory amounts);
138     function swapTokensForExactTokens(
139         uint amountOut,
140         uint amountInMax,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external returns (uint[] memory amounts);
145     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
146         external
147         payable
148         returns (uint[] memory amounts);
149     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
150         external
151         returns (uint[] memory amounts);
152     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
153         external
154         returns (uint[] memory amounts);
155     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
156         external
157         payable
158         returns (uint[] memory amounts);
159 
160     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
161     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
162     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
163     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
164     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
165 }
166 
167 interface IUniswapV2Router02 is IUniswapV2Router01 {
168     function removeLiquidityETHSupportingFeeOnTransferTokens(
169         address token,
170         uint liquidity,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline
175     ) external returns (uint amountETH);
176     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
177         address token,
178         uint liquidity,
179         uint amountTokenMin,
180         uint amountETHMin,
181         address to,
182         uint deadline,
183         bool approveMax, uint8 v, bytes32 r, bytes32 s
184     ) external returns (uint amountETH);
185 
186     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
187         uint amountIn,
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external;
193     function swapExactETHForTokensSupportingFeeOnTransferTokens(
194         uint amountOutMin,
195         address[] calldata path,
196         address to,
197         uint deadline
198     ) external payable;
199     function swapExactTokensForETHSupportingFeeOnTransferTokens(
200         uint amountIn,
201         uint amountOutMin,
202         address[] calldata path,
203         address to,
204         uint deadline
205     ) external;
206 }
207 
208 interface IERC20 {
209     function totalSupply() external view returns (uint256);
210     function balanceOf(address account) external view returns (uint256);
211     function transfer(address recipient, uint256 amount) external returns (bool);
212     function allowance(address owner, address spender) external view returns (uint256);
213     function approve(address spender, uint256 amount) external returns (bool);
214     function transferFrom(
215         address sender,
216         address recipient,
217         uint256 amount
218     ) external returns (bool);
219    
220     event Transfer(address indexed from, address indexed to, uint256 value);
221     event Approval(address indexed owner, address indexed spender, uint256 value);
222 }
223 
224 interface IERC20Metadata is IERC20 {
225     function name() external view returns (string memory);
226     function symbol() external view returns (string memory);
227     function decimals() external view returns (uint8);
228 }
229 
230 library Address {
231     function isContract(address account) internal view returns (bool) {
232         return account.code.length > 0;
233     }
234 
235     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         return success;
240     }
241 
242     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
244     }
245 
246     function functionCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, 0, errorMessage);
252     }
253 
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
260     }
261 
262     function functionCallWithValue(
263         address target,
264         bytes memory data,
265         uint256 value,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(address(this).balance >= value, "Address: insufficient balance for call");
269         (bool success, bytes memory returndata) = target.call{value: value}(data);
270         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
271     }
272 
273     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
274         return functionStaticCall(target, data, "Address: low-level static call failed");
275     }
276 
277     function functionStaticCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal view returns (bytes memory) {
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
284     }
285 
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     function functionDelegateCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal returns (bytes memory) {
295         (bool success, bytes memory returndata) = target.delegatecall(data);
296         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
297     }
298 
299     function verifyCallResultFromTarget(
300         address target,
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal view returns (bytes memory) {
305         if (success) {
306             if (returndata.length == 0) {
307                 // only check isContract if the call was successful and the return data is empty
308                 // otherwise we already know that it was a contract
309                 require(isContract(target), "Address: call to non-contract");
310             }
311             return returndata;
312         } else {
313             _revert(returndata, errorMessage);
314         }
315     }
316 
317     function verifyCallResult(
318         bool success,
319         bytes memory returndata,
320         string memory errorMessage
321     ) internal pure returns (bytes memory) {
322         if (success) {
323             return returndata;
324         } else {
325             _revert(returndata, errorMessage);
326         }
327     }
328 
329     function _revert(bytes memory returndata, string memory errorMessage) private pure {
330         // Look for revert reason and bubble it up if present
331         if (returndata.length > 0) {
332             // The easiest way to bubble the revert reason is using memory via assembly
333             /// @solidity memory-safe-assembly
334             assembly {
335                 let returndata_size := mload(returndata)
336                 revert(add(32, returndata), returndata_size)
337             }
338         } else {
339             revert(errorMessage);
340         }
341     }
342 }
343 
344 abstract contract Context {
345     function _msgSender() internal view virtual returns (address) {
346         return msg.sender;
347     }
348 
349     function _msgData() internal view virtual returns (bytes calldata) {
350         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
351         return msg.data;
352     }
353 }
354 
355 abstract contract Ownable is Context {
356     address private _owner;
357 
358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
359 
360     constructor () {
361         address msgSender = _msgSender();
362         _owner = msgSender;
363         emit OwnershipTransferred(address(0), msgSender);
364     }
365 
366     function owner() public view returns (address) {
367         return _owner;
368     }
369 
370     modifier onlyOwner() {
371         require(_owner == _msgSender(), "Ownable: caller is not the owner");
372         _;
373     }
374 
375     function renounceOwnership() public virtual onlyOwner {
376         emit OwnershipTransferred(_owner, address(0));
377         _owner = address(0);
378     }
379 
380     function transferOwnership(address newOwner) public virtual onlyOwner {
381         require(newOwner != address(0), "Ownable: new owner is the zero address");
382         emit OwnershipTransferred(_owner, newOwner);
383         _owner = newOwner;
384     }
385 }
386 
387 contract ERC20 is Context, IERC20, IERC20Metadata {
388     mapping(address => uint256) private _balances;
389 
390     mapping(address => mapping(address => uint256)) private _allowances;
391 
392     uint256 private _totalSupply;
393 
394     string private _name;
395     string private _symbol;
396 
397     constructor(string memory name_, string memory symbol_) {
398         _name = name_;
399         _symbol = symbol_;
400     }
401 
402     function name() public view virtual override returns (string memory) {
403         return _name;
404     }
405 
406     function symbol() public view virtual override returns (string memory) {
407         return _symbol;
408     }
409 
410     function decimals() public view virtual override returns (uint8) {
411         return 18;
412     }
413 
414     function totalSupply() public view virtual override returns (uint256) {
415         return _totalSupply;
416     }
417 
418     function balanceOf(address account) public view virtual override returns (uint256) {
419         return _balances[account];
420     }
421 
422     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
423         _transfer(_msgSender(), recipient, amount);
424         return true;
425     }
426 
427     function allowance(address owner, address spender) public view virtual override returns (uint256) {
428         return _allowances[owner][spender];
429     }
430 
431     function approve(address spender, uint256 amount) public virtual override returns (bool) {
432         _approve(_msgSender(), spender, amount);
433         return true;
434     }
435 
436     function transferFrom(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) public virtual override returns (bool) {
441         uint256 currentAllowance = _allowances[sender][_msgSender()];
442         if (currentAllowance != type(uint256).max) {
443             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
444             unchecked {
445                 _approve(sender, _msgSender(), currentAllowance - amount);
446             }
447         }
448 
449         _transfer(sender, recipient, amount);
450 
451         return true;
452     }
453 
454     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
456         return true;
457     }
458 
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         uint256 currentAllowance = _allowances[_msgSender()][spender];
461         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
462         unchecked {
463             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
464         }
465 
466         return true;
467     }
468 
469     function _transfer(
470         address sender,
471         address recipient,
472         uint256 amount
473     ) internal virtual {
474         require(sender != address(0), "ERC20: transfer from the zero address");
475         require(recipient != address(0), "ERC20: transfer to the zero address");
476 
477         _beforeTokenTransfer(sender, recipient, amount);
478 
479         uint256 senderBalance = _balances[sender];
480         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
481         unchecked {
482             _balances[sender] = senderBalance - amount;
483         }
484         _balances[recipient] += amount;
485 
486         emit Transfer(sender, recipient, amount);
487 
488         _afterTokenTransfer(sender, recipient, amount);
489     }
490 
491     function _mint(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: mint to the zero address");
493 
494         _beforeTokenTransfer(address(0), account, amount);
495 
496         _totalSupply += amount;
497         _balances[account] += amount;
498         emit Transfer(address(0), account, amount);
499 
500         _afterTokenTransfer(address(0), account, amount);
501     }
502 
503     function _burn(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: burn from the zero address");
505 
506         _beforeTokenTransfer(account, address(0), amount);
507 
508         uint256 accountBalance = _balances[account];
509         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
510         unchecked {
511             _balances[account] = accountBalance - amount;
512         }
513         _totalSupply -= amount;
514 
515         emit Transfer(account, address(0), amount);
516 
517         _afterTokenTransfer(account, address(0), amount);
518     }
519 
520     function _approve(
521         address owner,
522         address spender,
523         uint256 amount
524     ) internal virtual {
525         require(owner != address(0), "ERC20: approve from the zero address");
526         require(spender != address(0), "ERC20: approve to the zero address");
527 
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     function _beforeTokenTransfer(
533         address from,
534         address to,
535         uint256 amount
536     ) internal virtual {}
537 
538     function _afterTokenTransfer(
539         address from,
540         address to,
541         uint256 amount
542     ) internal virtual {}
543 }
544 
545 contract ShibaX is ERC20, Ownable {
546     using Address for address payable;
547 
548     IUniswapV2Router02 public uniswapV2Router;
549     address public  uniswapV2Pair;
550     mapping (address => bool) private _isExcludedFromFees;
551     mapping (address => uint256) private _buyBlock;  // Anti Sandwich bot!!
552 
553     uint256 public  marketingFeeOnBuy;
554     uint256 public  marketingFeeOnSell;
555     uint256 public  marketingFeeOnTransfer;
556     address public  marketingWallet;
557     uint256 public  swapTokensAtAmount;
558     bool    private swapping;
559     bool    public swapEnabled;
560 
561     event ExcludeFromFees(address indexed account, bool isExcluded);
562     event MarketingWalletChanged(address marketingWallet);
563     event UpdateFees(uint256 marketingFeeOnBuy, uint256 marketingFeeOnSell);
564     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
565     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
566 
567     constructor () ERC20(unicode"Shiba 𝕏", unicode"Shiba 𝕏") 
568     {   
569         address router;
570         if (block.chainid == 56) {
571             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
572         } else if (block.chainid == 97) {
573             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
574         } else if (block.chainid == 1 || block.chainid == 5) {
575             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
576         } else {
577             revert();
578         }
579 
580         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
581         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
582             .createPair(address(this), _uniswapV2Router.WETH());
583 
584         uniswapV2Router = _uniswapV2Router;
585         uniswapV2Pair   = _uniswapV2Pair;
586 
587         _approve(address(this), address(uniswapV2Router), type(uint256).max);
588         marketingFeeOnBuy  = 1;
589         marketingFeeOnSell = 3;
590         marketingFeeOnTransfer = 5;
591         marketingWallet = 0x404324e50517903BC1A84aaC69B8840f4efA8712;
592 
593         _isExcludedFromFees[owner()] = true;
594         _isExcludedFromFees[address(0xdead)] = true;
595         _isExcludedFromFees[address(this)] = true;
596         _isExcludedFromFees[marketingWallet] = true;
597 
598         _mint(owner(), 1000_000_000_000_000 * (10 ** decimals()));
599         swapTokensAtAmount = totalSupply() / 1000_000;
600 
601         tradingEnabled = false;
602         swapEnabled = false;
603     }
604 
605     receive() external payable {
606 
607   	}
608 
609     bool public tradingEnabled;
610 
611     function claimStuckTokens(address token) external onlyOwner {
612         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
613         if (token == address(0x0)) {
614             payable(msg.sender).sendValue(address(this).balance);
615             return;
616         }
617         IERC20 ERC20token = IERC20(token);
618         uint256 balance = ERC20token.balanceOf(address(this));
619         ERC20token.transfer(msg.sender, balance);
620     }
621 
622     function excludeFromFees(address account, bool excluded) external onlyOwner{
623         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
624         _isExcludedFromFees[account] = excluded;
625         emit ExcludeFromFees(account, excluded);
626     }
627 
628     function isExcludedFromFees(address account) public view returns(bool) {
629         return _isExcludedFromFees[account];
630     }
631 
632     function changeMarketingWallet(address _marketingWallet) external onlyOwner{
633         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
634         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
635         marketingWallet = _marketingWallet;
636 
637         emit MarketingWalletChanged(marketingWallet);
638     }
639 
640     function _transfer(address from,address to,uint256 amount) internal  override {
641         require(from != address(0), "ERC20: transfer from the zero address");
642         require(to != address(0), "ERC20: transfer to the zero address");
643         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
644         require(_buyBlock[from] != block.number, "Bad bot!");
645         _buyBlock[to] = block.number;
646        
647         if (amount == 0) {
648             super._transfer(from, to, 0);
649             return;
650         }
651 
652 		uint256 contractTokenBalance = balanceOf(address(this));
653 
654         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
655 
656         if (canSwap &&
657             !swapping &&
658             to == uniswapV2Pair &&
659             swapEnabled
660         ) {
661             swapping = true;
662 
663             swapAndSendMarketing(contractTokenBalance);     
664 
665             swapping = false;
666         }
667 
668         uint256 _totalFees;
669         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
670             _totalFees = 0;
671         } else if (from == uniswapV2Pair) {
672             _totalFees = marketingFeeOnBuy;
673         } else if (to == uniswapV2Pair) {
674             _totalFees =  marketingFeeOnSell;
675         } else {
676             _totalFees = marketingFeeOnTransfer;
677         }
678 
679         if (_totalFees > 0) {
680             uint256 fees = (amount * _totalFees) / 100;
681             amount = amount - fees;
682             super._transfer(from, address(this), fees);
683         }
684 
685 
686         super._transfer(from, to, amount);
687     }
688 
689     function enableTrading() external onlyOwner{
690         require(!tradingEnabled, "Trading already enabled.");  //The function can only be used once at launch
691         tradingEnabled = true;
692         swapEnabled = true;
693     }
694 
695     function setSwapEnabled(bool _enabled) external onlyOwner{
696         require(swapEnabled != _enabled, "swapEnabled already at this state.");
697         swapEnabled = _enabled;
698     }
699 
700     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
701         require(newAmount > totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
702         swapTokensAtAmount = newAmount;
703 
704         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
705     }
706 
707     function swapAndSendMarketing(uint256 tokenAmount) private {
708         uint256 initialBalance = address(this).balance;
709 
710         address[] memory path = new address[](2);
711         path[0] = address(this);
712         path[1] = uniswapV2Router.WETH();
713 
714         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
715             tokenAmount,
716             0,
717             path,
718             address(this),
719             block.timestamp);
720 
721         uint256 newBalance = address(this).balance - initialBalance;
722 
723         payable(marketingWallet).sendValue(newBalance);
724 
725         emit SwapAndSendMarketing(tokenAmount, newBalance);
726     }
727 }