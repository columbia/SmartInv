1 /*
2 
3 
4 
5      ██╗ █████╗ ██████╗ ██████╗  █████╗ 
6      ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗
7      ██║███████║██████╔╝██████╔╝███████║
8 ██   ██║██╔══██║██╔══██╗██╔══██╗██╔══██║
9 ╚█████╔╝██║  ██║██████╔╝██████╔╝██║  ██║
10  ╚════╝ ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝
11                                         
12 
13                                                 
14 TG: https://t.me/jabbaverification
15 TW: https://twitter.com/JabbaETH
16 Web: https://Jabba-queen.vip
17 
18 */
19 
20 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
21 
22 // SPDX-License-Identifier: MIT
23 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         return msg.data;
44     }
45 }
46 
47 
48 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.3
49 
50 
51 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _transferOwnership(_msgSender());
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         _checkOwner();
84         _;
85     }
86 
87     /**
88      * @dev Returns the address of the current owner.
89      */
90     function owner() public view virtual returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if the sender is not the owner.
96      */
97     function _checkOwner() internal view virtual {
98         require(owner() == _msgSender(), "Ownable: caller is not the owner");
99     }
100 
101     /**
102      * @dev Leaves the contract without owner. It will not be possible to call
103      * `onlyOwner` functions anymore. Can only be called by the current owner.
104      *
105      * NOTE: Renouncing ownership will leave the contract without an owner,
106      * thereby removing any functionality that is only available to the owner.
107      */
108     function renounceOwnership() public virtual onlyOwner {
109         _transferOwnership(address(0));
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Can only be called by the current owner.
115      */
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(newOwner != address(0), "Ownable: new owner is the zero address");
118         _transferOwnership(newOwner);
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Internal function without access restriction.
124      */
125     function _transferOwnership(address newOwner) internal virtual {
126         address oldOwner = _owner;
127         _owner = newOwner;
128         emit OwnershipTransferred(oldOwner, newOwner);
129     }
130 }
131 
132 
133 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.3
134 
135 
136 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Interface of the ERC20 standard as defined in the EIP.
142  */
143 interface IERC20 {
144     /**
145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
146      * another (`to`).
147      *
148      * Note that `value` may be zero.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     /**
153      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
154      * a call to {approve}. `value` is the new allowance.
155      */
156     event Approval(address indexed owner, address indexed spender, uint256 value);
157 
158     /**
159      * @dev Returns the amount of tokens in existence.
160      */
161     function totalSupply() external view returns (uint256);
162 
163     /**
164      * @dev Returns the amount of tokens owned by `account`.
165      */
166     function balanceOf(address account) external view returns (uint256);
167 
168     /**
169      * @dev Moves `amount` tokens from the caller's account to `to`.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transfer(address to, uint256 amount) external returns (bool);
176 
177     /**
178      * @dev Returns the remaining number of tokens that `spender` will be
179      * allowed to spend on behalf of `owner` through {transferFrom}. This is
180      * zero by default.
181      *
182      * This value changes when {approve} or {transferFrom} are called.
183      */
184     function allowance(address owner, address spender) external view returns (uint256);
185 
186     /**
187      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * IMPORTANT: Beware that changing an allowance with this method brings the risk
192      * that someone may use both the old and the new allowance by unfortunate
193      * transaction ordering. One possible solution to mitigate this race
194      * condition is to first reduce the spender's allowance to 0 and set the
195      * desired value afterwards:
196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197      *
198      * Emits an {Approval} event.
199      */
200     function approve(address spender, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Moves `amount` tokens from `from` to `to` using the
204      * allowance mechanism. `amount` is then deducted from the caller's
205      * allowance.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 amount
215     ) external returns (bool);
216 }
217 
218 
219 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.3
220 
221 
222 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Interface for the optional metadata functions from the ERC20 standard.
228  *
229  * _Available since v4.1._
230  */
231 interface IERC20Metadata is IERC20 {
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() external view returns (string memory);
236 
237     /**
238      * @dev Returns the symbol of the token.
239      */
240     function symbol() external view returns (string memory);
241 
242     /**
243      * @dev Returns the decimals places of the token.
244      */
245     function decimals() external view returns (uint8);
246 }
247 
248 
249 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.3
250 
251 
252 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 
257 
258 /**
259  * @dev Implementation of the {IERC20} interface.
260  *
261  * This implementation is agnostic to the way tokens are created. This means
262  * that a supply mechanism has to be added in a derived contract using {_mint}.
263  * For a generic mechanism see {ERC20PresetMinterPauser}.
264  *
265  * TIP: For a detailed writeup see our guide
266  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
267  * to implement supply mechanisms].
268  *
269  * We have followed general OpenZeppelin Contracts guidelines: functions revert
270  * instead returning `false` on failure. This behavior is nonetheless
271  * conventional and does not conflict with the expectations of ERC20
272  * applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20, IERC20Metadata {
284     mapping(address => uint256) private _balances;
285 
286     mapping(address => mapping(address => uint256)) private _allowances;
287 
288     uint256 private _totalSupply;
289 
290     string private _name;
291     string private _symbol;
292 
293     /**
294      * @dev Sets the values for {name} and {symbol}.
295      *
296      * The default value of {decimals} is 18. To select a different value for
297      * {decimals} you should overload it.
298      *
299      * All two of these values are immutable: they can only be set once during
300      * construction.
301      */
302     constructor(string memory name_, string memory symbol_) {
303         _name = name_;
304         _symbol = symbol_;
305     }
306 
307     /**
308      * @dev Returns the name of the token.
309      */
310     function name() public view virtual override returns (string memory) {
311         return _name;
312     }
313 
314     /**
315      * @dev Returns the symbol of the token, usually a shorter version of the
316      * name.
317      */
318     function symbol() public view virtual override returns (string memory) {
319         return _symbol;
320     }
321 
322     /**
323      * @dev Returns the number of decimals used to get its user representation.
324      * For example, if `decimals` equals `2`, a balance of `505` tokens should
325      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
326      *
327      * Tokens usually opt for a value of 18, imitating the relationship between
328      * Ether and Wei. This is the value {ERC20} uses, unless this function is
329      * overridden;
330      *
331      * NOTE: This information is only used for _display_ purposes: it in
332      * no way affects any of the arithmetic of the contract, including
333      * {IERC20-balanceOf} and {IERC20-transfer}.
334      */
335     function decimals() public view virtual override returns (uint8) {
336         return 18;
337     }
338 
339     /**
340      * @dev See {IERC20-totalSupply}.
341      */
342     function totalSupply() public view virtual override returns (uint256) {
343         return _totalSupply;
344     }
345 
346     /**
347      * @dev See {IERC20-balanceOf}.
348      */
349     function balanceOf(address account) public view virtual override returns (uint256) {
350         return _balances[account];
351     }
352 
353     /**
354      * @dev See {IERC20-transfer}.
355      *
356      * Requirements:
357      *
358      * - `to` cannot be the zero address.
359      * - the caller must have a balance of at least `amount`.
360      */
361     function transfer(address to, uint256 amount) public virtual override returns (bool) {
362         address owner = _msgSender();
363         _transfer(owner, to, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-allowance}.
369      */
370     function allowance(address owner, address spender) public view virtual override returns (uint256) {
371         return _allowances[owner][spender];
372     }
373 
374     /**
375      * @dev See {IERC20-approve}.
376      *
377      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
378      * `transferFrom`. This is semantically equivalent to an infinite approval.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public virtual override returns (bool) {
385         address owner = _msgSender();
386         _approve(owner, spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20}.
395      *
396      * NOTE: Does not update the allowance if the current allowance
397      * is the maximum `uint256`.
398      *
399      * Requirements:
400      *
401      * - `from` and `to` cannot be the zero address.
402      * - `from` must have a balance of at least `amount`.
403      * - the caller must have allowance for ``from``'s tokens of at least
404      * `amount`.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 amount
410     ) public virtual override returns (bool) {
411         address spender = _msgSender();
412         _spendAllowance(from, spender, amount);
413         _transfer(from, to, amount);
414         return true;
415     }
416 
417     /**
418      * @dev Atomically increases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
430         address owner = _msgSender();
431         _approve(owner, spender, allowance(owner, spender) + addedValue);
432         return true;
433     }
434 
435     /**
436      * @dev Atomically decreases the allowance granted to `spender` by the caller.
437      *
438      * This is an alternative to {approve} that can be used as a mitigation for
439      * problems described in {IERC20-approve}.
440      *
441      * Emits an {Approval} event indicating the updated allowance.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      * - `spender` must have allowance for the caller of at least
447      * `subtractedValue`.
448      */
449     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
450         address owner = _msgSender();
451         uint256 currentAllowance = allowance(owner, spender);
452         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
453         unchecked {
454             _approve(owner, spender, currentAllowance - subtractedValue);
455         }
456 
457         return true;
458     }
459 
460     /**
461      * @dev Moves `amount` of tokens from `from` to `to`.
462      *
463      * This internal function is equivalent to {transfer}, and can be used to
464      * e.g. implement automatic token fees, slashing mechanisms, etc.
465      *
466      * Emits a {Transfer} event.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `from` must have a balance of at least `amount`.
473      */
474     function _transfer(
475         address from,
476         address to,
477         uint256 amount
478     ) internal virtual {
479         require(from != address(0), "ERC20: transfer from the zero address");
480         require(to != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(from, to, amount);
483 
484         uint256 fromBalance = _balances[from];
485         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
486         unchecked {
487             _balances[from] = fromBalance - amount;
488             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
489             // decrementing then incrementing.
490             _balances[to] += amount;
491         }
492 
493         emit Transfer(from, to, amount);
494 
495         _afterTokenTransfer(from, to, amount);
496     }
497 
498     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
499      * the total supply.
500      *
501      * Emits a {Transfer} event with `from` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      */
507     function _mint(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: mint to the zero address");
509 
510         _beforeTokenTransfer(address(0), account, amount);
511 
512         _totalSupply += amount;
513         unchecked {
514             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
515             _balances[account] += amount;
516         }
517         emit Transfer(address(0), account, amount);
518 
519         _afterTokenTransfer(address(0), account, amount);
520     }
521 
522     /**
523      * @dev Destroys `amount` tokens from `account`, reducing the
524      * total supply.
525      *
526      * Emits a {Transfer} event with `to` set to the zero address.
527      *
528      * Requirements:
529      *
530      * - `account` cannot be the zero address.
531      * - `account` must have at least `amount` tokens.
532      */
533     function _burn(address account, uint256 amount) internal virtual {
534         require(account != address(0), "ERC20: burn from the zero address");
535 
536         _beforeTokenTransfer(account, address(0), amount);
537 
538         uint256 accountBalance = _balances[account];
539         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
540         unchecked {
541             _balances[account] = accountBalance - amount;
542             // Overflow not possible: amount <= accountBalance <= totalSupply.
543             _totalSupply -= amount;
544         }
545 
546         emit Transfer(account, address(0), amount);
547 
548         _afterTokenTransfer(account, address(0), amount);
549     }
550 
551     /**
552      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
553      *
554      * This internal function is equivalent to `approve`, and can be used to
555      * e.g. set automatic allowances for certain subsystems, etc.
556      *
557      * Emits an {Approval} event.
558      *
559      * Requirements:
560      *
561      * - `owner` cannot be the zero address.
562      * - `spender` cannot be the zero address.
563      */
564     function _approve(
565         address owner,
566         address spender,
567         uint256 amount
568     ) internal virtual {
569         require(owner != address(0), "ERC20: approve from the zero address");
570         require(spender != address(0), "ERC20: approve to the zero address");
571 
572         _allowances[owner][spender] = amount;
573         emit Approval(owner, spender, amount);
574     }
575 
576     /**
577      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
578      *
579      * Does not update the allowance amount in case of infinite allowance.
580      * Revert if not enough allowance is available.
581      *
582      * Might emit an {Approval} event.
583      */
584     function _spendAllowance(
585         address owner,
586         address spender,
587         uint256 amount
588     ) internal virtual {
589         uint256 currentAllowance = allowance(owner, spender);
590         if (currentAllowance != type(uint256).max) {
591             require(currentAllowance >= amount, "ERC20: insufficient allowance");
592             unchecked {
593                 _approve(owner, spender, currentAllowance - amount);
594             }
595         }
596     }
597 
598     /**
599      * @dev Hook that is called before any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * will be transferred to `to`.
606      * - when `from` is zero, `amount` tokens will be minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _beforeTokenTransfer(
613         address from,
614         address to,
615         uint256 amount
616     ) internal virtual {}
617 
618     /**
619      * @dev Hook that is called after any transfer of tokens. This includes
620      * minting and burning.
621      *
622      * Calling conditions:
623      *
624      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
625      * has been transferred to `to`.
626      * - when `from` is zero, `amount` tokens have been minted for `to`.
627      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
628      * - `from` and `to` are never both zero.
629      *
630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
631      */
632     function _afterTokenTransfer(
633         address from,
634         address to,
635         uint256 amount
636     ) internal virtual {}
637 }
638 
639 
640 // File hardhat/console.sol@v2.14.0
641 
642 
643 pragma solidity >= 0.4.22 <0.9.0;
644 
645 library console {
646 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
647 
648 	function _sendLogPayload(bytes memory payload) private view {
649 		uint256 payloadLength = payload.length;
650 		address consoleAddress = CONSOLE_ADDRESS;
651 		assembly {
652 			let payloadStart := add(payload, 32)
653 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
654 		}
655 	}
656 
657 	function log() internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log()"));
659 	}
660 
661 	function logInt(int256 p0) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(int256)", p0));
663 	}
664 
665 	function logUint(uint256 p0) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
667 	}
668 
669 	function logString(string memory p0) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
671 	}
672 
673 	function logBool(bool p0) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
675 	}
676 
677 	function logAddress(address p0) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
679 	}
680 
681 	function logBytes(bytes memory p0) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
683 	}
684 
685 	function logBytes1(bytes1 p0) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
687 	}
688 
689 	function logBytes2(bytes2 p0) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
691 	}
692 
693 	function logBytes3(bytes3 p0) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
695 	}
696 
697 	function logBytes4(bytes4 p0) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
699 	}
700 
701 	function logBytes5(bytes5 p0) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
703 	}
704 
705 	function logBytes6(bytes6 p0) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
707 	}
708 
709 	function logBytes7(bytes7 p0) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
711 	}
712 
713 	function logBytes8(bytes8 p0) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
715 	}
716 
717 	function logBytes9(bytes9 p0) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
719 	}
720 
721 	function logBytes10(bytes10 p0) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
723 	}
724 
725 	function logBytes11(bytes11 p0) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
727 	}
728 
729 	function logBytes12(bytes12 p0) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
731 	}
732 
733 	function logBytes13(bytes13 p0) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
735 	}
736 
737 	function logBytes14(bytes14 p0) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
739 	}
740 
741 	function logBytes15(bytes15 p0) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
743 	}
744 
745 	function logBytes16(bytes16 p0) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
747 	}
748 
749 	function logBytes17(bytes17 p0) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
751 	}
752 
753 	function logBytes18(bytes18 p0) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
755 	}
756 
757 	function logBytes19(bytes19 p0) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
759 	}
760 
761 	function logBytes20(bytes20 p0) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
763 	}
764 
765 	function logBytes21(bytes21 p0) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
767 	}
768 
769 	function logBytes22(bytes22 p0) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
771 	}
772 
773 	function logBytes23(bytes23 p0) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
775 	}
776 
777 	function logBytes24(bytes24 p0) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
779 	}
780 
781 	function logBytes25(bytes25 p0) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
783 	}
784 
785 	function logBytes26(bytes26 p0) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
787 	}
788 
789 	function logBytes27(bytes27 p0) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
791 	}
792 
793 	function logBytes28(bytes28 p0) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
795 	}
796 
797 	function logBytes29(bytes29 p0) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
799 	}
800 
801 	function logBytes30(bytes30 p0) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
803 	}
804 
805 	function logBytes31(bytes31 p0) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
807 	}
808 
809 	function logBytes32(bytes32 p0) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
811 	}
812 
813 	function log(uint256 p0) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(uint256)", p0));
815 	}
816 
817 	function log(string memory p0) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
819 	}
820 
821 	function log(bool p0) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
823 	}
824 
825 	function log(address p0) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
827 	}
828 
829 	function log(uint256 p0, uint256 p1) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256)", p0, p1));
831 	}
832 
833 	function log(uint256 p0, string memory p1) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string)", p0, p1));
835 	}
836 
837 	function log(uint256 p0, bool p1) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool)", p0, p1));
839 	}
840 
841 	function log(uint256 p0, address p1) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address)", p0, p1));
843 	}
844 
845 	function log(string memory p0, uint256 p1) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256)", p0, p1));
847 	}
848 
849 	function log(string memory p0, string memory p1) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
851 	}
852 
853 	function log(string memory p0, bool p1) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
855 	}
856 
857 	function log(string memory p0, address p1) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
859 	}
860 
861 	function log(bool p0, uint256 p1) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256)", p0, p1));
863 	}
864 
865 	function log(bool p0, string memory p1) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
867 	}
868 
869 	function log(bool p0, bool p1) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
871 	}
872 
873 	function log(bool p0, address p1) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
875 	}
876 
877 	function log(address p0, uint256 p1) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256)", p0, p1));
879 	}
880 
881 	function log(address p0, string memory p1) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
883 	}
884 
885 	function log(address p0, bool p1) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
887 	}
888 
889 	function log(address p0, address p1) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
891 	}
892 
893 	function log(uint256 p0, uint256 p1, uint256 p2) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256)", p0, p1, p2));
895 	}
896 
897 	function log(uint256 p0, uint256 p1, string memory p2) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string)", p0, p1, p2));
899 	}
900 
901 	function log(uint256 p0, uint256 p1, bool p2) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool)", p0, p1, p2));
903 	}
904 
905 	function log(uint256 p0, uint256 p1, address p2) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address)", p0, p1, p2));
907 	}
908 
909 	function log(uint256 p0, string memory p1, uint256 p2) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256)", p0, p1, p2));
911 	}
912 
913 	function log(uint256 p0, string memory p1, string memory p2) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string)", p0, p1, p2));
915 	}
916 
917 	function log(uint256 p0, string memory p1, bool p2) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool)", p0, p1, p2));
919 	}
920 
921 	function log(uint256 p0, string memory p1, address p2) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address)", p0, p1, p2));
923 	}
924 
925 	function log(uint256 p0, bool p1, uint256 p2) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256)", p0, p1, p2));
927 	}
928 
929 	function log(uint256 p0, bool p1, string memory p2) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string)", p0, p1, p2));
931 	}
932 
933 	function log(uint256 p0, bool p1, bool p2) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool)", p0, p1, p2));
935 	}
936 
937 	function log(uint256 p0, bool p1, address p2) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address)", p0, p1, p2));
939 	}
940 
941 	function log(uint256 p0, address p1, uint256 p2) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256)", p0, p1, p2));
943 	}
944 
945 	function log(uint256 p0, address p1, string memory p2) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string)", p0, p1, p2));
947 	}
948 
949 	function log(uint256 p0, address p1, bool p2) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool)", p0, p1, p2));
951 	}
952 
953 	function log(uint256 p0, address p1, address p2) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address)", p0, p1, p2));
955 	}
956 
957 	function log(string memory p0, uint256 p1, uint256 p2) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256)", p0, p1, p2));
959 	}
960 
961 	function log(string memory p0, uint256 p1, string memory p2) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string)", p0, p1, p2));
963 	}
964 
965 	function log(string memory p0, uint256 p1, bool p2) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool)", p0, p1, p2));
967 	}
968 
969 	function log(string memory p0, uint256 p1, address p2) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address)", p0, p1, p2));
971 	}
972 
973 	function log(string memory p0, string memory p1, uint256 p2) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256)", p0, p1, p2));
975 	}
976 
977 	function log(string memory p0, string memory p1, string memory p2) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
979 	}
980 
981 	function log(string memory p0, string memory p1, bool p2) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
983 	}
984 
985 	function log(string memory p0, string memory p1, address p2) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
987 	}
988 
989 	function log(string memory p0, bool p1, uint256 p2) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256)", p0, p1, p2));
991 	}
992 
993 	function log(string memory p0, bool p1, string memory p2) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
995 	}
996 
997 	function log(string memory p0, bool p1, bool p2) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
999 	}
1000 
1001 	function log(string memory p0, bool p1, address p2) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1003 	}
1004 
1005 	function log(string memory p0, address p1, uint256 p2) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2));
1007 	}
1008 
1009 	function log(string memory p0, address p1, string memory p2) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1011 	}
1012 
1013 	function log(string memory p0, address p1, bool p2) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1015 	}
1016 
1017 	function log(string memory p0, address p1, address p2) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1019 	}
1020 
1021 	function log(bool p0, uint256 p1, uint256 p2) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256)", p0, p1, p2));
1023 	}
1024 
1025 	function log(bool p0, uint256 p1, string memory p2) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string)", p0, p1, p2));
1027 	}
1028 
1029 	function log(bool p0, uint256 p1, bool p2) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool)", p0, p1, p2));
1031 	}
1032 
1033 	function log(bool p0, uint256 p1, address p2) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address)", p0, p1, p2));
1035 	}
1036 
1037 	function log(bool p0, string memory p1, uint256 p2) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256)", p0, p1, p2));
1039 	}
1040 
1041 	function log(bool p0, string memory p1, string memory p2) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1043 	}
1044 
1045 	function log(bool p0, string memory p1, bool p2) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1047 	}
1048 
1049 	function log(bool p0, string memory p1, address p2) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1051 	}
1052 
1053 	function log(bool p0, bool p1, uint256 p2) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256)", p0, p1, p2));
1055 	}
1056 
1057 	function log(bool p0, bool p1, string memory p2) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1059 	}
1060 
1061 	function log(bool p0, bool p1, bool p2) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1063 	}
1064 
1065 	function log(bool p0, bool p1, address p2) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1067 	}
1068 
1069 	function log(bool p0, address p1, uint256 p2) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256)", p0, p1, p2));
1071 	}
1072 
1073 	function log(bool p0, address p1, string memory p2) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1075 	}
1076 
1077 	function log(bool p0, address p1, bool p2) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1079 	}
1080 
1081 	function log(bool p0, address p1, address p2) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1083 	}
1084 
1085 	function log(address p0, uint256 p1, uint256 p2) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256)", p0, p1, p2));
1087 	}
1088 
1089 	function log(address p0, uint256 p1, string memory p2) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string)", p0, p1, p2));
1091 	}
1092 
1093 	function log(address p0, uint256 p1, bool p2) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool)", p0, p1, p2));
1095 	}
1096 
1097 	function log(address p0, uint256 p1, address p2) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address)", p0, p1, p2));
1099 	}
1100 
1101 	function log(address p0, string memory p1, uint256 p2) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256)", p0, p1, p2));
1103 	}
1104 
1105 	function log(address p0, string memory p1, string memory p2) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1107 	}
1108 
1109 	function log(address p0, string memory p1, bool p2) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1111 	}
1112 
1113 	function log(address p0, string memory p1, address p2) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1115 	}
1116 
1117 	function log(address p0, bool p1, uint256 p2) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256)", p0, p1, p2));
1119 	}
1120 
1121 	function log(address p0, bool p1, string memory p2) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1123 	}
1124 
1125 	function log(address p0, bool p1, bool p2) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1127 	}
1128 
1129 	function log(address p0, bool p1, address p2) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1131 	}
1132 
1133 	function log(address p0, address p1, uint256 p2) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256)", p0, p1, p2));
1135 	}
1136 
1137 	function log(address p0, address p1, string memory p2) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1139 	}
1140 
1141 	function log(address p0, address p1, bool p2) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1143 	}
1144 
1145 	function log(address p0, address p1, address p2) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1147 	}
1148 
1149 	function log(uint256 p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,uint256)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(uint256 p0, uint256 p1, uint256 p2, string memory p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,string)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(uint256 p0, uint256 p1, uint256 p2, bool p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,bool)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(uint256 p0, uint256 p1, uint256 p2, address p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,uint256,address)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(uint256 p0, uint256 p1, string memory p2, uint256 p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,uint256)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(uint256 p0, uint256 p1, string memory p2, string memory p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,string)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(uint256 p0, uint256 p1, string memory p2, bool p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,bool)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(uint256 p0, uint256 p1, string memory p2, address p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,string,address)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(uint256 p0, uint256 p1, bool p2, uint256 p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,uint256)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(uint256 p0, uint256 p1, bool p2, string memory p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,string)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(uint256 p0, uint256 p1, bool p2, bool p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,bool)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(uint256 p0, uint256 p1, bool p2, address p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,bool,address)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(uint256 p0, uint256 p1, address p2, uint256 p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,uint256)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(uint256 p0, uint256 p1, address p2, string memory p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,string)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(uint256 p0, uint256 p1, address p2, bool p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,bool)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(uint256 p0, uint256 p1, address p2, address p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(uint256,uint256,address,address)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(uint256 p0, string memory p1, uint256 p2, uint256 p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,uint256)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(uint256 p0, string memory p1, uint256 p2, string memory p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,string)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(uint256 p0, string memory p1, uint256 p2, bool p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,bool)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(uint256 p0, string memory p1, uint256 p2, address p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,uint256,address)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(uint256 p0, string memory p1, string memory p2, uint256 p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,uint256)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(uint256 p0, string memory p1, string memory p2, string memory p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,string)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(uint256 p0, string memory p1, string memory p2, bool p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,bool)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(uint256 p0, string memory p1, string memory p2, address p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,string,address)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(uint256 p0, string memory p1, bool p2, uint256 p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,uint256)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(uint256 p0, string memory p1, bool p2, string memory p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,string)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(uint256 p0, string memory p1, bool p2, bool p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,bool)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(uint256 p0, string memory p1, bool p2, address p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,bool,address)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(uint256 p0, string memory p1, address p2, uint256 p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,uint256)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(uint256 p0, string memory p1, address p2, string memory p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,string)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(uint256 p0, string memory p1, address p2, bool p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,bool)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(uint256 p0, string memory p1, address p2, address p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(uint256,string,address,address)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(uint256 p0, bool p1, uint256 p2, uint256 p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,uint256)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(uint256 p0, bool p1, uint256 p2, string memory p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,string)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(uint256 p0, bool p1, uint256 p2, bool p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,bool)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(uint256 p0, bool p1, uint256 p2, address p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,uint256,address)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(uint256 p0, bool p1, string memory p2, uint256 p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,uint256)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(uint256 p0, bool p1, string memory p2, string memory p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,string)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(uint256 p0, bool p1, string memory p2, bool p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,bool)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(uint256 p0, bool p1, string memory p2, address p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,string,address)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(uint256 p0, bool p1, bool p2, uint256 p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,uint256)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(uint256 p0, bool p1, bool p2, string memory p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,string)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(uint256 p0, bool p1, bool p2, bool p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,bool)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(uint256 p0, bool p1, bool p2, address p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,bool,address)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(uint256 p0, bool p1, address p2, uint256 p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,uint256)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(uint256 p0, bool p1, address p2, string memory p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,string)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(uint256 p0, bool p1, address p2, bool p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,bool)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(uint256 p0, bool p1, address p2, address p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(uint256,bool,address,address)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(uint256 p0, address p1, uint256 p2, uint256 p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,uint256)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(uint256 p0, address p1, uint256 p2, string memory p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,string)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(uint256 p0, address p1, uint256 p2, bool p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,bool)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(uint256 p0, address p1, uint256 p2, address p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,uint256,address)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(uint256 p0, address p1, string memory p2, uint256 p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,uint256)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(uint256 p0, address p1, string memory p2, string memory p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,string)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(uint256 p0, address p1, string memory p2, bool p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,bool)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(uint256 p0, address p1, string memory p2, address p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,string,address)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(uint256 p0, address p1, bool p2, uint256 p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,uint256)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(uint256 p0, address p1, bool p2, string memory p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,string)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(uint256 p0, address p1, bool p2, bool p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,bool)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(uint256 p0, address p1, bool p2, address p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,bool,address)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(uint256 p0, address p1, address p2, uint256 p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,uint256)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(uint256 p0, address p1, address p2, string memory p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,string)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(uint256 p0, address p1, address p2, bool p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,bool)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(uint256 p0, address p1, address p2, address p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(uint256,address,address,address)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(string memory p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,uint256)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(string memory p0, uint256 p1, uint256 p2, string memory p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,string)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(string memory p0, uint256 p1, uint256 p2, bool p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,bool)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(string memory p0, uint256 p1, uint256 p2, address p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,uint256,address)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(string memory p0, uint256 p1, string memory p2, uint256 p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,uint256)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(string memory p0, uint256 p1, string memory p2, string memory p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,string)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(string memory p0, uint256 p1, string memory p2, bool p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,bool)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(string memory p0, uint256 p1, string memory p2, address p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,string,address)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(string memory p0, uint256 p1, bool p2, uint256 p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,uint256)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(string memory p0, uint256 p1, bool p2, string memory p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,string)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(string memory p0, uint256 p1, bool p2, bool p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,bool)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(string memory p0, uint256 p1, bool p2, address p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,bool,address)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(string memory p0, uint256 p1, address p2, uint256 p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,uint256)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(string memory p0, uint256 p1, address p2, string memory p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,string)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(string memory p0, uint256 p1, address p2, bool p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,bool)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(string memory p0, uint256 p1, address p2, address p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(string,uint256,address,address)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(string memory p0, string memory p1, uint256 p2, uint256 p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,uint256)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(string memory p0, string memory p1, uint256 p2, string memory p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,string)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(string memory p0, string memory p1, uint256 p2, bool p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,bool)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(string memory p0, string memory p1, uint256 p2, address p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint256,address)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(string memory p0, string memory p1, string memory p2, uint256 p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint256)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(string memory p0, string memory p1, bool p2, uint256 p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint256)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(string memory p0, string memory p1, address p2, uint256 p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint256)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(string memory p0, bool p1, uint256 p2, uint256 p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,uint256)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(string memory p0, bool p1, uint256 p2, string memory p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,string)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(string memory p0, bool p1, uint256 p2, bool p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,bool)", p0, p1, p2, p3));
1543 	}
1544 
1545 	function log(string memory p0, bool p1, uint256 p2, address p3) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint256,address)", p0, p1, p2, p3));
1547 	}
1548 
1549 	function log(string memory p0, bool p1, string memory p2, uint256 p3) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint256)", p0, p1, p2, p3));
1551 	}
1552 
1553 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1555 	}
1556 
1557 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1559 	}
1560 
1561 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1563 	}
1564 
1565 	function log(string memory p0, bool p1, bool p2, uint256 p3) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint256)", p0, p1, p2, p3));
1567 	}
1568 
1569 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1571 	}
1572 
1573 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1574 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1575 	}
1576 
1577 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1578 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1579 	}
1580 
1581 	function log(string memory p0, bool p1, address p2, uint256 p3) internal view {
1582 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint256)", p0, p1, p2, p3));
1583 	}
1584 
1585 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1586 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1587 	}
1588 
1589 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1590 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1591 	}
1592 
1593 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1594 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1595 	}
1596 
1597 	function log(string memory p0, address p1, uint256 p2, uint256 p3) internal view {
1598 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,uint256)", p0, p1, p2, p3));
1599 	}
1600 
1601 	function log(string memory p0, address p1, uint256 p2, string memory p3) internal view {
1602 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,string)", p0, p1, p2, p3));
1603 	}
1604 
1605 	function log(string memory p0, address p1, uint256 p2, bool p3) internal view {
1606 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,bool)", p0, p1, p2, p3));
1607 	}
1608 
1609 	function log(string memory p0, address p1, uint256 p2, address p3) internal view {
1610 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint256,address)", p0, p1, p2, p3));
1611 	}
1612 
1613 	function log(string memory p0, address p1, string memory p2, uint256 p3) internal view {
1614 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint256)", p0, p1, p2, p3));
1615 	}
1616 
1617 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1618 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1619 	}
1620 
1621 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1622 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1623 	}
1624 
1625 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1627 	}
1628 
1629 	function log(string memory p0, address p1, bool p2, uint256 p3) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint256)", p0, p1, p2, p3));
1631 	}
1632 
1633 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1635 	}
1636 
1637 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1639 	}
1640 
1641 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1643 	}
1644 
1645 	function log(string memory p0, address p1, address p2, uint256 p3) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint256)", p0, p1, p2, p3));
1647 	}
1648 
1649 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1651 	}
1652 
1653 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1655 	}
1656 
1657 	function log(string memory p0, address p1, address p2, address p3) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1659 	}
1660 
1661 	function log(bool p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,uint256)", p0, p1, p2, p3));
1663 	}
1664 
1665 	function log(bool p0, uint256 p1, uint256 p2, string memory p3) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,string)", p0, p1, p2, p3));
1667 	}
1668 
1669 	function log(bool p0, uint256 p1, uint256 p2, bool p3) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,bool)", p0, p1, p2, p3));
1671 	}
1672 
1673 	function log(bool p0, uint256 p1, uint256 p2, address p3) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,uint256,address)", p0, p1, p2, p3));
1675 	}
1676 
1677 	function log(bool p0, uint256 p1, string memory p2, uint256 p3) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,uint256)", p0, p1, p2, p3));
1679 	}
1680 
1681 	function log(bool p0, uint256 p1, string memory p2, string memory p3) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,string)", p0, p1, p2, p3));
1683 	}
1684 
1685 	function log(bool p0, uint256 p1, string memory p2, bool p3) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,bool)", p0, p1, p2, p3));
1687 	}
1688 
1689 	function log(bool p0, uint256 p1, string memory p2, address p3) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,string,address)", p0, p1, p2, p3));
1691 	}
1692 
1693 	function log(bool p0, uint256 p1, bool p2, uint256 p3) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,uint256)", p0, p1, p2, p3));
1695 	}
1696 
1697 	function log(bool p0, uint256 p1, bool p2, string memory p3) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,string)", p0, p1, p2, p3));
1699 	}
1700 
1701 	function log(bool p0, uint256 p1, bool p2, bool p3) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,bool)", p0, p1, p2, p3));
1703 	}
1704 
1705 	function log(bool p0, uint256 p1, bool p2, address p3) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,bool,address)", p0, p1, p2, p3));
1707 	}
1708 
1709 	function log(bool p0, uint256 p1, address p2, uint256 p3) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,uint256)", p0, p1, p2, p3));
1711 	}
1712 
1713 	function log(bool p0, uint256 p1, address p2, string memory p3) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,string)", p0, p1, p2, p3));
1715 	}
1716 
1717 	function log(bool p0, uint256 p1, address p2, bool p3) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,bool)", p0, p1, p2, p3));
1719 	}
1720 
1721 	function log(bool p0, uint256 p1, address p2, address p3) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint256,address,address)", p0, p1, p2, p3));
1723 	}
1724 
1725 	function log(bool p0, string memory p1, uint256 p2, uint256 p3) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,uint256)", p0, p1, p2, p3));
1727 	}
1728 
1729 	function log(bool p0, string memory p1, uint256 p2, string memory p3) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,string)", p0, p1, p2, p3));
1731 	}
1732 
1733 	function log(bool p0, string memory p1, uint256 p2, bool p3) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,bool)", p0, p1, p2, p3));
1735 	}
1736 
1737 	function log(bool p0, string memory p1, uint256 p2, address p3) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint256,address)", p0, p1, p2, p3));
1739 	}
1740 
1741 	function log(bool p0, string memory p1, string memory p2, uint256 p3) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint256)", p0, p1, p2, p3));
1743 	}
1744 
1745 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1747 	}
1748 
1749 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1751 	}
1752 
1753 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1755 	}
1756 
1757 	function log(bool p0, string memory p1, bool p2, uint256 p3) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint256)", p0, p1, p2, p3));
1759 	}
1760 
1761 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1763 	}
1764 
1765 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1767 	}
1768 
1769 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1771 	}
1772 
1773 	function log(bool p0, string memory p1, address p2, uint256 p3) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint256)", p0, p1, p2, p3));
1775 	}
1776 
1777 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1779 	}
1780 
1781 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1783 	}
1784 
1785 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1787 	}
1788 
1789 	function log(bool p0, bool p1, uint256 p2, uint256 p3) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,uint256)", p0, p1, p2, p3));
1791 	}
1792 
1793 	function log(bool p0, bool p1, uint256 p2, string memory p3) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,string)", p0, p1, p2, p3));
1795 	}
1796 
1797 	function log(bool p0, bool p1, uint256 p2, bool p3) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,bool)", p0, p1, p2, p3));
1799 	}
1800 
1801 	function log(bool p0, bool p1, uint256 p2, address p3) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint256,address)", p0, p1, p2, p3));
1803 	}
1804 
1805 	function log(bool p0, bool p1, string memory p2, uint256 p3) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint256)", p0, p1, p2, p3));
1807 	}
1808 
1809 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1811 	}
1812 
1813 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1815 	}
1816 
1817 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1819 	}
1820 
1821 	function log(bool p0, bool p1, bool p2, uint256 p3) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint256)", p0, p1, p2, p3));
1823 	}
1824 
1825 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1827 	}
1828 
1829 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1831 	}
1832 
1833 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1835 	}
1836 
1837 	function log(bool p0, bool p1, address p2, uint256 p3) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint256)", p0, p1, p2, p3));
1839 	}
1840 
1841 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1843 	}
1844 
1845 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1846 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1847 	}
1848 
1849 	function log(bool p0, bool p1, address p2, address p3) internal view {
1850 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1851 	}
1852 
1853 	function log(bool p0, address p1, uint256 p2, uint256 p3) internal view {
1854 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,uint256)", p0, p1, p2, p3));
1855 	}
1856 
1857 	function log(bool p0, address p1, uint256 p2, string memory p3) internal view {
1858 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,string)", p0, p1, p2, p3));
1859 	}
1860 
1861 	function log(bool p0, address p1, uint256 p2, bool p3) internal view {
1862 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,bool)", p0, p1, p2, p3));
1863 	}
1864 
1865 	function log(bool p0, address p1, uint256 p2, address p3) internal view {
1866 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint256,address)", p0, p1, p2, p3));
1867 	}
1868 
1869 	function log(bool p0, address p1, string memory p2, uint256 p3) internal view {
1870 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint256)", p0, p1, p2, p3));
1871 	}
1872 
1873 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1874 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1875 	}
1876 
1877 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1878 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1879 	}
1880 
1881 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1882 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1883 	}
1884 
1885 	function log(bool p0, address p1, bool p2, uint256 p3) internal view {
1886 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint256)", p0, p1, p2, p3));
1887 	}
1888 
1889 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1890 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1891 	}
1892 
1893 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1894 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1895 	}
1896 
1897 	function log(bool p0, address p1, bool p2, address p3) internal view {
1898 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1899 	}
1900 
1901 	function log(bool p0, address p1, address p2, uint256 p3) internal view {
1902 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint256)", p0, p1, p2, p3));
1903 	}
1904 
1905 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1906 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1907 	}
1908 
1909 	function log(bool p0, address p1, address p2, bool p3) internal view {
1910 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1911 	}
1912 
1913 	function log(bool p0, address p1, address p2, address p3) internal view {
1914 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1915 	}
1916 
1917 	function log(address p0, uint256 p1, uint256 p2, uint256 p3) internal view {
1918 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,uint256)", p0, p1, p2, p3));
1919 	}
1920 
1921 	function log(address p0, uint256 p1, uint256 p2, string memory p3) internal view {
1922 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,string)", p0, p1, p2, p3));
1923 	}
1924 
1925 	function log(address p0, uint256 p1, uint256 p2, bool p3) internal view {
1926 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,bool)", p0, p1, p2, p3));
1927 	}
1928 
1929 	function log(address p0, uint256 p1, uint256 p2, address p3) internal view {
1930 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,uint256,address)", p0, p1, p2, p3));
1931 	}
1932 
1933 	function log(address p0, uint256 p1, string memory p2, uint256 p3) internal view {
1934 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,uint256)", p0, p1, p2, p3));
1935 	}
1936 
1937 	function log(address p0, uint256 p1, string memory p2, string memory p3) internal view {
1938 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,string)", p0, p1, p2, p3));
1939 	}
1940 
1941 	function log(address p0, uint256 p1, string memory p2, bool p3) internal view {
1942 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,bool)", p0, p1, p2, p3));
1943 	}
1944 
1945 	function log(address p0, uint256 p1, string memory p2, address p3) internal view {
1946 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,string,address)", p0, p1, p2, p3));
1947 	}
1948 
1949 	function log(address p0, uint256 p1, bool p2, uint256 p3) internal view {
1950 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,uint256)", p0, p1, p2, p3));
1951 	}
1952 
1953 	function log(address p0, uint256 p1, bool p2, string memory p3) internal view {
1954 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,string)", p0, p1, p2, p3));
1955 	}
1956 
1957 	function log(address p0, uint256 p1, bool p2, bool p3) internal view {
1958 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,bool)", p0, p1, p2, p3));
1959 	}
1960 
1961 	function log(address p0, uint256 p1, bool p2, address p3) internal view {
1962 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,bool,address)", p0, p1, p2, p3));
1963 	}
1964 
1965 	function log(address p0, uint256 p1, address p2, uint256 p3) internal view {
1966 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,uint256)", p0, p1, p2, p3));
1967 	}
1968 
1969 	function log(address p0, uint256 p1, address p2, string memory p3) internal view {
1970 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,string)", p0, p1, p2, p3));
1971 	}
1972 
1973 	function log(address p0, uint256 p1, address p2, bool p3) internal view {
1974 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,bool)", p0, p1, p2, p3));
1975 	}
1976 
1977 	function log(address p0, uint256 p1, address p2, address p3) internal view {
1978 		_sendLogPayload(abi.encodeWithSignature("log(address,uint256,address,address)", p0, p1, p2, p3));
1979 	}
1980 
1981 	function log(address p0, string memory p1, uint256 p2, uint256 p3) internal view {
1982 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,uint256)", p0, p1, p2, p3));
1983 	}
1984 
1985 	function log(address p0, string memory p1, uint256 p2, string memory p3) internal view {
1986 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,string)", p0, p1, p2, p3));
1987 	}
1988 
1989 	function log(address p0, string memory p1, uint256 p2, bool p3) internal view {
1990 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,bool)", p0, p1, p2, p3));
1991 	}
1992 
1993 	function log(address p0, string memory p1, uint256 p2, address p3) internal view {
1994 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint256,address)", p0, p1, p2, p3));
1995 	}
1996 
1997 	function log(address p0, string memory p1, string memory p2, uint256 p3) internal view {
1998 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint256)", p0, p1, p2, p3));
1999 	}
2000 
2001 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2002 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2003 	}
2004 
2005 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2006 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2007 	}
2008 
2009 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2010 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2011 	}
2012 
2013 	function log(address p0, string memory p1, bool p2, uint256 p3) internal view {
2014 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint256)", p0, p1, p2, p3));
2015 	}
2016 
2017 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2018 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2019 	}
2020 
2021 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2022 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2023 	}
2024 
2025 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2026 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2027 	}
2028 
2029 	function log(address p0, string memory p1, address p2, uint256 p3) internal view {
2030 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint256)", p0, p1, p2, p3));
2031 	}
2032 
2033 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2034 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2035 	}
2036 
2037 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2038 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2039 	}
2040 
2041 	function log(address p0, string memory p1, address p2, address p3) internal view {
2042 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2043 	}
2044 
2045 	function log(address p0, bool p1, uint256 p2, uint256 p3) internal view {
2046 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,uint256)", p0, p1, p2, p3));
2047 	}
2048 
2049 	function log(address p0, bool p1, uint256 p2, string memory p3) internal view {
2050 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,string)", p0, p1, p2, p3));
2051 	}
2052 
2053 	function log(address p0, bool p1, uint256 p2, bool p3) internal view {
2054 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,bool)", p0, p1, p2, p3));
2055 	}
2056 
2057 	function log(address p0, bool p1, uint256 p2, address p3) internal view {
2058 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint256,address)", p0, p1, p2, p3));
2059 	}
2060 
2061 	function log(address p0, bool p1, string memory p2, uint256 p3) internal view {
2062 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint256)", p0, p1, p2, p3));
2063 	}
2064 
2065 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2066 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2067 	}
2068 
2069 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2070 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2071 	}
2072 
2073 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2074 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2075 	}
2076 
2077 	function log(address p0, bool p1, bool p2, uint256 p3) internal view {
2078 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint256)", p0, p1, p2, p3));
2079 	}
2080 
2081 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2082 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2083 	}
2084 
2085 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2086 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2087 	}
2088 
2089 	function log(address p0, bool p1, bool p2, address p3) internal view {
2090 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2091 	}
2092 
2093 	function log(address p0, bool p1, address p2, uint256 p3) internal view {
2094 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint256)", p0, p1, p2, p3));
2095 	}
2096 
2097 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2098 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2099 	}
2100 
2101 	function log(address p0, bool p1, address p2, bool p3) internal view {
2102 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2103 	}
2104 
2105 	function log(address p0, bool p1, address p2, address p3) internal view {
2106 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2107 	}
2108 
2109 	function log(address p0, address p1, uint256 p2, uint256 p3) internal view {
2110 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,uint256)", p0, p1, p2, p3));
2111 	}
2112 
2113 	function log(address p0, address p1, uint256 p2, string memory p3) internal view {
2114 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,string)", p0, p1, p2, p3));
2115 	}
2116 
2117 	function log(address p0, address p1, uint256 p2, bool p3) internal view {
2118 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,bool)", p0, p1, p2, p3));
2119 	}
2120 
2121 	function log(address p0, address p1, uint256 p2, address p3) internal view {
2122 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint256,address)", p0, p1, p2, p3));
2123 	}
2124 
2125 	function log(address p0, address p1, string memory p2, uint256 p3) internal view {
2126 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint256)", p0, p1, p2, p3));
2127 	}
2128 
2129 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2130 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2131 	}
2132 
2133 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2134 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2135 	}
2136 
2137 	function log(address p0, address p1, string memory p2, address p3) internal view {
2138 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2139 	}
2140 
2141 	function log(address p0, address p1, bool p2, uint256 p3) internal view {
2142 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint256)", p0, p1, p2, p3));
2143 	}
2144 
2145 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2146 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2147 	}
2148 
2149 	function log(address p0, address p1, bool p2, bool p3) internal view {
2150 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2151 	}
2152 
2153 	function log(address p0, address p1, bool p2, address p3) internal view {
2154 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2155 	}
2156 
2157 	function log(address p0, address p1, address p2, uint256 p3) internal view {
2158 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint256)", p0, p1, p2, p3));
2159 	}
2160 
2161 	function log(address p0, address p1, address p2, string memory p3) internal view {
2162 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2163 	}
2164 
2165 	function log(address p0, address p1, address p2, bool p3) internal view {
2166 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2167 	}
2168 
2169 	function log(address p0, address p1, address p2, address p3) internal view {
2170 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2171 	}
2172 
2173 }
2174 
2175 
2176 // File contracts/Jabba.sol
2177 
2178 
2179 
2180 /*
2181 
2182 
2183 
2184      ██╗ █████╗ ██████╗ ██████╗  █████╗ 
2185      ██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗
2186      ██║███████║██████╔╝██████╔╝███████║
2187 ██   ██║██╔══██║██╔══██╗██╔══██╗██╔══██║
2188 ╚█████╔╝██║  ██║██████╔╝██████╔╝██║  ██║
2189  ╚════╝ ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝
2190                                         
2191 
2192                                                 
2193 TG: https://t.me/jabbaverification
2194 TW: https://twitter.com/JabbaETH
2195 Web: https://Jabba-queen.vip
2196 
2197 */
2198 
2199 
2200 pragma solidity ^0.8.0;
2201 
2202 
2203 contract Jabba is ERC20, Ownable {
2204 
2205     uint256 private _totalSupply = 1 * 1e9 * 10**18;
2206 
2207     mapping(address => bool) public blacklists;
2208     
2209     address public uniswapV2Pair;
2210     address public uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
2211 
2212     uint256 public maxTxAmount = 1e7 * 10**18;
2213     
2214 
2215     uint256 private saleTax = 25;
2216     bool public saleTaxEnabled = true;
2217 
2218     uint256 private buyTax = 15;
2219     bool public buyTaxEnabled = true;
2220 
2221     address public marketing;
2222 
2223     constructor() ERC20("Jabba", "JABBA") {
2224         _mint(msg.sender, _totalSupply);
2225     }
2226 
2227     function setMarketing(address _marketing) external onlyOwner {
2228         marketing = _marketing;
2229     }
2230 
2231     function setPair( address _uniswapV2Pair) external onlyOwner {
2232         uniswapV2Pair = _uniswapV2Pair;        
2233     }
2234 
2235     
2236 
2237     function setMaxTxAmount(uint256 _max) external onlyOwner {
2238         maxTxAmount = _max;
2239         
2240     }
2241 
2242     function removeTax() external onlyOwner {
2243        buyTaxEnabled = false;
2244        saleTaxEnabled = false;
2245     }
2246 
2247 
2248     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
2249         blacklists[_address] = _isBlacklisting;
2250     }
2251 
2252     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2253         address owner = _msgSender();
2254         uint256 _amount = amount;
2255 
2256         if (to == uniswapV2Pair && owner != address(uniswapV2Router)) {
2257            // Sale 
2258            
2259            if (saleTaxEnabled) {
2260               // Apply tax if enabled
2261               uint256 fee = amount * saleTax/100;
2262               _amount = _amount - fee;
2263               _transfer(owner, marketing, fee);
2264            }
2265         } 
2266 
2267         if (owner == uniswapV2Pair && to != address(uniswapV2Router)) {
2268             // Buy
2269             if (buyTaxEnabled) {
2270              // Apply tax if enabled
2271               uint256 fee = amount * buyTax/100;
2272               _amount = _amount - fee;
2273               _transfer(owner, marketing, fee);
2274             }
2275 
2276         }
2277 
2278         _transfer(owner, to, _amount);
2279         return true;
2280     }
2281 
2282     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
2283         address spender = _msgSender();
2284         _spendAllowance(from, spender, amount);
2285         uint256 _amount = amount;
2286 
2287         if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
2288            // Sale 
2289            
2290            if (saleTaxEnabled) {
2291               // Apply tax if enabled
2292               uint256 fee = amount * saleTax/100;
2293               _amount = _amount - fee;
2294               _transfer(from, marketing, fee);
2295            }
2296         } 
2297 
2298         if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
2299             // Buy
2300             if (buyTaxEnabled) {
2301              // Apply tax if enabled
2302               uint256 fee = amount * buyTax/100;
2303               _amount = _amount - fee;
2304               _transfer(from, marketing, fee);
2305             }
2306 
2307         }
2308 
2309         _transfer(from, to, _amount);
2310         return true;
2311     }
2312 
2313 
2314     
2315     function _beforeTokenTransfer(
2316         address from,
2317         address to,
2318         uint256 amount
2319     ) override internal virtual {
2320         require(!blacklists[to] && !blacklists[from], "Blacklisted");
2321            
2322 
2323         if (uniswapV2Pair == address(0)) {
2324             require(from == owner() || to == owner(), "Trading has not started yet");
2325             return;
2326         }
2327 
2328         if(maxTxAmount > 0 && from != owner() && to != owner())
2329             require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
2330 
2331     }
2332 
2333 
2334     function burn(uint256 value) external {
2335         _burn(msg.sender, value);
2336     }
2337     
2338 
2339 }