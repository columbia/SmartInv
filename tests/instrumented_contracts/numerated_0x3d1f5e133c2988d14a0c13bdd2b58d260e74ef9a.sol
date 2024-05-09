1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.5;
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7         return c;
8     }
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         return sub(a, b, "SafeMath: subtraction overflow");
11     }
12     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
13         require(b <= a, errorMessage);
14         uint256 c = a - b;
15         return c;
16     }
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         require(c / a == b, "SafeMath: multiplication overflow");
23         return c;
24     }
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         return div(a, b, "SafeMath: division by zero");
27     }
28     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b > 0, errorMessage);
30         uint256 c = a / b;
31         return c;
32     }
33 }
34 
35 interface ERC20 {
36     function totalSupply() external view returns (uint256);
37     function decimals() external view returns (uint8);
38     function symbol() external view returns (string memory);
39     function name() external view returns (string memory);
40     function getOwner() external view returns (address);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address _owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 abstract contract Ownable {
51     address internal owner;
52     constructor(address _owner) {
53         owner = _owner;
54     }
55     modifier onlyOwner() {
56         require(isOwner(msg.sender), "!OWNER"); _;
57     }
58     function isOwner(address account) public view returns (bool) {
59         return account == owner;
60     }
61     function renounceOwnership() public onlyOwner {
62         owner = address(0);
63         emit OwnershipTransferred(address(0));
64     }  
65     event OwnershipTransferred(address owner);
66 }
67 
68 interface IDEXFactory {
69     function createPair(address tokenA, address tokenB) external returns (address pair);
70 }
71 
72 interface IDEXRouter {
73     function factory() external pure returns (address);
74     function WETH() external pure returns (address);
75     function addLiquidity(
76         address tokenA,
77         address tokenB,
78         uint amountADesired,
79         uint amountBDesired,
80         uint amountAMin,
81         uint amountBMin,
82         address to,
83         uint deadline
84     ) external returns (uint amountA, uint amountB, uint liquidity);
85     function addLiquidityETH(
86         address token,
87         uint amountTokenDesired,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline
92     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
93     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function swapExactETHForTokensSupportingFeeOnTransferTokens(
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external payable;
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113 }
114 
115 contract OMEGA is ERC20, Ownable {
116     using SafeMath for uint256;
117     address routerAdress;
118     address DEAD = 0x000000000000000000000000000000000000dEaD;
119 
120     string constant _name = "OMEGA FINANCE";
121     string constant _symbol = "OMG";
122     uint8 constant _decimals = 9;
123 
124     uint256 _totalSupply = 1 * 10**6 * (10 ** _decimals); // 1 Million
125 
126     mapping(address => uint256) _balances;
127     mapping(address => mapping (address => uint256)) _allowances;
128 
129     address public marketingFeeReceiver = 0xe07692319060db7344ccDc7D777ee32236f80f7d;
130 
131     IDEXRouter public router;
132     address public pair;
133 
134     struct user {
135         uint256 firstBuy;
136         uint256 lastTradeTime;
137     }
138 
139     mapping(address => bool) public isFeeExempt;
140     mapping(address => bool) public isTxLimitExempt;
141     mapping(address => bool) public isBot;
142     mapping(address => user) public tradeData;
143 
144     uint256 liquidityFee = 0;
145     uint256 marketingFee = 10;
146     uint256 totalFee = liquidityFee + marketingFee;
147     uint256 feeDenominator = 100;
148 
149     bool inSwap;
150     bool public swapEnabled = true;
151     modifier swapping() { inSwap = true; _; inSwap = false; }
152 
153     uint256 public maxWalletAmount = (_totalSupply * 100) / 10000; //1% of Total Supply  
154     uint256 public maxSellTransactionAmount = (_totalSupply * 100) / 100000; //0.1% of Total Supply
155     uint256 public swapThreshold = (_totalSupply * 500) / 100000; //0.5% of Total Supply
156     uint256 public sellCooldownSeconds = 86400;//86400; //1 Day
157     uint256 public sellPercent = 10; //0.1%
158 
159     bool private sellLimited = true;
160     bool private p2pLimited = true;
161 
162     uint256 public startTime;
163 
164     modifier checkLimit(address sender, address recipient, uint256 amount) {
165         if(!isTxLimitExempt[sender] && recipient == pair) {
166             require(sold[sender][getCurrentDay()] + amount <= getUserSellLimit(sender), "Cannot sell or transfer more than limit.");
167         }
168         _;
169     }
170     mapping(address => mapping(uint256 => uint256)) public sold;
171 
172     constructor () Ownable(msg.sender) {
173     
174             routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
175 
176         router = IDEXRouter(routerAdress);
177         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
178         _allowances[address(this)][address(router)] = type(uint256).max;
179 
180         address _owner = owner;
181         isFeeExempt[_owner] = true;
182         isFeeExempt[0xe07692319060db7344ccDc7D777ee32236f80f7d] = true;
183         
184         isTxLimitExempt[_owner] = true;
185         isTxLimitExempt[0xe07692319060db7344ccDc7D777ee32236f80f7d] = true;
186         isTxLimitExempt[DEAD] = true;
187 
188         startTime = block.timestamp;
189 
190         _balances[_owner] = _totalSupply;
191         emit Transfer(address(0), _owner, _totalSupply);
192     }
193 
194     receive() external payable { }
195 
196     function totalSupply() external view override returns (uint256) { return _totalSupply; }
197     function decimals() external pure override returns (uint8) { return _decimals; }
198     function symbol() external pure override returns (string memory) { return _symbol; }
199     function name() external pure override returns (string memory) { return _name; }
200     function getOwner() external view override returns (address) { return owner; }
201     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
202     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
203 
204     function approve(address spender, uint256 amount) public override returns (bool) {
205         _allowances[msg.sender][spender] = amount;
206         emit Approval(msg.sender, spender, amount);
207         return true;
208     }
209 
210     function approveMax(address spender) external returns (bool) {
211         return approve(spender, type(uint256).max);
212     }
213 
214     function getCurrentDay() public view returns (uint256) {
215         return minZero(block.timestamp, startTime).div(sellCooldownSeconds);
216     }
217 
218     function getCirculatingSupply() public view returns (uint256) {
219         return
220             (_totalSupply - _balances[DEAD]);
221     }
222 
223     function getUserSellLimitMultiplier(address sender) internal view returns (uint256) {
224         uint multiplier;
225 
226         if(tradeData[sender].lastTradeTime == 0) {
227             multiplier = ((block.timestamp - tradeData[sender].firstBuy) / sellCooldownSeconds).mul(1000);
228         } else {
229             multiplier = ((block.timestamp - tradeData[sender].lastTradeTime) / sellCooldownSeconds).mul(1000);
230         }
231 
232         return multiplier < 1000 ? 1000 : multiplier;
233     }
234 
235     function getUserSellLimit(address sender) public view returns (uint256) {
236         uint256 calc = getUserSellLimitMultiplier(sender).div(1000);
237         uint256 calc2 = calc.mul(sellPercent);
238 
239         return getCirculatingSupply().mul(calc2).div(10000);
240     }
241 
242     function transfer(address recipient, uint256 amount) external override returns (bool) {
243         return _transferFrom(msg.sender, recipient, amount);
244     }
245 
246     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
247         if(_allowances[sender][msg.sender] != type(uint256).max){
248             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
249         }
250 
251         return _transferFrom(sender, recipient, amount);
252     }
253 
254     function _transferFrom(address sender, address recipient, uint256 amount) internal checkLimit(sender, recipient, amount) returns (bool) {
255         require(!isBot[sender], "Bot Address");
256 
257         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
258 
259         if(recipient != pair && sender != pair && recipient != DEAD && p2pLimited){
260             require(isFeeExempt[recipient] || isFeeExempt[sender] || isTxLimitExempt[recipient] || isTxLimitExempt[sender], "P2P not allowed");
261         }
262 
263         if (recipient != pair && recipient != DEAD) {
264             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= maxWalletAmount, "Transfer amount exceeds the bag size.");
265         }
266 
267          if(!isTxLimitExempt[recipient] && sender == pair) {
268             tradeData[recipient].firstBuy = block.timestamp;
269         }
270 
271         if(!isTxLimitExempt[sender] && recipient == pair) {
272             tradeData[sender].lastTradeTime = block.timestamp;
273             sold[sender][getCurrentDay()] = sold[sender][getCurrentDay()].add(amount);
274         }
275         
276         if(shouldSwapBack()){ swapBack(); } 
277 
278         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
279 
280         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
281         _balances[recipient] = _balances[recipient].add(amountReceived);
282 
283         emit Transfer(sender, recipient, amountReceived);
284         return true;
285        
286     }
287     
288     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
289         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
290         _balances[recipient] = _balances[recipient].add(amount);
291         emit Transfer(sender, recipient, amount);
292         return true;
293     }
294 
295     function shouldTakeFee(address sender) internal view returns (bool) {
296         return !isFeeExempt[sender];
297     }
298 
299     function takeFee(address sender, uint256 amount) internal returns (uint256) {
300         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
301         _balances[address(this)] = _balances[address(this)].add(feeAmount);
302         emit Transfer(sender, address(this), feeAmount);
303         return amount.sub(feeAmount);
304     }
305 
306     function shouldSwapBack() internal view returns (bool) {
307         return msg.sender != pair
308         && !inSwap
309         && swapEnabled
310         && _balances[address(this)] >= swapThreshold;
311     }
312 
313     function swapBack() internal swapping {
314         uint256 contractTokenBalance = swapThreshold;
315         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
316         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
317 
318         address[] memory path = new address[](2);
319         path[0] = address(this);
320         path[1] = router.WETH();
321 
322         uint256 balanceBefore = address(this).balance;
323 
324         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
325             amountToSwap,
326             0,
327             path,
328             address(this),
329             block.timestamp
330         );
331         uint256 amountETH = address(this).balance.sub(balanceBefore);
332         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
333         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
334         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
335 
336         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
337         require(MarketingSuccess, "receiver rejected ETH transfer");
338 
339         if(amountToLiquify > 0){
340             router.addLiquidityETH{value: amountETHLiquidity}(
341                 address(this),
342                 amountToLiquify,
343                 0,
344                 0,
345                 marketingFeeReceiver,
346                 block.timestamp
347             );
348             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
349         }
350     }
351 
352     function buyTokens(uint256 amount, address to) internal swapping {
353         address[] memory path = new address[](2);
354         path[0] = router.WETH();
355         path[1] = address(this);
356 
357         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
358             0,
359             path,
360             to,
361             block.timestamp
362         );
363     }
364 
365     function clearStuckBalance() external onlyOwner {
366         payable(marketingFeeReceiver).transfer(address(this).balance);
367     }
368 
369     function clearStuckTokens(address _tokenAddr, address _to, uint256 _amount) external onlyOwner {
370         require(ERC20(_tokenAddr).transfer(_to, _amount), "Transfer failed");
371     }
372 
373     function setWalletLimit(uint256 amountPercent) external onlyOwner {
374         maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
375     }
376 
377     function isBots(address botAddress, bool status) external onlyOwner {      
378         isBot[botAddress] = status;
379     }
380 
381     function addBots(address[] calldata botAddress, bool status) external onlyOwner {
382         for (uint256 i = 0; i < botAddress.length; i++) {
383              isBot[botAddress[i]] = status;
384         }      
385     }
386 
387      function setFees(uint256 _LiquidityFee, uint256 _MarketingFee) external onlyOwner {
388         marketingFee = _MarketingFee;
389         liquidityFee = _LiquidityFee;
390         totalFee = liquidityFee + marketingFee;
391 
392         require(totalFee <= 25, "Must keep fees at 25% or less");
393     }
394   
395     function setContractLimits(bool sellLimited_, bool p2pLimited_) external onlyOwner {
396         sellLimited = sellLimited_;
397         p2pLimited = p2pLimited_;
398     }
399     
400     function viewContractLimits() external view returns (bool isSellLimited, bool isP2PLimited){
401         return(sellLimited,p2pLimited);
402     }
403 
404     function setADMSettings(uint256 sellCooldownSeconds_, uint256 maxSellTransactionAmount_, uint256 sellPercent_) external onlyOwner {
405         sellCooldownSeconds = sellCooldownSeconds_;
406         maxSellTransactionAmount = maxSellTransactionAmount_;
407         sellPercent = sellPercent_;
408     }
409 
410     function viewADMSettings() external view returns (uint sellCooldownSecs, uint maxSellTransactionAmt, uint256 sellPercentAmt){
411         return(sellCooldownSeconds,maxSellTransactionAmount,sellPercent);
412     }
413 
414     function minZero(uint a, uint b) private pure returns(uint) {
415         if (a > b) {
416            return a - b; 
417         } else {
418            return 0;    
419         }    
420     } 
421 
422     event AutoLiquify(uint256 amountETH, uint256 amountBEE);
423 
424 }