1 // SPDX-License-Identifier: MIT
2 
3 
4 //https://t.me/Gamblers_Anonymous
5 
6 //https://twitter.com/GamblersAnoneth
7                                                                                                     
8  //                                             ..::                                                  
9  //                                           .!??JJJ!                                                
10  //                                          ~JJJJJY557!7??7^                                         
11  //                                     .:^^^~^~!?YY5YJJJJJY5?^.                                      
12  //                                 .^!7??JJ!!?. ~?Y7~!?JYY5PGJJ7^                                    
13  //                               .~?J??????7PG~^!?7~^ .~J55GGJJJY?^                                  
14  //                            :~?55?????????????J7GP.:!?5GGY?JJJYY7:                                
15  //                          ^!???YJ???????JJ??????JJ!!?YPPYJJJJJYYYY~                               
16  //                         .!????????????JY5GGY??????JJY5YJJJJJJJYYY55?.                             
17  //                        :??????????????????J????????JJJJJJJJJJJYYYY555~                            
18  //                       :?????????????????????????????JJJJJJJJJYYYY555PB!                           
19  //                       7????????????????????????????JJJYJJYYYYYY5555PG#G.                          
20  //                      :???????????????????????????JJJYYYYYYYYYJ???Y5G###!                          
21  //                      :J?????????????????????????JJJYY55YYY?!~~!7?JYP###J                          
22  //                      .?J????????????????????JJJJJYYY5PPYJ~^~!7?JY5PB#&&7                          
23  //                       ^YJJJ?????????????JJJJJJJYYY55PBP?~~~!7?Y5PGBB#&P.                          
24  //                        ~YYYJJJJJJJJJJJJJJYYYYYYYY5PGB#5~!!7?JY5PBBB#&&5.                          
25  //                         ^Y55YYYYYYYYYYYYYYYYYY55PGB##BJ7?JY5PGGBBB##&#&?                          
26  //                        ^??JY5PP555555555PPPPPGGBB##BGP55PGGBBBBBBG555G#G.                         
27  //                       ~J?????7?YPGGGGGBBBBBB###BBG5J7JPGBGGGGP5YYYYYYYPG?~~^:.                    
28  //                      ^JJ??J?^. .:^!7JY55555YY55YYJJJJYYYYJJJJJJJJ?JJYYYY5YJJJ?7^                  
29  //              .^^~~^:.?J????~...                 ..   ^JJJJJJJ??????J55YYY55YYJJY~                 
30  //            ^?Y555555YYJ????^..                        !JJJJJ??????JY55YYYY555YY5J                 
31  //          .~?!~!JYYY55YJJ??7^..                        :?JJJ??????JJYPP55YY55PPPGJ                 
32  //          !??77!~!JY55YJ????^...                        ~JJ??????JJY5G555555PPPPG7                 
33  //          !??????!!7JYJ???JJ~:..                        .7J?????JJY5GG555PPPGGGGP^                 
34  //          .7???????7?JJJJJJY!^:...                 ..:~!7??????JJY5PBPPPGGGBBBBBB7                 
35  //           :7???????YY5YJJY57^^::.....      ......^!7???J???JJJJY5PGGGGBBGGGBB#B#J                 
36  //            .~??????YGPYYYPBJ~^^::.....:::::::::^7???????JJJJJY5PGGGGGG5YJ?JY5GB#?                 
37  //              :!?????5PPGBBB57!~^^:.:::::::^^^^!?????JJJJYYY55PGGGPG5J???JJY55PBG:                 
38  //               .??????7J5P55PP?!~~^^:^^^^^^^^^!?????JJY5PP5YY555Y5P5J?JJYYY55PG5:                  
39  //                ^????????Y5PG#GY?7!!~~~~~~~~~!??JJJJJY5P5?77!!7JY55555YYYYY5PGBJ                   
40  //                 ^7?????Y5PB#7:.^?YJ?77777777JJJY5JJY55Y?777!!~~!?Y55PP5Y5PGB##~                   
41  //                  .!7???YGG5!     ~J55YYJJJJJJ555PG555Y?????????77?5PPPGGB####Y                    
42  //                    .:~~^:.         :7YPGGGPPPPGBB#BBBY????????????YPGB######Y.                    
43  //                                       :!?YPGBBBB#####GJ???????????YGB##&#B5~                      
44  //                                            .::^^~~~~~?J????????????G#&#?~:                        
45  //                                                      7????????????YB#P!                           
46  //                                                     ~?????????JYP#B^                             
47  //                                                       ^7????????5BB!                              
48  //                                                         :!7??????7.                               
49  //                                                            .:::.                                 
50 
51 
52 pragma solidity 0.8.17;
53 pragma experimental ABIEncoderV2;
54 
55 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
56 
57 // pragma solidity ^0.8.0;
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
79 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
80 
81 // pragma solidity ^0.8.0;
82 
83 // import "../utils/Context.sol";
84 
85 /**
86  * @dev Contract module which provides a basic access control mechanism, where
87  * there is an account (an owner) that can be granted exclusive access to
88  * specific functions.
89  *
90  * By default, the owner account will be the one that deploys the contract. This
91  * can later be changed with {transferOwnership}.
92  *
93  * This module is used through inheritance. It will make available the modifier
94  * `onlyOwner`, which can be applied to your functions to restrict their use to
95  * the owner.
96  */
97 abstract contract Ownable is Context {
98     address private _owner;
99 
100     event OwnershipTransferred(
101         address indexed previousOwner,
102         address indexed newOwner
103     );
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor() {
109         _transferOwnership(_msgSender());
110     }
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115     modifier onlyOwner() {
116         _checkOwner();
117         _;
118     }
119 
120     /**
121      * @dev Returns the address of the current owner.
122      */
123     function owner() public view virtual returns (address) {
124         return _owner;
125     }
126 
127     /**
128      * @dev Throws if the sender is not the owner.
129      */
130     function _checkOwner() internal view virtual {
131         require(owner() == _msgSender(), "Ownable: caller is not the owner");
132     }
133 
134     /**
135      * @dev Leaves the contract without owner. It will not be possible to call
136      * `onlyOwner` functions. Can only be called by the current owner.
137      *
138      * NOTE: Renouncing ownership will leave the contract without an owner,
139      * thereby disabling any functionality that is only available to the owner.
140      */
141     function renounceOwnership() public virtual onlyOwner {
142         _transferOwnership(address(0));
143     }
144 
145     /**
146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
147      * Can only be called by the current owner.
148      */
149     function transferOwnership(address newOwner) public virtual onlyOwner {
150         require(
151             newOwner != address(0),
152             "Ownable: new owner is the zero address"
153         );
154         _transferOwnership(newOwner);
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Internal function without access restriction.
160      */
161     function _transferOwnership(address newOwner) internal virtual {
162         address oldOwner = _owner;
163         _owner = newOwner;
164         emit OwnershipTransferred(oldOwner, newOwner);
165     }
166 }
167 
168 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
169 
170 // pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Interface of the ERC20 standard as defined in the EIP.
174  */
175 interface IERC20 {
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(
189         address indexed owner,
190         address indexed spender,
191         uint256 value
192     );
193 
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `to`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transfer(address to, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through {transferFrom}. This is
216      * zero by default.
217      *
218      * This value changes when {approve} or {transferFrom} are called.
219      */
220     function allowance(address owner, address spender)
221         external
222         view
223         returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `from` to `to` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(
251         address from,
252         address to,
253         uint256 amount
254     ) external returns (bool);
255 }
256 
257 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
258 
259 // pragma solidity ^0.8.0;
260 
261 // import "../IERC20.sol";
262 
263 /**
264  * @dev Interface for the optional metadata functions from the ERC20 standard.
265  *
266  * _Available since v4.1._
267  */
268 interface IERC20Metadata is IERC20 {
269     /**
270      * @dev Returns the name of the token.
271      */
272     function name() external view returns (string memory);
273 
274     /**
275      * @dev Returns the symbol of the token.
276      */
277     function symbol() external view returns (string memory);
278 
279     /**
280      * @dev Returns the decimals places of the token.
281      */
282     function decimals() external view returns (uint8);
283 }
284 
285 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
286 
287 // pragma solidity ^0.8.0;
288 
289 // import "./IERC20.sol";
290 // import "./extensions/IERC20Metadata.sol";
291 // import "../../utils/Context.sol";
292 
293 /**
294  * @dev Implementation of the {IERC20} interface.
295  *
296  * This implementation is agnostic to the way tokens are created. This means
297  * that a supply mechanism has to be added in a derived contract using {_mint}.
298  * For a generic mechanism see {ERC20PresetMinterPauser}.
299  *
300  * TIP: For a detailed writeup see our guide
301  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
302  * to implement supply mechanisms].
303  *
304  * The default value of {decimals} is 18. To change this, you should override
305  * this function so it returns a different value.
306  *
307  * We have followed general OpenZeppelin Contracts guidelines: functions revert
308  * instead returning `false` on failure. This behavior is nonetheless
309  * conventional and does not conflict with the expectations of ERC20
310  * applications.
311  *
312  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
313  * This allows applications to reconstruct the allowance for all accounts just
314  * by listening to said events. Other implementations of the EIP may not emit
315  * these events, as it isn't required by the specification.
316  *
317  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
318  * functions have been added to mitigate the well-known issues around setting
319  * allowances. See {IERC20-approve}.
320  */
321 contract ERC20 is Context, IERC20, IERC20Metadata {
322     mapping(address => uint256) private _balances;
323 
324     mapping(address => mapping(address => uint256)) private _allowances;
325 
326     uint256 private _totalSupply;
327 
328     string private _name;
329     string private _symbol;
330 
331     /**
332      * @dev Sets the values for {name} and {symbol}.
333      *
334      * All two of these values are immutable: they can only be set once during
335      * construction.
336      */
337     constructor(string memory name_, string memory symbol_) {
338         _name = name_;
339         _symbol = symbol_;
340     }
341 
342     /**
343      * @dev Returns the name of the token.
344      */
345     function name() public view virtual override returns (string memory) {
346         return _name;
347     }
348 
349     /**
350      * @dev Returns the symbol of the token, usually a shorter version of the
351      * name.
352      */
353     function symbol() public view virtual override returns (string memory) {
354         return _symbol;
355     }
356 
357     /**
358      * @dev Returns the number of decimals used to get its user representation.
359      * For example, if `decimals` equals `2`, a balance of `505` tokens should
360      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
361      *
362      * Tokens usually opt for a value of 18, imitating the relationship between
363      * Ether and Wei. This is the default value returned by this function, unless
364      * it's overridden.
365      *
366      * NOTE: This information is only used for _display_ purposes: it in
367      * no way affects any of the arithmetic of the contract, including
368      * {IERC20-balanceOf} and {IERC20-transfer}.
369      */
370     function decimals() public view virtual override returns (uint8) {
371         return 18;
372     }
373 
374     /**
375      * @dev See {IERC20-totalSupply}.
376      */
377     function totalSupply() public view virtual override returns (uint256) {
378         return _totalSupply;
379     }
380 
381     /**
382      * @dev See {IERC20-balanceOf}.
383      */
384     function balanceOf(address account)
385         public
386         view
387         virtual
388         override
389         returns (uint256)
390     {
391         return _balances[account];
392     }
393 
394     /**
395      * @dev See {IERC20-transfer}.
396      *
397      * Requirements:
398      *
399      * - `to` cannot be the zero address.
400      * - the caller must have a balance of at least `amount`.
401      */
402     function transfer(address to, uint256 amount)
403         public
404         virtual
405         override
406         returns (bool)
407     {
408         address owner = _msgSender();
409         _transfer(owner, to, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-allowance}.
415      */
416     function allowance(address owner, address spender)
417         public
418         view
419         virtual
420         override
421         returns (uint256)
422     {
423         return _allowances[owner][spender];
424     }
425 
426     /**
427      * @dev See {IERC20-approve}.
428      *
429      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
430      * `transferFrom`. This is semantically equivalent to an infinite approval.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount)
437         public
438         virtual
439         override
440         returns (bool)
441     {
442         address owner = _msgSender();
443         _approve(owner, spender, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-transferFrom}.
449      *
450      * Emits an {Approval} event indicating the updated allowance. This is not
451      * required by the EIP. See the note at the beginning of {ERC20}.
452      *
453      * NOTE: Does not update the allowance if the current allowance
454      * is the maximum `uint256`.
455      *
456      * Requirements:
457      *
458      * - `from` and `to` cannot be the zero address.
459      * - `from` must have a balance of at least `amount`.
460      * - the caller must have allowance for ``from``'s tokens of at least
461      * `amount`.
462      */
463     function transferFrom(
464         address from,
465         address to,
466         uint256 amount
467     ) public virtual override returns (bool) {
468         address spender = _msgSender();
469         _spendAllowance(from, spender, amount);
470         _transfer(from, to, amount);
471         return true;
472     }
473 
474     /**
475      * @dev Atomically increases the allowance granted to `spender` by the caller.
476      *
477      * This is an alternative to {approve} that can be used as a mitigation for
478      * problems described in {IERC20-approve}.
479      *
480      * Emits an {Approval} event indicating the updated allowance.
481      *
482      * Requirements:
483      *
484      * - `spender` cannot be the zero address.
485      */
486     function increaseAllowance(address spender, uint256 addedValue)
487         public
488         virtual
489         returns (bool)
490     {
491         address owner = _msgSender();
492         _approve(owner, spender, allowance(owner, spender) + addedValue);
493         return true;
494     }
495 
496     /**
497      * @dev Atomically decreases the allowance granted to `spender` by the caller.
498      *
499      * This is an alternative to {approve} that can be used as a mitigation for
500      * problems described in {IERC20-approve}.
501      *
502      * Emits an {Approval} event indicating the updated allowance.
503      *
504      * Requirements:
505      *
506      * - `spender` cannot be the zero address.
507      * - `spender` must have allowance for the caller of at least
508      * `subtractedValue`.
509      */
510     function decreaseAllowance(address spender, uint256 subtractedValue)
511         public
512         virtual
513         returns (bool)
514     {
515         address owner = _msgSender();
516         uint256 currentAllowance = allowance(owner, spender);
517         require(
518             currentAllowance >= subtractedValue,
519             "ERC20: decreased allowance below zero"
520         );
521         unchecked {
522             _approve(owner, spender, currentAllowance - subtractedValue);
523         }
524 
525         return true;
526     }
527 
528     /**
529      * @dev Moves `amount` of tokens from `from` to `to`.
530      *
531      * This internal function is equivalent to {transfer}, and can be used to
532      * e.g. implement automatic token fees, slashing mechanisms, etc.
533      *
534      * Emits a {Transfer} event.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `from` must have a balance of at least `amount`.
541      */
542     function _transfer(
543         address from,
544         address to,
545         uint256 amount
546     ) internal virtual {
547         require(from != address(0), "ERC20: transfer from the zero address");
548         require(to != address(0), "ERC20: transfer to the zero address");
549 
550         _beforeTokenTransfer(from, to, amount);
551 
552         uint256 fromBalance = _balances[from];
553         require(
554             fromBalance >= amount,
555             "ERC20: transfer amount exceeds balance"
556         );
557         unchecked {
558             _balances[from] = fromBalance - amount;
559             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
560             // decrementing then incrementing.
561             _balances[to] += amount;
562         }
563 
564         emit Transfer(from, to, amount);
565 
566         _afterTokenTransfer(from, to, amount);
567     }
568 
569     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
570      * the total supply.
571      *
572      * Emits a {Transfer} event with `from` set to the zero address.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      */
578     function _mint(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: mint to the zero address");
580 
581         _beforeTokenTransfer(address(0), account, amount);
582 
583         _totalSupply += amount;
584         unchecked {
585             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
586             _balances[account] += amount;
587         }
588         emit Transfer(address(0), account, amount);
589 
590         _afterTokenTransfer(address(0), account, amount);
591     }
592 
593     /**
594      * @dev Destroys `amount` tokens from `account`, reducing the
595      * total supply.
596      *
597      * Emits a {Transfer} event with `to` set to the zero address.
598      *
599      * Requirements:
600      *
601      * - `account` cannot be the zero address.
602      * - `account` must have at least `amount` tokens.
603      */
604     function _burn(address account, uint256 amount) internal virtual {
605         require(account != address(0), "ERC20: burn from the zero address");
606 
607         _beforeTokenTransfer(account, address(0), amount);
608 
609         uint256 accountBalance = _balances[account];
610         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
611         unchecked {
612             _balances[account] = accountBalance - amount;
613             // Overflow not possible: amount <= accountBalance <= totalSupply.
614             _totalSupply -= amount;
615         }
616 
617         emit Transfer(account, address(0), amount);
618 
619         _afterTokenTransfer(account, address(0), amount);
620     }
621 
622     /**
623      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
624      *
625      * This internal function is equivalent to `approve`, and can be used to
626      * e.g. set automatic allowances for certain subsystems, etc.
627      *
628      * Emits an {Approval} event.
629      *
630      * Requirements:
631      *
632      * - `owner` cannot be the zero address.
633      * - `spender` cannot be the zero address.
634      */
635     function _approve(
636         address owner,
637         address spender,
638         uint256 amount
639     ) internal virtual {
640         require(owner != address(0), "ERC20: approve from the zero address");
641         require(spender != address(0), "ERC20: approve to the zero address");
642 
643         _allowances[owner][spender] = amount;
644         emit Approval(owner, spender, amount);
645     }
646 
647     /**
648      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
649      *
650      * Does not update the allowance amount in case of infinite allowance.
651      * Revert if not enough allowance is available.
652      *
653      * Might emit an {Approval} event.
654      */
655     function _spendAllowance(
656         address owner,
657         address spender,
658         uint256 amount
659     ) internal virtual {
660         uint256 currentAllowance = allowance(owner, spender);
661         if (currentAllowance != type(uint256).max) {
662             require(
663                 currentAllowance >= amount,
664                 "ERC20: insufficient allowance"
665             );
666             unchecked {
667                 _approve(owner, spender, currentAllowance - amount);
668             }
669         }
670     }
671 
672     /**
673      * @dev Hook that is called before any transfer of tokens. This includes
674      * minting and burning.
675      *
676      * Calling conditions:
677      *
678      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
679      * will be transferred to `to`.
680      * - when `from` is zero, `amount` tokens will be minted for `to`.
681      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
682      * - `from` and `to` are never both zero.
683      *
684      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
685      */
686     function _beforeTokenTransfer(
687         address from,
688         address to,
689         uint256 amount
690     ) internal virtual {}
691 
692     /**
693      * @dev Hook that is called after any transfer of tokens. This includes
694      * minting and burning.
695      *
696      * Calling conditions:
697      *
698      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
699      * has been transferred to `to`.
700      * - when `from` is zero, `amount` tokens have been minted for `to`.
701      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
702      * - `from` and `to` are never both zero.
703      *
704      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
705      */
706     function _afterTokenTransfer(
707         address from,
708         address to,
709         uint256 amount
710     ) internal virtual {}
711 }
712 
713 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
714 
715 // pragma solidity ^0.8.0;
716 
717 // CAUTION
718 // This version of SafeMath should only be used with Solidity 0.8 or later,
719 // because it relies on the compiler's built in overflow checks.
720 
721 /**
722  * @dev Wrappers over Solidity's arithmetic operations.
723  *
724  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
725  * now has built in overflow checking.
726  */
727 library SafeMath {
728     /**
729      * @dev Returns the addition of two unsigned integers, with an overflow flag.
730      *
731      * _Available since v3.4._
732      */
733     function tryAdd(uint256 a, uint256 b)
734         internal
735         pure
736         returns (bool, uint256)
737     {
738         unchecked {
739             uint256 c = a + b;
740             if (c < a) return (false, 0);
741             return (true, c);
742         }
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
747      *
748      * _Available since v3.4._
749      */
750     function trySub(uint256 a, uint256 b)
751         internal
752         pure
753         returns (bool, uint256)
754     {
755         unchecked {
756             if (b > a) return (false, 0);
757             return (true, a - b);
758         }
759     }
760 
761     /**
762      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
763      *
764      * _Available since v3.4._
765      */
766     function tryMul(uint256 a, uint256 b)
767         internal
768         pure
769         returns (bool, uint256)
770     {
771         unchecked {
772             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
773             // benefit is lost if 'b' is also tested.
774             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
775             if (a == 0) return (true, 0);
776             uint256 c = a * b;
777             if (c / a != b) return (false, 0);
778             return (true, c);
779         }
780     }
781 
782     /**
783      * @dev Returns the division of two unsigned integers, with a division by zero flag.
784      *
785      * _Available since v3.4._
786      */
787     function tryDiv(uint256 a, uint256 b)
788         internal
789         pure
790         returns (bool, uint256)
791     {
792         unchecked {
793             if (b == 0) return (false, 0);
794             return (true, a / b);
795         }
796     }
797 
798     /**
799      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
800      *
801      * _Available since v3.4._
802      */
803     function tryMod(uint256 a, uint256 b)
804         internal
805         pure
806         returns (bool, uint256)
807     {
808         unchecked {
809             if (b == 0) return (false, 0);
810             return (true, a % b);
811         }
812     }
813 
814     /**
815      * @dev Returns the addition of two unsigned integers, reverting on
816      * overflow.
817      *
818      * Counterpart to Solidity's `+` operator.
819      *
820      * Requirements:
821      *
822      * - Addition cannot overflow.
823      */
824     function add(uint256 a, uint256 b) internal pure returns (uint256) {
825         return a + b;
826     }
827 
828     /**
829      * @dev Returns the subtraction of two unsigned integers, reverting on
830      * overflow (when the result is negative).
831      *
832      * Counterpart to Solidity's `-` operator.
833      *
834      * Requirements:
835      *
836      * - Subtraction cannot overflow.
837      */
838     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
839         return a - b;
840     }
841 
842     /**
843      * @dev Returns the multiplication of two unsigned integers, reverting on
844      * overflow.
845      *
846      * Counterpart to Solidity's `*` operator.
847      *
848      * Requirements:
849      *
850      * - Multiplication cannot overflow.
851      */
852     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
853         return a * b;
854     }
855 
856     /**
857      * @dev Returns the integer division of two unsigned integers, reverting on
858      * division by zero. The result is rounded towards zero.
859      *
860      * Counterpart to Solidity's `/` operator.
861      *
862      * Requirements:
863      *
864      * - The divisor cannot be zero.
865      */
866     function div(uint256 a, uint256 b) internal pure returns (uint256) {
867         return a / b;
868     }
869 
870     /**
871      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
872      * reverting when dividing by zero.
873      *
874      * Counterpart to Solidity's `%` operator. This function uses a `revert`
875      * opcode (which leaves remaining gas untouched) while Solidity uses an
876      * invalid opcode to revert (consuming all remaining gas).
877      *
878      * Requirements:
879      *
880      * - The divisor cannot be zero.
881      */
882     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
883         return a % b;
884     }
885 
886     /**
887      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
888      * overflow (when the result is negative).
889      *
890      * CAUTION: This function is deprecated because it requires allocating memory for the error
891      * message unnecessarily. For custom revert reasons use {trySub}.
892      *
893      * Counterpart to Solidity's `-` operator.
894      *
895      * Requirements:
896      *
897      * - Subtraction cannot overflow.
898      */
899     function sub(
900         uint256 a,
901         uint256 b,
902         string memory errorMessage
903     ) internal pure returns (uint256) {
904         unchecked {
905             require(b <= a, errorMessage);
906             return a - b;
907         }
908     }
909 
910     /**
911      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
912      * division by zero. The result is rounded towards zero.
913      *
914      * Counterpart to Solidity's `/` operator. Note: this function uses a
915      * `revert` opcode (which leaves remaining gas untouched) while Solidity
916      * uses an invalid opcode to revert (consuming all remaining gas).
917      *
918      * Requirements:
919      *
920      * - The divisor cannot be zero.
921      */
922     function div(
923         uint256 a,
924         uint256 b,
925         string memory errorMessage
926     ) internal pure returns (uint256) {
927         unchecked {
928             require(b > 0, errorMessage);
929             return a / b;
930         }
931     }
932 
933     /**
934      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
935      * reverting with custom message when dividing by zero.
936      *
937      * CAUTION: This function is deprecated because it requires allocating memory for the error
938      * message unnecessarily. For custom revert reasons use {tryMod}.
939      *
940      * Counterpart to Solidity's `%` operator. This function uses a `revert`
941      * opcode (which leaves remaining gas untouched) while Solidity uses an
942      * invalid opcode to revert (consuming all remaining gas).
943      *
944      * Requirements:
945      *
946      * - The divisor cannot be zero.
947      */
948     function mod(
949         uint256 a,
950         uint256 b,
951         string memory errorMessage
952     ) internal pure returns (uint256) {
953         unchecked {
954             require(b > 0, errorMessage);
955             return a % b;
956         }
957     }
958 }
959 
960 // pragma solidity >=0.5.0;
961 
962 interface IUniswapV2Factory {
963     event PairCreated(
964         address indexed token0,
965         address indexed token1,
966         address pair,
967         uint256
968     );
969 
970     function feeTo() external view returns (address);
971 
972     function feeToSetter() external view returns (address);
973 
974     function getPair(address tokenA, address tokenB)
975         external
976         view
977         returns (address pair);
978 
979     function allPairs(uint256) external view returns (address pair);
980 
981     function allPairsLength() external view returns (uint256);
982 
983     function createPair(address tokenA, address tokenB)
984         external
985         returns (address pair);
986 
987     function setFeeTo(address) external;
988 
989     function setFeeToSetter(address) external;
990 }
991 
992 // pragma solidity >=0.6.2;
993 
994 interface IUniswapV2Router01 {
995     function factory() external pure returns (address);
996 
997     function WETH() external pure returns (address);
998 
999     function addLiquidity(
1000         address tokenA,
1001         address tokenB,
1002         uint256 amountADesired,
1003         uint256 amountBDesired,
1004         uint256 amountAMin,
1005         uint256 amountBMin,
1006         address to,
1007         uint256 deadline
1008     )
1009         external
1010         returns (
1011             uint256 amountA,
1012             uint256 amountB,
1013             uint256 liquidity
1014         );
1015 
1016     function addLiquidityETH(
1017         address token,
1018         uint256 amountTokenDesired,
1019         uint256 amountTokenMin,
1020         uint256 amountETHMin,
1021         address to,
1022         uint256 deadline
1023     )
1024         external
1025         payable
1026         returns (
1027             uint256 amountToken,
1028             uint256 amountETH,
1029             uint256 liquidity
1030         );
1031 
1032     function removeLiquidity(
1033         address tokenA,
1034         address tokenB,
1035         uint256 liquidity,
1036         uint256 amountAMin,
1037         uint256 amountBMin,
1038         address to,
1039         uint256 deadline
1040     ) external returns (uint256 amountA, uint256 amountB);
1041 
1042     function removeLiquidityETH(
1043         address token,
1044         uint256 liquidity,
1045         uint256 amountTokenMin,
1046         uint256 amountETHMin,
1047         address to,
1048         uint256 deadline
1049     ) external returns (uint256 amountToken, uint256 amountETH);
1050 
1051     function removeLiquidityWithPermit(
1052         address tokenA,
1053         address tokenB,
1054         uint256 liquidity,
1055         uint256 amountAMin,
1056         uint256 amountBMin,
1057         address to,
1058         uint256 deadline,
1059         bool approveMax,
1060         uint8 v,
1061         bytes32 r,
1062         bytes32 s
1063     ) external returns (uint256 amountA, uint256 amountB);
1064 
1065     function removeLiquidityETHWithPermit(
1066         address token,
1067         uint256 liquidity,
1068         uint256 amountTokenMin,
1069         uint256 amountETHMin,
1070         address to,
1071         uint256 deadline,
1072         bool approveMax,
1073         uint8 v,
1074         bytes32 r,
1075         bytes32 s
1076     ) external returns (uint256 amountToken, uint256 amountETH);
1077 
1078     function swapExactTokensForTokens(
1079         uint256 amountIn,
1080         uint256 amountOutMin,
1081         address[] calldata path,
1082         address to,
1083         uint256 deadline
1084     ) external returns (uint256[] memory amounts);
1085 
1086     function swapTokensForExactTokens(
1087         uint256 amountOut,
1088         uint256 amountInMax,
1089         address[] calldata path,
1090         address to,
1091         uint256 deadline
1092     ) external returns (uint256[] memory amounts);
1093 
1094     function swapExactETHForTokens(
1095         uint256 amountOutMin,
1096         address[] calldata path,
1097         address to,
1098         uint256 deadline
1099     ) external payable returns (uint256[] memory amounts);
1100 
1101     function swapTokensForExactETH(
1102         uint256 amountOut,
1103         uint256 amountInMax,
1104         address[] calldata path,
1105         address to,
1106         uint256 deadline
1107     ) external returns (uint256[] memory amounts);
1108 
1109     function swapExactTokensForETH(
1110         uint256 amountIn,
1111         uint256 amountOutMin,
1112         address[] calldata path,
1113         address to,
1114         uint256 deadline
1115     ) external returns (uint256[] memory amounts);
1116 
1117     function swapETHForExactTokens(
1118         uint256 amountOut,
1119         address[] calldata path,
1120         address to,
1121         uint256 deadline
1122     ) external payable returns (uint256[] memory amounts);
1123 
1124     function quote(
1125         uint256 amountA,
1126         uint256 reserveA,
1127         uint256 reserveB
1128     ) external pure returns (uint256 amountB);
1129 
1130     function getAmountOut(
1131         uint256 amountIn,
1132         uint256 reserveIn,
1133         uint256 reserveOut
1134     ) external pure returns (uint256 amountOut);
1135 
1136     function getAmountIn(
1137         uint256 amountOut,
1138         uint256 reserveIn,
1139         uint256 reserveOut
1140     ) external pure returns (uint256 amountIn);
1141 
1142     function getAmountsOut(uint256 amountIn, address[] calldata path)
1143         external
1144         view
1145         returns (uint256[] memory amounts);
1146 
1147     function getAmountsIn(uint256 amountOut, address[] calldata path)
1148         external
1149         view
1150         returns (uint256[] memory amounts);
1151 }
1152 
1153 // pragma solidity >=0.6.2;
1154 
1155 // import './IUniswapV2Router01.sol';
1156 
1157 interface IUniswapV2Router02 is IUniswapV2Router01 {
1158     function removeLiquidityETHSupportingFeeOnTransferTokens(
1159         address token,
1160         uint256 liquidity,
1161         uint256 amountTokenMin,
1162         uint256 amountETHMin,
1163         address to,
1164         uint256 deadline
1165     ) external returns (uint256 amountETH);
1166 
1167     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1168         address token,
1169         uint256 liquidity,
1170         uint256 amountTokenMin,
1171         uint256 amountETHMin,
1172         address to,
1173         uint256 deadline,
1174         bool approveMax,
1175         uint8 v,
1176         bytes32 r,
1177         bytes32 s
1178     ) external returns (uint256 amountETH);
1179 
1180     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1181         uint256 amountIn,
1182         uint256 amountOutMin,
1183         address[] calldata path,
1184         address to,
1185         uint256 deadline
1186     ) external;
1187 
1188     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1189         uint256 amountOutMin,
1190         address[] calldata path,
1191         address to,
1192         uint256 deadline
1193     ) external payable;
1194 
1195     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1196         uint256 amountIn,
1197         uint256 amountOutMin,
1198         address[] calldata path,
1199         address to,
1200         uint256 deadline
1201     ) external;
1202 }
1203 
1204 contract GamblersAnonymous is ERC20, Ownable {
1205     using SafeMath for uint256;
1206 
1207     IUniswapV2Router02 public immutable uniswapV2Router;
1208     address public uniswapV2Pair;
1209     address public constant deadAddress = address(0xdead);
1210 
1211     bool private swapping;
1212 
1213     address public marketingWallet;
1214     address public developmentWallet;
1215     address public liquidityWallet;
1216 
1217     uint256 public maxTransactionAmount;
1218     uint256 public swapTokensAtAmount;
1219     uint256 public maxWallet;
1220 
1221     
1222     uint256 public tradingBlock;
1223 
1224     bool public tradingActive = false;
1225     bool public swapEnabled = false;
1226 
1227     uint256 public buyTotalFees;
1228     uint256 private buyMarketingFee;
1229     uint256 private buyDevelopmentFee;
1230     uint256 private buyLiquidityFee;
1231 
1232     uint256 public sellTotalFees;
1233     uint256 private sellMarketingFee;
1234     uint256 private sellDevelopmentFee;
1235     uint256 private sellLiquidityFee;
1236 
1237     uint256 private tokensForMarketing;
1238     uint256 private tokensForDevelopment;
1239     uint256 private tokensForLiquidity;
1240     uint256 private previousFee;
1241 
1242     mapping(address => bool) private _isExcludedFromFees;
1243     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1244     mapping(address => bool) private automatedMarketMakerPairs;
1245 
1246     event ExcludeFromFees(address indexed account, bool isExcluded);
1247 
1248     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1249 
1250     event marketingWalletUpdated(
1251         address indexed newWallet,
1252         address indexed oldWallet
1253     );
1254     
1255     event developmentWalletUpdated(
1256         address indexed newWallet,
1257         address indexed oldWallet
1258     );
1259     
1260     event liquidityWalletUpdated(
1261         address indexed newWallet,
1262         address indexed oldWallet
1263     );
1264 
1265     event SwapAndLiquify(
1266         uint256 tokensSwapped,
1267         uint256 ethReceived,
1268         uint256 tokensIntoLiquidity
1269     );
1270 
1271     constructor() ERC20("Gamblers Anonymous", "GA") {
1272         uniswapV2Router = IUniswapV2Router02(
1273             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1274         );
1275         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1276 
1277         uint256 totalSupply = 420_690_000_000 ether;
1278 
1279         maxTransactionAmount = (totalSupply * 3) / 100;
1280         maxWallet = (totalSupply * 3) / 100;
1281         swapTokensAtAmount = (totalSupply * 5) / 10000;
1282 
1283         buyMarketingFee = 1;
1284         buyDevelopmentFee = 1;
1285         buyLiquidityFee = 1;
1286         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1287 
1288         sellMarketingFee = 1;
1289         sellDevelopmentFee = 1;
1290         sellLiquidityFee = 1;
1291         sellTotalFees = sellMarketingFee + sellDevelopmentFee + sellLiquidityFee;
1292 
1293         previousFee = sellTotalFees;
1294 
1295         marketingWallet = owner();
1296         developmentWallet = (0xEc7600e4af983D3096d273ebbA18af354014130c);
1297         liquidityWallet = owner();
1298 
1299         excludeFromFees(owner(), true);
1300         excludeFromFees(address(this), true);
1301         excludeFromFees(deadAddress, true);
1302         excludeFromFees(marketingWallet, true);
1303         excludeFromFees(developmentWallet, true);
1304         excludeFromFees(liquidityWallet, true);
1305 
1306         excludeFromMaxTransaction(owner(), true);
1307         excludeFromMaxTransaction(address(this), true);
1308         excludeFromMaxTransaction(deadAddress, true);
1309         excludeFromMaxTransaction(address(uniswapV2Router), true);
1310         excludeFromMaxTransaction(marketingWallet, true);
1311         excludeFromMaxTransaction(developmentWallet, true);
1312         excludeFromMaxTransaction(liquidityWallet, true);
1313 
1314         _mint(msg.sender, totalSupply);
1315     }
1316 
1317     receive() external payable {}
1318 
1319     function burn(uint256 amount) external {
1320         _burn(msg.sender, amount);
1321     }
1322 
1323     function HelloMyNameisBobAndIamAGamblingAddict() external onlyOwner {
1324         require(!tradingActive, "Trading already active.");
1325 
1326         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1327             address(this),
1328             uniswapV2Router.WETH()
1329         );
1330         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1331         IERC20(uniswapV2Pair).approve(
1332             address(uniswapV2Router),
1333             type(uint256).max
1334         );
1335 
1336         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1337         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1338 
1339         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1340             address(this),
1341             balanceOf(address(this)),
1342             0,
1343             0,
1344             owner(),
1345             block.timestamp
1346         );
1347         tradingActive = true;
1348         swapEnabled = true;
1349         tradingBlock = block.number;
1350     }
1351 
1352     function updateSwapTokensAtAmount(uint256 newAmount)
1353         external
1354         onlyOwner
1355         returns (bool)
1356     {
1357         require(
1358             newAmount >= (totalSupply() * 1) / 100000,
1359             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1360         );
1361         require(
1362             newAmount <= (totalSupply() * 5) / 1000,
1363             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1364         );
1365         swapTokensAtAmount = newAmount;
1366         return true;
1367     }
1368 
1369     function updateMaxWalletAndTxnAmount(
1370         uint256 newTxnNum,
1371         uint256 newMaxWalletNum
1372     ) external onlyOwner {
1373         require(
1374             newTxnNum >= ((totalSupply() * 5) / 1000),
1375             "ERC20: Cannot set maxTxn lower than 0.5%"
1376         );
1377         require(
1378             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1379             "ERC20: Cannot set maxWallet lower than 0.5%"
1380         );
1381         maxWallet = newMaxWalletNum;
1382         maxTransactionAmount = newTxnNum;
1383     }
1384 
1385     function excludeFromMaxTransaction(address updAds, bool isEx)
1386         public
1387         onlyOwner
1388     {
1389         _isExcludedMaxTransactionAmount[updAds] = isEx;
1390     }
1391 
1392     function updateBuyFees(uint256 _marketingFee, uint256 _developmentFee, uint256 _liquidityFee)
1393         external
1394         onlyOwner
1395     {
1396         buyMarketingFee = _marketingFee;
1397         buyDevelopmentFee = _developmentFee;
1398         buyLiquidityFee = _liquidityFee;
1399         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1400         require(buyTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1401     }
1402 
1403     function updateSellFees(uint256 _marketingFee, uint256 _developmentFee, uint256 _liquidityFee)
1404         external
1405         onlyOwner
1406     {
1407         sellMarketingFee = _marketingFee;
1408         sellDevelopmentFee = _developmentFee;
1409         sellLiquidityFee = _liquidityFee;
1410         sellTotalFees = sellMarketingFee + sellDevelopmentFee + sellLiquidityFee;
1411         previousFee = sellTotalFees;
1412         require(sellTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1413     }
1414 
1415     function updateMarketingWallet(address _marketingWallet)
1416         external
1417         onlyOwner
1418     {
1419         require(_marketingWallet != address(0), "ERC20: Address 0");
1420         address oldWallet = marketingWallet;
1421         marketingWallet = _marketingWallet;
1422         emit marketingWalletUpdated(marketingWallet, oldWallet);
1423     }
1424 
1425     function updateDevelopmentWallet(address _developmentWallet)
1426         external
1427         onlyOwner
1428     {
1429         require(_developmentWallet != address(0), "ERC20: Address 0");
1430         address oldWallet = developmentWallet;
1431         developmentWallet = _developmentWallet;
1432         emit developmentWalletUpdated(developmentWallet, oldWallet);
1433     }
1434 
1435     function updateLiquidityWallet(address _liquidityWallet)
1436         external
1437         onlyOwner
1438     {
1439         require(_liquidityWallet != address(0), "ERC20: Address 0");
1440         address oldWallet = liquidityWallet;
1441         liquidityWallet = _liquidityWallet;
1442         emit liquidityWalletUpdated(liquidityWallet, oldWallet);
1443     }
1444 
1445     function excludeFromFees(address account, bool excluded) public onlyOwner {
1446         _isExcludedFromFees[account] = excluded;
1447         emit ExcludeFromFees(account, excluded);
1448     }
1449 
1450     function withdrawStuckETH() public onlyOwner {
1451         bool success;
1452         (success, ) = address(msg.sender).call{value: address(this).balance}(
1453             ""
1454         );
1455     }
1456 
1457     function withdrawStuckTokens(address tkn) public onlyOwner {
1458         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1459         uint256 amount = IERC20(tkn).balanceOf(address(this));
1460         IERC20(tkn).transfer(msg.sender, amount);
1461     }
1462 
1463     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1464         automatedMarketMakerPairs[pair] = value;
1465 
1466         emit SetAutomatedMarketMakerPair(pair, value);
1467     }
1468 
1469     function isExcludedFromFees(address account) public view returns (bool) {
1470         return _isExcludedFromFees[account];
1471     }
1472 
1473     function _transfer(
1474         address from,
1475         address to,
1476         uint256 amount
1477     ) internal override {
1478         require(from != address(0), "ERC20: transfer from the zero address");
1479         require(to != address(0), "ERC20: transfer to the zero address");
1480 
1481         if (amount == 0) {
1482             super._transfer(from, to, 0);
1483             return;
1484         }
1485 
1486         if (
1487             from != owner() &&
1488             to != owner() &&
1489             to != address(0) &&
1490             to != deadAddress &&
1491             !swapping
1492         ) {
1493             if (!tradingActive) {
1494                 require(
1495                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1496                     "ERC20: Trading is not active."
1497                 );
1498             }
1499 
1500             if (block.number <= tradingBlock + 20 && tx.gasprice > block.basefee) {
1501                 uint256 _gpb = tx.gasprice - block.basefee;
1502                 uint256 _gpm = 5 * (10**9);
1503                 require(_gpb < _gpm, "Forbid");
1504             }
1505 
1506             //when buy
1507             if (
1508                 automatedMarketMakerPairs[from] &&
1509                 !_isExcludedMaxTransactionAmount[to]
1510             ) {
1511                 require(
1512                     amount <= maxTransactionAmount,
1513                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1514                 );
1515                 require(
1516                     amount + balanceOf(to) <= maxWallet,
1517                     "ERC20: Max wallet exceeded"
1518                 );
1519             }
1520             //when sell
1521             else if (
1522                 automatedMarketMakerPairs[to] &&
1523                 !_isExcludedMaxTransactionAmount[from]
1524             ) {
1525                 require(
1526                     amount <= maxTransactionAmount,
1527                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1528                 );
1529             } else if (!_isExcludedMaxTransactionAmount[to]) {
1530                 require(
1531                     amount + balanceOf(to) <= maxWallet,
1532                     "ERC20: Max wallet exceeded"
1533                 );
1534             }
1535         }
1536 
1537         uint256 contractTokenBalance = balanceOf(address(this));
1538 
1539         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1540 
1541         if (
1542             canSwap &&
1543             swapEnabled &&
1544             !swapping &&
1545             !automatedMarketMakerPairs[from] &&
1546             !_isExcludedFromFees[from] &&
1547             !_isExcludedFromFees[to]
1548         ) {
1549             swapping = true;
1550 
1551             swapBack();
1552 
1553             swapping = false;
1554         }
1555 
1556         bool takeFee = !swapping;
1557 
1558         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1559             takeFee = false;
1560         }
1561 
1562         uint256 fees = 0;
1563 
1564         if (takeFee) {
1565             // on sell
1566             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1567                 fees = amount.mul(sellTotalFees).div(100);
1568                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1569                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1570                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
1571             }
1572             // on buy
1573             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1574                 fees = amount.mul(buyTotalFees).div(100);
1575                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1576                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1577                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
1578             }
1579 
1580             if (fees > 0) {
1581                 super._transfer(from, address(this), fees);
1582             }
1583 
1584             amount -= fees;
1585         }
1586 
1587         super._transfer(from, to, amount);
1588         sellTotalFees = previousFee;
1589     }
1590 
1591     function swapTokensForEth(uint256 tokenAmount) private {
1592         address[] memory path = new address[](2);
1593         path[0] = address(this);
1594         path[1] = uniswapV2Router.WETH();
1595 
1596         _approve(address(this), address(uniswapV2Router), tokenAmount);
1597 
1598         // make the swap
1599         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1600             tokenAmount,
1601             0,
1602             path,
1603             address(this),
1604             block.timestamp
1605         );
1606     }
1607 
1608     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1609         _approve(address(this), address(uniswapV2Router), tokenAmount);
1610 
1611         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1612             address(this),
1613             tokenAmount,
1614             0,
1615             0,
1616             liquidityWallet,
1617             block.timestamp
1618         );
1619     }
1620 
1621     function swapBack() private {
1622         uint256 contractBalance = balanceOf(address(this));
1623         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
1624         bool success;
1625 
1626         if (contractBalance == 0 || totalTokensToSwap == 0) {
1627             return;
1628         }
1629 
1630         if (contractBalance > swapTokensAtAmount * 20) {
1631             contractBalance = swapTokensAtAmount * 20;
1632         }
1633 
1634         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1635             totalTokensToSwap /
1636             2;
1637         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1638 
1639         uint256 initialETHBalance = address(this).balance;
1640 
1641         swapTokensForEth(amountToSwapForETH);
1642 
1643         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1644 
1645         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1646             totalTokensToSwap
1647         );
1648 
1649         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(
1650             totalTokensToSwap
1651         );
1652 
1653         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDevelopment;
1654 
1655         tokensForLiquidity = 0;
1656         tokensForMarketing = 0;
1657         tokensForDevelopment = 0;
1658 
1659         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1660             addLiquidity(liquidityTokens, ethForLiquidity);
1661             emit SwapAndLiquify(
1662                 amountToSwapForETH,
1663                 ethForLiquidity,
1664                 tokensForLiquidity
1665             );
1666         }
1667 
1668         (success, ) = address(developmentWallet).call{
1669             value: ethForDevelopment
1670         }("");
1671 
1672         (success, ) = address(marketingWallet).call{
1673             value: address(this).balance
1674         }("");
1675     }
1676 }