1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.16;
8 
9 
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
15     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
16     
17     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
19 
20     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
22 
23     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
25         if(c / a != b) return(false, 0); return(true, c);}}
26 
27     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
29 
30     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         unchecked{require(b <= a, errorMessage); return a - b;}}
35 
36     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         unchecked{require(b > 0, errorMessage); return a / b;}}
38 
39     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         unchecked{require(b > 0, errorMessage); return a % b;}}}
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function getOwner() external view returns (address);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address _owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);}
55 
56 abstract contract Ownable {
57     address internal owner;
58     constructor(address _owner) {owner = _owner;}
59     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
60     function isOwner(address account) public view returns (bool) {return account == owner;}
61     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
62     event OwnershipTransferred(address owner);
63 }
64 
65 interface IFactory{
66         function createPair(address tokenA, address tokenB) external returns (address pair);
67         function getPair(address tokenA, address tokenB) external view returns (address pair);
68 }
69 
70 interface IRouter {
71     function factory() external pure returns (address);
72     function WETH() external pure returns (address);
73     function addLiquidityETH(
74         address token,
75         uint amountTokenDesired,
76         uint amountTokenMin,
77         uint amountETHMin,
78         address to,
79         uint deadline
80     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
81 
82     function removeLiquidityWithPermit(
83         address tokenA,
84         address tokenB,
85         uint liquidity,
86         uint amountAMin,
87         uint amountBMin,
88         address to,
89         uint deadline,
90         bool approveMax, uint8 v, bytes32 r, bytes32 s
91     ) external returns (uint amountA, uint amountB);
92 
93     function swapExactETHForTokensSupportingFeeOnTransferTokens(
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external payable;
99 
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline) external;
106 }
107 
108 contract VortexProtocol is IERC20, Ownable {
109     using SafeMath for uint256;
110     string private constant _name = 'Vortex Protocol';
111     string private constant _symbol = 'VXP';
112     uint8 private constant _decimals = 9;
113     uint256 private _totalSupply = 100000000000 * (10 ** _decimals);
114     uint256 private _maxTxAmountPercent = 200; // 10000;
115     uint256 private _maxTransferPercent = 200;
116     uint256 private _maxWalletPercent = 200;
117     mapping (address => uint256) _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) public isFeeExempt;
120     mapping (address => bool) private isBot;
121     IRouter router;
122     address public pair;
123     bool private tradingAllowed = false;
124     uint256 private liquidityFee = 100;
125     uint256 private marketingFee = 350;
126     uint256 private developmentFee = 50;
127     uint256 private burnFee = 0;
128     uint256 private totalFee = 500;
129     uint256 private sellFee = 500;
130     uint256 private transferFee = 500;
131     uint256 private denominator = 10000;
132     bool private swapEnabled = true;
133     uint256 private swapTimes;
134     bool private swapping; 
135     uint256 private swapThreshold = ( _totalSupply * 200 ) / 100000;
136     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
137     modifier lockTheSwap {swapping = true; _; swapping = false;}
138 
139     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
140     address internal constant development_receiver = 0xB402FE70fF18eDd310fA463aCcc82bA7B786BDEE; 
141     address internal constant marketing_receiver = 0x2070688bd7b12C3e50A5dBd4ecf4F9F378455637;
142     address internal constant liquidity_receiver = 0x542c0C72760af7D9d78272e8EeeB787997F7f021;
143 
144     constructor() Ownable(msg.sender) {
145         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
146         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
147         router = _router;
148         pair = _pair;
149         isFeeExempt[address(this)] = true;
150         isFeeExempt[liquidity_receiver] = true;
151         isFeeExempt[marketing_receiver] = true;
152         isFeeExempt[msg.sender] = true;
153         _balances[msg.sender] = _totalSupply;
154         emit Transfer(address(0), msg.sender, _totalSupply);
155     }
156 
157     receive() external payable {}
158     function name() public pure returns (string memory) {return _name;}
159     function symbol() public pure returns (string memory) {return _symbol;}
160     function decimals() public pure returns (uint8) {return _decimals;}
161     function startTrading() external onlyOwner {tradingAllowed = true;}
162     function getOwner() external view override returns (address) { return owner; }
163     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
164     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
165     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
166     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
167     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
168     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
169     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
170     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
171     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
172     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
173     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
174 
175     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
176         require(sender != address(0), "ERC20: transfer from the zero address");
177         require(recipient != address(0), "ERC20: transfer to the zero address");
178         require(amount > uint256(0), "Transfer amount must be greater than zero");
179         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
180     }
181 
182     function _transfer(address sender, address recipient, uint256 amount) private {
183         preTxCheck(sender, recipient, amount);
184         checkTradingAllowed(sender, recipient);
185         checkMaxWallet(sender, recipient, amount); 
186         swapbackCounters(sender, recipient);
187         checkTxLimit(sender, recipient, amount); 
188         swapBack(sender, recipient, amount);
189         _balances[sender] = _balances[sender].sub(amount);
190         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
191         _balances[recipient] = _balances[recipient].add(amountReceived);
192         emit Transfer(sender, recipient, amountReceived);
193     }
194 
195     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
196         liquidityFee = _liquidity;
197         marketingFee = _marketing;
198         burnFee = _burn;
199         developmentFee = _development;
200         totalFee = _total;
201         sellFee = _sell;
202         transferFee = _trans;
203         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
204     }
205 
206     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
207         uint256 newTx = (totalSupply() * _buy) / 10000;
208         uint256 newTransfer = (totalSupply() * _trans) / 10000;
209         uint256 newWallet = (totalSupply() * _wallet) / 10000;
210         _maxTxAmountPercent = _buy;
211         _maxTransferPercent = _trans;
212         _maxWalletPercent = _wallet;
213         uint256 limit = totalSupply().mul(5).div(1000);
214         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
215     }
216 
217     function checkTradingAllowed(address sender, address recipient) internal view {
218         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
219     }
220     
221     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
222         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
223             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
224     }
225 
226     function swapbackCounters(address sender, address recipient) internal {
227         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
228     }
229 
230     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
231         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
232         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
233     }
234 
235     function swapAndLiquify(uint256 tokens) private lockTheSwap {
236         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
237         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
238         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
239         uint256 initialBalance = address(this).balance;
240         swapTokensForETH(toSwap);
241         uint256 deltaBalance = address(this).balance.sub(initialBalance);
242         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
243         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
244         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
245         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
246         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
247         uint256 remainingBalance = address(this).balance;
248         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
249     }
250 
251     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
252         _approve(address(this), address(router), tokenAmount);
253         router.addLiquidityETH{value: ETHAmount}(
254             address(this),
255             tokenAmount,
256             0,
257             0,
258             liquidity_receiver,
259             block.timestamp);
260     }
261 
262     function swapTokensForETH(uint256 tokenAmount) private {
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = router.WETH();
266         _approve(address(this), address(router), tokenAmount);
267         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             tokenAmount,
269             0,
270             path,
271             address(this),
272             block.timestamp);
273     }
274 
275     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
276         bool aboveMin = amount >= _minTokenAmount;
277         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
278         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(1) && aboveThreshold;
279     }
280 
281     function swapBack(address sender, address recipient, uint256 amount) internal {
282         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
283     }
284 
285     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
286         return !isFeeExempt[sender] && !isFeeExempt[recipient];
287     }
288 
289     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
290         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
291         if(recipient == pair){return sellFee;}
292         if(sender == pair){return totalFee;}
293         return transferFee;
294     }
295 
296     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
297         if(getTotalFee(sender, recipient) > 0){
298         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
299         _balances[address(this)] = _balances[address(this)].add(feeAmount);
300         emit Transfer(sender, address(this), feeAmount);
301         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
302         return amount.sub(feeAmount);} return amount;
303     }
304 
305     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
306         _transfer(sender, recipient, amount);
307         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
308         return true;
309     }
310 
311     function _approve(address owner, address spender, uint256 amount) private {
312         require(owner != address(0), "ERC20: approve from the zero address");
313         require(spender != address(0), "ERC20: approve to the zero address");
314         _allowances[owner][spender] = amount;
315         emit Approval(owner, spender, amount);
316     }
317 
318 }