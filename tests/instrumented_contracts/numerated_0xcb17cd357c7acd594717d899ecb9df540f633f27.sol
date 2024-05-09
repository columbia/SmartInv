1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Contract module which provides a basic access control mechanism, where
5  * there is an account (an owner) that can be granted exclusive access to
6  * specific functions.
7  *
8  * This module is used through inheritance. It will make available the modifier
9  * `onlyOwner`, which can be aplied to your functions to restrict their use to
10  * the owner.
11  */
12 contract Ownable {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev Initializes the contract setting the deployer as the initial owner.
19      */
20     constructor () internal {
21         _owner = msg.sender;
22         emit OwnershipTransferred(address(0), _owner);
23     }
24 
25     /**
26      * @dev Returns the address of the current owner.
27      */
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(isOwner(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     /**
41      * @dev Returns true if the caller is the current owner.
42      */
43     function isOwner() public view returns (bool) {
44         return msg.sender == _owner;
45     }
46 
47     /**
48      * @dev Leaves the contract without owner. It will not be possible to call
49      * `onlyOwner` functions anymore. Can only be called by the current owner.
50      *
51      * > Note: Renouncing ownership will leave the contract without an owner,
52      * thereby removing any functionality that is only available to the owner.
53      */
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58 
59     /**
60      * @dev Transfers ownership of the contract to a new account (`newOwner`).
61      * Can only be called by the current owner.
62      */
63     function transferOwnership(address newOwner) public onlyOwner {
64         _transferOwnership(newOwner);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 /**
78  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
79  * the optional functions; to access them see `ERC20Detailed`.
80  */
81 interface IERC20 {
82     /**
83      * @dev Returns the amount of tokens in existence.
84      */
85     function totalSupply() external view returns (uint256);
86 
87     /**
88      * @dev Returns the amount of tokens owned by `account`.
89      */
90     function balanceOf(address account) external view returns (uint256);
91 
92     /**
93      * @dev Moves `amount` tokens from the caller's account to `recipient`.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a `Transfer` event.
98      */
99     function transfer(address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Returns the remaining number of tokens that `spender` will be
103      * allowed to spend on behalf of `owner` through `transferFrom`. This is
104      * zero by default.
105      *
106      * This value changes when `approve` or `transferFrom` are called.
107      */
108     function allowance(address owner, address spender) external view returns (uint256);
109 
110     /**
111      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * > Beware that changing an allowance with this method brings the risk
116      * that someone may use both the old and the new allowance by unfortunate
117      * transaction ordering. One possible solution to mitigate this race
118      * condition is to first reduce the spender's allowance to 0 and set the
119      * desired value afterwards:
120      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121      *
122      * Emits an `Approval` event.
123      */
124     function approve(address spender, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Moves `amount` tokens from `sender` to `recipient` using the
128      * allowance mechanism. `amount` is then deducted from the caller's
129      * allowance.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a `Transfer` event.
134      */
135     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Emitted when `value` tokens are moved from one account (`from`) to
139      * another (`to`).
140      *
141      * Note that `value` may be zero.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     /**
146      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
147      * a call to `approve`. `value` is the new allowance.
148      */
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 /**
153  * @dev Optional functions from the ERC20 standard.
154  */
155 contract ERC20Detailed is IERC20 {
156     string private _name;
157     string private _symbol;
158     uint8 private _decimals;
159 
160     /**
161      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
162      * these values are immutable: they can only be set once during
163      * construction.
164      */
165     constructor (string memory name, string memory symbol, uint8 decimals) public {
166         _name = name;
167         _symbol = symbol;
168         _decimals = decimals;
169     }
170 
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() public view returns (string memory) {
175         return _name;
176     }
177 
178     /**
179      * @dev Returns the symbol of the token, usually a shorter version of the
180      * name.
181      */
182     function symbol() public view returns (string memory) {
183         return _symbol;
184     }
185 
186     /**
187      * @dev Returns the number of decimals used to get its user representation.
188      * For example, if `decimals` equals `2`, a balance of `505` tokens should
189      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
190      *
191      * Tokens usually opt for a value of 18, imitating the relationship between
192      * Ether and Wei.
193      *
194      * > Note that this information is only used for _display_ purposes: it in
195      * no way affects any of the arithmetic of the contract, including
196      * `IERC20.balanceOf` and `IERC20.transfer`.
197      */
198     function decimals() public view returns (uint8) {
199         return _decimals;
200     }
201 }
202 
203 library SafeMath {
204     /**
205      * @dev Returns the addition of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `+` operator.
209      *
210      * Requirements:
211      * - Addition cannot overflow.
212      */
213     function add(uint256 a, uint256 b) internal pure returns (uint256) {
214         uint256 c = a + b;
215         require(c >= a, "SafeMath: addition overflow");
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      * - Subtraction cannot overflow.
228      */
229     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b <= a, "SafeMath: subtraction overflow");
231         uint256 c = a - b;
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `*` operator.
241      *
242      * Requirements:
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         uint256 c = a * b;
254         require(c / a == b, "SafeMath: multiplication overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      * - The divisor cannot be zero.
269      */
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Solidity only automatically asserts when dividing by 0
272         require(b > 0, "SafeMath: division by zero");
273         uint256 c = a / b;
274         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * Reverts when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      * - The divisor cannot be zero.
289      */
290     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
291         require(b != 0, "SafeMath: modulo by zero");
292         return a % b;
293     }
294 }
295 
296 /**
297  * @dev Implementation of the `IERC20` interface.
298  *
299  * This implementation is agnostic to the way tokens are created. This means
300  * that a supply mechanism has to be added in a derived contract using `_mint`.
301  * For a generic mechanism see `ERC20Mintable`.
302  *
303  * *For a detailed writeup see our guide [How to implement supply
304  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
305  *
306  * We have followed general OpenZeppelin guidelines: functions revert instead
307  * of returning `false` on failure. This behavior is nonetheless conventional
308  * and does not conflict with the expectations of ERC20 applications.
309  *
310  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
311  * This allows applications to reconstruct the allowance for all accounts just
312  * by listening to said events. Other implementations of the EIP may not emit
313  * these events, as it isn't required by the specification.
314  *
315  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
316  * functions have been added to mitigate the well-known issues around setting
317  * allowances. See `IERC20.approve`.
318  */
319 contract ERC20 is IERC20 {
320     using SafeMath for uint256;
321 
322     mapping (address => uint256) private _balances;
323 
324     mapping (address => mapping (address => uint256)) private _allowances;
325 
326     uint256 private _totalSupply;
327 
328     /**
329      * @dev See `IERC20.totalSupply`.
330      */
331     function totalSupply() public view returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See `IERC20.balanceOf`.
337      */
338     function balanceOf(address account) public view returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See `IERC20.transfer`.
344      *
345      * Requirements:
346      *
347      * - `recipient` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address recipient, uint256 amount) public returns (bool) {
351         _transfer(msg.sender, recipient, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See `IERC20.allowance`.
357      */
358     function allowance(address owner, address spender) public view returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See `IERC20.approve`.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 value) public returns (bool) {
370         _approve(msg.sender, spender, value);
371         return true;
372     }
373 
374     /**
375      * @dev See `IERC20.transferFrom`.
376      *
377      * Emits an `Approval` event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of `ERC20`;
379      *
380      * Requirements:
381      * - `sender` and `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `value`.
383      * - the caller must have allowance for `sender`'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
387         _transfer(sender, recipient, amount);
388         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
389         return true;
390     }
391 
392     /**
393      * @dev Atomically increases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to `approve` that can be used as a mitigation for
396      * problems described in `IERC20.approve`.
397      *
398      * Emits an `Approval` event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
405         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
406         return true;
407     }
408 
409     /**
410      * @dev Atomically decreases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to `approve` that can be used as a mitigation for
413      * problems described in `IERC20.approve`.
414      *
415      * Emits an `Approval` event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      * - `spender` must have allowance for the caller of at least
421      * `subtractedValue`.
422      */
423     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
424         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
425         return true;
426     }
427 
428     /**
429      * @dev Moves tokens `amount` from `sender` to `recipient`.
430      *
431      * This is internal function is equivalent to `transfer`, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a `Transfer` event.
435      *
436      * Requirements:
437      *
438      * - `sender` cannot be the zero address.
439      * - `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      */
442     function _transfer(address sender, address recipient, uint256 amount) internal {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445 
446         _balances[sender] = _balances[sender].sub(amount);
447         _balances[recipient] = _balances[recipient].add(amount);
448         emit Transfer(sender, recipient, amount);
449     }
450 
451     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
452      * the total supply.
453      *
454      * Emits a `Transfer` event with `from` set to the zero address.
455      *
456      * Requirements
457      *
458      * - `to` cannot be the zero address.
459      */
460     function _mint(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: mint to the zero address");
462 
463         _totalSupply = _totalSupply.add(amount);
464         _balances[account] = _balances[account].add(amount);
465         emit Transfer(address(0), account, amount);
466     }
467 
468      /**
469      * @dev Destoys `amount` tokens from `account`, reducing the
470      * total supply.
471      *
472      * Emits a `Transfer` event with `to` set to the zero address.
473      *
474      * Requirements
475      *
476      * - `account` cannot be the zero address.
477      * - `account` must have at least `amount` tokens.
478      */
479     function _burn(address account, uint256 value) internal {
480         require(account != address(0), "ERC20: burn from the zero address");
481 
482         _totalSupply = _totalSupply.sub(value);
483         _balances[account] = _balances[account].sub(value);
484         emit Transfer(account, address(0), value);
485     }
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
489      *
490      * This is internal function is equivalent to `approve`, and can be used to
491      * e.g. set automatic allowances for certain subsystems, etc.
492      *
493      * Emits an `Approval` event.
494      *
495      * Requirements:
496      *
497      * - `owner` cannot be the zero address.
498      * - `spender` cannot be the zero address.
499      */
500     function _approve(address owner, address spender, uint256 value) internal {
501         require(owner != address(0), "ERC20: approve from the zero address");
502         require(spender != address(0), "ERC20: approve to the zero address");
503 
504         _allowances[owner][spender] = value;
505         emit Approval(owner, spender, value);
506     }
507 
508     /**
509      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
510      * from the caller's allowance.
511      *
512      * See `_burn` and `_approve`.
513      */
514     function _burnFrom(address account, uint256 amount) internal {
515         _burn(account, amount);
516         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
517     }
518 }
519 
520 library Address {
521     /**
522      * @dev Returns true if `account` is a contract.
523      *
524      * This test is non-exhaustive, and there may be false-negatives: during the
525      * execution of a contract's constructor, its address will be reported as
526      * not containing a contract.
527      *
528      * > It is unsafe to assume that an address for which this function returns
529      * false is an externally-owned account (EOA) and not a contract.
530      */
531     function isContract(address account) internal view returns (bool) {
532         // This method relies in extcodesize, which returns 0 for contracts in
533         // construction, since the code is only stored at the end of the
534         // constructor execution.
535 
536         uint256 size;
537         // solhint-disable-next-line no-inline-assembly
538         assembly { size := extcodesize(account) }
539         return size > 0;
540     }
541 }
542 
543 interface IERC223Recipient {
544     function tokenFallback(address _from, uint _value, bytes calldata _data) external;
545 }
546 
547 contract CoindealToken is ERC20Detailed, ERC20, Ownable {
548     // ERC223 event override
549     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
550 
551     constructor (
552         string memory name,
553         string memory symbol,
554         uint8 decimals,
555         uint256 supply
556     ) ERC20Detailed(name, symbol, decimals) public {
557         _mint(msg.sender, supply);
558     }
559 
560     function transfer(address recipient, uint amount, bytes memory data) public returns (bool) {
561         _transfer(msg.sender, recipient, amount);  // emits ERC20 transfer event
562         if(Address.isContract(recipient)) {
563             IERC223Recipient receiver = IERC223Recipient(recipient);
564             receiver.tokenFallback(msg.sender, amount, data);  // fallback function with data
565         }
566         emit Transfer(msg.sender, recipient, amount, data);  // second transfer event for ERC223
567         return true;
568     }
569 }