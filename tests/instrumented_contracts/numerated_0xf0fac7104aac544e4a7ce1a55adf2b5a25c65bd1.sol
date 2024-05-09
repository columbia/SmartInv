1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-06
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.9;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 
82 }
83 
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address payable) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes memory) {
90         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
91         return msg.data;
92     }
93 }
94 
95 /**
96  * @dev Wrappers over Solidity's arithmetic operations with added overflow
97  * checks.
98  *
99  * Arithmetic operations in Solidity wrap on overflow. This can easily result
100  * in bugs, because programmers usually assume that an overflow raises an
101  * error, which is the standard behavior in high level programming languages.
102  * `SafeMath` restores this intuition by reverting the transaction when an
103  * operation overflows.
104  *
105  * Using this library instead of the unchecked operations eliminates an entire
106  * class of bugs, so it's recommended to use it always.
107  */
108 library SafeMath {
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b > 0, errorMessage);
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 contract Ownable is Context {
244     address private _owner;
245 
246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247 
248     /**
249      * @dev Initializes the contract setting the deployer as the initial owner.
250      */
251     constructor () internal {
252         address msgSender = _msgSender();
253         _owner = msgSender;
254         emit OwnershipTransferred(address(0), msgSender);
255     }
256 
257     /**
258      * @dev Returns the address of the current owner.
259      */
260     function owner() public view returns (address) {
261         return _owner;
262     }
263 
264     /**
265      * @dev Throws if called by any account other than the owner.
266      */
267     modifier onlyOwner() {
268         require(_owner == _msgSender(), "Ownable: caller is not the owner");
269         _;
270     }
271 
272     /**
273      * @dev Leaves the contract without owner. It will not be possible to call
274      * `onlyOwner` functions anymore. Can only be called by the current owner.
275      *
276      * NOTE: Renouncing ownership will leave the contract without an owner,
277      * thereby removing any functionality that is only available to the owner.
278      */
279     function renounceOwnership() public virtual onlyOwner {
280         emit OwnershipTransferred(_owner, address(0));
281         _owner = address(0);
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      * Can only be called by the current owner.
287      */
288     function transferOwnership(address newOwner) public virtual onlyOwner {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         emit OwnershipTransferred(_owner, newOwner);
291         _owner = newOwner;
292     }
293 }
294 
295 abstract contract StakePampToken {
296     function transferHook(address sender, address recipient, uint256 amount, uint256 senderBalance, uint256 recipientBalance) external virtual returns (uint256, uint256, uint256);
297     function updateMyStakes(address staker, uint256 balance, uint256 totalSupply) external virtual returns (uint256);
298 }
299 
300 
301 /**
302  * @dev Implementation of the Pamp Network: https://pamp.network
303  * Pamp Network (PAMP) is the world's first price-reactive cryptocurrency.
304  * That is, the inflation rate of the token is wholly dependent on its market activity.
305  * Minting does not happen when the price is less than the day prior.
306  * When the price is greater than the day prior, the inflation for that day is
307  * a function of its price, percent increase, volume, any positive price streaks,
308  * and the amount of time any given holder has been holding.
309  * In the first iteration, the dev team acts as the price oracle, but in the future, we plan to integrate a Chainlink price oracle.
310  */
311 contract PampToken is Ownable, IERC20 {
312     using SafeMath for uint256;
313 
314     mapping (address => uint256) private _balances;
315 
316     mapping (address => mapping (address => uint256)) private _allowances;
317     
318     uint256 private _totalSupply;
319     
320     string public constant _name = "Pamp Network";
321     string public constant _symbol = "PAMP";
322     uint8 public constant _decimals = 18;
323     
324     StakePampToken public _stakingContract;
325     
326     bool private _stakingEnabled;
327     
328     modifier onlyStakingContract() {
329         require(msg.sender == address(_stakingContract), "Ownable: caller is not the staking contract");
330         _;
331     }
332     
333     event ErrorMessage(string errorMessage);
334     
335      
336     constructor () public {
337         _mint(msg.sender, 3000000E18);
338         _stakingEnabled = false;
339     }
340     
341     
342     
343     function updateMyStakes() public {
344         
345         require(_stakingEnabled, "Staking is disabled");
346         
347         
348         try _stakingContract.updateMyStakes(msg.sender, _balances[msg.sender], _totalSupply) returns (uint256 numTokens) {
349             _mint(msg.sender, numTokens);
350         } catch Error (string memory error) {
351             emit ErrorMessage(error);
352         }
353     }
354     
355     function updateStakingContract(StakePampToken stakingContract) external onlyOwner {
356         _stakingContract = stakingContract;
357         _stakingEnabled = true;
358     }
359     
360 
361     /**
362      * @dev Returns the name of the token.
363      */
364     function name() public view returns (string memory) {
365         return _name;
366     }
367 
368     /**
369      * @dev Returns the symbol of the token, usually a shorter version of the
370      * name.
371      */
372     function symbol() public view returns (string memory) {
373         return _symbol;
374     }
375 
376     /**
377      * @dev Returns the number of decimals used to get its user representation.
378      * For example, if `decimals` equals `2`, a balance of `505` tokens should
379      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
380      *
381      * Tokens usually opt for a value of 18, imitating the relationship between
382      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
383      * called.
384      *
385      * NOTE: This information is only used for _display_ purposes: it in
386      * no way affects any of the arithmetic of the contract, including
387      * {IERC20-balanceOf} and {IERC20-transfer}.
388      */
389     function decimals() public view returns (uint8) {
390         return _decimals;
391     }
392 
393     /**
394      * @dev See {IERC20-totalSupply}.
395      */
396     function totalSupply() public view override returns (uint256) {
397         return _totalSupply;
398     }
399 
400     /**
401      * @dev See {IERC20-balanceOf}.
402      */
403     function balanceOf(address account) public view override returns (uint256) {
404         return _balances[account];
405     }
406 
407     /**
408      * @dev See {IERC20-transfer}.
409      *
410      * Requirements:
411      *
412      * - `recipient` cannot be the zero address.
413      * - the caller must have a balance of at least `amount`.
414      */
415     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
416         _transfer(_msgSender(), recipient, amount);
417         return true;
418     }
419 
420     /**
421      * @dev See {IERC20-allowance}.
422      */
423     function allowance(address owner, address spender) public view virtual override returns (uint256) {
424         return _allowances[owner][spender];
425     }
426 
427     /**
428      * @dev See {IERC20-approve}.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function approve(address spender, uint256 amount) public virtual override returns (bool) {
435         _approve(_msgSender(), spender, amount);
436         return true;
437     }
438 
439     /**
440      * @dev See {IERC20-transferFrom}.
441      *
442      * Emits an {Approval} event indicating the updated allowance. This is not
443      * required by the EIP. See the note at the beginning of {ERC20};
444      *
445      * Requirements:
446      * - `sender` and `recipient` cannot be the zero address.
447      * - `sender` must have a balance of at least `amount`.
448      * - the caller must have allowance for ``sender``'s tokens of at least
449      * `amount`.
450      */
451     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
452         _transfer(sender, recipient, amount);
453         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
454         return true;
455     }
456 
457     /**
458      * @dev Atomically increases the allowance granted to `spender` by the caller.
459      *
460      * This is an alternative to {approve} that can be used as a mitigation for
461      * problems described in {IERC20-approve}.
462      *
463      * Emits an {Approval} event indicating the updated allowance.
464      *
465      * Requirements:
466      *
467      * - `spender` cannot be the zero address.
468      */
469     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
470         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
471         return true;
472     }
473 
474     /**
475      * @dev Atomically decreases the allowance granted to `spender` by the caller.
476      *
477      * This is an alternative to {approve} that can be used as a mitigation for
478      * problems described in {IERC20-approve}.
479      *
480      * Emits an {Approval} event indicating the updated allowance.
481      *
482      * Requirements:
483      *
484      * - `spender` cannot be the zero address.
485      * - `spender` must have allowance for the caller of at least
486      * `subtractedValue`.
487      */
488     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
489         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
490         return true;
491     }
492 
493     /**
494      * @dev Moves tokens `amount` from `sender` to `recipient`.
495      *
496      * This is internal function is equivalent to {transfer}, and can be used to
497      * e.g. implement automatic token fees, slashing mechanisms, etc.
498      *
499      * Emits a {Transfer} event.
500      *
501      * Requirements:
502      *
503      * - `sender` cannot be the zero address.
504      * - `recipient` cannot be the zero address.
505      * - `sender` must have a balance of at least `amount`.
506      */
507     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
508         
509         require(sender != address(0), "ERC20: transfer from the zero address");
510         require(recipient != address(0), "ERC20: transfer to the zero address");
511         require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
512         
513         if(_stakingEnabled) {
514             
515             try _stakingContract.transferHook(sender, recipient, amount, _balances[sender], _balances[recipient]) returns (uint256 senderBalance, uint256 recipientBalance, uint256 burnAmount) {
516             
517                 _balances[sender] = senderBalance;
518                 _balances[recipient] = recipientBalance;
519                 _totalSupply = _totalSupply.sub(burnAmount);
520                 if (burnAmount > 0) {
521                     emit Transfer(sender, recipient, amount.sub(burnAmount));
522                     emit Transfer(sender, address(0), burnAmount);
523                 } else {
524                     emit Transfer(sender, recipient, amount);
525                 }
526             } catch Error (string memory error) {
527                 emit ErrorMessage(error);
528             }
529             
530         } else {
531             _balances[sender] = _balances[sender].sub(amount);
532             _balances[recipient] = _balances[recipient].add(amount);
533             emit Transfer(sender, recipient, amount);
534         }
535     }
536 
537     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
538      * the total supply.
539      *
540      * Emits a {Transfer} event with `from` set to the zero address.
541      *
542      * Requirements
543      *
544      * - `to` cannot be the zero address.
545      */
546     function _mint(address account, uint256 amount) internal virtual {
547         require(account != address(0), "ERC20: mint to the zero address");
548 
549         _totalSupply = _totalSupply.add(amount);
550         _balances[account] = _balances[account].add(amount);
551         emit Transfer(address(0), account, amount);
552     }
553     
554     
555     function mint(address account, uint256 amount) public onlyStakingContract {
556         require(account != address(0), "ERC20: mint to the zero address");
557 
558         _totalSupply = _totalSupply.add(amount);
559         _balances[account] = _balances[account].add(amount);
560         emit Transfer(address(0), account, amount);
561     }
562 
563     /**
564      * @dev Destroys `amount` tokens from `account`, reducing the
565      * total supply.
566      *
567      * Emits a {Transfer} event with `to` set to the zero address.
568      *
569      * Requirements
570      *
571      * - `account` cannot be the zero address.
572      * - `account` must have at least `amount` tokens.
573      */
574     function _burn(address account, uint256 amount) external onlyStakingContract {
575 
576         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
577         _totalSupply = _totalSupply.sub(amount);
578         emit Transfer(account, address(0), amount);
579     }
580     
581     function burn(uint256 amount) external {
582         _balances[_msgSender()] = _balances[_msgSender()].sub(amount, "ERC20: burn amount exceeds balance");
583         _totalSupply = _totalSupply.sub(amount);
584         emit Transfer(_msgSender(), address(0), amount);
585     }
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
589      *
590      * This is internal function is equivalent to `approve`, and can be used to
591      * e.g. set automatic allowances for certain subsystems, etc.
592      *
593      * Emits an {Approval} event.
594      *
595      * Requirements:
596      *
597      * - `owner` cannot be the zero address.
598      * - `spender` cannot be the zero address.
599      */
600     function _approve(address owner, address spender, uint256 amount) internal virtual {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 }