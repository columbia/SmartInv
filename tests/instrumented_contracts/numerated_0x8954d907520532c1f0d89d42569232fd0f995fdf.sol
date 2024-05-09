1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6 
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this;
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53 
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56 
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69         return c;
70     }
71 
72 }
73 
74 contract Ownable is Context {
75 
76     address private _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }   
89     
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94     
95     function isOwner() public view returns (bool) {
96         return msg.sender == _owner;
97     }
98 
99     function renouncedOwnership() public virtual onlyOwner {
100         emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
101         _owner = address(0x000000000000000000000000000000000000dEaD);
102     }
103 
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 
110 }
111 
112 interface IUniswapV2Factory {
113     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115     function getPair(address tokenA, address tokenB) external view returns (address pair);
116 }
117 
118 interface IUniswapV2Router01 {
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 interface IUniswapV2Router02 is IUniswapV2Router01 {
132     function swapExactTokensForETHSupportingFeeOnTransferTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external;
139 }
140 
141 contract Token is Context, IERC20, Ownable {
142     
143     using SafeMath for uint256;
144     
145     string private _name = "Tradix";
146     string private _symbol = "TX";
147     uint8 private _decimals = 8;
148 
149     address public splitOneDev = 0x9a0a4047FC5A342dAdc8425471C289649c247d89;
150     address public splitTwoDev = 0xDa1CB3Df3DD7265c070F6e8bD2bd115241E4DFFC;
151     address public splitThreeDev = 0xad3444832Ff9B3B0276c1E31962f03e1A38A63A9;
152 
153     address public growthWallet = 0x663Ab4a26af101D22DEba36F277e0C99258A89e1;
154     address public whaleWallet = 0x3BFafd3D788D3C9dDE7a4082288ECBB95b45C8Ca;
155     address public stakingWallet = 0xdA0723345bB5fC3A9daE15E4782D8FdbB8ef51a1;
156     address public liquidityReciever;
157 
158     address public constant deadAddress = 0x000000000000000000000000000000000000dEaD;
159     address public constant zeroAddress = 0x0000000000000000000000000000000000000000;
160     
161     mapping (address => uint256) _balances;
162     mapping (address => mapping (address => uint256)) private _allowances;
163     
164     mapping (address => bool) public isExcludedFromFee;
165     mapping (address => bool) public isMarketPair;
166     mapping (address => bool) public isWalletLimitExempt;
167     mapping (address => bool) public isTxLimitExempt;
168 
169     uint256 public constant MAX_FEE = 200;
170 
171     uint256 _buyDevFee = 30;
172     uint256 _buyLiquidityFee = 20;
173     uint256 _buyGrowthFee = 30;
174     uint256 _buyWhalePoolFee = 10;
175     uint256 _buyStakingPoolFee = 10;
176     
177     uint256 _sellDevFee = 60;
178     uint256 _sellLiquidityFee = 20;
179     uint256 _sellGrowthFee = 100;
180     uint256 _sellWhalePoolFee = 10;
181     uint256 _sellStakingPoolFee = 10;
182 
183     uint256 totalBuy;
184     uint256 totalSell;
185 
186     uint256 constant denominator = 1000;
187 
188     uint256 private _totalSupply = 100_000_000 * 10**_decimals;   
189 
190     uint256 public minimumTokensBeforeSwap = 10000 * 10**_decimals;
191 
192     uint256 public _maxTxAmount =  _totalSupply.mul(5).div(denominator);     //0.5%
193     uint256 public _walletMax = _totalSupply.mul(20).div(denominator);    //2%
194 
195     bool public EnableTxLimit = true;
196     bool public checkWalletLimit = true;
197 
198     IUniswapV2Router02 public uniswapV2Router;
199     address public uniswapPair;
200     
201     bool inSwapAndLiquify;
202     bool public swapAndLiquifyEnabled = true;
203 
204     event SwapAndLiquifyEnabledUpdated(bool enabled);
205 
206     event SwapAndLiquify(
207         uint256 tokensSwapped,
208         uint256 ethReceived,
209         uint256 tokensIntoLiqudity
210     );
211     
212     event SwapTokensForETH(
213         uint256 amountIn,
214         address[] path
215     );
216     
217     modifier lockTheSwap {
218         inSwapAndLiquify = true;
219         _;
220         inSwapAndLiquify = false;
221     }
222     
223     constructor () {
224         
225         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
226 
227         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
228             .createPair(address(this), _uniswapV2Router.WETH());
229 
230         uniswapV2Router = _uniswapV2Router;
231         _allowances[address(this)][address(uniswapV2Router)] = ~uint256(0);
232 
233         liquidityReciever = msg.sender;
234 
235         isExcludedFromFee[address(this)] = true;
236         isExcludedFromFee[msg.sender] = true;
237 
238         isWalletLimitExempt[msg.sender] = true;
239         isWalletLimitExempt[address(uniswapPair)] = true;
240         isWalletLimitExempt[address(this)] = true;
241         
242         isTxLimitExempt[msg.sender] = true;
243         isTxLimitExempt[address(this)] = true;
244 
245         isMarketPair[address(uniswapPair)] = true;
246 
247         totalBuy = _buyDevFee.add(_buyLiquidityFee).add(_buyGrowthFee).add(_buyWhalePoolFee).add(_buyStakingPoolFee);
248         totalSell = _sellDevFee.add(_sellLiquidityFee).add(_sellGrowthFee).add(_sellWhalePoolFee).add(_sellStakingPoolFee);
249 
250         _balances[msg.sender] = _totalSupply;
251         emit Transfer(address(0), msg.sender, _totalSupply);
252     }
253 
254     function name() public view returns (string memory) {
255         return _name;
256     }
257 
258     function symbol() public view returns (string memory) {
259         return _symbol;
260     }
261 
262     function decimals() public view returns (uint8) {
263         return _decimals;
264     }
265 
266     function totalSupply() public view override returns (uint256) {
267         return _totalSupply;
268     }
269 
270     function balanceOf(address account) public view override returns (uint256) {
271        return _balances[account];     
272     }
273 
274     function allowance(address owner, address spender) public view override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
279         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
280         return true;
281     }
282 
283     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
284         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
285         return true;
286     }
287 
288     function approve(address spender, uint256 amount) public override returns (bool) {
289         _approve(_msgSender(), spender, amount);
290         return true;
291     }
292 
293     function _approve(address owner, address spender, uint256 amount) private {
294         require(owner != address(0), "ERC20: approve from the zero address");
295         require(spender != address(0), "ERC20: approve to the zero address");
296 
297         _allowances[owner][spender] = amount;
298         emit Approval(owner, spender, amount);
299     }
300     
301     function getCirculatingSupply() public view returns (uint256) {
302         return _totalSupply.sub(balanceOf(deadAddress)).sub(balanceOf(zeroAddress));
303     }
304 
305      //to recieve ETH from uniswapV2Router when swaping
306     receive() external payable {}
307 
308     function transfer(address recipient, uint256 amount) public override returns (bool) {
309         _transfer(_msgSender(), recipient, amount);
310         return true;
311     }
312 
313     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
314         _transfer(sender, recipient, amount);
315         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
316         return true;
317     }
318 
319     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
320 
321         require(sender != address(0), "ERC20:from zero");
322         require(recipient != address(0), "ERC20:to zero");
323         require(amount > 0, "Invalid Amount");
324 
325         if(inSwapAndLiquify)
326         { 
327             return _basicTransfer(sender, recipient, amount); 
328         }
329         else
330         {  
331             if(!isTxLimitExempt[sender] && !isTxLimitExempt[recipient] && EnableTxLimit) {
332                 require(amount <= _maxTxAmount,"Max Tx");
333             } 
334 
335             uint256 contractTokenBalance = balanceOf(address(this));
336             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
337             
338             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
339             {
340                 swapAndLiquify();
341             }
342 
343             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
344 
345             uint256 finalAmount = shouldTakeFee(sender,recipient) ? amount : takeFee(sender, recipient, amount);
346 
347             if(checkWalletLimit && !isWalletLimitExempt[recipient]) {
348                 require(balanceOf(recipient).add(finalAmount) <= _walletMax,"Max Wallet");
349             }
350 
351             _balances[recipient] = _balances[recipient].add(finalAmount);
352 
353             emit Transfer(sender, recipient, finalAmount);
354             return true;
355         }
356     }
357 
358     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
359         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
360         _balances[recipient] = _balances[recipient].add(amount);
361         emit Transfer(sender, recipient, amount);
362         return true;
363     }
364 
365     function swapAndLiquify() private lockTheSwap {
366         
367         uint256 contractBalance = balanceOf(address(this));
368 
369         if(contractBalance == 0) return;
370 
371         uint256 _liquidityShare = _buyLiquidityFee.add(_sellLiquidityFee);
372         uint256 _DevShare = _buyDevFee.add(_sellDevFee);
373         uint256 _GrowthShare = _buyGrowthFee.add(_sellGrowthFee);
374         uint256 _WhaleShare = _buyWhalePoolFee.add(_sellWhalePoolFee);
375 
376         uint totalShares = totalBuy.add(totalSell);
377 
378         if(totalShares == 0) return;
379 
380         uint256 tokensForLP = contractBalance.mul(_liquidityShare).div(totalShares).div(2);
381         uint256 tokensForSwap = contractBalance.sub(tokensForLP);
382 
383         uint256 initialBalance = address(this).balance;
384         swapTokensForEth(tokensForSwap);
385         uint256 amountReceived = address(this).balance.sub(initialBalance);
386 
387         uint256 totalETHFee = totalShares.sub(_liquidityShare.div(2));
388 
389         uint256 amountETHLiquidity = amountReceived.mul(_liquidityShare).div(totalETHFee).div(2);
390         uint256 amountETHDev = amountReceived.mul(_DevShare).div(totalETHFee);
391         uint256 amountETHGrowth = amountReceived.mul(_GrowthShare).div(totalETHFee);
392         uint256 amountETHWhale = amountReceived.mul(_WhaleShare).div(totalETHFee);
393         uint256 amountETHStaking = amountReceived.sub(amountETHLiquidity).sub(amountETHDev).sub(amountETHGrowth).sub(amountETHWhale);
394 
395         if(amountETHDev > 0) {
396             uint split = amountETHDev / 3;
397             transferToAddressETH(splitOneDev, split);
398             transferToAddressETH(splitTwoDev, split);
399             transferToAddressETH(splitThreeDev, split);
400         }
401 
402         if(amountETHGrowth > 0)
403             transferToAddressETH(growthWallet, amountETHGrowth);
404 
405         if(amountETHWhale > 0)
406             transferToAddressETH(whaleWallet, amountETHWhale);
407 
408         if(amountETHStaking > 0)
409             transferToAddressETH(stakingWallet, amountETHStaking);
410 
411         if(amountETHLiquidity > 0 && tokensForLP > 0)
412             addLiquidity(tokensForLP, amountETHLiquidity);
413     }
414 
415     function transferToAddressETH(address recipient, uint256 amount) private {
416         payable(recipient).transfer(amount);
417     }
418     
419     function swapTokensForEth(uint256 tokenAmount) private {
420         // generate the uniswap pair path of token -> weth
421         address[] memory path = new address[](2);
422         path[0] = address(this);
423         path[1] = uniswapV2Router.WETH();
424 
425         _approve(address(this), address(uniswapV2Router), tokenAmount);
426 
427         // make the swap
428         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
429             tokenAmount,
430             0, // accept any amount of ETH
431             path,
432             address(this), // The contract
433             block.timestamp
434         );
435 
436         emit SwapTokensForETH(tokenAmount, path);
437     }
438 
439     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
440         // approve token transfer to cover all possible scenarios
441         _approve(address(this), address(uniswapV2Router), tokenAmount);
442 
443         // add the liquidity
444         uniswapV2Router.addLiquidityETH{value: ethAmount}(
445             address(this),
446             tokenAmount,
447             0, // slippage is unavoidable
448             0, // slippage is unavoidable
449             liquidityReciever,
450             block.timestamp
451         );
452     }
453 
454     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
455         if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
456             return true;
457         }
458         else if (isMarketPair[sender] || isMarketPair[recipient]) {
459             return false;
460         }
461         else {
462             return false;
463         }
464     }
465 
466     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
467         
468         uint feeAmount;
469 
470         unchecked {
471 
472             if(isMarketPair[sender]) {
473 
474                 feeAmount = amount.mul(totalBuy).div(denominator);
475             
476             }
477             else if(isMarketPair[recipient]) {
478                 
479                 feeAmount = amount.mul(totalSell).div(denominator);
480                 
481             }     
482 
483             if(feeAmount > 0) {
484                 _balances[address(this)] = _balances[address(this)].add(feeAmount);
485                 emit Transfer(sender, address(this), feeAmount);
486             }
487 
488             return amount.sub(feeAmount);
489         }
490         
491     }
492 
493     //To Rescue Stucked Balance
494     function rescueFunds() external onlyOwner { 
495         (bool os,) = payable(msg.sender).call{value: address(this).balance}("");
496         require(os,"Transaction Failed!!");
497     }
498 
499     //To Rescue Stucked Tokens
500     function rescueTokens(IERC20 adr,address recipient,uint amount) external onlyOwner {
501         adr.transfer(recipient,amount);
502     }
503 
504     function enableTxLimit(bool _status) external onlyOwner {
505         EnableTxLimit = _status;
506     }
507 
508     function enableWalletLimit(bool _status) external onlyOwner {
509         checkWalletLimit = _status;
510     }
511 
512     function setBuyFee(uint _newDev, uint _newLP , uint _newGrowth , uint _newWhale, uint _newStake) external onlyOwner {     
513         _buyDevFee = _newDev;
514         _buyLiquidityFee = _newLP;
515         _buyGrowthFee = _newGrowth;
516         _buyWhalePoolFee = _newWhale;
517         _buyStakingPoolFee = _newStake;
518         totalBuy = _buyDevFee.add(_buyLiquidityFee).add(_buyGrowthFee).add(_buyWhalePoolFee).add(_buyStakingPoolFee);
519         require(totalBuy <= MAX_FEE,"Error: Max 20% Tax Limit Exceeded!");
520     }
521 
522     function setSellFee(uint _newDev, uint _newLP , uint _newGrowth , uint _newWhale, uint _newStake) external onlyOwner {        
523         _sellDevFee = _newDev;
524         _sellLiquidityFee = _newLP;
525         _sellGrowthFee = _newGrowth;
526         _sellWhalePoolFee = _newWhale;
527         _sellStakingPoolFee = _newStake;
528         totalSell = _sellDevFee.add(_sellLiquidityFee).add(_sellGrowthFee).add(_sellWhalePoolFee).add(_sellStakingPoolFee);
529         require(totalSell <= MAX_FEE,"Error: Max 20% Tax Limit Exceeded!");
530     }
531 
532     function setDevsWallet(address _newOne, address _newTwo, address _newThree) external onlyOwner {
533         splitOneDev = _newOne;
534         splitTwoDev = _newTwo;
535         splitThreeDev = _newThree;
536     }
537 
538     function setGrowthWallets(address _newWallet) external onlyOwner {
539         growthWallet = _newWallet;
540     }
541     
542     function setWhaleWallets(address _newWallet) external onlyOwner {
543         whaleWallet = _newWallet;
544     }
545 
546     function setStakingWallets(address _newWallet) external onlyOwner {
547         stakingWallet = _newWallet;
548     }
549 
550     function setLiquidityWallets(address _newWallet) external onlyOwner {
551         liquidityReciever = _newWallet;
552     }
553 
554     function setExcludeFromFee(address _adr,bool _status) external onlyOwner {
555         require(isExcludedFromFee[_adr] != _status,"Not Changed!!");
556         isExcludedFromFee[_adr] = _status;
557     }
558 
559     function ExcludeWalletLimit(address _adr,bool _status) external onlyOwner {
560         require(isWalletLimitExempt[_adr] != _status,"Not Changed!!");
561         isWalletLimitExempt[_adr] = _status;
562     }
563 
564     function ExcludeTxLimit(address _adr,bool _status) external onlyOwner {
565         require(isTxLimitExempt[_adr] != _status,"Not Changed!!");
566         isTxLimitExempt[_adr] = _status;
567     }
568 
569     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
570         minimumTokensBeforeSwap = newLimit;
571     }
572 
573     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
574         _walletMax = newLimit;
575     }
576 
577     function setTxLimit(uint256 newLimit) external onlyOwner() {
578         _maxTxAmount = newLimit;
579     }
580 
581     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
582         swapAndLiquifyEnabled = _enabled;
583         emit SwapAndLiquifyEnabledUpdated(_enabled);
584     }
585 
586     function setMarketPair(address _pair, bool _status) external onlyOwner {
587         isMarketPair[_pair] = _status;
588     }
589 
590     function changeRouterVersion(address newRouterAddress) external onlyOwner returns(address newPairAddress) {
591 
592         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouterAddress); 
593 
594         newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
595 
596         if(newPairAddress == address(0)) //Create If Doesnt exist
597         {
598             newPairAddress = IUniswapV2Factory(_uniswapV2Router.factory())
599                 .createPair(address(this), _uniswapV2Router.WETH());
600         }
601 
602         uniswapPair = newPairAddress; //Set new pair address
603         uniswapV2Router = _uniswapV2Router; //Set new router address
604 
605         isMarketPair[address(uniswapPair)] = true;
606     }
607 
608 
609 }