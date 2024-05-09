1 //SPDX-License-Identifier: NONE
2 
3 pragma solidity ^0.8.0;
4 
5 interface Ialien {
6     function balanceOf(address _user) external view returns (uint);
7 
8     function tokensOfWalletOwner(address _user) external view returns (uint256[] memory);
9 
10     function ownerOf(uint256 tokenId) external view returns (address owner);
11 
12     function totalSupply() external view returns (uint256);
13 }
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
95 
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 
120 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
121 
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
145 
146 
147 /**
148  * @dev Implementation of the {IERC20} interface.
149  *
150  * This implementation is agnostic to the way tokens are created. This means
151  * that a supply mechanism has to be added in a derived contract using {_mint}.
152  * For a generic mechanism see {ERC20PresetMinterPauser}.
153  *
154  * TIP: For a detailed writeup see our guide
155  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
156  * to implement supply mechanisms].
157  *
158  * We have followed general OpenZeppelin Contracts guidelines: functions revert
159  * instead returning `false` on failure. This behavior is nonetheless
160  * conventional and does not conflict with the expectations of ERC20
161  * applications.
162  *
163  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
164  * This allows applications to reconstruct the allowance for all accounts just
165  * by listening to said events. Other implementations of the EIP may not emit
166  * these events, as it isn't required by the specification.
167  *
168  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
169  * functions have been added to mitigate the well-known issues around setting
170  * allowances. See {IERC20-approve}.
171  */
172 contract ERC20 is Context, IERC20, IERC20Metadata {
173     mapping(address => uint256) private _balances;
174 
175     mapping(address => mapping(address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     string private _name;
180     string private _symbol;
181 
182     /**
183      * @dev Sets the values for {name} and {symbol}.
184      *
185      * The default value of {decimals} is 18. To select a different value for
186      * {decimals} you should overload it.
187      *
188      * All two of these values are immutable: they can only be set once during
189      * construction.
190      */
191     constructor(string memory name_, string memory symbol_) {
192         _name = name_;
193         _symbol = symbol_;
194     }
195 
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() public view virtual override returns (string memory) {
200         return _name;
201     }
202 
203     /**
204      * @dev Returns the symbol of the token, usually a shorter version of the
205      * name.
206      */
207     function symbol() public view virtual override returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @dev Returns the number of decimals used to get its user representation.
213      * For example, if `decimals` equals `2`, a balance of `505` tokens should
214      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
215      *
216      * Tokens usually opt for a value of 18, imitating the relationship between
217      * Ether and Wei. This is the value {ERC20} uses, unless this function is
218      * overridden;
219      *
220      * NOTE: This information is only used for _display_ purposes: it in
221      * no way affects any of the arithmetic of the contract, including
222      * {IERC20-balanceOf} and {IERC20-transfer}.
223      */
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     /**
229      * @dev See {IERC20-totalSupply}.
230      */
231     function totalSupply() public view virtual override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(address account) public view virtual override returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 amount) public virtual override returns (bool) {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-transferFrom}.
276      *
277      * Emits an {Approval} event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of {ERC20}.
279      *
280      * Requirements:
281      *
282      * - `sender` and `recipient` cannot be the zero address.
283      * - `sender` must have a balance of at least `amount`.
284      * - the caller must have allowance for ``sender``'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(
288         address sender,
289         address recipient,
290         uint256 amount
291     ) public virtual override returns (bool) {
292         _transfer(sender, recipient, amount);
293 
294         uint256 currentAllowance = _allowances[sender][_msgSender()];
295         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
296     unchecked {
297         _approve(sender, _msgSender(), currentAllowance - amount);
298     }
299 
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
316         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
317         return true;
318     }
319 
320     /**
321      * @dev Atomically decreases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      * - `spender` must have allowance for the caller of at least
332      * `subtractedValue`.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
335         uint256 currentAllowance = _allowances[_msgSender()][spender];
336         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
337     unchecked {
338         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
339     }
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
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) internal virtual {
363         require(sender != address(0), "ERC20: transfer from the zero address");
364         require(recipient != address(0), "ERC20: transfer to the zero address");
365 
366         _beforeTokenTransfer(sender, recipient, amount);
367 
368         uint256 senderBalance = _balances[sender];
369         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
370     unchecked {
371         _balances[sender] = senderBalance - amount;
372     }
373         _balances[recipient] += amount;
374 
375         emit Transfer(sender, recipient, amount);
376 
377         _afterTokenTransfer(sender, recipient, amount);
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
419     unchecked {
420         _balances[account] = accountBalance - amount;
421     }
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
455      * @dev Hook that is called before any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * will be transferred to `to`.
462      * - when `from` is zero, `amount` tokens will be minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _beforeTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 
474     /**
475      * @dev Hook that is called after any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * has been transferred to `to`.
482      * - when `from` is zero, `amount` tokens have been minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _afterTokenTransfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {}
493 }
494 
495 // File contracts/StarToken.sol
496 
497 pragma solidity ^0.8.0;
498 
499 contract StarToken is ERC20 ("Star", "STAR") {
500 
501     uint public burnRate = 5 ether;
502     uint public startingStar = 126 ether;
503     uint public START;
504     uint public END;
505     //^^ https://www.epochconverter.com/ |
506 
507     mapping(uint => uint) private lastClaim;
508     mapping(address => uint) private claimTime;
509 
510     Ialien public alienContract;
511 
512     event rewardPaid(address indexed user, uint256 reward);
513 
514     constructor(address _alien) {
515         alienContract = Ialien(_alien);
516         START = block.timestamp;
517         END = START + 157766400;
518         //^^ 5 years from deployment
519 
520     }
521 
522     function checkaliens(address _owner) public view returns (uint[] memory){
523         return alienContract.tokensOfWalletOwner(_owner);
524     }
525 
526     function checkReward(uint256 tokenId) public view returns (uint256) {
527         require(alienContract.ownerOf(tokenId) != address(0), "alien has no owner");
528         require(tokenId < alienContract.totalSupply(), "alien is nonexistent");
529         uint _lastClaimed = uint(lastClaim[tokenId]);
530         uint claimPeriod = _lastClaimed == 0 ? START : _lastClaimed;
531 
532         //There are 86400 seconds in a day
533         uint rewardAmount = ((block.timestamp - claimPeriod) * burnRate) / 86400;
534 
535         // TO CLAIM STARTING STAR
536         if (_lastClaimed == 0) rewardAmount += startingStar;
537 
538         return rewardAmount;
539     }
540 
541     function getLastClaim(address _owner) public view returns (uint256) {
542         return claimTime[_owner];
543     }
544 
545     function checkTotalRewards(uint256[] memory tokenIds) public view returns (uint256) {
546         uint256 rewardAmount = 0;
547         for (uint i = 0; i < tokenIds.length; i++) {
548             rewardAmount = rewardAmount + checkReward(tokenIds[i]);
549         }
550 
551         return rewardAmount;
552     }
553 
554     function claimRewards(uint[] memory tokenIds, address _owner) public returns (uint){
555         require(block.timestamp < END, "There is no more $STAR available");
556         uint totalClaimQty = 0;
557 
558         for (uint i = 0; i < tokenIds.length; i++) {
559             require(tokenIds[i] < alienContract.totalSupply(), "alien is nonexistent");
560             require(alienContract.ownerOf(tokenIds[i]) == msg.sender, "Claimant is not the owner");
561 
562             uint claimQty = checkReward(tokenIds[i]);
563             if (claimQty != 0) {
564                 totalClaimQty += claimQty;
565                 lastClaim[tokenIds[i]] = block.timestamp;
566             }
567         }
568 
569         require(totalClaimQty != 0, "No accumulated $STAR");
570 
571         _mint(msg.sender, totalClaimQty);
572         claimTime[_owner] = block.timestamp;
573 
574         emit rewardPaid(msg.sender, totalClaimQty);
575         return totalClaimQty;
576     }
577 }