1 // SPDX-License-Identifier: MIT
2 /**
3  * _______ _             ____       _       _             _   _____
4  * |__   __| |           / __ \     (_)     (_)           | | |  __ \
5  *    | |  | |__   ___  | |  | |_ __ _  __ _ _ _ __   __ _| | | |__) |__ _ __   ___
6  *    | |  | '_ \ / _ \ | |  | | '__| |/ _` | | '_ \ / _` | | |  ___/ _ \ '_ \ / _ \
7  *    | |  | | | |  __/ | |__| | |  | | (_| | | | | | (_| | | | |  |  __/ |_) |  __/
8  *    |_|  |_| |_|\___|  \____/|_|  |_|\__, |_|_| |_|\__,_|_| |_|   \___| .__/ \___|
9  *                                      __/ |                           | |
10  *                                     |___/                            |_|
11  *
12  *⠀⢀⠔⠂⠉⠉⠉⠉⠑⠢⡄⣀⠔⠊⠁⠀⠒⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13  *⡰⠁⠀⠀⠀⠀⢀⣀⣀⣀⠘⡇⠀⠀⠀⠀⠀⠀⠘⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14  *⠁⠀⠀⣠⠔⠉⠁⠀⠀⠀⠉⠉⠲⣤⠖⠒⠒⠒⠲⠬⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀
15  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀
16  *⠀⠀⠀⣠⠔⣊⠭⠭⠭⠭⢭⣛⠩⣉⠲⣇⠀⠀⢀⣶⠶⢦⣶⢷⣤⡀⠀⠀⠀⠀
17  *⠀⠀⢸⣵⣉⡤⠤⢤⣤⣤⣤⣬⠵⠮⣶⣌⣇⠐⣫⣶⣭⣭⣍⡑⢼⠁⠀⠀⠀⠀
18  *⠀⠀⠀⠀⠈⣅⠲⣿⣞⣿⣉⣿⠀⠀⠘⡎⣇⡜⣿⣾⣿⣹⡇⠈⣽⠀⠀⠀⠀⠀
19  *⠀⠀⠀⠀⠀⠀⠓⠤⢈⣉⣛⣓⣂⣒⣊⡽⠂⢹⣛⠛⢛⠛⣒⣩⠞⠀⠀⠀⠀⠀
20  *⠀⠠⠤⠂⠀⠀⠀⠀⠀⠀⠀⠀⣀⠼⠁⠀⠀⠀⠈⠫⡁⠐⠛⠁⠱⡀⠀⠀⠀⠀
21  *⢠⢶⠭⠭⣄⣀⠀⠀⠀⠤⠒⠉⠁⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⢰⢻⠄⠀⠀⠀
22  *⠀⠘⢦⣙⠲⠤⣍⡉⠑⠒⠢⠤⠤⠤⣀⣀⣀⣀⣀⣀⣀⣀⣀⠔⣡⠊⠀⠀⠀⠀
23  *⠀⠀⠀⠈⠉⠢⢄⡈⠉⠁⠀⠀⠒⠒⠦⠤⠤⠤⠤⠤⠤⠤⠤⠊⡸⠀⠀⠀⠀⠀
24  *⠀⠀⠀⠀⠀⠀⠀⠈⠙⠒⠂⠤⠤⠤⠤⢄⣀⣀⡤⠤⠤⢤⠤⠚⠅⠀⠀⠀⠀⠀
25  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠒⠓⢤⠞⠀⠀⠀⠀⠀⠀
26  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⢄⡠⢶⡁⠀⣀⣀⡀⢑⠢⣄⠀⠀⠀⠀
27  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠣⢶⠕⢋⢔⡵⠗⠁⠀⠈⠳⡀⠀⠀
28  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢣⠀⠘⣖⡝⠁⠀⢀⠔⠀⠀⠀⠘⣆⠀
29  *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⠀⠈⠑⠤⢠⠃⠀⣠⠞⢀⠄⠈⢆
30  *
31  * pepecoin
32  *
33  * website: https://pepeco.in
34  * telegram: T.me/pepecoins
35  *
36 */
37 
38 // File: @openzeppelin/contracts/utils/Context.sol
39 
40 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev Provides information about the current execution context, including the
46  * sender of the transaction and its data. While these are generally available
47  * via msg.sender and msg.data, they should not be accessed in such a direct
48  * manner, since when dealing with meta-transactions the account sending and
49  * paying for execution may not be the actual sender (as far as an application
50  * is concerned).
51  *
52  * This contract is only required for intermediate, library-like contracts.
53  */
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 
59     function _msgData() internal view virtual returns (bytes calldata) {
60         return msg.data;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/access/Ownable.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 
72 /**
73  * @dev Contract module which provides a basic access control mechanism, where
74  * there is an account (an owner) that can be granted exclusive access to
75  * specific functions.
76  *
77  * By default, the owner account will be the one that deploys the contract. This
78  * can later be changed with {transferOwnership}.
79  *
80  * This module is used through inheritance. It will make available the modifier
81  * `onlyOwner`, which can be applied to your functions to restrict their use to
82  * the owner.
83  */
84 abstract contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     /**
90      * @dev Initializes the contract setting the deployer as the initial owner.
91      */
92     constructor() {
93         _transferOwnership(_msgSender());
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         _checkOwner();
101         _;
102     }
103 
104     /**
105      * @dev Returns the address of the current owner.
106      */
107     function owner() public view virtual returns (address) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if the sender is not the owner.
113      */
114     function _checkOwner() internal view virtual {
115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
116     }
117 
118     /**
119      * @dev Leaves the contract without owner. It will not be possible to call
120      * `onlyOwner` functions anymore. Can only be called by the current owner.
121      *
122      * NOTE: Renouncing ownership will leave the contract without an owner,
123      * thereby removing any functionality that is only available to the owner.
124      */
125     function renounceOwnership() public virtual onlyOwner {
126         _transferOwnership(address(0));
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Can only be called by the current owner.
132      */
133     function transferOwnership(address newOwner) public virtual onlyOwner {
134         require(newOwner != address(0), "Ownable: new owner is the zero address");
135         _transferOwnership(newOwner);
136     }
137 
138     /**
139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
140      * Internal function without access restriction.
141      */
142     function _transferOwnership(address newOwner) internal virtual {
143         address oldOwner = _owner;
144         _owner = newOwner;
145         emit OwnershipTransferred(oldOwner, newOwner);
146     }
147 }
148 
149 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
150 
151 
152 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Interface of the ERC20 standard as defined in the EIP.
158  */
159 interface IERC20 {
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 
174     /**
175      * @dev Returns the amount of tokens in existence.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183 
184     /**
185      * @dev Moves `amount` tokens from the caller's account to `to`.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transfer(address to, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Returns the remaining number of tokens that `spender` will be
195      * allowed to spend on behalf of `owner` through {transferFrom}. This is
196      * zero by default.
197      *
198      * This value changes when {approve} or {transferFrom} are called.
199      */
200     function allowance(address owner, address spender) external view returns (uint256);
201 
202     /**
203      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * IMPORTANT: Beware that changing an allowance with this method brings the risk
208      * that someone may use both the old and the new allowance by unfortunate
209      * transaction ordering. One possible solution to mitigate this race
210      * condition is to first reduce the spender's allowance to 0 and set the
211      * desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address spender, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Moves `amount` tokens from `from` to `to` using the
220      * allowance mechanism. `amount` is then deducted from the caller's
221      * allowance.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transferFrom(
228         address from,
229         address to,
230         uint256 amount
231     ) external returns (bool);
232 }
233 
234 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 /**
243  * @dev Interface for the optional metadata functions from the ERC20 standard.
244  *
245  * _Available since v4.1._
246  */
247 interface IERC20Metadata is IERC20 {
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() external view returns (string memory);
252 
253     /**
254      * @dev Returns the symbol of the token.
255      */
256     function symbol() external view returns (string memory);
257 
258     /**
259      * @dev Returns the decimals places of the token.
260      */
261     function decimals() external view returns (uint8);
262 }
263 
264 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
265 
266 
267 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 
272 
273 
274 /**
275  * @dev Implementation of the {IERC20} interface.
276  *
277  * This implementation is agnostic to the way tokens are created. This means
278  * that a supply mechanism has to be added in a derived contract using {_mint}.
279  * For a generic mechanism see {ERC20PresetMinterPauser}.
280  *
281  * TIP: For a detailed writeup see our guide
282  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
283  * to implement supply mechanisms].
284  *
285  * We have followed general OpenZeppelin Contracts guidelines: functions revert
286  * instead returning `false` on failure. This behavior is nonetheless
287  * conventional and does not conflict with the expectations of ERC20
288  * applications.
289  *
290  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
291  * This allows applications to reconstruct the allowance for all accounts just
292  * by listening to said events. Other implementations of the EIP may not emit
293  * these events, as it isn't required by the specification.
294  *
295  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
296  * functions have been added to mitigate the well-known issues around setting
297  * allowances. See {IERC20-approve}.
298  */
299 contract ERC20 is Context, IERC20, IERC20Metadata {
300     mapping(address => uint256) private _balances;
301 
302     mapping(address => mapping(address => uint256)) private _allowances;
303 
304     uint256 private _totalSupply;
305 
306     string private _name;
307     string private _symbol;
308 
309     /**
310      * @dev Sets the values for {name} and {symbol}.
311      *
312      * The default value of {decimals} is 18. To select a different value for
313      * {decimals} you should overload it.
314      *
315      * All two of these values are immutable: they can only be set once during
316      * construction.
317      */
318     constructor(string memory name_, string memory symbol_) {
319         _name = name_;
320         _symbol = symbol_;
321     }
322 
323     /**
324      * @dev Returns the name of the token.
325      */
326     function name() public view virtual override returns (string memory) {
327         return _name;
328     }
329 
330     /**
331      * @dev Returns the symbol of the token, usually a shorter version of the
332      * name.
333      */
334     function symbol() public view virtual override returns (string memory) {
335         return _symbol;
336     }
337 
338     /**
339      * @dev Returns the number of decimals used to get its user representation.
340      * For example, if `decimals` equals `2`, a balance of `505` tokens should
341      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
342      *
343      * Tokens usually opt for a value of 18, imitating the relationship between
344      * Ether and Wei. This is the value {ERC20} uses, unless this function is
345      * overridden;
346      *
347      * NOTE: This information is only used for _display_ purposes: it in
348      * no way affects any of the arithmetic of the contract, including
349      * {IERC20-balanceOf} and {IERC20-transfer}.
350      */
351     function decimals() public view virtual override returns (uint8) {
352         return 18;
353     }
354 
355     /**
356      * @dev See {IERC20-totalSupply}.
357      */
358     function totalSupply() public view virtual override returns (uint256) {
359         return _totalSupply;
360     }
361 
362     /**
363      * @dev See {IERC20-balanceOf}.
364      */
365     function balanceOf(address account) public view virtual override returns (uint256) {
366         return _balances[account];
367     }
368 
369     /**
370      * @dev See {IERC20-transfer}.
371      *
372      * Requirements:
373      *
374      * - `to` cannot be the zero address.
375      * - the caller must have a balance of at least `amount`.
376      */
377     function transfer(address to, uint256 amount) public virtual override returns (bool) {
378         address owner = _msgSender();
379         _transfer(owner, to, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-allowance}.
385      */
386     function allowance(address owner, address spender) public view virtual override returns (uint256) {
387         return _allowances[owner][spender];
388     }
389 
390     /**
391      * @dev See {IERC20-approve}.
392      *
393      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
394      * `transferFrom`. This is semantically equivalent to an infinite approval.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function approve(address spender, uint256 amount) public virtual override returns (bool) {
401         address owner = _msgSender();
402         _approve(owner, spender, amount);
403         return true;
404     }
405 
406     /**
407      * @dev See {IERC20-transferFrom}.
408      *
409      * Emits an {Approval} event indicating the updated allowance. This is not
410      * required by the EIP. See the note at the beginning of {ERC20}.
411      *
412      * NOTE: Does not update the allowance if the current allowance
413      * is the maximum `uint256`.
414      *
415      * Requirements:
416      *
417      * - `from` and `to` cannot be the zero address.
418      * - `from` must have a balance of at least `amount`.
419      * - the caller must have allowance for ``from``'s tokens of at least
420      * `amount`.
421      */
422     function transferFrom(
423         address from,
424         address to,
425         uint256 amount
426     ) public virtual override returns (bool) {
427         address spender = _msgSender();
428         _spendAllowance(from, spender, amount);
429         _transfer(from, to, amount);
430         return true;
431     }
432 
433     /**
434      * @dev Atomically increases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
446         address owner = _msgSender();
447         _approve(owner, spender, allowance(owner, spender) + addedValue);
448         return true;
449     }
450 
451     /**
452      * @dev Atomically decreases the allowance granted to `spender` by the caller.
453      *
454      * This is an alternative to {approve} that can be used as a mitigation for
455      * problems described in {IERC20-approve}.
456      *
457      * Emits an {Approval} event indicating the updated allowance.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      * - `spender` must have allowance for the caller of at least
463      * `subtractedValue`.
464      */
465     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
466         address owner = _msgSender();
467         uint256 currentAllowance = allowance(owner, spender);
468         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
469         unchecked {
470             _approve(owner, spender, currentAllowance - subtractedValue);
471         }
472 
473         return true;
474     }
475 
476     /**
477      * @dev Moves `amount` of tokens from `from` to `to`.
478      *
479      * This internal function is equivalent to {transfer}, and can be used to
480      * e.g. implement automatic token fees, slashing mechanisms, etc.
481      *
482      * Emits a {Transfer} event.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `from` must have a balance of at least `amount`.
489      */
490     function _transfer(
491         address from,
492         address to,
493         uint256 amount
494     ) internal virtual {
495         require(from != address(0), "ERC20: transfer from the zero address");
496         require(to != address(0), "ERC20: transfer to the zero address");
497 
498         _beforeTokenTransfer(from, to, amount);
499 
500         uint256 fromBalance = _balances[from];
501         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
502         unchecked {
503             _balances[from] = fromBalance - amount;
504             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
505             // decrementing then incrementing.
506             _balances[to] += amount;
507         }
508 
509         emit Transfer(from, to, amount);
510 
511         _afterTokenTransfer(from, to, amount);
512     }
513 
514     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
515      * the total supply.
516      *
517      * Emits a {Transfer} event with `from` set to the zero address.
518      *
519      * Requirements:
520      *
521      * - `account` cannot be the zero address.
522      */
523     function _mint(address account, uint256 amount) internal virtual {
524         require(account != address(0), "ERC20: mint to the zero address");
525 
526         _beforeTokenTransfer(address(0), account, amount);
527 
528         _totalSupply += amount;
529         unchecked {
530             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
531             _balances[account] += amount;
532         }
533         emit Transfer(address(0), account, amount);
534 
535         _afterTokenTransfer(address(0), account, amount);
536     }
537 
538     /**
539      * @dev Destroys `amount` tokens from `account`, reducing the
540      * total supply.
541      *
542      * Emits a {Transfer} event with `to` set to the zero address.
543      *
544      * Requirements:
545      *
546      * - `account` cannot be the zero address.
547      * - `account` must have at least `amount` tokens.
548      */
549     function _burn(address account, uint256 amount) internal virtual {
550         require(account != address(0), "ERC20: burn from the zero address");
551 
552         _beforeTokenTransfer(account, address(0), amount);
553 
554         uint256 accountBalance = _balances[account];
555         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
556         unchecked {
557             _balances[account] = accountBalance - amount;
558             // Overflow not possible: amount <= accountBalance <= totalSupply.
559             _totalSupply -= amount;
560         }
561 
562         emit Transfer(account, address(0), amount);
563 
564         _afterTokenTransfer(account, address(0), amount);
565     }
566 
567     /**
568      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
569      *
570      * This internal function is equivalent to `approve`, and can be used to
571      * e.g. set automatic allowances for certain subsystems, etc.
572      *
573      * Emits an {Approval} event.
574      *
575      * Requirements:
576      *
577      * - `owner` cannot be the zero address.
578      * - `spender` cannot be the zero address.
579      */
580     function _approve(
581         address owner,
582         address spender,
583         uint256 amount
584     ) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     /**
593      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
594      *
595      * Does not update the allowance amount in case of infinite allowance.
596      * Revert if not enough allowance is available.
597      *
598      * Might emit an {Approval} event.
599      */
600     function _spendAllowance(
601         address owner,
602         address spender,
603         uint256 amount
604     ) internal virtual {
605         uint256 currentAllowance = allowance(owner, spender);
606         if (currentAllowance != type(uint256).max) {
607             require(currentAllowance >= amount, "ERC20: insufficient allowance");
608             unchecked {
609                 _approve(owner, spender, currentAllowance - amount);
610             }
611         }
612     }
613 
614     /**
615      * @dev Hook that is called before any transfer of tokens. This includes
616      * minting and burning.
617      *
618      * Calling conditions:
619      *
620      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
621      * will be transferred to `to`.
622      * - when `from` is zero, `amount` tokens will be minted for `to`.
623      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
624      * - `from` and `to` are never both zero.
625      *
626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
627      */
628     function _beforeTokenTransfer(
629         address from,
630         address to,
631         uint256 amount
632     ) internal virtual {}
633 
634     /**
635      * @dev Hook that is called after any transfer of tokens. This includes
636      * minting and burning.
637      *
638      * Calling conditions:
639      *
640      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
641      * has been transferred to `to`.
642      * - when `from` is zero, `amount` tokens have been minted for `to`.
643      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
644      * - `from` and `to` are never both zero.
645      *
646      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
647      */
648     function _afterTokenTransfer(
649         address from,
650         address to,
651         uint256 amount
652     ) internal virtual {}
653 }
654 
655 // File: v11.sol
656 
657 pragma solidity ^0.8.0;
658 
659 
660 
661 contract pepeCoin is ERC20, Ownable {
662     uint256 private _totalSupply = 133769420 * (10 ** 18);
663     uint256 private _tokenPrice = 200000 * (10 ** 18);
664 
665     constructor() ERC20("pepeCoin", "pepecoin") {
666         _mint(msg.sender, _totalSupply);
667     }
668 
669     function withdraw() external onlyOwner {
670         uint256 balance = address(this).balance;
671         require(balance > 0, "No balance to withdraw");
672         payable(msg.sender).transfer(balance);
673     }
674 
675     function setTokenPrice(uint256 newTokenPrice) external onlyOwner {
676         require(newTokenPrice > 0, "Token price should be greater than 0");
677         _tokenPrice = newTokenPrice;
678     }
679 
680     function getTokenPrice() external view returns (uint256) {
681         return _tokenPrice;
682     }
683 
684     function burn(uint256 amount) external {
685         require(amount > 0, "Amount to burn should be greater than 0");
686         require(balanceOf(msg.sender) >= amount, "Not enough tokens to burn");
687         _burn(msg.sender, amount);
688     }
689 }