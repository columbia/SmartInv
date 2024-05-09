1 // SPDX-License-Identifier: No License
2 
3 pragma solidity ^0.8.10;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      *
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 library Address {
231     function isContract(address account) internal view returns (bool) {
232         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
233         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
234         // for accounts without code, i.e. `keccak256('')`
235         bytes32 codehash;
236         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
237         // solhint-disable-next-line no-inline-assembly
238         assembly { codehash := extcodehash(account) }
239         return (codehash != accountHash && codehash != 0x0);
240     }
241 
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(address(this).balance >= amount, "Address: insufficient balance");
244 
245         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
246         (bool success, ) = recipient.call{ value: amount }("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250 
251     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
252       return functionCall(target, data, "Address: low-level call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
257      * `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
262         return _functionCallWithValue(target, data, 0, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but also transferring `value` wei to `target`.
268      *
269      * Requirements:
270      *
271      * - the calling contract must have an ETH balance of at least `value`.
272      * - the called Solidity function must be `payable`.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
282      * with `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
287         require(address(this).balance >= value, "Address: insufficient balance for call");
288         return _functionCallWithValue(target, data, value, errorMessage);
289     }
290 
291     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
292         require(isContract(target), "Address: call to non-contract");
293 
294         // solhint-disable-next-line avoid-low-level-calls
295         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
296         if (success) {
297             return returndata;
298         } else {
299             // Look for revert reason and bubble it up if present
300             if (returndata.length > 0) {
301                 // The easiest way to bubble the revert reason is using memory via assembly
302 
303                 // solhint-disable-next-line no-inline-assembly
304                 assembly {
305                     let returndata_size := mload(returndata)
306                     revert(add(32, returndata), returndata_size)
307                 }
308             } else {
309                 revert(errorMessage);
310             }
311         }
312     }
313 }
314 
315 contract ERC20 is Context, IERC20 {
316     using SafeMath for uint256;
317     using Address for address;
318 
319     mapping (address => uint256) private _balances;
320 
321     mapping (address => mapping (address => uint256)) private _allowances;
322 
323     uint256 private _totalSupply;
324 
325     string private _name;
326     string private _symbol;
327     uint8 private _decimals;
328 
329 
330     constructor (string memory tname, string memory tsymbol) {
331         _name = tname;
332         _symbol = tsymbol;
333         _decimals = 18;
334     }
335 
336     /**
337      * @dev Returns the name of the token.
338      */
339     function name() public view returns (string memory) {
340         return _name;
341     }
342 
343     /**
344      * @dev Returns the symbol of the token, usually a shorter version of the
345      * name.
346      */
347     function symbol() public view returns (string memory) {
348         return _symbol;
349     }
350 
351     /**
352      * @dev Returns the number of decimals used to get its user representation.
353      * For example, if `decimals` equals `2`, a balance of `505` tokens should
354      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
355      *
356      * Tokens usually opt for a value of 18, imitating the relationship between
357      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
358      * called.
359      *
360      * NOTE: This information is only used for _display_ purposes: it in
361      * no way affects any of the arithmetic of the contract, including
362      * {IERC20-balanceOf} and {IERC20-transfer}.
363      */
364     function decimals() public view returns (uint8) {
365         return _decimals;
366     }
367 
368     /**
369      * @dev See {IERC20-totalSupply}.
370      */
371     function totalSupply() public view override returns (uint256) {
372         return _totalSupply;
373     }
374 
375     /**
376      * @dev See {IERC20-balanceOf}.
377      */
378     function balanceOf(address account) public view override returns (uint256) {
379         return _balances[account];
380     }
381 
382     /**
383      * @dev See {IERC20-transfer}.
384      *
385      * Requirements:
386      *
387      * - `recipient` cannot be the zero address.
388      * - the caller must have a balance of at least `amount`.
389      */
390     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
391         _transfer(_msgSender(), recipient, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-allowance}.
397      */
398     function allowance(address owner, address spender) public view virtual override returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @dev See {IERC20-approve}.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function approve(address spender, uint256 amount) public virtual override returns (bool) {
410         _approve(_msgSender(), spender, amount);
411         return true;
412     }
413 
414     /**
415      * @dev See {IERC20-transferFrom}.
416      *
417      * Emits an {Approval} event indicating the updated allowance. This is not
418      * required by the EIP. See the note at the beginning of {ERC20};
419      *
420      * Requirements:
421      * - `sender` and `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      * - the caller must have allowance for ``sender``'s tokens of at least
424      * `amount`.
425      */
426     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
427         _transfer(sender, recipient, amount);
428         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically increases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
446         return true;
447     }
448 
449     /**
450      * @dev Atomically decreases the allowance granted to `spender` by the caller.
451      *
452      * This is an alternative to {approve} that can be used as a mitigation for
453      * problems described in {IERC20-approve}.
454      *
455      * Emits an {Approval} event indicating the updated allowance.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      * - `spender` must have allowance for the caller of at least
461      * `subtractedValue`.
462      */
463     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
465         return true;
466     }
467 
468     /**
469      * @dev Moves tokens `amount` from `sender` to `recipient`.
470      *
471      * This is internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
483         require(sender != address(0), "ERC20: transfer from the zero address");
484         require(recipient != address(0), "ERC20: transfer to the zero address");
485 
486         _beforeTokenTransfer(sender, recipient, amount);
487 
488         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
489         _balances[recipient] = _balances[recipient].add(amount);
490         emit Transfer(sender, recipient, amount);
491     }
492 
493     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
494      * the total supply.
495      *
496      * Emits a {Transfer} event with `from` set to the zero address.
497      *
498      * Requirements
499      *
500      * - `to` cannot be the zero address.
501      */
502     function _mint(address account, uint256 amount) internal virtual {
503         require(account != address(0), "ERC20: mint to the zero address");
504 
505         _beforeTokenTransfer(address(0), account, amount);
506 
507         _totalSupply = _totalSupply.add(amount);
508         _balances[account] = _balances[account].add(amount);
509         emit Transfer(address(0), account, amount);
510     }
511 
512     /**
513      * @dev Destroys `amount` tokens from `account`, reducing the
514      * total supply.
515      *
516      * Emits a {Transfer} event with `to` set to the zero address.
517      *
518      * Requirements
519      *
520      * - `account` cannot be the zero address.
521      * - `account` must have at least `amount` tokens.
522      */
523     function _burn(address account, uint256 amount) internal virtual {
524         require(account != address(0), "ERC20: burn from the zero address");
525 
526         _beforeTokenTransfer(account, address(0), amount);
527 
528         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
529         _totalSupply = _totalSupply.sub(amount);
530         emit Transfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
535      *
536      * This is internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(address owner, address spender, uint256 amount) internal virtual {
547         require(owner != address(0), "ERC20: approve from the zero address");
548         require(spender != address(0), "ERC20: approve to the zero address");
549 
550         _allowances[owner][spender] = amount;
551         emit Approval(owner, spender, amount);
552     }
553 
554     /**
555      * @dev Sets {decimals} to a value other than the default one of 18.
556      *
557      * WARNING: This function should only be called from the constructor. Most
558      * applications that interact with token contracts will not expect
559      * {decimals} to ever change, and may work incorrectly if it does.
560      */
561     function _setupDecimals(uint8 decimals_) internal {
562         _decimals = decimals_;
563     }
564 
565     /**
566      * @dev Hook that is called before any transfer of tokens. This includes
567      * minting and burning.
568      *
569      * Calling conditions:
570      *
571      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
572      * will be to transferred to `to`.
573      * - when `from` is zero, `amount` tokens will be minted for `to`.
574      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
575      * - `from` and `to` are never both zero.
576      *
577      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
578      */
579     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
580 }
581 
582 contract Ownable is Context {
583     address private _owner;
584 
585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
586 
587     /**
588      * @dev Initializes the contract setting the deployer as the initial owner.
589      */
590     constructor () {
591         address msgSender = _msgSender();
592         _owner = msgSender;
593         emit OwnershipTransferred(address(0), msgSender);
594     }
595 
596     /**
597      * @dev Returns the address of the current owner.
598      */
599     function owner() public view returns (address) {
600         return _owner;
601     }
602 
603     /**
604      * @dev Throws if called by any account other than the owner.
605      */
606     modifier onlyOwner() {
607         require(_owner == _msgSender(), "Ownable: caller is not the owner");
608         _;
609     }
610 
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         emit OwnershipTransferred(_owner, address(0));
620         _owner = address(0);
621     }
622 
623     /**
624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
625      * Can only be called by the current owner.
626      */
627     function transferOwnership(address newOwner) public virtual onlyOwner {
628         require(newOwner != address(0), "Ownable: new owner is the zero address");
629         emit OwnershipTransferred(_owner, newOwner);
630         _owner = newOwner;
631     }
632 }
633 
634 contract LOLA is ERC20, Ownable {
635     constructor() ERC20("Lola", "Lola") {
636         _mint(msg.sender, 1000000000000 * 10 ** decimals());
637     }   
638 }