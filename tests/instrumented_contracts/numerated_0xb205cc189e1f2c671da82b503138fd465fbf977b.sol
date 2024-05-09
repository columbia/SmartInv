1 /***
2       Rubinomix 
3       $RBX 
4        
5       Like a Rubik’s Cube, Blockchain and DeFi is tedious and difficult
6       to decipher. Our Rubinomix dapps RubeFis (deciphers) DeFi and 
7       blockchain into a human readable form. The resulting advanced 
8       analysis data enables DeFi traders to better understand their 
9       trading habits and performance. Additionally RubeFi analysis gives 
10       traders deep insight into other traders and tokens through 
11       deciphered historical and live data. Rubinomix provides the tools 
12       to help traders succeed in DeFi. 
13       
14                                  ___ ___ ___
15                                /___/___/___/|
16                               /___/___/___/||
17                              /___/___/__ /|/|
18                             |   |   |   | /||
19                             |___|___|___|/|/|
20                             |   |   |   | /||
21                             |___|___|___|/|/
22                             |   |   |   | /
23                             |___|___|___|/
24       
25       Website:   
26       https://rubix.red  
27         
28       Telegram:   
29       https://t.me/Rubinomix 
30       
31       Medium:   
32       https://medium.com/@rubinomix 
33             
34 ***/
35 
36 //   SPDX-License-Identifier: MIT
37 
38 pragma solidity 0.8.14;
39 
40 abstract contract Context { 
41     function _msgSender() internal view virtual returns (address) { 
42         return msg.sender;
43     }                
44 
45     function _msgData() internal view virtual returns (bytes calldata) { 
46         return msg.data;
47     }                
48 }              
49 
50 abstract contract Ownable is Context { 
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() { 
59         _transferOwnership(_msgSender());
60     }              
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) { 
66         return _owner;
67     }              
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() { 
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }              
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner { 
85         _transferOwnership(address(0));
86     }              
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner { 
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }              
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual { 
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }              
106 }              
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 { 
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `recipient`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a { Transfer}               event.
128      */
129     function transfer(address recipient, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through { transferFrom}              . This is
134      * zero by default.
135      *
136      * This value changes when { approve}               or { transferFrom}               are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://  github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an { Approval}               event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `sender` to `recipient` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a { Transfer}               event.
164      */
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) external returns (bool);
170 
171     /**
172      * @dev Emitted when `value` tokens are moved from one account (`from`) to
173      * another (`to`).
174      *
175      * Note that `value` may be zero.
176      */
177     event Transfer(address indexed from, address indexed to, uint256 value);
178 
179     /**
180      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
181      * a call to { approve}              . `value` is the new allowance.
182      */
183     event Approval(address indexed owner, address indexed spender, uint256 value);
184 }              
185 
186 //  //  //  lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
187 //  OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
188 
189 /* pragma solidity ^0.8.0; */
190 
191 /* import "../IERC20.sol"; */
192 
193 /**
194  * @dev Interface for the optional metadata functions from the ERC20 standard.
195  *
196  * _Available since v4.1._
197  */
198 interface IERC20Metadata is IERC20 { 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the symbol of the token.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the decimals places of the token.
211      */
212     function decimals() external view returns (uint8);
213 }              
214 
215 //  //  //  lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
216 //  OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
217 
218 /* pragma solidity ^0.8.0; */
219 
220 /* import "./IERC20.sol"; */
221 /* import "./extensions/IERC20Metadata.sol"; */
222 /* import "../../utils/Context.sol"; */
223 
224 /**
225  * @dev Implementation of the { IERC20}               interface.
226  *
227  * This implementation is agnostic to the way tokens are created. This means
228  * that a supply mechanism has to be added in a derived contract using { _mint}              .
229  * For a generic mechanism see { ERC20PresetMinterPauser}              .
230  *
231  * TIP: For a detailed writeup see our guide
232  * https://  forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
233  * to implement supply mechanisms].
234  *
235  * We have followed general OpenZeppelin Contracts guidelines: functions revert
236  * instead returning `false` on failure. This behavior is nonetheless
237  * conventional and does not conflict with the expectations of ERC20
238  * applications.
239  *
240  * Additionally, an { Approval}               event is emitted on calls to { transferFrom}              .
241  * This allows applications to reconstruct the allowance for all accounts just
242  * by listening to said events. Other implementations of the EIP may not emit
243  * these events, as it isn't required by the specification.
244  *
245  * Finally, the non-standard { decreaseAllowance}               and { increaseAllowance}              
246  * functions have been added to mitigate the well-known issues around setting
247  * allowances. See { IERC20-approve}              .
248  */
249 contract ERC20 is Context, IERC20, IERC20Metadata { 
250     mapping(address => uint256) private _balances;
251 
252     mapping(address => mapping(address => uint256)) private _allowances;
253 
254     uint256 private _totalSupply;
255 
256     string private _name;
257     string private _symbol;
258 
259     /**
260      * @dev Sets the values for { name}               and { symbol}              .
261      *
262      * The default value of { decimals}               is 18. To select a different value for
263      * { decimals}               you should overload it.
264      *
265      * All two of these values are immutable: they can only be set once during
266      * construction.
267      */
268     constructor(string memory name_, string memory symbol_) { 
269         _name = name_;
270         _symbol = symbol_;
271     }              
272 
273     /**
274      * @dev Returns the name of the token.
275      */
276     function name() public view virtual override returns (string memory) { 
277         return _name;
278     }              
279 
280     /**
281      * @dev Returns the symbol of the token, usually a shorter version of the
282      * name.
283      */
284     function symbol() public view virtual override returns (string memory) { 
285         return _symbol;
286     }              
287 
288     /**
289      * @dev Returns the number of decimals used to get its user representation.
290      * For example, if `decimals` equals `2`, a balance of `505` tokens should
291      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
292      *
293      * Tokens usually opt for a value of 18, imitating the relationship between
294      * Ether and Wei. This is the value { ERC20}               uses, unless this function is
295      * overridden;
296      *
297      * NOTE: This information is only used for _display_ purposes: it in
298      * no way affects any of the arithmetic of the contract, including
299      * { IERC20-balanceOf}               and { IERC20-transfer}              .
300      */
301     function decimals() public view virtual override returns (uint8) { 
302         return 18;
303     }              
304 
305     /**
306      * @dev See { IERC20-totalSupply}              .
307      */
308     function totalSupply() public view virtual override returns (uint256) { 
309         return _totalSupply;
310     }              
311 
312     /**
313      * @dev See { IERC20-balanceOf}              .
314      */
315     function balanceOf(address account) public view virtual override returns (uint256) { 
316         return _balances[account];
317     }              
318 
319     /**
320      * @dev See { IERC20-transfer}              .
321      *
322      * Requirements:
323      *
324      * - `recipient` cannot be the zero address.
325      * - the caller must have a balance of at least `amount`.
326      */
327     function transfer(address recipient, uint256 amount) public virtual override returns (bool) { 
328         _transfer(_msgSender(), recipient, amount);
329         return true;
330     }              
331 
332     /**
333      * @dev See { IERC20-allowance}              .
334      */
335     function allowance(address owner, address spender) public view virtual override returns (uint256) { 
336         return _allowances[owner][spender];
337     }              
338 
339     /**
340      * @dev See { IERC20-approve}              .
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      */
346     function approve(address spender, uint256 amount) public virtual override returns (bool) { 
347         _approve(_msgSender(), spender, amount);
348         return true;
349     }              
350 
351     /**
352      * @dev See { IERC20-transferFrom}              .
353      *
354      * Emits an { Approval}               event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of { ERC20}              .
356      *
357      * Requirements:
358      *
359      * - `sender` and `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      * - the caller must have allowance for ``sender``'s tokens of at least
362      * `amount`.
363      */
364     function transferFrom(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) public virtual override returns (bool) { 
369         _transfer(sender, recipient, amount);
370 
371         uint256 currentAllowance = _allowances[sender][_msgSender()];
372         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
373         unchecked { 
374             _approve(sender, _msgSender(), currentAllowance - amount);
375         }              
376 
377         return true;
378     }              
379 
380     /**
381      * @dev Atomically increases the allowance granted to `spender` by the caller.
382      *
383      * This is an alternative to { approve}               that can be used as a mitigation for
384      * problems described in { IERC20-approve}              .
385      *
386      * Emits an { Approval}               event indicating the updated allowance.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) { 
393         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
394         return true;
395     }              
396 
397     /**
398      * @dev Atomically decreases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to { approve}               that can be used as a mitigation for
401      * problems described in { IERC20-approve}              .
402      *
403      * Emits an { Approval}               event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      * - `spender` must have allowance for the caller of at least
409      * `subtractedValue`.
410      */
411     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) { 
412         uint256 currentAllowance = _allowances[_msgSender()][spender];
413         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
414         unchecked { 
415             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
416         }              
417 
418         return true;
419     }              
420 
421     /**
422      * @dev Moves `amount` of tokens from `sender` to `recipient`.
423      *
424      * This internal function is equivalent to { transfer}              , and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a { Transfer}               event.
428      *
429      * Requirements:
430      *
431      * - `sender` cannot be the zero address.
432      * - `recipient` cannot be the zero address.
433      * - `sender` must have a balance of at least `amount`.
434      */
435     function _transfer(
436         address sender,
437         address recipient,
438         uint256 amount
439     ) internal virtual { 
440         require(sender != address(0), "ERC20: transfer from the zero address");
441         require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(sender, recipient, amount);
444 
445         uint256 senderBalance = _balances[sender];
446         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
447         unchecked { 
448             _balances[sender] = senderBalance - amount;
449         }              
450         _balances[recipient] += amount;
451 
452         emit Transfer(sender, recipient, amount);
453 
454         _afterTokenTransfer(sender, recipient, amount);
455     }              
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a { Transfer}               event with `from` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal virtual { 
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply += amount;
472         _balances[account] += amount;
473         emit Transfer(address(0), account, amount);
474 
475         _afterTokenTransfer(address(0), account, amount);
476     }              
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`, reducing the
480      * total supply.
481      *
482      * Emits a { Transfer}               event with `to` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      * - `account` must have at least `amount` tokens.
488      */
489     function _burn(address account, uint256 amount) internal virtual { 
490         require(account != address(0), "ERC20: burn from the zero address");
491 
492         _beforeTokenTransfer(account, address(0), amount);
493 
494         uint256 accountBalance = _balances[account];
495         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
496         unchecked { 
497             _balances[account] = accountBalance - amount;
498         }              
499         _totalSupply -= amount;
500 
501         emit Transfer(account, address(0), amount);
502 
503         _afterTokenTransfer(account, address(0), amount);
504     }              
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an { Approval}               event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519     function _approve(
520         address owner,
521         address spender,
522         uint256 amount
523     ) internal virtual { 
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }              
530 
531     /**
532      * @dev Hook that is called before any transfer of tokens. This includes
533      * minting and burning.
534      *
535      * Calling conditions:
536      *
537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
538      * will be transferred to `to`.
539      * - when `from` is zero, `amount` tokens will be minted for `to`.
540      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
541      * - `from` and `to` are never both zero.
542      *
543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
544      */
545     function _beforeTokenTransfer(
546         address from,
547         address to,
548         uint256 amount
549     ) internal virtual { }              
550 
551     /**
552      * @dev Hook that is called after any transfer of tokens. This includes
553      * minting and burning.
554      *
555      * Calling conditions:
556      *
557      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
558      * has been transferred to `to`.
559      * - when `from` is zero, `amount` tokens have been minted for `to`.
560      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
561      * - `from` and `to` are never both zero.
562      *
563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
564      */
565     function _afterTokenTransfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual { }              
570 }              
571 
572 //  //  //  lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
573 //  OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
574 
575 /* pragma solidity ^0.8.0; */
576 
577 //  CAUTION
578 //  This version of SafeMath should only be used with Solidity 0.8 or later,
579 //  because it relies on the compiler's built in overflow checks.
580 
581 /**
582  * @dev Wrappers over Solidity's arithmetic operations.
583  *
584  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
585  * now has built in overflow checking.
586  */
587 library SafeMath { 
588     /**
589      * @dev Returns the addition of two unsigned integers, with an overflow flag.
590      *
591      * _Available since v3.4._
592      */
593     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) { 
594         unchecked { 
595             uint256 c = a + b;
596             if (c < a) return (false, 0);
597             return (true, c);
598         }              
599     }              
600 
601     /**
602      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
603      *
604      * _Available since v3.4._
605      */
606     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) { 
607         unchecked { 
608             if (b > a) return (false, 0);
609             return (true, a - b);
610         }              
611     }              
612 
613     /**
614      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
615      *
616      * _Available since v3.4._
617      */
618     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) { 
619         unchecked { 
620             //  Gas optimization: this is cheaper than requiring 'a' not being zero, but the
621             //  benefit is lost if 'b' is also tested.
622             //  See: https://  github.com/OpenZeppelin/openzeppelin-contracts/pull/522
623             if (a == 0) return (true, 0);
624             uint256 c = a * b;
625             if (c / a != b) return (false, 0);
626             return (true, c);
627         }              
628     }              
629 
630     /**
631      * @dev Returns the division of two unsigned integers, with a division by zero flag.
632      *
633      * _Available since v3.4._
634      */
635     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) { 
636         unchecked { 
637             if (b == 0) return (false, 0);
638             return (true, a / b);
639         }              
640     }              
641 
642     /**
643      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
644      *
645      * _Available since v3.4._
646      */
647     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) { 
648         unchecked { 
649             if (b == 0) return (false, 0);
650             return (true, a % b);
651         }              
652     }              
653 
654     /**
655      * @dev Returns the addition of two unsigned integers, reverting on
656      * overflow.
657      *
658      * Counterpart to Solidity's `+` operator.
659      *
660      * Requirements:
661      *
662      * - Addition cannot overflow.
663      */
664     function add(uint256 a, uint256 b) internal pure returns (uint256) { 
665         return a + b;
666     }              
667 
668     /**
669      * @dev Returns the subtraction of two unsigned integers, reverting on
670      * overflow (when the result is negative).
671      *
672      * Counterpart to Solidity's `-` operator.
673      *
674      * Requirements:
675      *
676      * - Subtraction cannot overflow.
677      */
678     function sub(uint256 a, uint256 b) internal pure returns (uint256) { 
679         return a - b;
680     }              
681 
682     /**
683      * @dev Returns the multiplication of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `*` operator.
687      *
688      * Requirements:
689      *
690      * - Multiplication cannot overflow.
691      */
692     function mul(uint256 a, uint256 b) internal pure returns (uint256) { 
693         return a * b;
694     }              
695 
696     /**
697      * @dev Returns the integer division of two unsigned integers, reverting on
698      * division by zero. The result is rounded towards zero.
699      *
700      * Counterpart to Solidity's `/` operator.
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function div(uint256 a, uint256 b) internal pure returns (uint256) { 
707         return a / b;
708     }              
709 
710     /**
711      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
712      * reverting when dividing by zero.
713      *
714      * Counterpart to Solidity's `%` operator. This function uses a `revert`
715      * opcode (which leaves remaining gas untouched) while Solidity uses an
716      * invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function mod(uint256 a, uint256 b) internal pure returns (uint256) { 
723         return a % b;
724     }              
725 
726     /**
727      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
728      * overflow (when the result is negative).
729      *
730      * CAUTION: This function is deprecated because it requires allocating memory for the error
731      * message unnecessarily. For custom revert reasons use { trySub}              .
732      *
733      * Counterpart to Solidity's `-` operator.
734      *
735      * Requirements:
736      *
737      * - Subtraction cannot overflow.
738      */
739     function sub(
740         uint256 a,
741         uint256 b,
742         string memory errorMessage
743     ) internal pure returns (uint256) { 
744         unchecked { 
745             require(b <= a, errorMessage);
746             return a - b;
747         }              
748     }              
749 
750     /**
751      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
752      * division by zero. The result is rounded towards zero.
753      *
754      * Counterpart to Solidity's `/` operator. Note: this function uses a
755      * `revert` opcode (which leaves remaining gas untouched) while Solidity
756      * uses an invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function div(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) { 
767         unchecked { 
768             require(b > 0, errorMessage);
769             return a / b;
770         }              
771     }              
772 
773     /**
774      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
775      * reverting with custom message when dividing by zero.
776      *
777      * CAUTION: This function is deprecated because it requires allocating memory for the error
778      * message unnecessarily. For custom revert reasons use { tryMod}              .
779      *
780      * Counterpart to Solidity's `%` operator. This function uses a `revert`
781      * opcode (which leaves remaining gas untouched) while Solidity uses an
782      * invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function mod(
789         uint256 a,
790         uint256 b,
791         string memory errorMessage
792     ) internal pure returns (uint256) { 
793         unchecked { 
794             require(b > 0, errorMessage);
795             return a % b;
796         }              
797     }              
798 }              
799 
800 //  //  //  src/IUniswapV2Factory.sol
801 /* pragma solidity 0.8.10; */
802 /* pragma experimental ABIEncoderV2; */
803 
804 interface IUniswapV2Factory { 
805     event PairCreated(
806         address indexed token0,
807         address indexed token1,
808         address pair,
809         uint256
810     );
811 
812     function feeTo() external view returns (address);
813 
814     function feeToSetter() external view returns (address);
815 
816     function getPair(address tokenA, address tokenB)
817         external
818         view
819         returns (address pair);
820 
821     function allPairs(uint256) external view returns (address pair);
822 
823     function allPairsLength() external view returns (uint256);
824 
825     function createPair(address tokenA, address tokenB)
826         external
827         returns (address pair);
828 
829     function setFeeTo(address) external;
830 
831     function setFeeToSetter(address) external;
832 }              
833 
834 //  //  //  src/IUniswapV2Pair.sol
835 /* pragma solidity 0.8.10; */
836 /* pragma experimental ABIEncoderV2; */
837 
838 interface IUniswapV2Pair { 
839     event Approval(
840         address indexed owner,
841         address indexed spender,
842         uint256 value
843     );
844     event Transfer(address indexed from, address indexed to, uint256 value);
845 
846     function name() external pure returns (string memory);
847 
848     function symbol() external pure returns (string memory);
849 
850     function decimals() external pure returns (uint8);
851 
852     function totalSupply() external view returns (uint256);
853 
854     function balanceOf(address owner) external view returns (uint256);
855 
856     function allowance(address owner, address spender)
857         external
858         view
859         returns (uint256);
860 
861     function approve(address spender, uint256 value) external returns (bool);
862 
863     function transfer(address to, uint256 value) external returns (bool);
864 
865     function transferFrom(
866         address from,
867         address to,
868         uint256 value
869     ) external returns (bool);
870 
871     function DOMAIN_SEPARATOR() external view returns (bytes32);
872 
873     function PERMIT_TYPEHASH() external pure returns (bytes32);
874 
875     function nonces(address owner) external view returns (uint256);
876 
877     function permit(
878         address owner,
879         address spender,
880         uint256 value,
881         uint256 deadline,
882         uint8 v,
883         bytes32 r,
884         bytes32 s
885     ) external;
886 
887     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
888     event Burn(
889         address indexed sender,
890         uint256 amount0,
891         uint256 amount1,
892         address indexed to
893     );
894     event Swap(
895         address indexed sender,
896         uint256 amount0In,
897         uint256 amount1In,
898         uint256 amount0Out,
899         uint256 amount1Out,
900         address indexed to
901     );
902     event Sync(uint112 reserve0, uint112 reserve1);
903 
904     function MINIMUM_LIQUIDITY() external pure returns (uint256);
905 
906     function factory() external view returns (address);
907 
908     function token0() external view returns (address);
909 
910     function token1() external view returns (address);
911 
912     function getReserves()
913         external
914         view
915         returns (
916             uint112 reserve0,
917             uint112 reserve1,
918             uint32 blockTimestampLast
919         );
920 
921     function price0CumulativeLast() external view returns (uint256);
922 
923     function price1CumulativeLast() external view returns (uint256);
924 
925     function kLast() external view returns (uint256);
926 
927     function mint(address to) external returns (uint256 liquidity);
928 
929     function burn(address to)
930         external
931         returns (uint256 amount0, uint256 amount1);
932 
933     function swap(
934         uint256 amount0Out,
935         uint256 amount1Out,
936         address to,
937         bytes calldata data
938     ) external;
939 
940     function skim(address to) external;
941 
942     function sync() external;
943 
944     function initialize(address, address) external;
945 }              
946 
947 interface IUniswapV2Router02 { 
948     function factory() external pure returns (address);
949 
950     function WETH() external pure returns (address);
951 
952     function addLiquidity(
953         address tokenA,
954         address tokenB,
955         uint256 amountADesired,
956         uint256 amountBDesired,
957         uint256 amountAMin,
958         uint256 amountBMin,
959         address to,
960         uint256 deadline
961     )
962         external
963         returns (
964             uint256 amountA,
965             uint256 amountB,
966             uint256 liquidity
967         );
968 
969     function addLiquidityETH(
970         address token,
971         uint256 amountTokenDesired,
972         uint256 amountTokenMin,
973         uint256 amountETHMin,
974         address to,
975         uint256 deadline
976     )
977         external
978         payable
979         returns (
980             uint256 amountToken,
981             uint256 amountETH,
982             uint256 liquidity
983         );
984 
985     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
986         uint256 amountIn,
987         uint256 amountOutMin,
988         address[] calldata path,
989         address to,
990         uint256 deadline
991     ) external;
992 
993     function swapExactETHForTokensSupportingFeeOnTransferTokens(
994         uint256 amountOutMin,
995         address[] calldata path,
996         address to,
997         uint256 deadline
998     ) external payable;
999 
1000     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1001         uint256 amountIn,
1002         uint256 amountOutMin,
1003         address[] calldata path,
1004         address to,
1005         uint256 deadline
1006     ) external;
1007 }              
1008 
1009 contract Rubinomix is ERC20, Ownable { 
1010 // contract NULL1 is ERC20, Ownable { 
1011 
1012      using SafeMath for uint256;
1013 
1014      string[] public Announcements;
1015 
1016      IUniswapV2Router02 public immutable uniswapV2Router;
1017      address public immutable uniswapV2Pair;
1018      address public constant deadAddress = address(0xdead);
1019 
1020      bool private swapping;
1021 
1022      address public marketingWallet;
1023      address public devWallet;
1024 
1025      uint256 public maxTransactionAmount;
1026      uint256 public swapTokensAtAmount;
1027      uint256 public maxWallet;
1028 
1029      uint256 public percentForLPBurn = 25; //  25 = .25%
1030      bool public lpBurnEnabled = true;
1031      uint256 public lpBurnFrequency = 3600 seconds;
1032      uint256 public lastLpBurnTime;
1033 
1034      uint256 public manualBurnFrequency = 30 minutes;
1035      uint256 public lastManualLpBurnTime;
1036 
1037      bool public limitsInEffect = true;
1038      bool public tradingActive = false;
1039      bool public swapEnabled = false;
1040 
1041      mapping(address => uint256) private _holderLastTransferTimestamp; //  to hold last Transfers temporarily during launch
1042      bool public transferDelayEnabled = true;
1043 
1044      uint256 public tokensForMarketing;
1045      uint256 public tokensForLiquidity;
1046      uint256 public tokensForDev;
1047 
1048      uint256 public buyTotalFees;
1049      uint256 public buyMarketingFee;
1050      uint256 public buyLiquidityFee;
1051      uint256 public buyDevFee;
1052 
1053      uint256 public sellTotalFees;
1054      uint256 public sellMarketingFee;
1055      uint256 public sellLiquidityFee;
1056      uint256 public sellDevFee;
1057 
1058      //  exlcude from fees and max transaction amount
1059      mapping(address => bool) private _isExcludedFromFees;
1060      mapping(address => bool) public _isExcludedMaxTransactionAmount;
1061 
1062      //  store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1063      //  could be subject to a maximum transfer amount
1064      mapping(address => bool) public automatedMarketMakerPairs;
1065 
1066      event UpdateUniswapV2Router(
1067           address indexed newAddress,
1068           address indexed oldAddress
1069      );
1070 
1071      event ExcludeFromFees(address indexed account, bool isExcluded);
1072 
1073      event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1074 
1075      event marketingWalletUpdated(
1076           address indexed newWallet,
1077           address indexed oldWallet
1078      );
1079 
1080      event devWalletUpdated(
1081           address indexed newWallet,
1082           address indexed oldWallet
1083      );
1084 
1085      event SwapAndLiquify(
1086           uint256 tokensSwapped,
1087           uint256 ethReceived,
1088           uint256 tokensIntoLiquidity
1089      );
1090 
1091      event AutoNukeLP();
1092 
1093      event ManualNukeLP();
1094 
1095      constructor() ERC20("Rubinomix", "RBX") { 
1096     //  constructor() ERC20("NULL1", "NULL1") { 
1097 
1098           IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1099                0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1100           );
1101 
1102           excludeFromMaxTx(address(_uniswapV2Router), true);
1103           uniswapV2Router = _uniswapV2Router;
1104 
1105           uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1106                .createPair(address(this), _uniswapV2Router.WETH());
1107           excludeFromMaxTx(address(uniswapV2Pair), true);
1108           _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1109 
1110           uint256 _buyMarketingFee = 3;
1111           uint256 _buyLiquidityFee = 0;
1112           uint256 _buyDevFee = 3;
1113 
1114           uint256 _sellMarketingFee = 3;
1115           uint256 _sellLiquidityFee = 0;
1116           uint256 _sellDevFee = 3;
1117 
1118           uint256 totalSupply = 1_000_000_000 * 1e18;
1119 
1120           maxTransactionAmount = 10_000_001 * 1e18; //  1% from total supply maxTransactionAmountTxn
1121           maxWallet = 20_000_002 * 1e18; //  2% from total supply maxWallet
1122           swapTokensAtAmount = (totalSupply * 5) / 10000; //  0.05% swap wallet
1123 
1124           devWallet = address(0x3b1Bf6b7e9577640bAb82930f4CcB9334329AC01);
1125           marketingWallet = address(0x25ca4A60D53A43696E2b6b4Fc7e89165CfFc52b6);
1126 
1127           buyMarketingFee = _buyMarketingFee;
1128           buyLiquidityFee = _buyLiquidityFee;
1129           buyDevFee = _buyDevFee;
1130           buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1131 
1132           sellMarketingFee = _sellMarketingFee;
1133           sellLiquidityFee = _sellLiquidityFee;
1134           sellDevFee = _sellDevFee;
1135           sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1136 
1137           //  exclude from paying fees or having max transaction amount
1138           excludeFromMaxTx(owner(), true);
1139           excludeFromMaxTx(address(this), true);
1140           excludeFromMaxTx(address(0xdead), true);
1141           excludeFromFees(owner(), true);
1142           excludeFromFees(address(this), true);
1143           excludeFromFees(address(0xdead), true);
1144 
1145           _mint(msg.sender, totalSupply);
1146      }              
1147 
1148      receive() external payable { }              
1149 
1150      function intToStr(uint _i) internal pure returns (string memory _uintAsString) {
1151         if (_i == 0) {
1152             return "0";
1153         }              
1154         uint j = _i;
1155         uint len;
1156         while (j != 0) {
1157             len++;
1158             j /= 10;
1159         }              
1160         bytes memory bstr = new bytes(len);
1161         uint k = len;
1162         while (_i != 0) {
1163             k = k-1;
1164             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1165             bytes1 b1 = bytes1(temp);
1166             bstr[k] = b1;
1167             _i /= 10;
1168         }              
1169         return string(bstr);
1170      }              
1171 
1172      function Announcement(string memory teamAnnouncement) external onlyOwner {
1173           string memory _msg = string(abi.encodePacked(intToStr(block.timestamp), ": ", teamAnnouncement));
1174           Announcements.push(_msg);
1175      }              
1176 
1177      function AllAnnouncments() external view returns (string[] memory) {
1178 		  return Announcements;
1179 	 }              
1180 
1181      function excludeFromFees(address account, bool excluded) public onlyOwner { 
1182           _isExcludedFromFees[account] = excluded;
1183           emit ExcludeFromFees(account, excluded);
1184      }              
1185 
1186      function updateBuyFees(
1187           uint256 _marketingFee,
1188           uint256 _liquidityFee,
1189           uint256 _devFee
1190      ) external onlyOwner { 
1191           buyMarketingFee = _marketingFee;
1192           buyLiquidityFee = _liquidityFee;
1193           buyDevFee = _devFee;
1194           buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1195           require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1196      }              
1197 
1198      function updateSellFees(
1199           uint256 _marketingFee,
1200           uint256 _liquidityFee,
1201           uint256 _devFee
1202      ) external onlyOwner { 
1203           sellMarketingFee = _marketingFee;
1204           sellLiquidityFee = _liquidityFee;
1205           sellDevFee = _devFee;
1206           sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1207           require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1208      }              
1209 
1210      //  remove limits after token is stable
1211      function removeLimits() external onlyOwner returns (bool) { 
1212           limitsInEffect = false;
1213           return true;
1214      }              
1215 
1216      //  disable Transfer delay - cannot be reenabled
1217      function disableTransferDelay() external onlyOwner returns (bool) { 
1218           transferDelayEnabled = false;
1219           return true;
1220      }              
1221 
1222      //  change the minimum amount of tokens to sell from fees
1223      function updateSwapTokensAtAmount(uint256 newAmount)
1224           external
1225           onlyOwner
1226           returns (bool)
1227      { 
1228           require(
1229                newAmount >= (totalSupply() * 1) / 100000,
1230                "Swap amount cannot be lower than 0.001% total supply."
1231           );
1232           require(
1233                newAmount <= (totalSupply() * 5) / 1000,
1234                "Swap amount cannot be higher than 0.5% total supply."
1235           );
1236           swapTokensAtAmount = newAmount;
1237           return true;
1238      }              
1239 
1240      function updateMaxWalletAmount(uint256 newNum) external onlyOwner { 
1241           require(
1242                newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1243                "Cannot set maxWallet lower than 1.0%"
1244           );
1245           maxWallet = newNum * (10**18);
1246      }              
1247      function updateMaxTxAmount(uint256 newNum) external onlyOwner { 
1248           require(
1249                newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1250                "Cannot set maxTransactionAmount lower than 1.0%"
1251           );
1252           maxTransactionAmount = newNum * (10**18);
1253      }              
1254 
1255      function excludeFromMaxTx(address updAds, bool isEx)
1256           public
1257           onlyOwner
1258      { 
1259           _isExcludedMaxTransactionAmount[updAds] = isEx;
1260      }              
1261 
1262      //  enables trading -- must add liq first
1263      function enableTrading() external onlyOwner { 
1264           tradingActive = true;
1265           swapEnabled = true;
1266           lastLpBurnTime = block.timestamp;
1267      }              
1268 
1269      function setAutomatedMarketMakerPair(address pair, bool value)
1270           public
1271           onlyOwner
1272      { 
1273           require(
1274                pair != uniswapV2Pair,
1275                "The pair cannot be removed from automatedMarketMakerPairs"
1276           );
1277 
1278           _setAutomatedMarketMakerPair(pair, value);
1279      }              
1280 
1281      function _setAutomatedMarketMakerPair(address pair, bool value) private { 
1282           automatedMarketMakerPairs[pair] = value;
1283 
1284           emit SetAutomatedMarketMakerPair(pair, value);
1285      }              
1286 
1287      function updateDevWallet(address newWallet) external onlyOwner { 
1288           emit devWalletUpdated(newWallet, devWallet);
1289           devWallet = newWallet;
1290      }              
1291 
1292      function isExcludedFromFees(address account) public view returns (bool) { 
1293           return _isExcludedFromFees[account];
1294      }              
1295 
1296      function updateMarketingWallet(address newMarketingWallet)
1297           external
1298           onlyOwner
1299      { 
1300           emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1301           marketingWallet = newMarketingWallet;
1302      }              
1303 
1304      function _transfer(
1305           address from,
1306           address to,
1307           uint256 amount
1308      ) internal override { 
1309           require(from != address(0), "ERC20: transfer from the zero address.");
1310           require(to != address(0), "ERC20: transfer to the zero address.");
1311 
1312           if (amount == 0) { 
1313                super._transfer(from, to, 0);
1314                return;
1315           }              
1316 
1317           if (limitsInEffect) { 
1318                if (
1319                     from != owner() &&
1320                     to != owner() &&
1321                     to != address(0) &&
1322                     to != address(0xdead) &&
1323                     !swapping
1324                ) { 
1325                     if (!tradingActive) { 
1326                          require(
1327                               _isExcludedFromFees[from] || _isExcludedFromFees[to],
1328                               "Trading is not active!"
1329                          );
1330                     }              
1331 
1332                     //  at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1333                     if (transferDelayEnabled) { 
1334                          if (
1335                               to != owner() &&
1336                               to != address(uniswapV2Router) &&
1337                               to != address(uniswapV2Pair)
1338                          ) { 
1339                               require(
1340                                    _holderLastTransferTimestamp[tx.origin] <
1341                                         block.number,
1342                                    "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed!"
1343                               );
1344                               _holderLastTransferTimestamp[tx.origin] = block.number;
1345                          }              
1346                     }              
1347 
1348                     //  when buy
1349                     if (
1350                          automatedMarketMakerPairs[from] &&
1351                          !_isExcludedMaxTransactionAmount[to]
1352                     ) { 
1353                          require(
1354                               amount <= maxTransactionAmount,
1355                               "Buy transfer amount exceeds the maxTransactionAmount!"
1356                          );
1357                          require(
1358                               amount + balanceOf(to) <= maxWallet,
1359                               "Max wallet exceeded."
1360                          );
1361                     }              
1362                     //  when sell
1363                     else if (
1364                          automatedMarketMakerPairs[to] &&
1365                          !_isExcludedMaxTransactionAmount[from]
1366                     ) { 
1367                          require(
1368                               amount <= maxTransactionAmount,
1369                               "Sell transfer amount exceeds the maxTransactionAmount!"
1370                          );
1371                     }               else if (!_isExcludedMaxTransactionAmount[to]) { 
1372                          require(
1373                               amount + balanceOf(to) <= maxWallet,
1374                               "Max wallet exceeded."
1375                          );
1376                     }              
1377                }              
1378           }              
1379 
1380           uint256 contractTokenBalance = balanceOf(address(this));
1381 
1382           bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1383 
1384           if (
1385                canSwap &&
1386                swapEnabled &&
1387                !swapping &&
1388                !automatedMarketMakerPairs[from] &&
1389                !_isExcludedFromFees[from] &&
1390                !_isExcludedFromFees[to]
1391           ) { 
1392                swapping = true;
1393 
1394                swapBack();
1395 
1396                swapping = false;
1397           }              
1398 
1399           if (
1400                !swapping &&
1401                automatedMarketMakerPairs[to] &&
1402                lpBurnEnabled &&
1403                block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1404                !_isExcludedFromFees[from]
1405           ) { 
1406                autoBurnLiquidityPairTokens();
1407           }              
1408 
1409           bool takeFee = !swapping;
1410 
1411           //  if any account belongs to _isExcludedFromFee account then remove the fee
1412           if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) { 
1413                takeFee = false;
1414           }              
1415 
1416           uint256 fees = 0;
1417           //  only take fees on buys/sells, do not take on wallet transfers
1418           if (takeFee) { 
1419                //  on sell
1420                if (automatedMarketMakerPairs[to] && sellTotalFees > 0) { 
1421                     fees = amount.mul(sellTotalFees).div(100);
1422                     tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1423                     tokensForDev += (fees * sellDevFee) / sellTotalFees;
1424                     tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1425                }              
1426                //  on buy
1427                else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) { 
1428                     fees = amount.mul(buyTotalFees).div(100);
1429                     tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1430                     tokensForDev += (fees * buyDevFee) / buyTotalFees;
1431                     tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1432                }              
1433 
1434                if (fees > 0) { 
1435                     super._transfer(from, address(this), fees);
1436                }              
1437 
1438                amount -= fees;
1439           }              
1440 
1441           super._transfer(from, to, amount);
1442      }              
1443 
1444      function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private { 
1445           //  approve token transfer to cover all possible scenarios
1446           _approve(address(this), address(uniswapV2Router), tokenAmount);
1447 
1448           //  add the liquidity
1449           uniswapV2Router.addLiquidityETH{value: ethAmount}              (
1450                address(this),
1451                tokenAmount,
1452                0, //  slippage is unavoidable
1453                0, //  slippage is unavoidable
1454                deadAddress,
1455                block.timestamp
1456           );
1457      }              
1458 
1459      function swapTokensForEth(uint256 tokenAmount) private { 
1460           //  generate the uniswap pair path of token -> weth
1461           address[] memory path = new address[](2);
1462           path[0] = address(this);
1463           path[1] = uniswapV2Router.WETH();
1464 
1465           _approve(address(this), address(uniswapV2Router), tokenAmount);
1466 
1467           //  make the swap
1468           uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1469                tokenAmount,
1470                0, //  accept any amount of ETH
1471                path,
1472                address(this),
1473                block.timestamp
1474           );
1475      }              
1476 
1477      function swapBack() private { 
1478           uint256 contractBalance = balanceOf(address(this));
1479           uint256 totalTokensToSwap = tokensForLiquidity +
1480                tokensForMarketing +
1481                tokensForDev;
1482           bool success;
1483 
1484           if (contractBalance == 0 || totalTokensToSwap == 0) { 
1485                return;
1486           }              
1487 
1488           if (contractBalance > swapTokensAtAmount * 20) { 
1489                contractBalance = swapTokensAtAmount * 20;
1490           }              
1491 
1492           //  Halve the amount of liquidity tokens
1493           uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1494                totalTokensToSwap /
1495                2;
1496           uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1497 
1498           uint256 initialETHBalance = address(this).balance;
1499 
1500           swapTokensForEth(amountToSwapForETH);
1501 
1502           uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1503 
1504           uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1505                totalTokensToSwap
1506           );
1507           uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1508 
1509           uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1510 
1511           tokensForLiquidity = 0;
1512           tokensForMarketing = 0;
1513           tokensForDev = 0;
1514 
1515           (success, ) = address(devWallet).call{value: ethForDev}              ("");
1516 
1517           if (liquidityTokens > 0 && ethForLiquidity > 0) { 
1518                addLiquidity(liquidityTokens, ethForLiquidity);
1519                emit SwapAndLiquify(
1520                     amountToSwapForETH,
1521                     ethForLiquidity,
1522                     tokensForLiquidity
1523                );
1524           }              
1525 
1526           (success, ) = address(marketingWallet).call{
1527                value: address(this).balance
1528           }              ("");
1529      }              
1530 
1531      function setAutoLPBurnSettings(
1532           uint256 _frequencyInSeconds,
1533           uint256 _percent,
1534           bool _Enabled
1535      ) external onlyOwner { 
1536           require(
1537                _frequencyInSeconds >= 600,
1538                "cannot set buyback more often than every 10 minutes"
1539           );
1540           require(
1541                _percent <= 1000 && _percent >= 0,
1542                "Must set auto LP burn percent between 0% and 10%"
1543           );
1544           lpBurnFrequency = _frequencyInSeconds;
1545           percentForLPBurn = _percent;
1546           lpBurnEnabled = _Enabled;
1547      }              
1548 
1549      function autoBurnLiquidityPairTokens() internal returns (bool) { 
1550           lastLpBurnTime = block.timestamp;
1551 
1552           //  get balance of liquidity pair
1553           uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1554 
1555           //  calculate amount to burn
1556           uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1557                10000
1558           );
1559 
1560           //  pull tokens from pancakePair liquidity and move to dead address permanently
1561           if (amountToBurn > 0) { 
1562                super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1563           }              
1564 
1565           //  sync price since this is not in a swap transaction!
1566           IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1567           pair.sync();
1568           emit AutoNukeLP();
1569           return true;
1570      }              
1571 
1572      function manualBurnLiquidityPairTokens(uint256 percent)
1573           external
1574           onlyOwner
1575           returns (bool)
1576      { 
1577           require(
1578                block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1579                "Must wait for cooldown to finish"
1580           );
1581           require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1582           lastManualLpBurnTime = block.timestamp;
1583 
1584           //  get balance of liquidity pair
1585           uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1586 
1587           //  calculate amount to burn
1588           uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1589 
1590           //  pull tokens from pancakePair liquidity and move to dead address permanently
1591           if (amountToBurn > 0) { 
1592                super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1593           }              
1594 
1595           //  sync price since this is not in a swap transaction!
1596           IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1597           pair.sync();
1598           emit ManualNukeLP();
1599           return true;
1600      }              
1601 }