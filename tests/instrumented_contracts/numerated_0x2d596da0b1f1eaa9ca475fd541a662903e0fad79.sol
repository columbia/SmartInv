1 pragma solidity ^0.6.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // SPDX-License-Identifier: MIT
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 // SPDX-License-Identifier: MIT
92 /**
93  * @dev Interface of the ERC20 standard as defined in the EIP.
94  */
95 interface IERC20 {
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `recipient`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transfer(address recipient, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
118      * zero by default.
119      *
120      * This value changes when {approve} or {transferFrom} are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `sender` to `recipient` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to {approve}. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // SPDX-License-Identifier: MIT
167 /**
168  * @dev Wrappers over Solidity's arithmetic operations with added overflow
169  * checks.
170  *
171  * Arithmetic operations in Solidity wrap on overflow. This can easily result
172  * in bugs, because programmers usually assume that an overflow raises an
173  * error, which is the standard behavior in high level programming languages.
174  * `SafeMath` restores this intuition by reverting the transaction when an
175  * operation overflows.
176  *
177  * Using this library instead of the unchecked operations eliminates an entire
178  * class of bugs, so it's recommended to use it always.
179  */
180 library SafeMath {
181     /**
182      * @dev Returns the addition of two unsigned integers, with an overflow flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         uint256 c = a + b;
188         if (c < a) return (false, 0);
189         return (true, c);
190     }
191 
192     /**
193      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
194      *
195      * _Available since v3.4._
196      */
197     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         if (b > a) return (false, 0);
199         return (true, a - b);
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
204      *
205      * _Available since v3.4._
206      */
207     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
209         // benefit is lost if 'b' is also tested.
210         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
211         if (a == 0) return (true, 0);
212         uint256 c = a * b;
213         if (c / a != b) return (false, 0);
214         return (true, c);
215     }
216 
217     /**
218      * @dev Returns the division of two unsigned integers, with a division by zero flag.
219      *
220      * _Available since v3.4._
221      */
222     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
223         if (b == 0) return (false, 0);
224         return (true, a / b);
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
229      *
230      * _Available since v3.4._
231      */
232     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
233         if (b == 0) return (false, 0);
234         return (true, a % b);
235     }
236 
237     /**
238      * @dev Returns the addition of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `+` operator.
242      *
243      * Requirements:
244      *
245      * - Addition cannot overflow.
246      */
247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a + b;
249         require(c >= a, "SafeMath: addition overflow");
250         return c;
251     }
252 
253     /**
254      * @dev Returns the subtraction of two unsigned integers, reverting on
255      * overflow (when the result is negative).
256      *
257      * Counterpart to Solidity's `-` operator.
258      *
259      * Requirements:
260      *
261      * - Subtraction cannot overflow.
262      */
263     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
264         require(b <= a, "SafeMath: subtraction overflow");
265         return a - b;
266     }
267 
268     /**
269      * @dev Returns the multiplication of two unsigned integers, reverting on
270      * overflow.
271      *
272      * Counterpart to Solidity's `*` operator.
273      *
274      * Requirements:
275      *
276      * - Multiplication cannot overflow.
277      */
278     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
279         if (a == 0) return 0;
280         uint256 c = a * b;
281         require(c / a == b, "SafeMath: multiplication overflow");
282         return c;
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers, reverting on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         require(b > 0, "SafeMath: division by zero");
299         return a / b;
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * reverting when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
315         require(b > 0, "SafeMath: modulo by zero");
316         return a % b;
317     }
318 
319     /**
320      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
321      * overflow (when the result is negative).
322      *
323      * CAUTION: This function is deprecated because it requires allocating memory for the error
324      * message unnecessarily. For custom revert reasons use {trySub}.
325      *
326      * Counterpart to Solidity's `-` operator.
327      *
328      * Requirements:
329      *
330      * - Subtraction cannot overflow.
331      */
332     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b <= a, errorMessage);
334         return a - b;
335     }
336 
337     /**
338      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
339      * division by zero. The result is rounded towards zero.
340      *
341      * CAUTION: This function is deprecated because it requires allocating memory for the error
342      * message unnecessarily. For custom revert reasons use {tryDiv}.
343      *
344      * Counterpart to Solidity's `/` operator. Note: this function uses a
345      * `revert` opcode (which leaves remaining gas untouched) while Solidity
346      * uses an invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
353         require(b > 0, errorMessage);
354         return a / b;
355     }
356 
357     /**
358      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
359      * reverting with custom message when dividing by zero.
360      *
361      * CAUTION: This function is deprecated because it requires allocating memory for the error
362      * message unnecessarily. For custom revert reasons use {tryMod}.
363      *
364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
365      * opcode (which leaves remaining gas untouched) while Solidity uses an
366      * invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      *
370      * - The divisor cannot be zero.
371      */
372     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
373         require(b > 0, errorMessage);
374         return a % b;
375     }
376 }
377 
378 // SPDX-License-Identifier: MIT
379 /**
380  * @dev Implementation of the {IERC20} interface.
381  *
382  * This implementation is agnostic to the way tokens are created. This means
383  * that a supply mechanism has to be added in a derived contract using {_mint}.
384  * For a generic mechanism see {ERC20PresetMinterPauser}.
385  *
386  * TIP: For a detailed writeup see our guide
387  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
388  * to implement supply mechanisms].
389  *
390  * We have followed general OpenZeppelin guidelines: functions revert instead
391  * of returning `false` on failure. This behavior is nonetheless conventional
392  * and does not conflict with the expectations of ERC20 applications.
393  *
394  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
395  * This allows applications to reconstruct the allowance for all accounts just
396  * by listening to said events. Other implementations of the EIP may not emit
397  * these events, as it isn't required by the specification.
398  *
399  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
400  * functions have been added to mitigate the well-known issues around setting
401  * allowances. See {IERC20-approve}.
402  */
403 contract ERC20 is Context, IERC20 {
404     using SafeMath for uint256;
405 
406     mapping (address => uint256) private _balances;
407 
408     mapping (address => mapping (address => uint256)) private _allowances;
409 
410     uint256 private _totalSupply;
411 
412     string private _name;
413     string private _symbol;
414     uint8 private _decimals;
415 
416     /**
417      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
418      * a default value of 18.
419      *
420      * To select a different value for {decimals}, use {_setupDecimals}.
421      *
422      * All three of these values are immutable: they can only be set once during
423      * construction.
424      */
425     constructor (string memory name_, string memory symbol_) public {
426         _name = name_;
427         _symbol = symbol_;
428         _decimals = 18;
429     }
430 
431     /**
432      * @dev Returns the name of the token.
433      */
434     function name() public view virtual returns (string memory) {
435         return _name;
436     }
437 
438     /**
439      * @dev Returns the symbol of the token, usually a shorter version of the
440      * name.
441      */
442     function symbol() public view virtual returns (string memory) {
443         return _symbol;
444     }
445 
446     /**
447      * @dev Returns the number of decimals used to get its user representation.
448      * For example, if `decimals` equals `2`, a balance of `505` tokens should
449      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
450      *
451      * Tokens usually opt for a value of 18, imitating the relationship between
452      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
453      * called.
454      *
455      * NOTE: This information is only used for _display_ purposes: it in
456      * no way affects any of the arithmetic of the contract, including
457      * {IERC20-balanceOf} and {IERC20-transfer}.
458      */
459     function decimals() public view virtual returns (uint8) {
460         return _decimals;
461     }
462 
463     /**
464      * @dev See {IERC20-totalSupply}.
465      */
466     function totalSupply() public view virtual override returns (uint256) {
467         return _totalSupply;
468     }
469 
470     /**
471      * @dev See {IERC20-balanceOf}.
472      */
473     function balanceOf(address account) public view virtual override returns (uint256) {
474         return _balances[account];
475     }
476 
477     /**
478      * @dev See {IERC20-transfer}.
479      *
480      * Requirements:
481      *
482      * - `recipient` cannot be the zero address.
483      * - the caller must have a balance of at least `amount`.
484      */
485     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
486         _transfer(_msgSender(), recipient, amount);
487         return true;
488     }
489 
490     /**
491      * @dev See {IERC20-allowance}.
492      */
493     function allowance(address owner, address spender) public view virtual override returns (uint256) {
494         return _allowances[owner][spender];
495     }
496 
497     /**
498      * @dev See {IERC20-approve}.
499      *
500      * Requirements:
501      *
502      * - `spender` cannot be the zero address.
503      */
504     function approve(address spender, uint256 amount) public virtual override returns (bool) {
505         _approve(_msgSender(), spender, amount);
506         return true;
507     }
508 
509     /**
510      * @dev See {IERC20-transferFrom}.
511      *
512      * Emits an {Approval} event indicating the updated allowance. This is not
513      * required by the EIP. See the note at the beginning of {ERC20}.
514      *
515      * Requirements:
516      *
517      * - `sender` and `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      * - the caller must have allowance for ``sender``'s tokens of at least
520      * `amount`.
521      */
522     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
523         _transfer(sender, recipient, amount);
524         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
525         return true;
526     }
527 
528     /**
529      * @dev Atomically increases the allowance granted to `spender` by the caller.
530      *
531      * This is an alternative to {approve} that can be used as a mitigation for
532      * problems described in {IERC20-approve}.
533      *
534      * Emits an {Approval} event indicating the updated allowance.
535      *
536      * Requirements:
537      *
538      * - `spender` cannot be the zero address.
539      */
540     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
541         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
542         return true;
543     }
544 
545     /**
546      * @dev Atomically decreases the allowance granted to `spender` by the caller.
547      *
548      * This is an alternative to {approve} that can be used as a mitigation for
549      * problems described in {IERC20-approve}.
550      *
551      * Emits an {Approval} event indicating the updated allowance.
552      *
553      * Requirements:
554      *
555      * - `spender` cannot be the zero address.
556      * - `spender` must have allowance for the caller of at least
557      * `subtractedValue`.
558      */
559     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
561         return true;
562     }
563 
564     /**
565      * @dev Moves tokens `amount` from `sender` to `recipient`.
566      *
567      * This is internal function is equivalent to {transfer}, and can be used to
568      * e.g. implement automatic token fees, slashing mechanisms, etc.
569      *
570      * Emits a {Transfer} event.
571      *
572      * Requirements:
573      *
574      * - `sender` cannot be the zero address.
575      * - `recipient` cannot be the zero address.
576      * - `sender` must have a balance of at least `amount`.
577      */
578     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
579         require(sender != address(0), "ERC20: transfer from the zero address");
580         require(recipient != address(0), "ERC20: transfer to the zero address");
581 
582         _beforeTokenTransfer(sender, recipient, amount);
583 
584         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
585         _balances[recipient] = _balances[recipient].add(amount);
586         emit Transfer(sender, recipient, amount);
587     }
588 
589     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
590      * the total supply.
591      *
592      * Emits a {Transfer} event with `from` set to the zero address.
593      *
594      * Requirements:
595      *
596      * - `to` cannot be the zero address.
597      */
598     function _mint(address account, uint256 amount) internal virtual {
599         require(account != address(0), "ERC20: mint to the zero address");
600 
601         _beforeTokenTransfer(address(0), account, amount);
602 
603         _totalSupply = _totalSupply.add(amount);
604         _balances[account] = _balances[account].add(amount);
605         emit Transfer(address(0), account, amount);
606     }
607 
608     /**
609      * @dev Destroys `amount` tokens from `account`, reducing the
610      * total supply.
611      *
612      * Emits a {Transfer} event with `to` set to the zero address.
613      *
614      * Requirements:
615      *
616      * - `account` cannot be the zero address.
617      * - `account` must have at least `amount` tokens.
618      */
619     function _burn(address account, uint256 amount) internal virtual {
620         require(account != address(0), "ERC20: burn from the zero address");
621 
622         _beforeTokenTransfer(account, address(0), amount);
623 
624         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
625         _totalSupply = _totalSupply.sub(amount);
626         emit Transfer(account, address(0), amount);
627     }
628 
629     /**
630      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
631      *
632      * This internal function is equivalent to `approve`, and can be used to
633      * e.g. set automatic allowances for certain subsystems, etc.
634      *
635      * Emits an {Approval} event.
636      *
637      * Requirements:
638      *
639      * - `owner` cannot be the zero address.
640      * - `spender` cannot be the zero address.
641      */
642     function _approve(address owner, address spender, uint256 amount) internal virtual {
643         require(owner != address(0), "ERC20: approve from the zero address");
644         require(spender != address(0), "ERC20: approve to the zero address");
645 
646         _allowances[owner][spender] = amount;
647         emit Approval(owner, spender, amount);
648     }
649 
650     /**
651      * @dev Sets {decimals} to a value other than the default one of 18.
652      *
653      * WARNING: This function should only be called from the constructor. Most
654      * applications that interact with token contracts will not expect
655      * {decimals} to ever change, and may work incorrectly if it does.
656      */
657     function _setupDecimals(uint8 decimals_) internal virtual {
658         _decimals = decimals_;
659     }
660 
661     /**
662      * @dev Hook that is called before any transfer of tokens. This includes
663      * minting and burning.
664      *
665      * Calling conditions:
666      *
667      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
668      * will be to transferred to `to`.
669      * - when `from` is zero, `amount` tokens will be minted for `to`.
670      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
671      * - `from` and `to` are never both zero.
672      *
673      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
674      */
675     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
676 }
677 
678 contract TokenPoolClaimable is Ownable {
679     uint256 public rewardAmount = 63163213744300000; //0.0631632137443153
680     address public token;
681     bytes32 public immutable merkleRoot;
682     mapping(address => bool) claimed;
683 
684     /**
685   @notice the constructor function is fired only once during contract deployment
686   @param _merkleRoot The merkle proof root
687   **/
688     constructor(bytes32 _merkleRoot, address _token) public {
689         merkleRoot = _merkleRoot;
690         token = _token;
691     }
692 
693 
694     function verifyForUser(bytes32[] memory proof, address user) public view returns (bool) {
695         bytes32 node = keccak256(abi.encodePacked(user));
696         bytes32 computedHash = node;
697 
698         for (uint256 i = 0; i < proof.length; i++) {
699             bytes32 proofElement = proof[i];
700 
701             if (computedHash < proofElement) {
702                 // Hash(current computed hash + current element of the proof)
703                 computedHash = keccak256(
704                     abi.encodePacked(computedHash, proofElement)
705                 );
706             } else {
707                 // Hash(current element of the proof + current computed hash)
708                 computedHash = keccak256(
709                     abi.encodePacked(proofElement, computedHash)
710                 );
711             }
712         }
713 
714         // Check if the computed hash (root) is equal to the provided root
715         return computedHash == merkleRoot;
716     }
717 
718     function verify(bytes32[] memory proof) public view returns (bool) {
719         bytes32 node = keccak256(abi.encodePacked(msg.sender));
720         bytes32 computedHash = node;
721 
722         for (uint256 i = 0; i < proof.length; i++) {
723             bytes32 proofElement = proof[i];
724 
725             if (computedHash < proofElement) {
726                 // Hash(current computed hash + current element of the proof)
727                 computedHash = keccak256(
728                     abi.encodePacked(computedHash, proofElement)
729                 );
730             } else {
731                 // Hash(current element of the proof + current computed hash)
732                 computedHash = keccak256(
733                     abi.encodePacked(proofElement, computedHash)
734                 );
735             }
736         }
737 
738         // Check if the computed hash (root) is equal to the provided root
739         return computedHash == merkleRoot;
740     }
741 
742     function isClaimed(address user) public view returns (bool) {
743         return claimed[user];
744     }
745 
746     function _setClaimed(address user) private {
747         claimed[user] = true;
748     }
749 
750     function rescueRewards() external onlyOwner {
751         IERC20(token).transfer(
752             msg.sender,
753             IERC20(token).balanceOf(address(this))
754         );
755     }
756 
757     function claimRewards(bytes32[] calldata merkleProof) external {
758         require(
759             IERC20(token).balanceOf(address(this)) > uint256(0),
760             "TokenPoolClaimable: No rewards available"
761         );
762         require(
763             !isClaimed(msg.sender),
764             "TokenPoolClaimable: Drop already claimed."
765         );
766 
767         require(verify(merkleProof), "TokenPoolClaimable: Invalid proof.");
768 
769         require(
770             IERC20(token).transfer(msg.sender, rewardAmount),
771             "TokenPoolClaimable: claim rewards failed"
772         );
773 
774         _setClaimed(msg.sender);
775     }
776 }