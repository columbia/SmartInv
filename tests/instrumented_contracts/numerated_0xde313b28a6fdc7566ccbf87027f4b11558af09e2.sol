1 // https://t.me/yearnmemefinance (Official Telegram Channel)
2 // https://twitter.com/yearnmeme  (Official Twitter)
3 // https://www.yearnmeme.finance/ (Official Website)
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.5;
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a + b;
10         require(c >= a, "SafeMath: addition overflow");
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19         return c;
20     }
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         if (a == 0) {
23             return 0;
24         }
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27         return c;
28     }
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         return div(a, b, "SafeMath: division by zero");
31     }
32     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b > 0, errorMessage);
34         uint256 c = a / b;
35         return c;
36     }
37 }
38 
39 interface ERC20 {
40     function totalSupply() external view returns (uint256);
41     function decimals() external view returns (uint8);
42     function symbol() external view returns (string memory);
43     function name() external view returns (string memory);
44     function getOwner() external view returns (address);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address _owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 abstract contract Ownable {
55     address internal owner;
56     constructor(address _owner) {
57         owner = _owner;
58     }
59     modifier onlyOwner() {
60         require(isOwner(msg.sender), "!OWNER"); _;
61     }
62     function isOwner(address account) public view returns (bool) {
63         return account == owner;
64     }
65     function renounceOwnership() public onlyOwner {
66         owner = address(0);
67         emit OwnershipTransferred(address(0));
68     }  
69     event OwnershipTransferred(address owner);
70 }
71 
72 interface IDEXFactory {
73     function createPair(address tokenA, address tokenB) external returns (address pair);
74 }
75 
76 interface IDEXRouter {
77     function factory() external pure returns (address);
78     function WETH() external pure returns (address);
79     function addLiquidity(
80         address tokenA,
81         address tokenB,
82         uint amountADesired,
83         uint amountBDesired,
84         uint amountAMin,
85         uint amountBMin,
86         address to,
87         uint deadline
88     ) external returns (uint amountA, uint amountB, uint liquidity);
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function swapExactETHForTokensSupportingFeeOnTransferTokens(
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external payable;
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external;
117 }
118 
119 contract YearnMemeFinance is ERC20, Ownable {
120     using SafeMath for uint256;
121     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
122     address DEAD = 0x000000000000000000000000000000000000dEaD;
123 
124     string constant _name = "Yearn Meme Finance";
125     string constant _symbol = "yMEME";
126     uint8 constant _decimals = 9;
127 
128     uint256 public _totalSupply = 1_000_000_000 * (10 ** _decimals);
129     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
130     uint256 public _maxTxAmount = _totalSupply.mul(2).div(100); //2%
131 
132     mapping (address => uint256) _balances;
133     mapping (address => mapping (address => uint256)) _allowances;
134 
135     mapping (address => bool) isFeeExempt;
136     mapping (address => bool) isTxLimitExempt;
137 
138     uint256 liquidityFee = 0; 
139     uint256 marketingFee = 5;
140     uint256 totalFee = liquidityFee + marketingFee;
141     uint256 feeDenominator = 100;
142 
143     address public marketingFeeReceiver = 0x6FbC03e885Fe96C43c948e31Eddfa6C721e1D5b9;
144 
145     IDEXRouter public router;
146     address public pair;
147 
148     bool public swapEnabled = true;
149     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
150     bool inSwap;
151     modifier swapping() { inSwap = true; _; inSwap = false; }
152 
153     constructor () Ownable(msg.sender) {
154         router = IDEXRouter(routerAdress);
155         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
156         _allowances[address(this)][address(router)] = type(uint256).max;
157 
158         address _owner = owner;
159         isFeeExempt[0x6FbC03e885Fe96C43c948e31Eddfa6C721e1D5b9] = true;
160         isTxLimitExempt[_owner] = true;
161         isTxLimitExempt[0x6FbC03e885Fe96C43c948e31Eddfa6C721e1D5b9] = true;
162         isTxLimitExempt[DEAD] = true;
163 
164         _balances[_owner] = _totalSupply;
165         emit Transfer(address(0), _owner, _totalSupply);
166     }
167 
168     receive() external payable { }
169 
170     function totalSupply() external view override returns (uint256) { return _totalSupply; }
171     function decimals() external pure override returns (uint8) { return _decimals; }
172     function symbol() external pure override returns (string memory) { return _symbol; }
173     function name() external pure override returns (string memory) { return _name; }
174     function getOwner() external view override returns (address) { return owner; }
175     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
176     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
177 
178     function approve(address spender, uint256 amount) public override returns (bool) {
179         _allowances[msg.sender][spender] = amount;
180         emit Approval(msg.sender, spender, amount);
181         return true;
182     }
183 
184     function approveMax(address spender) external returns (bool) {
185         return approve(spender, type(uint256).max);
186     }
187 
188     function transfer(address recipient, uint256 amount) external override returns (bool) {
189         return _transferFrom(msg.sender, recipient, amount);
190     }
191 
192     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
193         if(_allowances[sender][msg.sender] != type(uint256).max){
194             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
195         }
196 
197         return _transferFrom(sender, recipient, amount);
198     }
199 
200     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
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
244         uint256 contractTokenBalance = swapThreshold;
245         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
246         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
247 
248         address[] memory path = new address[](2);
249         path[0] = address(this);
250         path[1] = router.WETH();
251 
252         uint256 balanceBefore = address(this).balance;
253 
254         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
255             amountToSwap,
256             0,
257             path,
258             address(this),
259             block.timestamp
260         );
261         uint256 amountETH = address(this).balance.sub(balanceBefore);
262         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
263         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
264         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
265 
266 
267         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
268         require(MarketingSuccess, "receiver rejected ETH transfer");
269 
270         if(amountToLiquify > 0){
271             router.addLiquidityETH{value: amountETHLiquidity}(
272                 address(this),
273                 amountToLiquify,
274                 0,
275                 0,
276                 0x00361c5A854f5F971B6b7c5B389962fAA68c6ef1,
277                 block.timestamp
278             );
279             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
280         }
281     }
282 
283     function buyTokens(uint256 amount, address to) internal swapping {
284         address[] memory path = new address[](2);
285         path[0] = router.WETH();
286         path[1] = address(this);
287 
288         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
289             0,
290             path,
291             to,
292             block.timestamp
293         );
294     }
295 
296     function clearStuckBalance() external {
297         payable(marketingFeeReceiver).transfer(address(this).balance);
298     }
299 
300     function setWalletLimit(uint256 amountPercent) external onlyOwner {
301         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
302     }
303 
304     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
305          liquidityFee = _liquidityFee; 
306          marketingFee = _marketingFee;
307          totalFee = liquidityFee + marketingFee;
308     }    
309     
310     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
311 }