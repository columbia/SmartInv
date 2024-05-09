1 // SPDX-License-Identifier: MIT
2 // File: openzeppelin-solidity/contracts/utils/Context.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address sender,
93         address recipient,
94         uint256 amount
95     ) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // File: openzeppelin-solidity/contracts/token/ERC20/extensions/IERC20Metadata.sol
113 
114 
115 
116 pragma solidity ^0.8.0;
117 
118 
119 /**
120  * @dev Interface for the optional metadata functions from the ERC20 standard.
121  *
122  * _Available since v4.1._
123  */
124 interface IERC20Metadata is IERC20 {
125     /**
126      * @dev Returns the name of the token.
127      */
128     function name() external view returns (string memory);
129 
130     /**
131      * @dev Returns the symbol of the token.
132      */
133     function symbol() external view returns (string memory);
134 
135     /**
136      * @dev Returns the decimals places of the token.
137      */
138     function decimals() external view returns (uint8);
139 }
140 
141 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
142 
143 
144 
145 pragma solidity ^0.8.0;
146 
147 
148 
149 
150 /**
151  * @dev Implementation of the {IERC20} interface.
152  *
153  * This implementation is agnostic to the way tokens are created. This means
154  * that a supply mechanism has to be added in a derived contract using {_mint}.
155  * For a generic mechanism see {ERC20PresetMinterPauser}.
156  *
157  * TIP: For a detailed writeup see our guide
158  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
159  * to implement supply mechanisms].
160  *
161  * We have followed general OpenZeppelin Contracts guidelines: functions revert
162  * instead returning `false` on failure. This behavior is nonetheless
163  * conventional and does not conflict with the expectations of ERC20
164  * applications.
165  *
166  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
167  * This allows applications to reconstruct the allowance for all accounts just
168  * by listening to said events. Other implementations of the EIP may not emit
169  * these events, as it isn't required by the specification.
170  *
171  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
172  * functions have been added to mitigate the well-known issues around setting
173  * allowances. See {IERC20-approve}.
174  */
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     mapping(address => uint256) private _balances;
177 
178     mapping(address => mapping(address => uint256)) private _allowances;
179 
180     uint256 private _totalSupply;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The default value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor(string memory name_, string memory symbol_) {
195         _name = name_;
196         _symbol = symbol_;
197     }
198 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view virtual override returns (string memory) {
203         return _name;
204     }
205 
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213 
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if `decimals` equals `2`, a balance of `505` tokens should
217      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei. This is the value {ERC20} uses, unless this function is
221      * overridden;
222      *
223      * NOTE: This information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * {IERC20-balanceOf} and {IERC20-transfer}.
226      */
227     function decimals() public view virtual override returns (uint8) {
228         return 18;
229     }
230 
231     /**
232      * @dev See {IERC20-totalSupply}.
233      */
234     function totalSupply() public view virtual override returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See {IERC20-balanceOf}.
240      */
241     function balanceOf(address account) public view virtual override returns (uint256) {
242         return _balances[account];
243     }
244 
245     /**
246      * @dev See {IERC20-transfer}.
247      *
248      * Requirements:
249      *
250      * - `recipient` cannot be the zero address.
251      * - the caller must have a balance of at least `amount`.
252      */
253     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-transferFrom}.
279      *
280      * Emits an {Approval} event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of {ERC20}.
282      *
283      * Requirements:
284      *
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `amount`.
287      * - the caller must have allowance for ``sender``'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) public virtual override returns (bool) {
295         _transfer(sender, recipient, amount);
296 
297         uint256 currentAllowance = _allowances[sender][_msgSender()];
298         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
299         unchecked {
300             _approve(sender, _msgSender(), currentAllowance - amount);
301         }
302 
303         return true;
304     }
305 
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         uint256 currentAllowance = _allowances[_msgSender()][spender];
339         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
340         unchecked {
341             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
342         }
343 
344         return true;
345     }
346 
347     /**
348      * @dev Moves `amount` of tokens from `sender` to `recipient`.
349      *
350      * This internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `sender` cannot be the zero address.
358      * - `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368 
369         _beforeTokenTransfer(sender, recipient, amount);
370 
371         uint256 senderBalance = _balances[sender];
372         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
373         unchecked {
374             _balances[sender] = senderBalance - amount;
375         }
376         _balances[recipient] += amount;
377 
378         emit Transfer(sender, recipient, amount);
379 
380         _afterTokenTransfer(sender, recipient, amount);
381     }
382 
383     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
384      * the total supply.
385      *
386      * Emits a {Transfer} event with `from` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      */
392     function _mint(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: mint to the zero address");
394 
395         _beforeTokenTransfer(address(0), account, amount);
396 
397         _totalSupply += amount;
398         _balances[account] += amount;
399         emit Transfer(address(0), account, amount);
400 
401         _afterTokenTransfer(address(0), account, amount);
402     }
403 
404     /**
405      * @dev Destroys `amount` tokens from `account`, reducing the
406      * total supply.
407      *
408      * Emits a {Transfer} event with `to` set to the zero address.
409      *
410      * Requirements:
411      *
412      * - `account` cannot be the zero address.
413      * - `account` must have at least `amount` tokens.
414      */
415     function _burn(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: burn from the zero address");
417 
418         _beforeTokenTransfer(account, address(0), amount);
419 
420         uint256 accountBalance = _balances[account];
421         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
422         unchecked {
423             _balances[account] = accountBalance - amount;
424         }
425         _totalSupply -= amount;
426 
427         emit Transfer(account, address(0), amount);
428 
429         _afterTokenTransfer(account, address(0), amount);
430     }
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
434      *
435      * This internal function is equivalent to `approve`, and can be used to
436      * e.g. set automatic allowances for certain subsystems, etc.
437      *
438      * Emits an {Approval} event.
439      *
440      * Requirements:
441      *
442      * - `owner` cannot be the zero address.
443      * - `spender` cannot be the zero address.
444      */
445     function _approve(
446         address owner,
447         address spender,
448         uint256 amount
449     ) internal virtual {
450         require(owner != address(0), "ERC20: approve from the zero address");
451         require(spender != address(0), "ERC20: approve to the zero address");
452 
453         _allowances[owner][spender] = amount;
454         emit Approval(owner, spender, amount);
455     }
456 
457     /**
458      * @dev Hook that is called before any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * will be transferred to `to`.
465      * - when `from` is zero, `amount` tokens will be minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _beforeTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 
477     /**
478      * @dev Hook that is called after any transfer of tokens. This includes
479      * minting and burning.
480      *
481      * Calling conditions:
482      *
483      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
484      * has been transferred to `to`.
485      * - when `from` is zero, `amount` tokens have been minted for `to`.
486      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
487      * - `from` and `to` are never both zero.
488      *
489      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
490      */
491     function _afterTokenTransfer(
492         address from,
493         address to,
494         uint256 amount
495     ) internal virtual {}
496 }
497 
498 // File: contracts/4_ERC20POC.sol
499 
500 
501 pragma solidity ^0.8.9;
502 
503 
504 contract ERC20POC is ERC20 {
505   uint256 constant INIT_SUPPLY_POC = 1000000000;  // 1,000,000,000
506     
507   address _owner;
508   uint256 _locked_POC_total;
509   uint256 _fee_rate;
510   uint256 _submit_daily_limit_total;
511   uint256 _submit_daily_limit_personal;
512   
513   struct bridge_staff {
514     address user;
515     uint256 quota;
516   }
517   bridge_staff[] private arr_staff;
518   
519   enum Submit_state {submit, cancel, complete}
520   struct pegin_data {
521     uint256 reg_date;
522     bytes32 id;
523     address user;
524     uint256 amount;
525     uint256 fee;
526     Submit_state state;
527   }
528   mapping (bytes32 => pegin_data) private arr_pegin_submit;
529   mapping (uint256 => bytes32) private arr_pegin_submit_key;
530   uint256 arr_pegin_submit_key_start = 1;
531   uint256 arr_pegin_submit_key_last = 0;
532   
533   enum Reserve_state {reserve, cancel, complete}
534   struct pegout_data {
535     uint256 reg_date;
536     bytes32 id;
537     address user;
538     uint256 amount;
539 	address staff;
540     Reserve_state state;
541   }
542   mapping (bytes32 => pegout_data) private arr_pegout_reserve;  
543   mapping (uint256 => bytes32) private arr_pegout_reserve_key;
544   uint256 arr_pegout_reserve_key_start = 1;
545   uint256 arr_pegout_reserve_key_last = 0;
546   
547   constructor(uint256 fee_rate, uint256 locking_POC, address new_staff, uint256 new_staff_locked_POC,
548                 uint256 new_submit_daily_limit_total, uint256 new_submit_daily_limit_personal) ERC20("PocketArena", "POC") {
549     _owner = msg.sender;
550     _mint(_owner, (INIT_SUPPLY_POC * (10 ** uint256(decimals()))));
551     _locked_POC_total = locking_POC;
552     staff_add(new_staff, new_staff_locked_POC);
553     _fee_rate_set(fee_rate);
554     _submit_daily_limit_total = new_submit_daily_limit_total;
555     _submit_daily_limit_personal = new_submit_daily_limit_personal;
556   }
557   
558   modifier onlyOwner() {
559     require(msg.sender == _owner, "only owner is possible");
560     _;
561   }
562   modifier onlyStaff() {
563     (bool is_staff, uint256 quota) = staff_check(msg.sender);
564     require(is_staff, "only staff is possible");
565     _;
566   }
567   
568 
569   
570   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
571     if (msg.sender == _owner) {
572       require(balanceOf(_owner) - (_locked_POC_total - staff_quota_total()) >= amount, "sendable POC is not enough");
573     }
574     else {
575       (bool is_staff, ) = staff_check(msg.sender);
576       if (is_staff) {
577         require(recipient == _owner, "staff can transfer POC to the owner only");
578       }
579       else {
580         (is_staff, ) = staff_check(recipient);
581         require(!is_staff, "you can't transfer POC to the staff");
582       }
583     }
584     _transfer(_msgSender(), recipient, amount);
585     return true;
586   }
587   
588   function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
589     if (sender == _owner) {
590       require(balanceOf(_owner) - (_locked_POC_total - staff_quota_total()) >= amount, "sendable POC is not enough");
591     }
592     else {
593       (bool is_staff, uint256 quota) = staff_check(msg.sender);
594       if (is_staff) {
595         require(quota >= amount, "staff can transferFrom POC within quota");
596       }
597     }
598     _transfer(sender, recipient, amount);
599     uint256 currentAllowance = allowance(sender, _msgSender());
600     require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
601     unchecked {
602       _approve(sender, _msgSender(), currentAllowance - amount);
603     }
604     return true;
605   }
606   
607   
608   
609   function staff_list() onlyOwner external view returns (bridge_staff[] memory) {
610     return arr_staff;
611   }
612   
613   function staff_add(address new_staff, uint256 new_staff_locked_POC) onlyOwner public returns (bool) {
614     require(arr_staff.length < 5, "it allows max 5 staffs only");
615     require(new_staff != _owner, "owner can't be staff");
616     (bool is_staff, ) = staff_check(new_staff);
617     require(!is_staff, "it's already added as staff");
618     transfer(new_staff, new_staff_locked_POC);
619     arr_staff.push(bridge_staff(new_staff, new_staff_locked_POC));
620     return true;
621   }
622      
623   event evt_staff_del(bool result);
624   function staff_del() onlyStaff external {
625     uint256 del_index = arr_staff.length + 1;
626     for (uint256 i=0; i<arr_staff.length; i++) {
627       if (arr_staff[i].user == msg.sender) {
628         transfer(_owner, balanceOf(msg.sender));
629         delete arr_staff[i];
630         del_index = i;
631         break;
632       }
633     }
634     if (del_index >= (arr_staff.length + 1)) {
635       emit evt_staff_del(false);
636     }
637     else {
638       for (uint256 i=del_index; i<arr_staff.length-1; i++){
639         arr_staff[i] = arr_staff[i+1];
640       }
641       arr_staff.pop();
642       emit evt_staff_del(true);
643     }
644   }
645    
646   function staff_check(address user) public view returns (bool, uint256) {
647     bool is_staff = false;
648     uint256 quota = 0;
649     for (uint256 i=0; i<arr_staff.length; i++) {
650       if (arr_staff[i].user == user) {
651         is_staff = true;
652         quota = arr_staff[i].quota;
653         break;
654       }
655     }
656     return (is_staff, quota);
657   }
658   
659   event evt_staff_quota_add(bool result);
660   function staff_quota_add(address staff, uint256 increased) onlyOwner external {
661     (bool is_staff, ) = staff_check(staff);
662     require(is_staff, "you can add quota for existed staff only");
663     require(_locked_POC_total - staff_quota_total() > increased, "you can add within your locked_POC");
664     for (uint256 i=0; i<arr_staff.length; i++) {
665       if (arr_staff[i].user == staff) {
666         _transfer(msg.sender, staff, increased);
667         arr_staff[i].quota += increased;
668         break;
669       }
670     }
671     emit evt_staff_quota_add(true);
672   }
673   
674   event evt_staff_quota_minus(bool result);
675   function staff_quota_minus(uint256 decreased) onlyStaff external {
676     (, uint256 quota) = staff_check(msg.sender);
677     require(quota >= decreased, "you can minus within your locked_POC");
678     for (uint256 i=0; i<arr_staff.length; i++) {
679       if (arr_staff[i].user == msg.sender) {
680         transfer(_owner, decreased);
681         arr_staff[i].quota -= decreased;
682         break;
683       }
684     }
685     emit evt_staff_quota_minus(true);
686   }
687   
688   function staff_quota_total() onlyOwner public view returns (uint256) {
689     uint256 total = 0;
690     for (uint256 i=0; i<arr_staff.length; i++) {
691       total += arr_staff[i].quota;  
692     }
693     return total;
694   }
695 
696   
697   
698   function _fee_rate_get() onlyOwner external view returns (uint256) {
699     return _fee_rate;
700   }
701   
702   event evt_fee_rate_set(uint256 _fee_rate);
703   function _fee_rate_set(uint256 new_fee_rate) onlyOwner public {
704     require(new_fee_rate <= 10000 * 100, "rate should be 1000000 or less");
705     _fee_rate = new_fee_rate;
706     emit evt_fee_rate_set(_fee_rate);
707   }
708   
709   function fee_get(uint256 amount) public view returns (uint256) {
710     return amount * _fee_rate / 10000 / 100;
711   }
712   
713   
714   
715   function locked_POC_total() external view returns (uint256) {
716     return _locked_POC_total;
717   }
718   
719   event evt_locked_POC_total_add(uint256 _locked_POC_total);
720   function locked_POC_total_add(uint256 amount) onlyOwner external {
721     require((balanceOf(_owner) - _locked_POC_total) >= amount, "lockable POC is not enough");
722     _locked_POC_total += amount;
723     emit evt_locked_POC_total_add(_locked_POC_total);
724   }
725   
726   event evt_locked_POC_total_minus(uint256 _locked_POC_total);
727   function locked_POC_total_minus(uint256 amount) onlyOwner external {
728     require((_locked_POC_total - staff_quota_total()) >= amount, "lockable POC is not enough");
729     _locked_POC_total -= amount;
730     emit evt_locked_POC_total_minus(_locked_POC_total);
731   }
732   
733   
734    
735   function _submit_daily_limit_total_get() onlyOwner external view returns (uint256) {
736     return _submit_daily_limit_total;
737   }
738   
739   event evt_submit_daily_limit_total_set(uint256 _submit_daily_limit_total);
740   function _submit_daily_limit_total_set(uint256 new_submit_daily_limit_total) onlyOwner external {
741     _submit_daily_limit_total = new_submit_daily_limit_total;
742     emit evt_submit_daily_limit_total_set(_submit_daily_limit_total);
743   }
744   
745   function _submit_daily_limit_personal_get() onlyOwner external view returns (uint256) {
746     return _submit_daily_limit_personal;
747   }
748   
749   event evt_submit_daily_limit_personal_set(uint256 _submit_daily_limit_personal);
750   function _submit_daily_limit_personal_set(uint256 new_submit_daily_limit_personal) onlyOwner external {
751     _submit_daily_limit_personal = new_submit_daily_limit_personal;
752     emit evt_submit_daily_limit_personal_set(_submit_daily_limit_personal);
753   }
754   
755 
756   function arr_pegin_submit_key_last_get() onlyOwner external view returns (uint256) {
757     return arr_pegin_submit_key_last;
758   }  
759   
760   function arr_pegin_submit_key_start_get() onlyOwner external view returns (uint256) {
761     return arr_pegin_submit_key_start;
762   }
763   
764   event evt_arr_pegin_submit_key_start_set(uint256 arr_pegin_submit_key_start);
765   function arr_pegin_submit_key_start_set(uint256 new_arr_pegin_submit_key_start) onlyOwner external {
766     arr_pegin_submit_key_start = new_arr_pegin_submit_key_start;
767     emit evt_arr_pegin_submit_key_start_set(arr_pegin_submit_key_start);
768   }
769   
770   function arr_pegout_reserve_key_last_get() onlyOwner external view returns (uint256) {
771     return arr_pegout_reserve_key_last;
772   }
773   
774   function arr_pegout_reserve_key_start_get() onlyOwner external view returns (uint256) {
775     return arr_pegout_reserve_key_start;
776   }
777   event evt_arr_pegout_reserve_key_start_set(uint256 arr_pegout_reserve_ey_start);
778   function arr_pegout_reserve_key_start_set(uint256 new_arr_pegout_reserve_key_start) onlyOwner external {
779     arr_pegout_reserve_key_start = new_arr_pegout_reserve_key_start;
780     emit evt_arr_pegout_reserve_key_start_set(arr_pegout_reserve_key_start);
781   }
782   
783   
784   
785   event evt_pegin_submit(pegin_data temp);
786   function pegin_submit(uint256 amount) external {
787     uint256 calc_fee = fee_get(amount);
788     require(balanceOf(msg.sender) >= (amount + calc_fee), "your balance is not enough");
789     uint256 daily_total = 0;
790     uint256 daily_personal = 0;
791     for (uint256 i=arr_pegin_submit_key_last; i>=arr_pegin_submit_key_start; i--) {
792       if ((block.timestamp - arr_pegin_submit[arr_pegin_submit_key[i]].reg_date) < 86400) {
793         daily_total += 1;
794         require(daily_total < _submit_daily_limit_total, "we dont't get the submit anymore today");
795         if (arr_pegin_submit[arr_pegin_submit_key[i]].user == msg.sender) {
796           daily_personal += 1;
797           require(daily_personal < _submit_daily_limit_personal, "you can't submit anymore today");
798         }
799       }
800       else {
801         break;
802       }
803     }
804     transfer(_owner, (amount + calc_fee));
805     _locked_POC_total += (amount + calc_fee);
806     bytes32 temp_key = keccak256(abi.encodePacked(block.timestamp, msg.sender));
807     pegin_data memory temp = pegin_data(block.timestamp, temp_key, msg.sender, amount, calc_fee, Submit_state.submit);
808     arr_pegin_submit[temp_key] = temp;
809     arr_pegin_submit_key_last += 1;
810     arr_pegin_submit_key[arr_pegin_submit_key_last] = temp_key;
811     emit evt_pegin_submit(temp);
812   }
813     
814   function pegin_submit_list(bytes32 id) external view returns (pegin_data memory) {
815       return arr_pegin_submit[id];
816   }  
817   
818   function pegin_submit_list(uint256 count_per_page, uint256 current_page) external view returns (pegin_data[] memory) {
819     uint256 new_arr_pegin_submit_key_last;
820     uint256 new_arr_pegin_submit_key_start;
821     if (current_page == 0) { 
822       current_page = 1;
823     }
824     if (current_page == 1) {
825       new_arr_pegin_submit_key_last = arr_pegin_submit_key_last;
826     }
827     else
828     {
829       uint256 key_position = count_per_page * (current_page - 1);
830       if (arr_pegin_submit_key_last <= key_position) {
831         new_arr_pegin_submit_key_last = 0;
832       }
833       else {
834         new_arr_pegin_submit_key_last = arr_pegin_submit_key_last - key_position;
835       }
836     }
837     if (new_arr_pegin_submit_key_last < count_per_page) {
838       new_arr_pegin_submit_key_start = arr_pegin_submit_key_start;
839     }
840     else {
841       if ( new_arr_pegin_submit_key_last < (arr_pegin_submit_key_start + count_per_page) ) {
842         new_arr_pegin_submit_key_start = arr_pegin_submit_key_start;
843       }
844       else {
845         new_arr_pegin_submit_key_start = new_arr_pegin_submit_key_last - count_per_page + 1;
846       }
847     }
848     uint256 temp_size = 0;
849     if (new_arr_pegin_submit_key_start < (new_arr_pegin_submit_key_last + 1) ) {
850       temp_size = new_arr_pegin_submit_key_last - new_arr_pegin_submit_key_start + 1;
851     }
852     pegin_data[] memory arr_temp = new pegin_data[](temp_size);
853     uint256 index = 0;
854     for (uint256 i=new_arr_pegin_submit_key_last; i>=new_arr_pegin_submit_key_start; i--) {
855       arr_temp[index] = arr_pegin_submit[arr_pegin_submit_key[i]];
856       index += 1;
857     }
858     return arr_temp;
859   }
860   
861   event evt_pegin_submit_complete(bool result);
862   function pegin_submit_complete(bytes32[] memory complete_id) onlyStaff external {
863     uint256 len = complete_id.length;
864     for (uint256 i=0; i<len; i++) {
865       if (arr_pegin_submit[complete_id[i]].reg_date > 0) {
866         arr_pegin_submit[complete_id[i]].state = Submit_state.complete;
867       }
868     }
869     emit evt_pegin_submit_complete(true);
870   }
871   
872   event evt_pegin_submit_cancel(bool result);
873   function pegin_submit_cancel(bytes32[] memory del_id) onlyStaff external {
874     uint256 len = del_id.length;
875     for (uint256 i=0; i<len; i++) {
876       if (arr_pegin_submit[del_id[i]].reg_date > 0) {
877         if (arr_pegin_submit[del_id[i]].state == Submit_state.submit) {
878           transfer(arr_pegin_submit[del_id[i]].user, (arr_pegin_submit[del_id[i]].amount + arr_pegin_submit[del_id[i]].fee));
879           _locked_POC_total -= (arr_pegin_submit[del_id[i]].amount + arr_pegin_submit[del_id[i]].fee);
880           arr_pegin_submit[del_id[i]].state = Submit_state.cancel;
881         }
882       }
883     }
884     emit evt_pegin_submit_cancel(false);
885   }
886   
887   
888   
889   event evt_pegout_reserve(bool result);
890   function pegout_reserve(uint256[] memory reg_date, bytes32[] memory id, address[] memory user, uint256[] memory amount) onlyStaff external {
891     uint256 len = reg_date.length;
892     require(len == id.length, "2nd parameter is missed");
893     require(len == user.length, "3rd parameter is missed");
894     require(len == amount.length, "4th parameter is missed");
895     (, uint256 quota) = staff_check(msg.sender);
896     uint256 total_amount = 0;
897     for (uint256 i=0; i<len; i++) {
898       require(arr_pegout_reserve[id[i]].reg_date == 0, "there is an already reserved data");
899       total_amount += amount[i];
900     }
901     require(quota >= total_amount, "your unlocked_POC balance is not enough");
902     for (uint256 i=0; i<len; i++) {
903       increaseAllowance(user[i], amount[i]);
904       arr_pegout_reserve[id[i]] = pegout_data(reg_date[i], id[i], user[i], amount[i], msg.sender, Reserve_state.reserve);
905       arr_pegout_reserve_key_last += 1;
906       arr_pegout_reserve_key[arr_pegout_reserve_key_last] = id[i];
907     }
908     emit evt_pegout_reserve(true);
909   }
910   
911   function pegout_reserve_list(bytes32 id) external view returns (pegout_data memory) {
912       return arr_pegout_reserve[id];
913   }
914     
915   function pegout_reserve_list(uint256 count_per_page, uint256 current_page) external view returns (pegout_data[] memory) {
916     uint256 new_arr_pegout_reserve_key_last;
917     uint256 new_arr_pegout_reserve_key_start;
918     if (current_page == 0) { 
919       current_page = 1;
920     }
921     if (current_page == 1) {
922       new_arr_pegout_reserve_key_last = arr_pegout_reserve_key_last;
923     }
924     else
925     {
926       uint256 key_position = count_per_page * (current_page - 1);
927       if (arr_pegout_reserve_key_last <= key_position) {
928         new_arr_pegout_reserve_key_last = 0;
929       }
930       else {
931         new_arr_pegout_reserve_key_last = arr_pegout_reserve_key_last - key_position;
932       }
933     }
934     if (new_arr_pegout_reserve_key_last < count_per_page) {
935       new_arr_pegout_reserve_key_start = arr_pegout_reserve_key_start;
936     }
937     else {
938       if ( new_arr_pegout_reserve_key_last < (arr_pegout_reserve_key_start + count_per_page) ) {
939         new_arr_pegout_reserve_key_start = arr_pegout_reserve_key_start;
940       }
941       else {
942         new_arr_pegout_reserve_key_start = new_arr_pegout_reserve_key_last - count_per_page + 1;
943       }
944     }
945     uint256 temp_size = 0;
946     if (new_arr_pegout_reserve_key_start < (new_arr_pegout_reserve_key_last + 1) ) {
947       temp_size = new_arr_pegout_reserve_key_last - new_arr_pegout_reserve_key_start + 1;
948     }
949     pegout_data[] memory arr_temp = new pegout_data[](temp_size);
950     uint256 index = 0;
951     for (uint256 i=new_arr_pegout_reserve_key_last; i>=new_arr_pegout_reserve_key_start; i--) {
952       arr_temp[index] = arr_pegout_reserve[arr_pegout_reserve_key[i]];
953       index += 1;
954     }
955     return arr_temp;
956   }
957   
958   event evt_pegout_run(bytes32[] arr_temp);
959   function pegout_run(bytes32[] memory id) external {
960     uint256 len = id.length;
961     bytes32[] memory arr_temp = new bytes32[](len);
962     uint256 temp_index = 0;
963     for (uint256 i=0; i<len; i++) {
964       if (arr_pegout_reserve[id[i]].reg_date > 0) {
965         if ( (arr_pegout_reserve[id[i]].user == msg.sender) && (arr_pegout_reserve[id[i]].state == Reserve_state.reserve) ) {
966           bool result = transferFrom(arr_pegout_reserve[id[i]].staff, msg.sender, arr_pegout_reserve[id[i]].amount);
967           if (result) {
968             arr_pegout_reserve[id[i]].state = Reserve_state.complete;
969             _locked_POC_total -= arr_pegout_reserve[id[i]].amount;
970 			arr_temp[temp_index] = id[i];
971 			temp_index += 1;
972           }
973         
974         }
975       }
976     }
977     emit evt_pegout_run(arr_temp);
978   }
979   
980   event evt_pegout_reserve_cancel(bool result);
981   function pegout_reserve_cancel(bytes32[] memory del_id) onlyStaff external {
982     uint256 len = del_id.length;
983     for (uint256 i=0; i<len; i++) {
984       if (arr_pegout_reserve[del_id[i]].reg_date > 0) {
985         if (arr_pegout_reserve[del_id[i]].staff == msg.sender) {
986           decreaseAllowance(arr_pegout_reserve[del_id[i]].user, arr_pegout_reserve[del_id[i]].amount);
987           arr_pegout_reserve[del_id[i]].state = Reserve_state.cancel;
988         }
989       }
990     }
991     emit evt_pegout_reserve_cancel(true);
992   } 
993 }