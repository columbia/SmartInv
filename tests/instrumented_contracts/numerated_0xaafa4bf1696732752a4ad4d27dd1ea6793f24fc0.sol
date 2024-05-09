1 pragma solidity 0.5.0;
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
74 /**
75  * @title ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 interface IERC20 {
79     function transfer(address to, uint256 value) external returns (bool);
80 
81     function approve(address spender, uint256 value) external returns (bool);
82 
83     function transferFrom(address from, address to, uint256 value) external returns (bool);
84 
85     function totalSupply() external view returns (uint256);
86 
87     function balanceOf(address who) external view returns (uint256);
88 
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title ERC20Detailed token
98  * @dev The decimals are only for visualization purposes.
99  * All the operations are done using the smallest and indivisible token unit,
100  * just as on Ethereum all the operations are done in wei.
101  */
102 contract ERC20Detailed is IERC20 {
103     string private _name;
104     string private _symbol;
105     uint8 private _decimals;
106 
107     constructor (string memory name, string memory symbol, uint8 decimals) public {
108         _name = name;
109         _symbol = symbol;
110         _decimals = decimals;
111     }
112 
113     /**
114      * @return the name of the token.
115      */
116     function name() public view returns (string memory) {
117         return _name;
118     }
119 
120     /**
121      * @return the symbol of the token.
122      */
123     function symbol() public view returns (string memory) {
124         return _symbol;
125     }
126 
127     /**
128      * @return the number of decimals of the token.
129      */
130     function decimals() public view returns (uint8) {
131         return _decimals;
132     }
133 }
134 
135 /**
136  * @title SafeMath
137  * @dev Unsigned math operations with safety checks that revert on error
138  */
139 library SafeMath {
140     /**
141     * @dev Multiplies two unsigned integers, reverts on overflow.
142     */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145         // benefit is lost if 'b' is also tested.
146         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
147         if (a == 0) {
148             return 0;
149         }
150 
151         uint256 c = a * b;
152         require(c / a == b);
153 
154         return c;
155     }
156 
157     /**
158     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
159     */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Solidity only automatically asserts when dividing by 0
162         require(b > 0);
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 
169     /**
170     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
171     */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         require(b <= a);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180     * @dev Adds two unsigned integers, reverts on overflow.
181     */
182     function add(uint256 a, uint256 b) internal pure returns (uint256) {
183         uint256 c = a + b;
184         require(c >= a);
185 
186         return c;
187     }
188 
189     /**
190     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
191     * reverts when dividing by zero.
192     */
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         require(b != 0);
195         return a % b;
196     }
197 }
198 
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
204  * Originally based on code by FirstBlood:
205  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  *
207  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
208  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
209  * compliant implementations may not do it.
210  */
211 contract ERC20 is IERC20 {
212     using SafeMath for uint256;
213 
214     mapping (address => uint256) private _balances;
215 
216     mapping (address => mapping (address => uint256)) private _allowed;
217 
218     uint256 private _totalSupply;
219 
220     /**
221     * @dev Total number of tokens in existence
222     */
223     function totalSupply() public view returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228     * @dev Gets the balance of the specified address.
229     * @param owner The address to query the balance of.
230     * @return An uint256 representing the amount owned by the passed address.
231     */
232     function balanceOf(address owner) public view returns (uint256) {
233         return _balances[owner];
234     }
235 
236     /**
237      * @dev Function to check the amount of tokens that an owner allowed to a spender.
238      * @param owner address The address which owns the funds.
239      * @param spender address The address which will spend the funds.
240      * @return A uint256 specifying the amount of tokens still available for the spender.
241      */
242     function allowance(address owner, address spender) public view returns (uint256) {
243         return _allowed[owner][spender];
244     }
245 
246     /**
247     * @dev Transfer token for a specified address
248     * @param to The address to transfer to.
249     * @param value The amount to be transferred.
250     */
251     function transfer(address to, uint256 value) public returns (bool) {
252         _transfer(msg.sender, to, value);
253         return true;
254     }
255 
256     /**
257      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258      * Beware that changing an allowance with this method brings the risk that someone may use both the old
259      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262      * @param spender The address which will spend the funds.
263      * @param value The amount of tokens to be spent.
264      */
265     function approve(address spender, uint256 value) public returns (bool) {
266         require(spender != address(0));
267 
268         _allowed[msg.sender][spender] = value;
269         emit Approval(msg.sender, spender, value);
270         return true;
271     }
272 
273     /**
274      * @dev Transfer tokens from one address to another.
275      * Note that while this function emits an Approval event, this is not required as per the specification,
276      * and other compliant implementations may not emit the event.
277      * @param from address The address which you want to send tokens from
278      * @param to address The address which you want to transfer to
279      * @param value uint256 the amount of tokens to be transferred
280      */
281     function transferFrom(address from, address to, uint256 value) public returns (bool) {
282         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
283         _transfer(from, to, value);
284         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
285         return true;
286     }
287 
288     /**
289      * @dev Increase the amount of tokens that an owner allowed to a spender.
290      * approve should be called when allowed_[_spender] == 0. To increment
291      * allowed value is better to use this function to avoid 2 calls (and wait until
292      * the first transaction is mined)
293      * From MonolithDAO Token.sol
294      * Emits an Approval event.
295      * @param spender The address which will spend the funds.
296      * @param addedValue The amount of tokens to increase the allowance by.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
299         require(spender != address(0));
300 
301         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
302         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
303         return true;
304     }
305 
306     /**
307      * @dev Decrease the amount of tokens that an owner allowed to a spender.
308      * approve should be called when allowed_[_spender] == 0. To decrement
309      * allowed value is better to use this function to avoid 2 calls (and wait until
310      * the first transaction is mined)
311      * From MonolithDAO Token.sol
312      * Emits an Approval event.
313      * @param spender The address which will spend the funds.
314      * @param subtractedValue The amount of tokens to decrease the allowance by.
315      */
316     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
317         require(spender != address(0));
318 
319         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
320         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
321         return true;
322     }
323 
324     /**
325     * @dev Transfer token for a specified addresses
326     * @param from The address to transfer from.
327     * @param to The address to transfer to.
328     * @param value The amount to be transferred.
329     */
330     function _transfer(address from, address to, uint256 value) internal {
331         require(to != address(0));
332 
333         _balances[from] = _balances[from].sub(value);
334         _balances[to] = _balances[to].add(value);
335         emit Transfer(from, to, value);
336     }
337 
338     /**
339      * @dev Internal function that mints an amount of the token and assigns it to
340      * an account. This encapsulates the modification of balances such that the
341      * proper events are emitted.
342      * @param account The account that will receive the created tokens.
343      * @param value The amount that will be created.
344      */
345     function _mint(address account, uint256 value) internal {
346         require(account != address(0));
347 
348         _totalSupply = _totalSupply.add(value);
349         _balances[account] = _balances[account].add(value);
350         emit Transfer(address(0), account, value);
351     }
352 
353     /**
354      * @dev Internal function that burns an amount of the token of a given
355      * account.
356      * @param account The account whose tokens will be burnt.
357      * @param value The amount that will be burnt.
358      */
359     function _burn(address account, uint256 value) internal {
360         require(account != address(0));
361 
362         _totalSupply = _totalSupply.sub(value);
363         _balances[account] = _balances[account].sub(value);
364         emit Transfer(account, address(0), value);
365     }
366 
367     /**
368      * @dev Internal function that burns an amount of the token of a given
369      * account, deducting from the sender's allowance for said account. Uses the
370      * internal burn function.
371      * Emits an Approval event (reflecting the reduced allowance).
372      * @param account The account whose tokens will be burnt.
373      * @param value The amount that will be burnt.
374      */
375     function _burnFrom(address account, uint256 value) internal {
376         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
377         _burn(account, value);
378         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
379     }
380 }
381 
382 /**
383  * @title Roles
384  * @dev Library for managing addresses assigned to a Role.
385  */
386 library Roles {
387     struct Role {
388         mapping (address => bool) bearer;
389     }
390 
391     /**
392      * @dev give an account access to this role
393      */
394     function add(Role storage role, address account) internal {
395         require(account != address(0));
396         require(!has(role, account));
397 
398         role.bearer[account] = true;
399     }
400 
401     /**
402      * @dev remove an account's access to this role
403      */
404     function remove(Role storage role, address account) internal {
405         require(account != address(0));
406         require(has(role, account));
407 
408         role.bearer[account] = false;
409     }
410 
411     /**
412      * @dev check if an account has this role
413      * @return bool
414      */
415     function has(Role storage role, address account) internal view returns (bool) {
416         require(account != address(0));
417         return role.bearer[account];
418     }
419 }
420 
421 contract MinterRole {
422     using Roles for Roles.Role;
423 
424     event MinterAdded(address indexed account);
425     event MinterRemoved(address indexed account);
426 
427     Roles.Role private _minters;
428 
429     constructor () internal {
430         _addMinter(msg.sender);
431     }
432 
433     modifier onlyMinter() {
434         require(isMinter(msg.sender));
435         _;
436     }
437 
438     function isMinter(address account) public view returns (bool) {
439         return _minters.has(account);
440     }
441 
442     function addMinter(address account) public onlyMinter {
443         _addMinter(account);
444     }
445 
446     function renounceMinter() public {
447         _removeMinter(msg.sender);
448     }
449 
450     function _addMinter(address account) internal {
451         _minters.add(account);
452         emit MinterAdded(account);
453     }
454 
455     function _removeMinter(address account) internal {
456         _minters.remove(account);
457         emit MinterRemoved(account);
458     }
459 }
460 
461 /**
462  * @title ERC20Mintable
463  * @dev ERC20 minting logic
464  */
465 contract ERC20Mintable is ERC20, MinterRole {
466     /**
467      * @dev Function to mint tokens
468      * @param to The address that will receive the minted tokens.
469      * @param value The amount of tokens to mint.
470      * @return A boolean that indicates if the operation was successful.
471      */
472     function mint(address to, uint256 value) public onlyMinter returns (bool) {
473         _mint(to, value);
474         return true;
475     }
476 }
477 
478 /**
479  * @title Capped token
480  * @dev Mintable token with a token cap.
481  */
482 contract ERC20Capped is ERC20Mintable {
483     uint256 private _cap;
484 
485     constructor (uint256 cap) public {
486         require(cap > 0);
487         _cap = cap;
488     }
489 
490     /**
491      * @return the cap for the token minting.
492      */
493     function cap() public view returns (uint256) {
494         return _cap;
495     }
496 
497     function _mint(address account, uint256 value) internal {
498         require(totalSupply().add(value) <= _cap);
499         super._mint(account, value);
500     }
501 }
502 
503 /**
504  * Phat Cats - Crypto-Cards
505  *  - https://crypto-cards.io
506  *  - https://phatcats.co
507  *
508  * Copyright 2019 (c) Phat Cats, Inc.
509  *
510  * Contract Audits:
511  *   - SmartDEC International - https://smartcontracts.smartdec.net
512  *   - Callisto Security Department - https://callisto.network/
513  */
514 
515 /**
516  * @title Crypto-Cards ERC20 Token
517  */
518 contract CryptoCardsERC20 is Ownable, ERC20Detailed, ERC20Capped {
519     constructor(string memory name, string memory symbol, uint8 decimals, uint256 tokenCap)
520         public
521         ERC20Detailed(name, symbol, decimals)
522         ERC20Capped(tokenCap)
523     {}
524 
525     // Avoid 'Double Withdrawal Attack"
526     // see:
527     //  - https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
528     //  - https://docs.google.com/document/d/1Feh5sP6oQL1-1NHi-X1dbgT3ch2WdhbXRevDN681Jv4/
529     function _transfer(address from, address to, uint256 value) internal {
530         require(to != address(this));
531         super._transfer(from, to, value);
532     }
533 }
534 
535 /**
536  * Phat Cats - Crypto-Cards
537  *  - https://crypto-cards.io
538  *  - https://phatcats.co
539  *
540  * Copyright 2019 (c) Phat Cats, Inc.
541  *
542  * Contract Audits:
543  *   - SmartDEC International - https://smartcontracts.smartdec.net
544  *   - Callisto Security Department - https://callisto.network/
545  */
546 
547 /**
548  * @title Crypto-Cards ERC20 GUM Token
549  * ERC20-compliant token representing Pack-Gum
550  */
551 contract CryptoCardsGumToken is CryptoCardsERC20 {
552     constructor() public CryptoCardsERC20("CryptoCards Gum", "GUM", 18, 3000000000 * (10**18)) { }
553 
554     // 3 Billion, Total Supply
555     function mintTotalSupply(uint256 totalSupply, address initialHolder) public {
556         _mint(initialHolder, totalSupply * (10**18));
557     }
558 }