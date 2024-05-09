1 /*
2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@%  #@@@@@   *@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&  ,@@@   @@@@@/      &@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.  /@.  &@@&  *@@@@@         @@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@@@@@@@@@@@@@   *@@@@@@@@@@@@@@@@@@#          %@@@@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@@@@@@@@*@@@@@@@@@@@@@@@@@@@@@@@@@@          #@@@@@@@@@@@@@@@@@@@@@
17 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(     &@@@@@@@@@@@@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    *@@@@@@@@@@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
29 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
30 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
31 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
32 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
33 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
34 
35 
36 Website: https://www.swiftbot.io/
37 Twitter: https://x.com/swiftecosystem?s=21
38 Telegram: https://t.me/+qc21Ci7uWbJjOGJk
39 
40 */
41 // SPDX-License-Identifier: MIT
42 
43 pragma solidity 0.8.19;
44 
45 
46 library SafeMath {
47 
48     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             uint256 c = a + b;
51             if (c < a) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             if (b > a) return (false, 0);
59             return (true, a - b);
60         }
61     }
62 
63     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             if (a == 0) return (true, 0);
66             uint256 c = a * b;
67             if (c / a != b) return (false, 0);
68             return (true, c);
69         }
70     }
71 
72     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         unchecked {
74             if (b == 0) return (false, 0);
75             return (true, a / b);
76         }
77     }
78 
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     function add(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a + b;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return a - b;
92     }
93 
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a * b;
96     }
97 
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a / b;
100     }
101 
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a % b;
104     }
105 
106     function sub(
107         uint256 a,
108         uint256 b,
109         string memory errorMessage
110     ) internal pure returns (uint256) {
111         unchecked {
112             require(b <= a, errorMessage);
113             return a - b;
114         }
115     }
116 
117     function div(
118         uint256 a,
119         uint256 b,
120         string memory errorMessage
121     ) internal pure returns (uint256) {
122         unchecked {
123             require(b > 0, errorMessage);
124             return a / b;
125         }
126     }
127 
128     function mod(
129         uint256 a,
130         uint256 b,
131         string memory errorMessage
132     ) internal pure returns (uint256) {
133         unchecked {
134             require(b > 0, errorMessage);
135             return a % b;
136         }
137     }
138 }
139 
140 interface IERC20 {
141     function decimals() external view returns (uint8);
142     function symbol() external view returns (string memory);
143     function name() external view returns (string memory);
144     function getOwner() external view returns (address);
145     function totalSupply() external view returns (uint256);
146     function balanceOf(address account) external view returns (uint256);
147     function transfer(address recipient, uint256 amount) external returns (bool);
148     function allowance(address _owner, address spender) external view returns (uint256);
149     function approve(address spender, uint256 amount) external returns (bool);
150     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
151     event Transfer(address indexed from, address indexed to, uint256 value);
152     event Approval(address indexed owner, address indexed spender, uint256 value);}
153 
154 abstract contract Ownable {
155     address internal owner;
156     constructor(address _owner) {owner = _owner;}
157     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
158     function isOwner(address account) public view returns (bool) {return account == owner;}
159     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
160     event OwnershipTransferred(address owner);
161 }
162 
163 interface IFactory{
164         function createPair(address tokenA, address tokenB) external returns (address pair);
165         function getPair(address tokenA, address tokenB) external view returns (address pair);
166 }
167 
168 interface IRouter {
169     function factory() external pure returns (address);
170     function WETH() external pure returns (address);
171     function addLiquidityETH(
172         address token,
173         uint amountTokenDesired,
174         uint amountTokenMin,
175         uint amountETHMin,
176         address to,
177         uint deadline
178     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
179 
180     function swapExactTokensForETHSupportingFeeOnTransferTokens(
181         uint amountIn,
182         uint amountOutMin,
183         address[] calldata path,
184         address to,
185         uint deadline) external;
186 }
187 
188 contract Swift is IERC20, Ownable {
189     using SafeMath for uint256;
190     string private constant _name = 'Swift';
191     string private constant _symbol = unicode'SWIFT';
192     uint8 private constant _decimals = 18;
193     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
194     mapping (address => uint256) _balances;
195     mapping (address => mapping (address => uint256)) private _allowances;
196     mapping (address => bool) public isFeeExempt;
197     mapping (address => bool) private isBot;
198     IRouter router;
199     address public pair;
200     bool private tradingAllowed = false;
201     bool private swapEnabled = true;
202     uint256 private swapTimes;
203     bool private swapping;
204     uint256 swapAmount = 1;
205     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
206     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
207     modifier lockTheSwap {swapping = true; _; swapping = false;}
208     uint256 private liquidityFee = 0;
209     uint256 private marketingFee = 1500;
210     uint256 private developmentFee = 1500;
211     uint256 private burnFee = 0;
212     uint256 private totalFee = 3000;
213     uint256 private sellFee = 6000;
214     uint256 private transferFee = 6000;
215     uint256 private denominator = 10000;
216     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
217     address internal development_receiver = 0xAF306498b1f88CE86d4AaFFd4871b557AAd2Aa59; 
218     address internal marketing_receiver = 0xAF306498b1f88CE86d4AaFFd4871b557AAd2Aa59;
219     address internal liquidity_receiver = 0xAF306498b1f88CE86d4AaFFd4871b557AAd2Aa59;
220     uint256 public _maxTxAmount = ( _totalSupply * 100 ) / 10000;
221     uint256 public _maxSellAmount = ( _totalSupply * 100 ) / 10000;
222     uint256 public _maxWalletToken = ( _totalSupply * 150 ) / 10000;
223 
224     constructor() Ownable(msg.sender) {
225         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
226         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
227         router = _router; pair = _pair;
228         isFeeExempt[address(this)] = true;
229         isFeeExempt[liquidity_receiver] = true;
230         isFeeExempt[marketing_receiver] = true;
231         isFeeExempt[development_receiver] = true;
232         isFeeExempt[msg.sender] = true;
233         _balances[msg.sender] = _totalSupply;
234         emit Transfer(address(0), msg.sender, _totalSupply);
235     }
236 
237     receive() external payable {}
238     function name() public pure returns (string memory) {return _name;}
239     function symbol() public pure returns (string memory) {return _symbol;}
240     function decimals() public pure returns (uint8) {return _decimals;}
241     function startTrading() external onlyOwner {tradingAllowed = true;}
242     function getOwner() external view override returns (address) { return owner; }
243     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
244     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
245     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
246     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
247     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
248     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
249 
250     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
251         bool aboveMin = amount >= minTokenAmount;
252         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
253         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
254     }
255 
256     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
257         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
258         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
259     }
260 
261     function setCAFees(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
262         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
263         require(totalFee <= denominator && sellFee <= denominator && transferFee <= denominator, "totalFee and sellFee cannot be more than 100%");
264     }
265 
266     function setTxLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
267         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
268         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
269         uint256 limit = totalSupply().mul(5).div(1000);
270         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
271     }
272 
273     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
274         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
275         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
276     }
277 
278     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
279         for(uint i=0; i < addresses.length; i++){
280         isBot[addresses[i]] = _enabled; }
281     }
282 
283     function manualSwap() external onlyOwner {
284         swapAndLiquify(swapThreshold);
285     }
286 
287     function rescueERC20(address _address, uint256 percent) external onlyOwner {
288         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
289         IERC20(_address).transfer(development_receiver, _amount);
290     }
291 
292     function swapAndLiquify(uint256 tokens) private lockTheSwap {
293         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
294         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
295         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
296         uint256 initialBalance = address(this).balance;
297         swapTokensForETH(toSwap);
298         uint256 deltaBalance = address(this).balance.sub(initialBalance);
299         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
300         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
301         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
302         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
303         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
304         uint256 contractBalance = address(this).balance;
305         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
306     }
307 
308     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
309         _approve(address(this), address(router), tokenAmount);
310         router.addLiquidityETH{value: ETHAmount}(
311             address(this),
312             tokenAmount,
313             0,
314             0,
315             liquidity_receiver,
316             block.timestamp);
317     }
318 
319     function swapTokensForETH(uint256 tokenAmount) private {
320         address[] memory path = new address[](2);
321         path[0] = address(this);
322         path[1] = router.WETH();
323         _approve(address(this), address(router), tokenAmount);
324         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
325             tokenAmount,
326             0,
327             path,
328             address(this),
329             block.timestamp);
330     }
331 
332     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
333         return !isFeeExempt[sender] && !isFeeExempt[recipient];
334     }
335 
336     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
337         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
338         if(recipient == pair){return sellFee;}
339         if(sender == pair){return totalFee;}
340         return transferFee;
341     }
342 
343     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
344         if(getTotalFee(sender, recipient) > 0){
345         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
346         _balances[address(this)] = _balances[address(this)].add(feeAmount);
347         emit Transfer(sender, address(this), feeAmount);
348         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
349         return amount.sub(feeAmount);} return amount;
350     }
351 
352     function _transfer(address sender, address recipient, uint256 amount) private {
353         require(sender != address(0), "ERC20: transfer from the zero address");
354         require(recipient != address(0), "ERC20: transfer to the zero address");
355         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
356         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
357         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
358         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
359         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
360         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
361         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
362         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
363         _balances[sender] = _balances[sender].sub(amount);
364         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
365         _balances[recipient] = _balances[recipient].add(amountReceived);
366         emit Transfer(sender, recipient, amountReceived);
367     }
368 
369     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
370         _transfer(sender, recipient, amount);
371         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
372         return true;
373     }
374 
375     function _approve(address owner, address spender, uint256 amount) private {
376         require(owner != address(0), "ERC20: approve from the zero address");
377         require(spender != address(0), "ERC20: approve to the zero address");
378         _allowances[owner][spender] = amount;
379         emit Approval(owner, spender, amount);
380     }
381 
382 }