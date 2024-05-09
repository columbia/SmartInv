1 /*
2 
3 
4  ██████╗ ██╗       ██╗ █████╗ ██████╗ ██╗███████╗██╗   ██╗
5 ██╔════╝ ██║  ██╗  ██║██╔══██╗██╔══██╗██║██╔════╝╚██╗  █╔╝
6 ╚█████╗  ╚██╗████╗██╔╝███████║██████╔╝██║█████╗   ╚████╔╝ 
7  ╚═══██╗  ████╔═████║ ██╔══██║██╔═══╝ ██║██╔══╝    ╚██╔╝  
8 ██████╔╝  ╚██╔╝ ╚██╔╝ ██║  ██║██║     ██║██║        ██║   
9 ╚═════╝    ╚═╝   ╚═╝  ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝        ╚═╝   
10 
11 A new way to trade.
12 Swapify has features that no other swap can offer.
13 Join us now to find out more.                                                   
14 
15 Telegram: https://t.me/swapifyeth
16 Twitter: https://twitter.com/SwapifySwap
17 Website: https://swapifyeth.com
18 Medium: https://medium.com/@swapifyerc/swapify-medium-d504305bd14e
19 
20 */
21  
22 // SPDX-License-Identifier: MIT
23 pragma solidity ^0.8.5;
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b > 0, errorMessage);
51         uint256 c = a / b;
52         return c;
53     }
54 }
55 
56 interface ERC20 {
57     function totalSupply() external view returns (uint256);
58     function decimals() external view returns (uint8);
59     function symbol() external view returns (string memory);
60     function name() external view returns (string memory);
61     function getOwner() external view returns (address);
62     function balanceOf(address account) external view returns (uint256);
63     function transfer(address recipient, uint256 amount) external returns (bool);
64     function allowance(address _owner, address spender) external view returns (uint256);
65     function approve(address spender, uint256 amount) external returns (bool);
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 abstract contract Ownable {
72     address internal owner;
73     constructor(address _owner) {
74         owner = _owner;
75     }
76     modifier onlyOwner() {
77         require(isOwner(msg.sender), "!OWNER"); _;
78     }
79     function isOwner(address account) public view returns (bool) {
80         return account == owner;
81     }
82     function renounceOwnership() public onlyOwner {
83         owner = address(0);
84         emit OwnershipTransferred(address(0));
85     }  
86     event OwnershipTransferred(address owner);
87 }
88 
89 interface IDEXFactory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IDEXRouter {
94     function factory() external pure returns (address);
95     function WETH() external pure returns (address);
96     function addLiquidity(
97         address tokenA,
98         address tokenB,
99         uint amountADesired,
100         uint amountBDesired,
101         uint amountAMin,
102         uint amountBMin,
103         address to,
104         uint deadline
105     ) external returns (uint amountA, uint amountB, uint liquidity);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121     function swapExactETHForTokensSupportingFeeOnTransferTokens(
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external payable;
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134 }
135 
136 contract Swapify is ERC20, Ownable {
137     using SafeMath for uint256;
138     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
139     address DEAD = 0x000000000000000000000000000000000000dEaD;
140 
141     string constant _name = "Swapify";
142     string constant _symbol = "SWIFY";
143     uint8 constant _decimals = 9;
144 
145     uint256 _totalSupply = 100_000_000 * (10 ** _decimals);
146     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
147 
148     mapping (address => uint256) _balances;
149     mapping (address => mapping (address => uint256)) _allowances;
150 
151     mapping (address => bool) isFeeExempt;
152     mapping (address => bool) isTxLimitExempt;
153 
154     uint256 liquidityFee = 0; 
155     uint256 marketingFee = 8;
156     uint256 totalFee = liquidityFee + marketingFee;
157     uint256 feeDenominator = 100;
158 
159     address public marketingFeeReceiver = 0xF36aDbd40bed0d2a1F440F23AB11d7bdE6065c8f;
160 
161     IDEXRouter public router;
162     address public pair;
163 
164     bool public swapEnabled = true;
165     uint256 public swapThreshold = _totalSupply / 1000 * 4; // 0.5%
166     bool inSwap;
167     modifier swapping() { inSwap = true; _; inSwap = false; }
168 
169     constructor () Ownable(msg.sender) {
170         router = IDEXRouter(routerAdress);
171         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
172         _allowances[address(this)][address(router)] = type(uint256).max;
173 
174         address _owner = owner;
175         isFeeExempt[0xF36aDbd40bed0d2a1F440F23AB11d7bdE6065c8f] = true;
176         isTxLimitExempt[_owner] = true;
177         isTxLimitExempt[0xF36aDbd40bed0d2a1F440F23AB11d7bdE6065c8f] = true;
178         isTxLimitExempt[DEAD] = true;
179 
180         _balances[_owner] = _totalSupply;
181         emit Transfer(address(0), _owner, _totalSupply);
182     }
183 
184     receive() external payable { }
185 
186     function totalSupply() external view override returns (uint256) { return _totalSupply; }
187     function decimals() external pure override returns (uint8) { return _decimals; }
188     function symbol() external pure override returns (string memory) { return _symbol; }
189     function name() external pure override returns (string memory) { return _name; }
190     function getOwner() external view override returns (address) { return owner; }
191     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
192     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _allowances[msg.sender][spender] = amount;
196         emit Approval(msg.sender, spender, amount);
197         return true;
198     }
199 
200     function approveMax(address spender) external returns (bool) {
201         return approve(spender, type(uint256).max);
202     }
203 
204     function transfer(address recipient, uint256 amount) external override returns (bool) {
205         return _transferFrom(msg.sender, recipient, amount);
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
209         if(_allowances[sender][msg.sender] != type(uint256).max){
210             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
211         }
212 
213         return _transferFrom(sender, recipient, amount);
214     }
215 
216     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
217         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
218         
219         if (recipient != pair && recipient != DEAD) {
220             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
221         }
222         
223         if(shouldSwapBack()){ swapBack(); } 
224 
225         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
226 
227         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
228         _balances[recipient] = _balances[recipient].add(amountReceived);
229 
230         emit Transfer(sender, recipient, amountReceived);
231         return true;
232     }
233     
234     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
235         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
236         _balances[recipient] = _balances[recipient].add(amount);
237         emit Transfer(sender, recipient, amount);
238         return true;
239     }
240 
241     function shouldTakeFee(address sender) internal view returns (bool) {
242         return !isFeeExempt[sender];
243     }
244 
245     function takeFee(address sender, uint256 amount) internal returns (uint256) {
246         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
247         _balances[address(this)] = _balances[address(this)].add(feeAmount);
248         emit Transfer(sender, address(this), feeAmount);
249         return amount.sub(feeAmount);
250     }
251 
252     function shouldSwapBack() internal view returns (bool) {
253         return msg.sender != pair
254         && !inSwap
255         && swapEnabled
256         && _balances[address(this)] >= swapThreshold;
257     }
258 
259     function swapBack() internal swapping {
260         uint256 contractTokenBalance = swapThreshold;
261         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
262         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
263 
264         address[] memory path = new address[](2);
265         path[0] = address(this);
266         path[1] = router.WETH();
267 
268         uint256 balanceBefore = address(this).balance;
269 
270         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
271             amountToSwap,
272             0,
273             path,
274             address(this),
275             block.timestamp
276         );
277         uint256 amountETH = address(this).balance.sub(balanceBefore);
278         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
279         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
280         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
281 
282 
283         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
284         require(MarketingSuccess, "receiver rejected ETH transfer");
285 
286         if(amountToLiquify > 0){
287             router.addLiquidityETH{value: amountETHLiquidity}(
288                 address(this),
289                 amountToLiquify,
290                 0,
291                 0,
292                 0xF36aDbd40bed0d2a1F440F23AB11d7bdE6065c8f,
293                 block.timestamp
294             );
295             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
296         }
297     }
298 
299     function buyTokens(uint256 amount, address to) internal swapping {
300         address[] memory path = new address[](2);
301         path[0] = router.WETH();
302         path[1] = address(this);
303 
304         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
305             0,
306             path,
307             to,
308             block.timestamp
309         );
310     }
311 
312     function clearStuckBalance() external {
313         payable(marketingFeeReceiver).transfer(address(this).balance);
314     }
315 
316     function setWalletLimit(uint256 amountPercent) external onlyOwner {
317         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
318     }
319 
320     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
321          liquidityFee = _liquidityFee; 
322          marketingFee = _marketingFee;
323          totalFee = liquidityFee + marketingFee;
324     }    
325     
326     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
327 }