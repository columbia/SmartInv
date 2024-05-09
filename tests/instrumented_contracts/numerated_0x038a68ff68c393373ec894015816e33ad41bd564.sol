1 //SPDX-License-Identifier: MIT
2 // produced by the Solididy File Flattener (c) David Appleton 2018 - 2020 and beyond
3 // contact : calistralabs@gmail.com
4 // source  : https://github.com/DaveAppleton/SolidityFlattery
5 // released under Apache 2.0 licence
6 // input  /Users/daveappleton/Documents/myProjects/Glitch/contracts/Glitch.sol
7 // flattened :  Thursday, 17-Dec-20 01:10:47 UTC
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 contract ERC20 is Context, IERC20 {
234     using SafeMath for uint256;
235 
236     mapping (address => uint256) private _balances;
237 
238     mapping (address => mapping (address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     string private _name;
243     string private _symbol;
244     uint8 private _decimals;
245 
246     /**
247      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
248      * a default value of 18.
249      *
250      * To select a different value for {decimals}, use {_setupDecimals}.
251      *
252      * All three of these values are immutable: they can only be set once during
253      * construction.
254      */
255     constructor (string memory name_, string memory symbol_) public {
256         _name = name_;
257         _symbol = symbol_;
258         _decimals = 18;
259     }
260 
261     /**
262      * @dev Returns the name of the token.
263      */
264     function name() public view returns (string memory) {
265         return _name;
266     }
267 
268     /**
269      * @dev Returns the symbol of the token, usually a shorter version of the
270      * name.
271      */
272     function symbol() public view returns (string memory) {
273         return _symbol;
274     }
275 
276     /**
277      * @dev Returns the number of decimals used to get its user representation.
278      * For example, if `decimals` equals `2`, a balance of `505` tokens should
279      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
280      *
281      * Tokens usually opt for a value of 18, imitating the relationship between
282      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
283      * called.
284      *
285      * NOTE: This information is only used for _display_ purposes: it in
286      * no way affects any of the arithmetic of the contract, including
287      * {IERC20-balanceOf} and {IERC20-transfer}.
288      */
289     function decimals() public view returns (uint8) {
290         return _decimals;
291     }
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view override returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account) public view override returns (uint256) {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `recipient` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
316         _transfer(_msgSender(), recipient, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-allowance}.
322      */
323     function allowance(address owner, address spender) public view virtual override returns (uint256) {
324         return _allowances[owner][spender];
325     }
326 
327     /**
328      * @dev See {IERC20-approve}.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function approve(address spender, uint256 amount) public virtual override returns (bool) {
335         _approve(_msgSender(), spender, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-transferFrom}.
341      *
342      * Emits an {Approval} event indicating the updated allowance. This is not
343      * required by the EIP. See the note at the beginning of {ERC20}.
344      *
345      * Requirements:
346      *
347      * - `sender` and `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      * - the caller must have allowance for ``sender``'s tokens of at least
350      * `amount`.
351      */
352     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
353         _transfer(sender, recipient, amount);
354         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
355         return true;
356     }
357 
358     /**
359      * @dev Atomically increases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically decreases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      * - `spender` must have allowance for the caller of at least
387      * `subtractedValue`.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
391         return true;
392     }
393 
394     /**
395      * @dev Moves tokens `amount` from `sender` to `recipient`.
396      *
397      * This is internal function is equivalent to {transfer}, and can be used to
398      * e.g. implement automatic token fees, slashing mechanisms, etc.
399      *
400      * Emits a {Transfer} event.
401      *
402      * Requirements:
403      *
404      * - `sender` cannot be the zero address.
405      * - `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      */
408     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
409         require(sender != address(0), "ERC20: transfer from the zero address");
410         require(recipient != address(0), "ERC20: transfer to the zero address");
411 
412         _beforeTokenTransfer(sender, recipient, amount);
413 
414         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
415         _balances[recipient] = _balances[recipient].add(amount);
416         emit Transfer(sender, recipient, amount);
417     }
418 
419     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
420      * the total supply.
421      *
422      * Emits a {Transfer} event with `from` set to the zero address.
423      *
424      * Requirements:
425      *
426      * - `to` cannot be the zero address.
427      */
428     function _mint(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: mint to the zero address");
430 
431         _beforeTokenTransfer(address(0), account, amount);
432 
433         _totalSupply = _totalSupply.add(amount);
434         _balances[account] = _balances[account].add(amount);
435         emit Transfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a {Transfer} event with `to` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 amount) internal virtual {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _beforeTokenTransfer(account, address(0), amount);
453 
454         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
455         _totalSupply = _totalSupply.sub(amount);
456         emit Transfer(account, address(0), amount);
457     }
458 
459     /**
460      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
461      *
462      * This internal function is equivalent to `approve`, and can be used to
463      * e.g. set automatic allowances for certain subsystems, etc.
464      *
465      * Emits an {Approval} event.
466      *
467      * Requirements:
468      *
469      * - `owner` cannot be the zero address.
470      * - `spender` cannot be the zero address.
471      */
472     function _approve(address owner, address spender, uint256 amount) internal virtual {
473         require(owner != address(0), "ERC20: approve from the zero address");
474         require(spender != address(0), "ERC20: approve to the zero address");
475 
476         _allowances[owner][spender] = amount;
477         emit Approval(owner, spender, amount);
478     }
479 
480     /**
481      * @dev Sets {decimals} to a value other than the default one of 18.
482      *
483      * WARNING: This function should only be called from the constructor. Most
484      * applications that interact with token contracts will not expect
485      * {decimals} to ever change, and may work incorrectly if it does.
486      */
487     function _setupDecimals(uint8 decimals_) internal {
488         _decimals = decimals_;
489     }
490 
491     /**
492      * @dev Hook that is called before any transfer of tokens. This includes
493      * minting and burning.
494      *
495      * Calling conditions:
496      *
497      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
498      * will be to transferred to `to`.
499      * - when `from` is zero, `amount` tokens will be minted for `to`.
500      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
501      * - `from` and `to` are never both zero.
502      *
503      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
504      */
505     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
506 }
507 
508 contract Glitch is ERC20 {
509 
510     constructor() ERC20("Glitch","GLCH") {
511         _mint(0x450Ebf894B790c7bEDBdD6Bd88271398ebb9Dc25,88888888 * 1e18);
512     }
513 }