1 //Website: Shikoku2.io
2 //Twitter: Twitter.com/Shikoku2io
3 //Telegram: t.me/Shikoku2io
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.19;
8 
9 
10 library SafeMath {
11 
12     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13         unchecked {
14             uint256 c = a + b;
15             if (c < a) return (false, 0);
16             return (true, c);
17         }
18     }
19 
20     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             if (b > a) return (false, 0);
23             return (true, a - b);
24         }
25     }
26 
27     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             if (a == 0) return (true, 0);
30             uint256 c = a * b;
31             if (c / a != b) return (false, 0);
32             return (true, c);
33         }
34     }
35 
36     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b == 0) return (false, 0);
39             return (true, a / b);
40         }
41     }
42 
43     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b == 0) return (false, 0);
46             return (true, a % b);
47         }
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a + b;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a - b;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a * b;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a / b;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a % b;
68     }
69 
70     function sub(
71         uint256 a,
72         uint256 b,
73         string memory errorMessage
74     ) internal pure returns (uint256) {
75         unchecked {
76             require(b <= a, errorMessage);
77             return a - b;
78         }
79     }
80 
81     function div(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         unchecked {
87             require(b > 0, errorMessage);
88             return a / b;
89         }
90     }
91 
92     function mod(
93         uint256 a,
94         uint256 b,
95         string memory errorMessage
96     ) internal pure returns (uint256) {
97         unchecked {
98             require(b > 0, errorMessage);
99             return a % b;
100         }
101     }
102 }
103 
104 interface IERC20 {
105     function decimals() external view returns (uint8);
106     function symbol() external view returns (string memory);
107     function name() external view returns (string memory);
108     function getOwner() external view returns (address);
109     function totalSupply() external view returns (uint256);
110     function balanceOf(address account) external view returns (uint256);
111     function transfer(address recipient, uint256 amount) external returns (bool);
112     function allowance(address _owner, address spender) external view returns (uint256);
113     function approve(address spender, uint256 amount) external returns (bool);
114     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
115     event Transfer(address indexed from, address indexed to, uint256 value);
116     event Approval(address indexed owner, address indexed spender, uint256 value);}
117 
118 abstract contract Ownable {
119     address internal owner;
120     constructor(address _owner) {owner = _owner;}
121     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
122     function isOwner(address account) public view returns (bool) {return account == owner;}
123     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
124     event OwnershipTransferred(address owner);
125 }
126 
127 interface IFactory{
128         function createPair(address tokenA, address tokenB) external returns (address pair);
129         function getPair(address tokenA, address tokenB) external view returns (address pair);
130 }
131 
132 interface IRouter {
133     function factory() external pure returns (address);
134     function WETH() external pure returns (address);
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 
144     function swapExactTokensForETHSupportingFeeOnTransferTokens(
145         uint amountIn,
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline) external;
150 }
151 
152 contract SHIK2 is IERC20, Ownable {
153     using SafeMath for uint256;
154     string private constant _name = 'Shikoku Inu 2.0';
155     string private constant _symbol = 'SHIK2.0';
156     uint8 private constant _decimals = 9;
157     uint256 private _totalSupply = 1000000000000000 * (10 ** _decimals);
158     mapping (address => uint256) _balances;
159     mapping (address => mapping (address => uint256)) private _allowances;
160     mapping (address => bool) public isFeeExempt;
161     IRouter router;
162     address public pair;
163     bool private tradingAllowed = false;
164     bool private swapEnabled = true;
165     uint256 private swapTimes;
166     bool private swapping;
167     uint256 swapAmount = 4;
168     uint256 private swapThreshold = ( _totalSupply * 500 ) / 100000;
169     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
170     modifier lockTheSwap {swapping = true; _; swapping = false;}
171     uint256 private liquidityFee = 0;
172     uint256 private marketingFee = 2500;
173     uint256 private developmentFee = 0;
174     uint256 private burnFee = 0;
175     uint256 private totalFee = 2500;
176     uint256 private sellFee = 2500;
177     uint256 private transferFee = 0;
178     uint256 private denominator = 10000;
179     address internal constant DEAD = 0x685eCB6F4b27D86142dED37173ddc8e6250cCc32;
180     address internal development_receiver = 0x44a9f49C29C9543c31BD9bc8712410D8DBdB0b54; 
181     address internal marketing_receiver = 0x44a9f49C29C9543c31BD9bc8712410D8DBdB0b54;
182     address internal liquidity_receiver = 0x44a9f49C29C9543c31BD9bc8712410D8DBdB0b54;
183     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
184     uint256 public _maxSellAmount = ( _totalSupply * 200 ) / 10000;
185     uint256 public _maxWalletToken = ( _totalSupply * 200 ) / 10000;
186 
187     constructor() Ownable(msg.sender) {
188         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
189         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
190         router = _router; pair = _pair;
191         isFeeExempt[address(this)] = true;
192         isFeeExempt[liquidity_receiver] = true;
193         isFeeExempt[marketing_receiver] = true;
194         isFeeExempt[development_receiver] = true;
195         isFeeExempt[msg.sender] = true;
196         _balances[development_receiver] = _totalSupply;
197         emit Transfer(address(0), development_receiver, _totalSupply);
198     }
199 
200     receive() external payable {}
201     function name() public pure returns (string memory) {return _name;}
202     function symbol() public pure returns (string memory) {return _symbol;}
203     function decimals() public pure returns (uint8) {return _decimals;}
204     function startTrading() external onlyOwner {tradingAllowed = true;}
205     function getOwner() external view override returns (address) { return owner; }
206     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
207     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
208     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
209     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
210     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
211     function totalSupply() public view returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
212 
213     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
214         bool aboveMin = amount >= minTokenAmount;
215         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
216         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
217     }
218 
219     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
220         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
221         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
222     }
223 
224     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
225         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
226         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
227     }
228 
229     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
230         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
231         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
232         uint256 limit = totalSupply().mul(5).div(1000);
233         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
234     }
235 
236     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
237         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
238         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
239     }
240 
241 
242     function manualSwap() external onlyOwner {
243         uint256 amount = balanceOf(address(this));
244         if(amount > swapThreshold){amount = swapThreshold;}
245         swapAndLiquify(amount);
246     }
247 
248     function rescueERC20(address _address, uint256 percent) external onlyOwner {
249         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
250         IERC20(_address).transfer(development_receiver, _amount);
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
265         uint256 contractBalance = address(this).balance;
266         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
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
293     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
294         return !isFeeExempt[sender] && !isFeeExempt[recipient];
295     }
296 
297     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
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
308         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
309         return amount.sub(feeAmount);} return amount;
310     }
311 
312     function _transfer(address sender, address recipient, uint256 amount) private {
313         require(sender != address(0), "ERC20: transfer from the zero address");
314         require(recipient != address(0), "ERC20: transfer to the zero address");
315         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
316         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
317         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
318         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
319         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
320         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
321         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
322         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
323         _balances[sender] = _balances[sender].sub(amount);
324         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
325         _balances[recipient] = _balances[recipient].add(amountReceived);
326         emit Transfer(sender, recipient, amountReceived);
327     }
328 
329     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
330         _transfer(sender, recipient, amount);
331         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
332         return true;
333     }
334 
335     function _approve(address owner, address spender, uint256 amount) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341 }