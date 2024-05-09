1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * This module is used through inheritance. It will make available the modifier
164  * `onlyOwner`, which can be applied to your functions to restrict their use to
165  * the owner.
166  */
167 contract Ownable {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor () internal {
176         address msgSender = msg.sender;
177         _owner = msgSender;
178         emit OwnershipTransferred(address(0), msgSender);
179     }
180 
181     /**
182      * @dev Returns the address of the current owner.
183      */
184     function owner() public view returns (address) {
185         return _owner;
186     }
187 
188     /**
189      * @dev Throws if called by any account other than the owner.
190      */
191     modifier onlyOwner() {
192         require(isOwner(), "Ownable: caller is not the owner");
193         _;
194     }
195 
196     /**
197      * @dev Returns true if the caller is the current owner.
198      */
199     function isOwner() public view returns (bool) {
200         return msg.sender == _owner;
201     }
202 
203     /**
204      * @dev Leaves the contract without owner. It will not be possible to call
205      * `onlyOwner` functions anymore. Can only be called by the current owner.
206      *
207      * NOTE: Renouncing ownership will leave the contract without an owner,
208      * thereby removing any functionality that is only available to the owner.
209      */
210     function renounceOwnership() public onlyOwner {
211         emit OwnershipTransferred(_owner, address(0));
212         _owner = address(0);
213     }
214 
215     /**
216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
217      * Can only be called by the current owner.
218      */
219     function transferOwnership(address newOwner) public onlyOwner {
220         _transferOwnership(newOwner);
221     }
222 
223     /**
224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
225      */
226     function _transferOwnership(address newOwner) internal {
227         require(newOwner != address(0), "Ownable: new owner is the zero address");
228         emit OwnershipTransferred(_owner, newOwner);
229         _owner = newOwner;
230     }
231 }
232 
233 /**
234  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
235  * the optional functions; to access them see {ERC20Detailed}.
236  */
237 interface IERC20 {
238     /**
239      * @dev Returns the amount of tokens in existence.
240      */
241     function totalSupply() external view returns (uint256);
242 
243     /**
244      * @dev Returns the amount of tokens owned by `account`.
245      */
246     function balanceOf(address account) external view returns (uint256);
247 
248     /**
249      * @dev Moves `amount` tokens from the caller's account to `recipient`.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transfer(address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Returns the remaining number of tokens that `spender` will be
259      * allowed to spend on behalf of `owner` through {transferFrom}. This is
260      * zero by default.
261      *
262      * This value changes when {approve} or {transferFrom} are called.
263      */
264     function allowance(address owner, address spender) external view returns (uint256);
265 
266     /**
267      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * IMPORTANT: Beware that changing an allowance with this method brings the risk
272      * that someone may use both the old and the new allowance by unfortunate
273      * transaction ordering. One possible solution to mitigate this race
274      * condition is to first reduce the spender's allowance to 0 and set the
275      * desired value afterwards:
276      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277      *
278      * Emits an {Approval} event.
279      */
280     function approve(address spender, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Moves `amount` tokens from `sender` to `recipient` using the
284      * allowance mechanism. `amount` is then deducted from the caller's
285      * allowance.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Emitted when `value` tokens are moved from one account (`from`) to
295      * another (`to`).
296      *
297      * Note that `value` may be zero.
298      */
299     event Transfer(address indexed from, address indexed to, uint256 value);
300 
301     /**
302      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
303      * a call to {approve}. `value` is the new allowance.
304      */
305     event Approval(address indexed owner, address indexed spender, uint256 value);
306 }
307 
308 /**
309  * @dev Implementation of the {IERC20} interface.
310  *
311  * This implementation is agnostic to the way tokens are created. This means
312  * that a supply mechanism has to be added in a derived contract using {_mint}.
313  * For a generic mechanism see {ERC20Mintable}.
314  *
315  * TIP: For a detailed writeup see our guide
316  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
317  * to implement supply mechanisms].
318  *
319  * We have followed general OpenZeppelin guidelines: functions revert instead
320  * of returning `false` on failure. This behavior is nonetheless conventional
321  * and does not conflict with the expectations of ERC20 applications.
322  *
323  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
324  * This allows applications to reconstruct the allowance for all accounts just
325  * by listening to said events. Other implementations of the EIP may not emit
326  * these events, as it isn't required by the specification.
327  *
328  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
329  * functions have been added to mitigate the well-known issues around setting
330  * allowances. See {IERC20-approve}.
331  */
332 contract ERC20 is IERC20 {
333     using SafeMath for uint256;
334 
335     mapping (address => uint256) private _balances;
336 
337     mapping (address => mapping (address => uint256)) private _allowances;
338 
339     uint256 private _totalSupply;
340 
341     /**
342      * @dev See {IERC20-totalSupply}.
343      */
344     function totalSupply() public view returns (uint256) {
345         return _totalSupply;
346     }
347 
348     /**
349      * @dev See {IERC20-balanceOf}.
350      */
351     function balanceOf(address account) public view returns (uint256) {
352         return _balances[account];
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
363     function transfer(address recipient, uint256 amount) public returns (bool) {
364         _transfer(msg.sender, recipient, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-allowance}.
370      */
371     function allowance(address owner, address spender) public view returns (uint256) {
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
382     function approve(address spender, uint256 amount) public returns (bool) {
383         _approve(msg.sender, spender, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-transferFrom}.
389      *
390      * Emits an {Approval} event indicating the updated allowance. This is not
391      * required by the EIP. See the note at the beginning of {ERC20};
392      *
393      * Requirements:
394      * - `sender` and `recipient` cannot be the zero address.
395      * - `sender` must have a balance of at least `amount`.
396      * - the caller must have allowance for `sender`'s tokens of at least
397      * `amount`.
398      */
399     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
400         _transfer(sender, recipient, amount);
401         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
402         return true;
403     }
404 
405     /**
406      * @dev Atomically increases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
418         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
419         return true;
420     }
421 
422     /**
423      * @dev Atomically decreases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      * - `spender` must have allowance for the caller of at least
434      * `subtractedValue`.
435      */
436     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
437         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
438         return true;
439     }
440 
441     /**
442      * @dev Moves tokens `amount` from `sender` to `recipient`.
443      *
444      * This is internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `sender` cannot be the zero address.
452      * - `recipient` cannot be the zero address.
453      * - `sender` must have a balance of at least `amount`.
454      */
455     function _transfer(address sender, address recipient, uint256 amount) internal {
456         require(sender != address(0), "ERC20: transfer from the zero address");
457         require(recipient != address(0), "ERC20: transfer to the zero address");
458 
459         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
460         _balances[recipient] = _balances[recipient].add(amount);
461         emit Transfer(sender, recipient, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements
470      *
471      * - `to` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _totalSupply = _totalSupply.add(amount);
477         _balances[account] = _balances[account].add(amount);
478         emit Transfer(address(0), account, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal {
493         require(account != address(0), "ERC20: burn from the zero address");
494 
495         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
496         _totalSupply = _totalSupply.sub(amount);
497         emit Transfer(account, address(0), amount);
498     }
499 
500     /**
501      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
502      *
503      * This is internal function is equivalent to `approve`, and can be used to
504      * e.g. set automatic allowances for certain subsystems, etc.
505      *
506      * Emits an {Approval} event.
507      *
508      * Requirements:
509      *
510      * - `owner` cannot be the zero address.
511      * - `spender` cannot be the zero address.
512      */
513     function _approve(address owner, address spender, uint256 amount) internal {
514         require(owner != address(0), "ERC20: approve from the zero address");
515         require(spender != address(0), "ERC20: approve to the zero address");
516 
517         _allowances[owner][spender] = amount;
518         emit Approval(owner, spender, amount);
519     }
520 
521     /**
522      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
523      * from the caller's allowance.
524      *
525      * See {_burn} and {_approve}.
526      */
527     function _burnFrom(address account, uint256 amount) internal {
528         _burn(account, amount);
529         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
530     }
531 }
532 
533 
534 contract Token is Ownable, ERC20 {
535 
536     using SafeMath for uint;
537 
538     string public constant name = "Bitxmi";
539     string public constant symbol = "Bxmi";
540     uint public constant decimals = 18;
541 
542     uint private constant _month = 30 days;
543     uint public constant team_percents = 24;
544     uint public constant advisors_percents = 3;
545     uint public constant bounty_percents = 3;
546     uint public constant tokenSale_percents = 70;
547     uint public constant initialEmission = 210_000_000;
548 
549     uint private t_count;
550     uint private a_count;
551     uint private b_count;
552 
553     uint private deployTime;
554 
555     address public saleAddress;
556 
557     constructor() public {
558         deployTime = now;
559 
560         _mint(address(this), initialEmission * 10 ** decimals);
561     }
562 
563     function() external {
564         revert();
565     }
566 
567     function sendSaleTokens(address _tokenSale) public onlyOwner {
568         saleAddress = _tokenSale;
569         _transfer(address(this), _tokenSale, totalSupply().mul(tokenSale_percents).div(100));
570     }
571 
572     function sendTokens(address[] memory _receivers, uint[] memory _amounts) public onlyOwner {
573         require(_receivers.length == _amounts.length, "The length of the arrays must be equal");
574 
575         for (uint i = 0; i < _receivers.length; i++) {
576             _transfer(address(this), _receivers[i], _amounts[i]);
577         }
578     }
579 
580     function sendTokens(address to, uint amount) public onlyOwner {
581         _transfer(address(this), to, amount);
582     }
583 
584     function sendTeamTokens(address _teamAddress) public onlyOwner {
585         require(now >= deployTime.add(_month.mul(7)));
586         require(t_count < 3, "All tokens send");
587         if(now < deployTime.add(_month.mul(12))){
588             _transfer(address(this), _teamAddress, totalSupply().mul(team_percents).div(100).div(3));
589             t_count++;
590         }
591         else if(now >= deployTime.add(_month.mul(12)) && now < deployTime.add(_month.mul(18))){
592             _transfer(address(this), _teamAddress, totalSupply().mul(team_percents).div(100).mul(uint(2).sub(t_count)).div(3));
593             t_count = 2;
594         }
595         else if (now >= deployTime.add(_month.mul(18))){
596             _transfer(address(this), _teamAddress, totalSupply().mul(team_percents).div(100).mul(uint(3).sub(t_count)).div(3));
597             t_count = 3;
598         }
599     }
600 
601     function sendAdvisorsTokens(address _advisorsAddress) public onlyOwner {
602         require(now >= deployTime.add(_month.mul(7)));
603         require(a_count < 3, "All tokens send");
604         if(now < deployTime.add(_month.mul(12))){
605             _transfer(address(this), _advisorsAddress, totalSupply().mul(advisors_percents).div(100).div(3));
606             a_count++;
607         }
608         else if(now >= deployTime.add(_month.mul(12)) && now < deployTime.add(_month.mul(18))){
609             _transfer(address(this), _advisorsAddress, totalSupply().mul(advisors_percents).div(100).mul(uint(2).sub(a_count)).div(3));
610             a_count = 2;
611         }
612         else if (now >= deployTime.add(_month.mul(18))){
613             _transfer(address(this), _advisorsAddress, totalSupply().mul(advisors_percents).div(100).mul(uint(3).sub(a_count)).div(3));
614             a_count = 3;
615         }
616     }
617 
618     function sendBountyTokens(address _bountyAddress) public onlyOwner {
619         require(now >= deployTime.add(_month.mul(7)));
620         require(b_count < 3, "All tokens send");
621         if(now < deployTime.add(_month.mul(12))){
622             _transfer(address(this), _bountyAddress, totalSupply().mul(bounty_percents).div(100).div(3));
623             b_count++;
624         }
625         else if(now >= deployTime.add(_month.mul(12)) && now < deployTime.add(_month.mul(18))){
626             _transfer(address(this), _bountyAddress, totalSupply().mul(bounty_percents).div(100).mul(uint(2).sub(b_count)).div(3));
627             b_count = 2;
628         }
629         else if (now >= deployTime.add(_month.mul(18))){
630             _transfer(address(this), _bountyAddress, totalSupply().mul(bounty_percents).div(100).mul(uint(3).sub(b_count)).div(3));
631             b_count = 3;
632         }
633     }
634 
635     function burnUnsoldTokens() public {
636         require(msg.sender == owner() || msg.sender == saleAddress, "Caller is not the owner or sale address");
637         require(now >= deployTime.add(_month.mul(7)));
638         _burn(saleAddress, balanceOf(saleAddress));
639     }
640 }