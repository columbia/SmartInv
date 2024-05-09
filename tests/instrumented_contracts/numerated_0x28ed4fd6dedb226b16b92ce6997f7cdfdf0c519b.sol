1 pragma solidity ^0.6.0;
2 // produced by the Solididy File Flattener (c) David Appleton 2018 - 2020 and beyond
3 // contact : calistralabs@gmail.com
4 // source  : https://github.com/DaveAppleton/SolidityFlattery
5 // released under Apache 2.0 licence
6 // input  /Users/ijonas/Downloads/Scotcoin/contracts/Scotcoin.sol
7 // flattened :  Tuesday, 27-Apr-21 10:11:50 UTC
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      * - Addition cannot overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Returns the subtraction of two unsigned integers, reverting on
27      * overflow (when the result is negative).
28      *
29      * Counterpart to Solidity's `-` operator.
30      *
31      * Requirements:
32      * - Subtraction cannot overflow.
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      * - The divisor cannot be zero.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         // Solidity only automatically asserts when dividing by 0
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts with custom message when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b != 0, errorMessage);
140         return a % b;
141     }
142 }
143 
144 library Address {
145     /**
146      * @dev Returns true if `account` is a contract.
147      *
148      * [IMPORTANT]
149      * ====
150      * It is unsafe to assume that an address for which this function returns
151      * false is an externally-owned account (EOA) and not a contract.
152      *
153      * Among others, `isContract` will return false for the following
154      * types of addresses:
155      *
156      *  - an externally-owned account
157      *  - a contract in construction
158      *  - an address where a contract will be created
159      *  - an address where a contract lived, but was destroyed
160      * ====
161      */
162     function isContract(address account) internal view returns (bool) {
163         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
164         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
165         // for accounts without code, i.e. `keccak256('')`
166         bytes32 codehash;
167         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
168         // solhint-disable-next-line no-inline-assembly
169         assembly { codehash := extcodehash(account) }
170         return (codehash != accountHash && codehash != 0x0);
171     }
172 
173     /**
174      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
175      * `recipient`, forwarding all available gas and reverting on errors.
176      *
177      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
178      * of certain opcodes, possibly making contracts go over the 2300 gas limit
179      * imposed by `transfer`, making them unable to receive funds via
180      * `transfer`. {sendValue} removes this limitation.
181      *
182      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
183      *
184      * IMPORTANT: because control is transferred to `recipient`, care must be
185      * taken to not create reentrancy vulnerabilities. Consider using
186      * {ReentrancyGuard} or the
187      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
188      */
189     function sendValue(address payable recipient, uint256 amount) internal {
190         require(address(this).balance >= amount, "Address: insufficient balance");
191 
192         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
193         (bool success, ) = recipient.call{ value: amount }("");
194         require(success, "Address: unable to send value, recipient may have reverted");
195     }
196 }
197 
198 contract Context {
199     // Empty internal constructor, to prevent people from mistakenly deploying
200     // an instance of this contract, which should be used via inheritance.
201     constructor () internal { }
202 
203     function _msgSender() internal view virtual returns (address payable) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes memory) {
208         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
209         return msg.data;
210     }
211 }
212 
213 interface IERC20 {
214     /**
215      * @dev Returns the amount of tokens in existence.
216      */
217     function totalSupply() external view returns (uint256);
218 
219     /**
220      * @dev Returns the amount of tokens owned by `account`.
221      */
222     function balanceOf(address account) external view returns (uint256);
223 
224     /**
225      * @dev Moves `amount` tokens from the caller's account to `recipient`.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transfer(address recipient, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Returns the remaining number of tokens that `spender` will be
235      * allowed to spend on behalf of `owner` through {transferFrom}. This is
236      * zero by default.
237      *
238      * This value changes when {approve} or {transferFrom} are called.
239      */
240     function allowance(address owner, address spender) external view returns (uint256);
241 
242     /**
243      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * IMPORTANT: Beware that changing an allowance with this method brings the risk
248      * that someone may use both the old and the new allowance by unfortunate
249      * transaction ordering. One possible solution to mitigate this race
250      * condition is to first reduce the spender's allowance to 0 and set the
251      * desired value afterwards:
252      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253      *
254      * Emits an {Approval} event.
255      */
256     function approve(address spender, uint256 amount) external returns (bool);
257 
258     /**
259      * @dev Moves `amount` tokens from `sender` to `recipient` using the
260      * allowance mechanism. `amount` is then deducted from the caller's
261      * allowance.
262      *
263      * Returns a boolean value indicating whether the operation succeeded.
264      *
265      * Emits a {Transfer} event.
266      */
267     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
268 
269     /**
270      * @dev Emitted when `value` tokens are moved from one account (`from`) to
271      * another (`to`).
272      *
273      * Note that `value` may be zero.
274      */
275     event Transfer(address indexed from, address indexed to, uint256 value);
276 
277     /**
278      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
279      * a call to {approve}. `value` is the new allowance.
280      */
281     event Approval(address indexed owner, address indexed spender, uint256 value);
282 }
283 
284 contract ERC20 is Context, IERC20 {
285     using SafeMath for uint256;
286     using Address for address;
287 
288     mapping (address => uint256) private _balances;
289 
290     mapping (address => mapping (address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     string private _name;
295     string private _symbol;
296     uint8 private _decimals;
297 
298     /**
299      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
300      * a default value of 18.
301      *
302      * To select a different value for {decimals}, use {_setupDecimals}.
303      *
304      * All three of these values are immutable: they can only be set once during
305      * construction.
306      */
307     constructor (string memory name, string memory symbol) public {
308         _name = name;
309         _symbol = symbol;
310         _decimals = 18;
311     }
312 
313     /**
314      * @dev Returns the name of the token.
315      */
316     function name() public view returns (string memory) {
317         return _name;
318     }
319 
320     /**
321      * @dev Returns the symbol of the token, usually a shorter version of the
322      * name.
323      */
324     function symbol() public view returns (string memory) {
325         return _symbol;
326     }
327 
328     /**
329      * @dev Returns the number of decimals used to get its user representation.
330      * For example, if `decimals` equals `2`, a balance of `505` tokens should
331      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
332      *
333      * Tokens usually opt for a value of 18, imitating the relationship between
334      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
335      * called.
336      *
337      * NOTE: This information is only used for _display_ purposes: it in
338      * no way affects any of the arithmetic of the contract, including
339      * {IERC20-balanceOf} and {IERC20-transfer}.
340      */
341     function decimals() public view returns (uint8) {
342         return _decimals;
343     }
344 
345     /**
346      * @dev See {IERC20-totalSupply}.
347      */
348     function totalSupply() public view override returns (uint256) {
349         return _totalSupply;
350     }
351 
352     /**
353      * @dev See {IERC20-balanceOf}.
354      */
355     function balanceOf(address account) public view override returns (uint256) {
356         return _balances[account];
357     }
358 
359     /**
360      * @dev See {IERC20-transfer}.
361      *
362      * Requirements:
363      *
364      * - `recipient` cannot be the zero address.
365      * - the caller must have a balance of at least `amount`.
366      */
367     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
368         _transfer(_msgSender(), recipient, amount);
369         return true;
370     }
371 
372     /**
373      * @dev See {IERC20-allowance}.
374      */
375     function allowance(address owner, address spender) public view virtual override returns (uint256) {
376         return _allowances[owner][spender];
377     }
378 
379     /**
380      * @dev See {IERC20-approve}.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function approve(address spender, uint256 amount) public virtual override returns (bool) {
387         _approve(_msgSender(), spender, amount);
388         return true;
389     }
390 
391     /**
392      * @dev See {IERC20-transferFrom}.
393      *
394      * Emits an {Approval} event indicating the updated allowance. This is not
395      * required by the EIP. See the note at the beginning of {ERC20};
396      *
397      * Requirements:
398      * - `sender` and `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `amount`.
400      * - the caller must have allowance for ``sender``'s tokens of at least
401      * `amount`.
402      */
403     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
404         _transfer(sender, recipient, amount);
405         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
406         return true;
407     }
408 
409     /**
410      * @dev Atomically increases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to {approve} that can be used as a mitigation for
413      * problems described in {IERC20-approve}.
414      *
415      * Emits an {Approval} event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      */
421     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
422         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
423         return true;
424     }
425 
426     /**
427      * @dev Atomically decreases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to {approve} that can be used as a mitigation for
430      * problems described in {IERC20-approve}.
431      *
432      * Emits an {Approval} event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      * - `spender` must have allowance for the caller of at least
438      * `subtractedValue`.
439      */
440     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
441         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
442         return true;
443     }
444 
445     /**
446      * @dev Moves tokens `amount` from `sender` to `recipient`.
447      *
448      * This is internal function is equivalent to {transfer}, and can be used to
449      * e.g. implement automatic token fees, slashing mechanisms, etc.
450      *
451      * Emits a {Transfer} event.
452      *
453      * Requirements:
454      *
455      * - `sender` cannot be the zero address.
456      * - `recipient` cannot be the zero address.
457      * - `sender` must have a balance of at least `amount`.
458      */
459     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
460         require(sender != address(0), "ERC20: transfer from the zero address");
461         require(recipient != address(0), "ERC20: transfer to the zero address");
462 
463         _beforeTokenTransfer(sender, recipient, amount);
464 
465         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
466         _balances[recipient] = _balances[recipient].add(amount);
467         emit Transfer(sender, recipient, amount);
468     }
469 
470     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
471      * the total supply.
472      *
473      * Emits a {Transfer} event with `from` set to the zero address.
474      *
475      * Requirements
476      *
477      * - `to` cannot be the zero address.
478      */
479     function _mint(address account, uint256 amount) internal virtual {
480         require(account != address(0), "ERC20: mint to the zero address");
481 
482         _beforeTokenTransfer(address(0), account, amount);
483 
484         _totalSupply = _totalSupply.add(amount);
485         _balances[account] = _balances[account].add(amount);
486         emit Transfer(address(0), account, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`, reducing the
491      * total supply.
492      *
493      * Emits a {Transfer} event with `to` set to the zero address.
494      *
495      * Requirements
496      *
497      * - `account` cannot be the zero address.
498      * - `account` must have at least `amount` tokens.
499      */
500     function _burn(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: burn from the zero address");
502 
503         _beforeTokenTransfer(account, address(0), amount);
504 
505         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
506         _totalSupply = _totalSupply.sub(amount);
507         emit Transfer(account, address(0), amount);
508     }
509 
510     /**
511      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
512      *
513      * This is internal function is equivalent to `approve`, and can be used to
514      * e.g. set automatic allowances for certain subsystems, etc.
515      *
516      * Emits an {Approval} event.
517      *
518      * Requirements:
519      *
520      * - `owner` cannot be the zero address.
521      * - `spender` cannot be the zero address.
522      */
523     function _approve(address owner, address spender, uint256 amount) internal virtual {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Sets {decimals} to a value other than the default one of 18.
533      *
534      * WARNING: This function should only be called from the constructor. Most
535      * applications that interact with token contracts will not expect
536      * {decimals} to ever change, and may work incorrectly if it does.
537      */
538     function _setupDecimals(uint8 decimals_) internal {
539         _decimals = decimals_;
540     }
541 
542     /**
543      * @dev Hook that is called before any transfer of tokens. This includes
544      * minting and burning.
545      *
546      * Calling conditions:
547      *
548      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
549      * will be to transferred to `to`.
550      * - when `from` is zero, `amount` tokens will be minted for `to`.
551      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
552      * - `from` and `to` are never both zero.
553      *
554      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
555      */
556     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
557 }
558 
559 contract Scotcoin is ERC20 {
560   
561   constructor (string memory name, string memory symbol, uint8 decimals, uint256 supply) 
562     ERC20(name, symbol) 
563     public 
564   {
565     _setupDecimals(decimals);
566     _mint(msg.sender, supply);
567   }
568 
569 }