1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6     
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(
13         address sender,
14         address recipient,
15         uint256 amount
16     ) external returns (bool);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 interface IERC20Metadata is IERC20 {
23    
24     function name() external view returns (string memory);
25     function symbol() external view returns (string memory);
26     function decimals() external view returns (uint8);
27 }
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 abstract contract Ownable is Context {
40     address private _owner;
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() {
44         _transferOwnership(_msgSender());
45     }
46 
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     modifier onlyOwner() {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 contract YeagerInu is Context, IERC20Metadata, Ownable {
73     
74     struct governingTaxes{
75         uint32 _split0;
76         uint32 _split1;
77         uint32 _split2;
78         uint32 _split3;
79         address _wallet1;
80         address _wallet2;
81     }
82 
83     struct Fees {
84         uint256 _fee0;
85         uint256 _fee1;
86         uint256 _fee2;
87         uint256 _fee3;
88     }
89     
90     uint32 private _totalTaxPercent;
91     governingTaxes private _governingTaxes;
92     
93     mapping (address => uint256) private _rOwned;
94     mapping (address => uint256) private _tOwned;
95     mapping(address => mapping(address => uint256)) private _allowances;
96     
97     mapping (address => bool) private _isExcluded;
98     address[] private _excluded;
99     mapping (address => bool) private _isExcludedFromFee;
100     mapping (address => bool) private _isLiquidityPool;
101 
102     mapping (address => bool) private _isBlacklisted;
103     uint256 public _maxTxAmount;
104     uint256 private _maxHoldAmount;
105 
106     bool private _tokenLock = true; //Locking the token until Liquidty is added
107     bool private _taxReverted = false;
108     uint256 public _tokenCommenceTime;
109 
110     uint256 private constant _startingSupply = 100_000_000_000_000_000; //100 Quadrillion
111     
112     uint256 private constant MAX = ~uint256(0);
113     uint256 private constant _tTotal = _startingSupply * 10**9;
114     uint256 private _rTotal = (MAX - (MAX % _tTotal));
115     uint256 private _tFeeTotal;
116     
117     string private constant _name = "Yeager Inu";
118     string private constant _symbol = "YEAGER";
119     uint8 private constant _decimals = 9;
120 
121     address public constant burnAddress = 0x000000000000000000000000000000000000dEaD; 
122 
123     constructor (address wallet1_,  address wallet2_) {
124         _rOwned[_msgSender()] = _rTotal;
125 
126         /*
127             Total Tax Percentage per Transaction : 10%
128             Tax Split:
129                 > Burn (burnAddress): 10%
130                 > Dev Wallet (wallet1): 20% 
131                 > Marketing Wallet (wallet2): 50%
132                 > Holders (reflect): 20%
133         */
134 
135         /*
136             >>> First 24 hour Tax <<<
137 
138             Total Tax Percentage per Transaction : 25%
139             Tax Split:
140                 > Burn (burnAddress): 4%
141                 > Dev Wallet (wallet1): 40% 
142                 > Marketing Wallet (wallet2): 40%
143                 > Holders (reflect): 16%
144         */
145         _totalTaxPercent = 25;  
146         _governingTaxes = governingTaxes(4, 40, 40, 16, wallet1_, wallet2_); 
147         
148 
149         //Max TX amount is 100% of the total supply, will be updated when token gets into circulation (anti-whale)
150         _maxTxAmount = (_startingSupply * 10**9); 
151         //Max Hold amount is 2% of the total supply. (Only for first 24 hours) (anti-whale) 
152         _maxHoldAmount = ((_startingSupply * 10**9) * 2) / 100;
153 
154         //Excluding Owner and Other Governing Wallets From Reward System;
155         excludeFromFee(owner());
156         excludeFromReward(owner());
157         excludeFromReward(burnAddress);
158         excludeFromReward(wallet1_);
159         excludeFromReward(wallet2_);
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure override returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure override returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure override returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         if (_isExcluded[account]) return _tOwned[account];
182         return tokenFromReflection(_rOwned[account]);
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(
200         address sender,
201         address recipient,
202         uint256 amount
203     ) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205 
206         uint256 currentAllowance = _allowances[sender][_msgSender()];
207         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
208         unchecked {
209             _approve(sender, _msgSender(), currentAllowance - amount);
210         }
211 
212         return true;
213     }
214 
215     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
216         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
217         return true;
218     }
219 
220     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
221         uint256 currentAllowance = _allowances[_msgSender()][spender];
222         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
223         unchecked {
224             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
225         }
226 
227         return true;
228     }
229 
230     function totalFees() public view returns (uint256) {
231         return _tFeeTotal;
232     }
233 
234     function currentTaxes() public view 
235     returns (
236         uint32 total_Tax_Percent,
237         uint32 burn_Split,
238         uint32 governingSplit_Wallet1,
239         uint32 governingSplit_Wallet2,
240         uint32 reflect_Split
241     ) {
242         return (
243             _totalTaxPercent,
244             _governingTaxes._split0,
245             _governingTaxes._split1,
246             _governingTaxes._split2,
247             _governingTaxes._split3
248         );
249     }
250 
251     function isExcludedFromReward(address account) public view returns (bool) {
252         return _isExcluded[account];
253     }
254 
255     function isExcludedFromFee(address account) public view returns(bool) {
256         return _isExcludedFromFee[account];
257     }
258 
259     function isBlacklisted(address account) public view returns (bool) {
260         return _isBlacklisted[account];
261     }
262 
263     function isLiquidityPool(address account) public view returns (bool) {
264         return _isLiquidityPool[account];
265     }
266 
267     function _hasLimits(address from, address to) private view returns (bool) {
268         return from != owner()
269             && to != owner()
270             && to != burnAddress;
271     }
272 
273     function setBlacklistAccount(address account, bool enabled) external onlyOwner() {
274         _isBlacklisted[account] = enabled;
275     }
276 
277     function setLiquidityPool(address account, bool enabled) external onlyOwner() {
278         _isLiquidityPool[account] = enabled;
279     }
280 
281     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
282         require(maxTxAmount >= (_tTotal / 1000), "Max Transaction amt must be above 0.1% of total supply"); // Cannot set lower than 0.1%
283         _maxTxAmount = maxTxAmount;
284     }
285 
286     function unlockToken() external onlyOwner() {
287         _tokenLock = false;
288         _tokenCommenceTime = block.timestamp;
289     }
290 
291     function revertTax() external {
292         require(!_tokenLock, "Token is Locked for Liquidty to be added");
293         require(block.timestamp - _tokenCommenceTime > 86400, "Tax can be reverted only after 24hrs"); //check for 24 hours timeperiod
294         require(!_taxReverted, "Tax had been Reverted!"); //To prevent taxRevert more than once 
295 
296         _totalTaxPercent = 10;
297         _governingTaxes._split0 = 10;
298         _governingTaxes._split1 = 20;
299         _governingTaxes._split2 = 50;
300         _governingTaxes._split3 = 20;
301 
302         _maxHoldAmount = _tTotal; //Removing the max hold limit of 2%
303         _taxReverted = true;
304     }
305 
306     function setTaxes(
307         uint32 totalTaxPercent_, 
308         uint32 split0_, 
309         uint32 split1_, 
310         uint32 split2_, 
311         uint32 split3_, 
312         address wallet1_, 
313         address wallet2_
314     ) external onlyOwner() {
315         require(wallet1_ != address(0) && wallet2_ != address(0), "Tax Wallets assigned zero address !");
316         require(totalTaxPercent_ <= 10, "Total Tax Percent Exceeds 10% !"); // Prevents owner from manipulating Tax.
317         require(split0_+split1_+split2_+split3_ == 100, "Split Percentages does not sum upto 100 !");
318 
319         _totalTaxPercent = totalTaxPercent_;
320         _governingTaxes._split0 = split0_;
321         _governingTaxes._split1 = split1_;
322         _governingTaxes._split2 = split2_;
323         _governingTaxes._split3 = split3_;
324         _governingTaxes._wallet1 = wallet1_;
325         _governingTaxes._wallet2 = wallet2_;
326     }
327 
328     function excludeFromFee(address account) public onlyOwner {
329         _isExcludedFromFee[account] = true;
330     }
331     
332     function includeInFee(address account) external onlyOwner {
333         _isExcludedFromFee[account] = false;
334     }
335 
336     function excludeFromReward(address account) public onlyOwner() {
337         require(!_isExcluded[account], "Account is already excluded");
338         if(_rOwned[account] > 0) {
339             _tOwned[account] = tokenFromReflection(_rOwned[account]);
340         }
341         _isExcluded[account] = true;
342         _excluded.push(account);
343     }
344 
345     function includeInReward(address account) external onlyOwner() {
346         require(_isExcluded[account], "Account is already excluded");
347         for (uint256 i = 0; i < _excluded.length; i++) {
348             if (_excluded[i] == account) {
349                 _excluded[i] = _excluded[_excluded.length - 1];
350                 _tOwned[account] = 0;
351                 _isExcluded[account] = false;
352                 _excluded.pop();
353                 break;
354             }
355         }
356     }
357 
358     function reflect(uint256 tAmount) public {
359         address sender = _msgSender();
360         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
361         (uint256 rAmount,,,,) = _getValues(tAmount);
362         _rOwned[sender] = _rOwned[sender] - rAmount;
363         _rTotal = _rTotal - rAmount;
364         _tFeeTotal = _tFeeTotal + tAmount;
365     }
366 
367     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
368         require(tAmount <= _tTotal, "Amount must be less than supply");
369         if (!deductTransferFee) {
370             (uint256 rAmount,,,,) = _getValues(tAmount);
371             return rAmount;
372         } else {
373             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
374             return rTransferAmount;
375         }
376     }
377 
378     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
379         require(rAmount <= _rTotal, "Amount must be less than total reflections");
380         uint256 currentRate =  _getRate();
381         return rAmount / currentRate;
382     }
383 
384     function _approve(
385         address owner,
386         address spender,
387         uint256 amount
388     ) internal virtual {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391 
392         _allowances[owner][spender] = amount;
393         emit Approval(owner, spender, amount);
394     }
395 
396     function _transfer(
397         address sender,
398         address recipient,
399         uint256 tAmount
400     ) private {
401         require(sender != address(0), "ERC20: transfer from the zero address");
402         require(recipient != address(0), "ERC20: transfer to the zero address");
403         require((!_tokenLock) || (!_hasLimits(sender, recipient))  , "Token is Locked for Liquidty to be added");
404 
405         if(_hasLimits(sender, recipient)) {
406             require(tAmount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount");
407             require(!isBlacklisted(sender) || !isBlacklisted(recipient), "Sniper Rejected");
408             if(!_taxReverted && !_isLiquidityPool[recipient]) {
409                 require(balanceOf(recipient)+tAmount <= _maxHoldAmount, "Receiver address exceeds the maxHoldAmount");
410             }
411         }
412 
413         uint32 _previoustotalTaxPercent;
414         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) //checking if Tax should be deducted from transfer
415         {
416             _previoustotalTaxPercent = _totalTaxPercent;
417             _totalTaxPercent = 0; //removing Taxes
418         }
419         else if(!_taxReverted && _isLiquidityPool[sender]) {
420             _previoustotalTaxPercent = _totalTaxPercent;
421             _totalTaxPercent = 10; //Liquisity pool Buy tax reduced to 10% from 25%
422         }
423 
424         (uint256 rAmount, uint256 rTransferAmount, Fees memory rFee, uint256 tTransferAmount, Fees memory tFee) = _getValues(tAmount);
425 
426         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient] || 
427           (!_taxReverted && _isLiquidityPool[sender])) _totalTaxPercent = _previoustotalTaxPercent; //restoring Taxes
428 
429         _rOwned[sender] = _rOwned[sender] - rAmount;
430         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
431 
432         _rOwned[burnAddress] += rFee._fee0;
433         _rOwned[_governingTaxes._wallet1] += rFee._fee1;
434         _rOwned[_governingTaxes._wallet2] += rFee._fee2;
435         _reflectFee(rFee._fee3, tFee._fee0+tFee._fee1+tFee._fee2+tFee._fee3);
436 
437         if (_isExcluded[sender]) _tOwned[sender] = _tOwned[sender] - tAmount;
438         if (_isExcluded[recipient]) _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
439         if (_isExcluded[burnAddress]) _tOwned[burnAddress] += tFee._fee0;
440         if (_isExcluded[_governingTaxes._wallet1]) _tOwned[_governingTaxes._wallet1] += tFee._fee1;
441         if (_isExcluded[_governingTaxes._wallet2])_tOwned[_governingTaxes._wallet2] += tFee._fee2;
442         
443         emit Transfer(sender, recipient, tTransferAmount);
444     }
445 
446     function _reflectFee(uint256 rFee, uint256 tFee) private {
447         _rTotal = _rTotal - rFee;
448         _tFeeTotal = _tFeeTotal + tFee;
449     }
450 
451     function _getValues(uint256 tAmount) private view returns (uint256 rAmount, uint256 rTransferAmount, Fees memory rFee, uint256 tTransferAmount, Fees memory tFee) {
452         (tTransferAmount, tFee) = _getTValues(tAmount);
453         uint256 currentRate =  _getRate();
454         (rAmount, rTransferAmount, rFee) = _getRValues(tAmount, tFee, currentRate);
455         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
456     }
457 
458     function _getTValues(uint256 tAmount) private view returns (uint256, Fees memory) {
459         Fees memory tFee;
460         tFee._fee0 = (tAmount * _totalTaxPercent * _governingTaxes._split0) / 10**4;
461         tFee._fee1 = (tAmount * _totalTaxPercent * _governingTaxes._split1) / 10**4;
462         tFee._fee2 = (tAmount * _totalTaxPercent * _governingTaxes._split2) / 10**4;
463         tFee._fee3 = (tAmount * _totalTaxPercent * _governingTaxes._split3) / 10**4;
464         uint256 tTransferAmount = tAmount - tFee._fee0 - tFee._fee1 - tFee._fee2 - tFee._fee3;
465         return (tTransferAmount, tFee);
466     }
467 
468     function _getRValues(uint256 tAmount, Fees memory tFee, uint256 currentRate) private pure returns (uint256, uint256, Fees memory) {
469         uint256 rAmount = tAmount * currentRate;
470         Fees memory rFee;
471         rFee._fee0 = tFee._fee0 * currentRate;
472         rFee._fee1 = tFee._fee1 * currentRate;
473         rFee._fee2 = tFee._fee2 * currentRate;
474         rFee._fee3 = tFee._fee3 * currentRate;
475         uint256 rTransferAmount = rAmount - rFee._fee0 - rFee._fee1 - rFee._fee2 - rFee._fee3;
476         return (rAmount, rTransferAmount, rFee);
477     }
478 
479     function _getRate() private view returns(uint256) {
480         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
481         return rSupply / tSupply;
482     }
483 
484     function _getCurrentSupply() private view returns(uint256, uint256) {
485         uint256 rSupply = _rTotal;
486         uint256 tSupply = _tTotal;      
487         for (uint256 i = 0; i < _excluded.length; i++) {
488             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
489             rSupply = rSupply - _rOwned[_excluded[i]];
490             tSupply = tSupply - _tOwned[_excluded[i]];
491         }
492         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
493         return (rSupply, tSupply);
494     }
495 }