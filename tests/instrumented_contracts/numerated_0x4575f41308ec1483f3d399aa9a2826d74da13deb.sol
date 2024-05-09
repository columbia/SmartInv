1 /* The MIT License (MIT) {{{ */
2 /*
3  * Permission is hereby granted, free of charge, to any person obtaining
4  * a copy of this software and associated documentation files (the
5  * "Software"), to deal in the Software without restriction, including
6  * without limitation the rights to use, copy, modify, merge, publish,
7  * distribute, sublicense, and/or sell copies of the Software, and to
8  * permit persons to whom the Software is furnished to do so, subject to
9  * the following conditions:
10 
11  * The above copyright notice and this permission notice shall be included
12  * in all copies or substantial portions of the Software.
13 
14  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
15  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
16  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
17  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
18  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
19  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
20  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
21 **/
22 /* }}} */
23 
24 
25 /* OpenZeppelin Contracts v2.4.0
26  * git cdf655f770cf8412fbd4d6aef3c55194a1233ef1
27  * library for secure smart contract development
28  * Copyright (c) 2016-2019 zOS Global Limited
29 */
30 
31 pragma solidity ^0.5.0;
32 
33 /* openzeppelin-solidity/contracts/GSN/Context.sol {{{ */
34 
35 /* 
36 /*
37  * @dev Provides information about the current execution context, including the
38  * sender of the transaction and its data. While these are generally available
39  * via msg.sender and msg.data, they should not be accessed in such a direct
40  * manner, since when dealing with GSN meta-transactions the account sending and
41  * paying for execution may not be the actual sender (as far as an application
42  * is concerned).
43  *
44  * This contract is only required for intermediate, library-like contracts.
45  */
46 contract Context {
47     // Empty internal constructor, to prevent people from mistakenly deploying
48     // an instance of this contract, which should be used via inheritance.
49     constructor () internal { }
50     // solhint-disable-previous-line no-empty-blocks
51 
52     function _msgSender() internal view returns (address payable) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view returns (bytes memory) {
57         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
58         return msg.data;
59     }
60 }
61 
62 /* }}} */
63 /* openzeppelin-solidity/contracts/math/SafeMath.sol {{{ */
64 
65 /**
66  * @dev Wrappers over Solidity's arithmetic operations with added overflow
67  * checks.
68  *
69  * Arithmetic operations in Solidity wrap on overflow. This can easily result
70  * in bugs, because programmers usually assume that an overflow raises an
71  * error, which is the standard behavior in high level programming languages.
72  * `SafeMath` restores this intuition by reverting the transaction when an
73  * operation overflows.
74  *
75  * Using this library instead of the unchecked operations eliminates an entire
76  * class of bugs, so it's recommended to use it always.
77  */
78 library SafeMath {
79     /**
80      * @dev Returns the addition of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `+` operator.
84      *
85      * Requirements:
86      * - Addition cannot overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a, "SafeMath: addition overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      * - Subtraction cannot overflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      *
117      * _Available since v2.4.0._
118      */
119     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b <= a, errorMessage);
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         return div(a, b, "SafeMath: division by zero");
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      *
175      * _Available since v2.4.0._
176      */
177     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         // Solidity only automatically asserts when dividing by 0
179         require(b > 0, errorMessage);
180         uint256 c = a / b;
181         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
188      * Reverts when dividing by zero.
189      *
190      * Counterpart to Solidity's `%` operator. This function uses a `revert`
191      * opcode (which leaves remaining gas untouched) while Solidity uses an
192      * invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      * - The divisor cannot be zero.
196      */
197     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
198         return mod(a, b, "SafeMath: modulo by zero");
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts with custom message when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      *
212      * _Available since v2.4.0._
213      */
214     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b != 0, errorMessage);
216         return a % b;
217     }
218 }
219 
220 /* }}} */
221 /* openzeppelin-solidity/contracts/token/ERC20/IERC20.sol {{{ */
222 
223 /**
224  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
225  * the optional functions; to access them see {ERC20Detailed}.
226  */
227 interface IERC20 {
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `recipient`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(address owner, address spender) external view returns (uint256);
255 
256     /**
257      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * IMPORTANT: Beware that changing an allowance with this method brings the risk
262      * that someone may use both the old and the new allowance by unfortunate
263      * transaction ordering. One possible solution to mitigate this race
264      * condition is to first reduce the spender's allowance to 0 and set the
265      * desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address spender, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Moves `amount` tokens from `sender` to `recipient` using the
274      * allowance mechanism. `amount` is then deducted from the caller's
275      * allowance.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Emitted when `value` tokens are moved from one account (`from`) to
285      * another (`to`).
286      *
287      * Note that `value` may be zero.
288      */
289     event Transfer(address indexed from, address indexed to, uint256 value);
290 
291     /**
292      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
293      * a call to {approve}. `value` is the new allowance.
294      */
295     event Approval(address indexed owner, address indexed spender, uint256 value);
296 }
297 
298 /* }}} */
299 /* openzeppelin-solidity/contracts/token/ERC20/ERC20.sol {{{ */
300 
301 /**
302  * @dev Implementation of the {IERC20} interface.
303  *
304  * This implementation is agnostic to the way tokens are created. This means
305  * that a supply mechanism has to be added in a derived contract using {_mint}.
306  * For a generic mechanism see {ERC20Mintable}.
307  *
308  * TIP: For a detailed writeup see our guide
309  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
310  * to implement supply mechanisms].
311  *
312  * We have followed general OpenZeppelin guidelines: functions revert instead
313  * of returning `false` on failure. This behavior is nonetheless conventional
314  * and does not conflict with the expectations of ERC20 applications.
315  *
316  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
317  * This allows applications to reconstruct the allowance for all accounts just
318  * by listening to said events. Other implementations of the EIP may not emit
319  * these events, as it isn't required by the specification.
320  *
321  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
322  * functions have been added to mitigate the well-known issues around setting
323  * allowances. See {IERC20-approve}.
324  */
325 contract ERC20 is Context, IERC20 {
326     using SafeMath for uint256;
327 
328     mapping (address => uint256) private _balances;
329 
330     mapping (address => mapping (address => uint256)) private _allowances;
331 
332     uint256 private _totalSupply;
333 
334     /**
335      * @dev See {IERC20-totalSupply}.
336      */
337     function totalSupply() public view returns (uint256) {
338         return _totalSupply;
339     }
340 
341     /**
342      * @dev See {IERC20-balanceOf}.
343      */
344     function balanceOf(address account) public view returns (uint256) {
345         return _balances[account];
346     }
347 
348     /**
349      * @dev See {IERC20-transfer}.
350      *
351      * Requirements:
352      *
353      * - `recipient` cannot be the zero address.
354      * - the caller must have a balance of at least `amount`.
355      */
356     function transfer(address recipient, uint256 amount) public returns (bool) {
357         _transfer(_msgSender(), recipient, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-allowance}.
363      */
364     function allowance(address owner, address spender) public view returns (uint256) {
365         return _allowances[owner][spender];
366     }
367 
368     /**
369      * @dev See {IERC20-approve}.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function approve(address spender, uint256 amount) public returns (bool) {
376         _approve(_msgSender(), spender, amount);
377         return true;
378     }
379 
380     /**
381      * @dev See {IERC20-transferFrom}.
382      *
383      * Emits an {Approval} event indicating the updated allowance. This is not
384      * required by the EIP. See the note at the beginning of {ERC20};
385      *
386      * Requirements:
387      * - `sender` and `recipient` cannot be the zero address.
388      * - `sender` must have a balance of at least `amount`.
389      * - the caller must have allowance for `sender`'s tokens of at least
390      * `amount`.
391      */
392     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
393         _transfer(sender, recipient, amount);
394         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
395         return true;
396     }
397 
398     /**
399      * @dev Atomically increases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
430         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
431         return true;
432     }
433 
434     /**
435      * @dev Moves tokens `amount` from `sender` to `recipient`.
436      *
437      * This is internal function is equivalent to {transfer}, and can be used to
438      * e.g. implement automatic token fees, slashing mechanisms, etc.
439      *
440      * Emits a {Transfer} event.
441      *
442      * Requirements:
443      *
444      * - `sender` cannot be the zero address.
445      * - `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      */
448     function _transfer(address sender, address recipient, uint256 amount) internal {
449         require(sender != address(0), "ERC20: transfer from the zero address");
450         require(recipient != address(0), "ERC20: transfer to the zero address");
451 
452         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
453         _balances[recipient] = _balances[recipient].add(amount);
454         emit Transfer(sender, recipient, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements
463      *
464      * - `to` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal {
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _totalSupply = _totalSupply.add(amount);
470         _balances[account] = _balances[account].add(amount);
471         emit Transfer(address(0), account, amount);
472     }
473 
474      /**
475      * @dev Destroys `amount` tokens from `account`, reducing the
476      * total supply.
477      *
478      * Emits a {Transfer} event with `to` set to the zero address.
479      *
480      * Requirements
481      *
482      * - `account` cannot be the zero address.
483      * - `account` must have at least `amount` tokens.
484      */
485     function _burn(address account, uint256 amount) internal {
486         require(account != address(0), "ERC20: burn from the zero address");
487 
488         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
489         _totalSupply = _totalSupply.sub(amount);
490         emit Transfer(account, address(0), amount);
491     }
492 
493     /**
494      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
495      *
496      * This is internal function is equivalent to `approve`, and can be used to
497      * e.g. set automatic allowances for certain subsystems, etc.
498      *
499      * Emits an {Approval} event.
500      *
501      * Requirements:
502      *
503      * - `owner` cannot be the zero address.
504      * - `spender` cannot be the zero address.
505      */
506     function _approve(address owner, address spender, uint256 amount) internal {
507         require(owner != address(0), "ERC20: approve from the zero address");
508         require(spender != address(0), "ERC20: approve to the zero address");
509 
510         _allowances[owner][spender] = amount;
511         emit Approval(owner, spender, amount);
512     }
513 
514     /**
515      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
516      * from the caller's allowance.
517      *
518      * See {_burn} and {_approve}.
519      */
520     function _burnFrom(address account, uint256 amount) internal {
521         _burn(account, amount);
522         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
523     }
524 }
525 
526 /* }}} */
527 /* openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol {{{ */
528 
529 /**
530  * @dev Optional functions from the ERC20 standard.
531  */
532 contract ERC20Detailed is IERC20 {
533     string private _name;
534     string private _symbol;
535     uint8 private _decimals;
536 
537     /**
538      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
539      * these values are immutable: they can only be set once during
540      * construction.
541      */
542     constructor (string memory name, string memory symbol, uint8 decimals) public {
543         _name = name;
544         _symbol = symbol;
545         _decimals = decimals;
546     }
547 
548     /**
549      * @dev Returns the name of the token.
550      */
551     function name() public view returns (string memory) {
552         return _name;
553     }
554 
555     /**
556      * @dev Returns the symbol of the token, usually a shorter version of the
557      * name.
558      */
559     function symbol() public view returns (string memory) {
560         return _symbol;
561     }
562 
563     /**
564      * @dev Returns the number of decimals used to get its user representation.
565      * For example, if `decimals` equals `2`, a balance of `505` tokens should
566      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
567      *
568      * Tokens usually opt for a value of 18, imitating the relationship between
569      * Ether and Wei.
570      *
571      * NOTE: This information is only used for _display_ purposes: it in
572      * no way affects any of the arithmetic of the contract, including
573      * {IERC20-balanceOf} and {IERC20-transfer}.
574      */
575     function decimals() public view returns (uint8) {
576         return _decimals;
577     }
578 }
579 
580 /* }}} */
581 
582 
583 /* Orchid - WebRTC P2P VPN Market (on Ethereum)
584  * Copyright (C) 2019  Orchid Labs, Inc.
585 */
586 
587 pragma solidity 0.5.12;
588 
589 contract OrchidToken is ERC20, ERC20Detailed {
590     constructor()
591         ERC20Detailed("Orchid", "OXT", 18)
592     public {
593         _mint(msg.sender, 10**9 * 10**uint256(decimals()));
594     }
595 }