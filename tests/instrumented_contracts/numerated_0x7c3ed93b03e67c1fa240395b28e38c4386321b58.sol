1 // SPDX-License-Identifier: MIT
2 // https://www.wallybot.net/
3 // https://t.me/WallyBot_Group
4 pragma solidity ^0.8.17;
5 
6 library Address{
7     function sendValue(address payable recipient, uint256 amount) internal {
8         require(address(this).balance >= amount, "Address: insufficient balance");
9 
10         (bool success, ) = recipient.call{value: amount}("");
11         require(success, "Address: unable to send value, recipient may have reverted");
12     }
13 }
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return payable(msg.sender);
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this;
22         return msg.data;
23     }
24 }
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         _setOwner(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _setOwner(address(0));
46     }
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         _setOwner(newOwner);
51     }
52 
53     function _setOwner(address newOwner) private {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 interface IERC20 {
61 
62     function totalSupply() external view returns (uint256);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 interface IFactory{
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75 }
76 
77 interface IRouter {
78     function factory() external pure returns (address);
79     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
80     function WETH() external pure returns (address);
81     function addLiquidityETH(
82         address token,
83         uint amountTokenDesired,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline
88     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
89     function swapExactTokensForETHSupportingFeeOnTransferTokens(
90         uint amountIn,
91         uint amountOutMin,
92         address[] calldata path,
93         address to,
94         uint deadline) external;
95 }
96 
97 contract WallyBot is Context, IERC20, Ownable {
98 
99     using Address for address payable;
100 
101     IRouter public router;
102     address public pair;
103     
104     mapping (address => uint256) private _tOwned;
105     mapping (address => mapping (address => uint256)) private _allowances;
106 
107     mapping (address => bool) public _isExcludedFromFee;
108     mapping (address => bool) public _isExcludedFromMaxBalance;
109     mapping (address => bool) public _isBlacklisted;
110     mapping (address => uint256) public _dogSellTime;
111 
112     uint256 private _dogSellTimeOffset = 3;
113     bool public watchdogMode = true;
114     uint256 public _caughtDogs;
115 
116     uint8 private constant _decimals = 9; 
117     uint256 private _tTotal = 1_000_000 * (10**_decimals);
118     uint256 public swapThreshold = 5_000 * (10**_decimals); 
119     uint256 public maxTxAmount = 20_000 * (10**_decimals);
120     uint256 public maxWallet =  20_000 * (10**_decimals);
121 
122     string private constant _name = "Wally Bot"; 
123     string private constant _symbol = "Wally";
124 
125     struct Tax{
126         uint8 marketingTax;
127         uint8 lpTax;
128     }
129 
130     struct TokensFromTax{
131         uint marketingTokens;
132         uint lpTokens;
133     }
134     TokensFromTax public totalTokensFromTax;
135 
136     Tax public buyTax = Tax(20,1);
137     Tax public sellTax = Tax(45,1);
138     
139     address public marketingWallet = 0xA7a190cb5c00195E1595ac62d221009e20BFC441;
140     
141     bool private swapping;
142     uint private _swapCooldown = 5; 
143     uint private _lastSwap;
144     modifier lockTheSwap {
145         swapping = true;
146         _;
147         swapping = false;
148     }
149 
150     constructor () {
151         _tOwned[_msgSender()] = _tTotal;
152         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
153         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
154         router = _router;
155         pair = _pair;
156         _approve(owner(), address(router), ~uint256(0));
157         
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[marketingWallet] = true;
161 
162         _isExcludedFromMaxBalance[owner()] = true;
163         _isExcludedFromMaxBalance[address(this)] = true;
164         _isExcludedFromMaxBalance[pair] = true;
165         _isExcludedFromMaxBalance[marketingWallet] = true;
166         
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170 // ================= ERC20 =============== //
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public view override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _tOwned[account];
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
208         return true;
209     }
210 
211     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
212         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
213         return true;
214     }
215 
216     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
217         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
218         return true;
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227     
228     receive() external payable {}
229 // ========================================== //
230 
231 //============== Owner Functions ===========//
232    
233     function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{
234         _isBlacklisted[account] = isBlacklisted;
235     }
236     
237     function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
238         for(uint256 i =0; i < accounts.length; i++){
239             _isBlacklisted[accounts[i]] = state;
240         }
241     }
242 
243     function owner_setBuyTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
244         uint tTax =  marketingTax + lpTax;
245         require(tTax <= 30, "Can't set tax too high");
246         buyTax = Tax(marketingTax,lpTax);
247         emit TaxesChanged();
248     }
249 
250     function owner_setSellTaxes(uint8 marketingTax, uint8 lpTax) external onlyOwner{
251         uint tTax = marketingTax + lpTax;
252         require(tTax <= 80, "Can't set tax too high");
253         sellTax = Tax(marketingTax,lpTax);
254         emit TaxesChanged();
255     }
256     
257     function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{
258         uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);
259         require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, "Invalid Settings");
260         maxTxAmount = maxTX_EXACT * (10**_decimals);
261         maxWallet = maxWallet_EXACT * (10**_decimals);
262     }
263 
264     function owner_rescueETH(uint256 weiAmount) public onlyOwner{
265         require(address(this).balance >= weiAmount, "Insufficient ETH balance");
266         payable(msg.sender).transfer(weiAmount);
267     }
268     
269     function owner_setWatchDog(bool status_) external onlyOwner{
270         watchdogMode = status_;
271     }
272 
273     function owner_setDogSellTimeForAddress(address holder, uint dTime) external onlyOwner{
274         _dogSellTime[holder] = block.timestamp + dTime;
275     }
276 
277 // ========================================//
278     
279     function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){
280         Tax memory tmpTaxes = buyTax;
281         if (isSell){
282             tmpTaxes = sellTax;
283         }
284 
285         uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;
286         uint tokensForLP = amount * tmpTaxes.lpTax / 100;
287 
288         if(tokensForMarketing > 0)
289             totalTokensFromTax.marketingTokens += tokensForMarketing;
290 
291         if(tokensForLP > 0)
292             totalTokensFromTax.lpTokens += tokensForLP;
293 
294         uint totalTaxedTokens = tokensForMarketing + tokensForLP;
295 
296         _tOwned[address(this)] += totalTaxedTokens;
297         if(totalTaxedTokens > 0)
298             emit Transfer (from, address(this), totalTaxedTokens);
299             
300         return (amount - totalTaxedTokens);
301     }
302 
303     function _transfer(address from,address to,uint256 amount) private {
304         require(from != address(0), "ERC20: transfer from the zero address");
305         require(to != address(0), "ERC20: transfer to the zero address");
306         require(amount > 0, "Transfer amount must be greater than zero");
307         require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the _maxTxAmount.");
308         require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted, can't trade");
309 
310         if(!_isExcludedFromMaxBalance[to])
311             require(balanceOf(to) + amount <= maxWallet, "Transfer amount exceeds the maxWallet.");
312         
313         if (balanceOf(address(this)) >= swapThreshold && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner())
314             swapAndLiquify();
315           
316         _tOwned[from] -= amount;
317         uint256 transferAmount = amount;
318         
319         if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
320             transferAmount = _getTaxValues(amount, from, to == pair);
321             if (from == pair){
322                 if(watchdogMode){
323                     _caughtDogs++;
324                     _dogSellTime[to] = block.timestamp + _dogSellTimeOffset;
325                 }
326             }else{
327                 if (_dogSellTime[from] != 0)
328                     require(block.timestamp < _dogSellTime[from]); 
329             }
330         }
331 
332         _tOwned[to] += transferAmount;
333         emit Transfer(from, to, transferAmount);
334     }
335 
336     function swapAndLiquify() private lockTheSwap{
337         
338         if(totalTokensFromTax.marketingTokens > 0){
339             uint256 ethSwapped = swapTokensForETH(totalTokensFromTax.marketingTokens);
340             if(ethSwapped > 0){
341                 payable(marketingWallet).transfer(ethSwapped);
342                 totalTokensFromTax.marketingTokens = 0;
343             }
344         }   
345 
346         if(totalTokensFromTax.lpTokens > 0){
347             uint half = totalTokensFromTax.lpTokens / 2;
348             uint otherHalf = totalTokensFromTax.lpTokens - half;
349             uint balAutoLP = swapTokensForETH(half);
350             if (balAutoLP > 0)
351                 addLiquidity(otherHalf, balAutoLP);
352             totalTokensFromTax.lpTokens = 0;
353         }
354 
355         emit SwapAndLiquify();
356 
357         _lastSwap = block.timestamp;
358     }
359 
360     function swapTokensForETH(uint256 tokenAmount) private returns (uint256) {
361         uint256 initialBalance = address(this).balance;
362         address[] memory path = new address[](2);
363         path[0] = address(this);
364         path[1] = router.WETH();
365 
366         _approve(address(this), address(router), tokenAmount);
367 
368         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
369             tokenAmount,
370             0,
371             path,
372             address(this),
373             block.timestamp
374         );
375         return (address(this).balance - initialBalance);
376     }
377 
378     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
379         _approve(address(this), address(router), tokenAmount);
380 
381         (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
382             address(this),
383             tokenAmount,
384             0,
385             0,
386             owner(),
387             block.timestamp
388         );
389         
390         if (ethAmount - ethFromLiquidity > 0)
391             payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
392     }
393 
394     event SwapAndLiquify();
395     event TaxesChanged();
396 
397 }