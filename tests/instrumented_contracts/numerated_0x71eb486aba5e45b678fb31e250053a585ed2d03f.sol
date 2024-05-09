1 /**
2 
3 
4         ▓▓▓▓▓▓                                                            ▓▓▓▓▓▓      
5       ████████████                                                    ████████████    
6       ██████▓▓██████░░                                            ░░██████▓▓██████    
7       ████░░  ████████                                            ████████  ░░████    
8       ████      ▒▒██████▓▓        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░        ▓▓██████▒▒      ████    
9       ████    ██    ████████████████████████████████████████████████    ██    ████    
10       ████    ████  ██▒▒████████████████████████████████████████▒▒██  ████    ████    
11       ████    ████████▒▒▒▒██████▒▒▒▒▒▒████████████▒▒▒▒▒▒██████▒▒▒▒████████    ████    
12       ████████████████▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒████████▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒████████████████    
13       ████▒▒▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓████████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████▒▒▒▒████    
14       ████▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒████    
15       ████▓▓▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓████████████▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▓▓████    
16       ████████▒▒████▒▒▒▒▒▒▒▒▒▒████████████████████████████▒▒▒▒▒▒▒▒▒▒████▒▒████████    
17       ░░██████▓▓██▒▒▒▒▒▒▒▒▓▓▓▓████████████████████████████▓▓▓▓▒▒▒▒▒▒▒▒██▓▓██████      
18       ██████████▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒████████████████▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██████████    
19         ██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████      
20         ██████▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██████      
21       ▓▓████▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒████▓▓    
22       ████▒▒▒▒▒▒▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▒▒▒▒▒▒████    
23     ░░████▒▒▒▒▓▓████▒▒▒▒▒▒░░░░░░░░▒▒░░▒▒████████▒▒░░▒▒░░░░░░░░▒▒▒▒▒▒████▓▓▒▒▒▒████▓▓  
24     ██████▒▒▒▒████▒▒▒▒▒▒▒▒            ▒▒████████▒▒            ▒▒▒▒▒▒▓▓████▒▒▒▒██████  
25   ░░████▒▒▒▒▒▒████▒▒▒▒░░  ▓▓▓▓▓▓▓▓▒▒    ████████    ▓▓▓▓▓▓▓▓▓▓  ░░▒▒▒▒████▒▒▒▒▒▒██████
26   ██████▒▒▒▒▒▒████▒▒▒▒    ██████████▒▒  ████████  ▒▒██████████    ▒▒▒▒████▒▒▒▒▒▒██████
27   ██████▒▒▒▒▒▒████▓▓▒▒  ░░▒▒████▓▓▓▓██  ████████  ██▒▒▓▓████▒▒░░  ▒▒▓▓████▒▒▒▒▒▒██████
28   ████████▒▒▒▒████████        ████████  ████████  ████████        ████████▒▒▒▒████████
29     ██████▒▒▒▒▒▒██████░░      ░░░░████  ████████  ████░░░░      ░░██████▒▒▒▒▒▒██████░░
30     ████████▒▒▒▒▒▒████████          ██  ████████  ██          ████████▒▒▒▒▒▒████████  
31     ████████████████████████      ██    ████████    ██      ████████████████████████  
32     ██████████████████▒▒████▓▓      ██    ████    ██      ▓▓████▒▒██████████████████  
33     ██  ████████▒▒████▒▒▒▒██████        ████████        ██████▒▒▒▒████▒▒████████  ██  
34           ██████▓▓▒▒████▒▒▒▒████          ████          ████▒▒▒▒████▒▒▓▓██████        
35           ████████▓▓████▒▒▒▒████        ░░████░░        ████▒▒▒▒████▓▓████████        
36           ████████████████▒▒████          ████          ████▒▒████████████████        
37           ██      ██████████████                        ██████████████      ██        
38             ▓▓    ██████████████      ▓▓▓▓▓▓▓▓▓▓▓▓      ██████████████    ▓▓          
39                   ██      ████████    ████████████    ████████      ██                
40                     ▓▓      ██████    ██▒▒████▒▒██    ██████      ▓▓                  
41                             ████████    ████████    ████████                          
42                               ██████▓▓  ░░░░░░░░  ▓▓██████░░                          
43                                 ████████████████████████                              
44                                   ████████████████████                                
45                                   ░░░░████████████░░                                  
46 
47 
48 
49 https://t.me/OkamiInu
50 
51 https://twitter.com/OkamiInuCoin
52 
53 https://www.okamiinucoin.com/
54 */
55 
56 // SPDX-License-Identifier: MIT
57 
58 pragma solidity 0.8.19;
59 
60 
61 library SafeMath {
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
67     
68     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
70 
71     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
73 
74     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
76         if(c / a != b) return(false, 0); return(true, c);}}
77 
78     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
80 
81     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
82         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
83 
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         unchecked{require(b <= a, errorMessage); return a - b;}}
86 
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         unchecked{require(b > 0, errorMessage); return a / b;}}
89 
90     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         unchecked{require(b > 0, errorMessage); return a % b;}}}
92 
93 interface IERC20 {
94     function totalSupply() external view returns (uint256);
95     function circulatingSupply() external view returns (uint256);
96     function decimals() external view returns (uint8);
97     function symbol() external view returns (string memory);
98     function name() external view returns (string memory);
99     function getOwner() external view returns (address);
100     function balanceOf(address account) external view returns (uint256);
101     function transfer(address recipient, uint256 amount) external returns (bool);
102     function allowance(address _owner, address spender) external view returns (uint256);
103     function approve(address spender, uint256 amount) external returns (bool);
104     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
105     event Transfer(address indexed from, address indexed to, uint256 value);
106     event Approval(address indexed owner, address indexed spender, uint256 value);}
107 
108 abstract contract Ownable {
109     address internal owner;
110     constructor(address _owner) {owner = _owner;}
111     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
112     function isOwner(address account) public view returns (bool) {return account == owner;}
113     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
114     event OwnershipTransferred(address owner);
115 }
116 
117 interface AIVolumizer {
118     function tokenVolumeTransaction(address _contract) external;
119     function tokenManualVolumeTransaction(address _contract, uint256 maxAmount, uint256 volumePercentage) external;
120     function setTokenMaxVolumeAmount(address _contract, uint256 maxAmount) external;
121     function setTokenMaxVolumePercent(address _contract, uint256 volumePercentage, uint256 denominator) external;
122     function rescueHubERC20(address token, address receiver, uint256 amount) external;
123     function tokenVaryETHVolumeTransaction(address _contract, uint256 amountAdd, address receiver, bool send) external;
124     function viewProjectTokenParameters(address _contract) external view returns (uint256, uint256, uint256);
125     function veiwVolumeStats(address _contract) external view returns (uint256 totalPurchased, 
126         uint256 totalETH, uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime);
127     function viewLastVolumeBlock(address _contract) external view returns (uint256);
128     function viewTotalTokenPurchased(address _contract) external view returns (uint256);
129     function viewTotalETHPurchased(address _contract) external view returns (uint256);
130     function viewLastETHPurchased(address _contract) external view returns (uint256);
131     function viewLastTokensPurchased(address _contract) external view returns (uint256);
132     function viewTotalTokenVolume(address _contract) external view returns (uint256);
133     function viewLastTokenVolume(address _contract) external view returns (uint256);
134     function viewLastVolumeTimestamp(address _contract) external view returns (uint256);
135     function viewNumberTokenVolumeTxs(address _contract) external view returns (uint256);
136     function viewNumberETHVolumeTxs(address _contract) external view returns (uint256);
137 }
138 
139 interface stakeIntegration {
140     function stakingWithdraw(address depositor, uint256 _amount) external;
141     function stakingDeposit(address depositor, uint256 _amount) external;
142     function stakingClaimToCompound(address sender, address recipient) external;
143 }
144 
145 interface tokenStaking {
146     function deposit(uint256 amount) external;
147     function withdraw(uint256 amount) external;
148     function compound() external;
149 }
150 
151 interface IFactory{
152     function createPair(address tokenA, address tokenB) external returns (address pair);
153     function getPair(address tokenA, address tokenB) external view returns (address pair);
154 }
155 
156 interface IRouter {
157     function factory() external pure returns (address);
158     function WETH() external pure returns (address);
159     
160     function addLiquidityETH(
161         address token,
162         uint amountTokenDesired,
163         uint amountTokenMin,
164         uint amountETHMin,
165         address to,
166         uint deadline
167     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
168 
169     function swapExactTokensForETHSupportingFeeOnTransferTokens(
170         uint amountIn,
171         uint amountOutMin,
172         address[] calldata path,
173         address to,
174         uint deadline
175     ) external;
176 
177     function swapExactETHForTokensSupportingFeeOnTransferTokens(
178         uint amountOutMin,
179         address[] calldata path,
180         address to,
181         uint deadline
182     ) external payable;
183 }
184 
185 contract OkamiInu is IERC20, tokenStaking, Ownable {
186     using SafeMath for uint256;
187     string private constant _name = 'Okami Inu';
188     string private constant _symbol = 'OKAMI';
189     uint8 private constant _decimals = 9;
190     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
191     uint256 public _maxTxAmount = ( _totalSupply * 100 ) / 10000;
192     uint256 public _maxWalletToken = ( _totalSupply * 100 ) / 10000;
193     mapping (address => uint256) _balances;
194     mapping (address => mapping (address => uint256)) private _allowances;
195     mapping(address => bool) public isFeeExempt;
196     IRouter router;
197     address public pair;
198     uint256 private liquidityFee = 0;
199     uint256 private marketingFee = 400;
200     uint256 private developmentFee = 1000;
201     uint256 private buybackFee = 400;
202     uint256 private tairyoFee = 100;
203     uint256 private volumeFee = 100;
204     uint256 private stakingFee = 0;
205     uint256 private totalFee = 2000;
206     uint256 private sellFee = 6000;
207     uint256 private transferFee = 6000;
208     uint256 private denominator = 10000;
209     bool private swapEnabled = true;
210     bool private tradingAllowed = false;
211     bool public volumeToken = true;
212     bool private volumeTx;
213     uint256 public txGas = 500000;
214     uint256 public swapVolumeTimes;
215     uint256 private swapTimes;
216     bool private swapping;
217     uint256 private swapVolumeAmount = 3;
218     uint256 private swapAmount = 1;
219     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
220     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
221     uint256 private minVolumeTokenAmount = ( _totalSupply * 10 ) / 100000;
222     modifier lockTheSwap {swapping = true; _; swapping = false;}
223     mapping(address => bool) public isDevAllowed;
224     mapping(address => bool) public cexPair;
225     mapping(address => uint256) public amountStaked;
226     uint256 public totalStaked; bool public manualVolumeAllowed = false;
227     stakeIntegration internal stakingContract;
228     AIVolumizer volumizer; bool public buybackSend;
229     bool public stakedVolume = true; uint256 public buybackAddAmount;
230     uint256 public amountTokensFunded; uint256 public amountETHBuyback;
231     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
232     address internal development_receiver = 0x71bB329B978D99A13236f8776a9c5F8C1895d113; 
233     address internal marketing_receiver = 0xCF5A4FF2918D186c19F47242B7fd0D92AbdAE289;
234     address internal liquidity_receiver = 0x71bB329B978D99A13236f8776a9c5F8C1895d113;
235     address internal staking_receiver = 0x71bB329B978D99A13236f8776a9c5F8C1895d113;
236     address internal buyback_receiver = 0x71bB329B978D99A13236f8776a9c5F8C1895d113;
237     address internal tairyo_receiver = 0x063541d35981c74F72bE5bd3a0Fafe1b824A1cbb;
238 
239     constructor() Ownable(msg.sender) {
240         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
241         volumizer = AIVolumizer(0xE818B4aFf32625ca4620623Ac4AEccf7CBccc260);
242         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
243         buybackAddAmount = uint256(50000000000000000);
244         router = _router;
245         pair = _pair;
246         isDevAllowed[msg.sender] = true;
247         isFeeExempt[address(this)] = true;
248         isFeeExempt[liquidity_receiver] = true;
249         isFeeExempt[marketing_receiver] = true;
250         isFeeExempt[development_receiver] = true;
251         isFeeExempt[address(DEAD)] = true;
252         isFeeExempt[msg.sender] = true;
253         isFeeExempt[address(volumizer)] = true;
254         _balances[msg.sender] = _totalSupply;
255         emit Transfer(address(0), msg.sender, _totalSupply);
256     }
257 
258     receive() external payable {}
259     function name() public pure returns (string memory) {return _name;}
260     function symbol() public pure returns (string memory) {return _symbol;}
261     function decimals() public pure returns (uint8) {return _decimals;}
262     function getOwner() external view override returns (address) { return owner; }
263     function totalSupply() public view override returns (uint256) {return _totalSupply;}
264     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
265     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
266     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
267     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
268     function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
269     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
270 
271     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
272         require(sender != address(0), "ERC20: transfer from the zero address");
273         require(recipient != address(0), "ERC20: transfer to the zero address");
274         require(amount <= balanceOf(sender),"ERC20: below available balance threshold");
275     }
276 
277     function _transfer(address sender, address recipient, uint256 amount) private {
278         preTxCheck(sender, recipient, amount);
279         checkTradingAllowed(sender, recipient);
280         checkTxLimit(sender, recipient, amount);
281         checkMaxWallet(sender, recipient, amount);
282         swapbackCounters(sender, recipient, amount);
283         swapBack(sender, recipient);
284         swapVolume(sender, recipient, amount);
285         _balances[sender] = _balances[sender].sub(amount);
286         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
287         _balances[recipient] = _balances[recipient].add(amountReceived);
288         emit Transfer(sender, recipient, amountReceived);
289     }
290 
291     function checkTradingAllowed(address sender, address recipient) internal view {
292         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "ERC20: Trading is not allowed");}
293     }
294 
295     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
296         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD) && !volumeTx){
297             require((_balances[recipient].add(amount)) <= _maxWalletToken, "ERC20: exceeds maximum wallet amount.");}
298     }
299 
300     function swapbackCounters(address sender, address recipient, uint256 amount) internal {
301         if((recipient == address(pair) || cexPair[recipient]) && !isFeeExempt[sender] && amount >= minTokenAmount && !swapping && !volumeTx){swapTimes += uint256(1);}
302     }
303 
304     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
305         if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: exceeds maximum allowed not currently staked.");}
306         if(!volumeTx){require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "ERC20: tx limit exceeded");}
307     }
308 
309     function swapAndLiquify(uint256 tokens) private lockTheSwap {
310         uint256 _denominator = (totalFee).add(1).mul(2);
311         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
312         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
313         uint256 initialBalance = address(this).balance;
314         swapTokensForETH(toSwap);
315         uint256 deltaBalance = address(this).balance.sub(initialBalance);
316         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
317         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
318         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
319         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
320         if(marketingAmount > uint256(0)){payable(marketing_receiver).transfer(marketingAmount);}
321         uint256 tairyoAmount = unitBalance.mul(2).mul(tairyoFee);
322         if(tairyoAmount > uint256(0)){payable(address(tairyo_receiver)).transfer(tairyoAmount);}
323         uint256 buybackAmount = unitBalance.mul(2).mul(buybackFee);
324         if(buybackAmount > uint256(0)){amountETHBuyback = amountETHBuyback.add(buybackAmount);}
325         uint256 eAmount = address(this).balance.sub(amountETHBuyback);
326         if(eAmount > uint256(0)){payable(development_receiver).transfer(eAmount);}
327     }
328 
329     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
330         _approve(address(this), address(router), tokenAmount);
331         router.addLiquidityETH{value: ETHAmount}(
332             address(this),
333             tokenAmount,
334             0,
335             0,
336             address(receiver),
337             block.timestamp);
338     }
339 
340     function swapTokensForETH(uint256 tokenAmount) private {
341         address[] memory path = new address[](2);
342         path[0] = address(this);
343         path[1] = router.WETH();
344         _approve(address(this), address(router), tokenAmount);
345         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
346             tokenAmount,
347             0,
348             path,
349             address(this),
350             block.timestamp);
351     }
352 
353     function shouldSwapBack(address sender, address recipient) internal view returns (bool) {
354         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
355         bool isPair = (recipient == address(pair) || cexPair[recipient]);
356         return !swapping && swapEnabled && tradingAllowed && !isFeeExempt[sender]
357             && isPair && swapTimes >= swapAmount && aboveThreshold && !volumeTx;
358     }
359 
360     function swapBack(address sender, address recipient) internal {
361         if(shouldSwapBack(sender, recipient)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
362     }
363     
364     function volumizing() external onlyOwner {
365         tradingAllowed = true;
366     }
367 
368     function _claimStakingDividends() external {
369         stakingContract.stakingClaimToCompound(msg.sender, msg.sender);
370     }
371 
372     function deposit(uint256 amount) override external {
373         require(amount <= _balances[msg.sender].sub(amountStaked[msg.sender]), "ERC20: Cannot stake more than available balance");
374         stakingContract.stakingDeposit(msg.sender, amount);
375         amountStaked[msg.sender] = amountStaked[msg.sender].add(amount);
376         totalStaked = totalStaked.add(amount);
377         if(stakedVolume){
378         volumeTx = true;
379         volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
380         volumeTx = false;}
381     }
382 
383     function withdraw(uint256 amount) override external {
384         require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
385         stakingContract.stakingWithdraw(msg.sender, amount);
386         amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
387         totalStaked = totalStaked.sub(amount);
388         if(stakedVolume){
389         volumeTx = true;
390         volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
391         volumeTx = false;}
392     }
393 
394     function compound() override external {
395         require(amountStaked[msg.sender] > uint256(0), "ERC20: Cannot compound more than amount staked");
396         uint256 beforeBalance = balanceOf(msg.sender);
397         stakingContract.stakingClaimToCompound(msg.sender, msg.sender);
398         uint256 afterBalance = balanceOf(msg.sender).sub(beforeBalance);
399         stakingContract.stakingDeposit(msg.sender, afterBalance);
400         amountStaked[msg.sender] = amountStaked[msg.sender].add(afterBalance);
401         totalStaked = totalStaked.add(afterBalance);
402         if(stakedVolume){
403         volumeTx = true;
404         volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
405         volumeTx = false;}
406     }
407 
408     function setStakingAddress(address _staking) external onlyOwner {
409         stakingContract = stakeIntegration(_staking); isFeeExempt[_staking] = true;
410     }
411 
412     function setisCEXPair(address _pair, bool enable) external onlyOwner {
413         cexPair[_pair] = enable;
414     }
415 
416     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _development, uint256 _tairyo, uint256 _volume, uint256 _buyback, uint256 _staking, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
417         liquidityFee = _liquidity; marketingFee = _marketing; developmentFee = _development; volumeFee = _volume; tairyoFee = _tairyo; buybackFee = _buyback; stakingFee = _staking;
418         totalFee = _total; sellFee = _sell; transferFee = _trans;
419         require(totalFee <= denominator && sellFee <= denominator && transferFee <= denominator, "ERC20: invalid total entry%");
420     }
421 
422     function setInternalAddresses(address _marketing, address _liquidity, address _development, address _buyback, address _staking) external onlyOwner {
423         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development; buyback_receiver = _buyback; staking_receiver = _staking;
424         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true; isFeeExempt[_buyback] = true; isFeeExempt[_staking] = true;
425     }
426 
427     function setisExempt(address _address, bool _enabled) external onlyOwner {
428         isFeeExempt[_address] = _enabled;
429     }
430 
431     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
432         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
433     }
434 
435     function setParameters(uint256 _buy, uint256 _wallet) external onlyOwner {
436         uint256 newTx = totalSupply().mul(_buy).div(uint256(10000));
437         uint256 newWallet = totalSupply().mul(_wallet).div(uint256(10000)); uint256 limit = totalSupply().mul(5).div(10000);
438         require(newTx >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
439         _maxTxAmount = newTx; _maxWalletToken = newWallet;
440     }
441 
442     function rescueERC20(address _address, uint256 _amount) external onlyOwner {
443         IERC20(_address).transfer(development_receiver, _amount);
444     }
445 
446     function toggleVolume(bool token, bool manual, bool staked) external onlyOwner {
447         volumeToken = token; manualVolumeAllowed = manual; stakedVolume = staked;
448     }
449 
450     function SetVolumeParameters(uint256 _volumePercentage, uint256 _maxAmount) external onlyOwner {
451         uint256 newAmount = totalSupply().mul(_maxAmount).div(uint256(10000));
452         require(_volumePercentage <= uint256(100), "Value Must Be Less Than or Equal to Denominator");
453         volumizer.setTokenMaxVolumeAmount(address(this), newAmount);
454         volumizer.setTokenMaxVolumePercent(address(this), _volumePercentage, uint256(100));
455     }
456 
457     function setminVolumeToken(uint256 amount) external onlyOwner {
458         minVolumeTokenAmount = amount;
459     }
460 
461     function setVolumeGasPerTx(uint256 gas) external onlyOwner {
462         txGas = gas;
463     }
464 
465     function setVolumizerContract(address _contract) external onlyOwner {
466         volumizer = AIVolumizer(_contract); isFeeExempt[_contract] = true;
467     }
468 
469     function UserFundVolumizerContract(uint256 amount) external {
470         uint256 amountTokens = amount.mul(10 ** _decimals); 
471         IERC20(address(this)).transferFrom(msg.sender, address(volumizer), amountTokens);
472         amountTokensFunded = amountTokensFunded.add(amountTokens);
473     }
474 
475     function RescueVolumizerTokensPercent(uint256 percent) external onlyOwner {
476         uint256 amount = IERC20(address(this)).balanceOf(address(volumizer)).mul(percent).div(denominator);
477         volumizer.rescueHubERC20(address(this), msg.sender, amount);
478     }
479 
480     function RescueVolumizerTokens(uint256 amount) external onlyOwner {
481         uint256 tokenAmount = amount.mul(10 ** _decimals);
482         volumizer.rescueHubERC20(address(this), msg.sender, tokenAmount);
483     }
484 
485     function setVolumizerBuyback(uint256 _ethAdd, address receiver, bool tokenSend) external onlyOwner {
486         buyback_receiver = receiver; buybackAddAmount = _ethAdd; buybackSend = tokenSend;
487     }
488 
489     function swapVolume(address sender, address recipient, uint256 amount) internal {
490         if(tradingAllowed && !isFeeExempt[sender] && (recipient == address(pair) || cexPair[recipient]) && amount >= minVolumeTokenAmount &&
491             !swapping && !volumeTx){swapVolumeTimes += uint256(1);}
492         if(tradingAllowed && volumeToken && balanceOf(address(volumizer)) > uint256(0) && !isFeeExempt[sender] && (recipient == address(pair) || cexPair[recipient]) &&
493             !swapping && !volumeTx){
494                 if(amountETHBuyback >= buybackAddAmount && address(this).balance >= buybackAddAmount && swapVolumeTimes >= swapVolumeAmount){
495                     performVolumizerBuyback();}
496                 else{performVolumizer();}}
497     }
498 
499     function performVolumizer() internal {
500         volumeTx = true;
501         try volumizer.tokenVolumeTransaction{gas: txGas}(address(this)) {} catch {}
502         volumeTx = false;
503     }
504 
505     function performVolumizerBuyback() internal {
506         (bool sending,) = payable(address(volumizer)).call{value: buybackAddAmount}("");
507         sending = false;
508         amountETHBuyback = amountETHBuyback.sub(buybackAddAmount);
509         volumeTx = true;
510         try volumizer.tokenVaryETHVolumeTransaction{gas: txGas}(address(this), buybackAddAmount, buyback_receiver, buybackSend) {} catch {}
511         volumeTx = false;
512         swapVolumeTimes = uint256(0);
513     }
514 
515     function PerformVolumizer() external {
516         require(manualVolumeAllowed);
517         volumeTx = true;
518         volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
519         volumeTx = false;
520     }
521 
522     function manualVolumizer(uint256 maxAmount, uint256 volumePercentage) external onlyOwner {
523         uint256 newAmount = totalSupply().mul(maxAmount).div(uint256(10000));
524         volumeTx = true;
525         volumizer.tokenManualVolumeTransaction{gas: txGas}(address(this), newAmount, volumePercentage);
526         volumeTx = false;
527     }
528 
529     function manualVolumizerBuybackContract(uint256 amountETH, address _receiver, bool send) external onlyOwner {
530         require(amountETH <= amountETHBuyback && amountETH <= address(this).balance, "Balance Below Inputed Value");
531         payable(address(volumizer)).transfer(amountETH);
532         amountETHBuyback = amountETHBuyback.sub(amountETH);
533         volumeTx = true;
534         try volumizer.tokenVaryETHVolumeTransaction{gas: txGas}(address(this), amountETH, _receiver, send) {} catch {}
535         swapVolumeTimes = uint256(0);
536         volumeTx = false;
537     }
538 
539     function setETHBuybackAmount(uint256 amount) external onlyOwner {
540         amountETHBuyback = amount;
541     }
542 
543     function manualFundETHBuyback() external payable {
544         amountETHBuyback = amountETHBuyback.add(msg.value);
545     }
546 
547     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
548         return !isFeeExempt[sender] && !isFeeExempt[recipient] && !volumeTx;
549     }
550 
551     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
552         if((recipient == address(pair) || cexPair[recipient]) && sellFee > uint256(0)){return sellFee;}
553         if((sender == address(pair) || cexPair[sender]) && totalFee > uint256(0)){return totalFee;}
554         return transferFee;
555     }
556 
557     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
558         if(getTotalFee(sender, recipient) > 0 && !volumeTx){
559         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
560         _balances[address(this)] = _balances[address(this)].add(feeAmount);
561         emit Transfer(sender, address(this), feeAmount);
562         if(volumeFee > uint256(0)){_transfer(address(this), address(volumizer), amount.div(denominator).mul(volumeFee));}
563         if(stakingFee > uint256(0)){_transfer(address(this), address(staking_receiver), amount.div(denominator).mul(stakingFee));}
564         return amount.sub(feeAmount);} return amount;
565     }
566 
567     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
570         return true;
571     }
572 
573     function _approve(address owner, address spender, uint256 amount) private {
574         require(owner != address(0), "ERC20: approve from the zero address");
575         require(spender != address(0), "ERC20: approve to the zero address");
576         _allowances[owner][spender] = amount;
577         emit Approval(owner, spender, amount);
578     }
579 
580     function viewProjectTokenParameters() public view returns (uint256 _maxVolumeAmount, uint256 _volumePercentage, uint256 _denominator) {
581         return(volumizer.viewProjectTokenParameters(address(this)));
582     }
583 
584     function veiwFullVolumeStats() external view returns (uint256 totalPurchased, uint256 totalETH, 
585         uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime) {
586         return(volumizer.viewTotalTokenPurchased(address(this)), volumizer.viewTotalETHPurchased(address(this)), 
587             volumizer.viewTotalTokenVolume(address(this)), volumizer.viewLastTokenVolume(address(this)), 
588                 volumizer.viewLastVolumeTimestamp(address(this)));
589     }
590     
591     function viewTotalTokenPurchased() public view returns (uint256) {
592         return(volumizer.viewTotalTokenPurchased(address(this)));
593     }
594 
595     function viewTotalETHPurchased() public view returns (uint256) {
596         return(volumizer.viewTotalETHPurchased(address(this)));
597     }
598 
599     function viewLastETHPurchased() public view returns (uint256) {
600         return(volumizer.viewLastETHPurchased(address(this)));
601     }
602 
603     function viewLastTokensPurchased() public view returns (uint256) {
604         return(volumizer.viewLastTokensPurchased(address(this)));
605     }
606 
607     function viewTotalTokenVolume() public view returns (uint256) {
608         return(volumizer.viewTotalTokenVolume(address(this)));
609     }
610     
611     function viewLastTokenVolume() public view returns (uint256) {
612         return(volumizer.viewLastTokenVolume(address(this)));
613     }
614 
615     function viewLastVolumeTimestamp() public view returns (uint256) {
616         return(volumizer.viewLastVolumeTimestamp(address(this)));
617     }
618 
619     function viewNumberTokenVolumeTxs() public view returns (uint256) {
620         return(volumizer.viewNumberTokenVolumeTxs(address(this)));
621     }
622 
623     function viewTokenBalanceVolumizer() public view returns (uint256) {
624         return(IERC20(address(this)).balanceOf(address(volumizer)));
625     }
626 
627     function viewLastVolumizerBlock() public view returns (uint256) {
628         return(volumizer.viewLastVolumeBlock(address(this)));
629     }
630 }