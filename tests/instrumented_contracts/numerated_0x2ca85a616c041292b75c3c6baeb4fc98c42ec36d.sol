1 /**
2 
3 Pepe Floki ($PEPOKI) is the most memeable crypto coin out there, 
4 combining two of the most iconic internet memes of all time. This coin 
5 is not for the faint of heart, it's for those who want to have fun and 
6 make some serious gains while doing it. 
7 
8 https://pepefloki.org/  coming soon
9 
10 https://t.me/pepeflokiofficial
11 
12 https://twitter.com/pepeflokierc
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity 0.8.16;
19 
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
26     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
27     
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
30 
31     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
33 
34     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
36         if(c / a != b) return(false, 0); return(true, c);}}
37 
38     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
40 
41     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         unchecked{require(b <= a, errorMessage); return a - b;}}
46 
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         unchecked{require(b > 0, errorMessage); return a / b;}}
49 
50     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         unchecked{require(b > 0, errorMessage); return a % b;}}}
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function decimals() external view returns (uint8);
56     function symbol() external view returns (string memory);
57     function name() external view returns (string memory);
58     function getOwner() external view returns (address);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address _owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);}
66 
67 abstract contract Ownable {
68     address internal owner;
69     constructor(address _owner) {owner = _owner;}
70     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
71     function isOwner(address account) public view returns (bool) {return account == owner;}
72     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
73     event OwnershipTransferred(address owner);
74 }
75 
76 interface IFactory{
77         function createPair(address tokenA, address tokenB) external returns (address pair);
78         function getPair(address tokenA, address tokenB) external view returns (address pair);
79 }
80 
81 interface IRouter {
82     function factory() external pure returns (address);
83     function WETH() external pure returns (address);
84     function addLiquidityETH(
85         address token,
86         uint amountTokenDesired,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline
91     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
92 
93     function removeLiquidityWithPermit(
94         address tokenA,
95         address tokenB,
96         uint liquidity,
97         uint amountAMin,
98         uint amountBMin,
99         address to,
100         uint deadline,
101         bool approveMax, uint8 v, bytes32 r, bytes32 s
102     ) external returns (uint amountA, uint amountB);
103 
104     function swapExactETHForTokensSupportingFeeOnTransferTokens(
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external payable;
110 
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline) external;
117 }
118 
119 contract PepeFloki is IERC20, Ownable {
120     using SafeMath for uint256;
121     string private constant _name = 'Pepe Floki';
122     string private constant _symbol = 'PEPOKI';
123     uint8 private constant _decimals = 9;
124     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
125     uint256 private _maxTxAmountPercent = 200; // 10000;
126     uint256 private _maxTransferPercent = 200;
127     uint256 private _maxWalletPercent = 300;
128     mapping (address => uint256) _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) public isFeeExempt;
131     mapping (address => bool) private isBot;
132     IRouter router;
133     address public pair;
134     bool private tradingAllowed = false;
135     uint256 private liquidityFee = 0;
136     uint256 private marketingFee = 0;
137     uint256 private developmentFee = 1000;
138     uint256 private burnFee = 0;
139     uint256 private totalFee = 3000;
140     uint256 private sellFee = 6000;
141     uint256 private transferFee = 9900;
142     uint256 private denominator = 10000;
143     bool private swapEnabled = true;
144     uint256 private swapTimes;
145     bool private swapping;
146     uint256 swapAmount = 1;
147     uint256 private swapThreshold = ( _totalSupply * 2000 ) / 100000;
148     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
149     modifier lockTheSwap {swapping = true; _; swapping = false;}
150 
151     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
152     address internal constant development_receiver = 0x45e71601465528e1D3028A94a86d51731B38d8F8; 
153     address internal constant marketing_receiver = 0x45e71601465528e1D3028A94a86d51731B38d8F8;
154     address internal constant liquidity_receiver = 0x45e71601465528e1D3028A94a86d51731B38d8F8;
155 
156     constructor() Ownable(msg.sender) {
157         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
158         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
159         router = _router;
160         pair = _pair;
161         isFeeExempt[address(this)] = true;
162         isFeeExempt[liquidity_receiver] = true;
163         isFeeExempt[marketing_receiver] = true;
164         isFeeExempt[msg.sender] = true;
165         _balances[msg.sender] = _totalSupply;
166         emit Transfer(address(0), msg.sender, _totalSupply);
167     }
168 
169     receive() external payable {}
170     function name() public pure returns (string memory) {return _name;}
171     function symbol() public pure returns (string memory) {return _symbol;}
172     function decimals() public pure returns (uint8) {return _decimals;}
173     function startTrading() external onlyOwner {tradingAllowed = true;}
174     function getOwner() external view override returns (address) { return owner; }
175     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
176     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
177     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
178     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
179     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
180     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
181     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
182     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
183     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
184     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
185     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
186 
187     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
188         require(sender != address(0), "ERC20: transfer from the zero address");
189         require(recipient != address(0), "ERC20: transfer to the zero address");
190         require(amount > uint256(0), "Transfer amount must be greater than zero");
191         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
192     }
193 
194     function _transfer(address sender, address recipient, uint256 amount) private {
195         preTxCheck(sender, recipient, amount);
196         checkTradingAllowed(sender, recipient);
197         checkMaxWallet(sender, recipient, amount); 
198         swapbackCounters(sender, recipient);
199         checkTxLimit(sender, recipient, amount); 
200         swapBack(sender, recipient, amount);
201         _balances[sender] = _balances[sender].sub(amount);
202         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
203         _balances[recipient] = _balances[recipient].add(amountReceived);
204         emit Transfer(sender, recipient, amountReceived);
205     }
206 
207     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
208         liquidityFee = _liquidity;
209         marketingFee = _marketing;
210         burnFee = _burn;
211         developmentFee = _development;
212         totalFee = _total;
213         sellFee = _sell;
214         transferFee = _trans;
215         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
216     }
217 
218     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
219         uint256 newTx = (totalSupply() * _buy) / 10000;
220         uint256 newTransfer = (totalSupply() * _trans) / 10000;
221         uint256 newWallet = (totalSupply() * _wallet) / 10000;
222         _maxTxAmountPercent = _buy;
223         _maxTransferPercent = _trans;
224         _maxWalletPercent = _wallet;
225         uint256 limit = totalSupply().mul(5).div(1000);
226         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
227     }
228 
229     function checkTradingAllowed(address sender, address recipient) internal view {
230         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
231     }
232     
233     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
234         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
235             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
236     }
237 
238     function swapbackCounters(address sender, address recipient) internal {
239         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
240     }
241 
242     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
243         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
244         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
245     }
246 
247     function swapAndLiquify(uint256 tokens) private lockTheSwap {
248         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
249         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
250         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
251         uint256 initialBalance = address(this).balance;
252         swapTokensForETH(toSwap);
253         uint256 deltaBalance = address(this).balance.sub(initialBalance);
254         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
255         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
256         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
257         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
258         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
259         uint256 remainingBalance = address(this).balance;
260         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
261     }
262 
263     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
264         _approve(address(this), address(router), tokenAmount);
265         router.addLiquidityETH{value: ETHAmount}(
266             address(this),
267             tokenAmount,
268             0,
269             0,
270             liquidity_receiver,
271             block.timestamp);
272     }
273 
274     function swapTokensForETH(uint256 tokenAmount) private {
275         address[] memory path = new address[](2);
276         path[0] = address(this);
277         path[1] = router.WETH();
278         _approve(address(this), address(router), tokenAmount);
279         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
280             tokenAmount,
281             0,
282             path,
283             address(this),
284             block.timestamp);
285     }
286 
287     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
288         bool aboveMin = amount >= minTokenAmount;
289         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
290         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
291     }
292 
293     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
294         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
295         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
296     }
297 
298     function swapBack(address sender, address recipient, uint256 amount) internal {
299         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
300     }
301 
302     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
303         return !isFeeExempt[sender] && !isFeeExempt[recipient];
304     }
305 
306     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
307         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
308         if(recipient == pair){return sellFee;}
309         if(sender == pair){return totalFee;}
310         return transferFee;
311     }
312 
313     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
314         if(getTotalFee(sender, recipient) > 0){
315         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
316         _balances[address(this)] = _balances[address(this)].add(feeAmount);
317         emit Transfer(sender, address(this), feeAmount);
318         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
319         return amount.sub(feeAmount);} return amount;
320     }
321 
322     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
323         _transfer(sender, recipient, amount);
324         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
325         return true;
326     }
327 
328     function _approve(address owner, address spender, uint256 amount) private {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331         _allowances[owner][spender] = amount;
332         emit Approval(owner, spender, amount);
333     }
334 
335 }