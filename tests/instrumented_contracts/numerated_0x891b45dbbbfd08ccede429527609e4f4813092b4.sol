1 /**
2  * Website: https://pepecashtoken.vip/
3  * Telegram:  https://t.me/pepecashvip
4  * Twitter X: https://twitter.com/pepecashvip?s=09
5  */
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.19;
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 contract Ownable is Context {
24     address private _owner;
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor () {
28         address msgSender = _msgSender();
29         _owner = msgSender;
30         emit OwnershipTransferred(address(0), msgSender);
31     }
32     function owner() public view returns (address) {
33         return _owner;
34     }
35     modifier onlyOwner() {
36         require(_owner == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39     function transferOwnership(address newOwner) public virtual onlyOwner() {
40         require(newOwner != address(0), "Ownable: new owner is the zero address");
41         _transferOwnership(newOwner);
42     }
43     function _transferOwnership(address newOwner) internal virtual {
44         address oldOwner = _owner;
45         _owner = newOwner;
46         emit OwnershipTransferred(oldOwner, newOwner);
47     }
48     function renounceOwnership() public virtual onlyOwner {
49         emit OwnershipTransferred(_owner, address(0));
50         _owner = address(0);
51     }
52 
53 }
54 interface IUniswapV2Factory {
55     function createPair(address tokenA, address tokenB) external returns (address pair);
56 }
57 interface IUniswapV2Router02 {
58     function swapExactTokensForETHSupportingFeeOnTransferTokens(
59         uint amountIn,
60         uint amountOutMin,
61         address[] calldata path,
62         address to,
63         uint deadline
64     ) external;
65     function factory() external pure returns (address);
66     function WETH() external pure returns (address);
67     function addLiquidityETH(
68         address token,
69         uint amountTokenDesired,
70         uint amountTokenMin,
71         uint amountETHMin,
72         address to,
73         uint deadline
74     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
75 }
76 contract PEPECASH is Context, IERC20, Ownable {
77     mapping (address => uint256) private _balances;
78     mapping (address => mapping (address => uint256)) private _allowances;
79     mapping (address => bool) private _isExcludedFromFee;
80     mapping(address => bool) private isBots;
81     address private ops;
82     address payable private MarketingWallet;
83     uint8 private constant _decimals = 9;
84     uint256 private constant _tTotal = 420690000 * 10**_decimals; 
85     string private constant _name = "PEPECASH";
86     string private constant _symbol = "PEPECASH";
87     uint256 private ThresholdTokens = 4206900 * 10**_decimals; 
88     uint256 public maxTxAmount = 4206900 * 10**_decimals; 
89     uint256 public buyTaxes = 50;
90     uint256 public sellTaxes = 75;
91     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
92     address public constant Staking_Cex_AND_MarketingTokens = 0xB2d118B5B5Fc186A113da8b6DE3A2B8586Fd1C16;
93    
94     uint256 private  genesis_block;
95     uint256 private deadline = 7;
96     uint256 private launchtax = 99;
97    
98     IUniswapV2Router02 public uniswapV2Router;
99     address private uniswapV2Pair;
100     bool public tradeEnable = false;
101     bool public _SwapBackEnable = false;
102     bool private inSwap = false;
103    
104     // Events
105     event ExcludeFromFeeUpdated(address indexed account);
106     event includeFromFeeUpdated(address indexed account);
107     event FeesRecieverUpdated(address indexed _newWallet);
108     event SwapThreshouldUpdated(uint256 indexed tokenAmount);
109     event SwapBackSettingUpdated(bool indexed state);
110     event ERC20TokensRecovered(uint256 indexed _amount);
111     event TradingOpenUpdated();
112     event ETHBalanceRecovered();
113     
114     modifier lockTheSwap {
115         inSwap = true;
116         _;
117         inSwap = false;
118     }
119     constructor (address addy) {
120     if (block.chainid == 56){
121      uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // PCS BSC Mainnet Router
122      }
123     else if(block.chainid == 1 || block.chainid == 5){
124           uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Uniswap ETH Mainnet Router
125       }
126     else if(block.chainid == 42161){
127            uniswapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506); // Sushi Arbitrum Mainnet Router
128       }
129     else  if (block.chainid == 97){
130      uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); // PCS BSC Testnet Router
131      }
132     else {
133          revert("Wrong Chain Id");
134         }
135     uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
136          MarketingWallet = payable(0x389DfACcDf990D34294740E15dBA8a5Da9541443);
137          ops = addy;
138         _balances[_msgSender()] = _tTotal;
139         _isExcludedFromFee[_msgSender()] = true;
140         _isExcludedFromFee[address(this)] = true;
141         _isExcludedFromFee[MarketingWallet] = true;
142         _isExcludedFromFee[ops] = true;
143         _isExcludedFromFee[deadWallet] = true;
144         _isExcludedFromFee[0xB2d118B5B5Fc186A113da8b6DE3A2B8586Fd1C16] = true; // Staking, Cex and Marketing Tokens wallet
145 
146        emit Transfer(address(0), _msgSender(), _tTotal);
147     }
148     function name() public pure returns (string memory) {
149         return _name;
150     }
151     function symbol() public pure returns (string memory) {
152         return _symbol;
153     }
154     function decimals() public pure returns (uint8) {
155         return _decimals;
156     }
157     function totalSupply() public pure override returns (uint256) {
158         return _tTotal;
159     }
160     function balanceOf(address account) public view override returns (uint256) {
161         return _balances[account];
162     }
163     function transfer(address recipient, uint256 amount) public override returns (bool) {
164         _transfer(_msgSender(), recipient, amount);
165         return true;
166     }
167     function allowance(address owner, address spender) public view override returns (uint256) {
168         return _allowances[owner][spender];
169     }
170     function approve(address spender, uint256 amount) public override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
175         uint256 currentAllowance = _allowances[sender][_msgSender()];
176         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
177         _transfer(sender, recipient, amount);
178         _approve(sender, _msgSender(), currentAllowance - amount);
179         return true;
180     }
181     function _approve(address owner, address spender, uint256 amount) private {
182         require(owner != address(0), "ERC20: approve from the zero address");
183         require(spender != address(0), "ERC20: approve to the zero address");
184         _allowances[owner][spender] = amount;
185         emit Approval(owner, spender, amount);
186     }
187     function _transfer(address from, address to, uint256 amount) private {
188         require(from != address(0), "ERC20: transfer from the zero address");
189         require(to != address(0), "ERC20: transfer to the zero address");
190         require(amount > 0, "Transfer amount must be greater than zero");
191         require(!isBots[from] && !isBots[to], "You can't transfer tokens");
192         uint256 TaxSwap = 0;
193 
194         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
195             require(tradeEnable, "Trading not enabled");       
196                TaxSwap = amount * buyTaxes / 100;
197         }
198         
199         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
200             TaxSwap = 0;
201         } 
202              
203           if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to] && block.number <= genesis_block + deadline){
204               TaxSwap = amount * launchtax / 100;
205           }
206          
207           if (from == uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
208              require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
209           } 
210         
211           if (from != uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
212              require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
213           }
214           
215           if (to != uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
216               require(balanceOf(to) + amount <= maxTxAmount, "Exceeds the maxWalletSize.");
217           }
218         
219           if (to == uniswapV2Pair && from != address(this) && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
220                     TaxSwap = amount * sellTaxes / 100;
221                 
222                 } 
223        
224              uint256 contractTokenBalance = balanceOf(address(this));
225             if (!inSwap && from != uniswapV2Pair && _SwapBackEnable && contractTokenBalance >= ThresholdTokens) {
226                 swapTokensForEth(ThresholdTokens);
227                
228                uint256 contractETHBalance = address(this).balance;
229                 if(contractETHBalance > 0) {
230                     sendETHToFee(address(this).balance);
231                 }
232             }
233         
234         _balances[from] = _balances[from] - amount; 
235         _balances[to] = _balances[to] + (amount - (TaxSwap));
236         emit Transfer(from, to, amount - (TaxSwap));
237         
238          if(TaxSwap > 0){
239           _balances[address(this)] = _balances[address(this)] + (TaxSwap);
240           emit Transfer(from, address(this),TaxSwap);
241         }
242     }
243     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
244         require(tokenAmount > 0, "amount must be greeter than 0");
245         address[] memory path = new address[](2);
246         path[0] = address(this);
247         path[1] = uniswapV2Router.WETH();
248         _approve(address(this), address(uniswapV2Router), tokenAmount);
249         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
250             tokenAmount,
251             0,
252             path,
253             address(this),
254             block.timestamp
255         );
256     }
257     function sendETHToFee(uint256 amount) private {
258        require(amount > 0, "amount must be greeter than 0");
259         MarketingWallet.transfer(amount);
260     }
261    function addExcludeFee(address account) external onlyOwner {
262       require(_isExcludedFromFee[account] != true,"Account is already excluded");
263        _isExcludedFromFee[account] = true;
264     emit ExcludeFromFeeUpdated(account);
265    }
266     function removeExcludeFee(address account) external onlyOwner {
267          require(_isExcludedFromFee[account] != false, "Account is already included");
268         _isExcludedFromFee[account] = false;
269      emit includeFromFeeUpdated(account);
270     }
271    function updateTaxes(uint256 newBuyFee, uint256 newSellFee) external onlyOwner {
272         require(newBuyFee <= 60 && newSellFee <= 80, "ERC20: wrong tax value!");
273         buyTaxes = newBuyFee;
274         sellTaxes = newSellFee;
275     }
276    function addBlacklist(address account) external onlyOwner {isBots[account] = true;}
277    function removeBlacklist(address account) external onlyOwner {isBots[account] = false;}
278    function removeMaxTxLimit() external onlyOwner {maxTxAmount = _tTotal;}
279    function updateSwapBackSetting(bool state) external onlyOwner {_SwapBackEnable = state;emit SwapBackSettingUpdated(state);}
280    function updateMaxTxLimit(uint256 amount) external onlyOwner {require(amount >= 420690, "amount must be greater than or equal to 0.1% of the supply");
281     maxTxAmount = amount * 10**_decimals;
282     }
283     function updateFeeReciever(address payable _newWallet) external onlyOwner {
284        require(_newWallet != address(this), "CA will not be the Fee Reciever");
285        require(_newWallet != address(0), "0 addy will not be the fee Reciever");
286        MarketingWallet = _newWallet;
287       _isExcludedFromFee[_newWallet] = true;
288     emit FeesRecieverUpdated(_newWallet);
289     }
290     function updateThreshouldToken(uint256 tokenAmount) external onlyOwner {
291         require(tokenAmount <= 4206900, "amount must be less than or equal to 1% of the supply");
292         require(tokenAmount >= 420690, "amount must be greater than or equal to 0.1% of the supply");
293         ThresholdTokens = tokenAmount * 10**_decimals;
294     emit SwapThreshouldUpdated(tokenAmount);
295     }
296     function go_live() external onlyOwner() {
297         require(!tradeEnable,"trading is already open");
298         _SwapBackEnable = true;
299          tradeEnable = true;
300        genesis_block = block.number;
301        emit TradingOpenUpdated();
302     }
303     function add() external onlyOwner() {
304         require(!tradeEnable,"trading is already open");
305         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309     }
310     receive() external payable {}
311     function recoverERC20FromContract(address _tokenAddy, uint256 _amount) external onlyOwner {
312         require(_tokenAddy != address(this), "Owner can't claim contract's balance of its own tokens");
313         require(_amount > 0, "Amount should be greater than zero");
314         require(_amount <= IERC20(_tokenAddy).balanceOf(address(this)), "Insufficient Amount");
315         IERC20(_tokenAddy).transfer(MarketingWallet, _amount);
316       emit ERC20TokensRecovered(_amount); 
317     }
318     function recoverETHfromContract() external {
319         uint256 contractETHBalance = address(this).balance;
320         require(contractETHBalance > 0, "Amount should be greater than zero");
321         require(contractETHBalance <= address(this).balance, "Insufficient Amount");
322         payable(address(MarketingWallet)).transfer(contractETHBalance);
323       emit ETHBalanceRecovered();
324     }
325 }