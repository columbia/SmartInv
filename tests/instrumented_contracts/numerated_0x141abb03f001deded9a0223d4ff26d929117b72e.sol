1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8     /**
9     * @dev Returns the largest of two numbers.
10     */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16     * @dev Returns the smallest of two numbers.
17     */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23     * @dev Calculates the average of two numbers. Since these are integers,
24     * averages of an even and odd number cannot be represented, and will be
25     * rounded down.
26     */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     /**
39     * @dev Multiplies two unsigned integers, reverts on overflow.
40     */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57     */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69     */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78     * @dev Adds two unsigned integers, reverts on overflow.
79     */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 
87     /**
88     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
89     * reverts when dividing by zero.
90     */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 
97 /**
98  * @title Roles
99  * @dev Library for managing addresses assigned to a Role.
100  */
101 library Roles {
102     struct Role {
103         mapping (address => bool) bearer;
104     }
105 
106     /**
107      * @dev give an account access to this role
108      */
109     function add(Role storage role, address account) internal {
110         require(account != address(0));
111         require(!has(role, account));
112 
113         role.bearer[account] = true;
114     }
115 
116     /**
117      * @dev remove an account's access to this role
118      */
119     function remove(Role storage role, address account) internal {
120         require(account != address(0));
121         require(has(role, account));
122 
123         role.bearer[account] = false;
124     }
125 
126     /**
127      * @dev check if an account has this role
128      * @return bool
129      */
130     function has(Role storage role, address account) internal view returns (bool) {
131         require(account != address(0));
132         return role.bearer[account];
133     }
134 }
135 
136 contract MinterRole {
137     using Roles for Roles.Role;
138 
139     event MinterAdded(address indexed account);
140     event MinterRemoved(address indexed account);
141 
142     Roles.Role private _minters;
143 
144     constructor () internal {
145         _addMinter(msg.sender);
146     }
147 
148     modifier onlyMinter() {
149         require(isMinter(msg.sender));
150         _;
151     }
152 
153     function isMinter(address account) public view returns (bool) {
154         return _minters.has(account);
155     }
156 
157     function addMinter(address account) public onlyMinter {
158         _addMinter(account);
159     }
160 
161     function renounceMinter() public {
162         _removeMinter(msg.sender);
163     }
164 
165     function _addMinter(address account) internal {
166         _minters.add(account);
167         emit MinterAdded(account);
168     }
169 
170     function _removeMinter(address account) internal {
171         _minters.remove(account);
172         emit MinterRemoved(account);
173     }
174 }
175 
176 contract PauserRole {
177     using Roles for Roles.Role;
178 
179     event PauserAdded(address indexed account);
180     event PauserRemoved(address indexed account);
181 
182     Roles.Role private _pausers;
183 
184     constructor () internal {
185         _addPauser(msg.sender);
186     }
187 
188     modifier onlyPauser() {
189         require(isPauser(msg.sender));
190         _;
191     }
192 
193     function isPauser(address account) public view returns (bool) {
194         return _pausers.has(account);
195     }
196 
197     function addPauser(address account) public onlyPauser {
198         _addPauser(account);
199     }
200 
201     function renouncePauser() public {
202         _removePauser(msg.sender);
203     }
204 
205     function _addPauser(address account) internal {
206         _pausers.add(account);
207         emit PauserAdded(account);
208     }
209 
210     function _removePauser(address account) internal {
211         _pausers.remove(account);
212         emit PauserRemoved(account);
213     }
214 }
215 
216 /**
217  * @title Pausable
218  * @dev Base contract which allows children to implement an emergency stop mechanism.
219  */
220 contract Pausable is PauserRole {
221     event Paused(address account);
222     event Unpaused(address account);
223 
224     bool private _paused;
225 
226     constructor () internal {
227         _paused = false;
228     }
229 
230     /**
231      * @return true if the contract is paused, false otherwise.
232      */
233     function paused() public view returns (bool) {
234         return _paused;
235     }
236 
237     /**
238      * @dev Modifier to make a function callable only when the contract is not paused.
239      */
240     modifier whenNotPaused() {
241         require(!_paused);
242         _;
243     }
244 
245     /**
246      * @dev Modifier to make a function callable only when the contract is paused.
247      */
248     modifier whenPaused() {
249         require(_paused);
250         _;
251     }
252 
253     /**
254      * @dev called by the owner to pause, triggers stopped state
255      */
256     function pause() public onlyPauser whenNotPaused {
257         _paused = true;
258         emit Paused(msg.sender);
259     }
260 
261     /**
262      * @dev called by the owner to unpause, returns to normal state
263      */
264     function unpause() public onlyPauser whenPaused {
265         _paused = false;
266         emit Unpaused(msg.sender);
267     }
268 }
269 
270 /**
271  * @title ERC20 interface
272  * @dev see https://github.com/ethereum/EIPs/issues/20
273  */
274 interface IERC20 {
275     function transfer(address to, uint256 value) external returns (bool);
276 
277     function approve(address spender, uint256 value) external returns (bool);
278 
279     function transferFrom(address from, address to, uint256 value) external returns (bool);
280 
281     function totalSupply() external view returns (uint256);
282 
283     function balanceOf(address who) external view returns (uint256);
284 
285     function allowance(address owner, address spender) external view returns (uint256);
286 
287     event Transfer(address indexed from, address indexed to, uint256 value);
288 
289     event Approval(address indexed owner, address indexed spender, uint256 value);
290 }
291 
292 /**
293  * @title Standard ERC20 token
294  *
295  * @dev Implementation of the basic standard token.
296  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
297  * Originally based on code by FirstBlood:
298  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
299  *
300  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
301  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
302  * compliant implementations may not do it.
303  */
304 contract ERC20 is IERC20 {
305     using SafeMath for uint256;
306 
307     mapping (address => uint256) private _balances;
308 
309     mapping (address => mapping (address => uint256)) private _allowed;
310 
311     uint256 private _totalSupply;
312 
313     /**
314     * @dev Total number of tokens in existence
315     */
316     function totalSupply() public view returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321     * @dev Gets the balance of the specified address.
322     * @param owner The address to query the balance of.
323     * @return An uint256 representing the amount owned by the passed address.
324     */
325     function balanceOf(address owner) public view returns (uint256) {
326         return _balances[owner];
327     }
328 
329     /**
330      * @dev Function to check the amount of tokens that an owner allowed to a spender.
331      * @param owner address The address which owns the funds.
332      * @param spender address The address which will spend the funds.
333      * @return A uint256 specifying the amount of tokens still available for the spender.
334      */
335     function allowance(address owner, address spender) public view returns (uint256) {
336         return _allowed[owner][spender];
337     }
338 
339     /**
340     * @dev Transfer token for a specified address
341     * @param to The address to transfer to.
342     * @param value The amount to be transferred.
343     */
344     function transfer(address to, uint256 value) public returns (bool) {
345         _transfer(msg.sender, to, value);
346         return true;
347     }
348 
349     /**
350      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
351      * Beware that changing an allowance with this method brings the risk that someone may use both the old
352      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
353      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
354      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
355      * @param spender The address which will spend the funds.
356      * @param value The amount of tokens to be spent.
357      */
358     function approve(address spender, uint256 value) public returns (bool) {
359         require(spender != address(0));
360 
361         _allowed[msg.sender][spender] = value;
362         emit Approval(msg.sender, spender, value);
363         return true;
364     }
365 
366     /**
367      * @dev Transfer tokens from one address to another.
368      * Note that while this function emits an Approval event, this is not required as per the specification,
369      * and other compliant implementations may not emit the event.
370      * @param from address The address which you want to send tokens from
371      * @param to address The address which you want to transfer to
372      * @param value uint256 the amount of tokens to be transferred
373      */
374     function transferFrom(address from, address to, uint256 value) public returns (bool) {
375         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
376         _transfer(from, to, value);
377         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
378         return true;
379     }
380 
381     /**
382      * @dev Increase the amount of tokens that an owner allowed to a spender.
383      * approve should be called when allowed_[_spender] == 0. To increment
384      * allowed value is better to use this function to avoid 2 calls (and wait until
385      * the first transaction is mined)
386      * From MonolithDAO Token.sol
387      * Emits an Approval event.
388      * @param spender The address which will spend the funds.
389      * @param addedValue The amount of tokens to increase the allowance by.
390      */
391     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
392         require(spender != address(0));
393 
394         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
395         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
396         return true;
397     }
398 
399     /**
400      * @dev Decrease the amount of tokens that an owner allowed to a spender.
401      * approve should be called when allowed_[_spender] == 0. To decrement
402      * allowed value is better to use this function to avoid 2 calls (and wait until
403      * the first transaction is mined)
404      * From MonolithDAO Token.sol
405      * Emits an Approval event.
406      * @param spender The address which will spend the funds.
407      * @param subtractedValue The amount of tokens to decrease the allowance by.
408      */
409     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
410         require(spender != address(0));
411 
412         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
413         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
414         return true;
415     }
416 
417     /**
418     * @dev Transfer token for a specified addresses
419     * @param from The address to transfer from.
420     * @param to The address to transfer to.
421     * @param value The amount to be transferred.
422     */
423     function _transfer(address from, address to, uint256 value) internal {
424         require(to != address(0));
425 
426         _balances[from] = _balances[from].sub(value);
427         _balances[to] = _balances[to].add(value);
428         emit Transfer(from, to, value);
429     }
430 
431     /**
432      * @dev Internal function that mints an amount of the token and assigns it to
433      * an account. This encapsulates the modification of balances such that the
434      * proper events are emitted.
435      * @param account The account that will receive the created tokens.
436      * @param value The amount that will be created.
437      */
438     function _mint(address account, uint256 value) internal {
439         require(account != address(0));
440 
441         _totalSupply = _totalSupply.add(value);
442         _balances[account] = _balances[account].add(value);
443         emit Transfer(address(0), account, value);
444     }
445 
446     /**
447      * @dev Internal function that burns an amount of the token of a given
448      * account.
449      * @param account The account whose tokens will be burnt.
450      * @param value The amount that will be burnt.
451      */
452     function _burn(address account, uint256 value) internal {
453         require(account != address(0));
454 
455         _totalSupply = _totalSupply.sub(value);
456         _balances[account] = _balances[account].sub(value);
457         emit Transfer(account, address(0), value);
458     }
459 
460     /**
461      * @dev Internal function that burns an amount of the token of a given
462      * account, deducting from the sender's allowance for said account. Uses the
463      * internal burn function.
464      * Emits an Approval event (reflecting the reduced allowance).
465      * @param account The account whose tokens will be burnt.
466      * @param value The amount that will be burnt.
467      */
468     function _burnFrom(address account, uint256 value) internal {
469         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
470         _burn(account, value);
471         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
472     }
473 }
474 
475 /**
476  * @title ERC20Detailed token
477  * @dev The decimals are only for visualization purposes.
478  * All the operations are done using the smallest and indivisible token unit,
479  * just as on Ethereum all the operations are done in wei.
480  */
481 contract ERC20Detailed is IERC20 {
482     string private _name;
483     string private _symbol;
484     uint8 private _decimals;
485 
486     constructor (string memory name, string memory symbol, uint8 decimals) public {
487         _name = name;
488         _symbol = symbol;
489         _decimals = decimals;
490     }
491 
492     /**
493      * @return the name of the token.
494      */
495     function name() public view returns (string memory) {
496         return _name;
497     }
498 
499     /**
500      * @return the symbol of the token.
501      */
502     function symbol() public view returns (string memory) {
503         return _symbol;
504     }
505 
506     /**
507      * @return the number of decimals of the token.
508      */
509     function decimals() public view returns (uint8) {
510         return _decimals;
511     }
512 }
513 
514 /**
515  * @title Pausable token
516  * @dev ERC20 modified with pausable transfers.
517  **/
518 contract ERC20Pausable is ERC20, Pausable {
519     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
520         return super.transfer(to, value);
521     }
522 
523     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
524         return super.transferFrom(from, to, value);
525     }
526 
527     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
528         return super.approve(spender, value);
529     }
530 
531     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
532         return super.increaseAllowance(spender, addedValue);
533     }
534 
535     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
536         return super.decreaseAllowance(spender, subtractedValue);
537     }
538 }
539 
540 /**
541  * @title ERC20Mintable
542  * @dev ERC20 minting logic
543  */
544 contract ERC20Mintable is ERC20, MinterRole {
545     /**
546      * @dev Function to mint tokens
547      * @param to The address that will receive the minted tokens.
548      * @param value The amount of tokens to mint.
549      * @return A boolean that indicates if the operation was successful.
550      */
551     function mint(address to, uint256 value) public onlyMinter returns (bool) {
552         _mint(to, value);
553         return true;
554     }
555 }
556 
557 /**
558  * @title Ownable
559  * @dev The Ownable contract has an owner address, and provides basic authorization control
560  * functions, this simplifies the implementation of "user permissions".
561  */
562 contract Ownable {
563     address private _owner;
564 
565     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
566 
567     /**
568      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
569      * account.
570      */
571     constructor () internal {
572         _owner = msg.sender;
573         emit OwnershipTransferred(address(0), _owner);
574     }
575 
576     /**
577      * @return the address of the owner.
578      */
579     function owner() public view returns (address) {
580         return _owner;
581     }
582 
583     /**
584      * @dev Throws if called by any account other than the owner.
585      */
586     modifier onlyOwner() {
587         require(isOwner());
588         _;
589     }
590 
591     /**
592      * @return true if `msg.sender` is the owner of the contract.
593      */
594     function isOwner() public view returns (bool) {
595         return msg.sender == _owner;
596     }
597 
598     /**
599      * @dev Allows the current owner to relinquish control of the contract.
600      * @notice Renouncing to ownership will leave the contract without an owner.
601      * It will not be possible to call the functions with the `onlyOwner`
602      * modifier anymore.
603      */
604     function renounceOwnership() public onlyOwner {
605         emit OwnershipTransferred(_owner, address(0));
606         _owner = address(0);
607     }
608 
609     /**
610      * @dev Allows the current owner to transfer control of the contract to a newOwner.
611      * @param newOwner The address to transfer ownership to.
612      */
613     function transferOwnership(address newOwner) public onlyOwner {
614         _transferOwnership(newOwner);
615     }
616 
617     /**
618      * @dev Transfers control of the contract to a newOwner.
619      * @param newOwner The address to transfer ownership to.
620      */
621     function _transferOwnership(address newOwner) internal {
622         require(newOwner != address(0));
623         emit OwnershipTransferred(_owner, newOwner);
624         _owner = newOwner;
625     }
626 }
627 
628 /**
629  * @title HighVibe Token
630  * @dev Pausable, Mintable token
631  */
632 contract HighVibeToken is ERC20Detailed, ERC20Pausable, ERC20Mintable, Ownable {
633     uint256 public deploymentTime = now;
634     uint256 public month = 2629800;
635     uint256 public inflationRate = 100000;
636     uint256 public maxInflationRate = 100000;
637 
638     address public wallet_for_rewards_pool = 0xeA336D1C8ff0e0cCb09a253230963C7684ceE061;
639 
640     // initial token allocation
641     address public wallet_for_team_and_advisors = 0xA6548F72549c647dd400b0CC8c31C472FC97215c;
642     address public wallet_for_authors = 0xB29101d01C229b1cE23d75ae4af45349F7247142;
643     address public wallet_for_reserve = 0xA23feA54386A5B12C9BC83784A99De291fe923A3;
644     address public wallet_for_public_sale = 0x79ceBaF4cD934081E39757F3400cC83dc5DeBb78;
645     address public wallet_for_bounty = 0xAE2c66BEFb97A2C353329260703903076226Ad0b;
646 
647     /**
648     * @dev Constructor for the HighVibe Token contract.
649     *
650     * This contract creates a pausable, mintable token
651     * Pausing freezes all token functions - transfers, allowances, minting
652     */
653     constructor()
654         ERC20Detailed("HighVibe Token", "HV", 18)
655         ERC20Mintable() public {
656             super.mint(wallet_for_team_and_advisors, 1600000000 ether);
657             super.mint(wallet_for_authors, 800000000 ether);
658             super.mint(wallet_for_reserve, 1600000000 ether);
659             super.mint(wallet_for_public_sale, 3600000000 ether);
660             super.mint(wallet_for_bounty, 400000000 ether);
661     }
662 
663     // only owner can change ownership of rewards pool wallet address
664     function changeRewardsPoolOwnership(address _owner) external onlyOwner {
665         wallet_for_rewards_pool = _owner;
666     }
667 
668     // minting is disabled for anyone
669     function mint(address _to, uint256 _amount) whenNotPaused public returns (bool) {   
670         revert("tokens cannot be minted other than inflation tokens");
671     }
672 
673     // anyone can call this function to mint inflation tokens unless paused
674     // by owner
675     function mintInflationTokens() external {
676         require(now >= deploymentTime + month, "new inflation tokens cannot be minted yet");
677         uint256 _supplyIncrease = (super.totalSupply() * inflationRate) / 12000000;
678         super.mint(wallet_for_rewards_pool, _supplyIncrease);
679         deploymentTime += month; // increase the time since deployment
680     }
681 
682     // only owner can change inflation rate up to a maximum of 10%
683     function changeInflationRate(uint256 _rate) external onlyOwner {
684         require(_rate <= maxInflationRate, "Yearly inflation rate must be less than or equal to 10.0000%");
685         inflationRate = _rate;
686     }
687 }