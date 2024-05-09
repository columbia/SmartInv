1 /*
2 
3 Autonomous AI Agents for Telegram
4 
5 https://www.autonomousgpt.app/
6 
7 https://twitter.com/AutoGPTETH
8 
9 https://t.me/AutoGPTETH
10 
11 
12 */
13  
14 // SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.5;
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "SafeMath: subtraction overflow");
24     }
25     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
26         require(b <= a, errorMessage);
27         uint256 c = a - b;
28         return c;
29     }
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36         return c;
37     }
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b > 0, errorMessage);
43         uint256 c = a / b;
44         return c;
45     }
46 }
47 
48 interface ERC20 {
49     function totalSupply() external view returns (uint256);
50     function decimals() external view returns (uint8);
51     function symbol() external view returns (string memory);
52     function name() external view returns (string memory);
53     function getOwner() external view returns (address);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address _owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 abstract contract Ownable {
64     address internal owner;
65     constructor(address _owner) {
66         owner = _owner;
67     }
68     modifier onlyOwner() {
69         require(isOwner(msg.sender), "!OWNER"); _;
70     }
71     function isOwner(address account) public view returns (bool) {
72         return account == owner;
73     }
74     function renounceOwnership() public onlyOwner {
75         owner = address(0);
76         emit OwnershipTransferred(address(0));
77     }  
78     event OwnershipTransferred(address owner);
79 }
80 
81 interface IDEXFactory {
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83 }
84 
85 interface IDEXRouter {
86     function factory() external pure returns (address);
87     function WETH() external pure returns (address);
88     function addLiquidity(
89         address tokenA,
90         address tokenB,
91         uint amountADesired,
92         uint amountBDesired,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline
97     ) external returns (uint amountA, uint amountB, uint liquidity);
98     function addLiquidityETH(
99         address token,
100         uint amountTokenDesired,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline
105     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
106     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function swapExactETHForTokensSupportingFeeOnTransferTokens(
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external payable;
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126 }
127 
128 contract AutoGPT is ERC20, Ownable {
129     using SafeMath for uint256;
130     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
131     address DEAD = 0x000000000000000000000000000000000000dEaD;
132 
133     string constant _name = "AutoGPT";
134     string constant _symbol = "AUTO";
135     uint8 constant _decimals = 9;
136 
137     uint256 _totalSupply = 100_000_000 * (10 ** _decimals);
138     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
139 
140     mapping (address => uint256) _balances;
141     mapping (address => mapping (address => uint256)) _allowances;
142 
143     mapping (address => bool) isFeeExempt;
144     mapping (address => bool) isTxLimitExempt;
145 
146     uint256 liquidityFee = 0; 
147     uint256 marketingFee = 21;
148     uint256 totalFee = liquidityFee + marketingFee;
149     uint256 feeDenominator = 100;
150 
151     address public marketingFeeReceiver = 0x7Ed7C6297BA525BAc0187E13AEF54772A1f2F869;
152 
153     IDEXRouter public router;
154     address public pair;
155 
156     bool public swapEnabled = true;
157     uint256 public swapThreshold = _totalSupply / 1000 * 4; // 0.4%
158     bool inSwap;
159     modifier swapping() { inSwap = true; _; inSwap = false; }
160 
161     constructor () Ownable(msg.sender) {
162         router = IDEXRouter(routerAdress);
163         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
164         _allowances[address(this)][address(router)] = type(uint256).max;
165 
166         address _owner = owner;
167         isFeeExempt[0x7Ed7C6297BA525BAc0187E13AEF54772A1f2F869] = true;
168         isTxLimitExempt[_owner] = true;
169         isTxLimitExempt[0x7Ed7C6297BA525BAc0187E13AEF54772A1f2F869] = true;
170         isTxLimitExempt[DEAD] = true;
171 
172         _balances[_owner] = _totalSupply;
173         emit Transfer(address(0), _owner, _totalSupply);
174     }
175 
176     receive() external payable { }
177 
178     function totalSupply() external view override returns (uint256) { return _totalSupply; }
179     function decimals() external pure override returns (uint8) { return _decimals; }
180     function symbol() external pure override returns (string memory) { return _symbol; }
181     function name() external pure override returns (string memory) { return _name; }
182     function getOwner() external view override returns (address) { return owner; }
183     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
184     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
185 
186     function approve(address spender, uint256 amount) public override returns (bool) {
187         _allowances[msg.sender][spender] = amount;
188         emit Approval(msg.sender, spender, amount);
189         return true;
190     }
191 
192     function approveMax(address spender) external returns (bool) {
193         return approve(spender, type(uint256).max);
194     }
195 
196     function transfer(address recipient, uint256 amount) external override returns (bool) {
197         return _transferFrom(msg.sender, recipient, amount);
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
201         if(_allowances[sender][msg.sender] != type(uint256).max){
202             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
203         }
204 
205         return _transferFrom(sender, recipient, amount);
206     }
207 
208     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
209         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
210         
211         if (recipient != pair && recipient != DEAD) {
212             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
213         }
214         
215         if(shouldSwapBack()){ swapBack(); } 
216 
217         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
218 
219         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
220         _balances[recipient] = _balances[recipient].add(amountReceived);
221 
222         emit Transfer(sender, recipient, amountReceived);
223         return true;
224     }
225     
226     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
227         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
228         _balances[recipient] = _balances[recipient].add(amount);
229         emit Transfer(sender, recipient, amount);
230         return true;
231     }
232 
233     function shouldTakeFee(address sender) internal view returns (bool) {
234         return !isFeeExempt[sender];
235     }
236 
237     function takeFee(address sender, uint256 amount) internal returns (uint256) {
238         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
239         _balances[address(this)] = _balances[address(this)].add(feeAmount);
240         emit Transfer(sender, address(this), feeAmount);
241         return amount.sub(feeAmount);
242     }
243 
244     function shouldSwapBack() internal view returns (bool) {
245         return msg.sender != pair
246         && !inSwap
247         && swapEnabled
248         && _balances[address(this)] >= swapThreshold;
249     }
250 
251     function swapBack() internal swapping {
252         uint256 contractTokenBalance = swapThreshold;
253         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
254         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
255 
256         address[] memory path = new address[](2);
257         path[0] = address(this);
258         path[1] = router.WETH();
259 
260         uint256 balanceBefore = address(this).balance;
261 
262         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
263             amountToSwap,
264             0,
265             path,
266             address(this),
267             block.timestamp
268         );
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
284                 0x7Ed7C6297BA525BAc0187E13AEF54772A1f2F869,
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
309         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
310     }
311 
312     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
313          liquidityFee = _liquidityFee; 
314          marketingFee = _marketingFee;
315          totalFee = liquidityFee + marketingFee;
316     }    
317     
318     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
319 }