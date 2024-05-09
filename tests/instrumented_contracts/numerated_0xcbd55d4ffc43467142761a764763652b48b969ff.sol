1 pragma solidity ^0.6.0;
2 
3 /*        
4      Website: https://astrotools.io/
5      Twitter: https://twitter.com/@Astro_Tools
6                                       ,                                         
7                                      ###                                        
8                                     #####*                                      
9                                   *########                                     
10                                  ###########                                    
11                                 #############/                                  
12                               /################                                 
13                              ###################                                
14                             #########   #########(                              
15                           (#####*   *###,   *######                             
16                          ##(    #############    ###                            
17                            #######################                              
18                       /###############################*                         
19                  .#########################################                     
20              ###################################################                
21         ############################################################/           
22    *########################/  ###############  *########################.      
23    #####################       ###############       #####################      
24    ################.   (####(  ###############  ######    ################      
25    ###########/   ,########(   ###############   #########/   .###########      
26    #######    ############.    ###############    .############.   /######      
27    ##     ###############      ###############      ###############     ##      
28          ###############       ###############       ###############*           
29        /##############*        ###############        (###############          
30       ###############          ###############         .###############         
31      ###############           ###############           ###############/       
32    ##############              /##############              ##############      
33                                   .#######(                                     
34                                       #.                                         
35  */
36 
37 abstract contract Context {
38     function _msgSender() internal virtual view returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal virtual view returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 /**
49  * @dev Interface of the ERC20 standard as defined in the EIP.
50  */
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount)
70         external
71         returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address owner, address spender)
81         external
82         view
83         returns (uint256);
84 
85     /**
86      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * IMPORTANT: Beware that changing an allowance with this method brings the risk
91      * that someone may use both the old and the new allowance by unfortunate
92      * transaction ordering. One possible solution to mitigate this race
93      * condition is to first reduce the spender's allowance to 0 and set the
94      * desired value afterwards:
95      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
96      *
97      * Emits an {Approval} event.
98      */
99     function approve(address spender, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Moves `amount` tokens from `sender` to `recipient` using the
103      * allowance mechanism. `amount` is then deducted from the caller's
104      * allowance.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address sender,
112         address recipient,
113         uint256 amount
114     ) external returns (bool);
115 
116     /**
117      * @dev Emitted when `value` tokens are moved from one account (`from`) to
118      * another (`to`).
119      *
120      * Note that `value` may be zero.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 value);
123 
124     /**
125      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
126      * a call to {approve}. `value` is the new allowance.
127      */
128     event Approval(
129         address indexed owner,
130         address indexed spender,
131         uint256 value
132     );
133 }
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      *
157      * - Addition cannot overflow.
158      */
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         require(c >= a, "SafeMath: addition overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         return sub(a, b, "SafeMath: subtraction overflow");
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         require(b <= a, errorMessage);
196         uint256 c = a - b;
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the multiplication of two unsigned integers, reverting on
203      * overflow.
204      *
205      * Counterpart to Solidity's `*` operator.
206      *
207      * Requirements:
208      *
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
213         // benefit is lost if 'b' is also tested.
214         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
215         if (a == 0) {
216             return 0;
217         }
218 
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         return div(a, b, "SafeMath: division by zero");
239     }
240 
241     /**
242      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
243      * division by zero. The result is rounded towards zero.
244      *
245      * Counterpart to Solidity's `/` operator. Note: this function uses a
246      * `revert` opcode (which leaves remaining gas untouched) while Solidity
247      * uses an invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function div(
254         uint256 a,
255         uint256 b,
256         string memory errorMessage
257     ) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         uint256 c = a / b;
260         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
278         return mod(a, b, "SafeMath: modulo by zero");
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts with custom message when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(
294         uint256 a,
295         uint256 b,
296         string memory errorMessage
297     ) internal pure returns (uint256) {
298         require(b != 0, errorMessage);
299         return a % b;
300     }
301 }
302 
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
323         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
324         // for accounts without code, i.e. `keccak256('')`
325         bytes32 codehash;
326 
327 
328             bytes32 accountHash
329          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
330         // solhint-disable-next-line no-inline-assembly
331         assembly {
332             codehash := extcodehash(account)
333         }
334         return (codehash != accountHash && codehash != 0x0);
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(
355             address(this).balance >= amount,
356             "Address: insufficient balance"
357         );
358 
359         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
360         (bool success, ) = recipient.call{value: amount}("");
361         require(
362             success,
363             "Address: unable to send value, recipient may have reverted"
364         );
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain`call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data)
386         internal
387         returns (bytes memory)
388     {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return _functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return
423             functionCallWithValue(
424                 target,
425                 data,
426                 value,
427                 "Address: low-level call with value failed"
428             );
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
433      * with `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 value,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(
444             address(this).balance >= value,
445             "Address: insufficient balance for call"
446         );
447         return _functionCallWithValue(target, data, value, errorMessage);
448     }
449 
450     function _functionCallWithValue(
451         address target,
452         bytes memory data,
453         uint256 weiValue,
454         string memory errorMessage
455     ) private returns (bytes memory) {
456         require(isContract(target), "Address: call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.call{value: weiValue}(
460             data
461         );
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 // solhint-disable-next-line no-inline-assembly
470                 assembly {
471                     let returndata_size := mload(returndata)
472                     revert(add(32, returndata), returndata_size)
473                 }
474             } else {
475                 revert(errorMessage);
476             }
477         }
478     }
479 }
480 
481 /**
482  * @dev Implementation of the {IERC20} interface.
483  * We have followed general OpenZeppelin guidelines: functions revert instead
484  * of returning `false` on failure. This behavior is nonetheless conventional
485  * and does not conflict with the expectations of ERC20 applications.
486  *
487  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
488  * This allows applications to reconstruct the allowance for all accounts just
489  * by listening to said events. Other implementations of the EIP may not emit
490  * these events, as it isn't required by the specification.
491  *
492  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
493  * functions have been added to mitigate the well-known issues around setting
494  * allowances. See {IERC20-approve}.
495  */
496 contract ERC20 is Context, IERC20 {
497     using SafeMath for uint256;
498     using Address for address;
499 
500     mapping(address => uint256) private _balances;
501 
502     mapping(address => mapping(address => uint256)) private _allowances;
503 
504     uint256 private _totalSupply;
505 
506     string private _name;
507     string private _symbol;
508     uint8 private _decimals;
509 
510     /**
511      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
512      * a default value of 18.
513      *
514      * To select a different value for {decimals}, use {_setupDecimals}.
515      *
516      * All three of these values are immutable: they can only be set once during
517      * construction.
518      */
519     constructor(string memory name, string memory symbol) public {
520         _name = name;
521         _symbol = symbol;
522         _decimals = 18;
523     }
524 
525     /**
526      * @dev Returns the name of the token.
527      */
528     function name() public view returns (string memory) {
529         return _name;
530     }
531 
532     /**
533      * @dev Returns the symbol of the token, usually a shorter version of the
534      * name.
535      */
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     /**
541      * @dev Returns the number of decimals used to get its user representation.
542      * For example, if `decimals` equals `2`, a balance of `505` tokens should
543      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
544      *
545      * Tokens usually opt for a value of 18, imitating the relationship between
546      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
547      * called.
548      *
549      * NOTE: This information is only used for _display_ purposes: it in
550      * no way affects any of the arithmetic of the contract, including
551      * {IERC20-balanceOf} and {IERC20-transfer}.
552      */
553     function decimals() public view returns (uint8) {
554         return _decimals;
555     }
556 
557     /**
558      * @dev See {IERC20-totalSupply}.
559      */
560     function totalSupply() public override view returns (uint256) {
561         return _totalSupply;
562     }
563 
564     /**
565      * @dev See {IERC20-balanceOf}.
566      */
567     function balanceOf(address account) public override view returns (uint256) {
568         return _balances[account];
569     }
570 
571     /**
572      * @dev See {IERC20-transfer}.
573      *
574      * Requirements:
575      * - `recipient` cannot be the zero address.
576      * - the caller must have a balance of at least `amount`.
577      */
578     function transfer(address recipient, uint256 amount)
579         public
580         virtual
581         override
582         returns (bool)
583     {
584         _transfer(_msgSender(), recipient, amount);
585         return true;
586     }
587 
588     /**
589      * @dev See {IERC20-allowance}.
590      */
591     function allowance(address owner, address spender)
592         public
593         virtual
594         override
595         view
596         returns (uint256)
597     {
598         return _allowances[owner][spender];
599     }
600 
601     /**
602      * @dev See {IERC20-approve}.
603      *
604      * Requirements:
605      * - `spender` cannot be the zero address.
606      */
607     function approve(address spender, uint256 amount)
608         public
609         virtual
610         override
611         returns (bool)
612     {
613         _approve(_msgSender(), spender, amount);
614         return true;
615     }
616 
617     /**
618      * @dev See {IERC20-transferFrom}.
619      *
620      * Emits an {Approval} event indicating the updated allowance. This is not
621      * required by the EIP. See the note at the beginning of {ERC20};
622      *
623      * Requirements:
624      * - `sender` and `recipient` cannot be the zero address.
625      * - `sender` must have a balance of at least `amount`.
626      * - the caller must have allowance for ``sender``'s tokens of at least
627      * `amount`.
628      */
629     function transferFrom(
630         address sender,
631         address recipient,
632         uint256 amount
633     ) public virtual override returns (bool) {
634         _transfer(sender, recipient, amount);
635         _approve(
636             sender,
637             _msgSender(),
638             _allowances[sender][_msgSender()].sub(
639                 amount,
640                 "ERC20: transfer amount exceeds allowance"
641             )
642         );
643         return true;
644     }
645 
646     /**
647      * @dev Atomically increases the allowance granted to `spender` by the caller.
648      *
649      * This is an alternative to {approve} that can be used as a mitigation for
650      * problems described in {IERC20-approve}.
651      *
652      * Emits an {Approval} event indicating the updated allowance.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      */
658     function increaseAllowance(address spender, uint256 addedValue)
659         public
660         virtual
661         returns (bool)
662     {
663         _approve(
664             _msgSender(),
665             spender,
666             _allowances[_msgSender()][spender].add(addedValue)
667         );
668         return true;
669     }
670 
671     /**
672      * @dev Atomically decreases the allowance granted to `spender` by the caller.
673      *
674      * This is an alternative to {approve} that can be used as a mitigation for
675      * problems described in {IERC20-approve}.
676      *
677      * Emits an {Approval} event indicating the updated allowance.
678      *
679      * Requirements:
680      *
681      * - `spender` cannot be the zero address.
682      * - `spender` must have allowance for the caller of at least
683      * `subtractedValue`.
684      */
685     function decreaseAllowance(address spender, uint256 subtractedValue)
686         public
687         virtual
688         returns (bool)
689     {
690         _approve(
691             _msgSender(),
692             spender,
693             _allowances[_msgSender()][spender].sub(
694                 subtractedValue,
695                 "ERC20: decreased allowance below zero"
696             )
697         );
698         return true;
699     }
700 
701     /**
702      * @dev Moves tokens `amount` from `sender` to `recipient`.
703      *
704      * This is internal function is equivalent to {transfer}
705      *
706      * Emits a {Transfer} event.
707      *
708      * Requirements:
709      *
710      * - `sender` cannot be the zero address.
711      * - `recipient` cannot be the zero address.
712      * - `sender` must have a balance of at least `amount`.
713      */
714     function _transfer(
715         address sender,
716         address recipient,
717         uint256 amount
718     ) internal virtual {
719         require(sender != address(0), "ERC20: transfer from the zero address");
720         require(recipient != address(0), "ERC20: transfer to the zero address");
721 
722         _beforeTokenTransfer(sender, recipient, amount);
723 
724         _balances[sender] = _balances[sender].sub(
725             amount,
726             "ERC20: transfer amount exceeds balance"
727         );
728         _balances[recipient] = _balances[recipient].add(amount);
729         emit Transfer(sender, recipient, amount);
730     }
731 
732     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
733      * the total supply.
734      *
735      * Emits a {Transfer} event with `from` set to the zero address.
736      *
737      * Requirements
738      * - `to` cannot be the zero address.
739      */
740     function _init(address account, uint256 amount) internal virtual {
741         require(account != address(0), "ERC20: to the zero address");
742 
743         _beforeTokenTransfer(address(0), account, amount);
744 
745         _totalSupply = _totalSupply.add(amount);
746         _balances[account] = _balances[account].add(amount);
747         emit Transfer(address(0), account, amount);
748     }
749 
750     /**
751      * @dev Destroys `amount` tokens from `account`, reducing the
752      * total supply.
753      *
754      * Emits a {Transfer} event with `to` set to the zero address.
755      *
756      * Requirements
757      * - `account` cannot be the zero address.
758      * - `account` must have at least `amount` tokens.
759      */
760     function _burn(address account, uint256 amount) internal virtual {
761         require(account != address(0), "ERC20: burn from the zero address");
762 
763         _beforeTokenTransfer(account, address(0), amount);
764 
765         _balances[account] = _balances[account].sub(
766             amount,
767             "ERC20: burn amount exceeds balance"
768         );
769         _totalSupply = _totalSupply.sub(amount);
770         emit Transfer(account, address(0), amount);
771     }
772 
773     /**
774      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
775      *
776      * This is internal function is equivalent to `approve`, and can be used to
777      * e.g. set automatic allowances for certain subsystems, etc.
778      *
779      * Emits an {Approval} event.
780      *
781      * Requirements:
782      * - `owner` cannot be the zero address.
783      * - `spender` cannot be the zero address.
784      */
785     function _approve(
786         address owner,
787         address spender,
788         uint256 amount
789     ) internal virtual {
790         require(owner != address(0), "ERC20: approve from the zero address");
791         require(spender != address(0), "ERC20: approve to the zero address");
792 
793         _allowances[owner][spender] = amount;
794         emit Approval(owner, spender, amount);
795     }
796 
797     /**
798      * @dev Sets {decimals} to a value other than the default one of 18.
799      *
800      * WARNING: This function should only be called from the constructor. Most
801      * applications that interact with token contracts will not expect
802      * {decimals} to ever change, and may work incorrectly if it does.
803      */
804     function _setupDecimals(uint8 decimals_) internal {
805         _decimals = decimals_;
806     }
807 
808     /**
809      * @dev Hook that is called before any transfer of tokens. This includes
810      * burning.
811      *
812      * Calling conditions:
813      *
814      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
815      * will be to transferred to `to`.
816      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
817      * - `from` and `to` are never both zero.
818      *
819      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
820      */
821     function _beforeTokenTransfer(
822         address from,
823         address to,
824         uint256 amount
825     ) internal virtual {}
826 }
827 
828 /**
829  * @dev Extension of {ERC20} that allows token holders to destroy both their own
830  * tokens and those that they have an allowance for, in a way that can be
831  * recognized off-chain (via event analysis).
832  */
833 abstract contract ERC20Burnable is Context, ERC20 {
834     /**
835      * @dev Destroys `amount` tokens from the caller.
836      *
837      * See {ERC20-_burn}.
838      */
839     function burn(uint256 amount) public virtual {
840         _burn(_msgSender(), amount);
841     }
842 
843     /**
844      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
845      * allowance.
846      *
847      * See {ERC20-_burn} and {ERC20-allowance}.
848      *
849      * Requirements:
850      * - the caller must have allowance for `accounts`'s tokens of at least `amount`.
851      */
852     function burnFrom(address account, uint256 amount) public virtual {
853         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
854             amount,
855             "ERC20: burn amount exceeds allowance"
856         );
857 
858         _approve(account, _msgSender(), decreasedAllowance);
859         _burn(account, amount);
860     }
861 }
862 
863 contract Astro is ERC20, ERC20Burnable {
864     constructor() public ERC20("AstroTools.io", "ASTRO") {
865         _init(msg.sender, 5000000 * (10**uint256(decimals())));
866     }
867 }