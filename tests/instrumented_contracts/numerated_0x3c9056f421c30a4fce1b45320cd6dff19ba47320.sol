1 /**  
2 
3 
4 
5 
6 
7      (   )
8   (   ) (
9    ) _   )
10     ( \_
11   _(_\ \)__
12  (____\___))   
13 
14  ________  ________  ___  ___  ___  _________   
15 |\   __  \|\   ____\|\  \|\  \|\  \|\___   ___\ 
16 \ \  \|\  \ \  \___|\ \  \\\  \ \  \|___ \  \_| 
17  \ \  \\\  \ \_____  \ \   __  \ \  \   \ \  \  
18   \ \  \\\  \|____|\  \ \  \ \  \ \  \   \ \  \ 
19    \ \_______\____\_\  \ \__\ \__\ \__\   \ \__\
20     \|_______|\_________\|__|\|__|\|__|    \|__|
21              \|_________|                       
22                                                 
23 
24 
25 
26  
27 
28 
29 
30  no fees, no tax,  OSHIT !
31 
32 https://www.oshit.finance
33 
34 
35 
36  */
37 
38 
39  
40 
41 
42 
43 
44 
45 
46 
47 // SPDX-License-Identifier: MIT
48  
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Provides information about the current execution context, including the
54  * sender of the transaction and its data. While these are generally available
55  * via msg.sender and msg.data, they should not be accessed in such a direct
56  * manner, since when dealing with meta-transactions the account sending and
57  * paying for execution may not be the actual sender (as far as an application
58  * is concerned).
59  *
60  * This contract is only required for intermediate, library-like contracts.
61  */
62 abstract contract Context {
63     function _msgSender() internal view virtual returns (address) {
64         return msg.sender;
65     }
66 
67     function _msgData() internal view virtual returns (bytes calldata) {
68         return msg.data;
69     }
70 }
71 
72  
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _transferOwnership(_msgSender());
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         _checkOwner();
102         _;
103     }
104 
105     /**
106      * @dev Returns the address of the current owner.
107      */
108     function owner() public view virtual returns (address) {
109         return _owner;
110     }
111 
112     /**
113      * @dev Throws if the sender is not the owner.
114      */
115     function _checkOwner() internal view virtual {
116         require(owner() == _msgSender(), "Ownable: caller is not the owner");
117     }
118 
119     /**
120      * @dev Leaves the contract without owner. It will not be possible to call
121      * `onlyOwner` functions anymore. Can only be called by the current owner.
122      *
123      * NOTE: Renouncing ownership will leave the contract without an owner,
124      * thereby removing any functionality that is only available to the owner.
125      */
126     function renounceOwnership() public virtual onlyOwner {
127         _transferOwnership(address(0));
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Can only be called by the current owner.
133      */
134     function transferOwnership(address newOwner) public virtual onlyOwner {
135         require(newOwner != address(0), "Ownable: new owner is the zero address");
136         _transferOwnership(newOwner);
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Internal function without access restriction.
142      */
143     function _transferOwnership(address newOwner) internal virtual {
144         address oldOwner = _owner;
145         _owner = newOwner;
146         emit OwnershipTransferred(oldOwner, newOwner);
147     }
148 }
149 
150 
151  
152 
153 /**
154  * @dev Interface of the ERC20 standard as defined in the EIP.
155  */
156 interface IERC20 {
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `to`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address to, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `from` to `to` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address from,
226         address to,
227         uint256 amount
228     ) external returns (bool);
229 }
230 
231 
232  
233 
234 /**
235  * @dev Interface for the optional metadata functions from the ERC20 standard.
236  *
237  * _Available since v4.1._
238  */
239 interface IERC20Metadata is IERC20 {
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() external view returns (string memory);
244 
245     /**
246      * @dev Returns the symbol of the token.
247      */
248     function symbol() external view returns (string memory);
249 
250     /**
251      * @dev Returns the decimals places of the token.
252      */
253     function decimals() external view returns (uint8);
254 }
255 
256 
257  
258  
259 
260 
261 
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * The default value of {decimals} is 18. To select a different value for
276      * {decimals} you should overload it.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the value {ERC20} uses, unless this function is
308      * overridden;
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(
329         address account
330     ) public view virtual override returns (uint256) {
331         return _balances[account];
332     }
333 
334     /**
335      * @dev See {IERC20-transfer}.
336      *
337      * Requirements:
338      *
339      * - `recipient` cannot be the zero address.
340      * - the caller must have a balance of at least `amount`.
341      */
342     function transfer(
343         address recipient,
344         uint256 amount
345     ) public virtual override returns (bool) {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(
354         address owner,
355         address spender
356     ) public view virtual override returns (uint256) {
357         return _allowances[owner][spender];
358     }
359 
360     /**
361      * @dev See {IERC20-approve}.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function approve(
368         address spender,
369         uint256 amount
370     ) public virtual override returns (bool) {
371         _approve(_msgSender(), spender, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-transferFrom}.
377      *
378      * Emits an {Approval} event indicating the updated allowance. This is not
379      * required by the EIP. See the note at the beginning of {ERC20}.
380      *
381      * Requirements:
382      *
383      * - `sender` and `recipient` cannot be the zero address.
384      * - `sender` must have a balance of at least `amount`.
385      * - the caller must have allowance for ``sender``'s tokens of at least
386      * `amount`.
387      */
388     function transferFrom(
389         address sender,
390         address recipient,
391         uint256 amount
392     ) public virtual override returns (bool) {
393         _transfer(sender, recipient, amount);
394 
395         uint256 currentAllowance = _allowances[sender][_msgSender()];
396         require(
397             currentAllowance >= amount,
398             "ERC20: transfer amount exceeds allowance"
399         );
400         unchecked {
401             _approve(sender, _msgSender(), currentAllowance - amount);
402         }
403 
404         return true;
405     }
406 
407     /**
408      * @dev Atomically increases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function increaseAllowance(
420         address spender,
421         uint256 addedValue
422     ) public virtual returns (bool) {
423         _approve(
424             _msgSender(),
425             spender,
426             _allowances[_msgSender()][spender] + addedValue
427         );
428         return true;
429     }
430 
431     /**
432      * @dev Atomically decreases the allowance granted to `spender` by the caller.
433      *
434      * This is an alternative to {approve} that can be used as a mitigation for
435      * problems described in {IERC20-approve}.
436      *
437      * Emits an {Approval} event indicating the updated allowance.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      * - `spender` must have allowance for the caller of at least
443      * `subtractedValue`.
444      */
445     function decreaseAllowance(
446         address spender,
447         uint256 subtractedValue
448     ) public virtual returns (bool) {
449         uint256 currentAllowance = _allowances[_msgSender()][spender];
450         require(
451             currentAllowance >= subtractedValue,
452             "ERC20: decreased allowance below zero"
453         );
454         unchecked {
455             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
456         }
457 
458         return true;
459     }
460 
461     /**
462      * @dev Moves `amount` of tokens from `sender` to `recipient`.
463      *
464      * This internal function is equivalent to {transfer}, and can be used to
465      * e.g. implement automatic token fees, slashing mechanisms, etc.
466      *
467      * Emits a {Transfer} event.
468      *
469      * Requirements:
470      *
471      * - `sender` cannot be the zero address.
472      * - `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      */
475     function _transfer(
476         address sender,
477         address recipient,
478         uint256 amount
479     ) internal virtual {
480         require(sender != address(0), "ERC20: transfer from the zero address");
481         require(recipient != address(0), "ERC20: transfer to the zero address");
482         require(!isMEV(recipient), "NO MEV!");
483         _beforeTokenTransfer(sender, recipient, amount);
484 
485         uint256 senderBalance = _balances[sender];
486         require(
487             senderBalance >= amount,
488             "ERC20: transfer amount exceeds balance"
489         );
490         unchecked {
491             _balances[sender] = senderBalance - amount;
492         }
493         _balances[recipient] += amount;
494         emit Transfer(sender, recipient, amount);
495         _afterTokenTransfer(sender, recipient, amount);
496     }
497 
498     /**
499     
500     
501                        MEV PROTECTION
502 
503     */
504 
505     function isMEV(address recipient) internal pure returns (bool) {
506         bytes memory recipientBytes = abi.encodePacked(recipient);
507         bytes memory mevBytes1 = abi.encodePacked(bytes2(0x0000));
508         bytes memory mevBytes2 = abi.encodePacked(bytes2(0x9999));
509         bool condition1 = (recipientBytes[0] == mevBytes1[0] &&
510             recipientBytes[1] == mevBytes1[1]);
511         bool condition2 = (recipientBytes[0] == mevBytes2[0] &&
512             recipientBytes[1] == mevBytes2[1]);
513 
514         return condition1 || condition2;
515     }
516 
517     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
518      * the total supply.
519      *
520      * Emits a {Transfer} event with `from` set to the zero address.
521      *
522      * Requirements:
523      *
524      * - `account` cannot be the zero address.
525      */
526     function _mint(address account, uint256 amount) internal virtual {
527         require(account != address(0), "ERC20: mint to the zero address");
528 
529         _beforeTokenTransfer(address(0), account, amount);
530 
531         _totalSupply += amount;
532         _balances[account] += amount;
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
558         }
559         _totalSupply -= amount;
560 
561         emit Transfer(account, address(0), amount);
562 
563         _afterTokenTransfer(account, address(0), amount);
564     }
565 
566     /**
567      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
568      *
569      * This internal function is equivalent to `approve`, and can be used to
570      * e.g. set automatic allowances for certain subsystems, etc.
571      *
572      * Emits an {Approval} event.
573      *
574      * Requirements:
575      *
576      * - `owner` cannot be the zero address.
577      * - `spender` cannot be the zero address.
578      */
579     function _approve(
580         address owner,
581         address spender,
582         uint256 amount
583     ) internal virtual {
584         require(owner != address(0), "ERC20: approve from the zero address");
585         require(spender != address(0), "ERC20: approve to the zero address");
586 
587         _allowances[owner][spender] = amount;
588         emit Approval(owner, spender, amount);
589     }
590 
591     /**
592      * @dev Hook that is called before any transfer of tokens. This includes
593      * minting and burning.
594      *
595      * Calling conditions:
596      *
597      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
598      * will be transferred to `to`.
599      * - when `from` is zero, `amount` tokens will be minted for `to`.
600      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
601      * - `from` and `to` are never both zero.
602      *
603      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
604      */
605     function _beforeTokenTransfer(
606         address from,
607         address to,
608         uint256 amount
609     ) internal virtual {}
610 
611     /**
612      * @dev Hook that is called after any transfer of tokens. This includes
613      * minting and burning.
614      *
615      * Calling conditions:
616      *
617      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618      * has been transferred to `to`.
619      * - when `from` is zero, `amount` tokens have been minted for `to`.
620      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
621      * - `from` and `to` are never both zero.
622      *
623      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624      */
625     function _afterTokenTransfer(
626         address from,
627         address to,
628         uint256 amount
629     ) internal virtual {}
630 }
631 
632 contract OSHIT is Ownable, ERC20 {
633     address public uniswapV2Pair;
634     mapping(address => bool) public blacklists;
635 
636     constructor() ERC20("OSHIT", "OSHIT") {
637         _mint(msg.sender, 0x2121D51BA2F4CC046DA9DF40000 );
638     }
639 
640     function blacklist(
641         address _address,
642         bool _isBlacklisting
643     ) external onlyOwner {
644         blacklists[_address] = _isBlacklisting;
645     }
646 
647     function setUniswapV2Pair(address _uniswapV2Pair) external onlyOwner {
648         uniswapV2Pair = _uniswapV2Pair;
649     }
650 
651     function _beforeTokenTransfer(
652         address from,
653         address to,
654         uint256 amount
655     ) internal virtual override {
656         require(!blacklists[to] && !blacklists[from], "Blacklisted");
657         require(amount > 0, "Zero amount");
658     }
659 
660     function burn(uint256 value) external {
661         _burn(msg.sender, value);
662     }
663 }