1 /* 
2 
3 Welcome to Habibiti - Habibis long lost wife.
4 
5 TG 📞 - https://t.me/HABIBITIMEMEZ
6 
7 Twitter 🐥 -  https://twitter.com/HabibtiETH
8 
9 Website - 💻 http://thehabibti.io
10 
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 
13 */
14 
15 
16 // SPDX-License-Identifier: MIT
17 
18 
19 pragma solidity 0.8.14;
20 
21 interface ERC20 {
22     function totalSupply() external view returns (uint256);
23     function decimals() external view returns (uint8);
24     function symbol() external view returns (string memory);
25     function name() external view returns (string memory);
26     function getOwner() external view returns (address);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address _owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59 
60         return c;
61     }
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 }
71 
72 
73 
74 abstract contract Context {
75     
76     function _msgSender() internal view virtual returns (address payable) {
77         return payable(msg.sender);
78     }
79 
80     function _msgData() internal view virtual returns (bytes memory) {
81         this;
82         return msg.data;
83     }
84 }
85 
86 contract Ownable is Context {
87     address public _owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor () {
92         address msgSender = _msgSender();
93         _owner = msgSender;
94         authorizations[_owner] = true;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97     mapping (address => bool) internal authorizations;
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         emit OwnershipTransferred(_owner, newOwner);
116         _owner = newOwner;
117     }
118 }
119 
120 interface IDEXFactory {
121     function createPair(address tokenA, address tokenB) external returns (address pair);
122 }
123 
124 interface IDEXRouter {
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127 
128     function addLiquidity(
129         address tokenA,
130         address tokenB,
131         uint amountADesired,
132         uint amountBDesired,
133         uint amountAMin,
134         uint amountBMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountA, uint amountB, uint liquidity);
138 
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 
148     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external;
155 
156     function swapExactETHForTokensSupportingFeeOnTransferTokens(
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external payable;
162 
163     function swapExactTokensForETHSupportingFeeOnTransferTokens(
164         uint amountIn,
165         uint amountOutMin,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external;
170 }
171 
172 interface InterfaceLP {
173     function sync() external;
174 }
175 
176 contract Habibti is Ownable, ERC20 {
177     using SafeMath for uint256;
178 
179     address WETH;
180     address DEAD = 0x000000000000000000000000000000000000dEaD;
181     address ZERO = 0x0000000000000000000000000000000000000000;
182     
183 
184     string constant _name = "Habibti";
185     string constant _symbol = "BIBTI";
186     uint8 constant _decimals = 9; 
187   
188 
189     uint256 _totalSupply = 888000000000 * 10**_decimals;
190 
191     uint256 public _maxTxAmount = _totalSupply.mul(1).div(100);
192     uint256 public _maxWalletToken = _totalSupply.mul(1).div(100);
193 
194     mapping (address => uint256) _balances;
195     mapping (address => mapping (address => uint256)) _allowances;
196 
197     
198     mapping (address => bool) isFeeexempt;
199     mapping (address => bool) isTxLimitexempt;
200 
201     uint256 private liquidityFee             = 1;
202     uint256 private projectDevelopmentFee    = 3;
203     uint256 private teamFee                  = 0;
204     uint256 private nftfundFee               = 1; 
205     uint256 private burnFee                  = 0;
206     uint256 public totalFee                  = nftfundFee + projectDevelopmentFee + liquidityFee + teamFee + burnFee;
207     uint256 private feeDenominator           = 100;
208 
209     uint256 sellmultiplier = 900;
210     uint256 buymultiplier = 800;
211     uint256 transfertax = 800; 
212 
213     address private autoLiquidityReceiver;
214     address private projectDevelopmentFeeReceiver;
215     address private teamFeeReceiver;
216     address private nftfundFeeReceiver;
217     address private burnFeeReceiver;
218     
219     uint256 targetLiquidity = 30;
220     uint256 targetLiquidityDenominator = 100;
221 
222     IDEXRouter public router;
223     InterfaceLP private pairContract;
224     address public pair;
225     
226     bool public TradingOpen = false; 
227 
228 
229     bool public swapEnabled = true;
230     uint256 public swapThreshold = _totalSupply * 60 / 1000; 
231     bool inSwap;
232     modifier swapping() { inSwap = true; _; inSwap = false; }
233     
234     constructor () {
235         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
236         WETH = router.WETH();
237         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
238         pairContract = InterfaceLP(pair);
239        
240         
241         _allowances[address(this)][address(router)] = type(uint256).max;
242 
243         isFeeexempt[msg.sender] = true;
244         isFeeexempt[teamFeeReceiver] = true;
245             
246         isTxLimitexempt[msg.sender] = true;
247         isTxLimitexempt[pair] = true;
248         isTxLimitexempt[teamFeeReceiver] = true;
249         isTxLimitexempt[projectDevelopmentFeeReceiver] = true;
250         isTxLimitexempt[address(this)] = true;
251         
252         autoLiquidityReceiver = msg.sender;
253         projectDevelopmentFeeReceiver = 0x1E93E8cfbDBC29EF4A7A7f7F2233Dde2D3CA2C97;
254         teamFeeReceiver = msg.sender;
255         nftfundFeeReceiver = msg.sender;
256         burnFeeReceiver = DEAD; 
257 
258         _balances[msg.sender] = _totalSupply;
259         emit Transfer(address(0), msg.sender, _totalSupply);
260 
261     }
262 
263     receive() external payable { }
264 
265     function totalSupply() external view override returns (uint256) { return _totalSupply; }
266     function decimals() external pure override returns (uint8) { return _decimals; }
267     function symbol() external pure override returns (string memory) { return _symbol; }
268     function name() external pure override returns (string memory) { return _name; }
269     function getOwner() external view override returns (address) {return owner();}
270     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
271     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
272 
273     function approve(address spender, uint256 amount) public override returns (bool) {
274         _allowances[msg.sender][spender] = amount;
275         emit Approval(msg.sender, spender, amount);
276         return true;
277     }
278 
279     function approveMax(address spender) external returns (bool) {
280         return approve(spender, type(uint256).max);
281     }
282 
283     function transfer(address recipient, uint256 amount) external override returns (bool) {
284         return _transferFrom(msg.sender, recipient, amount);
285     }
286 
287     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
288         if(_allowances[sender][msg.sender] != type(uint256).max){
289             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
290         }
291 
292         return _transferFrom(sender, recipient, amount);
293     }
294 
295   
296     function disableAllLimits() external onlyOwner {
297             _maxTxAmount = _totalSupply;
298             _maxWalletToken = _totalSupply;
299     }
300       
301     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
302         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
303 
304         if(!authorizations[sender] && !authorizations[recipient]){
305             require(TradingOpen,"Trading not open yet");
306         
307           }
308         
309                
310         if (!authorizations[sender] && recipient != address(this)  && recipient != address(DEAD) && recipient != pair && recipient != burnFeeReceiver && recipient != projectDevelopmentFeeReceiver && !isTxLimitexempt[recipient]){
311             uint256 heldTokens = balanceOf(recipient);
312             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
313 
314         
315         checkTxLimit(sender, amount); 
316 
317         if(shouldSwapBack()){ swapBack(); }
318       
319         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
320 
321         uint256 amountReceived = (isFeeexempt[sender] || isFeeexempt[recipient]) ? amount : takeFee(sender, amount, recipient);
322         _balances[recipient] = _balances[recipient].add(amountReceived);
323 
324         emit Transfer(sender, recipient, amountReceived);
325         return true;
326     }
327     
328     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
329         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
330         _balances[recipient] = _balances[recipient].add(amount);
331         emit Transfer(sender, recipient, amount);
332         return true;
333     }
334 
335     function checkTxLimit(address sender, uint256 amount) internal view {
336         require(amount <= _maxTxAmount || isTxLimitexempt[sender], "TX Limit Exceeded");
337     }
338 
339     function shouldTakeFee(address sender) internal view returns (bool) {
340         return !isFeeexempt[sender];
341     }
342 
343     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
344         
345         uint256 percent = transfertax;
346 
347         if(recipient == pair) {
348             percent = sellmultiplier;
349         } else if(sender == pair) {
350             percent = buymultiplier;
351         }
352 
353         uint256 feeAmount = amount.mul(totalFee).mul(percent).div(feeDenominator * 100);
354         uint256 burnTokens = feeAmount.mul(burnFee).div(totalFee);
355         uint256 contractTokens = feeAmount.sub(burnTokens);
356 
357         _balances[address(this)] = _balances[address(this)].add(contractTokens);
358         _balances[burnFeeReceiver] = _balances[burnFeeReceiver].add(burnTokens);
359         emit Transfer(sender, address(this), contractTokens);
360         
361         
362         if(burnTokens > 0){
363             _totalSupply = _totalSupply.sub(burnTokens);
364             emit Transfer(sender, ZERO, burnTokens);  
365         
366         }
367 
368         return amount.sub(feeAmount);
369     }
370 
371     function shouldSwapBack() internal view returns (bool) {
372         return msg.sender != pair
373         && !inSwap
374         && swapEnabled
375         && _balances[address(this)] >= swapThreshold;
376     }
377 
378   
379     function manualSend() external { 
380     payable(autoLiquidityReceiver).transfer(address(this).balance);
381         
382     }
383   
384     function removeForeignERC20(address tokenAddress, uint256 tokens) public returns (bool) {
385                if(tokens == 0){
386             tokens = ERC20(tokenAddress).balanceOf(address(this));
387         }
388         return ERC20(tokenAddress).transfer(autoLiquidityReceiver, tokens);
389     }
390 
391     function setBreakdown(uint256 _issell, uint256 _isbuy, uint256 _wallet) external onlyOwner {
392         sellmultiplier = _issell;
393         buymultiplier = _isbuy;
394         transfertax = _wallet;    
395           
396     }
397 
398      function setMaxWalletAmount(uint256 maxWallPercent) external onlyOwner {
399          require(maxWallPercent >= 1); 
400         _maxWalletToken = (_totalSupply * maxWallPercent ) / 1000;
401                 
402     }
403 
404     function setMaxSellAmount(uint256 maxTXPercent) external onlyOwner {
405          require(maxTXPercent >= 1); 
406         _maxTxAmount = (_totalSupply * maxTXPercent ) / 1000;
407     }
408 
409     function tradingAllowed() public onlyOwner {
410         TradingOpen = true;     
411         
412     }
413 
414      function setBacking(uint256 _target, uint256 _denominator) external onlyOwner {
415         targetLiquidity = _target;
416         targetLiquidityDenominator = _denominator;
417     }
418     
419     
420                
421     function swapBack() internal swapping {
422         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
423         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
424         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
425 
426         address[] memory path = new address[](2);
427         path[0] = address(this);
428         path[1] = WETH;
429 
430         uint256 balanceBefore = address(this).balance;
431 
432         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
433             amountToSwap,
434             0,
435             path,
436             address(this),
437             block.timestamp
438         );
439 
440         uint256 amountETH = address(this).balance.sub(balanceBefore);
441 
442         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
443         
444         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
445         uint256 amountETHprojectDevelopment = amountETH.mul(projectDevelopmentFee).div(totalETHFee);
446         uint256 amountETHnftfund = amountETH.mul(nftfundFee).div(totalETHFee);
447         uint256 amountETHdev = amountETH.mul(teamFee).div(totalETHFee);
448 
449         (bool tmpSuccess,) = payable(projectDevelopmentFeeReceiver).call{value: amountETHprojectDevelopment}("");
450         (tmpSuccess,) = payable(teamFeeReceiver).call{value: amountETHdev}("");
451         (tmpSuccess,) = payable(nftfundFeeReceiver).call{value: amountETHnftfund}("");
452         
453         tmpSuccess = false;
454 
455         if(amountToLiquify > 0){
456             router.addLiquidityETH{value: amountETHLiquidity}(
457                 address(this),
458                 amountToLiquify,
459                 0,
460                 0,
461                 autoLiquidityReceiver,
462                 block.timestamp
463             );
464             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
465         }
466     }
467 
468     
469     function setTaxFee(uint256 _liquidityFee, uint256 _nftfundFee, uint256 _projectDevelopmentFee, uint256 _teamFee, uint256 _burnFee, uint256 _feeDenominator) external onlyOwner {
470         liquidityFee = _liquidityFee;
471         nftfundFee = _nftfundFee;
472         projectDevelopmentFee = _projectDevelopmentFee;
473         teamFee = _teamFee;
474         burnFee = _burnFee;
475         totalFee = _liquidityFee.add(_nftfundFee).add(_projectDevelopmentFee).add(_teamFee).add(_burnFee);
476         feeDenominator = _feeDenominator;
477         require(totalFee < feeDenominator / 5, "Fees can not be more than 20%"); 
478     }
479 
480     function setReceivers(address _autoLiquidityReceiver, address _projectDevelopmentFeeReceiver, address _teamFeeReceiver, address _burnFeeReceiver, address _nftfundFeeReceiver) external onlyOwner {
481         autoLiquidityReceiver = _autoLiquidityReceiver;
482         projectDevelopmentFeeReceiver = _projectDevelopmentFeeReceiver;
483         teamFeeReceiver = _teamFeeReceiver;
484         burnFeeReceiver = _burnFeeReceiver;
485         nftfundFeeReceiver = _nftfundFeeReceiver;
486     }
487 
488     function setSwapandLiquify(bool _enabled, uint256 _amount) external onlyOwner {
489         swapEnabled = _enabled;
490         swapThreshold = _amount;
491     }
492        
493     function getCirculatingSupply() public view returns (uint256) {
494         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
495     }
496 
497     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
498         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
499     }
500 
501     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
502         return getLiquidityBacking(accuracy) > target;
503     }
504 
505 
506 
507 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
508 
509 
510 }