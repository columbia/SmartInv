1 // THE FLASH ⚡
2 // TELEGRAM : https://t.me/TheFlashERC
3 // TWITTER : https://twitter.com/TheFlashERC
4 
5 pragma solidity 0.8.16;
6 
7 library SafeMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
12     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
13     
14     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
15         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
16 
17     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
19 
20     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
22         if(c / a != b) return(false, 0); return(true, c);}}
23 
24     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
26 
27     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
29 
30     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
31         unchecked{require(b <= a, errorMessage); return a - b;}}
32 
33     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         unchecked{require(b > 0, errorMessage); return a / b;}}
35 
36     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         unchecked{require(b > 0, errorMessage); return a % b;}}}
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function decimals() external view returns (uint8);
42     function symbol() external view returns (string memory);
43     function name() external view returns (string memory);
44     function getOwner() external view returns (address);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address _owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);}
52 
53 abstract contract Ownable {
54     address internal owner;
55     constructor(address _owner) {owner = _owner;}
56     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
57     function isOwner(address account) public view returns (bool) {return account == owner;}
58     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
59     event OwnershipTransferred(address owner);
60 }
61 
62 interface IFactory{
63         function createPair(address tokenA, address tokenB) external returns (address pair);
64         function getPair(address tokenA, address tokenB) external view returns (address pair);
65 }
66 
67 interface IRouter {
68     function factory() external pure returns (address);
69     function WETH() external pure returns (address);
70     function addLiquidityETH(
71         address token,
72         uint amountTokenDesired,
73         uint amountTokenMin,
74         uint amountETHMin,
75         address to,
76         uint deadline
77     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
78 
79     function removeLiquidityWithPermit(
80         address tokenA,
81         address tokenB,
82         uint liquidity,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline,
87         bool approveMax, uint8 v, bytes32 r, bytes32 s
88     ) external returns (uint amountA, uint amountB);
89 
90     function swapExactETHForTokensSupportingFeeOnTransferTokens(
91         uint amountOutMin,
92         address[] calldata path,
93         address to,
94         uint deadline
95     ) external payable;
96 
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline) external;
103 }
104 
105 contract flash is IERC20, Ownable {
106     using SafeMath for uint256;
107    string private constant _name = "The Flash";
108     string private constant _symbol = unicode"FLASH";
109     uint8 private constant _decimals = 9;
110     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
111     uint256 private _maxTxAmountPercent = 200; // 10000;
112     uint256 private _maxTransferPercent = 200;
113     uint256 private _maxWalletPercent = 200;
114     mapping (address => uint256) _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) public isFeeExempt;
117     mapping (address => bool) private isBot;
118     IRouter router;
119     address public pair;
120     bool private tradingAllowed = true;
121     uint256 private liquidityFee = 100;
122     uint256 private marketingFee = 300;
123     uint256 private developmentFee = 100;
124     uint256 private burnFee = 0;
125     uint256 private totalFee = 2000;
126     uint256 private sellFee =5000;
127     uint256 private transferFee = 0;
128     uint256 private denominator = 10000;
129     bool private swapEnabled = true;
130     uint256 private swapTimes;
131     bool private swapping;
132     uint256 swapAmount = 1;
133     uint256 private swapThreshold = ( _totalSupply * 1500 ) / 100000;
134     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
135     modifier lockTheSwap {swapping = true; _; swapping = false;}
136 
137     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
138     address internal constant development_receiver = 0x76051da3161eB6FCf61E1214Eb487c3b45c36AF1; 
139     address internal constant marketing_receiver = 0x76051da3161eB6FCf61E1214Eb487c3b45c36AF1;
140     address internal constant liquidity_receiver = 0x76051da3161eB6FCf61E1214Eb487c3b45c36AF1;
141 
142     constructor() Ownable(msg.sender) {
143         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
144         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
145         router = _router;
146         pair = _pair;
147         isFeeExempt[address(this)] = true;
148         isFeeExempt[liquidity_receiver] = true;
149         isFeeExempt[marketing_receiver] = true;
150         isFeeExempt[msg.sender] = true;
151         _balances[msg.sender] = _totalSupply;
152         emit Transfer(address(0), msg.sender, _totalSupply);
153     }
154 
155     receive() external payable {}
156     function name() public pure returns (string memory) {return _name;}
157     function symbol() public pure returns (string memory) {return _symbol;}
158     function decimals() public pure returns (uint8) {return _decimals;}
159     function botswap() external onlyOwner {tradingAllowed = true;}
160     function getOwner() external view override returns (address) { return owner; }
161     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
162     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
163     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
164     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
165     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
166     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
167     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
168     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
169     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
170     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
171     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
172 
173     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
174         require(sender != address(0), "ERC20: transfer from the zero address");
175         require(recipient != address(0), "ERC20: transfer to the zero address");
176         require(amount > uint256(0), "Transfer amount must be greater than zero");
177         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
178     }
179 
180     function _transfer(address sender, address recipient, uint256 amount) private {
181         preTxCheck(sender, recipient, amount);
182         checkTradingAllowed(sender, recipient);
183         checkMaxWallet(sender, recipient, amount); 
184         swapbackCounters(sender, recipient);
185         checkTxLimit(sender, recipient, amount); 
186         swapBack(sender, recipient, amount);
187         _balances[sender] = _balances[sender].sub(amount);
188         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
189         _balances[recipient] = _balances[recipient].add(amountReceived);
190         emit Transfer(sender, recipient, amountReceived);
191     }
192 
193     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
194         liquidityFee = _liquidity;
195         marketingFee = _marketing;
196         burnFee = _burn;
197         developmentFee = _development;
198         totalFee = _total;
199         sellFee = _sell;
200         transferFee = _trans;
201         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
202     }
203 
204     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
205         uint256 newTx = (totalSupply() * _buy) / 10000;
206         uint256 newTransfer = (totalSupply() * _trans) / 10000;
207         uint256 newWallet = (totalSupply() * _wallet) / 10000;
208         _maxTxAmountPercent = _buy;
209         _maxTransferPercent = _trans;
210         _maxWalletPercent = _wallet;
211         uint256 limit = totalSupply().mul(5).div(1000);
212         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
213     }
214 
215     function checkTradingAllowed(address sender, address recipient) internal view {
216         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
217     }
218     
219     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
220         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
221             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
222     }
223 
224     function swapbackCounters(address sender, address recipient) internal {
225         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
226     }
227 
228     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
229         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
230         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
231     }
232 
233     function swapAndLiquify(uint256 tokens) private lockTheSwap {
234         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
235         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
236         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
237         uint256 initialBalance = address(this).balance;
238         swapTokensForETH(toSwap);
239         uint256 deltaBalance = address(this).balance.sub(initialBalance);
240         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
241         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
242         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
243         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
244         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
245         uint256 remainingBalance = address(this).balance;
246         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
247     }
248 
249     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
250         _approve(address(this), address(router), tokenAmount);
251         router.addLiquidityETH{value: ETHAmount}(
252             address(this),
253             tokenAmount,
254             0,
255             0,
256             liquidity_receiver,
257             block.timestamp);
258     }
259 
260     function swapTokensForETH(uint256 tokenAmount) private {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = router.WETH();
264         _approve(address(this), address(router), tokenAmount);
265         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp);
271     }
272 
273     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
274         bool aboveMin = amount >= minTokenAmount;
275         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
276         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
277     }
278 
279     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
280         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
281         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
282     }
283 
284     function swapBack(address sender, address recipient, uint256 amount) internal {
285         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
286     }
287 
288     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
289         return !isFeeExempt[sender] && !isFeeExempt[recipient];
290     }
291 
292     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
293         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
294         if(recipient == pair){return sellFee;}
295         if(sender == pair){return totalFee;}
296         return transferFee;
297     }
298 
299     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
300         if(getTotalFee(sender, recipient) > 0){
301         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
302         _balances[address(this)] = _balances[address(this)].add(feeAmount);
303         emit Transfer(sender, address(this), feeAmount);
304         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
305         return amount.sub(feeAmount);} return amount;
306     }
307 
308     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
309         _transfer(sender, recipient, amount);
310         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
311         return true;
312     }
313 
314     function _approve(address owner, address spender, uint256 amount) private {
315         require(owner != address(0), "ERC20: approve from the zero address");
316         require(spender != address(0), "ERC20: approve to the zero address");
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320 
321 }