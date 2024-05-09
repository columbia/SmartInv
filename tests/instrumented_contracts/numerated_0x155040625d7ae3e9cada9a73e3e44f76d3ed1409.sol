1 pragma solidity ^0.6.0;
2 
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract Context {
23     // Empty internal constructor, to prevent people from mistakenly deploying
24     // an instance of this contract, which should be used via inheritance.
25     constructor () internal { }
26 
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 
38 library EnumerableSet {
39 
40     struct Set {
41         // Storage of set values
42         bytes32[] _values;
43 
44         // Position of the value in the `values` array, plus 1 because index 0
45         // means a value is not in the set.
46         mapping (bytes32 => uint256) _indexes;
47     }
48 
49     function _add(Set storage set, bytes32 value) private returns (bool) {
50         if (!_contains(set, value)) {
51             set._values.push(value);
52             // The value is stored at length-1, but we add 1 to all indexes
53             // and use 0 as a sentinel value
54             set._indexes[value] = set._values.length;
55             return true;
56         } else {
57             return false;
58         }
59     }
60 
61     function _remove(Set storage set, bytes32 value) private returns (bool) {
62         // We read and store the value's index to prevent multiple reads from the same storage slot
63         uint256 valueIndex = set._indexes[value];
64 
65         if (valueIndex != 0) { // Equivalent to contains(set, value)
66             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
67             // the array, and then remove the last element (sometimes called as 'swap and pop').
68             // This modifies the order of the array, as noted in {at}.
69 
70             uint256 toDeleteIndex = valueIndex - 1;
71             uint256 lastIndex = set._values.length - 1;
72 
73             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
74             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
75 
76             bytes32 lastvalue = set._values[lastIndex];
77 
78             // Move the last value to the index where the value to delete is
79             set._values[toDeleteIndex] = lastvalue;
80             // Update the index for the moved value
81             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
82 
83             // Delete the slot where the moved value was stored
84             set._values.pop();
85 
86             // Delete the index for the deleted slot
87             delete set._indexes[value];
88 
89             return true;
90         } else {
91             return false;
92         }
93     }
94 
95     function _contains(Set storage set, bytes32 value) private view returns (bool) {
96         return set._indexes[value] != 0;
97     }
98 
99 
100     function _length(Set storage set) private view returns (uint256) {
101         return set._values.length;
102     }
103 
104     function _at(Set storage set, uint256 index) private view returns (bytes32) {
105         require(set._values.length > index, "EnumerableSet: index out of bounds");
106         return set._values[index];
107     }
108 
109 
110     struct AddressSet {
111         Set _inner;
112     }
113 
114     function add(AddressSet storage set, address value) internal returns (bool) {
115         return _add(set._inner, bytes32(uint256(value)));
116     }
117 
118     function remove(AddressSet storage set, address value) internal returns (bool) {
119         return _remove(set._inner, bytes32(uint256(value)));
120     }
121 
122     function contains(AddressSet storage set, address value) internal view returns (bool) {
123         return _contains(set._inner, bytes32(uint256(value)));
124     }
125 
126     function length(AddressSet storage set) internal view returns (uint256) {
127         return _length(set._inner);
128     }
129 
130     function at(AddressSet storage set, uint256 index) internal view returns (address) {
131         return address(uint256(_at(set._inner, index)));
132     }
133 
134 
135 
136     struct UintSet {
137         Set _inner;
138     }
139 
140     function add(UintSet storage set, uint256 value) internal returns (bool) {
141         return _add(set._inner, bytes32(value));
142     }
143 
144     function remove(UintSet storage set, uint256 value) internal returns (bool) {
145         return _remove(set._inner, bytes32(value));
146     }
147 
148     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
149         return _contains(set._inner, bytes32(value));
150     }
151 
152     function length(UintSet storage set) internal view returns (uint256) {
153         return _length(set._inner);
154     }
155 
156     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
157         return uint256(_at(set._inner, index));
158     }
159 }
160 
161 
162 contract Ownable is Context {
163     address private _owner;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     constructor () internal {
168         address msgSender = _msgSender();
169         _owner = msgSender;
170         emit OwnershipTransferred(address(0), msgSender);
171     }
172 
173     function owner() public view returns (address) {
174         return _owner;
175     }
176 
177     modifier onlyOwner() {
178         require(_owner == _msgSender(), "Ownable: caller is not the owner");
179         _;
180     }
181 
182     function renounceOwnership() public virtual onlyOwner {
183         emit OwnershipTransferred(_owner, address(0));
184         _owner = address(0);
185     }
186 
187     function transferOwnership(address newOwner) public virtual onlyOwner {
188         require(newOwner != address(0), "Ownable: new owner is the zero address");
189         emit OwnershipTransferred(_owner, newOwner);
190         _owner = newOwner;
191     }
192 }
193 
194 library Address {
195     function isContract(address account) internal view returns (bool) {
196         bytes32 codehash;
197         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
198         assembly { codehash := extcodehash(account) }
199         return (codehash != accountHash && codehash != 0x0);
200     }
201 
202 
203     function sendValue(address payable recipient, uint256 amount) internal {
204         require(address(this).balance >= amount, "Address: insufficient balance");
205 
206         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
207         (bool success, ) = recipient.call{ value: amount }("");
208         require(success, "Address: unable to send value, recipient may have reverted");
209     }
210 }
211 
212 
213 abstract contract AccessControl is Context {
214     using EnumerableSet for EnumerableSet.AddressSet;
215     using Address for address;
216 
217     struct RoleData {
218         EnumerableSet.AddressSet members;
219         bytes32 adminRole;
220     }
221 
222     mapping (bytes32 => RoleData) private _roles;
223 
224     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
225 
226     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
227 
228     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
229 
230     function hasRole(bytes32 role, address account) public view returns (bool) {
231         return _roles[role].members.contains(account);
232     }
233 
234     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
235         return _roles[role].members.length();
236     }
237 
238     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
239         return _roles[role].members.at(index);
240     }
241 
242     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
243         return _roles[role].adminRole;
244     }
245 
246     function grantRole(bytes32 role, address account) public virtual {
247         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
248 
249         _grantRole(role, account);
250     }
251 
252     function revokeRole(bytes32 role, address account) public virtual {
253         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
254 
255         _revokeRole(role, account);
256     }
257 
258     function renounceRole(bytes32 role, address account) public virtual {
259         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
260 
261         _revokeRole(role, account);
262     }
263 
264     function _setupRole(bytes32 role, address account) internal virtual {
265         _grantRole(role, account);
266     }
267 
268     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
269         _roles[role].adminRole = adminRole;
270     }
271 
272     function _grantRole(bytes32 role, address account) private {
273         if (_roles[role].members.add(account)) {
274             emit RoleGranted(role, account, _msgSender());
275         }
276     }
277 
278     function _revokeRole(bytes32 role, address account) private {
279         if (_roles[role].members.remove(account)) {
280             emit RoleRevoked(role, account, _msgSender());
281         }
282     }
283 }
284 
285 library SafeMath {
286     /**
287      * @dev Returns the addition of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `+` operator.
291      *
292      * Requirements:
293      *
294      * - Addition cannot overflow.
295      */
296     function add(uint256 a, uint256 b) internal pure returns (uint256) {
297         uint256 c = a + b;
298         require(c >= a, "SafeMath: addition overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      *
311      * - Subtraction cannot overflow.
312      */
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         return sub(a, b, "SafeMath: subtraction overflow");
315     }
316 
317     /**
318      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
319      * overflow (when the result is negative).
320      *
321      * Counterpart to Solidity's `-` operator.
322      *
323      * Requirements:
324      *
325      * - Subtraction cannot overflow.
326      */
327     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b <= a, errorMessage);
329         uint256 c = a - b;
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the multiplication of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `*` operator.
339      *
340      * Requirements:
341      *
342      * - Multiplication cannot overflow.
343      */
344     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
345         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
346         // benefit is lost if 'b' is also tested.
347         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
348         if (a == 0) {
349             return 0;
350         }
351 
352         uint256 c = a * b;
353         require(c / a == b, "SafeMath: multiplication overflow");
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the integer division of two unsigned integers. Reverts on
360      * division by zero. The result is rounded towards zero.
361      *
362      * Counterpart to Solidity's `/` operator. Note: this function uses a
363      * `revert` opcode (which leaves remaining gas untouched) while Solidity
364      * uses an invalid opcode to revert (consuming all remaining gas).
365      *
366      * Requirements:
367      *
368      * - The divisor cannot be zero.
369      */
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         return div(a, b, "SafeMath: division by zero");
372     }
373 
374     /**
375      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
376      * division by zero. The result is rounded towards zero.
377      *
378      * Counterpart to Solidity's `/` operator. Note: this function uses a
379      * `revert` opcode (which leaves remaining gas untouched) while Solidity
380      * uses an invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      *
384      * - The divisor cannot be zero.
385      */
386     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
387         require(b > 0, errorMessage);
388         uint256 c = a / b;
389         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
396      * Reverts when dividing by zero.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
407         return mod(a, b, "SafeMath: modulo by zero");
408     }
409 
410     /**
411      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
412      * Reverts with custom message when dividing by zero.
413      *
414      * Counterpart to Solidity's `%` operator. This function uses a `revert`
415      * opcode (which leaves remaining gas untouched) while Solidity uses an
416      * invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         require(b != 0, errorMessage);
424         return a % b;
425     }
426 }
427 
428 contract ERC20 is Context, IERC20 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     mapping (address => uint256) private _balances;
433 
434     mapping (address => mapping (address => uint256)) private _allowances;
435 
436     uint256 private _totalSupply;
437 
438     string private _name;
439     string private _symbol;
440     uint8 private _decimals;
441 
442     /**
443      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
444      * a default value of 18.
445      *
446      * To select a different value for {decimals}, use {_setupDecimals}.
447      *
448      * All three of these values are immutable: they can only be set once during
449      * construction.
450      */
451     constructor (string memory name, string memory symbol) public {
452         _name = name;
453         _symbol = symbol;
454         _decimals = 18;
455     }
456 
457     /**
458      * @dev Returns the name of the token.
459      */
460     function name() public view returns (string memory) {
461         return _name;
462     }
463 
464     /**
465      * @dev Returns the symbol of the token, usually a shorter version of the
466      * name.
467      */
468     function symbol() public view returns (string memory) {
469         return _symbol;
470     }
471 
472     /**
473      * @dev Returns the number of decimals used to get its user representation.
474      * For example, if `decimals` equals `2`, a balance of `505` tokens should
475      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
476      *
477      * Tokens usually opt for a value of 18, imitating the relationship between
478      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
479      * called.
480      *
481      * NOTE: This information is only used for _display_ purposes: it in
482      * no way affects any of the arithmetic of the contract, including
483      * {IERC20-balanceOf} and {IERC20-transfer}.
484      */
485     function decimals() public view returns (uint8) {
486         return _decimals;
487     }
488 
489     /**
490      * @dev See {IERC20-totalSupply}.
491      */
492     function totalSupply() public view override returns (uint256) {
493         return _totalSupply;
494     }
495 
496     /**
497      * @dev See {IERC20-balanceOf}.
498      */
499     function balanceOf(address account) public view override returns (uint256) {
500         return _balances[account];
501     }
502 
503     /**
504      * @dev See {IERC20-transfer}.
505      *
506      * Requirements:
507      *
508      * - `recipient` cannot be the zero address.
509      * - the caller must have a balance of at least `amount`.
510      */
511     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
512         _transfer(_msgSender(), recipient, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-allowance}.
518      */
519     function allowance(address owner, address spender) public view virtual override returns (uint256) {
520         return _allowances[owner][spender];
521     }
522 
523     /**
524      * @dev See {IERC20-approve}.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      */
530     function approve(address spender, uint256 amount) public virtual override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-transferFrom}.
537      *
538      * Emits an {Approval} event indicating the updated allowance. This is not
539      * required by the EIP. See the note at the beginning of {ERC20};
540      *
541      * Requirements:
542      * - `sender` and `recipient` cannot be the zero address.
543      * - `sender` must have a balance of at least `amount`.
544      * - the caller must have allowance for ``sender``'s tokens of at least
545      * `amount`.
546      */
547     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
548         _transfer(sender, recipient, amount);
549         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
550         return true;
551     }
552 
553     /**
554      * @dev Atomically increases the allowance granted to `spender` by the caller.
555      *
556      * This is an alternative to {approve} that can be used as a mitigation for
557      * problems described in {IERC20-approve}.
558      *
559      * Emits an {Approval} event indicating the updated allowance.
560      *
561      * Requirements:
562      *
563      * - `spender` cannot be the zero address.
564      */
565     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
566         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
567         return true;
568     }
569 
570     /**
571      * @dev Atomically decreases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      * - `spender` must have allowance for the caller of at least
582      * `subtractedValue`.
583      */
584     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
586         return true;
587     }
588 
589     /**
590      * @dev Moves tokens `amount` from `sender` to `recipient`.
591      *
592      * This is internal function is equivalent to {transfer}, and can be used to
593      * e.g. implement automatic token fees, slashing mechanisms, etc.
594      *
595      * Emits a {Transfer} event.
596      *
597      * Requirements:
598      *
599      * - `sender` cannot be the zero address.
600      * - `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      */
603     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
604         require(sender != address(0), "ERC20: transfer from the zero address");
605         require(recipient != address(0), "ERC20: transfer to the zero address");
606 
607         _beforeTokenTransfer(sender, recipient, amount);
608 
609         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
610         _balances[recipient] = _balances[recipient].add(amount);
611         emit Transfer(sender, recipient, amount);
612     }
613 
614     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
615      * the total supply.
616      *
617      * Emits a {Transfer} event with `from` set to the zero address.
618      *
619      * Requirements
620      *
621      * - `to` cannot be the zero address.
622      */
623     function _mint(address account, uint256 amount) internal virtual {
624         require(account != address(0), "ERC20: mint to the zero address");
625 
626         _beforeTokenTransfer(address(0), account, amount);
627 
628         _totalSupply = _totalSupply.add(amount);
629         _balances[account] = _balances[account].add(amount);
630         emit Transfer(address(0), account, amount);
631     }
632 
633     /**
634      * @dev Destroys `amount` tokens from `account`, reducing the
635      * total supply.
636      *
637      * Emits a {Transfer} event with `to` set to the zero address.
638      *
639      * Requirements
640      *
641      * - `account` cannot be the zero address.
642      * - `account` must have at least `amount` tokens.
643      */
644     function _burn(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: burn from the zero address");
646 
647         _beforeTokenTransfer(account, address(0), amount);
648 
649         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
650         _totalSupply = _totalSupply.sub(amount);
651         emit Transfer(account, address(0), amount);
652     }
653 
654     /**
655      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
656      *
657      * This is internal function is equivalent to `approve`, and can be used to
658      * e.g. set automatic allowances for certain subsystems, etc.
659      *
660      * Emits an {Approval} event.
661      *
662      * Requirements:
663      *
664      * - `owner` cannot be the zero address.
665      * - `spender` cannot be the zero address.
666      */
667     function _approve(address owner, address spender, uint256 amount) internal virtual {
668         require(owner != address(0), "ERC20: approve from the zero address");
669         require(spender != address(0), "ERC20: approve to the zero address");
670 
671         _allowances[owner][spender] = amount;
672         emit Approval(owner, spender, amount);
673     }
674 
675     /**
676      * @dev Sets {decimals} to a value other than the default one of 18.
677      *
678      * WARNING: This function should only be called from the constructor. Most
679      * applications that interact with token contracts will not expect
680      * {decimals} to ever change, and may work incorrectly if it does.
681      */
682     function _setupDecimals(uint8 decimals_) internal {
683         _decimals = decimals_;
684     }
685 
686     /**
687      * @dev Hook that is called before any transfer of tokens. This includes
688      * minting and burning.
689      *
690      * Calling conditions:
691      *
692      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
693      * will be to transferred to `to`.
694      * - when `from` is zero, `amount` tokens will be minted for `to`.
695      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
696      * - `from` and `to` are never both zero.
697      *
698      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
699      */
700     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
701 }
702 
703 contract TokenRecover is Ownable {
704 
705     /**
706      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
707      * @param tokenAddress The token contract address
708      * @param tokenAmount Number of tokens to be sent
709      */
710     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
711         IERC20(tokenAddress).transfer(owner(), tokenAmount);
712     }
713 }
714 
715 abstract contract ERC20Burnable is Context, ERC20 {
716  
717     function burn(uint256 amount) public virtual {
718         _burn(_msgSender(), amount);
719     }
720 
721     function burnFrom(address account, uint256 amount) public virtual {
722         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
723 
724         _approve(account, _msgSender(), decreasedAllowance);
725         _burn(account, amount);
726     }
727 }
728 
729 interface IERC165 {
730 
731     function supportsInterface(bytes4 interfaceId) external view returns (bool);
732 }
733 
734 contract ERC165 is IERC165 {
735     /*
736      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
737      */
738     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
739 
740     /**
741      * @dev Mapping of interface ids to whether or not it's supported.
742      */
743     mapping(bytes4 => bool) private _supportedInterfaces;
744 
745     constructor () internal {
746         // Derived contracts need only register support for their own interfaces,
747         // we register support for ERC165 itself here
748         _registerInterface(_INTERFACE_ID_ERC165);
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      *
754      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
755      */
756     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
757         return _supportedInterfaces[interfaceId];
758     }
759 
760     /**
761      * @dev Registers the contract as an implementer of the interface defined by
762      * `interfaceId`. Support of the actual ERC165 interface is automatic and
763      * registering its interface id is not required.
764      *
765      * See {IERC165-supportsInterface}.
766      *
767      * Requirements:
768      *
769      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
770      */
771     function _registerInterface(bytes4 interfaceId) internal virtual {
772         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
773         _supportedInterfaces[interfaceId] = true;
774     }
775 }
776 
777 interface IERC1363 is IERC20, IERC165 {
778 
779 
780     function transferAndCall(address to, uint256 value) external returns (bool);
781 
782     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
783 
784     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
785 
786     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
787 
788     function approveAndCall(address spender, uint256 value) external returns (bool);
789 
790     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
791 }
792 
793 contract Roles is AccessControl {
794 
795     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
796     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
797 
798     constructor () public {
799         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
800         _setupRole(MINTER_ROLE, _msgSender());
801         _setupRole(OPERATOR_ROLE, _msgSender());
802     }
803 
804     modifier onlyMinter() {
805         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
806         _;
807     }
808 
809     modifier onlyOperator() {
810         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
811         _;
812     }
813 }
814 
815 interface IERC1363Receiver {
816 
817     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
818 }
819 
820 interface IERC1363Spender {
821     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
822 }
823 
824 
825 contract ERC1363 is ERC20, IERC1363, ERC165 {
826     using Address for address;
827 
828     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
829 
830     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
831 
832     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
833 
834     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
835 
836     constructor (
837         string memory name,
838         string memory symbol
839     ) public payable ERC20(name, symbol) {
840         // register the supported interfaces to conform to ERC1363 via ERC165
841         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
842         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
843     }
844 
845     function transferAndCall(address to, uint256 value) public override returns (bool) {
846         return transferAndCall(to, value, "");
847     }
848 
849     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
850         transfer(to, value);
851         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
852         return true;
853     }
854 
855     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
856         return transferFromAndCall(from, to, value, "");
857     }
858 
859     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
860         transferFrom(from, to, value);
861         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
862         return true;
863     }
864 
865     function approveAndCall(address spender, uint256 value) public override returns (bool) {
866         return approveAndCall(spender, value, "");
867     }
868 
869     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
870         approve(spender, value);
871         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
872         return true;
873     }
874 
875     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
876         if (!to.isContract()) {
877             return false;
878         }
879         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
880             _msgSender(), from, value, data
881         );
882         return (retval == _ERC1363_RECEIVED);
883     }
884 
885     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
886         if (!spender.isContract()) {
887             return false;
888         }
889         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
890             _msgSender(), value, data
891         );
892         return (retval == _ERC1363_APPROVED);
893     }
894 }
895 
896 
897 abstract contract ERC20Capped is ERC20 {
898     uint256 private _cap;
899 
900     /**
901      * @dev Sets the value of the `cap`. This value is immutable, it can only be
902      * set once during construction.
903      */
904     constructor (uint256 cap) public {
905         require(cap > 0, "ERC20Capped: cap is 0");
906         _cap = cap;
907     }
908 
909     /**
910      * @dev Returns the cap on the token's total supply.
911      */
912     function cap() public view returns (uint256) {
913         return _cap;
914     }
915 
916     /**
917      * @dev See {ERC20-_beforeTokenTransfer}.
918      *
919      * Requirements:
920      *
921      * - minted tokens must not cause the total supply to go over the cap.
922      */
923     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
924         super._beforeTokenTransfer(from, to, amount);
925 
926         if (from == address(0)) { // When minting tokens
927             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
928         }
929     }
930 }
931 
932 
933 /**
934  * @title RevomonToken
935  * @author RevomonToken (https://github.com/RevomonVR/Contracts)
936  */
937 contract RevomonToken is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
938 
939     constructor(
940         string memory name,
941         string memory symbol,
942         uint8 decimals,
943         uint256 cap,
944         uint256 initialSupply) public ERC20Capped(cap) ERC1363(name, symbol) {
945         
946         require(cap == initialSupply, "RevomonToken: cap must be equal to initialSupply");
947 
948         _setupDecimals(decimals);
949 
950         if (initialSupply > 0) {
951             _mint(owner(), initialSupply);
952         }
953     }
954 
955 
956     /**
957      * Transfer tokens to a specified address.
958      * @param to The address to transfer to
959      * @param value The amount to be transferred
960      * @return A boolean that indicates if the operation was successful.
961      */
962     function transfer(address to, uint256 value) public virtual override(ERC20) returns (bool) {
963         return super.transfer(to, value);
964     }
965 
966     /**
967      * Transfer tokens from one address to another.
968      * @param from The address which you want to send tokens from
969      * @param to The address which you want to transfer to
970      * @param value the amount of tokens to be transferred
971      * @return A boolean that indicates if the operation was successful.
972      */
973     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) returns (bool) {
974         return super.transferFrom(from, to, value);
975     }
976 
977     /**
978      * See {ERC20-_beforeTokenTransfer}.
979      */
980     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
981         super._beforeTokenTransfer(from, to, amount);
982     }
983 }