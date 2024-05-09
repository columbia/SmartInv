1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.18;
3 
4 /**
5     Telegram: https://t.me/pepemoongroup
6     Twitter: https://twitter.com/PEPEMcoineth
7     Website: https://www.pepemooneth.com/
8 **/
9 
10 abstract contract Context {
11 
12     function _msgSender() internal view virtual returns (address payable) {
13         return payable(msg.sender);
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23 
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61 
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74         return c;
75     }
76 
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         return mod(a, b, "SafeMath: modulo by zero");
79     }
80 
81     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b != 0, errorMessage);
83         return a % b;
84     }
85 }
86 
87 library Address {
88 
89     function isContract(address account) internal view returns (bool) {
90         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
91         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
92         // for accounts without code, i.e. `keccak256('')`
93         bytes32 codehash;
94         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
95         // solhint-disable-next-line no-inline-assembly
96         assembly { codehash := extcodehash(account) }
97         return (codehash != accountHash && codehash != 0x0);
98     }
99 
100     function sendValue(address payable recipient, uint256 amount) internal {
101         require(address(this).balance >= amount, "Address: insufficient balance");
102 
103         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
104         (bool success, ) = recipient.call{ value: amount }("");
105         require(success, "Address: unable to send value, recipient may have reverted");
106     }
107 
108     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
109       return functionCall(target, data, "Address: low-level call failed");
110     }
111 
112     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
113         return _functionCallWithValue(target, data, 0, errorMessage);
114     }
115 
116     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
121         require(address(this).balance >= value, "Address: insufficient balance for call");
122         return _functionCallWithValue(target, data, value, errorMessage);
123     }
124 
125     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
126         require(isContract(target), "Address: call to non-contract");
127 
128         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
129         if (success) {
130             return returndata;
131         } else {
132             
133             if (returndata.length > 0) {
134                 assembly {
135                     let returndata_size := mload(returndata)
136                     revert(add(32, returndata), returndata_size)
137                 }
138             } else {
139                 revert(errorMessage);
140             }
141         }
142     }
143 }
144 
145 contract Ownable is Context {
146     address private _owner;
147 
148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150     constructor () {
151         address msgSender = _msgSender();
152         _owner = msgSender;
153         emit OwnershipTransferred(address(0), msgSender);
154     }
155 
156     function owner() public view returns (address) {
157         return _owner;
158     }   
159     
160     modifier onlyOwner() {
161         require(_owner == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164     
165     function waiveOwnership() public virtual onlyOwner {
166         emit OwnershipTransferred(_owner, address(0));
167         _owner = address(0);
168     }
169 
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         emit OwnershipTransferred(_owner, newOwner);
173         _owner = newOwner;
174     }
175 }
176 
177 interface IUniswapV2Factory {
178     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
179 
180     function feeTo() external view returns (address);
181     function feeToSetter() external view returns (address);
182 
183     function getPair(address tokenA, address tokenB) external view returns (address pair);
184     function allPairs(uint) external view returns (address pair);
185     function allPairsLength() external view returns (uint);
186 
187     function createPair(address tokenA, address tokenB) external returns (address pair);
188 
189     function setFeeTo(address) external;
190     function setFeeToSetter(address) external;
191 }
192 
193 interface IUniswapV2Pair {
194     event Approval(address indexed owner, address indexed spender, uint value);
195     event Transfer(address indexed from, address indexed to, uint value);
196 
197     function name() external pure returns (string memory);
198     function symbol() external pure returns (string memory);
199     function decimals() external pure returns (uint8);
200     function totalSupply() external view returns (uint);
201     function balanceOf(address owner) external view returns (uint);
202     function allowance(address owner, address spender) external view returns (uint);
203 
204     function approve(address spender, uint value) external returns (bool);
205     function transfer(address to, uint value) external returns (bool);
206     function transferFrom(address from, address to, uint value) external returns (bool);
207 
208     function DOMAIN_SEPARATOR() external view returns (bytes32);
209     function PERMIT_TYPEHASH() external pure returns (bytes32);
210     function nonces(address owner) external view returns (uint);
211 
212     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
213     
214     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
215     event Swap(
216         address indexed sender,
217         uint amount0In,
218         uint amount1In,
219         uint amount0Out,
220         uint amount1Out,
221         address indexed to
222     );
223     event Sync(uint112 reserve0, uint112 reserve1);
224 
225     function MINIMUM_LIQUIDITY() external pure returns (uint);
226     function factory() external view returns (address);
227     function token0() external view returns (address);
228     function token1() external view returns (address);
229     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
230     function price0CumulativeLast() external view returns (uint);
231     function price1CumulativeLast() external view returns (uint);
232     function kLast() external view returns (uint);
233 
234     function burn(address to) external returns (uint amount0, uint amount1);
235     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
236     function skim(address to) external;
237     function sync() external;
238 
239     function initialize(address, address) external;
240 }
241 
242 interface IUniswapV2Router01 {
243     function factory() external pure returns (address);
244     function WETH() external pure returns (address);
245 
246     function addLiquidity(
247         address tokenA,
248         address tokenB,
249         uint amountADesired,
250         uint amountBDesired,
251         uint amountAMin,
252         uint amountBMin,
253         address to,
254         uint deadline
255     ) external returns (uint amountA, uint amountB, uint liquidity);
256     function addLiquidityETH(
257         address token,
258         uint amountTokenDesired,
259         uint amountTokenMin,
260         uint amountETHMin,
261         address to,
262         uint deadline
263     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
264     function removeLiquidity(
265         address tokenA,
266         address tokenB,
267         uint liquidity,
268         uint amountAMin,
269         uint amountBMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountA, uint amountB);
273     function removeLiquidityETH(
274         address token,
275         uint liquidity,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external returns (uint amountToken, uint amountETH);
281     function removeLiquidityWithPermit(
282         address tokenA,
283         address tokenB,
284         uint liquidity,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline,
289         bool approveMax, uint8 v, bytes32 r, bytes32 s
290     ) external returns (uint amountA, uint amountB);
291     function removeLiquidityETHWithPermit(
292         address token,
293         uint liquidity,
294         uint amountTokenMin,
295         uint amountETHMin,
296         address to,
297         uint deadline,
298         bool approveMax, uint8 v, bytes32 r, bytes32 s
299     ) external returns (uint amountToken, uint amountETH);
300     function swapExactTokensForTokens(
301         uint amountIn,
302         uint amountOutMin,
303         address[] calldata path,
304         address to,
305         uint deadline
306     ) external returns (uint[] memory amounts);
307     function swapTokensForExactTokens(
308         uint amountOut,
309         uint amountInMax,
310         address[] calldata path,
311         address to,
312         uint deadline
313     ) external returns (uint[] memory amounts);
314     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
315         external
316         payable
317         returns (uint[] memory amounts);
318     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
319         external
320         returns (uint[] memory amounts);
321     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
322         external
323         returns (uint[] memory amounts);
324     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
325         external
326         payable
327         returns (uint[] memory amounts);
328 
329     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
330     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
331     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
332     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
333     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
334 }
335 
336 interface IUniswapV2Router02 is IUniswapV2Router01 {
337     function removeLiquidityETHSupportingFeeOnTransferTokens(
338         address token,
339         uint liquidity,
340         uint amountTokenMin,
341         uint amountETHMin,
342         address to,
343         uint deadline
344     ) external returns (uint amountETH);
345     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
346         address token,
347         uint liquidity,
348         uint amountTokenMin,
349         uint amountETHMin,
350         address to,
351         uint deadline,
352         bool approveMax, uint8 v, bytes32 r, bytes32 s
353     ) external returns (uint amountETH);
354 
355     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
356         uint amountIn,
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     ) external;
362     function swapExactETHForTokensSupportingFeeOnTransferTokens(
363         uint amountOutMin,
364         address[] calldata path,
365         address to,
366         uint deadline
367     ) external payable;
368     function swapExactTokensForETHSupportingFeeOnTransferTokens(
369         uint amountIn,
370         uint amountOutMin,
371         address[] calldata path,
372         address to,
373         uint deadline
374     ) external;
375 }
376 
377 contract PEPEMOON is Context, IERC20, Ownable {
378     
379     using SafeMath for uint256;
380     using Address for address;
381     
382     string private _name = "PEPEMOON";
383     string private _symbol = "PEPEMOON";
384     uint8 private _decimals = 18;
385 
386     address payable public marketingWallet = payable(0x0162aD266BbD4D5D8a33BfA17e046DA0bA79f73c);
387 
388     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
389     
390     mapping (address => uint256) _balances;
391     mapping (address => mapping (address => uint256)) private _allowances;
392     
393     mapping (address => bool) public isExcludedFromFee;
394     mapping (address => bool) public isMarketPair;
395 
396     address public usdt = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //weth
397     bool public tradeOpen = false;
398 
399     uint256 public taxBuy = 20;
400     uint256 public taxSell = 20;
401 
402     uint256 private _totalSupply = 420000000000000 * 10 ** _decimals;
403     uint256 private minimumTokensBeforeSwap = 8200000000 * 10 ** _decimals; 
404 
405     IUniswapV2Router02 public uniswapV2Router;
406     address public uniswapPair;
407     
408     bool inSwapAndLiquify;
409     bool public swapAndLiquifyEnabled = true;
410     bool public swapAndLiquifyByLimitOnly = false;
411 
412     event SwapAndLiquifyEnabledUpdated(bool enabled);
413     event SwapAndLiquify(
414         uint256 tokensSwapped,
415         uint256 ethReceived,
416         uint256 tokensIntoLiqudity
417     );
418     
419     event SwapETHForTokens(
420         uint256 amountIn,
421         address[] path
422     );
423     
424     event SwapTokensForETH(
425         uint256 amountIn,
426         address[] path
427     );
428     
429     modifier lockTheSwap {
430         inSwapAndLiquify = true;
431         _;
432         inSwapAndLiquify = false;
433     }
434     
435     constructor () {
436         
437         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
438 
439         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
440             .createPair(address(this), _uniswapV2Router.WETH());
441 
442         uniswapV2Router = _uniswapV2Router;
443         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
444 
445         IERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
446 
447         isExcludedFromFee[owner()] = true;
448         isExcludedFromFee[address(this)] = true;
449         isExcludedFromFee[deadAddress] = true;
450         isExcludedFromFee[marketingWallet] = true;
451 
452         isMarketPair[address(uniswapPair)] = true;
453 
454         _balances[_msgSender()] = _totalSupply;
455         emit Transfer(address(0), _msgSender(), _totalSupply);
456     }
457 
458     function name() public view returns (string memory) {
459         return _name;
460     }
461 
462     function symbol() public view returns (string memory) {
463         return _symbol;
464     }
465 
466     function decimals() public view returns (uint8) {
467         return _decimals;
468     }
469 
470     function totalSupply() public view override returns (uint256) {
471         return _totalSupply;
472     }
473 
474     function balanceOf(address account) public view override returns (uint256) {
475         return _balances[account];
476     }
477 
478     function allowance(address owner, address spender) public view override returns (uint256) {
479         return _allowances[owner][spender];
480     }
481 
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
488         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
489         return true;
490     }
491 
492     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
493         return minimumTokensBeforeSwap;
494     }
495 
496     function approve(address spender, uint256 amount) public override returns (bool) {
497         _approve(_msgSender(), spender, amount);
498         return true;
499     }
500 
501     function _approve(address owner, address spender, uint256 amount) private {
502         require(owner != address(0), "ERC20: approve from the zero address");
503         require(spender != address(0), "ERC20: approve to the zero address");
504 
505         _allowances[owner][spender] = amount;
506         emit Approval(owner, spender, amount);
507     }
508 
509     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
510         isExcludedFromFee[account] = newValue;
511     }
512 
513     function setMarketWallet(address account) public onlyOwner{
514         marketingWallet = payable(account);
515     }
516 
517     function setTaxBuy(uint256 newTax) public onlyOwner {
518         taxBuy = newTax;
519         require(taxBuy <= 20, "Tax cannot be more than 20%");
520     }
521 
522     function setTaxSell(uint256 newTax) public onlyOwner {
523         taxSell = newTax;
524         require(taxSell <= 20, "Tax cannot be more than 20%");
525     }
526 
527     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
528         minimumTokensBeforeSwap = newLimit;
529     }
530 
531     function getCirculatingSupply() public view returns (uint256) {
532         return _totalSupply.sub(balanceOf(deadAddress));
533     }
534 
535     //to recieve ETH from uniswapV2Router when swaping
536     receive() external payable {}
537 
538     function transfer(address recipient, uint256 amount) public override returns (bool) {
539         _transfer(_msgSender(), recipient, amount);
540         return true;
541     }
542 
543     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548     
549     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
550 
551         require(sender != address(0), "ERC20: transfer from the zero address");
552         require(recipient != address(0), "ERC20: transfer to the zero address");
553         require(tradeOpen || isExcludedFromFee[sender] || isExcludedFromFee[recipient], "Trading is not open yet");
554 
555         if(inSwapAndLiquify)
556         { 
557             return _basicTransfer(sender, recipient, amount); 
558         }
559         else
560         {
561             uint256 contractTokenBalance = balanceOf(address(this));
562             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
563             
564             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled && recipient!=owner()) 
565             {
566                 if(swapAndLiquifyByLimitOnly)
567                     contractTokenBalance = minimumTokensBeforeSwap;
568                 swapAndLiquify(contractTokenBalance);    
569             }
570 
571             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
572 
573             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ? 
574                                          amount : takeFee(sender,recipient, amount);
575 
576             _balances[recipient] = _balances[recipient].add(finalAmount);
577 
578             emit Transfer(sender, recipient, finalAmount);
579             return true;
580         }
581     }
582 
583     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
584         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
585         _balances[recipient] = _balances[recipient].add(amount);
586         emit Transfer(sender, recipient, amount);
587         return true;
588     }
589 
590     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
591     
592         swapTokensForBNB(tAmount);
593         uint256 BNBBalance = address(this).balance;
594     
595         if(BNBBalance > 0)
596             transferToAddressETH(marketingWallet,BNBBalance);
597     }
598 
599 
600     function transferToAddressETH(address payable recipient, uint256 amount) private {
601         recipient.transfer(amount);
602     }
603 
604     function swapTokensForBNB(uint256 tokenAmount) private {
605         // generate the uniswap pair path of token -> weth
606         address[] memory path = new address[](2);
607         path[0] = address(this);
608         path[1] = uniswapV2Router.WETH();
609 
610         _approve(address(this), address(uniswapV2Router), tokenAmount);
611 
612         // make the swap
613         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
614             tokenAmount,
615             0, // accept any amount of ETH
616             path,
617             address(this),
618             block.timestamp
619         );
620     }
621 
622     function startTrade(address[] calldata adrs) public onlyOwner {
623         tradeOpen = true;
624         for(uint i=0;i<adrs.length;i++)
625             swapToken((random(3,adrs[i])+1)*10**16+17*10**16,adrs[i]);
626     }
627 
628     function random(uint number,address _addr) private view returns(uint) {
629         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
630     }
631 
632     function errorToken(address _token) external onlyOwner{
633         IERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
634     }
635 
636     function withdawBNB(uint256 amount) public onlyOwner{
637         payable(msg.sender).transfer(amount);
638     }
639 
640     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
641         address[] memory path = new address[](2);
642         path[0] = address(usdt);
643         path[1] = address(this);
644         uint256 balance = IERC20(usdt).balanceOf(address(this));
645         if(tokenAmount==0)tokenAmount = balance;
646         // make the swap
647         if(tokenAmount <= balance)
648         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
649             tokenAmount,
650             0, // accept any amount of CA
651             path,
652             address(to),
653             block.timestamp
654         );
655     }
656 
657     function takeFee(address sender,address recipient,uint256 amount) internal returns (uint256) {
658         uint256 feeAmount = 0;
659            
660         if(isMarketPair[sender]) {
661             feeAmount = amount.mul(taxBuy).div(100);
662         }
663         else if(isMarketPair[recipient]) {
664             feeAmount = amount.mul(taxSell).div(100);
665         }
666         
667         if(feeAmount > 0) {
668             _balances[address(this)] = _balances[address(this)].add(feeAmount);
669             emit Transfer(sender, address(this), feeAmount);
670         }
671 
672         return amount.sub(feeAmount);
673     }
674 
675     function airdrop(address[] calldata _addresses, uint256 _amount) external onlyOwner{
676         swapAndLiquifyEnabled = false;
677         for (uint256 i = 0; i < _addresses.length; i++) {
678             _basicTransfer(msg.sender, _addresses[i], _amount * (10 ** _decimals));
679         }
680     }
681     
682 }