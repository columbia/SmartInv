1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 
10 library SafeMath {
11     /**
12      * @dev Returns the addition of two unsigned integers, reverting on
13      * overflow.
14      *
15      * Counterpart to Solidity's `+` operator.
16      *
17      * Requirements:
18      * - Addition cannot overflow.
19      */
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26 
27     /**
28      * @dev Returns the subtraction of two unsigned integers, reverting on
29      * overflow (when the result is negative).
30      *
31      * Counterpart to Solidity's `-` operator.
32      *
33      * Requirements:
34      * - Subtraction cannot overflow.
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the multiplication of two unsigned integers, reverting on
58      * overflow.
59      *
60      * Counterpart to Solidity's `*` operator.
61      *
62      * Requirements:
63      * - Multiplication cannot overflow.
64      */
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
67         // benefit is lost if 'b' is also tested.
68         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
69         if (a == 0) {
70             return 0;
71         }
72 
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the integer division of two unsigned integers. Reverts on
81      * division by zero. The result is rounded towards zero.
82      *
83      * Counterpart to Solidity's `/` operator. Note: this function uses a
84      * `revert` opcode (which leaves remaining gas untouched) while Solidity
85      * uses an invalid opcode to revert (consuming all remaining gas).
86      *
87      * Requirements:
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      * - The divisor cannot be zero.
123      */
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         return mod(a, b, "SafeMath: modulo by zero");
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts with custom message when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 library Address {
146     /**
147      * @dev Returns true if `account` is a contract.
148      *
149      * [IMPORTANT]
150      * ====
151      * It is unsafe to assume that an address for which this function returns
152      * false is an externally-owned account (EOA) and not a contract.
153      *
154      * Among others, `isContract` will return false for the following
155      * types of addresses:
156      *
157      *  - an externally-owned account
158      *  - a contract in construction
159      *  - an address where a contract will be created
160      *  - an address where a contract lived, but was destroyed
161      * ====
162      */
163     function isContract(address account) internal view returns (bool) {
164         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
165         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
166         // for accounts without code, i.e. `keccak256('')`
167         bytes32 codehash;
168         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
169         // solhint-disable-next-line no-inline-assembly
170         assembly { codehash := extcodehash(account) }
171         return (codehash != accountHash && codehash != 0x0);
172     }
173 
174     /**
175      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
176      * `recipient`, forwarding all available gas and reverting on errors.
177      *
178      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
179      * of certain opcodes, possibly making contracts go over the 2300 gas limit
180      * imposed by `transfer`, making them unable to receive funds via
181      * `transfer`. {sendValue} removes this limitation.
182      *
183      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
184      *
185      * IMPORTANT: because control is transferred to `recipient`, care must be
186      * taken to not create reentrancy vulnerabilities. Consider using
187      * {ReentrancyGuard} or the
188      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
189      */
190     function sendValue(address payable recipient, uint256 amount) internal {
191         require(address(this).balance >= amount, "Address: insufficient balance");
192 
193         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
194         (bool success, ) = recipient.call{ value: amount }("");
195         require(success, "Address: unable to send value, recipient may have reverted");
196     }
197 }
198 /**
199  * @dev Implementation of the {IERC20} interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using {_mint}.
203  * For a generic mechanism see {ERC20MinterPauser}.
204  *
205  * TIP: For a detailed writeup see our guide
206  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
207  * to implement supply mechanisms].
208  *
209  * We have followed general OpenZeppelin guidelines: functions revert instead
210  * of returning `false` on failure. This behavior is nonetheless conventional
211  * and does not conflict with the expectations of ERC20 applications.
212  *
213  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
214  * This allows applications to reconstruct the allowance for all accounts just
215  * by listening to said events. Other implementations of the EIP may not emit
216  * these events, as it isn't required by the specification.
217  *
218  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
219  * functions have been added to mitigate the well-known issues around setting
220  * allowances. See {IERC20-approve}.
221  */
222  
223  interface IERC20 {
224     /**
225      * @dev Returns the amount of tokens in existence.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns the amount of tokens owned by `account`.
231      */
232     function balanceOf(address account) external view returns (uint256);
233 
234     /**
235      * @dev Moves `amount` tokens from the caller's account to `recipient`.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transfer(address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Returns the remaining number of tokens that `spender` will be
245      * allowed to spend on behalf of `owner` through {transferFrom}. This is
246      * zero by default.
247      *
248      * This value changes when {approve} or {transferFrom} are called.
249      */
250     function allowance(address owner, address spender) external view returns (uint256);
251 
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * IMPORTANT: Beware that changing an allowance with this method brings the risk
258      * that someone may use both the old and the new allowance by unfortunate
259      * transaction ordering. One possible solution to mitigate this race
260      * condition is to first reduce the spender's allowance to 0 and set the
261      * desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Moves `amount` tokens from `sender` to `recipient` using the
270      * allowance mechanism. `amount` is then deducted from the caller's
271      * allowance.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Emitted when `value` tokens are moved from one account (`from`) to
281      * another (`to`).
282      *
283      * Note that `value` may be zero.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     /**
288      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
289      * a call to {approve}. `value` is the new allowance.
290      */
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293  
294  abstract contract Context {
295     function _msgSender() internal view virtual returns (address payable) {
296         return msg.sender;
297     }
298 
299     function _msgData() internal view virtual returns (bytes memory) {
300         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
301         return msg.data;
302     }
303 }
304 
305 
306 contract ERC20 is Context, IERC20 {
307     using SafeMath for uint256;
308     using Address for address;
309 
310     mapping (address => uint256) private _balances;
311 
312     mapping (address => mapping (address => uint256)) private _allowances;
313 
314     uint256 private _totalSupply;
315 
316     string private _name;
317     string private _symbol;
318     uint8 private _decimals;
319 
320     /**
321      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
322      * a default value of 18.
323      *
324      * To select a different value for {decimals}, use {_setupDecimals}.
325      *
326      * All three of these values are immutable: they can only be set once during
327      * construction.
328      */
329     constructor (string memory name, string memory symbol) public {
330         _name = name;
331         _symbol = symbol;
332         _decimals = 18;
333     }
334 
335     /**
336      * @dev Returns the name of the token.
337      */
338     function name() public view returns (string memory) {
339         return _name;
340     }
341 
342     /**
343      * @dev Returns the symbol of the token, usually a shorter version of the
344      * name.
345      */
346     function symbol() public view returns (string memory) {
347         return _symbol;
348     }
349 
350     /**
351      * @dev Returns the number of decimals used to get its user representation.
352      * For example, if `decimals` equals `2`, a balance of `505` tokens should
353      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
354      *
355      * Tokens usually opt for a value of 18, imitating the relationship between
356      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
357      * called.
358      *
359      * NOTE: This information is only used for _display_ purposes: it in
360      * no way affects any of the arithmetic of the contract, including
361      * {IERC20-balanceOf} and {IERC20-transfer}.
362      */
363     function decimals() public view returns (uint8) {
364         return _decimals;
365     }
366 
367     /**
368      * @dev See {IERC20-totalSupply}.
369      */
370     function totalSupply() public view override returns (uint256) {
371         return _totalSupply;
372     }
373 
374     /**
375      * @dev See {IERC20-balanceOf}.
376      */
377     function balanceOf(address account) public view override returns (uint256) {
378         return _balances[account];
379     }
380 
381     /**
382      * @dev See {IERC20-transfer}.
383      *
384      * Requirements:
385      *
386      * - `recipient` cannot be the zero address.
387      * - the caller must have a balance of at least `amount`.
388      */
389     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
390         _transfer(_msgSender(), recipient, amount);
391         return true;
392     }
393 
394     /**
395      * @dev See {IERC20-allowance}.
396      */
397     function allowance(address owner, address spender) public view virtual override returns (uint256) {
398         return _allowances[owner][spender];
399     }
400 
401     /**
402      * @dev See {IERC20-approve}.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      */
408     function approve(address spender, uint256 amount) public virtual override returns (bool) {
409         _approve(_msgSender(), spender, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-transferFrom}.
415      *
416      * Emits an {Approval} event indicating the updated allowance. This is not
417      * required by the EIP. See the note at the beginning of {ERC20};
418      *
419      * Requirements:
420      * - `sender` and `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      * - the caller must have allowance for ``sender``'s tokens of at least
423      * `amount`.
424      */
425     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
426         _transfer(sender, recipient, amount);
427         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
428         return true;
429     }
430 
431     /**
432      * @dev Atomically increases the allowance granted to `spender` by the caller.
433      *
434      * This is an alternative to {approve} that can be used as a mitigation for
435      * problems described in {IERC20-approve}.
436      *
437      * Emits an {Approval} event indicating the updated allowance.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      */
443     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
444         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
445         return true;
446     }
447 
448     /**
449      * @dev Atomically decreases the allowance granted to `spender` by the caller.
450      *
451      * This is an alternative to {approve} that can be used as a mitigation for
452      * problems described in {IERC20-approve}.
453      *
454      * Emits an {Approval} event indicating the updated allowance.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      * - `spender` must have allowance for the caller of at least
460      * `subtractedValue`.
461      */
462     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
463         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
464         return true;
465     }
466 
467     /**
468      * @dev Moves tokens `amount` from `sender` to `recipient`.
469      *
470      * This is internal function is equivalent to {transfer}, and can be used to
471      * e.g. implement automatic token fees, slashing mechanisms, etc.
472      *
473      * Emits a {Transfer} event.
474      *
475      * Requirements:
476      *
477      * - `sender` cannot be the zero address.
478      * - `recipient` cannot be the zero address.
479      * - `sender` must have a balance of at least `amount`.
480      */
481     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
482         require(sender != address(0), "ERC20: transfer from the zero address");
483         require(recipient != address(0), "ERC20: transfer to the zero address");
484 
485         _beforeTokenTransfer(sender, recipient, amount);
486 
487         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
488         _balances[recipient] = _balances[recipient].add(amount);
489         emit Transfer(sender, recipient, amount);
490     }
491 
492     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
493      * the total supply.
494      *
495      * Emits a {Transfer} event with `from` set to the zero address.
496      *
497      * Requirements
498      *
499      * - `to` cannot be the zero address.
500      */
501     function _mint(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: mint to the zero address");
503 
504         _beforeTokenTransfer(address(0), account, amount);
505 
506         _totalSupply = _totalSupply.add(amount);
507         _balances[account] = _balances[account].add(amount);
508         emit Transfer(address(0), account, amount);
509     }
510 
511     /**
512      * @dev Destroys `amount` tokens from `account`, reducing the
513      * total supply.
514      *
515      * Emits a {Transfer} event with `to` set to the zero address.
516      *
517      * Requirements
518      *
519      * - `account` cannot be the zero address.
520      * - `account` must have at least `amount` tokens.
521      */
522     function _burn(address account, uint256 amount) internal virtual {
523         require(account != address(0), "ERC20: burn from the zero address");
524 
525         _beforeTokenTransfer(account, address(0), amount);
526 
527         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
528         _totalSupply = _totalSupply.sub(amount);
529         emit Transfer(account, address(0), amount);
530     }
531 
532     /**
533      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
534      *
535      * This is internal function is equivalent to `approve`, and can be used to
536      * e.g. set automatic allowances for certain subsystems, etc.
537      *
538      * Emits an {Approval} event.
539      *
540      * Requirements:
541      *
542      * - `owner` cannot be the zero address.
543      * - `spender` cannot be the zero address.
544      */
545     function _approve(address owner, address spender, uint256 amount) internal virtual {
546         require(owner != address(0), "ERC20: approve from the zero address");
547         require(spender != address(0), "ERC20: approve to the zero address");
548 
549         _allowances[owner][spender] = amount;
550         emit Approval(owner, spender, amount);
551     }
552 
553     /**
554      * @dev Sets {decimals} to a value other than the default one of 18.
555      *
556      * WARNING: This function should only be called from the constructor. Most
557      * applications that interact with token contracts will not expect
558      * {decimals} to ever change, and may work incorrectly if it does.
559      */
560     function _setupDecimals(uint8 decimals_) internal {
561         _decimals = decimals_;
562     }
563 
564     /**
565      * @dev Hook that is called before any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * will be to transferred to `to`.
572      * - when `from` is zero, `amount` tokens will be minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
579 }
580 
581 contract UNITRADE is ERC20 {
582     constructor(uint256 initialSupply) ERC20("UniTrade", "TRADE") public {
583         _mint(msg.sender, initialSupply);
584     }
585 }