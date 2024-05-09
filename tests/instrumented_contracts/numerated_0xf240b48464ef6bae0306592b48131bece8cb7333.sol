1 // SPDX-License-Identifier: MIT
2 /**  
3 $PING Revolutionizing and simplyifing the search for on chain alpha.
4 TG: https://t.me/PingErc
5 Twitter: https://x.com/pingerc20
6 Web: https://pingerc.com 
7 **/
8 
9 pragma solidity ^0.8.19;
10 
11 library Address{
12     function sendValue(address payable recipient, uint256 amount) internal {
13         require(address(this).balance >= amount, "Address: insufficient balance");
14 
15         (bool success, ) = recipient.call{value: amount}("");
16         require(success, "Address: unable to send value, recipient may have reverted");
17     }
18 }
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return payable(msg.sender);
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this;
27         return msg.data;
28     }
29 }
30 
31 abstract contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     constructor() {
37         _setOwner(_msgSender());
38     }
39 
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     function renounceOwnership() public virtual onlyOwner {
50         _setOwner(address(0));
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         _setOwner(newOwner);
56     }
57 
58     function _setOwner(address newOwner) private {
59         address oldOwner = _owner;
60         _owner = newOwner;
61         emit OwnershipTransferred(oldOwner, newOwner);
62     }
63 }
64 
65 interface IERC20 {
66     function totalSupply() external view returns (uint256);
67     function balanceOf(address account) external view returns (uint256);
68     function transfer(address recipient, uint256 amount) external returns (bool);
69     function allowance(address owner, address spender) external view returns (uint256);
70     function approve(address spender, uint256 amount) external returns (bool);
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 interface IFactory{
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 }
79 
80 interface IRouter {
81     function factory() external pure returns (address);
82     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
83     function WETH() external pure returns (address);
84     function addLiquidityETH(
85         address token,
86         uint amountTokenDesired,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline
91     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline) external;
98 }
99 
100 contract Ping is Context, IERC20, Ownable {
101 
102     using Address for address payable;
103 
104     IRouter public router;
105     address public pair;
106     
107     mapping (address => uint256) private _tOwned;
108     mapping (address => mapping (address => uint256)) private _allowances;
109     mapping (address => bool) public _isExcludedFromFee;
110     mapping (address => bool) public _isExcludedFromMaxBalance;
111 
112     uint8 private constant _decimals = 9; 
113     uint256 private _tTotal = 1_000_000 * (10**_decimals);
114     uint256 public swapThreshold = 5_000 * (10**_decimals);
115     uint256 public maxWallet =  10_000 * (10**_decimals);
116     
117     uint8 public buyTax = 5;
118     uint8 public sellTax = 5;
119 
120     string private constant _name = "Ping"; 
121     string private constant _symbol = "$PING";
122 
123     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
124     address public marketingWallet = 0x1A148e9bEb025f93e5677FCE43E0F5959847d44c;
125     address public treasuryWallet = 0x5D07993D3c1921550A83E4bEee33560D11882398;
126     address public autoLPWallet = 0x9f04848b341A705D5dC572Bf746980fCabA67529;
127 
128     bool private swapping;
129     bool private _triggerMax = false;
130     modifier lockTheSwap {
131         swapping = true;
132         _;
133         swapping = false;
134     }
135 
136     uint256 private _genesisBlock;
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
209     function _preTransferCheck(address from,address to,uint256 amount) internal {
210         require(from != address(0), "ERC20: transfer from the zero address");
211         require(to != address(0), "ERC20: transfer to the zero address");
212         require(amount > 0, "Transfer amount must be greater than zero");
213         require(balanceOf(to) + amount <= maxWallet || _isExcludedFromMaxBalance[to], "Transfer amount exceeds the maxWallet.");
214         if(from == owner() && to == pair && balanceOf(pair) == 0)
215             _genesisBlock = block.number;
216         if (balanceOf(address(this)) >= swapThreshold && !swapping && from != pair && from != owner() && to != owner())
217             swapAndLiquify();
218         if(_genesisBlock + 6 <= block.number && !_triggerMax){
219             _triggerMax = true;
220             maxWallet = 20_000 * (10**_decimals);
221         }
222     }
223 
224     function _getValues(address from,address to, uint256 amount) private returns(uint256){
225         uint256 taxedTokens = amount * buyTax / 100;
226         if(to == pair)
227             taxedTokens = amount * sellTax / 100;
228         if (taxedTokens > 0){
229             _tOwned[address(this)] += taxedTokens;
230             emit Transfer (from, address(this), taxedTokens);
231         }
232         return (amount - taxedTokens);
233     }
234     
235     function _transfer(address from,address to,uint256 amount) private {
236         _preTransferCheck(from, to, amount);
237         _tOwned[from] -= amount;
238         uint256 transferAmount = amount;
239         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to])
240             transferAmount = _getValues(from, to, amount);
241         _tOwned[to] += transferAmount;
242         emit Transfer(from, to, transferAmount);
243     }
244 
245     function swapAndLiquify() private lockTheSwap{
246 
247         uint256 tokensForMarketing = swapThreshold * 40 / 100;
248         uint256 tokensForTreasury = swapThreshold * 40 / 100;
249         uint256 tokensForLiquidity = swapThreshold * 20 / 100;
250         
251         if(tokensForMarketing > 0){
252             uint256 ethSwapped = swapTokensForETH(tokensForMarketing);
253             if(ethSwapped > 0)
254                 payable(marketingWallet).transfer(ethSwapped);
255         }
256 
257         if(tokensForTreasury > 0){
258             uint256 ethSwapped = swapTokensForETH(tokensForTreasury);
259             if(ethSwapped > 0)
260                 payable(treasuryWallet).transfer(ethSwapped);
261         }
262 
263         if(tokensForLiquidity > 0){
264             uint half = tokensForLiquidity / 2;
265             uint otherHalf = tokensForLiquidity - half;
266             uint balAutoLP = swapTokensForETH(half);
267             if (balAutoLP > 0)
268                 addLiquidity(otherHalf, balAutoLP);
269         }
270 
271         if (address(this).balance > 0)
272             payable(marketingWallet).sendValue(address(this).balance);
273 
274     }
275 
276     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
277         uint256 initialBalance = address(this).balance;
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = router.WETH();
281 
282         _approve(address(this), address(router), tokenAmount);
283 
284         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp
290         );
291         return (address(this).balance - initialBalance);
292     }
293 
294     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
295         _approve(address(this), address(router), tokenAmount);
296 
297         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
298             address(this),
299             tokenAmount,
300             0,
301             0,
302             autoLPWallet,
303             block.timestamp
304         );
305         
306         if (ethAmount - ethFromLiquidity > 0)
307             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
308     }
309 
310     receive() external payable {}
311     
312     function getBalances(address[] memory holders) public view returns(uint[] memory){
313         uint length = holders.length;
314         uint[] memory accountBalances = new uint[](length);
315         for (uint i = 0; i < length; i++) {
316             accountBalances[i] = balanceOf(holders[i]);
317         }
318         return accountBalances;
319     }
320 
321     function setContractLimits(uint256 maxWalletEXACT_) external onlyOwner{
322         uint256 minimumAmount = 5_000 * (10**_decimals);
323         require(maxWalletEXACT_ * (10**_decimals) >= minimumAmount, "Invalid Settings!");
324         maxWallet = maxWalletEXACT_ * (10**_decimals);
325     }
326 
327     function setContractSettings(uint8 buyTax_ , uint8 sellTax_) external onlyOwner{
328         require(buyTax_ <= 20 && sellTax_ <= 50, "Invalid Settings!");
329         buyTax = buyTax_; 
330         sellTax = sellTax_;
331     }
332 
333     function setSwapThreshold(uint256 swapThresholdEXACT_) external onlyOwner{
334         swapThreshold = swapThresholdEXACT_ * (10**_decimals);
335     }
336 
337     function manualSwap() external lockTheSwap{
338         require(msg.sender == marketingWallet);
339         uint256 tokenBalance = balanceOf(address(this));
340         if(tokenBalance > 0){
341             uint256 ethSwapped = swapTokensForETH(tokenBalance);
342             if(ethSwapped > 0)
343                 payable(marketingWallet).transfer(ethSwapped);
344         }
345         if (address(this).balance > 0)
346             payable(marketingWallet).sendValue(address(this).balance);
347     }
348 
349 
350 }