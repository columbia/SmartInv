1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 /*
5 Welcome to Genesis
6 
7 This is an experiment in decentralization with the objective of providing a fair blueprint that others can eventually improve upon.
8 
9 The code was written by Chat GPT.  I am not a developer or a team.
10 
11 The intial supply is 500,000,000 tokens that will be locked in uniswap V3 at a starting marketcap of around 100k USD.
12 
13 The total supply is 1,000,000,000 tokens.
14 
15 Assuming this actually works, any single wallet will be able to mint directly from the contract one time each a quantity of 100,000 tokens.
16 
17 Once the total supply has been minted, nobody should then be able to continue minting the token.
18 
19 V3 is being utilized with a set marketcap (i.e. no eth will be including in making the pair) so that nobody can then simply dump their tokens as they mint.  
20 
21 There will be no telegram or socials for this token.  
22 
23 If a community wishes to create one, by all means take the initiative.
24 
25 I hope that the outcome is the ushering of a new approach to token deployment in which everyone can mint tokens for free and share the excitement that web3
26 has to offer but with much less risk initially.
27 */
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         return msg.data;
50     }
51 }
52 
53 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
54 
55 
56 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev Interface of the ERC20 standard as defined in the EIP.
62  */
63 interface IERC20 {
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 
78     /**
79      * @dev Returns the amount of tokens in existence.
80      */
81     function totalSupply() external view returns (uint256);
82 
83     /**
84      * @dev Returns the amount of tokens owned by `account`.
85      */
86     function balanceOf(address account) external view returns (uint256);
87 
88     /**
89      * @dev Moves `amount` tokens from the caller's account to `to`.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transfer(address to, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Returns the remaining number of tokens that `spender` will be
99      * allowed to spend on behalf of `owner` through {transferFrom}. This is
100      * zero by default.
101      *
102      * This value changes when {approve} or {transferFrom} are called.
103      */
104     function allowance(address owner, address spender) external view returns (uint256);
105 
106     /**
107      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * IMPORTANT: Beware that changing an allowance with this method brings the risk
112      * that someone may use both the old and the new allowance by unfortunate
113      * transaction ordering. One possible solution to mitigate this race
114      * condition is to first reduce the spender's allowance to 0 and set the
115      * desired value afterwards:
116      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address spender, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Moves `amount` tokens from `from` to `to` using the
124      * allowance mechanism. `amount` is then deducted from the caller's
125      * allowance.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(address from, address to, uint256 amount) external returns (bool);
132 }
133 
134 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 
142 /**
143  * @dev Interface for the optional metadata functions from the ERC20 standard.
144  *
145  * _Available since v4.1._
146  */
147 interface IERC20Metadata is IERC20 {
148     /**
149      * @dev Returns the name of the token.
150      */
151     function name() external view returns (string memory);
152 
153     /**
154      * @dev Returns the symbol of the token.
155      */
156     function symbol() external view returns (string memory);
157 
158     /**
159      * @dev Returns the decimals places of the token.
160      */
161     function decimals() external view returns (uint8);
162 }
163 
164 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
165 
166 
167 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 
173 
174 /**
175  * @dev Implementation of the {IERC20} interface.
176  *
177  * This implementation is agnostic to the way tokens are created. This means
178  * that a supply mechanism has to be added in a derived contract using {_mint}.
179  * For a generic mechanism see {ERC20PresetMinterPauser}.
180  *
181  * TIP: For a detailed writeup see our guide
182  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
183  * to implement supply mechanisms].
184  *
185  * The default value of {decimals} is 18. To change this, you should override
186  * this function so it returns a different value.
187  *
188  * We have followed general OpenZeppelin Contracts guidelines: functions revert
189  * instead returning `false` on failure. This behavior is nonetheless
190  * conventional and does not conflict with the expectations of ERC20
191  * applications.
192  *
193  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
194  * This allows applications to reconstruct the allowance for all accounts just
195  * by listening to said events. Other implementations of the EIP may not emit
196  * these events, as it isn't required by the specification.
197  *
198  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
199  * functions have been added to mitigate the well-known issues around setting
200  * allowances. See {IERC20-approve}.
201  */
202 contract ERC20 is Context, IERC20, IERC20Metadata {
203     mapping(address => uint256) private _balances;
204 
205     mapping(address => mapping(address => uint256)) private _allowances;
206 
207     uint256 private _totalSupply;
208 
209     string private _name;
210     string private _symbol;
211 
212     /**
213      * @dev Sets the values for {name} and {symbol}.
214      *
215      * All two of these values are immutable: they can only be set once during
216      * construction.
217      */
218     constructor(string memory name_, string memory symbol_) {
219         _name = name_;
220         _symbol = symbol_;
221     }
222 
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() public view virtual override returns (string memory) {
227         return _name;
228     }
229 
230     /**
231      * @dev Returns the symbol of the token, usually a shorter version of the
232      * name.
233      */
234     function symbol() public view virtual override returns (string memory) {
235         return _symbol;
236     }
237 
238     /**
239      * @dev Returns the number of decimals used to get its user representation.
240      * For example, if `decimals` equals `2`, a balance of `505` tokens should
241      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
242      *
243      * Tokens usually opt for a value of 18, imitating the relationship between
244      * Ether and Wei. This is the default value returned by this function, unless
245      * it's overridden.
246      *
247      * NOTE: This information is only used for _display_ purposes: it in
248      * no way affects any of the arithmetic of the contract, including
249      * {IERC20-balanceOf} and {IERC20-transfer}.
250      */
251     function decimals() public view virtual override returns (uint8) {
252         return 18;
253     }
254 
255     /**
256      * @dev See {IERC20-totalSupply}.
257      */
258     function totalSupply() public view virtual override returns (uint256) {
259         return _totalSupply;
260     }
261 
262     /**
263      * @dev See {IERC20-balanceOf}.
264      */
265     function balanceOf(address account) public view virtual override returns (uint256) {
266         return _balances[account];
267     }
268 
269     /**
270      * @dev See {IERC20-transfer}.
271      *
272      * Requirements:
273      *
274      * - `to` cannot be the zero address.
275      * - the caller must have a balance of at least `amount`.
276      */
277     function transfer(address to, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _transfer(owner, to, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-allowance}.
285      */
286     function allowance(address owner, address spender) public view virtual override returns (uint256) {
287         return _allowances[owner][spender];
288     }
289 
290     /**
291      * @dev See {IERC20-approve}.
292      *
293      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
294      * `transferFrom`. This is semantically equivalent to an infinite approval.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function approve(address spender, uint256 amount) public virtual override returns (bool) {
301         address owner = _msgSender();
302         _approve(owner, spender, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-transferFrom}.
308      *
309      * Emits an {Approval} event indicating the updated allowance. This is not
310      * required by the EIP. See the note at the beginning of {ERC20}.
311      *
312      * NOTE: Does not update the allowance if the current allowance
313      * is the maximum `uint256`.
314      *
315      * Requirements:
316      *
317      * - `from` and `to` cannot be the zero address.
318      * - `from` must have a balance of at least `amount`.
319      * - the caller must have allowance for ``from``'s tokens of at least
320      * `amount`.
321      */
322     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
323         address spender = _msgSender();
324         _spendAllowance(from, spender, amount);
325         _transfer(from, to, amount);
326         return true;
327     }
328 
329     /**
330      * @dev Atomically increases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
342         address owner = _msgSender();
343         _approve(owner, spender, allowance(owner, spender) + addedValue);
344         return true;
345     }
346 
347     /**
348      * @dev Atomically decreases the allowance granted to `spender` by the caller.
349      *
350      * This is an alternative to {approve} that can be used as a mitigation for
351      * problems described in {IERC20-approve}.
352      *
353      * Emits an {Approval} event indicating the updated allowance.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      * - `spender` must have allowance for the caller of at least
359      * `subtractedValue`.
360      */
361     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
362         address owner = _msgSender();
363         uint256 currentAllowance = allowance(owner, spender);
364         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
365         unchecked {
366             _approve(owner, spender, currentAllowance - subtractedValue);
367         }
368 
369         return true;
370     }
371 
372     /**
373      * @dev Moves `amount` of tokens from `from` to `to`.
374      *
375      * This internal function is equivalent to {transfer}, and can be used to
376      * e.g. implement automatic token fees, slashing mechanisms, etc.
377      *
378      * Emits a {Transfer} event.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `from` must have a balance of at least `amount`.
385      */
386     function _transfer(address from, address to, uint256 amount) internal virtual {
387         require(from != address(0), "ERC20: transfer from the zero address");
388         require(to != address(0), "ERC20: transfer to the zero address");
389 
390         _beforeTokenTransfer(from, to, amount);
391 
392         uint256 fromBalance = _balances[from];
393         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
394         unchecked {
395             _balances[from] = fromBalance - amount;
396             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
397             // decrementing then incrementing.
398             _balances[to] += amount;
399         }
400 
401         emit Transfer(from, to, amount);
402 
403         _afterTokenTransfer(from, to, amount);
404     }
405 
406     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
407      * the total supply.
408      *
409      * Emits a {Transfer} event with `from` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      */
415     function _mint(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: mint to the zero address");
417 
418         _beforeTokenTransfer(address(0), account, amount);
419 
420         _totalSupply += amount;
421         unchecked {
422             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
423             _balances[account] += amount;
424         }
425         emit Transfer(address(0), account, amount);
426 
427         _afterTokenTransfer(address(0), account, amount);
428     }
429 
430     /**
431      * @dev Destroys `amount` tokens from `account`, reducing the
432      * total supply.
433      *
434      * Emits a {Transfer} event with `to` set to the zero address.
435      *
436      * Requirements:
437      *
438      * - `account` cannot be the zero address.
439      * - `account` must have at least `amount` tokens.
440      */
441     function _burn(address account, uint256 amount) internal virtual {
442         require(account != address(0), "ERC20: burn from the zero address");
443 
444         _beforeTokenTransfer(account, address(0), amount);
445 
446         uint256 accountBalance = _balances[account];
447         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
448         unchecked {
449             _balances[account] = accountBalance - amount;
450             // Overflow not possible: amount <= accountBalance <= totalSupply.
451             _totalSupply -= amount;
452         }
453 
454         emit Transfer(account, address(0), amount);
455 
456         _afterTokenTransfer(account, address(0), amount);
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
481      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
482      *
483      * Does not update the allowance amount in case of infinite allowance.
484      * Revert if not enough allowance is available.
485      *
486      * Might emit an {Approval} event.
487      */
488     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
489         uint256 currentAllowance = allowance(owner, spender);
490         if (currentAllowance != type(uint256).max) {
491             require(currentAllowance >= amount, "ERC20: insufficient allowance");
492             unchecked {
493                 _approve(owner, spender, currentAllowance - amount);
494             }
495         }
496     }
497 
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
513 
514     /**
515      * @dev Hook that is called after any transfer of tokens. This includes
516      * minting and burning.
517      *
518      * Calling conditions:
519      *
520      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
521      * has been transferred to `to`.
522      * - when `from` is zero, `amount` tokens have been minted for `to`.
523      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
524      * - `from` and `to` are never both zero.
525      *
526      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
527      */
528     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
529 }
530 
531 // File: contracts/GENESIS.sol
532 
533 
534 
535 pragma solidity ^0.8.0;
536 
537 
538 contract GENESIS is ERC20 {
539     uint256 public maxSupply = 1000000000 * 10**18; // Total supply in Wei (smallest unit of Ether)
540     mapping(address => bool) public hasMinted;
541 
542     constructor() ERC20("GENESIS", "GENESIS") {
543         _mint(msg.sender, 500000000 * 10**18); // Set the initial supply to 500,000,000 tokens
544     }
545 
546     function mint100K() external {
547         require(!hasMinted[msg.sender], "You have already minted");
548         require(totalSupply() + 100000 * 10**18 <= maxSupply, "Maximum supply reached");
549 
550         _mint(msg.sender, 100000 * 10**18); // Mint 100,000 tokens to the caller
551         hasMinted[msg.sender] = true;
552     }
553 }