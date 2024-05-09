1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.5;
3 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
15         require(b <= a, errorMessage);
16         uint256 c = a - b;
17 
18         return c;
19     }
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27 
28         return c;
29     }
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         return div(a, b, "SafeMath: division by zero");
32     }
33     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39         return c;
40     }
41 }
42 
43 /**
44  * BEP20 standard interface.
45  */
46 interface IBEP20 {
47     function totalSupply() external view returns (uint256);
48     function decimals() external view returns (uint8);
49     function symbol() external view returns (string memory);
50     function name() external view returns (string memory);
51     function getOwner() external view returns (address);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address _owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * Allows for contract ownership along with multi-address authorization
64  */
65 abstract contract Auth {
66     address internal owner;
67    
68 
69     constructor(address _owner) {
70         owner = _owner;
71       
72     }
73 
74     /**
75      * Function modifier to require caller to be contract owner
76      */
77     modifier onlyOwner() {
78         require(isOwner(msg.sender), "!OWNER"); _;
79     }
80 
81 
82   /**
83      * Check if address is owner
84      */
85     function isOwner(address account) public view returns (bool) {
86         return account == owner;
87     }
88 
89    
90 
91     /**
92      * Transfer ownership to new address. Caller must be owner. Leaves old owner authorized
93      */
94     function transferOwnership(address payable adr) public onlyOwner {
95         owner = adr;
96         
97         emit OwnershipTransferred(adr);
98     }
99 
100     event OwnershipTransferred(address owner);
101 }
102 
103 interface IDEXFactory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IDEXRouter {
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110 
111     function addLiquidity(
112         address tokenA,
113         address tokenB,
114         uint amountADesired,
115         uint amountBDesired,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountA, uint amountB, uint liquidity);
121 
122     function addLiquidityETH(
123         address token,
124         uint amountTokenDesired,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline
129     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
130 
131     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
132         uint amountIn,
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external;
138 
139     function swapExactETHForTokensSupportingFeeOnTransferTokens(
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external payable;
145 
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 }
154 
155 contract APECRON is IBEP20, Auth {
156     using SafeMath for uint256;
157 
158     address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
159     address DEAD = 0x000000000000000000000000000000000000dEaD;
160     address ZERO = 0x0000000000000000000000000000000000000000;
161 
162     string constant _name = "Apecron";
163     string constant _symbol = "APECRON";
164     uint8 constant _decimals = 9;
165 
166     uint256 _totalSupply = 1000000000 * (10 ** _decimals);
167     uint256 public _maxTxAmount = (_totalSupply * 1) / 100;  //2% max tx
168     uint256 public _maxWalletSize = (_totalSupply * 1) / 100;  //2% max wallet
169 
170     mapping (address => uint256) _balances;
171     mapping (address => mapping (address => uint256)) _allowances;
172 
173     mapping (address => bool) isFeeExempt;
174     mapping (address => bool) isTxLimitExempt;
175 
176     uint256 liquidityFee = 0;
177     uint256 teamFee =2;
178     uint256 marketingFee = 4;
179     uint256 totalFee = liquidityFee + teamFee + marketingFee;
180     uint256 feeDenominator = 100;
181     
182     address private marketingFeeReceiver = msg.sender;
183     address private teamFeeReceiver = msg.sender;
184 
185     IDEXRouter public router;
186     address public pair;
187 
188     uint256 public launchedAt;
189 
190     bool public swapEnabled = true;
191     uint256 public swapThreshold = _totalSupply / 1000 * 3; // 0.3%
192     bool inSwap;
193     modifier swapping() { inSwap = true; _; inSwap = false; }
194 
195     constructor () Auth(msg.sender) {
196         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
197         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
198         _allowances[address(this)][address(router)] = type(uint256).max;
199 
200         address _owner = owner;
201         isFeeExempt[_owner] = true;
202         isTxLimitExempt[_owner] = true;
203 
204         _balances[_owner] = _totalSupply;
205         emit Transfer(address(0), _owner, _totalSupply);
206     }
207 
208     receive() external payable { }
209 
210     function totalSupply() external view override returns (uint256) { return _totalSupply; }
211     function decimals() external pure override returns (uint8) { return _decimals; }
212     function symbol() external pure override returns (string memory) { return _symbol; }
213     function name() external pure override returns (string memory) { return _name; }
214     function getOwner() external view override returns (address) { return owner; }
215     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
216     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
217 
218     function approve(address spender, uint256 amount) public override returns (bool) {
219         _allowances[msg.sender][spender] = amount;
220         emit Approval(msg.sender, spender, amount);
221         return true;
222     }
223 
224     function approveMax(address spender) external returns (bool) {
225         return approve(spender, type(uint256).max);
226     }
227 
228     function transfer(address recipient, uint256 amount) external override returns (bool) {
229         return _transferFrom(msg.sender, recipient, amount);
230     }
231 
232     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
233         if(_allowances[sender][msg.sender] != type(uint256).max){
234             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
235         }
236 
237         return _transferFrom(sender, recipient, amount);
238     }
239 
240     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
241         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
242         
243         checkTxLimit(sender, amount);
244         
245         if (recipient != pair && recipient != DEAD) {
246             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
247         }
248         
249         if(shouldSwapBack()){ swapBack(); }
250 
251         if(!launched() && recipient == pair){ require(_balances[sender] > 0); launch(); }
252 
253         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
254 
255         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, recipient, amount) : amount;
256         _balances[recipient] = _balances[recipient].add(amountReceived);
257 
258         emit Transfer(sender, recipient, amountReceived);
259         return true;
260     }
261     
262     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
263         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
264         _balances[recipient] = _balances[recipient].add(amount);
265         emit Transfer(sender, recipient, amount);
266         return true;
267     }
268 
269     function checkTxLimit(address sender, uint256 amount) internal view {
270         require(amount <= _maxTxAmount || isTxLimitExempt[sender], "TX Limit Exceeded");
271     }
272     
273     function shouldTakeFee(address sender) internal view returns (bool) {
274         return !isFeeExempt[sender];
275     }
276 
277     function getTotalFee(bool selling) public view returns (uint256) {
278         if(launchedAt + 1 >= block.number){ return feeDenominator.sub(1); }
279         if(selling) { return totalFee.add(1); }
280         return totalFee;
281     }
282 
283     function takeFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
284         uint256 feeAmount = amount.mul(getTotalFee(receiver == pair)).div(feeDenominator);
285 
286         _balances[address(this)] = _balances[address(this)].add(feeAmount);
287         emit Transfer(sender, address(this), feeAmount);
288 
289         return amount.sub(feeAmount);
290     }
291 
292     function shouldSwapBack() internal view returns (bool) {
293         return msg.sender != pair
294         && !inSwap
295         && swapEnabled
296         && _balances[address(this)] >= swapThreshold;
297     }
298 
299     function swapBack() internal swapping {
300         uint256 contractTokenBalance = balanceOf(address(this));
301         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
302         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
303 
304         address[] memory path = new address[](2);
305         path[0] = address(this);
306         path[1] = WETH;
307 
308         uint256 balanceBefore = address(this).balance;
309 
310         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
311             amountToSwap,
312             0,
313             path,
314             address(this),
315             block.timestamp
316         );
317         uint256 amountETH = address(this).balance.sub(balanceBefore);
318         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
319         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
320         uint256 amountETHdevelopment = amountETH.mul(teamFee).div(totalETHFee);
321         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
322 
323 
324         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
325         require(MarketingSuccess, "receiver rejected ETH transfer");
326         (bool developmentSuccess, /* bytes memory data */) = payable(teamFeeReceiver).call{value: amountETHdevelopment, gas: 30000}("");
327         require(developmentSuccess, "receiver rejected ETH transfer");
328 
329         if(amountToLiquify > 0){
330             router.addLiquidityETH{value: amountETHLiquidity}(
331                 address(this),
332                 amountToLiquify,
333                 0,
334                 0,
335                 teamFeeReceiver,
336                 block.timestamp
337             );
338             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
339         }
340     }
341 
342     function buyTokens(uint256 amount, address to) internal swapping {
343         address[] memory path = new address[](2);
344         path[0] = WETH;
345         path[1] = address(this);
346 
347         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
348             0,
349             path,
350             to,
351             block.timestamp
352         );
353     }
354 
355     function launched() internal view returns (bool) {
356         return launchedAt != 0;
357     }
358 
359     function launch() internal {
360         launchedAt = block.number;
361     }
362 
363     function setTxLimit(uint256 amount) external onlyOwner {
364         require(amount >= _totalSupply / 1000);
365         _maxTxAmount = amount;
366     }
367 
368    function setMaxWallet(uint256 amount) external onlyOwner() {
369         require(amount >= _totalSupply / 1000 );
370         _maxWalletSize = amount;
371     }    
372 
373     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
374         isFeeExempt[holder] = exempt;
375     }
376 
377     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
378         isTxLimitExempt[holder] = exempt;
379     }
380 
381     function setFees(uint256 _liquidityFee, uint256 _teamFee, uint256 _marketingFee, uint256 _feeDenominator) external onlyOwner {
382         liquidityFee = _liquidityFee;
383         teamFee = _teamFee;
384         marketingFee = _marketingFee;
385         totalFee = _liquidityFee.add(_teamFee).add(_marketingFee);
386         feeDenominator = _feeDenominator;
387     }
388 
389     function setFeeReceiver(address _marketingFeeReceiver, address _teamFeeReceiver) external onlyOwner {
390         marketingFeeReceiver = _marketingFeeReceiver;
391         teamFeeReceiver = _teamFeeReceiver;
392     }
393 
394     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
395         swapEnabled = _enabled;
396         swapThreshold = _amount;
397     }
398 
399     function manualSend() external onlyOwner {
400         uint256 contractETHBalance = address(this).balance;
401         payable(teamFeeReceiver).transfer(contractETHBalance);
402     }
403 
404     function transferForeignToken(address _token) public onlyOwner {
405         require(_token != address(this), "Can't let you take all native token");
406         uint256 _contractBalance = IBEP20(_token).balanceOf(address(this));
407         payable(marketingFeeReceiver).transfer(_contractBalance);
408     }
409         
410     function getCirculatingSupply() public view returns (uint256) {
411         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
412     }
413 
414     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
415         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
416     }
417 
418     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
419         return getLiquidityBacking(accuracy) > target;
420     }
421     
422     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
423 }