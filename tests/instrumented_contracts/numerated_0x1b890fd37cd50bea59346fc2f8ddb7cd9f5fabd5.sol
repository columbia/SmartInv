1 // SPDX-License-Identifier: MIT
2 
3 // References:
4 //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
5 //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
6 
7 /**
8 Copyright 2021 New Order
9 
10 
11 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
12 
13 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
14 
15 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
16  * */
17  
18 pragma solidity ^0.8.4;
19 
20 /**
21 * @dev Inteface for the token lock features in this contract
22 */
23 interface ITOKENLOCK {
24     /**
25      * @dev Emitted when the token lock is initialized  
26      * `tokenHolder` is the address the lock pertains to
27      *  `amountLocked` is the amount of tokens locked 
28      *  `time` is the (initial) time at which tokens were locked
29      *  `unlockPeriod` is the time interval at which tokens become unlockedPerPeriod
30      *  `unlockedPerPeriod` is the amount of token unlocked earch unlockPeriod
31      */
32     event  NewTokenLock(address tokenHolder, uint256 amountLocked, uint256 time, uint256 unlockPeriod, uint256 unlockedPerPeriod);
33     /**
34      * @dev Emitted when the token lock is updated  to be more strict
35      * `tokenHolder` is the address the lock pertains to
36      *  `amountLocked` is the amount of tokens locked 
37      *  `time` is the (initial) time at which tokens were locked
38      *  `unlockPeriod` is the time interval at which tokens become unlockedPerPeriod
39      *  `unlockedPerPeriod` is the amount of token unlocked earch unlockPeriod
40      */
41     event  UpdateTokenLock(address tokenHolder, uint256 amountLocked, uint256 time, uint256 unlockPeriod, uint256 unlockedPerPeriod);
42     
43     /**
44      * @dev Lock `baseTokensLocked_` held by the caller with `unlockedPerEpoch_` tokens unlocking each `unlockEpoch_`
45      *
46      *
47      * Emits an {NewTokenLock} event indicating the updated terms of the token lockup.
48      *
49      * Requires msg.sender to:
50      *
51      * - If there was a prevoius lock for this address, tokens must first unlock through the passage of time, 
52      *      after which the lock must be cleared with a call to {clearLock} before calling this function again for the same address.     
53      * - Must have at least a balance of `baseTokensLocked_` to lock
54      * - Must provide non-zero `unlockEpoch_`
55      * - Must have at least `unlockedPerEpoch_` tokens to unlock 
56      *  - `unlockedPerEpoch_` must be greater than zero
57      */
58     
59     function newTokenLock(uint256 baseTokensLocked_, uint256 unlockEpoch_, uint256 unlockedPerEpoch_) external;
60     
61     /**
62      * @dev Reset the lock state
63      *
64      * Requirements:
65      *
66      * - msg.sender must not have any tokens locked, currently;
67      *      if there were tokens locked for msg.sender previously,
68      *      they must have all become unlocked through the passage of time
69      *      before calling this function.
70      */
71     function clearLock() external;
72     
73     /**
74      * @dev Returns the amount of tokens that are unlocked i.e. transferrable by `who`
75      *
76      */
77     function balanceUnlocked(address who) external view returns (uint256 amount);
78     /**
79      * @dev Returns the amount of tokens that are locked and not transferrable by `who`
80      *
81      */
82     function balanceLocked(address who) external view returns (uint256 amount);
83 
84     /**
85      * @dev Reduce the amount of token unlocked each period by `subtractedValue`
86      * 
87      * Emits an {UpdateTokenLock} event indicating the updated terms of the token lockup.
88      * 
89      * Requires: 
90      *  - msg.sender must have tokens currently locked
91      *  - `subtractedValue` is greater than 0
92      *  - cannot reduce the unlockedPerEpoch to 0
93      *
94      *  NOTE: As a side effect resets the baseTokensLocked and lockTime for msg.sender 
95      */
96     function decreaseUnlockAmount(uint256 subtractedValue) external;
97     /**
98      * @dev Increase the duration of the period at which tokens are unlocked by `addedValue`
99      * this will have the net effect of slowing the rate at which tokens are unlocked
100      * 
101      * Emits an {UpdateTokenLock} event indicating the updated terms of the token lockup.
102      * 
103      * Requires: 
104      *  - msg.sender must have tokens currently locked
105      *  - `addedValue` is greater than 0
106      * 
107      *  NOTE: As a side effect resets the baseTokensLocked and lockTime for msg.sender 
108      */
109     function increaseUnlockTime(uint256 addedValue) external;
110     /**
111      * @dev Increase the number of tokens locked by `addedValue`
112      * i.e. locks up more tokens.
113      * 
114      *      
115      * Emits an {UpdateTokenLock} event indicating the updated terms of the token lockup.
116      * 
117      * Requires: 
118      *  - msg.sender must have tokens currently locked
119      *  - `addedValue` is greater than zero
120      *  - msg.sender must have sufficient unlocked tokens to lock
121      * 
122      *  NOTE: As a side effect resets the baseTokensLocked and lockTime for msg.sender 
123      *
124      */
125     function increaseTokensLocked(uint256 addedValue) external;
126 
127 }
128 /**
129  * @dev Interface of the ERC20 standard as defined in the EIP.
130  */
131 interface IERC20 {
132     /**
133      * @dev Returns the amount of tokens in existence.
134      */
135     function totalSupply() external view returns (uint256);
136 
137     /**
138      * @dev Returns the amount of tokens owned by `account`.
139      */
140     function balanceOf(address account) external view returns (uint256);
141 
142     /**
143      * @dev Moves `amount` tokens from the caller's account to `recipient`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transfer(address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Returns the remaining number of tokens that `spender` will be
153      * allowed to spend on behalf of `owner` through {transferFrom}. This is
154      * zero by default.
155      *
156      * This value changes when {approve} or {transferFrom} are called.
157      */
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     /**
161      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * IMPORTANT: Beware that changing an allowance with this method brings the risk
166      * that someone may use both the old and the new allowance by unfortunate
167      * transaction ordering. One possible solution to mitigate this race
168      * condition is to first reduce the spender's allowance to 0 and set the
169      * desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address spender, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Moves `amount` tokens from `sender` to `recipient` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Emitted when `value` tokens are moved from one account (`from`) to
189      * another (`to`).
190      *
191      * Note that `value` may be zero.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 value);
194 
195     /**
196      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
197      * a call to {approve}. `value` is the new allowance.
198      */
199     event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 /**
203  * @dev Interface for the optional metadata functions from the ERC20 standard.
204  *
205  * _Available since v4.1._
206  */
207 interface IERC20Metadata is IERC20 {
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() external view returns (string memory);
212 
213     /**
214      * @dev Returns the symbol of the token.
215      */
216     function symbol() external view returns (string memory);
217 
218     /**
219      * @dev Returns the decimals places of the token.
220      */
221     function decimals() external view returns (uint8);
222 }
223 
224 /*
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address) {
236         return msg.sender;
237     }
238 
239 }
240 
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20PresetMinterPauser}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin guidelines: functions revert instead
253  * of returning `false` on failure. This behavior is nonetheless conventional
254  * and does not conflict with the expectations of ERC20 applications.
255  *
256  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See {IERC20-approve}.
264  */
265 contract ERC20 is Context, IERC20, IERC20Metadata {
266     mapping (address => uint256) private _balances;
267 
268     mapping (address => mapping (address => uint256)) private _allowances;
269 
270     uint256 private _totalSupply;
271 
272     string private _name;
273     string private _symbol;
274 
275     /**
276      * @dev Sets the values for {name} and {symbol}.
277      *
278      * The defaut value of {decimals} is 18. To select a different value for
279      * {decimals} you should overload it.
280      *
281      * All two of these values are immutable: they can only be set once during
282      * construction.
283      */
284     constructor (string memory name_, string memory symbol_) {
285         _name = name_;
286         _symbol = symbol_;
287     }
288 
289     /**
290      * @dev Returns the name of the token.
291      */
292     function name() public view virtual override returns (string memory) {
293         return _name;
294     }
295 
296     /**
297      * @dev Returns the symbol of the token, usually a shorter version of the
298      * name.
299      */
300     function symbol() public view virtual override returns (string memory) {
301         return _symbol;
302     }
303 
304     /**
305      * @dev Returns the number of decimals used to get its user representation.
306      * For example, if `decimals` equals `2`, a balance of `505` tokens should
307      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
308      *
309      * Tokens usually opt for a value of 18, imitating the relationship between
310      * Ether and Wei. This is the value {ERC20} uses, unless this function is
311      * overridden;
312      *
313      * NOTE: This information is only used for _display_ purposes: it in
314      * no way affects any of the arithmetic of the contract, including
315      * {IERC20-balanceOf} and {IERC20-transfer}.
316      */
317     function decimals() public view virtual override returns (uint8) {
318         return 18;
319     }
320 
321     /**
322      * @dev See {IERC20-totalSupply}.
323      */
324     function totalSupply() public view virtual override returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev See {IERC20-balanceOf}.
330      */
331     function balanceOf(address account) public view virtual override returns (uint256) {
332         return _balances[account];
333     }
334 
335     /**
336      * @dev See {IERC20-transfer}.
337      *
338      * Requirements:
339      *
340      * - `recipient` cannot be the zero address.
341      * - the caller must have a balance of at least `amount`.
342      */
343     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
344         _transfer(_msgSender(), recipient, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-allowance}.
350      */
351     function allowance(address owner, address spender) public view virtual override returns (uint256) {
352         return _allowances[owner][spender];
353     }
354 
355     /**
356      * @dev See {IERC20-approve}.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function approve(address spender, uint256 amount) public virtual override returns (bool) {
363         _approve(_msgSender(), spender, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-transferFrom}.
369      *
370      * Emits an {Approval} event indicating the updated allowance. This is not
371      * required by the EIP. See the note at the beginning of {ERC20}.
372      *
373      * Requirements:
374      *
375      * - `sender` and `recipient` cannot be the zero address.
376      * - `sender` must have a balance of at least `amount`.
377      * - the caller must have allowance for ``sender``'s tokens of at least
378      * `amount`.
379      */
380     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
381         _transfer(sender, recipient, amount);
382 
383         uint256 currentAllowance = _allowances[sender][_msgSender()];
384         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
385         _approve(sender, _msgSender(), currentAllowance - amount);
386 
387         return true;
388     }
389 
390     /**
391      * @dev Atomically increases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
403         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
404         return true;
405     }
406 
407     /**
408      * @dev Atomically decreases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      * - `spender` must have allowance for the caller of at least
419      * `subtractedValue`.
420      */
421     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
422         uint256 currentAllowance = _allowances[_msgSender()][spender];
423         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
424         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
425 
426         return true;
427     }
428 
429     /**
430      * @dev Moves tokens `amount` from `sender` to `recipient`.
431      *
432      * This is internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `sender` cannot be the zero address.
440      * - `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      */
443     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
444         require(sender != address(0), "ERC20: transfer from the zero address");
445         require(recipient != address(0), "ERC20: transfer to the zero address");
446 
447         _beforeTokenTransfer(sender, recipient, amount);
448 
449         uint256 senderBalance = _balances[sender];
450         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
451         _balances[sender] = senderBalance - amount;
452         _balances[recipient] += amount;
453 
454         emit Transfer(sender, recipient, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `to` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal virtual {
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply += amount;
472         _balances[account] += amount;
473         emit Transfer(address(0), account, amount);
474     }
475 
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
479      *
480      * This internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(address owner, address spender, uint256 amount) internal virtual {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497 
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be to transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
513 
514 }
515 
516 contract NewOrderGovernance is ERC20, ITOKENLOCK {
517 
518 
519     constructor(string memory name_, string memory symbol_, uint256 amount_, address deployer_) ERC20(name_, symbol_){
520         _mint(deployer_, amount_);
521     }
522     
523     string private constant ERROR_INSUFFICIENT_UNLOCKED = "Not enough unlocked tokens for transfer";
524     string private constant ERROR_LOCK_EXISTS = "Token lock already exists";
525     string private constant ERROR_INSUFFICIENT_TOKENS = "Not enough tokens to lock";
526     string private constant ERROR_EPOCH_ZERO = "Unlock interval must be greater than zero";
527     string private constant ERROR_BAD_UNLOCK_AMOUNT = "Unlock amount must be between 1 and the locked amount";
528     string private constant ERROR_CLEARING_LOCK = "Cannot clear lock while tokens are locked";
529     string private constant ERROR_BAD_NEW_UNLOCK_AMT = "New unlock amount must be lower than current";
530     string private constant ERROR_BAD_NEW_UNLOCK_TIME = "New unlock time must be greater than current";
531     string private constant ERROR_BAD_NEW_LOCKED_AMT = "New amount locked must be greater than current";
532     string private constant ERROR_NO_LOCKED_TOKENS = "No tokens are locked, create new lock first";
533     
534     
535     mapping (address => uint256) public lockTime; //the time tokens were locked
536     mapping (address => uint256) public unlockEpoch; //the time interval at which tokens unlock
537     mapping (address => uint256) public unlockedPerEpoch; // the number of tokens unlocked per unlockEpoch
538     mapping (address => uint256) public baseTokensLocked; // the number of tokens locked up by HOLDER
539     /**
540      * @dev require that at least `amount` tokens are unlocked before transfer is possible
541      *  also permit if minting tokens (coming from 0x0)
542      *
543     */
544     function _beforeTokenTransfer(address from, address /*to*/, uint256 amount) internal  virtual override {
545             require(from == address(0x0) || amount <= balanceUnlocked(from), ERROR_INSUFFICIENT_UNLOCKED);
546     }
547     
548     /**
549      * @dev Lock `baseTokensLocked_` held by the caller with `unlockedPerEpoch_` tokens unlocking each `unlockEpoch_`
550      *
551      *
552      * Emits an {NewTokenLock} event indicating the updated terms of the token lockup.
553      *
554      * Requires msg.sender to:
555      *
556      * - If there was a prevoius lock for this address, tokens must first unlock through the passage of time, 
557      *      after which the lock must be cleared with a call to {clearLock} before calling this function again for the same address.
558      * - Must have at least a balance of `baseTokensLocked_` to lock
559      * - Must provide non-zero `unlockEpoch_`
560      * - Must have at least `unlockedPerEpoch_` tokens to unlock 
561      *  - `unlockedPerEpoch_` must be greater than zero
562      */
563     
564     function newTokenLock(uint256 baseTokensLocked_, uint256 unlockEpoch_, uint256 unlockedPerEpoch_) public virtual override{
565         require(balanceLocked(msg.sender) == 0, ERROR_LOCK_EXISTS);
566         require(balanceOf(msg.sender) >= baseTokensLocked_, ERROR_INSUFFICIENT_TOKENS); 
567         require(unlockEpoch_ > 0, ERROR_EPOCH_ZERO);
568         require(unlockedPerEpoch_ <= baseTokensLocked_ &&  unlockedPerEpoch_ > 0, ERROR_BAD_UNLOCK_AMOUNT);
569         lockTime[msg.sender] = block.timestamp;
570         unlockEpoch[msg.sender] = unlockEpoch_;
571         unlockedPerEpoch[msg.sender] = unlockedPerEpoch_;
572         baseTokensLocked[msg.sender] = baseTokensLocked_;
573         emit NewTokenLock(msg.sender, baseTokensLocked[msg.sender], lockTime[msg.sender], unlockEpoch[msg.sender], unlockedPerEpoch[msg.sender]);
574     }
575     
576     /**
577      * @dev Reset the lock state
578      *
579      * Requirements:
580      *
581      * - msg.sender must not have any tokens locked, currently;
582      *      if there were tokens locked for msg.sender previously,
583      *      they must have all become unlocked through the passage of time
584      *      before calling this function.
585      */
586     function clearLock() public virtual override{
587         require(balanceLocked(msg.sender) == 0, ERROR_CLEARING_LOCK);
588         lockTime[msg.sender] = 0;
589         unlockEpoch[msg.sender] = 0;
590         unlockedPerEpoch[msg.sender] = 0;
591         baseTokensLocked[msg.sender] = 0;
592     }
593     
594     /**
595      * @dev Returns the amount of tokens that are unlocked i.e. transferrable by `who`
596      *
597      */
598     function balanceUnlocked(address who) public virtual override view returns (uint256 amount) {
599         
600         return (balanceOf(who)- balanceLocked(who));
601         
602     }
603     /**
604      * @dev Returns the amount of tokens that are locked and not transferrable by `who`
605      *
606      */
607     function balanceLocked(address who) public virtual override view returns (uint256 amount){
608         if(baseTokensLocked[who] == 0){
609             return 0;
610         }
611         uint256 unlockedOverTime = unlockedPerEpoch[who] * (block.timestamp - lockTime[who]) / unlockEpoch[who];
612         if(baseTokensLocked[who] <  unlockedOverTime){
613             return 0;
614         }
615         return baseTokensLocked[who]- unlockedOverTime;
616         
617     }
618 
619      /**
620      * @dev Emits the UpdateTokenLock event
621      */
622     function emitUpdateTokenLock() internal {
623         emit UpdateTokenLock(msg.sender, baseTokensLocked[msg.sender], lockTime[msg.sender], unlockEpoch[msg.sender], unlockedPerEpoch[msg.sender]);
624 
625     }
626  
627 
628     /**
629      * @dev Reduce the amount of token unlocked each period by `subtractedValue`
630      * 
631      * Emits an {UpdateTokenLock} event indicating the updated terms of the token lockup.
632      * 
633      * Requires: 
634      *  - msg.sender must have tokens currently locked
635      *  - `subtractedValue` is greater than 0
636      *  - cannot reduce the unlockedPerEpoch to 0
637      *
638      *  NOTE: As a side effect resets the baseTokensLocked and lockTime for msg.sender 
639      */
640     function decreaseUnlockAmount(uint256 subtractedValue) public virtual override{
641         require(balanceLocked(msg.sender) > 0, ERROR_NO_LOCKED_TOKENS);
642         require(subtractedValue > 0 && (unlockedPerEpoch[msg.sender]- subtractedValue) > 0, ERROR_BAD_NEW_UNLOCK_AMT);
643 
644         baseTokensLocked[msg.sender] = balanceLocked(msg.sender);
645         lockTime[msg.sender] = block.timestamp;
646     
647         unlockedPerEpoch[msg.sender] = (unlockedPerEpoch[msg.sender]- subtractedValue);
648         emitUpdateTokenLock();
649     
650     }
651     /**
652      * @dev Increase the duration of the period at which tokens are unlocked by `addedValue`
653      * this will have the net effect of slowing the rate at which tokens are unlocked
654      * 
655      * Emits an {UpdateTokenLock} event indicating the updated terms of the token lockup.
656      * 
657      * Requires: 
658      *  - msg.sender must have tokens currently locked
659      *  - `addedValue` is greater than 0
660      * 
661      *  NOTE: As a side effect resets the baseTokensLocked and lockTime for msg.sender 
662      */
663     function increaseUnlockTime(uint256 addedValue) public virtual override{
664         require(addedValue > 0, ERROR_BAD_NEW_UNLOCK_TIME);
665         require(balanceLocked(msg.sender) > 0, ERROR_NO_LOCKED_TOKENS);
666 
667         baseTokensLocked[msg.sender] = balanceLocked(msg.sender);
668         lockTime[msg.sender] = block.timestamp;
669     
670         unlockEpoch[msg.sender] = (addedValue+ unlockEpoch[msg.sender]);
671 
672         emitUpdateTokenLock();
673     
674     }
675     /**
676      * @dev Increase the number of tokens locked by `addedValue`
677      * i.e. locks up more tokens.
678      * 
679      *      
680      * Emits an {UpdateTokenLock} event indicating the updated terms of the token lockup.
681      * 
682      * Requires: 
683      *  - msg.sender must have tokens currently locked
684      *  - `addedValue` is greater than zero
685      *  - msg.sender must have sufficient unlocked tokens to lock
686      * 
687      *  NOTE: As a side effect resets the baseTokensLocked and lockTime for msg.sender 
688      *
689      */
690     function increaseTokensLocked(uint256 addedValue) public virtual override{
691         require(addedValue > 0, ERROR_BAD_NEW_LOCKED_AMT);
692         require(balanceLocked(msg.sender) > 0, ERROR_NO_LOCKED_TOKENS);
693         require(addedValue <= balanceUnlocked(msg.sender), ERROR_INSUFFICIENT_TOKENS);
694         baseTokensLocked[msg.sender] = (addedValue+ balanceLocked(msg.sender));
695         lockTime[msg.sender] = block.timestamp;
696         emitUpdateTokenLock();
697     }
698 
699 }