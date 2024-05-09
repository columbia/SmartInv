1 /**
2 
3 The Bogdanoff "he bought?" meme is a reference to the infamous French twin brothers, Igor and Grichka Bogdanoff. 
4 The meme is often used in a humorous or sarcastic way to imply that the person being asked the question is hiding something.
5 BOGDANOFF AND WOJAK 
6 
7 https://t.me/bogdanoffcoinerc
8 
9 https://twitter.com/bogdanofferc
10 
11 http://bogdanoffcoin.com/
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.16;
17 
18 
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
24     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
25     
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
28 
29     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
31 
32     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
34         if(c / a != b) return(false, 0); return(true, c);}}
35 
36     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
38 
39     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         unchecked{require(b <= a, errorMessage); return a - b;}}
44 
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         unchecked{require(b > 0, errorMessage); return a / b;}}
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         unchecked{require(b > 0, errorMessage); return a % b;}}}
50 
51 interface IERC20 {
52     function totalSupply() external view returns (uint256);
53     function decimals() external view returns (uint8);
54     function symbol() external view returns (string memory);
55     function name() external view returns (string memory);
56     function getOwner() external view returns (address);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address _owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);}
64 
65 abstract contract Ownable {
66     address internal owner;
67     constructor(address _owner) {owner = _owner;}
68     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
69     function isOwner(address account) public view returns (bool) {return account == owner;}
70     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
71     event OwnershipTransferred(address owner);
72 }
73 
74 interface IFactory{
75         function createPair(address tokenA, address tokenB) external returns (address pair);
76         function getPair(address tokenA, address tokenB) external view returns (address pair);
77 }
78 
79 interface IRouter {
80     function factory() external pure returns (address);
81     function WETH() external pure returns (address);
82     function addLiquidityETH(
83         address token,
84         uint amountTokenDesired,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline
89     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
90 
91     function removeLiquidityWithPermit(
92         address tokenA,
93         address tokenB,
94         uint liquidity,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline,
99         bool approveMax, uint8 v, bytes32 r, bytes32 s
100     ) external returns (uint amountA, uint amountB);
101 
102     function swapExactETHForTokensSupportingFeeOnTransferTokens(
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external payable;
108 
109     function swapExactTokensForETHSupportingFeeOnTransferTokens(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline) external;
115 }
116 
117 contract Bogdanoff is IERC20, Ownable {
118     using SafeMath for uint256;
119     string private constant _name = 'BOGDANOFF';
120     string private constant _symbol = 'BOGGED';
121     uint8 private constant _decimals = 9;
122     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
123     uint256 private _maxTxAmountPercent = 200; // 10000;
124     uint256 private _maxTransferPercent = 200;
125     uint256 private _maxWalletPercent = 300;
126     mapping (address => uint256) _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) public isFeeExempt;
129     mapping (address => bool) private isBot;
130     IRouter router;
131     address public pair;
132     bool private tradingAllowed = false;
133     uint256 private liquidityFee = 0;
134     uint256 private marketingFee = 300;
135     uint256 private developmentFee = 200;
136     uint256 private burnFee = 0;
137     uint256 private totalFee = 2000;
138     uint256 private sellFee = 4000;
139     uint256 private transferFee = 4000;
140     uint256 private denominator = 10000;
141     bool private swapEnabled = true;
142     uint256 private swapTimes;
143     bool private swapping;
144     uint256 swapAmount = 2;
145     uint256 private swapThreshold = ( _totalSupply * 500 ) / 100000;
146     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
147     modifier lockTheSwap {swapping = true; _; swapping = false;}
148 
149     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
150     address internal constant development_receiver = 0x8cd456322BeBD139130960ab9CC386E9CF65419E; 
151     address internal constant marketing_receiver = 0x8cd456322BeBD139130960ab9CC386E9CF65419E;
152     address internal constant liquidity_receiver = 0x8cd456322BeBD139130960ab9CC386E9CF65419E;
153 
154     constructor() Ownable(msg.sender) {
155         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
156         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
157         router = _router;
158         pair = _pair;
159         isFeeExempt[address(this)] = true;
160         isFeeExempt[liquidity_receiver] = true;
161         isFeeExempt[marketing_receiver] = true;
162         isFeeExempt[msg.sender] = true;
163         _balances[msg.sender] = _totalSupply;
164         emit Transfer(address(0), msg.sender, _totalSupply);
165     }
166 
167     receive() external payable {}
168     function name() public pure returns (string memory) {return _name;}
169     function symbol() public pure returns (string memory) {return _symbol;}
170     function decimals() public pure returns (uint8) {return _decimals;}
171     function startTrading() external onlyOwner {tradingAllowed = true;}
172     function getOwner() external view override returns (address) { return owner; }
173     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
174     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
175     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
176     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
177     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
178     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
179     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
180     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
181     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
182     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
183     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
184 
185     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
186         require(sender != address(0), "ERC20: transfer from the zero address");
187         require(recipient != address(0), "ERC20: transfer to the zero address");
188         require(amount > uint256(0), "Transfer amount must be greater than zero");
189         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
190     }
191 
192     function _transfer(address sender, address recipient, uint256 amount) private {
193         preTxCheck(sender, recipient, amount);
194         checkTradingAllowed(sender, recipient);
195         checkMaxWallet(sender, recipient, amount); 
196         swapbackCounters(sender, recipient);
197         checkTxLimit(sender, recipient, amount); 
198         swapBack(sender, recipient, amount);
199         _balances[sender] = _balances[sender].sub(amount);
200         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
201         _balances[recipient] = _balances[recipient].add(amountReceived);
202         emit Transfer(sender, recipient, amountReceived);
203     }
204 
205     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
206         liquidityFee = _liquidity;
207         marketingFee = _marketing;
208         burnFee = _burn;
209         developmentFee = _development;
210         totalFee = _total;
211         sellFee = _sell;
212         transferFee = _trans;
213         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
214     }
215 
216     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
217         uint256 newTx = (totalSupply() * _buy) / 10000;
218         uint256 newTransfer = (totalSupply() * _trans) / 10000;
219         uint256 newWallet = (totalSupply() * _wallet) / 10000;
220         _maxTxAmountPercent = _buy;
221         _maxTransferPercent = _trans;
222         _maxWalletPercent = _wallet;
223         uint256 limit = totalSupply().mul(5).div(1000);
224         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
225     }
226 
227     function checkTradingAllowed(address sender, address recipient) internal view {
228         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
229     }
230     
231     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
232         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
233             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
234     }
235 
236     function swapbackCounters(address sender, address recipient) internal {
237         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
238     }
239 
240     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
241         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
242         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
243     }
244 
245     function swapAndLiquify(uint256 tokens) private lockTheSwap {
246         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
247         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
248         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
249         uint256 initialBalance = address(this).balance;
250         swapTokensForETH(toSwap);
251         uint256 deltaBalance = address(this).balance.sub(initialBalance);
252         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
253         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
254         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
255         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
256         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
257         uint256 remainingBalance = address(this).balance;
258         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
259     }
260 
261     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
262         _approve(address(this), address(router), tokenAmount);
263         router.addLiquidityETH{value: ETHAmount}(
264             address(this),
265             tokenAmount,
266             0,
267             0,
268             liquidity_receiver,
269             block.timestamp);
270     }
271 
272     function swapTokensForETH(uint256 tokenAmount) private {
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = router.WETH();
276         _approve(address(this), address(router), tokenAmount);
277         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp);
283     }
284 
285     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
286         bool aboveMin = amount >= minTokenAmount;
287         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
288         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
289     }
290 
291     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
292         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
293         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
294     }
295 
296     function swapBack(address sender, address recipient, uint256 amount) internal {
297         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
298     }
299 
300     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
301         return !isFeeExempt[sender] && !isFeeExempt[recipient];
302     }
303 
304     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
305         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
306         if(recipient == pair){return sellFee;}
307         if(sender == pair){return totalFee;}
308         return transferFee;
309     }
310 
311     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
312         if(getTotalFee(sender, recipient) > 0){
313         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
314         _balances[address(this)] = _balances[address(this)].add(feeAmount);
315         emit Transfer(sender, address(this), feeAmount);
316         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
317         return amount.sub(feeAmount);} return amount;
318     }
319 
320     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
321         _transfer(sender, recipient, amount);
322         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
323         return true;
324     }
325 
326     function _approve(address owner, address spender, uint256 amount) private {
327         require(owner != address(0), "ERC20: approve from the zero address");
328         require(spender != address(0), "ERC20: approve to the zero address");
329         _allowances[owner][spender] = amount;
330         emit Approval(owner, spender, amount);
331     }
332 
333 }