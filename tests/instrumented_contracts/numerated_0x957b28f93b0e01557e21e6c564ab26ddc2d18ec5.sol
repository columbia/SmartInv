1 pragma solidity 0.5.4;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title MultiOwnable
56  *
57  * @dev Require majority approval of multiple owners to use and access to features
58  *      when restrictions on access to critical functions are required.
59  *
60  */
61 
62 contract MultiOwnable {
63     using SafeMath for uint8;
64 
65     struct CommitteeStatusPack{
66       /**
67        * Key informations for decisions.
68        * To save some gas, choosing the struct.
69        */
70         uint8 numOfOwners;
71         uint8 numOfVotes;
72         uint8 numOfMinOwners;
73         bytes proposedFuncData;
74     }
75     CommitteeStatusPack public committeeStatus;
76 
77     address[] public ballot; // To make sure if it already was voted
78     mapping(address => bool) public owner;
79 
80     event Vote(address indexed proposer, bytes indexed proposedFuncData);
81     event Propose(address indexed proposer, bytes indexed proposedFuncData);
82     event Dismiss(address indexed proposer, bytes indexed proposedFuncData);
83     event AddedOwner(address newOwner);
84     event RemovedOwner(address removedOwner);
85     event TransferOwnership(address from, address to);
86 
87 
88     /**
89      * Organize initial committee.
90      *
91      * @notice committee must be 3 at least.
92      *         you have to use this contract to be inherited because it is internal.
93      *
94      * @param _coOwner1 _coOwner2 _coOwner3 _coOwner4 _coOwner5 committee members
95      */
96     constructor(address _coOwner1, address _coOwner2, address _coOwner3, address _coOwner4, address _coOwner5) internal {
97         require(_coOwner1 != address(0x0) &&
98                 _coOwner2 != address(0x0) &&
99                 _coOwner3 != address(0x0) &&
100                 _coOwner4 != address(0x0) &&
101                 _coOwner5 != address(0x0));
102         require(_coOwner1 != _coOwner2 &&
103                 _coOwner1 != _coOwner3 &&
104                 _coOwner1 != _coOwner4 &&
105                 _coOwner1 != _coOwner5 &&
106                 _coOwner2 != _coOwner3 &&
107                 _coOwner2 != _coOwner4 &&
108                 _coOwner2 != _coOwner5 &&
109                 _coOwner3 != _coOwner4 &&
110                 _coOwner3 != _coOwner5 &&
111                 _coOwner4 != _coOwner5); // SmartDec Recommendations
112         owner[_coOwner1] = true;
113         owner[_coOwner2] = true;
114         owner[_coOwner3] = true;
115         owner[_coOwner4] = true;
116         owner[_coOwner5] = true;
117         committeeStatus.numOfOwners = 5;
118         committeeStatus.numOfMinOwners = 5;
119         emit AddedOwner(_coOwner1);
120         emit AddedOwner(_coOwner2);
121         emit AddedOwner(_coOwner3);
122         emit AddedOwner(_coOwner4);
123         emit AddedOwner(_coOwner5);
124     }
125 
126 
127     modifier onlyOwner() {
128         require(owner[msg.sender]);
129         _;
130     }
131 
132     /**
133      * Pre-check if it's decided by committee
134      *
135      * @notice If there is a majority approval,
136      *         the function with this modifier will not be executed.
137      */
138     modifier committeeApproved() {
139       /* check if proposed Function Name and real function Name are correct */
140       require( keccak256(committeeStatus.proposedFuncData) == keccak256(msg.data) ); // SmartDec Recommendations
141 
142       /* To check majority */
143       require(committeeStatus.numOfVotes > committeeStatus.numOfOwners.div(2));
144       _;
145       _dismiss(); //Once a commission-approved proposal is made, the proposal is initialized.
146     }
147 
148 
149     /**
150      * Suggest the functions you want to use.
151      *
152      * @notice To use some importan functions, propose function must be done first and voted.
153      */
154     function propose(bytes memory _targetFuncData) onlyOwner public {
155       /* Check if there're any ongoing proposals */
156       require(committeeStatus.numOfVotes == 0);
157       require(committeeStatus.proposedFuncData.length == 0);
158 
159       /* regist function informations that proposer want to run */
160       committeeStatus.proposedFuncData = _targetFuncData;
161       emit Propose(msg.sender, _targetFuncData);
162     }
163 
164     /**
165      * Proposal is withdrawn
166      *
167      * @notice When the proposed function is no longer used or deprecated,
168      *         proposal is discarded
169      */
170     function dismiss() onlyOwner public {
171       _dismiss();
172     }
173 
174     /**
175      * Suggest the functions you want to use.
176      *
177      * @notice 'dismiss' is executed even after successfully executing the proposed function.
178      *          If 'msg.sender' want to pass permission, he can't pass the 'committeeApproved' modifier.
179      *          internal functions are required to enable this.
180      */
181 
182     function _dismiss() internal {
183       emit Dismiss(msg.sender, committeeStatus.proposedFuncData);
184       committeeStatus.numOfVotes = 0;
185       committeeStatus.proposedFuncData = "";
186       delete ballot;
187     }
188 
189 
190     /**
191      * Owners vote for proposed item
192      *
193      * @notice if only there're proposals, 'vote' is processed.
194      *         the result must be majority.
195      *         one ticket for each owner.
196      */
197 
198     function vote() onlyOwner public {
199       // Check duplicated voting list.
200       uint length = ballot.length; // SmartDec Recommendations
201       for(uint i=0; i<length; i++) // SmartDec Recommendations
202         require(ballot[i] != msg.sender);
203 
204       //onlyOnwers can vote, if there's ongoing proposal.
205       require( committeeStatus.proposedFuncData.length != 0 );
206 
207       //Check, if everyone voted.
208       //require(committeeStatus.numOfOwners > committeeStatus.numOfVotes); // SmartDec Recommendations
209       committeeStatus.numOfVotes++;
210       ballot.push(msg.sender);
211       emit Vote(msg.sender, committeeStatus.proposedFuncData);
212     }
213 
214 
215     /**
216      * Existing owner transfers permissions to new owner.
217      *
218      * @notice It transfers authority to the person who was not the owner.
219      *           Approval from the committee is required.
220      */
221     function transferOwnership(address _newOwner) onlyOwner committeeApproved public {
222         require( _newOwner != address(0x0) ); // callisto recommendation
223         require( owner[_newOwner] == false );
224         owner[msg.sender] = false;
225         owner[_newOwner] = true;
226         emit TransferOwnership(msg.sender, _newOwner);
227     }
228 
229     /**
230      * Add new Owner to committee
231      *
232      * @notice Approval from the committee is required.
233      *
234      */
235     function addOwner(address _newOwner) onlyOwner committeeApproved public {
236         require( _newOwner != address(0x0) );
237         require( owner[_newOwner] != true );
238         owner[_newOwner] = true;
239         committeeStatus.numOfOwners++;
240         emit AddedOwner(_newOwner);
241     }
242 
243     /**
244      * Remove the Owner from committee
245      *
246      * @notice Approval from the committee is required.
247      *
248      */
249     function removeOwner(address _toRemove) onlyOwner committeeApproved public {
250         require( _toRemove != address(0x0) );
251         require( owner[_toRemove] == true );
252         require( committeeStatus.numOfOwners > committeeStatus.numOfMinOwners ); // must keep Number of Minimum Owners at least.
253         owner[_toRemove] = false;
254         committeeStatus.numOfOwners--;
255         emit RemovedOwner(_toRemove);
256     }
257 }
258 
259 contract Pausable is MultiOwnable {
260     event Pause();
261     event Unpause();
262 
263     bool internal paused;
264 
265     modifier whenNotPaused() {
266         require(!paused);
267         _;
268     }
269 
270     modifier whenPaused() {
271         require(paused);
272         _;
273     }
274 
275     modifier noReentrancy() {
276         require(!paused);
277         paused = true;
278         _;
279         paused = false;
280     }
281 
282     /* When you discover your smart contract is under attack, you can buy time to upgrade the contract by
283        immediately pausing the contract.
284      */
285     function pause() public onlyOwner committeeApproved whenNotPaused {
286         paused = true;
287         emit Pause();
288     }
289 
290     function unpause() public onlyOwner committeeApproved whenPaused {
291         paused = false;
292         emit Unpause();
293     }
294 }
295 
296 /**
297  * Contract Managing TokenExchanger's address used by ProxyNemodax
298  */
299 contract RunningContractManager is Pausable {
300     address public implementation; //SmartDec Recommendations
301 
302     event Upgraded(address indexed newContract);
303 
304     function upgrade(address _newAddr) onlyOwner committeeApproved external {
305         require(implementation != _newAddr);
306         implementation = _newAddr;
307         emit Upgraded(_newAddr); // SmartDec Recommendations
308     }
309 
310     /* SmartDec Recommendations
311     function runningAddress() onlyOwner external view returns (address){
312         return implementation;
313     }
314     */
315 }
316 
317 
318 
319 /**
320  * NemoLab ERC20 Token
321  * Written by Shin HyunJae
322  * version 12
323  */
324 contract TokenERC20 is RunningContractManager {
325     using SafeMath for uint256;
326 
327     // Public variables of the token
328     string public name;
329     string public symbol;
330     uint8 public decimals = 18;    // 18 decimals is the strongly suggested default, avoid changing it
331     uint256 public totalSupply;
332 
333     /* This creates an array with all balances */
334     mapping (address => uint256) internal balances;
335     mapping (address => mapping (address => uint256)) internal allowed;
336     //mapping (address => bool) public frozenAccount; // SmartDec Recommendations
337     mapping (address => uint256) public frozenExpired;
338 
339     //bool private initialized = false;
340     bool private initialized; // SmartDec Recommendations
341 
342     /**
343      * This is area for some variables to add.
344      * Please add variables from the end of pre-declared variables
345      * if you would have added some variables and re-deployed the contract,
346      * tokenPerEth would get garbage value. so please reset tokenPerEth variable
347      *
348      * uint256 something..;
349      */
350 
351 
352     // This generates a public event on the blockchain that will notify clients
353     event Transfer(address indexed from, address indexed to, uint256 value);
354     event LastBalance(address indexed account, uint256 value);
355 
356     // This notifies clients about the allowance of balance
357     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
358 
359     // This notifies clients about the amount burnt
360     // event Burn(address indexed from, uint256 value); // callisto recommendation
361 
362     // This notifies clients about the freezing address
363     //event FrozenFunds(address target, bool frozen); // callisto recommendation
364     event FrozenFunds(address target, uint256 expirationDate); // SmartDec Recommendations
365 
366     /**
367      * Initialize Token Function
368      *
369      * Initializes contract with initial supply tokens to the creator of the contract
370      */
371 
372     function initToken(
373         string memory _tokenName,
374         string memory _tokenSymbol,
375         uint256 _initialSupply,
376         address _marketSaleManager,
377         address _serviceOperationManager,
378         address _dividendManager,
379         address _incentiveManager,
380         address _reserveFundManager
381     ) internal onlyOwner committeeApproved {
382         require( initialized == false );
383         require(_initialSupply > 0 && _initialSupply <= 2**uint256(184)); // [2019.03.05] Fixed for Mythril Vulerablity SWC ID:101 => _initialSupply <= 2^184 <= (2^256 / 10^18)
384 
385         name = _tokenName;                                       // Set the name for display purposes
386         symbol = _tokenSymbol;                                   // Set the symbol for display purposes
387         //totalSupply = convertToDecimalUnits(_initialSupply);     // Update total supply with the decimal amount
388 
389         /*balances[msg.sender] = totalSupply;                     // Give the creator all initial tokens
390         emit Transfer(address(this), address(0), totalSupply);
391         emit LastBalance(address(this), 0);
392         emit LastBalance(msg.sender, totalSupply);*/
393 
394         // SmartDec Recommendations
395         uint256 tempSupply = convertToDecimalUnits(_initialSupply);
396 
397         uint256 dividendBalance = tempSupply.div(10);               // dividendBalance = 10%
398         uint256 reserveFundBalance = dividendBalance;               // reserveFundBalance = 10%
399         uint256 marketSaleBalance = tempSupply.div(5);              // marketSaleBalance = 20%
400         uint256 serviceOperationBalance = marketSaleBalance.mul(2); // serviceOperationBalance = 40%
401         uint256 incentiveBalance = marketSaleBalance;               // incentiveBalance = 20%
402 
403         balances[_marketSaleManager] = marketSaleBalance;
404         balances[_serviceOperationManager] = serviceOperationBalance;
405         balances[_dividendManager] = dividendBalance;
406         balances[_incentiveManager] = incentiveBalance;
407         balances[_reserveFundManager] = reserveFundBalance;
408 
409         totalSupply = tempSupply;
410 
411         emit Transfer(address(0), _marketSaleManager, marketSaleBalance);
412         emit Transfer(address(0), _serviceOperationManager, serviceOperationBalance);
413         emit Transfer(address(0), _dividendManager, dividendBalance);
414         emit Transfer(address(0), _incentiveManager, incentiveBalance);
415         emit Transfer(address(0), _reserveFundManager, reserveFundBalance);
416 
417         emit LastBalance(address(this), 0);
418         emit LastBalance(_marketSaleManager, marketSaleBalance);
419         emit LastBalance(_serviceOperationManager, serviceOperationBalance);
420         emit LastBalance(_dividendManager, dividendBalance);
421         emit LastBalance(_incentiveManager, incentiveBalance);
422         emit LastBalance(_reserveFundManager, reserveFundBalance);
423 
424         assert( tempSupply ==
425           marketSaleBalance.add(serviceOperationBalance).
426                             add(dividendBalance).
427                             add(incentiveBalance).
428                             add(reserveFundBalance)
429         );
430 
431 
432         initialized = true;
433     }
434 
435 
436     /**
437      * Convert tokens units to token decimal units
438      *
439      * @param _value Tokens units without decimal units
440      */
441     function convertToDecimalUnits(uint256 _value) internal view returns (uint256 value) {
442         value = _value.mul(10 ** uint256(decimals));
443         return value;
444     }
445 
446     /**
447      * Get tokens balance
448      *
449      * @notice Query tokens balance of the _account
450      *
451      * @param _account Account address to query tokens balance
452      */
453     function balanceOf(address _account) public view returns (uint256 balance) {
454         balance = balances[_account];
455         return balance;
456     }
457 
458     /**
459      * Get allowed tokens balance
460      *
461      * @notice Query tokens balance allowed to _spender
462      *
463      * @param _owner Owner address to query tokens balance
464      * @param _spender The address allowed tokens balance
465      */
466     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
467         remaining = allowed[_owner][_spender];
468         return remaining;
469     }
470 
471     /**
472      * Internal transfer, only can be called by this contract
473      */
474     function _transfer(address _from, address _to, uint256 _value) internal {
475         require(_to != address(0x0));                                            // Prevent transfer to 0x0 address.
476         require(balances[_from] >= _value);                             // Check if the sender has enough
477         if(frozenExpired[_from] != 0 ){                                 // Check if sender is frozen
478             require(block.timestamp > frozenExpired[_from]);
479             _unfreezeAccount(_from);
480         }
481         if(frozenExpired[_to] != 0 ){                                   // Check if recipient is frozen
482             require(block.timestamp > frozenExpired[_to]);
483             _unfreezeAccount(_to);
484         }
485 
486         uint256 previousBalances = balances[_from].add(balances[_to]);  // Save this for an assertion in the future
487 
488         balances[_from] = balances[_from].sub(_value);                  // Subtract from the sender
489         balances[_to] = balances[_to].add(_value);                      // Add the same to the recipient
490         emit Transfer(_from, _to, _value);
491         emit LastBalance(_from, balances[_from]);
492         emit LastBalance(_to, balances[_to]);
493 
494         // Asserts are used to use static analysis to find bugs in your code. They should never fail
495         assert(balances[_from] + balances[_to] == previousBalances);
496     }
497 
498     /**
499      * Transfer tokens
500      *
501      * @notice Send `_value` tokens to `_to` from your account
502      *
503      * @param _to The address of the recipient
504      * @param _value the amount to send
505      */
506     function transfer(address _to, uint256 _value) public noReentrancy returns (bool success) {
507         _transfer(msg.sender, _to, _value);
508         success = true;
509         return success;
510     }
511 
512 
513     /**
514      * Transfer tokens from other address
515      *
516      * Send `_value` tokens to `_to` on behalf of `_from`
517      *
518      * @param _from The address of the sender
519      * @param _to The address of the recipient
520      * @param _value the amount to send
521      */
522     function transferFrom(address _from, address _to, uint256 _value) public noReentrancy returns (bool success) {
523         require(_value <= allowed[_from][msg.sender]);     // Check allowance
524         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
525         _transfer(_from, _to, _value);
526         success = true;
527         return success;
528     }
529 
530     /**
531      * Internal approve, only can be called by this contract
532      *
533      * @param _spender The address authorized to spend
534      * @param _value the max amount they can spend
535      */
536     function _approve(address _spender, uint256 _value) internal returns (bool success) {
537         allowed[msg.sender][_spender] = _value;
538         emit Approval(msg.sender, _spender, _value);
539         success = true;
540         return success;
541     }
542 
543     /**
544      * Set allowance for other address
545      *
546      * Allows `_spender` to spend no more than `_value` tokens on your behalf
547      *
548      * @param _spender The address authorized to spend
549      * @param _value the max amount they can spend
550      */
551     function approve(address _spender, uint256 _value) public noReentrancy returns (bool success) {
552         success = _approve(_spender, _value);
553         return success;
554     }
555 
556 
557     /**
558      * @dev Increase the amount of tokens that an owner allowed to a spender.
559      * approve should be called when allowed[_spender] == 0. To increment
560      * allowed value is better to use this function to avoid 2 calls (and wait until
561      * the first transaction is mined)
562      * From MonolithDAO Token.sol
563      * @param _spender The address which will spend the funds.
564      * @param _addedValue The amount of tokens to increase the allowance by.
565      */
566     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
567       allowed[msg.sender][_spender] = (
568         allowed[msg.sender][_spender].add(_addedValue));
569       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
570       return true;
571     }
572 
573     /**
574      * @dev Decrease the amount of tokens that an owner allowed to a spender.
575      * approve should be called when allowed[_spender] == 0. To decrement
576      * allowed value is better to use this function to avoid 2 calls (and wait until
577      * the first transaction is mined)
578      * From MonolithDAO Token.sol
579      * @param _spender The address which will spend the funds.
580      * @param _subtractedValue The amount of tokens to decrease the allowance by.
581      */
582     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
583       uint256 oldValue = allowed[msg.sender][_spender];
584       if (_subtractedValue >= oldValue) {
585         allowed[msg.sender][_spender] = 0;
586       } else {
587         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
588       }
589       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
590       return true;
591     }
592 
593 
594 
595 
596     /// @notice `freeze? Prevent` `target` from sending & receiving tokens
597     /// @param target Address to be frozen
598     function freezeAccount(address target, uint256 freezeExpiration) onlyOwner committeeApproved public {
599         frozenExpired[target] = freezeExpiration;
600         //emit FrozenFunds(target, true);
601         emit FrozenFunds(target, freezeExpiration); // SmartDec Recommendations
602     }
603 
604     /// @notice  `freeze? Allow` `target` from sending & receiving tokens
605     /// @notice if expiration date was over, when this is called with transfer transaction, auto-unfreeze is occurred without committeeApproved
606     ///         the reason why it's separated from wrapper function.
607     /// @param target Address to be unfrozen
608     function _unfreezeAccount(address target) internal returns (bool success) {
609         frozenExpired[target] = 0;
610         //emit FrozenFunds(target, false);
611         emit FrozenFunds(target, 0); // SmartDec Recommendations
612         success = true;
613         return success;
614     }
615 
616     /// @notice _unfreezeAccount wrapper function.
617     /// @param target Address to be unfrozen
618     function unfreezeAccount(address target) onlyOwner committeeApproved public returns(bool success) {
619         success = _unfreezeAccount(target);
620         return success;
621     }
622 
623 }
624 
625 
626 /**
627  * @title TokenExchanger
628  * @notice This is for exchange between Ether and 'Nemo' token
629  *          It won't be needed after being listed on the exchange.
630  */
631 
632 contract TokenExchanger is TokenERC20{
633   using SafeMath for uint256;
634 
635     uint256 internal tokenPerEth;
636     bool public opened;
637 
638     event ExchangeEtherToToken(address indexed from, uint256 etherValue, uint256 tokenPerEth);
639     event ExchangeTokenToEther(address indexed from, uint256 etherValue, uint256 tokenPerEth);
640     event WithdrawToken(address indexed to, uint256 value);
641     event WithdrawEther(address indexed to, uint256 value);
642     event SetExchangeRate(address indexed from, uint256 tokenPerEth);
643 
644 
645     constructor(address _coOwner1,
646                 address _coOwner2,
647                 address _coOwner3,
648                 address _coOwner4,
649                 address _coOwner5)
650         MultiOwnable( _coOwner1, _coOwner2, _coOwner3, _coOwner4, _coOwner5) public { opened = true; }
651 
652     /**
653      * Initialize Exchanger Function
654      *
655      * Initialize Exchanger contract with tokenPerEth
656      * and Initialize NemoCoin by calling initToken
657      * It would call initToken in TokenERC20 with _tokenName, _tokenSymbol, _initalSupply
658      * Last five arguments are manager account to supply currency (_marketSaleManager, _serviceOperationManager, _dividendManager, _incentiveManager, _reserveFundManager)
659      *
660      */
661     function initExchanger(
662         string calldata _tokenName,
663         string calldata _tokenSymbol,
664         uint256 _initialSupply,
665         uint256 _tokenPerEth,
666         address _marketSaleManager,
667         address _serviceOperationManager,
668         address _dividendManager,
669         address _incentiveManager,
670         address _reserveFundManager
671     ) external onlyOwner committeeApproved {
672         require(opened);
673         //require(_tokenPerEth > 0 && _initialSupply > 0);  // [2019.03.05] Fixed for Mythril Vulerablity SWC ID:101
674         require(_tokenPerEth > 0); // SmartDec Recommendations
675         require(_marketSaleManager != address(0) &&
676                 _serviceOperationManager != address(0) &&
677                 _dividendManager != address(0) &&
678                 _incentiveManager != address(0) &&
679                 _reserveFundManager != address(0));
680         require(_marketSaleManager != _serviceOperationManager &&
681                 _marketSaleManager != _dividendManager &&
682                 _marketSaleManager != _incentiveManager &&
683                 _marketSaleManager != _reserveFundManager &&
684                 _serviceOperationManager != _dividendManager &&
685                 _serviceOperationManager != _incentiveManager &&
686                 _serviceOperationManager != _reserveFundManager &&
687                 _dividendManager != _incentiveManager &&
688                 _dividendManager != _reserveFundManager &&
689                 _incentiveManager != _reserveFundManager); // SmartDec Recommendations
690 
691         super.initToken(_tokenName, _tokenSymbol, _initialSupply,
692           // SmartDec Recommendations
693           _marketSaleManager,
694           _serviceOperationManager,
695           _dividendManager,
696           _incentiveManager,
697           _reserveFundManager
698         );
699         tokenPerEth = _tokenPerEth;
700         emit SetExchangeRate(msg.sender, tokenPerEth);
701     }
702 
703 
704     /**
705      * Change tokenPerEth variable only by owner
706      *
707      * Because "TokenExchaner" is only used until be listed on the exchange,
708      * tokenPerEth is needed by then and it would be managed by manager.
709      */
710     function setExchangeRate(uint256 _tokenPerEth) onlyOwner committeeApproved external returns (bool success){
711         require(opened);
712         require( _tokenPerEth > 0);
713         tokenPerEth = _tokenPerEth;
714         emit SetExchangeRate(msg.sender, tokenPerEth);
715 
716         success = true;
717         return success;
718     }
719 
720     function getExchangerRate() external view returns(uint256){
721         return tokenPerEth;
722     }
723 
724     /**
725      * Exchange Ether To Token
726      *
727      * @notice Send `Nemo` tokens to msg sender as much as amount of ether received considering exchangeRate.
728      */
729     function exchangeEtherToToken() payable external noReentrancy returns (bool success){
730         require(opened);
731         uint256 tokenPayment;
732         uint256 ethAmount = msg.value;
733 
734         require(ethAmount > 0);
735         require(tokenPerEth != 0);
736         tokenPayment = ethAmount.mul(tokenPerEth);
737 
738         super._transfer(address(this), msg.sender, tokenPayment);
739 
740         emit ExchangeEtherToToken(msg.sender, msg.value, tokenPerEth);
741 
742         success = true;
743         return success;
744     }
745 
746     /**
747      * Exchange Token To Ether
748      *
749      * @notice Send Ether to msg sender as much as amount of 'Nemo' Token received considering exchangeRate.
750      *
751      * @param _value Amount of 'Nemo' token
752      */
753     function exchangeTokenToEther(uint256 _value) external noReentrancy returns (bool success){
754       require(opened);
755       require(tokenPerEth != 0);
756 
757       uint256 remainingEthBalance = address(this).balance;
758       uint256 etherPayment = _value.div(tokenPerEth);
759       uint256 remainder = _value % tokenPerEth; // [2019.03.06 Fixing Securify vulnerabilities-Division influences Transfer Amount]
760       require(remainingEthBalance >= etherPayment);
761 
762       uint256 tokenAmount = _value.sub(remainder); // [2019.03.06 Fixing Securify vulnerabilities-Division influences Transfer Amount]
763       super._transfer(msg.sender, address(this), tokenAmount); // [2019.03.06 Fixing Securify vulnerabilities-Division influences Transfer Amount]
764       //require(address(msg.sender).send(etherPayment));
765       address(msg.sender).transfer(etherPayment); // SmartDec Recommendations
766 
767       emit ExchangeTokenToEther(address(this), etherPayment, tokenPerEth);
768       success = true;
769       return success;
770     }
771 
772     /**
773      * Withdraw token from TokenExchanger contract
774      *
775      * @notice Withdraw charged Token to _recipient.
776      *
777      * @param _recipient The address to which the token was issued.
778      * @param _value Amount of token to withdraw.
779      */
780     function withdrawToken(address _recipient, uint256 _value) onlyOwner committeeApproved noReentrancy public {
781       //require(opened);
782       super._transfer(address(this) ,_recipient, _value);
783       emit WithdrawToken(_recipient, _value);
784     }
785 
786 
787     /**
788      * Withdraw Ether from TokenExchanger contract
789      *
790      * @notice Withdraw charged Ether to _recipient.
791      *
792      * @param _recipient The address to which the Ether was issued.
793      * @param _value Amount of Ether to withdraw.
794      */
795     function withdrawEther(address payable _recipient, uint256 _value) onlyOwner committeeApproved noReentrancy public {
796         //require(opened);
797         //require(_recipient.send(_value));
798         _recipient.transfer(_value); // SmartDec Recommendations
799         emit WithdrawEther(_recipient, _value);
800     }
801 
802     /**
803      * close the TokenExchanger functions permanently
804      *
805      * @notice This contract would be closed when the coin is actively traded and judged that its TokenExchanger function is not needed.
806      */
807     function closeExchanger() onlyOwner committeeApproved external {
808         opened = false;
809     }
810 }
811 
812 
813 /**
814  * @title NemodaxStorage
815  *
816  * @dev This is contract for proxyNemodax data order list.
817  *      Contract shouldn't be changed as possible.
818  *      If it should be edited, please add from the end of the contract .
819  */
820 
821 contract NemodaxStorage is RunningContractManager {
822 
823     // Never ever change the order of variables below!!!!
824     // Public variables of the token
825     string public name;
826     string public symbol;
827     uint8 public decimals = 18;    // 18 decimals is the strongly suggested default, avoid changing it
828     uint256 public totalSupply;
829 
830     /* This creates an array with all balances */
831     mapping (address => uint256) internal balances;
832     mapping (address => mapping (address => uint256)) internal allowed;
833     mapping (address => uint256) public frozenExpired; // SmartDec Recommendations
834 
835     bool private initialized;
836 
837     uint256 internal tokenPerEth;
838     bool public opened = true;
839 }
840 
841 /**
842  * @title ProxyNemodax
843  *
844  * @dev The only fallback function will forward transaction to TokenExchanger Contract.
845  *      and the result of calculation would be stored in ProxyNemodax
846  *
847  */
848 
849 contract ProxyNemodax is NemodaxStorage {
850 
851     /* Initialize new committee. this will be real committee accounts, not from TokenExchanger contract */
852     constructor(address _coOwner1,
853                 address _coOwner2,
854                 address _coOwner3,
855                 address _coOwner4,
856                 address _coOwner5)
857         MultiOwnable( _coOwner1, _coOwner2, _coOwner3, _coOwner4, _coOwner5) public {}
858 
859     function () payable external {
860         address localImpl = implementation;
861         require(localImpl != address(0x0));
862 
863         assembly {
864             let ptr := mload(0x40)
865 
866             switch calldatasize
867             case 0 {  } // just to receive ethereum
868 
869             default{
870                 calldatacopy(ptr, 0, calldatasize)
871 
872                 let result := delegatecall(gas, localImpl, ptr, calldatasize, 0, 0)
873                 let size := returndatasize
874                 returndatacopy(ptr, 0, size)
875                 switch result
876 
877                 case 0 { revert(ptr, size) }
878                 default { return(ptr, size) }
879             }
880         }
881     }
882 }