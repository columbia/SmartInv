1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address account) external view returns (uint256);
7 
8     function transfer(address recipient, uint256 amount) external returns (bool);
9 
10     function allowance(address owner, address spender) external view returns (uint256);
11 
12     function approve(address spender, uint256 amount) external returns (bool);
13 
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract Context {
22     constructor () internal { }
23 
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         return msg.data;
30     }
31 }
32 
33 
34 library EnumerableSet {
35 
36     struct Set {
37         // Storage of set values
38         bytes32[] _values;
39 
40         // Position of the value in the `values` array, plus 1 because index 0
41         // means a value is not in the set.
42         mapping (bytes32 => uint256) _indexes;
43     }
44 
45     function _add(Set storage set, bytes32 value) private returns (bool) {
46         if (!_contains(set, value)) {
47             set._values.push(value);
48             // The value is stored at length-1, but we add 1 to all indexes
49             // and use 0 as a sentinel value
50             set._indexes[value] = set._values.length;
51             return true;
52         } else {
53             return false;
54         }
55     }
56 
57     function _remove(Set storage set, bytes32 value) private returns (bool) {
58         // We read and store the value's index to prevent multiple reads from the same storage slot
59         uint256 valueIndex = set._indexes[value];
60 
61         if (valueIndex != 0) { // Equivalent to contains(set, value)
62             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
63             // the array, and then remove the last element (sometimes called as 'swap and pop').
64             // This modifies the order of the array, as noted in {at}.
65 
66             uint256 toDeleteIndex = valueIndex - 1;
67             uint256 lastIndex = set._values.length - 1;
68 
69             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
70             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
71 
72             bytes32 lastvalue = set._values[lastIndex];
73 
74             // Move the last value to the index where the value to delete is
75             set._values[toDeleteIndex] = lastvalue;
76             // Update the index for the moved value
77             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
78 
79             // Delete the slot where the moved value was stored
80             set._values.pop();
81 
82             // Delete the index for the deleted slot
83             delete set._indexes[value];
84 
85             return true;
86         } else {
87             return false;
88         }
89     }
90 
91     function _contains(Set storage set, bytes32 value) private view returns (bool) {
92         return set._indexes[value] != 0;
93     }
94 
95 
96     function _length(Set storage set) private view returns (uint256) {
97         return set._values.length;
98     }
99 
100     function _at(Set storage set, uint256 index) private view returns (bytes32) {
101         require(set._values.length > index, "EnumerableSet: index out of bounds");
102         return set._values[index];
103     }
104 
105 
106     struct AddressSet {
107         Set _inner;
108     }
109 
110     function add(AddressSet storage set, address value) internal returns (bool) {
111         return _add(set._inner, bytes32(uint256(value)));
112     }
113 
114     function remove(AddressSet storage set, address value) internal returns (bool) {
115         return _remove(set._inner, bytes32(uint256(value)));
116     }
117 
118     function contains(AddressSet storage set, address value) internal view returns (bool) {
119         return _contains(set._inner, bytes32(uint256(value)));
120     }
121 
122     function length(AddressSet storage set) internal view returns (uint256) {
123         return _length(set._inner);
124     }
125 
126     function at(AddressSet storage set, uint256 index) internal view returns (address) {
127         return address(uint256(_at(set._inner, index)));
128     }
129 
130 
131 
132     struct UintSet {
133         Set _inner;
134     }
135 
136     function add(UintSet storage set, uint256 value) internal returns (bool) {
137         return _add(set._inner, bytes32(value));
138     }
139 
140     function remove(UintSet storage set, uint256 value) internal returns (bool) {
141         return _remove(set._inner, bytes32(value));
142     }
143 
144     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
145         return _contains(set._inner, bytes32(value));
146     }
147 
148     function length(UintSet storage set) internal view returns (uint256) {
149         return _length(set._inner);
150     }
151 
152     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
153         return uint256(_at(set._inner, index));
154     }
155 }
156 
157 
158 contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     constructor () internal {
164         address msgSender = _msgSender();
165         _owner = msgSender;
166         emit OwnershipTransferred(address(0), msgSender);
167     }
168 
169     function owner() public view returns (address) {
170         return _owner;
171     }
172 
173     modifier onlyOwner() {
174         require(_owner == _msgSender(), "Ownable: caller is not the owner");
175         _;
176     }
177 
178     function renounceOwnership() public virtual onlyOwner {
179         emit OwnershipTransferred(_owner, address(0));
180         _owner = address(0);
181     }
182 
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         emit OwnershipTransferred(_owner, newOwner);
186         _owner = newOwner;
187     }
188 }
189 
190 
191 contract Pausable is Ownable {
192   event Pause();
193   event Unpause();
194   address private _publicSaleContractAddress;
195 
196   bool public paused = false;
197 
198   constructor() public {}
199 
200   /**
201    * @dev modifier to allow actions only when the contract IS paused
202    */
203   modifier whenNotPaused() {
204     require(!paused || msg.sender == owner() || msg.sender == _publicSaleContractAddress);
205     _;
206   }
207 
208   /**
209    * @dev modifier to allow actions only when the contract IS NOT paused
210    */
211   modifier whenPaused {
212     require(paused);
213     _;
214   }
215 
216   /**
217    * @dev called by the owner to pause, triggers stopped state
218    */
219   function pause() public onlyOwner whenNotPaused returns (bool) {
220     paused = true;
221     emit Pause();
222     return true;
223   }
224 
225   /**
226    * @dev called by the owner to unpause, returns to normal state
227    */
228   function unpause() public onlyOwner whenPaused returns (bool) {
229     paused = false;
230     emit Unpause();
231     return true;
232   }
233 
234   function publicSaleContractAddress() public view returns (address) {
235       return _publicSaleContractAddress;
236   }
237 
238   function publicSaleContractAddress(address publicSaleAddress) public onlyOwner returns (address) {
239       _publicSaleContractAddress = publicSaleAddress;
240       return _publicSaleContractAddress;
241   }
242 }
243 
244 library Address {
245     function isContract(address account) internal view returns (bool) {
246         bytes32 codehash;
247         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
248         assembly { codehash := extcodehash(account) }
249         return (codehash != accountHash && codehash != 0x0);
250     }
251 
252 
253     function sendValue(address payable recipient, uint256 amount) internal {
254         require(address(this).balance >= amount, "Address: insufficient balance");
255 
256         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
257         (bool success, ) = recipient.call{ value: amount }("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260 }
261 
262 
263 abstract contract AccessControl is Context {
264     using EnumerableSet for EnumerableSet.AddressSet;
265     using Address for address;
266 
267     struct RoleData {
268         EnumerableSet.AddressSet members;
269         bytes32 adminRole;
270     }
271 
272     mapping (bytes32 => RoleData) private _roles;
273 
274     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
275 
276     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
277 
278     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
279 
280     function hasRole(bytes32 role, address account) public view returns (bool) {
281         return _roles[role].members.contains(account);
282     }
283 
284     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
285         return _roles[role].members.length();
286     }
287 
288     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
289         return _roles[role].members.at(index);
290     }
291 
292     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
293         return _roles[role].adminRole;
294     }
295 
296     function grantRole(bytes32 role, address account) public virtual {
297         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
298 
299         _grantRole(role, account);
300     }
301 
302     function revokeRole(bytes32 role, address account) public virtual {
303         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
304 
305         _revokeRole(role, account);
306     }
307 
308     function renounceRole(bytes32 role, address account) public virtual {
309         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
310 
311         _revokeRole(role, account);
312     }
313 
314     function _setupRole(bytes32 role, address account) internal virtual {
315         _grantRole(role, account);
316     }
317 
318     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
319         _roles[role].adminRole = adminRole;
320     }
321 
322     function _grantRole(bytes32 role, address account) private {
323         if (_roles[role].members.add(account)) {
324             emit RoleGranted(role, account, _msgSender());
325         }
326     }
327 
328     function _revokeRole(bytes32 role, address account) private {
329         if (_roles[role].members.remove(account)) {
330             emit RoleRevoked(role, account, _msgSender());
331         }
332     }
333 }
334 
335 library SafeMath {
336     /**
337      * @dev Returns the addition of two unsigned integers, reverting on
338      * overflow.
339      *
340      * Counterpart to Solidity's `+` operator.
341      *
342      * Requirements:
343      *
344      * - Addition cannot overflow.
345      */
346     function add(uint256 a, uint256 b) internal pure returns (uint256) {
347         uint256 c = a + b;
348         require(c >= a, "SafeMath: addition overflow");
349 
350         return c;
351     }
352 
353     /**
354      * @dev Returns the subtraction of two unsigned integers, reverting on
355      * overflow (when the result is negative).
356      *
357      * Counterpart to Solidity's `-` operator.
358      *
359      * Requirements:
360      *
361      * - Subtraction cannot overflow.
362      */
363     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
364         return sub(a, b, "SafeMath: subtraction overflow");
365     }
366 
367     /**
368      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
369      * overflow (when the result is negative).
370      *
371      * Counterpart to Solidity's `-` operator.
372      *
373      * Requirements:
374      *
375      * - Subtraction cannot overflow.
376      */
377     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
378         require(b <= a, errorMessage);
379         uint256 c = a - b;
380 
381         return c;
382     }
383 
384     /**
385      * @dev Returns the multiplication of two unsigned integers, reverting on
386      * overflow.
387      *
388      * Counterpart to Solidity's `*` operator.
389      *
390      * Requirements:
391      *
392      * - Multiplication cannot overflow.
393      */
394     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
395         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
396         // benefit is lost if 'b' is also tested.
397         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
398         if (a == 0) {
399             return 0;
400         }
401 
402         uint256 c = a * b;
403         require(c / a == b, "SafeMath: multiplication overflow");
404 
405         return c;
406     }
407 
408     /**
409      * @dev Returns the integer division of two unsigned integers. Reverts on
410      * division by zero. The result is rounded towards zero.
411      *
412      * Counterpart to Solidity's `/` operator. Note: this function uses a
413      * `revert` opcode (which leaves remaining gas untouched) while Solidity
414      * uses an invalid opcode to revert (consuming all remaining gas).
415      *
416      * Requirements:
417      *
418      * - The divisor cannot be zero.
419      */
420     function div(uint256 a, uint256 b) internal pure returns (uint256) {
421         return div(a, b, "SafeMath: division by zero");
422     }
423 
424     /**
425      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
426      * division by zero. The result is rounded towards zero.
427      *
428      * Counterpart to Solidity's `/` operator. Note: this function uses a
429      * `revert` opcode (which leaves remaining gas untouched) while Solidity
430      * uses an invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      *
434      * - The divisor cannot be zero.
435      */
436     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
437         require(b > 0, errorMessage);
438         uint256 c = a / b;
439         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
440 
441         return c;
442     }
443 
444     /**
445      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
446      * Reverts when dividing by zero.
447      *
448      * Counterpart to Solidity's `%` operator. This function uses a `revert`
449      * opcode (which leaves remaining gas untouched) while Solidity uses an
450      * invalid opcode to revert (consuming all remaining gas).
451      *
452      * Requirements:
453      *
454      * - The divisor cannot be zero.
455      */
456     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
457         return mod(a, b, "SafeMath: modulo by zero");
458     }
459 
460     /**
461      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
462      * Reverts with custom message when dividing by zero.
463      *
464      * Counterpart to Solidity's `%` operator. This function uses a `revert`
465      * opcode (which leaves remaining gas untouched) while Solidity uses an
466      * invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      *
470      * - The divisor cannot be zero.
471      */
472     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
473         require(b != 0, errorMessage);
474         return a % b;
475     }
476 }
477 
478 contract ERC20 is Context, IERC20 {
479     using SafeMath for uint256;
480     using Address for address;
481 
482     mapping (address => uint256) private _balances;
483 
484     mapping (address => mapping (address => uint256)) private _allowances;
485 
486     uint256 private _totalSupply;
487 
488     string private _name;
489     string private _symbol;
490     uint8 private _decimals;
491 
492     /**
493      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
494      * a default value of 18.
495      *
496      * To select a different value for {decimals}, use {_setupDecimals}.
497      *
498      * All three of these values are immutable: they can only be set once during
499      * construction.
500      */
501     constructor (string memory name, string memory symbol) public {
502         _name = name;
503         _symbol = symbol;
504         _decimals = 18;
505     }
506 
507     /**
508      * @dev Returns the name of the token.
509      */
510     function name() public view returns (string memory) {
511         return _name;
512     }
513 
514     /**
515      * @dev Returns the symbol of the token, usually a shorter version of the
516      * name.
517      */
518     function symbol() public view returns (string memory) {
519         return _symbol;
520     }
521 
522     /**
523      * @dev Returns the number of decimals used to get its user representation.
524      * For example, if `decimals` equals `2`, a balance of `505` tokens should
525      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
526      *
527      * Tokens usually opt for a value of 18, imitating the relationship between
528      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
529      * called.
530      *
531      * NOTE: This information is only used for _display_ purposes: it in
532      * no way affects any of the arithmetic of the contract, including
533      * {IERC20-balanceOf} and {IERC20-transfer}.
534      */
535     function decimals() public view returns (uint8) {
536         return _decimals;
537     }
538 
539     /**
540      * @dev See {IERC20-totalSupply}.
541      */
542     function totalSupply() public view override returns (uint256) {
543         return _totalSupply;
544     }
545 
546     /**
547      * @dev See {IERC20-balanceOf}.
548      */
549     function balanceOf(address account) public view override returns (uint256) {
550         return _balances[account];
551     }
552 
553     /**
554      * @dev See {IERC20-transfer}.
555      *
556      * Requirements:
557      *
558      * - `recipient` cannot be the zero address.
559      * - the caller must have a balance of at least `amount`.
560      */
561     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
562         _transfer(_msgSender(), recipient, amount);
563         return true;
564     }
565 
566     /**
567      * @dev See {IERC20-allowance}.
568      */
569     function allowance(address owner, address spender) public view virtual override returns (uint256) {
570         return _allowances[owner][spender];
571     }
572 
573     /**
574      * @dev See {IERC20-approve}.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function approve(address spender, uint256 amount) public virtual override returns (bool) {
581         _approve(_msgSender(), spender, amount);
582         return true;
583     }
584 
585     /**
586      * @dev See {IERC20-transferFrom}.
587      *
588      * Emits an {Approval} event indicating the updated allowance. This is not
589      * required by the EIP. See the note at the beginning of {ERC20};
590      *
591      * Requirements:
592      * - `sender` and `recipient` cannot be the zero address.
593      * - `sender` must have a balance of at least `amount`.
594      * - the caller must have allowance for ``sender``'s tokens of at least
595      * `amount`.
596      */
597     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
598         _transfer(sender, recipient, amount);
599         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
600         return true;
601     }
602 
603     /**
604      * @dev Atomically increases the allowance granted to `spender` by the caller.
605      *
606      * This is an alternative to {approve} that can be used as a mitigation for
607      * problems described in {IERC20-approve}.
608      *
609      * Emits an {Approval} event indicating the updated allowance.
610      *
611      * Requirements:
612      *
613      * - `spender` cannot be the zero address.
614      */
615     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
616         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
617         return true;
618     }
619 
620     /**
621      * @dev Atomically decreases the allowance granted to `spender` by the caller.
622      *
623      * This is an alternative to {approve} that can be used as a mitigation for
624      * problems described in {IERC20-approve}.
625      *
626      * Emits an {Approval} event indicating the updated allowance.
627      *
628      * Requirements:
629      *
630      * - `spender` cannot be the zero address.
631      * - `spender` must have allowance for the caller of at least
632      * `subtractedValue`.
633      */
634     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
636         return true;
637     }
638 
639     /**
640      * @dev Moves tokens `amount` from `sender` to `recipient`.
641      *
642      * This is internal function is equivalent to {transfer}, and can be used to
643      * e.g. implement automatic token fees, slashing mechanisms, etc.
644      *
645      * Emits a {Transfer} event.
646      *
647      * Requirements:
648      *
649      * - `sender` cannot be the zero address.
650      * - `recipient` cannot be the zero address.
651      * - `sender` must have a balance of at least `amount`.
652      */
653     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
654         require(sender != address(0), "ERC20: transfer from the zero address");
655         require(recipient != address(0), "ERC20: transfer to the zero address");
656 
657         _beforeTokenTransfer(sender, recipient, amount);
658 
659         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
660         _balances[recipient] = _balances[recipient].add(amount);
661         emit Transfer(sender, recipient, amount);
662     }
663 
664     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
665      * the total supply.
666      *
667      * Emits a {Transfer} event with `from` set to the zero address.
668      *
669      * Requirements
670      *
671      * - `to` cannot be the zero address.
672      */
673     function _mint(address account, uint256 amount) internal virtual {
674         require(account != address(0), "ERC20: mint to the zero address");
675 
676         _beforeTokenTransfer(address(0), account, amount);
677 
678         _totalSupply = _totalSupply.add(amount);
679         _balances[account] = _balances[account].add(amount);
680         emit Transfer(address(0), account, amount);
681     }
682 
683     /**
684      * @dev Destroys `amount` tokens from `account`, reducing the
685      * total supply.
686      *
687      * Emits a {Transfer} event with `to` set to the zero address.
688      *
689      * Requirements
690      *
691      * - `account` cannot be the zero address.
692      * - `account` must have at least `amount` tokens.
693      */
694     function _burn(address account, uint256 amount) internal virtual {
695         require(account != address(0), "ERC20: burn from the zero address");
696 
697         _beforeTokenTransfer(account, address(0), amount);
698 
699         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
700         _totalSupply = _totalSupply.sub(amount);
701         emit Transfer(account, address(0), amount);
702     }
703 
704     /**
705      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
706      *
707      * This is internal function is equivalent to `approve`, and can be used to
708      * e.g. set automatic allowances for certain subsystems, etc.
709      *
710      * Emits an {Approval} event.
711      *
712      * Requirements:
713      *
714      * - `owner` cannot be the zero address.
715      * - `spender` cannot be the zero address.
716      */
717     function _approve(address owner, address spender, uint256 amount) internal virtual {
718         require(owner != address(0), "ERC20: approve from the zero address");
719         require(spender != address(0), "ERC20: approve to the zero address");
720 
721         _allowances[owner][spender] = amount;
722         emit Approval(owner, spender, amount);
723     }
724 
725     /**
726      * @dev Sets {decimals} to a value other than the default one of 18.
727      *
728      * WARNING: This function should only be called from the constructor. Most
729      * applications that interact with token contracts will not expect
730      * {decimals} to ever change, and may work incorrectly if it does.
731      */
732     function _setupDecimals(uint8 decimals_) internal {
733         _decimals = decimals_;
734     }
735 
736     /**
737      * @dev Hook that is called before any transfer of tokens. This includes
738      * minting and burning.
739      *
740      * Calling conditions:
741      *
742      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
743      * will be to transferred to `to`.
744      * - when `from` is zero, `amount` tokens will be minted for `to`.
745      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
746      * - `from` and `to` are never both zero.
747      *
748      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
749      */
750     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
751 }
752 
753 contract TokenRecover is Ownable {
754 
755 
756     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
757         IERC20(tokenAddress).transfer(owner(), tokenAmount);
758     }
759 }
760 
761 abstract contract ERC20Burnable is Context, ERC20 {
762  
763     function burn(uint256 amount) public virtual {
764         _burn(_msgSender(), amount);
765     }
766 
767     function burnFrom(address account, uint256 amount) public virtual {
768         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
769 
770         _approve(account, _msgSender(), decreasedAllowance);
771         _burn(account, amount);
772     }
773 }
774 
775 interface IERC165 {
776 
777     function supportsInterface(bytes4 interfaceId) external view returns (bool);
778 }
779 
780 contract ERC165 is IERC165 {
781 
782     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
783 
784 
785     mapping(bytes4 => bool) private _supportedInterfaces;
786 
787     constructor () internal {
788         _registerInterface(_INTERFACE_ID_ERC165);
789     }
790 
791 
792     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
793         return _supportedInterfaces[interfaceId];
794     }
795 
796 
797     function _registerInterface(bytes4 interfaceId) internal virtual {
798         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
799         _supportedInterfaces[interfaceId] = true;
800     }
801 }
802 
803 interface IERC1363 is IERC20, IERC165 {
804 
805 
806     function transferAndCall(address to, uint256 value) external returns (bool);
807 
808     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
809 
810     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
811 
812     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
813 
814     function approveAndCall(address spender, uint256 value) external returns (bool);
815 
816     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
817 }
818 
819 contract Roles is AccessControl {
820 
821     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
822     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
823 
824     constructor () public {
825         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
826         _setupRole(MINTER_ROLE, _msgSender());
827         _setupRole(OPERATOR_ROLE, _msgSender());
828     }
829 
830     modifier onlyMinter() {
831         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
832         _;
833     }
834 
835     modifier onlyOperator() {
836         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
837         _;
838     }
839 }
840 
841 interface IERC1363Receiver {
842 
843     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
844 }
845 
846 interface IERC1363Spender {
847     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
848 }
849 
850 
851 contract ERC1363 is ERC20, IERC1363, ERC165 {
852     using Address for address;
853 
854     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
855 
856     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
857 
858     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
859 
860     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
861 
862     constructor (
863         string memory name,
864         string memory symbol
865     ) public payable ERC20(name, symbol) {
866         // register the supported interfaces to conform to ERC1363 via ERC165
867         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
868         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
869     }
870 
871     function transferAndCall(address to, uint256 value) public override returns (bool) {
872         return transferAndCall(to, value, "");
873     }
874 
875     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
876         transfer(to, value);
877         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
878         return true;
879     }
880 
881     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
882         return transferFromAndCall(from, to, value, "");
883     }
884 
885     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
886         transferFrom(from, to, value);
887         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
888         return true;
889     }
890 
891     function approveAndCall(address spender, uint256 value) public override returns (bool) {
892         return approveAndCall(spender, value, "");
893     }
894 
895     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
896         approve(spender, value);
897         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
898         return true;
899     }
900 
901     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
902         if (!to.isContract()) {
903             return false;
904         }
905         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
906             _msgSender(), from, value, data
907         );
908         return (retval == _ERC1363_RECEIVED);
909     }
910 
911     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
912         if (!spender.isContract()) {
913             return false;
914         }
915         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
916             _msgSender(), value, data
917         );
918         return (retval == _ERC1363_APPROVED);
919     }
920 }
921 
922 
923 abstract contract ERC20Capped is ERC20 {
924     uint256 private _cap;
925 
926     /**
927      * @dev Sets the value of the `cap`. This value is immutable, it can only be
928      * set once during construction.
929      */
930     constructor (uint256 cap) public {
931         require(cap > 0, "ERC20Capped: cap is 0");
932         _cap = cap;
933     }
934 
935     /**
936      * @dev Returns the cap on the token's total supply.
937      */
938     function cap() public view returns (uint256) {
939         return _cap;
940     }
941 
942     /**
943      * @dev See {ERC20-_beforeTokenTransfer}.
944      *
945      * Requirements:
946      *
947      * - minted tokens must not cause the total supply to go over the cap.
948      */
949     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
950         super._beforeTokenTransfer(from, to, amount);
951 
952         if (from == address(0)) { // When minting tokens
953             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
954         }
955     }
956 }
957 
958 
959 contract RocksTokenContract is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover, Pausable {
960 
961     bool private _transferEnabled = false;
962 
963 
964     event TransferEnabled();
965 
966 
967     modifier canTransfer(address from) {
968         require(
969             _transferEnabled || hasRole(OPERATOR_ROLE, from),
970             "RocksTokenContract: transfer is not enabled or from does not have the OPERATOR role"
971         );
972         _;
973     }
974     
975     modifier validDestination( address to ) {
976         require(to != address(0x0));
977         require(to != address(this) );
978         _;
979     }
980 
981     constructor(
982         string memory name,
983         string memory symbol,
984         uint8 decimals,
985         uint256 cap,
986         uint256 initialSupply,
987         bool transferEnabled
988     )
989         public
990         ERC20Capped(cap)
991         ERC1363(name, symbol)
992     {
993         require(
994             cap == initialSupply,
995             "RocksTokenContract: cap must be equal to initialSupply"
996         );
997 
998         _setupDecimals(decimals);
999 
1000         if (initialSupply > 0) {
1001             _mint(owner(), initialSupply);
1002         }
1003 
1004         if (transferEnabled) {
1005             enableTransfer();
1006         }
1007     }
1008 
1009 
1010     function transferEnabled() public view returns (bool) {
1011         return _transferEnabled;
1012     }
1013 
1014 
1015     function transfer(address to, uint256 value) public virtual override(ERC20) validDestination(to) canTransfer(_msgSender()) whenNotPaused returns (bool) {
1016         return super.transfer(to, value);
1017     }
1018 
1019 
1020     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) validDestination(to) canTransfer(from) whenNotPaused returns (bool) {
1021         return super.transferFrom(from, to, value);
1022     }
1023     
1024     
1025     function approve(address spender, uint256 amount) public virtual override(ERC20) whenNotPaused returns (bool) {
1026          return super.approve(spender, amount);
1027     }
1028     
1029     function increaseAllowance(address spender, uint256 addedValue) public virtual override(ERC20) whenNotPaused returns (bool) {
1030         return super.increaseAllowance(spender, addedValue);
1031     }
1032     
1033     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override(ERC20) whenNotPaused returns (bool) {
1034         return super.decreaseAllowance(spender, subtractedValue);
1035     }
1036 
1037 
1038     function enableTransfer() public onlyOwner {
1039         _transferEnabled = true;
1040 
1041         emit TransferEnabled();
1042     }
1043 
1044 
1045     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) validDestination(to) {
1046         super._beforeTokenTransfer(from, to, amount);
1047     }
1048 }