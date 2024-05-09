1 pragma solidity 0.5.12;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract Context {
75     // Empty internal constructor, to prevent people from mistakenly deploying
76     // an instance of this contract, which should be used via inheritance.
77     constructor () internal { }
78 
79     function _msgSender() internal view  returns (address payable) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view  returns (bytes memory) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b) internal pure returns (uint256) {
170         return div(a, b, "SafeMath: division by zero");
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         // Solidity only automatically asserts when dividing by 0
186         require(b > 0, errorMessage);
187         uint256 c = a / b;
188         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
205         return mod(a, b, "SafeMath: modulo by zero");
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts with custom message when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b != 0, errorMessage);
221         return a % b;
222     }
223 }
224 
225 contract ERC20 is Context, IERC20 {
226     using SafeMath for uint256;
227 
228     mapping (address => uint256) private _balances;
229 
230     mapping (address => mapping (address => uint256)) private _allowances;
231 
232     uint256 private _totalSupply;
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view  returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view  returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `recipient` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address recipient, uint256 amount) public   returns (bool) {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-allowance}.
263      */
264     function allowance(address owner, address spender) public view   returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     /**
269      * @dev See {IERC20-approve}.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public   returns (bool) {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20};
285      *
286      * Requirements:
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for `sender`'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(address sender, address recipient, uint256 amount) public   returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
295         return true;
296     }
297 
298     /**
299      * @dev Atomically increases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
311         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
312         return true;
313     }
314 
315     /**
316      * @dev Atomically decreases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      * - `spender` must have allowance for the caller of at least
327      * `subtractedValue`.
328      */
329     function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal  {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351 
352 
353         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
354         _balances[recipient] = _balances[recipient].add(amount);
355         emit Transfer(sender, recipient, amount);
356     }
357 
358     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
359      * the total supply.
360      *
361      * Emits a {Transfer} event with `from` set to the zero address.
362      *
363      * Requirements
364      *
365      * - `to` cannot be the zero address.
366      */
367     function _mint(address account, uint256 amount) internal  {
368         require(account != address(0), "ERC20: mint to the zero address");
369 
370 
371         _totalSupply = _totalSupply.add(amount);
372         _balances[account] = _balances[account].add(amount);
373         emit Transfer(address(0), account, amount);
374     }
375 
376     /**
377      * @dev Destroys `amount` tokens from `account`, reducing the
378      * total supply.
379      *
380      * Emits a {Transfer} event with `to` set to the zero address.
381      *
382      * Requirements
383      *
384      * - `account` cannot be the zero address.
385      * - `account` must have at least `amount` tokens.
386      */
387     function _burn(address account, uint256 amount) internal  {
388         require(account != address(0), "ERC20: burn from the zero address");
389 
390 
391         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
392         _totalSupply = _totalSupply.sub(amount);
393         emit Transfer(account, address(0), amount);
394     }
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
398      *
399      * This is internal function is equivalent to `approve`, and can be used to
400      * e.g. set automatic allowances for certain subsystems, etc.
401      *
402      * Emits an {Approval} event.
403      *
404      * Requirements:
405      *
406      * - `owner` cannot be the zero address.
407      * - `spender` cannot be the zero address.
408      */
409     function _approve(address owner, address spender, uint256 amount) internal  {
410         require(owner != address(0), "ERC20: approve from the zero address");
411         require(spender != address(0), "ERC20: approve to the zero address");
412 
413         _allowances[owner][spender] = amount;
414         emit Approval(owner, spender, amount);
415     }
416 
417    
418 }
419 
420 contract ERC20Detailed is IERC20 {
421   string private _name;
422   string private _symbol;
423   uint8 private _decimals;
424 
425   constructor(string memory name, string memory symbol, uint8 decimals) public {
426     _name = name;
427     _symbol = symbol;
428     _decimals = decimals;
429   }
430 
431   /**
432    * @return the name of the token.
433    */
434   function name() public view returns(string memory) {
435     return _name;
436   }
437 
438   /**
439    * @return the symbol of the token.
440    */
441   function symbol() public view returns(string memory) {
442     return _symbol;
443   }
444 
445   /**
446    * @return the number of decimals of the token.
447    */
448   function decimals() public view returns(uint8) {
449     return _decimals;
450   }
451 }
452 
453 contract StockLiquiditator is ERC20,ERC20Detailed
454 {
455 
456     using SafeMath for uint256;
457     
458     uint256 public cashDecimals;
459     uint256 public stockTokenMultiplier;
460     
461     ERC20Detailed internal cash;
462     ERC20Detailed internal stockToken;
463     
464     uint256 public stockToCashRate;
465     uint256 public poolToCashRate;
466     uint256 public cashValauationCap;
467     
468     string public url;
469     
470     event UrlUpdated(string _url);
471     event ValuationCapUpdated(uint256 cashCap);
472     event OwnerChanged(address indexed newOwner);
473     event PoolRateUpdated(uint256 poolrate);
474     event PoolTokensMinted(address indexed user,uint256 inputCashAmount,uint256 mintedPoolAmount);
475     event PoolTokensBurnt(address indexed user,uint256 burntPoolAmount,uint256 outputStockAmount,uint256 outputCashAmount);
476     event StockTokensRedeemed(address indexed user,uint256 redeemedStockToken,uint256 outputCashAmount);
477     
478     function () external payable {  //fallback function
479         
480     }
481     
482     address payable public owner;
483     
484     modifier onlyOwner() {
485         require (msg.sender == owner,"Account not Owner");
486         _;
487     }
488         
489     constructor (address cashAddress,address stockTokenAddress,uint256 _stockToCashRate,uint256 cashCap,string memory name,string memory symbol,string memory _url) 
490     public ERC20Detailed( name, symbol, 18)  
491     {
492         owner = msg.sender;
493         require(stockTokenAddress != address(0), "stockToken is the zero address");
494         require(cashAddress != address(0), "cash is the zero address");
495         cash = ERC20Detailed(cashAddress);
496         stockToken = ERC20Detailed(stockTokenAddress);
497         cashDecimals = cash.decimals();
498         stockTokenMultiplier = (10**uint256(stockToken.decimals()));
499         stockToCashRate = (10**(cashDecimals)).mul(_stockToCashRate);
500         updatePoolRate();
501         updateCashValuationCap(cashCap);
502         updateURL(_url);
503     }
504     
505     function updateURL(string memory _url) public onlyOwner returns(string memory){
506         url=_url;
507         emit UrlUpdated(_url);
508         return url;
509     }
510     
511     function updateCashValuationCap(uint256 cashCap) public onlyOwner returns(uint256){
512         cashValauationCap=cashCap;
513         emit ValuationCapUpdated(cashCap);
514         return cashValauationCap;
515     }
516     
517     function changeOwner(address payable newOwner) external onlyOwner {
518         owner=newOwner;
519         emit OwnerChanged(newOwner);
520     }
521     
522     function stockTokenAddress() public view returns (address) {
523         return address(stockToken);
524     }
525     
526     function _preValidateData(address beneficiary, uint256 amount) internal pure {
527         require(beneficiary != address(0), "Beneficiary can't be zero address");
528         require(amount != 0, "amount can't be 0");
529     }
530     
531     function contractCashBalance() public view returns(uint256 cashBalance){
532         return cash.balanceOf(address(this));
533     } 
534     
535     function contractStockTokenBalance() public view returns(uint256 stockTokenBalance){
536         return stockToken.balanceOf(address(this));
537     }
538     
539     function stockTokenCashValuation() internal view returns(uint256){
540         uint256 cashEquivalent=(contractStockTokenBalance().mul(stockToCashRate)).div(stockTokenMultiplier);
541         return cashEquivalent;
542     }
543     
544     function contractCashValuation() public view returns(uint256 cashValauation){
545         uint256 cashEquivalent=(contractStockTokenBalance().mul(stockToCashRate)).div(stockTokenMultiplier);
546         return contractCashBalance().add(cashEquivalent);
547     }
548 
549     function updatePoolRate() public returns (uint256 poolrate) {
550         if(totalSupply()==0){
551           poolToCashRate = (10**(cashDecimals)).mul(1);
552         }
553         else {
554             poolToCashRate=( (contractCashValuation().mul(1e18)).div(totalSupply()) );
555         }
556         emit PoolRateUpdated(poolrate);
557         return poolToCashRate;
558     }
559     
560     function mintPoolToken(uint256 inputCashAmount) external {    
561         if(cashValauationCap!=0)
562         {
563             require(inputCashAmount.add(contractCashValuation())<=cashValauationCap,"inputCashAmount exceeds cashValauationCap");
564         }
565         address sender= msg.sender;
566         _preValidateData(sender,inputCashAmount);
567         updatePoolRate();
568         uint256 balanceBeforeTransfer = cash.balanceOf(address(this));
569         cash.transferFrom(sender,address(this),inputCashAmount);
570         uint256 balanceAfterTransfer = cash.balanceOf(address(this));
571         require(balanceAfterTransfer == balanceBeforeTransfer.add(inputCashAmount),"Sent & Received Amount mismatched");
572         // calculate pool token amount to be minted
573         uint256 poolTokens = ( (inputCashAmount.mul(1e18)).div(poolToCashRate) );
574         _mint(sender, poolTokens); //Minting  Pool Token
575         emit PoolTokensMinted(sender,inputCashAmount,poolTokens);
576     }
577     
578     function burnPoolToken(uint256 poolTokenAmount) external {  
579         address sender= msg.sender;
580         _preValidateData(sender,poolTokenAmount);
581         
582         updatePoolRate();
583         uint256 cashToRedeem=( (poolTokenAmount.mul(poolToCashRate)).div(1e18) );
584         _burn(sender, poolTokenAmount);
585         
586         uint256 outputStockToken = 0;
587         uint256 outputCashAmount = 0;
588         
589         if( stockTokenCashValuation()>=cashToRedeem )
590         {
591          outputStockToken=( (cashToRedeem.mul(stockTokenMultiplier)).div(stockToCashRate) );//calculate stock token amount to be return
592          stockToken.transfer(sender,outputStockToken);
593         }
594         
595         else if( cashToRedeem>stockTokenCashValuation() )
596         {
597         outputStockToken=contractStockTokenBalance();
598         outputCashAmount=cashToRedeem.sub(stockTokenCashValuation());// calculate cash amount to be return
599         stockToken.transfer(sender,outputStockToken);
600         
601         uint256 balanceBeforeTransfer = cash.balanceOf(sender);
602         cash.transfer(sender,outputCashAmount);
603         uint256 balanceAfterTransfer = cash.balanceOf(sender);
604         require(balanceAfterTransfer == balanceBeforeTransfer.add(outputCashAmount),"Sent & Received Amount mismatched");
605         }
606         emit PoolTokensBurnt(sender,poolTokenAmount,outputStockToken,outputCashAmount);
607     }
608     
609     function redeemStockToken(uint256 stockTokenAmount) external{
610         address sender= msg.sender;
611         _preValidateData(sender,stockTokenAmount);
612         stockToken.transferFrom(sender,address(this),stockTokenAmount);
613         
614         // calculate Cash amount to be return
615         uint256 outputCashAmount=(stockTokenAmount.mul(stockToCashRate)).div(stockTokenMultiplier);
616         uint256 balanceBeforeTransfer = cash.balanceOf(sender);
617         cash.transfer(sender,outputCashAmount);
618         uint256 balanceAfterTransfer = cash.balanceOf(sender);
619         require(balanceAfterTransfer == balanceBeforeTransfer.add(outputCashAmount),"Sent & Received Amount mismatched");
620         emit StockTokensRedeemed(sender,stockTokenAmount,outputCashAmount);
621     }
622     
623     function kill() external onlyOwner {    //self destruct the code and transfer all contract balance to owner
624         selfdestruct(owner);
625     }
626     
627 }