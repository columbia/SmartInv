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
104 contract X is IERC20, Ownable {
105     using SafeMath for uint256;
106     string private constant _name = 'AI-X';
107     string private constant _symbol = 'X';
108     uint8 private constant _decimals = 9;
109     uint256 private _totalSupply = 10000000000000000 * (10 ** _decimals);
110     uint256 private _maxTxAmountPercent = 200; // 10000;
111     uint256 private _maxTransferPercent = 200;
112     uint256 private _maxWalletPercent = 300;
113     mapping (address => uint256) _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) public isFeeExempt;
116     mapping (address => bool) private isBot;
117     IRouter router;
118     address public pair;
119     bool private tradingAllowed = false;
120     uint256 private liquidityFee = 0;
121     uint256 private marketingFee = 0;
122     uint256 private developmentFee = 1000;
123     uint256 private burnFee = 0;
124     uint256 private totalFee = 3000;
125     uint256 private sellFee = 5000;
126     uint256 private transferFee = 9900;
127     uint256 private denominator = 10000;
128     bool private swapEnabled = true;
129     uint256 private swapTimes;
130     bool private swapping;
131     uint256 swapAmount = 3;
132     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
133     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
134     modifier lockTheSwap {swapping = true; _; swapping = false;}
135 
136     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
137     address internal constant development_receiver = 0xC36533602887443e665B47ec64085F49df7a452f; 
138     address internal constant marketing_receiver = 0xC36533602887443e665B47ec64085F49df7a452f;
139     address internal constant liquidity_receiver = 0xC36533602887443e665B47ec64085F49df7a452f;
140 
141     constructor() Ownable(msg.sender) {
142         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
143         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
144         router = _router;
145         pair = _pair;
146         isFeeExempt[address(this)] = true;
147         isFeeExempt[liquidity_receiver] = true;
148         isFeeExempt[marketing_receiver] = true;
149         isFeeExempt[msg.sender] = true;
150         _balances[msg.sender] = _totalSupply;
151         emit Transfer(address(0), msg.sender, _totalSupply);
152     }
153 
154     receive() external payable {}
155     function name() public pure returns (string memory) {return _name;}
156     function symbol() public pure returns (string memory) {return _symbol;}
157     function decimals() public pure returns (uint8) {return _decimals;}
158     function startTrading() external onlyOwner {tradingAllowed = true;}
159     function getOwner() external view override returns (address) { return owner; }
160     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
161     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
162     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
163     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
164     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
165     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
166     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
167     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
168     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
169     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
170     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
171 
172     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
173         require(sender != address(0), "ERC20: transfer from the zero address");
174         require(recipient != address(0), "ERC20: transfer to the zero address");
175         require(amount > uint256(0), "Transfer amount must be greater than zero");
176         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
177     }
178 
179     function _transfer(address sender, address recipient, uint256 amount) private {
180         preTxCheck(sender, recipient, amount);
181         checkTradingAllowed(sender, recipient);
182         checkMaxWallet(sender, recipient, amount); 
183         swapbackCounters(sender, recipient);
184         checkTxLimit(sender, recipient, amount); 
185         swapBack(sender, recipient, amount);
186         _balances[sender] = _balances[sender].sub(amount);
187         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
188         _balances[recipient] = _balances[recipient].add(amountReceived);
189         emit Transfer(sender, recipient, amountReceived);
190     }
191 
192     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
193         liquidityFee = _liquidity;
194         marketingFee = _marketing;
195         burnFee = _burn;
196         developmentFee = _development;
197         totalFee = _total;
198         sellFee = _sell;
199         transferFee = _trans;
200         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
201     }
202 
203     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
204         uint256 newTx = (totalSupply() * _buy) / 10000;
205         uint256 newTransfer = (totalSupply() * _trans) / 10000;
206         uint256 newWallet = (totalSupply() * _wallet) / 10000;
207         _maxTxAmountPercent = _buy;
208         _maxTransferPercent = _trans;
209         _maxWalletPercent = _wallet;
210         uint256 limit = totalSupply().mul(5).div(1000);
211         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
212     }
213 
214     function checkTradingAllowed(address sender, address recipient) internal view {
215         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
216     }
217     
218     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
219         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
220             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
221     }
222 
223     function swapbackCounters(address sender, address recipient) internal {
224         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
225     }
226 
227     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
228         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
229         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
230     }
231 
232     function swapAndLiquify(uint256 tokens) private lockTheSwap {
233         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
234         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
235         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
236         uint256 initialBalance = address(this).balance;
237         swapTokensForETH(toSwap);
238         uint256 deltaBalance = address(this).balance.sub(initialBalance);
239         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
240         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
241         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
242         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
243         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
244         uint256 remainingBalance = address(this).balance;
245         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
246     }
247 
248     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
249         _approve(address(this), address(router), tokenAmount);
250         router.addLiquidityETH{value: ETHAmount}(
251             address(this),
252             tokenAmount,
253             0,
254             0,
255             liquidity_receiver,
256             block.timestamp);
257     }
258 
259     function swapTokensForETH(uint256 tokenAmount) private {
260         address[] memory path = new address[](2);
261         path[0] = address(this);
262         path[1] = router.WETH();
263         _approve(address(this), address(router), tokenAmount);
264         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
265             tokenAmount,
266             0,
267             path,
268             address(this),
269             block.timestamp);
270     }
271 
272     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
273         bool aboveMin = amount >= minTokenAmount;
274         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
275         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
276     }
277 
278     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
279         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
280         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
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