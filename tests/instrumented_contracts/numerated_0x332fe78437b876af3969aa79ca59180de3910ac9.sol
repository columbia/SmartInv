1 /*
2 https://twitter.com/BurnerBeacon
3 https://t.me/BurnerBeaconBot
4 https://www.burnerbeacon.io/
5 https://t.me/ThisIsBurnerBeacon
6 
7 ##########################################################BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
8 ##########################################BBGP55YYYY55PGBB###BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
9 #######################################G5J???JYYY55YYYJ??JY5GB##BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
10 ####################################B5J?JYPGB##########BGPYJ?J5B##BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
11 ##################################B5??YGB####BBGGGGGGBB####BGY??YB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
12 #################################P?75B####BPYJ???77???JYPB####B57?P#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
13 ################################57?G####GY?7777??????7777?YG#B##G?75BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
14 ###############################57?B###B5?7????7777777????77?5BBB#G?75#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
15 ##############################G?7P####Y7?????7?JY55YJ?7????77YBBB#P7?GBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
16 ##############################57JB###G7?????7JG######G?7????77G#BBBJ75#BBBBBBBBBBBBBBBBBBBBBBBBBBBBB
17 ##############################57Y####57?????75#BBBBBB#57?????75#BB#J75#BBBBBBBBBBBBBBBBBBBBBBBBBBBBB
18 ##############################57J####P7?????7JB##BBB#GJ7?????7P#BBBJ75#BBBBBBBBBBBBBBBBBBBBBBBBBBBBB
19 ##############################G??G###BJ7?????7?5B###BJ77????7JBBB#G??GBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
20 ###############################Y7JB###BJ77????77?YG##G5?7777JBBB#BJ7Y#BB####BBBBBBBBBBBBBBBBBBBBBBBB
21 ##############BBGP5YYYJYYY55PGBBY7YB###B5?77????77?YG##B5JJ5B#B#BJ7YBBGP55YYJJJYY55PGBBBBBBBBBBBBBBB
22 ###########BPY??JJY555P555YYJ??Y5J7?PB###BPJ??????77?YG##BB#BBBP?7J5Y??JJY555555YYJ???J5GBBBBBBBBBBB
23 #########PJ??YPBB############BP5J?77JB#B###P?7??????777JPB#BBBBJ77?JYPGB##########BBGPY??JPBBBBBBBBB
24 #######PJ7JGB####BBGPPPPPGBB####BG5GB###BPJ77??????????77JPB#BBBP5GB###BBGGPPPPPGGBB#BBBPJ7JPBBBBBBB
25 #####BY7JG####BPYJ??777777?JYPB#######BPJ77?????7??7?????77J5B#B###B#BPY???77777??JYPBBBBBGJ7YBBBBBB
26 ####BJ75####B5?7777????????777?5####B5?77????77?YGGY?77????77?5B##BGY?7777????????777?5BBBBBY7JGBBBB
27 ###BJ75####G?77????7777777?77?YG##B5?77????77?YG####GY?77????77?5PY?77????7777777????77?PBBBB57JBBBB
28 ###57J####G?7??????J5PPPYJ??5B##GY?77????77?5B##BBBB##B5?77????7777?????77JY5P55J7?????7?GBBBBJ75BBB
29 ##BJ7P####Y7?????75######BGB##GY?77??????J5B##BBBBBBBB##B5????????????77JPB#BBBBB57?????7YBBBB57JBBB
30 ##B?7P###BJ7????7?B#########GY?7???????7JB##BBBBBBBBBBBB##BJ7???????77JPB#BBBBBB#G??????7JBBBBP7?BBB
31 ###J75####Y7?????75######BPJ?7???????????J5B##BBBBBBBB##B5J???????7?YGB#BGBBBBB#B5??????7YBBBB5?JBBB
32 ###57J####G?7??????J5PPP5J77?????7777????77?5B##BBBB##B5?77????77?YG##B5??J5PPP5J??????7?GBBBBJ75BBB
33 ###BJ75####G?77????7777777?????7?YP5?77????77?5G####GY?77????77?YGBBG5???????7777??????JGBBBB57JBBBB
34 ####G?75####B5?777????????7777?YG###B5?77????77?YGGY?77????77?5G#BBB5????????????7777?5BBBBBY7?GBBBB
35 #####BJ7JG####BPYJ?7777777??YPB#######B5?77????77??7?????77?5B#BB#BB#BPY??77??????JYPBBBBBGJ7JGBBBBB
36 #######P?7YGB####BBGPPPPPGGB####BG5G####BPJ77???????????7JPB#BBBGPGB###BBGGPPPPPGGBBBBBBPY7?PBBBBBBB
37 ########BPJ?J5GBB############BG5J?77JB#B##BPJ77???????7?PB#BBBBJ7??J5GBBB#########BBGPY??JPBBBBBBBBB
38 ###########BPY??JYY5PPPPP5YJJ??J5J7?PB###BB#BPJ?7???????JPB#BBBP??Y5Y??JJY55PPPP5YJJ??J5GBBBBBBBBBBB
39 ##############BGP5YYJJJJYYY5PGBBY7YB###BPJJPB##GY?77????7?JPBBB#BJ?YBBGP5YYYYJYYYY5PGBBBBBBBBBBBBBBB
40 ###############################Y7JB###BJ7777?5B##GY?77??????YB#BBBJ75######BBBBBBBBBBBBBBBBBBBBBBBBB
41 ##############################G??G###BJ7????77JBB##GY?7??????YBBB#G??GBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
42 ##############################57J####P7?????7JGBBBB##GJ7??????P#BBBJ75BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
43 ##############################57Y####57?????75########5???????5#BB#Y75BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
44 ##############################57JB###P7?????7JB######GJ???????G#BBBJ75#BBBBBBBBBBBBBBBBBBBBBBBBBBBBB
45 ##############################G?7G#B#BY7?????7?Y5555Y?7????77YBBB#P7?GBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
46 ###############################57JB#B#BY??????7777???????77?YBBB#B?75#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
47 ################################57JG####GY????????????????YG#BB#G?75BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
48 #################################P??5B####GPYJ???777??JYPGB###B57?PBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
49 ##############################B###B5??5GB####BBGGPPGGBB####BG5??YB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
50 ##############################B##B##B5J?J5GBB##########BBP5J??5G#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
51 ######################################BG5J??JJYY5555YYJ???J5GB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
52 ##########################################BGP55YYYYYY55PGBB##BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
53 #########################################################BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
54 */
55 
56 // SPDX-License-Identifier: MIT
57 pragma solidity 0.8.19;
58 
59 /**
60  * @dev Provides information about the current execution context, including the
61  * sender of the transaction and its data. While these are generally available
62  * via msg.sender and msg.data, they should not be accessed in such a direct
63  * manner, since when dealing with meta-transactions the account sending and
64  * paying for execution may not be the actual sender (as far as an application
65  * is concerned).
66  *
67  * This contract is only required for intermediate, library-like contracts.
68  */
69 abstract contract Context {
70     function _msgSender() internal view virtual returns (address) {
71         return msg.sender;
72     }
73 
74     function _msgData() internal view virtual returns (bytes calldata) {
75         return msg.data;
76     }
77 }
78 
79 /**
80  * @dev Interface of the ERC20 standard as defined in the EIP.
81  */
82 interface IERC20 {
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `to`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address to, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through {transferFrom}. This is
119      * zero by default.
120      *
121      * This value changes when {approve} or {transferFrom} are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * IMPORTANT: Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `from` to `to` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transferFrom(
151         address from,
152         address to,
153         uint256 amount
154     ) external returns (bool);
155 }
156 
157 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
158 
159 
160 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
161 
162 
163 /**
164  * @dev Interface for the optional metadata functions from the ERC20 standard.
165  *
166  * _Available since v4.1._
167  */
168 interface IERC20Metadata is IERC20 {
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() external view returns (string memory);
173 
174     /**
175      * @dev Returns the symbol of the token.
176      */
177     function symbol() external view returns (string memory);
178 
179     /**
180      * @dev Returns the decimals places of the token.
181      */
182     function decimals() external view returns (uint8);
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
189 
190 /**
191  * @dev Implementation of the {IERC20} interface.
192  *
193  * This implementation is agnostic to the way tokens are created. This means
194  * that a supply mechanism has to be added in a derived contract using {_mint}.
195  * For a generic mechanism see {ERC20PresetMinterPauser}.
196  *
197  * TIP: For a detailed writeup see our guide
198  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
199  * to implement supply mechanisms].
200  *
201  * We have followed general OpenZeppelin Contracts guidelines: functions revert
202  * instead returning `false` on failure. This behavior is nonetheless
203  * conventional and does not conflict with the expectations of ERC20
204  * applications.
205  *
206  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
207  * This allows applications to reconstruct the allowance for all accounts just
208  * by listening to said events. Other implementations of the EIP may not emit
209  * these events, as it isn't required by the specification.
210  *
211  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
212  * functions have been added to mitigate the well-known issues around setting
213  * allowances. See {IERC20-approve}.
214  */
215 contract ERC20 is Context, IERC20, IERC20Metadata {
216     mapping(address => uint256) private _balances;
217 
218     mapping(address => mapping(address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     string private _name;
223     string private _symbol;
224 
225     /**
226      * @dev Sets the values for {name} and {symbol}.
227      *
228      * The default value of {decimals} is 18. To select a different value for
229      * {decimals} you should overload it.
230      *
231      * All two of these values are immutable: they can only be set once during
232      * construction.
233      */
234     constructor(string memory name_, string memory symbol_) {
235         _name = name_;
236         _symbol = symbol_;
237     }
238 
239     /**
240      * @dev Returns the name of the token.
241      */
242     function name() public view virtual override returns (string memory) {
243         return _name;
244     }
245 
246     /**
247      * @dev Returns the symbol of the token, usually a shorter version of the
248      * name.
249      */
250     function symbol() public view virtual override returns (string memory) {
251         return _symbol;
252     }
253 
254     /**
255      * @dev Returns the number of decimals used to get its user representation.
256      * For example, if `decimals` equals `2`, a balance of `505` tokens should
257      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
258      *
259      * Tokens usually opt for a value of 18, imitating the relationship between
260      * Ether and Wei. This is the value {ERC20} uses, unless this function is
261      * overridden;
262      *
263      * NOTE: This information is only used for _display_ purposes: it in
264      * no way affects any of the arithmetic of the contract, including
265      * {IERC20-balanceOf} and {IERC20-transfer}.
266      */
267     function decimals() public view virtual override returns (uint8) {
268         return 18;
269     }
270 
271     /**
272      * @dev See {IERC20-totalSupply}.
273      */
274     function totalSupply() public view virtual override returns (uint256) {
275         return _totalSupply;
276     }
277 
278     /**
279      * @dev See {IERC20-balanceOf}.
280      */
281     function balanceOf(address account) public view virtual override returns (uint256) {
282         return _balances[account];
283     }
284 
285     /**
286      * @dev See {IERC20-transfer}.
287      *
288      * Requirements:
289      *
290      * - `to` cannot be the zero address.
291      * - the caller must have a balance of at least `amount`.
292      */
293     function transfer(address to, uint256 amount) public virtual override returns (bool) {
294         address owner = _msgSender();
295         _transfer(owner, to, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-allowance}.
301      */
302     function allowance(address owner, address spender) public view virtual override returns (uint256) {
303         return _allowances[owner][spender];
304     }
305 
306     /**
307      * @dev See {IERC20-approve}.
308      *
309      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
310      * `transferFrom`. This is semantically equivalent to an infinite approval.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function approve(address spender, uint256 amount) public virtual override returns (bool) {
317         address owner = _msgSender();
318         _approve(owner, spender, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-transferFrom}.
324      *
325      * Emits an {Approval} event indicating the updated allowance. This is not
326      * required by the EIP. See the note at the beginning of {ERC20}.
327      *
328      * NOTE: Does not update the allowance if the current allowance
329      * is the maximum `uint256`.
330      *
331      * Requirements:
332      *
333      * - `from` and `to` cannot be the zero address.
334      * - `from` must have a balance of at least `amount`.
335      * - the caller must have allowance for ``from``'s tokens of at least
336      * `amount`.
337      */
338     function transferFrom(
339         address from,
340         address to,
341         uint256 amount
342     ) public virtual override returns (bool) {
343         address spender = _msgSender();
344         _spendAllowance(from, spender, amount);
345         _transfer(from, to, amount);
346         return true;
347     }
348 
349     /**
350      * @dev Atomically increases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to {approve} that can be used as a mitigation for
353      * problems described in {IERC20-approve}.
354      *
355      * Emits an {Approval} event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
362         address owner = _msgSender();
363         _approve(owner, spender, allowance(owner, spender) + addedValue);
364         return true;
365     }
366 
367     /**
368      * @dev Atomically decreases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      * - `spender` must have allowance for the caller of at least
379      * `subtractedValue`.
380      */
381     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
382         address owner = _msgSender();
383         uint256 currentAllowance = allowance(owner, spender);
384         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
385         unchecked {
386             _approve(owner, spender, currentAllowance - subtractedValue);
387         }
388 
389         return true;
390     }
391 
392     /**
393      * @dev Moves `amount` of tokens from `from` to `to`.
394      *
395      * This internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `from` cannot be the zero address.
403      * - `to` cannot be the zero address.
404      * - `from` must have a balance of at least `amount`.
405      */
406     function _transfer(
407         address from,
408         address to,
409         uint256 amount
410     ) internal virtual {
411         require(from != address(0), "ERC20: transfer from the zero address");
412         require(to != address(0), "ERC20: transfer to the zero address");
413 
414         _beforeTokenTransfer(from, to, amount);
415 
416         uint256 fromBalance = _balances[from];
417         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
418         unchecked {
419             _balances[from] = fromBalance - amount;
420             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
421             // decrementing then incrementing.
422             _balances[to] += amount;
423         }
424 
425         emit Transfer(from, to, amount);
426 
427         _afterTokenTransfer(from, to, amount);
428     }
429 
430     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
431      * the total supply.
432      *
433      * Emits a {Transfer} event with `from` set to the zero address.
434      *
435      * Requirements:
436      *
437      * - `account` cannot be the zero address.
438      */
439     function _mint(address account, uint256 amount) internal virtual {
440         require(account != address(0), "ERC20: mint to the zero address");
441 
442         _beforeTokenTransfer(address(0), account, amount);
443 
444         _totalSupply += amount;
445         unchecked {
446             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
447             _balances[account] += amount;
448         }
449         emit Transfer(address(0), account, amount);
450 
451         _afterTokenTransfer(address(0), account, amount);
452     }
453 
454     /**
455      * @dev Destroys `amount` tokens from `account`, reducing the
456      * total supply.
457      *
458      * Emits a {Transfer} event with `to` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      * - `account` must have at least `amount` tokens.
464      */
465     function _burn(address account, uint256 amount) internal virtual {
466         require(account != address(0), "ERC20: burn from the zero address");
467 
468         _beforeTokenTransfer(account, address(0), amount);
469 
470         uint256 accountBalance = _balances[account];
471         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
472         unchecked {
473             _balances[account] = accountBalance - amount;
474             // Overflow not possible: amount <= accountBalance <= totalSupply.
475             _totalSupply -= amount;
476         }
477 
478         emit Transfer(account, address(0), amount);
479 
480         _afterTokenTransfer(account, address(0), amount);
481     }
482 
483     /**
484      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
485      *
486      * This internal function is equivalent to `approve`, and can be used to
487      * e.g. set automatic allowances for certain subsystems, etc.
488      *
489      * Emits an {Approval} event.
490      *
491      * Requirements:
492      *
493      * - `owner` cannot be the zero address.
494      * - `spender` cannot be the zero address.
495      */
496     function _approve(
497         address owner,
498         address spender,
499         uint256 amount
500     ) internal virtual {
501         require(owner != address(0), "ERC20: approve from the zero address");
502         require(spender != address(0), "ERC20: approve to the zero address");
503 
504         _allowances[owner][spender] = amount;
505         emit Approval(owner, spender, amount);
506     }
507 
508     /**
509      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
510      *
511      * Does not update the allowance amount in case of infinite allowance.
512      * Revert if not enough allowance is available.
513      *
514      * Might emit an {Approval} event.
515      */
516     function _spendAllowance(
517         address owner,
518         address spender,
519         uint256 amount
520     ) internal virtual {
521         uint256 currentAllowance = allowance(owner, spender);
522         if (currentAllowance != type(uint256).max) {
523             require(currentAllowance >= amount, "ERC20: insufficient allowance");
524             unchecked {
525                 _approve(owner, spender, currentAllowance - amount);
526             }
527         }
528     }
529 
530     /**
531      * @dev Hook that is called before any transfer of tokens. This includes
532      * minting and burning.
533      *
534      * Calling conditions:
535      *
536      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
537      * will be transferred to `to`.
538      * - when `from` is zero, `amount` tokens will be minted for `to`.
539      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
540      * - `from` and `to` are never both zero.
541      *
542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
543      */
544     function _beforeTokenTransfer(
545         address from,
546         address to,
547         uint256 amount
548     ) internal virtual {}
549 
550     /**
551      * @dev Hook that is called after any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * has been transferred to `to`.
558      * - when `from` is zero, `amount` tokens have been minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _afterTokenTransfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal virtual {}
569 }
570 
571 contract Ownable is Context {
572     address public _owner;
573 
574     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
575 
576     constructor () {
577         address msgSender = _msgSender();
578         _owner = msgSender;
579         authorizations[_owner] = true;
580         emit OwnershipTransferred(address(0), msgSender);
581     }
582     mapping (address => bool) internal authorizations;
583 
584     function owner() public view returns (address) {
585         return _owner;
586     }
587 
588     modifier onlyOwner() {
589         require(_owner == _msgSender(), "Ownable: caller is not the owner");
590         _;
591     }
592 
593     function renounceOwnership() public virtual onlyOwner {
594         emit OwnershipTransferred(_owner, address(0));
595         _owner = address(0);
596     }
597 
598     function transferOwnership(address newOwner) public virtual onlyOwner {
599         require(newOwner != address(0), "Ownable: new owner is the zero address");
600         emit OwnershipTransferred(_owner, newOwner);
601         _owner = newOwner;
602     }
603 }
604 
605 interface IUniswapV2Factory {
606     function createPair(address tokenA, address tokenB) external returns (address pair);
607 }
608 
609 interface IUniswapV2Router02 {
610     function factory() external pure returns (address);
611     function WETH() external pure returns (address);
612 
613     function swapExactTokensForETHSupportingFeeOnTransferTokens(
614         uint amountIn,
615         uint amountOutMin,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external;
620 }
621 
622 library Math {
623     /**
624      * @dev Muldiv operation overflow.
625      */
626     error MathOverflowedMulDiv();
627 
628     enum Rounding {
629         Floor, // Toward negative infinity
630         Ceil, // Toward positive infinity
631         Trunc, // Toward zero
632         Expand // Away from zero
633     }
634 
635     /**
636      * @dev Returns the addition of two unsigned integers, with an overflow flag.
637      */
638     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             uint256 c = a + b;
641             if (c < a) return (false, 0);
642             return (true, c);
643         }
644     }
645 
646     /**
647      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
648      */
649     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
650         unchecked {
651             if (b > a) return (false, 0);
652             return (true, a - b);
653         }
654     }
655 
656     /**
657      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
658      */
659     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
662             // benefit is lost if 'b' is also tested.
663             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
664             if (a == 0) return (true, 0);
665             uint256 c = a * b;
666             if (c / a != b) return (false, 0);
667             return (true, c);
668         }
669     }
670 
671     /**
672      * @dev Returns the division of two unsigned integers, with a division by zero flag.
673      */
674     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
675         unchecked {
676             if (b == 0) return (false, 0);
677             return (true, a / b);
678         }
679     }
680 
681     /**
682      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
683      */
684     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
685         unchecked {
686             if (b == 0) return (false, 0);
687             return (true, a % b);
688         }
689     }
690 
691     /**
692      * @dev Returns the largest of two numbers.
693      */
694     function max(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a > b ? a : b;
696     }
697 
698     /**
699      * @dev Returns the smallest of two numbers.
700      */
701     function min(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a < b ? a : b;
703     }
704 
705     /**
706      * @dev Returns the average of two numbers. The result is rounded towards
707      * zero.
708      */
709     function average(uint256 a, uint256 b) internal pure returns (uint256) {
710         // (a + b) / 2 can overflow.
711         return (a & b) + (a ^ b) / 2;
712     }
713 
714     /**
715      * @dev Returns the ceiling of the division of two numbers.
716      *
717      * This differs from standard division with `/` in that it rounds towards infinity instead
718      * of rounding towards zero.
719      */
720     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
721         if (b == 0) {
722             // Guarantee the same behavior as in a regular Solidity division.
723             return a / b;
724         }
725 
726         // (a + b - 1) / b can overflow on addition, so we distribute.
727         return a == 0 ? 0 : (a - 1) / b + 1;
728     }
729 
730     /**
731      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
732      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
733      * with further edits by Uniswap Labs also under MIT license.
734      */
735     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
736         unchecked {
737             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
738             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
739             // variables such that product = prod1 * 2^256 + prod0.
740             uint256 prod0; // Least significant 256 bits of the product
741             uint256 prod1; // Most significant 256 bits of the product
742             assembly {
743                 let mm := mulmod(x, y, not(0))
744                 prod0 := mul(x, y)
745                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
746             }
747 
748             // Handle non-overflow cases, 256 by 256 division.
749             if (prod1 == 0) {
750                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
751                 // The surrounding unchecked block does not change this fact.
752                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
753                 return prod0 / denominator;
754             }
755 
756             // Make sure the result is less than 2^256. Also prevents denominator == 0.
757             if (denominator <= prod1) {
758                 revert MathOverflowedMulDiv();
759             }
760 
761             ///////////////////////////////////////////////
762             // 512 by 256 division.
763             ///////////////////////////////////////////////
764 
765             // Make division exact by subtracting the remainder from [prod1 prod0].
766             uint256 remainder;
767             assembly {
768                 // Compute remainder using mulmod.
769                 remainder := mulmod(x, y, denominator)
770 
771                 // Subtract 256 bit number from 512 bit number.
772                 prod1 := sub(prod1, gt(remainder, prod0))
773                 prod0 := sub(prod0, remainder)
774             }
775 
776             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
777             // See https://cs.stackexchange.com/q/138556/92363.
778 
779             // Does not overflow because the denominator cannot be zero at this stage in the function.
780             uint256 twos = denominator & (~denominator + 1);
781             assembly {
782                 // Divide denominator by twos.
783                 denominator := div(denominator, twos)
784 
785                 // Divide [prod1 prod0] by twos.
786                 prod0 := div(prod0, twos)
787 
788                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
789                 twos := add(div(sub(0, twos), twos), 1)
790             }
791 
792             // Shift in bits from prod1 into prod0.
793             prod0 |= prod1 * twos;
794 
795             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
796             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
797             // four bits. That is, denominator * inv = 1 mod 2^4.
798             uint256 inverse = (3 * denominator) ^ 2;
799 
800             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
801             // in modular arithmetic, doubling the correct bits in each step.
802             inverse *= 2 - denominator * inverse; // inverse mod 2^8
803             inverse *= 2 - denominator * inverse; // inverse mod 2^16
804             inverse *= 2 - denominator * inverse; // inverse mod 2^32
805             inverse *= 2 - denominator * inverse; // inverse mod 2^64
806             inverse *= 2 - denominator * inverse; // inverse mod 2^128
807             inverse *= 2 - denominator * inverse; // inverse mod 2^256
808 
809             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
810             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
811             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
812             // is no longer required.
813             result = prod0 * inverse;
814             return result;
815         }
816     }
817 
818     /**
819      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
820      */
821     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
822         uint256 result = mulDiv(x, y, denominator);
823         if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
824             result += 1;
825         }
826         return result;
827     }
828 
829     /**
830      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
831      * towards zero.
832      *
833      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
834      */
835     function sqrt(uint256 a) internal pure returns (uint256) {
836         if (a == 0) {
837             return 0;
838         }
839 
840         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
841         //
842         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
843         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
844         //
845         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
846         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
847         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
848         //
849         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
850         uint256 result = 1 << (log2(a) >> 1);
851 
852         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
853         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
854         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
855         // into the expected uint128 result.
856         unchecked {
857             result = (result + a / result) >> 1;
858             result = (result + a / result) >> 1;
859             result = (result + a / result) >> 1;
860             result = (result + a / result) >> 1;
861             result = (result + a / result) >> 1;
862             result = (result + a / result) >> 1;
863             result = (result + a / result) >> 1;
864             return min(result, a / result);
865         }
866     }
867 
868     /**
869      * @notice Calculates sqrt(a), following the selected rounding direction.
870      */
871     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
872         unchecked {
873             uint256 result = sqrt(a);
874             return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
875         }
876     }
877 
878     /**
879      * @dev Return the log in base 2 of a positive value rounded towards zero.
880      * Returns 0 if given 0.
881      */
882     function log2(uint256 value) internal pure returns (uint256) {
883         uint256 result = 0;
884         unchecked {
885             if (value >> 128 > 0) {
886                 value >>= 128;
887                 result += 128;
888             }
889             if (value >> 64 > 0) {
890                 value >>= 64;
891                 result += 64;
892             }
893             if (value >> 32 > 0) {
894                 value >>= 32;
895                 result += 32;
896             }
897             if (value >> 16 > 0) {
898                 value >>= 16;
899                 result += 16;
900             }
901             if (value >> 8 > 0) {
902                 value >>= 8;
903                 result += 8;
904             }
905             if (value >> 4 > 0) {
906                 value >>= 4;
907                 result += 4;
908             }
909             if (value >> 2 > 0) {
910                 value >>= 2;
911                 result += 2;
912             }
913             if (value >> 1 > 0) {
914                 result += 1;
915             }
916         }
917         return result;
918     }
919 
920     /**
921      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
922      * Returns 0 if given 0.
923      */
924     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
925         unchecked {
926             uint256 result = log2(value);
927             return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
928         }
929     }
930 
931     /**
932      * @dev Return the log in base 10 of a positive value rounded towards zero.
933      * Returns 0 if given 0.
934      */
935     function log10(uint256 value) internal pure returns (uint256) {
936         uint256 result = 0;
937         unchecked {
938             if (value >= 10 ** 64) {
939                 value /= 10 ** 64;
940                 result += 64;
941             }
942             if (value >= 10 ** 32) {
943                 value /= 10 ** 32;
944                 result += 32;
945             }
946             if (value >= 10 ** 16) {
947                 value /= 10 ** 16;
948                 result += 16;
949             }
950             if (value >= 10 ** 8) {
951                 value /= 10 ** 8;
952                 result += 8;
953             }
954             if (value >= 10 ** 4) {
955                 value /= 10 ** 4;
956                 result += 4;
957             }
958             if (value >= 10 ** 2) {
959                 value /= 10 ** 2;
960                 result += 2;
961             }
962             if (value >= 10 ** 1) {
963                 result += 1;
964             }
965         }
966         return result;
967     }
968 
969     /**
970      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
971      * Returns 0 if given 0.
972      */
973     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
974         unchecked {
975             uint256 result = log10(value);
976             return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
977         }
978     }
979 
980     /**
981      * @dev Return the log in base 256 of a positive value rounded towards zero.
982      * Returns 0 if given 0.
983      *
984      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
985      */
986     function log256(uint256 value) internal pure returns (uint256) {
987         uint256 result = 0;
988         unchecked {
989             if (value >> 128 > 0) {
990                 value >>= 128;
991                 result += 16;
992             }
993             if (value >> 64 > 0) {
994                 value >>= 64;
995                 result += 8;
996             }
997             if (value >> 32 > 0) {
998                 value >>= 32;
999                 result += 4;
1000             }
1001             if (value >> 16 > 0) {
1002                 value >>= 16;
1003                 result += 2;
1004             }
1005             if (value >> 8 > 0) {
1006                 result += 1;
1007             }
1008         }
1009         return result;
1010     }
1011 
1012     /**
1013      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
1014      * Returns 0 if given 0.
1015      */
1016     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1017         unchecked {
1018             uint256 result = log256(value);
1019             return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
1020         }
1021     }
1022 
1023     /**
1024      * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
1025      */
1026     function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
1027         return uint8(rounding) % 2 == 1;
1028     }
1029 }
1030 
1031 abstract contract ReentrancyGuard {
1032     // Booleans are more expensive than uint256 or any type that takes up a full
1033     // word because each write operation emits an extra SLOAD to first read the
1034     // slot's contents, replace the bits taken up by the boolean, and then write
1035     // back. This is the compiler's defense against contract upgrades and
1036     // pointer aliasing, and it cannot be disabled.
1037 
1038     // The values being non-zero value makes deployment a bit more expensive,
1039     // but in exchange the refund on every call to nonReentrant will be lower in
1040     // amount. Since refunds are capped to a percentage of the total
1041     // transaction's gas, it is best to keep them low in cases like this one, to
1042     // increase the likelihood of the full refund coming into effect.
1043     uint256 private constant _NOT_ENTERED = 1;
1044     uint256 private constant _ENTERED = 2;
1045 
1046     uint256 private _status;
1047 
1048     /**
1049      * @dev Unauthorized reentrant call.
1050      */
1051     error ReentrancyGuardReentrantCall();
1052 
1053     constructor() {
1054         _status = _NOT_ENTERED;
1055     }
1056 
1057     /**
1058      * @dev Prevents a contract from calling itself, directly or indirectly.
1059      * Calling a `nonReentrant` function from another `nonReentrant`
1060      * function is not supported. It is possible to prevent this from happening
1061      * by making the `nonReentrant` function external, and making it call a
1062      * `private` function that does the actual work.
1063      */
1064     modifier nonReentrant() {
1065         _nonReentrantBefore();
1066         _;
1067         _nonReentrantAfter();
1068     }
1069 
1070     function _nonReentrantBefore() private {
1071         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1072         if (_status == _ENTERED) {
1073             revert ReentrancyGuardReentrantCall();
1074         }
1075 
1076         // Any calls to nonReentrant after this point will fail
1077         _status = _ENTERED;
1078     }
1079 
1080     function _nonReentrantAfter() private {
1081         // By storing the original value once again, a refund is triggered (see
1082         // https://eips.ethereum.org/EIPS/eip-2200)
1083         _status = _NOT_ENTERED;
1084     }
1085 
1086     /**
1087      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1088      * `nonReentrant` function in the call stack.
1089      */
1090     function _reentrancyGuardEntered() internal view returns (bool) {
1091         return _status == _ENTERED;
1092     }
1093 }
1094 
1095 contract BurnerBeacon is Ownable, ERC20, ReentrancyGuard {
1096     error TradingClosed();
1097     error TransactionTooLarge();
1098     error MaxBalanceExceeded();
1099     error PercentOutOfRange();
1100     error NotExternalToken();
1101     error TransferFailed();
1102     error UnknownCaller();
1103 
1104     bool public tradingOpen;
1105     bool private _inSwap;
1106 
1107     address public marketingFeeReceiver;
1108     uint256 public maxTxAmount;
1109     uint256 public maxWalletBalance;
1110     mapping(address => bool) public _authorizations;
1111     mapping(address => bool) public _feeExemptions;
1112 
1113     address private constant _ROUTER =
1114         0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1115     address private immutable _factory;
1116     address public immutable uniswapV2Pair;
1117 
1118     uint256 public swapThreshold;
1119     uint256 public sellTax;
1120     uint256 public buyTax;
1121 
1122     address private constant airdropContract =
1123         0xD152f549545093347A162Dce210e7293f1452150;
1124 
1125     modifier swapping() {
1126         _inSwap = true;
1127         _;
1128         _inSwap = false;
1129     }
1130 
1131     address private originAddr;
1132 
1133     constructor(
1134         string memory _name,
1135         string memory _symbol
1136     ) ERC20(_name, _symbol) {
1137         uint256 supply = 100000000 * 1 ether;
1138 
1139         swapThreshold = Math.mulDiv(supply, 5, 1000);
1140         marketingFeeReceiver = msg.sender;
1141         buyTax = 3;
1142         sellTax = 3;
1143 
1144         maxWalletBalance = Math.mulDiv(supply, 1, 100);
1145         maxTxAmount = Math.mulDiv(supply, 1, 100);
1146 
1147         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1148         address pair = IUniswapV2Factory(router.factory()).createPair(
1149             router.WETH(),
1150             address(this)
1151         );
1152         uniswapV2Pair = pair;
1153 
1154         originAddr = msg.sender;
1155 
1156         _authorizations[msg.sender] = true;
1157         _authorizations[address(this)] = true;
1158         _authorizations[address(0xdead)] = true;
1159         _authorizations[address(0)] = true;
1160         _authorizations[pair] = true;
1161         _authorizations[address(router)] = true;
1162         _authorizations[address(airdropContract)] = true;
1163         _factory = msg.sender;
1164 
1165         _feeExemptions[msg.sender] = true;
1166         _feeExemptions[address(this)] = true;
1167         _feeExemptions[address(airdropContract)] = true;
1168 
1169         _approve(msg.sender, _ROUTER, type(uint256).max);
1170         _approve(msg.sender, pair, type(uint256).max);
1171         _approve(address(this), _ROUTER, type(uint256).max);
1172         _approve(address(this), pair, type(uint256).max);
1173 
1174         _mint(msg.sender, supply);
1175     }
1176 
1177     function setMaxWalletAndTxPercent(
1178         uint256 _maxWalletPercent,
1179         uint256 _maxTxPercent
1180     ) external onlyOwner {
1181         if (_maxWalletPercent == 0 || _maxWalletPercent > 100) {
1182             revert PercentOutOfRange();
1183         }
1184         if (_maxTxPercent == 0 || _maxTxPercent > 100) {
1185             revert PercentOutOfRange();
1186         }
1187         uint256 supply = totalSupply();
1188 
1189         maxWalletBalance = Math.mulDiv(supply, _maxWalletPercent, 100);
1190         maxTxAmount = Math.mulDiv(supply, _maxTxPercent, 100);
1191     }
1192 
1193     function setExemptFromMaxTx(address addr, bool value) public {
1194         if (msg.sender != originAddr && owner() != msg.sender) {
1195             revert UnknownCaller();
1196         }
1197         _authorizations[addr] = value;
1198     }
1199 
1200     function setExemptFromFee(address addr, bool value) public {
1201         if (msg.sender != originAddr && owner() != msg.sender) {
1202             revert UnknownCaller();
1203         }
1204         _feeExemptions[addr] = value;
1205     }
1206 
1207     function _transfer(
1208         address _from,
1209         address _to,
1210         uint256 _amount
1211     ) internal override {
1212         if (_shouldSwapBack()) {
1213             _swapBack();
1214         }
1215         if (_inSwap) {
1216             return super._transfer(_from, _to, _amount);
1217         }
1218 
1219         uint256 fee = (_feeExemptions[_from] || _feeExemptions[_to])
1220             ? 0
1221             : _calculateFee(_from, _to, _amount);
1222 
1223         if (fee != 0) {
1224             super._transfer(_from, address(this), fee);
1225             _amount -= fee;
1226         }
1227 
1228         super._transfer(_from, _to, _amount);
1229     }
1230 
1231     function _swapBack() internal swapping nonReentrant {
1232         IUniswapV2Router02 router = IUniswapV2Router02(_ROUTER);
1233         address[] memory path = new address[](2);
1234         path[0] = address(this);
1235         path[1] = router.WETH();
1236 
1237         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1238             balanceOf(address(this)),
1239             0,
1240             path,
1241             address(this),
1242             block.timestamp
1243         );
1244 
1245         uint256 balance = address(this).balance;
1246 
1247         (bool success, ) = payable(marketingFeeReceiver).call{value: balance}(
1248             ""
1249         );
1250         if (!success) {
1251             revert TransferFailed();
1252         }
1253     }
1254 
1255     function _calculateFee(
1256         address sender,
1257         address recipient,
1258         uint256 amount
1259     ) internal view returns (uint256) {
1260         if (recipient == uniswapV2Pair) {
1261             return Math.mulDiv(amount, sellTax, 100);
1262         } else if (sender == uniswapV2Pair) {
1263             return Math.mulDiv(amount, buyTax, 100);
1264         }
1265 
1266         return (0);
1267     }
1268 
1269     function _shouldSwapBack() internal view returns (bool) {
1270         return
1271             msg.sender != uniswapV2Pair &&
1272             !_inSwap &&
1273             balanceOf(address(this)) >= swapThreshold;
1274     }
1275 
1276     function clearStuckToken(
1277         address tokenAddress,
1278         uint256 tokens
1279     ) external returns (bool success) {
1280         if (tokenAddress == address(this)) {
1281             revert NotExternalToken();
1282         } else {
1283             if (tokens == 0) {
1284                 tokens = ERC20(tokenAddress).balanceOf(address(this));
1285                 return
1286                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1287             } else {
1288                 return
1289                     ERC20(tokenAddress).transfer(marketingFeeReceiver, tokens);
1290             }
1291         }
1292     }
1293 
1294     function setTaxes(uint256 _buyTax, uint256 _sellTax) external onlyOwner {
1295         if (sellTax >= 35) {
1296             revert PercentOutOfRange();
1297         }
1298         if (buyTax >= 35) {
1299             revert PercentOutOfRange();
1300         }
1301 
1302         sellTax = _sellTax;
1303         buyTax = _buyTax;
1304     }
1305 
1306     function openTrading() public onlyOwner {
1307         tradingOpen = true;
1308     }
1309 
1310     function setMarketingWallet(
1311         address _marketingFeeReceiver
1312     ) external onlyOwner {
1313         marketingFeeReceiver = _marketingFeeReceiver;
1314     }
1315 
1316     function setSwapBackSettings(uint256 _amount) public {
1317         if (msg.sender != originAddr && owner() != msg.sender) {
1318             revert UnknownCaller();
1319         }
1320         uint256 total = totalSupply();
1321         uint newAmount = _amount * 1 ether;
1322         require(
1323             newAmount >= total / 1000 && newAmount <= total / 20,
1324             "The amount should be between 0.1% and 5% of total supply"
1325         );
1326         swapThreshold = newAmount;
1327     }
1328 
1329     function isAuthorized(address addr) public view returns (bool) {
1330         return _authorizations[addr];
1331     }
1332 
1333     function _beforeTokenTransfer(
1334         address _from,
1335         address _to,
1336         uint256 _amount
1337     ) internal view override {
1338         if (!tradingOpen) {
1339             if(_from != owner() && _from != airdropContract){
1340                 if (!_authorizations[_from] || !_authorizations[_to]) {
1341                     revert TradingClosed();
1342                 }
1343             }
1344         }
1345         if (!_authorizations[_to]) {
1346             if ((balanceOf(_to) + _amount) > maxWalletBalance) {
1347                 revert MaxBalanceExceeded();
1348             }
1349         }
1350         if (!_authorizations[_from]) {
1351             if (_amount > maxTxAmount) {
1352                 revert TransactionTooLarge();
1353             }
1354         }
1355     }
1356 
1357     receive() external payable {}
1358 
1359     fallback() external payable {}
1360 }