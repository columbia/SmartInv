1 // SPDX-License-Identifier: MIT
2 
3 /*
4 TG: https://t.me/KillerWhalesETH
5 */
6 
7 pragma solidity ^0.8.17;
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
64 
65     function totalSupply() external view returns (uint256);
66     function balanceOf(address account) external view returns (uint256);
67     function transfer(address recipient, uint256 amount) external returns (bool);
68     function allowance(address owner, address spender) external view returns (uint256);
69     function approve(address spender, uint256 amount) external returns (bool);
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
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
100 contract KillerWhales is Context, IERC20, Ownable {
101 
102     using Address for address payable;
103 
104     IRouter public router;
105     address public pair;
106     
107     mapping (address => uint256) private _tOwned;
108     mapping (address => mapping (address => uint256)) private _allowances;
109 
110     mapping (address => bool) public _isExcludedFromFee;
111     mapping (address => bool) public _isExcludedFromMaxBalance;
112     mapping (address => bool) public _isBlacklisted;
113     mapping (address => uint256) public _dogSellTime;
114 
115     uint256 private _dogSellTimeOffset = 3;
116     bool public watchdogMode = true;
117     uint256 public _caughtDogs;
118 
119     uint8 private constant _decimals = 9; 
120     uint256 private _tTotal = 1_000_000 * (10**_decimals);
121     uint256 public swapThreshold = 5_000 * (10**_decimals); 
122     uint256 public maxTxAmount = 20_000 * (10**_decimals);
123     uint256 public maxWallet =  20_000 * (10**_decimals);
124 
125     string private constant _name = "Killer Whales"; 
126     string private constant _symbol = "WHALES";
127 
128     struct Tax{
129         uint8 marketingTax;
130         uint8 lpTax;
131     }
132 
133     struct TokensFromTax{
134         uint marketingTokens;
135         uint lpTokens;
136     }
137     TokensFromTax public totalTokensFromTax;
138 
139     Tax public buyTax = Tax(25,0);
140     Tax public sellTax = Tax(75,0);
141     
142     address public marketingWallet = 0xe8B58a36eDdb069A787Bb4E5f008aAf9E123775D;
143     
144     bool private swapping;
145     uint private _swapCooldown = 5; 
146     uint private _lastSwap;
147     modifier lockTheSwap {
148         swapping = true;
149         _;
150         swapping = false;
151     }
152 
153     constructor () {
154         _tOwned[_msgSender()] = _tTotal;
155         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
156         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
157         router = _router;
158         pair = _pair;
159         _approve(owner(), address(router), ~uint256(0));
160         
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[marketingWallet] = true;
164 
165         _isExcludedFromMaxBalance[owner()] = true;
166         _isExcludedFromMaxBalance[address(this)] = true;
167         _isExcludedFromMaxBalance[pair] = true;
168         _isExcludedFromMaxBalance[marketingWallet] = true;
169         
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173 // ================= ERC20 =============== //
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public view override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _tOwned[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
211         return true;
212     }
213 
214     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
215         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
216         return true;
217     }
218 
219     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
220         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
221         return true;
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230     
231     receive() external payable {}
232 // ========================================== //
233 
234 //============== Owner Functions ===========//
235    
236     function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{
237         _isBlacklisted[account] = isBlacklisted;
238     }
239     
240     function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
241         for(uint256 i =0; i < accounts.length; i++){
242             _isBlacklisted[accounts[i]] = state;
243         }
244     }
245 
246     function owner_setBuyTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
247         uint tTax =  marketingTax + lpTax;
248         require(tTax <= 30, "Can't set tax too high");
249         buyTax = Tax(marketingTax,lpTax);
250         emit TaxesChanged();
251     }
252 
253     function owner_setSellTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
254         uint tTax = marketingTax + lpTax;
255         require(tTax <= 80, "Can't set tax too high");
256         sellTax = Tax(marketingTax,lpTax);
257         emit TaxesChanged();
258     }
259     
260     function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{
261         uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);
262         require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, "Invalid Settings");
263         maxTxAmount = maxTX_EXACT * (10**_decimals);
264         maxWallet = maxWallet_EXACT * (10**_decimals);
265     }
266 
267     function owner_rescueETH(uint256 weiAmount) public onlyOwner{
268         require(address(this).balance >= weiAmount, "Insufficient ETH balance");
269         payable(msg.sender).transfer(weiAmount);
270     }
271 
272     function owner_rescueTokens() public{
273         // Make sure ca doesn't withdraw the pending taxes to be swapped.
274         // Sends excess tokens / accidentally sent tokens back to marketing wallet.
275         uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens;
276         require(balanceOf(address(this)) >  pendingTaxTokens);
277         uint excessTokens = balanceOf(address(this)) - pendingTaxTokens;
278         _transfer(address(this), marketingWallet, excessTokens);
279     }
280     
281     function owner_setWatchDogg(bool status_) external onlyOwner{
282         watchdogMode = status_;
283     }
284 
285     function owner_setDogSellTimeForAddress(address holder, uint dTime) external onlyOwner{
286         _dogSellTime[holder] = block.timestamp + dTime;
287     }
288 
289 // ========================================//
290     
291     function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){
292         Tax memory tmpTaxes = buyTax;
293         if (isSell){
294             tmpTaxes = sellTax;
295         }
296 
297         uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;
298         uint tokensForLP = amount * tmpTaxes.lpTax / 100;
299 
300         if(tokensForMarketing > 0)
301             totalTokensFromTax.marketingTokens += tokensForMarketing;
302 
303         if(tokensForLP > 0)
304             totalTokensFromTax.lpTokens += tokensForLP;
305 
306         uint totalTaxedTokens = tokensForMarketing + tokensForLP;
307 
308         _tOwned[address(this)] += totalTaxedTokens;
309         if(totalTaxedTokens > 0)
310             emit Transfer (from, address(this), totalTaxedTokens);
311             
312         return (amount - totalTaxedTokens);
313     }
314 
315     function _transfer(address from,address to,uint256 amount) private {
316         require(from != address(0), "ERC20: transfer from the zero address");
317         require(to != address(0), "ERC20: transfer to the zero address");
318         require(amount > 0, "Transfer amount must be greater than zero");
319         require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the _maxTxAmount.");
320         require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted, can't trade");
321 
322         if(!_isExcludedFromMaxBalance[to])
323             require(balanceOf(to) + amount <= maxWallet, "Transfer amount exceeds the maxWallet.");
324         
325         if (balanceOf(address(this)) >= swapThreshold && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner())
326             swapAndLiquify();
327           
328         _tOwned[from] -= amount;
329         uint256 transferAmount = amount;
330         
331         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
332             transferAmount = _getTaxValues(amount, from, to == pair);
333             if (from == pair){
334                 if(watchdogMode){
335                     _caughtDogs++;
336                     _dogSellTime[to] = block.timestamp + _dogSellTimeOffset;
337                 }
338             }else{
339                 if (_dogSellTime[from] != 0)
340                     require(block.timestamp < _dogSellTime[from]); 
341             }
342         }
343 
344         _tOwned[to] += transferAmount;
345         emit Transfer(from, to, transferAmount);
346     }
347 
348     function swapAndLiquify() private lockTheSwap{
349         
350         if(totalTokensFromTax.marketingTokens > 0){
351             uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens);
352             if(ethSwapped > 0){
353                 payable(marketingWallet).transfer(ethSwapped);
354                 totalTokensFromTax.marketingTokens = 0;
355             }
356         }   
357 
358         if(totalTokensFromTax.lpTokens > 0){
359             uint half = totalTokensFromTax.lpTokens / 2;
360             uint otherHalf = totalTokensFromTax.lpTokens - half;
361             uint balAutoLP = swapTokensForETH(half);
362             if (balAutoLP > 0)
363                 addLiquidity(otherHalf, balAutoLP);
364             totalTokensFromTax.lpTokens = 0;
365         }
366 
367         emit SwapAndLiquify();
368 
369         _lastSwap = block.timestamp;
370     }
371 
372     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
373         uint256 initialBalance = address(this).balance;
374         address[] memory path = new address[](2);
375         path[0] = address(this);
376         path[1] = router.WETH();
377 
378         _approve(address(this), address(router), tokenAmount);
379 
380         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
381             tokenAmount,
382             0,
383             path,
384             address(this),
385             block.timestamp
386         );
387         return (address(this).balance - initialBalance);
388     }
389 
390     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
391         _approve(address(this), address(router), tokenAmount);
392 
393         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
394             address(this),
395             tokenAmount,
396             0,
397             0,
398             owner(),
399             block.timestamp
400         );
401         
402         if (ethAmount - ethFromLiquidity > 0)
403             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
404     }
405 
406     event SwapAndLiquify();
407     event TaxesChanged();
408 
409 }