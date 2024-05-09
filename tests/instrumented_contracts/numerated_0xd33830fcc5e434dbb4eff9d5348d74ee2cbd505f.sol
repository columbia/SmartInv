1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IERC20 {
7     function decimals() external view returns (uint8);
8     function symbol() external view returns (string memory);
9     function name() external view returns (string memory);
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 interface IUniswapRouter {
21 
22     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
23     function factory() external pure returns (address);
24 
25     function WETH() external pure returns (address);
26 
27     function swapExactTokensForETHSupportingFeeOnTransferTokens(
28         uint amountIn,
29         uint amountOutMin,
30         address[] calldata path,
31         address to,
32         uint deadline
33     ) external;
34 
35 }
36 
37 interface IUniswapFactory {
38     function getPair(address tokenA, address tokenB) external view returns (address pair);
39     function createPair(address tokenA, address tokenB) external returns (address pair);
40 }
41 
42 abstract contract Ownable {
43     address internal _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     constructor () {
48         address msgSender = msg.sender;
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == msg.sender, "you are not owner");
59         _;
60     }
61 
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "new is 0");
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 contract Token is IERC20, Ownable {
75     mapping(address => uint256) private _balances;
76     mapping(address => mapping(address => uint256)) private _allowances;
77 
78     address payable private MarketingWallet;
79 
80     string private _name;
81     string private _symbol;
82     uint8 private _decimals;
83 
84     mapping(address => bool) public _isExcludeFromFee;
85     
86     uint256 private _totalSupply;
87 
88     IUniswapRouter public _uniswapRouter;
89 
90     mapping (address => bool) private bots;
91 
92     mapping(address => bool) public isMarketPair;
93     bool private inSwap;
94 
95     uint256 private constant MAX = ~uint256(0);
96 
97     address public _uniswapPair;
98 
99     modifier lockTheSwap {
100         inSwap = true;
101         _;
102         inSwap = false;
103     }
104 
105     constructor (){
106 
107         _name = "PEPEP";
108         _symbol = "PEPEP";
109         _decimals = 18;
110         uint256 Supply = 420_690_000_000_000;
111 
112         _totalSupply = Supply * 10 ** _decimals;
113 
114         address receiveAddr = msg.sender;
115         _balances[receiveAddr] = _totalSupply;
116         emit Transfer(address(0), receiveAddr, _totalSupply);
117 
118         MarketingWallet = payable(msg.sender);
119         _walletMAX = _totalSupply * 2 / 100;
120 
121         _isExcludeFromFee[address(this)] = true;
122         _isExcludeFromFee[receiveAddr] = true;
123         _isExcludeFromFee[MarketingWallet] = true;
124 
125         IUniswapRouter swapRouter = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
126         _uniswapRouter = swapRouter;
127         _allowances[address(this)][address(swapRouter)] = MAX;
128 
129         IUniswapFactory swapFactory = IUniswapFactory(swapRouter.factory());
130         _uniswapPair = swapFactory.createPair(address(this), swapRouter.WETH());
131 
132         isMarketPair[_uniswapPair] = true;
133         IERC20(_uniswapRouter.WETH()).approve(
134             address(address(_uniswapRouter)),
135             ~uint256(0)
136         );
137         _isExcludeFromFee[address(swapRouter)] = true;
138 
139     }
140 
141     function setFundAddr(
142         address payable newAddr
143     ) public onlyOwner{
144         MarketingWallet = newAddr;
145     }
146 
147     function symbol() external view override returns (string memory) {
148         return _symbol;
149     }
150 
151     function name() external view override returns (string memory) {
152         return _name;
153     }
154 
155     function decimals() external view override returns (uint8) {
156         return _decimals;
157     }
158 
159     function totalSupply() public view override returns (uint256) {
160         return _totalSupply;
161     }
162 
163     function balanceOf(address account) public view override returns (uint256) {
164         return _balances[account];
165     }
166 
167     function transfer(address recipient, uint256 amount) public override returns (bool) {
168         _transfer(msg.sender, recipient, amount);
169         return true;
170     }
171 
172     function allowance(address owner, address spender) public view override returns (uint256) {
173         return _allowances[owner][spender];
174     }
175 
176     function approve(address spender, uint256 amount) public override returns (bool) {
177         _approve(msg.sender, spender, amount);
178         return true;
179     }
180 
181     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
182         _transfer(sender, recipient, amount);
183         if (_allowances[sender][msg.sender] != MAX) {
184             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
185         }
186         return true;
187     }
188 
189     function _approve(address owner, address spender, uint256 amount) private {
190         _allowances[owner][spender] = amount;
191         emit Approval(owner, spender, amount);
192     }
193 
194     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
195         _balances[sender] -= amount;
196         _balances[recipient] += amount;
197         emit Transfer(sender, recipient, amount);
198         return true;
199     }
200 
201     uint256 public _buyCount=0;
202     uint256 private _initialBuyTax=0;
203     uint256 private _initialSellTax=0;
204     uint256 private _finalBuyTax=30;
205     uint256 private _finalSellTax=31;
206     uint256 private _reduceBuyTaxAt=0;
207     uint256 private _reduceSellTaxAt=0;
208     uint256 private _preventSwapBefore=0;
209 
210     function recuseTax(
211         uint256 newBuy,
212         uint256 newSell,
213         uint256 newReduceBuy,
214         uint256 newReduceSell,
215         uint256 newPreventSwapBefore
216     ) public onlyOwner {
217         _finalBuyTax = newBuy;
218         _finalSellTax = newSell;
219         _reduceBuyTaxAt = newReduceBuy;
220         _reduceSellTaxAt = newReduceSell;
221         _preventSwapBefore = newPreventSwapBefore;
222     }
223 
224     bool public remainHolder = true;
225     function changeRemain() public onlyOwner{
226         remainHolder = !remainHolder;
227     }
228 
229     uint256 public _walletMAX;
230 
231     function setWalletMax(uint8 percentage) public onlyOwner{
232         _walletMAX = totalSupply() * percentage / 100;
233     }
234 
235     function _transfer(
236         address from,
237         address to,
238         uint256 amount
239     ) private {
240         uint256 balance = balanceOf(from);
241         require(balance >= amount, "balanceNotEnough");
242 
243         if (inSwap){
244             _basicTransfer(from, to, amount);
245             return;
246         }
247 
248         bool takeFee;
249 
250         if (isMarketPair[to] && !inSwap && !_isExcludeFromFee[from] && !_isExcludeFromFee[to] && _buyCount > _preventSwapBefore) {
251             uint256 _numSellToken = amount;
252             if (_numSellToken > balanceOf(address(this))){
253                 _numSellToken = _balances[address(this)];
254             }
255             if (_numSellToken > 0){
256                 swapTokenForETH(_numSellToken);
257             }
258         }
259 
260         if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && !inSwap) {
261             require(startTradeBlock > 0);
262             require(!bots[from]);
263             takeFee = true;
264             
265             if (isMarketPair[from] && to != address(_uniswapRouter) && !_isExcludeFromFee[to]) {
266                 _buyCount++;
267                 require(balanceOf(to) + amount <= _walletMAX,"walletlimit");
268             }
269 
270             if (remainHolder && amount == balance) {
271                 amount = amount - (amount / 10000);
272             }
273 
274         }
275 
276         _transferToken(from, to, amount, takeFee);
277     }
278 
279     function _transferToken(
280         address sender,
281         address recipient,
282         uint256 tAmount,
283         bool takeFee
284     ) private {
285         _balances[sender] = _balances[sender] - tAmount;
286         uint256 feeAmount;
287 
288         if (takeFee) {
289             uint256 taxFee;
290             if (isMarketPair[recipient]) {
291                 taxFee = _buyCount > _reduceSellTaxAt ? _finalSellTax : _initialSellTax;
292             } else if (isMarketPair[sender]) {
293                 taxFee = _buyCount > _reduceBuyTaxAt ? _finalBuyTax : _initialBuyTax;
294             }
295             uint256 swapAmount = tAmount * taxFee / 100;
296             if (swapAmount > 0) {
297                 feeAmount += swapAmount;
298                 _balances[address(this)] = _balances[address(this)] + swapAmount;
299                 emit Transfer(sender, address(this), swapAmount);
300             }
301         }
302 
303         _balances[recipient] = _balances[recipient] + (tAmount - feeAmount);
304         emit Transfer(sender, recipient, tAmount - feeAmount);
305 
306     }
307 
308     uint256 public startTradeBlock;
309     function startTrade() public onlyOwner {
310         startTradeBlock = block.number;
311     }
312 
313     function removeERC20(address _token) external {
314         if(_token != address(this)){
315             IERC20(_token).transfer(MarketingWallet, IERC20(_token).balanceOf(address(this)));
316             MarketingWallet.transfer(address(this).balance);
317         }
318     }
319 
320     function addBots(address[] memory bots_) public onlyOwner {
321         for (uint i = 0; i < bots_.length; i++) {
322             bots[bots_[i]] = true;
323         }
324     }
325 
326     function delBots(address[] memory notbot) public onlyOwner {
327       for (uint i = 0; i < notbot.length; i++) {
328           bots[notbot[i]] = false;
329       }
330     }
331 
332     function swapTokenForETH(uint256 tokenAmount) private lockTheSwap {
333         address[] memory path = new address[](2);
334         path[0] = address(this);
335         path[1] = _uniswapRouter.WETH();
336         _uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
337             tokenAmount,
338             0,
339             path,
340             address(this),
341             block.timestamp
342         );
343 
344         uint256 _bal = address(this).balance;
345         if (_bal > 0.01 ether){
346             MarketingWallet.transfer(_bal);
347         }
348     }
349 
350     function setFeeExclude(address account, bool value) public onlyOwner{
351         _isExcludeFromFee[account] = value;
352     }
353 
354     receive() external payable {}
355 }