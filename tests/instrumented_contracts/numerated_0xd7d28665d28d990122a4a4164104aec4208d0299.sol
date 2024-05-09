1 /**
2 
3 https://t.me/DegenIntelligence
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.16;
10 
11 
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
17     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
18     
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
21 
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
24 
25     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
27         if(c / a != b) return(false, 0); return(true, c);}}
28 
29     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
31 
32     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         unchecked{require(b <= a, errorMessage); return a - b;}}
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked{require(b > 0, errorMessage); return a / b;}}
40 
41     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked{require(b > 0, errorMessage); return a % b;}}}
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function decimals() external view returns (uint8);
47     function symbol() external view returns (string memory);
48     function name() external view returns (string memory);
49     function getOwner() external view returns (address);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address _owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);}
57 
58 abstract contract Ownable {
59     address internal owner;
60     constructor(address _owner) {owner = _owner;}
61     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
62     function isOwner(address account) public view returns (bool) {return account == owner;}
63     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
64     event OwnershipTransferred(address owner);
65 }
66 
67 interface IFactory{
68         function createPair(address tokenA, address tokenB) external returns (address pair);
69         function getPair(address tokenA, address tokenB) external view returns (address pair);
70 }
71 
72 interface IRouter {
73     function factory() external pure returns (address);
74     function WETH() external pure returns (address);
75     function addLiquidityETH(
76         address token,
77         uint amountTokenDesired,
78         uint amountTokenMin,
79         uint amountETHMin,
80         address to,
81         uint deadline
82     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
83 
84     function removeLiquidityWithPermit(
85         address tokenA,
86         address tokenB,
87         uint liquidity,
88         uint amountAMin,
89         uint amountBMin,
90         address to,
91         uint deadline,
92         bool approveMax, uint8 v, bytes32 r, bytes32 s
93     ) external returns (uint amountA, uint amountB);
94 
95     function swapExactETHForTokensSupportingFeeOnTransferTokens(
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external payable;
101 
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline) external;
108 }
109 
110 contract DegenIntelligence is IERC20, Ownable {
111     using SafeMath for uint256;
112     string private constant _name = 'Degen Intelligence';
113     string private constant _symbol = 'DI';
114     uint8 private constant _decimals = 9;
115     uint256 private _totalSupply = 69000000 * (10 ** _decimals);
116     uint256 private _maxTxAmountPercent = 150; // 10000;
117     uint256 private _maxTransferPercent = 150;
118     uint256 private _maxWalletPercent = 150;
119     mapping (address => uint256) _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) public isFeeExempt;
122     mapping (address => bool) private isBot;
123     IRouter router;
124     address public pair;
125     bool private tradingAllowed = false;
126     uint256 private liquidityFee = 0;
127     uint256 private marketingFee = 100;
128     uint256 private developmentFee = 100;
129     uint256 private burnFee = 0;
130     uint256 private totalFee = 1500;
131     uint256 private sellFee = 1500;
132     uint256 private transferFee = 1500;
133     uint256 private denominator = 10000;
134     bool private swapEnabled = true;
135     uint256 private swapTimes;
136     bool private swapping; 
137     uint256 private swapThreshold = ( _totalSupply * 350 ) / 100000;
138     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
139     modifier lockTheSwap {swapping = true; _; swapping = false;}
140 
141     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
142     address internal constant development_receiver = 0xad0097f3a3bA354E6645e867C2380575ac3859d6; 
143     address internal constant marketing_receiver = 0xad0097f3a3bA354E6645e867C2380575ac3859d6;
144     address internal constant liquidity_receiver = 0xad0097f3a3bA354E6645e867C2380575ac3859d6;
145 
146     constructor() Ownable(msg.sender) {
147         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
148         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
149         router = _router;
150         pair = _pair;
151         isFeeExempt[address(this)] = true;
152         isFeeExempt[liquidity_receiver] = true;
153         isFeeExempt[marketing_receiver] = true;
154         isFeeExempt[msg.sender] = true;
155         _balances[msg.sender] = _totalSupply;
156         emit Transfer(address(0), msg.sender, _totalSupply);
157     }
158 
159     receive() external payable {}
160     function name() public pure returns (string memory) {return _name;}
161     function symbol() public pure returns (string memory) {return _symbol;}
162     function decimals() public pure returns (uint8) {return _decimals;}
163     function startTrading() external onlyOwner {tradingAllowed = true;}
164     function getOwner() external view override returns (address) { return owner; }
165     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
166     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
167     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
168     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
169     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
170     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
171     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
172     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
173     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
174     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
175     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
176 
177     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
178         require(sender != address(0), "ERC20: transfer from the zero address");
179         require(recipient != address(0), "ERC20: transfer to the zero address");
180         require(amount > uint256(0), "Transfer amount must be greater than zero");
181         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
182     }
183 
184     function _transfer(address sender, address recipient, uint256 amount) private {
185         preTxCheck(sender, recipient, amount);
186         checkTradingAllowed(sender, recipient);
187         checkMaxWallet(sender, recipient, amount); 
188         swapbackCounters(sender, recipient);
189         checkTxLimit(sender, recipient, amount); 
190         swapBack(sender, recipient, amount);
191         _balances[sender] = _balances[sender].sub(amount);
192         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
193         _balances[recipient] = _balances[recipient].add(amountReceived);
194         emit Transfer(sender, recipient, amountReceived);
195     }
196 
197     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
198         liquidityFee = _liquidity;
199         marketingFee = _marketing;
200         burnFee = _burn;
201         developmentFee = _development;
202         totalFee = _total;
203         sellFee = _sell;
204         transferFee = _trans;
205         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
206     }
207 
208     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
209         uint256 newTx = (totalSupply() * _buy) / 10000;
210         uint256 newTransfer = (totalSupply() * _trans) / 10000;
211         uint256 newWallet = (totalSupply() * _wallet) / 10000;
212         _maxTxAmountPercent = _buy;
213         _maxTransferPercent = _trans;
214         _maxWalletPercent = _wallet;
215         uint256 limit = totalSupply().mul(5).div(1000);
216         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
217     }
218 
219     function checkTradingAllowed(address sender, address recipient) internal view {
220         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
221     }
222     
223     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
224         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
225             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
226     }
227 
228     function swapbackCounters(address sender, address recipient) internal {
229         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
230     }
231 
232     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
233         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
234         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
235     }
236 
237     function swapAndLiquify(uint256 tokens) private lockTheSwap {
238         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
239         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
240         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
241         uint256 initialBalance = address(this).balance;
242         swapTokensForETH(toSwap);
243         uint256 deltaBalance = address(this).balance.sub(initialBalance);
244         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
245         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
246         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
247         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
248         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
249         uint256 remainingBalance = address(this).balance;
250         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
251     }
252 
253     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
254         _approve(address(this), address(router), tokenAmount);
255         router.addLiquidityETH{value: ETHAmount}(
256             address(this),
257             tokenAmount,
258             0,
259             0,
260             liquidity_receiver,
261             block.timestamp);
262     }
263 
264     function swapTokensForETH(uint256 tokenAmount) private {
265         address[] memory path = new address[](2);
266         path[0] = address(this);
267         path[1] = router.WETH();
268         _approve(address(this), address(router), tokenAmount);
269         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
270             tokenAmount,
271             0,
272             path,
273             address(this),
274             block.timestamp);
275     }
276 
277     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
278         bool aboveMin = amount >= _minTokenAmount;
279         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
280         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
281     }
282 
283     function swapBack(address sender, address recipient, uint256 amount) internal {
284         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
285     }
286 
287     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
288         return !isFeeExempt[sender] && !isFeeExempt[recipient];
289     }
290 
291     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
292         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
293         if(recipient == pair){return sellFee;}
294         if(sender == pair){return totalFee;}
295         return transferFee;
296     }
297 
298     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
299         if(getTotalFee(sender, recipient) > 0){
300         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
301         _balances[address(this)] = _balances[address(this)].add(feeAmount);
302         emit Transfer(sender, address(this), feeAmount);
303         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
304         return amount.sub(feeAmount);} return amount;
305     }
306 
307     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
308         _transfer(sender, recipient, amount);
309         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
310         return true;
311     }
312 
313     function _approve(address owner, address spender, uint256 amount) private {
314         require(owner != address(0), "ERC20: approve from the zero address");
315         require(spender != address(0), "ERC20: approve to the zero address");
316         _allowances[owner][spender] = amount;
317         emit Approval(owner, spender, amount);
318     }
319 
320 }