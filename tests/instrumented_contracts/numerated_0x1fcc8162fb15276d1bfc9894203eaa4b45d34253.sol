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
43 interface IBEP20 {
44     function totalSupply() external view returns (uint256);
45     function decimals() external view returns (uint8);
46     function symbol() external view returns (string memory);
47     function name() external view returns (string memory);
48     function getOwner() external view returns (address);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address _owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 abstract contract Auth {
59     address internal owner;
60     mapping (address => bool) internal authorizations;
61 
62     constructor(address _owner) {
63         owner = _owner;
64         authorizations[_owner] = true;
65     }
66 
67     modifier onlyOwner() {
68         require(isOwner(msg.sender), "!OWNER"); _;
69     }
70 
71     modifier authorized() {
72         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
73     }
74 
75     function authorize(address adr) public onlyOwner {
76         authorizations[adr] = true;
77     }
78 
79     function unauthorize(address adr) public onlyOwner {
80         authorizations[adr] = false;
81     }
82 
83     function isOwner(address account) public view returns (bool) {
84         return account == owner;
85     }
86 
87     function isAuthorized(address adr) public view returns (bool) {
88         return authorizations[adr];
89     }
90 
91     function transferOwnership(address payable adr) public onlyOwner {
92         owner = adr;
93         authorizations[adr] = true;
94         emit OwnershipTransferred(adr);
95     }
96 
97     event OwnershipTransferred(address owner);
98 }
99 
100 interface IDEXFactory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IDEXRouter {
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107 
108     function addLiquidity(
109         address tokenA,
110         address tokenB,
111         uint amountADesired,
112         uint amountBDesired,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline
117     ) external returns (uint amountA, uint amountB, uint liquidity);
118 
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 
128     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135 
136     function swapExactETHForTokensSupportingFeeOnTransferTokens(
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external payable;
142 
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 contract ViralDAO is IBEP20, Auth {
153     using SafeMath for uint256;
154 
155     string constant _name = "ViralDAO";
156     string constant _symbol = "ViralDAO";
157     uint8 constant _decimals = 9;
158 
159     uint256 _totalSupply = 100000000 * (10 ** _decimals);
160     uint256 public _maxWalletSize = (_totalSupply * 1) / 100; 
161     uint256 public _minTransferForReferral = 1 * (10 ** _decimals); 
162 
163     mapping (address => uint256) _balances;
164     mapping (address => mapping (address => uint256)) _allowances;
165     
166     mapping (address => bool) isFeeExempt;
167     mapping (address => address) public referrer; 
168     mapping(address => bool) public isReferred;
169 
170     uint256 liquidityFee = 3;
171     uint256 devFee = 0;
172     uint256 marketingFee = 4;
173 
174     uint256 totalFee = 10;
175     uint256 feeDenominator = 100;
176 
177     uint256 referralFee = 3;
178 
179     uint256 public minSupplyForReferralReward = (_totalSupply * 1) / 1000;
180     
181     address private marketingFeeReceiver = 0xBC456bbe548D24dB5d11b577f79f50D2a9C33317;
182 
183     IDEXRouter public router;
184     address public pair;
185 
186     bool public swapEnabled = true;
187     uint256 public swapThreshold = _totalSupply / 1000 * 3; // 0.3%
188 
189     bool inSwap;
190     modifier swapping() { inSwap = true; _; inSwap = false; }
191 
192     event ReferralBonus(address indexed feesTo , address indexed feesFrom , uint value);
193     event Referred(address indexed referred,address indexed referrer);
194 
195     constructor () Auth(msg.sender) {
196         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
197         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
198         _allowances[address(this)][address(router)] = type(uint256).max;
199 
200         address _owner = owner;
201         isFeeExempt[_owner] = true;
202         isFeeExempt[pair] = true;
203         isFeeExempt[address(router)] = true;
204 
205         isReferred[_owner] = true;
206         
207         _balances[_owner] = _totalSupply;
208         emit Transfer(address(0), _owner, _totalSupply);
209     }
210 
211     receive() external payable { }
212 
213     function totalSupply() external view override returns (uint256) { return _totalSupply; }
214     function decimals() external pure override returns (uint8) { return _decimals; }
215     function symbol() external pure override returns (string memory) { return _symbol; }
216     function name() external pure override returns (string memory) { return _name; }
217     function getOwner() external view override returns (address) { return owner; }
218     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
219     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
220 
221     function approve(address spender, uint256 amount) public override returns (bool) {
222         _allowances[msg.sender][spender] = amount;
223         emit Approval(msg.sender, spender, amount);
224         return true;
225     }
226 
227     function approveMax(address spender) external returns (bool) {
228         return approve(spender, type(uint256).max);
229     }
230 
231     function transfer(address recipient, uint256 amount) external override returns (bool) {
232         return _transferFrom(msg.sender, recipient, amount);
233     }
234 
235     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
236         if(_allowances[sender][msg.sender] != type(uint256).max){
237             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
238         }
239 
240         return _transferFrom(sender, recipient, amount);
241     }
242 
243     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
244         if(inSwap){ return _basicTransfer(sender, recipient, amount); }    
245 
246         if (recipient != pair) {
247             require(isFeeExempt[recipient] || _balances[recipient] + amount <= _maxWalletSize, "Transfer amount exceeds the bag size.");
248         }
249 
250         uint256 amountReceived = amount; 
251         
252         if(sender == pair) { //buy
253             if(!isFeeExempt[recipient]) {
254                 require(isReferred[recipient],"Not referred");
255                 amountReceived = takeReferralFees(recipient,amount);
256             }
257 
258         } else if(recipient == pair) { //sell
259             if(shouldTakeFee(sender)) {
260                 amountReceived = takeFee(sender, amount);
261             }  
262 
263         } else if(isReferred[recipient]==false) {
264             if(amount >= _minTransferForReferral) {
265                 isReferred[recipient] = true;
266                 referrer[recipient] = sender;
267                 emit Referred(recipient,sender);
268             }
269         } 
270         
271         if(shouldSwapBack()){ swapBack(); }
272 
273         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
274         _balances[recipient] = _balances[recipient].add(amountReceived);
275 
276         emit Transfer(sender, recipient, amountReceived);
277         return true;
278     }
279     
280     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
281         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
282         _balances[recipient] = _balances[recipient].add(amount);
283         emit Transfer(sender, recipient, amount);
284         return true;
285     }
286 
287     function takeReferralFees(address from,uint256 amount) internal returns(uint) {
288         uint256 referralTokens = referralFee * amount / feeDenominator;
289         if(_balances[referrer[from]] > minSupplyForReferralReward) {
290             _balances[referrer[from]] = _balances[referrer[from]].add(referralTokens);
291             emit ReferralBonus(referrer[from],from,referralTokens);
292         } else {
293              _balances[marketingFeeReceiver] = _balances[marketingFeeReceiver].add(referralTokens);
294             emit ReferralBonus(marketingFeeReceiver,from,referralTokens);
295         }
296 
297         return amount - referralTokens;
298     }
299     
300     function shouldTakeFee(address sender) internal view returns (bool) {
301         return !isFeeExempt[sender];
302     }
303 
304     function takeFee(address sender, uint256 amount) internal returns (uint256) {
305         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
306 
307         _balances[address(this)] = _balances[address(this)].add(feeAmount);
308         emit Transfer(sender, address(this), feeAmount);
309 
310         return amount.sub(feeAmount);
311     }
312 
313     function shouldSwapBack() internal view returns (bool) {
314         return msg.sender != pair
315         && !inSwap
316         && swapEnabled
317         && _balances[address(this)] >= swapThreshold;
318     }
319 
320     function swapBack() internal swapping {
321         uint256 contractTokenBalance = balanceOf(address(this));
322         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
323         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
324 
325         address[] memory path = new address[](2);
326         path[0] = address(this);
327         path[1] = router.WETH();
328 
329         uint256 balanceBefore = address(this).balance;
330 
331         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
332             amountToSwap,
333             0,
334             path,
335             address(this),
336             block.timestamp
337         );
338         uint256 amountBNB = address(this).balance.sub(balanceBefore);
339         uint256 totalBNBFee = totalFee.sub(liquidityFee.div(2));
340         uint256 amountBNBLiquidity = amountBNB.mul(liquidityFee).div(totalBNBFee).div(2);
341         uint256 amountBNBMarketing = amountBNB - amountBNBLiquidity;
342 
343         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountBNBMarketing, gas: 30000}("");
344         require(MarketingSuccess, "receiver rejected ETH transfer");
345         addLiquidity(amountToLiquify, amountBNBLiquidity);
346     }
347 
348     function addLiquidity(uint256 tokenAmount, uint256 BNBAmount) private {
349         if(tokenAmount > 0){
350                 router.addLiquidityETH{value: BNBAmount}(
351                     address(this),
352                     tokenAmount,
353                     0,
354                     0,
355                     address(this),
356                     block.timestamp
357                 );
358                 emit AutoLiquify(BNBAmount, tokenAmount);
359             }
360     }
361 
362     function setMaxWallet(uint256 amount) external onlyOwner() {
363         require(amount >= _totalSupply / 1000 );
364         _maxWalletSize = amount;
365     }   
366 
367     function setMinTransferForReferral(uint256 amount) external onlyOwner() {
368         require(amount <= 1*(10**_decimals) );
369         _minTransferForReferral = amount; 
370     }
371 
372     function setIsFeeExempt(address holder, bool exempt) external authorized {
373         isFeeExempt[holder] = exempt;
374     }
375 
376     function setFees(uint256 _liquidityFee, uint256 _devFee, uint256 _marketingFee, uint256 _feeDenominator) external authorized {
377         liquidityFee = _liquidityFee;
378         devFee = _devFee;
379         marketingFee = _marketingFee;
380         totalFee = _liquidityFee.add(_devFee).add(_marketingFee);
381         feeDenominator = _feeDenominator;
382     }
383 
384     function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
385         swapEnabled = _enabled;
386         swapThreshold = _amount;
387     }
388 
389     function manualSend() external authorized {
390         uint256 contractETHBalance = address(this).balance;
391         payable(marketingFeeReceiver).transfer(contractETHBalance);
392     }
393 
394     function transferForeignToken(address _token) public authorized {
395         require(_token != address(this), "Can't let you take all native token");
396         uint256 _contractBalance = IBEP20(_token).balanceOf(address(this));
397         payable(marketingFeeReceiver).transfer(_contractBalance);
398     }
399     
400     event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
401 }