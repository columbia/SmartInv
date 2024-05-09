1 /**
2 Apu Apustaja (APU) - Help Helper
3 Telegram: https://t.me/ApuApustajaETH
4 Twitter : https://twitter.com/ApuApustajaETH
5 Info    : https://knowyourmeme.com/memes/apu-apustaja
6 */ 
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.17;
11 
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
17     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
18     
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
21 
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
24 
25     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
27         if(c / a != b) return(false, 0); return(true, c);}}
28 
29     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
31 
32     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         unchecked{require(b <= a, errorMessage); return a - b;}}
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked{require(b > 0, errorMessage); return a / b;}}
40 
41     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked{require(b > 0, errorMessage); return a % b;}}}
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function circulatingSupply() external view returns (uint256);
47     function decimals() external view returns (uint8);
48     function symbol() external view returns (string memory);
49     function name() external view returns (string memory);
50     function getOwner() external view returns (address);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address _owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);}
58 
59 abstract contract Ownable {
60     address internal owner;
61     constructor(address _owner) {owner = _owner;}
62     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
63     function isOwner(address account) public view returns (bool) {return account == owner;}
64     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
65     event OwnershipTransferred(address owner);
66 }
67 
68 interface IFactory{
69         function createPair(address tokenA, address tokenB) external returns (address pair);
70         function getPair(address tokenA, address tokenB) external view returns (address pair);
71 }
72 
73 interface IRouter {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76     function addLiquidityETH(
77         address token,
78         uint amountTokenDesired,
79         uint amountTokenMin,
80         uint amountETHMin,
81         address to,
82         uint deadline
83     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
84 
85     function removeLiquidityWithPermit(
86         address tokenA,
87         address tokenB,
88         uint liquidity,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline,
93         bool approveMax, uint8 v, bytes32 r, bytes32 s
94     ) external returns (uint amountA, uint amountB);
95 
96     function swapExactETHForTokensSupportingFeeOnTransferTokens(
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external payable;
102 
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline) external;
109 }
110 
111 contract Apu is IERC20, Ownable {
112     using SafeMath for uint256;
113     string private constant _name = "Apu Apustaja";
114     string private constant _symbol = "APU";
115     uint8 private constant _decimals = 9;
116     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
117     uint256 private _maxTxAmountPercent = 200; // 10000;
118     uint256 private _maxTransferPercent = 200;
119     uint256 private _maxWalletPercent = 300;
120     mapping (address => uint256) _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) public isFeeExempt;
123     mapping (address => bool) private isBot;
124     IRouter router;
125     address public pair;
126     bool private tradingAllowed = false;
127     uint256 private liquidityFee = 0;
128     uint256 private marketingFee = 500;
129     uint256 private developmentFee = 500;
130     uint256 private burnFee = 0;
131     uint256 private totalFee = 2000;
132     uint256 private sellFee = 5000;
133     uint256 private transferFee = 2000;
134     uint256 private denominator = 10000;
135     bool private swapEnabled = true;
136     uint256 private swapTimes;
137     bool private swapping; 
138     uint256 private swapThreshold = ( _totalSupply * 600 ) / 100000;
139     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
140     modifier lockTheSwap {swapping = true; _; swapping = false;}
141 
142     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
143     address internal constant development_receiver = 0x88c4EAA9Ab713B673df4E048b31df3Af2dbE4012;
144     address internal constant marketing_receiver = 0x88c4EAA9Ab713B673df4E048b31df3Af2dbE4012;
145     address internal constant liquidity_receiver = 0x88c4EAA9Ab713B673df4E048b31df3Af2dbE4012;
146 
147     constructor() Ownable(msg.sender) {
148         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
149         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
150         router = _router;
151         pair = _pair;
152         isFeeExempt[address(this)] = true;
153         isFeeExempt[liquidity_receiver] = true;
154         isFeeExempt[marketing_receiver] = true;
155         isFeeExempt[msg.sender] = true;
156         _balances[msg.sender] = _totalSupply;
157         emit Transfer(address(0), msg.sender, _totalSupply);
158     }
159 
160     receive() external payable {}
161     function name() public pure returns (string memory) {return _name;}
162     function symbol() public pure returns (string memory) {return _symbol;}
163     function decimals() public pure returns (uint8) {return _decimals;}
164     function startTrading() external onlyOwner {tradingAllowed = true;}
165     function getOwner() external view override returns (address) { return owner; }
166     function totalSupply() public view override returns (uint256) {return _totalSupply;}
167     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
168     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
169     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
170     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
171     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
172     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
173     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
174     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
175     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
176     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
177     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
178 
179     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
180         require(sender != address(0), "ERC20: transfer from the zero address");
181         require(recipient != address(0), "ERC20: transfer to the zero address");
182         require(amount > uint256(0), "Transfer amount must be greater than zero");
183         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
184     }
185 
186     function _transfer(address sender, address recipient, uint256 amount) private {
187         preTxCheck(sender, recipient, amount);
188         checkTradingAllowed(sender, recipient);
189         checkMaxWallet(sender, recipient, amount); 
190         swapbackCounters(sender, recipient);
191         checkTxLimit(sender, recipient, amount); 
192         swapBack(sender, recipient, amount);
193         _balances[sender] = _balances[sender].sub(amount);
194         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
195         _balances[recipient] = _balances[recipient].add(amountReceived);
196         emit Transfer(sender, recipient, amountReceived);
197     }
198 
199     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
200         liquidityFee = _liquidity;
201         marketingFee = _marketing;
202         burnFee = _burn;
203         developmentFee = _development;
204         totalFee = _total;
205         sellFee = _sell;
206         transferFee = _trans;
207         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
208     }
209 
210     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
211         uint256 newTx = (totalSupply() * _buy) / 10000;
212         uint256 newTransfer = (totalSupply() * _trans) / 10000;
213         uint256 newWallet = (totalSupply() * _wallet) / 10000;
214         _maxTxAmountPercent = _buy;
215         _maxTransferPercent = _trans;
216         _maxWalletPercent = _wallet;
217         uint256 limit = totalSupply().mul(5).div(1000);
218         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
219     }
220 
221     function checkTradingAllowed(address sender, address recipient) internal view {
222         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
223     }
224     
225     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
226         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
227             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
228     }
229 
230     function swapbackCounters(address sender, address recipient) internal {
231         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
232     }
233 
234     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
235         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
236         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
237     }
238 
239     function swapAndLiquify(uint256 tokens) private lockTheSwap {
240         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
241         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
242         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
243         uint256 initialBalance = address(this).balance;
244         swapTokensForETH(toSwap);
245         uint256 deltaBalance = address(this).balance.sub(initialBalance);
246         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
247         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
248         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
249         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
250         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
251         uint256 remainingBalance = address(this).balance;
252         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
253     }
254 
255     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
256         _approve(address(this), address(router), tokenAmount);
257         router.addLiquidityETH{value: ETHAmount}(
258             address(this),
259             tokenAmount,
260             0,
261             0,
262             liquidity_receiver,
263             block.timestamp);
264     }
265 
266     function swapTokensForETH(uint256 tokenAmount) private {
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = router.WETH();
270         _approve(address(this), address(router), tokenAmount);
271         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             tokenAmount,
273             0,
274             path,
275             address(this),
276             block.timestamp);
277     }
278 
279     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
280         bool aboveMin = amount >= _minTokenAmount;
281         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
282         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(0) && aboveThreshold;
283     }
284 
285     function swapBack(address sender, address recipient, uint256 amount) internal {
286         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
287     }
288 
289     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
290         return !isFeeExempt[sender] && !isFeeExempt[recipient];
291     }
292 
293     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
294         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
295         if(recipient == pair){return sellFee;}
296         if(sender == pair){return totalFee;}
297         return transferFee;
298     }
299 
300     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
301         if(getTotalFee(sender, recipient) > 0){
302         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
303         _balances[address(this)] = _balances[address(this)].add(feeAmount);
304         emit Transfer(sender, address(this), feeAmount);
305         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
306         return amount.sub(feeAmount);} return amount;
307     }
308 
309     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
310         _transfer(sender, recipient, amount);
311         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
312         return true;
313     }
314 
315     function _approve(address owner, address spender, uint256 amount) private {
316         require(owner != address(0), "ERC20: approve from the zero address");
317         require(spender != address(0), "ERC20: approve to the zero address");
318         _allowances[owner][spender] = amount;
319         emit Approval(owner, spender, amount);
320     }
321 
322 }