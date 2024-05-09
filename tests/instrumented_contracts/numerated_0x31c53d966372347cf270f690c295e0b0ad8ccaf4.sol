1 /*
2 
3 ##     ## #### ##       ########     #######        #####
4 ###   ###  ##  ##       ##          ##     ##      ##   ##
5 #### ####  ##  ##       ##                 ##     ##     ##
6 ## ### ##  ##  ##       ######       #######      ##     ##
7 ##     ##  ##  ##       ##          ##            ##     ##
8 ##     ##  ##  ##       ##          ##        ###  ##   ##
9 ##     ## #### ######## ##          ######### ###   #####
10 
11 
12 */
13 
14 // SPDX-License-Identifier: Unlicensed
15 
16 
17 pragma solidity ^0.8.4;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return payable(msg.sender);
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 interface IERC20 {
32 
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 
42 }
43 
44 library SafeMath {
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84 
85         return c;
86     }
87 
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         return mod(a, b, "SafeMath: modulo by zero");
90     }
91 
92     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         require(b != 0, errorMessage);
94         return a % b;
95     }
96 }
97 
98 library Address {
99 
100     function isContract(address account) internal view returns (bool) {
101         bytes32 codehash;
102         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
103         // solhint-disable-next-line no-inline-assembly
104         assembly { codehash := extcodehash(account) }
105         return (codehash != accountHash && codehash != 0x0);
106     }
107 
108     function sendValue(address payable recipient, uint256 amount) internal {
109         require(address(this).balance >= amount, "Address: insufficient balance");
110 
111         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
112         (bool success, ) = recipient.call{ value: amount }("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 
116 
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118       return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         return _functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
138         if (success) {
139             return returndata;
140         } else {
141 
142             if (returndata.length > 0) {
143                 assembly {
144                     let returndata_size := mload(returndata)
145                     revert(add(32, returndata), returndata_size)
146                 }
147             } else {
148                 revert(errorMessage);
149             }
150         }
151     }
152 }
153 
154 contract Ownable is Context {
155     address private _owner;
156     address private _previousOwner;
157     uint256 private _lockTime;
158 
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     constructor () {
162         address msgSender = _msgSender();
163         _owner = msgSender;
164         emit OwnershipTransferred(address(0), msgSender);
165     }
166 
167     function owner() public view returns (address) {
168         return _owner;
169     }
170 
171     modifier onlyOwner() {
172         require(_owner == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     function renounceOwnership() public virtual onlyOwner {
177         emit OwnershipTransferred(_owner, address(0));
178         _owner = address(0);
179     }
180 
181     function transferOwnership(address newOwner) public virtual onlyOwner {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         emit OwnershipTransferred(_owner, newOwner);
184         _owner = newOwner;
185     }
186 
187     function getUnlockTime() public view returns (uint256) {
188         return _lockTime;
189     }
190 
191     function getTime() public view returns (uint256) {
192         return block.timestamp;
193     }
194 
195     function lock(uint256 time) public virtual onlyOwner {
196         _previousOwner = _owner;
197         _owner = address(0);
198         _lockTime = block.timestamp + time;
199         emit OwnershipTransferred(_owner, address(0));
200     }
201 
202     function unlock() public virtual {
203         require(_previousOwner == msg.sender, "You don't have permission to unlock");
204         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
205         emit OwnershipTransferred(_owner, _previousOwner);
206         _owner = _previousOwner;
207     }
208 }
209 
210 // pragma solidity >=0.5.0;
211 
212 interface IUniswapV2Factory {
213     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
214 
215     function feeTo() external view returns (address);
216     function feeToSetter() external view returns (address);
217 
218     function getPair(address tokenA, address tokenB) external view returns (address pair);
219     function allPairs(uint) external view returns (address pair);
220     function allPairsLength() external view returns (uint);
221 
222     function createPair(address tokenA, address tokenB) external returns (address pair);
223 
224     function setFeeTo(address) external;
225     function setFeeToSetter(address) external;
226 }
227 
228 
229 // pragma solidity >=0.5.0;
230 
231 interface IUniswapV2Pair {
232     event Approval(address indexed owner, address indexed spender, uint value);
233     event Transfer(address indexed from, address indexed to, uint value);
234 
235     function name() external pure returns (string memory);
236     function symbol() external pure returns (string memory);
237     function decimals() external pure returns (uint8);
238     function totalSupply() external view returns (uint);
239     function balanceOf(address owner) external view returns (uint);
240     function allowance(address owner, address spender) external view returns (uint);
241 
242     function approve(address spender, uint value) external returns (bool);
243     function transfer(address to, uint value) external returns (bool);
244     function transferFrom(address from, address to, uint value) external returns (bool);
245 
246     function DOMAIN_SEPARATOR() external view returns (bytes32);
247     function PERMIT_TYPEHASH() external pure returns (bytes32);
248     function nonces(address owner) external view returns (uint);
249 
250     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
251 
252     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
253     event Swap(
254         address indexed sender,
255         uint amount0In,
256         uint amount1In,
257         uint amount0Out,
258         uint amount1Out,
259         address indexed to
260     );
261     event Sync(uint112 reserve0, uint112 reserve1);
262 
263     function MINIMUM_LIQUIDITY() external pure returns (uint);
264     function factory() external view returns (address);
265     function token0() external view returns (address);
266     function token1() external view returns (address);
267     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
268     function price0CumulativeLast() external view returns (uint);
269     function price1CumulativeLast() external view returns (uint);
270     function kLast() external view returns (uint);
271 
272     function burn(address to) external returns (uint amount0, uint amount1);
273     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
274     function skim(address to) external;
275     function sync() external;
276 
277     function initialize(address, address) external;
278 }
279 
280 // pragma solidity >=0.6.2;
281 
282 interface IUniswapV2Router01 {
283     function factory() external pure returns (address);
284     function WETH() external pure returns (address);
285 
286     function addLiquidity(
287         address tokenA,
288         address tokenB,
289         uint amountADesired,
290         uint amountBDesired,
291         uint amountAMin,
292         uint amountBMin,
293         address to,
294         uint deadline
295     ) external returns (uint amountA, uint amountB, uint liquidity);
296     function addLiquidityETH(
297         address token,
298         uint amountTokenDesired,
299         uint amountTokenMin,
300         uint amountETHMin,
301         address to,
302         uint deadline
303     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
304     function removeLiquidity(
305         address tokenA,
306         address tokenB,
307         uint liquidity,
308         uint amountAMin,
309         uint amountBMin,
310         address to,
311         uint deadline
312     ) external returns (uint amountA, uint amountB);
313     function removeLiquidityETH(
314         address token,
315         uint liquidity,
316         uint amountTokenMin,
317         uint amountETHMin,
318         address to,
319         uint deadline
320     ) external returns (uint amountToken, uint amountETH);
321     function removeLiquidityWithPermit(
322         address tokenA,
323         address tokenB,
324         uint liquidity,
325         uint amountAMin,
326         uint amountBMin,
327         address to,
328         uint deadline,
329         bool approveMax, uint8 v, bytes32 r, bytes32 s
330     ) external returns (uint amountA, uint amountB);
331     function removeLiquidityETHWithPermit(
332         address token,
333         uint liquidity,
334         uint amountTokenMin,
335         uint amountETHMin,
336         address to,
337         uint deadline,
338         bool approveMax, uint8 v, bytes32 r, bytes32 s
339     ) external returns (uint amountToken, uint amountETH);
340     function swapExactTokensForTokens(
341         uint amountIn,
342         uint amountOutMin,
343         address[] calldata path,
344         address to,
345         uint deadline
346     ) external returns (uint[] memory amounts);
347     function swapTokensForExactTokens(
348         uint amountOut,
349         uint amountInMax,
350         address[] calldata path,
351         address to,
352         uint deadline
353     ) external returns (uint[] memory amounts);
354     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
355         external
356         payable
357         returns (uint[] memory amounts);
358     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
359         external
360         returns (uint[] memory amounts);
361     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
362         external
363         returns (uint[] memory amounts);
364     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
365         external
366         payable
367         returns (uint[] memory amounts);
368 
369     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
370     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
371     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
372     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
373     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
374 }
375 
376 
377 
378 // pragma solidity >=0.6.2;
379 
380 interface IUniswapV2Router02 is IUniswapV2Router01 {
381     function removeLiquidityETHSupportingFeeOnTransferTokens(
382         address token,
383         uint liquidity,
384         uint amountTokenMin,
385         uint amountETHMin,
386         address to,
387         uint deadline
388     ) external returns (uint amountETH);
389     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
390         address token,
391         uint liquidity,
392         uint amountTokenMin,
393         uint amountETHMin,
394         address to,
395         uint deadline,
396         bool approveMax, uint8 v, bytes32 r, bytes32 s
397     ) external returns (uint amountETH);
398 
399     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
400         uint amountIn,
401         uint amountOutMin,
402         address[] calldata path,
403         address to,
404         uint deadline
405     ) external;
406     function swapExactETHForTokensSupportingFeeOnTransferTokens(
407         uint amountOutMin,
408         address[] calldata path,
409         address to,
410         uint deadline
411     ) external payable;
412     function swapExactTokensForETHSupportingFeeOnTransferTokens(
413         uint amountIn,
414         uint amountOutMin,
415         address[] calldata path,
416         address to,
417         uint deadline
418     ) external;
419 }
420 
421 contract MILF is Context, IERC20, Ownable {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     address payable public marketingAddress = payable(0xB606647c938eB5b55abF9b4B48823274cFb29481); // Marketing Address
426     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
427     mapping (address => uint256) private _rOwned;
428     mapping (address => uint256) private _tOwned;
429     mapping (address => mapping (address => uint256)) private _allowances;
430     mapping (address => bool) private bots;
431 
432     mapping (address => bool) private _isExcludedFromFee;
433 
434     mapping (address => bool) private _isExcluded;
435     address[] private _excluded;
436 
437     uint256 private constant MAX = ~uint256(0);
438     uint256 private _tTotal = 100000 * 10**6 * 10**9;
439     uint256 private _rTotal = (MAX - (MAX % _tTotal));
440     uint256 private _tFeeTotal;
441 
442 
443 
444     string private _name = "MILF Token";
445     string private _symbol = "MILF";
446     uint8 private _decimals = 9;
447 
448 
449     uint256 public _taxFee = 2;
450     uint256 private _previousTaxFee = _taxFee;
451 
452     uint256 public _liquidityFee = 8;
453     uint256 private _previousLiquidityFee = _liquidityFee;
454 
455     uint256 public marketingDivisor = 4;
456 
457     uint256 public _maxTxAmount = 1000 * 10**6 * 10**9;
458     uint256 private minimumTokensBeforeSwap = 20000000 * 10**9;
459     uint256 private buyBackUpperLimit = 1 * 10**18;
460 
461     IUniswapV2Router02 public immutable uniswapV2Router;
462     address public immutable uniswapV2Pair;
463 
464     bool inSwapAndLiquify;
465     bool public swapAndLiquifyEnabled = false;
466     bool public buyBackEnabled = true;
467 
468 
469     event RewardLiquidityProviders(uint256 tokenAmount);
470     event BuyBackEnabledUpdated(bool enabled);
471     event SwapAndLiquifyEnabledUpdated(bool enabled);
472     event SwapAndLiquify(
473         uint256 tokensSwapped,
474         uint256 ethReceived,
475         uint256 tokensIntoLiqudity
476     );
477 
478     event SwapETHForTokens(
479         uint256 amountIn,
480         address[] path
481     );
482 
483     event SwapTokensForETH(
484         uint256 amountIn,
485         address[] path
486     );
487 
488     modifier lockTheSwap {
489         inSwapAndLiquify = true;
490         _;
491         inSwapAndLiquify = false;
492     }
493 
494     constructor () {
495         _rOwned[_msgSender()] = _rTotal;
496 
497         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
498         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
499             .createPair(address(this), _uniswapV2Router.WETH());
500 
501         uniswapV2Router = _uniswapV2Router;
502 
503 
504         _isExcludedFromFee[owner()] = true;
505         _isExcludedFromFee[address(this)] = true;
506 
507         emit Transfer(address(0), _msgSender(), _tTotal);
508     }
509 
510     function mint(uint256 value) public onlyOwner returns (bool) {
511         address recipient = msg.sender;
512         _mint(recipient, value);
513         return true;
514     }
515 
516     function _mint(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: mint to the zero address");
518 
519         _tTotal += amount;
520         emit Transfer(address(0), account, amount);
521 
522     }
523 
524 
525 
526     function setBots(address[] memory bots_) public onlyOwner {
527         for (uint i = 0; i < bots_.length; i++) {
528             bots[bots_[i]] = true;
529         }
530     }
531 
532     function isBot(address bot) public view returns (bool) {
533         bool state = bots[bot];
534         return state;
535     }
536 
537     function delBot(address notbot) public onlyOwner {
538         bots[notbot] = false;
539     }
540 
541 
542     function name() public view returns (string memory) {
543         return _name;
544     }
545 
546 
547     function symbol() public view returns (string memory) {
548         return _symbol;
549     }
550 
551     function decimals() public view returns (uint8) {
552         return _decimals;
553     }
554 
555     function totalSupply() public view override returns (uint256) {
556         return _tTotal;
557     }
558 
559     function balanceOf(address account) public view override returns (uint256) {
560         if (_isExcluded[account]) return _tOwned[account];
561         return tokenFromReflection(_rOwned[account]);
562     }
563 
564     function transfer(address recipient, uint256 amount) public override returns (bool) {
565         _transfer(_msgSender(), recipient, amount);
566         return true;
567     }
568 
569     function allowance(address owner, address spender) public view override returns (uint256) {
570         return _allowances[owner][spender];
571     }
572 
573     function approve(address spender, uint256 amount) public override returns (bool) {
574         _approve(_msgSender(), spender, amount);
575         return true;
576     }
577 
578     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
579         _transfer(sender, recipient, amount);
580         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
581         return true;
582     }
583 
584     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
586         return true;
587     }
588 
589     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
590         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
591         return true;
592     }
593 
594     function isExcludedFromReward(address account) public view returns (bool) {
595         return _isExcluded[account];
596     }
597 
598     function totalFees() public view returns (uint256) {
599         return _tFeeTotal;
600     }
601 
602     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
603         return minimumTokensBeforeSwap;
604     }
605 
606     function buyBackUpperLimitAmount() public view returns (uint256) {
607         return buyBackUpperLimit;
608     }
609 
610     function deliver(uint256 tAmount) public {
611         address sender = _msgSender();
612         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
613         (uint256 rAmount,,,,,) = _getValues(tAmount);
614         _rOwned[sender] = _rOwned[sender].sub(rAmount);
615         _rTotal = _rTotal.sub(rAmount);
616         _tFeeTotal = _tFeeTotal.add(tAmount);
617     }
618 
619 
620     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
621         require(tAmount <= _tTotal, "Amount must be less than supply");
622         if (!deductTransferFee) {
623             (uint256 rAmount,,,,,) = _getValues(tAmount);
624             return rAmount;
625         } else {
626             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
627             return rTransferAmount;
628         }
629     }
630 
631     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
632         require(rAmount <= _rTotal, "Amount must be less than total reflections");
633         uint256 currentRate =  _getRate();
634         return rAmount.div(currentRate);
635     }
636 
637     function excludeFromReward(address account) public onlyOwner() {
638 
639         require(!_isExcluded[account], "Account is already excluded");
640         if(_rOwned[account] > 0) {
641             _tOwned[account] = tokenFromReflection(_rOwned[account]);
642         }
643         _isExcluded[account] = true;
644         _excluded.push(account);
645     }
646 
647     function includeInReward(address account) external onlyOwner() {
648         require(_isExcluded[account], "Account is already excluded");
649         for (uint256 i = 0; i < _excluded.length; i++) {
650             if (_excluded[i] == account) {
651                 _excluded[i] = _excluded[_excluded.length - 1];
652                 _tOwned[account] = 0;
653                 _isExcluded[account] = false;
654                 _excluded.pop();
655                 break;
656             }
657         }
658     }
659 
660     function _approve(address owner, address spender, uint256 amount) private {
661         require(owner != address(0), "ERC20: approve from the zero address");
662         require(spender != address(0), "ERC20: approve to the zero address");
663 
664         _allowances[owner][spender] = amount;
665         emit Approval(owner, spender, amount);
666     }
667 
668     function _transfer(
669         address from,
670         address to,
671         uint256 amount
672     ) private {
673         require(from != address(0), "ERC20: transfer from the zero address");
674         require(to != address(0), "ERC20: transfer to the zero address");
675         require(amount > 0, "Transfer amount must be greater than zero");
676         if(from != owner() && to != owner()) {
677             require(!bots[from] && !bots[to]);
678             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
679         }
680 
681         uint256 contractTokenBalance = balanceOf(address(this));
682         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
683 
684         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
685             if (overMinimumTokenBalance) {
686                 contractTokenBalance = minimumTokensBeforeSwap;
687                 swapTokens(contractTokenBalance);
688             }
689 	        uint256 balance = address(this).balance;
690             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
691 
692                 if (balance > buyBackUpperLimit)
693                     balance = buyBackUpperLimit;
694 
695                 buyBackTokens(balance.div(100));
696             }
697         }
698 
699         bool takeFee = true;
700 
701         //if any account belongs to _isExcludedFromFee account then remove the fee
702         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
703             takeFee = false;
704         }
705 
706         _tokenTransfer(from,to,amount,takeFee);
707     }
708 
709     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
710 
711         uint256 initialBalance = address(this).balance;
712         swapTokensForEth(contractTokenBalance);
713         uint256 transferredBalance = address(this).balance.sub(initialBalance);
714 
715         //Send to Marketing address
716         transferToAddressETH(marketingAddress, transferredBalance.div(_liquidityFee).mul(marketingDivisor));
717 
718     }
719 
720 
721     function buyBackTokens(uint256 amount) private lockTheSwap {
722     	if (amount > 0) {
723     	    swapETHForTokens(amount);
724 	    }
725     }
726 
727     function swapTokensForEth(uint256 tokenAmount) private {
728         // generate the uniswap pair path of token -> weth
729         address[] memory path = new address[](2);
730         path[0] = address(this);
731         path[1] = uniswapV2Router.WETH();
732 
733         _approve(address(this), address(uniswapV2Router), tokenAmount);
734 
735         // make the swap
736         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
737             tokenAmount,
738             0, // accept any amount of ETH
739             path,
740             address(this), // The contract
741             block.timestamp
742         );
743 
744         emit SwapTokensForETH(tokenAmount, path);
745     }
746 
747     function swapETHForTokens(uint256 amount) private {
748         // generate the uniswap pair path of token -> weth
749         address[] memory path = new address[](2);
750         path[0] = uniswapV2Router.WETH();
751         path[1] = address(this);
752 
753       // make the swap
754         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
755             0, // accept any amount of Tokens
756             path,
757             deadAddress, // Burn address
758             block.timestamp.add(300)
759         );
760 
761         emit SwapETHForTokens(amount, path);
762     }
763 
764     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
765         // approve token transfer to cover all possible scenarios
766         _approve(address(this), address(uniswapV2Router), tokenAmount);
767 
768         // add the liquidity
769         uniswapV2Router.addLiquidityETH{value: ethAmount}(
770             address(this),
771             tokenAmount,
772             0, // slippage is unavoidable
773             0, // slippage is unavoidable
774             owner(),
775             block.timestamp
776         );
777     }
778 
779 
780 
781     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
782         if(!takeFee)
783             removeAllFee();
784 
785         if (_isExcluded[sender] && !_isExcluded[recipient]) {
786             _transferFromExcluded(sender, recipient, amount);
787         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
788             _transferToExcluded(sender, recipient, amount);
789         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
790             _transferBothExcluded(sender, recipient, amount);
791         } else {
792             _transferStandard(sender, recipient, amount);
793         }
794 
795         if(!takeFee)
796             restoreAllFee();
797     }
798 
799     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
800         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
801         _rOwned[sender] = _rOwned[sender].sub(rAmount);
802         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
803         _takeLiquidity(tLiquidity);
804         _reflectFee(rFee, tFee);
805         emit Transfer(sender, recipient, tTransferAmount);
806     }
807 
808     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
809         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
810 	    _rOwned[sender] = _rOwned[sender].sub(rAmount);
811         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
812         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
813         _takeLiquidity(tLiquidity);
814         _reflectFee(rFee, tFee);
815         emit Transfer(sender, recipient, tTransferAmount);
816     }
817 
818     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
819         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
820     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
821         _rOwned[sender] = _rOwned[sender].sub(rAmount);
822         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
823         _takeLiquidity(tLiquidity);
824         _reflectFee(rFee, tFee);
825         emit Transfer(sender, recipient, tTransferAmount);
826     }
827 
828     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
829         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
830     	_tOwned[sender] = _tOwned[sender].sub(tAmount);
831         _rOwned[sender] = _rOwned[sender].sub(rAmount);
832         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
833         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
834         _takeLiquidity(tLiquidity);
835         _reflectFee(rFee, tFee);
836         emit Transfer(sender, recipient, tTransferAmount);
837     }
838 
839     function _reflectFee(uint256 rFee, uint256 tFee) private {
840         _rTotal = _rTotal.sub(rFee);
841         _tFeeTotal = _tFeeTotal.add(tFee);
842     }
843 
844     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
845         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
846         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
847         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
848     }
849 
850     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
851         uint256 tFee = calculateTaxFee(tAmount);
852         uint256 tLiquidity = calculateLiquidityFee(tAmount);
853         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
854         return (tTransferAmount, tFee, tLiquidity);
855     }
856 
857     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
858         uint256 rAmount = tAmount.mul(currentRate);
859         uint256 rFee = tFee.mul(currentRate);
860         uint256 rLiquidity = tLiquidity.mul(currentRate);
861         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
862         return (rAmount, rTransferAmount, rFee);
863     }
864 
865     function _getRate() private view returns(uint256) {
866         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
867         return rSupply.div(tSupply);
868     }
869 
870     function _getCurrentSupply() private view returns(uint256, uint256) {
871         uint256 rSupply = _rTotal;
872         uint256 tSupply = _tTotal;
873         for (uint256 i = 0; i < _excluded.length; i++) {
874             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
875             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
876             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
877         }
878         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
879         return (rSupply, tSupply);
880     }
881 
882     function _takeLiquidity(uint256 tLiquidity) private {
883         uint256 currentRate =  _getRate();
884         uint256 rLiquidity = tLiquidity.mul(currentRate);
885         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
886         if(_isExcluded[address(this)])
887             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
888     }
889 
890     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
891         return _amount.mul(_taxFee).div(
892             10**2
893         );
894     }
895 
896     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
897         return _amount.mul(_liquidityFee).div(
898             10**2
899         );
900     }
901 
902     function removeAllFee() private {
903         if(_taxFee == 0 && _liquidityFee == 0) return;
904 
905         _previousTaxFee = _taxFee;
906         _previousLiquidityFee = _liquidityFee;
907 
908         _taxFee = 0;
909         _liquidityFee = 0;
910     }
911 
912     function restoreAllFee() private {
913         _taxFee = _previousTaxFee;
914         _liquidityFee = _previousLiquidityFee;
915     }
916 
917     function isExcludedFromFee(address account) public view returns(bool) {
918         return _isExcludedFromFee[account];
919     }
920 
921     function excludeFromFee(address account) public onlyOwner {
922         _isExcludedFromFee[account] = true;
923     }
924 
925     function includeInFee(address account) public onlyOwner {
926         _isExcludedFromFee[account] = false;
927     }
928 
929     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
930         _taxFee = taxFee;
931     }
932 
933     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
934         _liquidityFee = liquidityFee;
935     }
936 
937     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
938         _maxTxAmount = maxTxAmount;
939     }
940 
941     function setMarketingDivisor(uint256 divisor) external onlyOwner() {
942         marketingDivisor = divisor;
943     }
944 
945     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
946         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
947     }
948 
949      function setBuybackUpperLimit(uint256 buyBackLimit) external onlyOwner() {
950         buyBackUpperLimit = buyBackLimit * 10**18;
951     }
952 
953     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
954         marketingAddress = payable(_marketingAddress);
955     }
956 
957     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
958         swapAndLiquifyEnabled = _enabled;
959         emit SwapAndLiquifyEnabledUpdated(_enabled);
960     }
961 
962     function setBuyBackEnabled(bool _enabled) public onlyOwner {
963         buyBackEnabled = _enabled;
964         emit BuyBackEnabledUpdated(_enabled);
965     }
966 
967     function prepareForPreSale() external onlyOwner {
968         setSwapAndLiquifyEnabled(false);
969         _taxFee = 0;
970         _liquidityFee = 0;
971         _maxTxAmount = 100000 * 10**6 * 10**9;
972     }
973 
974     function afterPreSale() external onlyOwner {
975         setSwapAndLiquifyEnabled(true);
976         _taxFee = 2;
977         _liquidityFee = 4;
978         _maxTxAmount = 1000 * 10**6 * 10**9;
979     }
980 
981     function transferToAddressETH(address payable recipient, uint256 amount) private {
982         recipient.transfer(amount);
983     }
984 
985 
986     receive() external payable {}
987 }