1 /**
2 
3 $NARUTO the greatest anime coin
4 
5 https://t.me/Naruto_Coin_ERC
6 
7 https://twitter.com/Naruto_Coin_ERC
8 
9 https://www.narutocoin.net/
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.8.19;
16 
17 
18 library SafeMath {
19 
20     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             if (b > a) return (false, 0);
31             return (true, a - b);
32         }
33     }
34 
35     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             if (a == 0) return (true, 0);
38             uint256 c = a * b;
39             if (c / a != b) return (false, 0);
40             return (true, c);
41         }
42     }
43 
44     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b == 0) return (false, 0);
47             return (true, a / b);
48         }
49     }
50 
51     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b == 0) return (false, 0);
54             return (true, a % b);
55         }
56     }
57 
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a + b;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a - b;
64     }
65 
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a * b;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a / b;
72     }
73 
74     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a % b;
76     }
77 
78     function sub(
79         uint256 a,
80         uint256 b,
81         string memory errorMessage
82     ) internal pure returns (uint256) {
83         unchecked {
84             require(b <= a, errorMessage);
85             return a - b;
86         }
87     }
88 
89     function div(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         unchecked {
95             require(b > 0, errorMessage);
96             return a / b;
97         }
98     }
99 
100     function mod(
101         uint256 a,
102         uint256 b,
103         string memory errorMessage
104     ) internal pure returns (uint256) {
105         unchecked {
106             require(b > 0, errorMessage);
107             return a % b;
108         }
109     }
110 }
111 
112 interface IERC20 {
113     function decimals() external view returns (uint8);
114     function symbol() external view returns (string memory);
115     function name() external view returns (string memory);
116     function getOwner() external view returns (address);
117     function totalSupply() external view returns (uint256);
118     function balanceOf(address account) external view returns (uint256);
119     function transfer(address recipient, uint256 amount) external returns (bool);
120     function allowance(address _owner, address spender) external view returns (uint256);
121     function approve(address spender, uint256 amount) external returns (bool);
122     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);}
125 
126 abstract contract Ownable {
127     address internal owner;
128     constructor(address _owner) {owner = _owner;}
129     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
130     function isOwner(address account) public view returns (bool) {return account == owner;}
131     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
132     event OwnershipTransferred(address owner);
133 }
134 
135 interface IFactory{
136         function createPair(address tokenA, address tokenB) external returns (address pair);
137         function getPair(address tokenA, address tokenB) external view returns (address pair);
138 }
139 
140 interface IRouter {
141     function factory() external pure returns (address);
142     function WETH() external pure returns (address);
143     function addLiquidityETH(
144         address token,
145         uint amountTokenDesired,
146         uint amountTokenMin,
147         uint amountETHMin,
148         address to,
149         uint deadline
150     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
151 
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline) external;
158 }
159 
160 contract NARUTO is IERC20, Ownable {
161     using SafeMath for uint256;
162     string private constant _name = 'Naruto';
163     string private constant _symbol = 'NARUTO';
164     uint8 private constant _decimals = 9;
165     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
166     mapping (address => uint256) _balances;
167     mapping (address => mapping (address => uint256)) private _allowances;
168     mapping (address => bool) public isFeeExempt;
169     mapping (address => bool) private isBot;
170     IRouter router;
171     address public pair;
172     bool private tradingAllowed = false;
173     bool private swapEnabled = true;
174     uint256 private swapTimes;
175     bool private swapping;
176     uint256 swapAmount = 1;
177     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
178     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
179     modifier lockTheSwap {swapping = true; _; swapping = false;}
180     uint256 private liquidityFee = 0;
181     uint256 private marketingFee = 0;
182     uint256 private developmentFee = 1000;
183     uint256 private burnFee = 0;
184     uint256 private totalFee = 3000;
185     uint256 private sellFee = 6000;
186     uint256 private transferFee = 7000;
187     uint256 private denominator = 10000;
188     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
189     address internal development_receiver = 0xacEb064B4DEff59E9915F48401b24140889F61A9; 
190     address internal marketing_receiver = 0xacEb064B4DEff59E9915F48401b24140889F61A9;
191     address internal liquidity_receiver = 0xacEb064B4DEff59E9915F48401b24140889F61A9;
192     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
193     uint256 public _maxSellAmount = ( _totalSupply * 300 ) / 10000;
194     uint256 public _maxWalletToken = ( _totalSupply * 300 ) / 10000;
195 
196     constructor() Ownable(msg.sender) {
197         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
198         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
199         router = _router; pair = _pair;
200         isFeeExempt[address(this)] = true;
201         isFeeExempt[liquidity_receiver] = true;
202         isFeeExempt[marketing_receiver] = true;
203         isFeeExempt[development_receiver] = true;
204         isFeeExempt[msg.sender] = true;
205         _balances[msg.sender] = _totalSupply;
206         emit Transfer(address(0), msg.sender, _totalSupply);
207     }
208 
209     receive() external payable {}
210     function name() public pure returns (string memory) {return _name;}
211     function symbol() public pure returns (string memory) {return _symbol;}
212     function decimals() public pure returns (uint8) {return _decimals;}
213     function startTrading() external onlyOwner {tradingAllowed = true;}
214     function getOwner() external view override returns (address) { return owner; }
215     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
216     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
217     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
218     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
219     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
220     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
221 
222     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
223         bool aboveMin = amount >= minTokenAmount;
224         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
225         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
226     }
227 
228     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
229         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
230         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
231     }
232 
233     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
234         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
235         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
236     }
237 
238     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
239         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
240         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
241         uint256 limit = totalSupply().mul(5).div(1000);
242         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
243     }
244 
245     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
246         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
247         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
248     }
249 
250     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
251         for(uint i=0; i < addresses.length; i++){
252         isBot[addresses[i]] = _enabled; }
253     }
254 
255     function manualSwap() external onlyOwner {
256         swapAndLiquify(swapThreshold);
257     }
258 
259     function rescueERC20(address _address, uint256 percent) external onlyOwner {
260         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
261         IERC20(_address).transfer(development_receiver, _amount);
262     }
263 
264     function swapAndLiquify(uint256 tokens) private lockTheSwap {
265         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
266         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
267         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
268         uint256 initialBalance = address(this).balance;
269         swapTokensForETH(toSwap);
270         uint256 deltaBalance = address(this).balance.sub(initialBalance);
271         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
272         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
273         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
274         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
275         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
276         uint256 contractBalance = address(this).balance;
277         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
278     }
279 
280     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
281         _approve(address(this), address(router), tokenAmount);
282         router.addLiquidityETH{value: ETHAmount}(
283             address(this),
284             tokenAmount,
285             0,
286             0,
287             liquidity_receiver,
288             block.timestamp);
289     }
290 
291     function swapTokensForETH(uint256 tokenAmount) private {
292         address[] memory path = new address[](2);
293         path[0] = address(this);
294         path[1] = router.WETH();
295         _approve(address(this), address(router), tokenAmount);
296         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
297             tokenAmount,
298             0,
299             path,
300             address(this),
301             block.timestamp);
302     }
303 
304     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
305         return !isFeeExempt[sender] && !isFeeExempt[recipient];
306     }
307 
308     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
309         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
310         if(recipient == pair){return sellFee;}
311         if(sender == pair){return totalFee;}
312         return transferFee;
313     }
314 
315     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
316         if(getTotalFee(sender, recipient) > 0){
317         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
318         _balances[address(this)] = _balances[address(this)].add(feeAmount);
319         emit Transfer(sender, address(this), feeAmount);
320         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
321         return amount.sub(feeAmount);} return amount;
322     }
323 
324     function _transfer(address sender, address recipient, uint256 amount) private {
325         require(sender != address(0), "ERC20: transfer from the zero address");
326         require(recipient != address(0), "ERC20: transfer to the zero address");
327         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
328         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
329         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
330         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
331         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
332         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
333         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
334         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
335         _balances[sender] = _balances[sender].sub(amount);
336         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
337         _balances[recipient] = _balances[recipient].add(amountReceived);
338         emit Transfer(sender, recipient, amountReceived);
339     }
340 
341     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
342         _transfer(sender, recipient, amount);
343         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
344         return true;
345     }
346 
347     function _approve(address owner, address spender, uint256 amount) private {
348         require(owner != address(0), "ERC20: approve from the zero address");
349         require(spender != address(0), "ERC20: approve to the zero address");
350         _allowances[owner][spender] = amount;
351         emit Approval(owner, spender, amount);
352     }
353 
354 }