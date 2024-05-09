1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title Operated
38  * @dev The Operated contract has a list of ops addresses, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Operated {
42     mapping(address => bool) private _ops;
43 
44     event OperatorChanged(
45         address indexed operator,
46         bool active
47     );
48 
49     /**
50      * @dev The Operated constructor sets the original ops account of the contract to the sender
51      * account.
52      */
53     constructor() internal {
54         _ops[msg.sender] = true;
55         emit OperatorChanged(msg.sender, true);
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the operations accounts.
60      */
61     modifier onlyOps() {
62         require(isOps(), "only operations accounts are allowed to call this function");
63         _;
64     }
65 
66     /**
67      * @return true if `msg.sender` is an operator.
68      */
69     function isOps() public view returns(bool) {
70         return _ops[msg.sender];
71     }
72 
73     /**
74      * @dev Allows the current operations accounts to give control of the contract to new accounts.
75      * @param _account The address of the new account
76      * @param _active Set active (true) or inactive (false)
77      */
78     function setOps(address _account, bool _active) public onlyOps {
79         _ops[_account] = _active;
80         emit OperatorChanged(_account, _active);
81     }
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90     address private _owner;
91 
92     event OwnershipTransferred(
93         address indexed previousOwner,
94         address indexed newOwner
95     );
96 
97     /**
98      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
99      * account.
100      */
101     constructor() internal {
102         _owner = msg.sender;
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     /**
107      * @return the address of the owner.
108      */
109     function owner() public view returns(address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(isOwner());
118         _;
119     }
120 
121     /**
122      * @return true if `msg.sender` is the owner of the contract.
123      */
124     function isOwner() public view returns(bool) {
125         return msg.sender == _owner;
126     }
127 
128     /**
129      * @dev Allows the current owner to relinquish control of the contract.
130      * @notice Renouncing to ownership will leave the contract without an owner.
131      * It will not be possible to call the functions with the `onlyOwner`
132      * modifier anymore.
133      */
134     function renounceOwnership() public onlyOwner {
135         emit OwnershipTransferred(_owner, address(0));
136         _owner = address(0);
137     }
138 
139     /**
140      * @dev Allows the current owner to transfer control of the contract to a newOwner.
141      * @param newOwner The address to transfer ownership to.
142      */
143     function transferOwnership(address newOwner) public onlyOwner {
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers control of the contract to a newOwner.
149      * @param newOwner The address to transfer ownership to.
150      */
151     function _transferOwnership(address newOwner) internal {
152         require(newOwner != address(0));
153         emit OwnershipTransferred(_owner, newOwner);
154         _owner = newOwner;
155     }
156 }
157 
158 /**
159  * @title SafeMath
160  * @dev Math operations with safety checks that revert on error
161  */
162 library SafeMath {
163 
164     /**
165     * @dev Multiplies two numbers, reverts on overflow.
166     */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169         // benefit is lost if 'b' is also tested.
170         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b);
177 
178         return c;
179     }
180 
181     /**
182     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
183     */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b > 0); // Solidity only automatically asserts when dividing by 0
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188 
189         return c;
190     }
191 
192     /**
193     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
194     */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a);
197         uint256 c = a - b;
198 
199         return c;
200     }
201 
202     /**
203     * @dev Adds two numbers, reverts on overflow.
204     */
205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
206         uint256 c = a + b;
207         require(c >= a);
208 
209         return c;
210     }
211 
212     /**
213     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
214     * reverts when dividing by zero.
215     */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         require(b != 0);
218         return a % b;
219     }
220 }
221 
222 /**
223  * @title WHISKY TOKEN
224  * @author WHYTOKEN GmbH
225  * @notice WHISKY TOKEN (WHY) stands for a disruptive new possibility in the crypto currency market
226  * due to the combination of High-End Whisky and Blockchain technology.
227  * WHY is a german based token, which lets everyone participate in the lucrative crypto market
228  * with minimal risk and effort through a high-end whisky portfolio as security.
229  */
230 contract WhiskyToken is IERC20, Ownable, Operated {
231     using SafeMath for uint256;
232     using SafeMath for uint64;
233 
234     // ERC20 standard variables
235     string public name = "Whisky Token";
236     string public symbol = "WHY";
237     uint8 public decimals = 18;
238     uint256 public initialSupply = 28100000 * (10 ** uint256(decimals));
239     uint256 public totalSupply;
240 
241     // Address of the ICO contract
242     address public crowdSaleContract;
243 
244     // The asset value of the whisky in EUR cents
245     uint64 public assetValue;
246 
247     // Fee to charge on every transfer (e.g. 15 is 1,5%)
248     uint64 public feeCharge;
249 
250     // Global freeze of all transfers
251     bool public freezeTransfer;
252 
253     // Flag to make all token available
254     bool private tokenAvailable;
255 
256     // Maximum value for feeCharge
257     uint64 private constant feeChargeMax = 20;
258 
259     // Address of the account/wallet which should receive the fees
260     address private feeReceiver;
261 
262     // Mappings of addresses for balances, allowances and frozen accounts
263     mapping(address => uint256) internal balances;
264     mapping(address => mapping (address => uint256)) internal allowed;
265     mapping(address => bool) public frozenAccount;
266 
267     // Event definitions
268     event Fee(address indexed payer, uint256 fee);
269     event FeeCharge(uint64 oldValue, uint64 newValue);
270     event AssetValue(uint64 oldValue, uint64 newValue);
271     event Burn(address indexed burner, uint256 value);
272     event FrozenFunds(address indexed target, bool frozen);
273     event FreezeTransfer(bool frozen);
274 
275     // Constructor which gets called once on contract deployment
276     constructor(address _tokenOwner) public {
277         transferOwnership(_tokenOwner);
278         setOps(_tokenOwner, true);
279         crowdSaleContract = msg.sender;
280         feeReceiver = _tokenOwner;
281         totalSupply = initialSupply;
282         balances[msg.sender] = initialSupply;
283         assetValue = 0;
284         feeCharge = 15;
285         freezeTransfer = true;
286         tokenAvailable = true;
287     }
288 
289     /**
290      * @notice Returns the total supply of tokens.
291      * @dev The total supply is the amount of tokens which are currently in circulation.
292      * @return Amount of tokens in Sip.
293      */
294     function totalSupply() public view returns (uint256) {
295         return totalSupply;
296     }
297 
298     /**
299      * @notice Gets the balance of the specified address.
300      * @dev Gets the balance of the specified address.
301      * @param _owner The address to query the the balance of.
302      * @return An uint256 representing the amount of tokens owned by the passed address.
303      */
304     function balanceOf(address _owner) public view returns (uint256 balance) {
305         if (!tokenAvailable) {
306             return 0;
307         }
308         return balances[_owner];
309     }
310 
311     /**
312      * @dev Internal transfer, can only be called by this contract.
313      * Will throw an exception to rollback the transaction if anything is wrong.
314      * @param _from The address from which the tokens should be transfered from.
315      * @param _to The address to which the tokens should be transfered to.
316      * @param _value The amount of tokens which should be transfered in Sip.
317      */
318     function _transfer(address _from, address _to, uint256 _value) internal {
319         require(_to != address(0), "zero address is not allowed");
320         require(_value >= 1000, "must transfer more than 1000 sip");
321         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
322         require(!frozenAccount[_from], "sender address is frozen");
323         require(!frozenAccount[_to], "receiver address is frozen");
324 
325         uint256 transferValue = _value;
326         if (msg.sender != owner() && msg.sender != crowdSaleContract) {
327             uint256 fee = _value.div(1000).mul(feeCharge);
328             transferValue = _value.sub(fee);
329             balances[feeReceiver] = balances[feeReceiver].add(fee);
330             emit Fee(msg.sender, fee);
331             emit Transfer(_from, feeReceiver, fee);
332         }
333 
334         // SafeMath.sub will throw if there is not enough balance.
335         balances[_from] = balances[_from].sub(_value);
336         balances[_to] = balances[_to].add(transferValue);
337         if (tokenAvailable) {
338             emit Transfer(_from, _to, transferValue);
339         }
340     }
341 
342     /**
343      * @notice Transfer tokens to a specified address. The message sender has to pay the fee.
344      * @dev Calls _transfer with message sender address as _from parameter.
345      * @param _to The address to transfer to.
346      * @param _value The amount to be transferred in Sip.
347      * @return Indicates if the transfer was successful.
348      */
349     function transfer(address _to, uint256 _value) public returns (bool) {
350         _transfer(msg.sender, _to, _value);
351         return true;
352     }
353 
354     /**
355      * @notice Transfer tokens from one address to another. The message sender has to pay the fee.
356      * @dev Calls _transfer with the addresses provided by the transactor.
357      * @param _from The address which you want to send tokens from.
358      * @param _to The address which you want to transfer to.
359      * @param _value The amount of tokens to be transferred in Sip.
360      * @return Indicates if the transfer was successful.
361      */
362     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
363         require(_value <= allowed[_from][msg.sender], "requesting more token than allowed");
364 
365         _transfer(_from, _to, _value);
366         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
367         return true;
368     }
369 
370     /**
371      * @notice Approve the passed address to spend the specified amount of tokens on behalf of the transactor.
372      * @dev Beware that changing an allowance with this method brings the risk that someone may use both the old
373      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
374      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
375      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
376      * @param _spender The address which is allowed to retrieve the tokens.
377      * @param _value The amount of tokens to be spent in Sip.
378      * @return Indicates if the approval was successful.
379      */
380     function approve(address _spender, uint256 _value) public returns (bool) {
381         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
382         require(_spender != address(0), "zero address is not allowed");
383         require(_value >= 1000, "must approve more than 1000 sip");
384 
385         allowed[msg.sender][_spender] = _value;
386         emit Approval(msg.sender, _spender, _value);
387         return true;
388     }
389 
390     /**
391      * @notice Returns the amount of tokens that the owner allowed to the spender.
392      * @dev Function to check the amount of tokens that an owner allowed to a spender.
393      * @param _owner The address which owns the tokens.
394      * @param _spender The address which is allowed to retrieve the tokens.
395      * @return The amount of tokens still available for the spender in Sip.
396      */
397     function allowance(address _owner, address _spender) public view returns (uint256) {
398         return allowed[_owner][_spender];
399     }
400 
401     /**
402      * @notice Increase the amount of tokens that an owner allowed to a spender.
403      * @dev Approve should be called when allowed[_spender] == 0. To increment
404      * allowed value is better to use this function to avoid 2 calls (and wait until
405      * the first transaction is mined)
406      * From MonolithDAO Token.sol
407      * @param _spender The address which is allowed to retrieve the tokens.
408      * @param _addedValue The amount of tokens to increase the allowance by in Sip.
409      * @return Indicates if the approval was successful.
410      */
411     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
412         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
413         require(_spender != address(0), "zero address is not allowed");
414         require(_addedValue >= 1000, "must approve more than 1000 sip");
415         
416         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
417         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
418         return true;
419     }
420 
421     /**
422      * @notice Decrease the amount of tokens that an owner allowed to a spender. 
423      * @dev Approve should be called when allowed[_spender] == 0. To decrement
424      * allowed value is better to use this function to avoid 2 calls (and wait until
425      * the first transaction is mined)
426      * From MonolithDAO Token.sol
427      * @param _spender The address which is allowed to retrieve the tokens.
428      * @param _subtractedValue The amount of tokens to decrease the allowance by in Sip.
429      * @return Indicates if the approval was successful.
430      */
431     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
432         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
433         require(_spender != address(0), "zero address is not allowed");
434         require(_subtractedValue >= 1000, "must approve more than 1000 sip");
435 
436         uint256 oldValue = allowed[msg.sender][_spender];
437         if (_subtractedValue > oldValue) {
438             allowed[msg.sender][_spender] = 0;
439         } else {
440             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
441         }
442         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
443         return true;
444     } 
445 
446     /**
447      * @notice Burns a specific amount of tokens.
448      * @dev Tokens get technically destroyed by this function and are therefore no longer in circulation afterwards.
449      * @param _value The amount of token to be burned in Sip.
450      */
451     function burn(uint256 _value) public {
452         require(!freezeTransfer || isOps(), "all transfers are currently frozen");
453         require(_value <= balances[msg.sender], "address has not enough token to burn");
454         address burner = msg.sender;
455         balances[burner] = balances[burner].sub(_value);
456         totalSupply = totalSupply.sub(_value);
457         emit Burn(burner, _value);
458         emit Transfer(burner, address(0), _value);
459     }
460 
461     /**
462      * @notice Not for public use!
463      * @dev Modifies the assetValue which represents the monetized value (in EUR) of the whisky baking the token.
464      * @param _value The new value of the asset in EUR cents.
465      */
466     function setAssetValue(uint64 _value) public onlyOwner {
467         uint64 oldValue = assetValue;
468         assetValue = _value;
469         emit AssetValue(oldValue, _value);
470     }
471 
472     /**
473      * @notice Not for public use!
474      * @dev Modifies the feeCharge which calculates the fee for each transaction.
475      * @param _value The new value of the feeCharge as fraction of 1000 (e.g. 15 is 1,5%).
476      */
477     function setFeeCharge(uint64 _value) public onlyOwner {
478         require(_value <= feeChargeMax, "can not increase fee charge over it's limit");
479         uint64 oldValue = feeCharge;
480         feeCharge = _value;
481         emit FeeCharge(oldValue, _value);
482     }
483 
484 
485     /**
486      * @notice Not for public use!
487      * @dev Prevents/Allows target from sending & receiving tokens.
488      * @param _target Address to be frozen.
489      * @param _freeze Either to freeze or unfreeze it.
490      */
491     function freezeAccount(address _target, bool _freeze) public onlyOwner {
492         require(_target != address(0), "zero address is not allowed");
493 
494         frozenAccount[_target] = _freeze;
495         emit FrozenFunds(_target, _freeze);
496     }
497 
498     /**
499      * @notice Not for public use!
500      * @dev Globally freeze all transfers for the token.
501      * @param _freeze Freeze or unfreeze every transfer.
502      */
503     function setFreezeTransfer(bool _freeze) public onlyOwner {
504         freezeTransfer = _freeze;
505         emit FreezeTransfer(_freeze);
506     }
507 
508     /**
509      * @notice Not for public use!
510      * @dev Allows the owner to set the address which receives the fees.
511      * @param _feeReceiver the address which should receive fees.
512      */
513     function setFeeReceiver(address _feeReceiver) public onlyOwner {
514         require(_feeReceiver != address(0), "zero address is not allowed");
515         feeReceiver = _feeReceiver;
516     }
517 
518     /**
519      * @notice Not for public use!
520      * @dev Make all tokens available for ERC20 wallets.
521      * @param _available Activate or deactivate all tokens
522      */
523     function setTokenAvailable(bool _available) public onlyOwner {
524         tokenAvailable = _available;
525     }
526 }
527 
528 /**
529  * @title WHISKY TOKEN ICO
530  * @author WHYTOKEN GmbH
531  * @notice WHISKY TOKEN (WHY) stands for a disruptive new possibility in the crypto currency market
532  * due to the combination of High-End Whisky and Blockchain technology.
533  * WHY is a german based token, which lets everyone participate in the lucrative crypto market
534  * with minimal risk and effort through a high-end whisky portfolio as security.
535  */
536 contract WhiskyTokenCrowdsale is Ownable, Operated {
537     using SafeMath for uint256;
538     using SafeMath for uint64;
539 
540     // Address of the beneficiary which will receive the raised ETH 
541     // Initialized during deployment
542     address public beneficiary;
543 
544     // Deadline of the ICO as epoch time
545     // Initialized when entering the first phase
546     uint256 public deadline;
547 
548     // Amount raised by the ICO in Ether
549     // Initialized during deployment
550     uint256 public amountRaisedETH;
551 
552     // Amount raised by the ICO in Euro
553     // Initialized during deployment
554     uint256 public amountRaisedEUR;
555 
556     // Amount of tokens sold in Sip
557     // Initialized during deployment
558     uint256 public tokenSold;
559 
560     // Indicator if the funding goal has been reached
561     // Initialized during deployment
562     bool public fundingGoalReached;
563 
564     // Indicator if the ICO already closed
565     // Initialized during deployment
566     bool public crowdsaleClosed;
567 
568     // Internal indicator if we have checked our goals at the end of the ICO
569     // Initialized during deployment
570     bool private goalChecked;
571 
572     // Instance of our deployed Whisky Token
573     // Initialized during deployment
574     WhiskyToken public tokenReward;
575 
576     // Instance of the FIAT contract we use for ETH/EUR conversion
577     // Initialized during deployment
578     FiatContract public fiat;
579 
580     // Amount of Euro cents we need to reach for the softcap
581     // 2.000.000 EUR
582     uint256 private minTokenSellInEuroCents = 200000000;
583 
584     // Minimum amount of Euro cents you need to pay per transaction
585     // 30 EUR    
586     uint256 private minTokenBuyEuroCents = 3000;
587 
588     // Minimum amount of tokens (in Sip) which are sold at the softcap
589     // 2.583.333 token
590     uint256 private minTokenSell = 2583333 * 1 ether;
591 
592     // Maximum amount of tokens (in Sip) which are sold at the hardcap
593     // 25.250.000 tokens
594     uint256 private maxTokenSell = 25250000 * 1 ether;
595 
596     // Minimum amount of tokens (in Sip) which the beneficiary will receive
597     // for the founders at the softcap
598     // 308.627 tokens
599     uint256 private minFounderToken = 308627 * 1 ether;
600 
601     // Maximum amount of tokens (in Sip) which the beneficiary will receive
602     // for the founders at the hardcap
603     // 1.405.000 tokens
604     uint256 private maxFounderToken = 1405000 * 1 ether;
605 
606     // Minimum amount of tokens (in Sip) which the beneficiary will receive
607     // for Research & Development and the Advisors after the ICO
608     // 154.313 tokens
609     uint256 private minRDAToken = 154313 * 1 ether;
610 
611     // Maximum amount of tokens (in Sip) which the beneficiary will receive
612     // for Research & Development and the Advisors after the ICO
613     // 1.405.000 tokens
614     uint256 private maxRDAToken = 1405000 * 1 ether;
615 
616     // Amount of tokens (in Sip) which a customer will receive as bounty
617     // 5 tokens
618     uint256 private bountyTokenPerPerson = 5 * 1 ether;
619 
620     // Maximum amount of tokens (in Sip) which are available for bounty
621     // 40.000 tokens
622     uint256 private maxBountyToken = 40000 * 1 ether;
623 
624     // Amount of tokens which are left for bounty
625     // Initialized during deployment
626     uint256 public tokenLeftForBounty;
627 
628     // The pre-sale phase of the ICO
629     // 333.333 tokens for 60 cent/token
630     Phase private preSalePhase = Phase({
631         id: PhaseID.PreSale,
632         tokenPrice: 60,
633         tokenForSale: 333333 * 1 ether,
634         tokenLeft: 333333 * 1 ether
635     });
636 
637     // The first public sale phase of the ICO
638     // 2.250.000 tokens for 80 cent/token
639     Phase private firstPhase = Phase({
640         id: PhaseID.First,
641         tokenPrice: 80,
642         tokenForSale: 2250000 * 1 ether,
643         tokenLeft: 2250000 * 1 ether
644     });
645 
646     // The second public sale phase of the ICO
647     // 21.000.000 tokens for 100 cent/token
648     Phase private secondPhase = Phase({
649         id: PhaseID.Second,
650         tokenPrice: 100,
651         tokenForSale: 21000000 * 1 ether,
652         tokenLeft: 21000000 * 1 ether
653     });
654 
655     // The third public sale phase of the ICO
656     // 1.666.667 tokens for 120 cent/token
657     Phase private thirdPhase = Phase({
658         id: PhaseID.Third,
659         tokenPrice: 120,
660         tokenForSale: 1666667 * 1 ether,
661         tokenLeft: 1666667 * 1 ether
662     });
663 
664     // The closed phase of the ICO
665     // No token for sell
666     Phase private closedPhase = Phase({
667         id: PhaseID.Closed,
668         tokenPrice: ~uint64(0),
669         tokenForSale: 0,
670         tokenLeft: 0
671     });
672 
673     // Points to the current phase
674     Phase public currentPhase;
675 
676     // Structure for the phases
677     // Consists of an id, the tokenPrice and the amount
678     // of tokens available and left for sale
679     struct Phase {
680         PhaseID id;
681         uint64 tokenPrice;
682         uint256 tokenForSale;
683         uint256 tokenLeft;
684     }
685 
686     // Enumeration for identification of the phases
687     enum PhaseID {
688         PreSale,        // 0 
689         First,          // 1
690         Second,         // 2
691         Third,          // 3
692         Closed          // 4
693     }    
694 
695     // Mapping of an address to a customer
696     mapping(address => Customer) public customer;
697 
698     // Structure representing a customer
699     // Consists of a rating, the amount of Ether and Euro the customer raised,
700     // and a boolean indicating if he/she has already received a bounty
701     struct Customer {
702         Rating rating;
703         uint256 amountRaisedEther;
704         uint256 amountRaisedEuro;
705         uint256 amountReceivedWhiskyToken;
706         bool hasReceivedBounty;
707     }
708 
709     // Enumeration for identification of a rating for a customer
710     enum Rating {
711         Unlisted,       // 0: No known customer, can't buy any token
712         Whitelisted     // 1: Known customer by personal data, allowed to buy token
713     }
714 
715     // Event definitions
716     event SaleClosed();
717     event GoalReached(address recipient, uint256 tokensSold, uint256 totalAmountRaised);
718     event WhitelistUpdated(address indexed _account, uint8 _phase);
719     event PhaseEntered(PhaseID phaseID);
720     event TokenSold(address indexed customer, uint256 amount);
721     event BountyTransfer(address indexed customer, uint256 amount);
722     event FounderTokenTransfer(address recipient, uint256 amount);
723     event RDATokenTransfer(address recipient, uint256 amount);
724     event FundsWithdrawal(address indexed recipient, uint256 amount);
725 
726     // Constructor which gets called once on contract deployment
727     constructor() public {
728         setOps(msg.sender, true);
729         beneficiary = msg.sender;
730         tokenReward = new WhiskyToken(msg.sender);
731         fiat = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // Main
732         currentPhase = preSalePhase;
733         fundingGoalReached = false;
734         crowdsaleClosed = false;
735         goalChecked = false;
736         tokenLeftForBounty = maxBountyToken;
737         tokenReward.transfer(msg.sender, currentPhase.tokenForSale);
738         currentPhase.tokenLeft = 0;
739         tokenSold += currentPhase.tokenForSale;
740         amountRaisedEUR = amountRaisedEUR.add((currentPhase.tokenForSale.div(1 ether)).mul(currentPhase.tokenPrice));
741     }
742 
743     /**
744      * @notice Not for public use!
745      * @dev Advances the crowdsale to the next phase.
746      */
747     function nextPhase() public onlyOwner {
748         require(currentPhase.id != PhaseID.Closed, "already reached the closed phase");
749 
750         uint8 nextPhaseNum = uint8(currentPhase.id) + 1;
751 
752         if (PhaseID(nextPhaseNum) == PhaseID.First) {
753             currentPhase = firstPhase;
754             deadline = now + 365 * 1 days;
755         }
756         if (PhaseID(nextPhaseNum) == PhaseID.Second) {
757             currentPhase = secondPhase;
758         }
759         if (PhaseID(nextPhaseNum) == PhaseID.Third) {
760             currentPhase = thirdPhase;
761         }
762         if (PhaseID(nextPhaseNum) == PhaseID.Closed) {
763             currentPhase = closedPhase;
764         }
765 
766         emit PhaseEntered(currentPhase.id);
767     }
768 
769     /**
770      * @notice Not for public use!
771      * @dev Set the rating of a customer by address.
772      * @param _account The address of the customer you want to change the rating of.
773      * @param _phase The rating as an uint:
774      * 0 => Unlisted
775      * 1 => Whitelisted
776      */
777     function updateWhitelist(address _account, uint8 _phase) external onlyOps returns (bool) {
778         require(_account != address(0), "zero address is not allowed");
779         require(_phase == uint8(Rating.Unlisted) || _phase == uint8(Rating.Whitelisted), "invalid rating");
780 
781         Rating rating = Rating(_phase);
782         customer[_account].rating = rating;
783         emit WhitelistUpdated(_account, _phase);
784 
785         if (rating > Rating.Unlisted && !customer[_account].hasReceivedBounty && tokenLeftForBounty > 0) {
786             customer[_account].hasReceivedBounty = true;
787             customer[_account].amountReceivedWhiskyToken = customer[_account].amountReceivedWhiskyToken.add(bountyTokenPerPerson);
788             tokenLeftForBounty = tokenLeftForBounty.sub(bountyTokenPerPerson);
789             require(tokenReward.transfer(_account, bountyTokenPerPerson), "token transfer failed");
790             emit BountyTransfer(_account, bountyTokenPerPerson);
791         }
792 
793         return true;
794     }
795 
796     /**
797      * @dev Checks if the deadline is reached or the crowdsale has been closed.
798      */
799     modifier afterDeadline() {
800         if ((now >= deadline && currentPhase.id >= PhaseID.First) || currentPhase.id == PhaseID.Closed) {
801             _;
802         }
803     }
804 
805     /**
806      * @notice Check if the funding goal was reached.
807      * Can only be called after the deadline or if the crowdsale has been closed.
808      * @dev Checks if the goal or time limit has been reached and ends the campaign.
809      * Should be directly called after the ICO.
810      */
811     function checkGoalReached() public afterDeadline {
812         if (!goalChecked) {
813             if (_checkFundingGoalReached()) {
814                 emit GoalReached(beneficiary, tokenSold, amountRaisedETH);
815             }
816             if (!crowdsaleClosed) {
817                 crowdsaleClosed = true;
818                 emit SaleClosed();
819             }
820             goalChecked = true;
821         }
822     }
823 
824     /**
825      * @dev Internal function for checking if we reached our funding goal.
826      * @return Indicates if the funding goal has been reached.
827      */
828     function _checkFundingGoalReached() internal returns (bool) {
829         if (!fundingGoalReached) {
830             if (amountRaisedEUR >= minTokenSellInEuroCents) {
831                 fundingGoalReached = true;
832             }
833         }
834         return fundingGoalReached;
835     }
836 
837     /**
838      * @dev Fallback function
839      * The function without name is the default function that is called whenever anyone sends funds to a contract
840      */
841     function () external payable {
842         _buyToken(msg.sender);
843     }
844 
845     /**
846      * @notice Buy tokens for ether. You can also just send ether to the contract to buy tokens.
847      * Your address needs to be whitelisted first.
848      * @dev Allows the caller to buy token for his address.
849      * Implemented for the case that other contracts want to buy tokens.
850      */
851     function buyToken() external payable {
852         _buyToken(msg.sender);
853     }
854 
855     /**
856      * @notice Buy tokens for another address. The address still needs to be whitelisted.
857      * @dev Allows the caller to buy token for a different address.
858      * @param _receiver Address of the person who should receive the tokens.
859      */
860     function buyTokenForAddress(address _receiver) external payable {
861         require(_receiver != address(0), "zero address is not allowed");
862         _buyToken(_receiver);
863     }
864 
865     /**
866      * @notice Not for public use!
867      * @dev Send tokens to receiver who has payed with FIAT or other currencies.
868      * @param _receiver Address of the person who should receive the tokens.
869      * @param _cent The amount of euro cents which the person has payed.
870      */
871     function buyTokenForAddressWithEuroCent(address _receiver, uint64 _cent) external onlyOps {
872         require(!crowdsaleClosed, "crowdsale is closed");
873         require(_receiver != address(0), "zero address is not allowed");
874         require(currentPhase.id != PhaseID.PreSale, "not allowed to buy token in presale phase");
875         require(currentPhase.id != PhaseID.Closed, "not allowed to buy token in closed phase");
876         require(customer[_receiver].rating == Rating.Whitelisted, "address is not whitelisted");
877         _sendTokenReward(_receiver, _cent);        
878         _checkFundingGoalReached();
879     }
880 
881     /**
882      * @dev Internal function for buying token.
883      * @param _receiver Address of the person who should receive the tokens.
884      */
885     function _buyToken(address _receiver) internal {
886         require(!crowdsaleClosed, "crowdsale is closed");
887         require(currentPhase.id != PhaseID.PreSale, "not allowed to buy token in presale phase");
888         require(currentPhase.id != PhaseID.Closed, "not allowed to buy token in closed phase");
889         require(customer[_receiver].rating == Rating.Whitelisted, "address is not whitelisted");
890         _sendTokenReward(_receiver, 0);
891         _checkFundingGoalReached();
892     }
893 
894     /**
895      * @dev Internal function for sending token as reward for ether.
896      * @param _receiver Address of the person who should receive the tokens.
897      */
898     function _sendTokenReward(address _receiver, uint64 _cent) internal {
899         // Remember the ETH amount of the message sender, not the token receiver!
900         // We need this because if the softcap was not reached
901         // the message sender should be able to retrive his ETH
902         uint256 amountEuroCents;
903         uint256 tokenAmount;
904         if (msg.value > 0) {
905             uint256 amount = msg.value;
906             customer[msg.sender].amountRaisedEther = customer[msg.sender].amountRaisedEther.add(amount);
907             amountRaisedETH = amountRaisedETH.add(amount);
908             amountEuroCents = amount.div(fiat.EUR(0));
909             tokenAmount = (amount.div(getTokenPrice())) * 1 ether;
910         } else if (_cent > 0) {
911             amountEuroCents = _cent;
912             tokenAmount = (amountEuroCents.div(currentPhase.tokenPrice)) * 1 ether;
913         } else {
914             revert("this should never happen");
915         }
916         
917         uint256 sumAmountEuroCents = customer[_receiver].amountRaisedEuro.add(amountEuroCents);
918         customer[_receiver].amountRaisedEuro = sumAmountEuroCents;
919         amountRaisedEUR = amountRaisedEUR.add(amountEuroCents);
920 
921         require(((tokenAmount / 1 ether) * currentPhase.tokenPrice) >= minTokenBuyEuroCents, "must buy token for at least 30 EUR");
922         require(tokenAmount <= currentPhase.tokenLeft, "not enough token left in current phase");
923         currentPhase.tokenLeft = currentPhase.tokenLeft.sub(tokenAmount);
924 
925         customer[_receiver].amountReceivedWhiskyToken = customer[_receiver].amountReceivedWhiskyToken.add(tokenAmount);
926         tokenSold = tokenSold.add(tokenAmount);
927         require(tokenReward.transfer(_receiver, tokenAmount), "token transfer failed");
928         emit TokenSold(_receiver, tokenAmount);
929     }
930 
931     /**
932      * @notice Withdraw your funds if the ICO softcap has not been reached.
933      * @dev Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
934      * sends the entire ether amount to the beneficiary.
935      * Also caluclates and sends the tokens for the founders, research & development and advisors.
936      * All tokens which were not sold or send will be burned at the end.
937      * If goal was not reached, each contributor can withdraw the amount they contributed.
938      */
939     function safeWithdrawal() public afterDeadline {
940         require(crowdsaleClosed, "crowdsale must be closed");
941         
942         if (!fundingGoalReached) {
943             // Let customers retrieve their ether
944             require(customer[msg.sender].amountRaisedEther > 0, "message sender has not raised any ether to this contract");
945             uint256 amount = customer[msg.sender].amountRaisedEther;
946             customer[msg.sender].amountRaisedEther = 0;
947             msg.sender.transfer(amount);
948             emit FundsWithdrawal(msg.sender, amount);
949         } else {
950             // Let owner retrive current ether amount and founder token
951             require(beneficiary == msg.sender, "message sender is not the beneficiary");
952             uint256 ethAmount = address(this).balance;
953             beneficiary.transfer(ethAmount);
954             emit FundsWithdrawal(beneficiary, ethAmount);
955 
956             // Calculate and transfer founder token
957             uint256 founderToken = (tokenSold - minTokenSell) * (maxFounderToken - minFounderToken) / (maxTokenSell - minTokenSell) + minFounderToken - (maxBountyToken - tokenLeftForBounty);
958             require(tokenReward.transfer(beneficiary, founderToken), "founder token transfer failed");
959             emit FounderTokenTransfer(beneficiary, founderToken);
960 
961             // Calculate and transfer research and advisor token
962             uint256 rdaToken = (tokenSold - minTokenSell) * (maxRDAToken - minRDAToken) / (maxTokenSell - minTokenSell) + minRDAToken;
963             require(tokenReward.transfer(beneficiary, rdaToken), "RDA token transfer failed");
964             emit RDATokenTransfer(beneficiary, rdaToken);
965 
966             // Burn all leftovers
967             tokenReward.burn(tokenReward.balanceOf(this));
968         }
969     }
970 
971     /**
972      * @notice Not for public use!
973      * @dev Allows early withdrawal of ether from the contract if the funding goal is reached.
974      * Only the owner and beneficiary of the contract can call this function.
975      * @param _amount The amount of ETH (in wei) which should be retreived.
976      */
977     function earlySafeWithdrawal(uint256 _amount) public onlyOwner {
978         require(fundingGoalReached, "funding goal has not been reached");
979         require(beneficiary == msg.sender, "message sender is not the beneficiary");
980         require(address(this).balance >= _amount, "contract has less ether in balance than requested");
981 
982         beneficiary.transfer(_amount);
983         emit FundsWithdrawal(beneficiary, _amount);
984     }
985 
986     /**
987      * @dev Internal function to calculate token price based on the ether price and current phase.
988      */
989     function getTokenPrice() internal view returns (uint256) {
990         return getEtherInEuroCents() * currentPhase.tokenPrice / 100;
991     }
992 
993     /**
994      * @dev Internal function to calculate 1 EUR in WEI.
995      */
996     function getEtherInEuroCents() internal view returns (uint256) {
997         return fiat.EUR(0) * 100;
998     }
999 
1000     /**
1001      * @notice Not for public use!
1002      * @dev Change the address of the fiat contract
1003      * @param _fiat The new address of the fiat contract
1004      */
1005     function setFiatContractAddress(address _fiat) public onlyOwner {
1006         require(_fiat != address(0), "zero address is not allowed");
1007         fiat = FiatContract(_fiat);
1008     }
1009 
1010     /**
1011      * @notice Not for public use!
1012      * @dev Change the address of the beneficiary
1013      * @param _beneficiary The new address of the beneficiary
1014      */
1015     function setBeneficiary(address _beneficiary) public onlyOwner {
1016         require(_beneficiary != address(0), "zero address is not allowed");
1017         beneficiary = _beneficiary;
1018     }
1019 }
1020 
1021 /**
1022  * @author https://github.com/hunterlong/fiatcontractd
1023  */
1024 contract FiatContract {
1025     function ETH(uint _id) public view returns (uint256);
1026     function USD(uint _id) public view returns (uint256);
1027     function EUR(uint _id) public view returns (uint256);
1028     function GBP(uint _id) public view returns (uint256);
1029     function updatedAt(uint _id) public view returns (uint);
1030 }