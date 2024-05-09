1 /**
2 
3     E̷X̷I̷T̷ T̷H̷E̷ M̷A̷T̷R̷I̷X̷
4 
5  https://www.the-matrix.xyz/
6 
7 */
8 //SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.5;
10 
11 
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16 
17 
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         return sub(a, b, "SafeMath: subtraction overflow");
22     }
23     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24         require(b <= a, errorMessage);
25         uint256 c = a - b;
26 
27 
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34 
35 
36         uint256 c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38 
39 
40         return c;
41     }
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51 
52         return c;
53     }
54 }
55 
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function decimals() external view returns (uint8);
60     function symbol() external view returns (string memory);
61     function name() external view returns (string memory);
62     function getOwner() external view returns (address);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address _owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 abstract contract Auth {
74     address internal owner;
75     mapping (address => bool) internal authorizations;
76 
77 
78     constructor(address _owner) {
79         owner = _owner;
80         authorizations[_owner] = true;
81     }
82 
83 
84     /**
85      */
86     modifier onlyOwner() {
87         require(isOwner(msg.sender), "!OWNER"); _;
88     }
89 
90 
91     /**
92      */
93     modifier authorized() {
94         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
95     }
96 
97 
98     /**
99      */
100     function authorize(address adr) public onlyOwner {
101         authorizations[adr] = true;
102     }
103 
104 
105     /**
106      * Remove address' authorization. Owner only
107      */
108     function unauthorize(address adr) public onlyOwner {
109         authorizations[adr] = false;
110     }
111 
112 
113     /**
114      * Check if address is owner
115      */
116     function isOwner(address account) public view returns (bool) {
117         return account == owner;
118     }
119 
120 
121     /**
122      * Return address' authorization status
123      */
124     function isAuthorized(address adr) public view returns (bool) {
125         return authorizations[adr];
126     }
127 
128 
129     /**
130      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
131      */
132     function transferOwnership(address payable adr) public onlyOwner {
133         owner = adr;
134         authorizations[adr] = true;
135         emit OwnershipTransferred(adr);
136     }
137 
138 
139     event OwnershipTransferred(address owner);
140 }
141 
142 
143 interface IDEXFactory {
144     function createPair(address tokenA, address tokenB) external returns (address pair);
145 }
146 
147 
148 interface IDEXRouter {
149     function factory() external pure returns (address);
150     function WETH() external pure returns (address);
151 
152 
153     function addLiquidity(
154         address tokenA,
155         address tokenB,
156         uint amountADesired,
157         uint amountBDesired,
158         uint amountAMin,
159         uint amountBMin,
160         address to,
161         uint deadline
162     ) external returns (uint amountA, uint amountB, uint liquidity);
163 
164 
165     function addLiquidityETH(
166         address token,
167         uint amountTokenDesired,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline
172     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
173 
174 
175     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
176         uint amountIn,
177         uint amountOutMin,
178         address[] calldata path,
179         address to,
180         uint deadline
181     ) external;
182 
183 
184     function swapExactETHForTokensSupportingFeeOnTransferTokens(
185         uint amountOutMin,
186         address[] calldata path,
187         address to,
188         uint deadline
189     ) external payable;
190 
191 
192     function swapExactTokensForETHSupportingFeeOnTransferTokens(
193         uint amountIn,
194         uint amountOutMin,
195         address[] calldata path,
196         address to,
197         uint deadline
198     ) external;
199 }
200 
201 
202 contract ExitTheMatrix is IERC20, Auth {
203     using SafeMath for uint256;
204 
205 
206     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
207     address DEAD = 0x000000000000000000000000000000000000dEaD;
208     address ZERO = 0x0000000000000000000000000000000000000000;
209 
210 
211     string constant _name = "Exit The Matrix";
212     string constant _symbol = "ETM";
213     uint8 constant _decimals = 18;
214 
215 
216     uint256 _totalSupply = 100000000000 * (10 ** _decimals);
217     uint256 public _maxTxAmount = (_totalSupply * 2) / 100; 
218     uint256 public _maxWalletSize = (_totalSupply * 2) / 100; 
219 
220 
221     mapping (address => uint256) _balances;
222     mapping (address => mapping (address => uint256)) _allowances;
223 
224 
225     mapping (address => bool) isFeeExempt;
226     mapping (address => bool) isTxLimitExempt;
227 
228 
229     uint256 liquidityFee = 2;
230     uint256 MarketingFee = 2;
231     uint256 DevFee = 1;
232     uint256 totalFee = 5;
233     uint256 feeDenominator = 100;
234     
235     address private DevFeeReceiver = 0x005Da8d6ffCe59722528DF4DC06d22E5D8De99DA;
236     address private MarketingFeeReceiver = 0xE96bb550Fed509f4f33eA3c14bF2FeE5E0888bb4;
237 
238 
239     IDEXRouter public router;
240     address public pair;
241 
242 
243     uint256 public launchedAt;
244 
245 
246     bool public swapEnabled = true;
247     uint256 public swapThreshold = _totalSupply / 1000000 * 1; // 0.3%
248     bool inSwap;
249     modifier swapping() { inSwap = true; _; inSwap = false; }
250 
251 
252     constructor () Auth(msg.sender) {
253         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
254         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
255         _allowances[address(this)][address(router)] = type(uint256).max;
256 
257 
258         address _owner = owner;
259         isFeeExempt[_owner] = true;
260         isTxLimitExempt[_owner] = true;
261 
262 
263         _balances[_owner] = _totalSupply;
264         emit Transfer(address(0), _owner, _totalSupply);
265     }
266 
267 
268     receive() external payable { }
269 
270 
271     function totalSupply() external view override returns (uint256) { return _totalSupply; }
272     function decimals() external pure override returns (uint8) { return _decimals; }
273     function symbol() external pure override returns (string memory) { return _symbol; }
274     function name() external pure override returns (string memory) { return _name; }
275     function getOwner() external view override returns (address) { return owner; }
276     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
277     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
278 
279 
280     function approve(address spender, uint256 amount) public override returns (bool) {
281         _allowances[msg.sender][spender] = amount;
282         emit Approval(msg.sender, spender, amount);
283         return true;
284     }
285 
286 
287     function approveMax(address spender) external returns (bool) {
288         return approve(spender, type(uint256).max);
289     }
290 
291 
292     function transfer(address recipient, uint256 amount) external override returns (bool) {
293         return _transferFrom(msg.sender, recipient, amount);
294     }
295 
296 
297     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
298         if(_allowances[sender][msg.sender] != type(uint256).max){
299             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
300         }
301 
302 
303         return _transferFrom(sender, recipient, amount);
304     }
305 
306 
307     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
308         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
309         
310         checkTxLimit(sender, amount);
311         
312         if (recipient != pair && recipient != DEAD) {
313             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
314         }
315         
316         if(shouldSwapBack()){ swapBack(); }
317 
318 
319         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
320 
321 
322         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
323 
324 
325         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
326         _balances[recipient] = _balances[recipient].add(amountReceived);
327 
328 
329         emit Transfer(sender, recipient, amountReceived);
330         return true;
331     }
332     
333     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
334         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337         return true;
338     }
339 
340 
341     function checkTxLimit(address sender, uint256 amount) internal view {
342         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
343     }
344     
345     function shouldTakeFee(address sender) internal view returns (bool) {
346         return !isFeeExempt[sender];
347     }
348 
349 
350 
351 
352     function takeFee(address sender, uint256 amount) internal returns (uint256) {
353         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
354 
355 
356         _balances[address(this)] = _balances[address(this)].add(feeAmount);
357         emit Transfer(sender, address(this), feeAmount);
358 
359 
360         return amount.sub(feeAmount);
361     }
362 
363 
364     function shouldSwapBack() internal view returns (bool) {
365         return msg.sender != pair
366         && !inSwap
367         && swapEnabled
368         && _balances[address(this)] >= swapThreshold;
369     }
370 
371 
372     function swapBack() internal swapping {
373         uint256 contractTokenBalance = balanceOf(address(this));
374         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
375         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
376 
377 
378         address[] memory path = new address[](2);
379         path[0] = address(this);
380         path[1] = WETH;
381 
382 
383         uint256 balanceBefore = address(this).balance;
384 
385 
386         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
387             amountToSwap,
388             0,
389             path,
390             address(this),
391             block.timestamp
392         );
393         uint256 amountETH = address(this).balance.sub(balanceBefore);
394         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
395         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
396         uint256 amountETHMarketing = amountETH.mul(MarketingFee).div(totalETHFee);
397         uint256 amountETHDev = amountETH - amountETHLiquidity - amountETHMarketing;
398 
399 
400         (bool DevSuccess, /* bytes memory data */) = payable(DevFeeReceiver).call{value: amountETHDev, gas: 30000}("");
401         require(DevSuccess, "receiver rejected ETH transfer");
402         (bool MarketingSuccess, /* bytes memory data */) = payable(MarketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
403         require(MarketingSuccess, "receiver rejected ETH transfer");
404         addLiquidity(amountToLiquify, amountETHLiquidity);
405     }
406 
407 
408     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
409     if(tokenAmount > 0){
410             router.addLiquidityETH{value: ETHAmount}(
411                 address(this),
412                 tokenAmount,
413                 0,
414                 0,
415                 address(this),
416                 block.timestamp
417             );
418             emit AutoLiquify(ETHAmount, tokenAmount);
419         }
420     }
421 
422 
423     function buyTokens(uint256 amount, address to) internal swapping {
424         address[] memory path = new address[](2);
425         path[0] = WETH;
426         path[1] = address(this);
427 
428 
429         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
430             0,
431             path,
432             to,
433             block.timestamp
434         );
435     }
436 
437 
438     function launched() internal view returns (bool) {
439         return launchedAt != 0;
440     }
441 
442 
443     function launch() internal {
444         launchedAt = block.number;
445     }
446 
447 
448     function setTxLimit(uint256 amount) external authorized {
449         require(amount >= _totalSupply / 1000);
450         _maxTxAmount = amount;
451     }
452 
453 
454    function setMaxWallet(uint256 amount) external onlyOwner() {
455         require(amount >= _totalSupply / 1000 );
456         _maxWalletSize = amount;
457     }    
458 
459 
460     function setIsFeeExempt(address holder, bool exempt) external authorized {
461         isFeeExempt[holder] = exempt;
462     }
463 
464 
465     function setIsTxLimitExempt(address holder, bool exempt) external authorized {
466         isTxLimitExempt[holder] = exempt;
467     }
468 
469 
470     function setFees(uint256 _liquidityFee, uint256 _MarketingFee, uint256 _DevFee, uint256 _feeDenominator) external authorized {
471         liquidityFee = _liquidityFee;
472         MarketingFee = _MarketingFee;
473         DevFee = _DevFee;
474         totalFee = _liquidityFee.add(_MarketingFee).add(_DevFee);
475         feeDenominator = _feeDenominator;
476     }
477 
478 
479     function setFeeReceiver(address _DevFeeReceiver, address _MarketingFeeReceiver) external authorized {
480         DevFeeReceiver = _DevFeeReceiver;
481         MarketingFeeReceiver = _MarketingFeeReceiver;
482     }
483 
484 
485     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
486         swapEnabled = _enabled;
487         swapThreshold = _amount;
488     }
489 
490 
491     function manualSend() external authorized {
492         uint256 contractETHBalance = address(this).balance;
493         payable(DevFeeReceiver).transfer(contractETHBalance);
494     }
495 
496 
497     function transferForeignToken(address _token) public authorized {
498         require(_token != address(this), "Can't let you take all native token");
499         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
500         payable(DevFeeReceiver).transfer(_contractBalance);
501     }
502         
503     function getCirculatingSupply() public view returns (uint256) {
504         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
505     }
506 
507 
508     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
509         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
510     }
511 
512 
513     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
514         return getLiquidityBacking(accuracy) > target;
515     }
516     
517     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
518 }