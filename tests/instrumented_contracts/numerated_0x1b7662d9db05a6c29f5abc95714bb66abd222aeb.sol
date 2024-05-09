1 /*
2 
3 
4 
5 Martin "The Geico Gecko" Was Matt Furie's Real Inspiration Behind Pepe!
6 
7 Martin Can Be Seen On Matt Furie's Myspace Back To 2005
8 + In News Articles where Matt Furie mentioned Martin the Gecko!
9 
10 
11 $MARTIN
12 
13 https://t.me/martincoineth
14 
15 https://twitter.com/martincoineth
16 
17 https://www.martincoineth.com/
18 
19 */
20  
21 // SPDX-License-Identifier: MIT
22 pragma solidity ^0.8.5;
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51         return c;
52     }
53 }
54 
55 interface ERC20 {
56     function totalSupply() external view returns (uint256);
57     function decimals() external view returns (uint8);
58     function symbol() external view returns (string memory);
59     function name() external view returns (string memory);
60     function getOwner() external view returns (address);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address _owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 abstract contract Ownable {
71     address internal owner;
72     constructor(address _owner) {
73         owner = _owner;
74     }
75     modifier onlyOwner() {
76         require(isOwner(msg.sender), "!OWNER"); _;
77     }
78     function isOwner(address account) public view returns (bool) {
79         return account == owner;
80     }
81     function renounceOwnership() public onlyOwner {
82         owner = address(0);
83         emit OwnershipTransferred(address(0));
84     }  
85     event OwnershipTransferred(address owner);
86 }
87 
88 interface IDEXFactory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IDEXRouter {
93     function factory() external pure returns (address);
94     function WETH() external pure returns (address);
95     function addLiquidity(
96         address tokenA,
97         address tokenB,
98         uint amountADesired,
99         uint amountBDesired,
100         uint amountAMin,
101         uint amountBMin,
102         address to,
103         uint deadline
104     ) external returns (uint amountA, uint amountB, uint liquidity);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function swapExactETHForTokensSupportingFeeOnTransferTokens(
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external payable;
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133 }
134 
135 contract MARTIN is ERC20, Ownable {
136     using SafeMath for uint256;
137     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
138     address DEAD = 0x000000000000000000000000000000000000dEaD;
139 
140     string constant _name = "Martin";
141     string constant _symbol = "MARTIN";
142     uint8 constant _decimals = 9;
143 
144     uint256 _totalSupply = 10_000_000 * (10 ** _decimals);
145     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
146 
147     mapping (address => uint256) _balances;
148     mapping (address => mapping (address => uint256)) _allowances;
149 
150     mapping (address => bool) isFeeExempt;
151     mapping (address => bool) isTxLimitExempt;
152 
153     uint256 liquidityFee = 0; 
154     uint256 marketingFee = 25;
155     uint256 totalFee = liquidityFee + marketingFee;
156     uint256 feeDenominator = 100;
157 
158     address public marketingFeeReceiver = 0xC97fcFf51b659D663536CABd51356018517Dc71d;
159 
160     IDEXRouter public router;
161     address public pair;
162 
163     bool public swapEnabled = true;
164     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
165     bool inSwap;
166     modifier swapping() { inSwap = true; _; inSwap = false; }
167 
168     constructor () Ownable(msg.sender) {
169         router = IDEXRouter(routerAdress);
170         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
171         _allowances[address(this)][address(router)] = type(uint256).max;
172 
173         address _owner = owner;
174         isFeeExempt[0xC97fcFf51b659D663536CABd51356018517Dc71d] = true;
175         isTxLimitExempt[_owner] = true;
176         isTxLimitExempt[0xC97fcFf51b659D663536CABd51356018517Dc71d] = true;
177         isTxLimitExempt[DEAD] = true;
178 
179         _balances[_owner] = _totalSupply;
180         emit Transfer(address(0), _owner, _totalSupply);
181     }
182 
183     receive() external payable { }
184 
185     function totalSupply() external view override returns (uint256) { return _totalSupply; }
186     function decimals() external pure override returns (uint8) { return _decimals; }
187     function symbol() external pure override returns (string memory) { return _symbol; }
188     function name() external pure override returns (string memory) { return _name; }
189     function getOwner() external view override returns (address) { return owner; }
190     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
191     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _allowances[msg.sender][spender] = amount;
195         emit Approval(msg.sender, spender, amount);
196         return true;
197     }
198 
199     function approveMax(address spender) external returns (bool) {
200         return approve(spender, type(uint256).max);
201     }
202 
203     function transfer(address recipient, uint256 amount) external override returns (bool) {
204         return _transferFrom(msg.sender, recipient, amount);
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
208         if(_allowances[sender][msg.sender] != type(uint256).max){
209             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
210         }
211 
212         return _transferFrom(sender, recipient, amount);
213     }
214 
215     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
216         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
217         
218         if (recipient != pair && recipient != DEAD) {
219             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
220         }
221         
222         if(shouldSwapBack()){ swapBack(); } 
223 
224         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
225 
226         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
227         _balances[recipient] = _balances[recipient].add(amountReceived);
228 
229         emit Transfer(sender, recipient, amountReceived);
230         return true;
231     }
232     
233     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
234         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
235         _balances[recipient] = _balances[recipient].add(amount);
236         emit Transfer(sender, recipient, amount);
237         return true;
238     }
239 
240     function shouldTakeFee(address sender) internal view returns (bool) {
241         return !isFeeExempt[sender];
242     }
243 
244     function takeFee(address sender, uint256 amount) internal returns (uint256) {
245         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
246         _balances[address(this)] = _balances[address(this)].add(feeAmount);
247         emit Transfer(sender, address(this), feeAmount);
248         return amount.sub(feeAmount);
249     }
250 
251     function shouldSwapBack() internal view returns (bool) {
252         return msg.sender != pair
253         && !inSwap
254         && swapEnabled
255         && _balances[address(this)] >= swapThreshold;
256     }
257 
258     function swapBack() internal swapping {
259         uint256 contractTokenBalance = swapThreshold;
260         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
261         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
262 
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = router.WETH();
266 
267         uint256 balanceBefore = address(this).balance;
268 
269         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
270             amountToSwap,
271             0,
272             path,
273             address(this),
274             block.timestamp
275         );
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
291                 0xC97fcFf51b659D663536CABd51356018517Dc71d,
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
316         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
317     }
318 
319     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
320          liquidityFee = _liquidityFee; 
321          marketingFee = _marketingFee;
322          totalFee = liquidityFee + marketingFee;
323     }    
324     
325     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
326 }