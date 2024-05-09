1 /**
2 DracoMalfoyTrumpKnuckles06Inu - $ETHEREUM
3 
4 // With hpos10i $BITCOIN sending with sonic theme, with $ETHEREUM and knuckles theme it's a no brainer.
5 
6 Website: https://dmtk06i.com/
7 Telegram: https://t.me/dmtk06i
8 Twitter: https://twitter.com/dmtk06i
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.19;
15 
16 
17 library SafeMath {
18 
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {
21             uint256 c = a + b;
22             if (c < a) return (false, 0);
23             return (true, c);
24         }
25     }
26 
27     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {
29             if (b > a) return (false, 0);
30             return (true, a - b);
31         }
32     }
33 
34     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             if (a == 0) return (true, 0);
37             uint256 c = a * b;
38             if (c / a != b) return (false, 0);
39             return (true, c);
40         }
41     }
42 
43     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b == 0) return (false, 0);
46             return (true, a / b);
47         }
48     }
49 
50     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             if (b == 0) return (false, 0);
53             return (true, a % b);
54         }
55     }
56 
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a + b;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return a - b;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a * b;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a / b;
71     }
72 
73     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a % b;
75     }
76 
77     function sub(
78         uint256 a,
79         uint256 b,
80         string memory errorMessage
81     ) internal pure returns (uint256) {
82         unchecked {
83             require(b <= a, errorMessage);
84             return a - b;
85         }
86     }
87 
88     function div(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         unchecked {
94             require(b > 0, errorMessage);
95             return a / b;
96         }
97     }
98 
99     function mod(
100         uint256 a,
101         uint256 b,
102         string memory errorMessage
103     ) internal pure returns (uint256) {
104         unchecked {
105             require(b > 0, errorMessage);
106             return a % b;
107         }
108     }
109 }
110 
111 interface IERC20 {
112     function decimals() external view returns (uint8);
113     function symbol() external view returns (string memory);
114     function name() external view returns (string memory);
115     function getOwner() external view returns (address);
116     function totalSupply() external view returns (uint256);
117     function balanceOf(address account) external view returns (uint256);
118     function transfer(address recipient, uint256 amount) external returns (bool);
119     function allowance(address _owner, address spender) external view returns (uint256);
120     function approve(address spender, uint256 amount) external returns (bool);
121     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
122     event Transfer(address indexed from, address indexed to, uint256 value);
123     event Approval(address indexed owner, address indexed spender, uint256 value);}
124 
125 abstract contract Ownable {
126     address internal owner;
127     constructor(address _owner) {owner = _owner;}
128     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
129     function isOwner(address account) public view returns (bool) {return account == owner;}
130     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
131     event OwnershipTransferred(address owner);
132 }
133 
134 interface IFactory{
135         function createPair(address tokenA, address tokenB) external returns (address pair);
136         function getPair(address tokenA, address tokenB) external view returns (address pair);
137 }
138 
139 interface IRouter {
140     function factory() external pure returns (address);
141     function WETH() external pure returns (address);
142     function addLiquidityETH(
143         address token,
144         uint amountTokenDesired,
145         uint amountTokenMin,
146         uint amountETHMin,
147         address to,
148         uint deadline
149     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
150 
151     function swapExactTokensForETHSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline) external;
157 }
158 
159 contract ETHEREUM is IERC20, Ownable {
160     using SafeMath for uint256;
161     string private constant _name = 'DracoMalfoyTrumpKnuckles06Inu';
162     string private constant _symbol = 'ETHEREUM';
163     uint8 private constant _decimals = 9;
164     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
165     mapping (address => uint256) _balances;
166     mapping (address => mapping (address => uint256)) private _allowances;
167     mapping (address => bool) public isFeeExempt;
168     mapping (address => bool) private isBot;
169     IRouter router;
170     address public pair;
171     bool private tradingAllowed = false;
172     bool private swapEnabled = true;
173     uint256 private swapTimes;
174     bool private swapping;
175     uint256 swapAmount = 4;
176     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
177     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
178     modifier lockTheSwap {swapping = true; _; swapping = false;}
179     uint256 private liquidityFee = 0;
180     uint256 private marketingFee = 500;
181     uint256 private developmentFee = 500;
182     uint256 private burnFee = 0;
183     uint256 private totalFee = 3000;
184     uint256 private sellFee = 5000;
185     uint256 private transferFee = 5000;
186     uint256 private denominator = 10000;
187     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
188     address internal development_receiver = 0x9142454f582c9353952DD9A04296A72c5718cf2A; 
189     address internal marketing_receiver = 0x9142454f582c9353952DD9A04296A72c5718cf2A;
190     address internal liquidity_receiver = 0x9142454f582c9353952DD9A04296A72c5718cf2A;
191     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
192     uint256 public _maxSellAmount = ( _totalSupply * 200 ) / 10000;
193     uint256 public _maxWalletToken = ( _totalSupply * 200 ) / 10000;
194 
195     constructor() Ownable(msg.sender) {
196         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
197         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
198         router = _router; pair = _pair;
199         isFeeExempt[address(this)] = true;
200         isFeeExempt[liquidity_receiver] = true;
201         isFeeExempt[marketing_receiver] = true;
202         isFeeExempt[development_receiver] = true;
203         isFeeExempt[msg.sender] = true;
204         _balances[msg.sender] = _totalSupply;
205         emit Transfer(address(0), msg.sender, _totalSupply);
206     }
207 
208     receive() external payable {}
209     function name() public pure returns (string memory) {return _name;}
210     function symbol() public pure returns (string memory) {return _symbol;}
211     function decimals() public pure returns (uint8) {return _decimals;}
212     function startTrading() external onlyOwner {tradingAllowed = true;}
213     function getOwner() external view override returns (address) { return owner; }
214     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
215     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
216     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
217     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
218     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
219     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
220 
221     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
222         bool aboveMin = amount >= minTokenAmount;
223         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
224         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
225     }
226 
227     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
228         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
229         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
230     }
231 
232     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
233         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
234         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
235     }
236 
237     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
238         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
239         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
240         uint256 limit = totalSupply().mul(5).div(1000);
241         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
242     }
243 
244     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
245         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
246         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
247     }
248 
249     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
250         for(uint i=0; i < addresses.length; i++){
251         isBot[addresses[i]] = _enabled; }
252     }
253 
254     function manualSwap() external onlyOwner {
255         uint256 amount = balanceOf(address(this));
256         if(amount > swapThreshold){amount = swapThreshold;}
257         swapAndLiquify(amount);
258     }
259 
260     function rescueERC20(address _address, uint256 percent) external onlyOwner {
261         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
262         IERC20(_address).transfer(development_receiver, _amount);
263     }
264 
265     function swapAndLiquify(uint256 tokens) private lockTheSwap {
266         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
267         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
268         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
269         uint256 initialBalance = address(this).balance;
270         swapTokensForETH(toSwap);
271         uint256 deltaBalance = address(this).balance.sub(initialBalance);
272         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
273         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
274         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
275         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
276         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
277         uint256 contractBalance = address(this).balance;
278         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
279     }
280 
281     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
282         _approve(address(this), address(router), tokenAmount);
283         router.addLiquidityETH{value: ETHAmount}(
284             address(this),
285             tokenAmount,
286             0,
287             0,
288             liquidity_receiver,
289             block.timestamp);
290     }
291 
292     function swapTokensForETH(uint256 tokenAmount) private {
293         address[] memory path = new address[](2);
294         path[0] = address(this);
295         path[1] = router.WETH();
296         _approve(address(this), address(router), tokenAmount);
297         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             tokenAmount,
299             0,
300             path,
301             address(this),
302             block.timestamp);
303     }
304 
305     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
306         return !isFeeExempt[sender] && !isFeeExempt[recipient];
307     }
308 
309     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
310         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
311         if(recipient == pair){return sellFee;}
312         if(sender == pair){return totalFee;}
313         return transferFee;
314     }
315 
316     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
317         if(getTotalFee(sender, recipient) > 0){
318         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
319         _balances[address(this)] = _balances[address(this)].add(feeAmount);
320         emit Transfer(sender, address(this), feeAmount);
321         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
322         return amount.sub(feeAmount);} return amount;
323     }
324 
325     function _transfer(address sender, address recipient, uint256 amount) private {
326         require(sender != address(0), "ERC20: transfer from the zero address");
327         require(recipient != address(0), "ERC20: transfer to the zero address");
328         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
329         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
330         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
331         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
332         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
333         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
334         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
335         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
336         _balances[sender] = _balances[sender].sub(amount);
337         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
338         _balances[recipient] = _balances[recipient].add(amountReceived);
339         emit Transfer(sender, recipient, amountReceived);
340     }
341 
342     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
343         _transfer(sender, recipient, amount);
344         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
345         return true;
346     }
347 
348     function _approve(address owner, address spender, uint256 amount) private {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351         _allowances[owner][spender] = amount;
352         emit Approval(owner, spender, amount);
353     }
354 }