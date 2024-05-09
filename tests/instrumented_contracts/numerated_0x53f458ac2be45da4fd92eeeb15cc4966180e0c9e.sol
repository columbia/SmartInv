1 /*
2 
3   _____  ______ _____  ______  _____ _   _ _____ _____  ______ _____  
4  |  __ \|  ____|  __ \|  ____|/ ____| \ | |_   _|  __ \|  ____|  __ \ 
5  | |__) | |__  | |__) | |__  | (___ |  \| | | | | |__) | |__  | |__) |
6  |  ___/|  __| |  ___/|  __|  \___ \| . ` | | | |  ___/|  __| |  _  / 
7  | |    | |____| |    | |____ ____) | |\  |_| |_| |    | |____| | \ \ 
8  |_|    |______|_|    |______|_____/|_| \_|_____|_|    |______|_|  \_\
9                                                                       
10 
11 Website - https://pepesniper.io
12 Telegram - https://t.me/pepesnipereth
13 
14 Sniper - https://pepesniper.app/
15 
16 */
17 
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity ^0.8.5;
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         require(b <= a, errorMessage);
32         uint256 c = a - b;
33         return c;
34     }
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39         uint256 c = a * b;
40         require(c / a == b, "SafeMath: multiplication overflow");
41         return c;
42     }
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         return div(a, b, "SafeMath: division by zero");
45     }
46     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         return c;
50     }
51 }
52 
53 interface ERC20 {
54     function totalSupply() external view returns (uint256);
55     function decimals() external view returns (uint8);
56     function symbol() external view returns (string memory);
57     function name() external view returns (string memory);
58     function getOwner() external view returns (address);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address _owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 abstract contract Ownable {
69     address internal owner;
70     constructor(address _owner) {
71         owner = _owner;
72     }
73     modifier onlyOwner() {
74         require(isOwner(msg.sender), "!OWNER"); _;
75     }
76     function isOwner(address account) public view returns (bool) {
77         return account == owner;
78     }
79     function renounceOwnership() public onlyOwner {
80         owner = address(0);
81         emit OwnershipTransferred(address(0));
82     }  
83     event OwnershipTransferred(address owner);
84 }
85 
86 interface IDEXFactory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IDEXRouter {
91     function factory() external pure returns (address);
92     function WETH() external pure returns (address);
93     function addLiquidity(
94         address tokenA,
95         address tokenB,
96         uint amountADesired,
97         uint amountBDesired,
98         uint amountAMin,
99         uint amountBMin,
100         address to,
101         uint deadline
102     ) external returns (uint amountA, uint amountB, uint liquidity);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118     function swapExactETHForTokensSupportingFeeOnTransferTokens(
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external payable;
124     function swapExactTokensForETHSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131 }
132 
133 contract PIPER is ERC20, Ownable {
134     using SafeMath for uint256;
135     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
136     address DEAD = 0x000000000000000000000000000000000000dEaD;
137 
138     string constant _name = "Pepe Sniper";
139     string constant _symbol = "PIPER";
140     uint8 constant _decimals = 9;
141 
142     uint256 _totalSupply = 100000000 * (10 ** _decimals);
143     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
144 
145     mapping (address => uint256) _balances;
146     mapping (address => mapping (address => uint256)) _allowances;
147 
148     mapping (address => bool) isFeeExempt;
149     mapping (address => bool) isTxLimitExempt;
150 
151     uint256 liquidityFee = 0; 
152     uint256 marketingFee = 8;
153     uint256 totalFee = liquidityFee + marketingFee;
154     uint256 feeDenominator = 100;
155 
156     address internal marketingFeeReceiver = 0xE31E44955D9dC98D4Bf479eCbeceC8F7E7066755;
157 
158     IDEXRouter public router;
159     address public pair;
160 
161     bool public swapEnabled = true;
162     uint256 public swapThreshold = _totalSupply / 1000 * 2; // 0.5%
163     bool inSwap;
164     modifier swapping() { inSwap = true; _; inSwap = false; }
165 
166     constructor () Ownable(msg.sender) {
167         router = IDEXRouter(routerAdress);
168         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
169         _allowances[address(this)][address(router)] = type(uint256).max;
170 
171         address _owner = owner;
172         isFeeExempt[0xE31E44955D9dC98D4Bf479eCbeceC8F7E7066755] = true;
173         isTxLimitExempt[_owner] = true;
174         isTxLimitExempt[0xE31E44955D9dC98D4Bf479eCbeceC8F7E7066755] = true;
175         isTxLimitExempt[DEAD] = true;
176 
177         _balances[_owner] = _totalSupply;
178         emit Transfer(address(0), _owner, _totalSupply);
179     }
180 
181     receive() external payable { }
182 
183     function totalSupply() external view override returns (uint256) { return _totalSupply; }
184     function decimals() external pure override returns (uint8) { return _decimals; }
185     function symbol() external pure override returns (string memory) { return _symbol; }
186     function name() external pure override returns (string memory) { return _name; }
187     function getOwner() external view override returns (address) { return owner; }
188     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
189     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _allowances[msg.sender][spender] = amount;
193         emit Approval(msg.sender, spender, amount);
194         return true;
195     }
196 
197     function approveMax(address spender) external returns (bool) {
198         return approve(spender, type(uint256).max);
199     }
200 
201     function transfer(address recipient, uint256 amount) external override returns (bool) {
202         return _transferFrom(msg.sender, recipient, amount);
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
206         if(_allowances[sender][msg.sender] != type(uint256).max){
207             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
208         }
209 
210         return _transferFrom(sender, recipient, amount);
211     }
212 
213     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
214         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
215         
216         if (recipient != pair && recipient != DEAD) {
217             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
218         }
219         
220         if(shouldSwapBack()){ swapBack(); } 
221 
222         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
223 
224         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
225         _balances[recipient] = _balances[recipient].add(amountReceived);
226 
227         emit Transfer(sender, recipient, amountReceived);
228         return true;
229     }
230     
231     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
232         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
233         _balances[recipient] = _balances[recipient].add(amount);
234         emit Transfer(sender, recipient, amount);
235         return true;
236     }
237 
238     function shouldTakeFee(address sender) internal view returns (bool) {
239         return !isFeeExempt[sender];
240     }
241 
242     function takeFee(address sender, uint256 amount) internal returns (uint256) {
243         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
244         _balances[address(this)] = _balances[address(this)].add(feeAmount);
245         emit Transfer(sender, address(this), feeAmount);
246         return amount.sub(feeAmount);
247     }
248 
249     function shouldSwapBack() internal view returns (bool) {
250         return msg.sender != pair
251         && !inSwap
252         && swapEnabled
253         && _balances[address(this)] >= swapThreshold;
254     }
255 
256     function swapBack() internal swapping {
257         uint256 contractTokenBalance = swapThreshold;
258         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
259         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
260 
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = router.WETH();
264 
265         uint256 balanceBefore = address(this).balance;
266 
267         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             amountToSwap,
269             0,
270             path,
271             address(this),
272             block.timestamp
273         );
274         uint256 amountETH = address(this).balance.sub(balanceBefore);
275         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
276         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
277         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
278 
279 
280         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
281         require(MarketingSuccess, "receiver rejected ETH transfer");
282 
283         if(amountToLiquify > 0){
284             router.addLiquidityETH{value: amountETHLiquidity}(
285                 address(this),
286                 amountToLiquify,
287                 0,
288                 0,
289                0xE31E44955D9dC98D4Bf479eCbeceC8F7E7066755,
290                 block.timestamp
291             );
292             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
293         }
294     }
295 
296     function buyTokens(uint256 amount, address to) internal swapping {
297         address[] memory path = new address[](2);
298         path[0] = router.WETH();
299         path[1] = address(this);
300 
301         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
302             0,
303             path,
304             to,
305             block.timestamp
306         );
307     }
308 
309     function clearStuckBalance() external {
310         payable(marketingFeeReceiver).transfer(address(this).balance);
311     }
312 
313     function setWalletLimit(uint256 amountPercent) external onlyOwner {
314         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
315     }
316 
317     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
318          liquidityFee = _liquidityFee; 
319          marketingFee = _marketingFee;
320          totalFee = liquidityFee + marketingFee;
321     }    
322     
323     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
324 }