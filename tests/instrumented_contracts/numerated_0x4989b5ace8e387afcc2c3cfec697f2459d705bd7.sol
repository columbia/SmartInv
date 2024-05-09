1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4  * DogeNetwork (DGNW) - A social network powered by DOGE!
5  * 
6  * https://DogeSocialNetwork.com
7  * https://t.me/DogeNetworkPortalWow
8  *
9  */
10 
11 pragma solidity ^0.8.12;
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
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
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         return c;
46     }
47 }
48 
49 interface ERC20 {
50     function totalSupply() external view returns (uint256);
51     function decimals() external view returns (uint8);
52     function symbol() external view returns (string memory);
53     function name() external view returns (string memory);
54     function getOwner() external view returns (address);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address _owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 abstract contract Auth {
65     address internal owner;
66     mapping (address => bool) internal authorizations;
67 
68     constructor(address _owner) {
69         owner = _owner;
70         authorizations[_owner] = true;
71     }
72 
73     modifier onlyOwner() {
74         require(isOwner(msg.sender), "!OWNER"); _;
75     }
76 
77     modifier authorized() {
78         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
79     }
80 
81     function authorize(address adr) public onlyOwner {
82         authorizations[adr] = true;
83     }
84 
85     function unauthorize(address adr) public onlyOwner {
86         require(adr != owner, "OWNER cant be unauthorized");
87         authorizations[adr] = false;
88     }
89 
90     function isOwner(address account) public view returns (bool) {
91         return account == owner;
92     }
93 
94     function isAuthorized(address adr) public view returns (bool) {
95         return authorizations[adr];
96     }
97 
98     function transferOwnership(address payable adr) public onlyOwner {
99         require(adr != owner, "Already the owner");
100         authorizations[owner] = false;
101         owner = adr;
102         authorizations[adr] = true;
103         emit OwnershipTransferred(adr);
104     }
105 
106     event OwnershipTransferred(address owner);
107 }
108 
109 interface IDEXFactory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IDEXRouter {
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
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
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133 }
134 
135 contract DogeNetwork is ERC20, Auth {
136     using SafeMath for uint256;
137 
138     address WETH;
139     address DEAD = 0x000000000000000000000000000000000000dEaD;
140     address ZERO = 0x0000000000000000000000000000000000000000;
141 
142     string constant _name = "DogeNetwork";
143     string constant _symbol = "DGNW";
144     uint8 constant _decimals = 4;
145 
146     uint256 _totalSupply = 1 * 10**6 * 10**_decimals;
147 
148     uint256 public _maxTxAmount = _totalSupply / 100;
149     uint256 public _maxWalletToken = _totalSupply / 50;
150 
151     mapping (address => uint256) _balances;
152     mapping (address => mapping (address => uint256)) _allowances;
153 
154     mapping (address => bool) isFeeExempt;
155     mapping (address => bool) isTxLimitExempt;
156     mapping (address => bool) isWalletLimitExempt;
157 
158     uint256 public liquidityFee = 6;
159     uint256 public marketingFee = 2;
160     uint256 public devFee = 2;
161     uint256 public totalFee = marketingFee + liquidityFee + devFee;
162     uint256 public constant feeDenominator = 100;
163 
164     address public autoLiquidityReceiver;
165     address public marketingFeeReceiver;
166     address public devFeeReceiver;
167 
168     IDEXRouter public router;
169     address public pair;
170 
171     bool public tradingOpen = false;
172 
173     bool public swapEnabled = true;
174     uint256 public swapThreshold = _totalSupply / 1000;
175     bool inSwap;
176     modifier swapping() { inSwap = true; _; inSwap = false; }
177 
178     constructor () Auth(msg.sender) {
179         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
180         WETH = router.WETH();
181 
182         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
183         _allowances[address(this)][address(router)] = type(uint256).max;
184 
185         autoLiquidityReceiver = msg.sender;
186         marketingFeeReceiver = 0xbAa5302e45113D6ba0541C2b091fC7c6D8da8E26;
187        	devFeeReceiver = msg.sender;
188 
189         isFeeExempt[msg.sender] = true;
190 
191         isTxLimitExempt[msg.sender] = true;
192         isTxLimitExempt[DEAD] = true;
193         isTxLimitExempt[ZERO] = true;
194 
195         isWalletLimitExempt[msg.sender] = true;
196         isWalletLimitExempt[address(this)] = true;
197         isWalletLimitExempt[DEAD] = true;
198 
199         _balances[msg.sender] = _totalSupply;
200         emit Transfer(address(0), msg.sender, _totalSupply);
201     }
202 
203     receive() external payable { }
204 
205     function totalSupply() external view override returns (uint256) { return _totalSupply; }
206     function decimals() external pure override returns (uint8) { return _decimals; }
207     function symbol() external pure override returns (string memory) { return _symbol; }
208     function name() external pure override returns (string memory) { return _name; }
209     function getOwner() external view override returns (address) { return owner; }
210     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
211     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _allowances[msg.sender][spender] = amount;
215         emit Approval(msg.sender, spender, amount);
216         return true;
217     }
218 
219     function approveMax(address spender) external returns (bool) {
220         return approve(spender, type(uint256).max);
221     }
222 
223     function transfer(address recipient, uint256 amount) external override returns (bool) {
224         return _transferFrom(msg.sender, recipient, amount);
225     }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
228         if(_allowances[sender][msg.sender] != type(uint256).max){
229             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
230         }
231 
232         return _transferFrom(sender, recipient, amount);
233     }
234 
235     function updateMaxWallet(uint256 maxWalletPercent) external onlyOwner {
236         require(maxWalletPercent >= 2, "Min 2%");
237         require(maxWalletPercent <= 100, "Max 100%");
238         _maxWalletToken = _totalSupply * maxWalletPercent / 100;
239     }
240 
241     function updateMaxTransaction(uint256 maxTransactionPercent) external onlyOwner {
242         require(maxTransactionPercent >= 1, "Min 1%");
243         require(maxTransactionPercent <= 100, "Max 100%");
244         _maxTxAmount = _totalSupply * maxTransactionPercent / 100;
245     }
246 
247     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
248         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
249 
250         if(!authorizations[sender] && !authorizations[recipient]){
251             require(tradingOpen,"Trading not open yet");
252         }
253 
254         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
255             require((balanceOf(recipient) + amount) <= _maxWalletToken,"max wallet limit reached");
256         }
257 
258         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
259 
260         if(shouldSwapBack()){ swapBack(); }
261 
262         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
263 
264         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount);
265 
266         _balances[recipient] = _balances[recipient].add(amountReceived);
267 
268         emit Transfer(sender, recipient, amountReceived);
269         return true;
270     }
271     
272     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
273         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
274         _balances[recipient] = _balances[recipient].add(amount);
275         emit Transfer(sender, recipient, amount);
276         return true;
277     }
278 
279     function takeFee(address sender, uint256 amount) internal returns (uint256) {
280 
281         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
282 
283         if(feeAmount > 0){
284             _balances[address(this)] = _balances[address(this)].add(feeAmount);
285             emit Transfer(sender, address(this), feeAmount);
286         } 
287 
288         return amount.sub(feeAmount);
289     }
290 
291     function shouldSwapBack() internal view returns (bool) {
292         return msg.sender != pair
293         && !inSwap
294         && swapEnabled
295         && _balances[address(this)] >= swapThreshold;
296     }
297 
298     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
299         uint256 amountETH = address(this).balance;
300         payable(msg.sender).transfer(amountETH * amountPercentage / 100);
301     }
302 
303     function clearContractSells(uint256 amountPercentage) external onlyOwner {
304         uint256 tokensInContract = balanceOf(address(this));
305         uint256 tokenstosell = tokensInContract.mul(amountPercentage).div(100);
306         _basicTransfer(address(this),msg.sender,tokenstosell);
307     }
308 
309     function openTrading() external onlyOwner {
310         tradingOpen = true;
311     }
312 
313     function swapBack() internal swapping {
314         uint256 dynamicLiquidityFee = liquidityFee;
315         uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
316         uint256 amountToSwap = swapThreshold.sub(amountToLiquify);
317 
318         address[] memory path = new address[](2);
319         path[0] = address(this);
320         path[1] = WETH;
321 
322         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
323             amountToSwap,
324             0,
325             path,
326             address(this),
327             block.timestamp
328         );
329 
330         uint256 amountETH = address(this).balance;
331 
332         uint256 totalETHFee = totalFee.sub(dynamicLiquidityFee.div(2));
333         
334         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
335         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
336         uint256 amountETHDev = amountETH.mul(devFee).div(totalETHFee);
337 
338         payable(marketingFeeReceiver).transfer(amountETHMarketing);
339         payable(devFeeReceiver).transfer(amountETHDev);
340 
341         if(amountToLiquify > 0){
342             router.addLiquidityETH{value: amountETHLiquidity}(
343                 address(this),
344                 amountToLiquify,
345                 0,
346                 0,
347                 autoLiquidityReceiver,
348                 block.timestamp
349             );
350             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
351         }
352     }
353 
354     function setFees(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _devFee) external onlyOwner {
355         liquidityFee = _liquidityFee;
356         marketingFee = _marketingFee;
357         devFee = _devFee;
358         totalFee = _liquidityFee + _marketingFee + _devFee;
359         
360         require(totalFee < 11, "Tax cannot be more than 10%");
361     }
362 
363     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _devFeeReceiver) external onlyOwner {
364         autoLiquidityReceiver = _autoLiquidityReceiver;
365         marketingFeeReceiver = _marketingFeeReceiver;
366         devFeeReceiver = _devFeeReceiver;
367     }
368 
369     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
370         swapEnabled = _enabled;
371         swapThreshold = _amount;
372     }
373     
374     function getCirculatingSupply() public view returns (uint256) {
375         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
376     }
377 
378 
379 event AutoLiquify(uint256 amountETH, uint256 amountTokens);
380 }