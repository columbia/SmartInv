1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-18
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.0;
8 
9 
10 
11 library SafeMath {
12     /**
13      * @dev Returns the addition of two unsigned integers, reverting on
14      * overflow.
15      *
16      * Counterpart to Solidity's `+` operator.
17      *
18      * Requirements:
19      *
20      * - Addition cannot overflow.
21      */
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28 
29     /**
30      * @dev Returns the subtraction of two unsigned integers, reverting on
31      * overflow (when the result is negative).
32      *
33      * Counterpart to Solidity's `-` operator.
34      *
35      * Requirements:
36      *
37      * - Subtraction cannot overflow.
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     /**
44      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
45      * overflow (when the result is negative).
46      *
47      * Counterpart to Solidity's `-` operator.
48      *
49      * Requirements:
50      *
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the multiplication of two unsigned integers, reverting on
62      * overflow.
63      *
64      * Counterpart to Solidity's `*` operator.
65      *
66      * Requirements:
67      *
68      * - Multiplication cannot overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80 
81         return c;
82     }
83 
84     /**
85      * @dev Returns the integer division of two unsigned integers. Reverts on
86      * division by zero. The result is rounded towards zero.
87      *
88      * Counterpart to Solidity's `/` operator. Note: this function uses a
89      * `revert` opcode (which leaves remaining gas untouched) while Solidity
90      * uses an invalid opcode to revert (consuming all remaining gas).
91      *
92      * Requirements:
93      *
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      *
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         return mod(a, b, "SafeMath: modulo by zero");
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts with custom message when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 interface IERC20 {
155     
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `recipient`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address recipient, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender) external view returns (uint256);
178 
179     /**
180      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * IMPORTANT: Beware that changing an allowance with this method brings the risk
185      * that someone may use both the old and the new allowance by unfortunate
186      * transaction ordering. One possible solution to mitigate this race
187      * condition is to first reduce the spender's allowance to 0 and set the
188      * desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      *
191      * Emits an {Approval} event.
192      */
193     function approve(address spender, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Moves `amount` tokens from `sender` to `recipient` using the
197      * allowance mechanism. `amount` is then deducted from the caller's
198      * allowance.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Emitted when `value` tokens are moved from one account (`from`) to
208      * another (`to`).
209      *
210      * Note that `value` may be zero.
211      */
212     event Transfer(address indexed from, address indexed to, uint256 value);
213 
214     /**
215      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
216      * a call to {approve}. `value` is the new allowance.
217      */
218     event Approval(address indexed owner, address indexed spender, uint256 value);
219 }
220 
221 
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes memory) {
228         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
229         return msg.data;
230     }
231 }
232 
233 contract Ownable is Context {
234     address private _owner;
235     address private _newOwner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev Initializes the contract setting the deployer as the initial owner.
241      */
242     constructor () {
243         _owner = _msgSender();
244         emit OwnershipTransferred(address(0), _msgSender());
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(_owner == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261     
262     /**
263      * @dev Throws if called by any account other than the _newOwnerowner.
264      */
265     modifier onlyMidWayOwner() {
266         require(_newOwner == _msgSender(), "Ownable: caller is not the Mid Way Owner");
267         _;
268     }
269 
270     /**
271      * @dev Leaves the contract without owner. It will not be possible to call
272      * `onlyOwner` functions anymore. Can only be called by the current owner.
273      *
274      * NOTE: Renouncing ownership will leave the contract without an owner,
275      * thereby removing any functionality that is only available to the owner.
276      */
277     function renounceOwnership() external onlyOwner {
278         emit OwnershipTransferred(_owner, address(0));
279         _owner = address(0);
280     }
281 
282     /**
283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
284      * Can only be called by the current owner.
285      */
286     function transferOwnership(address newOwner) public virtual onlyOwner {
287         require(newOwner != address(0), "Ownable: new owner is the zero address");
288         _newOwner = newOwner;
289     }
290     
291     /**
292      * @dev receive ownership of the contract by _newOwner. Previous owner assigned this _newOwner to receive ownership. 
293      * Can only be called by the current _newOwner.
294      */
295     function recieveOwnership() external onlyMidWayOwner {
296         emit OwnershipTransferred(_owner, _newOwner);
297         _owner = _newOwner;
298     }
299 }
300 
301 contract ERC20 is Context, IERC20, Ownable {
302     using SafeMath for uint256;
303 
304     mapping (address => uint256) private _balances;
305 
306     mapping (address => mapping (address => uint256)) private _allowances;
307 
308     uint256 public totalSupply;
309 
310     string public name;
311     string public symbol;
312     uint8 public immutable decimals;
313     
314     uint256 public constant tfees = 5; //0.5% fees 5/1000
315     
316      mapping(address => bool) public freeSender;
317     mapping(address => bool) public freeReciever;
318     
319 
320     /**
321      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
322      * a default value of 18.
323      *
324      * To select a different value for {decimals}, use {_setupDecimals}.
325      *
326      * All three of these values are immutable: they can only be set once during
327      * construction.
328      */
329     constructor (string memory name_, string memory symbol_) {
330         name = name_;
331         symbol = symbol_;
332         decimals = 18;
333     }
334 
335     
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account) external view override returns (uint256) {
340         return _balances[account];
341     }
342     
343     function setFeeFreeSender(address _sender, bool _feeFree) external onlyOwner {
344         require(_sender != address(0), "ERC20: transfer from the zero address");
345         require(!_feeFree || _feeFree, "Input must be a bool");
346         freeSender[_sender] = _feeFree;
347     }
348 
349     function setFeeFreeReciever(address _recipient, bool _feeFree) external onlyOwner {
350         require(_recipient != address(0), "ERC20: transfer from the zero address");
351         require(!_feeFree || _feeFree, "Input must be a bool");
352         freeReciever[_recipient] = _feeFree;
353     }
354 
355     /**
356      * @dev See {IERC20-transfer}.
357      *
358      * Requirements:
359      *
360      * - `recipient` cannot be the zero address.
361      * - the caller must have a balance of at least `amount`.
362      */
363     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
364         _transfer(_msgSender(), recipient, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-allowance}.
370      */
371     function allowance(address owner, address spender) external view virtual override returns (uint256) {
372         return _allowances[owner][spender];
373     }
374 
375     /**
376      * @dev See {IERC20-approve}.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      */
382     function approve(address spender, uint256 amount) external virtual override returns (bool) {
383         _approve(_msgSender(), spender, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-transferFrom}.
389      *
390      * Emits an {Approval} event indicating the updated allowance. This is not
391      * required by the EIP. See the note at the beginning of {ERC20}.
392      *
393      * Requirements:
394      *
395      * - `sender` and `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      * - the caller must have allowance for ``sender``'s tokens of at least
398      * `amount`.
399      */
400     function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
401         _transfer(sender, recipient, amount);
402         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
403         return true;
404     }
405 
406     /**
407      * @dev Atomically increases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
419         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
420         return true;
421     }
422 
423     /**
424      * @dev Atomically decreases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      * - `spender` must have allowance for the caller of at least
435      * `subtractedValue`.
436      */
437     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
438         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
439         return true;
440     }
441 
442     /**
443      * @dev Moves tokens `amount` from `sender` to `recipient`.
444      *
445      * This is internal function is equivalent to {transfer}, and can be used to
446      * e.g. implement automatic token fees, slashing mechanisms, etc.
447      *
448      * Emits a {Transfer} event.
449      *
450      * Requirements:
451      *
452      * - `sender` cannot be the zero address.
453      * - `recipient` cannot be the zero address.
454      * - `sender` must have a balance of at least `amount`.
455      */
456     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
457         require(sender != address(0), "ERC20: transfer from the zero address");
458         require(recipient != address(0), "ERC20: transfer to the zero address");
459 
460         _beforeTokenTransfer(sender, recipient, amount);
461         
462         
463         (uint256 amounToSend, uint256 feesAmount) = calculateFees(sender, recipient, amount);
464         
465         if(feesAmount > 0){
466             _balances[owner()] = _balances[owner()].add(feesAmount);
467             emit Transfer(sender, owner(), feesAmount);
468        }
469         
470 
471         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
472         _balances[recipient] = _balances[recipient].add(amounToSend);
473         emit Transfer(sender, recipient, amounToSend);
474     }
475     
476     // to caclulate the amounts for recipient and distributer after fees have been applied
477     function calculateFees(
478         address sender,
479         address recipient,
480         uint256 amount
481     ) public view returns (uint256, uint256) {
482         
483         if(freeSender[sender] || freeReciever[recipient]){
484             return (amount, 0);
485         }
486        
487         uint256 fee = amount.mul(tfees).div(1000);
488         return (amount.sub(fee), fee);
489     }
490 
491     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
492      * the total supply.
493      *
494      * Emits a {Transfer} event with `from` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `to` cannot be the zero address.
499      */
500     function _mint(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: mint to the zero address");
502 
503         _beforeTokenTransfer(address(0), account, amount);
504 
505         totalSupply = totalSupply.add(amount);
506         _balances[account] = _balances[account].add(amount);
507         emit Transfer(address(0), account, amount);
508     }
509 
510     /**
511      * @dev Destroys `amount` tokens from `account`, reducing the
512      * total supply.
513      *
514      * Emits a {Transfer} event with `to` set to the zero address.
515      *
516      * Requirements:
517      *
518      * - `account` cannot be the zero address.
519      * - `account` must have at least `amount` tokens.
520      */
521     function _burn(address account, uint256 amount) internal virtual {
522         require(account != address(0), "ERC20: burn from the zero address");
523 
524         _beforeTokenTransfer(account, address(0), amount);
525 
526         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
527         totalSupply = totalSupply.sub(amount);
528         emit Transfer(account, address(0), amount);
529     }
530 
531     /**
532      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
533      *
534      * This internal function is equivalent to `approve`, and can be used to
535      * e.g. set automatic allowances for certain subsystems, etc.
536      *
537      * Emits an {Approval} event.
538      *
539      * Requirements:
540      *
541      * - `owner` cannot be the zero address.
542      * - `spender` cannot be the zero address.
543      */
544     function _approve(address owner, address spender, uint256 amount) internal virtual {
545         require(owner != address(0), "ERC20: approve from the zero address");
546         require(spender != address(0), "ERC20: approve to the zero address");
547 
548         _allowances[owner][spender] = amount;
549         emit Approval(owner, spender, amount);
550     }
551 
552     
553     /**
554      * @dev Hook that is called before any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * will be to transferred to `to`.
561      * - when `from` is zero, `amount` tokens will be minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
568 }
569 
570 contract BitBotTokenV1 is ERC20 {
571 
572     constructor() ERC20("BitBot V1", "BBP") {
573         
574         _mint(msg.sender, 10000e18);
575     }
576 
577     function burn(uint256 amount) external {
578         _burn(msg.sender, amount);
579     }
580 }