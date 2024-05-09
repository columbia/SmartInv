1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /* 
6 
7 Created and tested by the Seed team!
8 
9 */
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239     
240     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
241         uint256 c = add(a,m);
242         uint256 d = sub(c,1);
243         return mul(div(d,m),m);
244     }
245 }
246 /**
247  * @dev Implementation of the {IERC20} interface.
248  *
249  * This implementation is agnostic to the way tokens are created. This means
250  * that a supply mechanism has to be added in a derived contract using {_mint}.
251  * For a generic mechanism see {ERC20PresetMinterPauser}.
252  *
253  * TIP: For a detailed writeup see our guide
254  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
255  * to implement supply mechanisms].
256  *
257  * We have followed general OpenZeppelin guidelines: functions revert instead
258  * of returning `false` on failure. This behavior is nonetheless conventional
259  * and does not conflict with the expectations of ERC20 applications.
260  *
261  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
262  * This allows applications to reconstruct the allowance for all accounts just
263  * by listening to said events. Other implementations of the EIP may not emit
264  * these events, as it isn't required by the specification.
265  *
266  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
267  * functions have been added to mitigate the well-known issues around setting
268  * allowances. See {IERC20-approve}.
269  */
270 contract Plantation is IERC20 {
271     using SafeMath for uint256;
272 
273     mapping (address => uint256) private _balances;
274 
275     mapping (address => mapping (address => uint256)) private _allowances;
276     
277     mapping (address => bool) private whitelist;
278 
279     uint256 private _totalSupply = 500 ether;
280 
281     string private _name = "PlantPump Token";
282     string private _symbol = "PLANT";
283     uint8 private _decimals = 18;
284     address private __owner;
285     bool public beginning = true;
286     bool private stopBots = false;
287     
288     /**
289      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
290      * a default value of 18.
291      *
292      * To select a different value for {decimals}, use {_setupDecimals}.
293      *
294      * All three of these values are immutable: they can only be set once during
295      * construction.
296      */
297     constructor () public {
298         __owner = msg.sender;
299         _balances[__owner] = _totalSupply;
300     }
301 
302     /**
303      * @dev Returns the name of the token.
304      */
305     function name() public view returns (string memory) {
306         return _name;
307     }
308 
309     /**
310      * @dev Returns the symbol of the token, usually a shorter version of the
311      * name.
312      */
313     function symbol() public view returns (string memory) {
314         return _symbol;
315     }
316 
317     /**
318      * @dev Returns the number of decimals used to get its user representation.
319      * For example, if `decimals` equals `2`, a balance of `505` tokens should
320      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
321      *
322      * Tokens usually opt for a value of 18, imitating the relationship between
323      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
324      * called.
325      *
326      * NOTE: This information is only used for _display_ purposes: it in
327      * no way affects any of the arithmetic of the contract, including
328      * {IERC20-balanceOf} and {IERC20-transfer}.
329      */
330     function decimals() public view returns (uint8) {
331         return _decimals;
332     }
333     
334     function multiWhitelistAdd(address[] memory addresses) public {
335         if (msg.sender != __owner) {
336             revert();
337         }
338 
339         for (uint256 i = 0; i < addresses.length; i++) {
340             whitelistAdd(addresses[i]);
341         }
342     }
343 
344     function multiWhitelistRemove(address[] memory addresses) public {
345         if (msg.sender != __owner) {
346             revert();
347         }
348 
349         for (uint256 i = 0; i < addresses.length; i++) {
350             whitelistRemove(addresses[i]);
351         }
352     }
353 
354     function whitelistAdd(address a) public {
355         if (msg.sender != __owner) {
356             revert();
357         }
358         
359         whitelist[a] = true;
360     }
361     
362     function whitelistRemove(address a) public {
363         if (msg.sender != __owner) {
364             revert();
365         }
366         
367         whitelist[a] = false;
368     }
369     
370     function isInWhitelist(address a) internal view returns (bool) {
371         return whitelist[a];
372     }
373 
374     /**
375      * @dev See {IERC20-totalSupply}.
376      */
377     function totalSupply() public view override returns (uint256) {
378         return _totalSupply;
379     }
380 
381     /**
382      * @dev See {IERC20-balanceOf}.
383      */
384     function balanceOf(address account) public view override returns (uint256) {
385         return _balances[account];
386     }
387     
388     function multiTransfer(address[] memory addresses, uint256 amount) public {
389         for (uint256 i = 0; i < addresses.length; i++) {
390             transfer(addresses[i], amount);
391         }
392     }
393 
394     /**
395      * @dev See {IERC20-transfer}.
396      *
397      * Requirements:
398      *
399      * - `recipient` cannot be the zero address.
400      * - the caller must have a balance of at least `amount`.
401      */
402     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
403         _transfer(msg.sender, recipient, amount);
404         return true;
405     }
406 
407     function disableBots() public {
408         if (msg.sender != __owner) {
409             revert();
410         }
411         
412         stopBots = true;
413     }
414     
415     function enableBots() public {
416         if (msg.sender != __owner) {
417             revert();
418         }
419         
420         stopBots = false;
421     }
422     /**
423      * @dev See {IERC20-allowance}.
424      */
425     function allowance(address owner, address spender) public view virtual override returns (uint256) {
426         return _allowances[owner][spender];
427     }
428 
429     /**
430      * @dev See {IERC20-approve}.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount) public virtual override returns (bool) {
437         _approve(msg.sender, spender, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-transferFrom}.
443      *
444      * Emits an {Approval} event indicating the updated allowance. This is not
445      * required by the EIP. See the note at the beginning of {ERC20}.
446      *
447      * Requirements:
448      *
449      * - `sender` and `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `amount`.
451      * - the caller must have allowance for ``sender``'s tokens of at least
452      * `amount`.
453      */
454     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
455         _transfer(sender, recipient, amount);
456         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
457         return true;
458     }
459 
460     /**
461      * @dev Atomically increases the allowance granted to `spender` by the caller.
462      *
463      * This is an alternative to {approve} that can be used as a mitigation for
464      * problems described in {IERC20-approve}.
465      *
466      * Emits an {Approval} event indicating the updated allowance.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      */
472     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
473         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
474         return true;
475     }
476 
477     /**
478      * @dev Atomically decreases the allowance granted to `spender` by the caller.
479      *
480      * This is an alternative to {approve} that can be used as a mitigation for
481      * problems described in {IERC20-approve}.
482      *
483      * Emits an {Approval} event indicating the updated allowance.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      * - `spender` must have allowance for the caller of at least
489      * `subtractedValue`.
490      */
491     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
492         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
493         return true;
494     }
495     
496     function findOnePercent(uint256 value) public pure returns (uint256)  {
497         uint256 roundValue = value.ceil(100);
498         uint256 onePercent = roundValue.mul(1000).div(10000); // burn 10
499         return onePercent;
500     }
501 
502     /**
503      * @dev Moves tokens `amount` from `sender` to `recipient`.
504      *
505      * This is internal function is equivalent to {transfer}, and can be used to
506      * e.g. implement automatic token fees, slashing mechanisms, etc.
507      *
508      * Emits a {Transfer} event.
509      *
510      * Requirements:
511      *
512      * - `sender` cannot be the zero address.
513      * - `recipient` cannot be the zero address.
514      * - `sender` must have a balance of at least `amount`.
515      */
516     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
517         require(sender != address(0), "ERC20: transfer from the zero address");
518         require(recipient != address(0), "ERC20: transfer to the zero address");
519         
520         if (beginning) {
521             if (isInWhitelist(sender)) {
522                 revert();
523             }
524         }
525         
526         if (stopBots) {
527             if (amount > 5 ether && sender != __owner) {
528                 revert('stop the bots!');
529             }
530         }
531         
532         uint256 tokensToBurn = findOnePercent(amount);
533         uint256 tokensToTransfer = amount.sub(tokensToBurn);
534         
535         _beforeTokenTransfer(sender, recipient, amount);
536         
537         _burn(sender, tokensToBurn);
538         _balances[sender] = _balances[sender].sub(tokensToTransfer, "ERC20: transfer amount exceeds balance");
539         _balances[recipient] = _balances[recipient].add(tokensToTransfer);
540         emit Transfer(sender, recipient, tokensToTransfer);
541     }
542 
543     /**
544      * @dev Destroys `amount` tokens from `account`, reducing the
545      * total supply.
546      *
547      * Emits a {Transfer} event with `to` set to the zero address.
548      *
549      * Requirements:
550      *
551      * - `account` cannot be the zero address.
552      * - `account` must have at least `amount` tokens.
553      */
554     function _burn(address account, uint256 amount) internal virtual {
555         require(account != address(0), "ERC20: burn from the zero address");
556 
557         _beforeTokenTransfer(account, address(0), amount);
558 
559         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
560         _totalSupply = _totalSupply.sub(amount);
561         emit Transfer(account, address(0), amount);
562     }
563 
564     /**
565      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
566      *
567      * This internal function is equivalent to `approve`, and can be used to
568      * e.g. set automatic allowances for certain subsystems, etc.
569      *
570      * Emits an {Approval} event.
571      *
572      * Requirements:
573      *
574      * - `owner` cannot be the zero address.
575      * - `spender` cannot be the zero address.
576      */
577     function _approve(address owner, address spender, uint256 amount) internal virtual {
578         require(owner != address(0), "ERC20: approve from the zero address");
579         require(spender != address(0), "ERC20: approve to the zero address");
580 
581         _allowances[owner][spender] = amount;
582         emit Approval(owner, spender, amount);
583     }
584 
585     /**
586      * @dev Sets {decimals} to a value other than the default one of 18.
587      *
588      * WARNING: This function should only be called from the constructor. Most
589      * applications that interact with token contracts will not expect
590      * {decimals} to ever change, and may work incorrectly if it does.
591      */
592     function _setupDecimals(uint8 decimals_) internal {
593         _decimals = decimals_;
594     }
595     
596     function stopBeginning() public {
597         if (__owner != msg.sender) {
598             revert();
599         }
600         
601         beginning = false;
602     }
603     
604     /**
605      * @dev Hook that is called before any transfer of tokens. This includes
606      * minting and burning.
607      *
608      * Calling conditions:
609      *
610      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
611      * will be to transferred to `to`.
612      * - when `from` is zero, `amount` tokens will be minted for `to`.
613      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
614      * - `from` and `to` are never both zero.
615      *
616      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
617      */
618     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
619 }