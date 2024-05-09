1 pragma solidity 0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a * b;
99 
100     assert(a == 0 || c / a == b);
101     return c;
102   }
103 
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 
122   function toInt256Safe(uint256 a) internal pure returns (int256) {
123     int256 b = int256(a);
124     assert(b >= 0);
125     return b;
126   }
127 }
128 
129 
130 /**
131  * @title SafeMathInt
132  * @dev Math operations with safety checks that throw on error
133  * @dev SafeMath adapted for int256
134  */
135 library SafeMathInt {
136   function mul(int256 a, int256 b) internal pure returns (int256) {
137     // Prevent overflow when multiplying INT256_MIN with -1
138     // https://github.com/RequestNetwork/requestNetwork/issues/43
139     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
140 
141     int256 c = a * b;
142     assert((b == 0) || (c / b == a));
143     return c;
144   }
145 
146   function div(int256 a, int256 b) internal pure returns (int256) {
147     // Prevent overflow when dividing INT256_MIN by -1
148     // https://github.com/RequestNetwork/requestNetwork/issues/43
149     assert(!(a == - 2**255 && b == -1));
150 
151     // assert(b > 0); // Solidity automatically throws when dividing by 0
152     int256 c = a / b;
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154     return c;
155   }
156 
157   function sub(int256 a, int256 b) internal pure returns (int256) {
158     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
159 
160     return a - b;
161   }
162 
163   function add(int256 a, int256 b) internal pure returns (int256) {
164     int256 c = a + b;
165     assert((b >= 0 && c >= a) || (b < 0 && c < a));
166     return c;
167   }
168 
169   function toUint256Safe(int256 a) internal pure returns (uint256) {
170     assert(a>=0);
171     return uint256(a);
172   }
173 }
174 
175 /**
176  * @title SafeMath
177  * @dev Math operations with safety checks that throw on error
178  * @dev SafeMath adapted for uint8
179  */
180 library SafeMathUint8 {
181   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
182     uint8 c = a * b;
183     assert(a == 0 || c / a == b);
184     return c;
185   }
186 
187   function div(uint8 a, uint8 b) internal pure returns (uint8) {
188     // assert(b > 0); // Solidity automatically throws when dividing by 0
189     uint8 c = a / b;
190     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191     return c;
192   }
193 
194   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
195     assert(b <= a);
196     return a - b;
197   }
198 
199   function add(uint8 a, uint8 b) internal pure returns (uint8) {
200     uint8 c = a + b;
201     assert(c >= a);
202     return c;
203   }
204 }
205 
206 /**
207  * @title SafeMath
208  * @dev Math operations with safety checks that throw on error
209  * @dev SafeMath adapted for uint96
210  */
211 library SafeMathUint96 {
212   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
213     uint96 c = a * b;
214     assert(a == 0 || c / a == b);
215     return c;
216   }
217 
218   function div(uint96 a, uint96 b) internal pure returns (uint96) {
219     // assert(b > 0); // Solidity automatically throws when dividing by 0
220     uint96 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222     return c;
223   }
224 
225   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
226     assert(b <= a);
227     return a - b;
228   }
229 
230   function add(uint96 a, uint96 b) internal pure returns (uint96) {
231     uint96 c = a + b;
232     assert(c >= a);
233     return c;
234   }
235 }
236 
237 /**
238  * @title ERC20Basic
239  * @dev Simpler version of ERC20 interface
240  * @dev see https://github.com/ethereum/EIPs/issues/179
241  */
242 contract ERC20Basic {
243   uint256 public totalSupply;
244   function balanceOf(address who) public constant returns (uint256);
245   function transfer(address to, uint256 value) public returns (bool);
246   event Transfer(address indexed from, address indexed to, uint256 value);
247 }
248 
249 
250 /**
251  * @title ERC20 interface
252  * @dev see https://github.com/ethereum/EIPs/issues/20
253  */
254 contract ERC20 is ERC20Basic {
255   function allowance(address owner, address spender) public constant returns (uint256);
256   function transferFrom(address from, address to, uint256 value) public returns (bool);
257   function approve(address spender, uint256 value) public returns (bool);
258   event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 
262 /**
263  * @title Administrable
264  * @dev Base contract for the administration of Core. Handles whitelisting of currency contracts
265  */
266 contract Administrable is Pausable {
267 
268     // mapping of address of trusted contract
269     mapping(address => uint8) public trustedCurrencyContracts;
270 
271     // Events of the system
272     event NewTrustedContract(address newContract);
273     event RemoveTrustedContract(address oldContract);
274 
275     /**
276      * @dev add a trusted currencyContract 
277      *
278      * @param _newContractAddress The address of the currencyContract
279      */
280     function adminAddTrustedCurrencyContract(address _newContractAddress)
281         external
282         onlyOwner
283     {
284         trustedCurrencyContracts[_newContractAddress] = 1; //Using int instead of boolean in case we need several states in the future.
285         NewTrustedContract(_newContractAddress);
286     }
287 
288     /**
289      * @dev remove a trusted currencyContract 
290      *
291      * @param _oldTrustedContractAddress The address of the currencyContract
292      */
293     function adminRemoveTrustedCurrencyContract(address _oldTrustedContractAddress)
294         external
295         onlyOwner
296     {
297         require(trustedCurrencyContracts[_oldTrustedContractAddress] != 0);
298         trustedCurrencyContracts[_oldTrustedContractAddress] = 0;
299         RemoveTrustedContract(_oldTrustedContractAddress);
300     }
301 
302     /**
303      * @dev get the status of a trusted currencyContract 
304      * @dev Not used today, useful if we have several states in the future.
305      *
306      * @param _contractAddress The address of the currencyContract
307      * @return The status of the currencyContract. If trusted 1, otherwise 0
308      */
309     function getStatusContract(address _contractAddress)
310         view
311         external
312         returns(uint8) 
313     {
314         return trustedCurrencyContracts[_contractAddress];
315     }
316 
317     /**
318      * @dev check if a currencyContract is trusted
319      *
320      * @param _contractAddress The address of the currencyContract
321      * @return bool true if contract is trusted
322      */
323     function isTrustedContract(address _contractAddress)
324         public
325         view
326         returns(bool)
327     {
328         return trustedCurrencyContracts[_contractAddress] == 1;
329     }
330 }
331 
332 /**
333  * @title RequestCore
334  *
335  * @dev The Core is the main contract which stores all the requests.
336  *
337  * @dev The Core philosophy is to be as much flexible as possible to adapt in the future to any new system
338  * @dev All the important conditions and an important part of the business logic takes place in the currency contracts.
339  * @dev Requests can only be created in the currency contracts
340  * @dev Currency contracts have to be allowed by the Core and respect the business logic.
341  * @dev Request Network will develop one currency contracts per currency and anyone can creates its own currency contracts.
342  */
343 contract RequestCore is Administrable {
344     using SafeMath for uint256;
345     using SafeMathUint96 for uint96;
346     using SafeMathInt for int256;
347     using SafeMathUint8 for uint8;
348 
349     enum State { Created, Accepted, Canceled }
350 
351     struct Request {
352         // ID address of the payer
353         address payer;
354 
355         // Address of the contract managing the request
356         address currencyContract;
357 
358         // State of the request
359         State state;
360 
361         // Main payee
362         Payee payee;
363     }
364 
365     // Structure for the payees. A sub payee is an additional entity which will be paid during the processing of the invoice.
366     // ex: can be used for routing taxes or fees at the moment of the payment.
367     struct Payee {
368         // ID address of the payee
369         address addr;
370 
371         // amount expected for the payee. 
372         // Not uint for evolution (may need negative amounts one day), and simpler operations
373         int256 expectedAmount;
374 
375         // balance of the payee
376         int256 balance;
377     }
378 
379     // Count of request in the mapping. A maximum of 2^96 requests can be created per Core contract.
380     // Integer, incremented for each request of a Core contract, starting from 0
381     // RequestId (256bits) = contract address (160bits) + numRequest
382     uint96 public numRequests; 
383     
384     // Mapping of all the Requests. The key is the request ID.
385     // not anymore public to avoid "UnimplementedFeatureError: Only in-memory reference type can be stored."
386     // https://github.com/ethereum/solidity/issues/3577
387     mapping(bytes32 => Request) requests;
388 
389     // Mapping of subPayees of the requests. The key is the request ID.
390     // This array is outside the Request structure to optimize the gas cost when there is only 1 payee.
391     mapping(bytes32 => Payee[256]) public subPayees;
392 
393     /*
394      *  Events 
395      */
396     event Created(bytes32 indexed requestId, address indexed payee, address indexed payer, address creator, string data);
397     event Accepted(bytes32 indexed requestId);
398     event Canceled(bytes32 indexed requestId);
399 
400     // Event for Payee & subPayees
401     event NewSubPayee(bytes32 indexed requestId, address indexed payee); // Separated from the Created Event to allow a 4th indexed parameter (subpayees)
402     event UpdateExpectedAmount(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
403     event UpdateBalance(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
404 
405     /*
406      * @dev Function used by currency contracts to create a request in the Core
407      *
408      * @dev _payees and _expectedAmounts must have the same size
409      *
410      * @param _creator Request creator. The creator is the one who initiated the request (create or sign) and not necessarily the one who broadcasted it
411      * @param _payees array of payees address (the index 0 will be the payee the others are subPayees). Size must be smaller than 256.
412      * @param _expectedAmounts array of Expected amount to be received by each payees. Must be in same order than the payees. Size must be smaller than 256.
413      * @param _payer Entity expected to pay
414      * @param _data data of the request
415      * @return Returns the id of the request
416      */
417     function createRequest(
418         address     _creator,
419         address[]   _payees,
420         int256[]    _expectedAmounts,
421         address     _payer,
422         string      _data)
423         external
424         whenNotPaused 
425         returns (bytes32 requestId) 
426     {
427         // creator must not be null
428         require(_creator!=0); // not as modifier to lighten the stack
429         // call must come from a trusted contract
430         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
431 
432         // Generate the requestId
433         requestId = generateRequestId();
434 
435         address mainPayee;
436         int256 mainExpectedAmount;
437         // extract the main payee if filled
438         if(_payees.length!=0) {
439             mainPayee = _payees[0];
440             mainExpectedAmount = _expectedAmounts[0];
441         }
442 
443         // Store the new request
444         requests[requestId] = Request(_payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
445 
446         // Declare the new request
447         Created(requestId, mainPayee, _payer, _creator, _data);
448         
449         // Store and declare the sub payees (needed in internal function to avoid "stack too deep")
450         initSubPayees(requestId, _payees, _expectedAmounts);
451 
452         return requestId;
453     }
454 
455     /*
456      * @dev Function used by currency contracts to create a request in the Core from bytes
457      * @dev Used to avoid receiving a stack too deep error when called from a currency contract with too many parameters.
458      * @audit Note that to optimize the stack size and the gas cost we do not extract the params and store them in the stack. As a result there is some code redundancy
459      * @param _data bytes containing all the data packed :
460             address(creator)
461             address(payer)
462             uint8(number_of_payees)
463             [
464                 address(main_payee_address)
465                 int256(main_payee_expected_amount)
466                 address(second_payee_address)
467                 int256(second_payee_expected_amount)
468                 ...
469             ]
470             uint8(data_string_size)
471             size(data)
472      * @return Returns the id of the request 
473      */ 
474     function createRequestFromBytes(bytes _data) 
475         external
476         whenNotPaused 
477         returns (bytes32 requestId) 
478     {
479         // call must come from a trusted contract
480         require(isTrustedContract(msg.sender)); // not as modifier to lighten the stack
481 
482         // extract address creator & payer
483         address creator = extractAddress(_data, 0);
484 
485         address payer = extractAddress(_data, 20);
486 
487         // creator must not be null
488         require(creator!=0);
489         
490         // extract the number of payees
491         uint8 payeesCount = uint8(_data[40]);
492 
493         // get the position of the dataSize in the byte (= number_of_payees * (address_payee_size + int256_payee_size) + address_creator_size + address_payer_size + payees_count_size
494         //                                              (= number_of_payees * (20+32) + 20 + 20 + 1 )
495         uint256 offsetDataSize = uint256(payeesCount).mul(52).add(41);
496 
497         // extract the data size and then the data itself
498         uint8 dataSize = uint8(_data[offsetDataSize]);
499         string memory dataStr = extractString(_data, dataSize, offsetDataSize.add(1));
500 
501         address mainPayee;
502         int256 mainExpectedAmount;
503         // extract the main payee if possible
504         if(payeesCount!=0) {
505             mainPayee = extractAddress(_data, 41);
506             mainExpectedAmount = int256(extractBytes32(_data, 61));
507         }
508 
509         // Generate the requestId
510         requestId = generateRequestId();
511 
512         // Store the new request
513         requests[requestId] = Request(payer, msg.sender, State.Created, Payee(mainPayee, mainExpectedAmount, 0));
514 
515         // Declare the new request
516         Created(requestId, mainPayee, payer, creator, dataStr);
517 
518         // Store and declare the sub payees
519         for(uint8 i = 1; i < payeesCount; i = i.add(1)) {
520             address subPayeeAddress = extractAddress(_data, uint256(i).mul(52).add(41));
521 
522             // payees address cannot be 0x0
523             require(subPayeeAddress != 0);
524 
525             subPayees[requestId][i-1] =  Payee(subPayeeAddress, int256(extractBytes32(_data, uint256(i).mul(52).add(61))), 0);
526             NewSubPayee(requestId, subPayeeAddress);
527         }
528 
529         return requestId;
530     }
531 
532     /*
533      * @dev Function used by currency contracts to accept a request in the Core.
534      * @dev callable only by the currency contract of the request
535      * @param _requestId Request id
536      */ 
537     function accept(bytes32 _requestId) 
538         external
539     {
540         Request storage r = requests[_requestId];
541         require(r.currencyContract==msg.sender); 
542         r.state = State.Accepted;
543         Accepted(_requestId);
544     }
545 
546     /*
547      * @dev Function used by currency contracts to cancel a request in the Core. Several reasons can lead to cancel a request, see request life cycle for more info.
548      * @dev callable only by the currency contract of the request
549      * @param _requestId Request id
550      */ 
551     function cancel(bytes32 _requestId)
552         external
553     {
554         Request storage r = requests[_requestId];
555         require(r.currencyContract==msg.sender);
556         r.state = State.Canceled;
557         Canceled(_requestId);
558     }   
559 
560     /*
561      * @dev Function used to update the balance
562      * @dev callable only by the currency contract of the request
563      * @param _requestId Request id
564      * @param _payeeIndex index of the payee (0 = main payee)
565      * @param _deltaAmount modifier amount
566      */ 
567     function updateBalance(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
568         external
569     {   
570         Request storage r = requests[_requestId];
571         require(r.currencyContract==msg.sender);
572 
573         if( _payeeIndex == 0 ) {
574             // modify the main payee
575             r.payee.balance = r.payee.balance.add(_deltaAmount);
576         } else {
577             // modify the sub payee
578             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
579             sp.balance = sp.balance.add(_deltaAmount);
580         }
581         UpdateBalance(_requestId, _payeeIndex, _deltaAmount);
582     }
583 
584     /*
585      * @dev Function update the expectedAmount adding additional or subtract
586      * @dev callable only by the currency contract of the request
587      * @param _requestId Request id
588      * @param _payeeIndex index of the payee (0 = main payee)
589      * @param _deltaAmount modifier amount
590      */ 
591     function updateExpectedAmount(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
592         external
593     {   
594         Request storage r = requests[_requestId];
595         require(r.currencyContract==msg.sender); 
596 
597         if( _payeeIndex == 0 ) {
598             // modify the main payee
599             r.payee.expectedAmount = r.payee.expectedAmount.add(_deltaAmount);    
600         } else {
601             // modify the sub payee
602             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
603             sp.expectedAmount = sp.expectedAmount.add(_deltaAmount);
604         }
605         UpdateExpectedAmount(_requestId, _payeeIndex, _deltaAmount);
606     }
607 
608     /*
609      * @dev Internal: Init payees for a request (needed to avoid 'stack too deep' in createRequest())
610      * @param _requestId Request id
611      * @param _payees array of payees address
612      * @param _expectedAmounts array of payees initial expected amounts
613      */ 
614     function initSubPayees(bytes32 _requestId, address[] _payees, int256[] _expectedAmounts)
615         internal
616     {
617         require(_payees.length == _expectedAmounts.length);
618      
619         for (uint8 i = 1; i < _payees.length; i = i.add(1))
620         {
621             // payees address cannot be 0x0
622             require(_payees[i] != 0);
623             subPayees[_requestId][i-1] = Payee(_payees[i], _expectedAmounts[i], 0);
624             NewSubPayee(_requestId, _payees[i]);
625         }
626     }
627 
628 
629     /* GETTER */
630     /*
631      * @dev Get address of a payee
632      * @param _requestId Request id
633      * @param _payeeIndex payee index (0 = main payee)
634      * @return payee address
635      */ 
636     function getPayeeAddress(bytes32 _requestId, uint8 _payeeIndex)
637         public
638         constant
639         returns(address)
640     {
641         if(_payeeIndex == 0) {
642             return requests[_requestId].payee.addr;
643         } else {
644             return subPayees[_requestId][_payeeIndex-1].addr;
645         }
646     }
647 
648     /*
649      * @dev Get payer of a request
650      * @param _requestId Request id
651      * @return payer address
652      */ 
653     function getPayer(bytes32 _requestId)
654         public
655         constant
656         returns(address)
657     {
658         return requests[_requestId].payer;
659     }
660 
661     /*
662      * @dev Get amount expected of a payee
663      * @param _requestId Request id
664      * @param _payeeIndex payee index (0 = main payee)
665      * @return amount expected
666      */     
667     function getPayeeExpectedAmount(bytes32 _requestId, uint8 _payeeIndex)
668         public
669         constant
670         returns(int256)
671     {
672         if(_payeeIndex == 0) {
673             return requests[_requestId].payee.expectedAmount;
674         } else {
675             return subPayees[_requestId][_payeeIndex-1].expectedAmount;
676         }
677     }
678 
679     /*
680      * @dev Get number of subPayees for a request
681      * @param _requestId Request id
682      * @return number of subPayees
683      */     
684     function getSubPayeesCount(bytes32 _requestId)
685         public
686         constant
687         returns(uint8)
688     {
689         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
690             // nothing to do
691         }
692         return i;
693     }
694 
695     /*
696      * @dev Get currencyContract of a request
697      * @param _requestId Request id
698      * @return currencyContract address
699      */
700     function getCurrencyContract(bytes32 _requestId)
701         public
702         constant
703         returns(address)
704     {
705         return requests[_requestId].currencyContract;
706     }
707 
708     /*
709      * @dev Get balance of a payee
710      * @param _requestId Request id
711      * @param _payeeIndex payee index (0 = main payee)
712      * @return balance
713      */     
714     function getPayeeBalance(bytes32 _requestId, uint8 _payeeIndex)
715         public
716         constant
717         returns(int256)
718     {
719         if(_payeeIndex == 0) {
720             return requests[_requestId].payee.balance;    
721         } else {
722             return subPayees[_requestId][_payeeIndex-1].balance;
723         }
724     }
725 
726     /*
727      * @dev Get balance total of a request
728      * @param _requestId Request id
729      * @return balance
730      */     
731     function getBalance(bytes32 _requestId)
732         public
733         constant
734         returns(int256)
735     {
736         int256 balance = requests[_requestId].payee.balance;
737 
738         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
739         {
740             balance = balance.add(subPayees[_requestId][i].balance);
741         }
742 
743         return balance;
744     }
745 
746 
747     /*
748      * @dev check if all the payees balances are null
749      * @param _requestId Request id
750      * @return true if all the payees balances are equals to 0
751      */     
752     function areAllBalanceNull(bytes32 _requestId)
753         public
754         constant
755         returns(bool isNull)
756     {
757         isNull = requests[_requestId].payee.balance == 0;
758 
759         for (uint8 i = 0; isNull && subPayees[_requestId][i].addr != address(0); i = i.add(1))
760         {
761             isNull = subPayees[_requestId][i].balance == 0;
762         }
763 
764         return isNull;
765     }
766 
767     /*
768      * @dev Get total expectedAmount of a request
769      * @param _requestId Request id
770      * @return balance
771      */     
772     function getExpectedAmount(bytes32 _requestId)
773         public
774         constant
775         returns(int256)
776     {
777         int256 expectedAmount = requests[_requestId].payee.expectedAmount;
778 
779         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
780         {
781             expectedAmount = expectedAmount.add(subPayees[_requestId][i].expectedAmount);
782         }
783 
784         return expectedAmount;
785     }
786 
787     /*
788      * @dev Get state of a request
789      * @param _requestId Request id
790      * @return state
791      */ 
792     function getState(bytes32 _requestId)
793         public
794         constant
795         returns(State)
796     {
797         return requests[_requestId].state;
798     }
799 
800     /*
801      * @dev Get address of a payee
802      * @param _requestId Request id
803      * @return payee index (0 = main payee) or -1 if not address not found
804      */
805     function getPayeeIndex(bytes32 _requestId, address _address)
806         public
807         constant
808         returns(int16)
809     {
810         // return 0 if main payee
811         if(requests[_requestId].payee.addr == _address) return 0;
812 
813         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1))
814         {
815             if(subPayees[_requestId][i].addr == _address) {
816                 // if found return subPayee index + 1 (0 is main payee)
817                 return i+1;
818             }
819         }
820         return -1;
821     }
822 
823     /*
824      * @dev getter of a request
825      * @param _requestId Request id
826      * @return request as a tuple : (address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
827      */ 
828     function getRequest(bytes32 _requestId) 
829         external
830         constant
831         returns(address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
832     {
833         Request storage r = requests[_requestId];
834         return ( r.payer, 
835                  r.currencyContract, 
836                  r.state, 
837                  r.payee.addr, 
838                  r.payee.expectedAmount, 
839                  r.payee.balance );
840     }
841 
842     /*
843      * @dev extract a string from a bytes. Extracts a sub-part from tha bytes and convert it to string
844      * @param data bytes from where the string will be extracted
845      * @param size string size to extract
846      * @param _offset position of the first byte of the string in bytes
847      * @return string
848      */ 
849     function extractString(bytes data, uint8 size, uint _offset) 
850         internal 
851         pure 
852         returns (string) 
853     {
854         bytes memory bytesString = new bytes(size);
855         for (uint j = 0; j < size; j++) {
856             bytesString[j] = data[_offset+j];
857         }
858         return string(bytesString);
859     }
860 
861     /*
862      * @dev generate a new unique requestId
863      * @return a bytes32 requestId 
864      */ 
865     function generateRequestId()
866         internal
867         returns (bytes32)
868     {
869         // Update numRequest
870         numRequests = numRequests.add(1);
871         // requestId = ADDRESS_CONTRACT_CORE + numRequests (0xADRRESSCONTRACT00000NUMREQUEST)
872         return bytes32((uint256(this) << 96).add(numRequests));
873     }
874 
875     /*
876      * @dev extract an address from a bytes at a given position
877      * @param _data bytes from where the address will be extract
878      * @param _offset position of the first byte of the address
879      * @return address
880      */
881     function extractAddress(bytes _data, uint offset)
882         internal
883         pure
884         returns (address m)
885     {
886         require(offset >=0 && offset + 20 <= _data.length);
887         assembly {
888             m := and( mload(add(_data, add(20, offset))), 
889                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
890         }
891     }
892 
893     /*
894      * @dev extract a bytes32 from a bytes
895      * @param data bytes from where the bytes32 will be extract
896      * @param offset position of the first byte of the bytes32
897      * @return address
898      */
899     function extractBytes32(bytes _data, uint offset)
900         public
901         pure
902         returns (bytes32 bs)
903     {
904         require(offset >=0 && offset + 32 <= _data.length);
905         assembly {
906             bs := mload(add(_data, add(32, offset)))
907         }
908     }
909 
910     /**
911      * @dev transfer to owner any tokens send by mistake on this contracts
912      * @param token The address of the token to transfer.
913      * @param amount The amount to be transfered.
914      */
915     function emergencyERC20Drain(ERC20 token, uint amount )
916         public
917         onlyOwner 
918     {
919         token.transfer(owner, amount);
920     }
921 }