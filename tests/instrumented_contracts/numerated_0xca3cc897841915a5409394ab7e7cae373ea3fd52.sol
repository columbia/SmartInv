1 /**
2     Website: https://upserc.vip
3     TG: https://t.me/upserc           
4     Twitter: https://twitter.com/UPS_COIN_ETH
5 */
6 
7 //SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.19;
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns (bool);
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 interface IERC20Metadata is IERC20 {
40     function name() external view returns (string memory);
41     function symbol() external view returns (string memory);
42     function decimals() external view returns (uint8);
43 }
44 
45 contract ERC20 is Context, IERC20, IERC20Metadata {
46     mapping(address => uint256) internal _balances;
47     mapping(address => mapping(address => uint256)) internal _allowances;
48 
49     uint256 private _totalSupply;
50 
51     string private _name;
52     string private _symbol;
53 
54     constructor(string memory name_, string memory symbol_) {
55         _name = name_;
56         _symbol = symbol_;
57     }
58 
59     function name() public view virtual override returns (string memory) {
60         return _name;
61     }
62 
63     function symbol() public view virtual override returns (string memory) {
64         return _symbol;
65     }
66 
67     function decimals() public view virtual override returns (uint8) {
68         return 18;
69     }
70 
71     function totalSupply() public view virtual override returns (uint256) {
72         return _totalSupply;
73     }
74 
75     function balanceOf(address account) public view virtual override returns (uint256) {
76         return _balances[account];
77     }
78 
79     function transfer(address recipient, uint256 amount)
80         public
81         virtual
82         override
83         returns (bool)
84     {
85         _transfer(_msgSender(), recipient, amount);
86         return true;
87     }
88 
89     function allowance(address owner, address spender)
90         public
91         view
92         virtual
93         override
94         returns (uint256)
95     {
96         return _allowances[owner][spender];
97     }
98 
99     function approve(address spender, uint256 amount) public virtual override returns (bool) {
100         _approve(_msgSender(), spender, amount);
101         return true;
102     }
103 
104     function transferFrom(
105         address sender,
106         address recipient,
107         uint256 amount
108     ) public virtual override returns (bool) {
109         _transfer(sender, recipient, amount);
110 
111         uint256 currentAllowance = _allowances[sender][_msgSender()];
112         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
113         _approve(sender, _msgSender(), currentAllowance - amount);
114 
115         return true;
116     }
117 
118     function increaseAllowance(address spender, uint256 addedValue)
119         public
120         virtual
121         returns (bool)
122     {
123         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
124         return true;
125     }
126 
127     function decreaseAllowance(address spender, uint256 subtractedValue)
128         public
129         virtual
130         returns (bool)
131     {
132         uint256 currentAllowance = _allowances[_msgSender()][spender];
133         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
134         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
135 
136         return true;
137     }
138 
139     function _transfer(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) internal virtual {
144         require(sender != address(0), "ERC20: transfer from the zero address");
145         require(recipient != address(0), "ERC20: transfer to the zero address");
146 
147         _beforeTokenTransfer(sender, recipient, amount);
148 
149         uint256 senderBalance = _balances[sender];
150         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
151         _balances[sender] = senderBalance - amount;
152         _balances[recipient] += amount;
153 
154         emit Transfer(sender, recipient, amount);
155     }
156 
157     function _tokengeneration(address account, uint256 amount) internal virtual {
158         require(account != address(0), "ERC20: generation to the zero address");
159 
160         _beforeTokenTransfer(address(0), account, amount);
161 
162         _totalSupply = amount;
163         _balances[account] = amount;
164         emit Transfer(address(0), account, amount);
165     }
166 
167     function _approve(
168         address owner,
169         address spender,
170         uint256 amount
171     ) internal virtual {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174 
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     function _beforeTokenTransfer(
180         address from,
181         address to,
182         uint256 amount
183     ) internal virtual {}
184 }
185 
186 library Address {
187     function sendValue(address payable recipient, uint256 amount) internal {
188         require(address(this).balance >= amount, "Address: insufficient balance");
189 
190         (bool success, ) = recipient.call{ value: amount }("");
191         require(success, "Address: unable to send value, recipient may have reverted");
192     }
193 }
194 
195 abstract contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     constructor() {
201         _setOwner(_msgSender());
202     }
203 
204     function owner() public view virtual returns (address) {
205         return _owner;
206     }
207 
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     function renounceOwnership() public virtual onlyOwner {
214         _setOwner(address(0));
215     }
216 
217     function transferOwnership(address newOwner) public virtual onlyOwner {
218         require(newOwner != address(0), "Ownable: new owner is the zero address");
219         _setOwner(newOwner);
220     }
221 
222     function _setOwner(address newOwner) private {
223         address oldOwner = _owner;
224         _owner = newOwner;
225         emit OwnershipTransferred(oldOwner, newOwner);
226     }
227 }
228 
229 interface IFactory {
230     function createPair(address tokenA, address tokenB) external returns (address pair);
231 }
232 
233 interface uniswapV2Router {
234     function factory() external pure returns (address);
235     function WETH() external pure returns (address);
236 
237     function addLiquidityETH(
238         address token,
239         uint256 amountTokenDesired,
240         uint256 amountTokenMin,
241         uint256 amountETHMin,
242         address to,
243         uint256 deadline
244     )
245         external
246         payable
247         returns (
248             uint256 amountToken,
249             uint256 amountETH,
250             uint256 liquidity
251         );
252 
253     function swapExactTokensForETHSupportingFeeOnTransferTokens(
254         uint256 amountIn,
255         uint256 amountOutMin,
256         address[] calldata path,
257         address to,
258         uint256 deadline
259     ) external;
260 }
261 
262 contract UPS is ERC20, Ownable {
263     using Address for address payable;
264     uniswapV2Router public IUniswapV2Router02;
265     address public uniswapV2Pair;
266     bool private _liquidityMutex = false;
267     bool private  providingLiquidity = false;
268     bool public tradingEnabled = false;
269 
270     uint256 private ThresholdAmt = 5e7 * 10**18;
271     uint256 public maxWalletLimit = 1e7 * 10**18;
272     uint256 private TxlimitFree = 1e9;
273     uint256 private CA_sell_After_launch = 25e5;
274     
275     uint256 private  genesis_block;
276     uint256 private deadline = 3;
277     uint256 private launchtax = 99;
278 
279     address private  marketingWallet = 0xC16A689e0E237CcC548bd367bFaa62240C1c8B67;
280     address private devWallet = 0xC16A689e0E237CcC548bd367bFaa62240C1c8B67;
281     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
282 
283     struct Taxes {
284         uint256 marketing;
285         uint256 liquidity;
286         uint256 dev;   
287     }
288 
289     Taxes public buytaxes = Taxes(2, 0, 1);
290     Taxes public sellTaxes = Taxes(2, 0, 1);
291 
292     mapping(address => bool) public exemptFee;
293     mapping(address => bool) private isBots;
294 
295     modifier mutexLock() {
296         if (!_liquidityMutex) {
297             _liquidityMutex = true;
298             _;
299             _liquidityMutex = false;
300         }
301     }
302 
303     constructor() ERC20("Unvaccinated Penis Sperm", "UPS") {
304         _tokengeneration(msg.sender, 1e9 * 10**decimals());
305         uniswapV2Router _router = uniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306       
307         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
308         IUniswapV2Router02 = _router;
309         uniswapV2Pair = _pair;
310         exemptFee[address(this)] = true;
311         exemptFee[msg.sender] = true;
312         exemptFee[marketingWallet] = true;
313         exemptFee[devWallet] = true;
314         exemptFee[deadWallet] = true;
315         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
316 
317     }
318 
319     function approve(address spender, uint256 amount) public override returns (bool) {
320         _approve(_msgSender(), spender, amount);
321         return true;
322     }
323 
324     function transferFrom(
325         address sender,
326         address recipient,
327         uint256 amount
328     ) public override returns (bool) {
329         _transfer(sender, recipient, amount);
330 
331         uint256 currentAllowance = _allowances[sender][_msgSender()];
332         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
333         _approve(sender, _msgSender(), currentAllowance - amount);
334 
335         return true;
336     }
337 
338     function increaseAllowance(address spender, uint256 addedValue)
339         public
340         override
341         returns (bool)
342     {
343         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
344         return true;
345     }
346 
347     function decreaseAllowance(address spender, uint256 subtractedValue)
348         public
349         override
350         returns (bool)
351     {
352         uint256 currentAllowance = _allowances[_msgSender()][spender];
353         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
354         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
355 
356         return true;
357     }
358 
359     function transfer(address recipient, uint256 amount) public override returns (bool) {
360         _transfer(msg.sender, recipient, amount);
361         return true;
362     }
363 
364     function _transfer(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) internal override {
369         require(amount > 0, "Transfer amount must be greater than zero");
370         require(!isBots[sender] && !isBots[recipient], "You can't transfer tokens");
371 
372         if (!exemptFee[sender] && !exemptFee[recipient]) {
373             require(tradingEnabled, "Trading not enabled");
374         }
375 
376         if (sender == uniswapV2Pair && !exemptFee[recipient] && !_liquidityMutex) {
377             require(balanceOf(recipient) + amount <= maxWalletLimit,
378                 "You are exceeding maxWalletLimit"
379             );
380         }
381 
382         if (sender != uniswapV2Pair && !exemptFee[recipient] && !exemptFee[sender] && !_liquidityMutex) {
383            
384             if (recipient != uniswapV2Pair) {
385                 require(balanceOf(recipient) + amount <= maxWalletLimit,
386                     "You are exceeding maxWalletLimit"
387                 );
388             }
389         }
390 
391         uint256 feeswap;
392         uint256 feesum;
393         uint256 fee;
394         Taxes memory currentTaxes;
395         bool useLaunchFee = !exemptFee[sender] && !exemptFee[recipient] && block.number < genesis_block + deadline;
396         if (_liquidityMutex || exemptFee[sender] || exemptFee[recipient])
397             fee = 0;
398 
399         else if (recipient == uniswapV2Pair && !useLaunchFee) {
400             feeswap = sellTaxes.liquidity + sellTaxes.marketing + sellTaxes.dev ;
401             feesum = feeswap;
402             currentTaxes = sellTaxes;
403         } else if (!useLaunchFee) {
404             feeswap = buytaxes.liquidity + buytaxes.marketing + buytaxes.dev ;
405             feesum = feeswap;
406             currentTaxes = buytaxes;
407         } else if (useLaunchFee) {
408             feeswap = launchtax;
409             feesum = launchtax;
410         }
411 
412         fee = (amount * feesum) / 100;
413 
414         if (providingLiquidity && sender != uniswapV2Pair) SwapBack(feeswap, currentTaxes);
415 
416         super._transfer(sender, recipient, amount - fee);
417         if (fee > 0) {
418            
419             if (feeswap > 0) {
420                 uint256 feeAmount = (amount * feeswap) / 100;
421                 super._transfer(sender, address(this), feeAmount);
422             }
423 
424         }
425     }
426 
427     function SwapBack(uint256 feeswap, Taxes memory swapTaxes) private mutexLock {
428     if(feeswap == 0){
429             return;
430         }   
431 
432         uint256 contractBalance = balanceOf(address(this));
433         if (contractBalance >= ThresholdAmt) {
434             if (ThresholdAmt > 1) {
435                 contractBalance = ThresholdAmt;
436             }
437 
438             uint256 denominator = feeswap * 2;
439             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /  denominator;
440             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
441             uint256 initialBalance = address(this).balance;
442 
443             swapTokensForETH(toSwap);
444 
445             uint256 deltaBalance = address(this).balance - initialBalance;
446             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
447             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
448             if (ethToAddLiquidityWith > 0) {
449                 addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
450             }
451             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
452             if (marketingAmt > 0) {
453                 payable(marketingWallet).sendValue(marketingAmt);
454             }
455             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
456             if (devAmt > 0) {
457                 payable(devWallet).sendValue(devAmt);
458             }
459 
460         }
461     }
462 
463     function swapTokensForETH(uint256 tokenAmount) private {
464         address[] memory path = new address[](2);
465         path[0] = address(this);
466         path[1] = IUniswapV2Router02.WETH();
467         _approve(address(this), address(IUniswapV2Router02), tokenAmount);
468         IUniswapV2Router02.swapExactTokensForETHSupportingFeeOnTransferTokens(
469             tokenAmount,
470             0,
471             path,
472             address(this),
473             block.timestamp
474         );
475     }
476 
477     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
478         _approve(address(this), address(IUniswapV2Router02), tokenAmount);
479         IUniswapV2Router02.addLiquidityETH{ value: ethAmount }(
480             address(this),
481             tokenAmount,
482             0, // slippage is unavoidable
483             0, // slippage is unavoidable
484             deadWallet,
485             block.timestamp
486         );
487     }
488 
489     function enableSwapBackSetting(bool state) external onlyOwner {
490         providingLiquidity = state;
491     }
492 
493     function setTreshholdAmount(uint256 new_amount) external onlyOwner {
494         ThresholdAmt = new_amount * 10**18;
495     }
496 
497     function BuyFees(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner {
498         buytaxes = Taxes(_marketing, _liquidity, _dev);
499      require((_marketing +  _liquidity + _dev) <= 40, "Must keep fees at 40% or less");
500     }
501 
502     function SellFees(uint256 _marketing, uint256 _liquidity, uint256 _dev) external onlyOwner {
503         sellTaxes = Taxes(_marketing, _liquidity, _dev);
504       require((_marketing +  _liquidity + _dev) <= 40, "Must keep fees at 40% or less");
505     }
506 
507    function go_live() external onlyOwner {
508         require(!tradingEnabled, "Trading is already enabled");
509         tradingEnabled = true;
510         providingLiquidity = true;
511         genesis_block = block.number;
512     }
513     
514     function setBotBlock(uint256 _deadline) external onlyOwner {
515         require(!tradingEnabled, "Can't change when trading has started");
516         require(_deadline <= 3, "Block should be less than or equal to 3");
517         deadline = _deadline;
518     }
519     
520    function setMarketingWallet(address _newAddr) external onlyOwner {
521         require(_newAddr != address(0),"Fee Address cannot be zero address");
522         require(_newAddr != address(this),"Fee Addy cannot be CA");
523         marketingWallet = _newAddr;
524         exemptFee[_newAddr] = true;
525     }
526 
527     function setDevWallet(address _newAddr) external onlyOwner {
528         require(_newAddr != address(0),"Fee Address cannot be zero address");
529         require(_newAddr != address(this),"Fee Addy cannot be CA");
530         devWallet = _newAddr;
531         exemptFee[_newAddr] = true;
532     }
533 
534     function blaclistWallet(address account) external onlyOwner {
535         isBots[account] = true;
536     }
537 
538    function unblaclistWallet(address account) external onlyOwner {
539         isBots[account] = false;
540     }
541 
542     function ExcludeFromFee(address _address) external onlyOwner {
543         exemptFee[_address] = true;
544     }
545 
546     function includeFromFee(address _address) external onlyOwner {
547         exemptFee[_address] = false;
548     }
549     
550      function ReduceTreshhold() external onlyOwner {
551         ThresholdAmt = CA_sell_After_launch * 10**18;
552     }
553 
554      function removeLimit() external onlyOwner {
555         maxWalletLimit = TxlimitFree * 10**18; 
556     }
557 
558      function UpdateMaxTxLimit(uint256 maxWallet) external onlyOwner {
559         maxWalletLimit = maxWallet * 10**18; 
560     }
561     
562     function rescueETH() external {
563         uint256 contractETHBalance = address(this).balance;
564         require(contractETHBalance > 0, "Amount should be greater than zero");
565         payable(marketingWallet).transfer(contractETHBalance);
566     }
567 
568     function rescueERC20(address _tokenAddy, uint256 _amount) external {
569         require(_tokenAddy != address(this), "Owner can't claim contract's balance of its own tokens");
570         require(_amount > 0, "Amount should be greater than zero");
571         require(_amount <= IERC20(_tokenAddy).balanceOf(address(this)), "Insufficient Amount");
572         IERC20(_tokenAddy).transfer(marketingWallet, _amount);
573     }
574     // fallbacks
575     receive() external payable {}
576 }