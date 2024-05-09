1 /**
2 
3 猫分散型。多くの人が挑戦しましたが、達成した人はほとんどいません。私は分散型通貨の新時代を始めるためにここにいます
4 
5 https://t.me/Neko_Chat_Eth
6 
7 https://twitter.com/The_real_neko_
8 
9 https://www.neko-decentralized.com/
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.16;
15 
16 
17 library SafeMath {
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
22     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
23     
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
26 
27     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
29 
30     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
32         if(c / a != b) return(false, 0); return(true, c);}}
33 
34     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
36 
37     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         unchecked{require(b <= a, errorMessage); return a - b;}}
42 
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         unchecked{require(b > 0, errorMessage); return a / b;}}
45 
46     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         unchecked{require(b > 0, errorMessage); return a % b;}}}
48 
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51     function decimals() external view returns (uint8);
52     function symbol() external view returns (string memory);
53     function name() external view returns (string memory);
54     function getOwner() external view returns (address);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address _owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);}
62 
63 abstract contract Ownable {
64     address internal owner;
65     constructor(address _owner) {owner = _owner;}
66     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
67     function isOwner(address account) public view returns (bool) {return account == owner;}
68     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
69     event OwnershipTransferred(address owner);
70 }
71 
72 interface IFactory{
73         function createPair(address tokenA, address tokenB) external returns (address pair);
74         function getPair(address tokenA, address tokenB) external view returns (address pair);
75 }
76 
77 interface IRouter {
78     function factory() external pure returns (address);
79     function WETH() external pure returns (address);
80     function addLiquidityETH(
81         address token,
82         uint amountTokenDesired,
83         uint amountTokenMin,
84         uint amountETHMin,
85         address to,
86         uint deadline
87     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
88 
89     function removeLiquidityWithPermit(
90         address tokenA,
91         address tokenB,
92         uint liquidity,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline,
97         bool approveMax, uint8 v, bytes32 r, bytes32 s
98     ) external returns (uint amountA, uint amountB);
99 
100     function swapExactETHForTokensSupportingFeeOnTransferTokens(
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external payable;
106 
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline) external;
113 }
114 
115 contract NEKO is IERC20, Ownable {
116     using SafeMath for uint256;
117     string private constant _name = 'Neko';
118     string private constant _symbol = 'NEKO';
119     uint8 private constant _decimals = 9;
120     uint256 private _totalSupply = 100000000000000 * (10 ** _decimals);
121     uint256 private _maxTxAmountPercent = 200; // 10000;
122     uint256 private _maxTransferPercent = 200;
123     uint256 private _maxWalletPercent = 300;
124     mapping (address => uint256) _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) public isFeeExempt;
127     mapping (address => bool) private isBot;
128     IRouter router;
129     address public pair;
130     bool private tradingAllowed = false;
131     uint256 private liquidityFee = 0;
132     uint256 private marketingFee = 0;
133     uint256 private developmentFee = 1000;
134     uint256 private burnFee = 0;
135     uint256 private totalFee = 2500;
136     uint256 private sellFee = 6000;
137     uint256 private transferFee = 9900;
138     uint256 private denominator = 10000;
139     bool private swapEnabled = true;
140     uint256 private swapTimes;
141     bool private swapping; 
142     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
143     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
144     modifier lockTheSwap {swapping = true; _; swapping = false;}
145 
146     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
147     address internal constant development_receiver = 0x04F8Adcf3A6c4AF600225262a35317405649F304; 
148     address internal constant marketing_receiver = 0x04F8Adcf3A6c4AF600225262a35317405649F304;
149     address internal constant liquidity_receiver = 0x04F8Adcf3A6c4AF600225262a35317405649F304;
150 
151     constructor() Ownable(msg.sender) {
152         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
153         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
154         router = _router;
155         pair = _pair;
156         isFeeExempt[address(this)] = true;
157         isFeeExempt[liquidity_receiver] = true;
158         isFeeExempt[marketing_receiver] = true;
159         isFeeExempt[msg.sender] = true;
160         _balances[msg.sender] = _totalSupply;
161         emit Transfer(address(0), msg.sender, _totalSupply);
162     }
163 
164     receive() external payable {}
165     function name() public pure returns (string memory) {return _name;}
166     function symbol() public pure returns (string memory) {return _symbol;}
167     function decimals() public pure returns (uint8) {return _decimals;}
168     function startTrading() external onlyOwner {tradingAllowed = true;}
169     function getOwner() external view override returns (address) { return owner; }
170     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
171     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
172     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
173     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
174     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
175     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
176     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
177     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
178     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
179     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
180     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
181 
182     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
183         require(sender != address(0), "ERC20: transfer from the zero address");
184         require(recipient != address(0), "ERC20: transfer to the zero address");
185         require(amount > uint256(0), "Transfer amount must be greater than zero");
186         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
187     }
188 
189     function _transfer(address sender, address recipient, uint256 amount) private {
190         preTxCheck(sender, recipient, amount);
191         checkTradingAllowed(sender, recipient);
192         checkMaxWallet(sender, recipient, amount); 
193         swapbackCounters(sender, recipient);
194         checkTxLimit(sender, recipient, amount); 
195         swapBack(sender, recipient, amount);
196         _balances[sender] = _balances[sender].sub(amount);
197         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
198         _balances[recipient] = _balances[recipient].add(amountReceived);
199         emit Transfer(sender, recipient, amountReceived);
200     }
201 
202     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
203         liquidityFee = _liquidity;
204         marketingFee = _marketing;
205         burnFee = _burn;
206         developmentFee = _development;
207         totalFee = _total;
208         sellFee = _sell;
209         transferFee = _trans;
210         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
211     }
212 
213     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
214         uint256 newTx = (totalSupply() * _buy) / 10000;
215         uint256 newTransfer = (totalSupply() * _trans) / 10000;
216         uint256 newWallet = (totalSupply() * _wallet) / 10000;
217         _maxTxAmountPercent = _buy;
218         _maxTransferPercent = _trans;
219         _maxWalletPercent = _wallet;
220         uint256 limit = totalSupply().mul(5).div(1000);
221         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
222     }
223 
224     function checkTradingAllowed(address sender, address recipient) internal view {
225         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
226     }
227     
228     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
229         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
230             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
231     }
232 
233     function swapbackCounters(address sender, address recipient) internal {
234         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
235     }
236 
237     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
238         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
239         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
240     }
241 
242     function swapAndLiquify(uint256 tokens) private lockTheSwap {
243         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
244         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
245         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
246         uint256 initialBalance = address(this).balance;
247         swapTokensForETH(toSwap);
248         uint256 deltaBalance = address(this).balance.sub(initialBalance);
249         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
250         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
251         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
252         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
253         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
254         uint256 remainingBalance = address(this).balance;
255         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
256     }
257 
258     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
259         _approve(address(this), address(router), tokenAmount);
260         router.addLiquidityETH{value: ETHAmount}(
261             address(this),
262             tokenAmount,
263             0,
264             0,
265             liquidity_receiver,
266             block.timestamp);
267     }
268 
269     function swapTokensForETH(uint256 tokenAmount) private {
270         address[] memory path = new address[](2);
271         path[0] = address(this);
272         path[1] = router.WETH();
273         _approve(address(this), address(router), tokenAmount);
274         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
275             tokenAmount,
276             0,
277             path,
278             address(this),
279             block.timestamp);
280     }
281 
282     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
283         bool aboveMin = amount >= _minTokenAmount;
284         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
285         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
286     }
287 
288     function swapBack(address sender, address recipient, uint256 amount) internal {
289         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
290     }
291 
292     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
293         return !isFeeExempt[sender] && !isFeeExempt[recipient];
294     }
295 
296     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
297         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
298         if(recipient == pair){return sellFee;}
299         if(sender == pair){return totalFee;}
300         return transferFee;
301     }
302 
303     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
304         if(getTotalFee(sender, recipient) > 0){
305         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
306         _balances[address(this)] = _balances[address(this)].add(feeAmount);
307         emit Transfer(sender, address(this), feeAmount);
308         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
309         return amount.sub(feeAmount);} return amount;
310     }
311 
312     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
313         _transfer(sender, recipient, amount);
314         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
315         return true;
316     }
317 
318     function _approve(address owner, address spender, uint256 amount) private {
319         require(owner != address(0), "ERC20: approve from the zero address");
320         require(spender != address(0), "ERC20: approve to the zero address");
321         _allowances[owner][spender] = amount;
322         emit Approval(owner, spender, amount);
323     }
324 
325 }