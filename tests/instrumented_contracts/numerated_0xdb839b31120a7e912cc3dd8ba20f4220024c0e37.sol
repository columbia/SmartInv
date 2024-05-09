1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; 
24         return msg.data;
25     }
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34  
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38  
39     function sub(
40         uint256 a,
41         uint256 b,
42         string memory errorMessage
43     ) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48  
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57  
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61  
62     function div(
63         uint256 a,
64         uint256 b,
65         string memory errorMessage
66     ) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         return c;
70     }
71 }
72 
73 abstract contract Ownable is Context {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor() {
79         _setOwner(_msgSender());
80     }
81 
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         _setOwner(address(0));
93     }
94 
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _setOwner(newOwner);
98     }
99 
100     function _setOwner(address newOwner) private {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119 
120     function WETH() external pure returns (address);
121     function factory() external pure returns (address);
122 
123      function addLiquidityETH(
124         address token,
125         uint256 amountTokenDesired,
126         uint256 amountTokenMin,
127         uint256 amountETHMin,
128         address to,
129         uint256 deadline
130     )
131         external
132         payable
133         returns (
134             uint256 amountToken,
135             uint256 amountETH,
136             uint256 liquidity
137         );
138 
139 
140     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
141 }
142 
143 library Address{
144     function sendValue(address payable recipient, uint256 amount) internal {
145         require(address(this).balance >= amount, "Address: insufficient balance");
146 
147         (bool success, ) = recipient.call{value: amount}("");
148         require(success, "Address: unable to send value, recipient may have reverted");
149     }
150 }
151 
152 contract TITUS is IERC20, Ownable {
153     using SafeMath for uint256;
154 
155     using Address for address payable;
156     string private constant _name = "TITUS";
157     string private constant _symbol = "TITUS";
158     uint8 private constant _decimals = 9;
159     uint256 private _totalSupply = 300_000_000_000 * 10**_decimals; // 300 billion token supply
160     uint256 private _maxWallet = 2_400_000_000 * 10**_decimals;
161     uint256 private _maxBuyAmount = 2_400_000_000 * 10**_decimals;
162     uint256 private _maxSellAmount = 2_400_000_000 * 10**_decimals;
163     uint256 private _swapTH = 300_000_000 * 10**_decimals;
164 
165     address public Dev = 0x5eD52896dB7DA4C4AE66a270a0c21A70a6131Faa;
166 
167     mapping(address => bool) private _isExcludedFromFee;
168     IUniswapV2Router02 public uniswapV2Router;
169     address public uniswapV2Pair;
170     address private _owner;
171 
172     mapping (address => uint256) private _balances;
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     bool public _AutoSwap = true;
176     bool public _Launch = false;
177     bool public _transfersEnabled = false;
178     bool private _TokenSwap = true;
179     bool private _autoLP = true;
180     bool private _isSelling = false;
181     uint256 private _swapPercent = 100;
182     uint256 private _devTaxRate = 0;
183     uint256 private AmountBuyRate = _devTaxRate;
184     uint256 private _devTaxSellRate = 0;
185     uint256 private AmountSellRate = _devTaxSellRate;
186 
187     constructor() {
188         
189         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
190 
191         uniswapV2Router = _uniswapV2Router;
192         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
193 
194         _owner = msg.sender;
195 
196         uint256 tsupply = _totalSupply;
197 
198         _balances[msg.sender] = tsupply;
199 
200 
201         _isExcludedFromFee[_owner] = true;
202         _isExcludedFromFee[address(this)] = true;
203         _isExcludedFromFee[Dev] = true;
204         
205         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
206     }
207 
208     function getOwner() public view returns (address) {
209         return owner();
210     }
211     
212     function name() public pure returns (string memory) {
213         return _name;
214     }
215     
216     function symbol() public pure returns (string memory) {
217         return _symbol;
218     }
219 
220     function decimals() public pure returns (uint8) {
221         return _decimals;
222     }
223 
224     function totalSupply() public view override returns (uint256) {
225         return _totalSupply;
226     }
227 
228 
229     function balanceOf(address account) public view override returns (uint256) {
230         return _balances[account];
231     }
232 
233     function isExcludedFromFee(address account) public view returns (bool) {
234         return _isExcludedFromFee[account];
235     }
236 
237     function ViewBuyRate() public view returns (
238         uint256 devBuyRate,
239         uint256 totalBuyRate,
240         uint256 maxWallet,
241         uint256 maxBuyAmount
242     ) {
243         devBuyRate = _devTaxRate;
244         totalBuyRate = AmountBuyRate;
245         maxWallet = _maxWallet;
246         maxBuyAmount = _maxBuyAmount;
247     }
248 
249     function ViewSellRate() public view returns (
250         uint256 devSellRate,
251         uint256 totalSellRate,
252         uint256 maxSellAmount
253     ) {
254         devSellRate = _devTaxSellRate;
255         totalSellRate = AmountSellRate;
256         maxSellAmount = _maxSellAmount;
257     }
258 
259 
260     function transfer(address recipient, uint256 amount) public override returns (bool) {
261 
262         if(recipient != uniswapV2Pair && recipient != owner() && !_isExcludedFromFee[recipient]){
263 
264             require(_balances[recipient] + amount <= _maxWallet, "TITUS: recipient wallet balance exceeds the maximum limit");
265 
266         }
267 
268         _transfer(msg.sender, recipient, amount);
269         
270         return true;
271     }
272 
273     function allowance(address owner, address spender) public view override returns (uint256) {
274         return _allowances[owner][spender];
275     }
276 
277     function approve(address spender, uint256 amount) public override returns (bool) {
278         _approve(msg.sender, spender, amount);
279         return true;
280     }
281 
282     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
283         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
284         _transfer(sender, recipient, amount);
285         return true;
286     }
287 
288     function _approve(address owner, address spender, uint256 amount) private {
289         require(owner != address(0), "TITUS: approve from the zero address");
290         require(spender != address(0), "TITUS: approve to the zero address");
291 
292         _allowances[owner][spender] = amount;
293         emit Approval(owner, spender, amount);
294     }
295 
296     function _transfer(address sender, address recipient, uint256 amount) private {
297 
298         require(sender != address(0), "TITUS: transfer from the zero address");
299         require(recipient != address(0), "TITUS: transfer to the zero address");
300         require(amount > 0, "TITUS: transfer amount must be greater than zero");
301         if(!_Launch){require(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient], "we not launch yet");}
302         if(!_Launch && recipient != uniswapV2Pair && sender != uniswapV2Pair) {require(_transfersEnabled, "Transfers are currently disabled");}
303 
304         bool _AutoTaxes = true;
305 
306 
307         if (recipient == uniswapV2Pair && sender == owner()) {
308 
309             _balances[sender] -= amount;
310             _balances[recipient] += amount;
311             emit Transfer(sender, recipient, amount);
312             return;
313         }
314 
315         // At the sell of TITUS
316         if(recipient == uniswapV2Pair && !_isExcludedFromFee[sender] && sender != owner()){
317 
318                 require(amount <= _maxSellAmount, "Sell amount exceeds max limit");
319 
320                 _isSelling = true;
321                
322                 if(_AutoSwap && balanceOf(address(this)) >= _swapTH){
323 
324                     CanSwap();
325                 }  
326         }
327 
328         //at the buy of TITUS
329         if(sender == uniswapV2Pair && !_isExcludedFromFee[recipient] && recipient != owner()){
330                     
331             require(amount <= _maxBuyAmount, "Buy amount exceeds max limit");
332             
333         }
334 
335         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) { _AutoTaxes = false; }
336         if (recipient != uniswapV2Pair && sender != uniswapV2Pair) { _AutoTaxes = false; }
337 
338         if (_AutoTaxes) {
339 
340                 if(!_isSelling){
341 
342                     uint256 totalTaxAmount = amount * AmountBuyRate / 100;
343                     uint256 transferAmount = amount - totalTaxAmount;
344                     
345                    
346                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
347                     _balances[sender] = _balances[sender].sub(amount);
348                     _balances[recipient] = _balances[recipient].add(transferAmount);
349 
350                     emit Transfer(sender, recipient, transferAmount);
351                     emit Transfer(sender, address(this), totalTaxAmount);
352 
353                 }else{
354 
355                     uint256 totalTaxAmount = amount * AmountSellRate / 100;
356                     uint256 transferAmount = amount - totalTaxAmount;
357                     
358 
359                     _balances[address(this)] = _balances[address(this)].add(totalTaxAmount);
360                     _balances[sender] = _balances[sender].sub(amount);
361                     _balances[recipient] = _balances[recipient].add(transferAmount);
362 
363                     emit Transfer(sender, recipient, transferAmount);
364                     emit Transfer(sender, address(this), totalTaxAmount);
365 
366                     _isSelling = false;
367                 }
368             
369         }else{
370 
371                 _balances[sender] = _balances[sender].sub(amount);
372                 _balances[recipient] = _balances[recipient].add(amount);
373 
374                 emit Transfer(sender, recipient, amount);
375 
376         }
377     }
378 
379 
380     function swapTokensForEth(uint256 tokenAmount) private {
381 
382         // Set up the contract and the TITUS token to be swapped
383         address[] memory path = new address[](2);
384         path[0] = address(this);
385         path[1] = uniswapV2Router.WETH();
386 
387         // Approve the transfer of TITUS tokens to the contract
388         _approve(address(this), address(uniswapV2Router), tokenAmount);
389 
390         // Make the swap
391         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
392             tokenAmount,
393             0, // Accept any amount of ETH for the swap
394             path,
395             address(this),
396             block.timestamp
397         );
398     }
399 
400 
401     function CanSwap() private {
402 
403         uint256 contractTokenBalance = balanceOf(address(this));
404 
405         if(contractTokenBalance > 0) {
406 
407             if(_TokenSwap){
408 
409                 if(contractTokenBalance > 0){
410                     
411                     uint256 caBalance = balanceOf(address(this)) * _swapPercent / 100;
412 
413                     uint256 toSwap = caBalance;
414 
415                     swapTokensForEth(toSwap);
416 
417                     uint256 receivedBalance = address(this).balance;
418 
419                     if (receivedBalance > 0) {payable(Dev).transfer(receivedBalance);}
420 
421                 }else{
422 
423                     revert("No TITUS tokens available to swap");
424                 }
425 
426             }
427 
428         }else{
429 
430            revert("No TITUS Balance available to swap");     
431            
432         }
433             
434     }
435 
436    receive() external payable {}
437 
438     function setDevAddress(address newAddress) public onlyOwner {
439         require(newAddress != address(0), "Invalid given address");
440         Dev = newAddress;
441         _isExcludedFromFee[newAddress] = true;
442     }
443 
444 
445    function enableLaunch() external {
446         _Launch = true;
447         _transfersEnabled = true;
448     }
449 
450     function SwapEnable(bool status) external onlyOwner {
451         _AutoSwap = status;
452     }
453 
454     function SetSwapPercentage(uint256 SwapPercent) external onlyOwner {
455         _swapPercent = SwapPercent;
456     }
457 
458     function setAutoSwap(uint256 newAutoSwap) external onlyOwner {
459         require(newAutoSwap <= (totalSupply() * 1) / 100, "Invalid value: it exceeds 1% of the total supply");
460         _swapTH = newAutoSwap * 10**_decimals;
461     }
462 
463     function updateLimits(uint256 maxWallet, uint256 maxBuyAmount, uint256 maxSellAmount) external onlyOwner {
464         _maxWallet = maxWallet * 10**_decimals;
465         _maxBuyAmount = maxBuyAmount * 10**_decimals;
466         _maxSellAmount = maxSellAmount * 10**_decimals;
467     }
468 
469     function setBuyTaxRates(uint256 devTaxRate) external onlyOwner {
470         _devTaxRate = devTaxRate;
471         AmountBuyRate = _devTaxRate;
472     }
473 
474 
475     function setSellTaxRates(uint256 devTaxRate) external onlyOwner {
476         _devTaxSellRate = devTaxRate;
477         AmountSellRate = _devTaxSellRate;
478     }
479 
480 }