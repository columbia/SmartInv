1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.0;
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
107 
108 //pragma solidity ^0.8.0;
109 
110 //import "../IERC20.sol";
111 
112 /**
113  * @dev Interface for the optional metadata functions from the ERC20 standard.
114  *
115  * _Available since v4.1._
116  */
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 
135 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
136 
137 
138 //import "./IERC20.sol";
139 //import "./extensions/IERC20Metadata.sol";
140 //import "../../utils/Context.sol";
141 
142 /**
143  * @dev Implementation of the {IERC20} interface.
144  *
145  * This implementation is agnostic to the way tokens are created. This means
146  * that a supply mechanism has to be added in a derived contract using {_mint}.
147  * For a generic mechanism see {ERC20PresetMinterPauser}.
148  *
149  * TIP: For a detailed writeup see our guide
150  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
151  * to implement supply mechanisms].
152  *
153  * We have followed general OpenZeppelin Contracts guidelines: functions revert
154  * instead returning `false` on failure. This behavior is nonetheless
155  * conventional and does not conflict with the expectations of ERC20
156  * applications.
157  *
158  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
159  * This allows applications to reconstruct the allowance for all accounts just
160  * by listening to said events. Other implementations of the EIP may not emit
161  * these events, as it isn't required by the specification.
162  *
163  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
164  * functions have been added to mitigate the well-known issues around setting
165  * allowances. See {IERC20-approve}.
166  */
167 contract ERC20 is Context, IERC20, IERC20Metadata {
168     mapping(address => uint256) private _balances;
169 
170     mapping(address => mapping(address => uint256)) private _allowances;
171 
172     uint256 private _totalSupply;
173 
174     string private _name;
175     string private _symbol;
176 
177     /**
178      * @dev Sets the values for {name} and {symbol}.
179      *
180      * The default value of {decimals} is 18. To select a different value for
181      * {decimals} you should overload it.
182      *
183      * All two of these values are immutable: they can only be set once during
184      * construction.
185      */
186     constructor(string memory name_, string memory symbol_) {
187         _name = name_;
188         _symbol = symbol_;
189     }
190 
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() public view virtual override returns (string memory) {
195         return _name;
196     }
197 
198     /**
199      * @dev Returns the symbol of the token, usually a shorter version of the
200      * name.
201      */
202     function symbol() public view virtual override returns (string memory) {
203         return _symbol;
204     }
205 
206     /**
207      * @dev Returns the number of decimals used to get its user representation.
208      * For example, if `decimals` equals `2`, a balance of `505` tokens should
209      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
210      *
211      * Tokens usually opt for a value of 18, imitating the relationship between
212      * Ether and Wei. This is the value {ERC20} uses, unless this function is
213      * overridden;
214      *
215      * NOTE: This information is only used for _display_ purposes: it in
216      * no way affects any of the arithmetic of the contract, including
217      * {IERC20-balanceOf} and {IERC20-transfer}.
218      */
219     function decimals() public view virtual override returns (uint8) {
220         return 18;
221     }
222 
223     /**
224      * @dev See {IERC20-totalSupply}.
225      */
226     function totalSupply() public view virtual override returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231      * @dev See {IERC20-balanceOf}.
232      */
233     function balanceOf(address account) public view virtual override returns (uint256) {
234         return _balances[account];
235     }
236 
237     /**
238      * @dev See {IERC20-transfer}.
239      *
240      * Requirements:
241      *
242      * - `to` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address to, uint256 amount) public virtual override returns (bool) {
246         address owner = _msgSender();
247         _transfer(owner, to, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-allowance}.
253      */
254     function allowance(address owner, address spender) public view virtual override returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * @dev See {IERC20-approve}.
260      *
261      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
262      * `transferFrom`. This is semantically equivalent to an infinite approval.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 amount) public virtual override returns (bool) {
269         address owner = _msgSender();
270         _approve(owner, spender, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-transferFrom}.
276      *
277      * Emits an {Approval} event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of {ERC20}.
279      *
280      * NOTE: Does not update the allowance if the current allowance
281      * is the maximum `uint256`.
282      *
283      * Requirements:
284      *
285      * - `from` and `to` cannot be the zero address.
286      * - `from` must have a balance of at least `amount`.
287      * - the caller must have allowance for ``from``'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(
291         address from,
292         address to,
293         uint256 amount
294     ) public virtual override returns (bool) {
295         address spender = _msgSender();
296         _spendAllowance(from, spender, amount);
297         _transfer(from, to, amount);
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         address owner = _msgSender();
315         _approve(owner, spender, _allowances[owner][spender] + addedValue);
316         return true;
317     }
318 
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
334         address owner = _msgSender();
335         uint256 currentAllowance = _allowances[owner][spender];
336         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
337         unchecked {
338             _approve(owner, spender, currentAllowance - subtractedValue);
339         }
340 
341         return true;
342     }
343 
344     /**
345      * @dev Moves `amount` of tokens from `sender` to `recipient`.
346      *
347      * This internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `from` cannot be the zero address.
355      * - `to` cannot be the zero address.
356      * - `from` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address from,
360         address to,
361         uint256 amount
362     ) internal virtual {
363         require(from != address(0), "ERC20: transfer from the zero address");
364         require(to != address(0), "ERC20: transfer to the zero address");
365 
366         _beforeTokenTransfer(from, to, amount);
367 
368         uint256 fromBalance = _balances[from];
369         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
370         unchecked {
371             _balances[from] = fromBalance - amount;
372         }
373         _balances[to] += amount;
374 
375         emit Transfer(from, to, amount);
376 
377         _afterTokenTransfer(from, to, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply += amount;
395         _balances[account] += amount;
396         emit Transfer(address(0), account, amount);
397 
398         _afterTokenTransfer(address(0), account, amount);
399     }
400 
401     /**
402      * @dev Destroys `amount` tokens from `account`, reducing the
403      * total supply.
404      *
405      * Emits a {Transfer} event with `to` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      * - `account` must have at least `amount` tokens.
411      */
412     function _burn(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: burn from the zero address");
414 
415         _beforeTokenTransfer(account, address(0), amount);
416 
417         uint256 accountBalance = _balances[account];
418         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
419         unchecked {
420             _balances[account] = accountBalance - amount;
421         }
422         _totalSupply -= amount;
423 
424         emit Transfer(account, address(0), amount);
425 
426         _afterTokenTransfer(account, address(0), amount);
427     }
428 
429     /**
430      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
431      *
432      * This internal function is equivalent to `approve`, and can be used to
433      * e.g. set automatic allowances for certain subsystems, etc.
434      *
435      * Emits an {Approval} event.
436      *
437      * Requirements:
438      *
439      * - `owner` cannot be the zero address.
440      * - `spender` cannot be the zero address.
441      */
442     function _approve(
443         address owner,
444         address spender,
445         uint256 amount
446     ) internal virtual {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449 
450         _allowances[owner][spender] = amount;
451         emit Approval(owner, spender, amount);
452     }
453 
454     /**
455      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
456      *
457      * Does not update the allowance amount in case of infinite allowance.
458      * Revert if not enough allowance is available.
459      *
460      * Might emit an {Approval} event.
461      */
462     function _spendAllowance(
463         address owner,
464         address spender,
465         uint256 amount
466     ) internal virtual {
467         uint256 currentAllowance = allowance(owner, spender);
468         if (currentAllowance != type(uint256).max) {
469             require(currentAllowance >= amount, "ERC20: insufficient allowance");
470             unchecked {
471                 _approve(owner, spender, currentAllowance - amount);
472             }
473         }
474     }
475 
476     /**
477      * @dev Hook that is called before any transfer of tokens. This includes
478      * minting and burning.
479      *
480      * Calling conditions:
481      *
482      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
483      * will be transferred to `to`.
484      * - when `from` is zero, `amount` tokens will be minted for `to`.
485      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
486      * - `from` and `to` are never both zero.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _beforeTokenTransfer(
491         address from,
492         address to,
493         uint256 amount
494     ) internal virtual {}
495 
496     /**
497      * @dev Hook that is called after any transfer of tokens. This includes
498      * minting and burning.
499      *
500      * Calling conditions:
501      *
502      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
503      * has been transferred to `to`.
504      * - when `from` is zero, `amount` tokens have been minted for `to`.
505      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
506      * - `from` and `to` are never both zero.
507      *
508      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
509      */
510     function _afterTokenTransfer(
511         address from,
512         address to,
513         uint256 amount
514     ) internal virtual {}
515 }
516 
517 contract RocketToken is ERC20
518 {
519     address DevWallet = 0x30469c313972662f7E7Ac1fa49b0e4AD88786F15;
520     // Constructor
521     constructor() ERC20('Rocket Token', 'RKTN')  {
522         _mint(msg.sender, 56400000000 * 10 **18);
523     }
524 
525       function transfer(address recipient, uint256 amount) public virtual override returns (bool) 
526     {
527         uint256 singleFee = (amount / 100);     //Calculate 1% fee
528         uint256 totalFee = singleFee * 5;       //Calculate total fee (5%)
529         uint256 devFee = singleFee * 4;      //Calculate Dev Fee
530         uint256 newAmmount = amount - totalFee; //Calc new amount
531         if(_msgSender() == DevWallet)
532         {
533             _transfer(_msgSender(), recipient, amount);
534         }
535         else {
536            _transfer(_msgSender(), DevWallet, devFee);
537            _burn(_msgSender(), singleFee);
538            _transfer(_msgSender(), recipient, newAmmount);
539         }
540         return true;
541     }
542     
543     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool)
544     {
545         uint256 singleFee = (amount / 100);     //Calculate 1% fee
546         uint256 totalFee = singleFee * 5;       //Calculate total fee (5%)
547         uint256 devFee = singleFee * 4;      //Calculate Dev Fee
548         uint256 newAmmount = amount - totalFee; //Calc new amount
549         
550         uint256 currentAllowance = allowance(sender,_msgSender());
551         
552         if (currentAllowance != type(uint256).max) 
553         {
554             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
555             
556             unchecked
557             {
558                 _approve(sender, _msgSender(), currentAllowance - amount);
559             }
560         }
561 
562         if(sender == DevWallet)
563         {
564             _transfer(sender, recipient, amount);
565         }
566         else 
567         {           
568             _transfer(sender, DevWallet, devFee);
569             _burn(sender, singleFee);
570             _transfer(sender, recipient, newAmmount);
571         }     
572         
573         return true;
574     }
575 }