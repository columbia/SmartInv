1 pragma solidity ^0.5.2;
2  
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18  
19         uint256 c = a * b;
20         require(c / a == b);
21  
22         return c;
23     }
24  
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33  
34         return c;
35     }
36  
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43  
44         return c;
45     }
46  
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53  
54         return c;
55     }
56  
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66  
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address private _owner;
74  
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76  
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor () internal {
82         _owner = msg.sender;
83         emit OwnershipTransferred(address(0), _owner);
84     }
85  
86     /**
87      * @return the address of the owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92  
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(isOwner());
98         _;
99     }
100  
101     /**
102      * @return true if `msg.sender` is the owner of the contract.
103      */
104     function isOwner() public view returns (bool) {
105         return msg.sender == _owner;
106     }
107  
108     /**
109      * @dev Allows the current owner to relinquish control of the contract.
110      * @notice Renouncing to ownership will leave the contract without an owner.
111      * It will not be possible to call the functions with the `onlyOwner`
112      * modifier anymore.
113      */
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118  
119     /**
120      * @dev Allows the current owner to transfer control of the contract to a newOwner.
121      * @param newOwner The address to transfer ownership to.
122      */
123     function transferOwnership(address newOwner) public onlyOwner {
124         _transferOwnership(newOwner);
125     }
126  
127     /**
128      * @dev Transfers control of the contract to a newOwner.
129      * @param newOwner The address to transfer ownership to.
130      */
131     function _transferOwnership(address newOwner) internal {
132         require(newOwner != address(0));
133         emit OwnershipTransferred(_owner, newOwner);
134         _owner = newOwner;
135     }
136 }
137  
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 interface IERC20 {
143     function totalSupply() external view returns (uint256);
144  
145     function balanceOf(address who) external view returns (uint256);
146  
147     function allowance(address owner, address spender) external view returns (uint256);
148  
149     function transfer(address to, uint256 value) external returns (bool);
150  
151     function approve(address spender, uint256 value) external returns (bool);
152  
153     function transferFrom(address from, address to, uint256 value) external returns (bool);
154  
155     event Transfer(address indexed from, address indexed to, uint256 value);
156  
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159  
160 /**
161  * @title Helps contracts guard against reentrancy attacks.
162  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
163  * @dev If you mark a function `nonReentrant`, you should also
164  * mark it `external`.
165  */
166 contract ReentrancyGuard {
167     /// @dev counter to allow mutex lock with only one SSTORE operation
168     uint256 private _guardCounter;
169  
170     constructor () internal {
171         // The counter starts at one to prevent changing it from zero to a non-zero
172         // value, which is a more expensive operation.
173         _guardCounter = 1;
174     }
175  
176     /**
177      * @dev Prevents a contract from calling itself, directly or indirectly.
178      * Calling a `nonReentrant` function from another `nonReentrant`
179      * function is not supported. It is possible to prevent this from happening
180      * by making the `nonReentrant` function external, and make it call a
181      * `private` function that does the actual work.
182      */
183     modifier nonReentrant() {
184         _guardCounter += 1;
185         uint256 localCounter = _guardCounter;
186         _;
187         require(localCounter == _guardCounter);
188     }
189 }
190  
191 /**
192  * @title Pausable
193  * @dev Base contract which allows children to implement an emergency stop mechanism.
194  */
195 contract Pausable is Ownable {
196     event Paused(address account);
197     event Unpaused(address account);
198  
199     bool private _paused;
200  
201     constructor () internal {
202         _paused = false;
203     }
204  
205     /**
206      * @return True if the contract is paused, false otherwise.
207      */
208     function paused() public view returns (bool) {
209         return _paused;
210     }
211  
212     /**
213      * @dev Modifier to make a function callable only when the contract is not paused.
214      */
215     modifier whenNotPaused() {
216         require(!_paused);
217         _;
218     }
219  
220     /**
221      * @dev Modifier to make a function callable only when the contract is paused.
222      */
223     modifier whenPaused() {
224         require(_paused);
225         _;
226     }
227  
228     /**
229      * @dev Called by a pauser to pause, triggers stopped state.
230      */
231     function pause() public onlyOwner whenNotPaused {
232         _paused = true;
233         emit Paused(msg.sender);
234     }
235  
236     /**
237      * @dev Called by a pauser to unpause, returns to normal state.
238      */
239     function unpause() public onlyOwner whenPaused {
240         _paused = false;
241         emit Unpaused(msg.sender);
242     }
243 }
244  
245 /**
246  * @title ERACoin
247  * @dev ERC20 Token 
248  */
249 contract ERACoin is IERC20, Ownable, ReentrancyGuard, Pausable  {
250    using SafeMath for uint256;
251    
252     mapping (address => uint256) private _balances;
253  
254     mapping (address => mapping (address => uint256)) private _allowed;
255  
256     uint256 private _totalSupply;
257     
258     /**
259     * @dev Total number of tokens in existence
260     */
261     function totalSupply() public view returns (uint256) {
262         return _totalSupply;
263     }
264  
265     /**
266     * @dev Gets the balance of the specified address.
267     * @param owner The address to query the balance of.
268     * @return An uint256 representing the amount owned by the passed address.
269     */
270     function balanceOf(address owner) public view returns (uint256) {
271         return _balances[owner];
272     }
273     
274     /**
275      * @dev Function to check the amount of tokens that an owner allowed to a spender.
276      * @param owner address The address which owns the funds.
277      * @param spender address The address which will spend the funds.
278      * @return A uint256 specifying the amount of tokens still available for the spender.
279      */
280     function allowance(address owner, address spender) public view returns (uint256) {
281         return _allowed[owner][spender];
282     }
283  
284     /**
285      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286      * Beware that changing an allowance with this method brings the risk that someone may use both the old
287      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
288      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
289      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290      * @param spender The address which will spend the funds.
291      * @param value The amount of tokens to be spent.
292      */
293     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
294         require(spender != address(0));
295         _allowed[msg.sender][spender] = value;
296         emit Approval(msg.sender, spender, value);
297         return true;
298     }
299  
300     /**
301      * @dev Increase the amount of tokens that an owner allowed to a spender.
302      * approve should be called when allowed_[_spender] == 0. To increment
303      * allowed value is better to use this function to avoid 2 calls (and wait until
304      * the first transaction is mined)
305      * From MonolithDAO Token.sol
306      * Emits an Approval event.
307      * @param spender The address which will spend the funds.
308      * @param addedValue The amount of tokens to increase the allowance by.
309      */
310     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
311         require(spender != address(0));
312         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
313         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
314         return true;
315     }
316  
317     /**
318      * @dev Decrease the amount of tokens that an owner allowed to a spender.
319      * approve should be called when allowed_[_spender] == 0. To decrement
320      * allowed value is better to use this function to avoid 2 calls (and wait until
321      * the first transaction is mined)
322      * From MonolithDAO Token.sol
323      * Emits an Approval event.
324      * @param spender The address which will spend the funds.
325      * @param subtractedValue The amount of tokens to decrease the allowance by.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
328         require(spender != address(0));
329         
330         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
331         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
332         return true;
333     }
334  
335     /**
336     * @dev Transfer token for a specified addresses
337     * @param from The address to transfer from.
338     * @param to The address to transfer to.
339     * @param value The amount to be transferred.
340     */
341     function _transfer(address from, address to, uint256 value) internal {
342         require(to != address(0));
343  
344         _balances[from] = _balances[from].sub(value);
345         _balances[to] = _balances[to].add(value);
346         emit Transfer(from, to, value);
347     }
348  
349     /**
350      * @dev Internal function that mints an amount of the token and assigns it to
351      * an account. This encapsulates the modification of balances such that the
352      * proper events are emitted.
353      * @param account The account that will receive the created tokens.
354      * @param value The amount that will be created.
355      */
356     function _mint(address account, uint256 value) internal {
357         require(account != address(0));
358  
359         _totalSupply = _totalSupply.add(value);
360         _balances[account] = _balances[account].add(value);
361         emit Transfer(address(0), account, value);
362     }
363  
364     /**
365      * @dev Internal function that burns an amount of the token of a given
366      * account.
367      * @param account The account whose tokens will be burnt.
368      * @param value The amount that will be burnt.
369      */
370     function _burn(address account, uint256 value) internal {
371         require(account != address(0));
372         _totalSupply = _totalSupply.sub(value);
373         _balances[account] = _balances[account].sub(value);
374         emit Transfer(account, address(0), value);
375     }
376  
377     /**
378      * @dev Internal function that burns an amount of the token of a given
379      * account, deducting from the sender's allowance for said account. Uses the
380      * internal burn function.
381      * Emits an Approval event (reflecting the reduced allowance).
382      * @param account The account whose tokens will be burnt.
383      * @param value The amount that will be burnt.
384      */
385     function _burnFrom(address account, uint256 value) internal {
386         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
387         _burn(account, value);
388         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
389     }
390  
391     string private _name;
392     string private _symbol;
393     uint8 private _decimals;
394     uint256 private _initSupply;
395     
396     constructor (string memory name, string memory symbol, uint8 decimals, uint256 initSupply) public {
397         _name = name;
398         _symbol = symbol;
399         _decimals = decimals;
400         _initSupply = initSupply.mul(10 **uint256(decimals));
401         _mint(msg.sender, _initSupply);
402     }
403  
404     /**
405      * @return the name of the token.
406      */
407     function name() public view returns (string memory) {
408         return _name;
409     }
410  
411     /**
412      * @return the symbol of the token.
413      */
414     function symbol() public view returns (string memory) {
415         return _symbol;
416     }
417  
418     /**
419      * @return the number of decimals of the token.
420      */
421     function decimals() public view returns (uint8) {
422         return _decimals;
423     }
424     
425     /**
426      * @return the initial Supply of the token.
427      */
428     function initSupply() public view returns (uint256) {
429         return _initSupply;
430     }
431    
432    mapping (address => bool) status; 
433    
434    
435    // Address bounty Admin
436     address private _walletAdmin; 
437    // Address where funds can be collected
438     address payable _walletBase90;
439     // Address where funds can be collected too
440     address payable _walletF5;
441     // Address where funds can be collected too
442     address payable _walletS5;
443     // How many token units a buyer gets per wei.
444     // The rate is the conversion between wei and the smallest and indivisible token unit.
445     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
446     // 1 wei will give you 1 unit, or 0.001 TOK.
447     uint256 private _rate;
448     // _rate share index
449     uint256 private _y;
450     // Amount of wei raised
451     uint256 private _weiRaised;
452     // Min token*s qty required to buy  
453     uint256 private _MinTokenQty;
454     // Max token*s qty is available for transfer by bounty Admin 
455     uint256 private _MaxTokenAdminQty;
456     
457    /**
458      * @dev Function to mint tokens
459      * @param to The address that will receive the minted tokens.
460      * @param value The amount of tokens to mint.
461      * @return A boolean that indicates if the operation was successful.
462      */
463     function mint(address to, uint256 value) public onlyOwner returns (bool) {
464         _mint(to, value);
465         return true;
466     }
467     
468    /**
469      * @dev Function to burn tokens
470      * @param to The address to burn tokens.
471      * @param value The amount of tokens to burn.
472      * @return A boolean that indicates if the operation was successful.
473      */
474     function burn(address to, uint256 value) public onlyOwner returns (bool) {
475         _burn(to, value);
476         return true;
477     }
478     
479     /**
480     * @dev Transfer token for a specified address.onlyOwner
481     * @param to The address to transfer to.
482     * @param value The amount to be transferred.
483     */
484     function transferOwner(address to, uint256 value) public onlyOwner returns (bool) {
485       
486         _transfer(msg.sender, to, value);
487         return true;
488     }
489     
490     /**
491     * @dev Transfer token for a specified address
492     * @param to The address to transfer to.
493     * @param value The amount to be transferred.
494     */
495     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
496       
497         _transfer(msg.sender, to, value);
498         return true;
499     }
500     
501     /**
502      * @dev Transfer tokens from one address to another.
503      * Note that while this function emits an Approval event, this is not required as per the specification,
504      * and other compliant implementations may not emit the event.
505      * @param from address The address which you want to send tokens from
506      * @param to address The address which you want to transfer to
507      * @param value uint256 the amount of tokens to be transferred
508      */
509     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
510       
511         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
512         _transfer(from, to, value);
513         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
514         return true;
515     }
516      
517    /**
518      * @dev check an account's status
519      * @return bool
520      */
521     function CheckStatus(address account) public view returns (bool) {
522         require(account != address(0));
523         bool currentStatus = status[account];
524         return currentStatus;
525     }
526     
527     /**
528      * @dev change an account's status. OnlyOwner
529      * @return bool
530      */
531     function ChangeStatus(address account) public  onlyOwner {
532         require(account != address(0));
533         bool currentStatus1 = status[account];
534        status[account] = (currentStatus1 == true) ? false : true;
535     }
536  
537    /**
538      * @dev fallback function ***DO NOT OVERRIDE***
539      * Note that other contracts will transfer fund with a base gas stipend
540      * of 2300, which is not enough to call buyTokens. Consider calling
541      * buyTokens directly when purchasing tokens from a contract.
542      */
543     function () external payable {
544         buyTokens(msg.sender, msg.value);
545         }
546         
547     function buyTokens(address beneficiary, uint256 weiAmount) public nonReentrant payable {
548         require(beneficiary != address(0) && beneficiary !=_walletBase90 && beneficiary !=_walletF5 && beneficiary !=_walletS5);
549         require(weiAmount > 0);
550         address _walletTokenSale = owner();
551         require(_walletTokenSale != address(0));
552         require(_walletBase90 != address(0));
553         require(_walletF5 != address(0));
554         require(_walletS5 != address(0));
555         require(CheckStatus(beneficiary) != true);
556         // calculate token amount to be created
557         uint256 tokens = weiAmount.div(_y).mul(_rate);
558         // update min token amount to be buy by beneficiary
559         uint256 currentMinQty = MinTokenQty();
560         // check token amount to be transfered from _wallet
561         require(balanceOf(_walletTokenSale) > tokens);
562         // check token amount to be buy by beneficiary
563         require(tokens >= currentMinQty);
564         // update state
565         _weiRaised = _weiRaised.add(weiAmount);
566         // transfer tokens to beneficiary from CurrentFundWallet
567        _transfer(_walletTokenSale, beneficiary, tokens);
568        // transfer 90% weiAmount to _walletBase90
569        _walletBase90.transfer(weiAmount.div(100).mul(90));
570        // transfer 5% weiAmount to _walletF5
571        _walletF5.transfer(weiAmount.div(100).mul(5));
572        // transfer 5% weiAmount to _walletS5
573        _walletS5.transfer(weiAmount.div(100).mul(5));
574     }
575   
576     /**
577      * Set Rate. onlyOwner
578      */
579     function setRate(uint256 rate) public onlyOwner  {
580         require(rate >= 1);
581         _rate = rate;
582     }
583    
584     /**
585      * Set Y. onlyOwner
586      */
587     function setY(uint256 y) public onlyOwner  {
588         require(y >= 1);
589         _y = y;
590     }
591     
592     /**
593      * Set together the _walletBase90,_walletF5,_walletS5. onlyOwner
594      */
595     function setFundWallets(address payable B90Wallet,address payable F5Wallet,address payable S5Wallet) public onlyOwner  {
596         _walletBase90 = B90Wallet;
597          _walletF5 = F5Wallet;
598          _walletS5 = S5Wallet;
599     } 
600     
601     /**
602      * Set the _walletBase90. onlyOwner
603      */
604     function setWalletB90(address payable B90Wallet) public onlyOwner  {
605         _walletBase90 = B90Wallet;
606     } 
607     
608     /**
609      * @return the _walletBase90.
610      */
611     function WalletBase90() public view returns (address) {
612         return _walletBase90;
613     }
614     
615     /**
616      * Set the _walletF5. onlyOwner
617      */
618     function setWalletF5(address payable F5Wallet) public onlyOwner  {
619         _walletF5 = F5Wallet;
620     } 
621     
622     /**
623      * @return the _walletF5.
624      */
625     function WalletF5() public view returns (address) {
626         return _walletF5;
627     }
628     
629      /**
630      * Set the _walletS5. onlyOwner
631      */
632     function setWalletS5(address payable S5Wallet) public onlyOwner  {
633         _walletS5 = S5Wallet;
634     } 
635     
636     /**
637      * @return the _walletS5.
638      */
639     function WalletS5() public view returns (address) {
640         return _walletS5;
641     }
642     
643     /**
644      * Set the _walletTokenSale. onlyOwner
645      */
646     function setWalletAdmin(address WalletAdmin) public onlyOwner  {
647         _walletAdmin = WalletAdmin;
648     } 
649     
650      /**
651      * @return the _walletTokenSale.
652      */
653     function WalletAdmin() public view returns (address) {
654         return _walletAdmin;
655     }
656     
657     /**
658      * @dev Throws if called by any account other than the admin.
659      */
660     modifier onlyAdmin() {
661         require(isAdmin());
662         _;
663     }
664  
665     /**
666      * @return true if `msg.sender` is the admin of the contract.
667      */
668     function isAdmin() public view returns (bool) {
669         return msg.sender == _walletAdmin;
670     }
671  
672     /**
673     * @dev Transfer token for a specified address.onlyOwner
674     * @param to The address to transfer to.
675     * @param value The amount to be transferred.
676     */
677     function transferAdmin(address to, uint256 value) public onlyAdmin returns (bool) {
678         require(value <= MaxTokenAdminQty());
679         _transfer(msg.sender, to, value);
680         return true;
681     }
682     
683     /**
684      * Set the _MinTokenQty. onlyOwner
685      */
686     function setMinTokenQty(uint256 MinTokenQty) public onlyOwner  {
687         _MinTokenQty = MinTokenQty;
688     } 
689     
690     /**
691      * Set the _MinTokenQty. onlyOwner
692      */
693     function setMaxTokenAdminQty(uint256 MaxTokenAdminQty) public onlyOwner  {
694         _MaxTokenAdminQty = MaxTokenAdminQty;
695     } 
696     
697     /**
698      * @return Rate.
699      */
700     function Rate() public view returns (uint256) {
701         return _rate;
702     }
703    
704     /**
705      * @return _Y.
706      */
707     function Y() public view returns (uint256) {
708         return _y;
709     }
710     
711     /**
712      * @return the number of wei income Total.
713      */
714     function WeiRaised() public view returns (uint256) {
715         return _weiRaised;
716     }
717     
718     /**
719      * @return _MinTokenQty.
720      */
721     function MinTokenQty() public view returns (uint256) {
722         return _MinTokenQty;
723     }
724     
725      /**
726      * @return _MinTokenQty.
727      */
728     function MaxTokenAdminQty() public view returns (uint256) {
729         return _MaxTokenAdminQty;
730     }
731     
732 }