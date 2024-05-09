1 /*
2                                         ,▄m    ,▄▄▄▄▄▄▄▄▄▄╖
3                                     ╓▄▓██▌╓▄▓███████████▀└
4                                   ▄████████████▓╬▓███████████▓▓▓▄▄▄,
5               ╓,              ,▄▄███▓╣██████▓╬╬▓████████████▀▓████████▓▄,
6                ▀█▓▄╥       xΘ╙╠╠███▓╬▓█████╬╬╬▓██████▓╬╬╬▓▀  ▐█╬╬╬╬▓██████▌╖
7                  ╙████▓▄Q  ,φ▒▒▒███╬╬█████╬╬╬▓████▓╬╬╬▓▓▀  ╕ ▐█▓▓▓╬╬╬╬╬▓█████▄
8                    ╙▓██████▓▄▄▒▒███╬╬╣████╬╬╣███╬╬▓███▀  ▄█⌐ ╫████████▓▓╬╬╬████▌
9                    /  ▀███▓████████▓╬╬▓████╬███▓████▀  ▄██▀ ╔██████████████▓▓▓███▄
10                  ▄╙     ╙██▓▄╙▀▓█████▓▓▓██████████▀  ª▀▀└ ,▓███████▓╬╬╬▓██████████▌
11                ,▓   ╓╠▒≥  ╙▓██▓╖ └▀▓███████▓███▓╙       ▄▓████████████▓╬╬╬╬▓███████▌
12               ▄█   ╔▒▒▒▒"   └▀███▌,  ╙████▀         ~Φ▓██▓▀▀╩▓██╙▀██████▓╬╬╬╬▓██████▌
13              ▓█   φ▒▒▒╙    ╔╔  ╙████▄▄███▀          ,         ██▌   ╙▓█████╬╬╬╬▓██▓└▀b
14             ▓█   ╔▒▒▒`    φ▒▒▒ⁿ  ╫██████`         ,▌          ╫██      ╙█████╬╬╬╬██▓
15            ╫█─  .▒▒▒     ╠▒▒╚   ]██████¬         ▓█            ██▌       └▓███▓╬╬╬██▓
16           ▐█▌   ╠▒▒     φ▒▒"    ▐█████─        ▓█▀██▌          ███       ╬ └████╬╬╬██▌
17           ██   ]▒▒⌐    .▒▒       ▓████       ▄█▀┤░▐██        ╓███▀      /╫▒ε ╙███╬╬╣██
18          ▐██   ╚▒╚     ╠▒        ║████⌐ ╟▄,▓█▓┤Q▄▓█▀        ▄▀▓▓`      ╓▒▓▌▒╔ └███╬╬██▌
19          ▓█▌   ▒▒      ▒╙        ██████ ╫████▓▀▀╙          ▓         ,φ▒║█▌▒▒≥  ███╬▓██
20          ██▌   ▒▒      ▒        ▐███╙██b └╙          ▄ÆR▀▀▀       ╓φ╠▒▒▄██▒▒▒▒  ╙███╣██
21          ██▌   ▒Γ      ╙        ███▌ ╟█            ,▓,φφ╠▒▒▒▒▒▒▒▒▒▒▒▄▓███▀▒▒▒▒╠  ▓██▓██─
22          ██▌   ╚⌐      ⌐       ▓███               ╔▌«▒▒▒▒▄▓████████████▀░▒▒▒▒▒▒  ▐█████
23          ███   'ε             ]███⌐             ╓▄▀φ▒▒▒▄▓█████████▓▀╬░▒▒▒▒▒▒▒▒▒   █████
24          ╫██µ   φ             ███▌        ╓╔φ╠▒░▓,╠▒▒▒▓███████▀  ╙█▓▄`╙╠▒▒▒▒▒▒▒   █████
25          └███                ╫███       ,╠▒▒▄▓▓█▓▓▓▄▄███████▀      ▓██▌,`╚▒▒▒▒▒  ]████▌
26           ▓██▌              ▓███¬   ╔  φ▒▒▒╠╠╠╠╬▓████████▓╙         ████▌  ╚▒▒╙  ▓████
27            ███▄           ▄███▀  ╒  ╠≥╠▒▒▒░▄▓▌╨╚▒╚▓█████└           ║█████  └▒  ]████`
28            └███▌         ▓███╙  ▓▄  ╠▒▒▒▒▒██╙╙▓▓ ▒▒████             ▐██████    ,████╨
29             └███▌       ▐███  ╔███  ╠▒▒▒▒╫█⌐,▄▓▓ ▒▒▓██▌             ╫██████▓  ╓████▀
30               ████µ      ███b  ▀╙  φ▒▒▒▒▄██▓▓╠φ╠▒▒▓███             ]████████⌐▄████┘
31                ▀███▌     ╫███  .╔φ▒▒▒▒▒▓█▓╬░▒▒▄▓████▀              █████████████▓
32                 ╙████▌    ▓██▓▄,   ▐▓▓██▄▄▄▄▓████▀└              ,█████████████▀
33                   ╙████▌µ  ╙▀████████████████▓▀                 ▄████████████▀
34                     ╙█████▄,   └╙╙▀▀╙                         ▄████████████▀
35                       └▀█████▓▄                            ▄▓███████████▀╙
36                          ╙▀██████▓▄▄,                 ,▄▓▓███████████▀╙
37                              ╙▀█████████▓▓▓▓▓▓▓▓▓▓▓██████████████▀▀└
38                                  ╙╙▀▓███████████████████████▀▀╙
39                                         └╙╙╙▀▀▀▀▀▀▀▀▀╙╙└
40 
41          ██╗██╗███╗   ██╗ ██████╗██╗  ██╗    ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
42         ███║██║████╗  ██║██╔════╝██║  ██║    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
43         ╚██║██║██╔██╗ ██║██║     ███████║       ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
44          ██║██║██║╚██╗██║██║     ██╔══██║       ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
45          ██║██║██║ ╚████║╚██████╗██║  ██║       ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
46          ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝       ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
47 */
48 // File: @openzeppelin/contracts/GSN/Context.sol
49 
50 // SPDX-License-Identifier: MIT
51 
52 pragma solidity >=0.6.0 <0.8.0;
53 
54 /*
55  * @dev Provides information about the current execution context, including the
56  * sender of the transaction and its data. While these are generally available
57  * via msg.sender and msg.data, they should not be accessed in such a direct
58  * manner, since when dealing with GSN meta-transactions the account sending and
59  * paying for execution may not be the actual sender (as far as an application
60  * is concerned).
61  *
62  * This contract is only required for intermediate, library-like contracts.
63  */
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address payable) {
66         return msg.sender;
67     }
68 
69     function _msgData() internal view virtual returns (bytes memory) {
70         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
71         return msg.data;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
76 
77 
78 pragma solidity >=0.6.0 <0.8.0;
79 
80 /**
81  * @dev Interface of the ERC20 standard as defined in the EIP.
82  */
83 interface IERC20 {
84     /**
85      * @dev Returns the amount of tokens in existence.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     /**
90      * @dev Returns the amount of tokens owned by `account`.
91      */
92     function balanceOf(address account) external view returns (uint256);
93 
94     /**
95      * @dev Moves `amount` tokens from the caller's account to `recipient`.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Returns the remaining number of tokens that `spender` will be
105      * allowed to spend on behalf of `owner` through {transferFrom}. This is
106      * zero by default.
107      *
108      * This value changes when {approve} or {transferFrom} are called.
109      */
110     function allowance(address owner, address spender) external view returns (uint256);
111 
112     /**
113      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * IMPORTANT: Beware that changing an allowance with this method brings the risk
118      * that someone may use both the old and the new allowance by unfortunate
119      * transaction ordering. One possible solution to mitigate this race
120      * condition is to first reduce the spender's allowance to 0 and set the
121      * desired value afterwards:
122      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address spender, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Moves `amount` tokens from `sender` to `recipient` using the
130      * allowance mechanism. `amount` is then deducted from the caller's
131      * allowance.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Emitted when `value` tokens are moved from one account (`from`) to
141      * another (`to`).
142      *
143      * Note that `value` may be zero.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147     /**
148      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
149      * a call to {approve}. `value` is the new allowance.
150      */
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 // File: @openzeppelin/contracts/math/SafeMath.sol
155 
156 
157 pragma solidity >=0.6.0 <0.8.0;
158 
159 /**
160  * @dev Wrappers over Solidity's arithmetic operations with added overflow
161  * checks.
162  *
163  * Arithmetic operations in Solidity wrap on overflow. This can easily result
164  * in bugs, because programmers usually assume that an overflow raises an
165  * error, which is the standard behavior in high level programming languages.
166  * `SafeMath` restores this intuition by reverting the transaction when an
167  * operation overflows.
168  *
169  * Using this library instead of the unchecked operations eliminates an entire
170  * class of bugs, so it's recommended to use it always.
171  */
172 library SafeMath {
173     /**
174      * @dev Returns the addition of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `+` operator.
178      *
179      * Requirements:
180      *
181      * - Addition cannot overflow.
182      */
183     function add(uint256 a, uint256 b) internal pure returns (uint256) {
184         uint256 c = a + b;
185         require(c >= a, "SafeMath: addition overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         return sub(a, b, "SafeMath: subtraction overflow");
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b <= a, errorMessage);
216         uint256 c = a - b;
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      *
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
233         // benefit is lost if 'b' is also tested.
234         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
235         if (a == 0) {
236             return 0;
237         }
238 
239         uint256 c = a * b;
240         require(c / a == b, "SafeMath: multiplication overflow");
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers. Reverts on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(uint256 a, uint256 b) internal pure returns (uint256) {
258         return div(a, b, "SafeMath: division by zero");
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b > 0, errorMessage);
275         uint256 c = a / b;
276         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277 
278         return c;
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294         return mod(a, b, "SafeMath: modulo by zero");
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * Reverts with custom message when dividing by zero.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         require(b != 0, errorMessage);
311         return a % b;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
316 
317 
318 pragma solidity >=0.6.0 <0.8.0;
319 
320 
321 
322 
323 /**
324  * @dev Implementation of the {IERC20} interface.
325  *
326  * This implementation is agnostic to the way tokens are created. This means
327  * that a supply mechanism has to be added in a derived contract using {_mint}.
328  * For a generic mechanism see {ERC20PresetMinterPauser}.
329  *
330  * TIP: For a detailed writeup see our guide
331  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
332  * to implement supply mechanisms].
333  *
334  * We have followed general OpenZeppelin guidelines: functions revert instead
335  * of returning `false` on failure. This behavior is nonetheless conventional
336  * and does not conflict with the expectations of ERC20 applications.
337  *
338  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
339  * This allows applications to reconstruct the allowance for all accounts just
340  * by listening to said events. Other implementations of the EIP may not emit
341  * these events, as it isn't required by the specification.
342  *
343  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
344  * functions have been added to mitigate the well-known issues around setting
345  * allowances. See {IERC20-approve}.
346  */
347 contract ERC20 is Context, IERC20 {
348     using SafeMath for uint256;
349 
350     mapping (address => uint256) private _balances;
351 
352     mapping (address => mapping (address => uint256)) private _allowances;
353 
354     uint256 private _totalSupply;
355 
356     string private _name;
357     string private _symbol;
358     uint8 private _decimals;
359 
360     /**
361      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
362      * a default value of 18.
363      *
364      * To select a different value for {decimals}, use {_setupDecimals}.
365      *
366      * All three of these values are immutable: they can only be set once during
367      * construction.
368      */
369     constructor (string memory name_, string memory symbol_) public {
370         _name = name_;
371         _symbol = symbol_;
372         _decimals = 18;
373     }
374 
375     /**
376      * @dev Returns the name of the token.
377      */
378     function name() public view returns (string memory) {
379         return _name;
380     }
381 
382     /**
383      * @dev Returns the symbol of the token, usually a shorter version of the
384      * name.
385      */
386     function symbol() public view returns (string memory) {
387         return _symbol;
388     }
389 
390     /**
391      * @dev Returns the number of decimals used to get its user representation.
392      * For example, if `decimals` equals `2`, a balance of `505` tokens should
393      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
394      *
395      * Tokens usually opt for a value of 18, imitating the relationship between
396      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
397      * called.
398      *
399      * NOTE: This information is only used for _display_ purposes: it in
400      * no way affects any of the arithmetic of the contract, including
401      * {IERC20-balanceOf} and {IERC20-transfer}.
402      */
403     function decimals() public view returns (uint8) {
404         return _decimals;
405     }
406 
407     /**
408      * @dev See {IERC20-totalSupply}.
409      */
410     function totalSupply() public view override returns (uint256) {
411         return _totalSupply;
412     }
413 
414     /**
415      * @dev See {IERC20-balanceOf}.
416      */
417     function balanceOf(address account) public view override returns (uint256) {
418         return _balances[account];
419     }
420 
421     /**
422      * @dev See {IERC20-transfer}.
423      *
424      * Requirements:
425      *
426      * - `recipient` cannot be the zero address.
427      * - the caller must have a balance of at least `amount`.
428      */
429     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
430         _transfer(_msgSender(), recipient, amount);
431         return true;
432     }
433 
434     /**
435      * @dev See {IERC20-allowance}.
436      */
437     function allowance(address owner, address spender) public view virtual override returns (uint256) {
438         return _allowances[owner][spender];
439     }
440 
441     /**
442      * @dev See {IERC20-approve}.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      */
448     function approve(address spender, uint256 amount) public virtual override returns (bool) {
449         _approve(_msgSender(), spender, amount);
450         return true;
451     }
452 
453     /**
454      * @dev See {IERC20-transferFrom}.
455      *
456      * Emits an {Approval} event indicating the updated allowance. This is not
457      * required by the EIP. See the note at the beginning of {ERC20}.
458      *
459      * Requirements:
460      *
461      * - `sender` and `recipient` cannot be the zero address.
462      * - `sender` must have a balance of at least `amount`.
463      * - the caller must have allowance for ``sender``'s tokens of at least
464      * `amount`.
465      */
466     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
467         _transfer(sender, recipient, amount);
468         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
469         return true;
470     }
471 
472     /**
473      * @dev Atomically increases the allowance granted to `spender` by the caller.
474      *
475      * This is an alternative to {approve} that can be used as a mitigation for
476      * problems described in {IERC20-approve}.
477      *
478      * Emits an {Approval} event indicating the updated allowance.
479      *
480      * Requirements:
481      *
482      * - `spender` cannot be the zero address.
483      */
484     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
486         return true;
487     }
488 
489     /**
490      * @dev Atomically decreases the allowance granted to `spender` by the caller.
491      *
492      * This is an alternative to {approve} that can be used as a mitigation for
493      * problems described in {IERC20-approve}.
494      *
495      * Emits an {Approval} event indicating the updated allowance.
496      *
497      * Requirements:
498      *
499      * - `spender` cannot be the zero address.
500      * - `spender` must have allowance for the caller of at least
501      * `subtractedValue`.
502      */
503     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
505         return true;
506     }
507 
508     /**
509      * @dev Moves tokens `amount` from `sender` to `recipient`.
510      *
511      * This is internal function is equivalent to {transfer}, and can be used to
512      * e.g. implement automatic token fees, slashing mechanisms, etc.
513      *
514      * Emits a {Transfer} event.
515      *
516      * Requirements:
517      *
518      * - `sender` cannot be the zero address.
519      * - `recipient` cannot be the zero address.
520      * - `sender` must have a balance of at least `amount`.
521      */
522     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
523         require(sender != address(0), "ERC20: transfer from the zero address");
524         require(recipient != address(0), "ERC20: transfer to the zero address");
525 
526         _beforeTokenTransfer(sender, recipient, amount);
527 
528         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
529         _balances[recipient] = _balances[recipient].add(amount);
530         emit Transfer(sender, recipient, amount);
531     }
532 
533     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
534      * the total supply.
535      *
536      * Emits a {Transfer} event with `from` set to the zero address.
537      *
538      * Requirements:
539      *
540      * - `to` cannot be the zero address.
541      */
542     function _mint(address account, uint256 amount) internal virtual {
543         require(account != address(0), "ERC20: mint to the zero address");
544 
545         _beforeTokenTransfer(address(0), account, amount);
546 
547         _totalSupply = _totalSupply.add(amount);
548         _balances[account] = _balances[account].add(amount);
549         emit Transfer(address(0), account, amount);
550     }
551 
552     /**
553      * @dev Destroys `amount` tokens from `account`, reducing the
554      * total supply.
555      *
556      * Emits a {Transfer} event with `to` set to the zero address.
557      *
558      * Requirements:
559      *
560      * - `account` cannot be the zero address.
561      * - `account` must have at least `amount` tokens.
562      */
563     function _burn(address account, uint256 amount) internal virtual {
564         require(account != address(0), "ERC20: burn from the zero address");
565 
566         _beforeTokenTransfer(account, address(0), amount);
567 
568         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
569         _totalSupply = _totalSupply.sub(amount);
570         emit Transfer(account, address(0), amount);
571     }
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
575      *
576      * This internal function is equivalent to `approve`, and can be used to
577      * e.g. set automatic allowances for certain subsystems, etc.
578      *
579      * Emits an {Approval} event.
580      *
581      * Requirements:
582      *
583      * - `owner` cannot be the zero address.
584      * - `spender` cannot be the zero address.
585      */
586     function _approve(address owner, address spender, uint256 amount) internal virtual {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589 
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593 
594     /**
595      * @dev Sets {decimals} to a value other than the default one of 18.
596      *
597      * WARNING: This function should only be called from the constructor. Most
598      * applications that interact with token contracts will not expect
599      * {decimals} to ever change, and may work incorrectly if it does.
600      */
601     function _setupDecimals(uint8 decimals_) internal {
602         _decimals = decimals_;
603     }
604 
605     /**
606      * @dev Hook that is called before any transfer of tokens. This includes
607      * minting and burning.
608      *
609      * Calling conditions:
610      *
611      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
612      * will be to transferred to `to`.
613      * - when `from` is zero, `amount` tokens will be minted for `to`.
614      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
615      * - `from` and `to` are never both zero.
616      *
617      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
618      */
619     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
620 }
621 
622 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
623 
624 
625 pragma solidity >=0.6.0 <0.8.0;
626 
627 
628 
629 /**
630  * @dev Extension of {ERC20} that allows token holders to destroy both their own
631  * tokens and those that they have an allowance for, in a way that can be
632  * recognized off-chain (via event analysis).
633  */
634 abstract contract ERC20Burnable is Context, ERC20 {
635     using SafeMath for uint256;
636 
637     /**
638      * @dev Destroys `amount` tokens from the caller.
639      *
640      * See {ERC20-_burn}.
641      */
642     function burn(uint256 amount) public virtual {
643         _burn(_msgSender(), amount);
644     }
645 
646     /**
647      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
648      * allowance.
649      *
650      * See {ERC20-_burn} and {ERC20-allowance}.
651      *
652      * Requirements:
653      *
654      * - the caller must have allowance for ``accounts``'s tokens of at least
655      * `amount`.
656      */
657     function burnFrom(address account, uint256 amount) public virtual {
658         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
659 
660         _approve(account, _msgSender(), decreasedAllowance);
661         _burn(account, amount);
662     }
663 }
664 
665 // File: @openzeppelin/contracts/access/Ownable.sol
666 
667 
668 pragma solidity >=0.6.0 <0.8.0;
669 
670 /**
671  * @dev Contract module which provides a basic access control mechanism, where
672  * there is an account (an owner) that can be granted exclusive access to
673  * specific functions.
674  *
675  * By default, the owner account will be the one that deploys the contract. This
676  * can later be changed with {transferOwnership}.
677  *
678  * This module is used through inheritance. It will make available the modifier
679  * `onlyOwner`, which can be applied to your functions to restrict their use to
680  * the owner.
681  */
682 abstract contract Ownable is Context {
683     address private _owner;
684 
685     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
686 
687     /**
688      * @dev Initializes the contract setting the deployer as the initial owner.
689      */
690     constructor () internal {
691         address msgSender = _msgSender();
692         _owner = msgSender;
693         emit OwnershipTransferred(address(0), msgSender);
694     }
695 
696     /**
697      * @dev Returns the address of the current owner.
698      */
699     function owner() public view returns (address) {
700         return _owner;
701     }
702 
703     /**
704      * @dev Throws if called by any account other than the owner.
705      */
706     modifier onlyOwner() {
707         require(_owner == _msgSender(), "Ownable: caller is not the owner");
708         _;
709     }
710 
711     /**
712      * @dev Leaves the contract without owner. It will not be possible to call
713      * `onlyOwner` functions anymore. Can only be called by the current owner.
714      *
715      * NOTE: Renouncing ownership will leave the contract without an owner,
716      * thereby removing any functionality that is only available to the owner.
717      */
718     function renounceOwnership() public virtual onlyOwner {
719         emit OwnershipTransferred(_owner, address(0));
720         _owner = address(0);
721     }
722 
723     /**
724      * @dev Transfers ownership of the contract to a new account (`newOwner`).
725      * Can only be called by the current owner.
726      */
727     function transferOwnership(address newOwner) public virtual onlyOwner {
728         require(newOwner != address(0), "Ownable: new owner is the zero address");
729         emit OwnershipTransferred(_owner, newOwner);
730         _owner = newOwner;
731     }
732 }
733 
734 // File: @openzeppelin/contracts/utils/Counters.sol
735 
736 
737 pragma solidity >=0.6.0 <0.8.0;
738 
739 
740 /**
741  * @title Counters
742  * @author Matt Condon (@shrugs)
743  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
744  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
745  *
746  * Include with `using Counters for Counters.Counter;`
747  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
748  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
749  * directly accessed.
750  */
751 library Counters {
752     using SafeMath for uint256;
753 
754     struct Counter {
755         // This variable should never be directly accessed by users of the library: interactions must be restricted to
756         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
757         // this feature: see https://github.com/ethereum/solidity/issues/4637
758         uint256 _value; // default: 0
759     }
760 
761     function current(Counter storage counter) internal view returns (uint256) {
762         return counter._value;
763     }
764 
765     function increment(Counter storage counter) internal {
766         // The {SafeMath} overflow check can be skipped here, see the comment at the top
767         counter._value += 1;
768     }
769 
770     function decrement(Counter storage counter) internal {
771         counter._value = counter._value.sub(1);
772     }
773 }
774 
775 // File: contracts/IERC20Permit.sol
776 
777 
778 pragma solidity ^0.6.0;
779 
780 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/IERC20Permit.sol
781 
782 /**
783  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
784  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
785  *
786  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
787  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
788  * need to send a transaction, and thus is not required to hold Ether at all.
789  */
790 interface IERC20Permit {
791     /**
792      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
793      * given `owner`'s signed approval.
794      *
795      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
796      * ordering also apply here.
797      *
798      * Emits an {Approval} event.
799      *
800      * Requirements:
801      *
802      * - `spender` cannot be the zero address.
803      * - `deadline` must be a timestamp in the future.
804      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
805      * over the EIP712-formatted function arguments.
806      * - the signature must use ``owner``'s current nonce (see {nonces}).
807      *
808      * For more information on the signature format, see the
809      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
810      * section].
811      */
812     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
813 
814     /**
815      * @dev Returns the current nonce for `owner`. This value must be
816      * included whenever a signature is generated for {permit}.
817      *
818      * Every successful call to {permit} increases ``owner``'s nonce by one. This
819      * prevents a signature from being used multiple times.
820      */
821     function nonces(address owner) external view returns (uint256);
822 
823     /**
824      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
825      */
826     // solhint-disable-next-line func-name-mixedcase
827     function DOMAIN_SEPARATOR() external view returns (bytes32);
828 }
829 
830 // File: contracts/ECDSA.sol
831 
832 
833 pragma solidity ^0.6.0;
834 
835 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/cryptography/ECDSA.sol
836 
837 /**
838  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
839  *
840  * These functions can be used to verify that a message was signed by the holder
841  * of the private keys of a given address.
842  */
843 library ECDSA {
844     /**
845      * @dev Returns the address that signed a hashed message (`hash`) with
846      * `signature`. This address can then be used for verification purposes.
847      *
848      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
849      * this function rejects them by requiring the `s` value to be in the lower
850      * half order, and the `v` value to be either 27 or 28.
851      *
852      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
853      * verification to be secure: it is possible to craft signatures that
854      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
855      * this is by receiving a hash of the original message (which may otherwise
856      * be too long), and then calling {toEthSignedMessageHash} on it.
857      */
858     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
859         // Check the signature length
860         if (signature.length != 65) {
861             revert("ECDSA: invalid signature length");
862         }
863 
864         // Divide the signature in r, s and v variables
865         bytes32 r;
866         bytes32 s;
867         uint8 v;
868 
869         // ecrecover takes the signature parameters, and the only way to get them
870         // currently is to use assembly.
871         // solhint-disable-next-line no-inline-assembly
872         assembly {
873             r := mload(add(signature, 0x20))
874             s := mload(add(signature, 0x40))
875             v := byte(0, mload(add(signature, 0x60)))
876         }
877 
878         return recover(hash, v, r, s);
879     }
880 
881     /**
882      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
883      * `r` and `s` signature fields separately.
884      */
885     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
886         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
887         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
888         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
889         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
890         //
891         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
892         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
893         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
894         // these malleable signatures as well.
895         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature s value");
896         require(v == 27 || v == 28, "ECDSA: invalid signature v value");
897 
898         // If the signature is valid (and not malleable), return the signer address
899         address signer = ecrecover(hash, v, r, s);
900         require(signer != address(0), "ECDSA: invalid signature");
901 
902         return signer;
903     }
904 
905     /**
906      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
907      * replicates the behavior of the
908      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
909      * JSON-RPC method.
910      *
911      * See {recover}.
912      */
913     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
914         // 32 is the length in bytes of hash,
915         // enforced by the type signature above
916         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
917     }
918 }
919 
920 // File: contracts/EIP712.sol
921 
922 
923 pragma solidity ^0.6.0;
924 
925 // A copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/EIP712.sol
926 
927 /**
928  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
929  *
930  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
931  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
932  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
933  *
934  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
935  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
936  * ({_hashTypedDataV4}).
937  *
938  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
939  * the chain id to protect against replay attacks on an eventual fork of the chain.
940  *
941  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
942  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
943  */
944 abstract contract EIP712 {
945     /* solhint-disable var-name-mixedcase */
946     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
947     // invalidate the cached domain separator if the chain id changes.
948     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
949     uint256 private immutable _CACHED_CHAIN_ID;
950 
951     bytes32 private immutable _HASHED_NAME;
952     bytes32 private immutable _HASHED_VERSION;
953     bytes32 private immutable _TYPE_HASH;
954     /* solhint-enable var-name-mixedcase */
955 
956     /**
957      * @dev Initializes the domain separator and parameter caches.
958      *
959      * The meaning of `name` and `version` is specified in
960      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
961      *
962      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
963      * - `version`: the current major version of the signing domain.
964      *
965      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
966      * contract upgrade].
967      */
968     constructor(string memory name, string memory version) internal {
969         bytes32 hashedName = keccak256(bytes(name));
970         bytes32 hashedVersion = keccak256(bytes(version));
971         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
972         _HASHED_NAME = hashedName;
973         _HASHED_VERSION = hashedVersion;
974         _CACHED_CHAIN_ID = _getChainId();
975         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
976         _TYPE_HASH = typeHash;
977     }
978 
979     /**
980      * @dev Returns the domain separator for the current chain.
981      */
982     function _domainSeparatorV4() internal view returns (bytes32) {
983         if (_getChainId() == _CACHED_CHAIN_ID) {
984             return _CACHED_DOMAIN_SEPARATOR;
985         } else {
986             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
987         }
988     }
989 
990     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
991         return keccak256(
992             abi.encode(
993                 typeHash,
994                 name,
995                 version,
996                 _getChainId(),
997                 address(this)
998             )
999         );
1000     }
1001 
1002     /**
1003      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1004      * function returns the hash of the fully encoded EIP712 message for this domain.
1005      *
1006      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1007      *
1008      * ```solidity
1009      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1010      *     keccak256("Mail(address to,string contents)"),
1011      *     mailTo,
1012      *     keccak256(bytes(mailContents))
1013      * )));
1014      * address signer = ECDSA.recover(digest, signature);
1015      * ```
1016      */
1017     function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
1018         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
1019     }
1020 
1021     function _getChainId() private pure returns (uint256 chainId) {
1022         // solhint-disable-next-line no-inline-assembly
1023         assembly {
1024             chainId := chainid()
1025         }
1026     }
1027 }
1028 
1029 // File: contracts/ERC20Permit.sol
1030 
1031 
1032 pragma solidity ^0.6.0;
1033 
1034 
1035 
1036 
1037 
1038 
1039 // An adapted copy of https://github.com/OpenZeppelin/openzeppelin-contracts/blob/ecc66719bd7681ed4eb8bf406f89a7408569ba9b/contracts/drafts/ERC20Permit.sol
1040 
1041 /**
1042  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1043  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1044  *
1045  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1046  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1047  * need to send a transaction, and thus is not required to hold Ether at all.
1048  */
1049 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1050     using Counters for Counters.Counter;
1051 
1052     mapping (address => Counters.Counter) private _nonces;
1053 
1054     // solhint-disable-next-line var-name-mixedcase
1055     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1056 
1057     /**
1058      * @dev See {IERC20Permit-permit}.
1059      */
1060     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1061         // solhint-disable-next-line not-rely-on-time
1062         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1063 
1064         bytes32 structHash = keccak256(
1065             abi.encode(
1066                 _PERMIT_TYPEHASH,
1067                 owner,
1068                 spender,
1069                 value,
1070                 _nonces[owner].current(),
1071                 deadline
1072             )
1073         );
1074 
1075         bytes32 hash = _hashTypedDataV4(structHash);
1076 
1077         address signer = ECDSA.recover(hash, v, r, s);
1078         require(signer == owner, "ERC20Permit: invalid signature");
1079 
1080         _nonces[owner].increment();
1081         _approve(owner, spender, value);
1082     }
1083 
1084     /**
1085      * @dev See {IERC20Permit-nonces}.
1086      */
1087     function nonces(address owner) public view override returns (uint256) {
1088         return _nonces[owner].current();
1089     }
1090 
1091     /**
1092      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1093      */
1094     // solhint-disable-next-line func-name-mixedcase
1095     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1096         return _domainSeparatorV4();
1097     }
1098 }
1099 
1100 // File: contracts/OneInch.sol
1101 
1102 
1103 pragma solidity ^0.6.0;
1104 
1105 
1106 
1107 
1108 
1109 contract OneInch is ERC20Permit, ERC20Burnable, Ownable {
1110     constructor(address _owner) public ERC20("1INCH Token", "1INCH") EIP712("1INCH Token", "1") {
1111         _mint(_owner, 1.5e9 ether);
1112         transferOwnership(_owner);
1113     }
1114 
1115     function mint(address to, uint256 amount) external onlyOwner {
1116         _mint(to, amount);
1117     }
1118 }