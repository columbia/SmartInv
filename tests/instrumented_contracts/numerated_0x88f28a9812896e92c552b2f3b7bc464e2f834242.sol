1 /**
2 Lily Coin $LILY
3 
4 Pauly0x keeps tweeting pepe and purple emojis. Purple means feminity. Which can mean it is a female pepe. 
5 
6 He posted “Lily” plant which can mean that its name is “Lily” which is perfect for a female name. Hence, Lily the female pepe.
7 
8 // https://t.me/lilycoin
9 // https://twitter.com/lilycoinerc
10 // https://lilycoin.org/
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity 0.8.19;
17 
18 
19 library SafeMath {
20 
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             uint256 c = a + b;
24             if (c < a) return (false, 0);
25             return (true, c);
26         }
27     }
28 
29     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             if (b > a) return (false, 0);
32             return (true, a - b);
33         }
34     }
35 
36     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (a == 0) return (true, 0);
39             uint256 c = a * b;
40             if (c / a != b) return (false, 0);
41             return (true, c);
42         }
43     }
44 
45     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             if (b == 0) return (false, 0);
48             return (true, a / b);
49         }
50     }
51 
52     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
53         unchecked {
54             if (b == 0) return (false, 0);
55             return (true, a % b);
56         }
57     }
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a + b;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a - b;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a * b;
69     }
70 
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a / b;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a % b;
77     }
78 
79     function sub(
80         uint256 a,
81         uint256 b,
82         string memory errorMessage
83     ) internal pure returns (uint256) {
84         unchecked {
85             require(b <= a, errorMessage);
86             return a - b;
87         }
88     }
89 
90     function div(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         unchecked {
96             require(b > 0, errorMessage);
97             return a / b;
98         }
99     }
100 
101     function mod(
102         uint256 a,
103         uint256 b,
104         string memory errorMessage
105     ) internal pure returns (uint256) {
106         unchecked {
107             require(b > 0, errorMessage);
108             return a % b;
109         }
110     }
111 }
112 
113 interface IERC20 {
114     function decimals() external view returns (uint8);
115     function symbol() external view returns (string memory);
116     function name() external view returns (string memory);
117     function getOwner() external view returns (address);
118     function totalSupply() external view returns (uint256);
119     function balanceOf(address account) external view returns (uint256);
120     function transfer(address recipient, uint256 amount) external returns (bool);
121     function allowance(address _owner, address spender) external view returns (uint256);
122     function approve(address spender, uint256 amount) external returns (bool);
123     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
124     event Transfer(address indexed from, address indexed to, uint256 value);
125     event Approval(address indexed owner, address indexed spender, uint256 value);}
126 
127 abstract contract Ownable {
128     address internal owner;
129     constructor(address _owner) {owner = _owner;}
130     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
131     function isOwner(address account) public view returns (bool) {return account == owner;}
132     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
133     event OwnershipTransferred(address owner);
134 }
135 
136 interface IFactory{
137         function createPair(address tokenA, address tokenB) external returns (address pair);
138         function getPair(address tokenA, address tokenB) external view returns (address pair);
139 }
140 
141 interface IRouter {
142     function factory() external pure returns (address);
143     function WETH() external pure returns (address);
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152 
153     function swapExactTokensForETHSupportingFeeOnTransferTokens(
154         uint amountIn,
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline) external;
159 }
160 
161 contract Lily is IERC20, Ownable {
162     using SafeMath for uint256;
163     string private constant _name = 'Lily';
164     string private constant _symbol = 'LILY';
165     uint8 private constant _decimals = 9;
166     uint256 private _totalSupply = 10000000000 * (10 ** _decimals);
167     mapping (address => uint256) _balances;
168     mapping (address => mapping (address => uint256)) private _allowances;
169     mapping (address => bool) public isFeeExempt;
170     mapping (address => bool) private isBot;
171     IRouter router;
172     address public pair;
173     bool private tradingAllowed = false;
174     bool private swapEnabled = true;
175     uint256 private swapTimes;
176     bool private swapping;
177     uint256 swapAmount = 4;
178     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
179     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
180     modifier lockTheSwap {swapping = true; _; swapping = false;}
181     uint256 private liquidityFee = 0;
182     uint256 private marketingFee = 500;
183     uint256 private developmentFee = 500;
184     uint256 private burnFee = 0;
185     uint256 private totalFee = 3000;
186     uint256 private sellFee = 6000;
187     uint256 private transferFee = 6000;
188     uint256 private denominator = 10000;
189     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
190     address internal development_receiver = 0x2982910C579867580D16F252c57e778EFE31A365; 
191     address internal marketing_receiver = 0x2982910C579867580D16F252c57e778EFE31A365;
192     address internal liquidity_receiver = 0x2982910C579867580D16F252c57e778EFE31A365;
193     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
194     uint256 public _maxSellAmount = ( _totalSupply * 200 ) / 10000;
195     uint256 public _maxWalletToken = ( _totalSupply * 200 ) / 10000;
196 
197     constructor() Ownable(msg.sender) {
198         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
199         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
200         router = _router; pair = _pair;
201         isFeeExempt[address(this)] = true;
202         isFeeExempt[liquidity_receiver] = true;
203         isFeeExempt[marketing_receiver] = true;
204         isFeeExempt[development_receiver] = true;
205         isFeeExempt[msg.sender] = true;
206         _balances[msg.sender] = _totalSupply;
207         emit Transfer(address(0), msg.sender, _totalSupply);
208     }
209 
210     receive() external payable {}
211     function name() public pure returns (string memory) {return _name;}
212     function symbol() public pure returns (string memory) {return _symbol;}
213     function decimals() public pure returns (uint8) {return _decimals;}
214     function startTrading() external onlyOwner {tradingAllowed = true;}
215     function getOwner() external view override returns (address) { return owner; }
216     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
217     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
218     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
219     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
220     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
221     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
222 
223     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
224         bool aboveMin = amount >= minTokenAmount;
225         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
226         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
227     }
228 
229     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
230         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
231         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
232     }
233 
234     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
235         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
236         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
237     }
238 
239     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
240         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
241         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
242         uint256 limit = totalSupply().mul(5).div(1000);
243         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
244     }
245 
246     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
247         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
248         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
249     }
250 
251     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
252         for(uint i=0; i < addresses.length; i++){
253         isBot[addresses[i]] = _enabled; }
254     }
255 
256     function manualSwap() external onlyOwner {
257         uint256 amount = balanceOf(address(this));
258         if(amount > swapThreshold){amount = swapThreshold;}
259         swapAndLiquify(amount);
260     }
261 
262     function rescueERC20(address _address, uint256 percent) external onlyOwner {
263         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
264         IERC20(_address).transfer(development_receiver, _amount);
265     }
266 
267     function swapAndLiquify(uint256 tokens) private lockTheSwap {
268         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
269         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
270         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
271         uint256 initialBalance = address(this).balance;
272         swapTokensForETH(toSwap);
273         uint256 deltaBalance = address(this).balance.sub(initialBalance);
274         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
275         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
276         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
277         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
278         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
279         uint256 contractBalance = address(this).balance;
280         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
281     }
282 
283     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
284         _approve(address(this), address(router), tokenAmount);
285         router.addLiquidityETH{value: ETHAmount}(
286             address(this),
287             tokenAmount,
288             0,
289             0,
290             liquidity_receiver,
291             block.timestamp);
292     }
293 
294     function swapTokensForETH(uint256 tokenAmount) private {
295         address[] memory path = new address[](2);
296         path[0] = address(this);
297         path[1] = router.WETH();
298         _approve(address(this), address(router), tokenAmount);
299         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
300             tokenAmount,
301             0,
302             path,
303             address(this),
304             block.timestamp);
305     }
306 
307     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
308         return !isFeeExempt[sender] && !isFeeExempt[recipient];
309     }
310 
311     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
312         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
313         if(recipient == pair){return sellFee;}
314         if(sender == pair){return totalFee;}
315         return transferFee;
316     }
317 
318     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
319         if(getTotalFee(sender, recipient) > 0){
320         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
321         _balances[address(this)] = _balances[address(this)].add(feeAmount);
322         emit Transfer(sender, address(this), feeAmount);
323         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
324         return amount.sub(feeAmount);} return amount;
325     }
326 
327     function _transfer(address sender, address recipient, uint256 amount) private {
328         require(sender != address(0), "ERC20: transfer from the zero address");
329         require(recipient != address(0), "ERC20: transfer to the zero address");
330         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
331         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
332         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
333         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
334         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
335         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
336         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
337         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
338         _balances[sender] = _balances[sender].sub(amount);
339         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
340         _balances[recipient] = _balances[recipient].add(amountReceived);
341         emit Transfer(sender, recipient, amountReceived);
342     }
343 
344     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
345         _transfer(sender, recipient, amount);
346         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
347         return true;
348     }
349 
350     function _approve(address owner, address spender, uint256 amount) private {
351         require(owner != address(0), "ERC20: approve from the zero address");
352         require(spender != address(0), "ERC20: approve to the zero address");
353         _allowances[owner][spender] = amount;
354         emit Approval(owner, spender, amount);
355     }
356 }