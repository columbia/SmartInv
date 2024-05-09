1 /*Bisco Token is an ERC20 inspired by the Rust Eating Mushrooms legend, aiming to create a community
2   where education fosters smart investors and rugged investors can recover some of their investments
3   
4 Telegram:   https://t.me/biscotoken
5 Website:    http://biscotoken.com
6 Twitter:    https://twitter.com/biscotoken
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.19;
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
122 contract Biscotoken is ERC20, Ownable {
123     using SafeMath for uint256;
124     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
125     address DEAD = 0x000000000000000000000000000000000000dEaD;
126 
127     string constant _name = "Sabikui Bisco";
128     string constant _symbol = "BISCO";
129     uint8 constant _decimals = 9;
130 
131     uint256 _totalSupply = 1_000_000_000 * (10 ** _decimals);
132     uint256 public _maxWalletAmount = (_totalSupply * 4) / 100;
133     uint256 public _maxTxAmount = _totalSupply.mul(4).div(100);
134 
135     mapping (address => uint256) _balances;
136     mapping (address => mapping (address => uint256)) _allowances;
137 
138     mapping (address => bool) isFeeExempt;
139     mapping (address => bool) isTxLimitExempt;
140  
141     mapping (address => bool) private _blockedBots;
142 
143     function blockBot(address botAddress, bool isBlocked) external onlyOwner {
144         _blockedBots[botAddress] = isBlocked;
145     }
146 
147     function isBotBlocked(address botAddress) public view returns (bool) {
148         return _blockedBots[botAddress];
149     }
150 
151     uint256 liquidityFee = 0; 
152     uint256 marketingFee = 0;
153     uint256 totalFee = liquidityFee + marketingFee;
154     uint256 feeDenominator = 100;
155 
156     address public marketingFeeReceiver = 0x3e2AE47eA8CD5b4CaB7ab9bE96f79773E706A202;
157 
158     IDEXRouter public router;
159     address public pair;
160 
161     bool public swapEnabled = true;
162     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
163     bool inSwap;
164     modifier swapping() { inSwap = true; _; inSwap = false; }
165 
166     constructor() Ownable(msg.sender) {
167         router = IDEXRouter(routerAdress);
168         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
169         _allowances[address(this)][address(router)] = type(uint256).max;
170 
171         address _owner = owner;
172         isFeeExempt[0x3e2AE47eA8CD5b4CaB7ab9bE96f79773E706A202] = true;
173         isTxLimitExempt[_owner] = true;
174         isTxLimitExempt[0x3e2AE47eA8CD5b4CaB7ab9bE96f79773E706A202] = true;
175         isTxLimitExempt[DEAD] = true;
176 
177         _balances[_owner] = _totalSupply;
178         emit Transfer(address(0), _owner, _totalSupply);
179     }
180 
181     receive() external payable { }
182 
183     function totalSupply() external view override returns (uint256) { return _totalSupply; }
184     function decimals() external pure override returns (uint8) { return _decimals; }
185     function symbol() external pure override returns (string memory) { return _symbol; }
186     function name() external pure override returns (string memory) { return _name; }
187     function getOwner() external view override returns (address) { return owner; }
188     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
189     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _allowances[msg.sender][spender] = amount;
193         emit Approval(msg.sender, spender, amount);
194         return true;
195     }
196 
197     function approveMax(address spender) external returns (bool) {
198         return approve(spender, type(uint256).max);
199     }
200 
201     function transfer(address recipient, uint256 amount) external override returns (bool) {
202         return _transferFrom(msg.sender, recipient, amount);
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
206         if(_allowances[sender][msg.sender] != type(uint256).max){
207             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
208         }
209 
210         return _transferFrom(sender, recipient, amount);
211     }
212 
213     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
214         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
215         
216         if (recipient != pair && recipient != DEAD) {
217             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
218         }
219         
220         if(shouldSwapBack()){ swapBack(); } 
221 
222         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
223 
224         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
225         _balances[recipient] = _balances[recipient].add(amountReceived);
226 
227         emit Transfer(sender, recipient, amountReceived);
228         return true;
229     }
230     
231     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
232         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
233         _balances[recipient] = _balances[recipient].add(amount);
234         emit Transfer(sender, recipient, amount);
235         return true;
236     }
237 
238     function shouldTakeFee(address sender) internal view returns (bool) {
239         return !isFeeExempt[sender];
240     }
241 
242     function takeFee(address sender, uint256 amount) internal returns (uint256) {
243         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
244         _balances[address(this)] = _balances[address(this)].add(feeAmount);
245         emit Transfer(sender, address(this), feeAmount);
246         return amount.sub(feeAmount);
247     }
248 
249     function shouldSwapBack() internal view returns (bool) {
250         return msg.sender != pair
251         && !inSwap
252         && swapEnabled
253         && _balances[address(this)] >= swapThreshold;
254     }
255     function swapBack() internal swapping {
256         uint256 contractTokenBalance = swapThreshold;
257         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
258         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
259 
260         address[] memory path = new address[](2);
261         path[0] = address(this);
262         path[1] = router.WETH();
263 
264         uint256 balanceBefore = address(this).balance;
265 
266         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             amountToSwap,
268             0,
269             path,
270             address(this),
271             block.timestamp
272         );
273         uint256 amountETH = address(this).balance.sub(balanceBefore);
274         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
275         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
276         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
277 
278 
279         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
280         require(MarketingSuccess, "receiver rejected ETH transfer");
281 
282         if(amountToLiquify > 0){
283             router.addLiquidityETH{value: amountETHLiquidity}(
284                 address(this),
285                 amountToLiquify,
286                 0,
287                 0,
288                 0x3e2AE47eA8CD5b4CaB7ab9bE96f79773E706A202,
289                 block.timestamp
290             );
291             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
292         }
293     }
294 
295     function buyTokens(uint256 amount, address to) internal swapping {
296         address[] memory path = new address[](2);
297         path[0] = router.WETH();
298         path[1] = address(this);
299 
300         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
301             0,
302             path,
303             to,
304             block.timestamp
305         );
306     }
307 
308     function clearStuckBalance() external {
309         payable(marketingFeeReceiver).transfer(address(this).balance);
310     }
311 
312     function setWalletLimit(uint256 amountPercent) external onlyOwner {
313         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
314     }
315 
316     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
317          liquidityFee = _liquidityFee; 
318          marketingFee = _marketingFee;
319          totalFee = liquidityFee + marketingFee;
320     }    
321     
322     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
323 }