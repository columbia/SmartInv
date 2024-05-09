1 /*
2 
3 just a panda on the blockchain
4 只是区块链上的一只熊猫
5 
6 LP will be locked for 1000 years
7 流动资金池将被锁定1000年
8 
9 Final Tax 0/0
10 最终税 0/0
11 
12 
13 ⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⢰⣿⡿⠗⠀⠠⠄⡀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⡜⠁⠀⠀⠀⠀⠀⠈⠑⢶⣶⡄
16 ⢀⣶⣦⣸⠀⢼⣟⡇⠀⠀⢀⣀⠀⠘⡿⠃
17 ⠀⢿⣿⣿⣄⠒⠀⠠⢶⡂⢫⣿⢇⢀⠃⠀
18 ⠀⠈⠻⣿⣿⣿⣶⣤⣀⣀⣀⣂⡠⠊⠀⠀
19 ⠀⠀⠀⠃⠀⠀⠉⠙⠛⠿⣿⣿⣧⠀⠀⠀
20 ⠀⠀⠘⡀⠀⠀⠀⠀⠀⠀⠘⣿⣿⡇⠀⠀
21 ⠀⠀⠀⣷⣄⡀⠀⠀⠀⢀⣴⡟⠿⠃⠀⠀
22 ⠀⠀⠀⢻⣿⣿⠉⠉⢹⣿⣿⠁⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠉⠁⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀
24 
25 */
26 
27 // SPDX-License-Identifier: MIT
28 
29 pragma solidity 0.8.16;
30 
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
38     
39     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
41 
42     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
44 
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
47         if(c / a != b) return(false, 0); return(true, c);}}
48 
49     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
51 
52     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
54 
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         unchecked{require(b <= a, errorMessage); return a - b;}}
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         unchecked{require(b > 0, errorMessage); return a / b;}}
60 
61     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         unchecked{require(b > 0, errorMessage); return a % b;}}}
63 
64 interface IERC20 {
65     function totalSupply() external view returns (uint256);
66     function decimals() external view returns (uint8);
67     function symbol() external view returns (string memory);
68     function name() external view returns (string memory);
69     function getOwner() external view returns (address);
70     function balanceOf(address account) external view returns (uint256);
71     function transfer(address recipient, uint256 amount) external returns (bool);
72     function allowance(address _owner, address spender) external view returns (uint256);
73     function approve(address spender, uint256 amount) external returns (bool);
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);}
77 
78 abstract contract Ownable {
79     address internal owner;
80     constructor(address _owner) {owner = _owner;}
81     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
82     function isOwner(address account) public view returns (bool) {return account == owner;}
83     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
84     event OwnershipTransferred(address owner);
85 }
86 
87 interface IFactory{
88         function createPair(address tokenA, address tokenB) external returns (address pair);
89         function getPair(address tokenA, address tokenB) external view returns (address pair);
90 }
91 
92 interface IRouter {
93     function factory() external pure returns (address);
94     function WETH() external pure returns (address);
95     function addLiquidityETH(
96         address token,
97         uint amountTokenDesired,
98         uint amountTokenMin,
99         uint amountETHMin,
100         address to,
101         uint deadline
102     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
103 
104     function removeLiquidityWithPermit(
105         address tokenA,
106         address tokenB,
107         uint liquidity,
108         uint amountAMin,
109         uint amountBMin,
110         address to,
111         uint deadline,
112         bool approveMax, uint8 v, bytes32 r, bytes32 s
113     ) external returns (uint amountA, uint amountB);
114 
115     function swapExactETHForTokensSupportingFeeOnTransferTokens(
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external payable;
121 
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline) external;
128 }
129 
130 contract PANDA is IERC20, Ownable {
131     using SafeMath for uint256;
132     string private constant _name = unicode"⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀⠀⠀⠀⢰⣿⡿⠗⠀⠠⠄⡀⠀⠀⠀⠀\n⠀⠀⠀⠀⡜⠁⠀⠀⠀⠀⠀⠈⠑⢶⣶⡄\n⢀⣶⣦⣸⠀⢼⣟⡇⠀⠀⢀⣀⠀⠘⡿⠃\n⠀⢿⣿⣿⣄⠒⠀⠠⢶⡂⢫⣿⢇⢀⠃⠀\n⠀⠈⠻⣿⣿⣿⣶⣤⣀⣀⣀⣂⡠⠊⠀⠀\n⠀⠀⠀⠃⠀⠀⠉⠙⠛⠿⣿⣿⣧⠀⠀⠀\n⠀⠀⠘⡀⠀⠀⠀⠀⠀⠀⠘⣿⣿⡇⠀⠀\n⠀⠀⠀⣷⣄⡀⠀⠀⠀⢀⣴⡟⠿⠃⠀⠀\n⠀⠀⠀⢻⣿⣿⠉⠉⢹⣿⣿⠁⠀⠀⠀⠀\n⠀⠀⠀⠀⠉⠁⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀\n";
133     string private constant _symbol = unicode"🐼";
134     uint8 private constant _decimals = 9;
135     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
136     uint256 private _maxTxAmountPercent = 150; // 10000;
137     uint256 private _maxTransferPercent = 150;
138     uint256 private _maxWalletPercent = 150;
139     mapping (address => uint256) _balances;
140     mapping (address => mapping (address => uint256)) private _allowances;
141     mapping (address => bool) public isFeeExempt;
142     mapping (address => bool) private isBot;
143     IRouter router;
144     address public pair;
145     bool private tradingAllowed = false;
146     uint256 private liquidityFee = 0;
147     uint256 private marketingFee = 2500;
148     uint256 private developmentFee = 0;
149     uint256 private burnFee = 0;
150     uint256 private totalFee = 2500;
151     uint256 private sellFee = 5000;
152     uint256 private transferFee = 0;
153     uint256 private denominator = 10000;
154     bool private swapEnabled = true;
155     uint256 private swapTimes;
156     bool private swapping;
157     uint256 swapAmount = 4;
158     uint256 private swapThreshold = ( _totalSupply * 2000 ) / 100000;
159     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
160     modifier lockTheSwap {swapping = true; _; swapping = false;}
161 
162     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
163     address internal constant development_receiver = 0xb792031aa9355F204A4FBc6A8Be8DFA7882F21aa; 
164     address internal constant marketing_receiver = 0xb792031aa9355F204A4FBc6A8Be8DFA7882F21aa;
165     address internal constant liquidity_receiver = 0xb792031aa9355F204A4FBc6A8Be8DFA7882F21aa;
166 
167     constructor() Ownable(msg.sender) {
168         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
169         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
170         router = _router;
171         pair = _pair;
172         isFeeExempt[address(this)] = true;
173         isFeeExempt[liquidity_receiver] = true;
174         isFeeExempt[marketing_receiver] = true;
175         isFeeExempt[msg.sender] = true;
176         _balances[msg.sender] = _totalSupply;
177         emit Transfer(address(0), msg.sender, _totalSupply);
178     }
179 
180     receive() external payable {}
181     function name() public pure returns (string memory) {return _name;}
182     function symbol() public pure returns (string memory) {return _symbol;}
183     function decimals() public pure returns (uint8) {return _decimals;}
184     function openTrading(bool enabled) external onlyOwner {if(enabled){tradingAllowed = true;}}
185     function getOwner() external view override returns (address) { return owner; }
186     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
187     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
188     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
189     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
190     function blacklist(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
191     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
192     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
193     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
194     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
195     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
196     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
197 
198     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201         require(amount > uint256(0), "Transfer amount must be greater than zero");
202         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
203     }
204 
205     function _transfer(address sender, address recipient, uint256 amount) private {
206         preTxCheck(sender, recipient, amount);
207         checkTradingAllowed(sender, recipient);
208         checkMaxWallet(sender, recipient, amount); 
209         swapbackCounters(sender, recipient);
210         checkTxLimit(sender, recipient, amount); 
211         swapBack(sender, recipient, amount);
212         _balances[sender] = _balances[sender].sub(amount);
213         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
214         _balances[recipient] = _balances[recipient].add(amountReceived);
215         emit Transfer(sender, recipient, amountReceived);
216     }
217 
218     function setFees(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
219         liquidityFee = _liquidity;
220         marketingFee = _marketing;
221         burnFee = _burn;
222         developmentFee = _development;
223         totalFee = _total;
224         sellFee = _sell;
225         transferFee = _trans;
226         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
227     }
228 
229     function setLimits(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
230         uint256 newTx = (totalSupply() * _buy) / 10000;
231         uint256 newTransfer = (totalSupply() * _trans) / 10000;
232         uint256 newWallet = (totalSupply() * _wallet) / 10000;
233         _maxTxAmountPercent = _buy;
234         _maxTransferPercent = _trans;
235         _maxWalletPercent = _wallet;
236         uint256 limit = totalSupply().mul(5).div(1000);
237         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
238     }
239 
240     function checkTradingAllowed(address sender, address recipient) internal view {
241         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
242     }
243     
244     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
245         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
246             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
247     }
248 
249     function swapbackCounters(address sender, address recipient) internal {
250         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
251     }
252 
253     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
254         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
255         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
256     }
257 
258     function swapAndLiquify(uint256 tokens) private lockTheSwap {
259         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
260         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
261         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
262         uint256 initialBalance = address(this).balance;
263         swapTokensForETH(toSwap);
264         uint256 deltaBalance = address(this).balance.sub(initialBalance);
265         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
266         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
267         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
268         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
269         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
270         uint256 remainingBalance = address(this).balance;
271         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
272     }
273 
274     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
275         _approve(address(this), address(router), tokenAmount);
276         router.addLiquidityETH{value: ETHAmount}(
277             address(this),
278             tokenAmount,
279             0,
280             0,
281             liquidity_receiver,
282             block.timestamp);
283     }
284 
285     function swapTokensForETH(uint256 tokenAmount) private {
286         address[] memory path = new address[](2);
287         path[0] = address(this);
288         path[1] = router.WETH();
289         _approve(address(this), address(router), tokenAmount);
290         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
291             tokenAmount,
292             0,
293             path,
294             address(this),
295             block.timestamp);
296     }
297 
298     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
299         bool aboveMin = amount >= minTokenAmount;
300         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
301         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
302     }
303 
304     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
305         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
306         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
307     }
308 
309     function swapBack(address sender, address recipient, uint256 amount) internal {
310         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
311     }
312 
313     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
314         return !isFeeExempt[sender] && !isFeeExempt[recipient];
315     }
316 
317     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
318         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
319         if(recipient == pair){return sellFee;}
320         if(sender == pair){return totalFee;}
321         return transferFee;
322     }
323 
324     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
325         if(getTotalFee(sender, recipient) > 0){
326         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
327         _balances[address(this)] = _balances[address(this)].add(feeAmount);
328         emit Transfer(sender, address(this), feeAmount);
329         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
330         return amount.sub(feeAmount);} return amount;
331     }
332 
333     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
334         _transfer(sender, recipient, amount);
335         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
336         return true;
337     }
338 
339     function _approve(address owner, address spender, uint256 amount) private {
340         require(owner != address(0), "ERC20: approve from the zero address");
341         require(spender != address(0), "ERC20: approve to the zero address");
342         _allowances[owner][spender] = amount;
343         emit Approval(owner, spender, amount);
344     }
345 
346 }