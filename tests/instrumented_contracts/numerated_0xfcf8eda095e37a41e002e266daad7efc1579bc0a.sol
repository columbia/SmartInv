1 // File contracts/CoinFLEX/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity ^0.6.0;
5 
6 abstract contract Context {
7   // Empty internal constructor, to prevent people from mistakenly deploying
8   // an instance of this contract, which should be used via inheritance.
9   constructor() internal {}
10 
11   function _msgSender() internal view returns (address payable) {
12     return msg.sender;
13   }
14 
15   function _msgData() internal view returns (bytes memory) {
16     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17     return msg.data;
18   }
19 }
20 
21 
22 // File contracts/CoinFLEX/IERC20.sol
23 
24 interface IERC20 {
25   /**
26    * @dev Returns the amount of tokens in existence.
27    */
28   function totalSupply() external view returns (uint256);
29 
30   /**
31    * @dev Returns the amount of tokens owned by `account`.
32    */
33   function balanceOf(address account) external view returns (uint256);
34 
35   /**
36    * @dev Moves `amount` tokens from the caller's account to `recipient`.
37    *
38    * Returns a boolean value indicating whether the operation succeeded.
39    *
40    * Emits a {Transfer} event.
41    */
42   function transfer(address recipient, uint256 amount)
43     external
44     returns (bool);
45 
46   /**
47    * @dev Returns the remaining number of tokens that `spender` will be
48    * allowed to spend on behalf of `owner` through {transferFrom}. This is
49    * zero by default.
50    *
51    * This value changes when {approve} or {transferFrom} are called.
52    */
53   function allowance(address owner, address spender)
54     external
55     view
56     returns (uint256);
57 
58   /**
59    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60    *
61    * Returns a boolean value indicating whether the operation succeeded.
62    *
63    * IMPORTANT: Beware that changing an allowance with this method brings the risk
64    * that someone may use both the old and the new allowance by unfortunate
65    * transaction ordering. One possible solution to mitigate this race
66    * condition is to first reduce the spender's allowance to 0 and set the
67    * desired value afterwards:
68    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69    *
70    * Emits an {Approval} event.
71    */
72   function approve(address spender, uint256 amount) external returns (bool);
73 
74   /**
75    * @dev Moves `amount` tokens from `sender` to `recipient` using the
76    * allowance mechanism. `amount` is then deducted from the caller's
77    * allowance.
78    *
79    * Returns a boolean value indicating whether the operation succeeded.
80    *
81    * Emits a {Transfer} event.
82    */
83   function transferFrom(
84     address sender,
85     address recipient,
86     uint256 amount
87   ) external returns (bool);
88 
89   /**
90    * @dev Emitted when `value` tokens are moved from one account (`from`) to
91    * another (`to`).
92    *
93    * Note that `value` may be zero.
94    */
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 
97   /**
98    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99    * a call to {approve}. `value` is the new allowance.
100    */
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 
108 
109 // File contracts/CoinFLEX/Storage.sol
110 
111 contract Storage {
112   /** 
113    * @dev WARNING: NEVER RE-ORDER VARIABLES! 
114    *  Always double-check that new variables are added APPEND-ONLY.
115    *  Re-ordering variables can permanently BREAK the deployed proxy contract.
116    */
117   bool public initialized;
118   mapping(address => uint256) internal _balances;
119   mapping(address => mapping(address => uint256)) internal _allowances;
120   mapping(address => bool) public blacklist;
121   uint256 internal _totalSupply;
122   string public name;
123   string public symbol;
124   uint256 public multiplier;
125   uint8 public constant decimals = 18;
126   address public admin;
127   uint256 internal constant deci = 1e18;
128   bool internal getpause;
129 
130   constructor(string memory _name, string memory _symbol) public {
131     name = _name;
132     symbol = _symbol;
133   }
134 }
135 
136 
137 // File contracts/CoinFLEX/LibertyLock.sol
138 
139 abstract contract LibraryLock is Storage {
140   // Ensures no one can manipulate the Logic Contract once it is deployed.	
141   // PARITY WALLET HACK PREVENTION	
142 
143   modifier delegatedOnly() {	
144     require(	
145       initialized == true,
146       "The library is locked. No direct 'call' is allowed."	
147     );	
148     _;	
149   }
150 
151   function initialize() internal {	
152     initialized = true;	
153   }
154 }
155 
156 
157 // File contracts/CoinFLEX/Proxiable.sol
158 
159 
160 contract Proxiable {
161   // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
162 
163   function updateCodeAddress(address newAddress) internal {
164     require(
165       bytes32(
166         0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7
167       ) == Proxiable(newAddress).proxiableUUID(),
168       'Not compatible'
169     );
170     assembly {
171       // solium-disable-line
172       sstore(
173         0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7,
174         newAddress
175       )
176     }
177   }
178 
179   function proxiableUUID() public pure returns (bytes32) {
180     return
181       0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
182   }
183 }
184 
185 
186 // File contracts/CoinFLEX/SafeMath.sol
187 
188 
189 library SafeMath {
190   /**
191    * @dev Returns the addition of two unsigned integers, reverting on
192    * overflow.
193    *
194    * Counterpart to Solidity's `+` operator.
195    *
196    * Requirements:
197    * - Addition cannot overflow.
198    */
199   function add(uint256 a, uint256 b) internal pure returns (uint256) {
200     uint256 c = a + b;
201     require(c >= a, "SafeMath: addition overflow");
202 
203     return c;
204   }
205 
206   /**
207    * @dev Returns the subtraction of two unsigned integers, reverting on
208    * overflow (when the result is negative).
209    *
210    * Counterpart to Solidity's `-` operator.
211    *
212    * Requirements:
213    * - Subtraction cannot overflow.
214    */
215   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216     return sub(a, b, "SafeMath: subtraction overflow");
217   }
218 
219   /**
220    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
221    * overflow (when the result is negative).
222    *
223    * Counterpart to Solidity's `-` operator.
224    *
225    * Requirements:
226    * - Subtraction cannot overflow.
227    */
228   function sub(
229     uint256 a,
230     uint256 b,
231     string memory errorMessage
232   ) internal pure returns (uint256) {
233     require(b <= a, errorMessage);
234     uint256 c = a - b;
235 
236     return c;
237   }
238 
239   /**
240    * @dev Returns the multiplication of two unsigned integers, reverting on
241    * overflow.
242    *
243    * Counterpart to Solidity's `*` operator.
244    *
245    * Requirements:
246    * - Multiplication cannot overflow.
247    */
248   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
250     // benefit is lost if 'b' is also tested.
251     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
252     if (a == 0) {
253       return 0;
254     }
255 
256     uint256 c = a * b;
257     require(c / a == b, "SafeMath: multiplication overflow");
258 
259     return c;
260   }
261 
262   /**
263    * @dev Returns the integer division of two unsigned integers. Reverts on
264    * division by zero. The result is rounded towards zero.
265    *
266    * Counterpart to Solidity's `/` operator. Note: this function uses a
267    * `revert` opcode (which leaves remaining gas untouched) while Solidity
268    * uses an invalid opcode to revert (consuming all remaining gas).
269    *
270    * Requirements:
271    * - The divisor cannot be zero.
272    */
273   function div(uint256 a, uint256 b) internal pure returns (uint256) {
274     return div(a, b, "SafeMath: division by zero");
275   }
276 
277   /**
278    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
279    * division by zero. The result is rounded towards zero.
280    *
281    * Counterpart to Solidity's `/` operator. Note: this function uses a
282    * `revert` opcode (which leaves remaining gas untouched) while Solidity
283    * uses an invalid opcode to revert (consuming all remaining gas).
284    *
285    * Requirements:
286    * - The divisor cannot be zero.
287    */
288   function div(
289     uint256 a,
290     uint256 b,
291     string memory errorMessage
292   ) internal pure returns (uint256) {
293     // Solidity only automatically asserts when dividing by 0
294     require(b > 0, errorMessage);
295     uint256 c = a / b;
296     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
297 
298     return c;
299   }
300 
301   /**
302    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303    * Reverts when dividing by zero.
304    *
305    * Counterpart to Solidity's `%` operator. This function uses a `revert`
306    * opcode (which leaves remaining gas untouched) while Solidity uses an
307    * invalid opcode to revert (consuming all remaining gas).
308    *
309    * Requirements:
310    * - The divisor cannot be zero.
311    */
312   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
313     return mod(a, b, "SafeMath: modulo by zero");
314   }
315 
316   /**
317    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318    * Reverts with custom message when dividing by zero.
319    *
320    * Counterpart to Solidity's `%` operator. This function uses a `revert`
321    * opcode (which leaves remaining gas untouched) while Solidity uses an
322    * invalid opcode to revert (consuming all remaining gas).
323    *
324    * Requirements:
325    * - The divisor cannot be zero.
326    */
327   function mod(
328     uint256 a,
329     uint256 b,
330     string memory errorMessage
331   ) internal pure returns (uint256) {
332     require(b != 0, errorMessage);
333     return a % b;
334   }
335 }
336 
337 
338 // File contracts/CoinFLEX/FlexCoin.sol
339 
340 contract FLEXCoin is Storage, Context, IERC20, Proxiable, LibraryLock {	
341   using SafeMath for uint256;
342 
343   event TokenBlacklist(address indexed account, bool blocked);
344   event ChangeMultiplier(uint256 multiplier);
345   event AdminChanged(address admin);
346   event CodeUpdated(address indexed newCode);	
347 
348   constructor() Storage("FLEX Coin", "FLEX") public {}
349 
350   function initialize(uint256 _totalsupply) public {
351     require(!initialized, "The library has already been initialized.");	
352     LibraryLock.initialize();
353     admin = msg.sender;
354     multiplier = 1 * deci;
355     _totalSupply = _totalsupply;
356     _balances[msg.sender] = _totalSupply;
357   }
358 
359   /// @dev Update the logic contract code	
360   function updateCode(address newCode) external onlyAdmin delegatedOnly {	
361     updateCodeAddress(newCode);	
362     emit CodeUpdated(newCode);	
363   }
364 
365   function setMultiplier(uint256 _multiplier)
366     external
367     onlyAdmin()
368     ispaused()
369   {
370     require(
371       _multiplier > multiplier,
372       "the multiplier should be greater than previous multiplier"
373     );
374     multiplier = _multiplier;
375     emit ChangeMultiplier(multiplier);
376   }
377 
378   function totalSupply() public override view returns (uint256) {
379     return _totalSupply.mul(multiplier).div(deci);
380   }
381 
382   function setTotalSupply(uint256 inputTotalsupply) external onlyAdmin() {
383     require(
384       inputTotalsupply > totalSupply(),
385       "the input total supply is not greater than present total supply"
386     );
387     multiplier = (inputTotalsupply.mul(deci)).div(_totalSupply);
388     emit ChangeMultiplier(multiplier);
389   }
390 
391   function balanceOf(address account) public override view returns (uint256) {
392     uint256 externalAmt;
393     externalAmt = _balances[account].mul(multiplier).div(deci);
394     return externalAmt;
395   }
396 
397   function transfer(address recipient, uint256 amount)
398     public
399     virtual
400     override
401     Notblacklist(msg.sender)
402     Notblacklist(recipient)
403     ispaused()
404     returns (bool)
405   {
406     uint256 internalAmt;
407     uint256 externalAmt = amount;
408     internalAmt = (amount.mul(deci)).div(multiplier);
409 
410     _transfer(msg.sender, recipient, externalAmt);
411     return true;
412   }
413 
414   function allowance(address owner, address spender)
415     public
416     virtual
417     override
418     view
419     returns (uint256)
420   {
421     uint256 internalAmt;
422     internalAmt = (_allowances[owner][spender]).mul(multiplier).div(deci);
423     return internalAmt;
424   }
425 
426   function approve(address spender, uint256 amount)
427     public
428     virtual
429     override
430     Notblacklist(spender)
431     Notblacklist(msg.sender)
432     ispaused()
433     returns (bool)
434   {
435     uint256 internalAmt;
436     uint256 externalAmt = amount;
437     internalAmt = externalAmt.mul(deci).div(multiplier);
438     _approve(msg.sender, spender, externalAmt);
439     return true;
440   }
441   
442     /**
443    * @dev Atomically increases the allowance granted to `spender` by the caller.
444    *
445    * This is an alternative to {approve} that can be used as a mitigation for
446    * problems described in {IERC20-approve}.
447    *
448    * Emits an {Approval} event indicating the updated allowance.
449    *
450    * Requirements:
451    *
452    * - `spender` cannot be the zero address.
453    */
454   function increaseAllowance(address spender, uint256 addedValue) public 
455     Notblacklist(spender)
456     Notblacklist(msg.sender)
457     ispaused()  
458     returns (bool) {
459      uint256 externalAmt = allowance(_msgSender(),spender) ;
460     _approve(_msgSender(), spender, externalAmt.add(addedValue));
461     return true;
462   }
463 
464   /**
465    * @dev Atomically decreases the allowance granted to `spender` by the caller.
466    *
467    * This is an alternative to {approve} that can be used as a mitigation for
468    * problems described in {IERC20-approve}.
469    *
470    * Emits an {Approval} event indicating the updated allowance.
471    *
472    * Requirements:
473    *
474    * - `spender` cannot be the zero address.
475    * - `spender` must have allowance for the caller of at least
476    * `subtractedValue`.
477    */
478   function decreaseAllowance(address spender, uint256 subtractedValue) public 
479     Notblacklist(spender)
480     Notblacklist(msg.sender)
481     ispaused() 
482     returns (bool) {
483     uint256 externalAmt = allowance(_msgSender(),spender) ;
484     _approve(_msgSender(), spender, externalAmt.sub(subtractedValue, "ERC20: decreased allowance below zero"));
485     return true;
486   }
487 
488   function transferFrom(
489     address sender,
490     address recipient,
491     uint256 amount
492   )
493     public
494     virtual
495     override
496     Notblacklist(sender)
497     Notblacklist(msg.sender)
498     Notblacklist(recipient)
499     ispaused()
500     returns (bool)
501   {
502     uint256 externalAmt = allowance(sender,_msgSender());
503     _transfer(sender, recipient, amount);
504     _approve(
505       sender,
506       _msgSender(),
507        externalAmt.sub(
508         amount,
509         "ERC20: transfer amount exceeds allowance"
510       )
511     );
512     return true;
513   }
514 
515   function _transfer(
516     address sender,
517     address recipient,
518     uint256 externalAmt
519   ) internal virtual {
520     require(sender != address(0), "ERC20: transfer from the zero address");
521     require(recipient != address(0), "ERC20: transfer to the zero address");
522     uint256 internalAmt = externalAmt.mul(deci).div(multiplier);
523     _balances[sender] = _balances[sender].sub(
524       internalAmt,
525       "ERC20: transfer internalAmt exceeds balance"
526     );
527     _balances[recipient] = _balances[recipient].add(internalAmt);
528     emit Transfer(sender, recipient, externalAmt);
529   }
530 
531   function mint(address mintTo, uint256 amount)
532     public
533     virtual
534     onlyAdmin()
535     ispaused()
536     returns (bool)
537   {
538     uint256 externalAmt = amount;
539     uint256 internalAmt = externalAmt.mul(deci).div(multiplier);
540     _mint(mintTo, internalAmt, externalAmt);
541     return true;
542   }
543 
544   function _mint(
545     address account,
546     uint256 internalAmt,
547     uint256 externalAmt
548   ) internal virtual {
549     require(account != address(0), "ERC20: mint to the zero address");
550 
551     _totalSupply = _totalSupply.add(internalAmt);
552     _balances[account] = _balances[account].add(internalAmt);
553     emit Transfer(address(0), account, externalAmt);
554   }
555 
556   function burn(address burnFrom, uint256 amount)
557     public
558     virtual
559     onlyAdmin()
560     ispaused()
561     returns (bool)
562   {
563     uint256 internalAmt;
564     uint256 externalAmt = amount;
565     internalAmt = externalAmt.mul(deci).div(multiplier);
566 
567     _burn(burnFrom, internalAmt, externalAmt);
568     return true;
569   }
570 
571   function _burn(
572     address account,
573     uint256 internalAmt,
574     uint256 externalAmt
575   ) internal virtual {
576     require(account != address(0), "ERC20: burn from the zero address");
577 
578     _balances[account] = _balances[account].sub(
579       internalAmt,
580       "ERC20: burn internaAmt exceeds balance"
581     );
582     _totalSupply = _totalSupply.sub(internalAmt);
583     emit Transfer(account, address(0), externalAmt);
584   }
585 
586   function _approve(
587     address owner,
588     address spender,
589     uint256 externalAmt
590   ) internal virtual {
591     require(owner != address(0), "ERC20: approve from the zero address");
592     require(spender != address(0), "ERC20: approve to the zero address");
593     uint256 internalAmt = externalAmt.mul(deci).div(multiplier);
594     _allowances[owner][spender] = internalAmt;
595     emit Approval(owner, spender,externalAmt);
596   }
597 
598   function TransferOwnership(address account) public onlyAdmin() {
599     require(account != address(0), "account cannot be zero address");
600     require(msg.sender == admin, "you are not the admin");
601     admin = account;
602     emit AdminChanged(admin);
603   }
604 
605   function pause() external onlyAdmin() {
606     getpause = true;
607   }
608 
609   function unpause() external onlyAdmin() {
610     getpause = false;
611   }
612 
613   // pause unpause
614 
615   modifier ispaused() {
616     require(getpause == false, "the contract is paused");
617     _;
618   }
619 
620   modifier onlyAdmin() {
621     require(msg.sender == admin, "you are not the admin");
622     _;
623   }
624 
625   function AddToBlacklist(address account) external onlyAdmin() {
626     blacklist[account] = true;
627     emit TokenBlacklist(account, true);
628   }
629 
630   function RemoveFromBlacklist(address account) external onlyAdmin() {
631     blacklist[account] = false;
632     emit TokenBlacklist(account, false);
633   }
634 
635   modifier Notblacklist(address account) {
636     require(!blacklist[account], "account is blacklisted");
637     _;
638   }
639 }