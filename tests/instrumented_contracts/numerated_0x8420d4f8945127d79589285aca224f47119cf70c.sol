1 // File: contracts\AddrArrayLib.sol
2 
3 /*
4   Unless required by applicable law or agreed to in writing, software
5   distributed under the License is distributed on an "AS IS" BASIS,
6   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
7   See the License for the specific language governing permissions and
8   limitations under the License.
9 */
10 
11 pragma solidity >=0.4.21 <0.7.0;
12 
13 library AddrArrayLib {
14     using AddrArrayLib for Addresses;
15 
16     struct Addresses {
17       address[]  _items;
18     }
19 
20     /**
21      * @notice push an address to the array
22      * @dev if the address already exists, it will not be added again
23      * @param self Storage array containing address type variables
24      * @param element the element to add in the array
25      */
26     function pushAddress(Addresses storage self, address element) internal {
27       if (!exists(self, element)) {
28         self._items.push(element);
29       }
30     }
31 
32     /**
33      * @notice remove an address from the array
34      * @dev finds the element, swaps it with the last element, and then deletes it;
35      *      returns a boolean whether the element was found and deleted
36      * @param self Storage array containing address type variables
37      * @param element the element to remove from the array
38      */
39     function removeAddress(Addresses storage self, address element) internal returns (bool) {
40         for (uint i = 0; i < self.size(); i++) {
41             if (self._items[i] == element) {
42                 self._items[i] = self._items[self.size() - 1];
43                 self._items.pop();
44                 return true;
45             }
46         }
47         return false;
48     }
49 
50     /**
51      * @notice get the address at a specific index from array
52      * @dev revert if the index is out of bounds
53      * @param self Storage array containing address type variables
54      * @param index the index in the array
55      */
56     function getAddressAtIndex(Addresses storage self, uint256 index) internal view returns (address) {
57         require(index < size(self), "the index is out of bounds");
58         return self._items[index];
59     }
60 
61     /**
62      * @notice get the size of the array
63      * @param self Storage array containing address type variables
64      */
65     function size(Addresses storage self) internal view returns (uint256) {
66       return self._items.length;
67     }
68 
69     /**
70      * @notice check if an element exist in the array
71      * @param self Storage array containing address type variables
72      * @param element the element to check if it exists in the array
73      */
74     function exists(Addresses storage self, address element) internal view returns (bool) {
75         for (uint i = 0; i < self.size(); i++) {
76             if (self._items[i] == element) {
77                 return true;
78             }
79         }
80         return false;
81     }
82 
83     /**
84      * @notice get the array
85      * @param self Storage array containing address type variables
86      */
87     function getAllAddresses(Addresses storage self) internal view returns(address[] memory) {
88         return self._items;
89     }
90 
91 }
92 
93 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
94 
95 pragma solidity ^0.6.0;
96 
97 /*
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with GSN meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 contract Context {
108     // Empty internal constructor, to prevent people from mistakenly deploying
109     // an instance of this contract, which should be used via inheritance.
110     constructor () internal { }
111 
112     function _msgSender() internal view virtual returns (address payable) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes memory) {
117         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
118         return msg.data;
119     }
120 }
121 
122 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
123 
124 pragma solidity ^0.6.0;
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
201 
202 pragma solidity ^0.6.0;
203 
204 /**
205  * @dev Wrappers over Solidity's arithmetic operations with added overflow
206  * checks.
207  *
208  * Arithmetic operations in Solidity wrap on overflow. This can easily result
209  * in bugs, because programmers usually assume that an overflow raises an
210  * error, which is the standard behavior in high level programming languages.
211  * `SafeMath` restores this intuition by reverting the transaction when an
212  * operation overflows.
213  *
214  * Using this library instead of the unchecked operations eliminates an entire
215  * class of bugs, so it's recommended to use it always.
216  */
217 library SafeMath {
218     /**
219      * @dev Returns the addition of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `+` operator.
223      *
224      * Requirements:
225      * - Addition cannot overflow.
226      */
227     function add(uint256 a, uint256 b) internal pure returns (uint256) {
228         uint256 c = a + b;
229         require(c >= a, "SafeMath: addition overflow");
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting on
236      * overflow (when the result is negative).
237      *
238      * Counterpart to Solidity's `-` operator.
239      *
240      * Requirements:
241      * - Subtraction cannot overflow.
242      */
243     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244         return sub(a, b, "SafeMath: subtraction overflow");
245     }
246 
247     /**
248      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
249      * overflow (when the result is negative).
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      * - Subtraction cannot overflow.
255      */
256     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b <= a, errorMessage);
258         uint256 c = a - b;
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `*` operator.
268      *
269      * Requirements:
270      * - Multiplication cannot overflow.
271      */
272     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
273         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
274         // benefit is lost if 'b' is also tested.
275         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
276         if (a == 0) {
277             return 0;
278         }
279 
280         uint256 c = a * b;
281         require(c / a == b, "SafeMath: multiplication overflow");
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b) internal pure returns (uint256) {
298         return div(a, b, "SafeMath: division by zero");
299     }
300 
301     /**
302      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
303      * division by zero. The result is rounded towards zero.
304      *
305      * Counterpart to Solidity's `/` operator. Note: this function uses a
306      * `revert` opcode (which leaves remaining gas untouched) while Solidity
307      * uses an invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         // Solidity only automatically asserts when dividing by 0
314         require(b > 0, errorMessage);
315         uint256 c = a / b;
316         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * Reverts when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         return mod(a, b, "SafeMath: modulo by zero");
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts with custom message when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      * - The divisor cannot be zero.
346      */
347     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
348         require(b != 0, errorMessage);
349         return a % b;
350     }
351 }
352 
353 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
354 
355 pragma solidity ^0.6.2;
356 
357 /**
358  * @dev Collection of functions related to the address type
359  */
360 library Address {
361     /**
362      * @dev Returns true if `account` is a contract.
363      *
364      * [IMPORTANT]
365      * ====
366      * It is unsafe to assume that an address for which this function returns
367      * false is an externally-owned account (EOA) and not a contract.
368      *
369      * Among others, `isContract` will return false for the following
370      * types of addresses:
371      *
372      *  - an externally-owned account
373      *  - a contract in construction
374      *  - an address where a contract will be created
375      *  - an address where a contract lived, but was destroyed
376      * ====
377      */
378     function isContract(address account) internal view returns (bool) {
379         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
380         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
381         // for accounts without code, i.e. `keccak256('')`
382         bytes32 codehash;
383         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
384         // solhint-disable-next-line no-inline-assembly
385         assembly { codehash := extcodehash(account) }
386         return (codehash != accountHash && codehash != 0x0);
387     }
388 
389     /**
390      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
391      * `recipient`, forwarding all available gas and reverting on errors.
392      *
393      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
394      * of certain opcodes, possibly making contracts go over the 2300 gas limit
395      * imposed by `transfer`, making them unable to receive funds via
396      * `transfer`. {sendValue} removes this limitation.
397      *
398      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
399      *
400      * IMPORTANT: because control is transferred to `recipient`, care must be
401      * taken to not create reentrancy vulnerabilities. Consider using
402      * {ReentrancyGuard} or the
403      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
404      */
405     function sendValue(address payable recipient, uint256 amount) internal {
406         require(address(this).balance >= amount, "Address: insufficient balance");
407 
408         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
409         (bool success, ) = recipient.call{ value: amount }("");
410         require(success, "Address: unable to send value, recipient may have reverted");
411     }
412 }
413 
414 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
415 
416 pragma solidity ^0.6.0;
417 
418 
419 
420 
421 
422 /**
423  * @dev Implementation of the {IERC20} interface.
424  *
425  * This implementation is agnostic to the way tokens are created. This means
426  * that a supply mechanism has to be added in a derived contract using {_mint}.
427  * For a generic mechanism see {ERC20MinterPauser}.
428  *
429  * TIP: For a detailed writeup see our guide
430  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
431  * to implement supply mechanisms].
432  *
433  * We have followed general OpenZeppelin guidelines: functions revert instead
434  * of returning `false` on failure. This behavior is nonetheless conventional
435  * and does not conflict with the expectations of ERC20 applications.
436  *
437  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
438  * This allows applications to reconstruct the allowance for all accounts just
439  * by listening to said events. Other implementations of the EIP may not emit
440  * these events, as it isn't required by the specification.
441  *
442  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
443  * functions have been added to mitigate the well-known issues around setting
444  * allowances. See {IERC20-approve}.
445  */
446 contract ERC20 is Context, IERC20 {
447     using SafeMath for uint256;
448     using Address for address;
449 
450     mapping (address => uint256) private _balances;
451 
452     mapping (address => mapping (address => uint256)) private _allowances;
453 
454     uint256 private _totalSupply;
455 
456     string private _name;
457     string private _symbol;
458     uint8 private _decimals;
459 
460     /**
461      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
462      * a default value of 18.
463      *
464      * To select a different value for {decimals}, use {_setupDecimals}.
465      *
466      * All three of these values are immutable: they can only be set once during
467      * construction.
468      */
469     constructor (string memory name, string memory symbol) public {
470         _name = name;
471         _symbol = symbol;
472         _decimals = 18;
473     }
474 
475     /**
476      * @dev Returns the name of the token.
477      */
478     function name() public view returns (string memory) {
479         return _name;
480     }
481 
482     /**
483      * @dev Returns the symbol of the token, usually a shorter version of the
484      * name.
485      */
486     function symbol() public view returns (string memory) {
487         return _symbol;
488     }
489 
490     /**
491      * @dev Returns the number of decimals used to get its user representation.
492      * For example, if `decimals` equals `2`, a balance of `505` tokens should
493      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
494      *
495      * Tokens usually opt for a value of 18, imitating the relationship between
496      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
497      * called.
498      *
499      * NOTE: This information is only used for _display_ purposes: it in
500      * no way affects any of the arithmetic of the contract, including
501      * {IERC20-balanceOf} and {IERC20-transfer}.
502      */
503     function decimals() public view returns (uint8) {
504         return _decimals;
505     }
506 
507     /**
508      * @dev See {IERC20-totalSupply}.
509      */
510     function totalSupply() public view override returns (uint256) {
511         return _totalSupply;
512     }
513 
514     /**
515      * @dev See {IERC20-balanceOf}.
516      */
517     function balanceOf(address account) public view override returns (uint256) {
518         return _balances[account];
519     }
520 
521     /**
522      * @dev See {IERC20-transfer}.
523      *
524      * Requirements:
525      *
526      * - `recipient` cannot be the zero address.
527      * - the caller must have a balance of at least `amount`.
528      */
529     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
530         _transfer(_msgSender(), recipient, amount);
531         return true;
532     }
533 
534     /**
535      * @dev See {IERC20-allowance}.
536      */
537     function allowance(address owner, address spender) public view virtual override returns (uint256) {
538         return _allowances[owner][spender];
539     }
540 
541     /**
542      * @dev See {IERC20-approve}.
543      *
544      * Requirements:
545      *
546      * - `spender` cannot be the zero address.
547      */
548     function approve(address spender, uint256 amount) public virtual override returns (bool) {
549         _approve(_msgSender(), spender, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-transferFrom}.
555      *
556      * Emits an {Approval} event indicating the updated allowance. This is not
557      * required by the EIP. See the note at the beginning of {ERC20};
558      *
559      * Requirements:
560      * - `sender` and `recipient` cannot be the zero address.
561      * - `sender` must have a balance of at least `amount`.
562      * - the caller must have allowance for ``sender``'s tokens of at least
563      * `amount`.
564      */
565     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
566         _transfer(sender, recipient, amount);
567         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
568         return true;
569     }
570 
571     /**
572      * @dev Atomically increases the allowance granted to `spender` by the caller.
573      *
574      * This is an alternative to {approve} that can be used as a mitigation for
575      * problems described in {IERC20-approve}.
576      *
577      * Emits an {Approval} event indicating the updated allowance.
578      *
579      * Requirements:
580      *
581      * - `spender` cannot be the zero address.
582      */
583     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
584         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
585         return true;
586     }
587 
588     /**
589      * @dev Atomically decreases the allowance granted to `spender` by the caller.
590      *
591      * This is an alternative to {approve} that can be used as a mitigation for
592      * problems described in {IERC20-approve}.
593      *
594      * Emits an {Approval} event indicating the updated allowance.
595      *
596      * Requirements:
597      *
598      * - `spender` cannot be the zero address.
599      * - `spender` must have allowance for the caller of at least
600      * `subtractedValue`.
601      */
602     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
603         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
604         return true;
605     }
606 
607     /**
608      * @dev Moves tokens `amount` from `sender` to `recipient`.
609      *
610      * This is internal function is equivalent to {transfer}, and can be used to
611      * e.g. implement automatic token fees, slashing mechanisms, etc.
612      *
613      * Emits a {Transfer} event.
614      *
615      * Requirements:
616      *
617      * - `sender` cannot be the zero address.
618      * - `recipient` cannot be the zero address.
619      * - `sender` must have a balance of at least `amount`.
620      */
621     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
622         require(sender != address(0), "ERC20: transfer from the zero address");
623         require(recipient != address(0), "ERC20: transfer to the zero address");
624 
625         _beforeTokenTransfer(sender, recipient, amount);
626 
627         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
628         _balances[recipient] = _balances[recipient].add(amount);
629         emit Transfer(sender, recipient, amount);
630     }
631 
632     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
633      * the total supply.
634      *
635      * Emits a {Transfer} event with `from` set to the zero address.
636      *
637      * Requirements
638      *
639      * - `to` cannot be the zero address.
640      */
641     function _mint(address account, uint256 amount) internal virtual {
642         require(account != address(0), "ERC20: mint to the zero address");
643 
644         _beforeTokenTransfer(address(0), account, amount);
645 
646         _totalSupply = _totalSupply.add(amount);
647         _balances[account] = _balances[account].add(amount);
648         emit Transfer(address(0), account, amount);
649     }
650 
651     /**
652      * @dev Destroys `amount` tokens from `account`, reducing the
653      * total supply.
654      *
655      * Emits a {Transfer} event with `to` set to the zero address.
656      *
657      * Requirements
658      *
659      * - `account` cannot be the zero address.
660      * - `account` must have at least `amount` tokens.
661      */
662     function _burn(address account, uint256 amount) internal virtual {
663         require(account != address(0), "ERC20: burn from the zero address");
664 
665         _beforeTokenTransfer(account, address(0), amount);
666 
667         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
668         _totalSupply = _totalSupply.sub(amount);
669         emit Transfer(account, address(0), amount);
670     }
671 
672     /**
673      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
674      *
675      * This is internal function is equivalent to `approve`, and can be used to
676      * e.g. set automatic allowances for certain subsystems, etc.
677      *
678      * Emits an {Approval} event.
679      *
680      * Requirements:
681      *
682      * - `owner` cannot be the zero address.
683      * - `spender` cannot be the zero address.
684      */
685     function _approve(address owner, address spender, uint256 amount) internal virtual {
686         require(owner != address(0), "ERC20: approve from the zero address");
687         require(spender != address(0), "ERC20: approve to the zero address");
688 
689         _allowances[owner][spender] = amount;
690         emit Approval(owner, spender, amount);
691     }
692 
693     /**
694      * @dev Sets {decimals} to a value other than the default one of 18.
695      *
696      * WARNING: This function should only be called from the constructor. Most
697      * applications that interact with token contracts will not expect
698      * {decimals} to ever change, and may work incorrectly if it does.
699      */
700     function _setupDecimals(uint8 decimals_) internal {
701         _decimals = decimals_;
702     }
703 
704     /**
705      * @dev Hook that is called before any transfer of tokens. This includes
706      * minting and burning.
707      *
708      * Calling conditions:
709      *
710      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
711      * will be to transferred to `to`.
712      * - when `from` is zero, `amount` tokens will be minted for `to`.
713      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
714      * - `from` and `to` are never both zero.
715      *
716      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
717      */
718     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
719 }
720 
721 // File: node_modules\@openzeppelin\contracts\utils\Pausable.sol
722 
723 pragma solidity ^0.6.0;
724 
725 
726 /**
727  * @dev Contract module which allows children to implement an emergency stop
728  * mechanism that can be triggered by an authorized account.
729  *
730  * This module is used through inheritance. It will make available the
731  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
732  * the functions of your contract. Note that they will not be pausable by
733  * simply including this module, only once the modifiers are put in place.
734  */
735 contract Pausable is Context {
736     /**
737      * @dev Emitted when the pause is triggered by `account`.
738      */
739     event Paused(address account);
740 
741     /**
742      * @dev Emitted when the pause is lifted by `account`.
743      */
744     event Unpaused(address account);
745 
746     bool private _paused;
747 
748     /**
749      * @dev Initializes the contract in unpaused state.
750      */
751     constructor () internal {
752         _paused = false;
753     }
754 
755     /**
756      * @dev Returns true if the contract is paused, and false otherwise.
757      */
758     function paused() public view returns (bool) {
759         return _paused;
760     }
761 
762     /**
763      * @dev Modifier to make a function callable only when the contract is not paused.
764      */
765     modifier whenNotPaused() {
766         require(!_paused, "Pausable: paused");
767         _;
768     }
769 
770     /**
771      * @dev Modifier to make a function callable only when the contract is paused.
772      */
773     modifier whenPaused() {
774         require(_paused, "Pausable: not paused");
775         _;
776     }
777 
778     /**
779      * @dev Triggers stopped state.
780      */
781     function _pause() internal virtual whenNotPaused {
782         _paused = true;
783         emit Paused(_msgSender());
784     }
785 
786     /**
787      * @dev Returns to normal state.
788      */
789     function _unpause() internal virtual whenPaused {
790         _paused = false;
791         emit Unpaused(_msgSender());
792     }
793 }
794 
795 // File: @openzeppelin\contracts\token\ERC20\ERC20Pausable.sol
796 
797 pragma solidity ^0.6.0;
798 
799 
800 
801 /**
802  * @dev ERC20 token with pausable token transfers, minting and burning.
803  *
804  * Useful for scenarios such as preventing trades until the end of an evaluation
805  * period, or having an emergency switch for freezing all token transfers in the
806  * event of a large bug.
807  */
808 abstract contract ERC20Pausable is ERC20, Pausable {
809     /**
810      * @dev See {ERC20-_beforeTokenTransfer}.
811      *
812      * Requirements:
813      *
814      * - the contract must not be paused.
815      */
816     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
817         super._beforeTokenTransfer(from, to, amount);
818 
819         require(!paused(), "ERC20Pausable: token transfer while paused");
820     }
821 }
822 
823 // File: contracts\MHLKC.sol
824 
825 pragma solidity >=0.4.21 <0.7.0;
826 
827 
828 
829 contract MHLKC is ERC20Pausable {
830     using AddrArrayLib for AddrArrayLib.Addresses;
831 
832     address private contractCreator;
833 
834     // List of trusted addresses which can mint tokens
835     AddrArrayLib.Addresses untrustedAddress;
836 
837     constructor () ERC20("Maharlika Crypto","MHLK-IRM") public {
838         _setupDecimals(2);
839         contractCreator = msg.sender;
840     }
841 
842     modifier ownerOnly() {
843         require(msg.sender == contractCreator, "This function could only be executed by the owner");
844         _;
845     }
846 
847     function mint(uint256 numberofToken) public ownerOnly(){
848         require((_msgSender()==contractCreator),"Not the contract creator");
849          _mint(contractCreator, numberofToken);
850     }
851 
852     function burn(uint256 amount) public {
853         require((balanceOf(_msgSender())>=amount),"does not have enough tokens");
854         require(!untrustedAddress.exists(_msgSender()),"Sender Blocked");
855         _burn(_msgSender(),amount);
856     }
857 
858     function transfer(address recipient, uint256 amount) public override returns (bool) {
859         require((balanceOf(_msgSender())>=amount),"does not have enough tokens");
860         require(!untrustedAddress.exists(_msgSender()),"Sender Blocked");
861         require(!untrustedAddress.exists(recipient),"Sender Blocked");
862         
863         _transfer(_msgSender(), recipient, amount);
864 
865          return true;
866     }
867 
868     function bulkTransfer(address[] memory _addresses,uint256 amount) public returns(uint256){
869         require((_addresses.length>0),"Empty list of addresses");
870         require((_addresses.length <= 32),"addresses more then 32");
871         require((balanceOf(_msgSender())>=(amount*_addresses.length)),"does not have enough tokens");
872         require(!untrustedAddress.exists(_msgSender()),"Sender Blocked");
873 
874         uint256 transferedAmount = 0;
875         for (uint i=0; i<_addresses.length; i++) {
876             if((_addresses[i] != address(0))&&(!untrustedAddress.exists(_addresses[i]))){
877               _transfer(_msgSender(), _addresses[i], amount);
878               transferedAmount += amount;
879             }
880         }
881 
882         return transferedAmount;
883     }
884 
885     function bulkAddressBlock(address[] memory _addresses) public ownerOnly() returns(uint256) {
886         require((_msgSender()==contractCreator),"Not the contract creator");
887 
888         for (uint i = 0; i<_addresses.length; i++) {
889             if(!untrustedAddress.exists(_addresses[i])){
890                 untrustedAddress.pushAddress(_addresses[i]);
891             }
892         }
893     }
894     function bulkAddressUnBlock(address[] memory _addresses) public ownerOnly() returns(uint256){
895         require((_msgSender()==contractCreator),"Not the contract creator");
896 
897         for (uint i = 0; i<_addresses.length; i++) {
898             untrustedAddress.removeAddress(_addresses[i]);
899         }
900     }
901 
902     function getUnBlockAddress() public ownerOnly() view returns(address[] memory) {
903         require((_msgSender()==contractCreator),"Not the contract creator");
904         return untrustedAddress.getAllAddresses();
905     }
906 
907     function pause() public ownerOnly(){
908         require((_msgSender()==contractCreator),"Not the contract creator");
909         super._pause();
910     }
911 
912      function unPause() public ownerOnly(){
913         require((_msgSender()==contractCreator),"Not the contract creator");
914         super._unpause();
915     }
916 }