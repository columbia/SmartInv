1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 TG: https://t.me/TweetXBot_portal
6 Twitter: https://twitter.com/TweetXBot_AI
7 Website: https://tweetx.tech/
8 
9 */
10 
11 pragma solidity ^0.8.17;
12 
13 library Address{
14     function sendValue(address payable recipient, uint256 amount) internal {
15         require(address(this).balance >= amount, "Address: insufficient balance");
16 
17         (bool success, ) = recipient.call{value: amount}("");
18         require(success, "Address: unable to send value, recipient may have reverted");
19     }
20 }
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return payable(msg.sender);
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this;
29         return msg.data;
30     }
31 }
32 /// 
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     constructor() {
39         _setOwner(_msgSender());
40     }
41 
42     function owner() public view virtual returns (address) {
43         return _owner;
44     }
45 
46     modifier onlyOwner() {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     function renounceOwnership() public virtual onlyOwner {
52         _setOwner(address(0));
53     }
54 
55     function transferOwnership(address newOwner) public virtual onlyOwner {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         _setOwner(newOwner);
58     }
59 
60     function _setOwner(address newOwner) private {
61         address oldOwner = _owner;
62         _owner = newOwner;
63         emit OwnershipTransferred(oldOwner, newOwner);
64     }
65 }
66 //// 
67 interface IERC20 {
68 
69     function totalSupply() external view returns (uint256);
70     function balanceOf(address account) external view returns (uint256);
71     function transfer(address recipient, uint256 amount) external returns (bool);
72     function allowance(address owner, address spender) external view returns (uint256);
73     function approve(address spender, uint256 amount) external returns (bool);
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IFactory{
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 }
83 
84 interface IRouter {
85     function factory() external pure returns (address);
86     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
87     function WETH() external pure returns (address);
88     function addLiquidityETH(
89         address token,
90         uint amountTokenDesired,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline) external;
102 }
103 
104 contract TWEETX is Context, IERC20, Ownable {
105 
106     using Address for address payable;
107 
108     IRouter public router;
109     address public pair;
110     
111     mapping (address => uint256) private _tOwned;
112     mapping (address => mapping (address => uint256)) private _allowances;
113 
114     mapping (address => bool) public _isExcludedFromFee;
115     mapping (address => bool) public _isExcludedFromMaxBalance;
116     mapping (address => bool) public _isBlacklisted;
117     mapping (address => uint256) public _dogSellTime;
118 
119     uint256 private _dogSellTimeOffset = 3;
120     bool public watchdogMode = false;
121     uint256 public _caughtDogs;
122 
123     uint8 private constant _decimals = 9; 
124     uint256 private _tTotal = 1_000_000 * (10**_decimals);
125     uint256 public swapThreshold = 1_000 * (10**_decimals); 
126     uint256 public maxTxAmount = 20_000 * (10**_decimals);
127     uint256 public maxWallet =  20_000 * (10**_decimals);
128 
129     string private constant _name = "TweetXBot"; 
130     string private constant _symbol = "TWEETX";
131 
132     struct Tax{
133         uint8 marketingTax;
134         uint8 lpTax;
135     }
136 
137     struct TokensFromTax{
138         uint marketingTokens;
139         uint lpTokens;
140     }
141     TokensFromTax public totalTokensFromTax;
142 
143     Tax public buyTax = Tax(20,0);
144     Tax public sellTax = Tax(30,0);
145     
146     address public marketingWallet = 0xAdD9957Df700B1B466B6B1Ab3B817b6E98A7136F;
147     
148     bool private swapping;
149     uint private _swapCooldown = 5; 
150     uint private _lastSwap;
151     modifier lockTheSwap {
152         swapping = true;
153         _;
154         swapping = false;
155     }
156 //// 
157     constructor () {
158         _tOwned[_msgSender()] = _tTotal;
159         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
160         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
161         router = _router;
162         pair = _pair;
163         _approve(owner(), address(router), ~uint256(0));
164         
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[marketingWallet] = true;
168 
169         _isExcludedFromMaxBalance[owner()] = true;
170         _isExcludedFromMaxBalance[address(this)] = true;
171         _isExcludedFromMaxBalance[pair] = true;
172         _isExcludedFromMaxBalance[marketingWallet] = true;
173         
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177 // ================= ERC20 =============== //   
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public view override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _tOwned[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
215         return true;
216     }
217 
218     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
219         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
220         return true;
221     }
222 
223     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
224         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
225         return true;
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) private {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234     
235     receive() external payable {}
236 // ========================================== //
237 // 
238 //============== Owner Functions ===========//
239    
240     function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{
241         _isBlacklisted[account] = isBlacklisted;
242     }
243     
244     function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
245         for(uint256 i =0; i < accounts.length; i++){
246             _isBlacklisted[accounts[i]] = state;
247         }
248     }
249 
250     function owner_setBuyTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
251         uint tTax =  marketingTax + lpTax;
252         require(tTax <= 30, "Can't set tax too high");
253         buyTax = Tax(marketingTax,lpTax);
254         emit TaxesChanged();
255     }
256 
257     function owner_setSellTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
258         uint tTax = marketingTax + lpTax;
259         require(tTax <= 80, "Can't set tax too high");
260         sellTax = Tax(marketingTax,lpTax);
261         emit TaxesChanged();
262     }
263     
264     function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{
265         uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);
266         require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, "Invalid Settings");
267         maxTxAmount = maxTX_EXACT * (10**_decimals);
268         maxWallet = maxWallet_EXACT * (10**_decimals);
269     }
270 
271     function owner_rescueETH(uint256 weiAmount) public onlyOwner{
272         require(address(this).balance >= weiAmount, "Insufficient ETH balance");
273         payable(msg.sender).transfer(weiAmount);
274     }
275 
276     function owner_rescueExcessTokens() public{
277         // Make sure ca doesn't withdraw the pending taxes to be swapped.    
278         // Sends excess tokens / accidentally sent tokens back to marketing wallet.
279         uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens;
280         require(balanceOf(address(this)) >  pendingTaxTokens);
281         uint excessTokens = balanceOf(address(this)) - pendingTaxTokens;
282         _transfer(address(this), marketingWallet, excessTokens);
283     }
284     
285     function owner_setWatchDogMode(bool status_) external onlyOwner{
286         watchdogMode = status_;
287     }
288 
289     function owner_setDogSellTimeForAddress(address holder, uint dTime) external onlyOwner{
290         _dogSellTime[holder] = block.timestamp + dTime;
291     }
292 
293 // ========================================//. 
294     
295     function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){
296         Tax memory tmpTaxes = buyTax;
297         if (isSell){
298             tmpTaxes = sellTax;
299         }
300 
301         uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;
302         uint tokensForLP = amount * tmpTaxes.lpTax / 100;
303 
304         if(tokensForMarketing > 0)
305             totalTokensFromTax.marketingTokens += tokensForMarketing;
306 
307         if(tokensForLP > 0)
308             totalTokensFromTax.lpTokens += tokensForLP;
309 
310         uint totalTaxedTokens = tokensForMarketing + tokensForLP;
311 
312         _tOwned[address(this)] += totalTaxedTokens;
313         if(totalTaxedTokens > 0)
314             emit Transfer (from, address(this), totalTaxedTokens);
315             
316         return (amount - totalTaxedTokens);
317     }
318 
319     function _transfer(address from,address to,uint256 amount) private {
320         require(from != address(0), "ERC20: transfer from the zero address");
321         require(to != address(0), "ERC20: transfer to the zero address");
322         require(amount > 0, "Transfer amount must be greater than zero");
323         require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the _maxTxAmount.");
324         require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted, can't trade");
325 
326         if(!_isExcludedFromMaxBalance[to])
327             require(balanceOf(to) + amount <= maxWallet, "Transfer amount exceeds the maxWallet.");
328         
329         if (balanceOf(address(this)) >= swapThreshold && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner())
330             swapAndLiquify();
331           
332         _tOwned[from] -= amount;
333         uint256 transferAmount = amount;
334         
335         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
336             transferAmount = _getTaxValues(amount, from, to == pair);
337             if (from == pair){
338                 if(watchdogMode){
339                     _caughtDogs++;
340                     _dogSellTime[to] = block.timestamp + _dogSellTimeOffset;
341                 }
342             }else{
343                 if (_dogSellTime[from] != 0)
344                     require(block.timestamp < _dogSellTime[from]); 
345             }
346         }
347 
348         _tOwned[to] += transferAmount;
349         emit Transfer(from, to, transferAmount);
350     }
351 
352     function swapAndLiquify() private lockTheSwap{
353         
354         if(totalTokensFromTax.marketingTokens > 0){
355             uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens);
356             if(ethSwapped > 0){
357                 payable(marketingWallet).transfer(ethSwapped);
358                 totalTokensFromTax.marketingTokens = 0;
359             }
360         }   
361 
362         if(totalTokensFromTax.lpTokens > 0){
363             uint half = totalTokensFromTax.lpTokens / 2;
364             uint otherHalf = totalTokensFromTax.lpTokens - half;
365             uint balAutoLP = swapTokensForETH(half);
366             if (balAutoLP > 0)
367                 addLiquidity(otherHalf, balAutoLP);
368             totalTokensFromTax.lpTokens = 0;
369         }
370 
371         emit SwapAndLiquify();
372 
373         _lastSwap = block.timestamp;
374     }
375 
376     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
377         uint256 initialBalance = address(this).balance;
378         address[] memory path = new address[](2);
379         path[0] = address(this);
380         path[1] = router.WETH();
381 
382         _approve(address(this), address(router), tokenAmount);
383 
384         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
385             tokenAmount,
386             0,
387             path,
388             address(this),
389             block.timestamp
390         );
391         return (address(this).balance - initialBalance);
392     }
393 
394     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
395         _approve(address(this), address(router), tokenAmount);
396 
397         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
398             address(this),
399             tokenAmount,
400             0,
401             0,
402             owner(),
403             block.timestamp
404         );
405         
406         if (ethAmount - ethFromLiquidity > 0)
407             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
408     }
409 
410     event SwapAndLiquify();
411     event TaxesChanged();
412 ///      
413 }