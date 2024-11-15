1 pragma solidity 0.4.23;
2 
3 /*
4  * Ownable
5  *
6  * Base contract with an owner.
7  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
8  */
9 
10 contract Ownable {
11   address public owner;
12 
13   constructor() public {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 }
22 
23 /**
24  * @title Pausable
25  * @dev Base contract which allows children to implement an emergency stop mechanism.
26  */
27 contract Pausable is Ownable {
28   event Pause();
29   event Unpause();
30 
31   bool public paused = false;
32 
33 
34   /**
35    * @dev Modifier to make a function callable only when the contract is not paused.
36    */
37   modifier whenNotPaused() {
38     require(!paused);
39     _;
40   }
41 
42   /**
43    * @dev Modifier to make a function callable only when the contract is paused.
44    */
45   modifier whenPaused() {
46     require(paused);
47     _;
48   }
49 
50   /**
51    * @dev called by the owner to pause, triggers stopped state
52    */
53   function pause() public onlyOwner whenNotPaused {
54     paused = true;
55     emit Pause();
56   }
57 
58   /**
59    * @dev called by the owner to unpause, returns to normal state
60    */
61   function unpause() public onlyOwner whenPaused {
62     paused = false;
63     emit Unpause();
64   }
65 }
66 
67 contract SafeMath {
68   function safeMul(uint a, uint b) internal pure returns (uint256) {
69     uint c = a * b;
70     assert(a == 0 || c / a == b);
71     return c;
72   }
73 
74   function safeDiv(uint a, uint b) internal pure returns (uint256) {
75     uint c = a / b;
76     return c;
77   }
78 
79   function safeSub(uint a, uint b) internal pure returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function safeAdd(uint a, uint b) internal pure returns (uint256) {
85     uint c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 
90   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
91     return a >= b ? a : b;
92   }
93 
94   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
95     return a < b ? a : b;
96   }
97 
98   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
99     return a >= b ? a : b;
100   }
101 
102   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
103     return a < b ? a : b;
104   }
105 }
106 
107 
108 /**
109  * @title Stoppable
110  * @dev Base contract which allows children to implement final irreversible stop mechanism.
111  */
112 contract Stoppable is Pausable {
113   event Stop();
114 
115   bool public stopped = false;
116 
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is not stopped.
120    */
121   modifier whenNotStopped() {
122     require(!stopped);
123     _;
124   }
125 
126   /**
127    * @dev Modifier to make a function callable only when the contract is stopped.
128    */
129   modifier whenStopped() {
130     require(stopped);
131     _;
132   }
133 
134   /**
135    * @dev called by the owner to pause, triggers stopped state
136    */
137   function stop() public onlyOwner whenNotStopped {
138     stopped = true;
139     emit Stop();
140   }
141 }
142 
143 
144 /**
145  * @title Eth2Phone Escrow Contract
146  * @dev Contract allows to send ether through verifier (owner of contract).
147  * 
148  * Only verifier can initiate withdrawal to recipient's address. 
149  * Verifier cannot choose recipient's address without 
150  * transit private key generated by sender. 
151  * 
152  * Sender is responsible to provide transit private key
153  * to recipient off-chain.
154  * 
155  * Recepient signs address to receive with transit private key and 
156  * provides signed address to verification server. 
157  * (See VerifyTransferSignature method for details.)
158  * 
159  * Verifier verifies off-chain the recipient in accordance with verification 
160  * conditions (e.g., phone ownership via SMS authentication) and initiates
161  * withdrawal to the address provided by recipient.
162  * (See withdraw method for details.)
163  * 
164  * Verifier charges commission for it's services.
165  * 
166  * Sender is able to cancel transfer if it's not yet cancelled or withdrawn
167  * by recipient.
168  * (See cancelTransfer method for details.)
169  */
170 contract e2pEscrow is Stoppable, SafeMath {
171 
172   // fixed amount of wei accrued to verifier with each transfer
173   uint public commissionFee;
174 
175   // verifier can withdraw this amount from smart-contract
176   uint public commissionToWithdraw; // in wei
177 
178   // verifier's address
179   address public verifier;
180     
181   /*
182    * EVENTS
183    */
184   event LogDeposit(
185 		   address indexed sender,
186 		   address indexed transitAddress,
187 		   uint amount,
188 		      uint commission
189 		   );
190 
191   event LogCancel(
192 		  address indexed sender,
193 		  address indexed transitAddress
194 		  );
195 
196   event LogWithdraw(
197 		    address indexed sender,
198 		    address indexed transitAddress,
199 		    address indexed recipient,
200 		    uint amount
201 		    );
202 
203   event LogWithdrawCommission(uint commissionAmount);
204 
205   event LogChangeFixedCommissionFee(
206 				    uint oldCommissionFee,
207 				    uint newCommissionFee
208 				    );
209   
210   event LogChangeVerifier(
211 			  address oldVerifier,
212 			  address newVerifier
213 			  );  
214   
215   struct Transfer {
216     address from;
217     uint amount; // in wei
218   }
219 
220   // Mappings of transitAddress => Transfer Struct
221   mapping (address => Transfer) transferDct;
222 
223 
224   /**
225    * @dev Contructor that sets msg.sender as owner (verifier) in Ownable
226    * and sets verifier's fixed commission fee.
227    * @param _commissionFee uint Verifier's fixed commission for each transfer
228    */
229   constructor(uint _commissionFee, address _verifier) public {
230     commissionFee = _commissionFee;
231     verifier = _verifier;
232   }
233 
234 
235   modifier onlyVerifier() {
236     require(msg.sender == verifier);
237     _;
238   }
239   
240   /**
241    * @dev Deposit ether to smart-contract and create transfer.
242    * Transit address is assigned to transfer by sender. 
243    * Recipient should sign withrawal address with the transit private key 
244    * 
245    * @param _transitAddress transit address assigned to transfer.
246    * @return True if success.
247    */
248   function deposit(address _transitAddress)
249                             public
250                             whenNotPaused
251                             whenNotStopped
252                             payable
253     returns(bool)
254   {
255     // can not override existing transfer
256     require(transferDct[_transitAddress].amount == 0);
257 
258     require(msg.value > commissionFee);
259 
260     // saving transfer details
261     transferDct[_transitAddress] = Transfer(
262 					    msg.sender,
263 					    safeSub(msg.value, commissionFee)//amount = msg.value - comission
264 					    );
265 
266     // accrue verifier's commission
267     commissionToWithdraw = safeAdd(commissionToWithdraw, commissionFee);
268 
269     // log deposit event
270     emit LogDeposit(msg.sender, _transitAddress, msg.value, commissionFee);
271     return true;
272   }
273 
274   /**
275    * @dev Change verifier's fixed commission fee.
276    * Only owner can change commision fee.
277    * 
278    * @param _newCommissionFee uint New verifier's fixed commission
279    * @return True if success.
280    */
281   function changeFixedCommissionFee(uint _newCommissionFee)
282                           public
283                           whenNotPaused
284                           whenNotStopped
285                           onlyOwner
286     returns(bool success)
287   {
288     uint oldCommissionFee = commissionFee;
289     commissionFee = _newCommissionFee;
290     emit LogChangeFixedCommissionFee(oldCommissionFee, commissionFee);
291     return true;
292   }
293 
294   
295   /**
296    * @dev Change verifier's address.
297    * Only owner can change verifier's address.
298    * 
299    * @param _newVerifier address New verifier's address
300    * @return True if success.
301    */
302   function changeVerifier(address _newVerifier)
303                           public
304                           whenNotPaused
305                           whenNotStopped
306                           onlyOwner
307     returns(bool success)
308   {
309     address oldVerifier = verifier;
310     verifier = _newVerifier;
311     emit LogChangeVerifier(oldVerifier, verifier);
312     return true;
313   }
314 
315   
316   /**
317    * @dev Transfer accrued commission to verifier's address.
318    * @return True if success.
319    */
320   function withdrawCommission()
321                         public
322                         whenNotPaused
323     returns(bool success)
324   {
325     uint commissionToTransfer = commissionToWithdraw;
326     commissionToWithdraw = 0;
327     owner.transfer(commissionToTransfer); // owner is verifier
328 
329     emit LogWithdrawCommission(commissionToTransfer);
330     return true;
331   }
332 
333   /**
334    * @dev Get transfer details.
335    * @param _transitAddress transit address assigned to transfer
336    * @return Transfer details (id, sender, amount)
337    */
338   function getTransfer(address _transitAddress)
339             public
340             constant
341     returns (
342 	     address id,
343 	     address from, // transfer sender
344 	     uint amount) // in wei
345   {
346     Transfer memory transfer = transferDct[_transitAddress];
347     return (
348 	    _transitAddress,
349 	    transfer.from,
350 	        transfer.amount
351 	    );
352   }
353 
354 
355   /**
356    * @dev Cancel transfer and get sent ether back. Only transfer sender can
357    * cancel transfer.
358    * @param _transitAddress transit address assigned to transfer
359    * @return True if success.
360    */
361   function cancelTransfer(address _transitAddress) public returns (bool success) {
362     Transfer memory transferOrder = transferDct[_transitAddress];
363 
364     // only sender can cancel transfer;
365     require(msg.sender == transferOrder.from);
366 
367     delete transferDct[_transitAddress];
368     
369     // transfer ether to recipient's address
370     msg.sender.transfer(transferOrder.amount);
371 
372     // log cancel event
373     emit LogCancel(msg.sender, _transitAddress);
374     
375     return true;
376   }
377 
378   /**
379    * @dev Verify that address is signed with correct verification private key.
380    * @param _transitAddress transit address assigned to transfer
381    * @param _recipient address Signed address.
382    * @param _v ECDSA signature parameter v.
383    * @param _r ECDSA signature parameters r.
384    * @param _s ECDSA signature parameters s.
385    * @return True if signature is correct.
386    */
387   function verifySignature(
388 			   address _transitAddress,
389 			   address _recipient,
390 			   uint8 _v,
391 			   bytes32 _r,
392 			   bytes32 _s)
393     public pure returns(bool success)
394   {
395     bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", _recipient);
396     address retAddr = ecrecover(prefixedHash, _v, _r, _s);
397     return retAddr == _transitAddress;
398   }
399 
400   /**
401    * @dev Verify that address is signed with correct private key for
402    * verification public key assigned to transfer.
403    * @param _transitAddress transit address assigned to transfer
404    * @param _recipient address Signed address.
405    * @param _v ECDSA signature parameter v.
406    * @param _r ECDSA signature parameters r.
407    * @param _s ECDSA signature parameters s.
408    * @return True if signature is correct.
409    */
410   function verifyTransferSignature(
411 				   address _transitAddress,
412 				   address _recipient,
413 				   uint8 _v,
414 				   bytes32 _r,
415 				   bytes32 _s)
416     public pure returns(bool success)
417   {
418     return (verifySignature(_transitAddress,
419 			    _recipient, _v, _r, _s));
420   }
421 
422   /**
423    * @dev Withdraw transfer to recipient's address if it is correctly signed
424    * with private key for verification public key assigned to transfer.
425    * 
426    * @param _transitAddress transit address assigned to transfer
427    * @param _recipient address Signed address.
428    * @param _v ECDSA signature parameter v.
429    * @param _r ECDSA signature parameters r.
430    * @param _s ECDSA signature parameters s.
431    * @return True if success.
432    */
433   function withdraw(
434 		    address _transitAddress,
435 		    address _recipient,
436 		    uint8 _v,
437 		    bytes32 _r,
438 		    bytes32 _s
439 		    )
440     public
441     onlyVerifier // only through verifier can withdraw transfer;
442     whenNotPaused
443     whenNotStopped
444     returns (bool success)
445   {
446     Transfer memory transferOrder = transferDct[_transitAddress];
447 
448     // verifying signature
449     require(verifySignature(_transitAddress,
450 		     _recipient, _v, _r, _s ));
451 
452     delete transferDct[_transitAddress];
453 
454     // transfer ether to recipient's address
455     _recipient.transfer(transferOrder.amount);
456 
457     // log withdraw event
458     emit LogWithdraw(transferOrder.from, _transitAddress, _recipient, transferOrder.amount);
459 
460     return true;
461   }
462 
463   // fallback function - do not receive ether by default
464   function() public payable {
465     revert();
466   }
467 }