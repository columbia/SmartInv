1 /*
2    Welcome to Nova Network ($NOVA) 🤝
3    The NOVA team is creating advanced Text-To-VR solutions with the goal of making Virtual Reality accessible to anyone.
4    🤖 The V1 of our Nova AI Assistant is already live.
5    You can use it here: @NovaAssistBot - simply use the command "/ask" and fire away!  
6 
7 
8 🌐 Website:    https://novanetwork.ai
9 ✍️ Whitepaper: https://nova-network.gitbook.io/nova-network-whitepaper
10 📲 Telegram:   https://t.me/NovaNetworkERC
11 
12 */
13  
14 // SPDX-License-Identifier: MIT
15 pragma solidity 0.8.19;
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
128 contract NovaNetwork is ERC20, Ownable {
129     using SafeMath for uint256;
130     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
131     address DEAD = 0x000000000000000000000000000000000000dEaD;
132 
133     string constant _name = "Nova Network";
134     string constant _symbol = "NOVA";
135     uint8 constant _decimals = 9;
136 
137     uint256 _totalSupply = 888_888 * (10 ** _decimals);
138     uint256 public _maxWalletAmount = (_totalSupply * 4) / 100;
139     uint256 public _maxTxAmount = _totalSupply.mul(4).div(100);
140 
141     mapping (address => uint256) _balances;
142     mapping (address => mapping (address => uint256)) _allowances;
143 
144     mapping (address => bool) isFeeExempt;
145     mapping (address => bool) isTxLimitExempt;
146 
147     uint256 liquidityFee = 0; 
148     uint256 marketingFee = 5;
149     uint256 totalFee = liquidityFee + marketingFee;
150     uint256 feeDenominator = 100;
151 
152     address public marketingFeeReceiver = 0xd467CC3DBc30417dBC5dc63A56D310F5AE61e012;
153 
154     IDEXRouter public router;
155     address public pair;
156 
157     bool public swapEnabled = true;
158     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
159     bool inSwap;
160     modifier swapping() { inSwap = true; _; inSwap = false; }
161 
162     constructor () Ownable(msg.sender) {
163         router = IDEXRouter(routerAdress);
164         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
165         _allowances[address(this)][address(router)] = type(uint256).max;
166 
167         address _owner = owner;
168         isFeeExempt[0xd467CC3DBc30417dBC5dc63A56D310F5AE61e012] = true;
169         isTxLimitExempt[_owner] = true;
170         isTxLimitExempt[0xd467CC3DBc30417dBC5dc63A56D310F5AE61e012] = true;
171         isTxLimitExempt[DEAD] = true;
172 
173         _balances[_owner] = _totalSupply;
174         emit Transfer(address(0), _owner, _totalSupply);
175     }
176 
177     receive() external payable { }
178 
179     function totalSupply() external view override returns (uint256) { return _totalSupply; }
180     function decimals() external pure override returns (uint8) { return _decimals; }
181     function symbol() external pure override returns (string memory) { return _symbol; }
182     function name() external pure override returns (string memory) { return _name; }
183     function getOwner() external view override returns (address) { return owner; }
184     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
185     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
186 
187     function approve(address spender, uint256 amount) public override returns (bool) {
188         _allowances[msg.sender][spender] = amount;
189         emit Approval(msg.sender, spender, amount);
190         return true;
191     }
192 
193     function approveMax(address spender) external returns (bool) {
194         return approve(spender, type(uint256).max);
195     }
196 
197     function transfer(address recipient, uint256 amount) external override returns (bool) {
198         return _transferFrom(msg.sender, recipient, amount);
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
202         if(_allowances[sender][msg.sender] != type(uint256).max){
203             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
204         }
205 
206         return _transferFrom(sender, recipient, amount);
207     }
208 
209     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
210         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
211         
212         if (recipient != pair && recipient != DEAD) {
213             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
214         }
215         
216         if(shouldSwapBack()){ swapBack(); } 
217 
218         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
219 
220         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
221         _balances[recipient] = _balances[recipient].add(amountReceived);
222 
223         emit Transfer(sender, recipient, amountReceived);
224         return true;
225     }
226     
227     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
228         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
229         _balances[recipient] = _balances[recipient].add(amount);
230         emit Transfer(sender, recipient, amount);
231         return true;
232     }
233 
234     function shouldTakeFee(address sender) internal view returns (bool) {
235         return !isFeeExempt[sender];
236     }
237 
238     function takeFee(address sender, uint256 amount) internal returns (uint256) {
239         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
240         _balances[address(this)] = _balances[address(this)].add(feeAmount);
241         emit Transfer(sender, address(this), feeAmount);
242         return amount.sub(feeAmount);
243     }
244 
245     function shouldSwapBack() internal view returns (bool) {
246         return msg.sender != pair
247         && !inSwap
248         && swapEnabled
249         && _balances[address(this)] >= swapThreshold;
250     }
251 
252     function swapBack() internal swapping {
253         uint256 contractTokenBalance = swapThreshold;
254         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
255         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
256 
257         address[] memory path = new address[](2);
258         path[0] = address(this);
259         path[1] = router.WETH();
260 
261         uint256 balanceBefore = address(this).balance;
262 
263         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
264             amountToSwap,
265             0,
266             path,
267             address(this),
268             block.timestamp
269         );
270         uint256 amountETH = address(this).balance.sub(balanceBefore);
271         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
272         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
273         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
274 
275 
276         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
277         require(MarketingSuccess, "receiver rejected ETH transfer");
278 
279         if(amountToLiquify > 0){
280             router.addLiquidityETH{value: amountETHLiquidity}(
281                 address(this),
282                 amountToLiquify,
283                 0,
284                 0,
285                 0xd467CC3DBc30417dBC5dc63A56D310F5AE61e012,
286                 block.timestamp
287             );
288             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
289         }
290     }
291 
292     function buyTokens(uint256 amount, address to) internal swapping {
293         address[] memory path = new address[](2);
294         path[0] = router.WETH();
295         path[1] = address(this);
296 
297         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
298             0,
299             path,
300             to,
301             block.timestamp
302         );
303     }
304 
305     function clearStuckBalance() external {
306         payable(marketingFeeReceiver).transfer(address(this).balance);
307     }
308 
309     function setWalletLimit(uint256 amountPercent) external onlyOwner {
310         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
311     }
312 
313     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
314          liquidityFee = _liquidityFee; 
315          marketingFee = _marketingFee;
316          totalFee = liquidityFee + marketingFee;
317     }    
318     
319     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
320 }