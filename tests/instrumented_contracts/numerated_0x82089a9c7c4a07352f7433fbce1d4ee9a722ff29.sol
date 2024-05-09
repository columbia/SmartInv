1 /*
2 
3 █▀█ █▀█ █▀█ ▀▄▀ █▄█  
4 █▀▀ █▀▄ █▄█ █░█ ░█░   
5 
6 Anonymity with Proxy, bringing privacy to you. 
7 
8 Telegram - https://t.me/proxyswap
9 
10 Web - https://proxy-eth.com
11 Whitepaper - https://proxywp.gitbook.io/docs/
12 Twitter - https://twitter.com/proxyswap
13 Medium - https://bit.ly/proxymedium
14 
15 */
16  
17 // SPDX-License-Identifier: MIT
18 pragma solidity ^0.8.5;
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23         return c;
24     }
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b <= a, errorMessage);
30         uint256 c = a - b;
31         return c;
32     }
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39         return c;
40     }
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return div(a, b, "SafeMath: division by zero");
43     }
44     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         return c;
48     }
49 }
50 
51 interface ERC20 {
52     function totalSupply() external view returns (uint256);
53     function decimals() external view returns (uint8);
54     function symbol() external view returns (string memory);
55     function name() external view returns (string memory);
56     function getOwner() external view returns (address);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address _owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 abstract contract Ownable {
67     address internal owner;
68     constructor(address _owner) {
69         owner = _owner;
70     }
71     modifier onlyOwner() {
72         require(isOwner(msg.sender), "!OWNER"); _;
73     }
74     function isOwner(address account) public view returns (bool) {
75         return account == owner;
76     }
77     function renounceOwnership() public onlyOwner {
78         owner = address(0);
79         emit OwnershipTransferred(address(0));
80     }  
81     event OwnershipTransferred(address owner);
82 }
83 
84 interface IDEXFactory {
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IDEXRouter {
89     function factory() external pure returns (address);
90     function WETH() external pure returns (address);
91     function addLiquidity(
92         address tokenA,
93         address tokenB,
94         uint amountADesired,
95         uint amountBDesired,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB, uint liquidity);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external;
116     function swapExactETHForTokensSupportingFeeOnTransferTokens(
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external payable;
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129 }
130 
131 contract Proxy is ERC20, Ownable {
132     using SafeMath for uint256;
133     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
134     address DEAD = 0x000000000000000000000000000000000000dEaD;
135 
136     string constant _name = "PROXY";
137     string constant _symbol = "PROXY";
138     uint8 constant _decimals = 9;
139 
140     uint256 _totalSupply = 100_000_000 * (10 ** _decimals);
141     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
142 
143     mapping (address => uint256) _balances;
144     mapping (address => mapping (address => uint256)) _allowances;
145 
146     mapping (address => bool) isFeeExempt;
147     mapping (address => bool) isTxLimitExempt;
148 
149     uint256 liquidityFee = 0; 
150     uint256 marketingFee = 6;
151     uint256 totalFee = liquidityFee + marketingFee;
152     uint256 feeDenominator = 100;
153 
154     address public marketingFeeReceiver = 0x9b162C72DA4E238422a19626953fDD6a60f2b877;
155 
156     IDEXRouter public router;
157     address public pair;
158 
159     bool public swapEnabled = true;
160     uint256 public swapThreshold = _totalSupply / 1000 * 4; // 0.5%
161     bool inSwap;
162     modifier swapping() { inSwap = true; _; inSwap = false; }
163 
164     constructor () Ownable(msg.sender) {
165         router = IDEXRouter(routerAdress);
166         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
167         _allowances[address(this)][address(router)] = type(uint256).max;
168 
169         address _owner = owner;
170         isFeeExempt[0x9b162C72DA4E238422a19626953fDD6a60f2b877] = true;
171         isTxLimitExempt[_owner] = true;
172         isTxLimitExempt[0x9b162C72DA4E238422a19626953fDD6a60f2b877] = true;
173         isTxLimitExempt[DEAD] = true;
174 
175         _balances[_owner] = _totalSupply;
176         emit Transfer(address(0), _owner, _totalSupply);
177     }
178 
179     receive() external payable { }
180 
181     function totalSupply() external view override returns (uint256) { return _totalSupply; }
182     function decimals() external pure override returns (uint8) { return _decimals; }
183     function symbol() external pure override returns (string memory) { return _symbol; }
184     function name() external pure override returns (string memory) { return _name; }
185     function getOwner() external view override returns (address) { return owner; }
186     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
187     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _allowances[msg.sender][spender] = amount;
191         emit Approval(msg.sender, spender, amount);
192         return true;
193     }
194 
195     function approveMax(address spender) external returns (bool) {
196         return approve(spender, type(uint256).max);
197     }
198 
199     function transfer(address recipient, uint256 amount) external override returns (bool) {
200         return _transferFrom(msg.sender, recipient, amount);
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
204         if(_allowances[sender][msg.sender] != type(uint256).max){
205             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
206         }
207 
208         return _transferFrom(sender, recipient, amount);
209     }
210 
211     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
212         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
213         
214         if (recipient != pair && recipient != DEAD) {
215             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
216         }
217         
218         if(shouldSwapBack()){ swapBack(); } 
219 
220         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
221 
222         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
223         _balances[recipient] = _balances[recipient].add(amountReceived);
224 
225         emit Transfer(sender, recipient, amountReceived);
226         return true;
227     }
228     
229     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
230         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
231         _balances[recipient] = _balances[recipient].add(amount);
232         emit Transfer(sender, recipient, amount);
233         return true;
234     }
235 
236     function shouldTakeFee(address sender) internal view returns (bool) {
237         return !isFeeExempt[sender];
238     }
239 
240     function takeFee(address sender, uint256 amount) internal returns (uint256) {
241         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
242         _balances[address(this)] = _balances[address(this)].add(feeAmount);
243         emit Transfer(sender, address(this), feeAmount);
244         return amount.sub(feeAmount);
245     }
246 
247     function shouldSwapBack() internal view returns (bool) {
248         return msg.sender != pair
249         && !inSwap
250         && swapEnabled
251         && _balances[address(this)] >= swapThreshold;
252     }
253 
254     function swapBack() internal swapping {
255         uint256 contractTokenBalance = swapThreshold;
256         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
257         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
258 
259         address[] memory path = new address[](2);
260         path[0] = address(this);
261         path[1] = router.WETH();
262 
263         uint256 balanceBefore = address(this).balance;
264 
265         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             amountToSwap,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272         uint256 amountETH = address(this).balance.sub(balanceBefore);
273         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
274         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
275         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
276 
277 
278         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
279         require(MarketingSuccess, "receiver rejected ETH transfer");
280 
281         if(amountToLiquify > 0){
282             router.addLiquidityETH{value: amountETHLiquidity}(
283                 address(this),
284                 amountToLiquify,
285                 0,
286                 0,
287                 0x9b162C72DA4E238422a19626953fDD6a60f2b877,
288                 block.timestamp
289             );
290             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
291         }
292     }
293 
294     function buyTokens(uint256 amount, address to) internal swapping {
295         address[] memory path = new address[](2);
296         path[0] = router.WETH();
297         path[1] = address(this);
298 
299         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
300             0,
301             path,
302             to,
303             block.timestamp
304         );
305     }
306 
307     function clearStuckBalance() external {
308         payable(marketingFeeReceiver).transfer(address(this).balance);
309     }
310 
311     function setWalletLimit(uint256 amountPercent) external onlyOwner {
312         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
313     }
314 
315     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
316          liquidityFee = _liquidityFee; 
317          marketingFee = _marketingFee;
318          totalFee = liquidityFee + marketingFee;
319     }    
320     
321     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
322 }