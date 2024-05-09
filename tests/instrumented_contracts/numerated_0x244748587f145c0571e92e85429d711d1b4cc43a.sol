1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.18;
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b, "SafeMath: multiplication overflow");
28 
29         return c;
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return div(a, b, "SafeMath: division by zero");
33     }
34     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         return c;
38     }
39 }
40 
41 interface ERC20 {
42     function totalSupply() external view returns (uint256);
43     function decimals() external view returns (uint8);
44     function symbol() external view returns (string memory);
45     function name() external view returns (string memory);
46     function getOwner() external view returns (address);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address _owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 abstract contract Auth {
57     address internal owner;
58     mapping (address => bool) internal authorizations;
59 
60     constructor(address _owner) {
61         owner = _owner;
62         authorizations[_owner] = true;
63     }
64 
65     modifier onlyOwner() {
66         require(isOwner(msg.sender), "!OWNER"); _;
67     }
68 
69     modifier authorized() {
70         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
71     }
72 
73     function authorize(address adr) public onlyOwner {
74         authorizations[adr] = true;
75     }
76 
77     function unauthorize(address adr) public onlyOwner {
78         authorizations[adr] = false;
79     }
80 
81     function isOwner(address account) public view returns (bool) {
82         return account == owner;
83     }
84 
85     function isAuthorized(address adr) public view returns (bool) {
86         return authorizations[adr];
87     }
88 
89     function transferOwnership(address payable adr) public onlyOwner {
90         owner = adr;
91         authorizations[adr] = true;
92         emit OwnershipTransferred(adr);
93     }
94 
95     event OwnershipTransferred(address owner);
96 }
97 
98 interface IDEXFactory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IDEXRouter {
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105 
106     function addLiquidity(
107         address tokenA,
108         address tokenB,
109         uint amountADesired,
110         uint amountBDesired,
111         uint amountAMin,
112         uint amountBMin,
113         address to,
114         uint deadline
115     ) external returns (uint amountA, uint amountB, uint liquidity);
116 
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 
126     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133 
134     function swapExactETHForTokensSupportingFeeOnTransferTokens(
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external payable;
140 
141     function swapExactTokensForETHSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 }
149 
150 contract Chooky is ERC20, Auth {
151     using SafeMath for uint256;
152 
153      //events
154     event Fupdated(uint256 _timeF);
155     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
156     event SetMaxWalletExempt(address _address, bool _bool);
157     event SellFeeChanged(uint256 _marketingFee);
158     event BuyFeeChanged(uint256 _marketingFee);
159     event TransferFeeChanged(uint256 _transferFee);
160     event SetFeeReceiver(address _marketingReceiver);
161     event ChangedSwapBack(bool _enabled, uint256 _amount);
162     event SetFeeExempt(address _addr, bool _value);
163     event InitialDistributionFinished(bool _value);
164     event ChangedMaxWallet(uint256 _maxWallet);
165     event SingleBlacklistUpdated(address _address, bool status);
166 
167     address private WETH;
168     address private DEAD = 0x000000000000000000000000000000000000dEaD;
169     address private ZERO = 0x0000000000000000000000000000000000000000;
170 
171     string constant private _name = "Chooky";
172     string constant private _symbol = "$CHOO";
173     uint8 constant private _decimals = 18;
174 
175     uint256 private _totalSupply = 21000000* 10**_decimals;
176 
177     uint256 public _maxWalletAmount = _totalSupply / 50;
178 
179     mapping (address => uint256) private _balances;
180     mapping (address => mapping (address => uint256)) private _allowances;
181 
182     address[] public _markerPairs;
183     mapping (address => bool) public automatedMarketMakerPairs;
184 
185     mapping (address => bool) public isBlacklisted;
186 
187     mapping (address => bool) public isFeeExempt;
188     mapping (address => bool) public isMaxWalletExempt;
189 
190     //Snipers
191     uint256 private deadblocks = 1; 
192     uint256 public launchBlock;
193     uint256 private latestSniperBlock;
194 
195 
196     //transfer fee
197     uint256 private transferFee = 0;
198     uint256 constant public maxFee = 5; 
199 
200     //totalFees
201     uint256 private totalBuyFee = 3;
202     uint256 private totalSellFee = 3;
203 
204     uint256 constant private feeDenominator  = 100;
205 
206     address private marketingFeeReceiver = 0x2efCF77A4E12Bb1CA3A1F829E34ef318819532f0 ;
207 
208 
209     IDEXRouter public router;
210     address public pair;
211 
212     bool public tradingEnabled = false;
213     bool public swapEnabled = true;
214     uint256 public swapThreshold = _totalSupply * 1 / 5000;
215 
216     bool private inSwap;
217     modifier swapping() { inSwap = true; _; inSwap = false; }
218 
219     constructor () Auth(msg.sender) {
220         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
221         WETH = router.WETH();
222         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
223 
224         setAutomatedMarketMakerPair(pair, true);
225         _allowances[address(this)][address(router)] = type(uint256).max;
226 
227         isFeeExempt[msg.sender] = true;
228         isMaxWalletExempt[msg.sender] = true;
229         
230         isFeeExempt[address(this)] = true; 
231         isMaxWalletExempt[address(this)] = true;
232 
233         isMaxWalletExempt[pair] = true; 
234 
235         _balances[msg.sender] = _totalSupply;
236         emit Transfer(address(0), msg.sender, _totalSupply);
237     }
238 
239     receive() external payable { }
240 
241     function totalSupply() external view override returns (uint256) { return _totalSupply; }
242     function decimals() external pure override returns (uint8) { return _decimals; }
243     function symbol() external pure override returns (string memory) { return _symbol; }
244     function name() external pure override returns (string memory) { return _name; }
245     function getOwner() external view override returns (address) { return owner; }
246     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
247     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
248 
249     function approve(address spender, uint256 amount) public override returns (bool) {
250         _allowances[msg.sender][spender] = amount;
251         emit Approval(msg.sender, spender, amount);
252         return true;
253     }
254 
255     function approveMax(address spender) external returns (bool) {
256         return approve(spender, type(uint256).max);
257     }
258 
259     function transfer(address recipient, uint256 amount) external override returns (bool) {
260         return _transferFrom(msg.sender, recipient, amount);
261     }
262 
263     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
264         if(_allowances[sender][msg.sender] != type(uint256).max){
265             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
266         }
267 
268         return _transferFrom(sender, recipient, amount);
269     }
270 
271     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
272         require(!isBlacklisted[sender] && !isBlacklisted[recipient],"Blacklisted");
273         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
274 
275         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){
276             require(tradingEnabled,"Trading not open, yet");
277         }
278 
279         if(shouldSwapBack()){ swapBack(); }
280 
281 
282         uint256 amountReceived = amount; 
283 
284         if(automatedMarketMakerPairs[sender]) { //buy
285             if(!isFeeExempt[recipient]) {
286                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
287                 amountReceived = takeBuyFee(sender, recipient, amount);
288             }
289 
290         } else if(automatedMarketMakerPairs[recipient]) { //sell
291             if(!isFeeExempt[sender]) {
292                 amountReceived = takeSellFee(sender, amount);
293             }
294         } else {	
295             if (!isFeeExempt[sender]) {	
296                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
297                 amountReceived = takeTransferFee(sender, amount);	
298             }
299         }
300 
301         _balances[sender] = _balances[sender].sub(amount);
302         _balances[recipient] = _balances[recipient].add(amountReceived);
303         
304 
305         emit Transfer(sender, recipient, amountReceived);
306         return true;
307     }
308     
309     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
310         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
311         _balances[recipient] = _balances[recipient].add(amount);
312         emit Transfer(sender, recipient, amount);
313         return true;
314     }
315 
316     // Fees
317     function takeBuyFee(address sender, address recipient, uint256 amount) internal returns (uint256){
318         if (block.number < latestSniperBlock) {
319             if (recipient != pair && recipient != address(router)) {
320                 isBlacklisted[recipient] = true;
321             }
322             }
323 
324         uint256 feeAmount = amount.mul(totalBuyFee).div(feeDenominator);
325 
326         _balances[address(this)] = _balances[address(this)].add(feeAmount);
327         emit Transfer(sender, address(this), feeAmount);
328 
329         return amount.sub(feeAmount);
330     }
331 
332     function takeSellFee(address sender, uint256 amount) internal returns (uint256){
333         uint256 feeAmount = amount.mul(totalSellFee).div(feeDenominator);
334 
335         _balances[address(this)] = _balances[address(this)].add(feeAmount);
336         emit Transfer(sender, address(this), feeAmount);
337 
338         return amount.sub(feeAmount);
339             
340     }
341 
342     function takeTransferFee(address sender, uint256 amount) internal returns (uint256){
343         uint256 feeAmount = amount.mul(transferFee).div(feeDenominator);
344             
345         if (feeAmount > 0) {
346             _balances[address(this)] = _balances[address(this)].add(feeAmount);	
347             emit Transfer(sender, address(this), feeAmount); 
348         }
349             	
350         return amount.sub(feeAmount);	
351     }    
352 
353     function shouldSwapBack() internal view returns (bool) {
354         return
355         !automatedMarketMakerPairs[msg.sender]
356         && !inSwap
357         && swapEnabled
358         && _balances[address(this)] >= swapThreshold;
359     }
360 
361     function clearStuckBalance() external authorized {
362         payable(msg.sender).transfer(address(this).balance);
363     }
364 
365     function rescueERC20(address tokenAddress, uint256 amount) external onlyOwner returns (bool) {
366         return ERC20(tokenAddress).transfer(msg.sender, amount);
367     }
368 
369     // switch Trading
370     function tradingStatus(bool _status) external onlyOwner {
371         require (tradingEnabled == false, "Can't pause trading");
372         tradingEnabled = _status;
373         launchBlock = block.number;
374         latestSniperBlock = block.number.add(deadblocks);
375 
376         emit InitialDistributionFinished(_status);
377     }
378 
379     function swapBack() internal swapping {
380 
381         address[] memory path = new address[](2);
382         path[0] = address(this);
383         path[1] = WETH;
384 
385         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
386             _balances[address(this)],
387             0,
388             path,
389             marketingFeeReceiver,
390             block.timestamp
391         );
392     
393     }
394 
395     // Admin Functions
396     function setMaxWallet(uint256 amount) external authorized {
397         require(amount > _totalSupply / 10000, "Can't limit trading");
398         _maxWalletAmount = amount;
399 
400         emit ChangedMaxWallet(amount);
401     }
402 
403     function setBL(address _address, bool _bool) external onlyOwner {
404         isBlacklisted[_address] = _bool;
405         
406         emit SingleBlacklistUpdated(_address, _bool);
407     }
408 
409     function updateF (uint256 _number) external onlyOwner {
410         require(_number < 15, "Can't go that high");
411         deadblocks = _number;
412         
413         emit Fupdated(_number);
414     }
415 
416     function setIsFeeExempt(address holder, bool exempt) external authorized {
417         isFeeExempt[holder] = exempt;
418 
419         emit SetFeeExempt(holder, exempt);
420     }
421 
422     function setIsMaxWalletExempt(address holder, bool exempt) external authorized {
423         isMaxWalletExempt[holder] = exempt;
424 
425         emit SetMaxWalletExempt(holder, exempt);
426     }
427 
428     function setBuyFee(uint256 _totalBuyFee) external authorized {
429         totalBuyFee = _totalBuyFee;
430         require(totalBuyFee <= maxFee, "Fees cannot be more than 5%");
431 
432         emit BuyFeeChanged(totalBuyFee);
433     }
434 
435     function setSellFee(uint256 _totalSellFee) external authorized {
436         totalSellFee = _totalSellFee;
437         require(totalSellFee <= maxFee, "Fees cannot be more than 5%");
438 
439         emit SellFeeChanged(totalSellFee);
440     }
441 
442     function setTransferFee(uint256 _transferFee) external authorized {	
443         transferFee = _transferFee;	
444         require(transferFee <= maxFee, "Fees cannot be higher than 5%");	
445 
446 	    emit TransferFeeChanged(_transferFee);	
447     }
448 
449 
450     function setMarketingFeeReceivers(address _marketingFeeReceiver) external authorized {
451         require(_marketingFeeReceiver != address(0), "Zero Address validation" );
452         marketingFeeReceiver = _marketingFeeReceiver;
453 
454         emit SetFeeReceiver(_marketingFeeReceiver);
455     }
456 
457     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
458         swapEnabled = _enabled;
459         swapThreshold = _amount;
460 
461         emit ChangedSwapBack(_enabled, _amount);
462     }
463 
464     function setAutomatedMarketMakerPair(address _pair, bool _value) public onlyOwner {
465             require(automatedMarketMakerPairs[_pair] != _value, "Value already set");
466 
467             automatedMarketMakerPairs[_pair] = _value;
468 
469             if(_value){
470                 _markerPairs.push(_pair);
471             }else{
472                 require(_markerPairs.length > 1, "Required 1 pair");
473                 for (uint256 i = 0; i < _markerPairs.length; i++) {
474                     if (_markerPairs[i] == _pair) {
475                         _markerPairs[i] = _markerPairs[_markerPairs.length - 1];
476                         _markerPairs.pop();
477                         break;
478                     }
479                 }
480             }
481 
482             emit SetAutomatedMarketMakerPair(_pair, _value);
483         }
484     
485     function getCirculatingSupply() public view returns (uint256) {
486         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
487     }
488 
489 
490 }