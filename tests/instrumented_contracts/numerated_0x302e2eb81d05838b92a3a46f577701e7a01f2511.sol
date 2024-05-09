1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.18;
3 
4 abstract contract Context {
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68         return c;
69     }
70 
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         return mod(a, b, "SafeMath: modulo by zero");
73     }
74 
75     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b != 0, errorMessage);
77         return a % b;
78     }
79 }
80 
81 library Address {
82 
83     function isContract(address account) internal view returns (bool) {
84         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
85         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
86         // for accounts without code, i.e. `keccak256('')`
87         bytes32 codehash;
88         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
89         // solhint-disable-next-line no-inline-assembly
90         assembly { codehash := extcodehash(account) }
91         return (codehash != accountHash && codehash != 0x0);
92     }
93 
94     function sendValue(address payable recipient, uint256 amount) internal {
95         require(address(this).balance >= amount, "Address: insufficient balance");
96 
97         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
98         (bool success, ) = recipient.call{ value: amount }("");
99         require(success, "Address: unable to send value, recipient may have reverted");
100     }
101 
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103       return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
107         return _functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
123         if (success) {
124             return returndata;
125         } else {
126             
127             if (returndata.length > 0) {
128                 assembly {
129                     let returndata_size := mload(returndata)
130                     revert(add(32, returndata), returndata_size)
131                 }
132             } else {
133                 revert(errorMessage);
134             }
135         }
136     }
137 }
138 
139 contract Ownable is Context {
140     address private _owner;
141     address private _previousOwner;
142     uint256 private _lockTime;
143 
144     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
145 
146     constructor () {
147         address msgSender = _msgSender();
148         _owner = msgSender;
149         emit OwnershipTransferred(address(0), msgSender);
150     }
151 
152     function owner() public view returns (address) {
153         return _owner;
154     }   
155     
156     modifier onlyOwner() {
157         require(_owner == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160     
161     function waiveOwnership() public virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 
172     function getUnlockTime() public view returns (uint256) {
173         return _lockTime;
174     }
175     
176     function getTime() public view returns (uint256) {
177         return block.timestamp;
178     }
179 
180     function lock(uint256 time) public virtual onlyOwner {
181         _previousOwner = _owner;
182         _owner = address(0);
183         _lockTime = block.timestamp + time;
184         emit OwnershipTransferred(_owner, address(0));
185     }
186     
187     function unlock() public virtual {
188         require(_previousOwner == msg.sender, "You don't have permission to unlock");
189         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
190         emit OwnershipTransferred(_owner, _previousOwner);
191         _owner = _previousOwner;
192     }
193 }
194 
195 interface IUniswapV2Factory {
196     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
197 
198     function feeTo() external view returns (address);
199     function feeToSetter() external view returns (address);
200 
201     function getPair(address tokenA, address tokenB) external view returns (address pair);
202     function allPairs(uint) external view returns (address pair);
203     function allPairsLength() external view returns (uint);
204 
205     function createPair(address tokenA, address tokenB) external returns (address pair);
206 
207     function setFeeTo(address) external;
208     function setFeeToSetter(address) external;
209 }
210 
211 interface IUniswapV2Pair {
212     event Approval(address indexed owner, address indexed spender, uint value);
213     event Transfer(address indexed from, address indexed to, uint value);
214 
215     function name() external pure returns (string memory);
216     function symbol() external pure returns (string memory);
217     function decimals() external pure returns (uint8);
218     function totalSupply() external view returns (uint);
219     function balanceOf(address owner) external view returns (uint);
220     function allowance(address owner, address spender) external view returns (uint);
221 
222     function approve(address spender, uint value) external returns (bool);
223     function transfer(address to, uint value) external returns (bool);
224     function transferFrom(address from, address to, uint value) external returns (bool);
225 
226     function DOMAIN_SEPARATOR() external view returns (bytes32);
227     function PERMIT_TYPEHASH() external pure returns (bytes32);
228     function nonces(address owner) external view returns (uint);
229 
230     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
231     
232     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
233     event Swap(
234         address indexed sender,
235         uint amount0In,
236         uint amount1In,
237         uint amount0Out,
238         uint amount1Out,
239         address indexed to
240     );
241     event Sync(uint112 reserve0, uint112 reserve1);
242 
243     function MINIMUM_LIQUIDITY() external pure returns (uint);
244     function factory() external view returns (address);
245     function token0() external view returns (address);
246     function token1() external view returns (address);
247     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
248     function price0CumulativeLast() external view returns (uint);
249     function price1CumulativeLast() external view returns (uint);
250     function kLast() external view returns (uint);
251 
252     function burn(address to) external returns (uint amount0, uint amount1);
253     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
254     function skim(address to) external;
255     function sync() external;
256 
257     function initialize(address, address) external;
258 }
259 
260 interface IUniswapV2Router01 {
261     function factory() external pure returns (address);
262     function WETH() external pure returns (address);
263 
264     function addLiquidity(
265         address tokenA,
266         address tokenB,
267         uint amountADesired,
268         uint amountBDesired,
269         uint amountAMin,
270         uint amountBMin,
271         address to,
272         uint deadline
273     ) external returns (uint amountA, uint amountB, uint liquidity);
274     function addLiquidityETH(
275         address token,
276         uint amountTokenDesired,
277         uint amountTokenMin,
278         uint amountETHMin,
279         address to,
280         uint deadline
281     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
282     function removeLiquidity(
283         address tokenA,
284         address tokenB,
285         uint liquidity,
286         uint amountAMin,
287         uint amountBMin,
288         address to,
289         uint deadline
290     ) external returns (uint amountA, uint amountB);
291     function removeLiquidityETH(
292         address token,
293         uint liquidity,
294         uint amountTokenMin,
295         uint amountETHMin,
296         address to,
297         uint deadline
298     ) external returns (uint amountToken, uint amountETH);
299     function removeLiquidityWithPermit(
300         address tokenA,
301         address tokenB,
302         uint liquidity,
303         uint amountAMin,
304         uint amountBMin,
305         address to,
306         uint deadline,
307         bool approveMax, uint8 v, bytes32 r, bytes32 s
308     ) external returns (uint amountA, uint amountB);
309     function removeLiquidityETHWithPermit(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline,
316         bool approveMax, uint8 v, bytes32 r, bytes32 s
317     ) external returns (uint amountToken, uint amountETH);
318     function swapExactTokensForTokens(
319         uint amountIn,
320         uint amountOutMin,
321         address[] calldata path,
322         address to,
323         uint deadline
324     ) external returns (uint[] memory amounts);
325     function swapTokensForExactTokens(
326         uint amountOut,
327         uint amountInMax,
328         address[] calldata path,
329         address to,
330         uint deadline
331     ) external returns (uint[] memory amounts);
332     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
333         external
334         payable
335         returns (uint[] memory amounts);
336     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
337         external
338         returns (uint[] memory amounts);
339     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
340         external
341         returns (uint[] memory amounts);
342     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
343         external
344         payable
345         returns (uint[] memory amounts);
346 
347     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
348     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
349     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
350     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
351     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
352 }
353 
354 interface IUniswapV2Router02 is IUniswapV2Router01 {
355     function removeLiquidityETHSupportingFeeOnTransferTokens(
356         address token,
357         uint liquidity,
358         uint amountTokenMin,
359         uint amountETHMin,
360         address to,
361         uint deadline
362     ) external returns (uint amountETH);
363     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
364         address token,
365         uint liquidity,
366         uint amountTokenMin,
367         uint amountETHMin,
368         address to,
369         uint deadline,
370         bool approveMax, uint8 v, bytes32 r, bytes32 s
371     ) external returns (uint amountETH);
372 
373     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
374         uint amountIn,
375         uint amountOutMin,
376         address[] calldata path,
377         address to,
378         uint deadline
379     ) external;
380     function swapExactETHForTokensSupportingFeeOnTransferTokens(
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external payable;
386     function swapExactTokensForETHSupportingFeeOnTransferTokens(
387         uint amountIn,
388         uint amountOutMin,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external;
393 }
394 
395 contract FURecosystem is Context, IERC20, Ownable {
396     
397     using SafeMath for uint256;
398     using Address for address;
399     
400     string private _name = "FUR";
401     string private _symbol = "FUR";
402     uint8 private _decimals = 9;
403 
404     address payable public marketingWalletAddress = payable(0x244d7eE82d5969817fD9fEAE9EB5B6006fe58aEC); // Marketing Address  4%
405     address payable public developmentWalletAddress = payable(0xd711347C87ec0eE4d53b6bCBD89db8b10DFb6855); // Utility development Address 1%
406     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
407     
408     mapping (address => uint256) _balances;
409     mapping (address => mapping (address => uint256)) private _allowances;
410     
411     mapping (address => bool) public isExcludedFromFee;
412     mapping (address => bool) public isWalletLimitExempt;
413     mapping (address => bool) public isTxLimitExempt;
414     mapping (address => bool) public isMarketPair;
415 
416     uint256 public _buyLiquidityFee = 0;
417     uint256 public _buyMarketingFee = 4;
418     uint256 public _buyDevelopmentFee = 1;
419     uint256 public _sellLiquidityFee = 0;
420     uint256 public _sellMarketingFee = 4;
421     uint256 public _sellDevelopmentFee = 1;
422 
423     uint256 public _liquidityShare = 0;
424     uint256 public _marketingShare = 8;
425     uint256 public _developmentShare = 2;
426 
427     uint256 public _totalTaxIfBuying = 5;
428     uint256 public _totalTaxIfSelling = 5;
429     uint256 public _totalDistributionShares = 10;
430 
431     uint256 private _totalSupply = 1000 * 10**6 * 10**9;
432     uint256 public _maxTxAmount = 1000 * 10**6 * 10**9;
433     uint256 public _walletMax = 1000 * 10**6 * 10**9;
434     uint256 private minimumTokensBeforeSwap = 250000 * 10**9; 
435 
436     IUniswapV2Router02 public uniswapV2Router;
437     address public uniswapPair;
438     
439     bool inSwapAndLiquify;
440     bool public swapAndLiquifyEnabled = true;
441     bool public swapAndLiquifyByLimitOnly = false;
442     bool public checkWalletLimit = true;
443 
444     event SwapAndLiquifyEnabledUpdated(bool enabled);
445     event SwapAndLiquify(
446         uint256 tokensSwapped,
447         uint256 ethReceived,
448         uint256 tokensIntoLiqudity
449     );
450     
451     event SwapETHForTokens(
452         uint256 amountIn,
453         address[] path
454     );
455     
456     event SwapTokensForETH(
457         uint256 amountIn,
458         address[] path
459     );
460     
461     modifier lockTheSwap {
462         inSwapAndLiquify = true;
463         _;
464         inSwapAndLiquify = false;
465     }
466     
467     constructor () {
468         
469         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
470 
471         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
472             .createPair(address(this), _uniswapV2Router.WETH());
473 
474         uniswapV2Router = _uniswapV2Router;
475         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
476 
477         isExcludedFromFee[owner()] = true;
478         isExcludedFromFee[address(this)] = true;
479         
480         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevelopmentFee);
481         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevelopmentFee);
482         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_developmentShare);
483 
484         isWalletLimitExempt[owner()] = true;
485         isWalletLimitExempt[address(uniswapPair)] = true;
486         isWalletLimitExempt[address(this)] = true;
487         
488         isTxLimitExempt[owner()] = true;
489         isTxLimitExempt[address(this)] = true;
490 
491         isMarketPair[address(uniswapPair)] = true;
492 
493         _balances[_msgSender()] = _totalSupply;
494         emit Transfer(address(0), _msgSender(), _totalSupply);
495     }
496 
497     function name() public view returns (string memory) {
498         return _name;
499     }
500 
501     function symbol() public view returns (string memory) {
502         return _symbol;
503     }
504 
505     function decimals() public view returns (uint8) {
506         return _decimals;
507     }
508 
509     function totalSupply() public view override returns (uint256) {
510         return _totalSupply;
511     }
512 
513     function balanceOf(address account) public view override returns (uint256) {
514         return _balances[account];
515     }
516 
517     function allowance(address owner, address spender) public view override returns (uint256) {
518         return _allowances[owner][spender];
519     }
520 
521     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
522         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
523         return true;
524     }
525 
526     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
527         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
528         return true;
529     }
530 
531     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
532         return minimumTokensBeforeSwap;
533     }
534 
535     function approve(address spender, uint256 amount) public override returns (bool) {
536         _approve(_msgSender(), spender, amount);
537         return true;
538     }
539 
540     function _approve(address owner, address spender, uint256 amount) private {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
549         isMarketPair[account] = newValue;
550     }
551 
552     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
553         isTxLimitExempt[holder] = exempt;
554     }
555     
556     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
557         isExcludedFromFee[account] = newValue;
558     }
559 
560     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
561         _buyLiquidityFee = newLiquidityTax;
562         _buyMarketingFee = newMarketingTax;
563         _buyDevelopmentFee = newDevelopmentTax;
564 
565         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyDevelopmentFee);
566         require(_totalTaxIfBuying <= 10, "Buy tax must be less than 10%");
567     }
568 
569     function setSellTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newDevelopmentTax) external onlyOwner() {
570         _sellLiquidityFee = newLiquidityTax;
571         _sellMarketingFee = newMarketingTax;
572         _sellDevelopmentFee = newDevelopmentTax;
573 
574         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellDevelopmentFee);
575         require(_totalTaxIfSelling <= 10, "Sell tax must be less than 10%");
576     }
577     
578     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newDevelopmentShare) external onlyOwner() {
579         _liquidityShare = newLiquidityShare;
580         _marketingShare = newMarketingShare;
581         _developmentShare = newDevelopmentShare;
582 
583         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_developmentShare);
584         require(_totalDistributionShares <=20, "Distribution Shares must be less than 20%");
585     }
586     
587     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
588         require(maxTxAmount >= _totalSupply / 1000, "Cannot set MaxTxAmount lower than 0.1%");
589         _maxTxAmount = maxTxAmount;
590     }
591 
592     function enableDisableWalletLimit(bool newValue) external onlyOwner {
593        checkWalletLimit = newValue;
594     }
595 
596     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
597         isWalletLimitExempt[holder] = exempt;
598     }
599 
600     function setWalletLimit(uint256 newLimit) external onlyOwner {
601         require(newLimit >= _totalSupply / 1000, "Cannot set MaxWallet lower than 0.1%");
602         _walletMax  = newLimit;
603     }
604 
605     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
606         require(newLimit > 1, "NumTokensBeforeSwap should be not 0");
607         minimumTokensBeforeSwap = newLimit;
608     }
609 
610     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
611         marketingWalletAddress = payable(newAddress);
612     }
613 
614     function setDevelopmentWalletAddress(address newAddress) external onlyOwner() {
615         developmentWalletAddress = payable(newAddress);
616     }
617 
618     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
619         swapAndLiquifyEnabled = _enabled;
620         emit SwapAndLiquifyEnabledUpdated(_enabled);
621     }
622 
623     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
624         swapAndLiquifyByLimitOnly = newValue;
625     }
626     
627     function getCirculatingSupply() public view returns (uint256) {
628         return _totalSupply.sub(balanceOf(deadAddress));
629     }
630 
631     function transferToAddressETH(address payable recipient, uint256 amount) private {
632         recipient.transfer(amount);
633     }
634 
635      //to recieve ETH from uniswapV2Router when swaping
636     receive() external payable {}
637 
638     function transfer(address recipient, uint256 amount) public override returns (bool) {
639         _transfer(_msgSender(), recipient, amount);
640         return true;
641     }
642 
643     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
644         _transfer(sender, recipient, amount);
645         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
646         return true;
647     }
648 
649     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
650 
651         require(sender != address(0), "ERC20: transfer from the zero address");
652         require(recipient != address(0), "ERC20: transfer to the zero address");
653 
654         if(inSwapAndLiquify)
655         { 
656             return _basicTransfer(sender, recipient, amount); 
657         }
658         else
659         {
660             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
661                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
662             }            
663 
664             uint256 contractTokenBalance = balanceOf(address(this));
665             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
666             
667             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
668             {
669                 if(swapAndLiquifyByLimitOnly)
670                     contractTokenBalance = minimumTokensBeforeSwap;
671                 swapAndLiquify(contractTokenBalance);    
672             }
673 
674             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
675 
676             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
677                                          amount : takeFee(sender, recipient, amount);
678 
679             if(checkWalletLimit && !isWalletLimitExempt[recipient])
680                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
681 
682             _balances[recipient] = _balances[recipient].add(finalAmount);
683 
684             emit Transfer(sender, recipient, finalAmount);
685             return true;
686         }
687     }
688 
689     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
690         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
691         _balances[recipient] = _balances[recipient].add(amount);
692         emit Transfer(sender, recipient, amount);
693         return true;
694     }
695 
696     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
697         
698         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
699         uint256 tokensForSwap = tAmount.sub(tokensForLP);
700 
701         swapTokensForEth(tokensForSwap);
702         uint256 amountReceived = address(this).balance;
703 
704         uint256 totalETHFee = _totalDistributionShares.sub(_liquidityShare.div(2));
705         
706         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShare).div(totalETHFee).div(2);
707         uint256 amountETHDevelopment = amountReceived.mul(_developmentShare).div(totalETHFee);
708         uint256 amountETHMarketing = amountReceived.sub(amountETHLiquidity).sub(amountETHDevelopment);
709 
710         if(amountETHMarketing > 0)
711             transferToAddressETH(marketingWalletAddress, amountETHMarketing);
712 
713         if(amountETHDevelopment > 0)
714             transferToAddressETH(developmentWalletAddress, amountETHDevelopment);
715 
716         if(amountETHLiquidity > 0 && tokensForLP > 0)
717             addLiquidity(tokensForLP, amountETHLiquidity);
718     }
719     
720     function swapTokensForEth(uint256 tokenAmount) private {
721         // generate the uniswap pair path of token -> weth
722         address[] memory path = new address[](2);
723         path[0] = address(this);
724         path[1] = uniswapV2Router.WETH();
725 
726         _approve(address(this), address(uniswapV2Router), tokenAmount);
727 
728         // make the swap
729         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
730             tokenAmount,
731             0, // accept any amount of ETH
732             path,
733             address(this), // The contract
734             block.timestamp
735         );
736         
737         emit SwapTokensForETH(tokenAmount, path);
738     }
739 
740     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
741         // approve token transfer to cover all possible scenarios
742         _approve(address(this), address(uniswapV2Router), tokenAmount);
743 
744         // add the liquidity
745         uniswapV2Router.addLiquidityETH{value: ethAmount}(
746             address(this),
747             tokenAmount,
748             0, // slippage is unavoidable
749             0, // slippage is unavoidable
750             owner(),
751             block.timestamp
752         );
753     }
754 
755     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
756         
757         uint256 feeAmount = 0;
758         
759         if(isMarketPair[sender]) {
760             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
761         }
762         else if(isMarketPair[recipient]) {
763             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
764         }
765         
766         if(feeAmount > 0) {
767             _balances[address(this)] = _balances[address(this)].add(feeAmount);
768             emit Transfer(sender, address(this), feeAmount);
769         }
770 
771         return amount.sub(feeAmount);
772     }
773     
774 }