1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/TxRegistry.sol
68 
69 /**
70 * @title Transaction Registry for Customer
71 * @dev Registry of customer's payments for MCW and payments for KWh.
72 */
73 contract TxRegistry is Ownable {
74     address public customer;
75 
76     // @dev Structure for TX data
77     struct TxData {
78         bytes32 txOrigMcwTransfer;
79         uint256 amountMCW;
80         uint256 amountKWh;
81         uint256 timestampPaymentMCW;
82         bytes32 txPaymentKWh;
83         uint256 timestampPaymentKWh;
84     }
85 
86     // @dev Customer's Tx of payment for MCW registry    
87     mapping (bytes32 => TxData) private txRegistry;
88 
89     // @dev Customer's list of Tx   
90     bytes32[] private txIndex;
91 
92     /**
93     * @dev Constructor
94     * @param _customer the address of a customer for whom the TxRegistry contract is creating
95     */    
96     constructor(address _customer) public {
97         customer = _customer;
98     }
99 
100     /**
101     * @dev Owner can add a new Tx of payment for MCW to the customer's TxRegistry
102     * @param _txPaymentForMCW the Tx of payment for MCW which will be added
103     * @param _txOrigMcwTransfer the Tx of original MCW transfer in Ethereum network which acts as source for this Tx of payment for MCW
104     * @param _amountMCW the amount of MCW tokens which will be recorded to the new Tx
105     * @param _amountKWh the amount of KWh which will be recorded to the new Tx
106     * @param _timestamp the timestamp of payment for MCW which will be recorded to the new Tx
107     */
108     function addTxToRegistry(
109         bytes32 _txPaymentForMCW,
110         bytes32 _txOrigMcwTransfer,
111         uint256 _amountMCW,
112         uint256 _amountKWh,
113         uint256 _timestamp
114         ) public onlyOwner returns(bool)
115     {
116         require(
117             _txPaymentForMCW != 0 && _txOrigMcwTransfer != 0 && _amountMCW != 0 && _amountKWh != 0 && _timestamp != 0,
118             "All parameters must be not empty."
119         );
120         require(
121             txRegistry[_txPaymentForMCW].timestampPaymentMCW == 0,
122             "Tx with such hash is already exist."
123         );
124 
125         txRegistry[_txPaymentForMCW].txOrigMcwTransfer = _txOrigMcwTransfer;
126         txRegistry[_txPaymentForMCW].amountMCW = _amountMCW;
127         txRegistry[_txPaymentForMCW].amountKWh = _amountKWh;
128         txRegistry[_txPaymentForMCW].timestampPaymentMCW = _timestamp;
129         txIndex.push(_txPaymentForMCW);
130         return true;
131     }
132 
133     /**
134     * @dev Owner can mark a customer's Tx of payment for MCW as spent
135     * @param _txPaymentForMCW the Tx of payment for MCW which will be marked as spent
136     * @param _txPaymentForKWh the additional Tx of payment for KWh which will be recorded to the original Tx as proof of spend
137     * @param _timestamp the timestamp of payment for KWh which will be recorded to the Tx
138     */
139     function setTxAsSpent(bytes32 _txPaymentForMCW, bytes32 _txPaymentForKWh, uint256 _timestamp) public onlyOwner returns(bool) {
140         require(
141             _txPaymentForMCW != 0 && _txPaymentForKWh != 0 && _timestamp != 0,
142             "All parameters must be not empty."
143         );
144         require(
145             txRegistry[_txPaymentForMCW].timestampPaymentMCW != 0,
146             "Tx with such hash doesn't exist."
147         );
148         require(
149             txRegistry[_txPaymentForMCW].timestampPaymentKWh == 0,
150             "Tx with such hash is already spent."
151         );
152 
153         txRegistry[_txPaymentForMCW].txPaymentKWh = _txPaymentForKWh;
154         txRegistry[_txPaymentForMCW].timestampPaymentKWh = _timestamp;
155         return true;
156     }
157 
158     /**
159     * @dev Get the customer's Tx of payment for MCW amount
160     */   
161     function getTxCount() public view returns(uint256) {
162         return txIndex.length;
163     }
164 
165     /**
166     * @dev Get the customer's Tx of payment for MCW from customer's Tx list by index
167     * @param _index the index of a customer's Tx of payment for MCW in the customer's Tx list
168     */  
169     function getTxAtIndex(uint256 _index) public view returns(bytes32) {
170         return txIndex[_index];
171     }
172 
173     /**
174     * @dev Get the customer's Tx of payment for MCW data - Tx of original MCW transfer in Ethereum network which is recorded in the Tx
175     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
176     */  
177     function getTxOrigMcwTransfer(bytes32 _txPaymentForMCW) public view returns(bytes32) {
178         return txRegistry[_txPaymentForMCW].txOrigMcwTransfer;
179     }
180 
181     /**
182     * @dev Get the customer's Tx of payment for MCW data - amount of MCW tokens which is recorded in the Tx
183     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
184     */  
185     function getTxAmountMCW(bytes32 _txPaymentForMCW) public view returns(uint256) {
186         return txRegistry[_txPaymentForMCW].amountMCW;
187     }
188 
189     /**
190     * @dev Get the customer's Tx of payment for MCW data - amount of KWh which is recorded in the Tx
191     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
192     */  
193     function getTxAmountKWh(bytes32 _txPaymentForMCW) public view returns(uint256) {
194         return txRegistry[_txPaymentForMCW].amountKWh;
195     }
196 
197     /**
198     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for MCW which is recorded in the Tx
199     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
200     */  
201     function getTxTimestampPaymentMCW(bytes32 _txPaymentForMCW) public view returns(uint256) {
202         return txRegistry[_txPaymentForMCW].timestampPaymentMCW;
203     }
204 
205     /**
206     * @dev Get the customer's Tx of payment for MCW data - Tx of payment for KWh which is recorded in the Tx
207     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
208     */  
209     function getTxPaymentKWh(bytes32 _txPaymentForMCW) public view returns(bytes32) {
210         return txRegistry[_txPaymentForMCW].txPaymentKWh;
211     }
212 
213     /**
214     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for KWh which is recorded in the Tx
215     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
216     */  
217     function getTxTimestampPaymentKWh(bytes32 _txPaymentForMCW) public view returns(uint256) {
218         return txRegistry[_txPaymentForMCW].timestampPaymentKWh;
219     }
220 
221     /**
222     * @dev Check the customer's Tx of payment for MCW
223     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
224     */  
225     function isValidTxPaymentForMCW(bytes32 _txPaymentForMCW) public view returns(bool) {
226         bool isValid = false;
227         if (txRegistry[_txPaymentForMCW].timestampPaymentMCW != 0) {
228             isValid = true;
229         }
230         return isValid;
231     }
232 
233     /**
234     * @dev Check if the customer's Tx of payment for MCW is spent
235     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
236     */
237     function isSpentTxPaymentForMCW(bytes32 _txPaymentForMCW) public view returns(bool) {
238         bool isSpent = false;
239         if (txRegistry[_txPaymentForMCW].timestampPaymentKWh != 0) {
240             isSpent = true;
241         }
242         return isSpent;
243     }
244 
245     /**
246     * @dev Check the customer's Tx of payment for KWh
247     * @param _txPaymentForKWh the Tx of payment for KWh which need to be checked
248     */
249     function isValidTxPaymentForKWh(bytes32 _txPaymentForKWh) public view returns(bool) {
250         bool isValid = false;
251         for (uint256 i = 0; i < getTxCount(); i++) {
252             if (txRegistry[getTxAtIndex(i)].txPaymentKWh == _txPaymentForKWh) {
253                 isValid = true;
254                 break;
255             }
256         }
257         return isValid;
258     }
259 
260     /**
261     * @dev Get the customer's Tx of payment for MCW by Tx payment for KWh 
262     * @param _txPaymentForKWh the Tx of payment for KWh
263     */
264     function getTxPaymentMCW(bytes32 _txPaymentForKWh) public view returns(bytes32) {
265         bytes32 txMCW = 0;
266         for (uint256 i = 0; i < getTxCount(); i++) {
267             if (txRegistry[getTxAtIndex(i)].txPaymentKWh == _txPaymentForKWh) {
268                 txMCW = getTxAtIndex(i);
269                 break;
270             }
271         }
272         return txMCW;
273     }
274 }
275 
276 // File: contracts/McwCustomerRegistry.sol
277 
278 /**
279 * @title Customers Registry
280 * @dev Registry of all customers
281 */
282 contract McwCustomerRegistry is Ownable {
283     // @dev Key: address of customer wallet, Value: address of customer TxRegistry contract
284     mapping (address => address) private registry;
285 
286     // @dev Customers list
287     address[] private customerIndex;
288 
289     // @dev Events for dashboard
290     event NewCustomer(address indexed customer, address indexed txRegistry);
291     event NewCustomerTx(
292         address indexed customer,
293         bytes32 txPaymentForMCW,
294         bytes32 txOrigMcwTransfer,
295         uint256 amountMCW,
296         uint256 amountKWh,
297         uint256 timestamp
298     );
299     event SpendCustomerTx(address indexed customer, bytes32 txPaymentForMCW, bytes32 txPaymentForKWh, uint256 timestamp);
300 
301     // @dev Constructor
302     constructor() public {}
303 
304     /**
305     * @dev Owner can add a new customer to registry
306     * @dev Creates a related TxRegistry contract for the new customer
307     * @dev Related event will be generated
308     * @param _customer the address of a new customer to add
309     */
310     function addCustomerToRegistry(address _customer) public onlyOwner returns(bool) {
311         require(
312             _customer != address(0),
313             "Parameter must be not empty."
314         );
315         require(
316             registry[_customer] == address(0),
317             "Customer is already in the registry."
318         );
319 
320         address txRegistry = new TxRegistry(_customer);
321         registry[_customer] = txRegistry;
322         customerIndex.push(_customer);
323         emit NewCustomer(_customer, txRegistry);
324         return true;
325     }
326 
327     /**
328     * @dev Owner can add a new Tx of payment for MCW to the customer's TxRegistry
329     * @dev Generates the Tx of payment for MCW (hash as proof of payment) and writes the Tx data to the customer's TxRegistry
330     * @dev Related event will be generated
331     * @param _customer the address of a customer to whom to add a new Tx
332     * @param _txOrigMcwTransfer the Tx of original MCW transfer in Ethereum network which acts as source for a new Tx of payment for MCW
333     * @param _amountMCW the amount of MCW tokens which will be recorded to the new Tx
334     * @param _amountKWh the amount of KWh which will be recorded to the new Tx
335     */
336     function addTxToCustomerRegistry(
337         address _customer,
338         bytes32 _txOrigMcwTransfer,
339         uint256 _amountMCW,
340         uint256 _amountKWh
341         ) public onlyOwner returns(bool)
342     {
343         require(
344             isValidCustomer(_customer),
345             "Customer is not in the registry."
346         );
347         require(
348             _txOrigMcwTransfer != 0 && _amountMCW != 0 && _amountKWh != 0,
349             "All parameters must be not empty."
350         );
351 
352         uint256 timestamp = now;
353         bytes32 txPaymentForMCW = keccak256(
354             abi.encodePacked(
355                 _customer,
356                 _amountMCW,
357                 _amountKWh,
358                 timestamp)
359             );
360 
361         TxRegistry txRegistry = TxRegistry(registry[_customer]);
362         require(
363             txRegistry.getTxTimestampPaymentMCW(txPaymentForMCW) == 0,
364             "Tx with such hash is already exist."
365         );
366 
367         if (!txRegistry.addTxToRegistry(
368             txPaymentForMCW,
369             _txOrigMcwTransfer,
370             _amountMCW,
371             _amountKWh,
372             timestamp))
373             revert ("Something went wrong.");
374         emit NewCustomerTx(
375             _customer,
376             txPaymentForMCW,
377             _txOrigMcwTransfer,
378             _amountMCW,
379             _amountKWh,
380             timestamp);
381         return true;
382     }
383 
384     /**
385     * @dev Owner can mark a customer's Tx of payment for MCW as spent
386     * @dev Generates an additional Tx of paymant for KWh (hash as proof of spend), which connected to the original Tx.
387     * @dev Related event will be generated
388     * @param _customer the address of a customer to whom to spend a Tx
389     * @param _txPaymentForMCW the Tx of payment for MCW which will be marked as spent
390     */
391     function setCustomerTxAsSpent(address _customer, bytes32 _txPaymentForMCW) public onlyOwner returns(bool) {
392         require(
393             isValidCustomer(_customer),
394             "Customer is not in the registry."
395         );
396 
397         TxRegistry txRegistry = TxRegistry(registry[_customer]);
398         require(
399             txRegistry.getTxTimestampPaymentMCW(_txPaymentForMCW) != 0,
400             "Tx with such hash doesn't exist."
401         );
402         require(
403             txRegistry.getTxTimestampPaymentKWh(_txPaymentForMCW) == 0,
404             "Tx with such hash is already spent."
405         );
406 
407         uint256 timestamp = now;
408         bytes32 txPaymentForKWh = keccak256(
409             abi.encodePacked(
410                 _txPaymentForMCW,
411                 timestamp)
412             );
413 
414         if (!txRegistry.setTxAsSpent(_txPaymentForMCW, txPaymentForKWh, timestamp))
415             revert ("Something went wrong.");
416         emit SpendCustomerTx(
417             _customer,
418             _txPaymentForMCW,
419             txPaymentForKWh,
420             timestamp);
421         return true;
422     }
423 
424     /**
425     * @dev Get the current amount of customers
426     */
427     function getCustomerCount() public view returns(uint256) {
428         return customerIndex.length;
429     }
430 
431     /**
432     * @dev Get the customer's address from customers list by index
433     * @param _index the index of a customer in the customers list
434     */    
435     function getCustomerAtIndex(uint256 _index) public view returns(address) {
436         return customerIndex[_index];
437     }
438 
439     /**
440     * @dev Get the customer's TxRegistry contract
441     * @param _customer the address of a customer for whom to get TxRegistry contract 
442     */   
443     function getCustomerTxRegistry(address _customer) public view returns(address) {
444         return registry[_customer];
445     }
446 
447     /**
448     * @dev Check the customer's address
449     * @param _customer the address of a customer which need to be checked
450     */   
451     function isValidCustomer(address _customer) public view returns(bool) {
452         require(
453             _customer != address(0),
454             "Parameter must be not empty."
455         );
456 
457         bool isValid = false;
458         address txRegistry = registry[_customer];
459         if (txRegistry != address(0)) {
460             isValid = true;
461         }
462         return isValid;
463     }
464 
465     // wrappers on TxRegistry contract
466 
467     /**
468     * @dev Get the customer's Tx of payment for MCW amount
469     * @param _customer the address of a customer for whom to get
470     */   
471     function getCustomerTxCount(address _customer) public view returns(uint256) {
472         require(
473             isValidCustomer(_customer),
474             "Customer is not in the registry."
475         );
476 
477         TxRegistry txRegistry = TxRegistry(registry[_customer]);
478         uint256 txCount = txRegistry.getTxCount();
479         return txCount;
480     }
481 
482     /**
483     * @dev Get the customer's Tx of payment for MCW from customer's Tx list by index
484     * @param _customer the address of a customer for whom to get
485     * @param _index the index of a customer's Tx of payment for MCW in the customer's Tx list
486     */       
487     function getCustomerTxAtIndex(address _customer, uint256 _index) public view returns(bytes32) {
488         require(
489             isValidCustomer(_customer),
490             "Customer is not in the registry."
491         );
492 
493         TxRegistry txRegistry = TxRegistry(registry[_customer]);
494         bytes32 txIndex = txRegistry.getTxAtIndex(_index);
495         return txIndex;
496     }
497 
498     /**
499     * @dev Get the customer's Tx of payment for MCW data - Tx of original MCW transfer in Ethereum network which is recorded in the Tx
500     * @param _customer the address of a customer for whom to get
501     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
502     */  
503     function getCustomerTxOrigMcwTransfer(address _customer, bytes32 _txPaymentForMCW) public view returns(bytes32) {
504         require(
505             isValidCustomer(_customer),
506             "Customer is not in the registry."
507         );
508         require(
509             _txPaymentForMCW != bytes32(0),
510             "Parameter must be not empty."
511         );
512 
513         TxRegistry txRegistry = TxRegistry(registry[_customer]);
514         bytes32 txOrigMcwTransfer = txRegistry.getTxOrigMcwTransfer(_txPaymentForMCW);
515         return txOrigMcwTransfer;
516     }
517 
518     /**
519     * @dev Get the customer's Tx of payment for MCW data - amount of MCW tokens which is recorded in the Tx
520     * @param _customer the address of a customer for whom to get
521     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
522     */  
523     function getCustomerTxAmountMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
524         require(
525             isValidCustomer(_customer),
526             "Customer is not in the registry."
527         );
528         require(
529             _txPaymentForMCW != bytes32(0),
530             "Parameter must be not empty."
531         );
532 
533         TxRegistry txRegistry = TxRegistry(registry[_customer]);
534         uint256 amountMCW = txRegistry.getTxAmountMCW(_txPaymentForMCW);
535         return amountMCW;
536     }
537 
538     /**
539     * @dev Get the customer's Tx of payment for MCW data - amount of KWh which is recorded in the Tx
540     * @param _customer the address of a customer for whom to get
541     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
542     */  
543     function getCustomerTxAmountKWh(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
544         require(
545             isValidCustomer(_customer),
546             "Customer is not in the registry."
547         );
548         require(
549             _txPaymentForMCW != bytes32(0),
550             "Parameter must be not empty."
551         );
552 
553         TxRegistry txRegistry = TxRegistry(registry[_customer]);
554         uint256 amountKWh = txRegistry.getTxAmountKWh(_txPaymentForMCW);
555         return amountKWh;
556     }
557 
558     /**
559     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for MCW which is recorded in the Tx
560     * @param _customer the address of a customer for whom to get
561     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
562     */  
563     function getCustomerTxTimestampPaymentMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
564         require(
565             isValidCustomer(_customer),
566             "Customer is not in the registry."
567         );
568         require(
569             _txPaymentForMCW != bytes32(0),
570             "Parameter must be not empty."
571         );
572 
573         TxRegistry txRegistry = TxRegistry(registry[_customer]);
574         uint256 timestampPaymentMCW = txRegistry.getTxTimestampPaymentMCW(_txPaymentForMCW);
575         return timestampPaymentMCW;
576     }
577 
578     /**
579     * @dev Get the customer's Tx of payment for MCW data - Tx of payment for KWh which is recorded in the Tx
580     * @param _customer the address of a customer for whom to get
581     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
582     */  
583     function getCustomerTxPaymentKWh(address _customer, bytes32 _txPaymentForMCW) public view returns(bytes32) {
584         require(
585             isValidCustomer(_customer),
586             "Customer is not in the registry."
587         );
588         require(
589             _txPaymentForMCW != bytes32(0),
590             "Parameter must be not empty."
591         );
592 
593         TxRegistry txRegistry = TxRegistry(registry[_customer]);
594         bytes32 txPaymentKWh = txRegistry.getTxPaymentKWh(_txPaymentForMCW);
595         return txPaymentKWh;
596     }
597 
598     /**
599     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for KWh which is recorded in the Tx
600     * @param _customer the address of a customer for whom to get
601     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
602     */  
603     function getCustomerTxTimestampPaymentKWh(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
604         require(
605             isValidCustomer(_customer),
606             "Customer is not in the registry."
607         );
608         require(
609             _txPaymentForMCW != bytes32(0),
610             "Parameter must be not empty."
611         );
612 
613         TxRegistry txRegistry = TxRegistry(registry[_customer]);
614         uint256 timestampPaymentKWh = txRegistry.getTxTimestampPaymentKWh(_txPaymentForMCW);
615         return timestampPaymentKWh;
616     }
617 
618     /**
619     * @dev Check the customer's Tx of payment for MCW
620     * @param _customer the address of a customer for whom to check
621     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
622     */  
623     function isValidCustomerTxPaymentForMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(bool) {
624         require(
625             isValidCustomer(_customer),
626             "Customer is not in the registry."
627         );
628         require(
629             _txPaymentForMCW != bytes32(0),
630             "Parameter must be not empty."
631         );
632 
633         TxRegistry txRegistry = TxRegistry(registry[_customer]);
634         bool isValid = txRegistry.isValidTxPaymentForMCW(_txPaymentForMCW);
635         return isValid;
636     }
637 
638     /**
639     * @dev Check if the customer's Tx of payment for MCW is spent
640     * @param _customer the address of a customer for whom to check
641     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
642     */
643     function isSpentCustomerTxPaymentForMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(bool) {
644         require(
645             isValidCustomer(_customer),
646             "Customer is not in the registry."
647         );
648         require(
649             _txPaymentForMCW != bytes32(0),
650             "Parameter must be not empty."
651         );
652 
653         TxRegistry txRegistry = TxRegistry(registry[_customer]);
654         bool isSpent = txRegistry.isSpentTxPaymentForMCW(_txPaymentForMCW);
655         return isSpent;
656     }
657 
658     /**
659     * @dev Check the customer's Tx of payment for KWh
660     * @param _customer the address of a customer for whom to check
661     * @param _txPaymentForKWh the Tx of payment for KWh which need to be checked
662     */
663     function isValidCustomerTxPaymentForKWh(address _customer, bytes32 _txPaymentForKWh) public view returns(bool) {
664         require(
665             isValidCustomer(_customer),
666             "Customer is not in the registry."
667         );
668         require(
669             _txPaymentForKWh != bytes32(0),
670             "Parameter must be not empty."
671         );
672 
673         TxRegistry txRegistry = TxRegistry(registry[_customer]);
674         bool isValid = txRegistry.isValidTxPaymentForKWh(_txPaymentForKWh);
675         return isValid;
676     }
677 
678     /**
679     * @dev Get the customer's Tx of payment for MCW by Tx payment for KWh 
680     * @param _customer the address of a customer for whom to get
681     * @param _txPaymentForKWh the Tx of payment for KWh
682     */
683     function getCustomerTxPaymentMCW(address _customer, bytes32 _txPaymentForKWh) public view returns(bytes32) {
684         require(
685             isValidCustomer(_customer),
686             "Customer is not in the registry."
687         );
688         require(
689             _txPaymentForKWh != bytes32(0),
690             "Parameter must be not empty."
691         );
692 
693         TxRegistry txRegistry = TxRegistry(registry[_customer]);
694         bytes32 txMCW = txRegistry.getTxPaymentMCW(_txPaymentForKWh);
695         return txMCW;
696     }
697 }