1 pragma solidity >=0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31      * @dev Multiplies two unsigned integers, reverts on overflow.
32      */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49      */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Adds two unsigned integers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81      * reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://eips.ethereum.org/EIPS/eip-20
94  * Originally based on code by FirstBlood:
95  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  *
97  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
98  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
99  * compliant implementations may not do it.
100  */
101 contract ERC20 is IERC20 {
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowed;
107 
108     uint256 private _totalSupply;
109 
110     /**
111      * @dev Total number of tokens in existence
112      */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118      * @dev Gets the balance of the specified address.
119      * @param owner The address to query the balance of.
120      * @return A uint256 representing the amount owned by the passed address.
121      */
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param owner address The address which owns the funds.
129      * @param spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowed[owner][spender];
134     }
135 
136     /**
137      * @dev Transfer token to a specified address
138      * @param to The address to transfer to.
139      * @param value The amount to be transferred.
140      */
141     function transfer(address to, uint256 value) public returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param spender The address which will spend the funds.
153      * @param value The amount of tokens to be spent.
154      */
155     function approve(address spender, uint256 value) public returns (bool) {
156         _approve(msg.sender, spender, value);
157         return true;
158     }
159 
160     /**
161      * @dev Transfer tokens from one address to another.
162      * Note that while this function emits an Approval event, this is not required as per the specification,
163      * and other compliant implementations may not emit the event.
164      * @param from address The address which you want to send tokens from
165      * @param to address The address which you want to transfer to
166      * @param value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address from, address to, uint256 value) public returns (bool) {
169         _transfer(from, to, value);
170         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
171         return true;
172     }
173 
174     /**
175      * @dev Increase the amount of tokens that an owner allowed to a spender.
176      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param addedValue The amount of tokens to increase the allowance by.
183      */
184     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
186         return true;
187     }
188 
189     /**
190      * @dev Decrease the amount of tokens that an owner allowed to a spender.
191      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * Emits an Approval event.
196      * @param spender The address which will spend the funds.
197      * @param subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
200         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
201         return true;
202     }
203 
204     /**
205      * @dev Transfer token for a specified addresses
206      * @param from The address to transfer from.
207      * @param to The address to transfer to.
208      * @param value The amount to be transferred.
209      */
210     function _transfer(address from, address to, uint256 value) internal {
211         require(to != address(0));
212 
213         _balances[from] = _balances[from].sub(value);
214         _balances[to] = _balances[to].add(value);
215         emit Transfer(from, to, value);
216     }
217 
218     /**
219      * @dev Internal function that mints an amount of the token and assigns it to
220      * an account. This encapsulates the modification of balances such that the
221      * proper events are emitted.
222      * @param account The account that will receive the created tokens.
223      * @param value The amount that will be created.
224      */
225     function _mint(address account, uint256 value) internal {
226         require(account != address(0));
227 
228         _totalSupply = _totalSupply.add(value);
229         _balances[account] = _balances[account].add(value);
230         emit Transfer(address(0), account, value);
231     }
232 
233     /**
234      * @dev Internal function that burns an amount of the token of a given
235      * account.
236      * @param account The account whose tokens will be burnt.
237      * @param value The amount that will be burnt.
238      */
239     function _burn(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.sub(value);
243         _balances[account] = _balances[account].sub(value);
244         emit Transfer(account, address(0), value);
245     }
246 
247     /**
248      * @dev Approve an address to spend another addresses' tokens.
249      * @param owner The address that owns the tokens.
250      * @param spender The address that will spend the tokens.
251      * @param value The number of tokens that can be spent.
252      */
253     function _approve(address owner, address spender, uint256 value) internal {
254         require(spender != address(0));
255         require(owner != address(0));
256 
257         _allowed[owner][spender] = value;
258         emit Approval(owner, spender, value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account, deducting from the sender's allowance for said account. Uses the
264      * internal burn function.
265      * Emits an Approval event (reflecting the reduced allowance).
266      * @param account The account whose tokens will be burnt.
267      * @param value The amount that will be burnt.
268      */
269     function _burnFrom(address account, uint256 value) internal {
270         _burn(account, value);
271         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
272     }
273 }
274 
275 /**
276  * @title Burnable Token
277  * @dev Token that can be irreversibly burned (destroyed).
278  */
279 contract ERC20Burnable is ERC20 {
280     /**
281      * @dev Burns a specific amount of tokens.
282      * @param value The amount of token to be burned.
283      */
284     function burn(uint256 value) public {
285         _burn(msg.sender, value);
286     }
287 
288     /**
289      * @dev Burns a specific amount of tokens from the target address and decrements allowance
290      * @param from address The account whose tokens will be burned.
291      * @param value uint256 The amount of token to be burned.
292      */
293     function burnFrom(address from, uint256 value) public {
294         _burnFrom(from, value);
295     }
296 }
297 
298 /**
299  * @title ERC20Detailed token
300  * @dev The decimals are only for visualization purposes.
301  * All the operations are done using the smallest and indivisible token unit,
302  * just as on Ethereum all the operations are done in wei.
303  */
304 contract ERC20Detailed is IERC20 {
305     string private _name;
306     string private _symbol;
307     uint8 private _decimals;
308 
309     constructor (string memory name, string memory symbol, uint8 decimals) public {
310         _name = name;
311         _symbol = symbol;
312         _decimals = decimals;
313     }
314 
315     /**
316      * @return the name of the token.
317      */
318     function name() public view returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @return the symbol of the token.
324      */
325     function symbol() public view returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @return the number of decimals of the token.
331      */
332     function decimals() public view returns (uint8) {
333         return _decimals;
334     }
335 }
336 
337 /**
338  * @title Roles
339  * @dev Library for managing addresses assigned to a Role.
340  */
341 library Roles {
342     struct Role {
343         mapping (address => bool) bearer;
344     }
345 
346     /**
347      * @dev give an account access to this role
348      */
349     function add(Role storage role, address account) internal {
350         require(account != address(0));
351         require(!has(role, account));
352 
353         role.bearer[account] = true;
354     }
355 
356     /**
357      * @dev remove an account's access to this role
358      */
359     function remove(Role storage role, address account) internal {
360         require(account != address(0));
361         require(has(role, account));
362 
363         role.bearer[account] = false;
364     }
365 
366     /**
367      * @dev check if an account has this role
368      * @return bool
369      */
370     function has(Role storage role, address account) internal view returns (bool) {
371         require(account != address(0));
372         return role.bearer[account];
373     }
374 }
375 
376 contract MinterRole {
377     using Roles for Roles.Role;
378 
379     event MinterAdded(address indexed account);
380     event MinterRemoved(address indexed account);
381 
382     Roles.Role private _minters;
383 
384     constructor () internal {
385         _addMinter(msg.sender);
386     }
387 
388     modifier onlyMinter() {
389         require(isMinter(msg.sender));
390         _;
391     }
392 
393     function isMinter(address account) public view returns (bool) {
394         return _minters.has(account);
395     }
396 
397     function addMinter(address account) public onlyMinter {
398         _addMinter(account);
399     }
400 
401     function renounceMinter() public {
402         _removeMinter(msg.sender);
403     }
404 
405     function _addMinter(address account) internal {
406         _minters.add(account);
407         emit MinterAdded(account);
408     }
409 
410     function _removeMinter(address account) internal {
411         _minters.remove(account);
412         emit MinterRemoved(account);
413     }
414 }
415 
416 /**
417  * @title ERC20Mintable
418  * @dev ERC20 minting logic
419  */
420 contract ERC20Mintable is ERC20, MinterRole {
421     /**
422      * @dev Function to mint tokens
423      * @param to The address that will receive the minted tokens.
424      * @param value The amount of tokens to mint.
425      * @return A boolean that indicates if the operation was successful.
426      */
427     function mint(address to, uint256 value) public onlyMinter returns (bool) {
428         _mint(to, value);
429         return true;
430     }
431 }
432 
433 /**
434  * @title Ownable
435  * @dev The Ownable contract has an owner address, and provides basic authorization control
436  * functions, this simplifies the implementation of "user permissions".
437  */
438 contract Ownable {
439     address private _owner;
440 
441     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
442 
443     /**
444      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
445      * account.
446      */
447     constructor () internal {
448         _owner = msg.sender;
449         emit OwnershipTransferred(address(0), _owner);
450     }
451 
452     /**
453      * @return the address of the owner.
454      */
455     function owner() public view returns (address) {
456         return _owner;
457     }
458 
459     /**
460      * @dev Throws if called by any account other than the owner.
461      */
462     modifier onlyOwner() {
463         require(isOwner());
464         _;
465     }
466 
467     /**
468      * @return true if `msg.sender` is the owner of the contract.
469      */
470     function isOwner() public view returns (bool) {
471         return msg.sender == _owner;
472     }
473 
474     /**
475      * @dev Allows the current owner to relinquish control of the contract.
476      * It will not be possible to call the functions with the `onlyOwner`
477      * modifier anymore.
478      * @notice Renouncing ownership will leave the contract without an owner,
479      * thereby removing any functionality that is only available to the owner.
480      */
481     function renounceOwnership() public onlyOwner {
482         emit OwnershipTransferred(_owner, address(0));
483         _owner = address(0);
484     }
485 
486     /**
487      * @dev Allows the current owner to transfer control of the contract to a newOwner.
488      * @param newOwner The address to transfer ownership to.
489      */
490     function transferOwnership(address newOwner) public onlyOwner {
491         _transferOwnership(newOwner);
492     }
493 
494     /**
495      * @dev Transfers control of the contract to a newOwner.
496      * @param newOwner The address to transfer ownership to.
497      */
498     function _transferOwnership(address newOwner) internal {
499         require(newOwner != address(0));
500         emit OwnershipTransferred(_owner, newOwner);
501         _owner = newOwner;
502     }
503 }
504 
505 interface Compliance {
506     /**
507      *  @dev Checks if a transfer can occur between the from/to addresses.
508      *
509      *  Both addresses must be whitelisted, unfrozen, and pass all compliance rule checks.
510      *  THROWS when the transfer should fail.
511      *  @param initiator The address initiating the transfer.
512      *  @param from The address of the sender.
513      *  @param to The address of the receiver.
514      *  @param tokens The number of tokens being transferred.
515      *  @return If a transfer can occur between the from/to addresses.
516      */
517     function canTransfer(address initiator, address from, address to, uint256 tokens) external returns (bool);
518 }
519 
520 contract QQQ is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable, Ownable {
521     uint constant private INITIAL_SUPPLY = 21000000000e18; // 21 Billion
522     string constant public NAME = "QQQ Token";
523     string constant public SYMBOL = "QQQ";
524     uint8 constant public DECIMALS = 18;
525 
526     address constant internal ZERO_ADDRESS = address(0);
527     Compliance public compliance;
528 
529     constructor()
530         ERC20()
531         ERC20Detailed(NAME, SYMBOL, DECIMALS)
532         ERC20Mintable()
533         ERC20Burnable()
534         Ownable()
535         public
536     {
537         _mint(msg.sender, INITIAL_SUPPLY);
538     }
539 
540     /**
541      *  @dev Sets the compliance contract address to use during transfers.
542      *  @param newComplianceAddress The address of the compliance contract.
543      */
544     function setCompliance(address newComplianceAddress) external onlyOwner {
545         compliance = Compliance(newComplianceAddress);
546     }
547 
548     /**
549      * @dev Transfer token to a specified address
550      * @param to The address to transfer to.
551      * @param value The amount to be transferred.
552      */
553     function transfer(address to, uint256 value) public returns (bool) {
554         bool transferAllowed;
555         transferAllowed = canTransfer(msg.sender, to, value);
556         if (transferAllowed) {
557             _transfer(msg.sender, to, value);
558         }
559         return transferAllowed;
560     }
561 
562     /**
563      *  @dev Checks if a transfer may take place between the two accounts.
564      *
565      *   Validates that the transfer can take place.
566      *     - Ensure the transfer is compliant
567      *  @param from The sender address.
568      *  @param to The recipient address.
569      *  @param tokens The number of tokens being transferred.
570      *  @return If the transfer can take place.
571      */
572     function canTransfer(address from, address to, uint256 tokens) private returns (bool) {
573         // ignore compliance rules when compliance not set.
574         if (address(compliance) == ZERO_ADDRESS) {
575             return true;
576         }
577         return compliance.canTransfer(msg.sender, from, to, tokens);
578     }
579 }