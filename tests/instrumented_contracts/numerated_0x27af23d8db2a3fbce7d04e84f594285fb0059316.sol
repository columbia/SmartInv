1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4     /**
5      * @dev Returns the addition of two unsigned integers, reverting on
6      * overflow.
7      *
8      * Counterpart to Solidity's `+` operator.
9      *
10      * Requirements:
11      *
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      *
29      * - Subtraction cannot overflow.
30      */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      *
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      *
86      * - The divisor cannot be zero.
87      */
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
125         return mod(a, b, "SafeMath: modulo by zero");
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts with custom message when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b != 0, errorMessage);
142         return a % b;
143     }
144 }
145 
146 pragma solidity ^0.6.0;
147 
148 /**
149  * @dev Interface of the ERC20 standard as defined in the EIP.
150  */
151 interface IERC20 {
152     /**
153      * @dev Returns the amount of tokens in existence.
154      */
155     function totalSupply() external view returns (uint256);
156 
157     /**
158      * @dev Returns the amount of tokens owned by `account`.
159      */
160     function balanceOf(address account) external view returns (uint256);
161 
162     /**
163      * @dev Moves `amount` tokens from the caller's account to `recipient`.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transfer(address recipient, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through {transferFrom}. This is
174      * zero by default.
175      *
176      * This value changes when {approve} or {transferFrom} are called.
177      */
178     function allowance(address owner, address spender) external view returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * IMPORTANT: Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `sender` to `recipient` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Emitted when `value` tokens are moved from one account (`from`) to
209      * another (`to`).
210      *
211      * Note that `value` may be zero.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     /**
216      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
217      * a call to {approve}. `value` is the new allowance.
218      */
219     event Approval(address indexed owner, address indexed spender, uint256 value);
220 }
221 
222 contract ERC20 is IERC20 {
223     using SafeMath for uint256;
224 
225     mapping (address => uint256) private _balances;
226 
227     mapping (address => mapping (address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233     uint8 private _decimals;
234 
235     /**
236      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
237      * a default value of 18.
238      *
239      * To select a different value for {decimals}, use {_setupDecimals}.
240      *
241      * All three of these values are immutable: they can only be set once during
242      * construction.
243      */
244     constructor (string memory name, string memory symbol) public {
245         _name = name;
246         _symbol = symbol;
247         _decimals = 18;
248     }
249 
250     /**
251      * @dev Returns the name of the token.
252      */
253     function name() public view returns (string memory) {
254         return _name;
255     }
256 
257     /**
258      * @dev Returns the symbol of the token, usually a shorter version of the
259      * name.
260      */
261     function symbol() public view returns (string memory) {
262         return _symbol;
263     }
264 
265     /**
266      * @dev Returns the number of decimals used to get its user representation.
267      * For example, if `decimals` equals `2`, a balance of `505` tokens should
268      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
269      *
270      * Tokens usually opt for a value of 18, imitating the relationship between
271      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
272      * called.
273      *
274      * NOTE: This information is only used for _display_ purposes: it in
275      * no way affects any of the arithmetic of the contract, including
276      * {IERC20-balanceOf} and {IERC20-transfer}.
277      */
278     function decimals() public view returns (uint8) {
279         return _decimals;
280     }
281 
282     /**
283      * @dev See {IERC20-totalSupply}.
284      */
285     function totalSupply() public view override returns (uint256) {
286         return _totalSupply;
287     }
288 
289     /**
290      * @dev See {IERC20-balanceOf}.
291      */
292     function balanceOf(address account) public view override returns (uint256) {
293         return _balances[account];
294     }
295 
296     /**
297      * @dev See {IERC20-transfer}.
298      *
299      * Requirements:
300      *
301      * - `recipient` cannot be the zero address.
302      * - the caller must have a balance of at least `amount`.
303      */
304     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
305         _transfer(msg.sender, recipient, amount);
306         return true;
307     }
308 
309     /**
310      * @dev See {IERC20-allowance}.
311      */
312     function allowance(address owner, address spender) public view virtual override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315 
316     /**
317      * @dev See {IERC20-approve}.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function approve(address spender, uint256 amount) public virtual override returns (bool) {
324         _approve(msg.sender, spender, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-transferFrom}.
330      *
331      * Emits an {Approval} event indicating the updated allowance. This is not
332      * required by the EIP. See the note at the beginning of {ERC20};
333      *
334      * Requirements:
335      * - `sender` and `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      * - the caller must have allowance for ``sender``'s tokens of at least
338      * `amount`.
339      */
340     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
341         _transfer(sender, recipient, amount);
342         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
343         return true;
344     }
345 
346     /**
347      * @dev Atomically increases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
359         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
360         return true;
361     }
362 
363     /**
364      * @dev Atomically decreases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      * - `spender` must have allowance for the caller of at least
375      * `subtractedValue`.
376      */
377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
379         return true;
380     }
381 
382     /**
383      * @dev Moves tokens `amount` from `sender` to `recipient`.
384      *
385      * This is internal function is equivalent to {transfer}, and can be used to
386      * e.g. implement automatic token fees, slashing mechanisms, etc.
387      *
388      * Emits a {Transfer} event.
389      *
390      * Requirements:
391      *
392      * - `sender` cannot be the zero address.
393      * - `recipient` cannot be the zero address.
394      * - `sender` must have a balance of at least `amount`.
395      */
396     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
397         require(sender != address(0), "ERC20: transfer from the zero address");
398         require(recipient != address(0), "ERC20: transfer to the zero address");
399 
400         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
401         _balances[recipient] = _balances[recipient].add(amount);
402         emit Transfer(sender, recipient, amount);
403     }
404 
405     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
406      * the total supply.
407      *
408      * Emits a {Transfer} event with `from` set to the zero address.
409      *
410      * Requirements
411      *
412      * - `to` cannot be the zero address.
413      */
414     function _mint(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: mint to the zero address");
416 
417         _totalSupply = _totalSupply.add(amount);
418         _balances[account] = _balances[account].add(amount);
419         emit Transfer(address(0), account, amount);
420     }
421 
422     /**
423      * @dev Destroys `amount` tokens from `account`, reducing the
424      * total supply.
425      *
426      * Emits a {Transfer} event with `to` set to the zero address.
427      *
428      * Requirements
429      *
430      * - `account` cannot be the zero address.
431      * - `account` must have at least `amount` tokens.
432      */
433     function _burn(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: burn from the zero address");
435 
436         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
437         _totalSupply = _totalSupply.sub(amount);
438         emit Transfer(account, address(0), amount);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
443      *
444      * This is internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(address owner, address spender, uint256 amount) internal virtual {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 
462     /**
463      * @dev Sets {decimals} to a value other than the default one of 18.
464      *
465      * WARNING: This function should only be called from the constructor. Most
466      * applications that interact with token contracts will not expect
467      * {decimals} to ever change, and may work incorrectly if it does.
468      */
469     function _setupDecimals(uint8 decimals_) internal {
470         _decimals = decimals_;
471     }
472 
473 }
474 
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address payable) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes memory) {
481         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
482         return msg.data;
483     }
484 }
485 
486 contract Ownable is Context {
487     address private _owner;
488 
489     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
490 
491     /**
492      * @dev Initializes the contract setting the deployer as the initial owner.
493      */
494     constructor () internal {
495         address msgSender = _msgSender();
496         _owner = msgSender;
497         emit OwnershipTransferred(address(0), msgSender);
498     }
499 
500     /**
501      * @dev Returns the address of the current owner.
502      */
503     function owner() public view returns (address) {
504         return _owner;
505     }
506 
507     /**
508      * @dev Throws if called by any account other than the owner.
509      */
510     modifier onlyOwner() {
511         require(_owner == _msgSender(), "Ownable: caller is not the owner");
512         _;
513     }
514 
515     /**
516      * @dev Leaves the contract without owner. It will not be possible to call
517      * `onlyOwner` functions anymore. Can only be called by the current owner.
518      *
519      * NOTE: Renouncing ownership will leave the contract without an owner,
520      * thereby removing any functionality that is only available to the owner.
521      */
522     function renounceOwnership() public virtual onlyOwner {
523         emit OwnershipTransferred(_owner, address(0));
524         _owner = address(0);
525     }
526 
527     /**
528      * @dev Transfers ownership of the contract to a new account (`newOwner`).
529      * Can only be called by the current owner.
530      */
531     function transferOwnership(address newOwner) public virtual onlyOwner {
532         require(newOwner != address(0), "Ownable: new owner is the zero address");
533         emit OwnershipTransferred(_owner, newOwner);
534         _owner = newOwner;
535     }
536 }
537 
538 
539 contract UniMex is ERC20("https://unimex.finance/", "UMEX"), Ownable {
540  
541    mapping(address => bool) public whitelist;
542    bool public locked;
543     
544     constructor() public {
545         locked = true;
546     }
547 
548     function unlock() public onlyOwner {
549         locked = false;
550     } 
551 
552     function lock() public onlyOwner {
553         locked = true;
554     }
555 
556     function add(address _user) public onlyOwner {
557         whitelist[_user] = true;
558     }
559 
560     function remove(address _user) public onlyOwner {
561         whitelist[_user] = false;
562     }
563     
564     function mint(address _to, uint256 _amount) public onlyOwner {
565         _mint(_to, _amount);
566     }
567     
568     function transfer(address to, uint256 amount) public override returns (bool) {
569         if(locked) {
570             require(msg.sender == owner() || whitelist[msg.sender]);
571         }
572         return super.transfer(to, amount);
573     }
574 
575     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
576         if(locked) {
577             require(from == owner() || whitelist[from]);
578         }
579         return super.transferFrom(from, to, amount);
580     }
581 
582 }