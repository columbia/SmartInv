1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.7;
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39 
40 
41 }
42 
43 contract Ownable is Context {
44     address private _owner;
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46     address constant private multiSigWallet  = address(0x93837577c98E01CFde883c23F64a0f608A70B90F);
47     constructor () {
48         _owner = multiSigWallet;
49         emit OwnershipTransferred(address(0), multiSigWallet);
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function transferOwnership(address _address) external onlyOwner notLocked(Functions.changeOwnership){
62         emit OwnershipTransferred(_owner, _address);
63         _owner = _address;
64         timelock[Functions.changeOwnership] = 0;
65     }
66     enum Functions {changeOwnership,changeMarketWallet,pause }
67     mapping(Functions => uint256) public timelock;
68 
69     modifier notLocked(Functions _func) {
70     require(
71         timelock[_func] != 0 && timelock[_func] <= block.timestamp,
72         "Function is timelocked"
73     );
74     _;
75     }
76 }  
77 
78 interface IUniswapV2Factory {
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 }
81 
82 interface IUniswapV2Router02 {
83     function swapExactTokensForETHSupportingFeeOnTransferTokens(
84         uint amountIn,
85         uint amountOutMin,
86         address[] calldata path,
87         address to,
88         uint deadline
89     ) external;
90     function factory() external pure returns (address);
91     function WETH() external pure returns (address);
92     function addLiquidityETH(
93         address token,
94         uint amountTokenDesired,
95         uint amountTokenMin,
96         uint amountETHMin,
97         address to,
98         uint deadline
99     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
100 }
101 
102 contract Kawakami is Context, IERC20, Ownable {
103     using SafeMath for uint256;
104     mapping (address => uint256) private balance;
105     mapping (address => mapping (address => uint256)) private _allowances;
106     mapping (address => bool) private _isExcludedFromFee;
107     mapping (address => bool) private bots;
108     
109     uint256 private constant _tTotal = 9.99999999999e20; //999,999,999,999.000000000
110     uint256 private constant maxWallet = _tTotal/50; 
111     uint256 private buyTax = 5;
112     uint256 private constant sellTax = 9;
113     uint256 private tax = 0;
114     uint256 private tradingEnableTime;
115     uint256 private constant _TIMELOCK = 2 days;
116     address payable private marketingWallet;
117     address payable private devWallet;
118     string private constant _name = "Kawakami";
119     string private constant _symbol = "KAWA";
120     uint8 private constant _decimals = 9;
121     bool private inSwap = false;
122     
123     modifier lockTheSwap {
124         inSwap = true;
125         _;
126         inSwap = false;
127     }
128     IUniswapV2Router02 private uniswapV2Router;
129     address private uniswapV2Pair;
130     bool private tradingOpen;
131     bool private paused;
132     uint256 private _maxTxAmount = _tTotal;
133     event MaxTxAmountUpdated(uint _maxTxAmount);
134     
135     function unlockFunction(Functions _func) external onlyOwner {
136         require(timelock[_func] == 0);
137         timelock[_func] = block.timestamp + _TIMELOCK;
138     } 
139 
140     function lockFunction(Functions _func) external onlyOwner {
141         timelock[_func] = 0;
142     }
143     
144     constructor (address payable _add1, address payable _add2) { 
145         require(_add1 != address(0),"Marketing Wallet can not be zero");
146         require(_add2 != address(0),"Marketing Wallet can not be zero");
147         marketingWallet = _add1;
148         devWallet = _add2;
149         balance[owner()] = _tTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[marketingWallet] = true;
153         emit Transfer(address(0),owner(), _tTotal);
154     }
155 
156     function name() external pure returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() external pure returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() external pure returns (uint8) {
165         return _decimals;
166     }
167 
168     function totalSupply() external pure override returns (uint256) {
169         return _tTotal;
170     }
171 
172     function balanceOf(address account) public view override returns (uint256) {
173         return balance[account];
174     }
175 
176     function transfer(address recipient, uint256 amount) external override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address holder, address spender) external view override returns (uint256) {
182         return _allowances[holder][spender];
183     }
184 
185     function approve(address spender, uint256 amount) external override returns (bool) {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function isWhitelisted(address _addr) external view returns(bool){
191         return _isExcludedFromFee[_addr];
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function _approve(address holder, address spender, uint256 amount) private {
201         require(holder != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[holder][spender] = amount;
204         emit Approval(holder, spender, amount);
205     }
206 
207     function _transfer(address from, address to, uint256 amount) private {
208         require(amount > 0, "Transfer amount must be greater than zero");
209         require(balanceOf(from) >= amount,"Balance less then transfer");
210         require(!bots[from],"Blacklisted can't trade");
211         tax = 0;
212         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {            
213             require(!paused,"Trading is paused");
214             require(amount <= _maxTxAmount,"Amount exceed max trnx amount");
215 
216             if(to != uniswapV2Pair){   //can't have tokens over maxWallet 
217             require(balanceOf(to) + amount*(1-(buyTax/100)) <= maxWallet,"max Wallet limit exceeded");
218             }
219             uint256 contractETHBalance = address(this).balance;
220             if(contractETHBalance > 1 ether) { // Minimum 1 eth before sending to marketing wallet
221                 sendETHToFee(address(this).balance);
222             }
223             if(from == uniswapV2Pair){ // Buy transaction
224                 tax = buyTax;
225             } 
226             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
227                 tax = sellTax;
228                 uint256 contractTokenBalance = balanceOf(address(this));
229                 if(!inSwap){
230                     if(contractTokenBalance > _tTotal/1000){ // 0.01%
231                         swapTokensForEth(contractTokenBalance);
232                     }
233                 }
234             }
235                
236         }
237         _tokenTransfer(from,to,amount);
238     }
239 
240 
241     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
242         address[] memory path = new address[](2);
243         path[0] = address(this);
244         path[1] = uniswapV2Router.WETH();
245         _approve(address(this), address(uniswapV2Router), tokenAmount);
246         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
247             tokenAmount,
248             0,
249             path,
250             address(this),
251             block.timestamp
252         );
253     }
254     
255     function liftMaxTx() external{
256         require(tradingOpen,"Trading is not enabled yet");
257         require(tradingEnableTime+ 10 minutes <  block.timestamp,"Transaction limit can only be lifted 10 mins after trading is enanbled");
258         _maxTxAmount = _tTotal ;
259         emit MaxTxAmountUpdated(_tTotal);
260     }
261 
262     function sendETHToFee(uint256 amount) private {
263         devWallet.transfer((amount*14)/100);
264         marketingWallet.transfer(address(this).balance);        
265     }
266     
267     
268     function openTrading() external onlyOwner {
269         require(!tradingOpen,"trading is already open");
270         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
271         uniswapV2Router = _uniswapV2Router;
272         _approve(address(this), address(uniswapV2Router), _tTotal);
273         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
274         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
275         _maxTxAmount = _tTotal/1000;
276         tradingOpen = true;
277         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
278         tradingEnableTime = block.timestamp;
279     }
280     
281     function blacklistBot(address _address) external onlyOwner{
282             bots[_address] = true;
283     }
284     
285     function changeMarketingWallet( address payable _address) external onlyOwner notLocked(Functions.changeMarketWallet){
286         require(_address != address(0),"Marketing Wallet can not be zero");
287         marketingWallet = _address;
288         timelock[Functions.changeMarketWallet] = 0;
289     }
290 
291     function removeFromBlacklist(address notbot) external onlyOwner{
292         bots[notbot] = false;
293     }
294 
295     function emergencyPause() external onlyOwner notLocked(Functions.pause){
296         paused = !paused;
297         timelock[Functions.pause] = 0;
298     }
299 
300     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
301         
302         uint256 tTeam = amount*tax/100;    // tax amount
303         uint256 remainingAmount = amount - tTeam; // to Send
304         balance[sender] = balance[sender].sub(amount); // deduct from sender
305         balance[recipient] = balance[recipient].add(remainingAmount); // add to recipient
306         balance[address(this)] = balance[address(this)].add(tTeam); // add team Take to address
307         emit Transfer(sender, recipient, remainingAmount);
308     }
309 
310     function whitelistAddress(address _addr,bool _bool) external onlyOwner{    //add or remove address from whitelist
311         _isExcludedFromFee[_addr] = _bool;
312     }
313 
314     receive() external payable {}
315     
316     function transferERC20(IERC20 token, uint256 amount) external onlyOwner{ //function to transfer stuck erc20 tokens
317         require(token != IERC20(address(this)),"You can't withdraw kawa tokens from owned by contract."); 
318         uint256 erc20balance = token.balanceOf(address(this));
319         require(amount <= erc20balance, "balance is low");
320         token.transfer(marketingWallet, amount);
321     }
322     event buyTaxUpdated(uint256 _newTaxAmount);   
323     function changeBuyTax(uint256 _newBuyTax) external onlyOwner{
324         require(_newBuyTax < 6,"New Buy tax have to be under 6");
325         buyTax = _newBuyTax;
326         emit buyTaxUpdated(_newBuyTax);
327     }
328 
329     function manualswap() external onlyOwner{
330         uint256 contractBalance = balanceOf(address(this));
331         swapTokensForEth(contractBalance);
332     }
333     
334     function manualsend() external onlyOwner{
335         uint256 contractETHBalance = address(this).balance;
336         sendETHToFee(contractETHBalance);
337     }
338 }