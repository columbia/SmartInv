1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.14;
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
42     function getOwner() external view returns (address);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address _owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 abstract contract Auth {
53     address internal owner;
54     mapping (address => bool) internal authorizations;
55 
56     constructor(address _owner) {
57         owner = _owner;
58         authorizations[_owner] = true;
59     }
60 
61     modifier onlyOwner() {
62         require(isOwner(msg.sender), "!OWNER"); _;
63     }
64 
65     modifier authorized() {
66         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
67     }
68 
69     function authorize(address adr) external onlyOwner {
70         authorizations[adr] = true;
71     }
72 
73     function unauthorize(address adr) external onlyOwner {
74         require(adr != owner, "OWNER cant be unauthorized");
75         authorizations[adr] = false;
76     }
77 
78     function isOwner(address account) public view returns (bool) {
79         return account == owner;
80     }
81 
82     function isAuthorized(address adr) public view returns (bool) {
83         return authorizations[adr];
84     }
85 
86     function transferOwnership(address payable _newOwner) external onlyOwner {
87         authorizations[owner] = false;
88         owner = _newOwner;
89         authorizations[owner] = true;
90         emit OwnershipTransferred(owner);
91     }
92 
93     function renounceOwnership() external onlyOwner {
94         authorizations[owner] = false;
95         owner = address(0);
96         emit OwnershipTransferred(owner);
97     }
98 
99     event OwnershipTransferred(address owner);
100 }
101 
102 interface IDEXFactory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IDEXRouter {
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109 
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126 }
127 
128 contract ERC20TALEOFHACHIKO is ERC20, Auth {
129     using SafeMath for uint256;
130 
131     address immutable WETH;
132     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
133     address constant ZERO = 0x0000000000000000000000000000000000000000;
134 
135     string public constant name = "Tale Of Hachiko";
136     string public constant symbol = "tHACHI";
137     uint8 public constant decimals = 9;
138 
139     uint256 public constant totalSupply = 5 * 10**6 * 10**decimals;
140 
141     uint256 public _maxTxAmount = totalSupply / 100;
142     uint256 public _maxWalletToken = totalSupply / 100;
143 
144     mapping (address => uint256) public balanceOf;
145     mapping (address => mapping (address => uint256)) _allowances;
146 
147     mapping (address => bool) public isFeeExempt;
148     mapping (address => bool) public isTxLimitExempt;
149     mapping (address => bool) public isWalletLimitExempt;
150 
151     uint256 public liquidityFee = 10;
152     uint256 public marketingFee = 30;
153     uint256 public totalFee = marketingFee + liquidityFee;
154     uint256 public constant feeDenominator = 1000;
155 
156     uint256 sellMultiplier = 2250;
157     uint256 buyMultiplier = 2250;
158     uint256 transferMultiplier = 2250;
159 
160     address public marketingFeeReceiver;
161     address public autoLpReceiver;
162 
163     IDEXRouter public router;
164     address public immutable pair;
165 
166     bool public tradingOpen = false;
167 
168     bool public swapEnabled = true;
169     uint256 public swapThreshold = totalSupply / 500;
170     bool inSwap;
171     modifier swapping() { inSwap = true; _; inSwap = false; }
172 
173     constructor () Auth(msg.sender) {
174         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
175         WETH = router.WETH();
176 
177         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
178         _allowances[address(this)][address(router)] = type(uint256).max;
179 
180         marketingFeeReceiver = 0xCaD3bA40091d3DdDa7c5c4b0aaFeAECa2f9c845A;
181         autoLpReceiver = msg.sender;
182 
183         isFeeExempt[msg.sender] = true;
184 
185         isTxLimitExempt[msg.sender] = true;
186         isTxLimitExempt[DEAD] = true;
187         isTxLimitExempt[ZERO] = true;
188 
189         isWalletLimitExempt[msg.sender] = true;
190         isWalletLimitExempt[address(this)] = true;
191         isWalletLimitExempt[DEAD] = true;
192         isWalletLimitExempt[ZERO] = true;
193 
194         balanceOf[msg.sender] = totalSupply;
195         emit Transfer(address(0), msg.sender, totalSupply);
196     }
197 
198     receive() external payable { }
199 
200     function getOwner() external view override returns (address) { return owner; }
201     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _allowances[msg.sender][spender] = amount;
205         emit Approval(msg.sender, spender, amount);
206         return true;
207     }
208 
209     function approveMax(address spender) external returns (bool) {
210         return approve(spender, type(uint256).max);
211     }
212 
213     function transfer(address recipient, uint256 amount) external override returns (bool) {
214         return _transferFrom(msg.sender, recipient, amount);
215     }
216 
217     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
218         if(_allowances[sender][msg.sender] != type(uint256).max){
219             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
220         }
221 
222         return _transferFrom(sender, recipient, amount);
223     }
224 
225     function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
226         require(maxWallPercent_base1000 >= 5,"Cannot set max wallet less than 0.5%");
227         _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
228     }
229     function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
230         require(maxTXPercentage_base1000 >= 5,"Cannot set max transaction less than 0.5%");
231         _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
232     }
233 
234     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
235         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
236 
237         if(!authorizations[sender] && !authorizations[recipient]){
238             require(tradingOpen,"Trading not open yet");
239         }
240 
241         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
242             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
243         }
244     
245         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
246 
247         if(shouldSwapBack()){ swapBack(); }
248 
249         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
250 
251         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
252 
253         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
254 
255         emit Transfer(sender, recipient, amountReceived);
256         return true;
257     }
258     
259     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
260         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
261         balanceOf[recipient] = balanceOf[recipient].add(amount);
262         emit Transfer(sender, recipient, amount);
263         return true;
264     }
265 
266     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
267         if(amount == 0 || totalFee == 0){
268             return amount;
269         }
270 
271         uint256 multiplier = transferMultiplier;
272 
273         if(recipient == pair) {
274             multiplier = sellMultiplier;
275         } else if(sender == pair) {
276             multiplier = buyMultiplier;
277         }
278 
279         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
280 
281         if(feeAmount > 0){
282             balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);
283             emit Transfer(sender, address(this), feeAmount);
284         }
285 
286         return amount.sub(feeAmount);
287     }
288 
289     function shouldSwapBack() internal view returns (bool) {
290         return msg.sender != pair
291         && !inSwap
292         && swapEnabled
293         && balanceOf[address(this)] >= swapThreshold;
294     }
295 
296     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
297         uint256 amountETH = address(this).balance;
298         uint256 amountToClear = ( amountETH * amountPercentage ) / 100;
299         payable(msg.sender).transfer(amountToClear);
300     }
301 
302     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
303         if(tokens == 0){
304             tokens = ERC20(tokenAddress).balanceOf(address(this));
305         }
306         return ERC20(tokenAddress).transfer(msg.sender, tokens);
307     }
308 
309     function goLive() external onlyOwner {
310         tradingOpen = true;
311     }
312 
313     function swapBack() internal swapping {
314 
315         uint256 totalETHFee = totalFee;
316 
317         uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalETHFee * 2);
318         uint256 amountToSwap = swapThreshold - amountToLiquify;
319 
320         address[] memory path = new address[](2);
321         path[0] = address(this);
322         path[1] = WETH;
323 
324         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
325             amountToSwap,
326             0,
327             path,
328             address(this),
329             block.timestamp
330         );
331 
332         uint256 amountETH = address(this).balance;
333 
334         totalETHFee = totalETHFee - (liquidityFee / 2);
335         
336         uint256 amountETHLiquidity = (amountETH * liquidityFee) / (totalETHFee * 2);
337         uint256 amountETHMarketing = (amountETH * marketingFee) / totalETHFee;
338 
339         payable(marketingFeeReceiver).transfer(amountETHMarketing);
340 
341         if(amountToLiquify > 0){
342             router.addLiquidityETH{value: amountETHLiquidity}(
343                 address(this),
344                 amountToLiquify,
345                 0,
346                 0,
347                 autoLpReceiver,
348                 block.timestamp
349             );
350         }
351     }
352 
353     function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
354         for (uint256 i=0; i < addresses.length; ++i) {
355             isFeeExempt[addresses[i]] = status;
356         }
357     }
358 
359     function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
360         for (uint256 i=0; i < addresses.length; ++i) {
361             isTxLimitExempt[addresses[i]] = status;
362         }
363     }
364 
365     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
366         for (uint256 i=0; i < addresses.length; ++i) {
367             isWalletLimitExempt[addresses[i]] = status;
368         }
369     }
370 
371     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
372         sellMultiplier = _sell;
373         buyMultiplier = _buy;
374         transferMultiplier = _trans;
375     }
376 
377     function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee) external onlyOwner {
378         liquidityFee = _liquidityFee;
379         marketingFee = _marketingFee;
380 
381         totalFee = liquidityFee + marketingFee;
382     }
383 
384     function setMarketingWallet(address _marketingFeeReceiver) external onlyOwner {
385         marketingFeeReceiver = _marketingFeeReceiver;
386     }
387 
388     function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
389         swapEnabled = _enabled;
390         swapThreshold = _amount;
391     }
392     
393     function getCirculatingSupply() public view returns (uint256) {
394         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
395     }
396 }