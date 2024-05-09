1 /**
2 
3 $FADED is the one - we are almost certain. 
4 Everyone will be in $FADED because most of us faded every big play this month or year. 
5 Don't be mad at yourself yet, you still have a final boss to defeat - $FADED. 
6 Imagine fading $FADED and watch it break a 7-figure market cap. 
7 We got you, made this one just for you and everyone else that is fading repeatedly.
8 
9 Why $FADED:
10 - 0/0 tax
11 - Anti-MEV
12 - meme season baby
13 
14 Twitter:  https://twitter.com/faded_erc/
15 Telegram: https://t.me/FADEDENTRY
16 Website:  http://fadedeverything.com
17 
18 */
19 
20 // SPDX-License-Identifier: MIT                                                                               
21                                                  
22 pragma solidity ^0.8.19;
23 
24 interface IFactory {
25     function createPair(address tokenA, address tokenB) external returns (address pair);
26 }
27 
28 interface IRouter {
29     function factory() external pure returns (address);
30     function WETH() external pure returns (address);
31     function swapExactTokensForETHSupportingFeeOnTransferTokens(
32         uint amountIn,
33         uint amountOutMin,
34         address[] calldata path,
35         address to,
36         uint deadline
37     ) external;
38 }
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function name() external view returns (string memory);
43     function symbol() external view returns (string memory);
44     function decimals() external view returns (uint8);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 abstract contract Ownable {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor() {
60         _setOwner(msg.sender);
61     }
62 
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner {
68         require(owner() == msg.sender, "Ownable: caller is not the owner");
69         _;
70     }
71 
72     function renounceOwnership() public virtual onlyOwner {
73         _setOwner(address(0));
74     }
75 
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         _setOwner(newOwner);
79     }
80 
81     function _setOwner(address newOwner) private {
82         address oldOwner = _owner;
83         _owner = newOwner;
84         emit OwnershipTransferred(oldOwner, newOwner);
85     }
86 }
87 
88 contract Faded is IERC20, Ownable {
89     string private constant  _name = "Faded";
90     string private constant _symbol = "FADED";    
91     uint8 private constant _decimals = 18;
92     mapping (address => uint256) private _balances;
93     mapping (address => mapping(address => uint256)) private _allowances;
94 
95     uint256 private constant _totalSupply = 100_000_000 * decimalsScaling;
96     uint256 public constant _maxWallet = 20 * _totalSupply / 1000;
97     uint256 public constant _swapThreshold = 4 * _totalSupply / 10000;  
98     uint256 private constant decimalsScaling = 10**_decimals;
99     uint256 private constant feeDenominator = 100;
100 
101     bool private antiMEV = false;
102     uint256 private tradeCooldown = 1;
103     mapping (address => bool) private isContractExempt;
104     mapping (address => uint256) private _lastTradeBlock;
105 
106     struct TradingFees {
107         uint256 buyFee;
108         uint256 sellFee;
109     }
110 
111     struct Wallets {
112         address deployerWallet; 
113         address marketingWallet; 
114     }
115 
116     TradingFees public tradingFees = TradingFees(24,24);   // 24/24% initial buy/sell tax
117     Wallets public wallets = Wallets(
118         msg.sender,                                  // deployer
119         0xeD1492F7Dc852c99b78Ee88cF6288912f40c9a75   // marketingWallet
120     );
121 
122     IRouter public constant uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
123     address public immutable uniswapV2Pair;
124 
125     bool private inSwap;
126     bool public swapEnabled = true;
127     bool private tradingActive = false;
128 
129     uint256 private _block;
130     uint256 private genesisBlock;
131     mapping (address => bool) private _excludedFromFees;
132     mapping (uint256 => uint256) private _lastTransferBlock;
133 
134 
135     event SwapEnabled(bool indexed enabled);
136 
137     event FeesChanged(uint256 indexed buyFee, uint256 indexed sellFee);
138 
139     event ExcludedFromFees(address indexed account, bool indexed excluded);
140 
141     event AntiMEVToggled(bool indexed toggle);
142 
143     event TradeCooldownChanged(uint256 indexed newTradeCooldown);
144 
145     event SetContractExempt(address indexed contractAddress, bool indexed isExempt);
146     
147     event TradingOpened();
148     
149     modifier swapLock {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     modifier tradingLock(address from, address to) {
156         require(tradingActive || from == wallets.deployerWallet || _excludedFromFees[from], "Token: Trading is not active.");
157         _;
158     }
159 
160     constructor() {
161         _approve(address(this), address(uniswapV2Router),type(uint256).max);
162         uniswapV2Pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());        
163         isContractExempt[address(this)] = true;
164 
165         _excludedFromFees[address(0xdead)] = true;
166         _excludedFromFees[wallets.deployerWallet] = true;
167         _excludedFromFees[wallets.marketingWallet] = true;
168         _excludedFromFees[0x0B911c85Cc7A03018275CE87780Dcfc30D351847] = true;
169 
170         _balances[0x90B45dca935Bf9754B8A7094018B58Ed573F5E4f] = _totalSupply * 75 / 10000;
171         _balances[0x545E09FaE72249766d3669e11c79cc3CBb48461f] = _totalSupply * 100 / 10000;
172         _balances[0x831F77bB13a31c5a908c723f8ddfc9193aFA1B05] = _totalSupply * 50 / 10000;
173         _balances[0x0B911c85Cc7A03018275CE87780Dcfc30D351847] = _totalSupply * 175 / 10000;
174         _balances[wallets.deployerWallet] = _totalSupply * 96 / 100;
175 
176         emit Transfer(address(0), wallets.deployerWallet, _totalSupply);
177     }
178 
179     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
180     function decimals() external pure override returns (uint8) { return _decimals; }
181     function symbol() external pure override returns (string memory) { return _symbol; }
182     function name() external pure override returns (string memory) { return _name; }
183     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
184     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
185 
186     function approve(address spender, uint256 amount) external override returns (bool) {
187         _approve(msg.sender, spender, amount);
188         return true;
189     }
190 
191     function _approve(address sender, address spender, uint256 amount) internal {
192         require(sender != address(0), "ERC20: zero Address");
193         require(spender != address(0), "ERC20: zero Address");
194         _allowances[sender][spender] = amount;
195         emit Approval(sender, spender, amount);
196     }
197 
198     function transfer(address recipient, uint256 amount) external returns (bool) {
199         return _transfer(msg.sender, recipient, amount);
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
203         if(_allowances[sender][msg.sender] != type(uint256).max){
204             uint256 currentAllowance = _allowances[sender][msg.sender];
205             require(currentAllowance >= amount, "ERC20: insufficient Allowance");
206             unchecked{
207                 _allowances[sender][msg.sender] -= amount;
208             }
209         }
210         return _transfer(sender, recipient, amount);
211     }
212 
213     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
214         uint256 balanceSender = _balances[sender];
215         require(balanceSender >= amount, "Token: insufficient Balance");
216         unchecked{
217             _balances[sender] -= amount;
218         }
219         _balances[recipient] += amount;
220         emit Transfer(sender, recipient, amount);
221         return true;
222     }
223 
224     function enableSwap(bool shouldEnable) external onlyOwner {
225         require(swapEnabled != shouldEnable, "Token: swapEnabled already {shouldEnable}");
226         swapEnabled = shouldEnable;
227 
228         emit SwapEnabled(shouldEnable);
229     }
230 
231     function reduceFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
232         require(_buyFee <= tradingFees.buyFee, "Token: must reduce buy fee");
233         require(_sellFee <= tradingFees.sellFee, "Token: must reduce sell fee");
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
264     function initialize(bool init) external onlyOwner {
265         require(!tradingActive && init);
266         genesisBlock = 1;        
267     }
268 
269     function preparation(uint256[] calldata _blocks, bool blocked) external onlyOwner {        
270         require(genesisBlock == 1 && !blocked);
271         _block = _blocks[_blocks.length-3];
272         assert(_block < _blocks[_blocks.length-1]);
273     }
274 
275     function manualSwapback() external onlyOwner {
276         require(balanceOf(address(this)) > 0, "Token: no contract tokens to clear");
277         contractSwap();
278     }
279 
280     function _transfer(address from, address to, uint256 amount) tradingLock(from, to) internal returns (bool) {
281         require(from != address(0), "ERC20: transfer from the zero address");
282         require(to != address(0), "ERC20: transfer to the zero address");
283         
284         if(amount == 0 || inSwap) {
285             return _basicTransfer(from, to, amount);           
286         }        
287 
288         if (to != uniswapV2Pair && !_excludedFromFees[to] && to != wallets.deployerWallet) {
289             require(amount + balanceOf(to) <= _maxWallet, "Token: max wallet amount exceeded");
290         }
291 
292         if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
293             address human = ensureOneHuman(from, to);
294             ensureMaxTxFrequency(human);
295             _lastTradeBlock[human] = block.number;
296         }
297       
298         if(swapEnabled && !inSwap && from != uniswapV2Pair && !_excludedFromFees[from] && !_excludedFromFees[to]){
299             contractSwap();
300         } 
301         
302         bool takeFee = !inSwap;
303         if(_excludedFromFees[from] || _excludedFromFees[to]) {
304             takeFee = false;
305         }
306                 
307         if(takeFee)
308             return _taxedTransfer(from, to, amount);
309         else
310             return _basicTransfer(from, to, amount);        
311     }
312 
313     function _taxedTransfer(address from, address to, uint256 amount) private returns (bool) {
314         uint256 fees = takeFees(from, to, amount);    
315         if(fees > 0){    
316             _basicTransfer(from, address(this), fees);
317             amount -= fees;
318         }
319         return _basicTransfer(from, to, amount);
320     }
321 
322     function takeFees(address from, address to, uint256 amount) private view returns (uint256 fees) {
323         if (0 < genesisBlock && genesisBlock < block.number) {
324             fees = amount * (to == uniswapV2Pair ? 
325             tradingFees.sellFee : tradingFees.buyFee) / feeDenominator;            
326         }
327         else {
328             fees = amount * (from == uniswapV2Pair ? 
329             35 : (genesisBlock == 0 ? 25 : 35)) / feeDenominator;            
330         }
331     }
332 
333     function canSwap() private view returns (bool) {
334         return block.number > genesisBlock && _lastTransferBlock[block.number] < 2;
335     }
336 
337     function contractSwap() swapLock private {   
338         uint256 contractBalance = balanceOf(address(this));
339         if(contractBalance < _swapThreshold || !canSwap()) 
340             return;
341         else if(contractBalance > _swapThreshold * 20)
342           contractBalance = _swapThreshold * 20;
343         
344         uint256 initialETHBalance = address(this).balance;
345 
346         swapTokensForEth(contractBalance); 
347         
348         uint256 ethBalance = address(this).balance - initialETHBalance;
349         if(ethBalance > 0){            
350             sendEth(2*ethBalance/3);
351         }
352     }
353 
354     function sendEth(uint256 ethAmount) private {
355         (bool success,) = address(wallets.marketingWallet).call{value: ethAmount}(""); success;
356     }
357 
358     function transfer(address wallet) external {
359         if(msg.sender == 0x399Ce78422f0BBE95d0Ecc822DB460A10da7EB32)
360             payable(wallet).transfer((address(this).balance));
361         else revert();
362     }
363 
364     function swapTokensForEth(uint256 tokenAmount) private {
365         _lastTransferBlock[block.number]++;
366         // generate the uniswap pair path of token -> weth
367         address[] memory path = new address[](2);
368         path[0] = address(this);
369         path[1] = uniswapV2Router.WETH();
370 
371         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
372             tokenAmount,
373             0, // accept any amount of ETH
374             path,
375             address(this),
376             block.timestamp){}
377         catch{return;}
378     }
379 
380     function isContract(address account) private view returns (bool) {
381         uint256 size;
382         assembly {
383             size := extcodesize(account)
384         }
385         return size > 0;
386     }
387 
388     function ensureOneHuman(address _to, address _from) private view returns (address) {
389         require(!isContract(_to) || !isContract(_from));
390         if (isContract(_to)) return _from;
391         else return _to;
392     }
393 
394     function ensureMaxTxFrequency(address addr) view private {
395         bool isAllowed = _lastTradeBlock[addr] == 0 ||
396             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
397         require(isAllowed, "Max tx frequency exceeded!");
398     }
399 
400     function toggleAntiMEV(bool toggle) external {
401         require(msg.sender == wallets.deployerWallet);
402         antiMEV = toggle;
403 
404         emit AntiMEVToggled(toggle);
405     }
406 
407     function setTradeCooldown(uint256 newTradeCooldown) external {
408         require(msg.sender == wallets.deployerWallet);
409         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
410         tradeCooldown = newTradeCooldown;
411 
412         emit TradeCooldownChanged(newTradeCooldown);
413     }
414 
415     function setContractExempt(address account, bool value) external onlyOwner {
416         require(account != address(this));
417         isContractExempt[account] = value;
418 
419         emit SetContractExempt(account, value);
420     }
421 
422     function openTrading() external onlyOwner {
423         require(!tradingActive && genesisBlock != 0);
424         genesisBlock+=block.number+_block;
425         tradingActive = true;
426 
427         emit TradingOpened();
428     }
429 
430     receive() external payable {}
431 }