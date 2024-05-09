1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address who) external view returns (uint256);
12 
13     function allowance(address owner, address spender) external view returns (uint256);
14 
15     function transfer(address to, uint256 value) external returns (bool);
16 
17     function approve(address spender, uint256 value) external returns (bool);
18 
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title ERC664Balances interface
28  * @dev see https://github.com/ethereum/EIPs/issues/644
29  */
30 interface IERC664Balances {
31     function getBalance(address _acct) external view returns(uint balance);
32 
33     function incBalance(address _acct, uint _val) external returns(bool success);
34 
35     function decBalance(address _acct, uint _val) external returns(bool success);
36 
37     function getAllowance(address _owner, address _spender) external view returns(uint remaining);
38 
39     function setApprove(address _sender, address _spender, uint256 _value) external returns(bool success);
40 
41     function decApprove(address _from, address _spender, uint _value) external returns(bool success);
42 
43     function getModule(address _acct) external view returns (bool success);
44 
45     function setModule(address _acct, bool _set) external returns(bool success);
46 
47     function getTotalSupply() external view returns(uint);
48 
49     function incTotalSupply(uint _val) external returns(bool success);
50 
51     function decTotalSupply(uint _val) external returns(bool success);
52 
53     function transferRoot(address _new) external returns(bool success);
54 
55     event BalanceAdj(address indexed Module, address indexed Account, uint Amount, string Polarity);
56 
57     event ModuleSet(address indexed Module, bool indexed Set);
58 }
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that revert on error
63  */
64 library SafeMath {
65     /**
66     * @dev Multiplies two numbers, reverts on overflow.
67     */
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70         // benefit is lost if 'b' is also tested.
71         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b);
78 
79         return c;
80     }
81 
82     /**
83     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
84     */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0);
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
96     */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b <= a);
99         uint256 c = a - b;
100 
101         return c;
102     }
103 
104     /**
105     * @dev Adds two numbers, reverts on overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a);
110 
111         return c;
112     }
113 
114     /**
115     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
116     * reverts when dividing by zero.
117     */
118     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b != 0);
120         return a % b;
121     }
122 }
123 
124 
125 /**
126  * @title Owned
127  * @author Adria Massanet <adria@codecontext.io>
128  * @notice The Owned contract has an owner address, and provides basic
129  *  authorization control functions, this simplifies & the implementation of
130  *  user permissions; this contract has three work flows for a change in
131  *  ownership, the first requires the new owner to validate that they have the
132  *  ability to accept ownership, the second allows the ownership to be
133  *  directly transferred without requiring acceptance, and the third allows for
134  *  the ownership to be removed to allow for decentralization
135  */
136 contract Owned {
137 
138     address public owner;
139     address public newOwnerCandidate;
140 
141     event OwnershipRequested(address indexed by, address indexed to);
142     event OwnershipTransferred(address indexed from, address indexed to);
143     event OwnershipRemoved();
144 
145     /**
146      * @dev The constructor sets the `msg.sender` as the`owner` of the contract
147      */
148     constructor() public {
149         owner = msg.sender;
150     }
151 
152     /**
153      * @dev `owner` is the only address that can call a function with this
154      * modifier
155      */
156     modifier onlyOwner() {
157         require(msg.sender == owner);
158         _;
159     }
160 
161     /**
162      * @dev In this 1st option for ownership transfer `proposeOwnership()` must
163      *  be called first by the current `owner` then `acceptOwnership()` must be
164      *  called by the `newOwnerCandidate`
165      * @notice `onlyOwner` Proposes to transfer control of the contract to a
166      *  new owner
167      * @param _newOwnerCandidate The address being proposed as the new owner
168      */
169     function proposeOwnership(address _newOwnerCandidate) external onlyOwner {
170         newOwnerCandidate = _newOwnerCandidate;
171         emit OwnershipRequested(msg.sender, newOwnerCandidate);
172     }
173 
174     /**
175      * @notice Can only be called by the `newOwnerCandidate`, accepts the
176      *  transfer of ownership
177      */
178     function acceptOwnership() external {
179         require(msg.sender == newOwnerCandidate);
180 
181         address oldOwner = owner;
182         owner = newOwnerCandidate;
183         newOwnerCandidate = 0x0;
184 
185         emit OwnershipTransferred(oldOwner, owner);
186     }
187 
188     /**
189      * @dev In this 2nd option for ownership transfer `changeOwnership()` can
190      *  be called and it will immediately assign ownership to the `newOwner`
191      * @notice `owner` can step down and assign some other address to this role
192      * @param _newOwner The address of the new owner
193      */
194     function changeOwnership(address _newOwner) external onlyOwner {
195         require(_newOwner != 0x0);
196 
197         address oldOwner = owner;
198         owner = _newOwner;
199         newOwnerCandidate = 0x0;
200 
201         emit OwnershipTransferred(oldOwner, owner);
202     }
203 
204     /**
205      * @dev In this 3rd option for ownership transfer `removeOwnership()` can
206      *  be called and it will immediately assign ownership to the 0x0 address;
207      *  it requires a 0xdece be input as a parameter to prevent accidental use
208      * @notice Decentralizes the contract, this operation cannot be undone
209      * @param _dac `0xdac` has to be entered for this function to work
210      */
211     function removeOwnership(address _dac) external onlyOwner {
212         require(_dac == 0xdac);
213         owner = 0x0;
214         newOwnerCandidate = 0x0;
215         emit OwnershipRemoved();
216     }
217 }
218 
219 /**
220  * @title Safe Guard Contract
221  * @author Panos
222  */
223 contract SafeGuard is Owned {
224 
225     event Transaction(address indexed destination, uint value, bytes data);
226 
227     /**
228      * @dev Allows owner to execute a transaction.
229      */
230     function executeTransaction(address destination, uint value, bytes data)
231     public
232     onlyOwner
233     {
234         require(externalCall(destination, value, data.length, data));
235         emit Transaction(destination, value, data);
236     }
237 
238     /**
239      * @dev call has been separated into its own function in order to take advantage
240      *  of the Solidity's code generator to produce a loop that copies tx.data into memory.
241      */
242     function externalCall(address destination, uint value, uint dataLength, bytes data)
243     private
244     returns (bool) {
245         bool result;
246         assembly { // solhint-disable-line no-inline-assembly
247             let x := mload(0x40)   // "Allocate" memory for output
248             // (0x40 is where "free memory" pointer is stored by convention)
249             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
250             result := call(
251             sub(gas, 34710), // 34710 is the value that solidity is currently emitting
252             // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
253             // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
254             destination,
255             value,
256             d,
257             dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
258             x,
259             0                  // Output is ignored, therefore the output size is zero
260             )
261         }
262         return result;
263     }
264 }
265 
266 /**
267  * @title ERC20Detailed token
268  * @dev The decimals are only for visualization purposes.
269  * All the operations are done using the smallest and indivisible token unit,
270  * just as on Ethereum all the operations are done in wei.
271  */
272 contract ERC20Detailed is IERC20 {
273     string private _name;
274     string private _symbol;
275     uint8 private _decimals;
276 
277     constructor (string name, string symbol, uint8 decimals) public {
278         _name = name;
279         _symbol = symbol;
280         _decimals = decimals;
281     }
282 
283     /**
284      * @return the name of the token.
285      */
286     function name() public view returns (string) {
287         return _name;
288     }
289 
290     /**
291      * @return the symbol of the token.
292      */
293     function symbol() public view returns (string) {
294         return _symbol;
295     }
296 
297     /**
298      * @return the number of decimals of the token.
299      */
300     function decimals() public view returns (uint8) {
301         return _decimals;
302     }
303 }
304 
305 /**
306  * @title Standard ERC20 token
307  *
308  * @dev Implementation of the basic standard token.
309  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
310  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
311  */
312 contract ERC20 is IERC20 {
313     using SafeMath for uint256;
314 
315     mapping (address => uint256) private _balances;
316 
317     mapping (address => mapping (address => uint256)) private _allowed;
318 
319     uint256 private _totalSupply;
320 
321     /**
322     * @dev Total number of tokens in existence
323     */
324     function totalSupply() public view returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329     * @dev Gets the balance of the specified address.
330     * @param owner The address to query the balance of.
331     * @return An uint256 representing the amount owned by the passed address.
332     */
333     function balanceOf(address owner) public view returns (uint256) {
334         return _balances[owner];
335     }
336 
337     /**
338      * @dev Function to check the amount of tokens that an owner allowed to a spender.
339      * @param owner address The address which owns the funds.
340      * @param spender address The address which will spend the funds.
341      * @return A uint256 specifying the amount of tokens still available for the spender.
342      */
343     function allowance(address owner, address spender) public view returns (uint256) {
344         return _allowed[owner][spender];
345     }
346 
347     /**
348     * @dev Transfer token for a specified address
349     * @param to The address to transfer to.
350     * @param value The amount to be transferred.
351     */
352     function transfer(address to, uint256 value) public returns (bool) {
353         _transfer(msg.sender, to, value);
354         return true;
355     }
356 
357     /**
358      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
359      * Beware that changing an allowance with this method brings the risk that someone may use both the old
360      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
361      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
362      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363      * @param spender The address which will spend the funds.
364      * @param value The amount of tokens to be spent.
365      */
366     function approve(address spender, uint256 value) public returns (bool) {
367         require(spender != address(0));
368 
369         _allowed[msg.sender][spender] = value;
370         emit Approval(msg.sender, spender, value);
371         return true;
372     }
373 
374     /**
375      * @dev Transfer tokens from one address to another
376      * @param from address The address which you want to send tokens from
377      * @param to address The address which you want to transfer to
378      * @param value uint256 the amount of tokens to be transferred
379      */
380     function transferFrom(address from, address to, uint256 value) public returns (bool) {
381         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
382         _transfer(from, to, value);
383         return true;
384     }
385 
386     /**
387      * @dev Increase the amount of tokens that an owner allowed to a spender.
388      * approve should be called when allowed_[_spender] == 0. To increment
389      * allowed value is better to use this function to avoid 2 calls (and wait until
390      * the first transaction is mined)
391      * From MonolithDAO Token.sol
392      * @param spender The address which will spend the funds.
393      * @param addedValue The amount of tokens to increase the allowance by.
394      */
395     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
396         require(spender != address(0));
397 
398         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
399         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
400         return true;
401     }
402 
403     /**
404      * @dev Decrease the amount of tokens that an owner allowed to a spender.
405      * approve should be called when allowed_[_spender] == 0. To decrement
406      * allowed value is better to use this function to avoid 2 calls (and wait until
407      * the first transaction is mined)
408      * From MonolithDAO Token.sol
409      * @param spender The address which will spend the funds.
410      * @param subtractedValue The amount of tokens to decrease the allowance by.
411      */
412     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
413         require(spender != address(0));
414 
415         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
416         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
417         return true;
418     }
419 
420     /**
421     * @dev Transfer token for a specified addresses
422     * @param from The address to transfer from.
423     * @param to The address to transfer to.
424     * @param value The amount to be transferred.
425     */
426     function _transfer(address from, address to, uint256 value) internal {
427         require(to != address(0));
428 
429         _balances[from] = _balances[from].sub(value);
430         _balances[to] = _balances[to].add(value);
431         emit Transfer(from, to, value);
432     }
433 
434     /**
435      * @dev Internal function that mints an amount of the token and assigns it to
436      * an account. This encapsulates the modification of balances such that the
437      * proper events are emitted.
438      * @param account The account that will receive the created tokens.
439      * @param value The amount that will be created.
440      */
441     function _mint(address account, uint256 value) internal {
442         require(account != address(0));
443 
444         _totalSupply = _totalSupply.add(value);
445         _balances[account] = _balances[account].add(value);
446         emit Transfer(address(0), account, value);
447     }
448 
449     /**
450      * @dev Internal function that burns an amount of the token of a given
451      * account.
452      * @param account The account whose tokens will be burnt.
453      * @param value The amount that will be burnt.
454      */
455     function _burn(address account, uint256 value) internal {
456         require(account != address(0));
457 
458         _totalSupply = _totalSupply.sub(value);
459         _balances[account] = _balances[account].sub(value);
460         emit Transfer(account, address(0), value);
461     }
462 
463     /**
464      * @dev Internal function that burns an amount of the token of a given
465      * account, deducting from the sender's allowance for said account. Uses the
466      * internal burn function.
467      * @param account The account whose tokens will be burnt.
468      * @param value The amount that will be burnt.
469      */
470     function _burnFrom(address account, uint256 value) internal {
471         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
472         // this function needs to emit an event with the updated approval.
473         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
474         _burn(account, value);
475     }
476 }
477 
478 
479 /**
480  * @title ERC664 Standard Balances Contract
481  * @author chrisfranko
482  */
483 contract ERC664Balances is IERC664Balances, SafeGuard {
484     using SafeMath for uint256;
485 
486     uint256 public totalSupply;
487 
488     event BalanceAdj(address indexed module, address indexed account, uint amount, string polarity);
489     event ModuleSet(address indexed module, bool indexed set);
490 
491     mapping(address => bool) public modules;
492     mapping(address => uint256) public balances;
493     mapping(address => mapping(address => uint256)) public allowed;
494 
495     modifier onlyModule() {
496         require(modules[msg.sender]);
497         _;
498     }
499 
500     /**
501      * @notice Constructor to create ERC664Balances
502      * @param _initialAmount Database initial amount
503      */
504     constructor(uint256 _initialAmount) public {
505         balances[msg.sender] = _initialAmount;
506         totalSupply = _initialAmount;
507         emit BalanceAdj(address(0), msg.sender, _initialAmount, "+");
508     }
509 
510     /**
511      * @notice Set allowance of `_spender` in behalf of `_sender` at `_value`
512      * @param _sender Owner account
513      * @param _spender Spender account
514      * @param _value Value to approve
515      * @return Operation status
516      */
517     function setApprove(address _sender, address _spender, uint256 _value) external onlyModule returns (bool) {
518         allowed[_sender][_spender] = _value;
519         return true;
520     }
521 
522     /**
523      * @notice Decrease allowance of `_spender` in behalf of `_from` at `_value`
524      * @param _from Owner account
525      * @param _spender Spender account
526      * @param _value Value to decrease
527      * @return Operation status
528      */
529     function decApprove(address _from, address _spender, uint _value) external onlyModule returns (bool) {
530         allowed[_from][_spender] = allowed[_from][_spender].sub(_value);
531         return true;
532     }
533 
534     /**
535     * @notice Increase total supply by `_val`
536     * @param _val Value to increase
537     * @return Operation status
538     */
539     function incTotalSupply(uint _val) external onlyOwner returns (bool) {
540         totalSupply = totalSupply.add(_val);
541         return true;
542     }
543 
544     /**
545      * @notice Decrease total supply by `_val`
546      * @param _val Value to decrease
547      * @return Operation status
548      */
549     function decTotalSupply(uint _val) external onlyOwner returns (bool) {
550         totalSupply = totalSupply.sub(_val);
551         return true;
552     }
553 
554     /**
555      * @notice Set/Unset `_acct` as an authorized module
556      * @param _acct Module address
557      * @param _set Module set status
558      * @return Operation status
559      */
560     function setModule(address _acct, bool _set) external onlyOwner returns (bool) {
561         modules[_acct] = _set;
562         emit ModuleSet(_acct, _set);
563         return true;
564     }
565 
566     /**
567      * @notice Change database owner
568      * @param _newOwner The new owner address
569      */
570     function transferRoot(address _newOwner) external onlyOwner returns(bool) {
571         owner = _newOwner;
572         return true;
573     }
574 
575     /**getBalance
576      * @notice Get `_acct` balance
577      * @param _acct Target account to get balance.
578      * @return The account balance
579      */
580     function getBalance(address _acct) external view returns (uint256) {
581         return balances[_acct];
582     }
583 
584     /**
585      * @notice Get allowance of `_spender` in behalf of `_owner`
586      * @param _owner Owner account
587      * @param _spender Spender account
588      * @return Allowance
589      */
590     function getAllowance(address _owner, address _spender) external view returns (uint256) {
591         return allowed[_owner][_spender];
592     }
593 
594     /**
595      * @notice Get if `_acct` is an authorized module
596      * @param _acct Module address
597      * @return Operation status
598      */
599     function getModule(address _acct) external view returns (bool) {
600         return modules[_acct];
601     }
602 
603     /**
604      * @notice Get total supply
605      * @return Total supply
606      */
607     function getTotalSupply() external view returns (uint256) {
608         return totalSupply;
609     }
610 
611     /**
612      * @notice Increment `_acct` balance by `_val`
613      * @param _acct Target account to increment balance.
614      * @param _val Value to increment
615      * @return Operation status
616      */
617     function incBalance(address _acct, uint _val) public onlyModule returns (bool) {
618         balances[_acct] = balances[_acct].add(_val);
619         emit BalanceAdj(msg.sender, _acct, _val, "+");
620         return true;
621     }
622 
623     /**
624      * @notice Decrement `_acct` balance by `_val`
625      * @param _acct Target account to decrement balance.
626      * @param _val Value to decrement
627      * @return Operation status
628      */
629     function decBalance(address _acct, uint _val) public onlyModule returns (bool) {
630         balances[_acct] = balances[_acct].sub(_val);
631         emit BalanceAdj(msg.sender, _acct, _val, "-");
632         return true;
633     }
634 }
635 
636 /**
637  * @title ERC664 Database Contract
638  * @author Panos
639  */
640 contract DStore is ERC664Balances {
641 
642     /**
643      * @notice Database construction
644      * @param _totalSupply The total supply of the token
645      */
646     constructor(uint256 _totalSupply) public
647     ERC664Balances(_totalSupply) {
648 
649     }
650 
651     /**
652      * @notice Increase total supply by `_val`
653      * @param _val Value to increase
654      * @return Operation status
655      */
656     // solhint-disable-next-line no-unused-vars
657     function incTotalSupply(uint _val) external onlyOwner returns (bool) {
658         return false;
659     }
660 
661     /**
662      * @notice Decrease total supply by `_val`
663      * @param _val Value to decrease
664      * @return Operation status
665      */
666     // solhint-disable-next-line no-unused-vars
667     function decTotalSupply(uint _val) external onlyOwner returns (bool) {
668         return false;
669     }
670 
671     /**
672      * @notice moving `_amount` from `_from` to `_to`
673      * @param _from The sender address
674      * @param _to The receiving address
675      * @param _amount The moving amount
676      * @return bool The move result
677      */
678     function move(address _from, address _to, uint256 _amount) external
679     onlyModule
680     returns (bool) {
681         balances[_from] = balances[_from].sub(_amount);
682         emit BalanceAdj(msg.sender, _from, _amount, "-");
683         balances[_to] = balances[_to].add(_amount);
684         emit BalanceAdj(msg.sender, _to, _amount, "+");
685         return true;
686     }
687 
688     /**
689      * @notice Increase allowance of `_spender` in behalf of `_from` at `_value`
690      * @param _from Owner account
691      * @param _spender Spender account
692      * @param _value Value to increase
693      * @return Operation status
694      */
695     function incApprove(address _from, address _spender, uint _value) external onlyModule returns (bool) {
696         allowed[_from][_spender] = allowed[_from][_spender].add(_value);
697         return true;
698     }
699 
700     /**
701      * @notice Increment `_acct` balance by `_val`
702      * @param _acct Target account to increment balance.
703      * @param _val Value to increment
704      * @return Operation status
705      */
706     // solhint-disable-next-line no-unused-vars
707     function incBalance(address _acct, uint _val) public
708     onlyModule
709     returns (bool) {
710         return false;
711     }
712 
713     /**
714      * @notice Decrement `_acct` balance by `_val`
715      * @param _acct Target account to decrement balance.
716      * @param _val Value to decrement
717      * @return Operation status
718      */
719     // solhint-disable-next-line no-unused-vars
720     function decBalance(address _acct, uint _val) public
721     onlyModule
722     returns (bool) {
723         return false;
724     }
725 }
726 
727 /**
728  * @title PreDeriveum
729  * @dev The Deriveum pre token.
730  *
731  */
732 contract PreDeriveum is ERC20, ERC20Detailed, SafeGuard {
733     uint256 public constant INITIAL_SUPPLY = 10000000000;
734     DStore public tokenDB;
735 
736     /**
737      * @dev Constructor that gives msg.sender all of existing tokens.
738      */
739     constructor () public ERC20Detailed("Pre-Deriveum", "PDER", 0) {
740         tokenDB = new DStore(INITIAL_SUPPLY);
741         require(tokenDB.setModule(address(this), true));
742         require(tokenDB.move(address(this), msg.sender, INITIAL_SUPPLY));
743         require(tokenDB.transferRoot(msg.sender));
744         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
745     }
746 
747     /**
748     * @dev Total number of tokens in existence
749     */
750     function totalSupply() public view returns (uint256) {
751         return tokenDB.getTotalSupply();
752     }
753 
754     /**
755     * @dev Gets the balance of the specified address.
756     * @param owner The address to query the balance of.
757     * @return An uint256 representing the amount owned by the passed address.
758     */
759     function balanceOf(address owner) public view returns (uint256) {
760         return tokenDB.getBalance(owner);
761     }
762 
763     /**
764      * @dev Function to check the amount of tokens that an owner allowed to a spender.
765      * @param owner address The address which owns the funds.
766      * @param spender address The address which will spend the funds.
767      * @return A uint256 specifying the amount of tokens still available for the spender.
768      */
769     function allowance(address owner, address spender) public view returns (uint256) {
770         return tokenDB.getAllowance(owner, spender);
771     }
772 
773     /**
774      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
775      * Beware that changing an allowance with this method brings the risk that someone may use both the old
776      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
777      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
778      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
779      * @param spender The address which will spend the funds.
780      * @param value The amount of tokens to be spent.
781      */
782     function approve(address spender, uint256 value) public returns (bool) {
783         require(spender != address(0));
784 
785         require(tokenDB.setApprove(msg.sender, spender, value));
786         emit Approval(msg.sender, spender, value);
787         return true;
788     }
789 
790     /**
791      * @dev Transfer tokens from one address to another
792      * @param from address The address which you want to send tokens from
793      * @param to address The address which you want to transfer to
794      * @param value uint256 the amount of tokens to be transferred
795      */
796     function transferFrom(address from, address to, uint256 value) public returns (bool) {
797         uint256 allow = tokenDB.getAllowance(from, msg.sender);
798         allow = allow.sub(value);
799         require(tokenDB.setApprove(from, msg.sender, allow));
800         _transfer(from, to, value);
801         return true;
802     }
803 
804     /**
805      * @dev Increase the amount of tokens that an owner allowed to a spender.
806      * approve should be called when allowed_[_spender] == 0. To increment
807      * allowed value is better to use this function to avoid 2 calls (and wait until
808      * the first transaction is mined)
809      * From MonolithDAO Token.sol
810      * @param spender The address which will spend the funds.
811      * @param addedValue The amount of tokens to increase the allowance by.
812      */
813     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
814         require(spender != address(0));
815 
816         uint256 allow = tokenDB.getAllowance(msg.sender, spender);
817         allow = allow.add(addedValue);
818         require(tokenDB.setApprove(msg.sender, spender, allow));
819         emit Approval(msg.sender, spender, allow);
820         return true;
821     }
822 
823     /**
824      * @dev Decrease the amount of tokens that an owner allowed to a spender.
825      * approve should be called when allowed_[_spender] == 0. To decrement
826      * allowed value is better to use this function to avoid 2 calls (and wait until
827      * the first transaction is mined)
828      * From MonolithDAO Token.sol
829      * @param spender The address which will spend the funds.
830      * @param subtractedValue The amount of tokens to decrease the allowance by.
831      */
832     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
833         require(spender != address(0));
834 
835         uint256 allow = tokenDB.getAllowance(msg.sender, spender);
836         allow = allow.sub(subtractedValue);
837         require(tokenDB.setApprove(msg.sender, spender, allow));
838         emit Approval(msg.sender, spender, allow);
839         return true;
840     }
841 
842     /**
843      * @dev Transfer token for a specified addresses
844      * @param from The address to transfer from.
845      * @param to The address to transfer to.
846      * @param value The amount to be transferred.
847      */
848     function _transfer(address from, address to, uint256 value) internal {
849         require(to != address(0));
850 
851         require(tokenDB.move(from, to, value));
852         emit Transfer(from, to, value);
853     }
854 }