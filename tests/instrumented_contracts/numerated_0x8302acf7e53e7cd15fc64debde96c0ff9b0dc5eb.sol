1 /**
2 
3 More than a meme.
4 The start of the Bull.
5 
6 https://kleekaiinu.com/
7 https://twitter.com/kleekaiinu
8 https://t.me/Kleekai_Inu
9 
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
51     function circulatingSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);}
63 
64 abstract contract Ownable {
65     address internal owner;
66     constructor(address _owner) {owner = _owner;}
67     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
68     function isOwner(address account) public view returns (bool) {return account == owner;}
69     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
70     event OwnershipTransferred(address owner);
71 }
72 
73 interface IFactory{
74         function createPair(address tokenA, address tokenB) external returns (address pair);
75         function getPair(address tokenA, address tokenB) external view returns (address pair);
76 }
77 
78 interface IRouter {
79     function factory() external pure returns (address);
80     function WETH() external pure returns (address);
81     function addLiquidityETH(
82         address token,
83         uint amountTokenDesired,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline
88     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
89 
90     function removeLiquidityWithPermit(
91         address tokenA,
92         address tokenB,
93         uint liquidity,
94         uint amountAMin,
95         uint amountBMin,
96         address to,
97         uint deadline,
98         bool approveMax, uint8 v, bytes32 r, bytes32 s
99     ) external returns (uint amountA, uint amountB);
100 
101     function swapExactETHForTokensSupportingFeeOnTransferTokens(
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external payable;
107 
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline) external;
114 }
115 
116 contract KleeKaiInu is IERC20, Ownable {
117     using SafeMath for uint256;
118     string private constant _name = 'Klee Kai Inu';
119     string private constant _symbol = 'KLEEK';
120     uint8 private constant _decimals = 9;
121     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
122     uint256 private _maxTxAmountPercent = 100; // 10000;
123     uint256 private _maxTransferPercent = 100;
124     uint256 private _maxWalletPercent = 100;
125     mapping (address => uint256) _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) public isFeeExempt;
128     mapping (address => bool) private isBot;
129     IRouter router;
130     address public pair;
131     bool private tradingAllowed = false;
132     uint256 private liquidityFee = 0;
133     uint256 private marketingFee = 1000;
134     uint256 private developmentFee = 1000;
135     uint256 private burnFee = 0;
136     uint256 private totalFee = 2000;
137     uint256 private sellFee = 2000;
138     uint256 private transferFee = 2000;
139     uint256 private denominator = 10000;
140     bool private swapEnabled = true;
141     uint256 private swapTimes;
142     bool private swapping; 
143     uint256 private swapThreshold = ( _totalSupply * 250 ) / 100000;
144     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
145     modifier lockTheSwap {swapping = true; _; swapping = false;}
146 
147     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
148     address internal constant development_receiver = 0x755fd382129ae11B3F5795bC946D0C7D4ce5AF1e; 
149     address internal constant marketing_receiver = 0x85C8bC1aF453b849B4993b188447014C5c62c019;
150     address internal constant liquidity_receiver = 0x755fd382129ae11B3F5795bC946D0C7D4ce5AF1e;
151 
152     constructor() Ownable(msg.sender) {
153         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
154         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
155         router = _router;
156         pair = _pair;
157         isFeeExempt[address(this)] = true;
158         isFeeExempt[liquidity_receiver] = true;
159         isFeeExempt[marketing_receiver] = true;
160         isFeeExempt[msg.sender] = true;
161         _balances[msg.sender] = _totalSupply;
162         emit Transfer(address(0), msg.sender, _totalSupply);
163     }
164 
165     receive() external payable {}
166     function name() public pure returns (string memory) {return _name;}
167     function symbol() public pure returns (string memory) {return _symbol;}
168     function decimals() public pure returns (uint8) {return _decimals;}
169     function startTrading() external onlyOwner {tradingAllowed = true;}
170     function getOwner() external view override returns (address) { return owner; }
171     function totalSupply() public view override returns (uint256) {return _totalSupply;}
172     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
173     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
174     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
175     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
176     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
177     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
178     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
179     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
180     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
181     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
182     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
183 
184     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
185         require(sender != address(0), "ERC20: transfer from the zero address");
186         require(recipient != address(0), "ERC20: transfer to the zero address");
187         require(amount > uint256(0), "Transfer amount must be greater than zero");
188         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
189     }
190 
191     function _transfer(address sender, address recipient, uint256 amount) private {
192         preTxCheck(sender, recipient, amount);
193         checkTradingAllowed(sender, recipient);
194         checkMaxWallet(sender, recipient, amount); 
195         swapbackCounters(sender, recipient);
196         checkTxLimit(sender, recipient, amount); 
197         swapBack(sender, recipient, amount);
198         _balances[sender] = _balances[sender].sub(amount);
199         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
200         _balances[recipient] = _balances[recipient].add(amountReceived);
201         emit Transfer(sender, recipient, amountReceived);
202     }
203 
204     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
205         liquidityFee = _liquidity;
206         marketingFee = _marketing;
207         burnFee = _burn;
208         developmentFee = _development;
209         totalFee = _total;
210         sellFee = _sell;
211         transferFee = _trans;
212         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
213     }
214 
215     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
216         uint256 newTx = (totalSupply() * _buy) / 10000;
217         uint256 newTransfer = (totalSupply() * _trans) / 10000;
218         uint256 newWallet = (totalSupply() * _wallet) / 10000;
219         _maxTxAmountPercent = _buy;
220         _maxTransferPercent = _trans;
221         _maxWalletPercent = _wallet;
222         uint256 limit = totalSupply().mul(5).div(1000);
223         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
224     }
225 
226     function checkTradingAllowed(address sender, address recipient) internal view {
227         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
228     }
229     
230     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
231         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
232             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
233     }
234 
235     function swapbackCounters(address sender, address recipient) internal {
236         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
237     }
238 
239     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
240         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
241         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
242     }
243 
244     function swapAndLiquify(uint256 tokens) private lockTheSwap {
245         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
246         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
247         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
248         uint256 initialBalance = address(this).balance;
249         swapTokensForETH(toSwap);
250         uint256 deltaBalance = address(this).balance.sub(initialBalance);
251         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
252         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
253         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
254         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
255         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
256         uint256 remainingBalance = address(this).balance;
257         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
258     }
259 
260     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
261         _approve(address(this), address(router), tokenAmount);
262         router.addLiquidityETH{value: ETHAmount}(
263             address(this),
264             tokenAmount,
265             0,
266             0,
267             liquidity_receiver,
268             block.timestamp);
269     }
270 
271     function swapTokensForETH(uint256 tokenAmount) private {
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = router.WETH();
275         _approve(address(this), address(router), tokenAmount);
276         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp);
282     }
283 
284     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
285         bool aboveMin = amount >= _minTokenAmount;
286         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
287         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
288     }
289 
290     function swapBack(address sender, address recipient, uint256 amount) internal {
291         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
292     }
293 
294     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
295         return !isFeeExempt[sender] && !isFeeExempt[recipient];
296     }
297 
298     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
299         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
300         if(recipient == pair){return sellFee;}
301         if(sender == pair){return totalFee;}
302         return transferFee;
303     }
304 
305     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
306         if(getTotalFee(sender, recipient) > 0){
307         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
308         _balances[address(this)] = _balances[address(this)].add(feeAmount);
309         emit Transfer(sender, address(this), feeAmount);
310         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
311         return amount.sub(feeAmount);} return amount;
312     }
313 
314     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
315         _transfer(sender, recipient, amount);
316         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
317         return true;
318     }
319 
320     function _approve(address owner, address spender, uint256 amount) private {
321         require(owner != address(0), "ERC20: approve from the zero address");
322         require(spender != address(0), "ERC20: approve to the zero address");
323         _allowances[owner][spender] = amount;
324         emit Approval(owner, spender, amount);
325     }
326 
327 }