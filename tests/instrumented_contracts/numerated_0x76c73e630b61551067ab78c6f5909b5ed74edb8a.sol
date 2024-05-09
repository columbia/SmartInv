1 //Twitter: https://twitter.com/fefecoineth
2 // Telegram: https://t.me/fefecoineth
3 // SPDX-License-Identifier: Unlicensed
4 
5 pragma solidity 0.8.7;
6 
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42 
43 
44 }
45 
46 contract Ownable is Context {
47     address private _owner;
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49     constructor () {
50         _owner = _msgSender();
51         emit OwnershipTransferred(address(0), _msgSender());
52     }
53 
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     function transferOwnership(address _address) external onlyOwner (){
64         emit OwnershipTransferred(_owner, _address);
65         _owner = _address;
66     }
67 
68 }  
69 
70 interface IUniswapV2Factory {
71     function createPair(address tokenA, address tokenB) external returns (address pair);
72 }
73 
74 interface IUniswapV2Router02 {
75     function swapExactTokensForETHSupportingFeeOnTransferTokens(
76         uint amountIn,
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external;
82     function factory() external pure returns (address);
83     function WETH() external pure returns (address);
84     function addLiquidityETH(
85         address token,
86         uint amountTokenDesired,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline
91     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
92 }
93 
94 contract ERC20 is Context, IERC20, Ownable {
95     using SafeMath for uint256;
96     mapping (address => uint256) private balance;
97     mapping (address => mapping (address => uint256)) private _allowances;
98     mapping (address => bool) private _isExcludedFromFee;
99     
100     uint256 private constant _tTotal = 69696969696969000000000;
101     uint256 private  maxWallet = _tTotal/100; 
102     uint256 private buyTax = 0;
103     uint256 private sellTax = 0;
104     uint256 private tax = 0;
105     address payable private marketingWallet;
106     address payable private teamWallet;
107     address payable private deployerWallet;
108     string private constant _name = "Fefe";
109     string private constant _symbol = "FEFE";
110     uint8 private constant _decimals = 9;
111     bool private inSwap = false;
112     
113     modifier lockTheSwap {
114         inSwap = true;
115         _;
116         inSwap = false;
117     }
118     IUniswapV2Router02 private uniswapV2Router;
119     address private uniswapV2Pair;
120     bool private tradingOpen;
121     bool private paused;
122     uint256 private _maxTxAmount = _tTotal;
123     event MaxTxAmountUpdated(uint _maxTxAmount);
124     event MaxWalletPercUpdated(uint _maxWalletPerc);
125     
126     constructor (address payable _marketingWallet, address payable _deployerWallet,address payable _teamWallet) { 
127         require(_marketingWallet != address(0),"Zero address exception");
128         require(_deployerWallet != address(0),"Zero address exception");
129         require(_teamWallet != address(0),"Zero address exception");
130         marketingWallet = _marketingWallet;
131         deployerWallet = _deployerWallet;
132         teamWallet = _teamWallet;
133         balance[msg.sender] = _tTotal;
134         _isExcludedFromFee[owner()] = true;
135         _isExcludedFromFee[address(this)] = true;
136         _isExcludedFromFee[marketingWallet] = true;
137         emit Transfer(address(0),owner(), _tTotal);
138     }
139 
140     function name() external pure returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() external pure returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() external pure returns (uint8) {
149         return _decimals;
150     }
151 
152     function totalSupply() external pure override returns (uint256) {
153         return _tTotal;
154     }
155 
156     function balanceOf(address account) public view override returns (uint256) {
157         return balance[account];
158     }
159 
160     function transfer(address recipient, uint256 amount) external override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(address holder, address spender) external view override returns (uint256) {
166         return _allowances[holder][spender];
167     }
168 
169     function approve(address spender, uint256 amount) external override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174     function isWhitelisted(address _addr) external view returns(bool){
175         return _isExcludedFromFee[_addr];
176     }
177 
178     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
179         _transfer(sender, recipient, amount);
180         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
181         return true;
182     }
183 
184     function _approve(address holder, address spender, uint256 amount) private {
185         require(holder != address(0), "ERC20: approve from the zero address");
186         require(spender != address(0), "ERC20: approve to the zero address");
187         _allowances[holder][spender] = amount;
188         emit Approval(holder, spender, amount);
189     }
190 
191     function _transfer(address from, address to, uint256 amount) private {
192         require(amount > 0, "Transfer amount must be greater than zero");
193         require(balanceOf(from) >= amount,"Balance less then transfer"); 
194 
195         tax = 0;
196         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {            
197             require(!paused,"Trading is paused");
198             require(amount <= _maxTxAmount,"Amount exceed max trnx amount");
199             
200             if(to != uniswapV2Pair){   //can't have tokens over maxWallet 
201             require(balanceOf(to) + amount <= maxWallet,"max Wallet limit exceeded");
202             }
203             uint256 contractETHBalance = address(this).balance;
204             if(contractETHBalance > 500000000000000000) { 
205                 sendETHToFee(address(this).balance);
206             }
207             if(from == uniswapV2Pair){
208                 tax = buyTax;
209             }
210             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
211                 tax = sellTax;
212                 uint256 contractTokenBalance = balanceOf(address(this));
213                 if(!inSwap){
214                     if(contractTokenBalance > _tTotal/1000){ // 0.01%
215                         swapTokensForEth(contractTokenBalance);
216                     }
217                 }
218             }
219                
220         }
221         _tokenTransfer(from,to,amount);
222     }
223 
224 
225     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
226         address[] memory path = new address[](2);
227         path[0] = address(this);
228         path[1] = uniswapV2Router.WETH();
229         _approve(address(this), address(uniswapV2Router), tokenAmount);
230         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
231             tokenAmount,
232             0,
233             path,
234             address(this),
235             block.timestamp
236         );
237     }
238     
239 
240     function walletAmountLimitOff() external onlyOwner{
241         require(tradingOpen,"Trading is not enabled yet");
242         _maxTxAmount = _tTotal;
243         maxWallet = _tTotal;
244         emit MaxTxAmountUpdated(_tTotal);
245         emit MaxWalletPercUpdated(_tTotal);
246     }
247 
248     function sendETHToFee(uint256 amount) private {
249         marketingWallet.transfer(amount*3/5);
250         teamWallet.transfer(amount/5);
251         deployerWallet.transfer(address(this).balance);        
252     }
253     
254     
255     function openTrading() external onlyOwner {
256         require(!tradingOpen,"trading is already open");
257         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
258         uniswapV2Router = _uniswapV2Router;
259         _approve(address(this), address(uniswapV2Router), _tTotal);
260         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
261         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
262         _maxTxAmount = _tTotal*69/1000;
263         maxWallet = _tTotal*69/1000;
264         buyTax = 20;
265         sellTax = 20;
266         tradingOpen = true;
267         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
268     }
269 
270 
271     function dropTaxes(uint256 _buyTax,uint256 _sellTax) external {
272         require(msg.sender == deployerWallet,"Only Deployer Can this function");
273         require(_buyTax < 3 && _sellTax < 3,"Max Tax is 2"); // Prevent tax to be over 2%
274         buyTax = _buyTax;
275         sellTax = _sellTax;
276     }
277 
278     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
279         
280         uint256 tTeam = amount*tax/100;    
281         uint256 remainingAmount = amount - tTeam; 
282         balance[sender] = balance[sender].sub(amount); 
283         balance[recipient] = balance[recipient].add(remainingAmount); 
284         balance[address(this)] = balance[address(this)].add(tTeam); 
285         emit Transfer(sender, recipient, remainingAmount);
286     }
287 
288     function whitelistAddress(address _addr,bool _bool) external {
289         require(msg.sender == deployerWallet,"Only team can call this function");
290         _isExcludedFromFee[_addr] = _bool;
291     }
292 
293     receive() external payable {}
294     
295     function transferERC20(IERC20 token, uint256 amount) external { //function to transfer stuck erc20 tokens
296         require(msg.sender == deployerWallet,"Only team can call this function");
297         require(token != IERC20(address(this)),"You can't withdraw tokens from owned by contract."); 
298         uint256 erc20balance = token.balanceOf(address(this));
299         require(amount <= erc20balance, "balance is low");
300         token.transfer(deployerWallet, amount);
301     }
302 
303 
304     function changeWallet(address payable _marketingWallet, address payable _deployerWallet,address payable _teamWallet) external {
305         require(msg.sender == deployerWallet,"Only team can call this function");
306         require(_marketingWallet != address(0),"Zero address exception");
307         require(_deployerWallet != address(0),"Zero address exception");
308         require(_teamWallet != address(0),"Zero address exception");
309         marketingWallet = _marketingWallet;
310         deployerWallet = _deployerWallet;
311         teamWallet = _teamWallet;
312     }
313 
314     function manualswap() external {
315         require(msg.sender == deployerWallet,"Only team can call this function");
316         uint256 contractBalance = balanceOf(address(this));
317         swapTokensForEth(contractBalance);
318     }
319     
320     function manualsend() external {
321         require(msg.sender == deployerWallet,"Only team can call this function");
322         uint256 contractETHBalance = address(this).balance;
323         sendETHToFee(contractETHBalance);
324     }
325 }