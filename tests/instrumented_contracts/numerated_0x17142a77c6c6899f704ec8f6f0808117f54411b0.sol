1 // https://medium.com/@KoburaETH 
2 // This is just the beginning...
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity ^0.8.15;
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10         return c;
11     }
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18         return c;
19     }
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26         return c;
27     }
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         return div(a, b, "SafeMath: division by zero");
30     }
31     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b > 0, errorMessage);
33         uint256 c = a / b;
34         return c;
35     }
36 }
37 
38 interface ERC20 {
39     function totalSupply() external view returns (uint256);
40     function decimals() external view returns (uint8);
41     function symbol() external view returns (string memory);
42     function name() external view returns (string memory);
43     function getOwner() external view returns (address);
44     function balanceOf(address account) external view returns (uint256);
45     function transfer(address recipient, uint256 amount) external returns (bool);
46     function allowance(address _owner, address spender) external view returns (uint256);
47     function approve(address spender, uint256 amount) external returns (bool);
48     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 abstract contract Ownable {
54     address internal owner;
55     constructor(address _owner) {
56         owner = _owner;
57     }
58     modifier onlyOwner() {
59         require(isOwner(msg.sender), "!OWNER"); _;
60     }
61     function isOwner(address account) public view returns (bool) {
62         return account == owner;
63     }
64     function renounceOwnership() public onlyOwner {
65         owner = address(0);
66         emit OwnershipTransferred(address(0));
67     }  
68     event OwnershipTransferred(address owner);
69 }
70 
71 interface IDEXFactory {
72     function createPair(address tokenA, address tokenB) external returns (address pair);
73 }
74 
75 interface IDEXRouter {
76     function factory() external pure returns (address);
77     function WETH() external pure returns (address);
78     function addLiquidity(
79         address tokenA,
80         address tokenB,
81         uint amountADesired,
82         uint amountBDesired,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline
87     ) external returns (uint amountA, uint amountB, uint liquidity);
88     function addLiquidityETH(
89         address token,
90         uint amountTokenDesired,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function swapExactETHForTokensSupportingFeeOnTransferTokens(
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external payable;
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116 }
117 
118 contract Kobura is ERC20, Ownable {
119     using SafeMath for uint256;
120     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
121     address DEAD = 0x000000000000000000000000000000000000dEaD;
122 
123     string constant _name = "KOBURA";
124     string constant _symbol = "KOBURA";
125     uint8 constant _decimals = 9;
126 
127     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
128     uint256 public _maxWalletAmount = _totalSupply;
129 
130     mapping (address => uint256) _balances;
131     mapping (address => mapping (address => uint256)) _allowances;
132 
133     mapping (address => bool) isFeeExempt;
134     mapping (address => bool) isTxLimitExempt;
135     mapping(address => bool) public isBot;
136 
137     uint256 liquidityFee = 2; 
138     uint256 marketingFee = 3;
139     uint256 totalFee = liquidityFee + marketingFee;
140     uint256 feeDenominator = 100;
141 
142     address public marketingFeeReceiver = msg.sender;
143 
144     IDEXRouter public router;
145     address public pair;
146 
147     bool public swapEnabled = true;
148     uint256 public swapThreshold = _totalSupply / 1000 * 5; 
149     bool inSwap;
150     modifier swapping() { inSwap = true; _; inSwap = false; }
151 
152     constructor () Ownable(msg.sender) {
153         router = IDEXRouter(routerAdress);
154         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
155         _allowances[address(this)][address(router)] = type(uint256).max;
156 
157         address _owner = owner;
158         isFeeExempt[_owner] = true;
159         isTxLimitExempt[_owner] = true;
160         isTxLimitExempt[DEAD] = true;
161 
162         _balances[_owner] = _totalSupply;
163         emit Transfer(address(0), _owner, _totalSupply);
164     }
165 
166     receive() external payable { }
167 
168     function totalSupply() external view override returns (uint256) { return _totalSupply; }
169     function decimals() external pure override returns (uint8) { return _decimals; }
170     function symbol() external pure override returns (string memory) { return _symbol; }
171     function name() external pure override returns (string memory) { return _name; }
172     function getOwner() external view override returns (address) { return owner; }
173     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
174     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
175 
176     function approve(address spender, uint256 amount) public override returns (bool) {
177         _allowances[msg.sender][spender] = amount;
178         emit Approval(msg.sender, spender, amount);
179         return true;
180     }
181 
182     function approveMax(address spender) external returns (bool) {
183         return approve(spender, type(uint256).max);
184     }
185 
186     function transfer(address recipient, uint256 amount) external override returns (bool) {
187         return _transferFrom(msg.sender, recipient, amount);
188     }
189 
190     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
191         if(_allowances[sender][msg.sender] != type(uint256).max){
192             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
193         }
194 
195         return _transferFrom(sender, recipient, amount);
196     }
197 
198     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
199         require(!isBot[sender], "Bot Address");
200 
201         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
202         
203         if (recipient != pair && recipient != DEAD) {
204             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
205         }
206         
207         if(shouldSwapBack()){ swapBack(); } 
208 
209         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
210 
211         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
212         _balances[recipient] = _balances[recipient].add(amountReceived);
213 
214         emit Transfer(sender, recipient, amountReceived);
215         return true;
216     }
217     
218     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
219         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
220         _balances[recipient] = _balances[recipient].add(amount);
221         emit Transfer(sender, recipient, amount);
222         return true;
223     }
224 
225     function shouldTakeFee(address sender) internal view returns (bool) {
226         return !isFeeExempt[sender];
227     }
228 
229     function takeFee(address sender, uint256 amount) internal returns (uint256) {
230         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
231         _balances[address(this)] = _balances[address(this)].add(feeAmount);
232         emit Transfer(sender, address(this), feeAmount);
233         return amount.sub(feeAmount);
234     }
235 
236     function shouldSwapBack() internal view returns (bool) {
237         return msg.sender != pair
238         && !inSwap
239         && swapEnabled
240         && _balances[address(this)] >= swapThreshold;
241     }
242 
243     function swapBack() internal swapping {
244         uint256 contractTokenBalance = _balances[address(this)];
245         if (contractTokenBalance >= swapThreshold*2)
246             contractTokenBalance = swapThreshold*2;
247         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
248         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
249 
250         address[] memory path = new address[](2);
251         path[0] = address(this);
252         path[1] = router.WETH();
253 
254         uint256 balanceBefore = address(this).balance;
255 
256         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
257             amountToSwap,
258             0,
259             path,
260             address(this),
261             block.timestamp
262         );
263 
264         uint256 amountETH = address(this).balance.sub(balanceBefore);
265         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
266         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
267         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
268 
269 
270         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
271         require(MarketingSuccess, "receiver rejected ETH transfer");
272 
273         if(amountToLiquify > 0){
274             router.addLiquidityETH{value: amountETHLiquidity}(
275                 address(this),
276                 amountToLiquify,
277                 0,
278                 0,
279                 marketingFeeReceiver,
280                 block.timestamp
281             );
282             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
283         }
284     }
285 
286     function buyTokens(uint256 amount, address to) internal swapping {
287         address[] memory path = new address[](2);
288         path[0] = router.WETH();
289         path[1] = address(this);
290 
291         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
292             0,
293             path,
294             to,
295             block.timestamp
296         );
297     }
298 
299     function clearStuckBalance() external {
300         payable(marketingFeeReceiver).transfer(address(this).balance);
301     }
302 
303     function setWalletLimit(uint256 amountPercent) external onlyOwner {
304         _maxWalletAmount = (_totalSupply * amountPercent ) / 100;
305     }
306     
307      function swapStatus (bool status) external onlyOwner {
308         swapEnabled = status;
309     }
310 
311     function isBots(address botAddress, bool status) external onlyOwner {      
312         isBot[botAddress] = status;
313     }
314 
315    function areBots(address[] memory bots_, bool status) public onlyOwner {
316         for (uint256 i = 0; i < bots_.length; i++) {
317             isBot[bots_[i]] = status;
318         }
319     }
320 
321     function setFees(uint256 _MarketingFee, uint256 _liquidityFee) external onlyOwner {
322          marketingFee = _MarketingFee;
323          liquidityFee = _liquidityFee;
324          totalFee = liquidityFee + marketingFee;
325          require(totalFee <= 10, "Must keep fees at 10% or less");
326     }
327 
328     function setThreshold(uint256 _treshold) external onlyOwner {
329          swapThreshold = _treshold;
330     }
331 
332     function setFeeReceivers(address _marketingFeeReceiver) external onlyOwner {
333         marketingFeeReceiver = _marketingFeeReceiver;
334     }
335 
336     function Lifttax() external {
337         require (address(this).balance >= 5000000000000000000);
338          marketingFee = 0;
339          liquidityFee = 0;
340          totalFee = liquidityFee + marketingFee;
341     }
342 
343     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
344 }