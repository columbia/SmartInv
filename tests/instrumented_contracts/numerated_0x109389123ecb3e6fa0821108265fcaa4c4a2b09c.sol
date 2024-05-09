1 /**
2 
3 WE ARE ALL RYOSHI 
4 
5 Ryoshi is the person who started the digital currency meme coin called
6 Shiba Inu (SHIB) in the year 2020. After its launch, it gained immense 
7 popularity and became a sensation worldwide. However, Ryoshi has 
8 kept their identity anonymous, and not much information is available 
9 about them.
10 
11 https://ryoshicoin.com/
12 
13 https://t.me/ryoshiercofficial
14 
15 https://twitter.com/ryoshierc
16 
17 */
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity 0.8.16;
22 
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
29     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
30     
31     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
33 
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
36 
37     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
39         if(c / a != b) return(false, 0); return(true, c);}}
40 
41     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
43 
44     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         unchecked{require(b <= a, errorMessage); return a - b;}}
49 
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         unchecked{require(b > 0, errorMessage); return a / b;}}
52 
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         unchecked{require(b > 0, errorMessage); return a % b;}}}
55 
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58     function decimals() external view returns (uint8);
59     function symbol() external view returns (string memory);
60     function name() external view returns (string memory);
61     function getOwner() external view returns (address);
62     function balanceOf(address account) external view returns (uint256);
63     function transfer(address recipient, uint256 amount) external returns (bool);
64     function allowance(address _owner, address spender) external view returns (uint256);
65     function approve(address spender, uint256 amount) external returns (bool);
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);}
69 
70 abstract contract Ownable {
71     address internal owner;
72     constructor(address _owner) {owner = _owner;}
73     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
74     function isOwner(address account) public view returns (bool) {return account == owner;}
75     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
76     event OwnershipTransferred(address owner);
77 }
78 
79 interface IFactory{
80         function createPair(address tokenA, address tokenB) external returns (address pair);
81         function getPair(address tokenA, address tokenB) external view returns (address pair);
82 }
83 
84 interface IRouter {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95 
96     function removeLiquidityWithPermit(
97         address tokenA,
98         address tokenB,
99         uint liquidity,
100         uint amountAMin,
101         uint amountBMin,
102         address to,
103         uint deadline,
104         bool approveMax, uint8 v, bytes32 r, bytes32 s
105     ) external returns (uint amountA, uint amountB);
106 
107     function swapExactETHForTokensSupportingFeeOnTransferTokens(
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external payable;
113 
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline) external;
120 }
121 
122 contract RYOSHI is IERC20, Ownable {
123     using SafeMath for uint256;
124     string private constant _name = 'RYOSHI';
125     string private constant _symbol = 'RYOSHI';
126     uint8 private constant _decimals = 9;
127     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
128     uint256 private _maxTxAmountPercent = 200; // 10000;
129     uint256 private _maxTransferPercent = 200;
130     uint256 private _maxWalletPercent = 300;
131     mapping (address => uint256) _balances;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) public isFeeExempt;
134     mapping (address => bool) private isBot;
135     IRouter router;
136     address public pair;
137     bool private tradingAllowed = false;
138     uint256 private liquidityFee = 0;
139     uint256 private marketingFee = 0;
140     uint256 private developmentFee = 1000;
141     uint256 private burnFee = 0;
142     uint256 private totalFee = 3000;
143     uint256 private sellFee = 6000;
144     uint256 private transferFee = 6000;
145     uint256 private denominator = 10000;
146     bool private swapEnabled = true;
147     uint256 private swapTimes;
148     bool private swapping;
149     uint256 swapAmount = 3;
150     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
151     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
152     modifier lockTheSwap {swapping = true; _; swapping = false;}
153 
154     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
155     address internal constant development_receiver = 0xA34D59336200FD6FFF094e4D52022fc0847b8905; 
156     address internal constant marketing_receiver = 0xA34D59336200FD6FFF094e4D52022fc0847b8905;
157     address internal constant liquidity_receiver = 0xA34D59336200FD6FFF094e4D52022fc0847b8905;
158 
159     constructor() Ownable(msg.sender) {
160         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
161         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
162         router = _router;
163         pair = _pair;
164         isFeeExempt[address(this)] = true;
165         isFeeExempt[liquidity_receiver] = true;
166         isFeeExempt[marketing_receiver] = true;
167         isFeeExempt[msg.sender] = true;
168         _balances[msg.sender] = _totalSupply;
169         emit Transfer(address(0), msg.sender, _totalSupply);
170     }
171 
172     receive() external payable {}
173     function name() public pure returns (string memory) {return _name;}
174     function symbol() public pure returns (string memory) {return _symbol;}
175     function decimals() public pure returns (uint8) {return _decimals;}
176     function startTrading() external onlyOwner {tradingAllowed = true;}
177     function getOwner() external view override returns (address) { return owner; }
178     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
179     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
180     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
181     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
182     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
183     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
184     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
185     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
186     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
187     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
188     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
189 
190     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
191         require(sender != address(0), "ERC20: transfer from the zero address");
192         require(recipient != address(0), "ERC20: transfer to the zero address");
193         require(amount > uint256(0), "Transfer amount must be greater than zero");
194         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
195     }
196 
197     function _transfer(address sender, address recipient, uint256 amount) private {
198         preTxCheck(sender, recipient, amount);
199         checkTradingAllowed(sender, recipient);
200         checkMaxWallet(sender, recipient, amount); 
201         swapbackCounters(sender, recipient);
202         checkTxLimit(sender, recipient, amount); 
203         swapBack(sender, recipient, amount);
204         _balances[sender] = _balances[sender].sub(amount);
205         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
206         _balances[recipient] = _balances[recipient].add(amountReceived);
207         emit Transfer(sender, recipient, amountReceived);
208     }
209 
210     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
211         liquidityFee = _liquidity;
212         marketingFee = _marketing;
213         burnFee = _burn;
214         developmentFee = _development;
215         totalFee = _total;
216         sellFee = _sell;
217         transferFee = _trans;
218         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
219     }
220 
221     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
222         uint256 newTx = (totalSupply() * _buy) / 10000;
223         uint256 newTransfer = (totalSupply() * _trans) / 10000;
224         uint256 newWallet = (totalSupply() * _wallet) / 10000;
225         _maxTxAmountPercent = _buy;
226         _maxTransferPercent = _trans;
227         _maxWalletPercent = _wallet;
228         uint256 limit = totalSupply().mul(5).div(1000);
229         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
230     }
231 
232     function checkTradingAllowed(address sender, address recipient) internal view {
233         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
234     }
235     
236     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
237         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
238             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
239     }
240 
241     function swapbackCounters(address sender, address recipient) internal {
242         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
243     }
244 
245     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
246         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
247         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
248     }
249 
250     function swapAndLiquify(uint256 tokens) private lockTheSwap {
251         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
252         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
253         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
254         uint256 initialBalance = address(this).balance;
255         swapTokensForETH(toSwap);
256         uint256 deltaBalance = address(this).balance.sub(initialBalance);
257         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
258         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
259         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
260         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
261         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
262         uint256 remainingBalance = address(this).balance;
263         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
264     }
265 
266     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
267         _approve(address(this), address(router), tokenAmount);
268         router.addLiquidityETH{value: ETHAmount}(
269             address(this),
270             tokenAmount,
271             0,
272             0,
273             liquidity_receiver,
274             block.timestamp);
275     }
276 
277     function swapTokensForETH(uint256 tokenAmount) private {
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = router.WETH();
281         _approve(address(this), address(router), tokenAmount);
282         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp);
288     }
289 
290     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
291         bool aboveMin = amount >= minTokenAmount;
292         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
293         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
294     }
295 
296     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
297         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
298         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
299     }
300 
301     function swapBack(address sender, address recipient, uint256 amount) internal {
302         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
303     }
304 
305     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
306         return !isFeeExempt[sender] && !isFeeExempt[recipient];
307     }
308 
309     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
310         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
311         if(recipient == pair){return sellFee;}
312         if(sender == pair){return totalFee;}
313         return transferFee;
314     }
315 
316     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
317         if(getTotalFee(sender, recipient) > 0){
318         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
319         _balances[address(this)] = _balances[address(this)].add(feeAmount);
320         emit Transfer(sender, address(this), feeAmount);
321         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
322         return amount.sub(feeAmount);} return amount;
323     }
324 
325     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
326         _transfer(sender, recipient, amount);
327         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
328         return true;
329     }
330 
331     function _approve(address owner, address spender, uint256 amount) private {
332         require(owner != address(0), "ERC20: approve from the zero address");
333         require(spender != address(0), "ERC20: approve to the zero address");
334         _allowances[owner][spender] = amount;
335         emit Approval(owner, spender, amount);
336     }
337 
338 }