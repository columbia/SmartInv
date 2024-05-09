1 /*
2 Telegram: https://t.me/PepiETH
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this; 
27         return msg.data;
28     }
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37  
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41  
42     function sub(
43         uint256 a,
44         uint256 b,
45         string memory errorMessage
46     ) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51  
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60  
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64  
65     function div(
66         uint256 a,
67         uint256 b,
68         string memory errorMessage
69     ) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 }
75 
76 abstract contract Ownable is Context {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor() {
82         _setOwner(_msgSender());
83     }
84 
85     function owner() public view virtual returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         _setOwner(address(0));
96     }
97 
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _setOwner(newOwner);
101     }
102 
103     function _setOwner(address newOwner) private {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122 
123     function WETH() external pure returns (address);
124     function factory() external pure returns (address);
125 
126      function addLiquidityETH(
127         address token,
128         uint256 amountTokenDesired,
129         uint256 amountTokenMin,
130         uint256 amountETHMin,
131         address to,
132         uint256 deadline
133     )
134         external
135         payable
136         returns (
137             uint256 amountToken,
138             uint256 amountETH,
139             uint256 liquidity
140         );
141 
142 
143     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
144 }
145 
146 library Address{
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 }
154 
155 contract PEPI is IERC20, Ownable {
156     using SafeMath for uint256;
157 
158     using Address for address payable;
159     string private constant _name = "PEPI";
160     string private constant _symbol = "PEPI";
161     uint8 private constant _decimals = 9;
162     uint256 private _totalSupply = 100_000_000 * 10**_decimals;
163     uint256 private  _maxWallet = 400_000 * 10**_decimals;
164     uint256 private  _maxBuyAmount = 400_000 * 10**_decimals;
165     uint256 private  _maxSellAmount = 400_000 * 10**_decimals;
166     uint256 private  _swapTH = 100_000 * 10**_decimals;
167     address public Dev = 0xA480b2F32E46D0A4B148014C68f22275DEfb2CE0;
168     mapping(address => bool) private _isExcludedFromFee;
169     mapping(address => bool) private _isWhiteList;
170     IUniswapV2Router02 public uniswapV2Router;
171     address public uniswapV2Pair;
172     address private _owner;
173     mapping (address => uint256) private _balances;
174     mapping (address => mapping (address => uint256)) private _allowances;
175 
176     bool public _AutoSwap = true;
177     bool public _Launch = false;
178     bool public _transfersEnabled = false;
179     bool private _TokenSwap = true;
180     bool private _autoLP = true;
181     bool private _isSelling = false;
182     
183     uint256 private _swapPercent = 100;
184 
185     uint256 private _devTaxRate = 1;
186     uint256 private AmountBuyRate = _devTaxRate;
187 
188     uint256 private _devTaxSellRate = 45;
189     uint256 private AmountSellRate = _devTaxSellRate;
190 
191     constructor() {
192         
193         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
194 
195         uniswapV2Router = _uniswapV2Router;
196         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
197 
198         _owner = msg.sender;
199 
200         uint256 tsupply = _totalSupply;
201 
202         _balances[msg.sender] = tsupply;
203 
204 
205         _isExcludedFromFee[_owner] = true;
206         _isExcludedFromFee[address(this)] = true;
207         _isExcludedFromFee[Dev] = true;
208         
209         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
210     }
211 
212     function getOwner() public view returns (address) {
213         return owner();
214     }
215     
216     function name() public pure returns (string memory) {
217         return _name;
218     }
219     
220     function symbol() public pure returns (string memory) {
221         return _symbol;
222     }
223 
224     function decimals() public pure returns (uint8) {
225         return _decimals;
226     }
227 
228     function totalSupply() public view override returns (uint256) {
229         return _totalSupply;
230     }
231 
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         return _balances[account];
235     }
236 
237     function isExcludedFromFee(address account) public view returns (bool) {
238         return _isExcludedFromFee[account];
239     }
240 
241     function isWhitelist(address account) public view returns (bool) {
242         return _isWhiteList[account];
243     }
244 
245     function ViewBuyRate() public view returns (
246         uint256 devBuyRate,
247         uint256 totalBuyRate,
248         uint256 maxWallet,
249         uint256 maxBuyAmount
250     ) {
251         devBuyRate = _devTaxRate;
252         totalBuyRate = AmountBuyRate;
253         maxWallet = _maxWallet;
254         maxBuyAmount = _maxBuyAmount;
255     }
256 
257     function ViewSellRate() public view returns (
258         uint256 devSellRate,
259         uint256 totalSellRate,
260         uint256 maxSellAmount
261     ) {
262         devSellRate = _devTaxSellRate;
263         totalSellRate = AmountSellRate;
264         maxSellAmount = _maxSellAmount;
265     }
266 
267 
268     function transfer(address recipient, uint256 amount) public override returns (bool) {
269 
270         if(recipient != uniswapV2Pair && recipient != owner() && !_isExcludedFromFee[recipient]){
271 
272             require(_balances[recipient] + amount <= _maxWallet, "MyToken: recipient wallet balance exceeds the maximum limit");
273 
274         }
275 
276         _transfer(msg.sender, recipient, amount);
277         
278         return true;
279     }
280 
281     function allowance(address owner, address spender) public view override returns (uint256) {
282         return _allowances[owner][spender];
283     }
284 
285     function approve(address spender, uint256 amount) public override returns (bool) {
286         _approve(msg.sender, spender, amount);
287         return true;
288     }
289 
290     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
291         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
292         _transfer(sender, recipient, amount);
293         return true;
294     }
295 
296     function _approve(address owner, address spender, uint256 amount) private {
297         require(owner != address(0), "MyToken: approve from the zero address");
298         require(spender != address(0), "MyToken: approve to the zero address");
299 
300         _allowances[owner][spender] = amount;
301         emit Approval(owner, spender, amount);
302     }
303 
304     function _transfer(address sender, address recipient, uint256 amount) private {
305 
306         require(sender != address(0), "MyToken: transfer from the zero address");
307         require(recipient != address(0), "MyToken: transfer to the zero address");
308         require(amount > 0, "MyToken: transfer amount must be greater than zero");
309         if(!_Launch){require(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient] || _isWhiteList[sender] || _isWhiteList[recipient], "we not launch yet");}
310         if(!_Launch && recipient != uniswapV2Pair && sender != uniswapV2Pair) {require(_transfersEnabled, "Transfers are currently disabled");}
311 
312         bool _AutoTaxes = true;
313 
314 
315         if (recipient == uniswapV2Pair && sender == owner()) {
316 
317             _balances[sender] -= amount;
318             _balances[recipient] += amount;
319             emit Transfer(sender, recipient, amount);
320             return;
321         }
322 
323         //sell   
324         if(recipient == uniswapV2Pair && !_isExcludedFromFee[sender] && sender != owner()){
325 
326                 require(amount <= _maxSellAmount, "Sell amount exceeds max limit");
327 
328                 _isSelling = true;
329                
330                 if(_AutoSwap && balanceOf(address(this)) >= _swapTH){
331 
332                     CanSwap();
333                 }  
334         }
335 
336         //buy
337         if(sender == uniswapV2Pair && !_isExcludedFromFee[recipient] && recipient != owner()){
338                     
339             require(amount <= _maxBuyAmount, "Buy amount exceeds max limit");
340             
341         }
342 
343         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { _AutoTaxes = false; }
344         if (recipient != uniswapV2Pair && sender != uniswapV2Pair) { _AutoTaxes = false; }
345 
346         if (_AutoTaxes) {
347 
348                 if(!_isSelling){
349 
350                     uint256 totalTaxAmount = amount * AmountBuyRate / 100;
351                     uint256 transferAmount = amount - totalTaxAmount;
352                     
353                    
354                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
355                     _balances[sender] = _balances[sender].sub(amount);
356                     _balances[recipient] = _balances[recipient].add(transferAmount);
357 
358                     emit Transfer(sender, recipient, transferAmount);
359                     emit Transfer(sender, address(this), totalTaxAmount);
360 
361                 }else{
362 
363                     uint256 totalTaxAmount = amount * AmountSellRate / 100;
364                     uint256 transferAmount = amount - totalTaxAmount;
365                     
366 
367                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
368                     _balances[sender] = _balances[sender].sub(amount);
369                     _balances[recipient] = _balances[recipient].add(transferAmount);
370 
371                     emit Transfer(sender, recipient, transferAmount);
372                     emit Transfer(sender, address(this), totalTaxAmount);
373 
374                     _isSelling = false;
375                 }
376             
377         }else{
378 
379                 _balances[sender] = _balances[sender].sub(amount);
380                 _balances[recipient] = _balances[recipient].add(amount);
381 
382                 emit Transfer(sender, recipient, amount);
383 
384         }
385     }
386 
387 
388     function swapTokensForEth(uint256 tokenAmount) private {
389 
390         // Set up the contract address and the token to be swapped
391         address[] memory path = new address[](2);
392         path[0] = address(this);
393         path[1] = uniswapV2Router.WETH();
394 
395         // Approve the transfer of tokens to the contract address
396         _approve(address(this), address(uniswapV2Router), tokenAmount);
397 
398         // Make the swap
399         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
400             tokenAmount,
401             0, // accept any amount of ETH
402             path,
403             address(this),
404             block.timestamp
405         );
406     }
407 
408 
409     function CanSwap() private {
410 
411         uint256 contractTokenBalance = balanceOf(address(this));
412 
413         if(contractTokenBalance > 0) {
414 
415             if(_TokenSwap){
416 
417                 if(contractTokenBalance > 0){
418                     
419                     uint256 caBalance = balanceOf(address(this)) * _swapPercent / 100;
420 
421                     uint256 toSwap = caBalance;
422 
423                     swapTokensForEth(toSwap);
424 
425                     uint256 receivedBalance = address(this).balance;
426 
427                     if (receivedBalance > 0) {payable(Dev).transfer(receivedBalance);}
428 
429                 }else{
430 
431                     revert("No tokens available to swap");
432                 }
433 
434             }
435 
436         }else{
437 
438            revert("No Balance available to swap");     
439            
440         }
441             
442     }
443 
444    receive() external payable {}
445 
446     function setDevAddress(address newAddress) public onlyOwner {
447         require(newAddress != address(0), "Invalid address");
448         Dev = newAddress;
449         _isExcludedFromFee[newAddress] = true;
450     }
451 
452 
453    function enableLaunch() external {
454         _Launch = true;
455         _transfersEnabled = true;
456     }
457 
458     function setExcludedFromFee(address account, bool status) external onlyOwner {
459         _isExcludedFromFee[account] = status;
460     }
461 
462     function setWhitelist(address account, bool status) external onlyOwner {
463         _isWhiteList[account] = status;
464     }
465 
466     function bulkwhitelist(address[] memory accounts, bool state) external onlyOwner{
467         for(uint256 i = 0; i < accounts.length; i++){
468             _isWhiteList[accounts[i]] = state;
469         }
470     }
471 
472     function SwapEnable(bool status) external onlyOwner {
473         _AutoSwap = status;
474     }
475 
476     function SetSwapPercentage(uint256 SwapPercent) external onlyOwner {
477         _swapPercent = SwapPercent;
478     }
479 
480     function setAutoSwap(uint256 newAutoSwap) external onlyOwner {
481         require(newAutoSwap <= (totalSupply() * 1) / 100, "Invalid value: exceeds 1% of total supply");
482         _swapTH = newAutoSwap * 10**_decimals;
483     }
484 
485     function updateLimits(uint256 maxWallet, uint256 maxBuyAmount, uint256 maxSellAmount) external onlyOwner {
486         _maxWallet = maxWallet * 10**_decimals;
487         _maxBuyAmount = maxBuyAmount * 10**_decimals;
488         _maxSellAmount = maxSellAmount * 10**_decimals;
489     }
490 
491     function setBuyTaxRates(uint256 devTaxRate) external onlyOwner {
492         _devTaxRate = devTaxRate;
493         AmountBuyRate = _devTaxRate;
494     }
495 
496 
497     function setSellTaxRates(uint256 devTaxRate) external onlyOwner {
498         _devTaxSellRate = devTaxRate;
499         AmountSellRate = _devTaxSellRate;
500     }
501 
502 }