1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.16;
4 
5 
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
8     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
11     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
12     
13     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
14         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
15 
16     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
18 
19     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
21         if(c / a != b) return(false, 0); return(true, c);}}
22 
23     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
25 
26     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
28 
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         unchecked{require(b <= a, errorMessage); return a - b;}}
31 
32     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         unchecked{require(b > 0, errorMessage); return a / b;}}
34 
35     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         unchecked{require(b > 0, errorMessage); return a % b;}}}
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40     function decimals() external view returns (uint8);
41     function symbol() external view returns (string memory);
42     function name() external view returns (string memory);
43     function getOwner() external view returns (address);
44     function balanceOf(address account) external view returns (uint256);
45     function transfer(address recipient, uint256 amount) external returns (bool);
46     function allowance(address _owner, address spender) external view returns (uint256);
47     function approve(address spender, uint256 amount) external returns (bool);
48     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);}
51 
52 abstract contract Ownable {
53     address internal owner;
54     constructor(address _owner) {owner = _owner;}
55     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
56     function isOwner(address account) public view returns (bool) {return account == owner;}
57     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
58     event OwnershipTransferred(address owner);
59 }
60 
61 interface IFactory{
62         function createPair(address tokenA, address tokenB) external returns (address pair);
63         function getPair(address tokenA, address tokenB) external view returns (address pair);
64 }
65 
66 interface IRouter {
67     function factory() external pure returns (address);
68     function WETH() external pure returns (address);
69     function addLiquidityETH(
70         address token,
71         uint amountTokenDesired,
72         uint amountTokenMin,
73         uint amountETHMin,
74         address to,
75         uint deadline
76     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
77 
78     function removeLiquidityWithPermit(
79         address tokenA,
80         address tokenB,
81         uint liquidity,
82         uint amountAMin,
83         uint amountBMin,
84         address to,
85         uint deadline,
86         bool approveMax, uint8 v, bytes32 r, bytes32 s
87     ) external returns (uint amountA, uint amountB);
88 
89     function swapExactETHForTokensSupportingFeeOnTransferTokens(
90         uint amountOutMin,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external payable;
95 
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline) external;
102 }
103 
104 contract CheemsInu is IERC20, Ownable {
105     using SafeMath for uint256;
106     string private constant _name = 'CheemsInu';
107     string private constant _symbol = 'CINU';
108     uint8 private constant _decimals = 9;
109     uint256 private _totalSupply = 4138058057 * (10 ** _decimals);
110     uint256 private _maxTxAmountPercent = 1000; // 10000;
111     uint256 private _maxTransferPercent = 1000;
112     uint256 private _maxWalletPercent = 1000;
113     mapping (address => uint256) _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) public isFeeExempt;
116     IRouter router;
117     address public pair;
118     bool private tradingAllowed = false;
119     uint256 private liquidityFee = 100;
120     uint256 private marketingFee = 350;
121     uint256 private developmentFee = 350;
122     uint256 private burnFee = 0;
123     uint256 private totalFee = 800;
124     uint256 private sellFee = 800;
125     uint256 private transferFee = 0;
126     uint256 private denominator = 10000;
127     bool private swapEnabled = true;
128     uint256 private swapTimes;
129     bool private swapping; 
130     uint256 private swapThreshold = ( _totalSupply * 200 ) / 100000;
131     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
132     modifier lockTheSwap {swapping = true; _; swapping = false;}
133 
134     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
135     address internal constant development_receiver = 0x2A748A0FdDeC2A13484CD5394A8821F80CCe4C0b; 
136     address internal constant marketing_receiver = 0xaf70066c66f547C36960d70AB7f6106d54dBb472;
137     address internal constant liquidity_receiver = 0x78eEa15417FeADEF60414F9FDf7886E72e29FA68;
138 
139     constructor() Ownable(msg.sender) {
140         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
141         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
142         router = _router;
143         pair = _pair;
144         isFeeExempt[address(this)] = true;
145         isFeeExempt[liquidity_receiver] = true;
146         isFeeExempt[marketing_receiver] = true;
147         isFeeExempt[msg.sender] = true;
148         _balances[msg.sender] = _totalSupply;
149         emit Transfer(address(0), msg.sender, _totalSupply);
150     }
151 
152     receive() external payable {}
153     function name() public pure returns (string memory) {return _name;}
154     function symbol() public pure returns (string memory) {return _symbol;}
155     function decimals() public pure returns (uint8) {return _decimals;}
156     function startTrading() external onlyOwner {tradingAllowed = true;}
157     function getOwner() external view override returns (address) { return owner; }
158     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
159     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
160     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
161     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
162     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
163     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
164     function totalSupply() public view override returns (uint256) {return _totalSupply;}
165     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
166     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
167     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
168 
169     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
170         require(sender != address(0), "ERC20: transfer from the zero address");
171         require(recipient != address(0), "ERC20: transfer to the zero address");
172         require(amount > uint256(0), "Transfer amount must be greater than zero");
173         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
174     }
175 
176     function _transfer(address sender, address recipient, uint256 amount) private {
177         preTxCheck(sender, recipient, amount);
178         checkTradingAllowed(sender, recipient);
179         checkMaxWallet(sender, recipient, amount); 
180         swapbackCounters(sender, recipient);
181         checkTxLimit(sender, recipient, amount); 
182         swapBack(sender, recipient, amount);
183         _balances[sender] = _balances[sender].sub(amount);
184         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
185         _balances[recipient] = _balances[recipient].add(amountReceived);
186         emit Transfer(sender, recipient, amountReceived);
187     }
188 
189     function checkTradingAllowed(address sender, address recipient) internal view {
190         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
191     }
192     
193     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
194         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
195             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
196     }
197 
198     function swapbackCounters(address sender, address recipient) internal {
199         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
200     }
201 
202     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
203         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
204         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
205     }
206 
207     function swapAndLiquify(uint256 tokens) private lockTheSwap {
208         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
209         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
210         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
211         uint256 initialBalance = address(this).balance;
212         swapTokensForETH(toSwap);
213         uint256 deltaBalance = address(this).balance.sub(initialBalance);
214         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
215         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
216         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
217         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
218         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
219         uint256 remainingBalance = address(this).balance;
220         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
221     }
222 
223     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
224         _approve(address(this), address(router), tokenAmount);
225         router.addLiquidityETH{value: ETHAmount}(
226             address(this),
227             tokenAmount,
228             0,
229             0,
230             liquidity_receiver,
231             block.timestamp);
232     }
233 
234     function swapTokensForETH(uint256 tokenAmount) private {
235         address[] memory path = new address[](2);
236         path[0] = address(this);
237         path[1] = router.WETH();
238         _approve(address(this), address(router), tokenAmount);
239         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
240             tokenAmount,
241             0,
242             path,
243             address(this),
244             block.timestamp);
245     }
246 
247     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
248         bool aboveMin = amount >= _minTokenAmount;
249         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
250         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(3) && aboveThreshold;
251     }
252 
253     function swapBack(address sender, address recipient, uint256 amount) internal {
254         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
255     }
256 
257     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
258         return !isFeeExempt[sender] && !isFeeExempt[recipient];
259     }
260 
261     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
262         if(recipient == pair){return sellFee;}
263         if(sender == pair){return totalFee;}
264         return transferFee;
265     }
266 
267     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
268         if(getTotalFee(sender, recipient) > 0){
269         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
270         _balances[address(this)] = _balances[address(this)].add(feeAmount);
271         emit Transfer(sender, address(this), feeAmount);
272         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
273         return amount.sub(feeAmount);} return amount;
274     }
275 
276     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
279         return true;
280     }
281 
282     function _approve(address owner, address spender, uint256 amount) private {
283         require(owner != address(0), "ERC20: approve from the zero address");
284         require(spender != address(0), "ERC20: approve to the zero address");
285         _allowances[owner][spender] = amount;
286         emit Approval(owner, spender, amount);
287     }
288 
289 }