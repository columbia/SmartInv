1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Emitted when `value` tokens are moved from one account (`from`) to
10      * another (`to`).
11      *
12      * Note that `value` may be zero.
13      */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /**
17      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
18      * a call to {approve}. `value` is the new allowance.
19      */
20     event Approval(
21         address indexed owner,
22         address indexed spender,
23         uint256 value
24     );
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(
53         address owner,
54         address spender
55     ) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `from` to `to` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address from,
84         address to,
85         uint256 amount
86     ) external returns (bool);
87 }
88 
89 /**
90  * @dev Interface for the optional metadata functions from the ERC20 standard.
91  *
92  * _Available since v4.1._
93  */
94 interface IERC20Metadata is IERC20 {
95     /**
96      * @dev Returns the name of the token.
97      */
98     function name() external view returns (string memory);
99 
100     /**
101      * @dev Returns the symbol of the token.
102      */
103     function symbol() external view returns (string memory);
104 
105     /**
106      * @dev Returns the decimals places of the token.
107      */
108     function decimals() external view returns (uint8);
109 }
110 
111 /**
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view returns (address) {
123         return msg.sender;
124     }
125 }
126 
127 /**
128  * @dev Contract module which provides a basic access control mechanism, where
129  * there is an account (an owner) that can be granted exclusive access to
130  * specific functions.
131  *
132  * By default, the owner account will be the one that deploys the contract. This
133  * can later be changed with {transferOwnership}.
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 abstract contract Ownable is Context {
140     address private _owner;
141 
142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144     /**
145      * @dev Initializes the contract setting the deployer as the initial owner.
146      */
147     constructor() {
148         _transferOwnership(_msgSender());
149     }
150 
151     /**
152      * @dev Returns the address of the current owner.
153      */
154     function owner() public view virtual returns (address) {
155         return _owner;
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Internal function without access restriction.
161      */
162     function _transferOwnership(address newOwner) internal virtual {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 /**
170  * @dev Implementation of the {IERC20} interface.
171  *
172  * This implementation is agnostic to the way tokens are created. This means
173  * that a supply mechanism has to be added in a derived contract using {_mint}.
174  * For a generic mechanism see {ERC20PresetMinterPauser}.
175  *
176  * TIP: For a detailed writeup see our guide
177  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
178  * to implement supply mechanisms].
179  *
180  * We have followed general OpenZeppelin Contracts guidelines: functions revert
181  * instead returning `false` on failure. This behavior is nonetheless
182  * conventional and does not conflict with the expectations of ERC20
183  * applications.
184  *
185  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
186  * This allows applications to reconstruct the allowance for all accounts just
187  * by listening to said events. Other implementations of the EIP may not emit
188  * these events, as it isn't required by the specification.
189  *
190  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
191  * functions have been added to mitigate the well-known issues around setting
192  * allowances. See {IERC20-approve}.
193  */
194 contract RaptorEgg is Ownable, IERC20, IERC20Metadata {
195     mapping(address => uint256) private _balances;
196 
197     mapping(address => mapping(address => uint256)) private _allowances;
198 
199     uint256 private _totalSupply;
200     uint256 private _burnAmount;
201 
202     string private _name;
203     string private _symbol;
204 
205     /**
206      * @dev Sets the values for {name} and {symbol}.
207      *
208      * The default value of {decimals} is 18. To select a different value for
209      * {decimals} you should overload it.
210      *
211      * All two of these values are immutable: they can only be set once during
212      * construction.
213      */
214     constructor() {
215         _name = "Raptor Egg";
216         _symbol = "RapEgg";
217         _mint(msg.sender, 666444444444444 * 10 ** decimals());
218         _transferOwnership(address(0));
219     }
220 
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() external view returns (string memory) {
225         return _name;
226     }
227 
228     /**
229      * @dev Returns the symbol of the token, usually a shorter version of the
230      * name.
231      */
232     function symbol() external view returns (string memory) {
233         return _symbol;
234     }
235 
236     /**
237      * @dev Returns the number of decimals used to get its user representation.
238      * For example, if `decimals` equals `2`, a balance of `505` tokens should
239      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
240      *
241      * Tokens usually opt for a value of 18, imitating the relationship between
242      * Ether and Wei. This is the value {ERC20} uses, unless this function is
243      * overridden;
244      *
245      * NOTE: This information is only used for _display_ purposes: it in
246      * no way affects any of the arithmetic of the contract, including
247      * {IERC20-balanceOf} and {IERC20-transfer}.
248      */
249     function decimals() public pure returns (uint8) {
250         return 18;
251     }
252 
253     /**
254      * @dev Destroys `amount` tokens from the caller.
255      *
256      * See {ERC20-_burn}.
257      */
258     function burn(uint256 amount) external {
259         _burn(_msgSender(), amount);
260     }
261 
262     /**
263      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
264      * allowance.
265      *
266      * See {ERC20-_burn} and {ERC20-allowance}.
267      *
268      * Requirements:
269      *
270      * - the caller must have allowance for ``accounts``'s tokens of at least
271      * `amount`.
272      */
273     function burnFrom(address account, uint256 amount) external {
274         _spendAllowance(account, _msgSender(), amount);
275         _burn(account, amount);
276     }
277 
278     /**
279      * @dev See {IERC20-totalSupply}.
280      */
281     function totalSupply() external view returns (uint256) {
282         return _totalSupply;
283     }
284 
285     /**
286      * @dev See {IERC20-balanceOf}.
287      */
288     function balanceOf(address account) external view returns (uint256) {
289         return _balances[account];
290     }
291 
292     function tokensBurnt() external view returns (uint256) {
293         return _burnAmount;
294     }
295 
296     /**
297      * @dev See {IERC20-transfer}.
298      *
299      * Requirements:
300      *
301      * - `to` cannot be the zero address.
302      * - the caller must have a balance of at least `amount`.
303      */
304     function transfer(address to, uint256 amount) external returns (bool) {
305         address owner = _msgSender();
306         _transfer(owner, to, amount);
307         return true;
308     }
309 
310     /**
311      * @dev See {IERC20-allowance}.
312      */
313     function allowance(
314         address owner,
315         address spender
316     ) public view returns (uint256) {
317         return _allowances[owner][spender];
318     }
319 
320     /**
321      * @dev See {IERC20-approve}.
322      *
323      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
324      * `transferFrom`. This is semantically equivalent to an infinite approval.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function approve(address spender, uint256 amount) external returns (bool) {
331         address owner = _msgSender();
332         _approve(owner, spender, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-transferFrom}.
338      *
339      * Emits an {Approval} event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of {ERC20}.
341      *
342      * NOTE: Does not update the allowance if the current allowance
343      * is the maximum `uint256`.
344      *
345      * Requirements:
346      *
347      * - `from` and `to` cannot be the zero address.
348      * - `from` must have a balance of at least `amount`.
349      * - the caller must have allowance for ``from``'s tokens of at least
350      * `amount`.
351      */
352     function transferFrom(
353         address from,
354         address to,
355         uint256 amount
356     ) external returns (bool) {
357         address spender = _msgSender();
358         _spendAllowance(from, spender, amount);
359         _transfer(from, to, amount);
360         return true;
361     }
362 
363     /**
364      * @dev Atomically increases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function increaseAllowance(
376         address spender,
377         uint256 addedValue
378     ) external returns (bool) {
379         address owner = _msgSender();
380         _approve(owner, spender, allowance(owner, spender) + addedValue);
381         return true;
382     }
383 
384     /**
385      * @dev Atomically decreases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      * - `spender` must have allowance for the caller of at least
396      * `subtractedValue`.
397      */
398     function decreaseAllowance(
399         address spender,
400         uint256 subtractedValue
401     ) external returns (bool) {
402         address owner = _msgSender();
403         uint256 currentAllowance = allowance(owner, spender);
404         require(
405             currentAllowance >= subtractedValue,
406             "ERC20: decreased allowance below zero"
407         );
408         unchecked {
409             _approve(owner, spender, currentAllowance - subtractedValue);
410         }
411 
412         return true;
413     }
414 
415     /**
416      * @dev Moves `amount` of tokens from `from` to `to`.
417      *
418      * This internal function is equivalent to {transfer}, and can be used to
419      * e.g. implement automatic token fees, slashing mechanisms, etc.
420      *
421      * Emits a {Transfer} event.
422      *
423      * Requirements:
424      *
425      * - `from` cannot be the zero address.
426      * - `to` cannot be the zero address.
427      * - `from` must have a balance of at least `amount`.
428      */
429     function _transfer(address from, address to, uint256 amount) private {
430         require(from != address(0), "ERC20: transfer from the zero address");
431         require(to != address(0), "ERC20: transfer to the zero address");
432 
433         uint256 fromBalance = _balances[from];
434         require(
435             fromBalance >= amount,
436             "ERC20: transfer amount exceeds balance"
437         );
438         unchecked {
439             _balances[from] = fromBalance - amount;
440             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
441             // decrementing then incrementing.
442             _balances[to] += amount;
443         }
444 
445         emit Transfer(from, to, amount);
446     }
447 
448     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
449      * the total supply.
450      *
451      * Emits a {Transfer} event with `from` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      */
457     function _mint(address account, uint256 amount) private {
458         require(account != address(0), "ERC20: mint to the zero address");
459 
460         _totalSupply += amount;
461         unchecked {
462             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
463             _balances[account] += amount;
464         }
465         emit Transfer(address(0), account, amount);
466     }
467 
468     /**
469      * @dev Destroys `amount` tokens from `account`, reducing the
470      * total supply.
471      *
472      * Emits a {Transfer} event with `to` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `account` cannot be the zero address.
477      * - `account` must have at least `amount` tokens.
478      */
479     function _burn(address account, uint256 amount) private {
480         require(account != address(0), "ERC20: burn from the zero address");
481 
482         uint256 accountBalance = _balances[account];
483         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
484         unchecked {
485             _balances[account] = accountBalance - amount;
486             // Overflow not possible: amount <= accountBalance <= totalSupply.
487             _totalSupply -= amount;
488             _burnAmount += amount;
489         }
490 
491         emit Transfer(account, address(0), amount);
492     }
493 
494     /**
495      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
496      *
497      * This internal function is equivalent to `approve`, and can be used to
498      * e.g. set automatic allowances for certain subsystems, etc.
499      *
500      * Emits an {Approval} event.
501      *
502      * Requirements:
503      *
504      * - `owner` cannot be the zero address.
505      * - `spender` cannot be the zero address.
506      */
507     function _approve(address owner, address spender, uint256 amount) private {
508         require(owner != address(0), "ERC20: approve from the zero address");
509         require(spender != address(0), "ERC20: approve to the zero address");
510 
511         _allowances[owner][spender] = amount;
512         emit Approval(owner, spender, amount);
513     }
514 
515     /**
516      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
517      *
518      * Does not update the allowance amount in case of infinite allowance.
519      * Revert if not enough allowance is available.
520      *
521      * Might emit an {Approval} event.
522      */
523     function _spendAllowance(
524         address owner,
525         address spender,
526         uint256 amount
527     ) private {
528         uint256 currentAllowance = allowance(owner, spender);
529         if (currentAllowance != type(uint256).max) {
530             require(
531                 currentAllowance >= amount,
532                 "ERC20: insufficient allowance"
533             );
534             unchecked {
535                 _approve(owner, spender, currentAllowance - amount);
536             }
537         }
538     }
539 }