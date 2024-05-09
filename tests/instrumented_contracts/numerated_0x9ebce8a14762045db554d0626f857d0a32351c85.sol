1 pragma solidity 0.4.18;
2 
3 // From https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11 
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function toInt256Safe(uint256 a) internal pure returns (int256) {
35     int256 b = int256(a);
36     assert(b >= 0);
37     return b;
38   }
39 }
40 
41 /**
42  * @title SafeMathInt
43  * @dev Math operations with safety checks that throw on error
44  * @dev SafeMath adapted for int256
45  */
46 library SafeMathInt {
47   function mul(int256 a, int256 b) internal pure returns (int256) {
48     // Prevent overflow when multiplying INT256_MIN with -1
49     // https://github.com/RequestNetwork/requestNetwork/issues/43
50     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
51 
52     int256 c = a * b;
53     assert((b == 0) || (c / b == a));
54     return c;
55   }
56 
57   function div(int256 a, int256 b) internal pure returns (int256) {
58     // Prevent overflow when dividing INT256_MIN by -1
59     // https://github.com/RequestNetwork/requestNetwork/issues/43
60     assert(!(a == - 2**255 && b == -1));
61 
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     int256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return c;
66   }
67 
68   function sub(int256 a, int256 b) internal pure returns (int256) {
69     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
70 
71     return a - b;
72   }
73 
74   function add(int256 a, int256 b) internal pure returns (int256) {
75     int256 c = a + b;
76     assert((b >= 0 && c >= a) || (b < 0 && c < a));
77     return c;
78   }
79 
80   function toUint256Safe(int256 a) internal pure returns (uint256) {
81     assert(a>=0);
82     return uint256(a);
83   }
84 }
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  * @dev SafeMath adapted for uint8
90  */
91 library SafeMathUint8 {
92   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
93     uint8 c = a * b;
94     assert(a == 0 || c / a == b);
95     return c;
96   }
97 
98   function div(uint8 a, uint8 b) internal pure returns (uint8) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint8 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   function add(uint8 a, uint8 b) internal pure returns (uint8) {
111     uint8 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 /**
118  * @title SafeMath
119  * @dev Math operations with safety checks that throw on error
120  * @dev SafeMath adapted for uint96
121  */
122 library SafeMathUint96 {
123   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
124     uint96 c = a * b;
125     assert(a == 0 || c / a == b);
126     return c;
127   }
128 
129   function div(uint96 a, uint96 b) internal pure returns (uint96) {
130     // assert(b > 0); // Solidity automatically throws when dividing by 0
131     uint96 c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133     return c;
134   }
135 
136   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
137     assert(b <= a);
138     return a - b;
139   }
140 
141   function add(uint96 a, uint96 b) internal pure returns (uint96) {
142     uint96 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }
147 
148 /**
149  * @title ERC20Basic
150  * @dev Simpler version of ERC20 interface
151  * @dev see https://github.com/ethereum/EIPs/issues/179
152  */
153 contract ERC20Basic {
154   uint256 public totalSupply;
155   function balanceOf(address who) public constant returns (uint256);
156   function transfer(address to, uint256 value) public returns (bool);
157   event Transfer(address indexed from, address indexed to, uint256 value);
158 }
159 
160 
161 /**
162  * @title ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/20
164  */
165 contract ERC20 is ERC20Basic {
166   function allowance(address owner, address spender) public constant returns (uint256);
167   function transferFrom(address from, address to, uint256 value) public returns (bool);
168   function approve(address spender, uint256 value) public returns (bool);
169   event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() public {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner public {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 /**
215  * @title Pausable
216  * @dev Base contract which allows children to implement an emergency stop mechanism.
217  */
218 contract Pausable is Ownable {
219   event Pause();
220   event Unpause();
221 
222   bool public paused = false;
223 
224 
225   /**
226    * @dev Modifier to make a function callable only when the contract is not paused.
227    */
228   modifier whenNotPaused() {
229     require(!paused);
230     _;
231   }
232 
233   /**
234    * @dev Modifier to make a function callable only when the contract is paused.
235    */
236   modifier whenPaused() {
237     require(paused);
238     _;
239   }
240 
241   /**
242    * @dev called by the owner to pause, triggers stopped state
243    */
244   function pause() onlyOwner whenNotPaused public {
245     paused = true;
246     Pause();
247   }
248 
249   /**
250    * @dev called by the owner to unpause, returns to normal state
251    */
252   function unpause() onlyOwner whenPaused public {
253     paused = false;
254     Unpause();
255   }
256 }
257 
258 
259 /**
260  * @title Administrable
261  * @dev Base contract for the administration of Core. Handles whitelisting of currency contracts
262  */
263 contract Administrable is Pausable {
264 
265     // mapping of address of trusted contract
266     mapping(address => uint8) public trustedCurrencyContracts;
267 
268     // Events of the system
269     event NewTrustedContract(address newContract);
270     event RemoveTrustedContract(address oldContract);
271 
272     /**
273      * @dev add a trusted currencyContract 
274      *
275      * @param _newContractAddress The address of the currencyContract
276      */
277     function adminAddTrustedCurrencyContract(address _newContractAddress)
278         external
279         onlyOwner
280     {
281         trustedCurrencyContracts[_newContractAddress] = 1; //Using int instead of boolean in case we need several states in the future.
282         NewTrustedContract(_newContractAddress);
283     }
284 
285     /**
286      * @dev remove a trusted currencyContract 
287      *
288      * @param _oldTrustedContractAddress The address of the currencyContract
289      */
290     function adminRemoveTrustedCurrencyContract(address _oldTrustedContractAddress)
291         external
292         onlyOwner
293     {
294         require(trustedCurrencyContracts[_oldTrustedContractAddress] != 0);
295         trustedCurrencyContracts[_oldTrustedContractAddress] = 0;
296         RemoveTrustedContract(_oldTrustedContractAddress);
297     }
298 
299     /**
300      * @dev get the status of a trusted currencyContract 
301      * @dev Not used today, useful if we have several states in the future.
302      *
303      * @param _contractAddress The address of the currencyContract
304      * @return The status of the currencyContract. If trusted 1, otherwise 0
305      */
306     function getStatusContract(address _contractAddress)
307         view
308         external
309         returns(uint8) 
310     {
311         return trustedCurrencyContracts[_contractAddress];
312     }
313 
314     /**
315      * @dev check if a currencyContract is trusted
316      *
317      * @param _contractAddress The address of the currencyContract
318      * @return bool true if contract is trusted
319      */
320     function isTrustedContract(address _contractAddress)
321         public
322         view
323         returns(bool)
324     {
325         return trustedCurrencyContracts[_contractAddress] == 1;
326     }
327 }
328 
329 /**
330  * @title RequestCore
331  *
332  * @dev The Core is the main contract which stores all the requests.
333  *
334  * @dev The Core philosophy is to be as much flexible as possible to adapt in the future to any new system
335  * @dev All the important conditions and an important part of the business logic takes place in the currency contracts.
336  * @dev Requests can only be created in the currency contracts
337  * @dev Currency contracts have to be allowed by the Core and respect the business logic.
338  * @dev Request Network will develop one currency contracts per currency and anyone can creates its own currency contracts.
339  */
340 contract RequestCore is Administrable {
341     using SafeMath for uint256;
342     using SafeMathUint96 for uint96;
343     using SafeMathInt for int256;
344     using SafeMathUint8 for uint8;
345 
346     enum State { Created, Accepted, Canceled }
347 
348     struct Request {
349         // ID address of the payer
350         address payer;
351 
352         // Address of the contract managing the request
353         address currencyContract;
354 
355         // State of the request
356         State state;
357 
358         // Main payee
359         Payee payee;
360     }
361 
362     // Structure for the payees. A sub payee is an additional entity which will be paid during the processing of the invoice.
363     // ex: can be used for routing taxes or fees at the moment of the payment.
364     struct Payee {
365         // ID address of the payee
366         address addr;
367 
368         // amount expected for the payee. 
369         // Not uint for evolution (may need negative amounts one day), and simpler operations
370         int256 expectedAmount;
371 
372         // balance of the payee
373         int256 balance;
374     }
375 
376     // Count of request in the mapping. A maximum of 2^96 requests can be created per Core contract.
377     // Integer, incremented for each request of a Core contract, starting from 0
378     // RequestId (256bits) = contract address (160bits) + numRequest
379     uint96 public numRequests; 
380     
381     // Mapping of all the Requests. The key is the request ID.
382     // not anymore public to avoid "UnimplementedFeatureError: Only in-memory reference type can be stored."
383     // https://github.com/ethereum/solidity/issues/3577
384     mapping(bytes32 => Request) requests;
385 
386     // Mapping of subPayees of the requests. The key is the request ID.
387     // This array is outside the Request structure to optimize the gas cost when there is only 1 payee.
388     mapping(bytes32 => Payee[256]) public subPayees;
389 
390     /*
391      *  Events 
392      */
393     event Created(bytes32 indexed requestId, address indexed payee, address indexed payer, address creator, string data);
394     event Accepted(bytes32 indexed requestId);
395     event Canceled(bytes32 indexed requestId);
396 
397     // Event for Payee & subPayees
398     event NewSubPayee(bytes32 indexed requestId, address indexed payee); // Separated from the Created Event to allow a 4th indexed parameter (subpayees)
399     event UpdateExpectedAmount(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
400     event UpdateBalance(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
401 
402     /*
403      * @dev Function used by currency contracts to create a request in the Core
404      *
405      * @dev _payees and _expectedAmounts must have the same size
406      *
407      * @param _creator Request creator. The creator is the one who initiated the request (create or sign) and not necessarily the one who broadcasted it
408      * @param _payees array of payees address (the index 0 will be the payee the others are subPayees). Size must be smaller than 256.
409      * @param _expectedAmounts array of Expected amount to be received by each payees. Must be in same order than the payees. Size must be smaller than 256.
410      * @param _payer Entity expected to pay
411      * @param _data data of the request
412      * @return Returns the id of the request
413      */
414     function createRequest(
415         address     _creator,
416         address[]   _payees,
417         int256[]    _expectedAmounts,
418         address     _payer,
419         string      _data)
420         external
421         whenNotPaused 
422         returns (bytes32 requestId) 
423     {
424         // creator must not be null
425         require(_creator!=0); // not as modifier to lighten the stack
426         // call must come from a trusted contract
427         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
428 
429         // Generate the requestId
430         requestId = generateRequestId();
431 
432         address mainPayee;
433         int256 mainExpectedAmount;
434         // extract the main payee if filled
435         if(_payees.length!=0) {
436             mainPayee = _payees[0];
437             mainExpectedAmount = _expectedAmounts[0];
438         }
439 
440         // Store the new request
441         requests[requestId] = Request(_payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
442 
443         // Declare the new request
444         Created(requestId, mainPayee, _payer, _creator, _data);
445         
446         // Store and declare the sub payees (needed in internal function to avoid "stack too deep")
447         initSubPayees(requestId, _payees, _expectedAmounts);
448 
449         return requestId;
450     }
451 
452     /*
453      * @dev Function used by currency contracts to create a request in the Core from bytes
454      * @dev Used to avoid receiving a stack too deep error when called from a currency contract with too many parameters.
455      * @audit Note that to optimize the stack size and the gas cost we do not extract the params and store them in the stack. As a result there is some code redundancy
456      * @param _data bytes containing all the data packed :
457             address(creator)
458             address(payer)
459             uint8(number_of_payees)
460             [
461                 address(main_payee_address)
462                 int256(main_payee_expected_amount)
463                 address(second_payee_address)
464                 int256(second_payee_expected_amount)
465                 ...
466             ]
467             uint8(data_string_size)
468             size(data)
469      * @return Returns the id of the request 
470      */ 
471     function createRequestFromBytes(bytes _data) 
472         external
473         whenNotPaused 
474         returns (bytes32 requestId) 
475     {
476         // call must come from a trusted contract
477         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
478 
479         // extract address creator & payer
480         address creator = extractAddress(_data, 0);
481 
482         address payer = extractAddress(_data, 20);
483 
484         // creator must not be null
485         require(creator!=0);
486         
487         // extract the number of payees
488         uint8 payeesCount = uint8(_data[40]);
489 
490         // get the position of the dataSize in the byte (= number_of_payees * (address_payee_size + int256_payee_size) + address_creator_size + address_payer_size + payees_count_size
491         //                                              (= number_of_payees * (20+32) + 20 + 20 + 1 )
492         uint256 offsetDataSize = uint256(payeesCount).mul(52).add(41);
493 
494         // extract the data size and then the data itself
495         uint8 dataSize = uint8(_data[offsetDataSize]);
496         string memory dataStr = extractString(_data, dataSize, offsetDataSize.add(1));
497 
498         address mainPayee;
499         int256 mainExpectedAmount;
500         // extract the main payee if possible
501         if(payeesCount!=0) {
502             mainPayee = extractAddress(_data, 41);
503             mainExpectedAmount = int256(extractBytes32(_data, 61));
504         }
505 
506         // Generate the requestId
507         requestId = generateRequestId();
508 
509         // Store the new request
510         requests[requestId] = Request(payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
511 
512         // Declare the new request
513         Created(requestId, mainPayee, payer, creator, dataStr);
514 
515         // Store and declare the sub payees
516         for(uint8 i = 1; i < payeesCount; i = i.add(1)) {
517             address subPayeeAddress = extractAddress(_data, uint256(i).mul(52).add(41));
518 
519             // payees address cannot be 0x0
520             require(subPayeeAddress != 0);
521 
522             subPayees[requestId][i-1] =  Payee(subPayeeAddress, int256(extractBytes32(_data, uint256(i).mul(52).add(61))), 0);
523             NewSubPayee(requestId, subPayeeAddress);
524         }
525 
526         return requestId;
527     }
528 
529     /*
530      * @dev Function used by currency contracts to accept a request in the Core.
531      * @dev callable only by the currency contract of the request
532      * @param _requestId Request id
533      */ 
534     function accept(bytes32 _requestId) 
535         external
536     {
537         Request storage r = requests[_requestId];
538         require(r.currencyContract==msg.sender); 
539         r.state = State.Accepted;
540         Accepted(_requestId);
541     }
542 
543     /*
544      * @dev Function used by currency contracts to cancel a request in the Core. Several reasons can lead to cancel a request, see request life cycle for more info.
545      * @dev callable only by the currency contract of the request
546      * @param _requestId Request id
547      */ 
548     function cancel(bytes32 _requestId)
549         external
550     {
551         Request storage r = requests[_requestId];
552         require(r.currencyContract==msg.sender);
553         r.state = State.Canceled;
554         Canceled(_requestId);
555     }   
556 
557     /*
558      * @dev Function used to update the balance
559      * @dev callable only by the currency contract of the request
560      * @param _requestId Request id
561      * @param _payeeIndex index of the payee (0 = main payee)
562      * @param _deltaAmount modifier amount
563      */ 
564     function updateBalance(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
565         external
566     {   
567         Request storage r = requests[_requestId];
568         require(r.currencyContract==msg.sender);
569 
570         if( _payeeIndex == 0 ) {
571             // modify the main payee
572             r.payee.balance = r.payee.balance.add(_deltaAmount);
573         } else {
574             // modify the sub payee
575             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
576             sp.balance = sp.balance.add(_deltaAmount);
577         }
578         UpdateBalance(_requestId, _payeeIndex, _deltaAmount);
579     }
580 
581     /*
582      * @dev Function update the expectedAmount adding additional or subtract
583      * @dev callable only by the currency contract of the request
584      * @param _requestId Request id
585      * @param _payeeIndex index of the payee (0 = main payee)
586      * @param _deltaAmount modifier amount
587      */ 
588     function updateExpectedAmount(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
589         external
590     {   
591         Request storage r = requests[_requestId];
592         require(r.currencyContract==msg.sender); 
593 
594         if( _payeeIndex == 0 ) {
595             // modify the main payee
596             r.payee.expectedAmount = r.payee.expectedAmount.add(_deltaAmount);    
597         } else {
598             // modify the sub payee
599             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
600             sp.expectedAmount = sp.expectedAmount.add(_deltaAmount);
601         }
602         UpdateExpectedAmount(_requestId, _payeeIndex, _deltaAmount);
603     }
604 
605     /*
606      * @dev Internal: Init payees for a request (needed to avoid 'stack too deep' in createRequest())
607      * @param _requestId Request id
608      * @param _payees array of payees address
609      * @param _expectedAmounts array of payees initial expected amounts
610      */ 
611     function initSubPayees(bytes32 _requestId, address[] _payees, int256[] _expectedAmounts)
612         internal
613     {
614         require(_payees.length == _expectedAmounts.length);
615      
616         for (uint8 i = 1; i < _payees.length; i = i.add(1))
617         {
618             // payees address cannot be 0x0
619             require(_payees[i] != 0);
620             subPayees[_requestId][i-1] = Payee(_payees[i], _expectedAmounts[i], 0);
621             NewSubPayee(_requestId, _payees[i]);
622         }
623     }
624 
625 
626     /* GETTER */
627     /*
628      * @dev Get address of a payee
629      * @param _requestId Request id
630      * @param _payeeIndex payee index (0 = main payee)
631      * @return payee address
632      */ 
633     function getPayeeAddress(bytes32 _requestId, uint8 _payeeIndex)
634         public
635         constant
636         returns(address)
637     {
638         if(_payeeIndex == 0) {
639             return requests[_requestId].payee.addr;
640         } else {
641             return subPayees[_requestId][_payeeIndex-1].addr;
642         }
643     }
644 
645     /*
646      * @dev Get payer of a request
647      * @param _requestId Request id
648      * @return payer address
649      */ 
650     function getPayer(bytes32 _requestId)
651         public
652         constant
653         returns(address)
654     {
655         return requests[_requestId].payer;
656     }
657 
658     /*
659      * @dev Get amount expected of a payee
660      * @param _requestId Request id
661      * @param _payeeIndex payee index (0 = main payee)
662      * @return amount expected
663      */     
664     function getPayeeExpectedAmount(bytes32 _requestId, uint8 _payeeIndex)
665         public
666         constant
667         returns(int256)
668     {
669         if(_payeeIndex == 0) {
670             return requests[_requestId].payee.expectedAmount;
671         } else {
672             return subPayees[_requestId][_payeeIndex-1].expectedAmount;
673         }
674     }
675 
676     /*
677      * @dev Get number of subPayees for a request
678      * @param _requestId Request id
679      * @return number of subPayees
680      */     
681     function getSubPayeesCount(bytes32 _requestId)
682         public
683         constant
684         returns(uint8)
685     {
686         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
687             // nothing to do
688         }
689         return i;
690     }
691 
692     /*
693      * @dev Get currencyContract of a request
694      * @param _requestId Request id
695      * @return currencyContract address
696      */
697     function getCurrencyContract(bytes32 _requestId)
698         public
699         constant
700         returns(address)
701     {
702         return requests[_requestId].currencyContract;
703     }
704 
705     /*
706      * @dev Get balance of a payee
707      * @param _requestId Request id
708      * @param _payeeIndex payee index (0 = main payee)
709      * @return balance
710      */     
711     function getPayeeBalance(bytes32 _requestId, uint8 _payeeIndex)
712         public
713         constant
714         returns(int256)
715     {
716         if(_payeeIndex == 0) {
717             return requests[_requestId].payee.balance;    
718         } else {
719             return subPayees[_requestId][_payeeIndex-1].balance;
720         }
721     }
722 
723     /*
724      * @dev Get balance total of a request
725      * @param _requestId Request id
726      * @return balance
727      */     
728     function getBalance(bytes32 _requestId)
729         public
730         constant
731         returns(int256)
732     {
733         int256 balance = requests[_requestId].payee.balance;
734 
735         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
736         {
737             balance = balance.add(subPayees[_requestId][i].balance);
738         }
739 
740         return balance;
741     }
742 
743 
744     /*
745      * @dev check if all the payees balances are null
746      * @param _requestId Request id
747      * @return true if all the payees balances are equals to 0
748      */     
749     function areAllBalanceNull(bytes32 _requestId)
750         public
751         constant
752         returns(bool isNull)
753     {
754         isNull = requests[_requestId].payee.balance == 0;
755 
756         for (uint8 i = 0; isNull && subPayees[_requestId][i].addr != address(0); i = i.add(1))
757         {
758             isNull = subPayees[_requestId][i].balance == 0;
759         }
760 
761         return isNull;
762     }
763 
764     /*
765      * @dev Get total expectedAmount of a request
766      * @param _requestId Request id
767      * @return balance
768      */     
769     function getExpectedAmount(bytes32 _requestId)
770         public
771         constant
772         returns(int256)
773     {
774         int256 expectedAmount = requests[_requestId].payee.expectedAmount;
775 
776         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
777         {
778             expectedAmount = expectedAmount.add(subPayees[_requestId][i].expectedAmount);
779         }
780 
781         return expectedAmount;
782     }
783 
784     /*
785      * @dev Get state of a request
786      * @param _requestId Request id
787      * @return state
788      */ 
789     function getState(bytes32 _requestId)
790         public
791         constant
792         returns(State)
793     {
794         return requests[_requestId].state;
795     }
796 
797     /*
798      * @dev Get address of a payee
799      * @param _requestId Request id
800      * @return payee index (0 = main payee) or -1 if not address not found
801      */
802     function getPayeeIndex(bytes32 _requestId, address _address)
803         public
804         constant
805         returns(int16)
806     {
807         // return 0 if main payee
808         if(requests[_requestId].payee.addr == _address) return 0;
809 
810         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
811         {
812             if(subPayees[_requestId][i].addr == _address) {
813                 // if found return subPayee index + 1 (0 is main payee)
814                 return i+1;
815             }
816         }
817         return -1;
818     }
819 
820     /*
821      * @dev getter of a request
822      * @param _requestId Request id
823      * @return request as a tuple : (address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
824      */ 
825     function getRequest(bytes32 _requestId) 
826         external
827         constant
828         returns(address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
829     {
830         Request storage r = requests[_requestId];
831         return ( r.payer, 
832                  r.currencyContract, 
833                  r.state, 
834                  r.payee.addr, 
835                  r.payee.expectedAmount, 
836                  r.payee.balance );
837     }
838 
839     /*
840      * @dev extract a string from a bytes. Extracts a sub-part from tha bytes and convert it to string
841      * @param data bytes from where the string will be extracted
842      * @param size string size to extract
843      * @param _offset position of the first byte of the string in bytes
844      * @return string
845      */ 
846     function extractString(bytes data, uint8 size, uint _offset) 
847         internal 
848         pure 
849         returns (string) 
850     {
851         bytes memory bytesString = new bytes(size);
852         for (uint j = 0; j < size; j++) {
853             bytesString[j] = data[_offset+j];
854         }
855         return string(bytesString);
856     }
857 
858     /*
859      * @dev generate a new unique requestId
860      * @return a bytes32 requestId 
861      */ 
862     function generateRequestId()
863         internal
864         returns (bytes32)
865     {
866         // Update numRequest
867         numRequests = numRequests.add(1);
868         // requestId = ADDRESS_CONTRACT_CORE + numRequests (0xADRRESSCONTRACT00000NUMREQUEST)
869         return bytes32((uint256(this) << 96).add(numRequests));
870     }
871 
872     /*
873      * @dev extract an address from a bytes at a given position
874      * @param _data bytes from where the address will be extract
875      * @param _offset position of the first byte of the address
876      * @return address
877      */
878     function extractAddress(bytes _data, uint offset)
879         internal
880         pure
881         returns (address m)
882     {
883         require(offset >=0 && offset + 20 <= _data.length);
884         assembly {
885             m := and( mload(add(_data, add(20, offset))), 
886                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
887         }
888     }
889 
890     /*
891      * @dev extract a bytes32 from a bytes
892      * @param data bytes from where the bytes32 will be extract
893      * @param offset position of the first byte of the bytes32
894      * @return address
895      */
896     function extractBytes32(bytes _data, uint offset)
897         public
898         pure
899         returns (bytes32 bs)
900     {
901         require(offset >=0 && offset + 32 <= _data.length);
902         assembly {
903             bs := mload(add(_data, add(32, offset)))
904         }
905     }
906 
907     /**
908      * @dev transfer to owner any tokens send by mistake on this contracts
909      * @param token The address of the token to transfer.
910      * @param amount The amount to be transfered.
911      */
912     function emergencyERC20Drain(ERC20 token, uint amount )
913         public
914         onlyOwner 
915     {
916         token.transfer(owner, amount);
917     }
918 }
919 
920 /**
921  * @title RequestCollectInterface
922  *
923  * @dev RequestCollectInterface is a contract managing the fees for currency contracts
924  */
925 contract RequestCollectInterface is Pausable {
926     using SafeMath for uint256;
927 
928     uint256 public rateFeesNumerator;
929     uint256 public rateFeesDenominator;
930     uint256 public maxFees;
931 
932     // address of the contract that will burn req token (through Kyber)
933     address public requestBurnerContract;
934 
935     /*
936      *  Events 
937      */
938     event UpdateRateFees(uint256 rateFeesNumerator, uint256 rateFeesDenominator);
939     event UpdateMaxFees(uint256 maxFees);
940 
941     /*
942      * @dev Constructor
943      * @param _requestBurnerContract Address of the contract where to send the ethers. 
944      * This burner contract will have a function that can be called by anyone and will exchange ethers to req via Kyber and burn the REQ
945      */  
946     function RequestCollectInterface(address _requestBurnerContract) 
947         public
948     {
949         requestBurnerContract = _requestBurnerContract;
950     }
951 
952     /*
953      * @dev send fees to the request burning address
954      * @param _amount amount to send to the burning address
955      */  
956     function collectForREQBurning(uint256 _amount)
957         internal
958         returns(bool)
959     {
960         return requestBurnerContract.send(_amount);
961     }
962 
963     /*
964      * @dev compute the fees
965      * @param _expectedAmount amount expected for the request
966      * @return the expected amount of fees in wei
967      */  
968     function collectEstimation(int256 _expectedAmount)
969         public
970         view
971         returns(uint256)
972     {
973         if(_expectedAmount<0) return 0;
974 
975         uint256 computedCollect = uint256(_expectedAmount).mul(rateFeesNumerator);
976 
977         if(rateFeesDenominator != 0) {
978             computedCollect = computedCollect.div(rateFeesDenominator);
979         }
980 
981         return computedCollect < maxFees ? computedCollect : maxFees;
982     }
983 
984     /*
985      * @dev set the fees rate
986      * NB: if the _rateFeesDenominator is 0, it will be treated as 1. (in other words, the computation of the fees will not use it)
987      * @param _rateFeesNumerator        numerator rate
988      * @param _rateFeesDenominator      denominator rate
989      */  
990     function setRateFees(uint256 _rateFeesNumerator, uint256 _rateFeesDenominator)
991         external
992         onlyOwner
993     {
994         rateFeesNumerator = _rateFeesNumerator;
995         UpdateRateFees(_rateFeesNumerator, _rateFeesDenominator);
996     }
997 
998     /*
999      * @dev set the maximum fees in wei
1000      * @param _newMax new max
1001      */  
1002     function setMaxCollectable(uint256 _newMaxFees) 
1003         external
1004         onlyOwner
1005     {
1006         maxFees = _newMaxFees;
1007         UpdateMaxFees(_newMaxFees);
1008     }
1009 
1010     /*
1011      * @dev set the request burner address
1012      * @param _requestBurnerContract address of the contract that will burn req token (probably through Kyber)
1013      */  
1014     function setRequestBurnerContract(address _requestBurnerContract) 
1015         external
1016         onlyOwner
1017     {
1018         requestBurnerContract=_requestBurnerContract;
1019     }
1020 
1021 }
1022 
1023 /**
1024  * @title RequestCurrencyContractInterface
1025  *
1026  * @dev RequestCurrencyContractInterface is the currency contract managing the request in Ethereum
1027  * @dev The contract can be paused. In this case, nobody can create Requests anymore but people can still interact with them or withdraw funds.
1028  *
1029  * @dev Requests can be created by the Payee with createRequestAsPayee(), by the payer with createRequestAsPayer() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer
1030  */
1031 contract RequestCurrencyContractInterface is RequestCollectInterface {
1032     using SafeMath for uint256;
1033     using SafeMathInt for int256;
1034     using SafeMathUint8 for uint8;
1035 
1036     // RequestCore object
1037     RequestCore public requestCore;
1038 
1039     /*
1040      * @dev Constructor
1041      * @param _requestCoreAddress Request Core address
1042      */
1043     function RequestCurrencyContractInterface(address _requestCoreAddress, address _addressBurner) 
1044         RequestCollectInterface(_addressBurner)
1045         public
1046     {
1047         requestCore=RequestCore(_requestCoreAddress);
1048     }
1049 
1050     /*
1051      * @dev Base function for request creation
1052      *
1053      * @dev msg.sender will be the creator
1054      *
1055      * @param _payer Entity expected to pay
1056      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1057      * @param _expectedAmounts array of Expected amount to be received by each payees
1058      * @param _data Hash linking to additional data on the Request stored on IPFS
1059      *
1060      * @return Returns the id of the request and the sum of the expected amounts
1061      */
1062     function createCoreRequestInternal(
1063         address     _payer,
1064         address[]   _payeesIdAddress,
1065         int256[]    _expectedAmounts,
1066         string      _data)
1067         internal
1068         whenNotPaused
1069         returns(bytes32 requestId, int256 totalExpectedAmounts)
1070     {
1071         totalExpectedAmounts = 0;
1072         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1))
1073         {
1074             // all expected amounts must be positive
1075             require(_expectedAmounts[i]>=0);
1076             // compute the total expected amount of the request
1077             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1078         }
1079 
1080         // store request in the core
1081         requestId= requestCore.createRequest(msg.sender, _payeesIdAddress, _expectedAmounts, _payer, _data);
1082     }
1083 
1084     /*
1085      * @dev Function to accept a request
1086      *
1087      * @dev msg.sender must be _payer
1088      *
1089      * @param _requestId id of the request
1090      */
1091     function acceptAction(bytes32 _requestId)
1092         public
1093         whenNotPaused
1094         onlyRequestPayer(_requestId)
1095     {
1096         // only a created request can be accepted
1097         require(requestCore.getState(_requestId)==RequestCore.State.Created);
1098 
1099         // declare the acceptation in the core
1100         requestCore.accept(_requestId);
1101     }
1102 
1103 
1104     /*
1105      * @dev Function to cancel a request
1106      *
1107      * @dev msg.sender must be the _payer or the _payee.
1108      * @dev only request with balance equals to zero can be cancel
1109      *
1110      * @param _requestId id of the request
1111      */
1112     function cancelAction(bytes32 _requestId)
1113         public
1114         whenNotPaused
1115     {
1116         // payer can cancel if request is just created
1117         // payee can cancel when request is not canceled yet
1118         require((requestCore.getPayer(_requestId)==msg.sender && requestCore.getState(_requestId)==RequestCore.State.Created)
1119                 || (requestCore.getPayeeAddress(_requestId,0)==msg.sender && requestCore.getState(_requestId)!=RequestCore.State.Canceled));
1120 
1121         // impossible to cancel a Request with any payees balance != 0
1122         require(requestCore.areAllBalanceNull(_requestId));
1123 
1124         // declare the cancellation in the core
1125         requestCore.cancel(_requestId);
1126     }
1127 
1128 
1129     /*
1130      * @dev Function to declare additionals
1131      *
1132      * @dev msg.sender must be _payer
1133      * @dev the request must be accepted or created
1134      *
1135      * @param _requestId id of the request
1136      * @param _additionalAmounts amounts of additional to declare (index 0 is for main payee)
1137      */
1138     function additionalAction(bytes32 _requestId, uint256[] _additionalAmounts)
1139         public
1140         whenNotPaused
1141         onlyRequestPayer(_requestId)
1142     {
1143 
1144         // impossible to make additional if request is canceled
1145         require(requestCore.getState(_requestId)!=RequestCore.State.Canceled);
1146 
1147         // impossible to declare more additionals than the number of payees
1148         require(_additionalAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1));
1149 
1150         for(uint8 i = 0; i < _additionalAmounts.length; i = i.add(1)) {
1151             // no need to declare a zero as additional 
1152             if(_additionalAmounts[i] != 0) {
1153                 // Store and declare the additional in the core
1154                 requestCore.updateExpectedAmount(_requestId, i, _additionalAmounts[i].toInt256Safe());
1155             }
1156         }
1157     }
1158 
1159     /*
1160      * @dev Function to declare subtracts
1161      *
1162      * @dev msg.sender must be _payee
1163      * @dev the request must be accepted or created
1164      *
1165      * @param _requestId id of the request
1166      * @param _subtractAmounts amounts of subtract to declare (index 0 is for main payee)
1167      */
1168     function subtractAction(bytes32 _requestId, uint256[] _subtractAmounts)
1169         public
1170         whenNotPaused
1171         onlyRequestPayee(_requestId)
1172     {
1173         // impossible to make subtracts if request is canceled
1174         require(requestCore.getState(_requestId)!=RequestCore.State.Canceled);
1175 
1176         // impossible to declare more subtracts than the number of payees
1177         require(_subtractAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1));
1178 
1179         for(uint8 i = 0; i < _subtractAmounts.length; i = i.add(1)) {
1180             // no need to declare a zero as subtracts 
1181             if(_subtractAmounts[i] != 0) {
1182                 // subtract must be equal or lower than amount expected
1183                 require(requestCore.getPayeeExpectedAmount(_requestId,i) >= _subtractAmounts[i].toInt256Safe());
1184                 // Store and declare the subtract in the core
1185                 requestCore.updateExpectedAmount(_requestId, i, -_subtractAmounts[i].toInt256Safe());
1186             }
1187         }
1188     }
1189     // ----------------------------------------------------------------------------------------
1190 
1191     /*
1192      * @dev Modifier to check if msg.sender is the main payee
1193      * @dev Revert if msg.sender is not the main payee
1194      * @param _requestId id of the request
1195      */ 
1196     modifier onlyRequestPayee(bytes32 _requestId)
1197     {
1198         require(requestCore.getPayeeAddress(_requestId, 0)==msg.sender);
1199         _;
1200     }
1201 
1202     /*
1203      * @dev Modifier to check if msg.sender is payer
1204      * @dev Revert if msg.sender is not payer
1205      * @param _requestId id of the request
1206      */ 
1207     modifier onlyRequestPayer(bytes32 _requestId)
1208     {
1209         require(requestCore.getPayer(_requestId)==msg.sender);
1210         _;
1211     }
1212 }
1213 
1214 
1215 /**
1216  * @title RequestERC20
1217  *
1218  * @dev RequestERC20 is the currency contract managing the request in ERC20 token
1219  * @dev The contract can be paused. In this case, nobody can create Requests anymore but people can still interact with them or withdraw funds.
1220  *
1221  * @dev Requests can be created by the Payee with createRequestAsPayee(), by the payer with createRequestAsPayer() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer
1222  */
1223 contract RequestERC20 is RequestCurrencyContractInterface {
1224     using SafeMath for uint256;
1225     using SafeMathInt for int256;
1226     using SafeMathUint8 for uint8;
1227 
1228     // payment addresses by requestId (optional). We separate the Identity of the payee/payer (in the core) and the wallet address in the currency contract
1229     mapping(bytes32 => address[256]) public payeesPaymentAddress;
1230     mapping(bytes32 => address) public payerRefundAddress;
1231 
1232     // token address
1233     ERC20 public erc20Token;
1234 
1235     /*
1236      * @dev Constructor
1237      * @param _requestCoreAddress Request Core address
1238      * @param _requestBurnerAddress Request Burner contract address
1239      * @param _erc20Token ERC20 token contract handled by this currency contract
1240      */
1241     function RequestERC20(address _requestCoreAddress, address _requestBurnerAddress, ERC20 _erc20Token) 
1242         RequestCurrencyContractInterface(_requestCoreAddress, _requestBurnerAddress)
1243         public
1244     {
1245         erc20Token = _erc20Token;
1246     }
1247 
1248     /*
1249      * @dev Function to create a request as payee
1250      *
1251      * @dev msg.sender must be the main payee
1252      * @dev if _payeesPaymentAddress.length > _payeesIdAddress.length, the extra addresses will be stored but never used
1253      *
1254      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1255      * @param _payeesPaymentAddress array of payees address for payment (optional)
1256      * @param _expectedAmounts array of Expected amount to be received by each payees
1257      * @param _payer Entity expected to pay
1258      * @param _payerRefundAddress Address of refund for the payer (optional)
1259      * @param _data Hash linking to additional data on the Request stored on IPFS
1260      *
1261      * @return Returns the id of the request
1262      */
1263     function createRequestAsPayeeAction(
1264         address[]   _payeesIdAddress,
1265         address[]   _payeesPaymentAddress,
1266         int256[]    _expectedAmounts,
1267         address     _payer,
1268         address     _payerRefundAddress,
1269         string      _data)
1270         external
1271         payable
1272         whenNotPaused
1273         returns(bytes32 requestId)
1274     {
1275         require(msg.sender == _payeesIdAddress[0] && msg.sender != _payer && _payer != 0);
1276 
1277         int256 totalExpectedAmounts;
1278         (requestId, totalExpectedAmounts) = createCoreRequestInternal(_payer, _payeesIdAddress, _expectedAmounts, _data);
1279         
1280         // compute and send fees
1281         uint256 fees = collectEstimation(totalExpectedAmounts);
1282         require(fees == msg.value && collectForREQBurning(fees));
1283 
1284         // set payment addresses for payees
1285         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1286             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1287         }
1288         // set payment address for payer
1289         if(_payerRefundAddress != 0) {
1290             payerRefundAddress[requestId] = _payerRefundAddress;
1291         }
1292 
1293         return requestId;
1294     }
1295 
1296 
1297     /*
1298      * @dev Function to create a request as payer. The request is payed if _payeeAmounts > 0.
1299      *
1300      * @dev msg.sender will be the payer
1301      * @dev If a contract is given as a payee make sure it is payable. Otherwise, the request will not be payable.
1302      *
1303      * @param _payeesIdAddress array of payees address (the index 0 will be the payee the others are subPayees)
1304      * @param _expectedAmounts array of Expected amount to be received by each payees
1305      * @param _payerRefundAddress Address of refund for the payer (optional)
1306      * @param _payeeAmounts array of amount repartition for the payment
1307      * @param _additionals array to increase the ExpectedAmount for payees
1308      * @param _data Hash linking to additional data on the Request stored on IPFS
1309      *
1310      * @return Returns the id of the request
1311      */
1312     function createRequestAsPayerAction(
1313         address[]   _payeesIdAddress,
1314         int256[]    _expectedAmounts,
1315         address     _payerRefundAddress,
1316         uint256[]   _payeeAmounts,
1317         uint256[]   _additionals,
1318         string      _data)
1319         external
1320         payable
1321         whenNotPaused
1322         returns(bytes32 requestId)
1323     {
1324         require(msg.sender != _payeesIdAddress[0] && _payeesIdAddress[0] != 0);
1325 
1326         int256 totalExpectedAmounts;
1327         (requestId, totalExpectedAmounts) = createCoreRequestInternal(msg.sender, _payeesIdAddress, _expectedAmounts, _data);
1328 
1329         // set payment address for payer
1330         if(_payerRefundAddress != 0) {
1331             payerRefundAddress[requestId] = _payerRefundAddress;
1332         }
1333 
1334         // accept and pay the request with the value remaining after the fee collect
1335         acceptAndPay(requestId, _payeeAmounts, _additionals, totalExpectedAmounts);
1336 
1337         return requestId;
1338     }
1339 
1340     /*
1341      * @dev Function to broadcast and accept an offchain signed request (the broadcaster can also pays and makes additionals )
1342      *
1343      * @dev msg.sender will be the _payer
1344      * @dev only the _payer can make additionals
1345      * @dev if _payeesPaymentAddress.length > _requestData.payeesIdAddress.length, the extra addresses will be stored but never used
1346      *
1347      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1348      * @param _payeesPaymentAddress array of payees address for payment (optional) 
1349      * @param _payeeAmounts array of amount repartition for the payment
1350      * @param _additionals array to increase the ExpectedAmount for payees
1351      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1352      * @param _signature ECDSA signature in bytes
1353      *
1354      * @return Returns the id of the request
1355      */
1356     function broadcastSignedRequestAsPayerAction(
1357         bytes       _requestData, // gather data to avoid "stack too deep"
1358         address[]   _payeesPaymentAddress,
1359         uint256[]   _payeeAmounts,
1360         uint256[]   _additionals,
1361         uint256     _expirationDate,
1362         bytes       _signature)
1363         external
1364         payable
1365         whenNotPaused
1366         returns(bytes32 requestId)
1367     {
1368         // check expiration date
1369         require(_expirationDate >= block.timestamp);
1370 
1371         // check the signature
1372         require(checkRequestSignature(_requestData, _payeesPaymentAddress, _expirationDate, _signature));
1373 
1374         return createAcceptAndPayFromBytes(_requestData, _payeesPaymentAddress, _payeeAmounts, _additionals);
1375     }
1376 
1377     /*
1378      * @dev Internal function to create, accept, add additionals and pay a request as Payer
1379      *
1380      * @dev msg.sender must be _payer
1381      *
1382      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1383      * @param _payeesPaymentAddress array of payees address for payment (optional)
1384      * @param _payeeAmounts array of amount repartition for the payment
1385      * @param _additionals Will increase the ExpectedAmount of the request right after its creation by adding additionals
1386      *
1387      * @return Returns the id of the request
1388      */
1389     function createAcceptAndPayFromBytes(
1390         bytes       _requestData,
1391         address[]   _payeesPaymentAddress,
1392         uint256[]   _payeeAmounts,
1393         uint256[]   _additionals)
1394         internal
1395         returns(bytes32 requestId)
1396     {
1397         // extract main payee
1398         address mainPayee = extractAddress(_requestData, 41);
1399         require(msg.sender != mainPayee && mainPayee != 0);
1400         // creator must be the main payee
1401         require(extractAddress(_requestData, 0) == mainPayee);
1402 
1403         // extract the number of payees
1404         uint8 payeesCount = uint8(_requestData[40]);
1405         int256 totalExpectedAmounts = 0;
1406         for(uint8 i = 0; i < payeesCount; i++) {
1407             // extract the expectedAmount for the payee[i]
1408             int256 expectedAmountTemp = int256(extractBytes32(_requestData, uint256(i).mul(52).add(61)));
1409             // compute the total expected amount of the request
1410             totalExpectedAmounts = totalExpectedAmounts.add(expectedAmountTemp);
1411             // all expected amount must be positive
1412             require(expectedAmountTemp>0);
1413         }
1414 
1415         // compute and send fees
1416         uint256 fees = collectEstimation(totalExpectedAmounts);
1417         // check fees has been well received
1418         require(fees == msg.value && collectForREQBurning(fees));
1419 
1420         // insert the msg.sender as the payer in the bytes
1421         updateBytes20inBytes(_requestData, 20, bytes20(msg.sender));
1422         // store request in the core
1423         requestId = requestCore.createRequestFromBytes(_requestData);
1424         
1425         // set payment addresses for payees
1426         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1427             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1428         }
1429 
1430         // accept and pay the request with the value remaining after the fee collect
1431         acceptAndPay(requestId, _payeeAmounts, _additionals, totalExpectedAmounts);
1432 
1433         return requestId;
1434     }
1435 
1436     /*
1437      * @dev Internal function to accept, add additionals and pay a request as Payer
1438      *
1439      * @param _requestId id of the request
1440      * @param _payeesAmounts Amount to pay to payees (sum must be equals to _amountPaid)
1441      * @param _additionals Will increase the ExpectedAmounts of payees
1442      * @param _payeeAmountsSum total of amount token send for this transaction
1443      *
1444      */ 
1445     function acceptAndPay(
1446         bytes32 _requestId,
1447         uint256[] _payeeAmounts,
1448         uint256[] _additionals,
1449         int256 _payeeAmountsSum)
1450         internal
1451     {
1452         acceptAction(_requestId);
1453         
1454         additionalAction(_requestId, _additionals);
1455 
1456         if(_payeeAmountsSum > 0) {
1457             paymentInternal(_requestId, _payeeAmounts);
1458         }
1459     }
1460 
1461     /*
1462      * @dev Function to pay a request in ERC20 token
1463      *
1464      * @dev msg.sender must have a balance of the token higher or equal to the sum of _payeeAmounts
1465      * @dev msg.sender must have approved an amount of the token higher or equal to the sum of _payeeAmounts to the current contract
1466      * @dev the request will be automatically accepted if msg.sender==payer. 
1467      *
1468      * @param _requestId id of the request
1469      * @param _payeeAmounts Amount to pay to payees (sum must be equal to msg.value) in wei
1470      * @param _additionalAmounts amount of additionals per payee in wei to declare
1471      */
1472     function paymentAction(
1473         bytes32 _requestId,
1474         uint256[] _payeeAmounts,
1475         uint256[] _additionalAmounts)
1476         external
1477         whenNotPaused
1478     {
1479         // automatically accept request if request is created and msg.sender is payer
1480         if (requestCore.getState(_requestId)==RequestCore.State.Created && msg.sender == requestCore.getPayer(_requestId)) {
1481             acceptAction(_requestId);
1482         }
1483 
1484         if (_additionalAmounts.length != 0) {
1485             additionalAction(_requestId, _additionalAmounts);
1486         }
1487 
1488         paymentInternal(_requestId, _payeeAmounts);
1489     }
1490 
1491 
1492     /*
1493      * @dev Function to pay back in ERC20 token a request to the payees
1494      *
1495      * @dev msg.sender must have a balance of the token higher or equal to _amountToRefund
1496      * @dev msg.sender must have approved an amount of the token higher or equal to _amountToRefund to the current contract
1497      * @dev msg.sender must be one of the payees or one of the payees payment address
1498      * @dev the request must be created or accepted
1499      *
1500      * @param _requestId id of the request
1501      */
1502     function refundAction(bytes32 _requestId, uint256 _amountToRefund)
1503         external
1504         whenNotPaused
1505     {
1506         refundInternal(_requestId, msg.sender, _amountToRefund);
1507     }
1508 
1509 
1510     // ---- INTERNAL FUNCTIONS ----------------------------------------------------------------
1511     /*
1512      * @dev Function internal to manage payment declaration
1513      *
1514      * @param _requestId id of the request
1515      * @param _payeesAmounts Amount to pay to payees (sum must be equals to msg.value)
1516      */
1517     function paymentInternal(
1518         bytes32     _requestId,
1519         uint256[]   _payeeAmounts)
1520         internal
1521     {
1522         require(requestCore.getState(_requestId)!=RequestCore.State.Canceled);
1523 
1524         // we cannot have more amounts declared than actual payees
1525         require(_payeeAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1));
1526 
1527         for(uint8 i = 0; i < _payeeAmounts.length; i = i.add(1)) {
1528             if(_payeeAmounts[i] != 0) {
1529                 // Store and declare the payment to the core
1530                 requestCore.updateBalance(_requestId, i, _payeeAmounts[i].toInt256Safe());
1531 
1532                 // pay the payment address if given, the id address otherwise
1533                 address addressToPay;
1534                 if(payeesPaymentAddress[_requestId][i] == 0) {
1535                     addressToPay = requestCore.getPayeeAddress(_requestId, i);
1536                 } else {
1537                     addressToPay = payeesPaymentAddress[_requestId][i];
1538                 }
1539 
1540                 // payment done, the token need to be sent
1541                 fundOrderInternal(msg.sender, addressToPay, _payeeAmounts[i]);
1542             }
1543         }
1544     }
1545 
1546 
1547     /*
1548      * @dev Function internal to manage refund declaration
1549      *
1550      * @param _requestId id of the request
1551      * @param _address address from where the refund has been done
1552      * @param _amount amount of the refund in ERC20 token to declare
1553      */
1554     function refundInternal(
1555         bytes32 _requestId,
1556         address _address,
1557         uint256 _amount)
1558         internal
1559     {
1560         require(requestCore.getState(_requestId)!=RequestCore.State.Canceled);
1561 
1562         // Check if the _address is a payeesId
1563         int16 payeeIndex = requestCore.getPayeeIndex(_requestId, _address);
1564 
1565         // get the number of payees
1566         uint8 payeesCount = requestCore.getSubPayeesCount(_requestId).add(1);
1567 
1568         if(payeeIndex < 0) {
1569             // if not ID addresses maybe in the payee payments addresses
1570             for (uint8 i = 0; i < payeesCount && payeeIndex == -1; i = i.add(1))
1571             {
1572                 if(payeesPaymentAddress[_requestId][i] == _address) {
1573                     // get the payeeIndex
1574                     payeeIndex = int16(i);
1575                 }
1576             }
1577         }
1578         // the address must be found somewhere
1579         require(payeeIndex >= 0); 
1580 
1581         // useless (subPayee size <256): require(payeeIndex < 265);
1582         requestCore.updateBalance(_requestId, uint8(payeeIndex), -_amount.toInt256Safe());
1583 
1584         // refund to the payment address if given, the id address otherwise
1585         address addressToPay = payerRefundAddress[_requestId];
1586         if(addressToPay == 0) {
1587             addressToPay = requestCore.getPayer(_requestId);
1588         }
1589 
1590         // refund declared, the money is ready to be sent to the payer
1591         fundOrderInternal(_address, addressToPay, _amount);
1592     }
1593 
1594     /*
1595      * @dev Function internal to manage fund mouvement
1596      *
1597      * @param _from address where the token will get from
1598      * @param _recipient address where the token has to be sent to
1599      * @param _amount amount in ERC20 token to send
1600      */
1601     function fundOrderInternal(
1602         address _from,
1603         address _recipient,
1604         uint256 _amount)
1605         internal
1606     {   
1607         require(erc20Token.transferFrom(_from, _recipient, _amount));
1608     }
1609     // -----------------------------------------------------------------------------
1610 
1611     /*
1612      * @dev Check the validity of a signed request & the expiration date
1613      * @param _data bytes containing all the data packed :
1614             address(creator)
1615             address(payer)
1616             uint8(number_of_payees)
1617             [
1618                 address(main_payee_address)
1619                 int256(main_payee_expected_amount)
1620                 address(second_payee_address)
1621                 int256(second_payee_expected_amount)
1622                 ...
1623             ]
1624             uint8(data_string_size)
1625             size(data)
1626      * @param _payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
1627      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1628      * @param _signature ECDSA signature containing v, r and s as bytes
1629      *
1630      * @return Validity of order signature.
1631      */ 
1632     function checkRequestSignature(
1633         bytes       _requestData,
1634         address[]   _payeesPaymentAddress,
1635         uint256     _expirationDate,
1636         bytes       _signature)
1637         public
1638         view
1639         returns (bool)
1640     {
1641         bytes32 hash = getRequestHash(_requestData, _payeesPaymentAddress, _expirationDate);
1642 
1643         // extract "v, r, s" from the signature
1644         uint8 v = uint8(_signature[64]);
1645         v = v < 27 ? v.add(27) : v;
1646         bytes32 r = extractBytes32(_signature, 0);
1647         bytes32 s = extractBytes32(_signature, 32);
1648 
1649         // check signature of the hash with the creator address
1650         return isValidSignature(extractAddress(_requestData, 0), hash, v, r, s);
1651     }
1652 
1653     /*
1654      * @dev Function internal to calculate Keccak-256 hash of a request with specified parameters
1655      *
1656      * @param _data bytes containing all the data packed
1657      * @param _payeesPaymentAddress array of payees payment addresses
1658      * @param _expirationDate timestamp after what the signed request cannot be broadcasted
1659      *
1660      * @return Keccak-256 hash of (this,_requestData, _payeesPaymentAddress, _expirationDate)
1661      */
1662     function getRequestHash(
1663         bytes       _requestData,
1664         address[]   _payeesPaymentAddress,
1665         uint256     _expirationDate)
1666         internal
1667         view
1668         returns(bytes32)
1669     {
1670         return keccak256(this,_requestData, _payeesPaymentAddress, _expirationDate);
1671     }
1672 
1673     /*
1674      * @dev Verifies that a hash signature is valid. 0x style
1675      * @param signer address of signer.
1676      * @param hash Signed Keccak-256 hash.
1677      * @param v ECDSA signature parameter v.
1678      * @param r ECDSA signature parameters r.
1679      * @param s ECDSA signature parameters s.
1680      * @return Validity of order signature.
1681      */
1682     function isValidSignature(
1683         address signer,
1684         bytes32 hash,
1685         uint8   v,
1686         bytes32 r,
1687         bytes32 s)
1688         public
1689         pure
1690         returns (bool)
1691     {
1692         return signer == ecrecover(
1693             keccak256("\x19Ethereum Signed Message:\n32", hash),
1694             v,
1695             r,
1696             s
1697         );
1698     }
1699 
1700     /*
1701      * @dev extract an address in a bytes
1702      * @param data bytes from where the address will be extract
1703      * @param offset position of the first byte of the address
1704      * @return address
1705      */
1706     function extractAddress(bytes _data, uint offset)
1707         internal
1708         pure
1709         returns (address m) 
1710     {
1711         require(offset >=0 && offset + 20 <= _data.length);
1712         assembly {
1713             m := and( mload(add(_data, add(20, offset))), 
1714                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1715         }
1716     }
1717 
1718     /*
1719      * @dev extract a bytes32 from a bytes
1720      * @param data bytes from where the bytes32 will be extract
1721      * @param offset position of the first byte of the bytes32
1722      * @return address
1723      */
1724     function extractBytes32(bytes _data, uint offset)
1725         public
1726         pure
1727         returns (bytes32 bs)
1728     {
1729         require(offset >=0 && offset + 32 <= _data.length);
1730         assembly {
1731             bs := mload(add(_data, add(32, offset)))
1732         }
1733     }
1734 
1735     /*
1736      * @dev modify 20 bytes in a bytes
1737      * @param data bytes to modify
1738      * @param offset position of the first byte to modify
1739      * @param b bytes20 to insert
1740      * @return address
1741      */
1742     function updateBytes20inBytes(bytes data, uint offset, bytes20 b)
1743         internal
1744         pure
1745     {
1746         require(offset >=0 && offset + 20 <= data.length);
1747         assembly {
1748             let m := mload(add(data, add(20, offset)))
1749             m := and(m, 0xFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000)
1750             m := or(m, div(b, 0x1000000000000000000000000))
1751             mstore(add(data, add(20, offset)), m)
1752         }
1753     }
1754 }