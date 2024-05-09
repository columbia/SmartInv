1 pragma solidity ^0.4.22;
2 
3 /**
4  *@title abstract TokenContract
5  *@dev  token contract to call multisig functions
6 */
7 contract TokenContract{
8   function mint(address _to, uint256 _amount) public;
9   function finishMinting () public;
10   function setupMultisig (address _address) public;
11 }
12 
13 /**
14  *@title contract GangMultisig
15  *@dev using multisig access to call another contract functions
16 */
17 contract GangMultisig {
18   
19   /**
20    *@dev token contract variable, contains token address
21    *can use abstract contract functions
22   */
23   TokenContract public token;
24 
25   //@dev Variable to check multisig functions life time.
26   //change it before deploy in main network
27   uint public lifeTime = 86400; // seconds;
28   
29   //@dev constructor
30   constructor (address _token, uint _needApprovesToConfirm, address[] _owners) public{
31     require (_needApprovesToConfirm > 1 && _needApprovesToConfirm <= _owners.length);
32     
33     //@dev setup GangTokenContract by contract address
34     token = TokenContract(_token);
35 
36     addInitialOwners(_owners);
37 
38     needApprovesToConfirm = _needApprovesToConfirm;
39 
40     /**
41      *@dev Call function setupMultisig in token contract
42      *This function can be call once.
43     */
44     token.setupMultisig(address(this));
45     
46     ownersCount = _owners.length;
47   }
48 
49   /**
50    *@dev internal function, called in constructor
51    *Add initial owners in mapping 'owners'
52   */
53   function addInitialOwners (address[] _owners) internal {
54     for (uint i = 0; i < _owners.length; i++){
55       //@dev check for duplicate owner addresses
56       require(!owners[_owners[i]]);
57       owners[_owners[i]] = true;
58     }
59   }
60 
61   //@dev variable to check is minting finished;
62   bool public mintingFinished = false;
63 
64   //@dev Mapping which contains all active owners.
65   mapping (address => bool) public owners;
66 
67   //@dev Owner can add new proposal 1 time at each lifeTime cycle
68   mapping (address => uint32) public lastOwnersAction;
69   
70   modifier canCreate() { 
71     require (lastOwnersAction[msg.sender] + lifeTime < now);
72     lastOwnersAction[msg.sender] = uint32(now);
73     _; 
74   }
75   
76 
77   //@dev Modifier to check is message sender contains in mapping 'owners'.
78   modifier onlyOwners() { 
79     require (owners[msg.sender]); 
80     _; 
81   }
82 
83   //@dev current owners count
84   uint public ownersCount;
85 
86   //@dev current approves need to confirm for any function. Can't be less than 2. 
87   uint public needApprovesToConfirm;
88 
89   //Start Minting Tokens
90   struct SetNewMint {
91     address spender;
92     uint value;
93     uint8 confirms;
94     bool isExecute;
95     address initiator;
96     bool isCanceled;
97     uint32 creationTimestamp;
98     address[] confirmators;
99   }
100 
101   //@dev Variable which contains all information about current SetNewMint request
102   SetNewMint public setNewMint;
103 
104   event NewMintRequestSetup(address indexed initiator, address indexed spender, uint value);
105   event NewMintRequestUpdate(address indexed owner, uint8 indexed confirms, bool isExecute);
106   event NewMintRequestCanceled();  
107 
108   /**
109    * @dev Set new mint request, can be call only by owner
110    * @param _spender address The address which you want to mint to
111    * @param _value uint256 the amount of tokens to be minted
112    */
113   function setNewMintRequest (address _spender, uint _value) public onlyOwners canCreate {
114     require (setNewMint.creationTimestamp + lifeTime < uint32(now) || setNewMint.isExecute || setNewMint.isCanceled);
115 
116     require (!mintingFinished);
117 
118     address[] memory addr;
119 
120     setNewMint = SetNewMint(_spender, _value, 1, false, msg.sender, false, uint32(now), addr);
121     setNewMint.confirmators.push(msg.sender);
122 
123     emit NewMintRequestSetup(msg.sender, _spender, _value);
124   }
125 
126   /**
127    * @dev Approve mint request, can be call only by owner
128    * which don't call this mint request before.
129    */
130   function approveNewMintRequest () public onlyOwners {
131     require (!setNewMint.isExecute && !setNewMint.isCanceled);
132     require (setNewMint.creationTimestamp + lifeTime >= uint32(now));
133 
134     require (!mintingFinished);
135 
136     for (uint i = 0; i < setNewMint.confirmators.length; i++){
137       require(setNewMint.confirmators[i] != msg.sender);
138     }
139       
140     setNewMint.confirms++;
141     setNewMint.confirmators.push(msg.sender);
142 
143     if(setNewMint.confirms >= needApprovesToConfirm){
144       setNewMint.isExecute = true;
145 
146       token.mint(setNewMint.spender, setNewMint.value); 
147     }
148     emit NewMintRequestUpdate(msg.sender, setNewMint.confirms, setNewMint.isExecute);
149   }
150 
151   /**
152    * @dev Cancel mint request, can be call only by owner
153    * which created this mint request.
154    */
155   function cancelMintRequest () public {
156     require (msg.sender == setNewMint.initiator);    
157     require (!setNewMint.isCanceled && !setNewMint.isExecute);
158 
159     setNewMint.isCanceled = true;
160     emit NewMintRequestCanceled();
161   }
162   //Finish Minting Tokens
163 
164   //Start finishMinting functions
165   struct FinishMintingStruct {
166     uint8 confirms;
167     bool isExecute;
168     address initiator;
169     bool isCanceled;
170     uint32 creationTimestamp;
171     address[] confirmators;
172   }
173 
174   //@dev Variable which contains all information about current finishMintingStruct request
175   FinishMintingStruct public finishMintingStruct;
176 
177   event FinishMintingRequestSetup(address indexed initiator);
178   event FinishMintingRequestUpdate(address indexed owner, uint8 indexed confirms, bool isExecute);
179   event FinishMintingRequestCanceled();
180   event FinishMintingApproveCanceled(address owner);
181 
182   /**
183    * @dev New finish minting request, can be call only by owner
184    */
185   function finishMintingRequestSetup () public onlyOwners canCreate{
186     require ((finishMintingStruct.creationTimestamp + lifeTime < uint32(now) || finishMintingStruct.isCanceled) && !finishMintingStruct.isExecute);
187     
188     require (!mintingFinished);
189 
190     address[] memory addr;
191 
192     finishMintingStruct = FinishMintingStruct(1, false, msg.sender, false, uint32(now), addr);
193     finishMintingStruct.confirmators.push(msg.sender);
194 
195     emit FinishMintingRequestSetup(msg.sender);
196   }
197 
198   /**
199    * @dev Approve finish minting request, can be call only by owner
200    * which don't call this finish minting request before.
201    */
202   function ApproveFinishMintingRequest () public onlyOwners {
203     require (!finishMintingStruct.isCanceled && !finishMintingStruct.isExecute);
204     require (finishMintingStruct.creationTimestamp + lifeTime >= uint32(now));
205 
206     require (!mintingFinished);
207 
208     for (uint i = 0; i < finishMintingStruct.confirmators.length; i++){
209       require(finishMintingStruct.confirmators[i] != msg.sender);
210     }
211 
212     finishMintingStruct.confirmators.push(msg.sender);
213 
214     finishMintingStruct.confirms++;
215 
216     if(finishMintingStruct.confirms >= needApprovesToConfirm){
217       token.finishMinting();
218       finishMintingStruct.isExecute = true;
219       mintingFinished = true;
220     }
221     
222     emit FinishMintingRequestUpdate(msg.sender, finishMintingStruct.confirms, finishMintingStruct.isExecute);
223   }
224   
225   /**
226    * @dev Cancel finish minting request, can be call only by owner
227    * which created this finish minting request.
228    */
229   function cancelFinishMintingRequest () public {
230     require (msg.sender == finishMintingStruct.initiator);
231     require (!finishMintingStruct.isCanceled);
232 
233     finishMintingStruct.isCanceled = true;
234     emit FinishMintingRequestCanceled();
235   }
236   //Finish finishMinting functions
237 
238   //Start change approves count
239   struct SetNewApproves {
240     uint count;
241     uint8 confirms;
242     bool isExecute;
243     address initiator;
244     bool isCanceled;
245     uint32 creationTimestamp;
246     address[] confirmators;
247   }
248 
249   //@dev Variable which contains all information about current setNewApproves request
250   SetNewApproves public setNewApproves;
251 
252   event NewNeedApprovesToConfirmRequestSetup(address indexed initiator, uint count);
253   event NewNeedApprovesToConfirmRequestUpdate(address indexed owner, uint8 indexed confirms, bool isExecute);
254   event NewNeedApprovesToConfirmRequestCanceled();
255 
256   /**
257    * @dev Function to change 'needApprovesToConfirm' variable, can be call only by owner
258    * @param _count uint256 New need approves to confirm will needed
259    */
260   function setNewOwnersCountToApprove (uint _count) public onlyOwners canCreate {
261     require (setNewApproves.creationTimestamp + lifeTime < uint32(now) || setNewApproves.isExecute || setNewApproves.isCanceled);
262 
263     require (_count > 1);
264 
265     address[] memory addr;
266 
267     setNewApproves = SetNewApproves(_count, 1, false, msg.sender,false, uint32(now), addr);
268     setNewApproves.confirmators.push(msg.sender);
269 
270     emit NewNeedApprovesToConfirmRequestSetup(msg.sender, _count);
271   }
272 
273   /**
274    * @dev Approve new owners count request, can be call only by owner
275    * which don't call this new owners count request before.
276    */
277   function approveNewOwnersCount () public onlyOwners {
278     require (setNewApproves.count <= ownersCount);
279     require (setNewApproves.creationTimestamp + lifeTime >= uint32(now));
280     
281     for (uint i = 0; i < setNewApproves.confirmators.length; i++){
282       require(setNewApproves.confirmators[i] != msg.sender);
283     }
284     
285     require (!setNewApproves.isExecute && !setNewApproves.isCanceled);
286     
287     setNewApproves.confirms++;
288     setNewApproves.confirmators.push(msg.sender);
289 
290     if(setNewApproves.confirms >= needApprovesToConfirm){
291       setNewApproves.isExecute = true;
292 
293       needApprovesToConfirm = setNewApproves.count;   
294     }
295     emit NewNeedApprovesToConfirmRequestUpdate(msg.sender, setNewApproves.confirms, setNewApproves.isExecute);
296   }
297 
298   /**
299    * @dev Cancel new owners count request, can be call only by owner
300    * which created this owners count request.
301    */
302   function cancelNewOwnersCountRequest () public {
303     require (msg.sender == setNewApproves.initiator);    
304     require (!setNewApproves.isCanceled && !setNewApproves.isExecute);
305 
306     setNewApproves.isCanceled = true;
307     emit NewNeedApprovesToConfirmRequestCanceled();
308   }
309   
310   //Finish change approves count
311 
312   //Start add new owner
313   struct NewOwner {
314     address newOwner;
315     uint8 confirms;
316     bool isExecute;
317     address initiator;
318     bool isCanceled;
319     uint32 creationTimestamp;
320     address[] confirmators;
321   }
322 
323   NewOwner public addOwner;
324   //@dev Variable which contains all information about current addOwner request
325 
326   event AddOwnerRequestSetup(address indexed initiator, address newOwner);
327   event AddOwnerRequestUpdate(address indexed owner, uint8 indexed confirms, bool isExecute);
328   event AddOwnerRequestCanceled();
329 
330   /**
331    * @dev Function to add new owner in mapping 'owners', can be call only by owner
332    * @param _newOwner address new potentially owner
333    */
334   function setAddOwnerRequest (address _newOwner) public onlyOwners canCreate {
335     require (addOwner.creationTimestamp + lifeTime < uint32(now) || addOwner.isExecute || addOwner.isCanceled);
336     
337     address[] memory addr;
338 
339     addOwner = NewOwner(_newOwner, 1, false, msg.sender, false, uint32(now), addr);
340     addOwner.confirmators.push(msg.sender);
341 
342     emit AddOwnerRequestSetup(msg.sender, _newOwner);
343   }
344 
345   /**
346    * @dev Approve new owner request, can be call only by owner
347    * which don't call this new owner request before.
348    */
349   function approveAddOwnerRequest () public onlyOwners {
350     require (!addOwner.isExecute && !addOwner.isCanceled);
351     require (addOwner.creationTimestamp + lifeTime >= uint32(now));
352 
353     /**
354      *@dev new owner shoudn't be in owners mapping
355      */
356     require (!owners[addOwner.newOwner]);
357 
358     for (uint i = 0; i < addOwner.confirmators.length; i++){
359       require(addOwner.confirmators[i] != msg.sender);
360     }
361     
362     addOwner.confirms++;
363     addOwner.confirmators.push(msg.sender);
364 
365     if(addOwner.confirms >= needApprovesToConfirm){
366       addOwner.isExecute = true;
367 
368       owners[addOwner.newOwner] = true;
369       ownersCount++;
370     }
371 
372     emit AddOwnerRequestUpdate(msg.sender, addOwner.confirms, addOwner.isExecute);
373   }
374 
375   /**
376    * @dev Cancel new owner request, can be call only by owner
377    * which created this add owner request.
378    */
379   function cancelAddOwnerRequest() public {
380     require (msg.sender == addOwner.initiator);
381     require (!addOwner.isCanceled && !addOwner.isExecute);
382 
383     addOwner.isCanceled = true;
384     emit AddOwnerRequestCanceled();
385   }
386   //Finish add new owner
387 
388   //Start remove owner
389   NewOwner public removeOwners;
390   //@dev Variable which contains all information about current removeOwners request
391 
392   event RemoveOwnerRequestSetup(address indexed initiator, address newOwner);
393   event RemoveOwnerRequestUpdate(address indexed owner, uint8 indexed confirms, bool isExecute);
394   event RemoveOwnerRequestCanceled();
395 
396   /**
397    * @dev Function to remove owner from mapping 'owners', can be call only by owner
398    * @param _removeOwner address potentially owner to remove
399    */
400   function removeOwnerRequest (address _removeOwner) public onlyOwners canCreate {
401     require (removeOwners.creationTimestamp + lifeTime < uint32(now) || removeOwners.isExecute || removeOwners.isCanceled);
402 
403     address[] memory addr;
404     
405     removeOwners = NewOwner(_removeOwner, 1, false, msg.sender, false, uint32(now), addr);
406     removeOwners.confirmators.push(msg.sender);
407 
408     emit RemoveOwnerRequestSetup(msg.sender, _removeOwner);
409   }
410 
411   /**
412    * @dev Approve remove owner request, can be call only by owner
413    * which don't call this remove owner request before.
414    */
415   function approveRemoveOwnerRequest () public onlyOwners {
416     require (ownersCount - 1 >= needApprovesToConfirm && ownersCount > 2);
417 
418     require (owners[removeOwners.newOwner]);
419     
420     require (!removeOwners.isExecute && !removeOwners.isCanceled);
421     require (removeOwners.creationTimestamp + lifeTime >= uint32(now));
422 
423     for (uint i = 0; i < removeOwners.confirmators.length; i++){
424       require(removeOwners.confirmators[i] != msg.sender);
425     }
426     
427     removeOwners.confirms++;
428     removeOwners.confirmators.push(msg.sender);
429 
430     if(removeOwners.confirms >= needApprovesToConfirm){
431       removeOwners.isExecute = true;
432 
433       owners[removeOwners.newOwner] = false;
434       ownersCount--;
435 
436       _removeOwnersAproves(removeOwners.newOwner);
437     }
438 
439     emit RemoveOwnerRequestUpdate(msg.sender, removeOwners.confirms, removeOwners.isExecute);
440   }
441 
442   
443   /**
444    * @dev Cancel remove owner request, can be call only by owner
445    * which created this remove owner request.
446    */
447   function cancelRemoveOwnerRequest () public {
448     require (msg.sender == removeOwners.initiator);    
449     require (!removeOwners.isCanceled && !removeOwners.isExecute);
450 
451     removeOwners.isCanceled = true;
452     emit RemoveOwnerRequestCanceled();
453   }
454   //Finish remove owner
455 
456   //Start remove 2nd owner
457   NewOwner public removeOwners2;
458   //@dev Variable which contains all information about current removeOwners request
459 
460   event RemoveOwnerRequestSetup2(address indexed initiator, address newOwner);
461   event RemoveOwnerRequestUpdate2(address indexed owner, uint8 indexed confirms, bool isExecute);
462   event RemoveOwnerRequestCanceled2();
463 
464   /**
465    * @dev Function to remove owner from mapping 'owners', can be call only by owner
466    * @param _removeOwner address potentially owner to remove
467    */
468   function removeOwnerRequest2 (address _removeOwner) public onlyOwners canCreate {
469     require (removeOwners2.creationTimestamp + lifeTime < uint32(now) || removeOwners2.isExecute || removeOwners2.isCanceled);
470 
471     address[] memory addr;
472     
473     removeOwners2 = NewOwner(_removeOwner, 1, false, msg.sender, false, uint32(now), addr);
474     removeOwners2.confirmators.push(msg.sender);
475 
476     emit RemoveOwnerRequestSetup2(msg.sender, _removeOwner);
477   }
478 
479   /**
480    * @dev Approve remove owner request, can be call only by owner
481    * which don't call this remove owner request before.
482    */
483   function approveRemoveOwnerRequest2 () public onlyOwners {
484     require (ownersCount - 1 >= needApprovesToConfirm && ownersCount > 2);
485 
486     require (owners[removeOwners2.newOwner]);
487     
488     require (!removeOwners2.isExecute && !removeOwners2.isCanceled);
489     require (removeOwners2.creationTimestamp + lifeTime >= uint32(now));
490 
491     for (uint i = 0; i < removeOwners2.confirmators.length; i++){
492       require(removeOwners2.confirmators[i] != msg.sender);
493     }
494     
495     removeOwners2.confirms++;
496     removeOwners2.confirmators.push(msg.sender);
497 
498     if(removeOwners2.confirms >= needApprovesToConfirm){
499       removeOwners2.isExecute = true;
500 
501       owners[removeOwners2.newOwner] = false;
502       ownersCount--;
503 
504       _removeOwnersAproves(removeOwners2.newOwner);
505     }
506 
507     emit RemoveOwnerRequestUpdate2(msg.sender, removeOwners2.confirms, removeOwners2.isExecute);
508   }
509 
510   /**
511    * @dev Cancel remove owner request, can be call only by owner
512    * which created this remove owner request.
513    */
514   function cancelRemoveOwnerRequest2 () public {
515     require (msg.sender == removeOwners2.initiator);    
516     require (!removeOwners2.isCanceled && !removeOwners2.isExecute);
517 
518     removeOwners2.isCanceled = true;
519     emit RemoveOwnerRequestCanceled2();
520   }
521   //Finish remove 2nd owner
522 
523   /**
524    * @dev internal function to check and revert all actions
525    * by removed owner in this contract.
526    * If _oldOwner created request then it will be canceled.
527    * If _oldOwner approved request then his approve will canceled.
528    */
529   function _removeOwnersAproves(address _oldOwner) internal{
530     //@dev check actions in setNewMint requests
531     //@dev check for empty struct
532     if (setNewMint.initiator != address(0)){
533       //@dev check, can this request be approved by someone, if no then no sense to change something
534       if (setNewMint.creationTimestamp + lifeTime >= uint32(now) && !setNewMint.isExecute && !setNewMint.isCanceled){
535         if(setNewMint.initiator == _oldOwner){
536           setNewMint.isCanceled = true;
537           emit NewMintRequestCanceled();
538         }else{
539           //@dev Trying to find _oldOwner in struct confirmators
540           for (uint i = 0; i < setNewMint.confirmators.length; i++){
541             if (setNewMint.confirmators[i] == _oldOwner){
542               //@dev if _oldOwner confirmed this request he should be removed from confirmators
543               setNewMint.confirmators[i] = address(0);
544               setNewMint.confirms--;
545 
546               /**
547                *@dev Struct can be confirmed each owner just once
548                *so no sence to continue loop
549                */
550               break;
551             }
552           }
553         }
554       }
555     }
556 
557     /**@dev check actions in finishMintingStruct requests
558      * check for empty struct
559      */
560     if (finishMintingStruct.initiator != address(0)){
561       //@dev check, can this request be approved by someone, if no then no sense to change something
562       if (finishMintingStruct.creationTimestamp + lifeTime >= uint32(now) && !finishMintingStruct.isExecute && !finishMintingStruct.isCanceled){
563         if(finishMintingStruct.initiator == _oldOwner){
564           finishMintingStruct.isCanceled = true;
565           emit NewMintRequestCanceled();
566         }else{
567           //@dev Trying to find _oldOwner in struct confirmators
568           for (i = 0; i < finishMintingStruct.confirmators.length; i++){
569             if (finishMintingStruct.confirmators[i] == _oldOwner){
570               //@dev if _oldOwner confirmed this request he should be removed from confirmators
571               finishMintingStruct.confirmators[i] = address(0);
572               finishMintingStruct.confirms--;
573 
574               /**
575                *@dev Struct can be confirmed each owner just once
576                *so no sence to continue loop
577                */
578               break;
579             }
580           }
581         }     
582       }
583     }
584 
585     /**@dev check actions in setNewApproves requests
586      * check for empty struct
587      */
588     if (setNewApproves.initiator != address(0)){
589       //@dev check, can this request be approved by someone, if no then no sense to change something
590       if (setNewApproves.creationTimestamp + lifeTime >= uint32(now) && !setNewApproves.isExecute && !setNewApproves.isCanceled){
591         if(setNewApproves.initiator == _oldOwner){
592           setNewApproves.isCanceled = true;
593 
594           emit NewNeedApprovesToConfirmRequestCanceled();
595         }else{
596           //@dev Trying to find _oldOwner in struct confirmators
597           for (i = 0; i < setNewApproves.confirmators.length; i++){
598             if (setNewApproves.confirmators[i] == _oldOwner){
599               //@dev if _oldOwner confirmed this request he should be removed from confirmators
600               setNewApproves.confirmators[i] = address(0);
601               setNewApproves.confirms--;
602 
603               /**
604                *@dev Struct can be confirmed each owner just once
605                *so no sence to continue loop
606                */
607               break;
608             }
609           }
610         }
611       }
612     }
613 
614     /**
615      *@dev check actions in addOwner requests
616      *check for empty struct
617      */
618     if (addOwner.initiator != address(0)){
619       //@dev check, can this request be approved by someone, if no then no sense to change something
620       if (addOwner.creationTimestamp + lifeTime >= uint32(now) && !addOwner.isExecute && !addOwner.isCanceled){
621         if(addOwner.initiator == _oldOwner){
622           addOwner.isCanceled = true;
623           emit AddOwnerRequestCanceled();
624         }else{
625           //@dev Trying to find _oldOwner in struct confirmators
626           for (i = 0; i < addOwner.confirmators.length; i++){
627             if (addOwner.confirmators[i] == _oldOwner){
628               //@dev if _oldOwner confirmed this request he should be removed from confirmators
629               addOwner.confirmators[i] = address(0);
630               addOwner.confirms--;
631 
632               /**
633                *@dev Struct can be confirmed each owner just once
634                *so no sence to continue loop
635                */
636               break;
637             }
638           }
639         }
640       }
641     }
642 
643     /**@dev check actions in removeOwners requests
644      *@dev check for empty struct
645     */
646     if (removeOwners.initiator != address(0)){
647       //@dev check, can this request be approved by someone, if no then no sense to change something
648       if (removeOwners.creationTimestamp + lifeTime >= uint32(now) && !removeOwners.isExecute && !removeOwners.isCanceled){
649         if(removeOwners.initiator == _oldOwner){
650           removeOwners.isCanceled = true;
651           emit RemoveOwnerRequestCanceled();
652         }else{
653           //@dev Trying to find _oldOwner in struct confirmators
654           for (i = 0; i < removeOwners.confirmators.length; i++){
655             if (removeOwners.confirmators[i] == _oldOwner){
656               //@dev if _oldOwner confirmed this request he should be removed from confirmators
657               removeOwners.confirmators[i] = address(0);
658               removeOwners.confirms--;
659 
660               /**
661                *@dev Struct can be confirmed each owner just once
662                *so no sence to continue loop
663                */
664               break;
665             }
666           }
667         }
668       }
669     }
670   }
671 }