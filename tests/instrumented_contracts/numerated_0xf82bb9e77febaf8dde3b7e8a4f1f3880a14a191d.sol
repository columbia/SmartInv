1 /**
2 
3 MILADS - $LADS
4 
5 Welcome to Milads, 
6 Here is where you a Milady can find your beloved Milad. Because 
7 each and every Lady must have their own Lad. 
8 
9 https://miladcoin.com/
10 
11 https://twitter.com/MiladsERC
12 
13 https://t.me/MiladsERC
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.16;
20 
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
27     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
28     
29     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
31 
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
34 
35     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
37         if(c / a != b) return(false, 0); return(true, c);}}
38 
39     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
41 
42     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         unchecked{require(b <= a, errorMessage); return a - b;}}
47 
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         unchecked{require(b > 0, errorMessage); return a / b;}}
50 
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         unchecked{require(b > 0, errorMessage); return a % b;}}}
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function getOwner() external view returns (address);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address _owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);}
67 
68 abstract contract Ownable {
69     address internal owner;
70     constructor(address _owner) {owner = _owner;}
71     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
72     function isOwner(address account) public view returns (bool) {return account == owner;}
73     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
74     event OwnershipTransferred(address owner);
75 }
76 
77 interface IFactory{
78         function createPair(address tokenA, address tokenB) external returns (address pair);
79         function getPair(address tokenA, address tokenB) external view returns (address pair);
80 }
81 
82 interface IRouter {
83     function factory() external pure returns (address);
84     function WETH() external pure returns (address);
85     function addLiquidityETH(
86         address token,
87         uint amountTokenDesired,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline
92     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
93 
94     function removeLiquidityWithPermit(
95         address tokenA,
96         address tokenB,
97         uint liquidity,
98         uint amountAMin,
99         uint amountBMin,
100         address to,
101         uint deadline,
102         bool approveMax, uint8 v, bytes32 r, bytes32 s
103     ) external returns (uint amountA, uint amountB);
104 
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
111 
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline) external;
118 }
119 
120 contract MILADS is IERC20, Ownable {
121     using SafeMath for uint256;
122     string private constant _name = 'MILADS';
123     string private constant _symbol = 'LADS';
124     uint8 private constant _decimals = 9;
125     uint256 private _totalSupply = 888000888000888 * (10 ** _decimals);
126     uint256 private _maxTxAmountPercent = 200; // 10000;
127     uint256 private _maxTransferPercent = 200;
128     uint256 private _maxWalletPercent = 300;
129     mapping (address => uint256) _balances;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) public isFeeExempt;
132     mapping (address => bool) private isBot;
133     IRouter router;
134     address public pair;
135     bool private tradingAllowed = false;
136     uint256 private liquidityFee = 0;
137     uint256 private marketingFee = 0;
138     uint256 private developmentFee = 1000;
139     uint256 private burnFee = 0;
140     uint256 private totalFee = 3000;
141     uint256 private sellFee = 3000;
142     uint256 private transferFee = 3000;
143     uint256 private denominator = 10000;
144     bool private swapEnabled = true;
145     uint256 private swapTimes;
146     bool private swapping;
147     uint256 swapAmount = 4;
148     uint256 private swapThreshold = ( _totalSupply * 2000 ) / 100000;
149     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
150     modifier lockTheSwap {swapping = true; _; swapping = false;}
151 
152     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
153     address internal constant development_receiver = 0xf100382727041773448dA5E45381f873DF92B287; 
154     address internal constant marketing_receiver = 0xf100382727041773448dA5E45381f873DF92B287;
155     address internal constant liquidity_receiver = 0xf100382727041773448dA5E45381f873DF92B287;
156 
157     constructor() Ownable(msg.sender) {
158         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
159         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
160         router = _router;
161         pair = _pair;
162         isFeeExempt[address(this)] = true;
163         isFeeExempt[liquidity_receiver] = true;
164         isFeeExempt[marketing_receiver] = true;
165         isFeeExempt[msg.sender] = true;
166         _balances[msg.sender] = _totalSupply;
167         emit Transfer(address(0), msg.sender, _totalSupply);
168     }
169 
170     receive() external payable {}
171     function name() public pure returns (string memory) {return _name;}
172     function symbol() public pure returns (string memory) {return _symbol;}
173     function decimals() public pure returns (uint8) {return _decimals;}
174     function startTrading() external onlyOwner {tradingAllowed = true;}
175     function getOwner() external view override returns (address) { return owner; }
176     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
177     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
178     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
179     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
180     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
181     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
182     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
183     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
184     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
185     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
186     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
187 
188     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
189         require(sender != address(0), "ERC20: transfer from the zero address");
190         require(recipient != address(0), "ERC20: transfer to the zero address");
191         require(amount > uint256(0), "Transfer amount must be greater than zero");
192         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
193     }
194 
195     function _transfer(address sender, address recipient, uint256 amount) private {
196         preTxCheck(sender, recipient, amount);
197         checkTradingAllowed(sender, recipient);
198         checkMaxWallet(sender, recipient, amount); 
199         swapbackCounters(sender, recipient);
200         checkTxLimit(sender, recipient, amount); 
201         swapBack(sender, recipient, amount);
202         _balances[sender] = _balances[sender].sub(amount);
203         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
204         _balances[recipient] = _balances[recipient].add(amountReceived);
205         emit Transfer(sender, recipient, amountReceived);
206     }
207 
208     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
209         liquidityFee = _liquidity;
210         marketingFee = _marketing;
211         burnFee = _burn;
212         developmentFee = _development;
213         totalFee = _total;
214         sellFee = _sell;
215         transferFee = _trans;
216         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
217     }
218 
219     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
220         uint256 newTx = (totalSupply() * _buy) / 10000;
221         uint256 newTransfer = (totalSupply() * _trans) / 10000;
222         uint256 newWallet = (totalSupply() * _wallet) / 10000;
223         _maxTxAmountPercent = _buy;
224         _maxTransferPercent = _trans;
225         _maxWalletPercent = _wallet;
226         uint256 limit = totalSupply().mul(5).div(1000);
227         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
228     }
229 
230     function checkTradingAllowed(address sender, address recipient) internal view {
231         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
232     }
233     
234     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
235         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
236             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
237     }
238 
239     function swapbackCounters(address sender, address recipient) internal {
240         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
241     }
242 
243     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
244         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
245         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
246     }
247 
248     function swapAndLiquify(uint256 tokens) private lockTheSwap {
249         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
250         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
251         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
252         uint256 initialBalance = address(this).balance;
253         swapTokensForETH(toSwap);
254         uint256 deltaBalance = address(this).balance.sub(initialBalance);
255         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
256         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
257         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
258         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
259         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
260         uint256 remainingBalance = address(this).balance;
261         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
262     }
263 
264     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
265         _approve(address(this), address(router), tokenAmount);
266         router.addLiquidityETH{value: ETHAmount}(
267             address(this),
268             tokenAmount,
269             0,
270             0,
271             liquidity_receiver,
272             block.timestamp);
273     }
274 
275     function swapTokensForETH(uint256 tokenAmount) private {
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = router.WETH();
279         _approve(address(this), address(router), tokenAmount);
280         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp);
286     }
287 
288     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
289         bool aboveMin = amount >= minTokenAmount;
290         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
291         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
292     }
293 
294     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
295         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
296         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
297     }
298 
299     function swapBack(address sender, address recipient, uint256 amount) internal {
300         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
301     }
302 
303     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
304         return !isFeeExempt[sender] && !isFeeExempt[recipient];
305     }
306 
307     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
308         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
309         if(recipient == pair){return sellFee;}
310         if(sender == pair){return totalFee;}
311         return transferFee;
312     }
313 
314     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
315         if(getTotalFee(sender, recipient) > 0){
316         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
317         _balances[address(this)] = _balances[address(this)].add(feeAmount);
318         emit Transfer(sender, address(this), feeAmount);
319         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
320         return amount.sub(feeAmount);} return amount;
321     }
322 
323     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
324         _transfer(sender, recipient, amount);
325         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
326         return true;
327     }
328 
329     function _approve(address owner, address spender, uint256 amount) private {
330         require(owner != address(0), "ERC20: approve from the zero address");
331         require(spender != address(0), "ERC20: approve to the zero address");
332         _allowances[owner][spender] = amount;
333         emit Approval(owner, spender, amount);
334     }
335 
336 }