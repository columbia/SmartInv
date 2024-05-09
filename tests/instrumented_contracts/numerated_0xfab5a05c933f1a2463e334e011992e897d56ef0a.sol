1 pragma solidity ^0.6.0;
2 
3 
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7 
8     function balanceOf(address account) external view returns (uint256);
9 
10     function transfer(address recipient, uint256 amount) external returns (bool);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function approve(address spender, uint256 amount) external returns (bool);
15 
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 contract Context {
24     // Empty internal constructor, to prevent people from mistakenly deploying
25     // an instance of this contract, which should be used via inheritance.
26     constructor () internal { }
27 
28     function _msgSender() internal view virtual returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 
39 library EnumerableSet {
40 
41     struct Set {
42         // Storage of set values
43         bytes32[] _values;
44 
45         // Position of the value in the `values` array, plus 1 because index 0
46         // means a value is not in the set.
47         mapping (bytes32 => uint256) _indexes;
48     }
49 
50     function _add(Set storage set, bytes32 value) private returns (bool) {
51         if (!_contains(set, value)) {
52             set._values.push(value);
53             // The value is stored at length-1, but we add 1 to all indexes
54             // and use 0 as a sentinel value
55             set._indexes[value] = set._values.length;
56             return true;
57         } else {
58             return false;
59         }
60     }
61 
62     function _remove(Set storage set, bytes32 value) private returns (bool) {
63         // We read and store the value's index to prevent multiple reads from the same storage slot
64         uint256 valueIndex = set._indexes[value];
65 
66         if (valueIndex != 0) { // Equivalent to contains(set, value)
67             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
68             // the array, and then remove the last element (sometimes called as 'swap and pop').
69             // This modifies the order of the array, as noted in {at}.
70 
71             uint256 toDeleteIndex = valueIndex - 1;
72             uint256 lastIndex = set._values.length - 1;
73 
74             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
75             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
76 
77             bytes32 lastvalue = set._values[lastIndex];
78 
79             // Move the last value to the index where the value to delete is
80             set._values[toDeleteIndex] = lastvalue;
81             // Update the index for the moved value
82             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
83 
84             // Delete the slot where the moved value was stored
85             set._values.pop();
86 
87             // Delete the index for the deleted slot
88             delete set._indexes[value];
89 
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     function _contains(Set storage set, bytes32 value) private view returns (bool) {
97         return set._indexes[value] != 0;
98     }
99 
100 
101     function _length(Set storage set) private view returns (uint256) {
102         return set._values.length;
103     }
104 
105     function _at(Set storage set, uint256 index) private view returns (bytes32) {
106         require(set._values.length > index, "EnumerableSet: index out of bounds");
107         return set._values[index];
108     }
109 
110 
111     struct AddressSet {
112         Set _inner;
113     }
114 
115     function add(AddressSet storage set, address value) internal returns (bool) {
116         return _add(set._inner, bytes32(uint256(value)));
117     }
118 
119     function remove(AddressSet storage set, address value) internal returns (bool) {
120         return _remove(set._inner, bytes32(uint256(value)));
121     }
122 
123     function contains(AddressSet storage set, address value) internal view returns (bool) {
124         return _contains(set._inner, bytes32(uint256(value)));
125     }
126 
127     function length(AddressSet storage set) internal view returns (uint256) {
128         return _length(set._inner);
129     }
130 
131     function at(AddressSet storage set, uint256 index) internal view returns (address) {
132         return address(uint256(_at(set._inner, index)));
133     }
134 
135 
136 
137     struct UintSet {
138         Set _inner;
139     }
140 
141     function add(UintSet storage set, uint256 value) internal returns (bool) {
142         return _add(set._inner, bytes32(value));
143     }
144 
145     function remove(UintSet storage set, uint256 value) internal returns (bool) {
146         return _remove(set._inner, bytes32(value));
147     }
148 
149     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
150         return _contains(set._inner, bytes32(value));
151     }
152 
153     function length(UintSet storage set) internal view returns (uint256) {
154         return _length(set._inner);
155     }
156 
157     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
158         return uint256(_at(set._inner, index));
159     }
160 }
161 
162 
163 contract Ownable is Context {
164     address private _owner;
165 
166     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
167 
168     constructor () internal {
169         address msgSender = _msgSender();
170         _owner = msgSender;
171         emit OwnershipTransferred(address(0), msgSender);
172     }
173 
174     function owner() public view returns (address) {
175         return _owner;
176     }
177 
178     modifier onlyOwner() {
179         require(_owner == _msgSender(), "Ownable: caller is not the owner");
180         _;
181     }
182 
183     function renounceOwnership() public virtual onlyOwner {
184         emit OwnershipTransferred(_owner, address(0));
185         _owner = address(0);
186     }
187 
188     function transferOwnership(address newOwner) public virtual onlyOwner {
189         require(newOwner != address(0), "Ownable: new owner is the zero address");
190         emit OwnershipTransferred(_owner, newOwner);
191         _owner = newOwner;
192     }
193 }
194 
195 
196 contract Pausable is Ownable {
197   event Pause();
198   event Unpause();
199   address private _publicSaleContractAddress;
200   address private _swapWallet;
201 
202   bool public paused = false;
203 
204   constructor() public {}
205 
206   /**
207    * @dev modifier to allow actions only when the contract IS paused
208    */
209   modifier whenNotPaused() {
210     require(!paused || msg.sender == owner() || msg.sender == _publicSaleContractAddress || msg.sender == _swapWallet);
211     _;
212   }
213 
214   /**
215    * @dev modifier to allow actions only when the contract IS NOT paused
216    */
217   modifier whenPaused {
218     require(paused);
219     _;
220   }
221 
222   /**
223    * @dev called by the owner to pause, triggers stopped state
224    */
225   function pause() public onlyOwner whenNotPaused returns (bool) {
226     paused = true;
227     emit Pause();
228     return true;
229   }
230 
231   /**
232    * @dev called by the owner to unpause, returns to normal state
233    */
234   function unpause() public onlyOwner whenPaused returns (bool) {
235     paused = false;
236     emit Unpause();
237     return true;
238   }
239 
240   function publicSaleContractAddress() public view returns (address) {
241       return _publicSaleContractAddress;
242   }
243 
244   function publicSaleContractAddress(address publicSaleAddress) public onlyOwner returns (address) {
245       _publicSaleContractAddress = publicSaleAddress;
246       return _publicSaleContractAddress;
247   }
248 
249   function swapWallet() public view returns (address) {
250       return _swapWallet;
251   }
252 
253   function swapWallet(address swapWallet) public onlyOwner returns (address) {
254       _swapWallet = swapWallet;
255       return _swapWallet;
256   }
257 }
258 
259 library Address {
260     function isContract(address account) internal view returns (bool) {
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267 
268     function sendValue(address payable recipient, uint256 amount) internal {
269         require(address(this).balance >= amount, "Address: insufficient balance");
270 
271         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
272         (bool success, ) = recipient.call{ value: amount }("");
273         require(success, "Address: unable to send value, recipient may have reverted");
274     }
275 }
276 
277 
278 abstract contract AccessControl is Context {
279     using EnumerableSet for EnumerableSet.AddressSet;
280     using Address for address;
281 
282     struct RoleData {
283         EnumerableSet.AddressSet members;
284         bytes32 adminRole;
285     }
286 
287     mapping (bytes32 => RoleData) private _roles;
288 
289     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
290 
291     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
292 
293     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
294 
295     function hasRole(bytes32 role, address account) public view returns (bool) {
296         return _roles[role].members.contains(account);
297     }
298 
299     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
300         return _roles[role].members.length();
301     }
302 
303     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
304         return _roles[role].members.at(index);
305     }
306 
307     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
308         return _roles[role].adminRole;
309     }
310 
311     function grantRole(bytes32 role, address account) public virtual {
312         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
313 
314         _grantRole(role, account);
315     }
316 
317     function revokeRole(bytes32 role, address account) public virtual {
318         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
319 
320         _revokeRole(role, account);
321     }
322 
323     function renounceRole(bytes32 role, address account) public virtual {
324         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
325 
326         _revokeRole(role, account);
327     }
328 
329     function _setupRole(bytes32 role, address account) internal virtual {
330         _grantRole(role, account);
331     }
332 
333     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
334         _roles[role].adminRole = adminRole;
335     }
336 
337     function _grantRole(bytes32 role, address account) private {
338         if (_roles[role].members.add(account)) {
339             emit RoleGranted(role, account, _msgSender());
340         }
341     }
342 
343     function _revokeRole(bytes32 role, address account) private {
344         if (_roles[role].members.remove(account)) {
345             emit RoleRevoked(role, account, _msgSender());
346         }
347     }
348 }
349 
350 library SafeMath {
351     /**
352      * @dev Returns the addition of two unsigned integers, reverting on
353      * overflow.
354      *
355      * Counterpart to Solidity's `+` operator.
356      *
357      * Requirements:
358      *
359      * - Addition cannot overflow.
360      */
361     function add(uint256 a, uint256 b) internal pure returns (uint256) {
362         uint256 c = a + b;
363         require(c >= a, "SafeMath: addition overflow");
364 
365         return c;
366     }
367 
368     /**
369      * @dev Returns the subtraction of two unsigned integers, reverting on
370      * overflow (when the result is negative).
371      *
372      * Counterpart to Solidity's `-` operator.
373      *
374      * Requirements:
375      *
376      * - Subtraction cannot overflow.
377      */
378     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
379         return sub(a, b, "SafeMath: subtraction overflow");
380     }
381 
382     /**
383      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
384      * overflow (when the result is negative).
385      *
386      * Counterpart to Solidity's `-` operator.
387      *
388      * Requirements:
389      *
390      * - Subtraction cannot overflow.
391      */
392     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
393         require(b <= a, errorMessage);
394         uint256 c = a - b;
395 
396         return c;
397     }
398 
399     /**
400      * @dev Returns the multiplication of two unsigned integers, reverting on
401      * overflow.
402      *
403      * Counterpart to Solidity's `*` operator.
404      *
405      * Requirements:
406      *
407      * - Multiplication cannot overflow.
408      */
409     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
410         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
411         // benefit is lost if 'b' is also tested.
412         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
413         if (a == 0) {
414             return 0;
415         }
416 
417         uint256 c = a * b;
418         require(c / a == b, "SafeMath: multiplication overflow");
419 
420         return c;
421     }
422 
423     /**
424      * @dev Returns the integer division of two unsigned integers. Reverts on
425      * division by zero. The result is rounded towards zero.
426      *
427      * Counterpart to Solidity's `/` operator. Note: this function uses a
428      * `revert` opcode (which leaves remaining gas untouched) while Solidity
429      * uses an invalid opcode to revert (consuming all remaining gas).
430      *
431      * Requirements:
432      *
433      * - The divisor cannot be zero.
434      */
435     function div(uint256 a, uint256 b) internal pure returns (uint256) {
436         return div(a, b, "SafeMath: division by zero");
437     }
438 
439     /**
440      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
441      * division by zero. The result is rounded towards zero.
442      *
443      * Counterpart to Solidity's `/` operator. Note: this function uses a
444      * `revert` opcode (which leaves remaining gas untouched) while Solidity
445      * uses an invalid opcode to revert (consuming all remaining gas).
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
452         require(b > 0, errorMessage);
453         uint256 c = a / b;
454         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
455 
456         return c;
457     }
458 
459     /**
460      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
461      * Reverts when dividing by zero.
462      *
463      * Counterpart to Solidity's `%` operator. This function uses a `revert`
464      * opcode (which leaves remaining gas untouched) while Solidity uses an
465      * invalid opcode to revert (consuming all remaining gas).
466      *
467      * Requirements:
468      *
469      * - The divisor cannot be zero.
470      */
471     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
472         return mod(a, b, "SafeMath: modulo by zero");
473     }
474 
475     /**
476      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
477      * Reverts with custom message when dividing by zero.
478      *
479      * Counterpart to Solidity's `%` operator. This function uses a `revert`
480      * opcode (which leaves remaining gas untouched) while Solidity uses an
481      * invalid opcode to revert (consuming all remaining gas).
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
488         require(b != 0, errorMessage);
489         return a % b;
490     }
491 }
492 
493 contract ERC20 is Context, IERC20 {
494     using SafeMath for uint256;
495     using Address for address;
496 
497     mapping (address => uint256) private _balances;
498 
499     mapping (address => mapping (address => uint256)) private _allowances;
500 
501     uint256 private _totalSupply;
502 
503     string private _name;
504     string private _symbol;
505     uint8 private _decimals;
506 
507     /**
508      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
509      * a default value of 18.
510      *
511      * To select a different value for {decimals}, use {_setupDecimals}.
512      *
513      * All three of these values are immutable: they can only be set once during
514      * construction.
515      */
516     constructor (string memory name, string memory symbol) public {
517         _name = name;
518         _symbol = symbol;
519         _decimals = 18;
520     }
521 
522     /**
523      * @dev Returns the name of the token.
524      */
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     /**
530      * @dev Returns the symbol of the token, usually a shorter version of the
531      * name.
532      */
533     function symbol() public view returns (string memory) {
534         return _symbol;
535     }
536 
537     /**
538      * @dev Returns the number of decimals used to get its user representation.
539      * For example, if `decimals` equals `2`, a balance of `505` tokens should
540      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
541      *
542      * Tokens usually opt for a value of 18, imitating the relationship between
543      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
544      * called.
545      *
546      * NOTE: This information is only used for _display_ purposes: it in
547      * no way affects any of the arithmetic of the contract, including
548      * {IERC20-balanceOf} and {IERC20-transfer}.
549      */
550     function decimals() public view returns (uint8) {
551         return _decimals;
552     }
553 
554     /**
555      * @dev See {IERC20-totalSupply}.
556      */
557     function totalSupply() public view override returns (uint256) {
558         return _totalSupply;
559     }
560 
561     /**
562      * @dev See {IERC20-balanceOf}.
563      */
564     function balanceOf(address account) public view override returns (uint256) {
565         return _balances[account];
566     }
567 
568     /**
569      * @dev See {IERC20-transfer}.
570      *
571      * Requirements:
572      *
573      * - `recipient` cannot be the zero address.
574      * - the caller must have a balance of at least `amount`.
575      */
576     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
577         _transfer(_msgSender(), recipient, amount);
578         return true;
579     }
580 
581     /**
582      * @dev See {IERC20-allowance}.
583      */
584     function allowance(address owner, address spender) public view virtual override returns (uint256) {
585         return _allowances[owner][spender];
586     }
587 
588     /**
589      * @dev See {IERC20-approve}.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      */
595     function approve(address spender, uint256 amount) public virtual override returns (bool) {
596         _approve(_msgSender(), spender, amount);
597         return true;
598     }
599 
600     /**
601      * @dev See {IERC20-transferFrom}.
602      *
603      * Emits an {Approval} event indicating the updated allowance. This is not
604      * required by the EIP. See the note at the beginning of {ERC20};
605      *
606      * Requirements:
607      * - `sender` and `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      * - the caller must have allowance for ``sender``'s tokens of at least
610      * `amount`.
611      */
612     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
613         _transfer(sender, recipient, amount);
614         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
615         return true;
616     }
617 
618     /**
619      * @dev Atomically increases the allowance granted to `spender` by the caller.
620      *
621      * This is an alternative to {approve} that can be used as a mitigation for
622      * problems described in {IERC20-approve}.
623      *
624      * Emits an {Approval} event indicating the updated allowance.
625      *
626      * Requirements:
627      *
628      * - `spender` cannot be the zero address.
629      */
630     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
631         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
632         return true;
633     }
634 
635     /**
636      * @dev Atomically decreases the allowance granted to `spender` by the caller.
637      *
638      * This is an alternative to {approve} that can be used as a mitigation for
639      * problems described in {IERC20-approve}.
640      *
641      * Emits an {Approval} event indicating the updated allowance.
642      *
643      * Requirements:
644      *
645      * - `spender` cannot be the zero address.
646      * - `spender` must have allowance for the caller of at least
647      * `subtractedValue`.
648      */
649     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
650         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
651         return true;
652     }
653 
654     /**
655      * @dev Moves tokens `amount` from `sender` to `recipient`.
656      *
657      * This is internal function is equivalent to {transfer}, and can be used to
658      * e.g. implement automatic token fees, slashing mechanisms, etc.
659      *
660      * Emits a {Transfer} event.
661      *
662      * Requirements:
663      *
664      * - `sender` cannot be the zero address.
665      * - `recipient` cannot be the zero address.
666      * - `sender` must have a balance of at least `amount`.
667      */
668     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
669         require(sender != address(0), "ERC20: transfer from the zero address");
670         require(recipient != address(0), "ERC20: transfer to the zero address");
671 
672         _beforeTokenTransfer(sender, recipient, amount);
673 
674         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
675         _balances[recipient] = _balances[recipient].add(amount);
676         emit Transfer(sender, recipient, amount);
677     }
678 
679     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
680      * the total supply.
681      *
682      * Emits a {Transfer} event with `from` set to the zero address.
683      *
684      * Requirements
685      *
686      * - `to` cannot be the zero address.
687      */
688     function _mint(address account, uint256 amount) internal virtual {
689         require(account != address(0), "ERC20: mint to the zero address");
690 
691         _beforeTokenTransfer(address(0), account, amount);
692 
693         _totalSupply = _totalSupply.add(amount);
694         _balances[account] = _balances[account].add(amount);
695         emit Transfer(address(0), account, amount);
696     }
697 
698     /**
699      * @dev Destroys `amount` tokens from `account`, reducing the
700      * total supply.
701      *
702      * Emits a {Transfer} event with `to` set to the zero address.
703      *
704      * Requirements
705      *
706      * - `account` cannot be the zero address.
707      * - `account` must have at least `amount` tokens.
708      */
709     function _burn(address account, uint256 amount) internal virtual {
710         require(account != address(0), "ERC20: burn from the zero address");
711 
712         _beforeTokenTransfer(account, address(0), amount);
713 
714         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
715         _totalSupply = _totalSupply.sub(amount);
716         emit Transfer(account, address(0), amount);
717     }
718 
719     /**
720      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
721      *
722      * This is internal function is equivalent to `approve`, and can be used to
723      * e.g. set automatic allowances for certain subsystems, etc.
724      *
725      * Emits an {Approval} event.
726      *
727      * Requirements:
728      *
729      * - `owner` cannot be the zero address.
730      * - `spender` cannot be the zero address.
731      */
732     function _approve(address owner, address spender, uint256 amount) internal virtual {
733         require(owner != address(0), "ERC20: approve from the zero address");
734         require(spender != address(0), "ERC20: approve to the zero address");
735 
736         _allowances[owner][spender] = amount;
737         emit Approval(owner, spender, amount);
738     }
739 
740     /**
741      * @dev Sets {decimals} to a value other than the default one of 18.
742      *
743      * WARNING: This function should only be called from the constructor. Most
744      * applications that interact with token contracts will not expect
745      * {decimals} to ever change, and may work incorrectly if it does.
746      */
747     function _setupDecimals(uint8 decimals_) internal {
748         _decimals = decimals_;
749     }
750 
751     /**
752      * @dev Hook that is called before any transfer of tokens. This includes
753      * minting and burning.
754      *
755      * Calling conditions:
756      *
757      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
758      * will be to transferred to `to`.
759      * - when `from` is zero, `amount` tokens will be minted for `to`.
760      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
761      * - `from` and `to` are never both zero.
762      *
763      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
764      */
765     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
766 }
767 
768 contract TokenRecover is Ownable {
769 
770     /**
771      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
772      * @param tokenAddress The token contract address
773      * @param tokenAmount Number of tokens to be sent
774      */
775     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
776         IERC20(tokenAddress).transfer(owner(), tokenAmount);
777     }
778 }
779 
780 abstract contract ERC20Burnable is Context, ERC20 {
781  
782     function burn(uint256 amount) public virtual {
783         _burn(_msgSender(), amount);
784     }
785 
786     function burnFrom(address account, uint256 amount) public virtual {
787         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
788 
789         _approve(account, _msgSender(), decreasedAllowance);
790         _burn(account, amount);
791     }
792 }
793 
794 interface IERC165 {
795 
796     function supportsInterface(bytes4 interfaceId) external view returns (bool);
797 }
798 
799 contract ERC165 is IERC165 {
800     /*
801      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
802      */
803     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
804 
805     /**
806      * @dev Mapping of interface ids to whether or not it's supported.
807      */
808     mapping(bytes4 => bool) private _supportedInterfaces;
809 
810     constructor () internal {
811         // Derived contracts need only register support for their own interfaces,
812         // we register support for ERC165 itself here
813         _registerInterface(_INTERFACE_ID_ERC165);
814     }
815 
816     /**
817      * @dev See {IERC165-supportsInterface}.
818      *
819      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
820      */
821     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
822         return _supportedInterfaces[interfaceId];
823     }
824 
825     /**
826      * @dev Registers the contract as an implementer of the interface defined by
827      * `interfaceId`. Support of the actual ERC165 interface is automatic and
828      * registering its interface id is not required.
829      *
830      * See {IERC165-supportsInterface}.
831      *
832      * Requirements:
833      *
834      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
835      */
836     function _registerInterface(bytes4 interfaceId) internal virtual {
837         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
838         _supportedInterfaces[interfaceId] = true;
839     }
840 }
841 
842 interface IERC1363 is IERC20, IERC165 {
843 
844 
845     function transferAndCall(address to, uint256 value) external returns (bool);
846 
847     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
848 
849     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
850 
851     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
852 
853     function approveAndCall(address spender, uint256 value) external returns (bool);
854 
855     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
856 }
857 
858 contract Roles is AccessControl {
859 
860     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
861     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
862 
863     constructor () public {
864         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
865         _setupRole(MINTER_ROLE, _msgSender());
866         _setupRole(OPERATOR_ROLE, _msgSender());
867     }
868 
869     modifier onlyMinter() {
870         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
871         _;
872     }
873 
874     modifier onlyOperator() {
875         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
876         _;
877     }
878 }
879 
880 interface IERC1363Receiver {
881 
882     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
883 }
884 
885 interface IERC1363Spender {
886     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
887 }
888 
889 
890 contract ERC1363 is ERC20, IERC1363, ERC165 {
891     using Address for address;
892 
893     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
894 
895     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
896 
897     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
898 
899     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
900 
901     constructor (
902         string memory name,
903         string memory symbol
904     ) public payable ERC20(name, symbol) {
905         // register the supported interfaces to conform to ERC1363 via ERC165
906         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
907         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
908     }
909 
910     function transferAndCall(address to, uint256 value) public override returns (bool) {
911         return transferAndCall(to, value, "");
912     }
913 
914     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
915         transfer(to, value);
916         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
917         return true;
918     }
919 
920     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
921         return transferFromAndCall(from, to, value, "");
922     }
923 
924     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
925         transferFrom(from, to, value);
926         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
927         return true;
928     }
929 
930     function approveAndCall(address spender, uint256 value) public override returns (bool) {
931         return approveAndCall(spender, value, "");
932     }
933 
934     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
935         approve(spender, value);
936         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
937         return true;
938     }
939 
940     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
941         if (!to.isContract()) {
942             return false;
943         }
944         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
945             _msgSender(), from, value, data
946         );
947         return (retval == _ERC1363_RECEIVED);
948     }
949 
950     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
951         if (!spender.isContract()) {
952             return false;
953         }
954         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
955             _msgSender(), value, data
956         );
957         return (retval == _ERC1363_APPROVED);
958     }
959 }
960 
961 
962 abstract contract ERC20Capped is ERC20 {
963     uint256 private _cap;
964 
965     /**
966      * @dev Sets the value of the `cap`. This value is immutable, it can only be
967      * set once during construction.
968      */
969     constructor (uint256 cap) public {
970         require(cap > 0, "ERC20Capped: cap is 0");
971         _cap = cap;
972     }
973 
974     /**
975      * @dev Returns the cap on the token's total supply.
976      */
977     function cap() public view returns (uint256) {
978         return _cap;
979     }
980 
981     /**
982      * @dev See {ERC20-_beforeTokenTransfer}.
983      *
984      * Requirements:
985      *
986      * - minted tokens must not cause the total supply to go over the cap.
987      */
988     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
989         super._beforeTokenTransfer(from, to, amount);
990 
991         if (from == address(0)) { // When minting tokens
992             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
993         }
994     }
995 }
996 
997 
998 /**
999  * @title DotTokenContract
1000  * @author DefiOfThrones (https://github.com/DefiOfThrones/DOTTokenContract)
1001  */
1002 contract DotTokenContract is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover, Pausable {
1003 
1004     // indicates if transfer is enabled
1005     bool private _transferEnabled = false;
1006 
1007     /**
1008      * Emitted during transfer enabling
1009      */
1010     event TransferEnabled();
1011 
1012     /**
1013      * Tokens can be moved only after if transfer enabled or if you are an approved operator.
1014      */
1015     modifier canTransfer(address from) {
1016         require(
1017             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1018             "DotTokenContract: transfer is not enabled or from does not have the OPERATOR role"
1019         );
1020         _;
1021     }
1022     
1023     modifier validDestination( address to ) {
1024         require(to != address(0x0));
1025         require(to != address(this) );
1026         _;
1027     }
1028 
1029     constructor(
1030         string memory name,
1031         string memory symbol,
1032         uint8 decimals,
1033         uint256 cap,
1034         uint256 initialSupply,
1035         bool transferEnabled
1036     )
1037         public
1038         ERC20Capped(cap)
1039         ERC1363(name, symbol)
1040     {
1041         require(
1042             cap == initialSupply,
1043             "DotTokenContract: cap must be equal to initialSupply"
1044         );
1045 
1046         _setupDecimals(decimals);
1047 
1048         if (initialSupply > 0) {
1049             _mint(owner(), initialSupply);
1050         }
1051 
1052         if (transferEnabled) {
1053             enableTransfer();
1054         }
1055     }
1056 
1057     /**
1058      * @return if transfer is enabled or not.
1059      */
1060     function transferEnabled() public view returns (bool) {
1061         return _transferEnabled;
1062     }
1063 
1064     /**
1065      * Transfer tokens to a specified address.
1066      * @param to The address to transfer to
1067      * @param value The amount to be transferred
1068      * @return A boolean that indicates if the operation was successful.
1069      */
1070     function transfer(address to, uint256 value) public virtual override(ERC20) validDestination(to) canTransfer(_msgSender()) whenNotPaused returns (bool) {
1071         return super.transfer(to, value);
1072     }
1073 
1074     /**
1075      * Transfer tokens from one address to another.
1076      * @param from The address which you want to send tokens from
1077      * @param to The address which you want to transfer to
1078      * @param value the amount of tokens to be transferred
1079      * @return A boolean that indicates if the operation was successful.
1080      */
1081     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) validDestination(to) canTransfer(from) whenNotPaused returns (bool) {
1082         return super.transferFrom(from, to, value);
1083     }
1084     
1085     
1086     function approve(address spender, uint256 amount) public virtual override(ERC20) whenNotPaused returns (bool) {
1087          return super.approve(spender, amount);
1088     }
1089     
1090     function increaseAllowance(address spender, uint256 addedValue) public virtual override(ERC20) whenNotPaused returns (bool) {
1091         return super.increaseAllowance(spender, addedValue);
1092     }
1093     
1094     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override(ERC20) whenNotPaused returns (bool) {
1095         return super.decreaseAllowance(spender, subtractedValue);
1096     }
1097 
1098     /**
1099      * Function to enable transfers.
1100      */
1101     function enableTransfer() public onlyOwner {
1102         _transferEnabled = true;
1103 
1104         emit TransferEnabled();
1105     }
1106 
1107     /**
1108      * See {ERC20-_beforeTokenTransfer}.
1109      */
1110     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) validDestination(to) {
1111         super._beforeTokenTransfer(from, to, amount);
1112     }
1113 }