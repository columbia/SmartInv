1 /**
2 
3 https://twitter.com/aigonewildeth
4 
5 https://t.me/aigonewild
6 
7 http://aigonewild.org/
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.16;
14 
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
21     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
22     
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
25 
26     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
28 
29     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
31         if(c / a != b) return(false, 0); return(true, c);}}
32 
33     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
35 
36     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         unchecked{require(b <= a, errorMessage); return a - b;}}
41 
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         unchecked{require(b > 0, errorMessage); return a / b;}}
44 
45     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         unchecked{require(b > 0, errorMessage); return a % b;}}}
47 
48 interface IERC20 {
49     function totalSupply() external view returns (uint256);
50     function decimals() external view returns (uint8);
51     function symbol() external view returns (string memory);
52     function name() external view returns (string memory);
53     function getOwner() external view returns (address);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address _owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);}
61 
62 abstract contract Ownable {
63     address internal owner;
64     constructor(address _owner) {owner = _owner;}
65     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
66     function isOwner(address account) public view returns (bool) {return account == owner;}
67     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
68     event OwnershipTransferred(address owner);
69 }
70 
71 interface IFactory{
72         function createPair(address tokenA, address tokenB) external returns (address pair);
73         function getPair(address tokenA, address tokenB) external view returns (address pair);
74 }
75 
76 interface IRouter {
77     function factory() external pure returns (address);
78     function WETH() external pure returns (address);
79     function addLiquidityETH(
80         address token,
81         uint amountTokenDesired,
82         uint amountTokenMin,
83         uint amountETHMin,
84         address to,
85         uint deadline
86     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
87 
88     function removeLiquidityWithPermit(
89         address tokenA,
90         address tokenB,
91         uint liquidity,
92         uint amountAMin,
93         uint amountBMin,
94         address to,
95         uint deadline,
96         bool approveMax, uint8 v, bytes32 r, bytes32 s
97     ) external returns (uint amountA, uint amountB);
98 
99     function swapExactETHForTokensSupportingFeeOnTransferTokens(
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external payable;
105 
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline) external;
112 }
113 
114 contract AIGoneWild is IERC20, Ownable {
115     using SafeMath for uint256;
116     string private constant _name = 'AIGoneWild';
117     string private constant _symbol = 'AIGW';
118     uint8 private constant _decimals = 9;
119     uint256 private _totalSupply = 69000000 * (10 ** _decimals);
120     uint256 private _maxTxAmountPercent = 100; // 10000;
121     uint256 private _maxTransferPercent = 100;
122     uint256 private _maxWalletPercent = 100;
123     mapping (address => uint256) _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) public isFeeExempt;
126     mapping (address => bool) private isBot;
127     IRouter router;
128     address public pair;
129     bool private tradingAllowed = false;
130     uint256 private liquidityFee = 0;
131     uint256 private marketingFee = 300;
132     uint256 private developmentFee = 100;
133     uint256 private burnFee = 0;
134     uint256 private totalFee = 1000;
135     uint256 private sellFee = 4000;
136     uint256 private transferFee = 4000;
137     uint256 private denominator = 10000;
138     bool private swapEnabled = true;
139     uint256 private swapTimes;
140     bool private swapping; 
141     uint256 private swapThreshold = ( _totalSupply * 200 ) / 100000;
142     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
143     modifier lockTheSwap {swapping = true; _; swapping = false;}
144 
145     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
146     address internal constant development_receiver = 0xE2cb3EBC27d5d148dE29Fc1E9d02dE57C401F6AF; 
147     address internal constant marketing_receiver = 0xB4424bc71f5dE6e5746b64C86FD2Ff804612fE21;
148     address internal constant liquidity_receiver = 0xE2cb3EBC27d5d148dE29Fc1E9d02dE57C401F6AF;
149 
150     constructor() Ownable(msg.sender) {
151         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
152         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
153         router = _router;
154         pair = _pair;
155         isFeeExempt[address(this)] = true;
156         isFeeExempt[liquidity_receiver] = true;
157         isFeeExempt[marketing_receiver] = true;
158         isFeeExempt[msg.sender] = true;
159         _balances[msg.sender] = _totalSupply;
160         emit Transfer(address(0), msg.sender, _totalSupply);
161     }
162 
163     receive() external payable {}
164     function name() public pure returns (string memory) {return _name;}
165     function symbol() public pure returns (string memory) {return _symbol;}
166     function decimals() public pure returns (uint8) {return _decimals;}
167     function startTrading() external onlyOwner {tradingAllowed = true;}
168     function getOwner() external view override returns (address) { return owner; }
169     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
170     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
171     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
172     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
173     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
174     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
175     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
176     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
177     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
178     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
179     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
180 
181     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
182         require(sender != address(0), "ERC20: transfer from the zero address");
183         require(recipient != address(0), "ERC20: transfer to the zero address");
184         require(amount > uint256(0), "Transfer amount must be greater than zero");
185         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
186     }
187 
188     function _transfer(address sender, address recipient, uint256 amount) private {
189         preTxCheck(sender, recipient, amount);
190         checkTradingAllowed(sender, recipient);
191         checkMaxWallet(sender, recipient, amount); 
192         swapbackCounters(sender, recipient);
193         checkTxLimit(sender, recipient, amount); 
194         swapBack(sender, recipient, amount);
195         _balances[sender] = _balances[sender].sub(amount);
196         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
197         _balances[recipient] = _balances[recipient].add(amountReceived);
198         emit Transfer(sender, recipient, amountReceived);
199     }
200 
201     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
202         liquidityFee = _liquidity;
203         marketingFee = _marketing;
204         burnFee = _burn;
205         developmentFee = _development;
206         totalFee = _total;
207         sellFee = _sell;
208         transferFee = _trans;
209         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
210     }
211 
212     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
213         uint256 newTx = (totalSupply() * _buy) / 10000;
214         uint256 newTransfer = (totalSupply() * _trans) / 10000;
215         uint256 newWallet = (totalSupply() * _wallet) / 10000;
216         _maxTxAmountPercent = _buy;
217         _maxTransferPercent = _trans;
218         _maxWalletPercent = _wallet;
219         uint256 limit = totalSupply().mul(5).div(1000);
220         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
221     }
222 
223     function checkTradingAllowed(address sender, address recipient) internal view {
224         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
225     }
226     
227     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
228         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
229             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
230     }
231 
232     function swapbackCounters(address sender, address recipient) internal {
233         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
234     }
235 
236     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
237         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
238         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
239     }
240 
241     function swapAndLiquify(uint256 tokens) private lockTheSwap {
242         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
243         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
244         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
245         uint256 initialBalance = address(this).balance;
246         swapTokensForETH(toSwap);
247         uint256 deltaBalance = address(this).balance.sub(initialBalance);
248         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
249         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
250         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
251         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
252         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
253         uint256 remainingBalance = address(this).balance;
254         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
255     }
256 
257     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
258         _approve(address(this), address(router), tokenAmount);
259         router.addLiquidityETH{value: ETHAmount}(
260             address(this),
261             tokenAmount,
262             0,
263             0,
264             liquidity_receiver,
265             block.timestamp);
266     }
267 
268     function swapTokensForETH(uint256 tokenAmount) private {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = router.WETH();
272         _approve(address(this), address(router), tokenAmount);
273         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp);
279     }
280 
281     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
282         bool aboveMin = amount >= _minTokenAmount;
283         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
284         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
285     }
286 
287     function swapBack(address sender, address recipient, uint256 amount) internal {
288         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
289     }
290 
291     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
292         return !isFeeExempt[sender] && !isFeeExempt[recipient];
293     }
294 
295     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
296         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
297         if(recipient == pair){return sellFee;}
298         if(sender == pair){return totalFee;}
299         return transferFee;
300     }
301 
302     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
303         if(getTotalFee(sender, recipient) > 0){
304         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
305         _balances[address(this)] = _balances[address(this)].add(feeAmount);
306         emit Transfer(sender, address(this), feeAmount);
307         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
308         return amount.sub(feeAmount);} return amount;
309     }
310 
311     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
312         _transfer(sender, recipient, amount);
313         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
314         return true;
315     }
316 
317     function _approve(address owner, address spender, uint256 amount) private {
318         require(owner != address(0), "ERC20: approve from the zero address");
319         require(spender != address(0), "ERC20: approve to the zero address");
320         _allowances[owner][spender] = amount;
321         emit Approval(owner, spender, amount);
322     }
323 
324 }