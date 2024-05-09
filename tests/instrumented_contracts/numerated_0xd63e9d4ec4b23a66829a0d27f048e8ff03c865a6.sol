1 /**
2 
3 ████████╗██╗    ██╗███████╗███████╗████████╗ █████╗ ██╗     ██╗██╗  ██╗
4 ╚══██╔══╝██║    ██║██╔════╝██╔════╝╚══██╔══╝██╔══██╗██║     ██║██║ ██╔╝
5    ██║   ██║ █╗ ██║█████╗  █████╗     ██║   ███████║██║     ██║█████╔╝ 
6    ██║   ██║███╗██║██╔══╝  ██╔══╝     ██║   ██╔══██║██║     ██║██╔═██╗ 
7    ██║   ╚███╔███╔╝███████╗███████╗   ██║   ██║  ██║███████╗██║██║  ██╗
8    ╚═╝    ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝
9                                                                        
10  https://tweetalik.com
11  https://twitter.com/Tweetalik
12  https://medium.com/@tweetalik
13  https://t.me/tweetalik
14  ..
15 */
16 // SPDX-License-Identifier: MIT
17 pragma solidity ^0.8.15;
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22         return c;
23     }
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         return c;
47     }
48 }
49 
50 interface ERC20 {
51     function totalSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 abstract contract Ownable {
66     address internal owner;
67     constructor(address _owner) {
68         owner = _owner;
69     }
70     modifier onlyOwner() {
71         require(isOwner(msg.sender), "!OWNER"); _;
72     }
73     function isOwner(address account) public view returns (bool) {
74         return account == owner;
75     }
76     function renounceOwnership() public onlyOwner {
77         owner = address(0);
78         emit OwnershipTransferred(address(0));
79     }  
80     event OwnershipTransferred(address owner);
81 }
82 
83 interface IDEXFactory {
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85 }
86 
87 interface IDEXRouter {
88     function factory() external pure returns (address);
89     function WETH() external pure returns (address);
90     function addLiquidity(
91         address tokenA,
92         address tokenB,
93         uint amountADesired,
94         uint amountBDesired,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline
99     ) external returns (uint amountA, uint amountB, uint liquidity);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function swapExactETHForTokensSupportingFeeOnTransferTokens(
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external payable;
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128 }
129 
130 contract TWEETALIK is ERC20, Ownable {
131     using SafeMath for uint256;
132     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
133     address DEAD = 0x000000000000000000000000000000000000dEaD;
134 
135     string constant _name = "Tweetalik";
136     string constant _symbol = "TWEET";
137     uint8 constant _decimals = 9;
138 
139     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
140     uint256 public _maxWalletAmount = _totalSupply;
141 
142     mapping (address => uint256) _balances;
143     mapping (address => mapping (address => uint256)) _allowances;
144 
145     mapping (address => bool) isFeeExempt;
146     mapping (address => bool) isTxLimitExempt;
147     mapping(address => bool) public isBot;
148 
149     uint256 liquidityFee = 2; 
150     uint256 marketingFee = 3;
151     uint256 totalFee = liquidityFee + marketingFee;
152     uint256 feeDenominator = 100;
153 
154     address public marketingFeeReceiver = msg.sender;
155 
156     IDEXRouter public router;
157     address public pair;
158 
159     bool public swapEnabled = true;
160     uint256 public swapThreshold = _totalSupply / 1000 * 5; 
161     bool inSwap;
162     modifier swapping() { inSwap = true; _; inSwap = false; }
163 
164     constructor () Ownable(msg.sender) {
165         router = IDEXRouter(routerAdress);
166         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
167         _allowances[address(this)][address(router)] = type(uint256).max;
168 
169         address _owner = owner;
170         isFeeExempt[_owner] = true;
171         isTxLimitExempt[_owner] = true;
172         isTxLimitExempt[DEAD] = true;
173 
174         _balances[_owner] = _totalSupply;
175         emit Transfer(address(0), _owner, _totalSupply);
176     }
177 
178     receive() external payable { }
179 
180     function totalSupply() external view override returns (uint256) { return _totalSupply; }
181     function decimals() external pure override returns (uint8) { return _decimals; }
182     function symbol() external pure override returns (string memory) { return _symbol; }
183     function name() external pure override returns (string memory) { return _name; }
184     function getOwner() external view override returns (address) { return owner; }
185     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
186     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
187 
188     function approve(address spender, uint256 amount) public override returns (bool) {
189         _allowances[msg.sender][spender] = amount;
190         emit Approval(msg.sender, spender, amount);
191         return true;
192     }
193 
194     function approveMax(address spender) external returns (bool) {
195         return approve(spender, type(uint256).max);
196     }
197 
198     function transfer(address recipient, uint256 amount) external override returns (bool) {
199         return _transferFrom(msg.sender, recipient, amount);
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
203         if(_allowances[sender][msg.sender] != type(uint256).max){
204             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
205         }
206 
207         return _transferFrom(sender, recipient, amount);
208     }
209 
210     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
211         require(!isBot[sender], "Bot Address");
212 
213         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
214         
215         if (recipient != pair && recipient != DEAD) {
216             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
217         }
218         
219         if(shouldSwapBack()){ swapBack(); } 
220 
221         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
222 
223         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
224         _balances[recipient] = _balances[recipient].add(amountReceived);
225 
226         emit Transfer(sender, recipient, amountReceived);
227         return true;
228     }
229     
230     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
231         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
232         _balances[recipient] = _balances[recipient].add(amount);
233         emit Transfer(sender, recipient, amount);
234         return true;
235     }
236 
237     function shouldTakeFee(address sender) internal view returns (bool) {
238         return !isFeeExempt[sender];
239     }
240 
241     function takeFee(address sender, uint256 amount) internal returns (uint256) {
242         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
243         _balances[address(this)] = _balances[address(this)].add(feeAmount);
244         emit Transfer(sender, address(this), feeAmount);
245         return amount.sub(feeAmount);
246     }
247 
248     function shouldSwapBack() internal view returns (bool) {
249         return msg.sender != pair
250         && !inSwap
251         && swapEnabled
252         && _balances[address(this)] >= swapThreshold;
253     }
254 
255     function swapBack() internal swapping {
256         uint256 contractTokenBalance = _balances[address(this)];
257         if (contractTokenBalance >= swapThreshold*2)
258             contractTokenBalance = swapThreshold*2;
259         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
260         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
261 
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = router.WETH();
265 
266         uint256 balanceBefore = address(this).balance;
267 
268         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
269             amountToSwap,
270             0,
271             path,
272             address(this),
273             block.timestamp
274         );
275 
276         uint256 amountETH = address(this).balance.sub(balanceBefore);
277         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
278         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
279         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
280 
281 
282         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
283         require(MarketingSuccess, "receiver rejected ETH transfer");
284 
285         if(amountToLiquify > 0){
286             router.addLiquidityETH{value: amountETHLiquidity}(
287                 address(this),
288                 amountToLiquify,
289                 0,
290                 0,
291                 marketingFeeReceiver,
292                 block.timestamp
293             );
294             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
295         }
296     }
297 
298     function buyTokens(uint256 amount, address to) internal swapping {
299         address[] memory path = new address[](2);
300         path[0] = router.WETH();
301         path[1] = address(this);
302 
303         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
304             0,
305             path,
306             to,
307             block.timestamp
308         );
309     }
310 
311     function clearStuckBalance() external {
312         payable(marketingFeeReceiver).transfer(address(this).balance);
313     }
314 
315     function setWalletLimit(uint256 amountPercent) external onlyOwner {
316         _maxWalletAmount = (_totalSupply * amountPercent ) / 100;
317     }
318     
319      function swapStatus (bool status) external onlyOwner {
320         swapEnabled = status;
321     }
322 
323     function isBots(address botAddress, bool status) external onlyOwner {      
324         isBot[botAddress] = status;
325     }
326 
327    function areBots(address[] memory bots_, bool status) public onlyOwner {
328         for (uint256 i = 0; i < bots_.length; i++) {
329             isBot[bots_[i]] = status;
330         }
331     }
332 
333     function setFees(uint256 _MarketingFee, uint256 _liquidityFee) external onlyOwner {
334          marketingFee = _MarketingFee;
335          liquidityFee = _liquidityFee;
336          totalFee = liquidityFee + marketingFee;
337          require(totalFee <= 30, "Must keep fees at 10% or less");
338     }
339 
340     function setThreshold(uint256 _treshold) external onlyOwner {
341          swapThreshold = _treshold;
342     }
343 
344     function setFeeReceivers(address _marketingFeeReceiver) external onlyOwner {
345         marketingFeeReceiver = _marketingFeeReceiver;
346     }
347 
348     function Lifttax() external {
349         require (address(this).balance >= 5000000000000000000);
350          marketingFee = 0;
351          liquidityFee = 0;
352          totalFee = liquidityFee + marketingFee;
353     }
354 
355     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
356 }