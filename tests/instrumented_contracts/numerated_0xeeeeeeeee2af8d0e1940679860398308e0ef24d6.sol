1 pragma solidity ^0.6.0;
2 
3 /*  
4     Ethverse : https://ethverse.com
5     Symbol: ETHV
6     Decimals: 18
7     
8     
9                        ``````````````                       
10                   `````              `````                  
11                 ..`                       ```               
12              `.`                            `.`             
13             .`                                `.`           
14           `.            :oydmmmmdyo/`           ``          
15          ::          :yNMMMMMMMMMMMMMd+`         `:         
16        -d+         -dMMMMMMMMMMMMMMMMMMN+         .h:       
17      .hMy         +MMMMMMMMMMMMMMMMMMMMMMh         /Mh.     
18    `sMMN-        /MMMMMMMMMMMMMMMMMMMMMMMMy         mMMs`   
19  `oNMMMm         mMMMMMMMMMMMMMMMMMMMMMMMMM-        oMMMNo` 
20 :mNNNNNh        .MMMMMMMMMMMMMMMMMMMMMMMMMM+        +NNNNNm/
21  +hddddy        `NMMMMMMMMMMMMMMMMMMMMMMMMM/        /dddddo`
22   `odddd`        yMMMMMMMMMMMMMMMMMMMMMMMMN`        sddds.  
23     .sdd/        `mMMMMMMMMMMMMMMMMMMMMMMM:        .ddy-    
24       -yh.        `hMMMMMMMMMMMMMMMMMMMMm-         sh:      
25         :s`         :dMMMMMMMMMMMMMMMMmo`         //        
26           :`          .ohNMMMMMMMMMms:           -`         
27            ..             .:////:.             `.           
28             `.`                              `.`            
29               `..                          `.`              
30                  ````                   ```                 
31                     ````````    ````````                    
32                             `````                       
33 */
34 
35 
36 
37 
38 
39 
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP.
43  */
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 
117 
118 
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `+` operator.
139      *
140      * Requirements:
141      *
142      * - Addition cannot overflow.
143      */
144     function add(uint256 a, uint256 b) internal pure returns (uint256) {
145         uint256 c = a + b;
146         require(c >= a, "SafeMath: addition overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         return sub(a, b, "SafeMath: subtraction overflow");
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b <= a, errorMessage);
177         uint256 c = a - b;
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the multiplication of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `*` operator.
187      *
188      * Requirements:
189      *
190      * - Multiplication cannot overflow.
191      */
192     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
193         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194         // benefit is lost if 'b' is also tested.
195         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
196         if (a == 0) {
197             return 0;
198         }
199 
200         uint256 c = a * b;
201         require(c / a == b, "SafeMath: multiplication overflow");
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         return div(a, b, "SafeMath: division by zero");
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b > 0, errorMessage);
236         uint256 c = a / b;
237         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return mod(a, b, "SafeMath: modulo by zero");
256     }
257 
258     /**
259      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
260      * Reverts with custom message when dividing by zero.
261      *
262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
263      * opcode (which leaves remaining gas untouched) while Solidity uses an
264      * invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         require(b != 0, errorMessage);
272         return a % b;
273     }
274 }
275 
276 
277 
278 
279 /*
280  * @dev Provides information about the current execution context, including the
281  * sender of the transaction and its data. While these are generally available
282  * via msg.sender and msg.data, they should not be accessed in such a direct
283  * manner, since when dealing with GSN meta-transactions the account sending and
284  * paying for execution may not be the actual sender (as far as an application
285  * is concerned).
286  *
287  * This contract is only required for intermediate, library-like contracts.
288  */
289 abstract contract Context {
290     function _msgSender() internal view virtual returns (address payable) {
291         return msg.sender;
292     }
293 
294     function _msgData() internal view virtual returns (bytes memory) {
295         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
296         return msg.data;
297     }
298 }
299 
300 
301 
302 
303 /**
304  * @dev Implementation of the {IERC20} interface.
305  *
306  * This implementation is agnostic to the way tokens are created. This means
307  * that a supply mechanism has to be added in a derived contract using {_mint}.
308  * For a generic mechanism see {ERC20PresetMinterPauser}.
309  *
310  * TIP: For a detailed writeup see our guide
311  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
312  * to implement supply mechanisms].
313  *
314  * We have followed general OpenZeppelin guidelines: functions revert instead
315  * of returning `false` on failure. This behavior is nonetheless conventional
316  * and does not conflict with the expectations of ERC20 applications.
317  *
318  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
319  * This allows applications to reconstruct the allowance for all accounts just
320  * by listening to said events. Other implementations of the EIP may not emit
321  * these events, as it isn't required by the specification.
322  *
323  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
324  * functions have been added to mitigate the well-known issues around setting
325  * allowances. See {IERC20-approve}.
326  */
327 contract ERC20 is Context, IERC20 {
328     using SafeMath for uint256;
329 
330     mapping (address => uint256) private _balances;
331 
332     mapping (address => mapping (address => uint256)) private _allowances;
333 
334     uint256 private _totalSupply;
335 
336     string private _name;
337     string private _symbol;
338     uint8 private _decimals;
339 
340     /**
341      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
342      * a default value of 18.
343      *
344      * To select a different value for {decimals}, use {_setupDecimals}.
345      *
346      * All three of these values are immutable: they can only be set once during
347      * construction.
348      */
349     constructor (string memory name, string memory symbol) public {
350         _name = name;
351         _symbol = symbol;
352     }
353 
354     /**
355      * @dev Returns the name of the token.
356      */
357     function name() public view returns (string memory) {
358         return _name;
359     }
360 
361     /**
362      * @dev Returns the symbol of the token, usually a shorter version of the
363      * name.
364      */
365     function symbol() public view returns (string memory) {
366         return _symbol;
367     }
368 
369     /**
370      * @dev Returns the number of decimals used to get its user representation.
371      * For example, if `decimals` equals `2`, a balance of `505` tokens should
372      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
373      *
374      * Tokens usually opt for a value of 18, imitating the relationship between
375      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
376      * called.
377      *
378      * NOTE: This information is only used for _display_ purposes: it in
379      * no way affects any of the arithmetic of the contract, including
380      * {IERC20-balanceOf} and {IERC20-transfer}.
381      */
382     function decimals() public view returns (uint8) {
383         return _decimals;
384     }
385 
386     /**
387      * @dev See {IERC20-totalSupply}.
388      */
389     function totalSupply() public view override returns (uint256) {
390         return _totalSupply;
391     }
392 
393     /**
394      * @dev See {IERC20-balanceOf}.
395      */
396     function balanceOf(address account) public view override returns (uint256) {
397         return _balances[account];
398     }
399 
400     /**
401      * @dev See {IERC20-transfer}.
402      *
403      * Requirements:
404      *
405      * - `recipient` cannot be the zero address.
406      * - the caller must have a balance of at least `amount`.
407      */
408     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
409         _transfer(_msgSender(), recipient, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-allowance}.
415      */
416     function allowance(address owner, address spender) public view virtual override returns (uint256) {
417         return _allowances[owner][spender];
418     }
419 
420     /**
421      * @dev See {IERC20-approve}.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function approve(address spender, uint256 amount) public virtual override returns (bool) {
428         _approve(_msgSender(), spender, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-transferFrom}.
434      *
435      * Emits an {Approval} event indicating the updated allowance. This is not
436      * required by the EIP. See the note at the beginning of {ERC20};
437      *
438      * Requirements:
439      * - `sender` and `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      * - the caller must have allowance for ``sender``'s tokens of at least
442      * `amount`.
443      */
444     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
445         _transfer(sender, recipient, amount);
446         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
447         return true;
448     }
449 
450     /**
451      * @dev Atomically increases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      *
456      * Emits an {Approval} event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      */
462     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
463         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
464         return true;
465     }
466 
467     /**
468      * @dev Atomically decreases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      * - `spender` must have allowance for the caller of at least
479      * `subtractedValue`.
480      */
481     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
483         return true;
484     }
485 
486     /**
487      * @dev Moves tokens `amount` from `sender` to `recipient`.
488      *
489      * This is internal function is equivalent to {transfer}, and can be used to
490      * e.g. implement automatic token fees, slashing mechanisms, etc.
491      *
492      * Emits a {Transfer} event.
493      *
494      * Requirements:
495      *
496      * - `sender` cannot be the zero address.
497      * - `recipient` cannot be the zero address.
498      * - `sender` must have a balance of at least `amount`.
499      */
500     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
501         require(sender != address(0), "ERC20: transfer from the zero address");
502         require(recipient != address(0), "ERC20: transfer to the zero address");
503 
504         _beforeTokenTransfer(sender, recipient, amount);
505 
506         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
507         _balances[recipient] = _balances[recipient].add(amount);
508         emit Transfer(sender, recipient, amount);
509     }
510 
511     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
512      * the total supply.
513      *
514      * Emits a {Transfer} event with `from` set to the zero address.
515      *
516      * Requirements
517      *
518      * - `to` cannot be the zero address.
519      */
520     function _mint(address account, uint256 amount) internal virtual {
521         require(account != address(0), "ERC20: mint to the zero address");
522 
523         _beforeTokenTransfer(address(0), account, amount);
524 
525         _totalSupply = _totalSupply.add(amount);
526         _balances[account] = _balances[account].add(amount);
527         emit Transfer(address(0), account, amount);
528     }
529 
530     /**
531      * @dev Destroys `amount` tokens from `account`, reducing the
532      * total supply.
533      *
534      * Emits a {Transfer} event with `to` set to the zero address.
535      *
536      * Requirements
537      *
538      * - `account` cannot be the zero address.
539      * - `account` must have at least `amount` tokens.
540      */
541     function _burn(address account, uint256 amount) internal virtual {
542         require(account != address(0), "ERC20: burn from the zero address");
543 
544         _beforeTokenTransfer(account, address(0), amount);
545 
546         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
547         _totalSupply = _totalSupply.sub(amount);
548         emit Transfer(account, address(0), amount);
549     }
550 
551     /**
552      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
553      *
554      * This is internal function is equivalent to `approve`, and can be used to
555      * e.g. set automatic allowances for certain subsystems, etc.
556      *
557      * Emits an {Approval} event.
558      *
559      * Requirements:
560      *
561      * - `owner` cannot be the zero address.
562      * - `spender` cannot be the zero address.
563      */
564     function _approve(address owner, address spender, uint256 amount) internal virtual {
565         require(owner != address(0), "ERC20: approve from the zero address");
566         require(spender != address(0), "ERC20: approve to the zero address");
567 
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571 
572     /**
573      * @dev Sets {decimals} to a value other than the default one of 18.
574      *
575      * WARNING: This function should only be called from the constructor. Most
576      * applications that interact with token contracts will not expect
577      * {decimals} to ever change, and may work incorrectly if it does.
578      */
579     function _setupDecimals(uint8 decimals_) internal {
580         _decimals = decimals_;
581     }
582 
583     /**
584      * @dev Hook that is called before any transfer of tokens. This includes
585      * minting and burning.
586      *
587      * Calling conditions:
588      *
589      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
590      * will be to transferred to `to`.
591      * - when `from` is zero, `amount` tokens will be minted for `to`.
592      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
593      * - `from` and `to` are never both zero.
594      *
595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
596      */
597     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
598 }
599 
600 
601 
602 
603 contract ETHVerse is ERC20 {
604     using SafeMath for uint256;
605     
606     
607     constructor()
608     public
609     ERC20("Ethverse Token", "ETHV")
610     {
611         uint8 decimals_ = 18;
612         uint256 supply_ = 40000000 * 10**uint256(decimals_);
613         
614         _mint(msg.sender, supply_);
615         _setupDecimals(decimals_);
616     }
617     
618     function burn(uint256 amount) external {
619         _burn(msg.sender, amount);
620     }
621 }