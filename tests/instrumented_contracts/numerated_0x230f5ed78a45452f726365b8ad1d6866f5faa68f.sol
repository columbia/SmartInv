1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 /*
8 Website:    https://cryptoforceplay.com/
9 Telegram:   https://t.me/cryptoforceportal
10 Twitter:    https://twitter.com/Cryptoforceplay
11 Discord:    https://discord.gg/Tj9nvbdJt3
12 Mail:       info@cryptoforceplay.com
13 
14 Victory or Nothing!
15   ______ .______     ____    ____ .______   .___________.  ______    _______   ______   .______        ______  _______ 
16  /      ||   _  \    \   \  /   / |   _  \  |           | /  __  \  |   ____| /  __  \  |   _  \      /      ||   ____|
17 |  ,----'|  |_)  |    \   \/   /  |  |_)  | `---|  |----`|  |  |  | |  |__   |  |  |  | |  |_)  |    |  ,----'|  |__   
18 |  |     |      /      \_    _/   |   ___/      |  |     |  |  |  | |   __|  |  |  |  | |      /     |  |     |   __|  
19 |  `----.|  |\  \----.   |  |     |  |          |  |     |  `--'  | |  |     |  `--'  | |  |\  \----.|  `----.|  |____ 
20  \______|| _| `._____|   |__|     | _|          |__|      \______/  |__|      \______/  | _| `._____| \______||_______|
21 
22 For Honor and Glory!
23 
24  +--^----------,--------,-----,--------^-,
25  | |||||||||   `--------'     |          O
26  `+---------------------------^----------|
27    `\_,---------,---------,--------------'
28      / XXXXXX /'|       /'
29     / XXXXXX /  `\    /'
30    / XXXXXX /`-------'
31   / XXXXXX /
32  / XXXXXX /
33 (________(                
34  `------'   
35 
36 */
37 
38 
39 
40 
41 
42 pragma solidity ^0.8.5;
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47         return c;
48     }
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55         return c;
56     }
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 }
74 
75 interface ERC20 {
76     function totalSupply() external view returns (uint256);
77     function decimals() external view returns (uint8);
78     function symbol() external view returns (string memory);
79     function name() external view returns (string memory);
80     function getOwner() external view returns (address);
81     function balanceOf(address account) external view returns (uint256);
82     function transfer(address recipient, uint256 amount) external returns (bool);
83     function allowance(address _owner, address spender) external view returns (uint256);
84     function approve(address spender, uint256 amount) external returns (bool);
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 abstract contract Ownable {
91     address internal owner;
92     constructor(address _owner) {
93         owner = _owner;
94     }
95     modifier onlyOwner() {
96         require(isOwner(msg.sender), "!OWNER"); _;
97     }
98     function isOwner(address account) public view returns (bool) {
99         return account == owner;
100     }
101     function renounceOwnership() public onlyOwner {
102         owner = address(0);
103         emit OwnershipTransferred(address(0));
104     }  
105     event OwnershipTransferred(address owner);
106 }
107 
108 interface IDEXFactory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IDEXRouter {
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidity(
116         address tokenA,
117         address tokenB,
118         uint amountADesired,
119         uint amountBDesired,
120         uint amountAMin,
121         uint amountBMin,
122         address to,
123         uint deadline
124     ) external returns (uint amountA, uint amountB, uint liquidity);
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
134         uint amountIn,
135         uint amountOutMin,
136         address[] calldata path,
137         address to,
138         uint deadline
139     ) external;
140     function swapExactETHForTokensSupportingFeeOnTransferTokens(
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external payable;
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 }
154 
155 contract CRYPTOFORCE is ERC20, Ownable {
156     using SafeMath for uint256;
157     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
158     address DEAD = 0x000000000000000000000000000000000000dEaD;
159 
160     string constant _name = "CRYPTOFORCE";
161     string constant _symbol = "COF";
162     uint8 constant _decimals = 9;
163 
164     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
165     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
166 
167     mapping (address => uint256) _balances;
168     mapping (address => mapping (address => uint256)) _allowances;
169 
170     mapping (address => bool) isFeeExempt;
171     mapping (address => bool) isTxLimitExempt;
172 
173     uint256 liquidityFee = 0; 
174     uint256 marketingFee = 4;
175     uint256 totalFee = liquidityFee + marketingFee;
176     uint256 feeDenominator = 100;
177 
178     address public marketingFeeReceiver = 0x6d472d07b6EB92381402e4996A6C7d223040600c;
179 
180     IDEXRouter public router;
181     address public pair;
182 
183     bool public swapEnabled = true;
184     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
185     bool inSwap;
186     modifier swapping() { inSwap = true; _; inSwap = false; }
187 
188     constructor () Ownable(msg.sender) {
189         router = IDEXRouter(routerAdress);
190         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
191         _allowances[address(this)][address(router)] = type(uint256).max;
192 
193         address _owner = owner;
194         isFeeExempt[0xA7Fab255F8d2510C2a97F913c504521Bf763FE16] = true;
195         isTxLimitExempt[_owner] = true;
196         isTxLimitExempt[0xA7Fab255F8d2510C2a97F913c504521Bf763FE16] = true;
197         isTxLimitExempt[DEAD] = true;
198 
199         _balances[_owner] = _totalSupply;
200         emit Transfer(address(0), _owner, _totalSupply);
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
235     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
236         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
237         
238         if (recipient != pair && recipient != DEAD) {
239             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
240         }
241         
242         if(shouldSwapBack()){ swapBack(); } 
243 
244         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
245 
246         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
247         _balances[recipient] = _balances[recipient].add(amountReceived);
248 
249         emit Transfer(sender, recipient, amountReceived);
250         return true;
251     }
252     
253     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
254         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
255         _balances[recipient] = _balances[recipient].add(amount);
256         emit Transfer(sender, recipient, amount);
257         return true;
258     }
259 
260     function shouldTakeFee(address sender) internal view returns (bool) {
261         return !isFeeExempt[sender];
262     }
263 
264     function takeFee(address sender, uint256 amount) internal returns (uint256) {
265         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
266         _balances[address(this)] = _balances[address(this)].add(feeAmount);
267         emit Transfer(sender, address(this), feeAmount);
268         return amount.sub(feeAmount);
269     }
270 
271     function shouldSwapBack() internal view returns (bool) {
272         return msg.sender != pair
273         && !inSwap
274         && swapEnabled
275         && _balances[address(this)] >= swapThreshold;
276     }
277 
278     function swapBack() internal swapping {
279         uint256 contractTokenBalance = swapThreshold;
280         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
281         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
282 
283         address[] memory path = new address[](2);
284         path[0] = address(this);
285         path[1] = router.WETH();
286 
287         uint256 balanceBefore = address(this).balance;
288 
289         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             amountToSwap,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296         uint256 amountETH = address(this).balance.sub(balanceBefore);
297         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
298         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
299         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
300 
301 
302         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
303         require(MarketingSuccess, "receiver rejected ETH transfer");
304 
305         if(amountToLiquify > 0){
306             router.addLiquidityETH{value: amountETHLiquidity}(
307                 address(this),
308                 amountToLiquify,
309                 0,
310                 0,
311                 0xA7Fab255F8d2510C2a97F913c504521Bf763FE16,
312                 block.timestamp
313             );
314             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
315         }
316     }
317 
318     function buyTokens(uint256 amount, address to) internal swapping {
319         address[] memory path = new address[](2);
320         path[0] = router.WETH();
321         path[1] = address(this);
322 
323         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
324             0,
325             path,
326             to,
327             block.timestamp
328         );
329     }
330 
331     function clearStuckBalance() external {
332         payable(marketingFeeReceiver).transfer(address(this).balance);
333     }
334 
335     function setWalletLimit(uint256 amountPercent) external onlyOwner {
336         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
337     }
338 
339     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
340          liquidityFee = _liquidityFee; 
341          marketingFee = _marketingFee;
342          totalFee = liquidityFee + marketingFee;
343     }    
344     
345     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
346 }