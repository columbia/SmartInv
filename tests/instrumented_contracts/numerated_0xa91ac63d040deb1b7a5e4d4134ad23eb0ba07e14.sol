1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: contracts/ERC20.sol
164 
165 pragma solidity 0.6.10;
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://eips.ethereum.org/EIPS/eip-20
173  * Originally based on code by FirstBlood:
174  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  *
176  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
177  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
178  * compliant implementations may not do it.
179  */
180 contract ERC20 {
181     using SafeMath for uint256;
182 
183     mapping (address => uint256) internal _balances;
184 
185     mapping (address => mapping (address => uint256)) internal _allowed;
186 
187     uint256 internal _totalSupply;
188 
189     /**
190      * @dev Total number of tokens in existence.
191      */
192     function totalSupply() public view returns (uint256) {
193         return _totalSupply;
194     }
195 
196     /**
197      * @dev Gets the balance of the specified address.
198      * @param owner The address to query the balance of.
199      * @return A uint256 representing the amount owned by the passed address.
200      */
201     function balanceOf(address owner) public view returns (uint256) {
202         return _balances[owner];
203     }
204 
205     /**
206      * @dev Function to check the amount of tokens that an owner allowed to a spender.
207      * @param owner address The address which owns the funds.
208      * @param spender address The address which will spend the funds.
209      * @return A uint256 specifying the amount of tokens still available for the spender.
210      */
211     function allowance(address owner, address spender) public view returns (uint256) {
212         return _allowed[owner][spender];
213     }
214 
215     /**
216      * @dev Transfer token to a specified address.
217      * @param to The address to transfer to.
218      * @param value The amount to be transferred.
219      */
220     function transfer(address to, uint256 value) public virtual returns (bool) {
221         _transfer(msg.sender, to, value);
222         return true;
223     }
224 
225     /**
226      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param spender The address which will spend the funds.
232      * @param value The amount of tokens to be spent.
233      */
234     function approve(address spender, uint256 value) public virtual returns (bool) {
235         _approve(msg.sender, spender, value);
236         return true;
237     }
238 
239     /**
240      * @dev Transfer tokens from one address to another.
241      * Note that while this function emits an Approval event, this is not required as per the specification,
242      * and other compliant implementations may not emit the event.
243      * @param from address The address which you want to send tokens from
244      * @param to address The address which you want to transfer to
245      * @param value uint256 the amount of tokens to be transferred
246      */
247     function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
248         _transfer(from, to, value);
249         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
250         return true;
251     }
252 
253     /**
254      * @dev Increase the amount of tokens that an owner allowed to a spender.
255      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
256      * allowed value is better to use this function to avoid 2 calls (and wait until
257      * the first transaction is mined)
258      * From MonolithDAO Token.sol
259      * Emits an Approval event.
260      * @param spender The address which will spend the funds.
261      * @param addedValue The amount of tokens to increase the allowance by.
262      */
263     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
264         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
265         return true;
266     }
267 
268     /**
269      * @dev Decrease the amount of tokens that an owner allowed to a spender.
270      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      * Emits an Approval event.
275      * @param spender The address which will spend the funds.
276      * @param subtractedValue The amount of tokens to decrease the allowance by.
277      */
278     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
279         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
280         return true;
281     }
282 
283     /**
284      * @dev Transfer token for a specified addresses.
285      * @param from The address to transfer from.
286      * @param to The address to transfer to.
287      * @param value The amount to be transferred.
288      */
289     function _transfer(address from, address to, uint256 value) internal {
290         require(to != address(0));
291 
292         _balances[from] = _balances[from].sub(value);
293         _balances[to] = _balances[to].add(value);
294         emit Transfer(from, to, value);
295     }
296 
297     /**
298      * @dev Internal function that mints an amount of the token and assigns it to
299      * an account. This encapsulates the modification of balances such that the
300      * proper events are emitted.
301      * @param account The account that will receive the created tokens.
302      * @param value The amount that will be created.
303      */
304     function _mint(address account, uint256 value) internal {
305         require(account != address(0));
306 
307         _totalSupply = _totalSupply.add(value);
308         _balances[account] = _balances[account].add(value);
309         emit Transfer(address(0), account, value);
310     }
311 
312     /**
313      * @dev Internal function that burns an amount of the token of a given
314      * account.
315      * @param account The account whose tokens will be burnt.
316      * @param value The amount that will be burnt.
317      */
318     function _burn(address account, uint256 value) internal {
319         require(account != address(0));
320 
321         _totalSupply = _totalSupply.sub(value);
322         _balances[account] = _balances[account].sub(value);
323         emit Transfer(account, address(0), value);
324     }
325 
326     /**
327      * @dev Approve an address to spend another addresses' tokens.
328      * @param owner The address that owns the tokens.
329      * @param spender The address that will spend the tokens.
330      * @param value The number of tokens that can be spent.
331      */
332     function _approve(address owner, address spender, uint256 value) internal {
333         require(spender != address(0));
334         require(owner != address(0));
335 
336         _allowed[owner][spender] = value;
337         emit Approval(owner, spender, value);
338     }
339 
340     /**
341      * @dev Internal function that burns an amount of the token of a given
342      * account, deducting from the sender's allowance for said account. Uses the
343      * internal burn function.
344      * Emits an Approval event (reflecting the reduced allowance).
345      * @param account The account whose tokens will be burnt.
346      * @param value The amount that will be burnt.
347      */
348     function _burnFrom(address account, uint256 value) internal {
349         _burn(account, value);
350         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
351     }
352 
353     /**
354      * @dev Emitted when `value` tokens are moved from one account (`from`) to
355      * another (`to`).
356      *
357      * Note that `value` may be zero.
358      */
359     event Transfer(address indexed from, address indexed to, uint256 value);
360 
361     /**
362      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
363      * a call to {approve}. `value` is the new allowance.
364      */
365     event Approval(address indexed owner, address indexed spender, uint256 value);
366 }
367 
368 // File: contracts/Ownable.sol
369 
370 pragma solidity 0.6.10;
371 
372 /**
373  * @title Ownable
374  * @dev The Ownable contract has an owner address, and provides basic authorization control
375  * functions, this simplifies the implementation of "user permissions".
376  */
377 contract Ownable {
378     address private _owner;
379 
380     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382     /**
383      * @dev The Ownable constructor sets the original `owner` of the contract to the a
384      * specified account.
385      * @param initalOwner The address of the inital owner.
386      */
387     constructor(address initalOwner) internal {
388         _owner = initalOwner;
389         emit OwnershipTransferred(address(0), _owner);
390     }
391 
392     /**
393      * @return the address of the owner.
394      */
395     function owner() public view returns (address) {
396         return _owner;
397     }
398 
399     /**
400      * @dev Throws if called by any account other than the owner.
401      */
402     modifier onlyOwner() {
403         require(isOwner(), "Only owner can call");
404         _;
405     }
406 
407     /**
408      * @return true if `msg.sender` is the owner of the contract.
409      */
410     function isOwner() public view returns (bool) {
411         return msg.sender == _owner;
412     }
413 
414     /**
415      * @dev Allows the current owner to relinquish control of the contract.
416      * It will not be possible to call the functions with the `onlyOwner`
417      * modifier anymore.
418      * @notice Renouncing ownership will leave the contract without an owner,
419      * thereby removing any functionality that is only available to the owner.
420      */
421     function renounceOwnership() public onlyOwner {
422         emit OwnershipTransferred(_owner, address(0));
423         _owner = address(0);
424     }
425 
426     /**
427      * @dev Allows the current owner to transfer control of the contract to a newOwner.
428      * @param newOwner The address to transfer ownership to.
429      */
430     function transferOwnership(address newOwner) public onlyOwner {
431         _transferOwnership(newOwner);
432     }
433 
434     /**
435      * @dev Transfers control of the contract to a newOwner.
436      * @param newOwner The address to transfer ownership to.
437      */
438     function _transferOwnership(address newOwner) internal {
439         require(newOwner != address(0), "Owner should not be 0 address");
440         emit OwnershipTransferred(_owner, newOwner);
441         _owner = newOwner;
442     }
443 }
444 
445 // File: contracts/Bella.sol
446 
447 pragma solidity 0.6.10;
448 
449 
450 
451 
452 /**
453  * @title Bella
454  * @dev Bella is an ownable, mintable, pausable and burnable ERC20 token
455  */
456 contract Bella is ERC20, Ownable {
457     using SafeMath for uint;
458 
459     string public constant name = "Bella";
460     uint8 public constant decimals = 18;
461     string public constant symbol = "BEL";
462     uint public constant initalSupply = 1 * 10**8 * 10**uint(decimals); // 100 million
463     
464     bool public paused; // True when circulation is paused.
465 
466     mapping (address => bool) public freezed;
467     mapping (address => bool) public minter;
468 
469     /**
470      * @dev Throws if called by any account that is not a minter.
471      */
472     modifier onlyMinter() {
473         require(minter[msg.sender], "Only minter can call");
474         _;
475     }
476 
477     /**
478      * @dev Throws if called when the circulation is paused.
479      */
480     modifier whenNotPaused() {
481         require(paused == false, "Cirlulation paused!");
482         _;
483     }
484 
485     /**
486      * @dev The Bella constructor sets the original manager of the contract to the a
487      * specified account, and send all the inital supply to it.
488      * @param manager The address of the first manager of this contract.
489      */
490     constructor(address manager) public Ownable(manager) {
491         _balances[manager] = initalSupply;
492         _totalSupply = initalSupply;
493     }
494 
495     /**
496      * @dev Add an address to the minter list.
497      * @param minterAddress The address to be added as a minter.
498      */
499     function addMinter(address minterAddress) public onlyOwner {
500         minter[minterAddress] = true;
501     }
502 
503     /**
504      * @dev Remove an address from the minter list.
505      * @param minterAddress The address to be removed from minters.
506      */
507     function removeMinter(address minterAddress) public onlyOwner {
508         minter[minterAddress] = false;
509     }
510 
511     /**
512      * @dev Function to mint tokens by a minter
513      * @param to The address that will receive the minted tokens.
514      * @param value The amount of tokens to mint.
515      * @return A boolean that indicates if the operation was successful.
516      */
517     function mint(address to, uint value) public onlyMinter returns (bool) {
518         _mint(to, value);
519         return true;
520     }
521 
522     /**
523      * @dev Function to pause all the circulation in the case of emergency.
524      */
525     function pause() public onlyOwner {
526         paused = true;
527     }
528 
529     /**
530      * @dev Function to recover all the circulation from emergency.
531      */
532     function unpause() public onlyOwner {
533         paused = false;
534     }
535 
536     /**
537      * @dev Function to freeze a specific user's circulation from emergency.
538      * @param user The user to freeze
539      */
540     function freeze(address user) public onlyOwner {
541         freezed[user] = true;
542     }
543 
544     /**
545      * @dev Function to recover a specific user's circulation from emergency.
546      * @param user The user to recover
547      */
548     function unfreeze(address user) public onlyOwner {
549         freezed[user] = false;
550     }
551 
552     /**
553      * @dev Burns a specific amount of tokens.
554      * @param value The amount of token to be burned.
555      */
556     function burn(uint256 value) public {
557         _burn(msg.sender, value);
558     }
559 
560     /**
561      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
562      * @param from address The account whose tokens will be burned.
563      * @param value uint256 The amount of token to be burned.
564      */
565     function burnFrom(address from, uint256 value) public {
566         _burnFrom(from, value);
567     }
568 
569     function transfer(address to, uint256 value) public whenNotPaused override returns (bool) {
570         require(!freezed[msg.sender] && !freezed[to], "target user is freezed");
571         return super.transfer(to, value);
572     }
573 
574     function transferFrom(address from, address to, uint256 value) public whenNotPaused override returns (bool) {
575         require(!freezed[from] && !freezed[to], "target user is freezed");
576         return super.transferFrom(from, to, value);
577     }
578 
579     function approve(address spender, uint256 value) public whenNotPaused override returns (bool) {
580         return super.approve(spender, value);
581     }
582 
583     function increaseAllowance(address spender, uint addedValue) public whenNotPaused override returns (bool) {
584         return super.increaseAllowance(spender, addedValue);
585     }
586 
587     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused override returns (bool) {
588         return super.decreaseAllowance(spender, subtractedValue);
589     }
590 }