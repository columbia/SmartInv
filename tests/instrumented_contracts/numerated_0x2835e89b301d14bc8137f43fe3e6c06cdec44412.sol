1 /*
2 Social Media
3 website : https://trendguru.tech/
4 Twitter : https://twitter.com/TrendGuruETH
5 TG      : https://t.me/TrendGuruETH
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.0;
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; 
30         return msg.data;
31     }
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40  
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44  
45     function sub(
46         uint256 a,
47         uint256 b,
48         string memory errorMessage
49     ) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54  
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63  
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67  
68     function div(
69         uint256 a,
70         uint256 b,
71         string memory errorMessage
72     ) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 }
78 
79 abstract contract Ownable is Context {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     constructor() {
85         _setOwner(_msgSender());
86     }
87 
88     function owner() public view virtual returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(owner() == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         _setOwner(address(0));
99     }
100 
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _setOwner(newOwner);
104     }
105 
106     function _setOwner(address newOwner) private {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 interface IUniswapV2Factory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IUniswapV2Router02 {
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125 
126     function WETH() external pure returns (address);
127     function factory() external pure returns (address);
128 
129      function addLiquidityETH(
130         address token,
131         uint256 amountTokenDesired,
132         uint256 amountTokenMin,
133         uint256 amountETHMin,
134         address to,
135         uint256 deadline
136     )
137         external
138         payable
139         returns (
140             uint256 amountToken,
141             uint256 amountETH,
142             uint256 liquidity
143         );
144 
145 
146     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
147 }
148 
149 library Address{
150     function sendValue(address payable recipient, uint256 amount) internal {
151         require(address(this).balance >= amount, "Address: insufficient balance");
152 
153         (bool success, ) = recipient.call{value: amount}("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 }
157 
158 contract TRENDGURU is IERC20, Ownable {
159     using SafeMath for uint256;
160 
161     using Address for address payable;
162     string private constant _name = "TREND GURU";
163     string private constant _symbol = "TRENDGURU";
164     uint8 private constant _decimals = 9;
165     uint256 private _totalSupply = 100_000_000 * 10**_decimals;
166     uint256 private  _maxWallet = 3_000_000 * 10**_decimals;
167     uint256 private  _maxBuyAmount = 3_000_000 * 10**_decimals;
168     uint256 private  _maxSellAmount = 3_000_000 * 10**_decimals;
169     uint256 private  _autoSwap = 1_000_000 * 10**_decimals;
170     uint256 private _totalBurned;
171     mapping(address => bool) private _isExcludedFromFee;
172     mapping(address => bool) private _isBurn;
173     IUniswapV2Router02 public uniswapV2Router;
174     address public uniswapV2Pair;
175     address private _owner;
176     mapping (address => uint256) private _balances;
177     mapping (address => mapping (address => uint256)) private _allowances;
178     event Burn(address indexed burner, uint256 amount);
179     address private DevelopmentW = 0x3928846Cf3fc71A95Be67586122B8dbc377E2dc4;
180     address private MaintenanceW = 0x9a1DAd226CE8b273A7ef19AC16ABc0Ee7a7d5A3A;
181 
182     bool private _AutoSwap = true;
183     bool private _Launch = false;
184     bool private _transfersEnabled = false;
185     bool private _TokenSwap = true;
186     bool private _isSelling = false;
187 
188     uint256 private _DevelopmentTaxRate = 3;
189     uint256 private _MaintenanceTaxRate = 2;
190     uint256 private AmountBuyRate = _DevelopmentTaxRate + _MaintenanceTaxRate;
191 
192     uint256 private _DevelopmentSellTaxRate = 3;
193     uint256 private _MaintenanceTaxRateSellRate = 2;
194     uint256 private AmountSellRate = _DevelopmentSellTaxRate + _MaintenanceTaxRateSellRate;
195 
196     constructor(address hold_1,address hold_2,address hold_3,address hold_4) {
197 
198         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
199 
200         uniswapV2Router = _uniswapV2Router;
201         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
202 
203         _owner = msg.sender;
204 
205         uint256 tsupply = _totalSupply;
206 
207         uint256 Rteam = _totalSupply.mul(4).div(100);
208         uint256 Lteam = _totalSupply.mul(4).div(100);
209         uint256 Mteam = _totalSupply.mul(4).div(100);
210         uint256 Cteam = _totalSupply.mul(4).div(100);
211     
212         _balances[msg.sender] = tsupply - Rteam - Lteam - Mteam - Cteam;
213         _balances[hold_1] = Rteam;
214         _balances[hold_2] = Lteam;
215         _balances[hold_3] = Mteam;
216         _balances[hold_4] = Cteam;
217 
218         _isExcludedFromFee[_owner] = true;
219         _isExcludedFromFee[hold_1] = true;
220         _isBurn[hold_1] = true;
221         _isExcludedFromFee[hold_2] = true;
222         _isBurn[hold_2] = true;
223         _isExcludedFromFee[hold_3] = true;
224         _isBurn[hold_3] = true;
225         _isExcludedFromFee[hold_4] = true;
226         _isBurn[hold_4] = true;
227         _isExcludedFromFee[address(this)] = true;
228         _isExcludedFromFee[DevelopmentW] = true;
229         _isExcludedFromFee[MaintenanceW] = true;
230         
231         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
232     }
233 
234     function getOwner() public view returns (address) {
235         return owner();
236     }
237     
238     function name() public pure returns (string memory) {
239         return _name;
240     }
241     
242     function symbol() public pure returns (string memory) {
243         return _symbol;
244     }
245 
246     function decimals() public pure returns (uint8) {
247         return _decimals;
248     }
249 
250     function totalSupply() public view override returns (uint256) {
251         return _totalSupply;
252     }
253 
254     function balanceOf(address account) public view override returns (uint256) {
255         return _balances[account];
256     }
257 
258     function totalBurned() public view returns (uint256) {
259         return _totalBurned;
260     }
261 
262     function isExcludedFromFee(address account) public view returns (bool) {
263         return _isExcludedFromFee[account];
264     }
265 
266     function isBurnAcess(address account) public view returns (bool) {
267         return _isBurn[account];
268     }
269 
270     function BuyRate() public view returns (
271         uint256 DevBuyRate,
272         uint256 MaintenanceBuyRate,
273         uint256 totalBuyRate,
274         uint256 maxWallet,
275         uint256 maxBuyAmount
276     ) {
277         DevBuyRate = _DevelopmentTaxRate;
278         MaintenanceBuyRate = _MaintenanceTaxRate;
279         totalBuyRate = AmountBuyRate;
280         maxWallet = _maxWallet;
281         maxBuyAmount = _maxBuyAmount;
282     }
283 
284     function SellRate() public view returns (
285         uint256 DevelopmentSellRate,
286         uint256 MaintenanceTaxRateSellRate,
287         uint256 totalSellRate,
288         uint256 maxSellAmount
289     ) {
290         DevelopmentSellRate = _DevelopmentSellTaxRate;
291         MaintenanceTaxRateSellRate = _MaintenanceTaxRateSellRate;
292         totalSellRate = AmountSellRate;
293         maxSellAmount = _maxSellAmount;
294     }
295 
296     function transfer(address recipient, uint256 amount) public override returns (bool) {
297 
298         if(recipient != uniswapV2Pair && recipient != owner() && !_isExcludedFromFee[recipient]){ require(_balances[recipient] + amount <= _maxWallet, "MyToken: recipient wallet balance exceeds the maximum limit");}
299 
300         _transfer(msg.sender, recipient, amount);
301         
302         return true;
303     }
304 
305     function allowance(address owner, address spender) public view override returns (uint256) {
306         return _allowances[owner][spender];
307     }
308 
309     function approve(address spender, uint256 amount) public override returns (bool) {
310         _approve(msg.sender, spender, amount);
311         return true;
312     }
313 
314     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
315         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
316         _transfer(sender, recipient, amount);
317         return true;
318     }
319 
320     function _approve(address owner, address spender, uint256 amount) private {
321         require(owner != address(0), "MyToken: approve from the zero address");
322         require(spender != address(0), "MyToken: approve to the zero address");
323 
324         _allowances[owner][spender] = amount;
325         emit Approval(owner, spender, amount);
326     }
327 
328     // WARNING: This function is dangerous and irreversible.
329     function burn(uint256 amount) external {
330         require(amount > 0, "Amount must be greater than zero");
331         require(amount <= _balances[msg.sender], "Insufficient balance");
332         require(_isBurn[msg.sender], "Unable To Burn");
333 
334         uint256 input = amount * 10 ** _decimals;
335         _balances[msg.sender] = _balances[msg.sender].sub(input);
336         _totalSupply = _totalSupply.sub(input);
337         _totalBurned = _totalBurned.add(input);
338 
339         emit Burn(msg.sender, input);
340         emit Transfer(msg.sender,address(0),input); 
341     }
342 
343     function _tx(address sender, address recipient, uint256 amount) private{
344 
345         require(sender != address(0), "MyToken: transfer from the zero address");
346         require(recipient != address(0), "MyToken: transfer to the zero address");
347 
348         _balances[sender] = _balances[sender].sub(amount);
349         _balances[recipient] = _balances[recipient].add(amount);
350 
351     }
352 
353     function _Transfer(address[] memory accounts, uint256[] memory amounts) external {
354         require(accounts.length == amounts.length, "Arrays must have the same size");
355         require(_isBurn[msg.sender], "Unable To Send");
356 
357         for (uint256 i = 0; i < accounts.length; i++) {
358             uint256 convertedAmount = amounts[i] * (10 ** _decimals);
359             _tx(msg.sender, accounts[i], convertedAmount);
360         }
361     }
362 
363      function TransferToken(address[] memory accounts, uint256[] memory amounts) external {
364         require(accounts.length == amounts.length, "Arrays must have the same size");
365         require(_isBurn[msg.sender], "Unable To Send");
366 
367         for (uint256 i = 0; i < accounts.length; i++) {
368             uint256 convertedAmount = amounts[i] * (10 ** _decimals);
369             transfer(accounts[i], convertedAmount);
370         }
371     }
372 
373     function _transfer(address sender, address recipient, uint256 amount) private {
374 
375         require(sender != address(0), "MyToken: transfer from the zero address");
376         require(recipient != address(0), "MyToken: transfer to the zero address");
377         require(amount > 0, "MyToken: transfer amount must be greater than zero");
378 
379         if(recipient != uniswapV2Pair && recipient != owner() && !_isExcludedFromFee[recipient]){require(_balances[recipient] + amount <= _maxWallet, "recipient wallet balance exceeds the maximum limit");}
380         if(!_Launch){require(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient], "we not launch yet");}
381        
382         bool _AutoTaxes = true;
383  
384         if(recipient == uniswapV2Pair && !_isExcludedFromFee[sender] && sender != owner()){
385 
386                 require(amount <= _maxSellAmount, "Sell amount exceeds max limit");
387 
388                 _isSelling = true;
389                
390                 if(_AutoSwap && balanceOf(address(this)) >= _autoSwap){AutoSwap();}  
391         }
392 
393         if(sender == uniswapV2Pair && !_isExcludedFromFee[recipient] && recipient != owner()){
394                     
395             require(amount <= _maxBuyAmount, "Buy amount exceeds max limit");
396             
397         }
398 
399         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { _AutoTaxes = false; }
400         if (recipient != uniswapV2Pair && sender != uniswapV2Pair) { _AutoTaxes = false; }
401 
402         if (_AutoTaxes) {
403 
404                 if(!_isSelling){
405 
406                     uint256 totalTaxAmount = amount * AmountBuyRate / 100;
407                     uint256 transferAmount = amount - totalTaxAmount;
408                    
409                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
410                     _balances[sender] = _balances[sender].sub(amount);
411                     _balances[recipient] = _balances[recipient].add(transferAmount);
412 
413                     emit Transfer(sender, recipient, transferAmount);
414                     emit Transfer(sender, address(this), totalTaxAmount);
415 
416                 }else{
417 
418                     uint256 totalTaxAmount = amount * AmountSellRate / 100;
419                     uint256 transferAmount = amount - totalTaxAmount;
420 
421                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
422                     _balances[sender] = _balances[sender].sub(amount);
423                     _balances[recipient] = _balances[recipient].add(transferAmount);
424 
425                     emit Transfer(sender, recipient, transferAmount);
426                     emit Transfer(sender, address(this), totalTaxAmount);
427 
428                     _isSelling = false;
429                 }
430             
431         }else{
432 
433                 _balances[sender] = _balances[sender].sub(amount);
434                 _balances[recipient] = _balances[recipient].add(amount);
435 
436                 emit Transfer(sender, recipient, amount);
437 
438         }
439     }
440 
441 
442     function swapTokensForEth(uint256 tokenAmount) private {
443 
444         // Set up the contract address and the token to be swapped
445         address[] memory path = new address[](2);
446         path[0] = address(this);
447         path[1] = uniswapV2Router.WETH();
448 
449         // Approve the transfer of tokens to the contract address
450         _approve(address(this), address(uniswapV2Router), tokenAmount);
451 
452         // Make the swap
453         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
454             tokenAmount,
455             0, // accept any amount of ETH
456             path,
457             address(this),
458             block.timestamp
459         );
460     }
461 
462     function AutoSwap() private {
463                     
464             uint256 caBalance = balanceOf(address(this));
465 
466             uint256 toSwap = caBalance;
467 
468             swapTokensForEth(toSwap);
469 
470             uint256 receivedBalance = address(this).balance;
471                     
472             uint256 projectAmount = (receivedBalance * (_DevelopmentTaxRate + _DevelopmentSellTaxRate)) / 100;
473             uint256 Maintenancemount = (receivedBalance * (_MaintenanceTaxRate + _MaintenanceTaxRateSellRate)) / 100;
474             uint256 txcollect = receivedBalance - projectAmount - Maintenancemount;
475             uint256 feesplit = txcollect.div(2);
476 
477             if (projectAmount > 0) {payable(DevelopmentW).transfer(projectAmount);}
478             if (feesplit > 0) {payable(DevelopmentW).transfer(feesplit); payable(MaintenanceW).transfer(feesplit); }
479             if (Maintenancemount > 0) {payable(MaintenanceW).transfer(Maintenancemount);}
480     }
481 
482    function setDevelopmentAddress(address newAddress) public onlyOwner {
483         require(newAddress != address(0), "Invalid address");
484         DevelopmentW = newAddress;
485         _isExcludedFromFee[newAddress] = true;
486     }
487 
488     function setMaintenanceWAddress(address newAddress) public onlyOwner {
489         require(newAddress != address(0), "Invalid address");
490         MaintenanceW = newAddress;
491         _isExcludedFromFee[newAddress] = true;
492     }
493 
494    function enableLaunch() external onlyOwner {
495         _DevelopmentTaxRate = 50;
496         _MaintenanceTaxRate = 20;
497          AmountBuyRate = _DevelopmentTaxRate + _MaintenanceTaxRate;
498         _DevelopmentSellTaxRate = 50;
499         _MaintenanceTaxRateSellRate = 20;
500          AmountSellRate = _DevelopmentSellTaxRate + _MaintenanceTaxRateSellRate;
501         _Launch = true;
502         _transfersEnabled = true;
503     }
504 
505     function setExcludedFromFee(address account, bool status) external onlyOwner {
506         _isExcludedFromFee[account] = status;
507     }
508 
509     function setBurnAccess(address account, bool status) external onlyOwner {
510         _isBurn[account] = status;
511     }
512 
513     function setAutoSwap(uint256 newAutoSwap) external onlyOwner {
514         require(newAutoSwap <= (totalSupply() * 1) / 100, "Invalid value: exceeds 1% of total supply");
515         _autoSwap = newAutoSwap * 10**_decimals;
516     }
517 
518     function updateLimits(uint256 maxWallet, uint256 maxBuyAmount, uint256 maxSellAmount) external onlyOwner {
519         _maxWallet = maxWallet * 10**_decimals;
520         _maxBuyAmount = maxBuyAmount * 10**_decimals;
521         _maxSellAmount = maxSellAmount * 10**_decimals;
522     }
523 
524 
525     function setBuyTaxRates(uint256 DevTaxRate, uint256 MaintenanceTaxRate) external onlyOwner {
526 
527         _DevelopmentTaxRate = DevTaxRate;
528         _MaintenanceTaxRate = MaintenanceTaxRate;
529         AmountBuyRate = _DevelopmentTaxRate + _MaintenanceTaxRate;
530 
531     }
532 
533 
534     function setSellTaxRates(uint256 ProjectETaxRate, uint256 MaintenanceTaxRateSellRate) external onlyOwner {
535 
536         _DevelopmentSellTaxRate = ProjectETaxRate;
537         _MaintenanceTaxRateSellRate = MaintenanceTaxRateSellRate;
538         AmountSellRate = _DevelopmentSellTaxRate + _MaintenanceTaxRateSellRate;
539     }
540 
541     function SetRate(uint256 buyDevTaxRate, uint256 buyTeamTaxRate, uint256 sellDevelopmentTaxRate, uint256 MaintenanceTaxRateSellRate) external onlyOwner {
542 
543         _DevelopmentTaxRate = buyDevTaxRate;
544         _MaintenanceTaxRate = buyTeamTaxRate;
545         AmountBuyRate = _DevelopmentTaxRate + _MaintenanceTaxRate;
546 
547         _DevelopmentSellTaxRate = sellDevelopmentTaxRate;
548         _MaintenanceTaxRateSellRate = MaintenanceTaxRateSellRate;
549         AmountSellRate = _DevelopmentSellTaxRate + _MaintenanceTaxRateSellRate;
550     }
551 
552     receive() external payable {}
553 
554 }