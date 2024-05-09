1 /**
2 
3 
4 现在转做科太币
5 https://t.me/ketaicoineth
6 */
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.19;
11 
12 
13 library SafeMath {
14 
15     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
16         unchecked {
17             uint256 c = a + b;
18             if (c < a) return (false, 0);
19             return (true, c);
20         }
21     }
22 
23     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             if (b > a) return (false, 0);
26             return (true, a - b);
27         }
28     }
29 
30     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             if (a == 0) return (true, 0);
33             uint256 c = a * b;
34             if (c / a != b) return (false, 0);
35             return (true, c);
36         }
37     }
38 
39     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b == 0) return (false, 0);
42             return (true, a / b);
43         }
44     }
45 
46     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b == 0) return (false, 0);
49             return (true, a % b);
50         }
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a + b;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a - b;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a * b;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a / b;
67     }
68 
69     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a % b;
71     }
72 
73     function sub(
74         uint256 a,
75         uint256 b,
76         string memory errorMessage
77     ) internal pure returns (uint256) {
78         unchecked {
79             require(b <= a, errorMessage);
80             return a - b;
81         }
82     }
83 
84     function div(
85         uint256 a,
86         uint256 b,
87         string memory errorMessage
88     ) internal pure returns (uint256) {
89         unchecked {
90             require(b > 0, errorMessage);
91             return a / b;
92         }
93     }
94 
95     function mod(
96         uint256 a,
97         uint256 b,
98         string memory errorMessage
99     ) internal pure returns (uint256) {
100         unchecked {
101             require(b > 0, errorMessage);
102             return a % b;
103         }
104     }
105 }
106 
107 interface IERC20 {
108     function decimals() external view returns (uint8);
109     function symbol() external view returns (string memory);
110     function name() external view returns (string memory);
111     function getOwner() external view returns (address);
112     function totalSupply() external view returns (uint256);
113     function balanceOf(address account) external view returns (uint256);
114     function transfer(address recipient, uint256 amount) external returns (bool);
115     function allowance(address _owner, address spender) external view returns (uint256);
116     function approve(address spender, uint256 amount) external returns (bool);
117     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     event Approval(address indexed owner, address indexed spender, uint256 value);}
120 
121 abstract contract Ownable {
122     address internal owner;
123     constructor(address _owner) {owner = _owner;}
124     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
125     function isOwner(address account) public view returns (bool) {return account == owner;}
126     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
127     event OwnershipTransferred(address owner);
128 }
129 
130 interface IFactory{
131         function createPair(address tokenA, address tokenB) external returns (address pair);
132         function getPair(address tokenA, address tokenB) external view returns (address pair);
133 }
134 
135 interface IRouter {
136     function factory() external pure returns (address);
137     function WETH() external pure returns (address);
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 
147     function swapExactTokensForETHSupportingFeeOnTransferTokens(
148         uint amountIn,
149         uint amountOutMin,
150         address[] calldata path,
151         address to,
152         uint deadline) external;
153 }
154 
155 contract  Ethereum is IERC20, Ownable {
156     using SafeMath for uint256;
157     string private constant _name = ' Ethereum';
158     string private constant _symbol = unicode'科太币';
159     uint8 private constant _decimals = 9;
160     uint256 private _totalSupply = 420690000000000 * (10 ** _decimals);
161     mapping (address => uint256) _balances;
162     mapping (address => mapping (address => uint256)) private _allowances;
163     mapping (address => bool) public isFeeExempt;
164     mapping (address => bool) private isBot;
165     IRouter router;
166     address public pair;
167     bool private tradingAllowed = false;
168     bool private swapEnabled = true;
169     uint256 private swapTimes;
170     bool private swapping;
171     uint256 swapAmount = 1;
172     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
173     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
174     modifier lockTheSwap {swapping = true; _; swapping = false;}
175     uint256 private liquidityFee = 0;
176     uint256 private marketingFee = 0;
177     uint256 private developmentFee = 1000;
178     uint256 private burnFee = 0;
179     uint256 private totalFee = 3500;
180     uint256 private sellFee = 4500;
181     uint256 private transferFee = 4500;
182     uint256 private denominator = 10000;
183     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
184     address internal development_receiver = 0x9ca414d5085FcE4243900EF45A6cdc026ba62C8A; 
185     address internal marketing_receiver = 0x9ca414d5085FcE4243900EF45A6cdc026ba62C8A;
186     address internal liquidity_receiver = 0x9ca414d5085FcE4243900EF45A6cdc026ba62C8A;
187     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
188     uint256 public _maxSellAmount = ( _totalSupply * 300 ) / 10000;
189     uint256 public _maxWalletToken = ( _totalSupply * 300 ) / 10000;
190 
191     constructor() Ownable(msg.sender) {
192         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
194         router = _router; pair = _pair;
195         isFeeExempt[address(this)] = true;
196         isFeeExempt[liquidity_receiver] = true;
197         isFeeExempt[marketing_receiver] = true;
198         isFeeExempt[development_receiver] = true;
199         isFeeExempt[msg.sender] = true;
200         _balances[msg.sender] = _totalSupply;
201         emit Transfer(address(0), msg.sender, _totalSupply);
202     }
203 
204     receive() external payable {}
205     function name() public pure returns (string memory) {return _name;}
206     function symbol() public pure returns (string memory) {return _symbol;}
207     function decimals() public pure returns (uint8) {return _decimals;}
208     function startTrading() external onlyOwner {tradingAllowed = true;}
209     function getOwner() external view override returns (address) { return owner; }
210     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
211     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
212     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
213     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
214     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
215     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
216 
217     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
218         bool aboveMin = amount >= minTokenAmount;
219         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
220         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
221     }
222 
223     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
224         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
225         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
226     }
227 
228     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
229         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
230         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
231     }
232 
233     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
234         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
235         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
236         uint256 limit = totalSupply().mul(5).div(1000);
237         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
238     }
239 
240     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
241         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
242         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
243     }
244 
245     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
246         for(uint i=0; i < addresses.length; i++){
247         isBot[addresses[i]] = _enabled; }
248     }
249 
250     function manualSwap() external onlyOwner {
251         swapAndLiquify(swapThreshold);
252     }
253 
254     function rescueERC20(address _address, uint256 percent) external onlyOwner {
255         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
256         IERC20(_address).transfer(development_receiver, _amount);
257     }
258 
259     function swapAndLiquify(uint256 tokens) private lockTheSwap {
260         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
261         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
262         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
263         uint256 initialBalance = address(this).balance;
264         swapTokensForETH(toSwap);
265         uint256 deltaBalance = address(this).balance.sub(initialBalance);
266         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
267         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
268         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
269         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
270         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
271         uint256 contractBalance = address(this).balance;
272         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
273     }
274 
275     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
276         _approve(address(this), address(router), tokenAmount);
277         router.addLiquidityETH{value: ETHAmount}(
278             address(this),
279             tokenAmount,
280             0,
281             0,
282             liquidity_receiver,
283             block.timestamp);
284     }
285 
286     function swapTokensForETH(uint256 tokenAmount) private {
287         address[] memory path = new address[](2);
288         path[0] = address(this);
289         path[1] = router.WETH();
290         _approve(address(this), address(router), tokenAmount);
291         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
292             tokenAmount,
293             0,
294             path,
295             address(this),
296             block.timestamp);
297     }
298 
299     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
300         return !isFeeExempt[sender] && !isFeeExempt[recipient];
301     }
302 
303     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
304         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
305         if(recipient == pair){return sellFee;}
306         if(sender == pair){return totalFee;}
307         return transferFee;
308     }
309 
310     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
311         if(getTotalFee(sender, recipient) > 0){
312         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
313         _balances[address(this)] = _balances[address(this)].add(feeAmount);
314         emit Transfer(sender, address(this), feeAmount);
315         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
316         return amount.sub(feeAmount);} return amount;
317     }
318 
319     function _transfer(address sender, address recipient, uint256 amount) private {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
323         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
324         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
325         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
326         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
327         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
328         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
329         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
330         _balances[sender] = _balances[sender].sub(amount);
331         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
332         _balances[recipient] = _balances[recipient].add(amountReceived);
333         emit Transfer(sender, recipient, amountReceived);
334     }
335 
336     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
337         _transfer(sender, recipient, amount);
338         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
339         return true;
340     }
341 
342     function _approve(address owner, address spender, uint256 amount) private {
343         require(owner != address(0), "ERC20: approve from the zero address");
344         require(spender != address(0), "ERC20: approve to the zero address");
345         _allowances[owner][spender] = amount;
346         emit Approval(owner, spender, amount);
347     }
348 
349 }