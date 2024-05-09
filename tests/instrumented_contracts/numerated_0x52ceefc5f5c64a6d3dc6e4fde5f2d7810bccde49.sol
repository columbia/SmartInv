1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 interface IERC20 {
83     function transfer(address to, uint256 value) external returns (bool);
84 
85     function approve(address spender, uint256 value) external returns (bool);
86 
87     function transferFrom(address from, address to, uint256 value) external returns (bool);
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address who) external view returns (uint256);
92 
93     function allowance(address owner, address spender) external view returns (uint256);
94 
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
101 
102 pragma solidity ^0.5.0;
103 
104 /**
105  * @title SafeMath
106  * @dev Unsigned math operations with safety checks that revert on error
107  */
108 library SafeMath {
109     /**
110     * @dev Multiplies two unsigned integers, reverts on overflow.
111     */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b);
122 
123         return c;
124     }
125 
126     /**
127     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
128     */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
140     */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149     * @dev Adds two unsigned integers, reverts on overflow.
150     */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         require(c >= a);
154 
155         return c;
156     }
157 
158     /**
159     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
160     * reverts when dividing by zero.
161     */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         require(b != 0);
164         return a % b;
165     }
166 }
167 
168 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
169 
170 pragma solidity ^0.5.0;
171 
172 
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
179  * Originally based on code by FirstBlood:
180  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  *
182  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
183  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
184  * compliant implementations may not do it.
185  */
186 contract ERC20 is IERC20 {
187     using SafeMath for uint256;
188 
189     mapping (address => uint256) private _balances;
190 
191     mapping (address => mapping (address => uint256)) private _allowed;
192 
193     uint256 private _totalSupply;
194 
195     /**
196     * @dev Total number of tokens in existence
197     */
198     function totalSupply() public view returns (uint256) {
199         return _totalSupply;
200     }
201 
202     /**
203     * @dev Gets the balance of the specified address.
204     * @param owner The address to query the balance of.
205     * @return An uint256 representing the amount owned by the passed address.
206     */
207     function balanceOf(address owner) public view returns (uint256) {
208         return _balances[owner];
209     }
210 
211     /**
212      * @dev Function to check the amount of tokens that an owner allowed to a spender.
213      * @param owner address The address which owns the funds.
214      * @param spender address The address which will spend the funds.
215      * @return A uint256 specifying the amount of tokens still available for the spender.
216      */
217     function allowance(address owner, address spender) public view returns (uint256) {
218         return _allowed[owner][spender];
219     }
220 
221     /**
222     * @dev Transfer token for a specified address
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function transfer(address to, uint256 value) public returns (bool) {
227         _transfer(msg.sender, to, value);
228         return true;
229     }
230 
231     /**
232      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233      * Beware that changing an allowance with this method brings the risk that someone may use both the old
234      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      * @param spender The address which will spend the funds.
238      * @param value The amount of tokens to be spent.
239      */
240     function approve(address spender, uint256 value) public returns (bool) {
241         require(spender != address(0));
242 
243         _allowed[msg.sender][spender] = value;
244         emit Approval(msg.sender, spender, value);
245         return true;
246     }
247 
248     /**
249      * @dev Transfer tokens from one address to another.
250      * Note that while this function emits an Approval event, this is not required as per the specification,
251      * and other compliant implementations may not emit the event.
252      * @param from address The address which you want to send tokens from
253      * @param to address The address which you want to transfer to
254      * @param value uint256 the amount of tokens to be transferred
255      */
256     function transferFrom(address from, address to, uint256 value) public returns (bool) {
257         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
258         _transfer(from, to, value);
259         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
260         return true;
261     }
262 
263     /**
264      * @dev Increase the amount of tokens that an owner allowed to a spender.
265      * approve should be called when allowed_[_spender] == 0. To increment
266      * allowed value is better to use this function to avoid 2 calls (and wait until
267      * the first transaction is mined)
268      * From MonolithDAO Token.sol
269      * Emits an Approval event.
270      * @param spender The address which will spend the funds.
271      * @param addedValue The amount of tokens to increase the allowance by.
272      */
273     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
274         require(spender != address(0));
275 
276         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
277         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
278         return true;
279     }
280 
281     /**
282      * @dev Decrease the amount of tokens that an owner allowed to a spender.
283      * approve should be called when allowed_[_spender] == 0. To decrement
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * Emits an Approval event.
288      * @param spender The address which will spend the funds.
289      * @param subtractedValue The amount of tokens to decrease the allowance by.
290      */
291     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
292         require(spender != address(0));
293 
294         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
295         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
296         return true;
297     }
298 
299     /**
300     * @dev Transfer token for a specified addresses
301     * @param from The address to transfer from.
302     * @param to The address to transfer to.
303     * @param value The amount to be transferred.
304     */
305     function _transfer(address from, address to, uint256 value) internal {
306         require(to != address(0));
307 
308         _balances[from] = _balances[from].sub(value);
309         _balances[to] = _balances[to].add(value);
310         emit Transfer(from, to, value);
311     }
312 
313     /**
314      * @dev Internal function that mints an amount of the token and assigns it to
315      * an account. This encapsulates the modification of balances such that the
316      * proper events are emitted.
317      * @param account The account that will receive the created tokens.
318      * @param value The amount that will be created.
319      */
320     function _mint(address account, uint256 value) internal {
321         require(account != address(0));
322 
323         _totalSupply = _totalSupply.add(value);
324         _balances[account] = _balances[account].add(value);
325         emit Transfer(address(0), account, value);
326     }
327 
328     /**
329      * @dev Internal function that burns an amount of the token of a given
330      * account.
331      * @param account The account whose tokens will be burnt.
332      * @param value The amount that will be burnt.
333      */
334     function _burn(address account, uint256 value) internal {
335         require(account != address(0));
336 
337         _totalSupply = _totalSupply.sub(value);
338         _balances[account] = _balances[account].sub(value);
339         emit Transfer(account, address(0), value);
340     }
341 
342     /**
343      * @dev Internal function that burns an amount of the token of a given
344      * account, deducting from the sender's allowance for said account. Uses the
345      * internal burn function.
346      * Emits an Approval event (reflecting the reduced allowance).
347      * @param account The account whose tokens will be burnt.
348      * @param value The amount that will be burnt.
349      */
350     function _burnFrom(address account, uint256 value) internal {
351         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
352         _burn(account, value);
353         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
354     }
355 }
356 
357 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Burnable.sol
358 
359 pragma solidity ^0.5.0;
360 
361 
362 /**
363  * @title Burnable Token
364  * @dev Token that can be irreversibly burned (destroyed).
365  */
366 contract ERC20Burnable is ERC20 {
367     /**
368      * @dev Burns a specific amount of tokens.
369      * @param value The amount of token to be burned.
370      */
371     function burn(uint256 value) public {
372         _burn(msg.sender, value);
373     }
374 
375     /**
376      * @dev Burns a specific amount of tokens from the target address and decrements allowance
377      * @param from address The address which you want to send tokens from
378      * @param value uint256 The amount of token to be burned
379      */
380     function burnFrom(address from, uint256 value) public {
381         _burnFrom(from, value);
382     }
383 }
384 
385 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
386 
387 pragma solidity ^0.5.0;
388 
389 /**
390  * @title Roles
391  * @dev Library for managing addresses assigned to a Role.
392  */
393 library Roles {
394     struct Role {
395         mapping (address => bool) bearer;
396     }
397 
398     /**
399      * @dev give an account access to this role
400      */
401     function add(Role storage role, address account) internal {
402         require(account != address(0));
403         require(!has(role, account));
404 
405         role.bearer[account] = true;
406     }
407 
408     /**
409      * @dev remove an account's access to this role
410      */
411     function remove(Role storage role, address account) internal {
412         require(account != address(0));
413         require(has(role, account));
414 
415         role.bearer[account] = false;
416     }
417 
418     /**
419      * @dev check if an account has this role
420      * @return bool
421      */
422     function has(Role storage role, address account) internal view returns (bool) {
423         require(account != address(0));
424         return role.bearer[account];
425     }
426 }
427 
428 // File: node_modules\openzeppelin-solidity\contracts\access\roles\MinterRole.sol
429 
430 pragma solidity ^0.5.0;
431 
432 
433 contract MinterRole {
434     using Roles for Roles.Role;
435 
436     event MinterAdded(address indexed account);
437     event MinterRemoved(address indexed account);
438 
439     Roles.Role private _minters;
440 
441     constructor () internal {
442         _addMinter(msg.sender);
443     }
444 
445     modifier onlyMinter() {
446         require(isMinter(msg.sender));
447         _;
448     }
449 
450     function isMinter(address account) public view returns (bool) {
451         return _minters.has(account);
452     }
453 
454     function addMinter(address account) public onlyMinter {
455         _addMinter(account);
456     }
457 
458     function renounceMinter() public {
459         _removeMinter(msg.sender);
460     }
461 
462     function _addMinter(address account) internal {
463         _minters.add(account);
464         emit MinterAdded(account);
465     }
466 
467     function _removeMinter(address account) internal {
468         _minters.remove(account);
469         emit MinterRemoved(account);
470     }
471 }
472 
473 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Mintable.sol
474 
475 pragma solidity ^0.5.0;
476 
477 
478 
479 /**
480  * @title ERC20Mintable
481  * @dev ERC20 minting logic
482  */
483 contract ERC20Mintable is ERC20, MinterRole {
484     /**
485      * @dev Function to mint tokens
486      * @param to The address that will receive the minted tokens.
487      * @param value The amount of tokens to mint.
488      * @return A boolean that indicates if the operation was successful.
489      */
490     function mint(address to, uint256 value) public onlyMinter returns (bool) {
491         _mint(to, value);
492         return true;
493     }
494 }
495 
496 // File: contracts\ERC20Frozenable.sol
497 
498 pragma solidity ^0.5.0;
499 
500 
501 //truffle-flattener Token.sol
502 contract ERC20Frozenable is ERC20Burnable, ERC20Mintable, Ownable {
503     mapping (address => bool) private _frozenAccount;
504     event FrozenFunds(address target, bool frozen);
505 
506 
507     function frozenAccount(address _address) public view returns(bool isFrozen) {
508         return _frozenAccount[_address];
509     }
510 
511     function freezeAccount(address target, bool freeze)  public onlyOwner {
512         require(_frozenAccount[target] != freeze, "Same as current");
513         _frozenAccount[target] = freeze;
514         emit FrozenFunds(target, freeze);
515     }
516 
517     function _transfer(address from, address to, uint256 value) internal {
518         require(!_frozenAccount[from], "error - frozen");
519         require(!_frozenAccount[to], "error - frozen");
520         super._transfer(from, to, value);
521     }
522 
523 }
524 
525 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
526 
527 pragma solidity ^0.5.0;
528 
529 
530 /**
531  * @title ERC20Detailed token
532  * @dev The decimals are only for visualization purposes.
533  * All the operations are done using the smallest and indivisible token unit,
534  * just as on Ethereum all the operations are done in wei.
535  */
536 contract ERC20Detailed is IERC20 {
537     string private _name;
538     string private _symbol;
539     uint8 private _decimals;
540 
541     constructor (string memory name, string memory symbol, uint8 decimals) public {
542         _name = name;
543         _symbol = symbol;
544         _decimals = decimals;
545     }
546 
547     /**
548      * @return the name of the token.
549      */
550     function name() public view returns (string memory) {
551         return _name;
552     }
553 
554     /**
555      * @return the symbol of the token.
556      */
557     function symbol() public view returns (string memory) {
558         return _symbol;
559     }
560 
561     /**
562      * @return the number of decimals of the token.
563      */
564     function decimals() public view returns (uint8) {
565         return _decimals;
566     }
567 }
568 
569 // File: contracts\Token.sol
570 
571 pragma solidity ^0.5.0;
572 
573 //truffle-flattener Token.sol
574 contract Token is ERC20Frozenable, ERC20Detailed {
575 
576     constructor()
577     ERC20Detailed("COINXCLUB", "CPX", 18)
578     public {
579         uint256 supply = 10000000000;
580         uint256 initialSupply = supply * uint(10) ** decimals();
581         _mint(msg.sender, initialSupply);
582     }
583 }