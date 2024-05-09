1 pragma solidity ^0.6.10;
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 contract Context {
19     // Empty internal constructor, to prevent people from mistakenly deploying
20     // an instance of this contract, which should be used via inheritance.
21     constructor () internal { }
22 
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      * - Subtraction cannot overflow.
149      */
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         return sub(a, b, "SafeMath: subtraction overflow");
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         // Solidity only automatically asserts when dividing by 0
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 }
318 
319 
320 /**
321  * @dev Implementation of the {IERC20} interface.
322  *
323  * This implementation is agnostic to the way tokens are created. This means
324  * that a supply mechanism has to be added in a derived contract using {_mint}.
325  * For a generic mechanism see {ERC20MinterPauser}.
326  *
327  * TIP: For a detailed writeup see our guide
328  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
329  * to implement supply mechanisms].
330  *
331  * We have followed general OpenZeppelin guidelines: functions revert instead
332  * of returning `false` on failure. This behavior is nonetheless conventional
333  * and does not conflict with the expectations of ERC20 applications.
334  *
335  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
336  * This allows applications to reconstruct the allowance for all accounts just
337  * by listening to said events. Other implementations of the EIP may not emit
338  * these events, as it isn't required by the specification.
339  *
340  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
341  * functions have been added to mitigate the well-known issues around setting
342  * allowances. See {IERC20-approve}.
343  */
344 contract ERC20 is Context, IERC20 {
345     using SafeMath for uint256;
346     using Address for address;
347 
348     mapping (address => uint256) private _balances;
349 
350     mapping (address => mapping (address => uint256)) private _allowances;
351 
352     uint256 private _totalSupply;
353 
354     string private _name;
355     string private _symbol;
356     uint8 private _decimals;
357 
358     /**
359      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
360      * a default value of 18.
361      *
362      * To select a different value for {decimals}, use {_setupDecimals}.
363      *
364      * All three of these values are immutable: they can only be set once during
365      * construction.
366      */
367     constructor (string memory name, string memory symbol) public {
368         _name = name;
369         _symbol = symbol;
370         _decimals = 18;
371     }
372 
373     /**
374      * @dev Returns the name of the token.
375      */
376     function name() public view returns (string memory) {
377         return _name;
378     }
379 
380     /**
381      * @dev Returns the symbol of the token, usually a shorter version of the
382      * name.
383      */
384     function symbol() public view returns (string memory) {
385         return _symbol;
386     }
387 
388     /**
389      * @dev Returns the number of decimals used to get its user representation.
390      * For example, if `decimals` equals `2`, a balance of `505` tokens should
391      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
392      *
393      * Tokens usually opt for a value of 18, imitating the relationship between
394      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
395      * called.
396      *
397      * NOTE: This information is only used for _display_ purposes: it in
398      * no way affects any of the arithmetic of the contract, including
399      * {IERC20-balanceOf} and {IERC20-transfer}.
400      */
401     function decimals() public view returns (uint8) {
402         return _decimals;
403     }
404 
405     /**
406      * @dev See {IERC20-totalSupply}.
407      */
408     function totalSupply() public view override returns (uint256) {
409         return _totalSupply;
410     }
411 
412     /**
413      * @dev See {IERC20-balanceOf}.
414      */
415     function balanceOf(address account) public view override returns (uint256) {
416         return _balances[account];
417     }
418 
419     /**
420      * @dev See {IERC20-transfer}.
421      *
422      * Requirements:
423      *
424      * - `recipient` cannot be the zero address.
425      * - the caller must have a balance of at least `amount`.
426      */
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-allowance}.
434      */
435     function allowance(address owner, address spender) public view virtual override returns (uint256) {
436         return _allowances[owner][spender];
437     }
438 
439     /**
440      * @dev See {IERC20-approve}.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function approve(address spender, uint256 amount) public virtual override returns (bool) {
447         _approve(_msgSender(), spender, amount);
448         return true;
449     }
450 
451     /**
452      * @dev See {IERC20-transferFrom}.
453      *
454      * Emits an {Approval} event indicating the updated allowance. This is not
455      * required by the EIP. See the note at the beginning of {ERC20};
456      *
457      * Requirements:
458      * - `sender` and `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      * - the caller must have allowance for ``sender``'s tokens of at least
461      * `amount`.
462      */
463     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
466         return true;
467     }
468 
469     /**
470      * @dev Atomically increases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      */
481     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
483         return true;
484     }
485 
486     /**
487      * @dev Atomically decreases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {IERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      * - `spender` must have allowance for the caller of at least
498      * `subtractedValue`.
499      */
500     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
502         return true;
503     }
504 
505     /**
506      * @dev Moves tokens `amount` from `sender` to `recipient`.
507      *
508      * This is internal function is equivalent to {transfer}, and can be used to
509      * e.g. implement automatic token fees, slashing mechanisms, etc.
510      *
511      * Emits a {Transfer} event.
512      *
513      * Requirements:
514      *
515      * - `sender` cannot be the zero address.
516      * - `recipient` cannot be the zero address.
517      * - `sender` must have a balance of at least `amount`.
518      */
519     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
520         require(sender != address(0), "ERC20: transfer from the zero address");
521         require(recipient != address(0), "ERC20: transfer to the zero address");
522 
523         _beforeTokenTransfer(sender, recipient, amount);
524 
525         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
526         _balances[recipient] = _balances[recipient].add(amount);
527         emit Transfer(sender, recipient, amount);
528     }
529 
530     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
531      * the total supply.
532      *
533      * Emits a {Transfer} event with `from` set to the zero address.
534      *
535      * Requirements
536      *
537      * - `to` cannot be the zero address.
538      */
539     function _mint(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: mint to the zero address");
541 
542         _beforeTokenTransfer(address(0), account, amount);
543 
544         _totalSupply = _totalSupply.add(amount);
545         _balances[account] = _balances[account].add(amount);
546         emit Transfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
566         _totalSupply = _totalSupply.sub(amount);
567         emit Transfer(account, address(0), amount);
568     }
569 
570     /**
571      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
572      *
573      * This is internal function is equivalent to `approve`, and can be used to
574      * e.g. set automatic allowances for certain subsystems, etc.
575      *
576      * Emits an {Approval} event.
577      *
578      * Requirements:
579      *
580      * - `owner` cannot be the zero address.
581      * - `spender` cannot be the zero address.
582      */
583     function _approve(address owner, address spender, uint256 amount) internal virtual {
584         require(owner != address(0), "ERC20: approve from the zero address");
585         require(spender != address(0), "ERC20: approve to the zero address");
586 
587         _allowances[owner][spender] = amount;
588         emit Approval(owner, spender, amount);
589     }
590 
591     /**
592      * @dev Sets {decimals} to a value other than the default one of 18.
593      *
594      * WARNING: This function should only be called from the constructor. Most
595      * applications that interact with token contracts will not expect
596      * {decimals} to ever change, and may work incorrectly if it does.
597      */
598     function _setupDecimals(uint8 decimals_) internal {
599         _decimals = decimals_;
600     }
601 
602     /**
603      * @dev Hook that is called before any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * will be to transferred to `to`.
610      * - when `from` is zero, `amount` tokens will be minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
617 }
618 
619 
620 contract SGToken is ERC20 {
621     constructor() ERC20("snglsDAO Governance Token", "SGT") public {
622         _mint(0x57e2AD2Fdb5Ae489B05112810fA10D949716C73F, 1000000000000000000000000000);
623     }
624 }