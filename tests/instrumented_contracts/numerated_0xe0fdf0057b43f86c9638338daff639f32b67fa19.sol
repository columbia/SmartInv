1 /*  ,o888888o.           .8.          8 8888888888   8 888888888o.  8 8888      88    d888888o.
2    8888     `88.        .888.         8 8888         8 8888    `88. 8 8888      88  .`8888:' `88.
3 ,8 8888       `8.      :88888.        8 8888         8 8888     `88 8 8888      88  8.`8888.   Y8
4 88 8888               . `88888.       8 8888         8 8888     ,88 8 8888      88  `8.`8888.
5 88 8888              .8. `88888.      8 888888888888 8 8888.   ,88' 8 8888      88   `8.`8888.
6 88 8888             .8`8. `88888.     8 8888         8 888888888P'  8 8888      88    `8.`8888.
7 88 8888            .8' `8. `88888.    8 8888         8 8888`8b      8 8888      88     `8.`8888.
8 `8 8888       .8' .8'   `8. `88888.   8 8888         8 8888 `8b.    ` 8888     ,8P 8b   `8.`8888.
9    8888     ,88' .888888888. `88888.  8 8888         8 8888   `8b.    8888   ,d8P  `8b.  ;8.`8888
10     `8888888P'  .8'       `8. `88888. 8 888888888888 8 8888     `88.   `Y88888P'    `Y8888P ,88P' */
11 
12 
13 pragma solidity ^0.5.17;
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 contract Context {
26     // Empty internal constructor, to prevent people from mistakenly deploying
27     // an instance of this contract, which should be used via inheritance.
28     constructor () internal { }
29     // solhint-disable-previous-line no-empty-blocks
30 
31     function _msgSender() internal view returns (address payable) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view returns (bytes memory) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 /**
42  * @dev Contract module which provides a basic access control mechanism, where
43  * there is an account (an owner) that can be granted exclusive access to
44  * specific functions.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(isOwner(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Returns true if the caller is the current owner.
81      */
82     function isOwner() public view returns (bool) {
83         return _msgSender() == _owner;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public onlyOwner {
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      */
109     function _transferOwnership(address newOwner) internal {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         emit OwnershipTransferred(_owner, newOwner);
112         _owner = newOwner;
113     }
114 }
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      * - Subtraction cannot overflow.
167      *
168      * _Available since v2.4.0._
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         // Solidity only automatically asserts when dividing by 0
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      *
263      * _Available since v2.4.0._
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 interface IERC20 {
272   function totalSupply() external view returns (uint256);
273   function balanceOf(address who) external view returns (uint256);
274   function allowance(address owner, address spender) external view returns (uint256);
275   function transfer(address to, uint256 value) external returns (bool);
276   function approve(address spender, uint256 value) external returns (bool);
277   function transferFrom(address from, address to, uint256 value) external returns (bool);
278 
279   event Transfer(address indexed from, address indexed to, uint256 value);
280   event Approval(address indexed owner, address indexed spender, uint256 value);
281 }
282 
283 contract ERC20Detailed is IERC20 {
284   string private _name;
285   string private _symbol;
286   uint8 private _decimals;
287 
288   constructor(string memory name, string memory symbol, uint8 decimals) public {
289     _name = name;
290     _symbol = symbol;
291     _decimals = decimals;
292   }
293 
294   function name() public view returns(string memory) {
295     return _name;
296   }
297 
298   function symbol() public view returns(string memory) {
299     return _symbol;
300   }
301 
302   function decimals() public view returns(uint8) {
303     return _decimals;
304   }
305 }
306 
307 contract Caerus is ERC20Detailed, Ownable {
308     using SafeMath for uint256;
309 
310     address public lastBuyer;                       //The last address to purchase Caerus.
311 
312     string constant tokenName = "Caerus";
313     string constant tokenSymbol = "CRS";
314     uint8 constant tokenDecimals = 18;
315     uint8 public titheRate;                         // The fee % taken on transfers, distributed to LastBuyer.
316     uint256 public maxbuyorder;
317     uint256 public _totalSupply;                    // 5,500,000 CRS
318     uint256 public deploymentTime;
319 
320     mapping (address => uint256) private _balances;
321     mapping (address => mapping (address => uint256)) private _allowances;
322     mapping (address => bool) public whitelistedAddress;        // Immune to Tithe on transfers
323     mapping (address => bool) public blacklistedAddress;        // Cannot purchase CRS
324 
325     modifier isNotBlacklisted(address recipient) {
326         require(!blacklistedAddress[recipient]);
327         _;
328     }
329 
330     constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
331         _mint(msg.sender, 5500000000000000000000000);
332         _totalSupply = 5500000000000000000000000;
333         lastBuyer = msg.sender;
334         whitelistAdd(msg.sender);
335         maxbuyorder = 45000000000000000000000;
336         titheRate = 10;
337         deploymentTime = now;
338         }
339 
340     /**
341      * @dev Moves tokens `amount` from `sender` to `recipient`.
342      *
343      * This is internal function is equivalent to {transfer}, and can be used to
344      * e.g. implement automatic token fees, slashing mechanisms, etc.
345      *
346      * Emits a {Transfer} event.
347      *
348      * Requirements:
349      *
350      * - `sender` cannot be the zero address.
351      * - `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      *
354      *
355      * Function has been modified.
356      *
357      * A check is performed to determine if the transfer is for a buy or sell.
358      * If Buying: Transfer and become the new lastBuyer.
359      * If Selling: Transfer, pay 10% Fee (Tithe) to the current lastBuyer.
360      *
361      * Checks if the address calling the function is whitelisted. If it is, then the Tithe is 0 for the tx.
362      * 
363      */
364 
365     function _transfer(address sender, address recipient, uint256 amount) internal isNotBlacklisted(recipient) {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368 
369         uint tokensbeforetransfer = _balances[tx.origin];
370         uint Tithe = (amount / 100) * titheRate;
371 
372         if (isWhiteListed(msg.sender) == true || isWhiteListed(tx.origin) == true) {
373             Tithe = 0;
374         }
375         
376         if ((deploymentTime + 10 minutes) > now) {
377             if (isWhiteListed(tx.origin) == false) {
378                 require(amount < maxbuyorder);}
379             }
380 
381         uint tokenstotransfer = amount.sub(Tithe);
382 
383         _balances[sender] -= amount;
384         _balances[recipient] += amount.sub(Tithe);
385         _balances[lastBuyer] += Tithe;
386 
387         if (tokensbeforetransfer < _balances[tx.origin]) {
388             lastBuyer = tx.origin;
389             emit Transfer(sender, recipient, tokenstotransfer);
390         } 
391             else {
392                 emit Transfer(sender, recipient, tokenstotransfer);
393                 emit Transfer(sender, lastBuyer, Tithe);
394             }
395     }
396 
397     /**
398      * @dev Checks if an address is whitelisted
399      */
400     function isWhiteListed(address _address) internal view returns(bool) {
401         return whitelistedAddress[_address];
402     }
403 
404     /**
405      * @dev See {IERC20-totalSupply}.
406      */
407     function totalSupply() public view returns (uint256) {
408         return _totalSupply;
409     }
410 
411     /**
412      * @dev See {IERC20-balanceOf}.
413      */
414     function balanceOf(address account) public view returns (uint256) {
415         return _balances[account];
416     }
417 
418     /**
419      * @dev See {IERC20-transfer}.
420      *
421      * Requirements:
422      *
423      * - `recipient` cannot be the zero address.
424      * - the caller must have a balance of at least `amount`.
425      */
426     function transfer(address recipient, uint256 amount) public returns (bool) {
427         _transfer(_msgSender(), recipient, amount);
428         return true;
429     }
430 
431     /**
432      * @dev See {IERC20-allowance}.
433      */
434     function allowance(address owner, address spender) public view returns (uint256) {
435         return _allowances[owner][spender];
436     }
437 
438     /**
439      * @dev See {IERC20-approve}.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function approve(address spender, uint256 amount) public returns (bool) {
446         _approve(_msgSender(), spender, amount);
447         return true;
448     }
449 
450     /**
451      * @dev See {IERC20-transferFrom}.
452      *
453      * Emits an {Approval} event indicating the updated allowance. This is not
454      * required by the EIP. See the note at the beginning of {ERC20};
455      *
456      * Requirements:
457      * - `sender` and `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      * - the caller must have allowance for `sender`'s tokens of at least
460      * `amount`.
461      */
462     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
463         _transfer(sender, recipient, amount);
464         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
465         return true;
466     }
467 
468     /**
469      * @dev Atomically increases the allowance granted to `spender` by the caller.
470      *
471      * This is an alternative to {approve} that can be used as a mitigation for
472      * problems described in {IERC20-approve}.
473      *
474      * Emits an {Approval} event indicating the updated allowance.
475      *
476      * Requirements:
477      *
478      * - `spender` cannot be the zero address.
479      */
480     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
481         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically decreases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      * - `spender` must have allowance for the caller of at least
497      * `subtractedValue`.
498      */
499     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
501         return true;
502     }
503 
504 
505      /** @dev Creates `amount` tokens and assigns them to `account`, increasing
506      * the total supply.
507      *
508      * Emits a {Transfer} event with `from` set to the zero address.
509      *
510      * Requirements
511      *
512      * - `to` cannot be the zero address.
513      */
514     function _mint(address account, uint256 amount) internal onlyOwner {
515         require(account != address(0), "ERC20: mint to the zero address");
516 
517         _totalSupply = _totalSupply.add(amount);
518         _balances[account] = _balances[account].add(amount);
519         emit Transfer(address(0), account, amount);
520     }
521 
522     /**
523      * @dev Destroys `amount` tokens from `account`, reducing the
524      * total supply.
525      *
526      * Emits a {Transfer} event with `to` set to the zero address.
527      *
528      * Requirements
529      *
530      * - `account` cannot be the zero address.
531      * - `account` must have at least `amount` tokens.
532      */
533     function _burn(address account, uint256 amount) internal {
534         require(account != address(0), "ERC20: burn from the zero address");
535 
536         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
537         _totalSupply = _totalSupply.sub(amount);
538         emit Transfer(account, address(0), amount);
539     }
540 
541     /**
542      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
543      *
544      * This is internal function is equivalent to `approve`, and can be used to
545      * e.g. set automatic allowances for certain subsystems, etc.
546      *
547      * Emits an {Approval} event.
548      *
549      * Requirements:
550      *
551      * - `owner` cannot be the zero address.
552      * - `spender` cannot be the zero address.
553      */
554     function _approve(address owner, address spender, uint256 amount) internal {
555         require(owner != address(0), "ERC20: approve from the zero address");
556         require(spender != address(0), "ERC20: approve to the zero address");
557 
558         _allowances[owner][spender] = amount;
559         emit Approval(owner, spender, amount);
560     }
561 
562     /**
563      * @dev Adds an address as whitelisted
564      */
565     function whitelistAdd(address _address) public onlyOwner {
566         whitelistedAddress[_address] = true;
567     }
568 
569     /**
570      * @dev Removes an address as whitelisted
571      */
572     function whitelistRemove(address _address) public onlyOwner {
573         whitelistedAddress[_address] = false;
574     }
575 
576     /**
577      * @dev Adds an address as whitelisted
578      */
579     function blacklistAdd(address _address) public onlyOwner {
580         blacklistedAddress[_address] = true;
581     }
582 
583     /**
584      * @dev Removes an address as blacklisted
585      */
586     function blacklistRemove(address _address) public onlyOwner {
587         blacklistedAddress[_address] = false;
588     }
589 
590     /**
591      * @dev Sets the Tithe rate
592      */
593     function setTithe(uint8 newtithe) public onlyOwner {
594          titheRate = newtithe;
595     }
596 
597 }