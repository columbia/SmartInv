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
194 contract PAWZONE is Ownable, IERC20, IERC20Metadata {
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
215         _name = "PAWZONE";
216         _symbol = "PAW";
217         _mint(msg.sender, 1000000000000 * 10 ** decimals());
218         _burn(msg.sender, 500000000000 * 10 ** decimals());
219         _transferOwnership(address(0));
220     }
221 
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory) {
226         return _name;
227     }
228 
229     /**
230      * @dev Returns the symbol of the token, usually a shorter version of the
231      * name.
232      */
233     function symbol() external view returns (string memory) {
234         return _symbol;
235     }
236 
237     /**
238      * @dev Returns the number of decimals used to get its user representation.
239      * For example, if `decimals` equals `2`, a balance of `505` tokens should
240      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
241      *
242      * Tokens usually opt for a value of 18, imitating the relationship between
243      * Ether and Wei. This is the value {ERC20} uses, unless this function is
244      * overridden;
245      *
246      * NOTE: This information is only used for _display_ purposes: it in
247      * no way affects any of the arithmetic of the contract, including
248      * {IERC20-balanceOf} and {IERC20-transfer}.
249      */
250     function decimals() public pure returns (uint8) {
251         return 18;
252     }
253 
254     /**
255      * @dev Destroys `amount` tokens from the caller.
256      *
257      * See {ERC20-_burn}.
258      */
259     function burn(uint256 amount) external {
260         _burn(_msgSender(), amount);
261     }
262 
263     /**
264      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
265      * allowance.
266      *
267      * See {ERC20-_burn} and {ERC20-allowance}.
268      *
269      * Requirements:
270      *
271      * - the caller must have allowance for ``accounts``'s tokens of at least
272      * `amount`.
273      */
274     function burnFrom(address account, uint256 amount) external {
275         _spendAllowance(account, _msgSender(), amount);
276         _burn(account, amount);
277     }
278 
279     /**
280      * @dev See {IERC20-totalSupply}.
281      */
282     function totalSupply() external view returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev See {IERC20-balanceOf}.
288      */
289     function balanceOf(address account) external view returns (uint256) {
290         return _balances[account];
291     }
292 
293     function tokensBurnt() external view returns (uint256) {
294         return _burnAmount;
295     }
296 
297     /**
298      * @dev See {IERC20-transfer}.
299      *
300      * Requirements:
301      *
302      * - `to` cannot be the zero address.
303      * - the caller must have a balance of at least `amount`.
304      */
305     function transfer(address to, uint256 amount) external returns (bool) {
306         address owner = _msgSender();
307         _transfer(owner, to, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See {IERC20-allowance}.
313      */
314     function allowance(
315         address owner,
316         address spender
317     ) public view returns (uint256) {
318         return _allowances[owner][spender];
319     }
320 
321     /**
322      * @dev See {IERC20-approve}.
323      *
324      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
325      * `transferFrom`. This is semantically equivalent to an infinite approval.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function approve(address spender, uint256 amount) external returns (bool) {
332         address owner = _msgSender();
333         _approve(owner, spender, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See {IERC20-transferFrom}.
339      *
340      * Emits an {Approval} event indicating the updated allowance. This is not
341      * required by the EIP. See the note at the beginning of {ERC20}.
342      *
343      * NOTE: Does not update the allowance if the current allowance
344      * is the maximum `uint256`.
345      *
346      * Requirements:
347      *
348      * - `from` and `to` cannot be the zero address.
349      * - `from` must have a balance of at least `amount`.
350      * - the caller must have allowance for ``from``'s tokens of at least
351      * `amount`.
352      */
353     function transferFrom(
354         address from,
355         address to,
356         uint256 amount
357     ) external returns (bool) {
358         address spender = _msgSender();
359         _spendAllowance(from, spender, amount);
360         _transfer(from, to, amount);
361         return true;
362     }
363 
364     /**
365      * @dev Atomically increases the allowance granted to `spender` by the caller.
366      *
367      * This is an alternative to {approve} that can be used as a mitigation for
368      * problems described in {IERC20-approve}.
369      *
370      * Emits an {Approval} event indicating the updated allowance.
371      *
372      * Requirements:
373      *
374      * - `spender` cannot be the zero address.
375      */
376     function increaseAllowance(
377         address spender,
378         uint256 addedValue
379     ) external returns (bool) {
380         address owner = _msgSender();
381         _approve(owner, spender, allowance(owner, spender) + addedValue);
382         return true;
383     }
384 
385     /**
386      * @dev Atomically decreases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      * - `spender` must have allowance for the caller of at least
397      * `subtractedValue`.
398      */
399     function decreaseAllowance(
400         address spender,
401         uint256 subtractedValue
402     ) external returns (bool) {
403         address owner = _msgSender();
404         uint256 currentAllowance = allowance(owner, spender);
405         require(
406             currentAllowance >= subtractedValue,
407             "ERC20: decreased allowance below zero"
408         );
409         unchecked {
410             _approve(owner, spender, currentAllowance - subtractedValue);
411         }
412 
413         return true;
414     }
415 
416     /**
417      * @dev Moves `amount` of tokens from `from` to `to`.
418      *
419      * This internal function is equivalent to {transfer}, and can be used to
420      * e.g. implement automatic token fees, slashing mechanisms, etc.
421      *
422      * Emits a {Transfer} event.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `from` must have a balance of at least `amount`.
429      */
430     function _transfer(address from, address to, uint256 amount) private {
431         require(from != address(0), "ERC20: transfer from the zero address");
432         require(to != address(0), "ERC20: transfer to the zero address");
433 
434         uint256 fromBalance = _balances[from];
435         require(
436             fromBalance >= amount,
437             "ERC20: transfer amount exceeds balance"
438         );
439         unchecked {
440             _balances[from] = fromBalance - amount;
441             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
442             // decrementing then incrementing.
443             _balances[to] += amount;
444         }
445 
446         emit Transfer(from, to, amount);
447     }
448 
449     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
450      * the total supply.
451      *
452      * Emits a {Transfer} event with `from` set to the zero address.
453      *
454      * Requirements:
455      *
456      * - `account` cannot be the zero address.
457      */
458     function _mint(address account, uint256 amount) private {
459         require(account != address(0), "ERC20: mint to the zero address");
460 
461         _totalSupply += amount;
462         unchecked {
463             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
464             _balances[account] += amount;
465         }
466         emit Transfer(address(0), account, amount);
467     }
468 
469     /**
470      * @dev Destroys `amount` tokens from `account`, reducing the
471      * total supply.
472      *
473      * Emits a {Transfer} event with `to` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      * - `account` must have at least `amount` tokens.
479      */
480     function _burn(address account, uint256 amount) private {
481         require(account != address(0), "ERC20: burn from the zero address");
482 
483         uint256 accountBalance = _balances[account];
484         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
485         unchecked {
486             _balances[account] = accountBalance - amount;
487             // Overflow not possible: amount <= accountBalance <= totalSupply.
488             _totalSupply -= amount;
489             _burnAmount += amount;
490         }
491 
492         emit Transfer(account, address(0), amount);
493     }
494 
495     /**
496      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
497      *
498      * This internal function is equivalent to `approve`, and can be used to
499      * e.g. set automatic allowances for certain subsystems, etc.
500      *
501      * Emits an {Approval} event.
502      *
503      * Requirements:
504      *
505      * - `owner` cannot be the zero address.
506      * - `spender` cannot be the zero address.
507      */
508     function _approve(address owner, address spender, uint256 amount) private {
509         require(owner != address(0), "ERC20: approve from the zero address");
510         require(spender != address(0), "ERC20: approve to the zero address");
511 
512         _allowances[owner][spender] = amount;
513         emit Approval(owner, spender, amount);
514     }
515 
516     /**
517      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
518      *
519      * Does not update the allowance amount in case of infinite allowance.
520      * Revert if not enough allowance is available.
521      *
522      * Might emit an {Approval} event.
523      */
524     function _spendAllowance(
525         address owner,
526         address spender,
527         uint256 amount
528     ) private {
529         uint256 currentAllowance = allowance(owner, spender);
530         if (currentAllowance != type(uint256).max) {
531             require(
532                 currentAllowance >= amount,
533                 "ERC20: insufficient allowance"
534             );
535             unchecked {
536                 _approve(owner, spender, currentAllowance - amount);
537             }
538         }
539     }
540 }