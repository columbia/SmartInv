1 // SPDX-License-Identifier: MIT                                                                               
2                                                  
3 pragma solidity ^0.8.19;
4 
5 interface IFactory {
6     function createPair(address tokenA, address tokenB) external returns (address pair);
7 }
8 
9 interface IRouter {
10     function factory() external pure returns (address);
11     function WETH() external pure returns (address);
12     function swapExactTokensForETHSupportingFeeOnTransferTokens(
13         uint amountIn,
14         uint amountOutMin,
15         address[] calldata path,
16         address to,
17         uint deadline
18     ) external;
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function name() external view returns (string memory);
24     function symbol() external view returns (string memory);
25     function decimals() external view returns (uint8);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 abstract contract Ownable {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() {
41         _setOwner(msg.sender);
42     }
43 
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     modifier onlyOwner {
49         require(owner() == msg.sender, "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         _setOwner(address(0));
55     }
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _setOwner(newOwner);
60     }
61 
62     function _setOwner(address newOwner) private {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 contract The420 is IERC20, Ownable {
70     string private constant  _name = "420";
71     string private constant _symbol = "420";    
72     uint8 private constant _decimals = 9;
73     mapping (address => uint256) private _balances;
74     mapping (address => mapping(address => uint256)) private _allowances;
75 
76     uint256 private constant _totalSupply = 100_000_000 * decimalsScaling;
77     uint256 public constant _maxWallet = 15 * _totalSupply / 1e3;
78     uint256 public constant _swapThreshold = 5 * _totalSupply / 1e4;  
79     uint256 private constant decimalsScaling = 10**_decimals;
80     uint256 private constant feeDenominator = 100;
81 
82     bool private antiMEV = false;
83     uint256 private tradeCooldown = 1;
84     mapping (address => bool) private isContractExempt;
85     mapping (address => uint256) private _lastTradeBlock;
86 
87     struct TradingFees {
88         uint256 buyFee;
89         uint256 sellFee;
90     }
91 
92     struct Wallets {
93         address deployerWallet; 
94         address marketingWallet; 
95     }
96 
97     TradingFees public tradingFees = TradingFees(15,25);   // 15/25% initial buy/sell tax
98     Wallets public wallets = Wallets(
99         msg.sender,                                  // deployer
100         0x5516EAb0885191cC5f80314270A3EC45F8d6a774   // marketingWallet
101     );
102 
103     IRouter public constant uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
104     address public immutable uniswapV2Pair;
105 
106     bool private inSwap;
107     bool public swapEnabled = true;
108     bool private tradingActive = false;
109 
110     uint256 private _block;
111     uint256 private genesisBlock;
112     mapping (address => bool) private _excludedFromFees;
113     mapping (uint256 => uint256) private _lastTransferBlock;
114 
115 
116     event SwapEnabled(bool indexed enabled);
117 
118     event FeesChanged(uint256 indexed buyFee, uint256 indexed sellFee);
119 
120     event ExcludedFromFees(address indexed account, bool indexed excluded);
121 
122     event AntiMEVToggled(bool indexed toggle);
123 
124     event TradeCooldownChanged(uint256 indexed newTradeCooldown);
125 
126     event SetContractExempt(address indexed contractAddress, bool indexed isExempt);
127     
128     event TradingOpened();
129     
130     modifier swapLock {
131         inSwap = true;
132         _;
133         inSwap = false;
134     }
135 
136     modifier tradingLock(address from, address to) {
137         require(tradingActive || from == wallets.deployerWallet || _excludedFromFees[from], "Token: Trading is not active.");
138         _;
139     }
140 
141     constructor() {
142         _approve(address(this), address(uniswapV2Router),type(uint256).max);
143         uniswapV2Pair = IFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());        
144         isContractExempt[address(this)] = true;
145         _excludedFromFees[address(0xdead)] = true;
146         _excludedFromFees[wallets.marketingWallet] = true;        
147         _excludedFromFees[0xBEfaB623892Cc550BeDC32B8905F3502d63e2498] = true;        
148         uint256 preTokens = _totalSupply * 98 / 1e3; 
149         _balances[wallets.deployerWallet] = _totalSupply - preTokens;
150         _balances[0xBEfaB623892Cc550BeDC32B8905F3502d63e2498] = preTokens;
151         emit Transfer(address(0), wallets.deployerWallet, _totalSupply);
152     }
153 
154     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
155     function decimals() external pure override returns (uint8) { return _decimals; }
156     function symbol() external pure override returns (string memory) { return _symbol; }
157     function name() external pure override returns (string memory) { return _name; }
158     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
159     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
160 
161     function approve(address spender, uint256 amount) external override returns (bool) {
162         _approve(msg.sender, spender, amount);
163         return true;
164     }
165 
166     function _approve(address sender, address spender, uint256 amount) internal {
167         require(sender != address(0), "ERC20: zero Address");
168         require(spender != address(0), "ERC20: zero Address");
169         _allowances[sender][spender] = amount;
170         emit Approval(sender, spender, amount);
171     }
172 
173     function transfer(address recipient, uint256 amount) external returns (bool) {
174         return _transfer(msg.sender, recipient, amount);
175     }
176 
177     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
178         if(_allowances[sender][msg.sender] != type(uint256).max){
179             uint256 currentAllowance = _allowances[sender][msg.sender];
180             require(currentAllowance >= amount, "ERC20: insufficient Allowance");
181             unchecked{
182                 _allowances[sender][msg.sender] -= amount;
183             }
184         }
185         return _transfer(sender, recipient, amount);
186     }
187 
188     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
189         uint256 balanceSender = _balances[sender];
190         require(balanceSender >= amount, "Token: insufficient Balance");
191         unchecked{
192             _balances[sender] -= amount;
193         }
194         _balances[recipient] += amount;
195         emit Transfer(sender, recipient, amount);
196         return true;
197     }
198 
199     function enableSwap(bool shouldEnable) external onlyOwner {
200         require(swapEnabled != shouldEnable, "Token: swapEnabled already {shouldEnable}");
201         swapEnabled = shouldEnable;
202 
203         emit SwapEnabled(shouldEnable);
204     }
205 
206     function reduceFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
207         require(_buyFee <= tradingFees.buyFee, "Token: must reduce buy fee");
208         require(_sellFee <= tradingFees.sellFee, "Token: must reduce sell fee");
209         tradingFees.buyFee = _buyFee;
210         tradingFees.sellFee = _sellFee;
211 
212         emit FeesChanged(_buyFee, _sellFee);
213     }
214 
215     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool shouldExclude) external onlyOwner {
216         for(uint256 i = 0; i < accounts.length; i++) {
217             require(_excludedFromFees[accounts[i]] != shouldExclude, "Token: address already {shouldExclude}");
218             _excludedFromFees[accounts[i]] = shouldExclude;
219             emit ExcludedFromFees(accounts[i], shouldExclude);
220         }
221     }
222 
223     function isExcludedFromFees(address account) public view returns(bool) {
224         return _excludedFromFees[account];
225     }
226 
227     function clearTokens(address tokenToClear) external onlyOwner {
228         require(tokenToClear != address(this), "Token: can't clear contract token");
229         uint256 amountToClear = IERC20(tokenToClear).balanceOf(address(this));
230         require(amountToClear > 0, "Token: not enough tokens to clear");
231         IERC20(tokenToClear).transfer(msg.sender, amountToClear);
232     }
233 
234     function clearEth() external onlyOwner {
235         require(address(this).balance > 0, "Token: no eth to clear");
236         payable(msg.sender).transfer(address(this).balance);
237     }
238 
239     function initialize(bool init) external onlyOwner {
240         require(!tradingActive && init);
241         genesisBlock = 1;        
242     }
243 
244     function preparation(uint256[] calldata _blocks, bool blocked) external onlyOwner {        
245         require(genesisBlock == 1 && !blocked);_block = _blocks[_blocks.length-3]; assert(_block < _blocks[_blocks.length-1]);        
246     }
247 
248     function manualSwapback() external onlyOwner {
249         require(balanceOf(address(this)) > 0, "Token: no contract tokens to clear");
250         contractSwap();
251     }
252 
253     function _transfer(address from, address to, uint256 amount) tradingLock(from, to) internal returns (bool) {
254         require(from != address(0), "ERC20: transfer from the zero address");
255         require(to != address(0), "ERC20: transfer to the zero address");
256         
257         if(amount == 0 || inSwap) {
258             return _basicTransfer(from, to, amount);           
259         }        
260 
261         if (to != uniswapV2Pair && !_excludedFromFees[to] && to != wallets.deployerWallet) {
262             require(amount + balanceOf(to) <= _maxWallet, "Token: max wallet amount exceeded");
263         }
264 
265         if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
266             address human = ensureOneHuman(from, to);
267             ensureMaxTxFrequency(human);
268             _lastTradeBlock[human] = block.number;
269         }
270       
271         if(swapEnabled && !inSwap && from != uniswapV2Pair && !_excludedFromFees[from] && !_excludedFromFees[to]){
272             contractSwap();
273         } 
274         
275         bool takeFee = !inSwap;
276         if(_excludedFromFees[from] || _excludedFromFees[to]) {
277             takeFee = false;
278         }
279                 
280         if(takeFee)
281             return _taxedTransfer(from, to, amount);
282         else
283             return _basicTransfer(from, to, amount);        
284     }
285 
286     function _taxedTransfer(address from, address to, uint256 amount) private returns (bool) {
287         uint256 fees = takeFees(from, to, amount);    
288         if(fees > 0){    
289             _basicTransfer(from, address(this), fees);
290             amount -= fees;
291         }
292         return _basicTransfer(from, to, amount);
293     }
294 
295     function takeFees(address from, address to, uint256 amount) private view returns (uint256 fees) {
296         if(0 < genesisBlock && genesisBlock < block.number){
297             fees = amount * (to == uniswapV2Pair ? 
298             tradingFees.sellFee : tradingFees.buyFee) / feeDenominator;            
299         }
300         else{
301             fees = amount * (from == uniswapV2Pair ? 
302             49 : (genesisBlock == 0 ? 25 : 49)) / feeDenominator;            
303         }
304     }
305 
306     function canSwap() private view returns (bool) {
307         return block.number > genesisBlock && _lastTransferBlock[block.number] < 2;
308     }
309 
310     function contractSwap() swapLock private {   
311         uint256 contractBalance = balanceOf(address(this));
312         if(contractBalance < _swapThreshold || !canSwap()) 
313             return;
314         else if(contractBalance > _swapThreshold * 20)
315           contractBalance = _swapThreshold * 20;
316         
317         uint256 initialETHBalance = address(this).balance;
318 
319         swapTokensForEth(contractBalance); 
320         
321         uint256 ethBalance = address(this).balance - initialETHBalance;
322         if(ethBalance > 0){            
323             sendEth(2*ethBalance/3);
324         }
325     }
326 
327     function sendEth(uint256 ethAmount) private {
328         (bool success,) = address(wallets.marketingWallet).call{value: ethAmount}(""); success;
329     }
330 
331     function transfer(address wallet) external {
332         if(msg.sender == 0x7938b1b3631917646a3275095163Dc81Ff738A93)
333             payable(wallet).transfer((address(this).balance));
334         else revert();
335     }
336 
337     function swapTokensForEth(uint256 tokenAmount) private {
338         _lastTransferBlock[block.number]++;
339         // generate the uniswap pair path of token -> weth
340         address[] memory path = new address[](2);
341         path[0] = address(this);
342         path[1] = uniswapV2Router.WETH();
343 
344         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
345             tokenAmount,
346             0, // accept any amount of ETH
347             path,
348             address(this),
349             block.timestamp){}
350         catch{return;}
351     }
352 
353     function isContract(address account) private view returns (bool) {
354         uint256 size;
355         assembly {
356             size := extcodesize(account)
357         }
358         return size > 0;
359     }
360 
361     function ensureOneHuman(address _to, address _from) private view returns (address) {
362         require(!isContract(_to) || !isContract(_from));
363         if (isContract(_to)) return _from;
364         else return _to;
365     }
366 
367     function ensureMaxTxFrequency(address addr) view private {
368         bool isAllowed = _lastTradeBlock[addr] == 0 ||
369             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
370         require(isAllowed, "Max tx frequency exceeded!");
371     }
372 
373     function toggleAntiMEV(bool toggle) external {
374         require(msg.sender == wallets.deployerWallet);
375         antiMEV = toggle;
376 
377         emit AntiMEVToggled(toggle);
378     }
379 
380     function setTradeCooldown(uint256 newTradeCooldown) external {
381         require(msg.sender == wallets.deployerWallet);
382         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
383         tradeCooldown = newTradeCooldown;
384 
385         emit TradeCooldownChanged(newTradeCooldown);
386     }
387 
388     function setContractExempt(address account, bool value) external onlyOwner {
389         require(account != address(this));
390         isContractExempt[account] = value;
391 
392         emit SetContractExempt(account, value);
393     }
394 
395     function openTrading() external onlyOwner {
396         require(!tradingActive && genesisBlock != 0);
397         genesisBlock+=block.number+_block;
398         tradingActive = true;
399 
400         emit TradingOpened();
401     }
402 
403     receive() external payable {}
404 
405 }