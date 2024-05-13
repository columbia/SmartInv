1 pragma solidity ^0.6.6;
2 
3 abstract contract Context {
4     function _msgSender() internal virtual view returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal virtual view returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount)
33         external
34         returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender)
44         external
45         view
46         returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(
92         address indexed owner,
93         address indexed spender,
94         uint256 value
95     );
96 }
97 
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(
141         uint256 a,
142         uint256 b,
143         string memory errorMessage
144     ) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(
204         uint256 a,
205         uint256 b,
206         string memory errorMessage
207     ) internal pure returns (uint256) {
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return mod(a, b, "SafeMath: modulo by zero");
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts with custom message when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         require(b != 0, errorMessage);
249         return a % b;
250     }
251 }
252 
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies in extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         // solhint-disable-next-line no-inline-assembly
278         assembly {
279             size := extcodesize(account)
280         }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(
302             address(this).balance >= amount,
303             "Address: insufficient balance"
304         );
305 
306         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
307         (bool success, ) = recipient.call{value: amount}("");
308         require(
309             success,
310             "Address: unable to send value, recipient may have reverted"
311         );
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain`call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data)
333         internal
334         returns (bytes memory)
335     {
336         return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(
346         address target,
347         bytes memory data,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         return _functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(
365         address target,
366         bytes memory data,
367         uint256 value
368     ) internal returns (bytes memory) {
369         return
370             functionCallWithValue(
371                 target,
372                 data,
373                 value,
374                 "Address: low-level call with value failed"
375             );
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(
391             address(this).balance >= value,
392             "Address: insufficient balance for call"
393         );
394         return _functionCallWithValue(target, data, value, errorMessage);
395     }
396 
397     function _functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 weiValue,
401         string memory errorMessage
402     ) private returns (bytes memory) {
403         require(isContract(target), "Address: call to non-contract");
404 
405         // solhint-disable-next-line avoid-low-level-calls
406         (bool success, bytes memory returndata) = target.call{value: weiValue}(
407             data
408         );
409         if (success) {
410             return returndata;
411         } else {
412             // Look for revert reason and bubble it up if present
413             if (returndata.length > 0) {
414                 // The easiest way to bubble the revert reason is using memory via assembly
415 
416                 // solhint-disable-next-line no-inline-assembly
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 /**
429  * @dev Contract module which provides a basic access control mechanism, where
430  * there is an account (an owner) that can be granted exclusive access to
431  * specific functions.
432  *
433  * By default, the owner account will be the one that deploys the contract. This
434  * can later be changed with {transferOwnership}.
435  *
436  * This module is used through inheritance. It will make available the modifier
437  * `onlyOwner`, which can be applied to your functions to restrict their use to
438  * the owner.
439  */
440 contract Ownable is Context {
441     address private _owner;
442 
443     event OwnershipTransferred(
444         address indexed previousOwner,
445         address indexed newOwner
446     );
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor() internal {
452         address msgSender = _msgSender();
453         _owner = msgSender;
454         emit OwnershipTransferred(address(0), msgSender);
455     }
456 
457     /**
458      * @dev Returns the address of the current owner.
459      */
460     function owner() public view returns (address) {
461         return _owner;
462     }
463 
464     /**
465      * @dev Throws if called by any account other than the owner.
466      */
467     modifier onlyOwner() {
468         require(_owner == _msgSender(), "Ownable: caller is not the owner");
469         _;
470     }
471 
472     /**
473      * @dev Leaves the contract without owner. It will not be possible to call
474      * `onlyOwner` functions anymore. Can only be called by the current owner.
475      *
476      * NOTE: Renouncing ownership will leave the contract without an owner,
477      * thereby removing any functionality that is only available to the owner.
478      */
479     function renounceOwnership() public virtual onlyOwner {
480         emit OwnershipTransferred(_owner, address(0));
481         _owner = address(0);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Can only be called by the current owner.
487      */
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(
490             newOwner != address(0),
491             "Ownable: new owner is the zero address"
492         );
493         emit OwnershipTransferred(_owner, newOwner);
494         _owner = newOwner;
495     }
496 }
497 
498 /**
499  * @dev Implementation of the {IERC20} interface.
500  *
501  * This implementation is agnostic to the way tokens are created. This means
502  * that a supply mechanism has to be added in a derived contract using {_mint}.
503  * For a generic mechanism see {ERC20PresetMinterPauser}.
504  *
505  * TIP: For a detailed writeup see our guide
506  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
507  * to implement supply mechanisms].
508  *
509  * We have followed general OpenZeppelin guidelines: functions revert instead
510  * of returning `false` on failure. This behavior is nonetheless conventional
511  * and does not conflict with the expectations of ERC20 applications.
512  *
513  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
514  * This allows applications to reconstruct the allowance for all accounts just
515  * by listening to said events. Other implementations of the EIP may not emit
516  * these events, as it isn't required by the specification.
517  *
518  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
519  * functions have been added to mitigate the well-known issues around setting
520  * allowances. See {IERC20-approve}.
521  */
522 contract ERC20 is Context, IERC20 {
523     using SafeMath for uint256;
524     using Address for address;
525 
526     mapping(address => uint256) private _balances;
527 
528     mapping(address => mapping(address => uint256)) private _allowances;
529 
530     uint256 private _totalSupply;
531 
532     string private _name;
533     string private _symbol;
534     uint8 private _decimals;
535 
536     /**
537      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
538      * a default value of 18.
539      *
540      * To select a different value for {decimals}, use {_setupDecimals}.
541      *
542      * All three of these values are immutable: they can only be set once during
543      * construction.
544      */
545     constructor(string memory name, string memory symbol) public {
546         _name = name;
547         _symbol = symbol;
548         _decimals = 18;
549     }
550 
551     /**
552      * @dev Returns the name of the token.
553      */
554     function name() public view returns (string memory) {
555         return _name;
556     }
557 
558     /**
559      * @dev Returns the symbol of the token, usually a shorter version of the
560      * name.
561      */
562     function symbol() public view returns (string memory) {
563         return _symbol;
564     }
565 
566     /**
567      * @dev Returns the number of decimals used to get its user representation.
568      * For example, if `decimals` equals `2`, a balance of `505` tokens should
569      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
570      *
571      * Tokens usually opt for a value of 18, imitating the relationship between
572      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
573      * called.
574      *
575      * NOTE: This information is only used for _display_ purposes: it in
576      * no way affects any of the arithmetic of the contract, including
577      * {IERC20-balanceOf} and {IERC20-transfer}.
578      */
579     function decimals() public view returns (uint8) {
580         return _decimals;
581     }
582 
583     /**
584      * @dev See {IERC20-totalSupply}.
585      */
586     function totalSupply() public override view returns (uint256) {
587         return _totalSupply;
588     }
589 
590     /**
591      * @dev See {IERC20-balanceOf}.
592      */
593     function balanceOf(address account) public override view returns (uint256) {
594         return _balances[account];
595     }
596 
597     /**
598      * @dev See {IERC20-transfer}.
599      *
600      * Requirements:
601      *
602      * - `recipient` cannot be the zero address.
603      * - the caller must have a balance of at least `amount`.
604      */
605     function transfer(address recipient, uint256 amount)
606         public
607         virtual
608         override
609         returns (bool)
610     {
611         _transfer(_msgSender(), recipient, amount);
612         return true;
613     }
614 
615     /**
616      * @dev See {IERC20-allowance}.
617      */
618     function allowance(address owner, address spender)
619         public
620         virtual
621         override
622         view
623         returns (uint256)
624     {
625         return _allowances[owner][spender];
626     }
627 
628     /**
629      * @dev See {IERC20-approve}.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      */
635     function approve(address spender, uint256 amount)
636         public
637         virtual
638         override
639         returns (bool)
640     {
641         _approve(_msgSender(), spender, amount);
642         return true;
643     }
644 
645     /**
646      * @dev See {IERC20-transferFrom}.
647      *
648      * Emits an {Approval} event indicating the updated allowance. This is not
649      * required by the EIP. See the note at the beginning of {ERC20};
650      *
651      * Requirements:
652      * - `sender` and `recipient` cannot be the zero address.
653      * - `sender` must have a balance of at least `amount`.
654      * - the caller must have allowance for ``sender``'s tokens of at least
655      * `amount`.
656      */
657     function transferFrom(
658         address sender,
659         address recipient,
660         uint256 amount
661     ) public virtual override returns (bool) {
662         _transfer(sender, recipient, amount);
663         _approve(
664             sender,
665             _msgSender(),
666             _allowances[sender][_msgSender()].sub(
667                 amount,
668                 "ERC20: transfer amount exceeds allowance"
669             )
670         );
671         return true;
672     }
673 
674     /**
675      * @dev Atomically increases the allowance granted to `spender` by the caller.
676      *
677      * This is an alternative to {approve} that can be used as a mitigation for
678      * problems described in {IERC20-approve}.
679      *
680      * Emits an {Approval} event indicating the updated allowance.
681      *
682      * Requirements:
683      *
684      * - `spender` cannot be the zero address.
685      */
686     function increaseAllowance(address spender, uint256 addedValue)
687         public
688         virtual
689         returns (bool)
690     {
691         _approve(
692             _msgSender(),
693             spender,
694             _allowances[_msgSender()][spender].add(addedValue)
695         );
696         return true;
697     }
698 
699     /**
700      * @dev Atomically decreases the allowance granted to `spender` by the caller.
701      *
702      * This is an alternative to {approve} that can be used as a mitigation for
703      * problems described in {IERC20-approve}.
704      *
705      * Emits an {Approval} event indicating the updated allowance.
706      *
707      * Requirements:
708      *
709      * - `spender` cannot be the zero address.
710      * - `spender` must have allowance for the caller of at least
711      * `subtractedValue`.
712      */
713     function decreaseAllowance(address spender, uint256 subtractedValue)
714         public
715         virtual
716         returns (bool)
717     {
718         _approve(
719             _msgSender(),
720             spender,
721             _allowances[_msgSender()][spender].sub(
722                 subtractedValue,
723                 "ERC20: decreased allowance below zero"
724             )
725         );
726         return true;
727     }
728 
729     /**
730      * @dev Moves tokens `amount` from `sender` to `recipient`.
731      *
732      * This is internal function is equivalent to {transfer}, and can be used to
733      * e.g. implement automatic token fees, slashing mechanisms, etc.
734      *
735      * Emits a {Transfer} event.
736      *
737      * Requirements:
738      *
739      * - `sender` cannot be the zero address.
740      * - `recipient` cannot be the zero address.
741      * - `sender` must have a balance of at least `amount`.
742      */
743     function _transfer(
744         address sender,
745         address recipient,
746         uint256 amount
747     ) internal virtual {
748         require(sender != address(0), "ERC20: transfer from the zero address");
749         require(recipient != address(0), "ERC20: transfer to the zero address");
750 
751         _beforeTokenTransfer(sender, recipient, amount);
752 
753         _balances[sender] = _balances[sender].sub(
754             amount,
755             "ERC20: transfer amount exceeds balance"
756         );
757         _balances[recipient] = _balances[recipient].add(amount);
758         emit Transfer(sender, recipient, amount);
759     }
760 
761     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
762      * the total supply.
763      *
764      * Emits a {Transfer} event with `from` set to the zero address.
765      *
766      * Requirements
767      *
768      * - `to` cannot be the zero address.
769      */
770     function _mint(address account, uint256 amount) internal virtual {
771         require(account != address(0), "ERC20: mint to the zero address");
772 
773         _beforeTokenTransfer(address(0), account, amount);
774 
775         _totalSupply = _totalSupply.add(amount);
776         _balances[account] = _balances[account].add(amount);
777         emit Transfer(address(0), account, amount);
778     }
779 
780     /**
781      * @dev Destroys `amount` tokens from `account`, reducing the
782      * total supply.
783      *
784      * Emits a {Transfer} event with `to` set to the zero address.
785      *
786      * Requirements
787      *
788      * - `account` cannot be the zero address.
789      * - `account` must have at least `amount` tokens.
790      */
791     function _burn(address account, uint256 amount) internal virtual {
792         require(account != address(0), "ERC20: burn from the zero address");
793 
794         _beforeTokenTransfer(account, address(0), amount);
795 
796         _balances[account] = _balances[account].sub(
797             amount,
798             "ERC20: burn amount exceeds balance"
799         );
800         _totalSupply = _totalSupply.sub(amount);
801         emit Transfer(account, address(0), amount);
802     }
803 
804     /**
805      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
806      *
807      * This internal function is equivalent to `approve`, and can be used to
808      * e.g. set automatic allowances for certain subsystems, etc.
809      *
810      * Emits an {Approval} event.
811      *
812      * Requirements:
813      *
814      * - `owner` cannot be the zero address.
815      * - `spender` cannot be the zero address.
816      */
817     function _approve(
818         address owner,
819         address spender,
820         uint256 amount
821     ) internal virtual {
822         require(owner != address(0), "ERC20: approve from the zero address");
823         require(spender != address(0), "ERC20: approve to the zero address");
824 
825         _allowances[owner][spender] = amount;
826         emit Approval(owner, spender, amount);
827     }
828 
829     /**
830      * @dev Sets {decimals} to a value other than the default one of 18.
831      *
832      * WARNING: This function should only be called from the constructor. Most
833      * applications that interact with token contracts will not expect
834      * {decimals} to ever change, and may work incorrectly if it does.
835      */
836     function _setupDecimals(uint8 decimals_) internal {
837         _decimals = decimals_;
838     }
839 
840     /**
841      * @dev Hook that is called before any transfer of tokens. This includes
842      * minting and burning.
843      *
844      * Calling conditions:
845      *
846      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
847      * will be to transferred to `to`.
848      * - when `from` is zero, `amount` tokens will be minted for `to`.
849      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
850      * - `from` and `to` are never both zero.
851      *
852      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
853      */
854     function _beforeTokenTransfer(
855         address from,
856         address to,
857         uint256 amount
858     ) internal virtual {}
859 }
860 
861 contract NoodleToken is ERC20("NOODLE.Finance", "NOODLE"), Ownable {
862     function mint(address _to, uint256 _amount) public onlyOwner {
863         _mint(_to, _amount);
864     }
865 }