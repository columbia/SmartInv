1 /**
2  *Submitted for verification at Etherscan.io on 2023-09-26
3 */
4 
5 /**
6 
7 WHO CONTROLS THE MEMES, CONTROLS THE UNIVERSE
8 
9 https://x.com/xx_xiuxian
10 
11 https://www.xxcoin.me
12 
13 42 The answer to Life, the universe and Everything
14 
15 
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity 0.8.19;
21 
22 
23 library SafeMath {
24 
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37         }
38     }
39 
40     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {
42             if (a == 0) return (true, 0);
43             uint256 c = a * b;
44             if (c / a != b) return (false, 0);
45             return (true, c);
46         }
47     }
48 
49     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             if (b == 0) return (false, 0);
52             return (true, a / b);
53         }
54     }
55 
56     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         unchecked {
58             if (b == 0) return (false, 0);
59             return (true, a % b);
60         }
61     }
62 
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a + b;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a - b;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a * b;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return a / b;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a % b;
81     }
82 
83     function sub(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         unchecked {
89             require(b <= a, errorMessage);
90             return a - b;
91         }
92     }
93 
94     function div(
95         uint256 a,
96         uint256 b,
97         string memory errorMessage
98     ) internal pure returns (uint256) {
99         unchecked {
100             require(b > 0, errorMessage);
101             return a / b;
102         }
103     }
104 
105     function mod(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         unchecked {
111             require(b > 0, errorMessage);
112             return a % b;
113         }
114     }
115 }
116 
117 interface IERC20 {
118     function decimals() external view returns (uint8);
119     function symbol() external view returns (string memory);
120     function name() external view returns (string memory);
121     function getOwner() external view returns (address);
122     function totalSupply() external view returns (uint256);
123     function balanceOf(address account) external view returns (uint256);
124     function transfer(address recipient, uint256 amount) external returns (bool);
125     function allowance(address _owner, address spender) external view returns (uint256);
126     function approve(address spender, uint256 amount) external returns (bool);
127     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
128     event Transfer(address indexed from, address indexed to, uint256 value);
129     event Approval(address indexed owner, address indexed spender, uint256 value);}
130 
131 abstract contract Ownable {
132     address internal owner;
133     constructor(address _owner) {owner = _owner;}
134     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
135     function isOwner(address account) public view returns (bool) {return account == owner;}
136     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
137     event OwnershipTransferred(address owner);
138 }
139 
140 interface IFactory{
141         function createPair(address tokenA, address tokenB) external returns (address pair);
142         function getPair(address tokenA, address tokenB) external view returns (address pair);
143 }
144 
145 interface IRouter {
146     function factory() external pure returns (address);
147     function WETH() external pure returns (address);
148     function addLiquidityETH(
149         address token,
150         uint amountTokenDesired,
151         uint amountTokenMin,
152         uint amountETHMin,
153         address to,
154         uint deadline
155     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
156 
157     function swapExactTokensForETHSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline) external;
163 }
164 
165 contract XXCOIN is IERC20, Ownable {
166     using SafeMath for uint256;
167     string private constant _name = 'XXCOIN';
168     string private constant _symbol = 'XX';
169     uint8 private constant _decimals = 9;
170     uint256 private _totalSupply = 42069000000000 * (10 ** _decimals);
171     mapping (address => uint256) _balances;
172     mapping (address => mapping (address => uint256)) private _allowances;
173     mapping (address => bool) public isFeeExempt;
174     mapping (address => bool) private isBot;
175     IRouter router;
176     address public pair;
177     bool private tradingAllowed = false;
178     bool private swapEnabled = true;
179     uint256 private swapTimes;
180     bool private swapping;
181     uint256 swapAmount = 1;
182     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
183     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
184     modifier lockTheSwap {swapping = true; _; swapping = false;}
185     uint256 private liquidityFee = 0;
186     uint256 private marketingFee = 0;
187     uint256 private developmentFee = 1000;
188     uint256 private burnFee = 0;
189     uint256 private totalFee = 3000;
190     uint256 private sellFee = 7000;
191     uint256 private transferFee = 7000;
192     uint256 private denominator = 10000;
193     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
194     address internal development_receiver = 0xDa7de5F98eAF22538562Ef9f430292aBC78C6Edf; 
195     address internal marketing_receiver = 0xDa7de5F98eAF22538562Ef9f430292aBC78C6Edf;
196     address internal liquidity_receiver = 0xDa7de5F98eAF22538562Ef9f430292aBC78C6Edf;
197     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
198     uint256 public _maxSellAmount = ( _totalSupply * 300 ) / 10000;
199     uint256 public _maxWalletToken = ( _totalSupply * 300 ) / 10000;
200 
201     constructor() Ownable(msg.sender) {
202         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
203         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
204         router = _router; pair = _pair;
205         isFeeExempt[address(this)] = true;
206         isFeeExempt[liquidity_receiver] = true;
207         isFeeExempt[marketing_receiver] = true;
208         isFeeExempt[development_receiver] = true;
209         isFeeExempt[msg.sender] = true;
210         _balances[msg.sender] = _totalSupply;
211         emit Transfer(address(0), msg.sender, _totalSupply);
212     }
213 
214     receive() external payable {}
215     function name() public pure returns (string memory) {return _name;}
216     function symbol() public pure returns (string memory) {return _symbol;}
217     function decimals() public pure returns (uint8) {return _decimals;}
218     function startTrading() external onlyOwner {tradingAllowed = true;}
219     function getOwner() external view override returns (address) { return owner; }
220     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
221     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
222     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
223     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
224     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
225     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
226 
227     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
228         bool aboveMin = amount >= minTokenAmount;
229         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
230         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
231     }
232 
233     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
234         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
235         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
236     }
237 
238     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
239         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
240         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
241     }
242 
243     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
244         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
245         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
246         uint256 limit = totalSupply().mul(5).div(1000);
247         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
248     }
249 
250     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
251         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
252         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
253     }
254 
255     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
256         for(uint i=0; i < addresses.length; i++){
257         isBot[addresses[i]] = _enabled; }
258     }
259 
260     function manualSwap() external onlyOwner {
261         swapAndLiquify(swapThreshold);
262     }
263 
264     function rescueERC20(address _address, uint256 percent) external onlyOwner {
265         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
266         IERC20(_address).transfer(development_receiver, _amount);
267     }
268 
269     function swapAndLiquify(uint256 tokens) private lockTheSwap {
270         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
271         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
272         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
273         uint256 initialBalance = address(this).balance;
274         swapTokensForETH(toSwap);
275         uint256 deltaBalance = address(this).balance.sub(initialBalance);
276         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
277         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
278         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
279         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
280         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
281         uint256 contractBalance = address(this).balance;
282         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
283     }
284 
285     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
286         _approve(address(this), address(router), tokenAmount);
287         router.addLiquidityETH{value: ETHAmount}(
288             address(this),
289             tokenAmount,
290             0,
291             0,
292             liquidity_receiver,
293             block.timestamp);
294     }
295 
296     function swapTokensForETH(uint256 tokenAmount) private {
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = router.WETH();
300         _approve(address(this), address(router), tokenAmount);
301         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp);
307     }
308 
309     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
310         return !isFeeExempt[sender] && !isFeeExempt[recipient];
311     }
312 
313     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
314         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
315         if(recipient == pair){return sellFee;}
316         if(sender == pair){return totalFee;}
317         return transferFee;
318     }
319 
320     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
321         if(getTotalFee(sender, recipient) > 0){
322         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
323         _balances[address(this)] = _balances[address(this)].add(feeAmount);
324         emit Transfer(sender, address(this), feeAmount);
325         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
326         return amount.sub(feeAmount);} return amount;
327     }
328 
329     function _transfer(address sender, address recipient, uint256 amount) private {
330         require(sender != address(0), "ERC20: transfer from the zero address");
331         require(recipient != address(0), "ERC20: transfer to the zero address");
332         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
333         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
334         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
335         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
336         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
337         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
338         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
339         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
340         _balances[sender] = _balances[sender].sub(amount);
341         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
342         _balances[recipient] = _balances[recipient].add(amountReceived);
343         emit Transfer(sender, recipient, amountReceived);
344     }
345 
346     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
347         _transfer(sender, recipient, amount);
348         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
349         return true;
350     }
351 
352     function _approve(address owner, address spender, uint256 amount) private {
353         require(owner != address(0), "ERC20: approve from the zero address");
354         require(spender != address(0), "ERC20: approve to the zero address");
355         _allowances[owner][spender] = amount;
356         emit Approval(owner, spender, amount);
357     }
358 
359 }