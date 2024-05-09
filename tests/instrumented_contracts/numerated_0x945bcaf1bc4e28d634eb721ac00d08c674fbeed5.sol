1 pragma solidity >=0.4.22 <0.6.0;
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
27  * @dev Unsigned math operations with safety checks that revert on error.
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
90  * @title Ownable
91  * @dev The Ownable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  */
94 contract Ownable {
95     address payable private _owner;
96 
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99     /**
100      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101      * account.
102      */
103     constructor () internal {
104         _owner = msg.sender;
105         emit OwnershipTransferred(address(0), _owner);
106     }
107 
108     /**
109      * @return the address of the owner.
110      */
111     function owner() public view returns (address payable) {
112         return _owner;
113     }
114 
115     /**
116      * @dev Throws if called by any account other than the owner.
117      */
118     modifier onlyOwner() {
119         require(isOwner(),"Invalid owner");
120         _;
121     }
122 
123     /**
124      * @return true if `msg.sender` is the owner of the contract.
125      */
126     function isOwner() public view returns (bool) {
127         return msg.sender == _owner;
128     }
129 
130     /**
131      * @dev Allows the current owner to transfer control of the contract to a newOwner.
132      * @param newOwner The address to transfer ownership to.
133      */
134     function transferOwnership(address payable newOwner) public onlyOwner {
135         _transferOwnership(newOwner);
136     }
137 
138     /**
139      * @dev Transfers control of the contract to a newOwner.
140      * @param newOwner The address to transfer ownership to.
141      */
142     function _transferOwnership(address payable newOwner) internal {
143         require(newOwner != address(0));
144         emit OwnershipTransferred(_owner, newOwner);
145         _owner = newOwner;
146     }
147 }
148 
149 /**
150  * @title ERC20Detailed token
151  * @dev The decimals are only for visualization purposes.
152  * All the operations are done using the smallest and indivisible token unit,
153  * just as on Ethereum all the operations are done in wei.
154  */
155 contract ERC20Detailed is IERC20 {
156     string private _name;
157     string private _symbol;
158     uint8 public _decimals;
159 
160     constructor (string memory name, string memory symbol, uint8 decimals) public {
161         _name = name;
162         _symbol = symbol;
163         _decimals = decimals;
164     }
165 
166     /**
167      * @return the name of the token.
168      */
169     function name() public view returns (string memory) {
170         return _name;
171     }
172 
173     /**
174      * @return the symbol of the token.
175      */
176     function symbol() public view returns (string memory) {
177         return _symbol;
178     }
179 
180     /**
181      * @return the number of decimals of the token.
182      */
183     function decimals() public view returns (uint8) {
184         return _decimals;
185     }
186 }
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * https://eips.ethereum.org/EIPS/eip-20
194  * Originally based on code by FirstBlood:
195  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  *
197  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
198  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
199  * compliant implementations may not do it.
200  */
201 contract ERC20 is IERC20 {
202     using SafeMath for uint256;
203 
204     mapping (address => uint256) public _balances;
205 
206     mapping (address => mapping (address => uint256)) private _allowed;
207     
208     mapping (address => bool) public frozenAccount;
209 
210     uint256 private _totalSupply;
211     
212     /**
213      * @dev Total number of tokens in existence.
214      */
215     function totalSupply() public view returns (uint256) {
216         return _totalSupply;
217     }
218 
219 
220     /**
221      * @dev Gets the balance of the specified address.
222      * @param owner The address to query the balance of.
223      * @return A uint256 representing the amount owned by the passed address.
224      */
225     function balanceOf(address owner) public view returns (uint256) {
226         return _balances[owner];
227     }
228 
229     /**
230      * @dev Function to check the amount of tokens that an owner allowed to a spender.
231      * @param owner address The address which owns the funds.
232      * @param spender address The address which will spend the funds.
233      * @return A uint256 specifying the amount of tokens still available for the spender.
234      */
235     function allowance(address owner, address spender) public view returns (uint256) {
236         return _allowed[owner][spender];
237     }
238 
239     /**
240      * @dev Transfer token to a specified address.
241      * @param to The address to transfer to.
242      * @param value The amount to be transferred.
243      */
244     function transfer(address to, uint256 value) public returns (bool) {
245         _transfer(msg.sender, to, value);
246         return true;
247     }
248 
249     /**
250      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251      * Beware that changing an allowance with this method brings the risk that someone may use both the old
252      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      * @param spender The address which will spend the funds.
256      * @param value The amount of tokens to be spent.
257      */
258     function approve(address spender, uint256 value) public returns (bool) {
259         _approve(msg.sender, spender, value);
260         return true;
261     }
262 
263     /**
264      * @dev Transfer tokens from one address to another.
265      * Note that while this function emits an Approval event, this is not required as per the specification,
266      * and other compliant implementations may not emit the event.
267      * @param from address The address which you want to send tokens from
268      * @param to address The address which you want to transfer to
269      * @param value uint256 the amount of tokens to be transferred
270      */
271     function transferFrom(address from, address to, uint256 value) public returns (bool) {
272         _transfer(from, to, value);
273         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
274         return true;
275     }
276 
277     /**
278      * @dev Transfer token for a specified addresses.
279      * @param from The address to transfer from.
280      * @param to The address to transfer to.
281      * @param value The amount to be transferred.
282      */
283     function _transfer(address from, address to, uint256 value) internal {
284         require(to != address(0),"Check recipient is owner");
285         // Check if sender is frozen
286         require(!frozenAccount[from],"Check if sender is frozen");
287         // Check if recipient is frozen
288         require(!frozenAccount[to],"Check if recipient is frozen");
289         
290         _balances[from] = _balances[from].sub(value);
291         _balances[to] = _balances[to].add(value);
292         emit Transfer(from, to, value);
293     }
294 
295     /**
296      * @dev Internal function that mints an amount of the token and assigns it to
297      * an account. This encapsulates the modification of balances such that the
298      * proper events are emitted.
299      * @param account The account that will receive the created tokens.
300      * @param value The amount that will be created.
301      */
302     function _mint(address account, uint256 value) internal {
303         require(account != address(0),"Check recipient is '0x0'");
304 
305         _totalSupply = _totalSupply.add(value);
306         _balances[account] = _balances[account].add(value);
307         emit Transfer(address(0), account, value);
308     }
309 
310     /**
311      * @dev Internal function that burns an amount of the token of a given
312      * account.
313      * @param account The account whose tokens will be burnt.
314      * @param value The amount that will be burnt.
315      */
316     function _burn(address account, uint256 value) internal {
317         require(account != address(0),"Check recipient is owner");
318 
319         _totalSupply = _totalSupply.sub(value);
320         _balances[account] = _balances[account].sub(value);
321         emit Transfer(account, address(0), value);
322     }
323 
324     /**
325      * @dev Approve an address to spend another addresses' tokens.
326      * @param owner The address that owns the tokens.
327      * @param spender The address that will spend the tokens.
328      * @param value The number of tokens that can be spent.
329      */
330     function _approve(address owner, address spender, uint256 value) internal {
331         require(spender != address(0));
332         require(owner != address(0));
333 
334         _allowed[owner][spender] = value;
335         emit Approval(owner, spender, value);
336     }
337 
338     
339 }
340 
341 /**
342  * @title Roles
343  * @dev Library for managing addresses assigned to a Role.
344  */
345 library Roles {
346     struct Role {
347         mapping (address => bool) bearer;
348     }
349 
350     /**
351      * @dev Give an account access to this role.
352      */
353     function add(Role storage role, address account) internal {
354         require(account != address(0));
355         require(!has(role, account));
356 
357         role.bearer[account] = true;
358     }
359 
360     /**
361      * @dev Remove an account's access to this role.
362      */
363     function remove(Role storage role, address account) internal {
364         require(account != address(0));
365         require(has(role, account));
366 
367         role.bearer[account] = false;
368     }
369 
370     /**
371      * @dev Check if an account has this role.
372      * @return bool
373      */
374     function has(Role storage role, address account) internal view returns (bool) {
375         require(account != address(0));
376         return role.bearer[account];
377     }
378 }
379 
380 contract MinterRole is Ownable {
381     using Roles for Roles.Role;
382 
383     event MinterAdded(address indexed account);
384     event MinterRemoved(address indexed account);
385 
386     Roles.Role private _minters;
387 
388     constructor () internal {
389         _addMinter(msg.sender);
390     }
391 
392     function isMinter(address account) public view returns (bool) {
393         return _minters.has(account);
394     }
395 
396     function _addMinter(address account) internal {
397         _minters.add(account);
398         emit MinterAdded(account);
399     }
400 
401     function _removeMinter(address account) internal {
402         _minters.remove(account);
403         emit MinterRemoved(account);
404     }
405 }
406 
407 /**
408  * @title ERC20Mintable
409  * @dev ERC20 minting logic.
410  */
411 contract ERC20Mintable is ERC20, Ownable {
412     /**
413      * @dev Function to mint tokens
414      * @param to The address that will receive the minted tokens.
415      * @param value The amount of tokens to mint.
416      * @return A boolean that indicates if the operation was successful.
417      */
418     function mint(address to, uint256 value) public onlyOwner returns (bool) {
419         _mint(to, value);
420         return true;
421     }
422 }
423 
424 
425 /**
426  * @title Burnable Token
427  * @dev Token that can be irreversibly burned (destroyed).
428  */
429 contract ERC20Burnable is ERC20,Ownable{
430     /**
431      * @dev Burns a specific amount of tokens.
432      * @param value The amount of token to be burned.
433      */
434     function burn(uint256 value) onlyOwner public {
435         _burn(msg.sender, value);
436     }
437 
438 }
439 
440 contract PauserRole is Ownable {
441     using Roles for Roles.Role;
442 
443     event PauserAdded(address indexed account);
444     event PauserRemoved(address indexed account);
445 
446     Roles.Role private _pausers;
447 
448     constructor () internal {
449         _addPauser(msg.sender);
450     }
451 
452     modifier onlyPauser() {
453         require(isPauser(msg.sender));
454         _;
455     }
456 
457     function isPauser(address account) public view returns (bool) {
458         return _pausers.has(account);
459     }
460 
461     function _addPauser(address account) internal {
462         _pausers.add(account);
463         emit PauserAdded(account);
464     }
465 
466     function _removePauser(address account) internal {
467         _pausers.remove(account);
468         emit PauserRemoved(account);
469     }
470 }
471 
472 
473 /**
474  * @title Pausable
475  * @dev Base contract which allows children to implement an emergency stop mechanism.
476  */
477 contract Pausable is PauserRole {
478     event Paused(address account);
479     event Unpaused(address account);
480 
481     bool private _paused;
482 
483     constructor () internal {
484         _paused = false;
485     }
486     
487     // modifier onlyPauser() {
488     //     require(isPauser(msg.sender));
489     //     _;
490     // }
491     /**
492      * @return True if the contract is paused, false otherwise.
493      */
494     function paused() public view returns (bool) {
495         return _paused;
496     }
497 
498     /**
499      * @dev Modifier to make a function callable only when the contract is not paused.
500      */
501     modifier whenNotPaused() {
502         require(!_paused);
503         _;
504     }
505 
506     /**
507      * @dev Modifier to make a function callable only when the contract is paused.
508      */
509     modifier whenPaused() {
510         require(_paused);
511         _;
512     }
513 
514     /**
515      * @dev Called by a pauser to pause, triggers stopped state.
516      */
517     function pause() public onlyOwner whenNotPaused {
518         _paused = true;
519         emit Paused(msg.sender);
520     }
521 
522     /**
523      * @dev Called by a pauser to unpause, returns to normal state.
524      */
525     function unpause() public onlyOwner whenPaused {
526         _paused = false;
527         emit Unpaused(msg.sender);
528     }
529 }
530 
531 
532 /**
533  * @title Pausable token
534  * @dev ERC20 modified with pausable transfers.
535  */
536 contract ERC20Pausable is ERC20, Pausable {
537     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
538         return super.transfer(to, value);
539     }
540 
541     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
542         return super.transferFrom(from, to, value);
543     }
544 
545     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
546         return super.approve(spender, value);
547     }
548 
549 }
550 
551 
552 /**
553  * @title Heart Number Token
554  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
555  * Note they can later distribute these tokens as they wish using `transfer` and other
556  * `ERC20` functions.
557  */
558 contract HTN_TOKEN is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Pausable {
559 
560     string private constant NAME = "Heart Number"; 
561     string private constant SYMBOL = "HTN"; 
562     uint8 private constant DECIMALS = 18; 
563     
564     /**
565      * @dev The price of tokenBuy.
566      */
567     uint256 public TokenPerETHBuy = 100000;
568     
569     /**
570      * @dev The price of tokenSell.
571      */
572     uint256 public TokenPerETHSell = 100000;
573     
574     /**
575     * @dev Sell token is enabled
576     */
577     bool public SellTokenAllowed;
578     
579     /**
580     * @dev Buy token is enabled
581     */
582     bool public BuyTokenAllowed;
583     
584     /**
585      * @dev This notifies clients about the new Buy price.
586      */
587     event BuyRateChanged(uint256 oldValue, uint256 newValue);
588     
589     /**
590      * @dev This notifies clients about the new Sell price.
591      */
592     event SellRateChanged(uint256 oldValue, uint256 newValue);
593     
594     /**
595      * @dev This notifies clients about the Buy Token.
596      */
597     event BuyToken(address user, uint256 eth, uint256 token);
598     
599      /**
600      * @dev This notifies clients about the Sell Token.
601      */
602     event SellToken(address user, uint256 eth, uint256 token);
603     
604     /**
605      * @dev This notifies clients about frozen accounts.
606      */
607     event FrozenFunds(address target, bool frozen);    
608     
609     /**
610     * @dev This notifies sell token status.
611     */
612     event SellTokenAllowedEvent(bool isAllowed);
613     
614     /**
615     * @dev This notifies buy token status.
616     */
617     event BuyTokenAllowedEvent(bool isAllowed);
618     
619     uint256 public constant INITIAL_SUPPLY = 10000000000 *(10 ** uint256(DECIMALS));
620 
621     
622     /**
623      * @dev Constructor that gives msg.sender all of existing tokens.
624      */
625     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
626         _mint(msg.sender, INITIAL_SUPPLY);
627         SellTokenAllowed = false;
628         BuyTokenAllowed = true;
629     }
630     
631     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
632     /// @param target Address to be frozen
633     /// @param freeze either to freeze it or not
634     function freezeAccount(address target, bool freeze) onlyOwner  public {
635         frozenAccount[target] = freeze;
636         emit FrozenFunds(target, freeze);
637     }
638     
639     /**
640     * Set price function for Buy
641     *
642     * @param value the amount new Buy Price
643     */
644     function setBuyRate(uint256 value) onlyOwner public {
645         require(value > 0);
646         emit BuyRateChanged(TokenPerETHBuy, value);
647         TokenPerETHBuy = value;
648     }
649     
650     /**
651     * Set price function for Sell
652     *
653     * @param value the amount new Sell Price
654     */
655     function setSellRate(uint256 value) onlyOwner public {
656         require(value > 0);
657         emit SellRateChanged(TokenPerETHSell, value);
658         TokenPerETHSell = value;
659     }
660     
661     /**
662     *  function for Buy Token
663     */
664     function buy() payable public  returns (uint amount){
665         require(msg.value > 0 , "Ivalid Ether amount");
666         require(!frozenAccount[msg.sender], "Accout is frozen");                      // check sender is not frozen account
667         require(BuyTokenAllowed, "Buy Token is not allowed");                         // check buy token allowed
668         amount = ((msg.value.mul(TokenPerETHBuy)).mul( 10 ** uint256(decimals()))).div(1 ether);
669         _balances[address(this)] -= amount;                        // adds the amount to owner's 
670         _balances[msg.sender] += amount; 
671         emit Transfer(address(this),msg.sender ,amount);
672         return amount;
673     }
674     
675     /**
676     *  function for Sell Token
677     */
678     function sell(uint amount) public  returns (uint revenue){
679         
680         require(_balances[msg.sender] >= amount,"Checks if the sender has enough to sell");         // checks if the sender has enough to sell
681         require(!frozenAccount[msg.sender],"Check if sender is frozen");              // check sender is not frozen account
682         require(SellTokenAllowed);                        // check sell token allowed  
683         _balances[address(this)] += amount;               // adds the amount to owner's balance
684         _balances[msg.sender] -= amount;                  // subtracts the amount from seller's balance
685         revenue = (amount.mul(1 ether)).div(TokenPerETHSell.mul(10 ** uint256(decimals()))) ;
686         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
687         emit Transfer(msg.sender, address(this), amount);               // executes an event reflecting on the change
688         return revenue;                                   // ends function and returns
689         
690     }
691     
692     /**
693     * Enable Sell Token
694     */
695     function enableSellToken() onlyOwner public {
696         SellTokenAllowed = true;
697         emit SellTokenAllowedEvent (true);
698     }
699 
700     /**
701     * Disable Sell Token
702     */
703     function disableSellToken() onlyOwner public {
704         SellTokenAllowed = false;
705         emit SellTokenAllowedEvent (false);
706     }
707     
708     /**
709     * Enable Buy Token
710     */
711     function enableBuyToken() onlyOwner public {
712         BuyTokenAllowed = true;
713         emit BuyTokenAllowedEvent (true);
714     }
715 
716     /**
717     * Disable Buy Token
718     */
719     function disableBuyToken() onlyOwner public {
720         BuyTokenAllowed = false;
721         emit BuyTokenAllowedEvent (false);
722     }
723     
724     /**
725     * @dev Withdraw for Ether
726     */
727      function withdraw(uint withdrawAmount) onlyOwner public  {
728           if (withdrawAmount <= address(this).balance) {
729             owner().transfer(withdrawAmount);
730         }
731     }
732 }