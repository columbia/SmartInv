1 pragma solidity ^0.4.18;
2 
3 interface trinityData{
4     
5     function getChannelBalance(bytes32 channelId) external view returns (uint256);
6     function getChannelStatus(bytes32 channelId) external view returns(uint8);
7     function getChannelExist(bytes32 channelId) external view returns(bool);
8     function getChannelClosingSettler(bytes32 channelId) external view returns (address);
9     function getSettlingTimeoutBlock(bytes32 channelId) external view returns(uint256);
10     
11     function getChannelPartners(bytes32 channelId) external view returns (address,address);
12     function getClosingSettle(bytes32 channelId)external view returns (uint256,uint256,address,address,uint256,uint256);
13     function getTimeLock(bytes32 channelId, bytes32 lockHash) external view returns(address,address,uint256,uint256, uint256, bool);
14 }
15 
16 contract TrinityEvent{
17 
18     event Deposit(bytes32 channleId, address partnerA, uint256 amountA,address partnerB, uint256 amountB);
19     event UpdateDeposit(bytes32 channleId, address partnerA, uint256 amountA, address partnerB, uint256 amountB);    
20     event QuickCloseChannel(bytes32 channleId, address closer, uint256 amount1, address partner, uint256 amount2);
21     event CloseChannel(bytes32 channleId, address invoker, uint256 nonce, uint256 blockNumber);
22     event UpdateTransaction(bytes32 channleId, address partnerA, uint256 amountA, address partnerB, uint256 amountB);
23     event Settle(bytes32 channleId, address partnerA, uint256 amountA, address partnerB, uint256 amountB);
24     event Withdraw(bytes32 channleId, address invoker, uint256 nonce, bytes32 hashLock, bytes32 secret);
25     event WithdrawUpdate(bytes32 channleId, bytes32 hashLock, uint256 nonce, uint256 balance);
26     event WithdrawSettle(bytes32 channleId, bytes32 hashLock, uint256 balance);
27 }
28 
29 contract Owner{
30     address public owner;
31     bool paused;
32     
33     constructor() public{
34         owner = msg.sender;
35         paused = false;
36     }
37     
38     modifier onlyOwner(){
39         require(owner == msg.sender);
40         _;
41     } 
42     
43     modifier whenNotPaused(){
44         require(!paused);
45         _;
46     }
47 
48     modifier whenPaused(){
49         require(paused);
50         _;
51     }
52 
53     //disable contract setting funciton
54     function pause() external onlyOwner whenNotPaused {
55         paused = true;
56     }
57 
58     //enable contract setting funciton
59     function unpause() public onlyOwner whenPaused {
60         paused = false;
61     }    
62 }
63 
64 contract VerifySignature{
65     
66     function verifyTimelock(bytes32 channelId,
67                             uint256 nonce,
68                             address sender,
69                             address receiver,
70                             uint256 lockPeriod ,
71                             uint256 lockAmount,
72                             bytes32 lockHash,
73                             bytes partnerAsignature,
74                             bytes partnerBsignature) internal pure returns(bool)  {
75 
76         address recoverA = verifyLockSignature(channelId, nonce, sender, receiver, lockPeriod, lockAmount,lockHash, partnerAsignature);
77         address recoverB = verifyLockSignature(channelId, nonce, sender, receiver, lockPeriod, lockAmount,lockHash, partnerBsignature);
78         if ((recoverA == sender && recoverB == receiver) || (recoverA == receiver && recoverB == sender)){
79             return true;
80         }
81         return false;
82     }
83 
84     function verifyLockSignature(bytes32 channelId,
85                                 uint256 nonce,
86                                 address sender,
87                                 address receiver,
88                                 uint256 lockPeriod ,
89                                 uint256 lockAmount,
90                                 bytes32 lockHash,
91                                 bytes signature) internal pure returns(address)  {
92 
93         bytes32 data_hash;
94         address recover_addr;
95         data_hash=keccak256(channelId, nonce, sender, receiver, lockPeriod, lockAmount,lockHash);
96         recover_addr=_recoverAddressFromSignature(signature,data_hash);
97         return recover_addr;
98     }
99 
100      /*
101      * Funcion:   parse both signature for check whether the transaction is valid
102      * Parameters:
103      *    addressA: node address that deployed on same channel;
104      *    addressB: node address that deployed on same channel;
105      *    balanceA : nodaA assets amount;
106      *    balanceB : nodaB assets assets amount;
107      *    nonce: transaction nonce;
108      *    signatureA: A signature for this transaction;
109      *    signatureB: B signature for this transaction;
110      * Return:
111      *    result: if both signature is valid, return TRUE, or return False.
112     */
113 
114     function verifyTransaction(
115         bytes32 channelId,
116         uint256 nonce,
117         address addressA,
118         uint256 balanceA,
119         address addressB,
120         uint256 balanceB,
121         bytes signatureA,
122         bytes signatureB) internal pure returns(bool result){
123 
124         address recoverA;
125         address recoverB;
126 
127         recoverA = recoverAddressFromSignature(channelId, nonce, addressA, balanceA, addressB, balanceB, signatureA);
128         recoverB = recoverAddressFromSignature(channelId, nonce, addressA, balanceA, addressB, balanceB, signatureB);
129         if ((recoverA == addressA && recoverB == addressB) || (recoverA == addressB && recoverB == addressA)){
130             return true;
131         }
132         return false;
133     }
134 
135     function recoverAddressFromSignature(
136         bytes32 channelId,
137         uint256 nonce,
138         address addressA,
139         uint256 balanceA,
140         address addressB,
141         uint256 balanceB,
142         bytes signature
143         ) internal pure returns(address)  {
144 
145         bytes32 data_hash;
146         address recover_addr;
147         data_hash=keccak256(channelId, nonce, addressA, balanceA, addressB, balanceB);
148         recover_addr=_recoverAddressFromSignature(signature,data_hash);
149         return recover_addr;
150     }
151 
152 	function _recoverAddressFromSignature(bytes signature,bytes32 dataHash) internal pure returns (address)
153     {
154         bytes32 r;
155         bytes32 s;
156         uint8 v;
157 
158         (r,s,v)=signatureSplit(signature);
159 
160         return ecrecoverDecode(dataHash,v, r, s);
161     }
162 
163     function signatureSplit(bytes signature)
164         pure
165         internal
166         returns (bytes32 r, bytes32 s, uint8 v)
167     {
168         assembly {
169             r := mload(add(signature, 32))
170             s := mload(add(signature, 64))
171             v := and(mload(add(signature, 65)), 0xff)
172         }
173         v=v+27;
174         require((v == 27 || v == 28), "check v value");
175     }
176 
177     function ecrecoverDecode(bytes32 datahash,uint8 v,bytes32 r,bytes32 s) internal pure returns(address addr){
178 
179         addr=ecrecover(datahash,v,r,s);
180         return addr;
181     }
182 }
183 
184 library SafeMath{
185     
186     function add256(uint256 addend, uint256 augend) internal pure returns(uint256 result){
187         uint256 sum = addend + augend;
188         assert(sum >= addend);
189         return sum;
190     }
191 
192     function sub256(uint256 a, uint256 b) internal pure returns (uint256) {
193         assert(b <= a);
194         return a - b;
195     }
196 }
197 
198 contract TrinityContractCore is Owner, VerifySignature, TrinityEvent{
199 
200     using SafeMath for uint256;
201 
202     uint8 constant OPENING = 1;
203     uint8 constant CLOSING = 2;
204     uint8 constant LOCKING = 3;
205     
206     trinityData public trinityDataContract;
207     
208     constructor(address _dataAddress) public{
209         trinityDataContract = trinityData(_dataAddress);
210     }
211     
212     function getChannelBalance(bytes32 channelId) public view returns (uint256){
213         return trinityDataContract.getChannelBalance(channelId);
214     }   
215 
216    function getChannelStatus(bytes32 channelId) public view returns (uint8){
217         return trinityDataContract.getChannelStatus(channelId);
218     }
219 
220     function getTimeoutBlock(bytes32 channelId) public view returns (uint256){
221         return trinityDataContract.getSettlingTimeoutBlock(channelId);
222     }
223 
224     function setDataContract(address _dataContract) external onlyOwner {
225         trinityDataContract = trinityData(_dataContract);
226     }
227 
228     /*
229       * Function: 1. Lock both participants assets to the contract
230       *           2. setup channel.
231       *           Before lock assets,both participants must approve contract can spend special amout assets.
232       * Parameters:
233       *    partnerA: partner that deployed on same channel;
234       *    partnerB: partner that deployed on same channel;
235       *    amountA : partnerA will lock assets amount;
236       *    amountB : partnerB will lock assets amount;
237       *    signedStringA: partnerA signature for this transaction;
238       *    signedStringB: partnerB signature for this transaction;
239       * Return:
240       *    Null;
241     */
242     
243     function deposit(bytes32 channelId,
244                      uint256 nonce,
245                      address funderAddress,
246                      uint256 funderAmount,
247                      address partnerAddress,
248                      uint256 partnerAmount,
249                      bytes funderSignature,
250                      bytes partnerSignature) external whenNotPaused{
251 
252         //verify both signature to check the behavious is valid.
253         
254         require(verifyTransaction(channelId, 
255                                   nonce, 
256                                   funderAddress, 
257                                   funderAmount, 
258                                   partnerAddress, 
259                                   partnerAmount, 
260                                   funderSignature, 
261                                   partnerSignature) == true);
262         
263         bool channelExist = trinityDataContract.getChannelExist(channelId);
264         //if channel have existed, can not create it again
265         require(channelExist == false, "check whether channel exist");
266         
267         bool callResult = address(trinityDataContract).call(bytes4(keccak256("depositData(bytes32,address,uint256,address,uint256)")),
268                                                 channelId,
269                                                 funderAddress,
270                                                 funderAmount,
271                                                 partnerAddress,
272                                                 partnerAmount);
273                                                 
274         require(callResult == true);
275         
276         emit Deposit(channelId, funderAddress, funderAmount, partnerAddress, partnerAmount);
277     }
278 
279     function updateDeposit(bytes32 channelId,
280                            uint256 nonce,
281                            address funderAddress,
282                            uint256 funderAmount,
283                            address partnerAddress,
284                            uint256 partnerAmount,
285                            bytes funderSignature,
286                            bytes partnerSignature) external whenNotPaused{
287         
288         //verify both signature to check the behavious is valid.
289         require(verifyTransaction(channelId, nonce, funderAddress, funderAmount, partnerAddress, partnerAmount, funderSignature, partnerSignature) == true, "verify signature");
290         
291         require(getChannelStatus(channelId) == OPENING, "check channel status");
292 
293         bool callResult = address(trinityDataContract).call(bytes4(keccak256("updateDeposit(bytes32,address,uint256,address,uint256)")),
294                                                 channelId,
295                                                 funderAddress,
296                                                 funderAmount,
297                                                 partnerAddress,
298                                                 partnerAmount);
299 
300         require(callResult == true, "call result");
301         
302         emit UpdateDeposit(channelId, funderAddress, funderAmount, partnerAddress, partnerAmount);
303     }
304     
305     function withdrawBalance(bytes32 channelId,
306                                uint256 nonce,
307                                address funder,
308                                uint256 funderBalance,
309                                address partner,
310                                uint256 partnerBalance,
311                                bytes closerSignature,
312                                bytes partnerSignature) external whenNotPaused{
313 
314         uint256 totalBalance = 0;
315 
316         //verify both signatures to check the behavious is valid
317         require(verifyTransaction(channelId, nonce, funder, funderBalance, partner, partnerBalance, closerSignature, partnerSignature) == true, "verify signature");
318 
319         require(nonce == 0, "check nonce");
320 
321         require((msg.sender == funder || msg.sender == partner), "verify caller");
322 
323         //channel should be opening
324         require(getChannelStatus(channelId) == OPENING, "check channel status");
325         
326         //sum of both balance should not larger than total deposited assets
327         totalBalance = funderBalance.add256(partnerBalance);
328         require(totalBalance <= getChannelBalance(channelId),"check channel balance");
329  
330         bool callResult = address(trinityDataContract).call(bytes4(keccak256("withdrawBalance(bytes32,address,uint256,address,uint256)")),
331                                                 channelId,
332                                                 funder,
333                                                 funderBalance,
334                                                 partner,
335                                                 partnerBalance);
336 
337         require(callResult == true, "call result");
338         
339         emit QuickCloseChannel(channelId, funder, funderBalance, partner, partnerBalance);
340     }    
341 
342     function quickCloseChannel(bytes32 channelId,
343                                uint256 nonce,
344                                address funder,
345                                uint256 funderBalance,
346                                address partner,
347                                uint256 partnerBalance,
348                                bytes closerSignature,
349                                bytes partnerSignature) external whenNotPaused{
350 
351         uint256 closeTotalBalance = 0;
352  
353         //verify both signatures to check the behavious is valid
354         require(verifyTransaction(channelId, nonce, funder, funderBalance, partner, partnerBalance, closerSignature, partnerSignature) == true, "verify signature");
355 
356         require(nonce == 0, "check nonce");
357 
358         require((msg.sender == funder || msg.sender == partner), "verify caller");
359 
360         //channel should be opening
361         require(getChannelStatus(channelId) == OPENING, "check channel status");
362         
363         //sum of both balance should not larger than total deposited assets
364         closeTotalBalance = funderBalance.add256(partnerBalance);
365         require(closeTotalBalance == getChannelBalance(channelId),"check channel balance");
366  
367         bool callResult = address(trinityDataContract).call(bytes4(keccak256("quickCloseChannel(bytes32,address,uint256,address,uint256)")),
368                                                 channelId,
369                                                 funder,
370                                                 funderBalance,
371                                                 partner,
372                                                 partnerBalance);
373 
374         require(callResult == true, "call result");
375         
376         emit QuickCloseChannel(channelId, funder, funderBalance, partner, partnerBalance);
377     }
378 
379     /*
380      * Funcion:   1. set channel status as closing
381                   2. withdraw assets for partner against closer
382                   3. freeze closer settle assets untill setelement timeout or partner confirmed the transaction;
383      * Parameters:
384      *    partnerA: partner that deployed on same channel;
385      *    partnerB: partner that deployed on same channel;
386      *    settleBalanceA : partnerA will withdraw assets amount;
387      *    settleBalanceB : partnerB will withdraw assets amount;
388      *    signedStringA: partnerA signature for this transaction;
389      *    signedStringB: partnerB signature for this transaction;
390      *    settleNonce: closer provided nonce for settlement;
391      * Return:
392      *    Null;
393      */
394 
395     function closeChannel(bytes32 channelId,
396                           uint256 nonce,
397                           address founder,
398                           uint256 founderBalance,      
399                           address partner,
400                           uint256 partnerBalance,
401                           bytes closerSignature,
402                           bytes partnerSignature) public whenNotPaused{
403 
404         bool callResult;
405         uint256 closeTotalBalance = 0;
406 
407         //verify both signatures to check the behavious is valid
408         require(verifyTransaction(channelId, nonce, founder, founderBalance, partner, partnerBalance, closerSignature, partnerSignature) == true, "verify signature");
409 
410         require(nonce != 0, "check nonce");
411 
412         require((msg.sender == founder || msg.sender == partner), "check caller");
413 
414         //channel should be opening
415         require(getChannelStatus(channelId) == OPENING, "check channel status");
416 
417         //sum of both balance should not larger than total deposited assets
418         closeTotalBalance = founderBalance.add256(partnerBalance);
419         require(closeTotalBalance == getChannelBalance(channelId), "check total balance");
420 
421         if (msg.sender == founder){
422             //sender want close channel actively, withdraw partner balance firstly
423             callResult = address(trinityDataContract).call(bytes4(keccak256("closeChannel(bytes32,uint256,address,uint256,address,uint256)")),
424                                                 channelId,
425                                                 nonce,
426                                                 founder,
427                                                 founderBalance,
428                                                 partner,
429                                                 partnerBalance);
430 
431             require(callResult == true);    
432         }
433         else if(msg.sender == partner)
434         {
435             callResult = address(trinityDataContract).call(bytes4(keccak256("closeChannel(bytes32,uint256,address,uint256,address,uint256)")),
436                                                 channelId,
437                                                 nonce,
438                                                 partner,
439                                                 partnerBalance,
440                                                 founder,
441                                                 founderBalance);
442 
443             require(callResult == true);              
444         }
445         
446         emit CloseChannel(channelId, msg.sender, nonce, getTimeoutBlock(channelId));
447     }
448 
449     /*
450      * Funcion: After closer apply closed channle, partner update owner final transaction to check whether closer submitted invalid information
451      *      1. if bothe nonce is same, the submitted settlement is valid, withdraw closer assets
452             2. if partner nonce is larger than closer, then jugement closer have submitted invalid data, withdraw closer assets to partner;
453             3. if partner nonce is less than closer, then jugement closer submitted data is valid, withdraw close assets.
454      * Parameters:
455      *    partnerA: partner that deployed on same channel;
456      *    partnerB: partner that deployed on same channel;
457      *    updateBalanceA : partnerA will withdraw assets amount;
458      *    updateBalanceB : partnerB will withdraw assets amount;
459      *    signedStringA: partnerA signature for this transaction;
460      *    signedStringB: partnerB signature for this transaction;
461      *    settleNonce: closer provided nonce for settlement;
462      * Return:
463      *    Null;
464     */
465     function updateTransaction(bytes32 channelId,
466                                uint256 nonce,
467                                address partnerA,
468                                uint256 updateBalanceA,       
469                                address partnerB,
470                                uint256 updateBalanceB,
471                                bytes signedStringA,
472                                bytes signedStringB) external whenNotPaused{
473 
474         uint256 updateTotalBalance = 0;
475         
476         require(verifyTransaction(channelId, nonce, partnerA, updateBalanceA, partnerB, updateBalanceB, signedStringA, signedStringB) == true, "verify signature");
477 
478         require(nonce != 0, "check nonce");
479 
480         // only when channel status is closing, node can call it
481         require(getChannelStatus(channelId) == CLOSING, "check channel status");
482 
483         // channel closer can not call it
484         require(msg.sender == trinityDataContract.getChannelClosingSettler(channelId), "check settler");
485 
486         //sum of both balance should not larger than total deposited asset
487         updateTotalBalance = updateBalanceA.add256(updateBalanceB);
488         require(updateTotalBalance == getChannelBalance(channelId), "check total balance");
489     
490         verifyUpdateTransaction(channelId, nonce, partnerA, updateBalanceA, partnerB, updateBalanceB);
491     }    
492     
493     function verifyUpdateTransaction(bytes32 channelId,
494                                      uint256 nonce,
495                                      address partnerA,
496                                      uint256 updateBalanceA,
497                                      address partnerB,
498                                      uint256 updateBalanceB) internal{
499         
500         address channelSettler;
501         address channelCloser;
502         uint256 closingNonce;
503         uint256 closerBalance;
504         uint256 settlerBalance;
505         bool callResult;
506         
507         (closingNonce, ,channelCloser,channelSettler,closerBalance,settlerBalance) = trinityDataContract.getClosingSettle(channelId);
508         // if updated nonce is less than (or equal to) closer provided nonce, folow closer provided balance allocation
509         if (nonce <= closingNonce){
510             
511         }
512 
513         // if updated nonce is equal to nonce+1 that closer provided nonce, folow partner provided balance allocation
514         else if (nonce == (closingNonce + 1)){
515             channelCloser = partnerA;
516             closerBalance = updateBalanceA;
517             channelSettler = partnerB;
518             settlerBalance = updateBalanceB;
519         }
520 
521         // if updated nonce is larger than nonce+1 that closer provided nonce, determine closer provided invalid transaction, partner will also get closer assets
522         else if (nonce > (closingNonce + 1)){
523             closerBalance = 0;
524             settlerBalance = getChannelBalance(channelId);
525         }        
526         
527         callResult = address(trinityDataContract).call(bytes4(keccak256("closingSettle(bytes32,address,uint256,address,uint256)")),
528                                                 channelId,
529                                                 channelCloser,
530                                                 closerBalance,
531                                                 channelSettler,
532                                                 settlerBalance);
533 
534         require(callResult == true);
535         
536         emit UpdateTransaction(channelId, channelCloser, closerBalance, channelSettler, settlerBalance);        
537     }
538 
539     
540     /*
541      * Function: after apply close channnel, closer can withdraw assets until special settle window period time over
542      * Parameters:
543      *   partner: partner address that setup in same channel with sender;
544      * Return:
545          Null
546     */
547  
548     function settleTransaction(bytes32 channelId) external whenNotPaused{
549     
550         uint256 expectedSettleBlock;
551         uint256 closerBalance;
552         uint256 settlerBalance;
553         address channelCloser;
554         address channelSettler;
555     
556         (, expectedSettleBlock,channelCloser,channelSettler,closerBalance,settlerBalance) = trinityDataContract.getClosingSettle(channelId); 
557         
558         // only chanel closer can call the function and channel status must be closing
559         require(msg.sender == channelCloser, "check closer");
560         
561         require(expectedSettleBlock < block.number, "check settle time");        
562         
563         require(getChannelStatus(channelId) == CLOSING, "check channel status");
564         
565         bool callResult = address(trinityDataContract).call(bytes4(keccak256("closingSettle(bytes32,address,uint256,address,uint256)")),
566                                                 channelId,
567                                                 channelCloser,
568                                                 closerBalance,
569                                                 channelSettler,
570                                                 settlerBalance);
571 
572         require(callResult == true);        
573         
574         emit Settle(channelId, channelCloser, closerBalance, channelSettler, settlerBalance);
575     }
576  
577      function withdraw(bytes32 channelId,
578                       uint256 nonce,
579                       address sender,
580                       address receiver,
581                       uint256 lockTime ,
582                       uint256 lockAmount,
583                       bytes32 lockHash,
584                       bytes partnerAsignature,
585                       bytes partnerBsignature,
586                       bytes32 secret) external {
587 
588         require(verifyTimelock(channelId, nonce, sender, receiver, lockTime,lockAmount,lockHash,partnerAsignature,partnerBsignature) == true, "verify signature");
589 
590         require(nonce != 0, "check nonce");
591         
592         require(msg.sender == receiver, "check caller");
593         
594         require(lockTime > block.number, "check lock time");        
595 
596         require(lockHash == keccak256(secret), "verify hash");
597         
598         require(lockAmount <= getChannelBalance(channelId));        
599 
600         require(verifyWithdraw(channelId,lockHash) == true);
601 
602         bool callResult = address(trinityDataContract).call(bytes4(keccak256("withdrawLocks(bytes32,uint256,uint256,uint256,bytes32)")),
603                                                 channelId,
604                                                 nonce,
605                                                 lockAmount,
606                                                 lockTime,
607                                                 lockHash);  
608                                                 
609         bool result = address(trinityDataContract).call(bytes4(keccak256("withdrawPartners(bytes32,address,address,bytes32)")),
610                                                 channelId,
611                                                 sender,
612                                                 receiver,
613                                                 lockHash);                                                 
614                                                 
615         require(callResult == true && result == true);
616         
617         emit Withdraw(channelId, msg.sender, nonce, lockHash, secret);
618         
619     }
620     
621     function verifyWithdraw(bytes32 channelId,
622                             bytes32 lockHash) internal view returns(bool){
623         
624         bool withdrawLocked;
625         
626         (, , , , ,withdrawLocked) = trinityDataContract.getTimeLock(channelId,lockHash);
627 
628         require(withdrawLocked == false, "check withdraw status");
629         
630         return true;
631     }
632 
633 
634     function withdrawUpdate(bytes32 channelId,
635                       uint256 nonce,
636                       address sender,
637                       address receiver,
638                       uint256 lockTime ,
639                       uint256 lockAmount,
640                       bytes32 lockHash,
641                       bytes partnerAsignature,
642                       bytes partnerBsignature) external whenNotPaused{
643 
644         address withdrawVerifier;
645         
646         require(verifyTimelock(channelId, nonce, sender, receiver, lockTime,lockAmount,lockHash,partnerAsignature,partnerBsignature) == true, "verify signature");
647 
648         require(nonce != 0, "check nonce");
649 
650         require(lockTime > block.number, "check lock time"); 
651         
652         (withdrawVerifier, , , , , ) = trinityDataContract.getTimeLock(channelId,lockHash);
653         
654         require(msg.sender == withdrawVerifier, "check verifier");
655         
656         verifyWithdrawUpdate(channelId, lockHash, nonce, lockAmount);
657         
658     }
659 
660     function verifyWithdrawUpdate(bytes32 channelId, 
661                                 bytes32 lockHash,
662                                 uint256 nonce,
663                                 uint256 lockAmount) internal{
664         
665         address withdrawVerifier;
666         address withdrawer;
667         uint256 updateNonce;
668         uint256 channelTotalBalance;
669         bool withdrawLocked;
670         bool callResult = false;
671         
672         (withdrawVerifier,withdrawer, updateNonce, , ,withdrawLocked) = trinityDataContract.getTimeLock(channelId,lockHash);
673 
674         require(withdrawLocked == true, "check withdraw status");
675         
676         channelTotalBalance = getChannelBalance(channelId);
677         require(lockAmount <= channelTotalBalance);
678               
679         if (nonce <= updateNonce){
680             channelTotalBalance = channelTotalBalance.sub256(lockAmount);
681             
682             callResult = address(trinityDataContract).call(bytes4(keccak256("withdrawSettle(bytes32,address,uint256,uint256,bytes32)")),
683                                                 channelId,
684                                                 withdrawer,
685                                                 lockAmount,
686                                                 channelTotalBalance,
687                                                 lockHash);            
688         }
689         else if(nonce > updateNonce){
690 
691             callResult = address(trinityDataContract).call(bytes4(keccak256("withdrawSettle(bytes32,address,uint256,uint256,bytes32)")),
692                                                 channelId,
693                                                 withdrawVerifier,
694                                                 channelTotalBalance,
695                                                 0,
696                                                 lockHash);   
697             channelTotalBalance = 0;                                    
698         }  
699         
700         require(callResult == true);        
701         
702         emit WithdrawUpdate(channelId, lockHash, nonce, channelTotalBalance); 
703     }
704 
705     function withdrawSettle(bytes32 channelId,
706                             bytes32 lockHash,
707                             bytes32 secret) external whenNotPaused{
708                                 
709         address _withdrawer;
710         uint256 lockAmount;
711         uint256 lockTime;
712         uint256 _channelTotalBalance;
713         bool withdrawLocked;
714         
715         require(lockHash == keccak256(secret), "verify hash");
716         
717         (,_withdrawer, ,lockAmount,lockTime,withdrawLocked) = trinityDataContract.getTimeLock(channelId,lockHash);
718         
719         require(withdrawLocked == true, "check withdraw status");
720         
721         require(msg.sender == _withdrawer, "check caller");
722         
723         require(lockTime < block.number, "check time lock");           
724 
725         _channelTotalBalance = getChannelBalance(channelId);
726         _channelTotalBalance = _channelTotalBalance.sub256(lockAmount);
727 
728         bool callResult = address(trinityDataContract).call(bytes4(keccak256("withdrawSettle(bytes32,address,uint256,uint256,bytes32)")),
729                                                 channelId,
730                                                 msg.sender,
731                                                 lockAmount,
732                                                 _channelTotalBalance,
733                                                 lockHash);   
734                                                 
735         require(callResult == true);   
736         
737         emit WithdrawSettle(channelId, lockHash, _channelTotalBalance);
738     }
739 
740     function () public { revert(); }
741 }