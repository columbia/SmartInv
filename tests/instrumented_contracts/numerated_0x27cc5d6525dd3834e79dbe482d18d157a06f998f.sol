1 pragma solidity 0.4.19;
2 
3 // File: ../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: ../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: ../node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: ../node_modules/zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: ../node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: ../node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: ../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 contract YDToken is MintableToken {
310 
311     string public name = "YDTest"; 
312     string public symbol = "YDT";
313     uint8 public decimals = 18;
314 
315     function YDToken() public {
316     }
317 
318     /// This modifier will be used to disable all ERC20 functionalities during the minting process.
319     modifier whenNotMinting() {
320         require(mintingFinished);
321         _;
322     }
323 
324     /// @dev transfer token for a specified address
325     /// @param _to address The address to transfer to.
326     /// @param _value uint256 The amount to be transferred.
327     /// @return success bool Calling super.transfer and returns true if successful.
328     function transfer(address _to, uint256 _value) public whenNotMinting returns (bool) {
329 	    return super.transfer(_to, _value);
330     }
331 
332     /// @dev Transfer tokens from one address to another.
333     /// @param _from address The address which you want to send tokens from.
334     /// @param _to address The address which you want to transfer to.
335     /// @param _value uint256 the amount of tokens to be transferred.
336     /// @return success bool Calling super.transferFrom and returns true if successful.
337     function transferFrom(address _from, address _to, uint256 _value) public whenNotMinting returns (bool) {
338         return super.transferFrom(_from, _to, _value);
339     }
340 }
341 
342 // File: ../contracts/TokenMultisig.sol
343 
344 contract MultiSigWallet {
345 
346     /// =================================================================================================================
347     ///                                      Events
348     /// =================================================================================================================
349     event Confirmation(address indexed sender, uint indexed transactionId);
350     event Revocation(address indexed sender, uint indexed transactionId);
351     event Submission(uint indexed transactionId);
352     event Execution(uint indexed transactionId);
353     event ExecutionFailure(uint indexed transactionId);
354     event Deposit(address indexed sender, uint value);
355     event OwnerAddition(address indexed owner);
356     event OwnerRemoval(address indexed owner);
357     event RequirementChange(uint required);
358 
359      /// =================================================================================================================
360     ///                                      Constants
361     /// =================================================================================================================
362     uint constant public MAX_OWNER_COUNT = 50;
363     uint constant public VESTING_TIME_FRAME = 120 days;
364 
365     /// =================================================================================================================
366     ///                                      Members
367     /// =================================================================================================================
368     mapping (uint => Transaction) public transactions;
369     mapping (uint => mapping (address => bool)) public confirmations;
370     mapping (address => bool) public isOwner;
371     address[] public owners;
372     uint public required;
373     uint public transactionCount;
374     YDToken public token;
375 
376     struct Transaction {
377         address destination;
378         uint value;
379         bool executed;
380     }
381 
382     /// =================================================================================================================
383     ///                                      Modifiers
384     /// =================================================================================================================
385     modifier onlyWallet() {
386         require(msg.sender == address(this));
387         _;
388     }
389 
390     modifier ownerDoesNotExist(address owner) {
391         require(!isOwner[owner]);
392         _;
393     }
394 
395     modifier ownerExists(address owner) {
396         require(isOwner[owner]);
397         _;
398     }
399 
400     modifier transactionExists(uint transactionId) {
401         require(transactions[transactionId].destination != 0);
402         _;
403     }
404 
405     modifier confirmed(uint transactionId, address owner) {
406         require(confirmations[transactionId][owner]);
407         _;
408     }
409 
410     modifier notConfirmed(uint transactionId, address owner) {
411         require(!confirmations[transactionId][owner]);
412         _;
413     }
414 
415     modifier notExecuted(uint transactionId) {
416         require(!transactions[transactionId].executed);
417         _;
418     }
419 
420     modifier notNull(address _address) {
421         require(_address != 0);
422         _;
423     }
424 
425     modifier validRequirement(uint ownerCount, uint _required, YDToken _token) {
426         require(
427             ownerCount <= MAX_OWNER_COUNT
428             && _required <= ownerCount
429             && _required != 0
430             && ownerCount != 0
431             && _token != address(0)
432             );
433         _;
434     }
435 
436     /// =================================================================================================================
437     ///                                      Constructor
438     /// =================================================================================================================
439 
440     /// @dev Contract constructor sets initial owners and required number of confirmations.
441     /// @param _owners List of initial owners.
442     /// @param _required Number of required confirmations.
443     /// @param _token Token Address 
444     function MultiSigWallet(address[] _owners, uint _required, YDToken _token)
445         public
446         validRequirement(_owners.length, _required, _token)
447     {
448         token = _token;
449 
450         for (uint i = 0; i < _owners.length; i++) {
451             require(!isOwner[_owners[i]] && _owners[i] != 0);
452             isOwner[_owners[i]] = true;
453         }
454         owners = _owners;
455         required = _required;
456     }
457 
458     // =================================================================================================================
459     //                                      Public Functions
460     // =================================================================================================================
461 
462     /// @dev Allows an owner to submit and confirm a transaction.
463     /// @param destination Transaction target address.
464     /// @param value Transaction ether value.
465     /// @return Returns transaction ID.
466     function submitTransaction(address destination, uint value)
467         public
468         returns (uint transactionId)
469     {
470         transactionId = addTransaction(destination, value);
471         confirmTransaction(transactionId);
472     }
473 
474     /// @dev Allows an owner to confirm a transaction.
475     /// @param transactionId Transaction ID.
476     function confirmTransaction(uint transactionId)
477         public
478         ownerExists(msg.sender)
479         transactionExists(transactionId)
480         notConfirmed(transactionId, msg.sender)
481     {
482         confirmations[transactionId][msg.sender] = true;
483         Confirmation(msg.sender, transactionId);
484         executeTransaction(transactionId);
485     }
486 
487     /// @dev Allows an owner to revoke a confirmation for a transaction.
488     /// @param transactionId Transaction ID.
489     function revokeConfirmation(uint transactionId)
490         public
491         ownerExists(msg.sender)
492         confirmed(transactionId, msg.sender)
493         notExecuted(transactionId)
494     {
495         confirmations[transactionId][msg.sender] = false;
496         Revocation(msg.sender, transactionId);
497     }
498 
499     /// @dev Allows anyone to execute a confirmed transaction.
500     /// @param transactionId Transaction ID.
501     function executeTransaction(uint transactionId)
502         public
503         ownerExists(msg.sender)
504         confirmed(transactionId, msg.sender)
505         notExecuted(transactionId)
506     {
507         if (isConfirmed(transactionId)) {
508             Transaction storage txn = transactions[transactionId];
509             if (token.transfer(txn.destination, txn.value)) {
510                 txn.executed = true;
511                 Execution(transactionId);
512             } else {
513                 ExecutionFailure(transactionId);
514             }
515         }
516     }
517 
518     /// @dev Returns the confirmation status of a transaction.
519     /// @param transactionId Transaction ID.
520     /// @return Confirmation status.
521     function isConfirmed(uint transactionId)
522         public
523         constant
524         returns (bool)
525     {
526         uint count = 0;
527         for (uint i = 0; i < owners.length; i++) {
528             if (confirmations[transactionId][owners[i]])
529                 count += 1;
530             if (count == required)
531                 return true;
532         }
533     }
534 
535     // =================================================================================================================
536     //                                      Internal Functions
537     // =================================================================================================================
538 
539     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
540     /// @param destination Transaction target address.
541     /// @param value Transaction ether value.
542     /// @return Returns transaction ID.
543     function addTransaction(address destination, uint value)
544         internal
545         notNull(destination)
546         returns (uint transactionId)
547     {
548         transactionId = transactionCount;
549         transactions[transactionId] = Transaction({
550             destination: destination,
551             value: value,
552             executed: false
553         });
554         transactionCount += 1;
555         Submission(transactionId);
556     }
557 
558     /*
559      * Web3 call functions
560      */
561     /// @dev Returns number of confirmations of a transaction.
562     /// @param transactionId Transaction ID.
563     /// @return Number of confirmations.
564     function getConfirmationCount(uint transactionId)
565         public
566         constant
567         returns (uint count)
568     {
569         for (uint i = 0; i < owners.length; i++)
570             if (confirmations[transactionId][owners[i]]) {
571                 count += 1;
572             }
573     }
574 
575     /// @dev Returns total number of transactions after filers are applied.
576     /// @param pending Include pending transactions.
577     /// @param executed Include executed transactions.
578     /// @return Total number of transactions after filters are applied.
579     function getTransactionCount(bool pending, bool executed)
580         public
581         constant
582         returns (uint count)
583     {
584         for (uint i = 0; i < transactionCount; i++)
585             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
586                 count += 1;
587             }
588     }
589 
590     /// @dev Returns list of owners.
591     /// @return List of owner addresses.
592     function getOwners()
593         public
594         constant
595         returns (address[])
596     {
597         return owners;
598     }
599 
600     /// @dev Returns array with owner addresses, which confirmed transaction.
601     /// @param transactionId Transaction ID.
602     /// @return Returns array of owner addresses.
603     function getConfirmations(uint transactionId)
604         public
605         constant
606         returns (address[] _confirmations)
607     {
608         address[] memory confirmationsTemp = new address[](owners.length);
609         uint count = 0;
610         uint i;
611         for (i = 0; i < owners.length; i++)
612             if (confirmations[transactionId][owners[i]]) {
613                 confirmationsTemp[count] = owners[i];
614                 count += 1;
615             }
616         _confirmations = new address[](count);
617         for (i = 0; i < count; i++) {
618             _confirmations[i] = confirmationsTemp[i];
619         }
620     }
621 
622     /// @dev Returns list of transaction IDs in defined range.
623     /// @param from Index start position of transaction array.
624     /// @param to Index end position of transaction array.
625     /// @param pending Include pending transactions.
626     /// @param executed Include executed transactions.
627     /// @return Returns array of transaction IDs.
628     function getTransactionIds(uint from, uint to, bool pending, bool executed)
629         public
630         constant
631         returns (uint[] _transactionIds)
632     {
633         uint[] memory transactionIdsTemp = new uint[](transactionCount);
634         uint count = 0;
635         uint i;
636         for (i = 0; i < transactionCount; i++)
637             if (   pending && !transactions[i].executed || executed && transactions[i].executed) {
638                 transactionIdsTemp[count] = i;
639                 count += 1;
640             }
641         _transactionIds = new uint[](to - from);
642         for (i = from; i < to; i++) {
643             _transactionIds[i - from] = transactionIdsTemp[i];
644         }
645     }
646 }