1 /*
2 
3  .----------------.  .----------------.  .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
4 | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
5 | |   _____      | || |     ____     | || | ____  _____  | || |    ______    | || |  ________    | || |     ____     | || |    ______    | || |  _________   | |
6 | |  |_   _|     | || |   .'    `.   | || ||_   \|_   _| | || |  .' ___  |   | || | |_   ___ `.  | || |   .'    `.   | || |  .' ___  |   | || | |_   ___  |  | |
7 | |    | |       | || |  /  .--.  \  | || |  |   \ | |   | || | / .'   \_|   | || |   | |   `. \ | || |  /  .--.  \  | || | / .'   \_|   | || |   | |_  \_|  | |
8 | |    | |   _   | || |  | |    | |  | || |  | |\ \| |   | || | | |    ____  | || |   | |    | | | || |  | |    | |  | || | | |    ____  | || |   |  _|  _   | |
9 | |   _| |__/ |  | || |  \  `--'  /  | || | _| |_\   |_  | || | \ `.___]  _| | || |  _| |___.' / | || |  \  `--'  /  | || | \ `.___]  _| | || |  _| |___/ |  | |
10 | |  |________|  | || |   `.____.'   | || ||_____|\____| | || |  `._____.'   | || | |________.'  | || |   `.____.'   | || |  `._____.'   | || | |_________|  | |
11 | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |
12 | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
13  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'
14 
15 LongDoge $WOW
16 Your doge is wow long
17 You have collected 5 wows
18 0 TAX
19 
20 Telegram - @LongDogeERC
21 Website - http://www.longdoge.xyz/
22 Twitter - https://twitter.com/LongDogeERC
23 
24 
25 
26 
27 */
28 
29 // File: @openzeppelin/contracts@4.6.0/utils/Context.sol
30 // SPDX-License-Identifier: Unlicensed
31 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Provides information about the current execution context, including the
37  * sender of the transaction and its data. While these are generally available
38  * via msg.sender and msg.data, they should not be accessed in such a direct
39  * manner, since when dealing with meta-transactions the account sending and
40  * paying for execution may not be the actual sender (as far as an application
41  * is concerned).
42  *
43  * This contract is only required for intermediate, library-like contracts.
44  */
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 
55 // File: @openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol
56 
57 
58 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @dev Interface of the ERC20 standard as defined in the EIP.
64  */
65 interface IERC20 {
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 
80     /**
81      * @dev Returns the amount of tokens in existence.
82      */
83     function totalSupply() external view returns (uint256);
84 
85     /**
86      * @dev Returns the amount of tokens owned by `account`.
87      */
88     function balanceOf(address account) external view returns (uint256);
89 
90     /**
91      * @dev Moves `amount` tokens from the caller's account to `to`.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transfer(address to, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Returns the remaining number of tokens that `spender` will be
101      * allowed to spend on behalf of `owner` through {transferFrom}. This is
102      * zero by default.
103      *
104      * This value changes when {approve} or {transferFrom} are called.
105      */
106     function allowance(address owner, address spender) external view returns (uint256);
107 
108     /**
109      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * IMPORTANT: Beware that changing an allowance with this method brings the risk
114      * that someone may use both the old and the new allowance by unfortunate
115      * transaction ordering. One possible solution to mitigate this race
116      * condition is to first reduce the spender's allowance to 0 and set the
117      * desired value afterwards:
118      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address spender, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Moves `amount` tokens from `from` to `to` using the
126      * allowance mechanism. `amount` is then deducted from the caller's
127      * allowance.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transferFrom(
134         address from,
135         address to,
136         uint256 amount
137     ) external returns (bool);
138 }
139 
140 // File: @openzeppelin/contracts@4.6.0/token/ERC20/extensions/IERC20Metadata.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 
148 /**
149  * @dev Interface for the optional metadata functions from the ERC20 standard.
150  *
151  * _Available since v4.1._
152  */
153 interface IERC20Metadata is IERC20 {
154     /**
155      * @dev Returns the name of the token.
156      */
157     function name() external view returns (string memory);
158 
159     /**
160      * @dev Returns the symbol of the token.
161      */
162     function symbol() external view returns (string memory);
163 
164     /**
165      * @dev Returns the decimals places of the token.
166      */
167     function decimals() external view returns (uint8);
168 }
169 
170 // File: @openzeppelin/contracts@4.6.0/token/ERC20/ERC20.sol
171 
172 
173 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 
178 
179 
180 /**
181  * @dev Implementation of the {IERC20} interface.
182  *
183  * This implementation is agnostic to the way tokens are created. This means
184  * that a supply mechanism has to be added in a derived contract using {_mint}.
185  * For a generic mechanism see {ERC20PresetMinterPauser}.
186  *
187  * TIP: For a detailed writeup see our guide
188  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
189  * to implement supply mechanisms].
190  *
191  * We have followed general OpenZeppelin Contracts guidelines: functions revert
192  * instead returning `false` on failure. This behavior is nonetheless
193  * conventional and does not conflict with the expectations of ERC20
194  * applications.
195  *
196  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
197  * This allows applications to reconstruct the allowance for all accounts just
198  * by listening to said events. Other implementations of the EIP may not emit
199  * these events, as it isn't required by the specification.
200  *
201  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
202  * functions have been added to mitigate the well-known issues around setting
203  * allowances. See {IERC20-approve}.
204  */
205 contract ERC20 is Context, IERC20, IERC20Metadata {
206     mapping(address => uint256) private _balances;
207 
208     mapping(address => mapping(address => uint256)) private _allowances;
209 
210     uint256 private _totalSupply;
211 
212     string private _name;
213     string private _symbol;
214 
215     /**
216      * @dev Sets the values for {name} and {symbol}.
217      *
218      * The default value of {decimals} is 18. To select a different value for
219      * {decimals} you should overload it.
220      *
221      * All two of these values are immutable: they can only be set once during
222      * construction.
223      */
224     constructor(string memory name_, string memory symbol_) {
225         _name = name_;
226         _symbol = symbol_;
227     }
228 
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() public view virtual override returns (string memory) {
233         return _name;
234     }
235 
236     /**
237      * @dev Returns the symbol of the token, usually a shorter version of the
238      * name.
239      */
240     function symbol() public view virtual override returns (string memory) {
241         return _symbol;
242     }
243 
244     /**
245      * @dev Returns the number of decimals used to get its user representation.
246      * For example, if `decimals` equals `2`, a balance of `505` tokens should
247      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
248      *
249      * Tokens usually opt for a value of 18, imitating the relationship between
250      * Ether and Wei. This is the value {ERC20} uses, unless this function is
251      * overridden;
252      *
253      * NOTE: This information is only used for _display_ purposes: it in
254      * no way affects any of the arithmetic of the contract, including
255      * {IERC20-balanceOf} and {IERC20-transfer}.
256      */
257     function decimals() public view virtual override returns (uint8) {
258         return 18;
259     }
260 
261     /**
262      * @dev See {IERC20-totalSupply}.
263      */
264     function totalSupply() public view virtual override returns (uint256) {
265         return _totalSupply;
266     }
267 
268     /**
269      * @dev See {IERC20-balanceOf}.
270      */
271     function balanceOf(address account) public view virtual override returns (uint256) {
272         return _balances[account];
273     }
274 
275     /**
276      * @dev See {IERC20-transfer}.
277      *
278      * Requirements:
279      *
280      * - `to` cannot be the zero address.
281      * - the caller must have a balance of at least `amount`.
282      */
283     function transfer(address to, uint256 amount) public virtual override returns (bool) {
284         address owner = _msgSender();
285         _transfer(owner, to, amount);
286         return true;
287     }
288 
289     /**
290      * @dev See {IERC20-allowance}.
291      */
292     function allowance(address owner, address spender) public view virtual override returns (uint256) {
293         return _allowances[owner][spender];
294     }
295 
296     /**
297      * @dev See {IERC20-approve}.
298      *
299      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
300      * `transferFrom`. This is semantically equivalent to an infinite approval.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function approve(address spender, uint256 amount) public virtual override returns (bool) {
307         address owner = _msgSender();
308         _approve(owner, spender, amount);
309         return true;
310     }
311 
312     /**
313      * @dev See {IERC20-transferFrom}.
314      *
315      * Emits an {Approval} event indicating the updated allowance. This is not
316      * required by the EIP. See the note at the beginning of {ERC20}.
317      *
318      * NOTE: Does not update the allowance if the current allowance
319      * is the maximum `uint256`.
320      *
321      * Requirements:
322      *
323      * - `from` and `to` cannot be the zero address.
324      * - `from` must have a balance of at least `amount`.
325      * - the caller must have allowance for ``from``'s tokens of at least
326      * `amount`.
327      */
328     function transferFrom(
329         address from,
330         address to,
331         uint256 amount
332     ) public virtual override returns (bool) {
333         address spender = _msgSender();
334         _spendAllowance(from, spender, amount);
335         _transfer(from, to, amount);
336         return true;
337     }
338 
339     /**
340      * @dev Atomically increases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
352         address owner = _msgSender();
353         _approve(owner, spender, allowance(owner, spender) + addedValue);
354         return true;
355     }
356 
357     /**
358      * @dev Atomically decreases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      * - `spender` must have allowance for the caller of at least
369      * `subtractedValue`.
370      */
371     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
372         address owner = _msgSender();
373         uint256 currentAllowance = allowance(owner, spender);
374         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
375         unchecked {
376             _approve(owner, spender, currentAllowance - subtractedValue);
377         }
378 
379         return true;
380     }
381 
382     /**
383      * @dev Moves `amount` of tokens from `sender` to `recipient`.
384      *
385      * This internal function is equivalent to {transfer}, and can be used to
386      * e.g. implement automatic token fees, slashing mechanisms, etc.
387      *
388      * Emits a {Transfer} event.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `from` must have a balance of at least `amount`.
395      */
396     function _transfer(
397         address from,
398         address to,
399         uint256 amount
400     ) internal virtual {
401         require(from != address(0), "ERC20: transfer from the zero address");
402         require(to != address(0), "ERC20: transfer to the zero address");
403 
404         _beforeTokenTransfer(from, to, amount);
405 
406         uint256 fromBalance = _balances[from];
407         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
408         unchecked {
409             _balances[from] = fromBalance - amount;
410         }
411         _balances[to] += amount;
412 
413         emit Transfer(from, to, amount);
414 
415         _afterTokenTransfer(from, to, amount);
416     }
417 
418     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
419      * the total supply.
420      *
421      * Emits a {Transfer} event with `from` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `account` cannot be the zero address.
426      */
427     function _mint(address account, uint256 amount) internal virtual {
428         require(account != address(0), "ERC20: mint to the zero address");
429 
430         _beforeTokenTransfer(address(0), account, amount);
431 
432         _totalSupply += amount;
433         _balances[account] += amount;
434         emit Transfer(address(0), account, amount);
435 
436         _afterTokenTransfer(address(0), account, amount);
437     }
438 
439     /**
440      * @dev Destroys `amount` tokens from `account`, reducing the
441      * total supply.
442      *
443      * Emits a {Transfer} event with `to` set to the zero address.
444      *
445      * Requirements:
446      *
447      * - `account` cannot be the zero address.
448      * - `account` must have at least `amount` tokens.
449      */
450     function _burn(address account, uint256 amount) internal virtual {
451         require(account != address(0), "ERC20: burn from the zero address");
452 
453         _beforeTokenTransfer(account, address(0), amount);
454 
455         uint256 accountBalance = _balances[account];
456         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
457         unchecked {
458             _balances[account] = accountBalance - amount;
459         }
460         _totalSupply -= amount;
461 
462         emit Transfer(account, address(0), amount);
463 
464         _afterTokenTransfer(account, address(0), amount);
465     }
466 
467     /**
468      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
469      *
470      * This internal function is equivalent to `approve`, and can be used to
471      * e.g. set automatic allowances for certain subsystems, etc.
472      *
473      * Emits an {Approval} event.
474      *
475      * Requirements:
476      *
477      * - `owner` cannot be the zero address.
478      * - `spender` cannot be the zero address.
479      */
480     function _approve(
481         address owner,
482         address spender,
483         uint256 amount
484     ) internal virtual {
485         require(owner != address(0), "ERC20: approve from the zero address");
486         require(spender != address(0), "ERC20: approve to the zero address");
487 
488         _allowances[owner][spender] = amount;
489         emit Approval(owner, spender, amount);
490     }
491 
492     /**
493      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
494      *
495      * Does not update the allowance amount in case of infinite allowance.
496      * Revert if not enough allowance is available.
497      *
498      * Might emit an {Approval} event.
499      */
500     function _spendAllowance(
501         address owner,
502         address spender,
503         uint256 amount
504     ) internal virtual {
505         uint256 currentAllowance = allowance(owner, spender);
506         if (currentAllowance != type(uint256).max) {
507             require(currentAllowance >= amount, "ERC20: insufficient allowance");
508             unchecked {
509                 _approve(owner, spender, currentAllowance - amount);
510             }
511         }
512     }
513 
514     /**
515      * @dev Hook that is called before any transfer of tokens. This includes
516      * minting and burning.
517      *
518      * Calling conditions:
519      *
520      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
521      * will be transferred to `to`.
522      * - when `from` is zero, `amount` tokens will be minted for `to`.
523      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
524      * - `from` and `to` are never both zero.
525      *
526      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
527      */
528     function _beforeTokenTransfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal virtual {}
533 
534     /**
535      * @dev Hook that is called after any transfer of tokens. This includes
536      * minting and burning.
537      *
538      * Calling conditions:
539      *
540      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
541      * has been transferred to `to`.
542      * - when `from` is zero, `amount` tokens have been minted for `to`.
543      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
544      * - `from` and `to` are never both zero.
545      *
546      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
547      */
548     function _afterTokenTransfer(
549         address from,
550         address to,
551         uint256 amount
552     ) internal virtual {}
553 }
554 
555 // File: Faith.sol
556 
557 
558 pragma solidity ^0.8.4;
559 
560 
561 contract LongDoge is ERC20 {
562     constructor() ERC20("LongDoge", "WOW") {
563         _mint(msg.sender, 100000 * 10 ** decimals());
564     }
565 }