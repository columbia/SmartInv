1 // SPDX-License-Identifier: MIT
2 
3  /** ///////////////
4  *  $SHEPE -> $SHIA
5  *  $SHEPE -> $SHIA
6  *  ///////////////
7  *  $SHEPE -> $SHIA
8 */ ///////////////        
9             
10 pragma solidity 0.8.19;
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 contract Ownable is Context {
27     address private _owner;
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor () {
31         address msgSender = _msgSender();
32         _owner = msgSender;
33         emit OwnershipTransferred(address(0), msgSender);
34     }
35     function owner() public view returns (address) {
36         return _owner;
37     }
38     modifier onlyOwner() {
39         require(_owner == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42     function transferOwnership(address newOwner) public virtual onlyOwner() {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46     function _transferOwnership(address newOwner) internal virtual {
47         address oldOwner = _owner;
48         _owner = newOwner;
49         emit OwnershipTransferred(oldOwner, newOwner);
50     }
51     function renounceOwnership() public virtual onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56 }
57 interface IUniswapV2Factory {
58     function createPair(address tokenA, address tokenB) external returns (address pair);
59 }
60 interface IUniswapV2Router02 {
61     function swapExactTokensForETHSupportingFeeOnTransferTokens(
62         uint amountIn,
63         uint amountOutMin,
64         address[] calldata path,
65         address to,
66         uint deadline
67     ) external;
68     function factory() external pure returns (address);
69     function WETH() external pure returns (address);
70     function addLiquidityETH(
71         address token,
72         uint amountTokenDesired,
73         uint amountTokenMin,
74         uint amountETHMin,
75         address to,
76         uint deadline
77     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
78 }
79 
80 contract SHEPE is Context, IERC20, Ownable {
81     mapping (address => uint256) private _balances;
82     mapping (address => mapping (address => uint256)) private _allowances;
83     mapping (address => bool) private _isExcludedFromFee;
84     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
85     address payable public MarketingWallet;
86     uint8 private constant _decimals = 9;
87     uint256 private constant _tTotal =  420690000000000 * 10**_decimals; 
88     string private constant _name = "Shiba V Pepe";
89     string private constant _symbol = "SHEPE";
90     uint256 private SwapTokens = 1262070000000 * 10**_decimals; 
91     uint256 private maxSwapTokens = 4206900000000 * 10**_decimals;
92     uint256 public maxTxAmount = 8413800000000 * 10**_decimals; 
93     uint256 private _launchBuyTax = 40;
94     uint256 private _launchSellTax = 40;
95     uint256 private buyTaxes = 1;
96     uint256 private sellTaxes = 1;
97     bool private _isFinalFeeDone = false;
98     uint256 private _Buys_In = 0;
99    
100     IUniswapV2Router02 public uniswapV2Router;
101     address private uniswapV2Pair;
102     bool public tradeEnable = false;
103     bool private _SwapBackEnable = false;
104     bool private inSwap = false;
105     event FeesRecieverUpdated(address indexed _newWallet);
106     event ExcludeFromFeeUpdated(address indexed account);
107     event includeFromFeeUpdated(address indexed account);
108     event SwapThreshouldUpdated(uint256 indexed minToken, uint256 indexed maxToken);
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
119     constructor () {
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
136          MarketingWallet = payable(0x97b28b82de625e5191d26166ed6368dC8129C179);
137         _balances[_msgSender()] = _tTotal;
138         _isExcludedFromFee[_msgSender()] = true;
139         _isExcludedFromFee[address(this)] = true;
140         _isExcludedFromFee[MarketingWallet] = true;
141         _isExcludedFromFee[deadWallet] = true;
142 
143        emit Transfer(address(0), _msgSender(), _tTotal);
144     }
145     function name() public pure returns (string memory) {
146         return _name;
147     }
148     function symbol() public pure returns (string memory) {
149         return _symbol;
150     }
151     function decimals() public pure returns (uint8) {
152         return _decimals;
153     }
154     function totalSupply() public pure override returns (uint256) {
155         return _tTotal;
156     }
157     function balanceOf(address account) public view override returns (uint256) {
158         return _balances[account];
159     }
160     function min(uint256 a, uint256 b) private pure returns (uint256) {
161         return (a > b) ? b : a;
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
191         uint256 TaxSwap=0;
192 
193         if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
194             require(tradeEnable, "Trading not enabled");       
195                TaxSwap = amount * ((_isFinalFeeDone)? buyTaxes : _launchBuyTax) / (100);
196         }
197         
198          if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
199             TaxSwap = 0;
200         } 
201          
202           if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
203              require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
204              require(balanceOf(to) + amount <= maxTxAmount, "Exceeds the maxWalletSize.");
205               _Buys_In++;
206           } 
207         
208           if (from != uniswapV2Pair && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
209              require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
210           }
211         
212           if (to == uniswapV2Pair && from != address(this) && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
213                    TaxSwap = amount * ((_isFinalFeeDone)? sellTaxes : _launchSellTax) / (100);
214                 
215                 } 
216        
217              uint256 contractTokenBalance = balanceOf(address(this));
218             if (!inSwap && from != uniswapV2Pair && _SwapBackEnable && contractTokenBalance > SwapTokens && _Buys_In > 1) {
219                 swapTokensForEth(min(amount, min(contractTokenBalance, maxSwapTokens)));
220                uint256 contractETHBalance = address(this).balance;
221                 if(contractETHBalance > 0) {
222                     sendETHToFee(address(this).balance);
223                 }
224             }
225         _balances[from] = _balances[from] - amount; 
226         _balances[to] = _balances[to] + (amount - (TaxSwap));
227         emit Transfer(from, to, amount - (TaxSwap));
228          if(TaxSwap > 0){
229           _balances[address(this)] = _balances[address(this)] + (TaxSwap);
230           emit Transfer(from, address(this),TaxSwap);
231         }
232     }
233     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
234         require(tokenAmount > 0, "amount must be greeter than 0");
235         address[] memory path = new address[](2);
236         path[0] = address(this);
237         path[1] = uniswapV2Router.WETH();
238         _approve(address(this), address(uniswapV2Router), tokenAmount);
239         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
240             tokenAmount,
241             0,
242             path,
243             address(this),
244             block.timestamp
245         );
246     }
247     function sendETHToFee(uint256 amount) private {
248        require(amount > 0, "amount must be greeter than 0");
249         MarketingWallet.transfer(amount);
250     }
251    function removeMaxTxLimit() external onlyOwner {maxTxAmount = _tTotal;}
252    function updateFinalFee() external onlyOwner {_isFinalFeeDone = true;}
253    function updateSwapBackSetting(bool state) external onlyOwner {_SwapBackEnable = state;emit SwapBackSettingUpdated(state);}
254    function setMarketingWallet(address payable _newWallet) external onlyOwner {
255        require(_newWallet != address(this), "CA will not be the Fee Reciever");
256        require(_newWallet != address(0), "0 addy will not be the fee Reciever");
257        MarketingWallet = _newWallet;
258       _isExcludedFromFee[_newWallet] = true;
259     emit FeesRecieverUpdated(_newWallet);
260     }
261     
262     function excludeFromFee(address account) external onlyOwner {
263       require(_isExcludedFromFee[account] != true,"Account is already excluded");
264        _isExcludedFromFee[account] = true;
265     emit ExcludeFromFeeUpdated(account);
266    }
267    
268     function includeFromFee(address account) external onlyOwner {
269          require(_isExcludedFromFee[account] != false, "Account is already included");
270         _isExcludedFromFee[account] = false;
271      emit includeFromFeeUpdated(account);
272     }
273    
274     function updateThreshouldToken(uint256 minToken, uint256 maxToken) external onlyOwner {
275         require(maxToken <= 4206900000000, "amount must be less than or equal to 1% of the supply");
276         require(minToken <= 1262070000000, "amount must be less than or equal to 0.3% of the supply");
277         SwapTokens = minToken * 10**_decimals;
278        maxSwapTokens = maxToken * 10**_decimals;
279     emit SwapThreshouldUpdated(minToken, maxToken);
280     }
281     
282     function OpenTrading() external onlyOwner() {
283         require(!tradeEnable,"trading is already open");
284         _SwapBackEnable = true;
285          tradeEnable = true;
286        emit TradingOpenUpdated();
287     }
288     
289     receive() external payable {}
290    
291     function recoverERC20FromContract(address _tokenAddy, uint256 _amount) external onlyOwner {
292         require(_tokenAddy != address(this), "Owner can't claim contract's balance of its own tokens");
293         require(_amount > 0, "Amount should be greater than zero");
294         require(_amount <= IERC20(_tokenAddy).balanceOf(address(this)), "Insufficient Amount");
295         IERC20(_tokenAddy).transfer(MarketingWallet, _amount);
296       emit ERC20TokensRecovered(_amount); 
297     }
298    
299     function recoverETHfromContract() external {
300         uint256 contractETHBalance = address(this).balance;
301         require(contractETHBalance > 0, "Amount should be greater than zero");
302         require(contractETHBalance <= address(this).balance, "Insufficient Amount");
303         payable(address(MarketingWallet)).transfer(contractETHBalance);
304       emit ETHBalanceRecovered();
305     }
306 }