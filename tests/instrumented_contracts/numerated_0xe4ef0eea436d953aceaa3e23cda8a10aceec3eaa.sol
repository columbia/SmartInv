1 /**
2 https://0xburn.net
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.19; 
7 
8 
9 library SafeMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
14     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
15     
16     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
18 
19     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
21 
22     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
24         if(c / a != b) return(false, 0); return(true, c);}}
25 
26     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
28 
29     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         unchecked{require(b <= a, errorMessage); return a - b;}}
34 
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         unchecked{require(b > 0, errorMessage); return a / b;}}
37 
38     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked{require(b > 0, errorMessage); return a % b;}}}
40 
41 interface IERC20 {
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
53     event Approval(address indexed owner, address indexed spender, uint256 value);}
54 
55 abstract contract Ownable {
56     address internal owner;
57     constructor(address _owner) {owner = _owner;}
58     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
59     function isOwner(address account) public view returns (bool) {return account == owner;}
60     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
61     event OwnershipTransferred(address owner);
62 }
63 
64 interface IFactory{
65         function createPair(address tokenA, address tokenB) external returns (address pair);
66         function getPair(address tokenA, address tokenB) external view returns (address pair);
67 }
68 
69 interface IRouter {
70     function factory() external pure returns (address);
71     function WETH() external pure returns (address);
72     function addLiquidityETH(
73         address token,
74         uint amountTokenDesired,
75         uint amountTokenMin,
76         uint amountETHMin,
77         address to,
78         uint deadline
79     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
80 
81     function removeLiquidityWithPermit(
82         address tokenA,
83         address tokenB,
84         uint liquidity,
85         uint amountAMin,
86         uint amountBMin,
87         address to,
88         uint deadline,
89         bool approveMax, uint8 v, bytes32 r, bytes32 s
90     ) external returns (uint amountA, uint amountB);
91 
92     function swapExactETHForTokensSupportingFeeOnTransferTokens(
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external payable;
98 
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline) external;
105 }
106 
107 contract  OxBURN  is IERC20, Ownable {
108     using SafeMath for uint256;
109     string private constant _name = unicode"0xBurn";
110     string private constant _symbol = unicode"0xB";
111     uint8 private constant _decimals = 9;
112     uint256 private _totalSupply = 100000000000000 * (10 ** _decimals);
113     uint256 private _maxTxAmountPercent = 200; // 10000;
114     uint256 private _maxTransferPercent = 200;
115     uint256 private _maxWalletPercent = 200;
116     mapping (address => uint256) _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) public isFeeExempt;
119     mapping (address => bool) private isBot;
120     IRouter router;
121     address public pair;
122     bool private tradingAllowed = true;
123     uint256 private liquidityFee = 0;
124     uint256 private marketingFee = 2000;
125     uint256 private developmentFee = 0;
126     uint256 private burnFee = 0;
127     uint256 private totalFee = 2000;
128     uint256 private sellFee = 5000;
129     uint256 private transferFee = 0;
130     uint256 private denominator = 10000;
131     bool private swapEnabled = true;
132     uint256 private swapTimes;
133     bool private swapping; 
134     uint256 private swapThreshold = ( _totalSupply * 350 ) / 100000;
135     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
136     modifier lockTheSwap {swapping = true; _; swapping = false;}
137 
138     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
139     address internal constant development_receiver = 0x4aD058711A0f4a5eB5d6237169D4ed6282f6aD67; 
140     address internal constant marketing_receiver = 0x4aD058711A0f4a5eB5d6237169D4ed6282f6aD67;
141     address internal constant liquidity_receiver = 0x4aD058711A0f4a5eB5d6237169D4ed6282f6aD67;
142 
143     constructor() Ownable(msg.sender) {
144         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
145         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
146         router = _router;
147         pair = _pair;
148         isFeeExempt[address(this)] = true;
149         isFeeExempt[liquidity_receiver] = true;
150         isFeeExempt[marketing_receiver] = true;
151         isFeeExempt[msg.sender] = true;
152         _balances[msg.sender] = _totalSupply;
153         emit Transfer(address(0), msg.sender, _totalSupply);
154     }
155 
156     receive() external payable {}
157     function name() public pure returns (string memory) {return _name;}
158     function symbol() public pure returns (string memory) {return _symbol;}
159     function decimals() public pure returns (uint8) {return _decimals;}
160     function startTrading() external onlyOwner {tradingAllowed = true;}
161     function getOwner() external view override returns (address) { return owner; }
162     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
163     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
164     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
165     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
166     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
167     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
168     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
169     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
170     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
171     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
172     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
173 
174     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
175         require(sender != address(0), "ERC20: transfer from the zero address");
176         require(recipient != address(0), "ERC20: transfer to the zero address");
177         require(amount > uint256(0), "Transfer amount must be greater than zero");
178         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
179     }
180 
181     function _transfer(address sender, address recipient, uint256 amount) private {
182         preTxCheck(sender, recipient, amount);
183         checkTradingAllowed(sender, recipient);
184         checkMaxWallet(sender, recipient, amount); 
185         swapbackCounters(sender, recipient);
186         checkTxLimit(sender, recipient, amount); 
187         swapBack(sender, recipient, amount);
188         _balances[sender] = _balances[sender].sub(amount);
189         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
190         _balances[recipient] = _balances[recipient].add(amountReceived);
191         emit Transfer(sender, recipient, amountReceived);
192     }
193 
194     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
195         liquidityFee = _liquidity;
196         marketingFee = _marketing;
197         burnFee = _burn;
198         developmentFee = _development;
199         totalFee = _total;
200         sellFee = _sell;
201         transferFee = _trans;
202         require(totalFee <= denominator.div(6) && sellFee <= denominator.div(6), "totalFee and sellFee cannot be more than 16%");
203     }
204 
205     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
206         uint256 newTx = (totalSupply() * _buy) / 20000;
207         uint256 newTransfer = (totalSupply() * _trans) / 10000;
208         uint256 newWallet = (totalSupply() * _wallet) / 30000;
209         _maxTxAmountPercent = _buy;
210         _maxTransferPercent = _trans;
211         _maxWalletPercent = _wallet;
212         uint256 limit = totalSupply().mul(5).div(1000);
213         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
214     }
215 
216     function checkTradingAllowed(address sender, address recipient) internal view {
217         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
218     }
219     
220     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
221         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
222             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
223     }
224 
225     function swapbackCounters(address sender, address recipient) internal {
226         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
227     }
228 
229     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
230         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
231         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
232     }
233 
234     function swapAndLiquify(uint256 tokens) private lockTheSwap {
235         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
236         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
237         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
238         uint256 initialBalance = address(this).balance;
239         swapTokensForETH(toSwap);
240         uint256 deltaBalance = address(this).balance.sub(initialBalance);
241         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
242         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
243         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
244         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
245         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
246         uint256 remainingBalance = address(this).balance;
247         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
248     }
249 
250     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
251         _approve(address(this), address(router), tokenAmount);
252         router.addLiquidityETH{value: ETHAmount}(
253             address(this),
254             tokenAmount,
255             0,
256             0,
257             liquidity_receiver,
258             block.timestamp);
259     }
260 
261     function swapTokensForETH(uint256 tokenAmount) private {
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = router.WETH();
265         _approve(address(this), address(router), tokenAmount);
266         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             tokenAmount,
268             0,
269             path,
270             address(this),
271             block.timestamp);
272     }
273 
274     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
275         bool aboveMin = amount >= _minTokenAmount;
276         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
277         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(1) && aboveThreshold;
278     }
279 
280     function swapBack(address sender, address recipient, uint256 amount) internal {
281         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
282     }
283 
284     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
285         return !isFeeExempt[sender] && !isFeeExempt[recipient];
286     }
287 
288     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
289         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
290         if(recipient == pair){return sellFee;}
291         if(sender == pair){return totalFee;}
292         return transferFee;
293     }
294 
295     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
296         if(getTotalFee(sender, recipient) > 0){
297         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
298         _balances[address(this)] = _balances[address(this)].add(feeAmount);
299         emit Transfer(sender, address(this), feeAmount);
300         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
301         return amount.sub(feeAmount);} return amount;
302     }
303 
304     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
305         _transfer(sender, recipient, amount);
306         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
307         return true;
308     }
309 
310     function _approve(address owner, address spender, uint256 amount) private {
311         require(owner != address(0), "ERC20: approve from the zero address");
312         require(spender != address(0), "ERC20: approve to the zero address");
313         _allowances[owner][spender] = amount;
314         emit Approval(owner, spender, amount);
315     }
316 
317 }