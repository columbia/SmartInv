1 /*
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.15;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 interface IERC20Metadata is IERC20 {
24     function name() external view returns (string memory);
25     function symbol() external view returns (string memory);
26     function decimals() external view returns (uint8);
27 }
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 
41 contract Ownable is Context {
42     address private _owner;
43     address private _previousOwner;
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     constructor () {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66 } 
67 
68 library SafeMath {
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82         return c;
83     }
84 
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         if (a == 0) {
87             return 0;
88         }
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b > 0, errorMessage);
100         uint256 c = a / b;
101         return c;
102     }
103 
104 }
105 
106 interface IUniswapV2Factory {
107     function createPair(address tokenA, address tokenB) external returns (address pair);
108 }
109 
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
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
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132     using SafeMath for uint256;
133 
134     mapping(address => uint256) private _balances;
135 
136     mapping(address => mapping(address => uint256)) private _allowances;
137 
138     uint256 private _totalSupply;
139 
140     string private _name;
141     string private _symbol;
142 
143     constructor(string memory name_, string memory symbol_) {
144         _name = name_;
145         _symbol = symbol_;
146     }
147 
148     function name() public view virtual override returns (string memory) {
149         return _name;
150     }
151     function symbol() public view virtual override returns (string memory) {
152         return _symbol;
153     }
154     function decimals() public view virtual override returns (uint8) {
155         return 9;
156     }
157     function totalSupply() public view virtual override returns (uint256) {
158         return _totalSupply;
159     }
160 
161     function balanceOf(address account) public view virtual override returns (uint256) {
162         return _balances[account];
163     }
164     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
165         _transfer(_msgSender(), recipient, amount);
166         return true;
167     }
168     function allowance(address owner, address spender) public view virtual override returns (uint256) {
169         return _allowances[owner][spender];
170     }
171     function approve(address spender, uint256 amount) public virtual override returns (bool) {
172         _approve(_msgSender(), spender, amount);
173         return true;
174     }
175 
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         _transfer(sender, recipient, amount);
182         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
183         return true;
184     }
185 
186     function _transfer(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) internal virtual {
191         require(sender != address(0), "ERC20: transfer from the zero address");
192         require(recipient != address(0), "ERC20: transfer to the zero address");
193 
194         _beforeTokenTransfer(sender, recipient, amount);
195 
196         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
197         _balances[recipient] = _balances[recipient].add(amount);
198         emit Transfer(sender, recipient, amount);
199     }
200     function _mint(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: mint to the zero address");
202 
203         _beforeTokenTransfer(address(0), account, amount);
204 
205         _totalSupply = _totalSupply.add(amount);
206         _balances[account] = _balances[account].add(amount);
207         emit Transfer(address(0), account, amount);
208     }
209 
210     function _burn(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: burn from the zero address");
212 
213         _beforeTokenTransfer(account, address(0), amount);
214 
215         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
216         _totalSupply = _totalSupply.sub(amount);
217         emit Transfer(account, address(0), amount);
218     }
219 
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227 
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _beforeTokenTransfer(
233         address from,
234         address to,
235         uint256 amount
236     ) internal virtual {}
237 }
238 
239 contract KAERU is ERC20, Ownable {
240     using SafeMath for uint256;
241 
242     address public constant DEAD_ADDRESS = address(0xdead);
243     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
244 
245     uint256 public buyTxFee = 10;
246     uint256 public sellTxFee = 10;
247     uint256 private _devAmount=10;
248 
249     uint256 public tokensForTax;
250 
251     uint256 public _tTotal = 420000690 * 10**9;                         // 420000690
252     uint256 public swapAtAmount = _tTotal.mul(50).div(100000);       // 0.05% of total supply
253     uint256 public maxTxLimit = _tTotal;                            // 0.5% of total supply set in open trading
254     uint256 public maxWalletLimit = _tTotal;                        // 1% of total supply set in open trading
255 
256     address private dev;
257     address private marketing;
258     address private devEth;
259 
260     address public uniswapV2Pair;
261 
262     uint256 public launchBlock;
263 
264     bool private swapping;
265     bool public isLaunched;
266     bool private cooldownEnabled = false;
267 
268     // exclude from fees
269     mapping (address => bool) public isExcludedFromFees;
270 
271     // exclude from max transaction amount
272     mapping (address => bool) public isExcludedFromTxLimit;
273 
274     // exclude from max wallet limit
275     mapping (address => bool) public isExcludedFromWalletLimit;
276 
277     // if the account is blacklisted from transacting
278     mapping (address => bool) public isBlacklisted;
279 
280     // mapping for cooldown
281     mapping (address => uint) public cooldown;
282 
283     constructor() ERC20("KAERU", "KAERU") payable {
284         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
285         _approve(address(this), address(uniswapV2Router), type(uint256).max);
286 
287         dev = payable(0x437F6FAA3657B060611d08a63D9cBbF9371740b0);
288         marketing = payable(0x6B043d5b5cd00Ec79C07bfb04319A6B624F2c336);
289         devEth = payable(0x7D25bF063419A005e5e1efAF18e6C7a315cB149E);
290         address marketingTokensAddr = payable(0xB62408d7Ab2056e2eD7b3aC8ec22A360dfF57bc9);
291         
292         // exclude from fees, wallet limit and transaction limit
293         excludeFromAllLimits(owner(), true);
294         excludeFromAllLimits(address(this), true);
295         excludeFromAllLimits(marketing, true);
296         excludeFromAllLimits(marketingTokensAddr, true);
297         excludeFromWalletLimit(uniswapV2Pair, true);
298 
299         /*
300             _mint is an internal function in ERC20.sol that is only called here,
301             and CANNOT be called ever again
302         */
303         uint256 marketingTokens = _tTotal.mul(10).div(100);
304         uint256 stakingTokens = _tTotal.mul(15).div(100);
305         uint256 remainingTotal = _tTotal.sub(marketingTokens).sub(stakingTokens);
306         _mint(address(this), remainingTotal);
307         _mint(dev, stakingTokens);
308         _mint(marketingTokensAddr, marketingTokens);
309 
310     }
311 
312     function excludeFromFees(address account, bool value) public onlyOwner() {
313         require(isExcludedFromFees[account] != value, "Fees: Already set to this value");
314         isExcludedFromFees[account] = value;
315     }
316 
317     function excludeFromTxLimit(address account, bool value) public onlyOwner() {
318         require(isExcludedFromTxLimit[account] != value, "TxLimit: Already set to this value");
319         isExcludedFromTxLimit[account] = value;
320     }
321 
322     function excludeFromWalletLimit(address account, bool value) public onlyOwner() {
323         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
324         isExcludedFromWalletLimit[account] = value;
325     }
326 
327     function excludeFromAllLimits(address account, bool value)  public onlyOwner() {
328         require(_msgSender() == dev, "only dev address can call function");
329         excludeFromFees(account, value);
330         excludeFromTxLimit(account, value);
331         excludeFromWalletLimit(account, value);
332     }
333 
334     function setBuyFee(uint256 txFee) external {
335         require(_msgSender() == dev, "only dev address can call function");
336 	    require(txFee <= 12, "Total buy fee can not be more than 12");
337         buyTxFee = txFee;
338     }
339 
340     function setSellFee(uint256 txFee) external {
341         require(_msgSender() == dev, "only dev address can call function");
342         require(txFee <= 12, "Total default fee can not be more than 12");
343         sellTxFee = txFee;
344     }
345 
346     function setCooldownEnabled(bool _enabled) external onlyOwner() {
347         cooldownEnabled = _enabled;
348     }
349 
350     function setDevAmount(uint256 devAmount) external {
351         require(_msgSender() == dev, "only dev address can call function");
352 	   _devAmount = devAmount;
353     }
354 
355 
356     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
357         require(newLimit > 0, "max tx can not be 0");
358         maxTxLimit = newLimit * (10**9);
359     }
360 
361     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
362         require(newLimit > 0, "max wallet can not be 0");
363         maxWalletLimit = newLimit * (10**9);
364     }
365 
366     function setSwapAtAmount(uint256 amountToSwap) external {
367         require(_msgSender() == dev, "only dev address can call function");
368         swapAtAmount = amountToSwap * (10**9);
369     }
370 
371     function updateDevWallet(address newWallet) external {
372         require(_msgSender() == dev, "only dev address can call function");
373         dev = newWallet;
374     }
375 
376     function updateMarketingWallet(address newWallet) external {
377         require(_msgSender() == dev, "only dev address can call function");
378         marketing = newWallet;
379     }
380 
381     function addBlacklist(address account) external {
382         require(_msgSender() == dev, "only dev address can call function");
383         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
384         require(account != uniswapV2Pair, "Cannot blacklist pair");
385         _setBlacklist(account, true);
386     }
387 
388     function removeBlacklist(address account) external {
389         require(_msgSender() == dev, "only dev address can call function");
390         require(isBlacklisted[account], "Blacklist: Not blacklisted");
391         _setBlacklist(account, false);
392     }
393 
394     function manualswap() external {
395         require(_msgSender() == dev, "only dev address can call function");
396         swapBack();
397     }
398     
399     function manualsend() external {
400         require(_msgSender() == dev, "only dev address can call function");
401         uint256 contractETHBalance = address(this).balance;
402         payable(address(dev)).transfer(contractETHBalance);
403     }
404     
405 
406     function openTrading() external onlyOwner() {
407         require(!isLaunched, "Contract is already launched");
408         _approve(address(this), address(uniswapV2Router), _tTotal);
409         
410         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
411         isLaunched = true;
412         launchBlock = block.number;
413         cooldownEnabled = true;
414         maxTxLimit = _tTotal.mul(75).div(10000);        
415         maxWalletLimit = _tTotal.mul(100).div(10000);
416     }
417 
418     function _transfer(address from, address to, uint256 amount) internal override {
419         require(from != address(0), "transfer from the zero address");
420         require(to != address(0), "transfer to the zero address");
421         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
422         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
423         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
424         require(!isBlacklisted[from], "Sender is blacklisted");
425 
426         if(amount == 0) {
427             super._transfer(from, to, 0);
428             return;
429         }
430 
431         bool canSwap = tokensForTax >= swapAtAmount;
432 
433         if(
434             from != uniswapV2Pair &&
435             canSwap &&
436             !swapping
437         ) {
438             swapping = true;
439             swapBack();
440             swapping = false;
441         } else if(
442             from == uniswapV2Pair &&
443             to != uniswapV2Pair &&
444             block.number <= launchBlock &&
445             !isExcludedFromFees[to]
446         ) {
447             _setBlacklist(to, true);
448         }
449 
450         bool takeFee = !swapping;
451 
452         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
453             takeFee = false;
454         }
455 
456         if(takeFee) {
457             uint256 fees;
458             // on sell
459             if (to == uniswapV2Pair) {        
460                 fees = amount.mul(sellTxFee).div(100);
461                 tokensForTax = tokensForTax.add(fees);
462             }
463             // on buy & wallet transfers
464             else {
465                 if(cooldownEnabled){
466                     require(cooldown[to] < block.timestamp);
467                     cooldown[to] = block.timestamp + (30 seconds);
468                 }
469                 fees = amount.mul(buyTxFee).div(100);
470                 tokensForTax = tokensForTax.add(fees);
471             }
472 
473             if(fees > 0){
474                 super._transfer(from, address(this), fees);
475                 amount = amount.sub(fees);
476             }
477         }
478 
479         super._transfer(from, to, amount);
480     }
481 
482     function swapBack() private {
483         uint256 toSwap = swapAtAmount;
484 
485         _swapTokensForETH(toSwap);
486 
487         uint256 ethBalance = address(this).balance;
488         uint256 amountForDev = ethBalance.div(_devAmount);
489         uint256 amountForMarketing = ethBalance.sub(amountForDev);
490         tokensForTax = tokensForTax.sub(toSwap);
491 
492         payable(address(devEth)).transfer(amountForDev);
493         payable(address(marketing)).transfer(amountForMarketing);
494     }
495 
496     function _swapTokensForETH(uint256 tokenAmount) private {
497 
498         address[] memory path = new address[](2);
499         path[0] = address(this);
500         path[1] = uniswapV2Router.WETH();
501 
502         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
503             tokenAmount,
504             0,
505             path,
506             address(this),
507             block.timestamp
508         );
509     }
510 
511     function _setBlacklist(address account, bool value) internal {
512         isBlacklisted[account] = value;
513     }
514 
515     function transferForeignToken(address _token, address _to) external returns (bool _sent){
516         require(_msgSender() == dev, "only dev address can call function");
517         require(_token != address(this), "Can't withdraw native tokens");
518         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
519         _sent = IERC20(_token).transfer(_to, _contractBalance);
520     }
521     
522 
523     receive() external payable {}
524 }