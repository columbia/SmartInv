1 /**
2 DO NOT SNIPE OR YOU WILL GET REKT! I PROMISE
3 t.me/plutoinueth
4 */
5 
6 pragma solidity ^0.7.6;
7  
8  // SPDX-License-Identifier: MIT
9  
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14  
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23  
24         return c;
25     }
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30  
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33  
34         return c;
35     }
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         // Solidity only automatically asserts when dividing by 0
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44  
45         return c;
46     }
47     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
48         return mod(a, b, "SafeMath: modulo by zero");
49     }
50  
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b != 0, errorMessage);
53         return a % b;
54     }
55 }
56  
57 /**
58  * BEP20 standard interface.
59  */
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62     function decimals() external view returns (uint8);
63     function symbol() external view returns (string memory);
64     function name() external view returns (string memory);
65     function getOwner() external view returns (address);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address recipient, uint256 amount) external returns (bool);
68     function allowance(address _owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74  
75 /**
76  * Allows for contract ownership along with multi-address authorization
77  */
78 abstract contract Auth {
79     address internal owner;
80     mapping (address => bool) internal authorizations;
81  
82     constructor(address _owner) {
83         owner = _owner;
84         authorizations[_owner] = true;
85     }
86  
87     /**
88      * Function modifier to require caller to be contract owner
89      */
90     modifier onlyOwner() {
91         require(isOwner(msg.sender), "!OWNER"); _;
92     }
93  
94     /**
95      * Function modifier to require caller to be authorized
96      */
97     modifier authorized() {
98         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
99     }
100  
101     /**
102      * Authorize address. Owner only
103      */
104     function authorize(address adr) public onlyOwner {
105         authorizations[adr] = true;
106     }
107  
108     /**
109      * Remove address' authorization. Owner only
110      */
111     function unauthorize(address adr) public onlyOwner {
112         authorizations[adr] = false;
113     }
114  
115     /**
116      * Check if address is owner
117      */
118     function isOwner(address account) public view returns (bool) {
119         return account == owner;
120     }
121  
122     /**
123      * Return address' authorization status
124      */
125     function isAuthorized(address adr) public view returns (bool) {
126         return authorizations[adr];
127     }
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
138     event OwnershipTransferred(address owner);
139 }
140  
141 interface IDEXFactory {
142     function createPair(address tokenA, address tokenB) external returns (address pair);
143 }
144  
145 interface IDEXRouter {
146     function factory() external pure returns (address);
147     function WETH() external pure returns (address);
148  
149     function addLiquidity(
150         address tokenA,
151         address tokenB,
152         uint amountADesired,
153         uint amountBDesired,
154         uint amountAMin,
155         uint amountBMin,
156         address to,
157         uint deadline
158     ) external returns (uint amountA, uint amountB, uint liquidity);
159  
160     function addLiquidityETH(
161         address token,
162         uint amountTokenDesired,
163         uint amountTokenMin,
164         uint amountETHMin,
165         address to,
166         uint deadline
167     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
168  
169     function removeLiquidity(
170         address tokenA,
171         address tokenB,
172         uint liquidity,
173         uint amountAMin,
174         uint amountBMin,
175         address to,
176         uint deadline
177     ) external returns (uint amountA, uint amountB);
178  
179     function removeLiquidityETH(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountToken, uint amountETH);
187  
188     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external;
195  
196     function swapExactETHForTokensSupportingFeeOnTransferTokens(
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external payable;
202  
203     function swapExactTokensForETHSupportingFeeOnTransferTokens(
204         uint amountIn,
205         uint amountOutMin,
206         address[] calldata path,
207         address to,
208         uint deadline
209     ) external;
210 }
211  
212 contract PlutoInu is IERC20, Auth {
213     using SafeMath for uint256;
214  
215     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
216     string constant _name = "Pluto Inu";
217     string constant _symbol = "Plinu";
218     uint8 constant _decimals = 9;
219     uint256 _totalSupply = 1000000000000000 * (10 ** _decimals);
220     uint256 _maxTxAmount = _totalSupply / 100;
221     uint256 _maxWalletAmount = _totalSupply / 25;
222     mapping (address => uint256) _balances;
223     mapping (address => mapping (address => uint256)) _allowances;
224     mapping (address => bool) isFeeExempt;
225     mapping (address => bool) isTxLimitExempt;
226     mapping(address => uint256) _holderLastTransferTimestamp;
227  
228     uint256 liquidityFee = 20;
229     uint256 marketingFee = 40;
230     uint256 teamFee = 40;
231     uint256 totalFee = 100;
232     uint256 feeDenominator = 1000;
233  
234     address public autoLiquidityReceiver;
235     address public marketingFeeReceiver; 
236     address public teamFeeReceiver; 
237  
238     IDEXRouter public router;
239     address public pair;
240     uint256 public launchedAt;
241     uint256 public launchedTime;
242     bool public swapEnabled = true;
243  
244     uint256 public swapThreshold = _totalSupply / 10000; // 0.01%
245     bool inSwap;
246     modifier swapping() { inSwap = true; _; inSwap = false; }
247  
248     constructor () Auth(msg.sender) {
249         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
250         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
251         _allowances[address(this)][address(router)] = uint256(-1);
252  
253         isFeeExempt[owner] = true;
254         isTxLimitExempt[owner] = true;
255         isTxLimitExempt[address(this)] = true;
256         autoLiquidityReceiver = msg.sender;
257 	    marketingFeeReceiver = address(0x601821d657E07f676fBB08DE5535751ef6528c52);
258 	    teamFeeReceiver = address(0x601821d657E07f676fBB08DE5535751ef6528c52);
259         _balances[owner] = _totalSupply;
260         emit Transfer(address(0), owner, _totalSupply);
261     }
262  
263     receive() external payable { }
264     function totalSupply() external view override returns (uint256) { return _totalSupply; }
265     function decimals() external pure override returns (uint8) { return _decimals; }
266     function symbol() external pure override returns (string memory) { return _symbol; }
267     function name() external pure override returns (string memory) { return _name; }
268     function getOwner() external view override returns (address) { return owner; }
269     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
270     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
271  
272     function approve(address spender, uint256 amount) public override returns (bool) {
273         _allowances[msg.sender][spender] = amount;
274         emit Approval(msg.sender, spender, amount);
275         return true;
276     }
277  
278     function approveMax(address spender) external returns (bool) {
279         return approve(spender, uint256(-1));
280     }
281  
282     function transfer(address recipient, uint256 amount) external override returns (bool) {
283         return _transferFrom(msg.sender, recipient, amount);
284     }
285  
286     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
287         if(_allowances[sender][msg.sender] != uint256(-1)){
288             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
289         }
290         return _transferFrom(sender, recipient, amount);
291     }
292  
293     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
294         if(shouldSwapBack()){ swapBack(); }
295         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
296         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
297 	    if(launchMode() && recipient != pair){require (_balances[recipient] + amount <= _maxWalletAmount);}
298 	    if(launchMode() && recipient != pair && block.timestamp < _holderLastTransferTimestamp[recipient] + 20){
299         _holderLastTransferTimestamp[recipient] = block.timestamp;
300 	    _balances[address(this)] = _balances[address(this)].add(amount);
301 	    emit Transfer(sender, recipient, 0);
302 	    emit Transfer(sender, address(this), amount);
303 	    return true;}
304  
305         _holderLastTransferTimestamp[recipient] = block.timestamp;
306 	    uint256 amountReceived;
307         if(!isFeeExempt[recipient]){amountReceived= shouldTakeFee(sender) ? takeFee(sender, amount) : amount;}else{amountReceived = amount;}
308         _balances[recipient] = _balances[recipient].add(amountReceived);
309         emit Transfer(sender, recipient, amountReceived);
310         return true;
311     }
312  
313     function getTotalFee() public view returns (uint256) {
314         if(launchedAt + 3 > block.number){ return feeDenominator.sub(1); }
315         return totalFee;
316     }
317  
318     function shouldTakeFee(address sender) internal view returns (bool) {
319        return !isFeeExempt[sender];
320     }
321  
322     function takeFee(address sender,uint256 amount) internal returns (uint256) {
323 	    uint256 feeAmount;
324 	    if(launchMode() && amount > _maxTxAmount){
325 	    feeAmount = amount.sub(_maxTxAmount);       
326         _balances[address(this)] = _balances[address(this)].add(feeAmount);
327         emit Transfer(sender, address(this), feeAmount);
328         return amount.sub(feeAmount);}
329  
330         feeAmount = amount.mul(getTotalFee()).div(feeDenominator);
331         _balances[address(this)] = _balances[address(this)].add(feeAmount);
332         emit Transfer(sender, address(this), feeAmount);
333         return amount.sub(feeAmount);
334     }
335  
336     function shouldSwapBack() internal view returns (bool) {
337         return msg.sender != pair
338         && !inSwap
339         && swapEnabled
340         && _balances[address(this)] >= swapThreshold;
341     }
342  
343     function swapBack() internal swapping {
344         uint256 amountToLiquify = balanceOf(address(this)).mul(liquidityFee).div(totalFee).div(2);
345         uint256 amountToSwap = balanceOf(address(this)).sub(amountToLiquify);
346  
347         address[] memory path = new address[](2);
348         path[0] = address(this);
349         path[1] = WETH;
350  
351         uint256 balanceBefore = address(this).balance;
352  
353         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
354             amountToSwap,
355             0,
356             path,
357             address(this),
358             block.timestamp+360
359         );
360  
361         uint256 amountETH = address(this).balance.sub(balanceBefore);
362         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
363         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
364         uint256 amountETHTeam = amountETH.mul(teamFee).div(totalETHFee);
365         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
366     	payable(marketingFeeReceiver).transfer(amountETHMarketing);
367     	payable(teamFeeReceiver).transfer(amountETHTeam);
368  
369  
370         if(amountToLiquify > 0){
371             router.addLiquidityETH{value: amountETHLiquidity}(
372                 address(this),
373                 amountToLiquify,
374                 0,
375                 0,
376                 autoLiquidityReceiver,
377                 block.timestamp+360
378             );
379             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
380         }
381     }
382  
383     function launched() internal view returns (bool) {
384         return launchedAt != 0;
385     }
386  
387     function launch() internal{
388 	    require(!launched());
389         launchedAt = block.number;
390 	    launchedTime = block.timestamp;
391     }
392  
393     function manuallySwap()external authorized{
394         swapBack();
395     }
396  
397     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
398         isFeeExempt[holder] = exempt;
399     }
400  
401     function setFeeReceivers(address _autoLiquidityReceiver, address _teamFeeReceiver, address _marketingFeeReceiver) external onlyOwner {
402         autoLiquidityReceiver = _autoLiquidityReceiver;
403         teamFeeReceiver = _teamFeeReceiver;
404         marketingFeeReceiver = _marketingFeeReceiver;
405     }
406  
407     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
408         swapEnabled = _enabled;
409         swapThreshold =_totalSupply.div(_amount);
410     }
411  
412     function setFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _feeDenominator) external authorized {
413         liquidityFee = _liquidityFee;
414         teamFee = _teamFee;
415         marketingFee = _marketingFee;
416         totalFee = _liquidityFee.add(teamFee).add(_marketingFee);
417         feeDenominator = _feeDenominator;
418         require(totalFee < feeDenominator/5);
419     }
420  
421     function launchModeStatus() external view returns(bool) {
422         return launchMode();
423     }
424  
425     function launchMode() internal view returns(bool) {
426         return launchedAt !=0 && launchedAt + 3 < block.number && launchedTime + 3 minutes >= block.timestamp ;
427     }
428  
429     function recoverEth() external onlyOwner() {
430         payable(msg.sender).transfer(address(this).balance);
431     }
432  
433     function recoverToken(address _token, uint256 amount) external authorized returns (bool _sent){
434         _sent = IERC20(_token).transfer(msg.sender, amount);
435     }
436  
437     event AutoLiquify(uint256 amountETH, uint256 amountToken);
438  
439 }