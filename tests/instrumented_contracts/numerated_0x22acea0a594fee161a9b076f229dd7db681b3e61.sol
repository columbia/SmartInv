1 /**
2 
3 https://t.me/JomonInuPortal
4 
5 
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.16;
12 
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
19     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
20     
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
23 
24     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
26 
27     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
29         if(c / a != b) return(false, 0); return(true, c);}}
30 
31     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
33 
34     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         unchecked{require(b <= a, errorMessage); return a - b;}}
39 
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         unchecked{require(b > 0, errorMessage); return a / b;}}
42 
43     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         unchecked{require(b > 0, errorMessage); return a % b;}}}
45 
46 interface IERC20 {
47     function totalSupply() external view returns (uint256);
48     function decimals() external view returns (uint8);
49     function symbol() external view returns (string memory);
50     function name() external view returns (string memory);
51     function getOwner() external view returns (address);
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address _owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);}
59 
60 abstract contract Ownable {
61     address internal owner;
62     constructor(address _owner) {owner = _owner;}
63     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
64     function isOwner(address account) public view returns (bool) {return account == owner;}
65     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
66     event OwnershipTransferred(address owner);
67 }
68 
69 interface IFactory{
70         function createPair(address tokenA, address tokenB) external returns (address pair);
71         function getPair(address tokenA, address tokenB) external view returns (address pair);
72 }
73 
74 interface IRouter {
75     function factory() external pure returns (address);
76     function WETH() external pure returns (address);
77     function addLiquidityETH(
78         address token,
79         uint amountTokenDesired,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline
84     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
85 
86     function removeLiquidityWithPermit(
87         address tokenA,
88         address tokenB,
89         uint liquidity,
90         uint amountAMin,
91         uint amountBMin,
92         address to,
93         uint deadline,
94         bool approveMax, uint8 v, bytes32 r, bytes32 s
95     ) external returns (uint amountA, uint amountB);
96 
97     function swapExactETHForTokensSupportingFeeOnTransferTokens(
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external payable;
103 
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline) external;
110 }
111 
112 contract JomonInu is IERC20, Ownable {
113     using SafeMath for uint256;
114     string private constant _name = 'Jomon Inu';
115     string private constant _symbol = 'JINU';
116     uint8 private constant _decimals = 9;
117     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
118     uint256 private _maxTxAmountPercent = 100; // 10000;
119     uint256 private _maxTransferPercent = 100;
120     uint256 private _maxWalletPercent = 100;
121     mapping (address => uint256) _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) public isFeeExempt;
124     mapping (address => bool) private isBot;
125     IRouter router;
126     address public pair;
127     bool private tradingAllowed = false;
128     uint256 private liquidityFee = 0;
129     uint256 private marketingFee = 300;
130     uint256 private developmentFee = 0;
131     uint256 private burnFee = 0;
132     uint256 private totalFee = 300;
133     uint256 private sellFee = 300;
134     uint256 private transferFee = 0;
135     uint256 private denominator = 10000;
136     bool private swapEnabled = true;
137     uint256 private swapTimes;
138     bool private swapping; 
139     uint256 private swapThreshold = ( _totalSupply * 200 ) / 100000;
140     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
141     modifier lockTheSwap {swapping = true; _; swapping = false;}
142 
143     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
144     address internal constant development_receiver = 0x692AE94d32B31653B8ee4B557c1A0B029d3e5fEB; 
145     address internal constant marketing_receiver = 0x692AE94d32B31653B8ee4B557c1A0B029d3e5fEB;
146     address internal constant liquidity_receiver = 0x692AE94d32B31653B8ee4B557c1A0B029d3e5fEB;
147 
148     constructor() Ownable(msg.sender) {
149         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
150         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
151         router = _router;
152         pair = _pair;
153         isFeeExempt[address(this)] = true;
154         isFeeExempt[liquidity_receiver] = true;
155         isFeeExempt[marketing_receiver] = true;
156         isFeeExempt[msg.sender] = true;
157         _balances[msg.sender] = _totalSupply;
158         emit Transfer(address(0), msg.sender, _totalSupply);
159     }
160 
161     receive() external payable {}
162     function name() public pure returns (string memory) {return _name;}
163     function symbol() public pure returns (string memory) {return _symbol;}
164     function decimals() public pure returns (uint8) {return _decimals;}
165     function startTrading() external onlyOwner {tradingAllowed = true;}
166     function getOwner() external view override returns (address) { return owner; }
167     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
168     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
169     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
170     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
171     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
172     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
173     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
174     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
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
282         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
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