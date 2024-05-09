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
78         uint256 amountMCW;
79         uint256 amountKWh;
80         uint256 timestampPaymentMCW;
81         bytes32 txPaymentKWh;
82         uint256 timestampPaymentKWh;
83     }
84 
85     // @dev Customer's Tx of payment for MCW registry    
86     mapping (bytes32 => TxData) private txRegistry;
87 
88     // @dev Customer's list of Tx   
89     bytes32[] private txIndex;
90 
91     /**
92     * @dev Constructor
93     * @param _customer the address of a customer for whom the TxRegistry contract is creating
94     */    
95     constructor(address _customer) public {
96         customer = _customer;
97     }
98 
99     /**
100     * @dev Owner can add a new Tx of payment for MCW to the customer's TxRegistry
101     * @param _txPaymentForMCW the Tx of payment for MCW which will be added
102     * @param _amountMCW the amount of MCW tokens which will be recorded to the new Tx
103     * @param _amountKWh the amount of KWh which will be recorded to the new Tx
104     * @param _timestamp the timestamp of payment for MCW which will be recorded to the new Tx
105     */
106     function addTxToRegistry(
107         bytes32 _txPaymentForMCW,
108         uint256 _amountMCW,
109         uint256 _amountKWh,
110         uint256 _timestamp
111         ) public onlyOwner returns(bool)
112     {
113         require(_txPaymentForMCW != 0 && _amountMCW != 0 && _amountKWh != 0 && _timestamp != 0);
114         require(txRegistry[_txPaymentForMCW].timestampPaymentMCW == 0);
115 
116         txRegistry[_txPaymentForMCW].amountMCW = _amountMCW;
117         txRegistry[_txPaymentForMCW].amountKWh = _amountKWh;
118         txRegistry[_txPaymentForMCW].timestampPaymentMCW = _timestamp;
119         txIndex.push(_txPaymentForMCW);
120         return true;
121     }
122 
123     /**
124     * @dev Owner can mark a customer's Tx of payment for MCW as spent
125     * @param _txPaymentForMCW the Tx of payment for MCW which will be marked as spent
126     * @param _txPaymentForKWh the additional Tx of payment for KWh which will be recorded to the original Tx as proof of spend
127     * @param _timestamp the timestamp of payment for KWh which will be recorded to the Tx
128     */
129     function setTxAsSpent(bytes32 _txPaymentForMCW, bytes32 _txPaymentForKWh, uint256 _timestamp) public onlyOwner returns(bool) {
130         require(_txPaymentForMCW != 0 && _txPaymentForKWh != 0 && _timestamp != 0);
131         require(txRegistry[_txPaymentForMCW].timestampPaymentMCW != 0);
132         require(txRegistry[_txPaymentForMCW].timestampPaymentKWh == 0);
133 
134         txRegistry[_txPaymentForMCW].txPaymentKWh = _txPaymentForKWh;
135         txRegistry[_txPaymentForMCW].timestampPaymentKWh = _timestamp;
136         return true;
137     }
138 
139     /**
140     * @dev Get the customer's Tx of payment for MCW amount
141     */   
142     function getTxCount() public view returns(uint256) {
143         return txIndex.length;
144     }
145 
146     /**
147     * @dev Get the customer's Tx of payment for MCW from customer's Tx list by index
148     * @param _index the index of a customer's Tx of payment for MCW in the customer's Tx list
149     */  
150     function getTxAtIndex(uint256 _index) public view returns(bytes32) {
151         return txIndex[_index];
152     }
153 
154     /**
155     * @dev Get the customer's Tx of payment for MCW data - amount of MCW tokens which is recorded in the Tx
156     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
157     */  
158     function getTxAmountMCW(bytes32 _txPaymentForMCW) public view returns(uint256) {
159         return txRegistry[_txPaymentForMCW].amountMCW;
160     }
161 
162     /**
163     * @dev Get the customer's Tx of payment for MCW data - amount of KWh which is recorded in the Tx
164     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
165     */  
166     function getTxAmountKWh(bytes32 _txPaymentForMCW) public view returns(uint256) {
167         return txRegistry[_txPaymentForMCW].amountKWh;
168     }
169 
170     /**
171     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for MCW which is recorded in the Tx
172     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
173     */  
174     function getTxTimestampPaymentMCW(bytes32 _txPaymentForMCW) public view returns(uint256) {
175         return txRegistry[_txPaymentForMCW].timestampPaymentMCW;
176     }
177 
178     /**
179     * @dev Get the customer's Tx of payment for MCW data - Tx of payment for KWh which is recorded in the Tx
180     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
181     */  
182     function getTxPaymentKWh(bytes32 _txPaymentForMCW) public view returns(bytes32) {
183         return txRegistry[_txPaymentForMCW].txPaymentKWh;
184     }
185 
186     /**
187     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for KWh which is recorded in the Tx
188     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
189     */  
190     function getTxTimestampPaymentKWh(bytes32 _txPaymentForMCW) public view returns(uint256) {
191         return txRegistry[_txPaymentForMCW].timestampPaymentKWh;
192     }
193 
194     /**
195     * @dev Check the customer's Tx of payment for MCW
196     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
197     */  
198     function isValidTxPaymentForMCW(bytes32 _txPaymentForMCW) public view returns(bool) {
199         bool isValid = false;
200         if (txRegistry[_txPaymentForMCW].timestampPaymentMCW != 0) {
201             isValid = true;
202         }
203         return isValid;
204     }
205 
206     /**
207     * @dev Check if the customer's Tx of payment for MCW is spent
208     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
209     */
210     function isSpentTxPaymentForMCW(bytes32 _txPaymentForMCW) public view returns(bool) {
211         bool isSpent = false;
212         if (txRegistry[_txPaymentForMCW].timestampPaymentKWh != 0) {
213             isSpent = true;
214         }
215         return isSpent;
216     }
217 
218     /**
219     * @dev Check the customer's Tx of payment for KWh
220     * @param _txPaymentForKWh the Tx of payment for KWh which need to be checked
221     */
222     function isValidTxPaymentForKWh(bytes32 _txPaymentForKWh) public view returns(bool) {
223         bool isValid = false;
224         for (uint256 i = 0; i < getTxCount(); i++) {
225             if (txRegistry[getTxAtIndex(i)].txPaymentKWh == _txPaymentForKWh) {
226                 isValid = true;
227                 break;
228             }
229         }
230         return isValid;
231     }
232 
233     /**
234     * @dev Get the customer's Tx of payment for MCW by Tx payment for KWh 
235     * @param _txPaymentForKWh the Tx of payment for KWh
236     */
237     function getTxPaymentMCW(bytes32 _txPaymentForKWh) public view returns(bytes32) {
238         bytes32 txMCW = 0;
239         for (uint256 i = 0; i < getTxCount(); i++) {
240             if (txRegistry[getTxAtIndex(i)].txPaymentKWh == _txPaymentForKWh) {
241                 txMCW = getTxAtIndex(i);
242                 break;
243             }
244         }
245         return txMCW;
246     }
247 }
248 
249 // File: contracts/McwCustomerRegistry.sol
250 
251 /**
252 * @title Customers Registry
253 * @dev Registry of all customers
254 */
255 contract McwCustomerRegistry is Ownable {
256     // @dev Key: address of customer wallet, Value: address of customer TxRegistry contract
257     mapping (address => address) private registry;
258 
259     // @dev Customers list
260     address[] private customerIndex;
261 
262     // @dev Events for dashboard
263     event NewCustomer(address indexed customer, address indexed txRegistry);
264     event NewCustomerTx(address indexed customer, bytes32 txPaymentForMCW, uint256 amountMCW, uint256 amountKWh, uint256 timestamp);
265     event SpendCustomerTx(address indexed customer, bytes32 txPaymentForMCW, bytes32 txPaymentForKWh, uint256 timestamp);
266 
267     // @dev Constructor
268     constructor() public {}
269 
270     /**
271     * @dev Owner can add a new customer to registry
272     * @dev Creates a related TxRegistry contract for the new customer
273     * @dev Related event will be generated
274     * @param _customer the address of a new customer to add
275     */
276     function addCustomerToRegistry(address _customer) public onlyOwner returns(bool) {
277         require(_customer != address(0));
278         require(registry[_customer] == address(0));
279 
280         address txRegistry = new TxRegistry(_customer);
281         registry[_customer] = txRegistry;
282         customerIndex.push(_customer);
283         emit NewCustomer(_customer, txRegistry);
284         return true;
285     }
286 
287     /**
288     * @dev Owner can add a new Tx of payment for MCW to the customer's TxRegistry
289     * @dev Generates the Tx of payment for MCW (hash as proof of payment) and writes the Tx data to the customer's TxRegistry
290     * @dev Related event will be generated
291     * @param _customer the address of a customer to whom to add a new Tx
292     * @param _amountMCW the amount of MCW tokens which will be recorded to the new Tx
293     * @param _amountKWh the amount of KWh which will be recorded to the new Tx
294     */
295     function addTxToCustomerRegistry(address _customer, uint256 _amountMCW, uint256 _amountKWh) public onlyOwner returns(bool) {
296         require(isValidCustomer(_customer));
297         require(_amountMCW != 0 && _amountKWh != 0);
298 
299         uint256 timestamp = now;
300         bytes32 txPaymentForMCW = keccak256(
301             abi.encodePacked(
302                 _customer,
303                 _amountMCW,
304                 _amountKWh,
305                 timestamp)
306             );
307 
308         TxRegistry txRegistry = TxRegistry(registry[_customer]);
309         require(txRegistry.getTxTimestampPaymentMCW(txPaymentForMCW) == 0);
310 
311         if (!txRegistry.addTxToRegistry(
312             txPaymentForMCW,
313             _amountMCW,
314             _amountKWh,
315             timestamp))
316             revert ();
317         emit NewCustomerTx(
318             _customer,
319             txPaymentForMCW,
320             _amountMCW,
321             _amountKWh,
322             timestamp);
323         return true;
324     }
325 
326     /**
327     * @dev Owner can mark a customer's Tx of payment for MCW as spent
328     * @dev Generates an additional Tx of paymant for KWh (hash as proof of spend), which connected to the original Tx.
329     * @dev Related event will be generated
330     * @param _customer the address of a customer to whom to spend a Tx
331     * @param _txPaymentForMCW the Tx of payment for MCW which will be marked as spent
332     */
333     function setCustomerTxAsSpent(address _customer, bytes32 _txPaymentForMCW) public onlyOwner returns(bool) {
334         require(isValidCustomer(_customer));
335 
336         TxRegistry txRegistry = TxRegistry(registry[_customer]);
337         require(txRegistry.getTxTimestampPaymentMCW(_txPaymentForMCW) != 0);
338         require(txRegistry.getTxTimestampPaymentKWh(_txPaymentForMCW) == 0);
339 
340         uint256 timestamp = now;
341         bytes32 txPaymentForKWh = keccak256(
342             abi.encodePacked(
343                 _txPaymentForMCW,
344                 timestamp)
345             );
346 
347         if (!txRegistry.setTxAsSpent(_txPaymentForMCW, txPaymentForKWh, timestamp))
348             revert ();
349         emit SpendCustomerTx(
350             _customer,
351             _txPaymentForMCW,
352             txPaymentForKWh,
353             timestamp);
354         return true;
355     }
356 
357     /**
358     * @dev Get the current amount of customers
359     */
360     function getCustomerCount() public view returns(uint256) {
361         return customerIndex.length;
362     }
363 
364     /**
365     * @dev Get the customer's address from customers list by index
366     * @param _index the index of a customer in the customers list
367     */    
368     function getCustomerAtIndex(uint256 _index) public view returns(address) {
369         return customerIndex[_index];
370     }
371 
372     /**
373     * @dev Get the customer's TxRegistry contract
374     * @param _customer the address of a customer for whom to get TxRegistry contract 
375     */   
376     function getCustomerTxRegistry(address _customer) public view returns(address) {
377         return registry[_customer];
378     }
379 
380     /**
381     * @dev Check the customer's address
382     * @param _customer the address of a customer which need to be checked
383     */   
384     function isValidCustomer(address _customer) public view returns(bool) {
385         require(_customer != address(0));
386 
387         bool isValid = false;
388         address txRegistry = registry[_customer];
389         if (txRegistry != address(0)) {
390             isValid = true;
391         }
392         return isValid;
393     }
394 
395     // wrappers on TxRegistry contract
396 
397     /**
398     * @dev Get the customer's Tx of payment for MCW amount
399     * @param _customer the address of a customer for whom to get
400     */   
401     function getCustomerTxCount(address _customer) public view returns(uint256) {
402         require(isValidCustomer(_customer));
403 
404         TxRegistry txRegistry = TxRegistry(registry[_customer]);
405         uint256 txCount = txRegistry.getTxCount();
406         return txCount;
407     }
408 
409     /**
410     * @dev Get the customer's Tx of payment for MCW from customer's Tx list by index
411     * @param _customer the address of a customer for whom to get
412     * @param _index the index of a customer's Tx of payment for MCW in the customer's Tx list
413     */       
414     function getCustomerTxAtIndex(address _customer, uint256 _index) public view returns(bytes32) {
415         require(isValidCustomer(_customer));
416 
417         TxRegistry txRegistry = TxRegistry(registry[_customer]);
418         bytes32 txIndex = txRegistry.getTxAtIndex(_index);
419         return txIndex;
420     }
421 
422     /**
423     * @dev Get the customer's Tx of payment for MCW data - amount of MCW tokens which is recorded in the Tx
424     * @param _customer the address of a customer for whom to get
425     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
426     */  
427     function getCustomerTxAmountMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
428         require(isValidCustomer(_customer));
429         require(_txPaymentForMCW != bytes32(0));
430 
431         TxRegistry txRegistry = TxRegistry(registry[_customer]);
432         uint256 amountMCW = txRegistry.getTxAmountMCW(_txPaymentForMCW);
433         return amountMCW;
434     }
435 
436     /**
437     * @dev Get the customer's Tx of payment for MCW data - amount of KWh which is recorded in the Tx
438     * @param _customer the address of a customer for whom to get
439     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
440     */  
441     function getCustomerTxAmountKWh(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
442         require(isValidCustomer(_customer));
443         require(_txPaymentForMCW != bytes32(0));
444 
445         TxRegistry txRegistry = TxRegistry(registry[_customer]);
446         uint256 amountKWh = txRegistry.getTxAmountKWh(_txPaymentForMCW);
447         return amountKWh;
448     }
449 
450     /**
451     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for MCW which is recorded in the Tx
452     * @param _customer the address of a customer for whom to get
453     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
454     */  
455     function getCustomerTxTimestampPaymentMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
456         require(isValidCustomer(_customer));
457         require(_txPaymentForMCW != bytes32(0));
458 
459         TxRegistry txRegistry = TxRegistry(registry[_customer]);
460         uint256 timestampPaymentMCW = txRegistry.getTxTimestampPaymentMCW(_txPaymentForMCW);
461         return timestampPaymentMCW;
462     }
463 
464     /**
465     * @dev Get the customer's Tx of payment for MCW data - Tx of payment for KWh which is recorded in the Tx
466     * @param _customer the address of a customer for whom to get
467     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
468     */  
469     function getCustomerTxPaymentKWh(address _customer, bytes32 _txPaymentForMCW) public view returns(bytes32) {
470         require(isValidCustomer(_customer));
471         require(_txPaymentForMCW != bytes32(0));
472 
473         TxRegistry txRegistry = TxRegistry(registry[_customer]);
474         bytes32 txPaymentKWh = txRegistry.getTxPaymentKWh(_txPaymentForMCW);
475         return txPaymentKWh;
476     }
477 
478     /**
479     * @dev Get the customer's Tx of payment for MCW data - timestamp of payment for KWh which is recorded in the Tx
480     * @param _customer the address of a customer for whom to get
481     * @param _txPaymentForMCW the Tx of payment for MCW for which to get data
482     */  
483     function getCustomerTxTimestampPaymentKWh(address _customer, bytes32 _txPaymentForMCW) public view returns(uint256) {
484         require(isValidCustomer(_customer));
485         require(_txPaymentForMCW != bytes32(0));
486 
487         TxRegistry txRegistry = TxRegistry(registry[_customer]);
488         uint256 timestampPaymentKWh = txRegistry.getTxTimestampPaymentKWh(_txPaymentForMCW);
489         return timestampPaymentKWh;
490     }
491 
492     /**
493     * @dev Check the customer's Tx of payment for MCW
494     * @param _customer the address of a customer for whom to check
495     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
496     */  
497     function isValidCustomerTxPaymentForMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(bool) {
498         require(isValidCustomer(_customer));
499         require(_txPaymentForMCW != bytes32(0));
500 
501         TxRegistry txRegistry = TxRegistry(registry[_customer]);
502         bool isValid = txRegistry.isValidTxPaymentForMCW(_txPaymentForMCW);
503         return isValid;
504     }
505 
506     /**
507     * @dev Check if the customer's Tx of payment for MCW is spent
508     * @param _customer the address of a customer for whom to check
509     * @param _txPaymentForMCW the Tx of payment for MCW which need to be checked
510     */
511     function isSpentCustomerTxPaymentForMCW(address _customer, bytes32 _txPaymentForMCW) public view returns(bool) {
512         require(isValidCustomer(_customer));
513         require(_txPaymentForMCW != bytes32(0));
514 
515         TxRegistry txRegistry = TxRegistry(registry[_customer]);
516         bool isSpent = txRegistry.isSpentTxPaymentForMCW(_txPaymentForMCW);
517         return isSpent;
518     }
519 
520     /**
521     * @dev Check the customer's Tx of payment for KWh
522     * @param _customer the address of a customer for whom to check
523     * @param _txPaymentForKWh the Tx of payment for KWh which need to be checked
524     */
525     function isValidCustomerTxPaymentForKWh(address _customer, bytes32 _txPaymentForKWh) public view returns(bool) {
526         require(isValidCustomer(_customer));
527         require(_txPaymentForKWh != bytes32(0));
528 
529         TxRegistry txRegistry = TxRegistry(registry[_customer]);
530         bool isValid = txRegistry.isValidTxPaymentForKWh(_txPaymentForKWh);
531         return isValid;
532     }
533 
534     /**
535     * @dev Get the customer's Tx of payment for MCW by Tx payment for KWh 
536     * @param _customer the address of a customer for whom to get
537     * @param _txPaymentForKWh the Tx of payment for KWh
538     */
539     function getCustomerTxPaymentMCW(address _customer, bytes32 _txPaymentForKWh) public view returns(bytes32) {
540         require(isValidCustomer(_customer));
541         require(_txPaymentForKWh != bytes32(0));
542 
543         TxRegistry txRegistry = TxRegistry(registry[_customer]);
544         bytes32 txMCW = txRegistry.getTxPaymentMCW(_txPaymentForKWh);
545         return txMCW;
546     }
547 }