1 /**
2 Website: https://www.yasueth.com/
3  
4 
5  █▄█ ▄▀█ █▀ █░█
6  ░█░ █▀█ ▄█ █▄█
7 */
8  
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.5;
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
123 contract YASU is ERC20, Ownable {
124     using SafeMath for uint256;
125     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
126     address DEAD = 0x000000000000000000000000000000000000dEaD;
127 
128     string constant _name = "YASU";
129     string constant _symbol = "YASU";
130     uint8 constant _decimals = 9;
131 
132     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
133     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
134 
135     mapping (address => uint256) _balances;
136     mapping (address => mapping (address => uint256)) _allowances;
137 
138     mapping (address => bool) isFeeExempt;
139     mapping (address => bool) isTxLimitExempt;
140 
141     uint256 liquidityFee = 0; 
142     uint256 marketingFee = 8;
143     uint256 totalFee = liquidityFee + marketingFee;
144     uint256 feeDenominator = 100;
145 
146     address public marketingFeeReceiver = 0x15f892c922f08a41eBbfaE007826A526e86881CF;
147 
148     IDEXRouter public router;
149     address public pair;
150 
151     bool public swapEnabled = true;
152     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
153     bool inSwap;
154     modifier swapping() { inSwap = true; _; inSwap = false; }
155 
156     constructor () Ownable(msg.sender) {
157         router = IDEXRouter(routerAdress);
158         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
159         _allowances[address(this)][address(router)] = type(uint256).max;
160 
161         address _owner = owner;
162         isFeeExempt[0x15f892c922f08a41eBbfaE007826A526e86881CF] = true;
163         isTxLimitExempt[_owner] = true;
164         isTxLimitExempt[0x15f892c922f08a41eBbfaE007826A526e86881CF] = true;
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
204         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
205         
206         if (recipient != pair && recipient != DEAD) {
207             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
208         }
209         
210         if(shouldSwapBack()){ swapBack(); } 
211 
212         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
213 
214         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
215         _balances[recipient] = _balances[recipient].add(amountReceived);
216 
217         emit Transfer(sender, recipient, amountReceived);
218         return true;
219     }
220     
221     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
222         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
223         _balances[recipient] = _balances[recipient].add(amount);
224         emit Transfer(sender, recipient, amount);
225         return true;
226     }
227 
228     function shouldTakeFee(address sender) internal view returns (bool) {
229         return !isFeeExempt[sender];
230     }
231 
232     function takeFee(address sender, uint256 amount) internal returns (uint256) {
233         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
234         _balances[address(this)] = _balances[address(this)].add(feeAmount);
235         emit Transfer(sender, address(this), feeAmount);
236         return amount.sub(feeAmount);
237     }
238 
239     function shouldSwapBack() internal view returns (bool) {
240         return msg.sender != pair
241         && !inSwap
242         && swapEnabled
243         && _balances[address(this)] >= swapThreshold;
244     }
245 
246     function swapBack() internal swapping {
247         uint256 contractTokenBalance = swapThreshold;
248         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
249         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
250 
251         address[] memory path = new address[](2);
252         path[0] = address(this);
253         path[1] = router.WETH();
254 
255         uint256 balanceBefore = address(this).balance;
256 
257         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
258             amountToSwap,
259             0,
260             path,
261             address(this),
262             block.timestamp
263         );
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
279                 0x15f892c922f08a41eBbfaE007826A526e86881CF,
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
304         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
305     }
306 
307     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
308          liquidityFee = _liquidityFee; 
309          marketingFee = _marketingFee;
310          totalFee = liquidityFee + marketingFee;
311     }    
312     
313     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
314 }