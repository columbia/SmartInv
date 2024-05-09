1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 /*
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
96         return msg.data;
97     }
98 }
99 
100 
101 
102 /**
103  * @dev Implementation of the {IERC20} interface.
104  *
105  * This implementation is agnostic to the way tokens are created. This means
106  * that a supply mechanism has to be added in a derived contract using {_mint}.
107  * For a generic mechanism see {ERC20PresetMinterPauser}.
108  *
109  * TIP: For a detailed writeup see our guide
110  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
111  * to implement supply mechanisms].
112  *
113  * We have followed general OpenZeppelin guidelines: functions revert instead
114  * of returning `false` on failure. This behavior is nonetheless conventional
115  * and does not conflict with the expectations of ERC20 applications.
116  *
117  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
118  * This allows applications to reconstruct the allowance for all accounts just
119  * by listening to said events. Other implementations of the EIP may not emit
120  * these events, as it isn't required by the specification.
121  *
122  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
123  * functions have been added to mitigate the well-known issues around setting
124  * allowances. See {IERC20-approve}.
125  */
126 contract ERC20 is Context, IERC20 {
127     mapping (address => uint256) internal _balances;
128 
129     mapping (address => mapping (address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136     /**
137      * @dev Sets the values for {name} and {symbol}.
138      *
139      * The defaut value of {decimals} is 18. To select a different value for
140      * {decimals} you should overload it.
141      *
142      * All three of these values are immutable: they can only be set once during
143      * construction.
144      */
145     constructor (string memory name_, string memory symbol_) {
146         _name = name_;
147         _symbol = symbol_;
148     }
149 
150     /**
151      * @dev Returns the name of the token.
152      */
153     function name() external view virtual returns (string memory) {
154         return _name;
155     }
156 
157     /**
158      * @dev Returns the symbol of the token, usually a shorter version of the
159      * name.
160      */
161     function symbol() external view virtual returns (string memory) {
162         return _symbol;
163     }
164 
165     /**
166      * @dev Returns the number of decimals used to get its user representation.
167      * For example, if `decimals` equals `2`, a balance of `505` tokens should
168      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
169      *
170      * Tokens usually opt for a value of 18, imitating the relationship between
171      * Ether and Wei. This is the value {ERC20} uses, unless this function is
172      * overloaded;
173      *
174      * NOTE: This information is only used for _display_ purposes: it in
175      * no way affects any of the arithmetic of the contract, including
176      * {IERC20-balanceOf} and {IERC20-transfer}.
177      */
178     function decimals() external view virtual returns (uint8) {
179         return 18;
180     }
181 
182     /**
183      * @dev See {IERC20-totalSupply}.
184      */
185     function totalSupply() external view virtual override returns (uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190      * @dev See {IERC20-balanceOf}.
191      */
192     function balanceOf(address account) external view virtual override returns (uint256) {
193         return _balances[account];
194     }
195 
196     /**
197      * @dev See {IERC20-transfer}.
198      *
199      * Requirements:
200      *
201      * - `recipient` cannot be the zero address.
202      * - the caller must have a balance of at least `amount`.
203      */
204     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     /**
210      * @dev See {IERC20-allowance}.
211      */
212     function allowance(address owner, address spender) external view virtual override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     /**
217      * @dev See {IERC20-approve}.
218      *
219      * Requirements:
220      *
221      * - `spender` cannot be the zero address.
222      */
223     function approve(address spender, uint256 amount) external virtual override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-transferFrom}.
230      *
231      * Emits an {Approval} event indicating the updated allowance. This is not
232      * required by the EIP. See the note at the beginning of {ERC20}.
233      *
234      * Requirements:
235      *
236      * - `sender` and `recipient` cannot be the zero address.
237      * - `sender` must have a balance of at least `amount`.
238      * - the caller must have allowance for ``sender``'s tokens of at least
239      * `amount`.
240      */
241     function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
242         _transfer(sender, recipient, amount);
243 
244         uint256 currentAllowance = _allowances[sender][_msgSender()];
245         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
246         _approve(sender, _msgSender(), currentAllowance - amount);
247 
248         return true;
249     }
250 
251     /**
252      * @dev Atomically increases the allowance granted to `spender` by the caller.
253      *
254      * This is an alternative to {approve} that can be used as a mitigation for
255      * problems described in {IERC20-approve}.
256      *
257      * Emits an {Approval} event indicating the updated allowance.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
264         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
265         return true;
266     }
267 
268     /**
269      * @dev Atomically decreases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      * - `spender` must have allowance for the caller of at least
280      * `subtractedValue`.
281      */
282     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
283         uint256 currentAllowance = _allowances[_msgSender()][spender];
284         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
285         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
286 
287         return true;
288     }
289 
290     /**
291      * @dev Moves tokens `amount` from `sender` to `recipient`.
292      *
293      * This is internal function is equivalent to {transfer}, and can be used to
294      * e.g. implement automatic token fees, slashing mechanisms, etc.
295      *
296      * Emits a {Transfer} event.
297      *
298      * Requirements:
299      *
300      * - `sender` cannot be the zero address.
301      * - `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `amount`.
303      */
304     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
305         require(sender != address(0), "ERC20: transfer from the zero address");
306         require(recipient != address(0), "ERC20: transfer to the zero address");
307 
308         _beforeTokenTransfer(sender, recipient, amount);
309 
310         uint256 senderBalance = _balances[sender];
311         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
312         _balances[sender] = senderBalance - amount;
313         _balances[recipient] += amount;
314 
315         emit Transfer(sender, recipient, amount);
316     }
317 
318     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
319      * the total supply.
320      *
321      * Emits a {Transfer} event with `from` set to the zero address.
322      *
323      * Requirements:
324      *
325      * - `to` cannot be the zero address.
326      */
327     function _mint(address account, uint256 amount) internal virtual {
328         require(account != address(0), "ERC20: mint to the zero address");
329 
330         _beforeTokenTransfer(address(0), account, amount);
331 
332         _totalSupply += amount;
333         _balances[account] += amount;
334         emit Transfer(address(0), account, amount);
335     }
336 
337     /**
338      * @dev Destroys `amount` tokens from `account`, reducing the
339      * total supply.
340      *
341      * Emits a {Transfer} event with `to` set to the zero address.
342      *
343      * Requirements:
344      *
345      * - `account` cannot be the zero address.
346      * - `account` must have at least `amount` tokens.
347      */
348     function _burn(address account, uint256 amount) internal virtual {
349         require(account != address(0), "ERC20: burn from the zero address");
350 
351         _beforeTokenTransfer(account, address(0), amount);
352 
353         uint256 accountBalance = _balances[account];
354         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
355         _balances[account] = accountBalance - amount;
356         _totalSupply -= amount;
357 
358         emit Transfer(account, address(0), amount);
359     }
360 
361     /**
362      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
363      *
364      * This internal function is equivalent to `approve`, and can be used to
365      * e.g. set automatic allowances for certain subsystems, etc.
366      *
367      * Emits an {Approval} event.
368      *
369      * Requirements:
370      *
371      * - `owner` cannot be the zero address.
372      * - `spender` cannot be the zero address.
373      */
374     function _approve(address owner, address spender, uint256 amount) internal virtual {
375         require(owner != address(0), "ERC20: approve from the zero address");
376         require(spender != address(0), "ERC20: approve to the zero address");
377 
378         _allowances[owner][spender] = amount;
379         emit Approval(owner, spender, amount);
380     }
381 
382     /**
383      * @dev Hook that is called before any transfer of tokens. This includes
384      * minting and burning.
385      *
386      * Calling conditions:
387      *
388      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
389      * will be to transferred to `to`.
390      * - when `from` is zero, `amount` tokens will be minted for `to`.
391      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
392      * - `from` and `to` are never both zero.
393      *
394      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
395      */
396     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
397 }
398 
399 ///////////////////////////////////////////////
400 // QANX STARTS HERE, OPENZEPPELIN CODE ABOVE //
401 ///////////////////////////////////////////////
402 
403 contract QANX is ERC20 {
404 
405     // EVENTS TO BE EMITTED UPON LOCKS ARE APPLIED & REMOVED
406     event LockApplied(address indexed account, uint256 amount, uint32 hardLockUntil, uint32 softLockUntil, uint8 allowedHops);
407     event LockRemoved(address indexed account);
408 
409     // INITIALIZE AN ERC20 TOKEN BASED ON THE OPENZEPPELIN VERSION
410     constructor() ERC20("QANX Token", "QANX") {
411 
412         // INITIALLY MINT TOTAL SUPPLY TO CREATOR
413         _mint(_msgSender(), 3333333000 * (10 ** 18));
414     }
415 
416     // MAPPING FOR QUANTUM PUBLIC KEY HASHES
417     mapping (address => bytes32) private _qPubKeyHashes;
418 
419     // REGISTER QUANTUM PUBLIC KEY HASH OF THE CURRENT ACCOUNT
420     function setQuantumPubkeyHash(bytes32 qPubKeyHash) external {
421         _qPubKeyHashes[_msgSender()] = qPubKeyHash;
422     }
423 
424     // QUERY A QUANTUM PUBLIC KEY HASH OF A GIVEN ACCOUNT
425     function getQuantumPubkeyHash(address account) external view virtual returns (bytes32) {
426         return _qPubKeyHashes[account];
427     }
428 
429     // REPRESENTS A LOCK WHICH MIGHT BE APPLIED ON AN ADDRESS
430     struct Lock {
431         uint256 tokenAmount;    // HOW MANY TOKENS ARE LOCKED
432         uint32 hardLockUntil;   // UNTIL WHEN NO LOCKED TOKENS CAN BE ACCESSED
433         uint32 softLockUntil;   // UNTIL WHEN LOCKED TOKENS CAN BE GRADUALLY RELEASED
434         uint8 allowedHops;      // HOW MANY TRANSFERS LEFT WITH SAME LOCK PARAMS
435         uint32 lastUnlock;      // LAST GRADUAL UNLOCK TIME (SOFTLOCK PERIOD)
436         uint256 unlockPerSec;   // HOW MANY TOKENS ARE UNLOCKABLE EACH SEC FROM HL -> SL
437     }
438 
439     // THIS MAPS LOCK PARAMS TO CERTAIN ADDRESSES WHICH RECEIVED LOCKED TOKENS
440     mapping (address => Lock) private _locks;
441 
442     // RETURNS LOCK INFORMATION OF A GIVEN ADDRESS
443     function lockOf(address account) external view virtual returns (Lock memory) {
444         return _locks[account];
445     }
446 
447     // RETURN THE BALANCE OF UNLOCKED AND LOCKED TOKENS COMBINED
448     function balanceOf(address account) external view virtual override returns (uint256) {
449         return _balances[account] + _locks[account].tokenAmount;
450     }
451 
452     // TRANSFER FUNCTION WITH LOCK PARAMETERS
453     function transferLocked(address recipient, uint256 amount, uint32 hardLockUntil, uint32 softLockUntil, uint8 allowedHops) external returns (bool) {
454 
455         // ONLY ONE LOCKED TRANSACTION ALLOWED PER RECIPIENT
456         require(_locks[recipient].tokenAmount == 0, "Only one lock per address allowed!");
457 
458         // SENDER MUST HAVE ENOUGH TOKENS (UNLOCKED + LOCKED BALANCE COMBINED)
459         require(_balances[_msgSender()] + _locks[_msgSender()].tokenAmount >= amount, "Transfer amount exceeds balance");
460 
461         // IF SENDER HAS ENOUGH UNLOCKED BALANCE, THEN LOCK PARAMS CAN BE CHOSEN
462         if(_balances[_msgSender()] >= amount){
463 
464             // DEDUCT SENDER BALANCE
465             _balances[_msgSender()] = _balances[_msgSender()] - amount;
466 
467             // APPLY LOCK
468             return _applyLock(recipient, amount, hardLockUntil, softLockUntil, allowedHops);
469         }
470 
471         // OTHERWISE REQUIRE THAT THE CHOSEN LOCK PARAMS ARE SAME / STRICTER (allowedHops) THAN THE SENDER'S
472         require(
473             hardLockUntil >= _locks[_msgSender()].hardLockUntil && 
474             softLockUntil >= _locks[_msgSender()].softLockUntil && 
475             allowedHops < _locks[_msgSender()].allowedHops
476         );
477 
478         // IF SENDER HAS ENOUGH LOCKED BALANCE
479         if(_locks[_msgSender()].tokenAmount >= amount){
480 
481             // DECREASE LOCKED BALANCE OF SENDER
482             _locks[_msgSender()].tokenAmount = _locks[_msgSender()].tokenAmount - amount;
483 
484             // APPLY LOCK
485             return _applyLock(recipient, amount, hardLockUntil, softLockUntil, allowedHops);
486         }
487 
488         // IF NO CONDITIONS WERE MET SO FAR, DEDUCT FROM THE UNLOCKED BALANCE
489         _balances[_msgSender()] = _balances[_msgSender()] - (amount - _locks[_msgSender()].tokenAmount);
490 
491         // THEN SPEND LOCKED BALANCE OF SENDER FIRST
492         _locks[_msgSender()].tokenAmount = 0;
493 
494         // APPLY LOCK
495         return _applyLock(recipient, amount, hardLockUntil, softLockUntil, allowedHops);
496     }
497 
498     // APPLIES LOCK TO RECIPIENT WITH SPECIFIED PARAMS AND EMITS A TRANSFER EVENT
499     function _applyLock(address recipient, uint256 amount, uint32 hardLockUntil, uint32 softLockUntil, uint8 allowedHops) private returns (bool) {
500 
501         // MAKE SURE THAT SOFTLOCK IS AFTER HARDLOCK
502         require(softLockUntil > hardLockUntil, "SoftLock must be greater than HardLock!");
503 
504         // APPLY LOCK, EMIT TRANSFER EVENT
505         _locks[recipient] = Lock(amount, hardLockUntil, softLockUntil, allowedHops, hardLockUntil, amount / (softLockUntil - hardLockUntil));
506         emit LockApplied(recipient, amount, hardLockUntil, softLockUntil, allowedHops);
507         emit Transfer(_msgSender(), recipient, amount);
508         return true;
509     }
510 
511     function lockedBalanceOf(address account) external view virtual returns (uint256) {
512         return _locks[account].tokenAmount;
513     }
514 
515     function unlockedBalanceOf(address account) external view virtual returns (uint256) {
516         return _balances[account];
517     }
518 
519     function unlockableBalanceOf(address account) public view virtual returns (uint256) {
520 
521         // IF THE HARDLOCK HAS NOT PASSED YET, THERE ARE NO UNLOCKABLE TOKENS
522         if(block.timestamp < _locks[account].hardLockUntil) {
523             return 0;
524         }
525 
526         // IF THE SOFTLOCK PERIOD PASSED, ALL CURRENTLY TOKENS ARE UNLOCKABLE
527         if(block.timestamp > _locks[account].softLockUntil) {
528             return _locks[account].tokenAmount;
529         }
530 
531         // OTHERWISE THE PROPORTIONAL AMOUNT IS UNLOCKABLE
532         return (block.timestamp - _locks[account].lastUnlock) * _locks[account].unlockPerSec;
533     }
534 
535     function unlock(address account) external returns (bool) {
536 
537         // CALCULATE UNLOCKABLE BALANCE
538         uint256 unlockable = unlockableBalanceOf(account);
539 
540         // ONLY ADDRESSES OWNING LOCKED TOKENS AND BYPASSED HARDLOCK TIME ARE UNLOCKABLE
541         require(unlockable > 0 && _locks[account].tokenAmount > 0 && block.timestamp > _locks[account].hardLockUntil, "No unlockable tokens!");
542 
543         // SET LAST UNLOCK TIME, DEDUCT FROM LOCKED BALANCE & CREDIT TO REGULAR BALANCE
544         _locks[account].lastUnlock = uint32(block.timestamp);
545         _locks[account].tokenAmount = _locks[account].tokenAmount - unlockable;
546         _balances[account] = _balances[account] + unlockable;
547 
548         // IF NO MORE LOCKED TOKENS LEFT, REMOVE LOCK OBJECT FROM ADDRESS
549         if(_locks[account].tokenAmount == 0){
550             delete _locks[account];
551             emit LockRemoved(account);
552         }
553 
554         // UNLOCK SUCCESSFUL
555         emit Transfer(account, account, unlockable);
556         return true;
557     }
558 }