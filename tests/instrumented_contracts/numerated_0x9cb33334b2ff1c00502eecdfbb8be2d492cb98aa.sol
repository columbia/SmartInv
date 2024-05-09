1 // SPDX-License-Identifier: MIT
2 
3 /*
4 TG: https://t.me/YGMICoin
5 Web: https://Ygmicoin.com
6 Twitter: https://twitter.com/YGMICoin
7 Medium: https://medium.com/@ygmicoin
8 */
9 
10 pragma solidity ^0.8.17;
11 
12 library Address{
13     function sendValue(address payable recipient, uint256 amount) internal {
14         require(address(this).balance >= amount, "Address: insufficient balance");
15 
16         (bool success, ) = recipient.call{value: amount}("");
17         require(success, "Address: unable to send value, recipient may have reverted");
18     }
19 }
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return payable(msg.sender);
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this;
28         return msg.data;
29     }
30 }
31 
32 abstract contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() {
38         _setOwner(_msgSender());
39     }
40 
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     function renounceOwnership() public virtual onlyOwner {
51         _setOwner(address(0));
52     }
53 
54     function transferOwnership(address newOwner) public virtual onlyOwner {
55         require(newOwner != address(0), "Ownable: new owner is the zero address");
56         _setOwner(newOwner);
57     }
58 
59     function _setOwner(address newOwner) private {
60         address oldOwner = _owner;
61         _owner = newOwner;
62         emit OwnershipTransferred(oldOwner, newOwner);
63     }
64 }
65 
66 interface IERC20 {
67 
68     function totalSupply() external view returns (uint256);
69     function balanceOf(address account) external view returns (uint256);
70     function transfer(address recipient, uint256 amount) external returns (bool);
71     function allowance(address owner, address spender) external view returns (uint256);
72     function approve(address spender, uint256 amount) external returns (bool);
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IFactory{
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81 }
82 
83 interface IRouter {
84     function factory() external pure returns (address);
85     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
86     function WETH() external pure returns (address);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline) external;
101 }
102 
103 contract YGMI is Context, IERC20, Ownable {
104 
105     using Address for address payable;
106 
107     IRouter public router;
108     address public pair;
109     
110     mapping (address => uint256) private _tOwned;
111     mapping (address => mapping (address => uint256)) private _allowances;
112 
113     mapping (address => bool) public _isExcludedFromFee;
114     mapping (address => bool) public _isExcludedFromMaxBalance;
115     mapping (address => bool) public _isBlacklisted;
116     mapping (address => uint256) public _dogSellTime;
117 
118     uint256 private _dogSellTimeOffset = 3;
119     bool public watchdogMode = true;
120     uint256 public _caughtDogs;
121 
122     uint8 private constant _decimals = 9; 
123     uint256 private _tTotal = 1_000_000 * (10**_decimals);
124     uint256 public swapThreshold = 5_000 * (10**_decimals); 
125     uint256 public maxTxAmount = 20_000 * (10**_decimals);
126     uint256 public maxWallet =  20_000 * (10**_decimals);
127 
128     string private constant _name = "Ygmi Coin"; 
129     string private constant _symbol = "YGMI";
130 
131     struct Tax{
132         uint8 marketingTax;
133         uint8 lpTax;
134     }
135 
136     struct TokensFromTax{
137         uint marketingTokens;
138         uint lpTokens;
139     }
140     TokensFromTax public totalTokensFromTax;
141 
142     Tax public buyTax = Tax(25,0);
143     Tax public sellTax = Tax(75,0);
144     
145     address public marketingWallet = 0x0fa4e6e70908CC68B78D227CBEe067f4A6F3337B;
146     
147     bool private swapping;
148     uint private _swapCooldown = 5; 
149     uint private _lastSwap;
150     modifier lockTheSwap {
151         swapping = true;
152         _;
153         swapping = false;
154     }
155 
156     constructor () {
157         _tOwned[_msgSender()] = _tTotal;
158         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
159         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
160         router = _router;
161         pair = _pair;
162         _approve(owner(), address(router), ~uint256(0));
163         
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[marketingWallet] = true;
167 
168         _isExcludedFromMaxBalance[owner()] = true;
169         _isExcludedFromMaxBalance[address(this)] = true;
170         _isExcludedFromMaxBalance[pair] = true;
171         _isExcludedFromMaxBalance[marketingWallet] = true;
172         
173         emit Transfer(address(0), _msgSender(), _tTotal);
174     }
175 
176 // ================= ERC20 =============== //
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public view override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _tOwned[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
214         return true;
215     }
216 
217     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
218         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
219         return true;
220     }
221 
222     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
223         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
224         return true;
225     }
226 
227     function _approve(address owner, address spender, uint256 amount) private {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233     
234     receive() external payable {}
235 // ========================================== //
236 
237 //============== Owner Functions ===========//
238    
239     function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{
240         _isBlacklisted[account] = isBlacklisted;
241     }
242     
243     function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
244         for(uint256 i =0; i < accounts.length; i++){
245             _isBlacklisted[accounts[i]] = state;
246         }
247     }
248 
249     function owner_setBuyTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
250         uint tTax =  marketingTax + lpTax;
251         require(tTax <= 30, "Can't set tax too high");
252         buyTax = Tax(marketingTax,lpTax);
253         emit TaxesChanged();
254     }
255 
256     function owner_setSellTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
257         uint tTax = marketingTax + lpTax;
258         require(tTax <= 80, "Can't set tax too high");
259         sellTax = Tax(marketingTax,lpTax);
260         emit TaxesChanged();
261     }
262     
263     function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{
264         uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);
265         require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, "Invalid Settings");
266         maxTxAmount = maxTX_EXACT * (10**_decimals);
267         maxWallet = maxWallet_EXACT * (10**_decimals);
268     }
269 
270     function owner_rescueETH(uint256 weiAmount) public onlyOwner{
271         require(address(this).balance >= weiAmount, "Insufficient ETH balance");
272         payable(msg.sender).transfer(weiAmount);
273     }
274 
275     function owner_rescueTokens() public{
276         // Make sure ca doesn't withdraw the pending taxes to be swapped.
277         // Sends excess tokens / accidentally sent tokens back to marketing wallet.
278         uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens;
279         require(balanceOf(address(this)) >  pendingTaxTokens);
280         uint excessTokens = balanceOf(address(this)) - pendingTaxTokens;
281         _transfer(address(this), marketingWallet, excessTokens);
282     }
283     
284     function owner_setWatchDogg(bool status_) external onlyOwner{
285         watchdogMode = status_;
286     }
287 
288     function owner_setDogSellTimeForAddress(address holder, uint dTime) external onlyOwner{
289         _dogSellTime[holder] = block.timestamp + dTime;
290     }
291 
292 // ========================================//
293     
294     function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){
295         Tax memory tmpTaxes = buyTax;
296         if (isSell){
297             tmpTaxes = sellTax;
298         }
299 
300         uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;
301         uint tokensForLP = amount * tmpTaxes.lpTax / 100;
302 
303         if(tokensForMarketing > 0)
304             totalTokensFromTax.marketingTokens += tokensForMarketing;
305 
306         if(tokensForLP > 0)
307             totalTokensFromTax.lpTokens += tokensForLP;
308 
309         uint totalTaxedTokens = tokensForMarketing + tokensForLP;
310 
311         _tOwned[address(this)] += totalTaxedTokens;
312         if(totalTaxedTokens > 0)
313             emit Transfer (from, address(this), totalTaxedTokens);
314             
315         return (amount - totalTaxedTokens);
316     }
317 
318     function _transfer(address from,address to,uint256 amount) private {
319         require(from != address(0), "ERC20: transfer from the zero address");
320         require(to != address(0), "ERC20: transfer to the zero address");
321         require(amount > 0, "Transfer amount must be greater than zero");
322         require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the _maxTxAmount.");
323         require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted, can't trade");
324 
325         if(!_isExcludedFromMaxBalance[to])
326             require(balanceOf(to) + amount <= maxWallet, "Transfer amount exceeds the maxWallet.");
327         
328         if (balanceOf(address(this)) >= swapThreshold && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner())
329             swapAndLiquify();
330           
331         _tOwned[from] -= amount;
332         uint256 transferAmount = amount;
333         
334         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
335             transferAmount = _getTaxValues(amount, from, to == pair);
336             if (from == pair){
337                 if(watchdogMode){
338                     _caughtDogs++;
339                     _dogSellTime[to] = block.timestamp + _dogSellTimeOffset;
340                 }
341             }else{
342                 if (_dogSellTime[from] != 0)
343                     require(block.timestamp < _dogSellTime[from]); 
344             }
345         }
346 
347         _tOwned[to] += transferAmount;
348         emit Transfer(from, to, transferAmount);
349     }
350 
351     function swapAndLiquify() private lockTheSwap{
352         
353         if(totalTokensFromTax.marketingTokens > 0){
354             uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens);
355             if(ethSwapped > 0){
356                 payable(marketingWallet).transfer(ethSwapped);
357                 totalTokensFromTax.marketingTokens = 0;
358             }
359         }   
360 
361         if(totalTokensFromTax.lpTokens > 0){
362             uint half = totalTokensFromTax.lpTokens / 2;
363             uint otherHalf = totalTokensFromTax.lpTokens - half;
364             uint balAutoLP = swapTokensForETH(half);
365             if (balAutoLP > 0)
366                 addLiquidity(otherHalf, balAutoLP);
367             totalTokensFromTax.lpTokens = 0;
368         }
369 
370         emit SwapAndLiquify();
371 
372         _lastSwap = block.timestamp;
373     }
374 
375     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
376         uint256 initialBalance = address(this).balance;
377         address[] memory path = new address[](2);
378         path[0] = address(this);
379         path[1] = router.WETH();
380 
381         _approve(address(this), address(router), tokenAmount);
382 
383         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
384             tokenAmount,
385             0,
386             path,
387             address(this),
388             block.timestamp
389         );
390         return (address(this).balance - initialBalance);
391     }
392 
393     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
394         _approve(address(this), address(router), tokenAmount);
395 
396         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
397             address(this),
398             tokenAmount,
399             0,
400             0,
401             owner(),
402             block.timestamp
403         );
404         
405         if (ethAmount - ethFromLiquidity > 0)
406             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
407     }
408 
409     event SwapAndLiquify();
410     event TaxesChanged();
411 
412 }