1 /**
2 
3 SELF MADE - $HUSTLE
4 
5 SELF MADE $HUSTLE is the opposite of Generational Wealth, it’s for 
6 individuals whose upbringing is not from a rich family, but are 
7 striving and putting up work to be one of the new SELF-MADE new 
8 millionaires/ Billionaires.
9 
10 https://selfmadecoin.org/
11 
12 https://twitter.com/selfmadecoin
13 
14 https://t.me/selfmadecoin
15 
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity 0.8.16;
21 
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
28     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
29     
30     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
32 
33     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
35 
36     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
38         if(c / a != b) return(false, 0); return(true, c);}}
39 
40     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
42 
43     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         unchecked{require(b <= a, errorMessage); return a - b;}}
48 
49     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         unchecked{require(b > 0, errorMessage); return a / b;}}
51 
52     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         unchecked{require(b > 0, errorMessage); return a % b;}}}
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57     function decimals() external view returns (uint8);
58     function symbol() external view returns (string memory);
59     function name() external view returns (string memory);
60     function getOwner() external view returns (address);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address _owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);}
68 
69 abstract contract Ownable {
70     address internal owner;
71     constructor(address _owner) {owner = _owner;}
72     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
73     function isOwner(address account) public view returns (bool) {return account == owner;}
74     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
75     event OwnershipTransferred(address owner);
76 }
77 
78 interface IFactory{
79         function createPair(address tokenA, address tokenB) external returns (address pair);
80         function getPair(address tokenA, address tokenB) external view returns (address pair);
81 }
82 
83 interface IRouter {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86     function addLiquidityETH(
87         address token,
88         uint amountTokenDesired,
89         uint amountTokenMin,
90         uint amountETHMin,
91         address to,
92         uint deadline
93     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
94 
95     function removeLiquidityWithPermit(
96         address tokenA,
97         address tokenB,
98         uint liquidity,
99         uint amountAMin,
100         uint amountBMin,
101         address to,
102         uint deadline,
103         bool approveMax, uint8 v, bytes32 r, bytes32 s
104     ) external returns (uint amountA, uint amountB);
105 
106     function swapExactETHForTokensSupportingFeeOnTransferTokens(
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external payable;
112 
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline) external;
119 }
120 
121 contract SELFMADE is IERC20, Ownable {
122     using SafeMath for uint256;
123     string private constant _name = 'SELF MADE';
124     string private constant _symbol = 'HUSTLE';
125     uint8 private constant _decimals = 9;
126     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
127     uint256 private _maxTxAmountPercent = 200; // 10000;
128     uint256 private _maxTransferPercent = 200;
129     uint256 private _maxWalletPercent = 300;
130     mapping (address => uint256) _balances;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) public isFeeExempt;
133     mapping (address => bool) private isBot;
134     IRouter router;
135     address public pair;
136     bool private tradingAllowed = false;
137     uint256 private liquidityFee = 0;
138     uint256 private marketingFee = 0;
139     uint256 private developmentFee = 1000;
140     uint256 private burnFee = 0;
141     uint256 private totalFee = 2500;
142     uint256 private sellFee = 6000;
143     uint256 private transferFee = 6000;
144     uint256 private denominator = 10000;
145     bool private swapEnabled = true;
146     uint256 private swapTimes;
147     bool private swapping;
148     uint256 swapAmount = 4;
149     uint256 private swapThreshold = ( _totalSupply * 2000 ) / 100000;
150     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
151     modifier lockTheSwap {swapping = true; _; swapping = false;}
152 
153     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
154     address internal constant development_receiver = 0x2afE2bBbdcC96EaaD0a60766f3f71c1D501a5125; 
155     address internal constant marketing_receiver = 0x2afE2bBbdcC96EaaD0a60766f3f71c1D501a5125;
156     address internal constant liquidity_receiver = 0x2afE2bBbdcC96EaaD0a60766f3f71c1D501a5125;
157 
158     constructor() Ownable(msg.sender) {
159         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
160         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
161         router = _router;
162         pair = _pair;
163         isFeeExempt[address(this)] = true;
164         isFeeExempt[liquidity_receiver] = true;
165         isFeeExempt[marketing_receiver] = true;
166         isFeeExempt[msg.sender] = true;
167         _balances[msg.sender] = _totalSupply;
168         emit Transfer(address(0), msg.sender, _totalSupply);
169     }
170 
171     receive() external payable {}
172     function name() public pure returns (string memory) {return _name;}
173     function symbol() public pure returns (string memory) {return _symbol;}
174     function decimals() public pure returns (uint8) {return _decimals;}
175     function startTrading() external onlyOwner {tradingAllowed = true;}
176     function getOwner() external view override returns (address) { return owner; }
177     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
178     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
179     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
180     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
181     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
182     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
183     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
184     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
185     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
186     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
187     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
188 
189     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
190         require(sender != address(0), "ERC20: transfer from the zero address");
191         require(recipient != address(0), "ERC20: transfer to the zero address");
192         require(amount > uint256(0), "Transfer amount must be greater than zero");
193         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
194     }
195 
196     function _transfer(address sender, address recipient, uint256 amount) private {
197         preTxCheck(sender, recipient, amount);
198         checkTradingAllowed(sender, recipient);
199         checkMaxWallet(sender, recipient, amount); 
200         swapbackCounters(sender, recipient);
201         checkTxLimit(sender, recipient, amount); 
202         swapBack(sender, recipient, amount);
203         _balances[sender] = _balances[sender].sub(amount);
204         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
205         _balances[recipient] = _balances[recipient].add(amountReceived);
206         emit Transfer(sender, recipient, amountReceived);
207     }
208 
209     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
210         liquidityFee = _liquidity;
211         marketingFee = _marketing;
212         burnFee = _burn;
213         developmentFee = _development;
214         totalFee = _total;
215         sellFee = _sell;
216         transferFee = _trans;
217         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
218     }
219 
220     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
221         uint256 newTx = (totalSupply() * _buy) / 10000;
222         uint256 newTransfer = (totalSupply() * _trans) / 10000;
223         uint256 newWallet = (totalSupply() * _wallet) / 10000;
224         _maxTxAmountPercent = _buy;
225         _maxTransferPercent = _trans;
226         _maxWalletPercent = _wallet;
227         uint256 limit = totalSupply().mul(5).div(1000);
228         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
229     }
230 
231     function checkTradingAllowed(address sender, address recipient) internal view {
232         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
233     }
234     
235     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
236         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
237             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
238     }
239 
240     function swapbackCounters(address sender, address recipient) internal {
241         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
242     }
243 
244     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
245         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
246         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
247     }
248 
249     function swapAndLiquify(uint256 tokens) private lockTheSwap {
250         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
251         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
252         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
253         uint256 initialBalance = address(this).balance;
254         swapTokensForETH(toSwap);
255         uint256 deltaBalance = address(this).balance.sub(initialBalance);
256         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
257         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
258         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
259         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
260         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
261         uint256 remainingBalance = address(this).balance;
262         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
263     }
264 
265     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
266         _approve(address(this), address(router), tokenAmount);
267         router.addLiquidityETH{value: ETHAmount}(
268             address(this),
269             tokenAmount,
270             0,
271             0,
272             liquidity_receiver,
273             block.timestamp);
274     }
275 
276     function swapTokensForETH(uint256 tokenAmount) private {
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = router.WETH();
280         _approve(address(this), address(router), tokenAmount);
281         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp);
287     }
288 
289     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
290         bool aboveMin = amount >= minTokenAmount;
291         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
292         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
293     }
294 
295     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
296         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
297         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
298     }
299 
300     function swapBack(address sender, address recipient, uint256 amount) internal {
301         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
302     }
303 
304     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
305         return !isFeeExempt[sender] && !isFeeExempt[recipient];
306     }
307 
308     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
309         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
310         if(recipient == pair){return sellFee;}
311         if(sender == pair){return totalFee;}
312         return transferFee;
313     }
314 
315     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
316         if(getTotalFee(sender, recipient) > 0){
317         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
318         _balances[address(this)] = _balances[address(this)].add(feeAmount);
319         emit Transfer(sender, address(this), feeAmount);
320         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
321         return amount.sub(feeAmount);} return amount;
322     }
323 
324     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
325         _transfer(sender, recipient, amount);
326         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
327         return true;
328     }
329 
330     function _approve(address owner, address spender, uint256 amount) private {
331         require(owner != address(0), "ERC20: approve from the zero address");
332         require(spender != address(0), "ERC20: approve to the zero address");
333         _allowances[owner][spender] = amount;
334         emit Approval(owner, spender, amount);
335     }
336 
337 }