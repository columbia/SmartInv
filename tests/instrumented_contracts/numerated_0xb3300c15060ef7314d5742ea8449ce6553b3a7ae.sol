1 /**
2 */
3 
4 /*
5 Telegram: https://t.me/ElonXeth
6 Webiste: https://ElonX.wtf
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.0;
11 
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
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         this; 
31         return msg.data;
32     }
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41  
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45  
46     function sub(
47         uint256 a,
48         uint256 b,
49         string memory errorMessage
50     ) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55  
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64  
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68  
69     function div(
70         uint256 a,
71         uint256 b,
72         string memory errorMessage
73     ) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         return c;
77     }
78 }
79 
80 abstract contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor() {
86         _setOwner(_msgSender());
87     }
88 
89     function owner() public view virtual returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         _setOwner(address(0));
100     }
101 
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _setOwner(newOwner);
105     }
106 
107     function _setOwner(address newOwner) private {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116 }
117 
118 interface IUniswapV2Router02 {
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126 
127     function WETH() external pure returns (address);
128     function factory() external pure returns (address);
129 
130      function addLiquidityETH(
131         address token,
132         uint256 amountTokenDesired,
133         uint256 amountTokenMin,
134         uint256 amountETHMin,
135         address to,
136         uint256 deadline
137     )
138         external
139         payable
140         returns (
141             uint256 amountToken,
142             uint256 amountETH,
143             uint256 liquidity
144         );
145 
146 
147     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
148 }
149 
150 library Address{
151     function sendValue(address payable recipient, uint256 amount) internal {
152         require(address(this).balance >= amount, "Address: insufficient balance");
153 
154         (bool success, ) = recipient.call{value: amount}("");
155         require(success, "Address: unable to send value, recipient may have reverted");
156     }
157 }
158 
159 contract ElonX is IERC20, Ownable {
160     using SafeMath for uint256;
161 
162     using Address for address payable;
163     string private constant _name = "ElonX";
164     string private constant _symbol = "X";
165     uint8 private constant _decimals = 9;
166     uint256 private _totalSupply = 100_000_000 * 10**_decimals;
167     uint256 private  _maxWallet = 2_000_000 * 10**_decimals;
168     uint256 private  _maxBuyAmount = 2_000_000 * 10**_decimals;
169     uint256 private  _maxSellAmount = 2_000_000 * 10**_decimals;
170     uint256 private  _swapTH = 200_000 * 10**_decimals;
171     address public Dev = 0x4Fa7be9e5f10b54C63230cfb6e3101C8885D38E7;
172     mapping(address => bool) private _isExcludedFromFee;
173     mapping(address => bool) private _isWhiteList;
174     IUniswapV2Router02 public uniswapV2Router;
175     address public uniswapV2Pair;
176     address private _owner;
177     mapping (address => uint256) private _balances;
178     mapping (address => mapping (address => uint256)) private _allowances;
179 
180     bool public _AutoSwap = true;
181     bool public _Launch = false;
182     bool public _transfersEnabled = false;
183     bool private _TokenSwap = true;
184     bool private _autoLP = true;
185     bool private _isSelling = false;
186     
187     uint256 private _swapPercent = 100;
188 
189     uint256 private _devTaxRate = 25;
190     uint256 private AmountBuyRate = _devTaxRate;
191 
192     uint256 private _devTaxSellRate = 45;
193     uint256 private AmountSellRate = _devTaxSellRate;
194 
195     constructor() {
196         
197         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
198 
199         uniswapV2Router = _uniswapV2Router;
200         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
201 
202         _owner = msg.sender;
203 
204         uint256 tsupply = _totalSupply;
205 
206         _balances[msg.sender] = tsupply;
207 
208 
209         _isExcludedFromFee[_owner] = true;
210         _isExcludedFromFee[address(this)] = true;
211         _isExcludedFromFee[Dev] = true;
212         
213         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
214     }
215 
216     function getOwner() public view returns (address) {
217         return owner();
218     }
219     
220     function name() public pure returns (string memory) {
221         return _name;
222     }
223     
224     function symbol() public pure returns (string memory) {
225         return _symbol;
226     }
227 
228     function decimals() public pure returns (uint8) {
229         return _decimals;
230     }
231 
232     function totalSupply() public view override returns (uint256) {
233         return _totalSupply;
234     }
235 
236 
237     function balanceOf(address account) public view override returns (uint256) {
238         return _balances[account];
239     }
240 
241     function isExcludedFromFee(address account) public view returns (bool) {
242         return _isExcludedFromFee[account];
243     }
244 
245     function isWhitelist(address account) public view returns (bool) {
246         return _isWhiteList[account];
247     }
248 
249     function ViewBuyRate() public view returns (
250         uint256 devBuyRate,
251         uint256 totalBuyRate,
252         uint256 maxWallet,
253         uint256 maxBuyAmount
254     ) {
255         devBuyRate = _devTaxRate;
256         totalBuyRate = AmountBuyRate;
257         maxWallet = _maxWallet;
258         maxBuyAmount = _maxBuyAmount;
259     }
260 
261     function ViewSellRate() public view returns (
262         uint256 devSellRate,
263         uint256 totalSellRate,
264         uint256 maxSellAmount
265     ) {
266         devSellRate = _devTaxSellRate;
267         totalSellRate = AmountSellRate;
268         maxSellAmount = _maxSellAmount;
269     }
270 
271 
272     function transfer(address recipient, uint256 amount) public override returns (bool) {
273 
274         if(recipient != uniswapV2Pair && recipient != owner() && !_isExcludedFromFee[recipient]){
275 
276             require(_balances[recipient] + amount <= _maxWallet, "MyToken: recipient wallet balance exceeds the maximum limit");
277 
278         }
279 
280         _transfer(msg.sender, recipient, amount);
281         
282         return true;
283     }
284 
285     function allowance(address owner, address spender) public view override returns (uint256) {
286         return _allowances[owner][spender];
287     }
288 
289     function approve(address spender, uint256 amount) public override returns (bool) {
290         _approve(msg.sender, spender, amount);
291         return true;
292     }
293 
294     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
295         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
296         _transfer(sender, recipient, amount);
297         return true;
298     }
299 
300     function _approve(address owner, address spender, uint256 amount) private {
301         require(owner != address(0), "MyToken: approve from the zero address");
302         require(spender != address(0), "MyToken: approve to the zero address");
303 
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     function _transfer(address sender, address recipient, uint256 amount) private {
309 
310         require(sender != address(0), "MyToken: transfer from the zero address");
311         require(recipient != address(0), "MyToken: transfer to the zero address");
312         require(amount > 0, "MyToken: transfer amount must be greater than zero");
313         if(!_Launch){require(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient] || _isWhiteList[sender] || _isWhiteList[recipient], "we not launch yet");}
314         if(!_Launch && recipient != uniswapV2Pair && sender != uniswapV2Pair) {require(_transfersEnabled, "Transfers are currently disabled");}
315 
316         bool _AutoTaxes = true;
317 
318 
319         if (recipient == uniswapV2Pair && sender == owner()) {
320 
321             _balances[sender] -= amount;
322             _balances[recipient] += amount;
323             emit Transfer(sender, recipient, amount);
324             return;
325         }
326 
327         //sell   
328         if(recipient == uniswapV2Pair && !_isExcludedFromFee[sender] && sender != owner()){
329 
330                 require(amount <= _maxSellAmount, "Sell amount exceeds max limit");
331 
332                 _isSelling = true;
333                
334                 if(_AutoSwap && balanceOf(address(this)) >= _swapTH){
335 
336                     CanSwap();
337                 }  
338         }
339 
340         //buy
341         if(sender == uniswapV2Pair && !_isExcludedFromFee[recipient] && recipient != owner()){
342                     
343             require(amount <= _maxBuyAmount, "Buy amount exceeds max limit");
344             
345         }
346 
347         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { _AutoTaxes = false; }
348         if (recipient != uniswapV2Pair && sender != uniswapV2Pair) { _AutoTaxes = false; }
349 
350         if (_AutoTaxes) {
351 
352                 if(!_isSelling){
353 
354                     uint256 totalTaxAmount = amount * AmountBuyRate / 100;
355                     uint256 transferAmount = amount - totalTaxAmount;
356                     
357                    
358                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
359                     _balances[sender] = _balances[sender].sub(amount);
360                     _balances[recipient] = _balances[recipient].add(transferAmount);
361 
362                     emit Transfer(sender, recipient, transferAmount);
363                     emit Transfer(sender, address(this), totalTaxAmount);
364 
365                 }else{
366 
367                     uint256 totalTaxAmount = amount * AmountSellRate / 100;
368                     uint256 transferAmount = amount - totalTaxAmount;
369                     
370 
371                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
372                     _balances[sender] = _balances[sender].sub(amount);
373                     _balances[recipient] = _balances[recipient].add(transferAmount);
374 
375                     emit Transfer(sender, recipient, transferAmount);
376                     emit Transfer(sender, address(this), totalTaxAmount);
377 
378                     _isSelling = false;
379                 }
380             
381         }else{
382 
383                 _balances[sender] = _balances[sender].sub(amount);
384                 _balances[recipient] = _balances[recipient].add(amount);
385 
386                 emit Transfer(sender, recipient, amount);
387 
388         }
389     }
390 
391 
392     function swapTokensForEth(uint256 tokenAmount) private {
393 
394         // Set up the contract address and the token to be swapped
395         address[] memory path = new address[](2);
396         path[0] = address(this);
397         path[1] = uniswapV2Router.WETH();
398 
399         // Approve the transfer of tokens to the contract address
400         _approve(address(this), address(uniswapV2Router), tokenAmount);
401 
402         // Make the swap
403         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
404             tokenAmount,
405             0, // accept any amount of ETH
406             path,
407             address(this),
408             block.timestamp
409         );
410     }
411 
412 
413     function CanSwap() private {
414 
415         uint256 contractTokenBalance = balanceOf(address(this));
416 
417         if(contractTokenBalance > 0) {
418 
419             if(_TokenSwap){
420 
421                 if(contractTokenBalance > 0){
422                     
423                     uint256 caBalance = balanceOf(address(this)) * _swapPercent / 100;
424 
425                     uint256 toSwap = caBalance;
426 
427                     swapTokensForEth(toSwap);
428 
429                     uint256 receivedBalance = address(this).balance;
430 
431                     if (receivedBalance > 0) {payable(Dev).transfer(receivedBalance);}
432 
433                 }else{
434 
435                     revert("No tokens available to swap");
436                 }
437 
438             }
439 
440         }else{
441 
442            revert("No Balance available to swap");     
443            
444         }
445             
446     }
447 
448    receive() external payable {}
449 
450     function setDevAddress(address newAddress) public onlyOwner {
451         require(newAddress != address(0), "Invalid address");
452         Dev = newAddress;
453         _isExcludedFromFee[newAddress] = true;
454     }
455 
456 
457    function enableLaunch() external {
458         _Launch = true;
459         _transfersEnabled = true;
460     }
461 
462     function setExcludedFromFee(address account, bool status) external onlyOwner {
463         _isExcludedFromFee[account] = status;
464     }
465 
466     function setWhitelist(address account, bool status) external onlyOwner {
467         _isWhiteList[account] = status;
468     }
469 
470     function bulkwhitelist(address[] memory accounts, bool state) external onlyOwner{
471         for(uint256 i = 0; i < accounts.length; i++){
472             _isWhiteList[accounts[i]] = state;
473         }
474     }
475 
476     function SwapEnable(bool status) external onlyOwner {
477         _AutoSwap = status;
478     }
479 
480     function SetSwapPercentage(uint256 SwapPercent) external onlyOwner {
481         _swapPercent = SwapPercent;
482     }
483 
484     function setAutoSwap(uint256 newAutoSwap) external onlyOwner {
485         require(newAutoSwap <= (totalSupply() * 1) / 100, "Invalid value: exceeds 1% of total supply");
486         _swapTH = newAutoSwap * 10**_decimals;
487     }
488 
489     function updateLimits(uint256 maxWallet, uint256 maxBuyAmount, uint256 maxSellAmount) external onlyOwner {
490         _maxWallet = maxWallet * 10**_decimals;
491         _maxBuyAmount = maxBuyAmount * 10**_decimals;
492         _maxSellAmount = maxSellAmount * 10**_decimals;
493     }
494 
495     function setBuyTaxRates(uint256 devTaxRate) external onlyOwner {
496         _devTaxRate = devTaxRate;
497         AmountBuyRate = _devTaxRate;
498     }
499 
500 
501     function setSellTaxRates(uint256 devTaxRate) external onlyOwner {
502         _devTaxSellRate = devTaxRate;
503         AmountSellRate = _devTaxSellRate;
504     }
505 
506 }