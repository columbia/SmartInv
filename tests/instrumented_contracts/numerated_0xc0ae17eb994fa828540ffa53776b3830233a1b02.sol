1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `to`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `from` to `to` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address from,
67         address to,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 // File: @openzeppelin\contracts\utils\Context.sol
113 
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
138 
139 
140 pragma solidity ^0.8.0;
141 
142 
143 
144 /**
145  * @dev Implementation of the {IERC20} interface.
146  *
147  * This implementation is agnostic to the way tokens are created. This means
148  * that a supply mechanism has to be added in a derived contract using {_mint}.
149  * For a generic mechanism see {ERC20PresetMinterPauser}.
150  *
151  * TIP: For a detailed writeup see our guide
152  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
153  * to implement supply mechanisms].
154  *
155  * We have followed general OpenZeppelin Contracts guidelines: functions revert
156  * instead returning `false` on failure. This behavior is nonetheless
157  * conventional and does not conflict with the expectations of ERC20
158  * applications.
159  *
160  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
161  * This allows applications to reconstruct the allowance for all accounts just
162  * by listening to said events. Other implementations of the EIP may not emit
163  * these events, as it isn't required by the specification.
164  *
165  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
166  * functions have been added to mitigate the well-known issues around setting
167  * allowances. See {IERC20-approve}.
168  */
169 contract ERC20 is Context, IERC20, IERC20Metadata {
170     mapping(address => uint256) private _balances;
171 
172     mapping(address => mapping(address => uint256)) private _allowances;
173 
174     uint256 private _totalSupply;
175 
176     string private _name;
177     string private _symbol;
178 
179     /**
180      * @dev Sets the values for {name} and {symbol}.
181      *
182      * The default value of {decimals} is 18. To select a different value for
183      * {decimals} you should overload it.
184      *
185      * All two of these values are immutable: they can only be set once during
186      * construction.
187      */
188     constructor(string memory name_, string memory symbol_) {
189         _name = name_;
190         _symbol = symbol_;
191     }
192 
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() public view virtual override returns (string memory) {
197         return _name;
198     }
199 
200     /**
201      * @dev Returns the symbol of the token, usually a shorter version of the
202      * name.
203      */
204     function symbol() public view virtual override returns (string memory) {
205         return _symbol;
206     }
207 
208     /**
209      * @dev Returns the number of decimals used to get its user representation.
210      * For example, if `decimals` equals `2`, a balance of `505` tokens should
211      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
212      *
213      * Tokens usually opt for a value of 18, imitating the relationship between
214      * Ether and Wei. This is the value {ERC20} uses, unless this function is
215      * overridden;
216      *
217      * NOTE: This information is only used for _display_ purposes: it in
218      * no way affects any of the arithmetic of the contract, including
219      * {IERC20-balanceOf} and {IERC20-transfer}.
220      */
221     function decimals() public view virtual override returns (uint8) {
222         return 18;
223     }
224 
225     /**
226      * @dev See {IERC20-totalSupply}.
227      */
228     function totalSupply() public view virtual override returns (uint256) {
229         return _totalSupply;
230     }
231 
232     /**
233      * @dev See {IERC20-balanceOf}.
234      */
235     function balanceOf(address account) public view virtual override returns (uint256) {
236         return _balances[account];
237     }
238 
239     /**
240      * @dev See {IERC20-transfer}.
241      *
242      * Requirements:
243      *
244      * - `to` cannot be the zero address.
245      * - the caller must have a balance of at least `amount`.
246      */
247     function transfer(address to, uint256 amount) public virtual override returns (bool) {
248         address owner = _msgSender();
249         _transfer(owner, to, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
264      * `transferFrom`. This is semantically equivalent to an infinite approval.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         address owner = _msgSender();
272         _approve(owner, spender, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-transferFrom}.
278      *
279      * Emits an {Approval} event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of {ERC20}.
281      *
282      * NOTE: Does not update the allowance if the current allowance
283      * is the maximum `uint256`.
284      *
285      * Requirements:
286      *
287      * - `from` and `to` cannot be the zero address.
288      * - `from` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``from``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address from,
294         address to,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         address spender = _msgSender();
298         _spendAllowance(from, spender, amount);
299         _transfer(from, to, amount);
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         address owner = _msgSender();
317         _approve(owner, spender, _allowances[owner][spender] + addedValue);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         address owner = _msgSender();
337         uint256 currentAllowance = _allowances[owner][spender];
338         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
339         unchecked {
340             _approve(owner, spender, currentAllowance - subtractedValue);
341         }
342 
343         return true;
344     }
345 
346     /**
347      * @dev Moves `amount` of tokens from `sender` to `recipient`.
348      *
349      * This internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `from` must have a balance of at least `amount`.
359      */
360     function _transfer(
361         address from,
362         address to,
363         uint256 amount
364     ) internal virtual {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(from, to, amount);
369 
370         uint256 fromBalance = _balances[from];
371         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
372         unchecked {
373             _balances[from] = fromBalance - amount;
374         }
375         _balances[to] += amount;
376 
377         emit Transfer(from, to, amount);
378 
379         _afterTokenTransfer(from, to, amount);
380     }
381 
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a {Transfer} event with `from` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: mint to the zero address");
393 
394         _beforeTokenTransfer(address(0), account, amount);
395 
396         _totalSupply += amount;
397         _balances[account] += amount;
398         emit Transfer(address(0), account, amount);
399 
400         _afterTokenTransfer(address(0), account, amount);
401     }
402 
403     /**
404      * @dev Destroys `amount` tokens from `account`, reducing the
405      * total supply.
406      *
407      * Emits a {Transfer} event with `to` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      * - `account` must have at least `amount` tokens.
413      */
414     function _burn(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: burn from the zero address");
416 
417         _beforeTokenTransfer(account, address(0), amount);
418 
419         uint256 accountBalance = _balances[account];
420         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
421         unchecked {
422             _balances[account] = accountBalance - amount;
423         }
424         _totalSupply -= amount;
425 
426         emit Transfer(account, address(0), amount);
427 
428         _afterTokenTransfer(account, address(0), amount);
429     }
430 
431     /**
432      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
433      *
434      * This internal function is equivalent to `approve`, and can be used to
435      * e.g. set automatic allowances for certain subsystems, etc.
436      *
437      * Emits an {Approval} event.
438      *
439      * Requirements:
440      *
441      * - `owner` cannot be the zero address.
442      * - `spender` cannot be the zero address.
443      */
444     function _approve(
445         address owner,
446         address spender,
447         uint256 amount
448     ) internal virtual {
449         require(owner != address(0), "ERC20: approve from the zero address");
450         require(spender != address(0), "ERC20: approve to the zero address");
451 
452         _allowances[owner][spender] = amount;
453         emit Approval(owner, spender, amount);
454     }
455 
456     /**
457      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
458      *
459      * Does not update the allowance amount in case of infinite allowance.
460      * Revert if not enough allowance is available.
461      *
462      * Might emit an {Approval} event.
463      */
464     function _spendAllowance(
465         address owner,
466         address spender,
467         uint256 amount
468     ) internal virtual {
469         uint256 currentAllowance = allowance(owner, spender);
470         if (currentAllowance != type(uint256).max) {
471             require(currentAllowance >= amount, "ERC20: insufficient allowance");
472             unchecked {
473                 _approve(owner, spender, currentAllowance - amount);
474             }
475         }
476     }
477 
478     /**
479      * @dev Hook that is called before any transfer of tokens. This includes
480      * minting and burning.
481      *
482      * Calling conditions:
483      *
484      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
485      * will be transferred to `to`.
486      * - when `from` is zero, `amount` tokens will be minted for `to`.
487      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
488      * - `from` and `to` are never both zero.
489      *
490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
491      */
492     function _beforeTokenTransfer(
493         address from,
494         address to,
495         uint256 amount
496     ) internal virtual {}
497 
498     /**
499      * @dev Hook that is called after any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * has been transferred to `to`.
506      * - when `from` is zero, `amount` tokens have been minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _afterTokenTransfer(
513         address from,
514         address to,
515         uint256 amount
516     ) internal virtual {}
517 }
518 
519 // File: contracts\Element.sol
520 
521 pragma solidity ^0.8.4;
522 contract Element is ERC20{
523 
524     //lock address
525     mapping(address => bool) private lockAddrs;
526     //lock amount
527     mapping(address => uint256) private lockAmounts;
528     //lock time by days
529     mapping(address => uint256) private lockDays;
530     //release period
531     mapping(address => uint256) private releasePeriods;
532     //release amount
533     mapping(address => uint256) private releaseAmount;
534 
535     uint256 startDay;
536 
537 
538     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
539         //set start day;
540         startDay = block.timestamp/86400;
541         _setLock(0x21Ec933536835a9c2790D99853a243aC23F324e3, 1600000000, 365, 365, 400000000, 1200000000);
542         _setLock(0x291E8737680155e9765151aCE8e0e4E1c5fFD0a0, 5000000, 92, 7, 96154, 5000000);
543         _setLock(0x0d770aB53FE4cc08D75Fc38B5380248406FCd1B1, 6000000, 92, 7, 115385,6000000);
544         _setLock(0x5224198deb4Fff91fc0A54b0027Ebfe819E1C62e, 5000000, 92, 7, 96154, 5000000);
545         _setLock(0xC3a0EF97f6970212DFe0B89b87138f6d610Ae1a7, 10000000, 92, 7, 192308, 10000000);
546         _setLock(0x79fE7fD69f0AD716616b2D0514413B35F0933F2E, 10000000, 92, 7, 192308, 10000000);
547         _setLock(0x8e620174a2a6486C056D06F400ED6b480cae072f, 3000000, 92, 7, 57692 , 3000000);
548         _setLock(0x4d9212C16C069695C5915bceb6440A12ba836d52, 3200000, 92, 7, 61538 , 3200000);
549         _setLock(0x7CA9cBC8D4DbC0370E4F84CAaCc73E2072f2D8e1, 3800000, 92, 7, 73077 , 3800000);
550         _setLock(0x923f8f8e803d79bE4B19a2b68Dd53500F814bb3C, 200000, 92, 7, 3846 , 200000);
551         _setLock(0x1837025F3cCaD147C775579377C87A19607688cf, 200000, 92, 7, 3846, 200000);
552         _setLock(0x7C98a5Ff0a206d19c1A90BB08b63d405f7b5ED5f, 400000, 92, 7, 7692 , 400000);
553         _setLock(0x02f32E49F09a80C24038003F245280d5a1d069ed, 400000, 92, 7, 7692, 400000);
554         _setLock(0x30059F3d0Ec7De1d4532c9C906543D6F024f3122, 200000, 92, 7, 3846 , 200000);
555         _setLock(0x77293ef7ABB0F809D83eCb96A8F50e72b7534e7c, 200000, 92, 7, 3846, 200000);
556         _setLock(0x1d628F50F6B06A22A0fC633bf70B85D1DAdc442C, 200000, 92, 7, 3846, 200000);
557         _setLock(0x0a99D80F3dAD8EB741102C5D819cE4Da66840c12, 72200000, 92, 7, 1388462 , 72200000);
558         _setLock(0x5F1a5f5736a22B8E34E39509863B7fe7Eb71E33b, 120000000, 365, 7, 2307692, 120000000);
559         _setLock(0x192f66341559D0F84e85dE9D8183ed32987c2DC8, 480000000, 365, 30, 10000000, 480000000);
560         _setLock(0xBE908d0b4adc8F51d85Bd1336822BF613c5c4400, 560000000, 92, 7, 10769230, 560000000);
561         _mint(0xd409E7460b83C8320F58127e7E828e913D394b3f, 200000000*(10**decimals()));
562         _mint(0xae9B53e1263b7b6435358b93887934108E117d31, 40000000*(10**decimals()));
563         _setLock(0xae9B53e1263b7b6435358b93887934108E117d31, 280000000, 90, 7, 7000000, 280000000);
564         _setLock(0xCe9f4B301251e6d5b44742b217B2DA80805FfA12, 200000000, 183, 7, 461538, 176000000);
565         _setLock(0x0394c00331955197Cf758631e5b13F09064337cA, 300000000, 183, 7, 692307, 264000000);
566         _setLock(0x9274492aeE0bF9aE7F1818d4E7eFaa02E0d7E5B4, 100000000, 183, 7, 230769, 88000000);
567     }
568 
569     function _setLock(address addr,uint256 amount, uint256 _lockDays, uint256 _releasePeriods, uint256 _releaseAmount, uint256 _lockAmount) internal{
570         _mint(addr, amount*(10**decimals()));
571         lockAddrs[addr] = true;
572         lockDays[addr] = _lockDays;
573         releasePeriods[addr] = _releasePeriods;
574         releaseAmount[addr] = _releaseAmount*(10**decimals());
575         lockAmounts[addr] = _lockAmount*(10**decimals());
576     }
577 
578 
579     function _beforeTokenTransfer(address from, address to, uint256 amount) internal view override(ERC20) {
580         //check lock
581         if(lockAddrs[from]){
582             require(balanceOf(from) > calLockAmount(from)+ amount,"this address is at lock");
583         }
584     }
585 
586 
587     function calLockAmount(address addr) public view  returns (uint256){
588         if(lockAddrs[addr]){
589             uint256 curDays = block.timestamp/86400;
590             //get lockdays
591             uint256 lockday = lockDays[addr];
592             if((curDays - startDay) > lockday){
593                 uint256 outDays = curDays - startDay - lockday;
594                 //cal the number of release period
595                 uint256 relPeriods = outDays/releasePeriods[addr];
596                 if(relPeriods > 0){
597                     uint256 relAmount = releaseAmount[addr]*relPeriods;
598                     return lockAmounts[addr] - relAmount;
599                 }
600             }
601             // No lock up period
602             return lockAmounts[addr];
603         }else{
604             return 0;
605         }
606     }
607 }