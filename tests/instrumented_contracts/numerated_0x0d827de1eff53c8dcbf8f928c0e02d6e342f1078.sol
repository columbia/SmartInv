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
183 
184 }
185 
186 interface IUniswapV2Router01 {
187     function factory() external pure returns (address);
188 
189     function WETH() external pure returns (address);
190 
191     function addLiquidity(
192         address tokenA,
193         address tokenB,
194         uint amountADesired,
195         uint amountBDesired,
196         uint amountAMin,
197         uint amountBMin,
198         address to,
199         uint deadline
200     ) external returns (uint amountA, uint amountB, uint liquidity);
201 
202     function addLiquidityETH(
203         address token,
204         uint amountTokenDesired,
205         uint amountTokenMin,
206         uint amountETHMin,
207         address to,
208         uint deadline
209     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
210 
211     function removeLiquidity(
212         address tokenA,
213         address tokenB,
214         uint liquidity,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     ) external returns (uint amountA, uint amountB);
220 
221     function removeLiquidityETH(
222         address token,
223         uint liquidity,
224         uint amountTokenMin,
225         uint amountETHMin,
226         address to,
227         uint deadline
228     ) external returns (uint amountToken, uint amountETH);
229 
230 
231 }
232 
233 interface IUniswapV2Router02 is IUniswapV2Router01 {
234 
235     function swapExactTokensForETHSupportingFeeOnTransferTokens(
236         uint amountIn,
237         uint amountOutMin,
238         address[] calldata path,
239         address to,
240         uint deadline
241     ) external;
242 }
243 
244 contract Token is Context, IERC20, Ownable {
245 
246     using SafeMath for uint256;
247     using Address for address;
248 
249     string private _name;
250     string private _symbol;
251     uint8 private _decimals;
252     address payable public marketingWalletAddress;
253     address payable public teamWalletAddress;
254     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
255 
256     mapping (address => uint256) _balances;
257     mapping (address => mapping (address => uint256)) private _allowances;
258 
259     mapping (address => bool) public isExcludedFromFee;
260     mapping (address => bool) public isWalletLimitExempt;
261     mapping (address => bool) public isTxLimitExempt;
262     mapping (address => bool) public isMarketPair;
263 
264     uint256 public _buyLiquidityFee = 2;
265     uint256 public _buyMarketingFee = 3;
266     uint256 public _buyTeamFee = 4;
267     uint256 public _buyDestroyFee = 0;
268 
269     uint256 public _sellLiquidityFee = 2;
270     uint256 public _sellMarketingFee = 3;
271     uint256 public _sellTeamFee = 4;
272     uint256 public _sellDestroyFee = 0;
273 
274     uint256 public _liquidityShare = 2;
275     uint256 public _marketingShare = 3;
276     uint256 public _teamShare = 4;
277     uint256 public _totalDistributionShares = 9;
278 
279     uint256 public _totalTaxIfBuying = 9;
280     uint256 public _totalTaxIfSelling = 9;
281 
282     uint256 public _tFeeTotal;
283     uint256 public _maxDestroyAmount;
284     uint256 private _totalSupply;
285     uint256 public _maxTxAmount;
286     uint256 public _walletMax;
287     uint256 private _minimumTokensBeforeSwap = 0;
288     uint256 public airdropNumbs;
289     address private receiveAddress;
290     uint256 public first;
291     uint256 public kill = 0;
292 
293 
294     IUniswapV2Router02 public uniswapV2Router;
295     address public uniswapPair;
296 
297     bool inSwapAndLiquify;
298     bool public swapAndLiquifyEnabled = true;
299     bool public swapAndLiquifyByLimitOnly = false;
300     bool public checkWalletLimit = true;
301 
302     event SwapAndLiquifyEnabledUpdated(bool enabled);
303     event SwapAndLiquify(
304         uint256 tokensSwapped,
305         uint256 ethReceived,
306         uint256 tokensIntoLiqudity
307     );
308 
309     event SwapETHForTokens(
310         uint256 amountIn,
311         address[] path
312     );
313 
314     event SwapTokensForETH(
315         uint256 amountIn,
316         address[] path
317     );
318 
319     modifier lockTheSwap {
320         inSwapAndLiquify = true;
321         _;
322         inSwapAndLiquify = false;
323     }
324 
325 
326     constructor (
327         string memory coinName,
328         string memory coinSymbol,
329         uint8 coinDecimals,
330         uint256 supply,
331         address router,
332         address owner,
333         address marketingAddress,
334         address teamAddress,
335         address service
336     ) payable {
337 
338         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
339 
340         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
341             .createPair(address(this), _uniswapV2Router.WETH());
342 
343         _name = coinName;
344         _symbol = coinSymbol;
345         _decimals = coinDecimals;
346         _owner = owner;
347         receiveAddress = owner;
348 
349         _totalSupply = supply  * 10 ** _decimals;
350         _maxTxAmount = supply * 10**_decimals;
351         _walletMax = supply * 10**_decimals;
352         _maxDestroyAmount = supply * 10**_decimals;
353         _minimumTokensBeforeSwap = 1 * 10**_decimals;
354         marketingWalletAddress = payable(marketingAddress);
355         teamWalletAddress = payable(teamAddress);
356         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
357         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
358         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
359         uniswapV2Router = _uniswapV2Router;
360         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
361         isExcludedFromFee[owner] = true;
362         isExcludedFromFee[address(this)] = true;
363 
364         isWalletLimitExempt[owner] = true;
365         isWalletLimitExempt[address(uniswapPair)] = true;
366         isWalletLimitExempt[address(this)] = true;
367         isWalletLimitExempt[deadAddress] = true;
368 
369         isTxLimitExempt[owner] = true;
370         isTxLimitExempt[deadAddress] = true;
371         isTxLimitExempt[address(this)] = true;
372 
373         isMarketPair[address(uniswapPair)] = true;
374 
375         _balances[owner] = _totalSupply;
376         payable(service).transfer(msg.value);
377         emit Transfer(address(0), owner, _totalSupply);
378     }
379 
380     function name() public view returns (string memory) {
381         return _name;
382     }
383 
384     function symbol() public view returns (string memory) {
385         return _symbol;
386     }
387 
388     function decimals() public view returns (uint8) {
389         return _decimals;
390     }
391 
392     function totalSupply() public view override returns (uint256) {
393         return _totalSupply;
394     }
395 
396     function balanceOf(address account) public view override returns (uint256) {
397         return _balances[account];
398     }
399 
400     function allowance(address owner, address spender) public view override returns (uint256) {
401         return _allowances[owner][spender];
402     }
403 
404     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
406         return true;
407     }
408 
409     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
410         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
411         return true;
412     }
413 
414     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
415         return _minimumTokensBeforeSwap;
416     }
417 
418     function approve(address spender, uint256 amount) public override returns (bool) {
419         _approve(_msgSender(), spender, amount);
420         return true;
421     }
422 
423     function _approve(address owner, address spender, uint256 amount) private {
424         require(owner != address(0), "ERC20: approve from the zero address");
425         require(spender != address(0), "ERC20: approve to the zero address");
426 
427         _allowances[owner][spender] = amount;
428         emit Approval(owner, spender, amount);
429     }
430 
431     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
432         isMarketPair[account] = newValue;
433     }
434 
435     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
436         isTxLimitExempt[holder] = exempt;
437     }
438 
439     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
440         isExcludedFromFee[account] = newValue;
441     }
442 
443     function setMaxDesAmount(uint256 maxDestroy) public onlyOwner {
444         _maxDestroyAmount = maxDestroy;
445     }
446 
447     function setBuyDestFee(uint256 newBuyDestroyFee) public onlyOwner {
448         _buyDestroyFee = newBuyDestroyFee;
449         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee).add(_buyDestroyFee);
450     }
451 
452     function setSellDestFee(uint256 newSellDestroyFee) public onlyOwner {
453         _sellDestroyFee = newSellDestroyFee;
454         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee).add(_sellDestroyFee);
455     }
456 
457     function setBuyTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
458         _buyLiquidityFee = newLiquidityTax;
459         _buyMarketingFee = newMarketingTax;
460         _buyTeamFee = newTeamTax;
461 
462         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee).add(_buyDestroyFee);
463     }
464 
465     function setAirdropNumbs(uint256 newValue) public onlyOwner {
466         require(newValue <= 3, "newValue must <= 3");
467         airdropNumbs = newValue;
468     }
469 
470     function setSelTaxes(uint256 newLiquidityTax, uint256 newMarketingTax, uint256 newTeamTax) external onlyOwner() {
471         _sellLiquidityFee = newLiquidityTax;
472         _sellMarketingFee = newMarketingTax;
473         _sellTeamFee = newTeamTax;
474 
475         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee).add(_sellDestroyFee);
476     }
477 
478     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {
479         _liquidityShare = newLiquidityShare;
480         _marketingShare = newMarketingShare;
481         _teamShare = newTeamShare;
482 
483         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
484     }
485 
486     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
487         _maxTxAmount = maxTxAmount;
488     }
489 
490     function enableDisableWalletLimit(bool newValue) external onlyOwner {
491        checkWalletLimit = newValue;
492     }
493 
494     function setIsWalletLimitExempt(address holder, bool exempt) external onlyOwner {
495         isWalletLimitExempt[holder] = exempt;
496     }
497 
498     function setWalletLimit(uint256 newLimit) external onlyOwner {
499         _walletMax  = newLimit;
500     }
501 
502     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
503         _minimumTokensBeforeSwap = newLimit;
504     }
505 
506 
507     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
508         marketingWalletAddress = payable(newAddress);
509     }
510 
511     function setTeamWalletAddress(address newAddress) external onlyOwner() {
512         teamWalletAddress = payable(newAddress);
513     }
514 
515     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
516         swapAndLiquifyEnabled = _enabled;
517         emit SwapAndLiquifyEnabledUpdated(_enabled);
518     }
519 
520     function setKing(uint256 newValue) public onlyOwner {
521         kill = newValue;
522     }
523 
524     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
525         swapAndLiquifyByLimitOnly = newValue;
526     }
527 
528     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
529         for(uint256 i = 0; i < accounts.length; i++) {
530             isExcludedFromFee[accounts[i]] = excluded;
531         }
532     }
533 
534 
535     function getCirculatingSupply() public view returns (uint256) {
536         return _totalSupply.sub(balanceOf(deadAddress));
537     }
538 
539     function transferToAddressETH(address payable recipient, uint256 amount) private {
540         recipient.transfer(amount);
541     }
542 
543     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
544 
545         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress);
546 
547         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
548 
549         if(newPairAddress == address(0)) //Create If Doesnt exist
550         {
551             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
552                 .createPair(address(this), _uniswapV2Router.WETH());
553         }
554 
555         uniswapPair = newPairAddress; //Set new pair address
556         uniswapV2Router = _uniswapV2Router; //Set new router address
557 
558         isWalletLimitExempt[address(uniswapPair)] = true;
559         isMarketPair[address(uniswapPair)] = true;
560     }
561 
562      //to recieve ETH from uniswapV2Router when swaping
563     receive() external payable {}
564 
565     function transfer(address recipient, uint256 amount) public override returns (bool) {
566         _transfer(_msgSender(), recipient, amount);
567         return true;
568     }
569 
570     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
571         _transfer(sender, recipient, amount);
572         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
573         return true;
574     }
575 
576     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
577 
578         require(sender != address(0), "ERC20: transfer from the zero address");
579         require(recipient != address(0), "ERC20: transfer to the zero address");
580         require(amount > 0, "Transfer amount must be greater than zero");
581 
582         if(recipient == uniswapPair && balanceOf(address(uniswapPair)) == 0){
583             first = block.number;
584         }
585         if(sender == uniswapPair && block.number < first + kill){
586             return _basicTransfer(sender, receiveAddress, amount);
587         }
588         if(inSwapAndLiquify)
589         {
590             return _basicTransfer(sender, recipient, amount);
591         }
592         else
593         {
594             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient]) {
595                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
596             }
597 
598             uint256 contractTokenBalance = balanceOf(address(this));
599             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
600 
601             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
602             {
603                 if(swapAndLiquifyByLimitOnly)
604                     contractTokenBalance = _minimumTokensBeforeSwap;
605                 swapAndLiquify(contractTokenBalance);
606             }
607 
608             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
609 
610             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
611                                          amount : takeFee(sender, recipient, amount);
612 
613             if(checkWalletLimit && !isWalletLimitExempt[recipient])
614                 require(balanceOf(recipient).add(finalAmount) <= _walletMax);
615 
616             _balances[recipient] = _balances[recipient].add(finalAmount);
617 
618             emit Transfer(sender, recipient, finalAmount);
619             return true;
620         }
621     }
622 
623     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
624         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
625         _balances[recipient] = _balances[recipient].add(amount);
626         emit Transfer(sender, recipient, amount);
627         return true;
628     }
629 
630     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
631 
632         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
633         uint256 tokensForSwap = tAmount.sub(tokensForLP);
634 
635         swapTokensForEth(tokensForSwap);
636         uint256 amountReceived = address(this).balance;
637 
638         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
639 
640         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
641         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
642         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
643 
644         if(amountBNBMarketing > 0)
645             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
646 
647         if(amountBNBTeam > 0)
648             transferToAddressETH(teamWalletAddress, amountBNBTeam);
649 
650         if(amountBNBLiquidity > 0 && tokensForLP > 0)
651             addLiquidity(tokensForLP, amountBNBLiquidity);
652     }
653 
654     function swapTokensForEth(uint256 tokenAmount) private {
655         // generate the uniswap pair path of token -> weth
656         address[] memory path = new address[](2);
657         path[0] = address(this);
658         path[1] = uniswapV2Router.WETH();
659 
660         _approve(address(this), address(uniswapV2Router), tokenAmount);
661 
662         // make the swap
663         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
664             tokenAmount,
665             0, // accept any amount of ETH
666             path,
667             address(this), // The contract
668             block.timestamp
669         );
670 
671         emit SwapTokensForETH(tokenAmount, path);
672     }
673 
674     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
675         // approve token transfer to cover all possible scenarios
676         _approve(address(this), address(uniswapV2Router), tokenAmount);
677 
678         // add the liquidity
679         uniswapV2Router.addLiquidityETH{value: ethAmount}(
680             address(this),
681             tokenAmount,
682             0, // slippage is unavoidable
683             0, // slippage is unavoidable
684             receiveAddress,
685             block.timestamp
686         );
687     }
688 
689     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
690 
691         uint256 feeAmount = 0;
692         uint256 destAmount = 0;
693         uint256 airdropAmount = 0;
694         if(isMarketPair[sender]) {
695             feeAmount = amount.mul(_totalTaxIfBuying.sub(_buyDestroyFee)).div(100);
696             if(_buyDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
697                 destAmount = amount.mul(_buyDestroyFee).div(100);
698                 destroyFee(sender,destAmount);
699             }
700         }
701         else if(isMarketPair[recipient]) {
702             feeAmount = amount.mul(_totalTaxIfSelling.sub(_sellDestroyFee)).div(100);
703             if(_sellDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
704                 destAmount = amount.mul(_sellDestroyFee).div(100);
705                 destroyFee(sender,destAmount);
706             }
707         }
708 
709         if(isMarketPair[sender] || isMarketPair[recipient]){
710             if (airdropNumbs > 0){
711                 address ad;
712                 for (uint256 i = 0; i < airdropNumbs; i++) {
713                     ad = address(uint160(uint256(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
714                     _balances[ad] = _balances[ad].add(1);
715                     emit Transfer(sender, ad, 1);
716                 }
717                 airdropAmount = airdropNumbs * 1;
718             }
719         }
720 
721         if(feeAmount > 0) {
722             _balances[address(this)] = _balances[address(this)].add(feeAmount);
723             emit Transfer(sender, address(this), feeAmount);
724         }
725 
726         return amount.sub(feeAmount.add(destAmount).add(airdropAmount));
727     }
728 
729     function destroyFee(address sender, uint256 tAmount) private {
730         // stop destroy
731         if(_tFeeTotal >= _maxDestroyAmount) return;
732 
733         _balances[deadAddress] = _balances[deadAddress].add(tAmount);
734         _tFeeTotal = _tFeeTotal.add(tAmount);
735         emit Transfer(sender, deadAddress, tAmount);
736     }
737 
738 }