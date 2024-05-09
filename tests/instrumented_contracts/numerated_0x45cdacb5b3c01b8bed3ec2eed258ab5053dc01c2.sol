1 pragma solidity ^0.4.25;
2 
3 library Math {
4     
5     function Mul(uint a,uint b) internal pure returns (uint) {
6         if(a==0) {
7             return 0;
8         }
9         uint res = a*b;
10         require(res/a == b,"Overflow in Multiply");
11         return res;
12     }   
13     
14     function Div(uint a,uint b) internal pure returns (uint) {
15         require(b>0,"Division by zero");
16         return (a/b);
17     }   
18     
19     function Mod(uint a, uint b) internal pure returns (uint) {
20         require(b>0,"Division by zero");
21         return (a%b);
22     }   
23     
24     function Add(uint a, uint b) internal pure returns (uint) {
25         uint res = a+b;
26         require(res>=a,"Overflow in Addition");
27         return res;
28     }   
29     
30     function Sub(uint a,uint b) internal pure returns (uint) {
31         require(a>=b,"Subtraction results in negative number");
32         return (a-b);
33     }   
34 }
35 
36 contract TEST_MultiSig {
37 
38     using Math for uint256;
39     struct Transaction {
40         address destination;
41         uint256 value;
42         bytes data;
43         bool executed;
44         uint256 expiration;
45         uint256 receivedConfirmations;
46 
47     }
48 
49     event LogMultiSigContractCreated(
50         uint256 numOwners,
51         uint256 numAllowedDestinations,
52         uint256 quorum,
53         uint256 maxTxValiditySeconds
54     );
55     event LogDestinationStatus(address destination,bool status);
56     event LogTransactionProposal(
57         uint256 indexed txId,
58         address destination,
59         uint256 value,
60         bytes data
61     );
62     event LogTransactionConfirmationRescission(
63         uint256 indexed txId,
64         address approver,
65         uint256 currentlyReceivedConfirmations
66     );
67     event LogTransactionExecutionSuccess(uint256 indexed txId);
68     event LogTransactionExecutionFailure(uint256 indexed txId);
69     event LogTransactionConfirmation(
70         uint256 indexed txId,
71         address indexed approver,
72         uint256 currentlyReceivedConfirmations
73     );
74     event LogDeposit(address depositer, uint256 depositedValue); 
75    
76 
77     mapping (uint256 => Transaction) public transactions;
78     mapping (uint256 => mapping (address => bool)) public confirmations;
79     mapping (address => bool) public isOwner;
80     mapping (address => bool) public destinationAddressStatus;
81     address[] public owners;
82     uint256 public requiredConfirmations;
83     uint256 public transactionCount;
84     uint256 public maxValidTimeSecs;
85     uint256 constant MIN_OWNER_COUNT=3;
86     uint256 constant MIN_REQD_COUNT=2;
87 
88     modifier onlyByThisAddress {
89         require(msg.sender == address(this),"onlyByThisAddress");
90         _;
91     }
92 
93     modifier onlyByOwners {
94         require(isOwner[msg.sender],"onlyByOwners");
95         _;
96     }
97 
98     modifier destinationStatusCheck(address _destination,bool _status) {
99         require(
100             destinationAddressStatus[_destination]==_status,
101             "Failed destinationStatusCheck"
102         );
103         _;
104     }
105 
106     modifier awaitingConfirmation(uint256 _tx_id) {
107         //need only up to required approvals
108         require(!isConfirmed(_tx_id),"Already confirmed");
109         _;
110     }
111 
112     modifier completedConfirmation(uint256 _tx_id) {
113         //need exactly required approvals
114         require(isConfirmed(_tx_id),"Not confirmed yet");
115         _;
116     }
117 
118     modifier confirmationStatusCheck(
119         uint256 _tx_id,
120         address _sender,
121         bool _status
122     ) 
123     {
124         require(
125             confirmations[_tx_id][_sender]==_status,
126             "Failed confirmationStatusCheck"
127         );
128         _;
129     }
130 
131     modifier awaitingExecution(uint256 _tx_id) {
132         require( 
133             !isExecuted(_tx_id), 
134             "Tx already executed"
135         );
136         _;
137     }
138 
139     modifier awaitingExpiry(uint256 _tx_id) {
140         require(
141             !isExpired(_tx_id),
142             "Tx has expired"
143         );
144         _;
145     }
146 
147 
148     modifier validRequirement(uint _ownercount,uint _required) {
149         require(
150             (_ownercount>=MIN_OWNER_COUNT) &&
151             (_required >= MIN_REQD_COUNT)  &&
152             (MIN_REQD_COUNT <= MIN_OWNER_COUNT),
153             "Constructor requirements not met"
154         );
155         _;
156     }
157 
158     modifier validExpiration(uint256 _expiration) {
159         require(
160             _expiration>=now,
161             "time must be >= now"
162         );
163         require(
164             (_expiration-now)<maxValidTimeSecs,
165             "Expiration time is too far in the future" 
166         );
167         _;
168     }
169 
170 
171     /**
172      * @dev constructor
173      * @param _owners owners array
174      * @param _required_confirmations number of required confirmations
175      */
176     constructor(
177         address[] _owners,
178         address[] _allowed_destinations, 
179         uint256 _required_confirmations,
180         uint256 _max_valid_time_secs
181     ) 
182         public
183         validRequirement(_owners.length,_required_confirmations)
184     {
185 
186         //for(uint256 i=0;i<_owners.length;i++) {
187         for(uint256 i=0;i<_owners.length;i=i.Add(1)) {
188             
189             //requires an address
190             require(_owners[i] != address(0));
191 
192             //cant be repeated address
193             require(!isOwner[_owners[i]]);
194             
195             isOwner[_owners[i]]=true;
196         }
197 
198         requiredConfirmations = _required_confirmations;
199         maxValidTimeSecs = _max_valid_time_secs;
200         owners = _owners;
201         
202         //to allow this contract to call its own admin functions
203         destinationAddressStatus[address(this)] = true;
204 
205         //for(uint256 j=0;j<_allowed_destinations.length;/*j++*/j=j.Add(1)) {
206         for(uint256 j=0;j<_allowed_destinations.length;j=j.Add(1)) {
207             destinationAddressStatus[_allowed_destinations[j]]=true;
208         }
209 
210         emit LogMultiSigContractCreated(
211             _owners.length,
212             _allowed_destinations.length.Add(1),
213             _required_confirmations,
214             _max_valid_time_secs
215         );
216     }
217 
218     function() public payable {
219         if(msg.value>0)
220             emit LogDeposit(msg.sender,msg.value);
221     }
222 
223     /* =================================================================
224      *  admin functions
225      * =================================================================
226      */
227 
228     /**
229      * @notice Sets whether a destination address is allowed
230      * @param _destination Destination address
231      * @param _status true=allowed, false=not allowed
232      */
233     function setDestinationAddressStatus(
234         address _destination,
235         bool _status
236     )
237         public
238         onlyByThisAddress
239         destinationStatusCheck(_destination,!_status)
240     {
241         require(
242             _destination!=address(this),
243             "contract can never disable calling itself"
244         );
245 
246         destinationAddressStatus[_destination] = _status;      
247         emit LogDestinationStatus(_destination,_status);
248     }
249 
250     /* =================================================================
251      *  (propose,approve,revokeApproval,execute)Tx
252      * =================================================================
253      */
254 
255     /**
256      * @notice Propose a transaction for multi-sig approval
257      * @dev Proposal also counts as one confirmation
258      * @param _destination Destination address
259      * @param _value Wei, if payable function
260      * @param _data Transaction data
261      * @return {"tx_id":"Transaction id"}
262      */
263     function proposeTx(
264         address _destination, 
265         uint256 _value, 
266         bytes _data,
267         uint256 _expiration
268     )
269         public
270         onlyByOwners
271         destinationStatusCheck(_destination,true)
272         validExpiration(_expiration)
273         returns (uint256 tx_id)
274     {
275         tx_id = _createTx(_destination,_value,_data,_expiration);
276         _confirmTx(tx_id);
277     }
278 
279     /**
280      * @notice Approver calls this to approve a transaction
281      * @dev Transaction will be executed if <br/>
282      * @dev ...1) quorum is reached <br/> 
283      * @dev ...2) not expired, <br/> 
284      * @dev ...3) valid transaction <br/>
285      * @param _tx_id Transaction id
286      */
287     function approveTx(uint256 _tx_id)
288         public
289         onlyByOwners
290         confirmationStatusCheck(_tx_id,msg.sender,false)
291         awaitingConfirmation(_tx_id)
292         awaitingExecution(_tx_id)
293         awaitingExpiry(_tx_id)
294     {
295         _confirmTx(_tx_id);
296     }
297      
298     /**
299      * @notice Approver calls this to revoke an earlier approval
300      * @param _tx_id the transaction id
301      */
302     function revokeApprovalTx(uint256 _tx_id)
303         public
304         onlyByOwners
305         confirmationStatusCheck(_tx_id,msg.sender,true)
306         awaitingExecution(_tx_id)
307         awaitingExpiry(_tx_id)
308     {
309         _unconfirmTx(_tx_id);
310     }
311 
312     /**
313      * @notice Executes a multi-sig transaction
314      * @param _tx_id the transaction id
315      */
316     function executeTx(uint256 _tx_id)
317         public
318         //onlyByOwners
319         completedConfirmation(_tx_id)
320         awaitingExecution(_tx_id)
321         awaitingExpiry(_tx_id)
322     {
323         _executeTx(_tx_id);
324     }
325 
326     /* =================================================================
327      *  view functions
328      * =================================================================
329      */
330 
331     /**
332      * @notice Returns the number of owners of this contract
333      * @return {"":"the number of owners"}
334      */
335     function getNumberOfOwners() 
336         external 
337         view 
338         returns (uint256) 
339     {
340         return owners.length;
341     }
342 
343     /**
344      * @notice Checks to see if transacton was executed
345      * @param _tx_id Transaction id
346      * @return {"":"true on Executed, false on Not Executed"}
347      */
348     function isExecuted(uint256 _tx_id) internal view returns(bool) {
349         return transactions[_tx_id].executed;
350     }
351 
352     /**
353      * @notice Checks to see if transacton has expired
354      * @param _tx_id Transaction id
355      * @return {"":"true on Expired, false on Not Expired"}
356      */
357     function isExpired(uint256 _tx_id) internal view returns(bool) {
358         return (now>transactions[_tx_id].expiration);
359     }
360 
361     /**
362      * @notice Checks to see if transacton has been confirmed
363      * @param _tx_id Transaction id
364      * @return {"":"true on Confirmed, false on Not Confirmed"}
365      */
366     function isConfirmed(uint256 _tx_id) internal view returns(bool) {
367         return 
368             transactions[_tx_id].receivedConfirmations==requiredConfirmations;
369     }
370 
371 
372 
373     /* =================================================================
374      *  internal functions
375      * =================================================================
376      */
377 
378     /**
379      * @notice Creates a multi-sig transaction
380      * @param _destination Destination address 
381      * @param _value Amount of wei to pay if calling a payable fn
382      * @param _data Transaction data
383      */
384     function _createTx(
385         address _destination,
386         uint256 _value,
387         bytes _data,
388         uint256 _expiration
389     )
390         internal
391         returns (uint256 tx_id)
392     {
393         tx_id = transactionCount;
394         transactionCount=transactionCount.Add(1);
395         
396         transactions[tx_id] = Transaction({
397             destination: _destination,
398             value: _value,
399             data: _data,
400             executed: false,
401             expiration: _expiration,
402             receivedConfirmations: 0
403         });
404         emit LogTransactionProposal(tx_id,_destination,_value,_data);
405     }
406 
407     /**
408      * @notice Confirms a multi-sig transaction
409      * @param _tx_id Transaction id
410      */
411     function _confirmTx(uint256 _tx_id) 
412         internal
413     {
414         confirmations[_tx_id][msg.sender]=true;
415         
416         transactions[_tx_id].receivedConfirmations=
417                 transactions[_tx_id].receivedConfirmations.Add(1);
418 
419         //try to execute
420         _executeTx(_tx_id);
421 
422         emit LogTransactionConfirmation(
423             _tx_id,
424             msg.sender,
425             transactions[_tx_id].receivedConfirmations
426         );
427     }
428 
429     /**
430      * @notice Removes confirmation of a multi-sig transaction
431      * @param _tx_id Transaction id
432      */
433     function _unconfirmTx(uint256 _tx_id) 
434         internal
435     {
436         confirmations[_tx_id][msg.sender]=false;
437 
438         assert(transactions[_tx_id].receivedConfirmations!=0);
439         
440         transactions[_tx_id].receivedConfirmations = 
441             transactions[_tx_id].receivedConfirmations.Sub(1);
442 
443         emit LogTransactionConfirmationRescission(
444             _tx_id,
445             msg.sender,
446             transactions[_tx_id].receivedConfirmations
447         );
448     }
449 
450     /**
451      * @notice Internal execute function invoking "call"
452      * @dev this function cannot throw<br/>
453      * @dev cannot use modifiers, check explicitly here<br/>
454      * @dev ignoring the gas limits here<br/>
455      * @param _tx_id Transaction id
456      */
457     function _executeTx(uint256 _tx_id)
458         internal
459     {
460         if( 
461             (!isExecuted(_tx_id)) && 
462             (!isExpired(_tx_id)) && 
463             (isConfirmed(_tx_id)) 
464         )
465         {
466 
467             transactions[_tx_id].executed = true;
468             bool result = 
469                 (transactions[_tx_id].destination)
470                 .call
471                 .value(transactions[_tx_id].value)
472                 (transactions[_tx_id].data);
473 
474             transactions[_tx_id].executed = result;
475 
476             if(result) 
477             {
478                 emit LogTransactionExecutionSuccess(_tx_id);
479             }
480             else 
481             {
482                 emit LogTransactionExecutionFailure(_tx_id);
483             }
484         }
485     }
486 }