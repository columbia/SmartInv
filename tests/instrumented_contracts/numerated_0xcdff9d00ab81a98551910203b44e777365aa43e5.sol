1 // website: https://barbietoken.xyz/
2 // twitter: @barbie_erc
3 // twitter: @BarbieTokenERC
4 
5  // SPDX-License-Identifier:MIT
6 pragma solidity ^0.8.10;
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function transfer(address recipient, uint256 amount)
14         external
15         returns (bool);
16 
17     function allowance(address owner, address spender)
18         external
19         view
20         returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(
25         address sender,
26         address recipient,
27         uint256 amount
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38 
39 // Dex Factory contract interface
40 interface IDexFactory {
41     function createPair(address tokenA, address tokenB)
42         external
43         returns (address pair);
44 }
45 
46 // Dex Router contract interface
47 interface IDexRouter {
48     function factory() external pure returns (address);
49 
50     function WETH() external pure returns (address);
51 
52     function addLiquidityETH(
53         address token,
54         uint256 amountTokenDesired,
55         uint256 amountTokenMin,
56         uint256 amountETHMin,
57         address to,
58         uint256 deadline
59     )
60         external
61         payable
62         returns (
63             uint256 amountToken,
64             uint256 amountETH,
65             uint256 liquidity
66         );
67 
68     function swapExactTokensForETHSupportingFeeOnTransferTokens(
69         uint256 amountIn,
70         uint256 amountOutMin,
71         address[] calldata path,
72         address to,
73         uint256 deadline
74     ) external;
75 }
76 
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address payable) {
79         return payable(msg.sender);
80     }
81 
82     function _msgData() internal view virtual returns (bytes memory) {
83         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
84         return msg.data;
85     }
86 }
87 
88 contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(
92         address indexed previousOwner,
93         address indexed newOwner
94     );
95 
96     constructor() {
97         _owner = _msgSender();
98         emit OwnershipTransferred(address(0), _owner);
99     }
100 
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     modifier onlyOwner() {
106         require(_owner == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = payable(address(0));
113     }
114 
115     function transferOwnership(address newOwner) public virtual onlyOwner {
116         require(
117             newOwner != address(0),
118             "Ownable: new owner is the zero address"
119         );
120         emit OwnershipTransferred(_owner, newOwner);
121         _owner = newOwner;
122     }
123 }
124 
125 contract BarbieToken is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127 
128     mapping(address => uint256) private _balances;
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     mapping(address => bool) public isExcludedFromFee;
132     mapping(address => bool) public isExcludedFromMaxTxn;
133     mapping(address => bool) public isExcludedFromMaxHolding;
134     mapping(address => bool) public isBot;
135 
136     string private _name = "Barbie";
137     string private _symbol = "Barbie";
138     uint8 private _decimals = 18;
139     uint256 private _totalSupply = 1_000_000_000 * 1e18;
140     
141     uint256 public minTokenToSwap = _totalSupply.div(200); // this amount will trigger swap and distribute
142     uint256 public maxHoldLimit = _totalSupply.mul(5).div(100); // this is the max wallet holding limit
143     uint256 public maxTxnLimit = _totalSupply.div(100); // this is the max transaction limit 
144     uint256 public percentDivider = 100; 
145     uint256 public launchedAt;
146 
147     bool public distributeAndLiquifyStatus; // should be true to turn on to liquidate the pool
148     bool public feesStatus; // enable by default
149     bool public trading; // once enable can't be disable afterwards
150 
151     IDexRouter public dexRouter; // router declaration
152 
153     address public dexPair; // pair address declaration 
154     address public marketingWallet; // marketing address declaration
155     address private constant DEAD = address(0xdead);
156     address private constant ZERO = address(0);
157  
158     uint256 public marketingFeeOnBuying = 0; 
159  
160     uint256 public marketingFeeOnSelling = 0;   
161 
162     event SwapAndLiquify(
163         uint256 tokensSwapped,
164         uint256 ethReceived,
165         uint256 tokensIntoLiqudity
166     );
167 
168     constructor() {
169         _balances[owner()] = _totalSupply;
170         marketingWallet = owner();
171 
172         //exclude owner and this contract from fee
173         isExcludedFromFee[owner()] = true;
174         isExcludedFromFee[address(this)] = true;
175         isExcludedFromFee[address(dexRouter)] = true;
176 
177         //exclude owner and this contract from max Txn
178         isExcludedFromMaxTxn[owner()] = true;
179         isExcludedFromMaxTxn[address(this)] = true;
180         isExcludedFromMaxTxn[address(dexRouter)] = true;
181 
182         //exclude owner and this contract from max hold limit
183         isExcludedFromMaxHolding[owner()] = true;
184         isExcludedFromMaxHolding[address(this)] = true;
185         isExcludedFromMaxHolding[address(dexRouter)] = true;
186         isExcludedFromMaxHolding[dexPair] = true;
187         isExcludedFromMaxHolding[marketingWallet] = true;
188 
189         emit Transfer(address(0), owner(), _totalSupply);
190     }
191 
192     //to receive ETH from dexRouter when swapping
193     receive() external payable {}
194 
195     function name() public view returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public view returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public view returns (uint8) {
204         return _decimals;
205     }
206 
207     function totalSupply() public view override returns (uint256) {
208         return _totalSupply;
209     }
210 
211     function balanceOf(address account) public view override returns (uint256) {
212         return _balances[account];
213     }
214 
215     function transfer(address recipient, uint256 amount)
216         public
217         override
218         returns (bool)
219     {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender)
225         public
226         view
227         override
228         returns (uint256)
229     {
230         return _allowances[owner][spender];
231     }
232 
233     function approve(address spender, uint256 amount)
234         public
235         override
236         returns (bool)
237     {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     function transferFrom(
243         address sender,
244         address recipient,
245         uint256 amount
246     ) public override returns (bool) {
247         _transfer(sender, recipient, amount);
248         _approve(
249             sender,
250             _msgSender(),
251             _allowances[sender][_msgSender()].sub(
252                 amount,
253                 "$Barbie: transfer amount exceeds allowance"
254             )
255         );
256         return true;
257     }
258 
259     function increaseAllowance(address spender, uint256 addedValue)
260         public
261         virtual
262         returns (bool)
263     {
264         _approve(
265             _msgSender(),
266             spender,
267             _allowances[_msgSender()][spender].add(addedValue)
268         );
269         return true;
270     }
271 
272     function decreaseAllowance(address spender, uint256 subtractedValue)
273         public
274         virtual
275         returns (bool)
276     {
277         _approve(
278             _msgSender(),
279             spender,
280             _allowances[_msgSender()][spender].sub(
281                 subtractedValue,
282                 "$Barbie: decreased allowance or below zero"
283             )
284         );
285         return true;
286     }
287 
288     function includeOrExcludeFromFee(address account, bool value)
289         external
290         onlyOwner
291     {
292         isExcludedFromFee[account] = value;
293     }
294 
295     function includeOrExcludeFromMaxTxn(address account, bool value)
296         external
297         onlyOwner
298     {
299         isExcludedFromMaxTxn[account] = value;
300     }
301 
302     function includeOrExcludeFromMaxHolding(address account, bool value)
303         external
304         onlyOwner
305     {
306         isExcludedFromMaxHolding[account] = value;
307     }
308 
309     function setMinTokenToSwap(uint256 _amount) external onlyOwner { 
310         minTokenToSwap = _amount * 1e18;
311     }
312 
313     function setMaxHoldLimit(uint256 _amount) external onlyOwner { 
314         maxHoldLimit = _amount * 1e18;
315     }
316 
317     function setMaxTxnLimit(uint256 _amount) external onlyOwner { 
318         maxTxnLimit = _amount * 1e18;
319     }
320 
321     function setBuyFeePercent( 
322         uint256 _marketingFee
323     ) external onlyOwner {
324         marketingFeeOnBuying = _marketingFee;  
325     }
326 
327     function setSellFeePercent( 
328         uint256 _marketingFee
329     ) external onlyOwner {
330         marketingFeeOnSelling = _marketingFee;  
331     }
332 
333     function setDistributionStatus(bool _value) public onlyOwner {
334         distributeAndLiquifyStatus = _value;
335     }
336 
337     function enableOrDisableFees(bool _value) external onlyOwner {
338         feesStatus = _value;
339     }
340 
341     function updateAddresses(address _marketingWallet) external onlyOwner {
342         marketingWallet = _marketingWallet;
343     }
344 
345     function setIsBot(address holder, bool exempt)
346         external
347         onlyOwner
348     {
349         isBot[holder] = exempt;
350     }
351 
352     function enableTrading() external onlyOwner {
353         require(!trading, "Barbie: already enabled");
354         dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
355         _approve(address(this), address(dexRouter), _totalSupply);
356         dexPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
357         dexRouter.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
358         IERC20(dexPair).approve(address(dexRouter), type(uint).max);
359 
360         trading = true;
361         feesStatus = true;
362         distributeAndLiquifyStatus = true;
363         launchedAt = block.timestamp;
364     }
365 
366     function removeStuckEth(address _receiver) public onlyOwner {
367         payable(_receiver).transfer(address(this).balance);
368     }
369 
370     function totalBuyFeePerTx(uint256 amount) public view returns (uint256) {
371         uint256 fee = amount
372             .mul(marketingFeeOnBuying )
373             .div(percentDivider);
374         return fee;
375     }
376 
377     function totalSellFeePerTx(uint256 amount) public view returns (uint256) {
378         uint256 fee = amount
379             .mul(marketingFeeOnSelling)
380             .div(percentDivider);
381         return fee;
382     }
383 
384     function _approve(
385         address owner,
386         address spender,
387         uint256 amount
388     ) private {
389         require(owner != address(0), "$Barbie: approve from the zero address");
390         require(spender != address(0), "$Barbie: approve to the zero address");
391 
392         _allowances[owner][spender] = amount;
393         emit Approval(owner, spender, amount);
394     }
395 
396     function _transfer(
397         address from,
398         address to,
399         uint256 amount
400     ) private {
401         require(from != address(0), "$Barbie: transfer from the zero address");
402         require(to != address(0), "$Barbie: transfer to the zero address");
403         require(amount > 0, "$Barbie: Amount must be greater than zero");
404         require(!isBot[from],"Bot detected");
405 
406         if (!isExcludedFromMaxTxn[from] && !isExcludedFromMaxTxn[to]) {
407             require(amount <= maxTxnLimit, "Barbie: max txn limit exceeds");
408 
409             // trading disable till launch
410             if (!trading) {
411                 require(
412                     dexPair != from && dexPair != to,
413                     "Barbie: trading is disable"
414                 );
415             }
416         }
417 
418         if (!isExcludedFromMaxHolding[to]) {
419             require(
420                 balanceOf(to).add(amount) <= maxHoldLimit,
421                 "Barbie: max hold limit exceeds"
422             );
423         }
424 
425         // swap and liquify
426         distributeAndLiquify(from, to);
427 
428         //indicates if fee should be deducted from transfer
429         bool takeFee = true;
430 
431         //if any account belongs to isExcludedFromFee account then remove the fee
432         if (isExcludedFromFee[from] || isExcludedFromFee[to] || !feesStatus) {
433             takeFee = false;
434         }
435 
436         //transfer amount, it will take tax, burn, liquidity fee
437         _tokenTransfer(from, to, amount, takeFee);
438     }
439 
440     //this method is responsible for taking all fee, if takeFee is true
441     function _tokenTransfer(
442         address sender,
443         address recipient,
444         uint256 amount,
445         bool takeFee
446     ) private {
447         if (dexPair == sender && takeFee) {
448             uint256 allFee;
449             uint256 tTransferAmount; 
450                 allFee = totalBuyFeePerTx(amount);
451                 tTransferAmount = amount.sub(allFee); 
452 
453             _balances[sender] = _balances[sender].sub(
454                 amount,
455                 "Barbie: insufficient balance"
456             );
457             _balances[recipient] = _balances[recipient].add(tTransferAmount);
458             emit Transfer(sender, recipient, tTransferAmount);
459 
460             takeTokenFee(sender, allFee);
461         } else if (dexPair == recipient && takeFee) {
462             uint256 allFee = totalSellFeePerTx(amount);
463             uint256 tTransferAmount = amount.sub(allFee);
464             _balances[sender] = _balances[sender].sub(
465                 amount,
466                 "Barbie: insufficient balance"
467             );
468             _balances[recipient] = _balances[recipient].add(tTransferAmount);
469             emit Transfer(sender, recipient, tTransferAmount);
470 
471             takeTokenFee(sender, allFee); 
472         } else {
473             _balances[sender] = _balances[sender].sub(
474                 amount,
475                 "Barbie: insufficient balance"
476             );
477             _balances[recipient] = _balances[recipient].add(amount);
478             emit Transfer(sender, recipient, amount);
479         }
480     }
481 
482     function takeTokenFee(address sender, uint256 amount) private {
483         _balances[address(this)] = _balances[address(this)].add(amount);
484 
485         emit Transfer(sender, address(this), amount);
486     }
487  
488     // to withdarw ETH from contract
489     function withdrawETH(uint256 _amount) external onlyOwner {
490         require(address(this).balance >= _amount, "Invalid Amount");
491         payable(msg.sender).transfer(_amount);
492     }
493 
494     // to withdraw ERC20 tokens from contract
495     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
496         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
497         _token.transfer(msg.sender, _amount);
498     }
499     function distributeAndLiquify(address from, address to) private { 
500         uint256 contractTokenBalance = balanceOf(address(this));
501 
502         bool shouldSell = contractTokenBalance >= minTokenToSwap;
503 
504         if (
505             shouldSell &&
506             from != dexPair &&
507             distributeAndLiquifyStatus &&
508             !(from == address(this) && to == dexPair) // swap 1 time
509         ) {
510             // approve contract
511             _approve(address(this), address(dexRouter), minTokenToSwap);
512  
513 
514             // now is to lock into liquidty pool
515             Utils.swapTokensForEth(address(dexRouter), minTokenToSwap); 
516             uint256 ethForMarketing = address(this).balance;
517 
518             // sending Eth to Marketing wallet
519             if (ethForMarketing > 0) payable(marketingWallet).transfer(ethForMarketing);
520 
521            
522         }
523     }
524 }
525 
526 // Library for doing a swap on Dex
527 library Utils {
528     using SafeMath for uint256;
529 
530     function swapTokensForEth(address routerAddress, uint256 tokenAmount)
531         internal
532     {
533         IDexRouter dexRouter = IDexRouter(routerAddress);
534 
535         // generate the Dex pair path of token -> weth
536         address[] memory path = new address[](2);
537         path[0] = address(this);
538         path[1] = dexRouter.WETH();
539 
540         // make the swap
541         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
542             tokenAmount,
543             0, // accept any amount of ETH
544             path,
545             address(this),
546             block.timestamp + 300
547         );
548     }
549 
550     function addLiquidity(
551         address routerAddress,
552         address owner,
553         uint256 tokenAmount,
554         uint256 ethAmount
555     ) internal {
556         IDexRouter dexRouter = IDexRouter(routerAddress);
557 
558         // add the liquidity
559         dexRouter.addLiquidityETH{value: ethAmount}(
560             address(this),
561             tokenAmount,
562             0, // slippage is unavoidable
563             0, // slippage is unavoidable
564             owner,
565             block.timestamp + 300
566         );
567     }
568 }
569 
570 library SafeMath {
571     function add(uint256 a, uint256 b) internal pure returns (uint256) {
572         uint256 c = a + b;
573         require(c >= a, "SafeMath: addition overflow");
574 
575         return c;
576     }
577 
578     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
579         return sub(a, b, "SafeMath: subtraction overflow");
580     }
581 
582     function sub(
583         uint256 a,
584         uint256 b,
585         string memory errorMessage
586     ) internal pure returns (uint256) {
587         require(b <= a, errorMessage);
588         uint256 c = a - b;
589 
590         return c;
591     }
592 
593     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
594         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
595         // benefit is lost if 'b' is also tested.
596         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
597         if (a == 0) {
598             return 0;
599         }
600 
601         uint256 c = a * b;
602         require(c / a == b, "SafeMath: multiplication overflow");
603 
604         return c;
605     }
606 
607     function div(uint256 a, uint256 b) internal pure returns (uint256) {
608         return div(a, b, "SafeMath: division by zero");
609     }
610 
611     function div(
612         uint256 a,
613         uint256 b,
614         string memory errorMessage
615     ) internal pure returns (uint256) {
616         require(b > 0, errorMessage);
617         uint256 c = a / b;
618         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
619 
620         return c;
621     }
622 
623     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
624         return mod(a, b, "SafeMath: modulo by zero");
625     }
626 
627     function mod(
628         uint256 a,
629         uint256 b,
630         string memory errorMessage
631     ) internal pure returns (uint256) {
632         require(b != 0, errorMessage);
633         return a % b;
634     }
635 }