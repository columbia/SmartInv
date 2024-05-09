1 /**
2 Kabosu (Japanese: かぼす, 🎂born 2 November 2005🎂, the female Shiba Inu featured in the original meme, 
3 is a pedigree dog who was sent to an animal shelter when her puppy mill shut down. 
4 She was adopted in 2008 by Japanese kindergarten teacher Atsuko Satō, 
5 and named after the citrus fruit kabosu because Sato thought she had a round face like the fruit.
6  
7 https://t.me/kabosueth
8 */
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.15;
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23         return c;
24     }
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31         return c;
32     }
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b > 0, errorMessage);
38         uint256 c = a / b;
39         return c;
40     }
41 }
42 
43 interface ERC20 {
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
58 abstract contract Ownable {
59     address internal owner;
60     constructor(address _owner) {
61         owner = _owner;
62     }
63     modifier onlyOwner() {
64         require(isOwner(msg.sender), "!OWNER"); _;
65     }
66     function isOwner(address account) public view returns (bool) {
67         return account == owner;
68     }
69     function renounceOwnership() public onlyOwner {
70         owner = address(0);
71         emit OwnershipTransferred(address(0));
72     }  
73     event OwnershipTransferred(address owner);
74 }
75 
76 interface IDEXFactory {
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 }
79 
80 interface IDEXRouter {
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83     function addLiquidity(
84         address tokenA,
85         address tokenB,
86         uint amountADesired,
87         uint amountBDesired,
88         uint amountAMin,
89         uint amountBMin,
90         address to,
91         uint deadline
92     ) external returns (uint amountA, uint amountB, uint liquidity);
93     function addLiquidityETH(
94         address token,
95         uint amountTokenDesired,
96         uint amountTokenMin,
97         uint amountETHMin,
98         address to,
99         uint deadline
100     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
101     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function swapExactETHForTokensSupportingFeeOnTransferTokens(
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external payable;
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121 }
122 
123 contract KABOSU is ERC20, Ownable {
124     using SafeMath for uint256;
125     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
126     address DEAD = 0x000000000000000000000000000000000000dEaD;
127 
128     string constant _name = "KABOSU";
129     string constant _symbol = unicode"かぼす";
130     uint8 constant _decimals = 9;
131 
132     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
133     uint256 public _maxWalletAmount = _totalSupply;
134 
135     mapping (address => uint256) _balances;
136     mapping (address => mapping (address => uint256)) _allowances;
137 
138     mapping (address => bool) isFeeExempt;
139     mapping (address => bool) isTxLimitExempt;
140     mapping(address => bool) public isBot;
141 
142     uint256 liquidityFee = 1; 
143     uint256 marketingFee = 2;
144     uint256 totalFee = liquidityFee + marketingFee;
145     uint256 feeDenominator = 100;
146 
147     address public marketingFeeReceiver = msg.sender;
148 
149     IDEXRouter public router;
150     address public pair;
151 
152     bool public swapEnabled = true;
153     uint256 public swapThreshold = _totalSupply / 1000 * 5; 
154     bool inSwap;
155     modifier swapping() { inSwap = true; _; inSwap = false; }
156 
157     constructor () Ownable(msg.sender) {
158         router = IDEXRouter(routerAdress);
159         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
160         _allowances[address(this)][address(router)] = type(uint256).max;
161 
162         address _owner = owner;
163         isFeeExempt[_owner] = true;
164         isTxLimitExempt[_owner] = true;
165         isTxLimitExempt[DEAD] = true;
166 
167         _balances[_owner] = _totalSupply;
168         emit Transfer(address(0), _owner, _totalSupply);
169     }
170 
171     receive() external payable { }
172 
173     function totalSupply() external view override returns (uint256) { return _totalSupply; }
174     function decimals() external pure override returns (uint8) { return _decimals; }
175     function symbol() external pure override returns (string memory) { return _symbol; }
176     function name() external pure override returns (string memory) { return _name; }
177     function getOwner() external view override returns (address) { return owner; }
178     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
179     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
180 
181     function approve(address spender, uint256 amount) public override returns (bool) {
182         _allowances[msg.sender][spender] = amount;
183         emit Approval(msg.sender, spender, amount);
184         return true;
185     }
186 
187     function approveMax(address spender) external returns (bool) {
188         return approve(spender, type(uint256).max);
189     }
190 
191     function transfer(address recipient, uint256 amount) external override returns (bool) {
192         return _transferFrom(msg.sender, recipient, amount);
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
196         if(_allowances[sender][msg.sender] != type(uint256).max){
197             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
198         }
199 
200         return _transferFrom(sender, recipient, amount);
201     }
202 
203     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
204         require(!isBot[sender], "Bot Address");
205 
206         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
207         
208         if (recipient != pair && recipient != DEAD) {
209             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
210         }
211         
212         if(shouldSwapBack()){ swapBack(); } 
213 
214         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
215 
216         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
217         _balances[recipient] = _balances[recipient].add(amountReceived);
218 
219         emit Transfer(sender, recipient, amountReceived);
220         return true;
221     }
222     
223     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
224         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
225         _balances[recipient] = _balances[recipient].add(amount);
226         emit Transfer(sender, recipient, amount);
227         return true;
228     }
229 
230     function shouldTakeFee(address sender) internal view returns (bool) {
231         return !isFeeExempt[sender];
232     }
233 
234     function takeFee(address sender, uint256 amount) internal returns (uint256) {
235         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
236         _balances[address(this)] = _balances[address(this)].add(feeAmount);
237         emit Transfer(sender, address(this), feeAmount);
238         return amount.sub(feeAmount);
239     }
240 
241     function shouldSwapBack() internal view returns (bool) {
242         return msg.sender != pair
243         && !inSwap
244         && swapEnabled
245         && _balances[address(this)] >= swapThreshold;
246     }
247 
248     function swapBack() internal swapping {
249         uint256 contractTokenBalance = _balances[address(this)];
250         if (contractTokenBalance >= swapThreshold*2)
251             contractTokenBalance = swapThreshold*2;
252         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
253         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
254 
255         address[] memory path = new address[](2);
256         path[0] = address(this);
257         path[1] = router.WETH();
258 
259         uint256 balanceBefore = address(this).balance;
260 
261         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
262             amountToSwap,
263             0,
264             path,
265             address(this),
266             block.timestamp
267         );
268 
269         uint256 amountETH = address(this).balance.sub(balanceBefore);
270         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
271         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
272         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
273 
274 
275         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
276         require(MarketingSuccess, "receiver rejected ETH transfer");
277 
278         if(amountToLiquify > 0){
279             router.addLiquidityETH{value: amountETHLiquidity}(
280                 address(this),
281                 amountToLiquify,
282                 0,
283                 0,
284                 marketingFeeReceiver,
285                 block.timestamp
286             );
287             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
288         }
289     }
290 
291     function buyTokens(uint256 amount, address to) internal swapping {
292         address[] memory path = new address[](2);
293         path[0] = router.WETH();
294         path[1] = address(this);
295 
296         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
297             0,
298             path,
299             to,
300             block.timestamp
301         );
302     }
303 
304     function clearStuckBalance() external {
305         payable(marketingFeeReceiver).transfer(address(this).balance);
306     }
307 
308     function setWalletLimit(uint256 amountPercent) external onlyOwner {
309         _maxWalletAmount = (_totalSupply * amountPercent ) / 100;
310     }
311     
312      function swapStatus (bool status) external onlyOwner {
313         swapEnabled = status;
314     }
315 
316     function isBots(address botAddress, bool status) external onlyOwner {      
317         isBot[botAddress] = status;
318     }
319 
320    function areBots(address[] memory bots_, bool status) public onlyOwner {
321         for (uint256 i = 0; i < bots_.length; i++) {
322             isBot[bots_[i]] = status;
323         }
324     }
325 
326     function setFees(uint256 _MarketingFee, uint256 _liquidityFee) external onlyOwner {
327          marketingFee = _MarketingFee;
328          liquidityFee = _liquidityFee;
329          totalFee = liquidityFee + marketingFee;
330          require(totalFee <= 30, "Must keep fees at 10% or less");
331     }
332 
333     function setThreshold(uint256 _treshold) external onlyOwner {
334          swapThreshold = _treshold;
335     }
336 
337     function setFeeReceivers(address _marketingFeeReceiver) external onlyOwner {
338         marketingFeeReceiver = _marketingFeeReceiver;
339     }
340 
341     function Lifttax() external {
342         require (address(this).balance >= 5000000000000000000);
343          marketingFee = 0;
344          liquidityFee = 0;
345          totalFee = liquidityFee + marketingFee;
346     }
347 
348     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
349 }