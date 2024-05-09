1 /**
2  
3     _   ______  ______
4    / | / / __ \/ ____/
5   /  |/ / /_/ / /     
6  / /|  / ____/ /___   
7 /_/ |_/_/    \____/   
8                       
9 https://www.npcerc.com 
10 
11 */
12  
13 // SPDX-License-Identifier: MIT
14 pragma solidity ^0.8.5;
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         return c;
44     }
45 }
46 
47 interface ERC20 {
48     function totalSupply() external view returns (uint256);
49     function decimals() external view returns (uint8);
50     function symbol() external view returns (string memory);
51     function name() external view returns (string memory);
52     function getOwner() external view returns (address);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address _owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 abstract contract Ownable {
63     address internal owner;
64     constructor(address _owner) {
65         owner = _owner;
66     }
67     modifier onlyOwner() {
68         require(isOwner(msg.sender), "!OWNER"); _;
69     }
70     function isOwner(address account) public view returns (bool) {
71         return account == owner;
72     }
73     function renounceOwnership() public onlyOwner {
74         owner = address(0);
75         emit OwnershipTransferred(address(0));
76     }  
77     event OwnershipTransferred(address owner);
78 }
79 
80 interface IDEXFactory {
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 }
83 
84 interface IDEXRouter {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87     function addLiquidity(
88         address tokenA,
89         address tokenB,
90         uint amountADesired,
91         uint amountBDesired,
92         uint amountAMin,
93         uint amountBMin,
94         address to,
95         uint deadline
96     ) external returns (uint amountA, uint amountB, uint liquidity);
97     function addLiquidityETH(
98         address token,
99         uint amountTokenDesired,
100         uint amountTokenMin,
101         uint amountETHMin,
102         address to,
103         uint deadline
104     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
105     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function swapExactETHForTokensSupportingFeeOnTransferTokens(
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external payable;
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125 }
126 
127 contract NPC is ERC20, Ownable {
128     using SafeMath for uint256;
129     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
130     address DEAD = 0x000000000000000000000000000000000000dEaD;
131 
132     string constant _name = "The Simulation";
133     string constant _symbol = "NPC";
134     uint8 constant _decimals = 9;
135 
136     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
137     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
138 
139     mapping (address => uint256) _balances;
140     mapping (address => mapping (address => uint256)) _allowances;
141 
142     mapping (address => bool) isFeeExempt;
143     mapping (address => bool) isTxLimitExempt;
144 
145     uint256 liquidityFee = 0; 
146     uint256 marketingFee = 7;
147     uint256 totalFee = liquidityFee + marketingFee;
148     uint256 feeDenominator = 100;
149 
150     address public marketingFeeReceiver = 0xB7E5Bc7ba5E306fd8D787c8e36C350B3Bc3244bD;
151 
152     IDEXRouter public router;
153     address public pair;
154 
155     bool public swapEnabled = true;
156     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
157     bool inSwap;
158     modifier swapping() { inSwap = true; _; inSwap = false; }
159 
160     constructor () Ownable(msg.sender) {
161         router = IDEXRouter(routerAdress);
162         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
163         _allowances[address(this)][address(router)] = type(uint256).max;
164 
165         address _owner = owner;
166         isFeeExempt[0xB7E5Bc7ba5E306fd8D787c8e36C350B3Bc3244bD] = true;
167         isTxLimitExempt[_owner] = true;
168         isTxLimitExempt[0xB7E5Bc7ba5E306fd8D787c8e36C350B3Bc3244bD] = true;
169         isTxLimitExempt[DEAD] = true;
170 
171         _balances[_owner] = _totalSupply;
172         emit Transfer(address(0), _owner, _totalSupply);
173     }
174 
175     receive() external payable { }
176 
177     function totalSupply() external view override returns (uint256) { return _totalSupply; }
178     function decimals() external pure override returns (uint8) { return _decimals; }
179     function symbol() external pure override returns (string memory) { return _symbol; }
180     function name() external pure override returns (string memory) { return _name; }
181     function getOwner() external view override returns (address) { return owner; }
182     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
183     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
184 
185     function approve(address spender, uint256 amount) public override returns (bool) {
186         _allowances[msg.sender][spender] = amount;
187         emit Approval(msg.sender, spender, amount);
188         return true;
189     }
190 
191     function approveMax(address spender) external returns (bool) {
192         return approve(spender, type(uint256).max);
193     }
194 
195     function transfer(address recipient, uint256 amount) external override returns (bool) {
196         return _transferFrom(msg.sender, recipient, amount);
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
200         if(_allowances[sender][msg.sender] != type(uint256).max){
201             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
202         }
203 
204         return _transferFrom(sender, recipient, amount);
205     }
206 
207     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
208         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
209         
210         if (recipient != pair && recipient != DEAD) {
211             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
212         }
213         
214         if(shouldSwapBack()){ swapBack(); } 
215 
216         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
217 
218         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
219         _balances[recipient] = _balances[recipient].add(amountReceived);
220 
221         emit Transfer(sender, recipient, amountReceived);
222         return true;
223     }
224     
225     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
226         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
227         _balances[recipient] = _balances[recipient].add(amount);
228         emit Transfer(sender, recipient, amount);
229         return true;
230     }
231 
232     function shouldTakeFee(address sender) internal view returns (bool) {
233         return !isFeeExempt[sender];
234     }
235 
236     function takeFee(address sender, uint256 amount) internal returns (uint256) {
237         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
238         _balances[address(this)] = _balances[address(this)].add(feeAmount);
239         emit Transfer(sender, address(this), feeAmount);
240         return amount.sub(feeAmount);
241     }
242 
243     function shouldSwapBack() internal view returns (bool) {
244         return msg.sender != pair
245         && !inSwap
246         && swapEnabled
247         && _balances[address(this)] >= swapThreshold;
248     }
249 
250     function swapBack() internal swapping {
251         uint256 contractTokenBalance = swapThreshold;
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
268         uint256 amountETH = address(this).balance.sub(balanceBefore);
269         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
270         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
271         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
272 
273 
274         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
275         require(MarketingSuccess, "receiver rejected ETH transfer");
276 
277         if(amountToLiquify > 0){
278             router.addLiquidityETH{value: amountETHLiquidity}(
279                 address(this),
280                 amountToLiquify,
281                 0,
282                 0,
283                 0xB7E5Bc7ba5E306fd8D787c8e36C350B3Bc3244bD,
284                 block.timestamp
285             );
286             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
287         }
288     }
289 
290     function buyTokens(uint256 amount, address to) internal swapping {
291         address[] memory path = new address[](2);
292         path[0] = router.WETH();
293         path[1] = address(this);
294 
295         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
296             0,
297             path,
298             to,
299             block.timestamp
300         );
301     }
302 
303     function clearStuckBalance() external {
304         payable(marketingFeeReceiver).transfer(address(this).balance);
305     }
306 
307     function setWalletLimit(uint256 amountPercent) external onlyOwner {
308         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
309     }
310 
311     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
312          liquidityFee = _liquidityFee; 
313          marketingFee = _marketingFee;
314          totalFee = liquidityFee + marketingFee;
315     }    
316     
317     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
318 }