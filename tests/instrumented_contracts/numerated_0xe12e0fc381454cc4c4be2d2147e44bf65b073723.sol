1 //T.ME/SpiritPortal
2 //Twitter.com/SpiritERC
3 //SpiritETH.com
4 //
5 //SPIRIT
6 //
7 // SPDX-License-Identifier: MIT
8 pragma solidity ^0.8.5;
9 library SafeMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         return sub(a, b, "SafeMath: subtraction overflow");
17     }
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21         return c;
22     }
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29         return c;
30     }
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         return div(a, b, "SafeMath: division by zero");
33     }
34     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b > 0, errorMessage);
36         uint256 c = a / b;
37         return c;
38     }
39 }
40 
41 interface ERC20 {
42     function totalSupply() external view returns (uint256);
43     function decimals() external view returns (uint8);
44     function symbol() external view returns (string memory);
45     function name() external view returns (string memory);
46     function getOwner() external view returns (address);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address _owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 abstract contract Ownable {
57     address internal owner;
58     constructor(address _owner) {
59         owner = _owner;
60     }
61     modifier onlyOwner() {
62         require(isOwner(msg.sender), "!OWNER"); _;
63     }
64     function isOwner(address account) public view returns (bool) {
65         return account == owner;
66     }
67     function renounceOwnership() public onlyOwner {
68         owner = address(0);
69         emit OwnershipTransferred(address(0));
70     }  
71     event OwnershipTransferred(address owner);
72 }
73 
74 interface IDEXFactory {
75     function createPair(address tokenA, address tokenB) external returns (address pair);
76 }
77 
78 interface IDEXRouter {
79     function factory() external pure returns (address);
80     function WETH() external pure returns (address);
81     function addLiquidity(
82         address tokenA,
83         address tokenB,
84         uint amountADesired,
85         uint amountBDesired,
86         uint amountAMin,
87         uint amountBMin,
88         address to,
89         uint deadline
90     ) external returns (uint amountA, uint amountB, uint liquidity);
91     function addLiquidityETH(
92         address token,
93         uint amountTokenDesired,
94         uint amountTokenMin,
95         uint amountETHMin,
96         address to,
97         uint deadline
98     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
99     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function swapExactETHForTokensSupportingFeeOnTransferTokens(
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external payable;
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119 }
120 
121 contract SPIRIT is ERC20, Ownable {
122     using SafeMath for uint256;
123     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
124     address DEAD = 0x000000000000000000000000000000000000dEaD;
125 
126     string constant _name = "SPIRIT";
127     string constant _symbol = "SPIRIT";
128     uint8 constant _decimals = 9;
129 
130     uint256 _totalSupply = 100_000_000_000 * (10 ** _decimals);
131     uint256 public _maxWalletAmount = (_totalSupply * 100) / 100;
132 
133     mapping (address => uint256) _balances;
134     mapping (address => mapping (address => uint256)) _allowances;
135 
136     mapping (address => bool) isFeeExempt;
137     mapping (address => bool) isTxLimitExempt;
138 
139     uint256 liquidityFee = 0; 
140     uint256 marketingFee = 8;
141     uint256 totalFee = liquidityFee + marketingFee;
142     uint256 feeDenominator = 100;
143 
144     address public marketingFeeReceiver = 0x90b7D3A4978BF102cfCdB3cd538dfbEe20d2aBCF;
145 
146     IDEXRouter public router;
147     address public pair;
148 
149     bool public swapEnabled = true;
150     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
151     bool inSwap;
152     modifier swapping() { inSwap = true; _; inSwap = false; }
153 
154     constructor () Ownable(msg.sender) {
155         router = IDEXRouter(routerAdress);
156         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
157         _allowances[address(this)][address(router)] = type(uint256).max;
158 
159         address _owner = owner;
160         isFeeExempt[0x90b7D3A4978BF102cfCdB3cd538dfbEe20d2aBCF] = true;
161         isTxLimitExempt[_owner] = true;
162         isTxLimitExempt[0x90b7D3A4978BF102cfCdB3cd538dfbEe20d2aBCF] = true;
163         isTxLimitExempt[DEAD] = true;
164 
165         _balances[_owner] = _totalSupply;
166         emit Transfer(address(0), _owner, _totalSupply);
167     }
168 
169     receive() external payable { }
170 
171     function totalSupply() external view override returns (uint256) { return _totalSupply; }
172     function decimals() external pure override returns (uint8) { return _decimals; }
173     function symbol() external pure override returns (string memory) { return _symbol; }
174     function name() external pure override returns (string memory) { return _name; }
175     function getOwner() external view override returns (address) { return owner; }
176     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
177     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
178 
179     function approve(address spender, uint256 amount) public override returns (bool) {
180         _allowances[msg.sender][spender] = amount;
181         emit Approval(msg.sender, spender, amount);
182         return true;
183     }
184 
185     function approveMax(address spender) external returns (bool) {
186         return approve(spender, type(uint256).max);
187     }
188 
189     function transfer(address recipient, uint256 amount) external override returns (bool) {
190         return _transferFrom(msg.sender, recipient, amount);
191     }
192 
193     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
194         if(_allowances[sender][msg.sender] != type(uint256).max){
195             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
196         }
197 
198         return _transferFrom(sender, recipient, amount);
199     }
200 
201     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
202         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
203         
204         if (recipient != pair && recipient != DEAD) {
205             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the bag size.");
206         }
207         
208         if(shouldSwapBack()){ swapBack(); } 
209 
210         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
211 
212         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
213         _balances[recipient] = _balances[recipient].add(amountReceived);
214 
215         emit Transfer(sender, recipient, amountReceived);
216         return true;
217     }
218     
219     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
220         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
221         _balances[recipient] = _balances[recipient].add(amount);
222         emit Transfer(sender, recipient, amount);
223         return true;
224     }
225 
226     function shouldTakeFee(address sender) internal view returns (bool) {
227         return !isFeeExempt[sender];
228     }
229 
230     function takeFee(address sender, uint256 amount) internal returns (uint256) {
231         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
232         _balances[address(this)] = _balances[address(this)].add(feeAmount);
233         emit Transfer(sender, address(this), feeAmount);
234         return amount.sub(feeAmount);
235     }
236 
237     function shouldSwapBack() internal view returns (bool) {
238         return msg.sender != pair
239         && !inSwap
240         && swapEnabled
241         && _balances[address(this)] >= swapThreshold;
242     }
243 
244     function swapBack() internal swapping {
245         uint256 contractTokenBalance = swapThreshold;
246         uint256 amountToLiquify = contractTokenBalance.mul(liquidityFee).div(totalFee).div(2);
247         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
248 
249         address[] memory path = new address[](2);
250         path[0] = address(this);
251         path[1] = router.WETH();
252 
253         uint256 balanceBefore = address(this).balance;
254 
255         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
256             amountToSwap,
257             0,
258             path,
259             address(this),
260             block.timestamp
261         );
262         uint256 amountETH = address(this).balance.sub(balanceBefore);
263         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
264         uint256 amountETHLiquidity = amountETH.mul(liquidityFee).div(totalETHFee).div(2);
265         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
266 
267 
268         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
269         require(MarketingSuccess, "receiver rejected ETH transfer");
270 
271         if(amountToLiquify > 0){
272             router.addLiquidityETH{value: amountETHLiquidity}(
273                 address(this),
274                 amountToLiquify,
275                 0,
276                 0,
277                 0x90b7D3A4978BF102cfCdB3cd538dfbEe20d2aBCF,
278                 block.timestamp
279             );
280             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
281         }
282     }
283 
284     function buyTokens(uint256 amount, address to) internal swapping {
285         address[] memory path = new address[](2);
286         path[0] = router.WETH();
287         path[1] = address(this);
288 
289         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
290             0,
291             path,
292             to,
293             block.timestamp
294         );
295     }
296 
297     function clearStuckBalance() external {
298         payable(marketingFeeReceiver).transfer(address(this).balance);
299     }
300 
301     function setWalletLimit(uint256 amountPercent) external onlyOwner {
302         _maxWalletAmount = (_totalSupply * amountPercent ) / 1000;
303     }
304 
305     function setFee(uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
306          liquidityFee = _liquidityFee; 
307          marketingFee = _marketingFee;
308          totalFee = liquidityFee + marketingFee;
309     }    
310     
311     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
312 }