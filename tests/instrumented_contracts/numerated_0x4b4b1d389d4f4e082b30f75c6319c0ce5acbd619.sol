1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * HEART NUMBER 2019 
5  */
6 interface IERC20 {
7     function transfer(address to, uint256 value) external returns (bool);
8 
9     function approve(address spender, uint256 value) external returns (bool);
10 
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 /**
25  * @title SafeMath
26  * @dev Unsigned math operations with safety checks that revert on error.
27  */
28 library SafeMath {
29     /**
30      * @dev Multiplies two unsigned integers, reverts on overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Adds two unsigned integers, reverts on overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a);
74 
75         return c;
76     }
77 
78     /**
79      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
80      * reverts when dividing by zero.
81      */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0);
84         return a % b;
85     }
86 }
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94     address payable private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100      * account.
101      */
102     constructor () internal {
103         _owner = msg.sender;
104         emit OwnershipTransferred(address(0), _owner);
105     }
106 
107     /**
108      * @return the address of the owner.
109      */
110     function owner() public view returns (address payable) {
111         return _owner;
112     }
113 
114     /**
115      * @dev Throws if called by any account other than the owner.
116      */
117     modifier onlyOwner() {
118         require(isOwner(),"Invalid owner");
119         _;
120     }
121 
122     /**
123      * @return true if `msg.sender` is the owner of the contract.
124      */
125     function isOwner() public view returns (bool) {
126         return msg.sender == _owner;
127     }
128 
129     /**
130      * @dev Allows the current owner to transfer control of the contract to a newOwner.
131      * @param newOwner The address to transfer ownership to.
132      */
133     function transferOwnership(address payable newOwner) public onlyOwner {
134         _transferOwnership(newOwner);
135     }
136 
137     /**
138      * @dev Transfers control of the contract to a newOwner.
139      * @param newOwner The address to transfer ownership to.
140      */
141     function _transferOwnership(address payable newOwner) internal {
142         require(newOwner != address(0));
143         emit OwnershipTransferred(_owner, newOwner);
144         _owner = newOwner;
145     }
146 }
147 
148 /**
149  * @title ERC20Detailed token
150  * @dev The decimals are only for visualization purposes.
151  * All the operations are done using the smallest and indivisible token unit,
152  * just as on Ethereum all the operations are done in wei.
153  */
154 contract ERC20Detailed is IERC20 {
155     string private _name;
156     string private _symbol;
157     uint8 public _decimals;
158 
159     constructor (string memory name, string memory symbol, uint8 decimals) public {
160         _name = name;
161         _symbol = symbol;
162         _decimals = decimals;
163     }
164 
165     /**
166      * @return the name of the token.
167      */
168     function name() public view returns (string memory) {
169         return _name;
170     }
171 
172     /**
173      * @return the symbol of the token.
174      */
175     function symbol() public view returns (string memory) {
176         return _symbol;
177     }
178 
179     /**
180      * @return the number of decimals of the token.
181      */
182     function decimals() public view returns (uint8) {
183         return _decimals;
184     }
185 }
186 
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * https://eips.ethereum.org/EIPS/eip-20
193  * Originally based on code by FirstBlood:
194  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  *
196  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
197  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
198  * compliant implementations may not do it.
199  */
200 contract ERC20 is IERC20 {
201     using SafeMath for uint256;
202 
203     mapping (address => uint256) public _balances;
204 
205     mapping (address => mapping (address => uint256)) private _allowed;
206     
207     mapping (address => bool) public frozenAccount;
208 
209     uint256 private _totalSupply;
210     
211     /**
212      * @dev Total number of tokens in existence.
213      */
214     function totalSupply() public view returns (uint256) {
215         return _totalSupply;
216     }
217 
218 
219     /**
220      * @dev Gets the balance of the specified address.
221      * @param owner The address to query the balance of.
222      * @return A uint256 representing the amount owned by the passed address.
223      */
224     function balanceOf(address owner) public view returns (uint256) {
225         return _balances[owner];
226     }
227 
228     /**
229      * @dev Function to check the amount of tokens that an owner allowed to a spender.
230      * @param owner address The address which owns the funds.
231      * @param spender address The address which will spend the funds.
232      * @return A uint256 specifying the amount of tokens still available for the spender.
233      */
234     function allowance(address owner, address spender) public view returns (uint256) {
235         return _allowed[owner][spender];
236     }
237 
238     /**
239      * @dev Transfer token to a specified address.
240      * @param to The address to transfer to.
241      * @param value The amount to be transferred.
242      */
243     function transfer(address to, uint256 value) public returns (bool) {
244         _transfer(msg.sender, to, value);
245         return true;
246     }
247 
248     /**
249      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250      * Beware that changing an allowance with this method brings the risk that someone may use both the old
251      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254      * @param spender The address which will spend the funds.
255      * @param value The amount of tokens to be spent.
256      */
257     function approve(address spender, uint256 value) public returns (bool) {
258         _approve(msg.sender, spender, value);
259         return true;
260     }
261 
262     /**
263      * @dev Transfer tokens from one address to another.
264      * Note that while this function emits an Approval event, this is not required as per the specification,
265      * and other compliant implementations may not emit the event.
266      * @param from address The address which you want to send tokens from
267      * @param to address The address which you want to transfer to
268      * @param value uint256 the amount of tokens to be transferred
269      */
270     function transferFrom(address from, address to, uint256 value) public returns (bool) {
271         _transfer(from, to, value);
272         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
273         return true;
274     }
275 
276     /**
277      * @dev Transfer token for a specified addresses.
278      * @param from The address to transfer from.
279      * @param to The address to transfer to.
280      * @param value The amount to be transferred.
281      */
282     function _transfer(address from, address to, uint256 value) internal {
283         require(to != address(0),"Check recipient is owner");
284         // Check if sender is frozen
285         require(!frozenAccount[from],"Check if sender is frozen");
286         // Check if recipient is frozen
287         require(!frozenAccount[to],"Check if recipient is frozen");
288         
289         _balances[from] = _balances[from].sub(value);
290         _balances[to] = _balances[to].add(value);
291         emit Transfer(from, to, value);
292     }
293 
294     /**
295      * @dev Internal function that mints an amount of the token and assigns it to
296      * an account. This encapsulates the modification of balances such that the
297      * proper events are emitted.
298      * @param account The account that will receive the created tokens.
299      * @param value The amount that will be created.
300      */
301     function _mint(address account, uint256 value) internal {
302         require(account != address(0),"Check recipient is '0x0'");
303 
304         _totalSupply = _totalSupply.add(value);
305         _balances[account] = _balances[account].add(value);
306         emit Transfer(address(0), account, value);
307     }
308 
309     /**
310      * @dev Internal function that burns an amount of the token of a given
311      * account.
312      * @param account The account whose tokens will be burnt.
313      * @param value The amount that will be burnt.
314      */
315     function _burn(address account, uint256 value) internal {
316         require(account != address(0),"Check recipient is owner");
317 
318         _totalSupply = _totalSupply.sub(value);
319         _balances[account] = _balances[account].sub(value);
320         emit Transfer(account, address(0), value);
321     }
322 
323     /**
324      * @dev Approve an address to spend another addresses' tokens.
325      * @param owner The address that owns the tokens.
326      * @param spender The address that will spend the tokens.
327      * @param value The number of tokens that can be spent.
328      */
329     function _approve(address owner, address spender, uint256 value) internal {
330         require(spender != address(0));
331         require(owner != address(0));
332 
333         _allowed[owner][spender] = value;
334         emit Approval(owner, spender, value);
335     }
336 
337     
338 }
339 
340 /**
341  * @title Roles
342  * @dev Library for managing addresses assigned to a Role.
343  */
344 library Roles {
345     struct Role {
346         mapping (address => bool) bearer;
347     }
348 
349     /**
350      * @dev Give an account access to this role.
351      */
352     function add(Role storage role, address account) internal {
353         require(account != address(0));
354         require(!has(role, account));
355 
356         role.bearer[account] = true;
357     }
358 
359     /**
360      * @dev Remove an account's access to this role.
361      */
362     function remove(Role storage role, address account) internal {
363         require(account != address(0));
364         require(has(role, account));
365 
366         role.bearer[account] = false;
367     }
368 
369     /**
370      * @dev Check if an account has this role.
371      * @return bool
372      */
373     function has(Role storage role, address account) internal view returns (bool) {
374         require(account != address(0));
375         return role.bearer[account];
376     }
377 }
378 
379 contract MinterRole is Ownable {
380     using Roles for Roles.Role;
381 
382     event MinterAdded(address indexed account);
383     event MinterRemoved(address indexed account);
384 
385     Roles.Role private _minters;
386 
387     constructor () internal {
388         _addMinter(msg.sender);
389     }
390 
391     function isMinter(address account) public view returns (bool) {
392         return _minters.has(account);
393     }
394 
395     function _addMinter(address account) internal {
396         _minters.add(account);
397         emit MinterAdded(account);
398     }
399 
400     function _removeMinter(address account) internal {
401         _minters.remove(account);
402         emit MinterRemoved(account);
403     }
404 }
405 
406 /**
407  * @title ERC20Mintable
408  * @dev ERC20 minting logic.
409  */
410 contract ERC20Mintable is ERC20, Ownable {
411     /**
412      * @dev Function to mint tokens
413      * @param to The address that will receive the minted tokens.
414      * @param value The amount of tokens to mint.
415      * @return A boolean that indicates if the operation was successful.
416      */
417     function mint(address to, uint256 value) public onlyOwner returns (bool) {
418         _mint(to, value);
419         return true;
420     }
421 }
422 
423 
424 /**
425  * @title Burnable Token
426  * @dev Token that can be irreversibly burned (destroyed).
427  */
428 contract ERC20Burnable is ERC20,Ownable{
429     /**
430      * @dev Burns a specific amount of tokens.
431      * @param value The amount of token to be burned.
432      */
433     function burn(uint256 value) onlyOwner public {
434         _burn(msg.sender, value);
435     }
436 
437 }
438 
439 contract PauserRole is Ownable {
440     using Roles for Roles.Role;
441 
442     event PauserAdded(address indexed account);
443     event PauserRemoved(address indexed account);
444 
445     Roles.Role private _pausers;
446 
447     constructor () internal {
448         _addPauser(msg.sender);
449     }
450 
451     modifier onlyPauser() {
452         require(isPauser(msg.sender));
453         _;
454     }
455 
456     function isPauser(address account) public view returns (bool) {
457         return _pausers.has(account);
458     }
459 
460     function _addPauser(address account) internal {
461         _pausers.add(account);
462         emit PauserAdded(account);
463     }
464 
465     function _removePauser(address account) internal {
466         _pausers.remove(account);
467         emit PauserRemoved(account);
468     }
469 }
470 
471 
472 /**
473  * @title Pausable
474  * @dev Base contract which allows children to implement an emergency stop mechanism.
475  */
476 contract Pausable is PauserRole {
477     event Paused(address account);
478     event Unpaused(address account);
479 
480     bool private _paused;
481 
482     constructor () internal {
483         _paused = false;
484     }
485     
486     // modifier onlyPauser() {
487     //     require(isPauser(msg.sender));
488     //     _;
489     // }
490     /**
491      * @return True if the contract is paused, false otherwise.
492      */
493     function paused() public view returns (bool) {
494         return _paused;
495     }
496 
497     /**
498      * @dev Modifier to make a function callable only when the contract is not paused.
499      */
500     modifier whenNotPaused() {
501         require(!_paused);
502         _;
503     }
504 
505     /**
506      * @dev Modifier to make a function callable only when the contract is paused.
507      */
508     modifier whenPaused() {
509         require(_paused);
510         _;
511     }
512 
513     /**
514      * @dev Called by a pauser to pause, triggers stopped state.
515      */
516     function pause() public onlyOwner whenNotPaused {
517         _paused = true;
518         emit Paused(msg.sender);
519     }
520 
521     /**
522      * @dev Called by a pauser to unpause, returns to normal state.
523      */
524     function unpause() public onlyOwner whenPaused {
525         _paused = false;
526         emit Unpaused(msg.sender);
527     }
528 }
529 
530 
531 /**
532  * @title Pausable token
533  * @dev ERC20 modified with pausable transfers.
534  */
535 contract ERC20Pausable is ERC20, Pausable {
536     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
537         return super.transfer(to, value);
538     }
539 
540     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
541         return super.transferFrom(from, to, value);
542     }
543 
544     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
545         return super.approve(spender, value);
546     }
547 
548 }
549 
550 
551 /**
552  * @title Heart Number Token
553  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
554  * Note they can later distribute these tokens as they wish using `transfer` and other
555  * `ERC20` functions.
556  */
557 contract HTN_TOKEN is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Pausable {
558 
559     string private constant NAME = "Heart Number"; 
560     string private constant SYMBOL = "HTN"; 
561     uint8 private constant DECIMALS = 18; 
562     
563     /**
564      * The price of tokenBuy.
565      */
566     uint256 public TokenPerETHBuy = 100000;
567     
568     /**
569      * The price of tokenSell.
570      */
571     uint256 public TokenPerETHSell = 100000;
572     
573     /**
574     * Sell token is enabled
575     */
576     bool public SellTokenAllowed;
577     
578     /**
579     * Buy token is enabled
580     */
581     bool public BuyTokenAllowed;
582     
583     /**
584      * This notifies clients about the new Buy price.
585      */
586     event BuyRateChanged(uint256 oldValue, uint256 newValue);
587     
588     /**
589      * This notifies clients about the new Sell price.
590      */
591     event SellRateChanged(uint256 oldValue, uint256 newValue);
592     
593     /**
594      * This notifies clients about the Buy Token.
595      */
596     event BuyToken(address user, uint256 eth, uint256 token);
597     
598      /**
599      * This notifies clients about the Sell Token.
600      */
601     event SellToken(address user, uint256 eth, uint256 token);
602     
603     /**
604      * This notifies clients about frozen accounts.
605      */
606     event FrozenFunds(address target, bool frozen);    
607     
608     /**
609     * This notifies sell token status.
610     */
611     event SellTokenAllowedEvent(bool isAllowed);
612     
613     /**
614     * This notifies buy token status.
615     */
616     event BuyTokenAllowedEvent(bool isAllowed);
617     
618     uint256 public constant INITIAL_SUPPLY = 10000000000 *(10 ** uint256(DECIMALS));
619 
620     
621     /**
622      * Constructor that gives msg.sender all of existing tokens.
623      */
624     constructor () public ERC20Detailed(NAME, SYMBOL, DECIMALS) {
625         _mint(msg.sender, INITIAL_SUPPLY);
626         SellTokenAllowed = false;
627         BuyTokenAllowed = true;
628     }
629     
630     /**
631     * Freeze Account
632     */
633     function freezeAccount(address target, bool freeze) onlyOwner  public {
634         frozenAccount[target] = freeze;
635         emit FrozenFunds(target, freeze);
636     }
637     
638     /**
639     * Set price function for Buy
640     */
641     function setBuyRate(uint256 value) onlyOwner public {
642         require(value > 0);
643         emit BuyRateChanged(TokenPerETHBuy, value);
644         TokenPerETHBuy = value;
645     }
646     
647     /**
648     * Set price function for Sell
649     */
650     function setSellRate(uint256 value) onlyOwner public {
651         require(value > 0);
652         emit SellRateChanged(TokenPerETHSell, value);
653         TokenPerETHSell = value;
654     }
655     
656     /**
657     *  Function for Buy Token
658     */
659     function buy() payable public returns (uint amount){
660         require(msg.value > 0 , "Ivalid Ether amount");
661         require(!frozenAccount[msg.sender], "Accout is frozen");                      
662         require(BuyTokenAllowed, "Buy Token is not allowed");                         
663         amount = ((msg.value.mul(TokenPerETHBuy)).mul( 10 ** uint256(decimals()))).div(1 ether); 
664         
665         _balances[address(this)] = _balances[address(this)].sub(amount);                    
666         _balances[msg.sender] = _balances[msg.sender].add(amount) ;                                           
667         emit Transfer(address(this),msg.sender ,amount);
668         return amount;
669     }
670     
671     /**
672     *  function for Sell Token
673     */
674     function sell(uint amount) public returns (uint revenue){
675         
676         require(_balances[msg.sender] >= amount,"Checks if the sender has enough to sell");        
677         require(!frozenAccount[msg.sender],"Check if sender is frozen");                            
678         require(SellTokenAllowed);                                                              
679         
680         _balances[address(this)] = _balances[address(this)].add(amount);                          
681         _balances[msg.sender] = _balances[msg.sender].sub(amount);                               
682         
683         revenue = (amount.mul(1 ether)).div(TokenPerETHSell.mul(10 ** uint256(decimals()))) ;
684         
685         msg.sender.transfer(revenue);                                                        
686         emit Transfer(msg.sender, address(this), amount);         
687         return revenue;
688         
689     }
690     
691     /**
692     * Enable Sell Token
693     */
694     function enableSellToken() onlyOwner public {
695         SellTokenAllowed = true;
696         emit SellTokenAllowedEvent (true);
697     }
698 
699     /**
700     * Disable Sell Token
701     */
702     function disableSellToken() onlyOwner public {
703         SellTokenAllowed = false;
704         emit SellTokenAllowedEvent (false);
705     }
706     
707     /**
708     * Enable Buy Token
709     */
710     function enableBuyToken() onlyOwner public {
711         BuyTokenAllowed = true;
712         emit BuyTokenAllowedEvent (true);
713     }
714 
715     /**
716     * Disable Buy Token
717     */
718     function disableBuyToken() onlyOwner public {
719         BuyTokenAllowed = false;
720         emit BuyTokenAllowedEvent (false);
721     }
722     
723     /**
724     * Withdraw for Ether
725     */
726      function withdraw(uint withdrawAmount) onlyOwner public  {
727         require(withdrawAmount <= address(this).balance); 
728         owner().transfer(withdrawAmount);
729         
730     }
731     
732     /**
733     * Withdraw for Token
734     */
735     function withdrawToken(uint tokenAmount) onlyOwner public {
736         require(tokenAmount <= _balances[address(this)]);
737         _transfer(address(this),owner(),tokenAmount);
738     }
739     
740     
741 }