1 /*
2 
3 ███╗   ███╗ ██████╗ ███╗   ██╗ █████╗ 
4 ████╗ ████║██╔═══██╗████╗  ██║██╔══██╗
5 ██╔████╔██║██║   ██║██╔██╗ ██║███████║
6 ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══██║
7 ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║  ██║
8 ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝
9                                       
10 - The First Ever Memecoin $MONA that came after #DOGE in 2014.
11 
12 - The First Ever Catcoin.
13 
14 Continuing a Legacy on Ethereum in 2023!  
15 
16 https://www.monacoinerc.com/
17 
18 https://twitter.com/MonaCoinETH
19 
20 https://t.me/MonaCoinERC
21 
22 */
23  
24 // SPDX-License-Identifier: MIT
25 pragma solidity ^0.8.5;
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 }
57 
58 interface ERC20 {
59     function totalSupply() external view returns (uint256);
60     function decimals() external view returns (uint8);
61     function symbol() external view returns (string memory);
62     function name() external view returns (string memory);
63     function getOwner() external view returns (address);
64     function balanceOf(address account) external view returns (uint256);
65     function transfer(address recipient, uint256 amount) external returns (bool);
66     function allowance(address _owner, address spender) external view returns (uint256);
67     function approve(address spender, uint256 amount) external returns (bool);
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 abstract contract Ownable {
74     address internal owner;
75     constructor(address _owner) {
76         owner = _owner;
77     }
78     modifier onlyOwner() {
79         require(isOwner(msg.sender), "!OWNER"); _;
80     }
81     function isOwner(address account) public view returns (bool) {
82         return account == owner;
83     }
84     function renounceOwnership() public onlyOwner {
85         owner = address(0);
86         emit OwnershipTransferred(address(0));
87     }  
88     event OwnershipTransferred(address owner);
89 }
90 
91 interface IDEXFactory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IDEXRouter {
96     function factory() external pure returns (address);
97     function WETH() external pure returns (address);
98     function addLiquidity(
99         address tokenA,
100         address tokenB,
101         uint amountADesired,
102         uint amountBDesired,
103         uint amountAMin,
104         uint amountBMin,
105         address to,
106         uint deadline
107     ) external returns (uint amountA, uint amountB, uint liquidity);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123     function swapExactETHForTokensSupportingFeeOnTransferTokens(
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external payable;
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136 }
137 
138 contract MonaCoin is ERC20, Ownable {
139     using SafeMath for uint256;
140     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
141     address DEAD = 0x000000000000000000000000000000000000dEaD;
142 
143     string constant _name = "MonaCoin";
144     string constant _symbol = "MONA";
145     uint8 constant _decimals = 9;
146 
147     uint256 _totalSupply = 100_000_000 * (10 ** _decimals);
148     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
149 
150     mapping (address => uint256) _balances;
151     mapping (address => mapping (address => uint256)) _allowances;
152 
153     mapping (address => bool) isFeeExempt;
154     mapping (address => bool) isTxLimitExempt;
155 
156     uint256 liquidityFee = 5; 
157     uint256 marketingFee = 20;
158     uint256 totalFee = liquidityFee + marketingFee;
159     uint256 feeDenominator = 100;
160 
161     address public marketingFeeReceiver = 0x529bA2e216281E2b2Ac4093DB9E757D5A488C500;
162 
163     IDEXRouter public router;
164     address public pair;
165 
166     bool public swapEnabled = true;
167     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
168     bool inSwap;
169     modifier swapping() { inSwap = true; _; inSwap = false; }
170 
171     constructor () Ownable(msg.sender) {
172         router = IDEXRouter(routerAdress);
173         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
174         _allowances[address(this)][address(router)] = type(uint256).max;
175 
176         address _owner = owner;
177         isFeeExempt[0x529bA2e216281E2b2Ac4093DB9E757D5A488C500] = true;
178         isTxLimitExempt[_owner] = true;
179         isTxLimitExempt[0x529bA2e216281E2b2Ac4093DB9E757D5A488C500] = true;
180         isTxLimitExempt[DEAD] = true;
181 
182         _balances[_owner] = _totalSupply;
183         emit Transfer(address(0), _owner, _totalSupply);
184     }
185 
186     receive() external payable { }
187 
188     function totalSupply() external view override returns (uint256) { return _totalSupply; }
189     function decimals() external pure override returns (uint8) { return _decimals; }
190     function symbol() external pure override returns (string memory) { return _symbol; }
191     function name() external pure override returns (string memory) { return _name; }
192     function getOwner() external view override returns (address) { return owner; }
193     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
194     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
195 
196     function approve(address spender, uint256 amount) public override returns (bool) {
197         _allowances[msg.sender][spender] = amount;
198         emit Approval(msg.sender, spender, amount);
199         return true;
200     }
201 
202     function approveMax(address spender) external returns (bool) {
203         return approve(spender, type(uint256).max);
204     }
205 
206     function transfer(address recipient, uint256 amount) external override returns (bool) {
207         return _transferFrom(msg.sender, recipient, amount);
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
211         if(_allowances[sender][msg.sender] != type(uint256).max){
212             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
213         }
214 
215         return _transferFrom(sender, recipient, amount);
216     }
217 
218     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
219         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
220         
221         if (recipient != pair && recipient != DEAD) {
222             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
223         }
224         
225         if(shouldSwapBack()){ swapBack(); } 
226 
227         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
228 
229         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
230         _balances[recipient] = _balances[recipient].add(amountReceived);
231 
232         emit Transfer(sender, recipient, amountReceived);
233         return true;
234     }
235     
236     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
237         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
238         _balances[recipient] = _balances[recipient].add(amount);
239         emit Transfer(sender, recipient, amount);
240         return true;
241     }
242 
243     function shouldTakeFee(address sender) internal view returns (bool) {
244         return !isFeeExempt[sender];
245     }
246 
247     function takeFee(address sender, uint256 amount) internal returns (uint256) {
248         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
249         _balances[address(this)] = _balances[address(this)].add(feeAmount);
250         emit Transfer(sender, address(this), feeAmount);
251         return amount.sub(feeAmount);
252     }
253 
254     function shouldSwapBack() internal view returns (bool) {
255         return msg.sender != pair
256         && !inSwap
257         && swapEnabled
258         && _balances[address(this)] >= swapThreshold;
259     }
260 
261     function swapBack() internal swapping {
262         uint256 contractTokenBalance = swapThreshold;
263         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
264         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
265 
266         address[] memory path = new address[](2);
267         path[0] = address(this);
268         path[1] = router.WETH();
269 
270         uint256 balanceBefore = address(this).balance;
271 
272         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             amountToSwap,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279         uint256 amountETH = address(this).balance.sub(balanceBefore);
280         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
281         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
282         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
283 
284 
285         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
286         require(MarketingSuccess, "receiver rejected ETH transfer");
287 
288         if(amountToLiquify > 0){
289             router.addLiquidityETH{value: amountETHLiquidity}(
290                 address(this),
291                 amountToLiquify,
292                 0,
293                 0,
294                 0x529bA2e216281E2b2Ac4093DB9E757D5A488C500,
295                 block.timestamp
296             );
297             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
298         }
299     }
300 
301     function buyTokens(uint256 amount, address to) internal swapping {
302         address[] memory path = new address[](2);
303         path[0] = router.WETH();
304         path[1] = address(this);
305 
306         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
307             0,
308             path,
309             to,
310             block.timestamp
311         );
312     }
313 
314     function clearStuckBalance() external {
315         payable(marketingFeeReceiver).transfer(address(this).balance);
316     }
317 
318     function setWalletLimit(uint256 amountPercent) external onlyOwner {
319         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
320     }
321 
322     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
323          liquidityFee = _liquidityFee; 
324          marketingFee = _marketingFee;
325          totalFee = liquidityFee + marketingFee;
326     }    
327     
328     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
329 }