1 /**
2  Telegram: https://t.me/HuTuTu_ERC
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
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
43     function circulatingSupply() external view returns (uint256);
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
108 contract Tutu is IERC20, Ownable {
109     using SafeMath for uint256;
110     string private constant _name = 'Big Ear Tutu';
111     string private constant _symbol = 'HU TUTU';
112     uint8 private constant _decimals = 9;
113     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
114     uint256 private _maxTxAmountPercent = 10000; // 10000;
115     uint256 private _maxTransferPercent = 10000;
116     uint256 private _maxWalletPercent = 200;
117     mapping (address => uint256) _balances;
118     mapping (address => mapping (address => uint256)) private _allowances;
119     mapping (address => bool) public isFeeExempt;
120     mapping (address => bool) private isBot;
121     IRouter router;
122     address public pair;
123     bool private tradingAllowed = true;
124     uint256 private liquidityFee = 0;
125     uint256 private marketingFee = 200;
126     uint256 private developmentFee = 200;
127     uint256 private burnFee = 0;
128     uint256 private totalFee = 2000;
129     uint256 private sellFee = 5000;
130     uint256 private transferFee = 2000;
131     uint256 private denominator = 10000;
132     bool private swapEnabled = true;
133     uint256 private swapTimes;
134     bool private swapping; 
135     uint256 private swapThreshold = ( _totalSupply * 2000 ) / 100000;
136     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
137     modifier lockTheSwap {swapping = true; _; swapping = false;}
138 
139     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
140     address internal constant development_receiver = 0x89EE52D8616C0c3dca0C23C5f5d9542C9367811E; 
141     address internal constant marketing_receiver = 0x89EE52D8616C0c3dca0C23C5f5d9542C9367811E;
142     address internal constant liquidity_receiver = 0x89EE52D8616C0c3dca0C23C5f5d9542C9367811E;
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
161     function Trading() external onlyOwner {tradingAllowed = true;}
162     function getOwner() external view override returns (address) { return owner; }
163     function totalSupply() public view override returns (uint256) {return _totalSupply;}
164     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
165     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
166     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
167     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
168     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
169     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
170     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
171     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
172     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
173     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
174     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
175 
176     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
177         require(sender != address(0), "ERC20: transfer from the zero address");
178         require(recipient != address(0), "ERC20: transfer to the zero address");
179         require(amount > uint256(0), "Transfer amount must be greater than zero");
180         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
181     }
182 
183     function _transfer(address sender, address recipient, uint256 amount) private {
184         preTxCheck(sender, recipient, amount);
185         checkTradingAllowed(sender, recipient);
186         checkMaxWallet(sender, recipient, amount); 
187         swapbackCounters(sender, recipient);
188         checkTxLimit(sender, recipient, amount); 
189         swapBack(sender, recipient, amount);
190         _balances[sender] = _balances[sender].sub(amount);
191         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
192         _balances[recipient] = _balances[recipient].add(amountReceived);
193         emit Transfer(sender, recipient, amountReceived);
194     }
195 
196     function Fee(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
197         liquidityFee = _liquidity;
198         marketingFee = _marketing;
199         burnFee = _burn;
200         developmentFee = _development;
201         totalFee = _total;
202         sellFee = _sell;
203         transferFee = _trans;
204         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 100%");
205     }
206 
207     function Wallet(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
208         uint256 newTx = (totalSupply() * _buy) / 10000;
209         uint256 newTransfer = (totalSupply() * _trans) / 10000;
210         uint256 newWallet = (totalSupply() * _wallet) / 10000;
211         _maxTxAmountPercent = _buy;
212         _maxTransferPercent = _trans;
213         _maxWalletPercent = _wallet;
214         uint256 limit = totalSupply().mul(5).div(1000);
215         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
216     }
217 
218     function checkTradingAllowed(address sender, address recipient) internal view {
219         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
220     }
221     
222     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
223         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
224             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
225     }
226 
227     function swapbackCounters(address sender, address recipient) internal {
228         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
229     }
230 
231     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
232         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
233         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
234     }
235 
236     function swapAndLiquify(uint256 tokens) private lockTheSwap {
237         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
238         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
239         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
240         uint256 initialBalance = address(this).balance;
241         swapTokensForETH(toSwap);
242         uint256 deltaBalance = address(this).balance.sub(initialBalance);
243         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
244         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
245         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
246         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
247         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
248         uint256 remainingBalance = address(this).balance;
249         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
250     }
251 
252     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
253         _approve(address(this), address(router), tokenAmount);
254         router.addLiquidityETH{value: ETHAmount}(
255             address(this),
256             tokenAmount,
257             0,
258             0,
259             liquidity_receiver,
260             block.timestamp);
261     }
262 
263     function swapTokensForETH(uint256 tokenAmount) private {
264         address[] memory path = new address[](2);
265         path[0] = address(this);
266         path[1] = router.WETH();
267         _approve(address(this), address(router), tokenAmount);
268         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
269             tokenAmount,
270             0,
271             path,
272             address(this),
273             block.timestamp);
274     }
275 
276     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
277         bool aboveMin = amount >= _minTokenAmount;
278         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
279         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(0) && aboveThreshold;
280     }
281 
282     function swapBack(address sender, address recipient, uint256 amount) internal {
283         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
284     }
285 
286     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
287         return !isFeeExempt[sender] && !isFeeExempt[recipient];
288     }
289 
290     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
291         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
292         if(recipient == pair){return sellFee;}
293         if(sender == pair){return totalFee;}
294         return transferFee;
295     }
296 
297     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
298         if(getTotalFee(sender, recipient) > 0){
299         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
300         _balances[address(this)] = _balances[address(this)].add(feeAmount);
301         emit Transfer(sender, address(this), feeAmount);
302         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
303         return amount.sub(feeAmount);} return amount;
304     }
305 
306     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
309         return true;
310     }
311 
312     function _approve(address owner, address spender, uint256 amount) private {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315         _allowances[owner][spender] = amount;
316         emit Approval(owner, spender, amount);
317     }
318 
319 }