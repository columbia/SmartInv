1 pragma solidity 0.5.16;
2 
3 interface IERC20 {
4   /**
5    * @dev Returns the amount of tokens in existence.
6    */
7   function totalSupply() external view returns (uint256);
8 
9   /**
10    * @dev Returns the token decimals.
11    */
12   function decimals() external view returns (uint8);
13 
14   /**
15    * @dev Returns the token symbol.
16    */
17   function symbol() external view returns (string memory);
18 
19   /**
20   * @dev Returns the token name.
21   */
22   function name() external view returns (string memory);
23 
24   /**
25    * @dev Returns the bep token owner.
26    */
27   function getOwner() external view returns (address);
28 
29   /**
30    * @dev Returns the amount of tokens owned by `account`.
31    */
32   function balanceOf(address account) external view returns (uint256);
33 
34   /**
35    * @dev Moves `amount` tokens from the caller's account to `recipient`.
36    *
37    * Returns a boolean value indicating whether the operation succeeded.
38    *
39    * Emits a {Transfer} event.
40    */
41   function transfer(address recipient, uint256 amount) external returns (bool);
42 
43   /**
44    * @dev Returns the remaining number of tokens that `spender` will be
45    * allowed to spend on behalf of `owner` through {transferFrom}. This is
46    * zero by default.
47    *
48    * This value changes when {approve} or {transferFrom} are called.
49    */
50   function allowance(address _owner, address spender) external view returns (uint256);
51 
52   /**
53    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54    *
55    * Returns a boolean value indicating whether the operation succeeded.
56    *
57    * IMPORTANT: Beware that changing an allowance with this method brings the risk
58    * that someone may use both the old and the new allowance by unfortunate
59    * transaction ordering. One possible solution to mitigate this race
60    * condition is to first reduce the spender's allowance to 0 and set the
61    * desired value afterwards:
62    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63    *
64    * Emits an {Approval} event.
65    */
66   function approve(address spender, uint256 amount) external returns (bool);
67 
68   /**
69    * @dev Moves `amount` tokens from `sender` to `recipient` using the
70    * allowance mechanism. `amount` is then deducted from the caller's
71    * allowance.
72    *
73    * Returns a boolean value indicating whether the operation succeeded.
74    *
75    * Emits a {Transfer} event.
76    */
77   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79   /**
80    * @dev Emitted when `value` tokens are moved from one account (`from`) to
81    * another (`to`).
82    *
83    * Note that `value` may be zero.
84    */
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 
87   /**
88    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89    * a call to {approve}. `value` is the new allowance.
90    */
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /*
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with GSN meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 contract Context {
105   // Empty internal constructor, to prevent people from mistakenly deploying
106   // an instance of this contract, which should be used via inheritance.
107   constructor () internal { }
108 
109   function _msgSender() internal view returns (address payable) {
110     return msg.sender;
111   }
112 
113   function _msgData() internal view returns (bytes memory) {
114     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
115     return msg.data;
116   }
117 }
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133   /**
134    * @dev Returns the addition of two unsigned integers, reverting on
135    * overflow.
136    *
137    * Counterpart to Solidity's `+` operator.
138    *
139    * Requirements:
140    * - Addition cannot overflow.
141    */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     require(c >= a, "SafeMath: addition overflow");
145 
146     return c;
147   }
148 
149   /**
150    * @dev Returns the subtraction of two unsigned integers, reverting on
151    * overflow (when the result is negative).
152    *
153    * Counterpart to Solidity's `-` operator.
154    *
155    * Requirements:
156    * - Subtraction cannot overflow.
157    */
158   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159     return sub(a, b, "SafeMath: subtraction overflow");
160   }
161 
162   /**
163    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164    * overflow (when the result is negative).
165    *
166    * Counterpart to Solidity's `-` operator.
167    *
168    * Requirements:
169    * - Subtraction cannot overflow.
170    */
171   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172     require(b <= a, errorMessage);
173     uint256 c = a - b;
174 
175     return c;
176   }
177 
178   /**
179    * @dev Returns the multiplication of two unsigned integers, reverting on
180    * overflow.
181    *
182    * Counterpart to Solidity's `*` operator.
183    *
184    * Requirements:
185    * - Multiplication cannot overflow.
186    */
187   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189     // benefit is lost if 'b' is also tested.
190     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191     if (a == 0) {
192       return 0;
193     }
194 
195     uint256 c = a * b;
196     require(c / a == b, "SafeMath: multiplication overflow");
197 
198     return c;
199   }
200 
201   /**
202    * @dev Returns the integer division of two unsigned integers. Reverts on
203    * division by zero. The result is rounded towards zero.
204    *
205    * Counterpart to Solidity's `/` operator. Note: this function uses a
206    * `revert` opcode (which leaves remaining gas untouched) while Solidity
207    * uses an invalid opcode to revert (consuming all remaining gas).
208    *
209    * Requirements:
210    * - The divisor cannot be zero.
211    */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     return div(a, b, "SafeMath: division by zero");
214   }
215 
216   /**
217    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218    * division by zero. The result is rounded towards zero.
219    *
220    * Counterpart to Solidity's `/` operator. Note: this function uses a
221    * `revert` opcode (which leaves remaining gas untouched) while Solidity
222    * uses an invalid opcode to revert (consuming all remaining gas).
223    *
224    * Requirements:
225    * - The divisor cannot be zero.
226    */
227   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228     // Solidity only automatically asserts when dividing by 0
229     require(b > 0, errorMessage);
230     uint256 c = a / b;
231     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233     return c;
234   }
235 
236   /**
237    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238    * Reverts when dividing by zero.
239    *
240    * Counterpart to Solidity's `%` operator. This function uses a `revert`
241    * opcode (which leaves remaining gas untouched) while Solidity uses an
242    * invalid opcode to revert (consuming all remaining gas).
243    *
244    * Requirements:
245    * - The divisor cannot be zero.
246    */
247   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248     return mod(a, b, "SafeMath: modulo by zero");
249   }
250 
251   /**
252    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253    * Reverts with custom message when dividing by zero.
254    *
255    * Counterpart to Solidity's `%` operator. This function uses a `revert`
256    * opcode (which leaves remaining gas untouched) while Solidity uses an
257    * invalid opcode to revert (consuming all remaining gas).
258    *
259    * Requirements:
260    * - The divisor cannot be zero.
261    */
262   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263     require(b != 0, errorMessage);
264     return a % b;
265   }
266 }
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 contract Ownable is Context {
281   address private _owner;
282 
283   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285   /**
286    * @dev Initializes the contract setting the deployer as the initial owner.
287    */
288   constructor () internal {
289     address msgSender = _msgSender();
290     _owner = msgSender;
291     emit OwnershipTransferred(address(0), msgSender);
292   }
293 
294   /**
295    * @dev Returns the address of the current owner.
296    */
297   function owner() public view returns (address) {
298     return _owner;
299   }
300 
301   /**
302    * @dev Throws if called by any account other than the owner.
303    */
304   modifier onlyOwner() {
305     require(_owner == _msgSender(), "Ownable: caller is not the owner");
306     _;
307   }
308 
309   /**
310    * @dev Leaves the contract without owner. It will not be possible to call
311    * `onlyOwner` functions anymore. Can only be called by the current owner.
312    *
313    * NOTE: Renouncing ownership will leave the contract without an owner,
314    * thereby removing any functionality that is only available to the owner.
315    */
316   function renounceOwnership() external onlyOwner {
317     emit OwnershipTransferred(_owner, address(0));
318     _owner = address(0);
319   }
320 
321   /**
322    * @dev Transfers ownership of the contract to a new account (`newOwner`).
323    * Can only be called by the current owner.
324    */
325   function transferOwnership(address newOwner) external onlyOwner {
326     _transferOwnership(newOwner);
327   }
328 
329   /**
330    * @dev Transfers ownership of the contract to a new account (`newOwner`).
331    */
332   function _transferOwnership(address newOwner) internal {
333     require(newOwner != address(0), "Ownable: new owner is the zero address");
334     emit OwnershipTransferred(_owner, newOwner);
335     _owner = newOwner;
336   }
337 }
338 
339 contract LGEWhitelisted is Context {
340     
341     using SafeMath for uint256;
342     
343     struct WhitelistRound {
344         uint256 duration;
345         uint256 amountMax;
346         mapping(address => bool) addresses;
347         mapping(address => uint256) purchased;
348     }
349   
350     WhitelistRound[] public _lgeWhitelistRounds;
351     
352     uint256 public _lgeTimestamp;
353     address public _lgePairAddress;
354     
355     address public _whitelister;
356     
357     event WhitelisterTransferred(address indexed previousWhitelister, address indexed newWhitelister);
358     
359     constructor () internal {
360         _whitelister = _msgSender();
361     }
362     
363     modifier onlyWhitelister() {
364         require(_whitelister == _msgSender(), "Caller is not the whitelister");
365         _;
366     }
367     
368     function renounceWhitelister() external onlyWhitelister {
369         emit WhitelisterTransferred(_whitelister, address(0));
370         _whitelister = address(0);
371     }
372     
373     function transferWhitelister(address newWhitelister) external onlyWhitelister {
374         _transferWhitelister(newWhitelister);
375     }
376     
377     function _transferWhitelister(address newWhitelister) internal {
378         require(newWhitelister != address(0), "New whitelister is the zero address");
379         emit WhitelisterTransferred(_whitelister, newWhitelister);
380         _whitelister = newWhitelister;
381     }
382     
383     /*
384      * createLGEWhitelist - Call this after initial Token Generation Event (TGE) 
385      * 
386      * pairAddress - address generated from createPair() event on DEX
387      * durations - array of durations (seconds) for each whitelist rounds
388      * amountsMax - array of max amounts (TOKEN decimals) for each whitelist round
389      * 
390      */
391   
392     function createLGEWhitelist(address pairAddress, uint256[] calldata durations, uint256[] calldata amountsMax) external onlyWhitelister() {
393         require(durations.length == amountsMax.length, "Invalid whitelist(s)");
394         
395         _lgePairAddress = pairAddress;
396         
397         if(durations.length > 0) {
398             
399             delete _lgeWhitelistRounds;
400         
401             for (uint256 i = 0; i < durations.length; i++) {
402                 _lgeWhitelistRounds.push(WhitelistRound(durations[i], amountsMax[i]));
403             }
404         
405         }
406     }
407     
408     /*
409      * modifyLGEWhitelistAddresses - Define what addresses are included/excluded from a whitelist round
410      * 
411      * index - 0-based index of round to modify whitelist
412      * duration - period in seconds from LGE event or previous whitelist round
413      * amountMax - max amount (TOKEN decimals) for each whitelist round
414      * 
415      */
416     
417     function modifyLGEWhitelist(uint256 index, uint256 duration, uint256 amountMax, address[] calldata addresses, bool enabled) external onlyWhitelister() {
418         require(index < _lgeWhitelistRounds.length, "Invalid index");
419         require(amountMax > 0, "Invalid amountMax");
420 
421         if(duration != _lgeWhitelistRounds[index].duration)
422             _lgeWhitelistRounds[index].duration = duration;
423         
424         if(amountMax != _lgeWhitelistRounds[index].amountMax)  
425             _lgeWhitelistRounds[index].amountMax = amountMax;
426         
427         for (uint256 i = 0; i < addresses.length; i++) {
428             _lgeWhitelistRounds[index].addresses[addresses[i]] = enabled;
429         }
430     }
431     
432     /*
433      *  getLGEWhitelistRound
434      *
435      *  returns:
436      *
437      *  1. whitelist round number ( 0 = no active round now )
438      *  2. duration, in seconds, current whitelist round is active for
439      *  3. timestamp current whitelist round closes at
440      *  4. maximum amount a whitelister can purchase in this round
441      *  5. is caller whitelisted
442      *  6. how much caller has purchased in current whitelist round
443      *
444      */
445     
446     function getLGEWhitelistRound() public view returns (uint256, uint256, uint256, uint256, bool, uint256) {
447         
448         if(_lgeTimestamp > 0) {
449             
450             uint256 wlCloseTimestampLast = _lgeTimestamp;
451         
452             for (uint256 i = 0; i < _lgeWhitelistRounds.length; i++) {
453                 
454                 WhitelistRound storage wlRound = _lgeWhitelistRounds[i];
455                 
456                 wlCloseTimestampLast = wlCloseTimestampLast.add(wlRound.duration);
457                 if(now <= wlCloseTimestampLast)
458                     return (i.add(1), wlRound.duration, wlCloseTimestampLast, wlRound.amountMax, wlRound.addresses[_msgSender()], wlRound.purchased[_msgSender()]);
459             }
460         
461         }
462         
463         return (0, 0, 0, 0, false, 0);
464     }
465     
466     /*
467      * _applyLGEWhitelist - internal function to be called initially before any transfers
468      * 
469      */
470     
471     function _applyLGEWhitelist(address sender, address recipient, uint256 amount) internal {
472         
473         if(_lgePairAddress == address(0) || _lgeWhitelistRounds.length == 0)
474             return;
475         
476         if(_lgeTimestamp == 0 && sender != _lgePairAddress && recipient == _lgePairAddress && amount > 0)
477             _lgeTimestamp = now;
478         
479         if(sender == _lgePairAddress && recipient != _lgePairAddress) {
480             //buying
481             
482             (uint256 wlRoundNumber,,,,,) = getLGEWhitelistRound();
483         
484             if(wlRoundNumber > 0) {
485                 
486                 WhitelistRound storage wlRound = _lgeWhitelistRounds[wlRoundNumber.sub(1)];
487                 
488                 require(wlRound.addresses[recipient], "LGE - Buyer is not whitelisted");
489                 
490                 uint256 amountRemaining = 0;
491                 
492                 if(wlRound.purchased[recipient] < wlRound.amountMax)
493                     amountRemaining = wlRound.amountMax.sub(wlRound.purchased[recipient]);
494     
495                 require(amount <= amountRemaining, "LGE - Amount exceeds whitelist maximum");
496                 wlRound.purchased[recipient] = wlRound.purchased[recipient].add(amount);
497                 
498             }
499             
500         }
501         
502     }
503     
504 }
505 
506 contract X22Token is Context, IERC20, Ownable, LGEWhitelisted {
507     
508     using SafeMath for uint256;
509     
510     mapping (address => uint256) private _balances;
511     
512     mapping (address => mapping (address => uint256)) private _allowances;
513     
514     uint256 private _totalSupply;
515     uint8 private _decimals;
516     string private _symbol;
517     string private _name;
518     
519     constructor() public {
520         _name = "X22";
521         _symbol = "X22";
522         _decimals = 18;
523         _totalSupply = 20000022 * 10 ** 18;
524         _balances[_msgSender()] = _totalSupply;
525         
526         emit Transfer(address(0), _msgSender(), _totalSupply);
527     }
528 
529     /**
530     * @dev Returns the bep token owner.
531     */
532     
533     function getOwner() external view returns (address) {
534         return owner();
535     }
536     
537     /**
538     * @dev Returns the token decimals.
539     */
540     function decimals() external view returns (uint8) {
541         return _decimals;
542     }
543     
544     /**
545     * @dev Returns the token symbol.
546     */
547     function symbol() external view returns (string memory) {
548         return _symbol;
549     }
550     
551     /**
552     * @dev Returns the token name.
553     */
554     function name() external view returns (string memory) {
555         return _name;
556     }
557     
558     /**
559     * @dev See {ERC20-totalSupply}.
560     */
561     function totalSupply() external view returns (uint256) {
562         return _totalSupply;
563     }
564     
565     /**
566     * @dev See {ERC20-balanceOf}.
567     */
568     function balanceOf(address account) external view returns (uint256) {
569         return _balances[account];
570     }
571     
572     /**
573     * @dev See {ERC20-transfer}.
574     *
575     * Requirements:
576     *
577     * - `recipient` cannot be the zero address.
578     * - the caller must have a balance of at least `amount`.
579     */
580     function transfer(address recipient, uint256 amount) external returns (bool) {
581         _transfer(_msgSender(), recipient, amount);
582         return true;
583     }
584     
585     /**
586     * @dev See {ERC20-allowance}.
587     */
588     function allowance(address owner, address spender) external view returns (uint256) {
589         return _allowances[owner][spender];
590     }
591     
592     /**
593     * @dev See {ERC20-approve}.
594     *
595     * Requirements:
596     *
597     * - `spender` cannot be the zero address.
598     */
599     function approve(address spender, uint256 amount) external returns (bool) {
600         _approve(_msgSender(), spender, amount);
601         return true;
602     }
603     
604     /**
605     * @dev See {ERC20-transferFrom}.
606     *
607     * Emits an {Approval} event indicating the updated allowance. This is not
608     * required by the EIP. See the note at the beginning of {ERC20};
609     *
610     * Requirements:
611     * - `sender` and `recipient` cannot be the zero address.
612     * - `sender` must have a balance of at least `amount`.
613     * - the caller must have allowance for `sender`'s tokens of at least
614     * `amount`.
615     */
616     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
617         _transfer(sender, recipient, amount);
618         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
619         return true;
620     }
621     
622     /**
623     * @dev Atomically increases the allowance granted to `spender` by the caller.
624     *
625     * This is an alternative to {approve} that can be used as a mitigation for
626     * problems described in {ERC20-approve}.
627     *
628     * Emits an {Approval} event indicating the updated allowance.
629     *
630     * Requirements:
631     *
632     * - `spender` cannot be the zero address.
633     */
634     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
636         return true;
637     }
638     
639     /**
640     * @dev Atomically decreases the allowance granted to `spender` by the caller.
641     *
642     * This is an alternative to {approve} that can be used as a mitigation for
643     * problems described in {BEP20-approve}.
644     *
645     * Emits an {Approval} event indicating the updated allowance.
646     *
647     * Requirements:
648     *
649     * - `spender` cannot be the zero address.
650     * - `spender` must have allowance for the caller of at least
651     * `subtractedValue`.
652     */
653     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
654         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
655         return true;
656     }
657     
658     /**
659     * @dev Moves tokens `amount` from `sender` to `recipient`.
660     *
661     * This is internal function is equivalent to {transfer}, and can be used to
662     * e.g. implement automatic token fees, slashing mechanisms, etc.
663     *
664     * Emits a {Transfer} event.
665     *
666     * Requirements:
667     *
668     * - `sender` cannot be the zero address.
669     * - `recipient` cannot be the zero address.
670     * - `sender` must have a balance of at least `amount`.
671     */
672     function _transfer(address sender, address recipient, uint256 amount) internal {
673         require(sender != address(0), "ERC20: transfer from the zero address");
674         require(recipient != address(0), "ERC20: transfer to the zero address");
675         
676         _applyLGEWhitelist(sender, recipient, amount);
677         
678         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
679         _balances[recipient] = _balances[recipient].add(amount);
680         emit Transfer(sender, recipient, amount);
681     }
682     
683     /**
684     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
685     *
686     * This is internal function is equivalent to `approve`, and can be used to
687     * e.g. set automatic allowances for certain subsystems, etc.
688     *
689     * Emits an {Approval} event.
690     *
691     * Requirements:
692     *
693     * - `owner` cannot be the zero address.
694     * - `spender` cannot be the zero address.
695     */
696     function _approve(address owner, address spender, uint256 amount) internal {
697         require(owner != address(0), "ERC20: approve from the zero address");
698         require(spender != address(0), "ERC20: approve to the zero address");
699         
700         _allowances[owner][spender] = amount;
701         emit Approval(owner, spender, amount);
702     }
703     
704 }