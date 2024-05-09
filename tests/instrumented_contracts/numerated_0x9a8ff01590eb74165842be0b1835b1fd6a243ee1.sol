1 /**
2  
3     The AI-driven arbitrage betting bot. Operating on autopilot, it leverages odds differences among bookies, always profiting, no matter the match outcome.
4  
5   ______    ________   ________    ________  _______     ______  ___________  ________  
6    /    " \  |"      "\ |"      "\  /"       )|   _  "\   /    " \("     _   ")/"       ) 
7   // ____  \ (.  ___  :)(.  ___  :)(:   \___/ (. |_)  :) // ____  \)__/  \\__/(:   \___/  
8  /  /    ) :)|: \   ) |||: \   ) || \___  \   |:     \/ /  /    ) :)  \\_ /    \___  \    
9 (: (____/ // (| (___\ ||(| (___\ ||  __/  \\  (|  _  \\(: (____/ //   |.  |     __/  \\   
10  \        /  |:       :)|:       :) /" \   :) |: |_)  :)\        /    \:  |    /" \   :)  
11   \"_____/   (________/ (________/ (_______/  (_______/  \"_____/      \__|   (_______/   
12  
13 
14  * Website:     https://oddsbots.com/
15  * Telegram:    https://t.me/oddsbots
16  * Twitter(X):  https://x.com/oddsbotsai
17 
18  */      
19 
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity 0.8.19;
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 contract Ownable is Context {
40     address private _owner;
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor () {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48     function owner() public view returns (address) {
49         return _owner;
50     }
51     modifier onlyOwner() {
52         require(_owner == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55     function transferOwnership(address newOwner) public virtual onlyOwner() {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         _transferOwnership(newOwner);
58     }
59     function _transferOwnership(address newOwner) internal virtual {
60         address oldOwner = _owner;
61         _owner = newOwner;
62         emit OwnershipTransferred(oldOwner, newOwner);
63     }
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69 }
70 interface IUniswapV2Factory {
71     function createPair(address tokenA, address tokenB) external returns (address pair);
72 }
73 interface IUniswapV2Router02 {
74     function swapExactTokensForETHSupportingFeeOnTransferTokens(
75         uint amountIn,
76         uint amountOutMin,
77         address[] calldata path,
78         address to,
79         uint deadline
80     ) external;
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83     function addLiquidityETH(
84         address token,
85         uint amountTokenDesired,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline
90     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
91 }
92 contract Oddsbots is Context, IERC20, Ownable {
93     mapping (address => uint256) private _balances;
94     mapping (address => mapping (address => uint256)) private _allowances;
95     mapping (address => bool) private _isExcludedFromFee;
96     mapping(address => bool) private isBots;
97     address private ops;
98     address payable private MarketingWallet;
99     uint8 private constant _decimals = 9;
100     uint256 private constant _tTotal = 100000000 * 10**_decimals; 
101     string private constant _name = "Oddsbots";
102     string private constant _symbol = "ODDS";
103     uint256 private ThresholdTokens = 600000 * 10**_decimals; 
104     uint256 public maxTxAmount = 600000 * 10**_decimals; 
105     uint256 public maxWalletSize = 700000 * 10**_decimals;  
106     uint256 public buyTaxes = 6;
107     uint256 public sellTaxes = 6;
108     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
109     address public constant Team = 0xbC0D9F3E00F0196BA42D56c7d6E1d10311760378;
110    
111     uint256 private  genesis_block;
112     uint256 private deadline = 7;
113     uint256 private launchtax = 99;
114    
115     IUniswapV2Router02 public uniswapV2Router;
116     address private uniswapV2Pair;
117     bool public tradeEnable = false;
118     bool public _SwapBackEnable = false;
119     bool private inSwap = false;
120    
121    
122     event ExcludeFromFeeUpdated(address indexed account);
123     event includeFromFeeUpdated(address indexed account);
124     event FeesRecieverUpdated(address indexed _newWallet);
125     event SwapThreshouldUpdated(uint256 indexed tokenAmount);
126     event SwapBackSettingUpdated(bool indexed state);
127     event ERC20TokensRecovered(uint256 indexed _amount);
128     event TradingOpenUpdated();
129     event ETHBalanceRecovered();
130     
131     modifier lockTheSwap {
132         inSwap = true;
133         _;
134         inSwap = false;
135     }
136     constructor () {
137         
138     if (block.chainid == 56){
139         uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // PCS BSC Mainnet Router
140     }
141     else if(block.chainid == 1 || block.chainid == 5){
142         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Uniswap ETH Mainnet Router
143     }
144     else if(block.chainid == 42161){
145         uniswapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506); // Sushi Arbitrum Mainnet Router
146     }
147     else if (block.chainid == 97){
148         uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); // PCS BSC Testnet Router
149     }
150 
151     else if (block.chainid == 11155111) {
152         // SePolia Testnet Router Address
153         uniswapV2Router = IUniswapV2Router02(0x86dcd3293C53Cf8EFd7303B57beb2a3F671dDE98);
154     }
155     
156     else {
157         revert("Wrong Chain Id");
158     }
159     
160     
161     uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
162     MarketingWallet = payable(0x16Bb519c0Aca8ab6b012DC643843a4220B8a3cB2);
163     ops = 0x85Db4e18c4579f46185c26E3100fb6C85198dc1e; // Deployer Address
164 
165     _balances[_msgSender()] = _tTotal;
166     _isExcludedFromFee[_msgSender()] = true;
167     _isExcludedFromFee[address(this)] = true;
168     _isExcludedFromFee[MarketingWallet] = true;
169     _isExcludedFromFee[ops] = true;
170     _isExcludedFromFee[deadWallet] = true;
171     _isExcludedFromFee[0xbC0D9F3E00F0196BA42D56c7d6E1d10311760378] = true; // Team
172 
173     emit Transfer(address(0), _msgSender(), _tTotal);
174 }
175     function name() public pure returns (string memory) {
176         return _name;
177     }
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balances[account];
189     }
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
202         uint256 currentAllowance = _allowances[sender][_msgSender()];
203         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), currentAllowance - amount);
206         return true;
207     }
208     function setMaxWalletSize(uint256 _maxWalletSize) external onlyOwner {
209         maxWalletSize = _maxWalletSize;
210     }
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217     function _transfer(address from, address to, uint256 amount) private {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220         require(amount > 0, "Transfer amount must be greater than zero");
221         require(!isBots[from] && !isBots[to], "You can't transfer tokens");
222         uint256 TaxSwap = 0;
223 
224         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
225             require(tradeEnable, "Trading not enabled");       
226                TaxSwap = amount * buyTaxes / 100;
227         }
228         
229         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
230             TaxSwap = 0;
231         } 
232              
233           if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + deadline){
234               TaxSwap = amount * launchtax / 100;
235           }
236          
237           if (from == uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
238              require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
239           } 
240         
241           if (from != uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
242              require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
243           }
244           if (to != uniswapV2Pair && from != address(this) && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
245             require(balanceOf(to) + amount <= maxWalletSize, "Exceeds the maxWalletSize.");
246           }  
247           if (to != uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
248               require(balanceOf(to) + amount <= maxTxAmount, "Exceeds the maxWalletSize.");
249           }
250         
251           if (to == uniswapV2Pair && from != address(this) && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
252                     TaxSwap = amount * sellTaxes / 100;
253                 
254                 } 
255        
256              uint256 contractTokenBalance = balanceOf(address(this));
257             if (!inSwap && from != uniswapV2Pair && _SwapBackEnable && contractTokenBalance >= ThresholdTokens) {
258                 swapTokensForEth(ThresholdTokens);
259                
260                uint256 contractETHBalance = address(this).balance;
261                 if(contractETHBalance > 0) {
262                     sendETHToFee(address(this).balance);
263                 }
264             }
265         
266         _balances[from] = _balances[from] - amount; 
267         _balances[to] = _balances[to] + (amount - (TaxSwap));
268         emit Transfer(from, to, amount - (TaxSwap));
269         
270          if(TaxSwap > 0){
271           _balances[address(this)] = _balances[address(this)] + (TaxSwap);
272           emit Transfer(from, address(this),TaxSwap);
273         }
274     }
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         require(tokenAmount > 0, "amount must be greeter than 0");
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = uniswapV2Router.WETH();
280         _approve(address(this), address(uniswapV2Router), tokenAmount);
281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp
287         );
288     }
289     function sendETHToFee(uint256 amount) private {
290        require(amount > 0, "amount must be greeter than 0");
291         MarketingWallet.transfer(amount);
292     }
293    function addExcludeFee(address account) external onlyOwner {
294       require(_isExcludedFromFee[account] != true,"Account is already excluded");
295        _isExcludedFromFee[account] = true;
296     emit ExcludeFromFeeUpdated(account);
297    }
298     function removeExcludeFee(address account) external onlyOwner {
299          require(_isExcludedFromFee[account] != false, "Account is already included");
300         _isExcludedFromFee[account] = false;
301      emit includeFromFeeUpdated(account);
302     }
303    function updateTaxes(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
304         require(newBuyFee <= 60 && newSellFee <= 80, "ERC20: wrong tax value!");
305         buyTaxes = newBuyFee;
306         sellTaxes = newSellFee;
307     }
308    function addBlacklist(address account) external onlyOwner {isBots[account] = true;}
309    function removeBlacklist(address account) external onlyOwner {isBots[account] = false;}
310    function removeMaxTxLimit() external onlyOwner {maxTxAmount = _tTotal;}
311    function updateSwapBackSetting(bool state) external onlyOwner {_SwapBackEnable = state;emit SwapBackSettingUpdated(state);}
312    function updateMaxTxLimit(uint256 amount) external onlyOwner {require(amount >= 100000, "amount must be greater than or equal to 0.1% of the supply");
313     maxTxAmount = amount * 10**_decimals;
314     }
315     function updateFeeReciever(address payable _newWallet) external onlyOwner {
316        require(_newWallet != address(this), "CA will not be the Fee Reciever");
317        require(_newWallet != address(0), "0 addy will not be the fee Reciever");
318        MarketingWallet = _newWallet;
319       _isExcludedFromFee[_newWallet] = true;
320     emit FeesRecieverUpdated(_newWallet);
321     }
322     function updateThreshouldToken(uint256 tokenAmount) external onlyOwner {
323         require(tokenAmount <= 1000000, "amount must be less than or equal to 1% of the supply");
324         require(tokenAmount >= 100000, "amount must be greater than or equal to 0.1% of the supply");
325         ThresholdTokens = tokenAmount * 10**_decimals;
326     emit SwapThreshouldUpdated(tokenAmount);
327     }
328     function go_live() external onlyOwner() {
329         require(!tradeEnable,"trading is already open");
330         _SwapBackEnable = true;
331          tradeEnable = true;
332        genesis_block = block.number;
333        emit TradingOpenUpdated();
334     }
335     function add() external onlyOwner() {
336         require(!tradeEnable,"trading is already open");
337         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
338         _approve(address(this), address(uniswapV2Router), _tTotal);
339         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
340         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
341     }
342     receive() external payable {}
343     function recoverERC20FromContract(address _tokenAddy, uint256 _amount) external onlyOwner {
344         require(_tokenAddy != address(this), "Owner can't claim contract's balance of its own tokens");
345         require(_amount > 0, "Amount should be greater than zero");
346         require(_amount <= IERC20(_tokenAddy).balanceOf(address(this)), "Insufficient Amount");
347         IERC20(_tokenAddy).transfer(MarketingWallet, _amount);
348       emit ERC20TokensRecovered(_amount); 
349     }
350     function recoverETHfromContract() external {
351         uint256 contractETHBalance = address(this).balance;
352         require(contractETHBalance > 0, "Amount should be greater than zero");
353         require(contractETHBalance <= address(this).balance, "Insufficient Amount");
354         payable(address(MarketingWallet)).transfer(contractETHBalance);
355       emit ETHBalanceRecovered();
356     }
357 }