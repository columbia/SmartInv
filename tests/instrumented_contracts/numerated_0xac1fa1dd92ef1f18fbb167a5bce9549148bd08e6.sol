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
46     constructor () {
47         _owner = _msgSender();
48         emit OwnershipTransferred(address(0), _msgSender());
49     }
50 
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     function transferOwnership(address _address) external onlyOwner notLocked(Functions.changeOwnership){
61         require(_address != address(0),"New owner can not be zero address");
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
102 contract HEIM is Context, IERC20, Ownable {
103     using SafeMath for uint256;
104     mapping (address => uint256) private balance;
105     mapping (address => mapping (address => uint256)) private _allowances;
106     mapping (address => bool) private _isExcludedFromFee;
107     mapping (address => bool) private bots;
108     
109     uint256 private constant _tTotal = 1e18; //1,000,000.000 000 000
110     uint256 private  maxWallet = _tTotal/50; 
111     uint256 private taxAmount = 8;
112     uint256 private tax = 0;
113     uint256 private tradingEnableTime;
114     uint256 private constant _TIMELOCK = 2 days;
115     address payable private marketingWallet;
116     address payable private founderWallet;
117     address payable private devWallet;
118     string private constant _name = "Heimdl Coin";
119     string private constant _symbol = "HEIM";
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
134     event MaxWalletPercUpdated(uint _maxWalletPerc);
135     function unlockFunction(Functions _func) external onlyOwner {
136         require(timelock[_func] == 0);
137         timelock[_func] = block.timestamp + _TIMELOCK;
138     } 
139 
140     function lockFunction(Functions _func) external onlyOwner {
141         timelock[_func] = 0;
142     }
143     
144     constructor (address payable _add1, address payable _add2,address payable _add3) { 
145         require(_add1 != address(0),"Zero address exception");
146         require(_add2 != address(0),"Zero address exception");
147         require(_add3 != address(0),"Zero address exception");
148         marketingWallet = _add1;
149         devWallet = _add2;
150         founderWallet = _add3;
151         balance[owner()] = _tTotal;
152         _isExcludedFromFee[owner()] = true;
153         _isExcludedFromFee[address(this)] = true;
154         _isExcludedFromFee[marketingWallet] = true;
155         emit Transfer(address(0),owner(), _tTotal);
156     }
157 
158     function name() external pure returns (string memory) {
159         return _name;
160     }
161 
162     function symbol() external pure returns (string memory) {
163         return _symbol;
164     }
165 
166     function decimals() external pure returns (uint8) {
167         return _decimals;
168     }
169 
170     function totalSupply() external pure override returns (uint256) {
171         return _tTotal;
172     }
173 
174     function balanceOf(address account) public view override returns (uint256) {
175         return balance[account];
176     }
177 
178     function transfer(address recipient, uint256 amount) external override returns (bool) {
179         _transfer(_msgSender(), recipient, amount);
180         return true;
181     }
182 
183     function allowance(address holder, address spender) external view override returns (uint256) {
184         return _allowances[holder][spender];
185     }
186 
187     function approve(address spender, uint256 amount) external override returns (bool) {
188         _approve(_msgSender(), spender, amount);
189         return true;
190     }
191 
192     function isWhitelisted(address _addr) external view returns(bool){
193         return _isExcludedFromFee[_addr];
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function _approve(address holder, address spender, uint256 amount) private {
203         require(holder != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205         _allowances[holder][spender] = amount;
206         emit Approval(holder, spender, amount);
207     }
208 
209     function _transfer(address from, address to, uint256 amount) private {
210         require(amount > 0, "Transfer amount must be greater than zero");
211         require(balanceOf(from) >= amount,"Balance less then transfer");
212         require(!bots[from],"Blacklisted can't trade");
213         tax = 0;
214         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {            
215             require(!paused,"Trading is paused");
216             require(amount <= _maxTxAmount,"Amount exceed max trnx amount");
217 
218             if(to != uniswapV2Pair){   //can't have tokens over maxWallet 
219             require(balanceOf(to) + amount*(1-(taxAmount/100)) <= maxWallet,"max Wallet limit exceeded");
220             }
221             uint256 contractETHBalance = address(this).balance;
222             if(contractETHBalance > 1 ether) { // Minimum 1 eth before sending to marketing wallet
223                 sendETHToFee(address(this).balance);
224             }
225             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
226                 tax = taxAmount;
227                 uint256 contractTokenBalance = balanceOf(address(this));
228                 if(!inSwap){
229                     if(contractTokenBalance > _tTotal/1000){ // 0.01%
230                         swapTokensForEth(contractTokenBalance);
231                     }
232                 }
233             }
234                
235         }
236         _tokenTransfer(from,to,amount);
237     }
238 
239 
240     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
241         address[] memory path = new address[](2);
242         path[0] = address(this);
243         path[1] = uniswapV2Router.WETH();
244         _approve(address(this), address(uniswapV2Router), tokenAmount);
245         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
246             tokenAmount,
247             0,
248             path,
249             address(this),
250             block.timestamp
251         );
252     }
253     
254     function changeMaxTrnx(uint256 amount) external onlyOwner{
255         require(tradingOpen,"Trading is not enabled yet");
256         _maxTxAmount = amount ;
257         emit MaxTxAmountUpdated(amount);
258     }
259     function changeMaxWallet(uint256 perc) external onlyOwner{
260         require(perc > 0, "Wallet should be more than 0");
261         maxWallet = perc * _tTotal /100;
262         emit MaxWalletPercUpdated(perc);
263     }
264 
265     function sendETHToFee(uint256 amount) private {
266         marketingWallet.transfer(2*amount/5);
267         founderWallet.transfer(2*amount/5);
268         devWallet.transfer(address(this).balance);        
269     }
270     
271     
272     function openTrading() external onlyOwner {
273         require(!tradingOpen,"trading is already open");
274         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
275         uniswapV2Router = _uniswapV2Router;
276         _approve(address(this), address(uniswapV2Router), _tTotal);
277         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
278         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
279         _maxTxAmount = _tTotal/1000;
280         maxWallet = _tTotal/1000;
281         tradingOpen = true;
282         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
283         tradingEnableTime = block.timestamp;
284     }
285     
286     function blacklistBot(address _address) external onlyOwner{
287             bots[_address] = true;
288     }
289     
290     function changeMarketingWallet( address payable _address) external onlyOwner notLocked(Functions.changeMarketWallet){
291         require(_address != address(0),"Marketing Wallet can not be zero");
292         marketingWallet = _address;
293         timelock[Functions.changeMarketWallet] = 0;
294     }
295 
296     function removeFromBlacklist(address notbot) external onlyOwner{
297         bots[notbot] = false;
298     }
299 
300     function emergencyPause() external onlyOwner notLocked(Functions.pause){
301         paused = !paused;
302         timelock[Functions.pause] = 0;
303     }
304 
305     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
306         
307         uint256 tTeam = amount*tax/100;    // tax amount
308         uint256 remainingAmount = amount - tTeam; // to Send
309         balance[sender] = balance[sender].sub(amount); // deduct from sender
310         balance[recipient] = balance[recipient].add(remainingAmount); // add to recipient
311         balance[address(this)] = balance[address(this)].add(tTeam); // add team Take to address
312         emit Transfer(sender, recipient, remainingAmount);
313     }
314 
315     function whitelistAddress(address _addr,bool _bool) external onlyOwner{    //add or remove address from whitelist
316         _isExcludedFromFee[_addr] = _bool;
317     }
318 
319     receive() external payable {}
320     
321     function transferERC20(IERC20 token, uint256 amount) external onlyOwner{ //function to transfer stuck erc20 tokens
322         require(token != IERC20(address(this)),"You can't withdraw tokens from owned by contract."); 
323         uint256 erc20balance = token.balanceOf(address(this));
324         require(amount <= erc20balance, "balance is low");
325         token.transfer(marketingWallet, amount);
326     }
327     event buyTaxUpdated(uint256 _newTaxAmount);   
328     function changeTax(uint256 _newBuyTax) external onlyOwner{
329         require(_newBuyTax < 10,"New Buy tax have to be under 10");
330         taxAmount = _newBuyTax;
331         emit buyTaxUpdated(_newBuyTax);
332     }
333 
334     function manualswap() external onlyOwner{
335         uint256 contractBalance = balanceOf(address(this));
336         swapTokensForEth(contractBalance);
337     }
338     
339     function manualsend() external onlyOwner{
340         uint256 contractETHBalance = address(this).balance;
341         sendETHToFee(contractETHBalance);
342     }
343 }