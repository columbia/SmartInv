1 //SPDX-License-Identifier: UNLICENSED  
2 
3 //Telegram: https://t.me/peperonintoken
4 //Website: https://peperonin.xyz
5 
6 pragma solidity ^0.8.8;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; 
14         return msg.data;
15     }
16 }
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 interface IERC20Metadata is IERC20 {
32     function name() external view returns (string memory);
33     function symbol() external view returns (string memory);
34     function decimals() external view returns (uint8);
35 }
36 contract ERC20 is Context, IERC20, IERC20Metadata {
37     mapping(address => uint256) internal _balances;
38     mapping(address => mapping(address => uint256)) internal _allowances;
39     uint256 private _totalSupply;
40     string private _name;
41     string private _symbol;
42 
43     constructor(string memory name_, string memory symbol_) {
44         _name = name_;
45         _symbol = symbol_;
46     }
47     function name() public view virtual override returns (string memory) {
48         return _name;
49     }
50     function symbol() public view virtual override returns (string memory) {
51         return _symbol;
52     }
53     function decimals() public view virtual override returns (uint8) {
54         return 18;
55     }
56     function totalSupply() public view virtual override returns (uint256) {
57         return _totalSupply;
58     }
59     function balanceOf(address account) public view virtual override returns (uint256) {
60         return _balances[account];
61     }
62     function transfer(address recipient, uint256 amount)
63         public
64         virtual
65         override
66         returns (bool)
67     {
68         _transfer(_msgSender(), recipient, amount);
69         return true;
70     }
71     function allowance(address owner, address spender)
72         public
73         view
74         virtual
75         override
76         returns (uint256)
77     {
78         return _allowances[owner][spender];
79     }
80     function approve(address spender, uint256 amount) public virtual override returns (bool) {
81         _approve(_msgSender(), spender, amount);
82         return true;
83     }
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) public virtual override returns (bool) {
89         _transfer(sender, recipient, amount);
90 
91         uint256 currentAllowance = _allowances[sender][_msgSender()];
92         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
93         _approve(sender, _msgSender(), currentAllowance - amount);
94 
95         return true;
96     }
97     function increaseAllowance(address spender, uint256 addedValue)
98         public
99         virtual
100         returns (bool)
101     {
102         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
103         return true;
104     }
105     function decreaseAllowance(address spender, uint256 subtractedValue)
106         public
107         virtual
108         returns (bool)
109     {
110         uint256 currentAllowance = _allowances[_msgSender()][spender];
111         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
112         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
113 
114         return true;
115     }
116     function _transfer(
117         address sender,
118         address recipient,
119         uint256 amount
120     ) internal virtual {
121         require(sender != address(0), "ERC20: transfer from the zero address");
122         require(recipient != address(0), "ERC20: transfer to the zero address");
123 
124         uint256 senderBalance = _balances[sender];
125         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
126         _balances[sender] = senderBalance - amount;
127         _balances[recipient] += amount;
128 
129         emit Transfer(sender, recipient, amount);
130     }
131     function _tokengeneration(address account, uint256 amount) internal virtual {
132         _totalSupply = amount;
133         _balances[account] = amount;
134         emit Transfer(address(0), account, amount);
135     }
136     function _approve(
137         address owner,
138         address spender,
139         uint256 amount
140     ) internal virtual {
141         require(owner != address(0), "ERC20: approve from the zero address");
142         require(spender != address(0), "ERC20: approve to the zero address");
143 
144         _allowances[owner][spender] = amount;
145         emit Approval(owner, spender, amount);
146     }
147 }
148 library Address {
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         (bool success, ) = recipient.call{ value: amount }("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 }
156 abstract contract Ownable is Context {
157     address private _owner;
158     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159     constructor() {
160         _setOwner(_msgSender());
161     }
162     function owner() public view virtual returns (address) {
163         return _owner;
164     }
165     modifier onlyOwner() {
166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
167         _;
168     }
169     function renounceOwnership() public virtual onlyOwner {
170         _setOwner(address(0));
171     }
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         _setOwner(newOwner);
175     }
176     function _setOwner(address newOwner) private {
177         address oldOwner = _owner;
178         _owner = newOwner;
179         emit OwnershipTransferred(oldOwner, newOwner);
180     }
181 }
182 interface IFactory {
183     function createPair(address tokenA, address tokenB) external returns (address pair);
184 }
185 interface IRouter {
186     function factory() external pure returns (address);
187 
188     function WETH() external pure returns (address);
189 
190     function addLiquidityETH(
191         address token,
192         uint256 amountTokenDesired,
193         uint256 amountTokenMin,
194         uint256 amountETHMin,
195         address to,
196         uint256 deadline
197     )
198         external
199         payable
200         returns (
201             uint256 amountToken,
202             uint256 amountETH,
203             uint256 liquidity
204         );
205     function swapExactTokensForETHSupportingFeeOnTransferTokens(
206         uint256 amountIn,
207         uint256 amountOutMin,
208         address[] calldata path,
209         address to,
210         uint256 deadline
211     ) external;
212 }
213 contract PepeRonin is ERC20, Ownable {
214     using Address for address payable;
215     IRouter public router;
216     address public pair;
217      bool private _interlock = false;
218     bool public providingLiquidity = false;
219     bool public tradingEnabled = false;
220     uint256 public tokenLiquidityThreshold = 5e5 * 10**18;
221     uint256 public maxBuyLimit = 2e6 * 10**18;
222     uint256 public maxSellLimit = 2e6 * 10**18;
223     uint256 public maxWalletLimit = 2e6 * 10**18;
224     uint256 public genesis_block;
225     uint256 private deadline = 3;
226     uint256 private launchtax = 96;
227     address public marketingWallet = 0x1d863f5a66718F079b07175A9220470Dea348fD0; 
228     address public devWallet = 0x37fcc496Cc6CA778DE528f4939e6c9b0f7bfeAe6;
229     address public bbWallet = 0x37fcc496Cc6CA778DE528f4939e6c9b0f7bfeAe6;
230     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
231 
232     struct Taxes {
233         uint256 marketing;
234         uint256 liquidity;
235         uint256 bb;
236         uint256 dev;
237     }
238 
239     Taxes public taxes = Taxes(15, 0, 0, 15);
240     Taxes public sellTaxes = Taxes(15, 0, 0, 15);
241     mapping(address => bool) public exemptFee;
242     mapping(address => uint256) private _lastSell;
243     bool public coolDownEnabled = true;
244     uint256 public coolDownTime = 5 seconds;
245     modifier lockTheSwap() {
246         if (!_interlock) {
247             _interlock = true;
248             _;
249             _interlock = false;
250         }
251     }
252     constructor() ERC20("PepeRonin", "PEPERON") {
253         _tokengeneration(msg.sender, 1e8 * 10**decimals());
254         exemptFee[msg.sender] = true;
255         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
256         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
257         router = _router;
258         pair = _pair;
259         exemptFee[address(this)] = true;
260         exemptFee[marketingWallet] = true;
261         exemptFee[bbWallet] = true;
262         exemptFee[devWallet] = true;
263         exemptFee[deadWallet] = true;
264         exemptFee[0xD152f549545093347A162Dce210e7293f1452150] = true;
265 
266     }
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public override returns (bool) {
276         _transfer(sender, recipient, amount);
277         uint256 currentAllowance = _allowances[sender][_msgSender()];
278         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
279         _approve(sender, _msgSender(), currentAllowance - amount);
280 
281         return true;
282     }
283     function increaseAllowance(address spender, uint256 addedValue)
284         public
285         override
286         returns (bool)
287     {
288         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
289         return true;
290     }
291     function decreaseAllowance(address spender, uint256 subtractedValue)
292         public
293         override
294         returns (bool)
295     {
296         uint256 currentAllowance = _allowances[_msgSender()][spender];
297         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
298         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
299 
300         return true;
301     }
302     function transfer(address recipient, uint256 amount) public override returns (bool) {
303         _transfer(msg.sender, recipient, amount);
304         return true;
305     }
306     function _transfer(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) internal override {
311         require(amount > 0, "Transfer amount must be greater than zero");
312         if (!exemptFee[sender] && !exemptFee[recipient]) {
313             require(tradingEnabled, "Trading not enabled");
314         }
315         if (sender == pair && !exemptFee[recipient] && !_interlock) {
316             require(amount <= maxBuyLimit, "You are exceeding maxBuyLimit");
317             require(
318                 balanceOf(recipient) + amount <= maxWalletLimit,
319                 "You are exceeding maxWalletLimit"
320             );
321         }
322         if (
323             sender != pair && !exemptFee[recipient] && !exemptFee[sender] && !_interlock
324         ) {
325             require(amount <= maxSellLimit, "You are exceeding maxSellLimit");
326             if (recipient != pair) {
327                 require(
328                     balanceOf(recipient) + amount <= maxWalletLimit,
329                     "You are exceeding maxWalletLimit"
330                 );
331             }
332             if (coolDownEnabled) {
333                 uint256 timePassed = block.timestamp - _lastSell[sender];
334                 require(timePassed >= coolDownTime, "Cooldown enabled");
335                 _lastSell[sender] = block.timestamp;
336             }
337         }
338         uint256 feeswap;
339         uint256 feesum;
340         uint256 fee;
341         Taxes memory currentTaxes;
342         bool useLaunchFee = !exemptFee[sender] &&
343             !exemptFee[recipient] &&
344             block.number < genesis_block + deadline;
345         if (_interlock || exemptFee[sender] || exemptFee[recipient])
346             fee = 0;
347 
348         else if (recipient == pair && !useLaunchFee) {
349             feeswap =
350                 sellTaxes.liquidity +
351                 sellTaxes.marketing +
352                 sellTaxes.bb +            
353                 sellTaxes.dev;
354             feesum = feeswap;
355             currentTaxes = sellTaxes;
356         } else if (!useLaunchFee) {
357             feeswap =
358                 taxes.liquidity +
359                 taxes.marketing +
360                 taxes.bb +
361                 taxes.dev ;
362             feesum = feeswap;
363             currentTaxes = taxes;
364         } else if (useLaunchFee) {
365             feeswap = launchtax;
366             feesum = launchtax;
367         }
368         fee = (amount * feesum) / 100;
369         if (providingLiquidity && sender != pair) Liquify(feeswap, currentTaxes);
370          super._transfer(sender, recipient, amount - fee);
371         if (fee > 0) {
372 
373             if (feeswap > 0) {
374                 uint256 feeAmount = (amount * feeswap) / 100;
375                 super._transfer(sender, address(this), feeAmount);
376             }
377 
378         }
379     }
380     function Liquify(uint256 feeswap, Taxes memory swapTaxes) private lockTheSwap {
381         if(feeswap == 0){
382             return;
383         }
384         uint256 contractBalance = balanceOf(address(this));
385         if (contractBalance >= tokenLiquidityThreshold) {
386             if (tokenLiquidityThreshold > 1) {
387                 contractBalance = tokenLiquidityThreshold;
388             }
389          uint256 denominator = feeswap * 2;
390             uint256 tokensToAddLiquidityWith = (contractBalance * swapTaxes.liquidity) /
391                 denominator;
392             uint256 toSwap = contractBalance - tokensToAddLiquidityWith;
393             uint256 initialBalance = address(this).balance;
394             swapTokensForETH(toSwap);
395             uint256 deltaBalance = address(this).balance - initialBalance;
396             uint256 unitBalance = deltaBalance / (denominator - swapTaxes.liquidity);
397             uint256 ethToAddLiquidityWith = unitBalance * swapTaxes.liquidity;
398             if (ethToAddLiquidityWith > 0) {
399           addLiquidity(tokensToAddLiquidityWith, ethToAddLiquidityWith);
400             }
401             uint256 marketingAmt = unitBalance * 2 * swapTaxes.marketing;
402             if (marketingAmt > 0) {
403                 payable(marketingWallet).sendValue(marketingAmt);
404             }
405             uint256 bbAmt = unitBalance * 2 * swapTaxes.bb;
406             if (bbAmt > 0) {
407                 payable(bbWallet).sendValue(bbAmt);
408             }
409             uint256 devAmt = unitBalance * 2 * swapTaxes.dev;
410             if (devAmt > 0) {
411                 payable(devWallet).sendValue(devAmt);
412             }
413 
414         }
415     }
416     function swapTokensForETH(uint256 tokenAmount) private {
417         address[] memory path = new address[](2);
418         path[0] = address(this);
419         path[1] = router.WETH();
420         _approve(address(this), address(router), tokenAmount);
421         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
422             tokenAmount,
423             0,
424             path,
425             address(this),
426             block.timestamp
427         );
428     }
429     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
430       _approve(address(this), address(router), tokenAmount);
431         router.addLiquidityETH{ value: ethAmount }(
432             address(this),
433             tokenAmount,
434             0,
435             0,
436             deadWallet,
437             block.timestamp
438         );
439     }
440     function updateLiquidityProvide(bool state) external onlyOwner {
441          providingLiquidity = state;
442     }
443     function updateLiquidityTreshhold(uint256 new_amount) external onlyOwner {
444         require(new_amount <= 1e6, "Swap threshold amount should be lower or equal to 1% of tokens");
445         tokenLiquidityThreshold = new_amount * 10**decimals();
446     }
447     function SetBuyTaxes(
448         uint256 _marketing,
449         uint256 _liquidity,
450         uint256 _bb,
451         uint256 _dev
452     ) external onlyOwner {
453         taxes = Taxes(_marketing, _liquidity,  _bb, _dev);
454         require((_marketing + _liquidity + _bb + _dev) <= 35, "Must keep fees at 35% or less");
455     }
456     function SetSellTaxes(
457         uint256 _marketing,
458         uint256 _liquidity,
459         uint256 _bb,
460         uint256 _dev
461     ) external onlyOwner {
462         sellTaxes = Taxes(_marketing, _liquidity,  _bb,  _dev);
463         require((_marketing + _liquidity + _bb + _dev) <= 35, "Must keep fees at 35% or less");
464     }
465     function EnableTrading() external onlyOwner {
466         require(!tradingEnabled, "Cannot re-enable trading");
467         tradingEnabled = true;
468         providingLiquidity = true;
469         genesis_block = block.number;
470     }
471     function updatedeadline(uint256 _deadline) external onlyOwner {
472         require(!tradingEnabled, "Can't change when trading has started");
473         require(_deadline < 5,"Deadline should be less than 5 Blocks");
474         deadline = _deadline;
475     }
476     function updateMarketingWallet(address newWallet) external onlyOwner {
477         require(newWallet != address(0),"Fee Address cannot be zero address");
478         marketingWallet = newWallet;
479     }
480     function updateBbWallet(address newWallet) external onlyOwner {
481         require(newWallet != address(0),"Fee Address cannot be zero address");
482         bbWallet = newWallet;
483     }
484     function updateDevWallet(address newWallet) external onlyOwner {
485         require(newWallet != address(0),"Fee Address cannot be zero address");
486         devWallet = newWallet;
487     }
488     function updateCooldown(bool state, uint256 time) external onlyOwner {
489         coolDownTime = time * 1 seconds;
490         coolDownEnabled = state;
491         require(time <= 300, "cooldown timer cannot exceed 5 minutes");
492     }
493     function updateExemptFee(address _address, bool state) external onlyOwner {
494         exemptFee[_address] = state;
495     }
496     function bulkExemptFee(address[] memory accounts, bool state) external onlyOwner {
497         for (uint256 i = 0; i < accounts.length; i++) {
498             exemptFee[accounts[i]] = state;
499         }
500     }
501     function updateMaxTxLimit(uint256 maxBuy, uint256 maxSell, uint256 maxWallet) external onlyOwner {
502         require(maxBuy >= 1e6, "Cannot set max buy amount lower than 1%");
503         require(maxSell >= 1e6, "Cannot set max sell amount lower than 1%");
504         require(maxWallet >= 1e6, "Cannot set max wallet amount lower than 1%");
505         maxBuyLimit = maxBuy * 10**decimals();
506         maxSellLimit = maxSell * 10**decimals();
507         maxWalletLimit = maxWallet * 10**decimals(); 
508     }
509     function rescueETH() external onlyOwner {
510         uint256 contractETHBalance = address(this).balance;
511         payable(owner()).transfer(contractETHBalance);
512     }
513     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
514         require(tokenAdd != address(this), "Owner can't claim contract's balance of its own tokens");
515         IERC20(tokenAdd).transfer(owner(), amount);
516     }
517      receive() external payable {}
518 }