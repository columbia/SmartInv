1 contract Assertive {
2   function assert(bool assertion) {
3     if (!assertion) throw;
4   }
5 }
6 
7 contract TokenRecipient {
8   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
9 }
10 
11 contract Owned is Assertive {
12   address internal owner;
13   event SetOwner(address indexed previousOwner, address indexed newOwner);
14   function Owned () {
15     owner = msg.sender;
16   }
17   modifier onlyOwner {
18     assert(msg.sender == owner);
19     _
20   }
21   function setOwner(address newOwner) onlyOwner {
22     SetOwner(owner, newOwner);
23     owner = newOwner;
24   }
25   function getOwner() returns (address out) {
26     return owner;
27   }
28 }
29 
30 contract StateTransferrable is Owned {
31   bool internal locked;
32   event Locked(address indexed from);
33   event PropertySet(address indexed from);
34   modifier onlyIfUnlocked {
35     assert(!locked);
36     _
37   }
38   modifier setter {
39     _
40     PropertySet(msg.sender);
41   }
42   modifier onlyOwnerUnlocked {
43     assert(!locked && msg.sender == owner);
44     _
45   }
46   function lock() onlyOwner onlyIfUnlocked {
47     locked = true;
48     Locked(msg.sender);
49   }
50   function isLocked() returns (bool status) {
51     return locked;
52   }
53 }
54 
55 contract TrustEvents {
56   event AuthInit(address indexed from);
57   event AuthComplete(address indexed from, address indexed with);
58   event AuthPending(address indexed from);
59   event Unauthorized(address indexed from);
60   event InitCancel(address indexed from);
61   event NothingToCancel(address indexed from);
62   event SetMasterKey(address indexed from);
63   event AuthCancel(address indexed from, address indexed with);
64   event NameRegistered(address indexed from, bytes32 indexed name);
65 }
66 
67 contract Trust is StateTransferrable, TrustEvents {
68   mapping (address => bool) public masterKeys;
69   mapping (address => bytes32) public nameRegistry;
70   address[] public masterKeyIndex;
71   mapping (address => bool) public masterKeyActive;
72   mapping (address => bool) public trustedClients;
73   mapping (bytes32 => address) public functionCalls;
74   mapping (address => bytes32) public functionCalling;
75   function activateMasterKey(address addr) internal {
76     if (!masterKeyActive[addr]) {
77       masterKeyActive[addr] = true;
78       masterKeyIndex.push(addr);
79     }
80   }
81   function setTrustedClient(address addr) onlyOwnerUnlocked setter {
82     trustedClients[addr] = true;
83   }
84   function untrustClient(address addr) multisig(sha3(msg.data)) {
85     trustedClients[addr] = false;
86   }
87   function trustClient(address addr) multisig(sha3(msg.data)) {
88     trustedClients[addr] = true;
89   }
90   function setMasterKey(address addr) onlyOwnerUnlocked {
91     assert(!masterKeys[addr]);
92     activateMasterKey(addr);
93     masterKeys[addr] = true;
94     SetMasterKey(msg.sender);
95   }
96   modifier onlyMasterKey {
97     assert(masterKeys[msg.sender]);
98     _
99   }
100   function extractMasterKeyIndexLength() returns (uint256 length) {
101     return masterKeyIndex.length;
102   }
103   function resetAction(bytes32 hash) internal {
104     address addr = functionCalls[hash];
105     functionCalls[hash] = 0x0;
106     functionCalling[addr] = bytes32(0);
107   }
108   function authCancel(address from) external returns (uint8 status) {
109     if (!masterKeys[from] || !trustedClients[msg.sender]) {
110       Unauthorized(from);
111       return 0;
112     }
113     bytes32 call = functionCalling[from];
114     if (call == bytes32(0)) {
115       NothingToCancel(from);
116       return 1;
117     } else {
118       AuthCancel(from, from);
119       functionCalling[from] = bytes32(0);
120       functionCalls[call] = 0x0;
121       return 2;
122     }
123   }
124   function cancel() returns (uint8 code) {
125     if (!masterKeys[msg.sender]) {
126       Unauthorized(msg.sender);
127       return 0;
128     }
129     bytes32 call = functionCalling[msg.sender];
130     if (call == bytes32(0)) {
131       NothingToCancel(msg.sender);
132       return 1;
133     } else {
134       AuthCancel(msg.sender, msg.sender);
135       bytes32 hash = functionCalling[msg.sender];
136       functionCalling[msg.sender] = 0x0;
137       functionCalls[hash] = 0;
138       return 2;
139     }
140   }
141   function authCall(address from, bytes32 hash) external returns (uint8 code) {
142     if (!masterKeys[from] && !trustedClients[msg.sender]) {
143       Unauthorized(from);
144       return 0;
145     }
146     if (functionCalling[from] == 0) {
147       if (functionCalls[hash] == 0x0) {
148         functionCalls[hash] = from;
149         functionCalling[from] = hash;
150         AuthInit(from);
151         return 1;
152       } else { 
153         AuthComplete(functionCalls[hash], from);
154         resetAction(hash);
155         return 2;
156       }
157     } else {
158       AuthPending(from);
159       return 3;
160     }
161   }
162   modifier multisig (bytes32 hash) {
163     if (!masterKeys[msg.sender]) {
164       Unauthorized(msg.sender);
165     } else if (functionCalling[msg.sender] == 0) {
166       if (functionCalls[hash] == 0x0) {
167         functionCalls[hash] = msg.sender;
168         functionCalling[msg.sender] = hash;
169         AuthInit(msg.sender);
170       } else { 
171         AuthComplete(functionCalls[hash], msg.sender);
172         resetAction(hash);
173         _
174       }
175     } else {
176       AuthPending(msg.sender);
177     }
178   }
179   function voteOutMasterKey(address addr) multisig(sha3(msg.data)) {
180     assert(masterKeys[addr]);
181     masterKeys[addr] = false;
182   }
183   function voteInMasterKey(address addr) multisig(sha3(msg.data)) {
184     assert(!masterKeys[addr]);
185     activateMasterKey(addr);
186     masterKeys[addr] = true;
187   }
188   function identify(bytes32 name) onlyMasterKey {
189     nameRegistry[msg.sender] = name;
190     NameRegistered(msg.sender, name);
191   }
192   function nameFor(address addr) returns (bytes32 name) {
193     return nameRegistry[addr];
194   }
195 }
196 
197 
198 contract TrustClient is StateTransferrable, TrustEvents {
199   address public trustAddress;
200   function setTrust(address addr) setter onlyOwnerUnlocked {
201     trustAddress = addr;
202   }
203   function nameFor(address addr) constant returns (bytes32 name) {
204     return Trust(trustAddress).nameFor(addr);
205   }
206   function cancel() returns (uint8 status) {
207     assert(trustAddress != address(0x0));
208     uint8 code = Trust(trustAddress).authCancel(msg.sender);
209     if (code == 0) Unauthorized(msg.sender);
210     else if (code == 1) NothingToCancel(msg.sender);
211     else if (code == 2) AuthCancel(msg.sender, msg.sender);
212     return code;
213   }
214   modifier multisig (bytes32 hash) {
215     assert(trustAddress != address(0x0));
216     address current = Trust(trustAddress).functionCalls(hash);
217     uint8 code = Trust(trustAddress).authCall(msg.sender, hash);
218     if (code == 0) Unauthorized(msg.sender);
219     else if (code == 1) AuthInit(msg.sender);
220     else if (code == 2) {
221       AuthComplete(current, msg.sender);
222       _
223     }
224     else if (code == 3) {
225       AuthPending(msg.sender);
226     }
227   }
228 }
229 contract Relay {
230   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success);
231 }
232 contract TokenBase is Owned {
233     bytes32 public standard = 'Token 0.1';
234     bytes32 public name;
235     bytes32 public symbol;
236     uint256 public totalSupply;
237     bool public allowTransactions;
238 
239     event Approval(address indexed from, address indexed spender, uint256 amount);
240 
241     mapping (address => uint256) public balanceOf;
242     mapping (address => mapping (address => uint256)) public allowance;
243 
244     event Transfer(address indexed from, address indexed to, uint256 value);
245 
246     function transfer(address _to, uint256 _value) returns (bool success);
247     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
248     function approve(address _spender, uint256 _value) returns (bool success);
249     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
250 
251     function () {
252         throw;
253     }
254 }
255 
256 contract Precision {
257   uint8 public decimals;
258 }
259 contract Token is TokenBase, Precision {}
260 contract Util {
261   function pow10(uint256 a, uint8 b) internal returns (uint256 result) {
262     for (uint8 i = 0; i < b; i++) {
263       a *= 10;
264     }
265     return a;
266   }
267   function div10(uint256 a, uint8 b) internal returns (uint256 result) {
268     for (uint8 i = 0; i < b; i++) {
269       a /= 10;
270     }
271     return a;
272   }
273   function max(uint256 a, uint256 b) internal returns (uint256 res) {
274     if (a >= b) return a;
275     return b;
276   }
277 }
278 
279 /**
280  * @title DVIP Contract. DCAsset Membership Token contract.
281  *
282  * @author Ray Pulver, ray@decentralizedcapital.com
283  */
284 contract DVIP is Token, StateTransferrable, TrustClient, Util {
285 
286   uint256 public totalSupply;
287 
288   mapping (address => bool) public frozenAccount;
289 
290   mapping (address => address[]) public allowanceIndex;
291   mapping (address => mapping (address => bool)) public allowanceActive;
292   address[] public accountIndex;
293   mapping (address => bool) public accountActive;
294   address public oversightAddress;
295   uint256 public expiry;
296 
297   uint256 public treasuryBalance;
298 
299   bool public isActive;
300   mapping (address => uint256) public exportFee;
301   address[] public exportFeeIndex;
302   mapping (address => bool) exportFeeActive;
303 
304   mapping (address => uint256) public importFee;
305   address[] public importFeeIndex;
306   mapping (address => bool) importFeeActive;
307 
308   event FrozenFunds(address target, bool frozen);
309   event PrecisionSet(address indexed from, uint8 precision);
310   event TransactionsShutDown(address indexed from);
311   event FeeSetup(address indexed from, address indexed target, uint256 amount);
312 
313 
314   /**
315    * Constructor.
316    *
317    */
318   function DVIP() {
319     isActive = true;
320     treasuryBalance = 0;
321     totalSupply = 0;
322     name = "DVIP";
323     symbol = "DVIP";
324     decimals = 6;
325     allowTransactions = true;
326     expiry = 1514764800; //1 jan 2018
327   }
328 
329 
330   /* ---------------  modifiers  --------------*/
331 
332   /**
333    * Makes sure a method is only called by an overseer.
334    */
335   modifier onlyOverseer {
336     assert(msg.sender == oversightAddress);
337     _
338   }
339 
340   /* ---------------  setter methods, only for the unlocked state --------------*/
341 
342 
343   /**
344    * Sets the oversight address (not the contract).
345    *
346    * @param addr The oversight contract address.
347    */
348   function setOversight(address addr) onlyOwnerUnlocked setter {
349     oversightAddress = addr;
350   }
351 
352 
353   /**
354    * Sets the total supply
355    *
356    * @param total Total supply of the asset.
357    */
358   function setTotalSupply(uint256 total) onlyOwnerUnlocked setter {
359     totalSupply = total;
360   }
361 
362   /**
363    * Set the Token Standard the contract applies to.
364    *
365    * @param std the Standard.
366    */
367   function setStandard(bytes32 std) onlyOwnerUnlocked setter {
368     standard = std;
369   }
370 
371   /**
372    * Sets the name of the contraxt
373    *
374    * @param _name the name.
375    */
376   function setName(bytes32 _name) onlyOwnerUnlocked setter {
377     name = _name;
378   }
379 
380   /**
381    * Sets the symbol
382    *
383    * @param sym The Symbol
384    */
385   function setSymbol(bytes32 sym) onlyOwnerUnlocked setter {
386     symbol = sym;
387   }
388 
389   /**
390    * Sets the precision
391    *
392    * @param precision Amount of decimals
393    */
394   function setPrecisionDirect(uint8 precision) onlyOwnerUnlocked {
395     decimals = precision;
396     PrecisionSet(msg.sender, precision);
397   }
398 
399   /**
400    * Sets the balance of a certain account.
401    *
402    * @param addr Address of the account
403    * @param amount Amount of assets to set on the account
404    */
405   function setAccountBalance(address addr, uint256 amount) onlyOwnerUnlocked {
406     balanceOf[addr] = amount;
407     activateAccount(addr);
408   }
409 
410   /**
411    * Sets an allowance from a specific account to a specific account.
412    *
413    * @param from From-part of the allowance
414    * @param to To-part of the allowance
415    * @param amount Amount of the allowance
416    */
417   function setAccountAllowance(address from, address to, uint256 amount) onlyOwnerUnlocked {
418     allowance[from][to] = amount;
419     activateAllowanceRecord(from, to);
420   }
421 
422   /**
423    * Sets the treasure balance to a certain account.
424    *
425    * @param amount Amount of assets to pre-set in the treasury
426    */
427   function setTreasuryBalance(uint256 amount) onlyOwnerUnlocked {
428     treasuryBalance = amount;
429   }
430 
431   /**
432    * Sets a certain account on frozen/unfrozen
433    *
434    * @param addr Account that will be frozen/unfrozen
435    * @param frozen Boolean to freeze or unfreeze
436    */
437   function setAccountFrozenStatus(address addr, bool frozen) onlyOwnerUnlocked {
438     activateAccount(addr);
439     frozenAccount[addr] = frozen;
440   }
441 
442   /**
443    * Sets up a import fee for a certain address.
444    *
445    * @param addr Address that will require fee
446    * @param fee Amount of fee
447    */
448   function setupImportFee(address addr, uint256 fee) onlyOwnerUnlocked {
449     importFee[addr] = fee;
450     activateImportFeeChargeRecord(addr);
451     FeeSetup(msg.sender, addr, fee);
452   }
453  
454   /**
455    * Sets up a export fee for a certain address.
456    *
457    * @param addr Address that will require fee
458    * @param fee Amount of fee
459    */
460   function setupExportFee(address addr, uint256 fee) onlyOwnerUnlocked {
461     exportFee[addr] = fee;
462     activateExportFeeChargeRecord(addr);
463     FeeSetup(msg.sender, addr, fee);
464   }
465 
466   /* ---------------  main token methods  --------------*/
467 
468 
469   /**
470    * @notice Transfer `_amount` from `msg.sender.address()` to `_to`.
471    *
472    * @param _to Address that will receive.
473    * @param _amount Amount to be transferred.
474    */
475   function transfer(address _to, uint256 _amount) returns (bool success) {
476     assert(allowTransactions);
477     assert(!frozenAccount[msg.sender]);
478     assert(balanceOf[msg.sender] >= _amount);
479     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
480     activateAccount(msg.sender);
481     activateAccount(_to);
482     balanceOf[msg.sender] -= _amount;
483     if (_to == address(this)) treasuryBalance += _amount;
484     else balanceOf[_to] += _amount;
485     Transfer(msg.sender, _to, _amount);
486     return true;
487   }
488 
489   /**
490    * @notice Transfer `_amount` from `_from` to `_to`.
491    *
492    * @param _from Origin address
493    * @param _to Address that will receive
494    * @param _amount Amount to be transferred.
495    * @return result of the method call
496    */
497   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
498     assert(allowTransactions);
499     assert(!frozenAccount[msg.sender]);
500     assert(!frozenAccount[_from]);
501     assert(balanceOf[_from] >= _amount);
502     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
503     assert(_amount <= allowance[_from][msg.sender]);
504     balanceOf[_from] -= _amount;
505     balanceOf[_to] += _amount;
506     allowance[_from][msg.sender] -= _amount;
507     activateAccount(_from);
508     activateAccount(_to);
509     activateAccount(msg.sender);
510     Transfer(_from, _to, _amount);
511     return true;
512   }
513 
514   /**
515    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
516    *
517    * @param _spender Address that receives the cheque
518    * @param _amount Amount on the cheque
519    * @param _extraData Consequential contract to be executed by spender in same transcation.
520    * @return result of the method call
521    */
522   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
523     assert(allowTransactions);
524     assert(!frozenAccount[msg.sender]);
525     allowance[msg.sender][_spender] = _amount;
526     activateAccount(msg.sender);
527     activateAccount(_spender);
528     activateAllowanceRecord(msg.sender, _spender);
529     TokenRecipient spender = TokenRecipient(_spender);
530     spender.receiveApproval(msg.sender, _amount, this, _extraData);
531     Approval(msg.sender, _spender, _amount);
532     return true;
533   }
534 
535   /**
536    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
537    *
538    * @param _spender Address that receives the cheque
539    * @param _amount Amount on the cheque
540    * @return result of the method call
541    */
542   function approve(address _spender, uint256 _amount) returns (bool success) {
543     assert(allowTransactions);
544     assert(!frozenAccount[msg.sender]);
545     allowance[msg.sender][_spender] = _amount;
546     activateAccount(msg.sender);
547     activateAccount(_spender);
548     activateAllowanceRecord(msg.sender, _spender);
549     Approval(msg.sender, _spender, _amount);
550     return true;
551   }
552 
553   /* ---------------  multisig admin methods  --------------*/
554 
555 
556 
557   /**
558    * @notice Sets the expiry time in milliseconds since 1970.
559    *
560    * @param ts milliseconds since 1970.
561    *
562    */
563   function setExpiry(uint256 ts) multisig(sha3(msg.data)) {
564     expiry = ts;
565   }
566 
567   /**
568    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
569    *
570    * @param mintedAmount Amount of new tokens to be minted.
571    */
572   function mint(uint256 mintedAmount) multisig(sha3(msg.data)) {
573     treasuryBalance += mintedAmount;
574     totalSupply += mintedAmount;
575   }
576 
577   /**
578    * @notice Destroys `destroyAmount` new tokens from the hotwallet `hotWalletAddress`
579    *
580    * @param destroyAmount Amount of new tokens to be minted.
581    */
582   function destroyTokens(uint256 destroyAmount) multisig(sha3(msg.data)) {
583     assert(treasuryBalance >= destroyAmount);
584     treasuryBalance -= destroyAmount;
585     totalSupply -= destroyAmount;
586   }
587 
588   /**
589    * @notice Transfers `amount` from the treasury to `to`
590    *
591    * @param to Address to transfer to
592    * @param amount Amount to transfer from treasury
593    */
594   function transferFromTreasury(address to, uint256 amount) multisig(sha3(msg.data)) {
595     assert(treasuryBalance >= amount);
596     treasuryBalance -= amount;
597     balanceOf[to] += amount;
598     activateAccount(to);
599   }
600 
601   /* ---------------  fee setting administration methods  --------------*/
602 
603   /**
604    * @notice Sets an import fee of `fee` on address `addr`
605    *
606    * @param addr Address for which the fee is valid
607    * @param addr fee Fee
608    *
609    */
610   function setImportFee(address addr, uint256 fee) multisig(sha3(msg.data)) {
611     uint256 max = 1;
612     max = pow10(1, decimals);
613     assert(fee <= max);
614     importFee[addr] = fee;
615     activateImportFeeChargeRecord(addr);
616   }
617 
618   /**
619    * @notice Sets an export fee of `fee` on address `addr`
620    *
621    * @param addr Address for which the fee is valid
622    * @param addr fee Fee
623    *
624    */
625   function setExportFee(address addr, uint256 fee) multisig(sha3(msg.data)) {
626     uint256 max = 1;
627     max = pow10(1, decimals);
628     assert(fee <= max);
629     exportFee[addr] = fee;
630     activateExportFeeChargeRecord(addr);
631   }
632 
633 
634   /* ---------------  multisig emergency methods --------------*/
635 
636   /**
637    * @notice Sets allow transactions to `allow`
638    *
639    * @param allow Allow or disallow transactions
640    */
641   function voteAllowTransactions(bool allow) multisig(sha3(msg.data)) {
642     assert(allow != allowTransactions);
643     allowTransactions = allow;
644   }
645 
646   /**
647    * @notice Destructs the contract and sends remaining `this.balance` Ether to `beneficiary`
648    *
649    * @param beneficiary Beneficiary of remaining Ether on contract
650    */
651   function voteSuicide(address beneficiary) multisig(sha3(msg.data)) {
652     selfdestruct(beneficiary);
653   }
654 
655   /**
656    * @notice Sets frozen to `freeze` for account `target`
657    *
658    * @param addr Address to be frozen/unfrozen
659    * @param freeze Freeze/unfreeze account
660    */
661   function freezeAccount(address addr, bool freeze) multisig(sha3(msg.data)) {
662     frozenAccount[addr] = freeze;
663     activateAccount(addr);
664   }
665 
666   /**
667    * @notice Seizes `seizeAmount` of tokens from `address` and transfers it to hotwallet
668    *
669    * @param addr Adress to seize tokens from
670    * @param amount Amount of tokens to seize
671    */
672   function seizeTokens(address addr, uint256 amount) multisig(sha3(msg.data)) {
673     assert(balanceOf[addr] >= amount);
674     assert(frozenAccount[addr]);
675     activateAccount(addr);
676     balanceOf[addr] -= amount;
677     treasuryBalance += amount;
678   }
679 
680   /* --------------- fee calculation method ---------------- */
681 
682 
683   /**
684    * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.
685    *
686    * Fee's consist of a possible
687    *    - import fee on transfers to an address
688    *    - export fee on transfers from an address
689    * DVIP ownership on an address
690    *    - reduces fee on a transfer from this address to an import fee-ed address
691    *    - reduces the fee on a transfer to this address from an export fee-ed address
692    * DVIP discount does not work for addresses that have an import fee or export fee set up against them.
693    *
694    * DVIP discount goes up to 100%
695    *
696    * @param from From address
697    * @param to To address
698    * @param amount Amount for which fee needs to be calculated.
699    *
700    */
701   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {
702     uint256 fee = exportFee[from] + importFee[to];
703     if (fee == 0) return 0;
704     uint256 amountHeld;
705     bool discounted = true;
706     uint256 oneDVIPUnit;
707     if (exportFee[from] == 0 && balanceOf[from] != 0 && now < expiry) {
708       amountHeld = balanceOf[from];
709     } else if (importFee[to] == 0 && balanceOf[to] != 0 && now < expiry) {
710       amountHeld = balanceOf[to];
711     } else discounted = false;
712     if (discounted) {
713       oneDVIPUnit = pow10(1, decimals);
714       if (amountHeld > oneDVIPUnit) amountHeld = oneDVIPUnit;
715       uint256 remaining = oneDVIPUnit - amountHeld;
716       return div10(amount*fee*remaining, decimals*2);
717     }
718     return div10(amount*fee, decimals);
719   }
720 
721 
722   /* ---------------  overseer methods for emergency --------------*/
723 
724   /**
725    * @notice Shuts down all transaction and approval options on the asset contract
726    */
727   function shutdownTransactions() onlyOverseer {
728     allowTransactions = false;
729     TransactionsShutDown(msg.sender);
730   }
731 
732   /* ---------------  helper methods for siphoning --------------*/
733 
734   function extractAccountAllowanceRecordLength(address addr) constant returns (uint256 len) {
735     return allowanceIndex[addr].length;
736   }
737 
738   function extractAccountLength() constant returns (uint256 length) {
739     return accountIndex.length;
740   }
741 
742   /* ---------------  private methods --------------*/
743 
744   function activateAccount(address addr) internal {
745     if (!accountActive[addr]) {
746       accountActive[addr] = true;
747       accountIndex.push(addr);
748     }
749   }
750 
751   function activateAllowanceRecord(address from, address to) internal {
752     if (!allowanceActive[from][to]) {
753       allowanceActive[from][to] = true;
754       allowanceIndex[from].push(to);
755     }
756   }
757 
758   function activateExportFeeChargeRecord(address addr) internal {
759     if (!exportFeeActive[addr]) {
760       exportFeeActive[addr] = true;
761       exportFeeIndex.push(addr);
762     }
763   }
764 
765   function activateImportFeeChargeRecord(address addr) internal {
766     if (!importFeeActive[addr]) {
767       importFeeActive[addr] = true;
768       importFeeIndex.push(addr);
769     }
770   }
771   function extractImportFeeChargeLength() returns (uint256 length) {
772     return importFeeIndex.length;
773   }
774 
775   function extractExportFeeChargeLength() returns (uint256 length) {
776     return exportFeeIndex.length;
777   }
778 }
779 
780 /**
781  * @title DCAssetBackend Contract
782  *
783  * @author Ray Pulver, ray@decentralizedcapital.com
784  */
785 contract DCAssetBackend is Owned, Precision, StateTransferrable, TrustClient, Util {
786 
787   bytes32 public standard = 'Token 0.1';
788   bytes32 public name;
789   bytes32 public symbol;
790 
791   bool public allowTransactions;
792 
793   event Approval(address indexed from, address indexed spender, uint256 amount);
794 
795   mapping (address => uint256) public balanceOf;
796   mapping (address => mapping (address => uint256)) public allowance;
797 
798   event Transfer(address indexed from, address indexed to, uint256 value);
799 
800   uint256 public totalSupply;
801 
802   address public hotWalletAddress;
803   address public assetAddress;
804   address public oversightAddress;
805   address public membershipAddress;
806 
807   mapping (address => bool) public frozenAccount;
808 
809   mapping (address => address[]) public allowanceIndex;
810   mapping (address => mapping (address => bool)) public allowanceActive;
811   address[] public accountIndex;
812   mapping (address => bool) public accountActive;
813 
814   bool public isActive;
815   uint256 public treasuryBalance;
816 
817   mapping (address => uint256) public feeCharge;
818   address[] public feeChargeIndex;
819   mapping (address => bool) feeActive;
820 
821   event FrozenFunds(address target, bool frozen);
822   event PrecisionSet(address indexed from, uint8 precision);
823   event TransactionsShutDown(address indexed from);
824   event FeeSetup(address indexed from, address indexed target, uint256 amount);
825 
826 
827   /**
828    * Constructor.
829    *
830    * @param tokenName Name of the Token
831    * @param tokenSymbol The Token Symbol
832    */
833   function DCAssetBackend(bytes32 tokenSymbol, bytes32 tokenName) {
834     isActive = true;
835     name = tokenName;
836     symbol = tokenSymbol;
837     decimals = 6;
838     allowTransactions = true;
839   }
840 
841   /* ---------------  modifiers  --------------*/
842 
843   /**
844    * Makes sure a method is only called by an overseer.
845    */
846   modifier onlyOverseer {
847     assert(msg.sender == oversightAddress);
848     _
849   }
850 
851   /**
852    * Make sure only the front end Asset can call the transfer methods
853    */
854    modifier onlyAsset {
855     assert(msg.sender == assetAddress);
856     _
857    }
858 
859   /* ---------------  setter methods, only for the unlocked state --------------*/
860 
861 
862   /**
863    * Sets the hot wallet contract address
864    *
865    * @param addr Address of the Hotwallet
866    */
867   function setHotWallet(address addr) onlyOwnerUnlocked setter {
868     hotWalletAddress = addr;
869   }
870 
871   /**
872     * Sets the token facade contract address
873     *
874     * @param addr Address of the front-end Asset
875     */
876   function setAsset(address addr) onlyOwnerUnlocked setter {
877     assetAddress = addr;
878   }
879 
880   /**
881    * Sets the membership contract address
882    *
883    * @param addr Address of the membership contract
884    */
885   function setMembership(address addr) onlyOwnerUnlocked setter {
886     membershipAddress = addr;
887   }
888 
889   /**
890    * Sets the oversight address (not the contract).
891    *
892    * @param addr The oversight contract address.
893    */
894   function setOversight(address addr) onlyOwnerUnlocked setter {
895     oversightAddress = addr;
896   }
897 
898   /**
899    * Sets the total supply
900    *
901    * @param total Total supply of the asset.
902    */
903   function setTotalSupply(uint256 total) onlyOwnerUnlocked setter {
904     totalSupply = total;
905   }
906 
907   /**
908    * Set the Token Standard the contract applies to.
909    *
910    * @param std the Standard.
911    */
912   function setStandard(bytes32 std) onlyOwnerUnlocked setter {
913     standard = std;
914   }
915 
916   /**
917    * Sets the name of the contraxt
918    *
919    * @param _name the name.
920    */
921   function setName(bytes32 _name) onlyOwnerUnlocked setter {
922     name = _name;
923   }
924 
925   /**
926    * Sets the symbol
927    *
928    * @param sym The Symbol
929    */
930   function setSymbol(bytes32 sym) onlyOwnerUnlocked setter {
931     symbol = sym;
932   }
933 
934   /**
935    * Sets the precision
936    *
937    * @param precision Amount of decimals
938    */
939   function setPrecisionDirect(uint8 precision) onlyOwnerUnlocked {
940     decimals = precision;
941     PrecisionSet(msg.sender, precision);
942   }
943 
944   /**
945    * Sets the balance of a certain account.
946    *
947    * @param addr Address of the account
948    * @param amount Amount of assets to set on the account
949    */
950   function setAccountBalance(address addr, uint256 amount) onlyOwnerUnlocked {
951     balanceOf[addr] = amount;
952     activateAccount(addr);
953   }
954 
955   /**
956    * Sets an allowance from a specific account to a specific account.
957    *
958    * @param from From-part of the allowance
959    * @param to To-part of the allowance
960    * @param amount Amount of the allowance
961    */
962   function setAccountAllowance(address from, address to, uint256 amount) onlyOwnerUnlocked {
963     allowance[from][to] = amount;
964     activateAllowanceRecord(from, to);
965   }
966 
967   /**
968    * Sets the treasure balance to a certain account.
969    *
970    * @param amount Amount of assets to pre-set in the treasury
971    */
972   function setTreasuryBalance(uint256 amount) onlyOwnerUnlocked {
973     treasuryBalance = amount;
974   }
975 
976   /**
977    * Sets a certain account on frozen/unfrozen
978    *
979    * @param addr Account that will be frozen/unfrozen
980    * @param frozen Boolean to freeze or unfreeze
981    */
982   function setAccountFrozenStatus(address addr, bool frozen) onlyOwnerUnlocked {
983     activateAccount(addr);
984     frozenAccount[addr] = frozen;
985   }
986 
987   /* ---------------  main token methods  --------------*/
988 
989 
990   /**
991    * @notice Transfer `_amount` from `_caller` to `_to`.
992    *
993    * @param _caller Origin address
994    * @param _to Address that will receive.
995    * @param _amount Amount to be transferred.
996    */
997   function transfer(address _caller, address _to, uint256 _amount) onlyAsset returns (bool success) {
998     assert(allowTransactions);
999     assert(!frozenAccount[_caller]);
1000     assert(balanceOf[_caller] >= _amount);
1001     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
1002     activateAccount(_caller);
1003     activateAccount(_to);
1004     balanceOf[_caller] -= _amount;
1005     if (_to == address(this)) treasuryBalance += _amount;
1006     else {
1007         uint256 fee = feeFor(_caller, _to, _amount);
1008         balanceOf[_to] += _amount - fee;
1009         treasuryBalance += fee;
1010     }
1011     Transfer(_caller, _to, _amount);
1012     return true;
1013   }
1014 
1015   /**
1016    * @notice Transfer `_amount` from `_from` to `_to`, invoked by `_caller`.
1017    *
1018    * @param _caller Invoker of the call (owner of the allowance)
1019    * @param _from Origin address
1020    * @param _to Address that will receive
1021    * @param _amount Amount to be transferred.
1022    * @return result of the method call
1023    */
1024   function transferFrom(address _caller, address _from, address _to, uint256 _amount) onlyAsset returns (bool success) {
1025     assert(allowTransactions);
1026     assert(!frozenAccount[_caller]);
1027     assert(!frozenAccount[_from]);
1028     assert(balanceOf[_from] >= _amount);
1029     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
1030     assert(_amount <= allowance[_from][_caller]);
1031     balanceOf[_from] -= _amount;
1032     uint256 fee = feeFor(_from, _to, _amount);
1033     balanceOf[_to] += _amount - fee;
1034     treasuryBalance += fee;
1035     allowance[_from][_caller] -= _amount;
1036     activateAccount(_from);
1037     activateAccount(_to);
1038     activateAccount(_caller);
1039     Transfer(_from, _to, _amount);
1040     return true;
1041   }
1042 
1043   /**
1044    * @notice Approve Approves spender `_spender` to transfer `_amount` from `_caller`
1045    *
1046    * @param _caller Address that grants the allowance
1047    * @param _spender Address that receives the cheque
1048    * @param _amount Amount on the cheque
1049    * @param _extraData Consequential contract to be executed by spender in same transcation.
1050    * @return result of the method call
1051    */
1052   function approveAndCall(address _caller, address _spender, uint256 _amount, bytes _extraData) onlyAsset returns (bool success) {
1053     assert(allowTransactions);
1054     assert(!frozenAccount[_caller]);
1055     allowance[_caller][_spender] = _amount;
1056     activateAccount(_caller);
1057     activateAccount(_spender);
1058     activateAllowanceRecord(_caller, _spender);
1059     TokenRecipient spender = TokenRecipient(_spender);
1060     assert(Relay(assetAddress).relayReceiveApproval(_caller, _spender, _amount, _extraData));
1061     Approval(_caller, _spender, _amount);
1062     return true;
1063   }
1064 
1065   /**
1066    * @notice Approve Approves spender `_spender` to transfer `_amount` from `_caller`
1067    *
1068    * @param _caller Address that grants the allowance
1069    * @param _spender Address that receives the cheque
1070    * @param _amount Amount on the cheque
1071    * @return result of the method call
1072    */
1073   function approve(address _caller, address _spender, uint256 _amount) onlyAsset returns (bool success) {
1074     assert(allowTransactions);
1075     assert(!frozenAccount[_caller]);
1076     allowance[_caller][_spender] = _amount;
1077     activateAccount(_caller);
1078     activateAccount(_spender);
1079     activateAllowanceRecord(_caller, _spender);
1080     Approval(_caller, _spender, _amount);
1081     return true;
1082   }
1083 
1084   /* ---------------  multisig admin methods  --------------*/
1085 
1086 
1087   /**
1088    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
1089    *
1090    * @param mintedAmount Amount of new tokens to be minted.
1091    */
1092   function mint(uint256 mintedAmount) multisig(sha3(msg.data)) {
1093     activateAccount(hotWalletAddress);
1094     balanceOf[hotWalletAddress] += mintedAmount;
1095     totalSupply += mintedAmount;
1096   }
1097 
1098   /**
1099    * @notice Destroys `destroyAmount` new tokens from the hotwallet `hotWalletAddress`
1100    *
1101    * @param destroyAmount Amount of new tokens to be minted.
1102    */
1103   function destroyTokens(uint256 destroyAmount) multisig(sha3(msg.data)) {
1104     assert(balanceOf[hotWalletAddress] >= destroyAmount);
1105     activateAccount(hotWalletAddress);
1106     balanceOf[hotWalletAddress] -= destroyAmount;
1107     totalSupply -= destroyAmount;
1108   }
1109 
1110   /**
1111    * @notice Transfers `amount` from the treasury to `to`
1112    *
1113    * @param to Address to transfer to
1114    * @param amount Amount to transfer from treasury
1115    */
1116   function transferFromTreasury(address to, uint256 amount) multisig(sha3(msg.data)) {
1117     assert(treasuryBalance >= amount);
1118     treasuryBalance -= amount;
1119     balanceOf[to] += amount;
1120     activateAccount(to);
1121   }
1122 
1123   /* ---------------  multisig emergency methods --------------*/
1124 
1125   /**
1126    * @notice Sets allow transactions to `allow`
1127    *
1128    * @param allow Allow or disallow transactions
1129    */
1130   function voteAllowTransactions(bool allow) multisig(sha3(msg.data)) {
1131     if (allow == allowTransactions) throw;
1132     allowTransactions = allow;
1133   }
1134 
1135   /**
1136    * @notice Destructs the contract and sends remaining `this.balance` Ether to `beneficiary`
1137    *
1138    * @param beneficiary Beneficiary of remaining Ether on contract
1139    */
1140   function voteSuicide(address beneficiary) multisig(sha3(msg.data)) {
1141     selfdestruct(beneficiary);
1142   }
1143 
1144   /**
1145    * @notice Sets frozen to `freeze` for account `target`
1146    *
1147    * @param addr Address to be frozen/unfrozen
1148    * @param freeze Freeze/unfreeze account
1149    */
1150   function freezeAccount(address addr, bool freeze) multisig(sha3(msg.data)) {
1151     frozenAccount[addr] = freeze;
1152     activateAccount(addr);
1153   }
1154 
1155   /**
1156    * @notice Seizes `seizeAmount` of tokens from `address` and transfers it to hotwallet
1157    *
1158    * @param addr Adress to seize tokens from
1159    * @param amount Amount of tokens to seize
1160    */
1161   function seizeTokens(address addr, uint256 amount) multisig(sha3(msg.data)) {
1162     assert(balanceOf[addr] >= amount);
1163     assert(frozenAccount[addr]);
1164     activateAccount(addr);
1165     balanceOf[addr] -= amount;
1166     balanceOf[hotWalletAddress] += amount;
1167   }
1168 
1169   /* ---------------  overseer methods for emergency --------------*/
1170 
1171   /**
1172    * @notice Shuts down all transaction and approval options on the asset contract
1173    */
1174   function shutdownTransactions() onlyOverseer {
1175     allowTransactions = false;
1176     TransactionsShutDown(msg.sender);
1177   }
1178 
1179   /* ---------------  helper methods for siphoning --------------*/
1180 
1181   function extractAccountAllowanceRecordLength(address addr) returns (uint256 len) {
1182     return allowanceIndex[addr].length;
1183   }
1184 
1185   function extractAccountLength() returns (uint256 length) {
1186     return accountIndex.length;
1187   }
1188 
1189 
1190   /* ---------------  private methods --------------*/
1191 
1192   function activateAccount(address addr) internal {
1193     if (!accountActive[addr]) {
1194       accountActive[addr] = true;
1195       accountIndex.push(addr);
1196     }
1197   }
1198 
1199   function activateAllowanceRecord(address from, address to) internal {
1200     if (!allowanceActive[from][to]) {
1201       allowanceActive[from][to] = true;
1202       allowanceIndex[from].push(to);
1203     }
1204   }
1205   function feeFor(address a, address b, uint256 amount) returns (uint256 value) {
1206     if (membershipAddress == address(0x0)) return 0;
1207     return DVIP(membershipAddress).feeFor(a, b, amount);
1208   }
1209 }
1210 
1211 
1212 /**
1213  * @title DCAssetFacade, Facade for the underlying back-end dcasset token contract. Allow to be updated later.
1214  *
1215  * @author P.S.D. Reitsma, peter@decentralizedcapital.com
1216  *
1217  */
1218 contract DCAsset is TokenBase, StateTransferrable, TrustClient, Relay {
1219 
1220    address public backendContract;
1221 
1222    /**
1223     * Constructor
1224     *
1225     *
1226     */
1227    function DCAsset(address _backendContract) {
1228      backendContract = _backendContract;
1229    }
1230 
1231    function standard() constant returns (bytes32 std) {
1232      return DCAssetBackend(backendContract).standard();
1233    }
1234 
1235    function name() constant returns (bytes32 nm) {
1236      return DCAssetBackend(backendContract).name();
1237    }
1238 
1239    function symbol() constant returns (bytes32 sym) {
1240      return DCAssetBackend(backendContract).symbol();
1241    }
1242 
1243    function decimals() constant returns (uint8 precision) {
1244      return DCAssetBackend(backendContract).decimals();
1245    }
1246   
1247    function allowance(address from, address to) constant returns (uint256 res) {
1248      return DCAssetBackend(backendContract).allowance(from, to);
1249    }
1250 
1251 
1252    /* ---------------  multisig admin methods  --------------*/
1253 
1254 
1255    /**
1256     * @notice Sets the backend contract to `_backendContract`. Can only be switched by multisig.
1257     *
1258     * @param _backendContract Address of the underlying token contract.
1259     */
1260    function setBackend(address _backendContract) multisig(sha3(msg.data)) {
1261      backendContract = _backendContract;
1262    }
1263 
1264    /* ---------------  main token methods  --------------*/
1265 
1266    /**
1267     * @notice Returns the balance of `_address`.
1268     *
1269     * @param _address The address of the balance.
1270     */
1271    function balanceOf(address _address) constant returns (uint256 balance) {
1272       return DCAssetBackend(backendContract).balanceOf(_address);
1273    }
1274 
1275    /**
1276     * @notice Returns the total supply of the token
1277     *
1278     */
1279    function totalSupply() constant returns (uint256 balance) {
1280       return DCAssetBackend(backendContract).totalSupply();
1281    }
1282 
1283   /**
1284    * @notice Transfer `_amount` to `_to`.
1285    *
1286    * @param _to Address that will receive.
1287    * @param _amount Amount to be transferred.
1288    */
1289    function transfer(address _to, uint256 _amount) returns (bool success)  {
1290       if (!DCAssetBackend(backendContract).transfer(msg.sender, _to, _amount)) throw;
1291       Transfer(msg.sender, _to, _amount);
1292       return true;
1293    }
1294 
1295   /**
1296    * @notice Approve Approves spender `_spender` to transfer `_amount`.
1297    *
1298    * @param _spender Address that receives the cheque
1299    * @param _amount Amount on the cheque
1300    * @param _extraData Consequential contract to be executed by spender in same transcation.
1301    * @return result of the method call
1302    */
1303    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
1304       if (!DCAssetBackend(backendContract).approveAndCall(msg.sender, _spender, _amount, _extraData)) throw;
1305       Approval(msg.sender, _spender, _amount);
1306       return true;
1307    }
1308 
1309   /**
1310    * @notice Approve Approves spender `_spender` to transfer `_amount`.
1311    *
1312    * @param _spender Address that receives the cheque
1313    * @param _amount Amount on the cheque
1314    * @return result of the method call
1315    */
1316    function approve(address _spender, uint256 _amount) returns (bool success) {
1317       if (!DCAssetBackend(backendContract).approve(msg.sender, _spender, _amount)) throw;
1318       Approval(msg.sender, _spender, _amount);
1319       return true;
1320    }
1321 
1322   /**
1323    * @notice Transfer `_amount` from `_from` to `_to`.
1324    *
1325    * @param _from Origin address
1326    * @param _to Address that will receive
1327    * @param _amount Amount to be transferred.
1328    * @return result of the method call
1329    */
1330   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
1331       if (!DCAssetBackend(backendContract).transferFrom(msg.sender, _from, _to, _amount)) throw;
1332       Transfer(_from, _to, _amount);
1333       return true;
1334   }
1335 
1336   /**
1337    * @notice Returns fee for transferral of `_amount` from `_from` to `_to`.
1338    *
1339    * @param _from Origin address
1340    * @param _to Address that will receive
1341    * @param _amount Amount to be transferred.
1342    * @return height of the fee
1343    */
1344   function feeFor(address _from, address _to, uint256 _amount) returns (uint256 amount) {
1345       return DCAssetBackend(backendContract).feeFor(_from, _to, _amount);
1346   }
1347 
1348   /* ---------------  to be called by backend  --------------*/
1349 
1350   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
1351      assert(msg.sender == backendContract);
1352      TokenRecipient spender = TokenRecipient(_spender);
1353      spender.receiveApproval(_caller, _amount, this, _extraData);
1354      return true;
1355   }
1356 
1357 }
1358 /**
1359  * @title Oversight Contract that is hooked into HotWallet to provide extra security.
1360  *
1361  * @author Ray Pulver, ray@decentralizedcapital.com
1362  */
1363 contract Oversight is StateTransferrable, TrustClient {
1364 
1365   address public hotWalletAddress;
1366 
1367   mapping (address => uint256) public approved;             //map of approved amounts per currency
1368   address[] public approvedIndex;                           //array of approved currencies
1369 
1370   mapping (address => uint256) public expiry;               //map of expiry times per currency
1371 
1372   mapping (address => bool) public currencyActive;          //map of active/inactive currencies
1373 
1374   mapping (address => bool) public oversightAddresses;      //map of active/inactive oversight addresses
1375   address[] public oversightAddressesIndex;                 //array of oversight addresses
1376 
1377   mapping (address => bool) public oversightAddressActive;  //map of active oversight addresses (for siphoning/uploading)
1378 
1379   uint256 public timeWindow;                                //expiry time for an approval
1380 
1381   event TransactionsShutDown(address indexed from);
1382 
1383   /**
1384    * Constructor. Sets expiry to 10 minutes.
1385    */
1386   function Oversight() {
1387     timeWindow = 10 minutes;
1388   }
1389 
1390   /* ---------------  modifiers  --------------*/
1391 
1392   /**
1393    * Makes sure a method is only called by an overseer.
1394    */
1395   modifier onlyOverseer {
1396     assert(oversightAddresses[msg.sender]);
1397     _
1398   }
1399 
1400   /**
1401    * Makes sure a method is only called from the HotWallet.
1402    */
1403   modifier onlyHotWallet {
1404     assert(msg.sender == hotWalletAddress);
1405     _
1406   }
1407 
1408   /* ---------------  setter methods, only for the unlocked state --------------*/
1409 
1410   /**
1411    * Sets the HotWallet address.
1412    *
1413    * @param addr Address of the hotwallet.
1414    */
1415   function setHotWallet(address addr) onlyOwnerUnlocked setter {
1416       hotWalletAddress = addr;
1417   }
1418 
1419   /**
1420    * Sets the approval expiry window, called before the contract is locked.
1421    *
1422    * @param secs Expiry time in seconds.
1423    */
1424   function setupTimeWindow(uint256 secs) onlyOwnerUnlocked setter {
1425     timeWindow = secs;
1426   }
1427 
1428   /**
1429    * Approves an amount for a certain currency, called before the contract is locked.
1430    *
1431    * @param addr Currency.
1432    * @param amount The amount to approve.
1433    */
1434   function setApproved(address addr, uint256 amount) onlyOwnerUnlocked setter {
1435     activateCurrency(addr);
1436     approved[addr] = amount;
1437   }
1438 
1439   /**
1440    * Sets the expiry window for a certain currency, called before the contracted is locked.
1441    *
1442    * @param addr Currency.
1443    * @param ts Window in seconds
1444    */
1445   function setExpiry(address addr, uint256 ts) onlyOwnerUnlocked setter {
1446     activateCurrency(addr);
1447     expiry[addr] = ts;
1448   }
1449 
1450   /**
1451    * Sets an oversight address, on active or inactive, called before the contract is locked.
1452    *
1453    * @param addr The oversight address.
1454    * @param value Whether to activate or deactivate the address.
1455    */
1456   function setOversightAddress(address addr, bool value) onlyOwnerUnlocked setter {
1457     activateOversightAddress(addr);
1458     oversightAddresses[addr] = value;
1459   }
1460 
1461 
1462 
1463   /* ---------------  multisig admin methods  --------------*/
1464 
1465   /**
1466    * @notice Sets the approval expiry window to `secs`.
1467    *
1468    * @param secs Expiry time in seconds.
1469    */
1470   function setTimeWindow(uint256 secs) external multisig(sha3(msg.data)) {
1471     timeWindow = secs;
1472   }
1473 
1474   /**
1475    * @notice Adds and activates new oversight address `addr`.
1476    *
1477    * @param addr The oversight addresss.
1478    */
1479   function addOversight(address addr) external multisig(sha3(msg.data)) {
1480     activateOversightAddress(addr);
1481     oversightAddresses[addr] = true;
1482   }
1483 
1484   /**
1485    * @notice Removes/deactivates oversight address `addr`.
1486    *
1487    * @param addr The oversight address to be removed.
1488    */
1489   function removeOversight(address addr) external multisig(sha3(msg.data)) {
1490     oversightAddresses[addr] = false;
1491   }
1492 
1493   /* ---------------  multisig main methods  --------------*/
1494 
1495   /**
1496    * @notice Approve `amount` of asset `currency` to be withdrawn.
1497    *
1498    * @param currency Address of the currency/asset to approve a certain amount for.
1499    * @param amount The amount to approve.
1500    */
1501   function approve(address currency, uint256 amount) external multisig(sha3(msg.data)) {
1502     activateCurrency(currency);
1503     approved[currency] = amount;
1504     expiry[currency] = now + timeWindow;
1505   }
1506 
1507   /* ---------------  method for hotwallet  --------------*/
1508 
1509   /**
1510    * @notice Validate that `amount` is allowed to be transacted for `currency`.
1511    * Called by the HotWallet to validate a transaction.
1512    *
1513    * @param currency Address of the currency/asset for which is validated.
1514    * @param amount The amount that is validated.
1515    */
1516   function validate(address currency, uint256 amount) external onlyHotWallet returns (bool) {
1517     assert(approved[currency] >= amount);
1518     approved[currency] -= amount;
1519     return true;
1520   }
1521 
1522   /* ---------------  Overseer methods for emergency --------------*/
1523 
1524   /**
1525    * @notice Shutdown transactions on asset `currency`
1526    *
1527    * @param currency Address of the currency/asset contract to be shut down.
1528    */
1529   function shutdownTransactions(address currency) onlyOverseer {
1530     address backend = DCAsset(currency).backendContract();
1531     DCAssetBackend(backend).shutdownTransactions();
1532     TransactionsShutDown(msg.sender);
1533   }
1534 
1535   /* ---------------  Helper methods for siphoning --------------*/
1536 
1537   /**
1538    * Returns the amount of approvals.
1539    */
1540   function extractApprovedIndexLength() returns (uint256) {
1541     return approvedIndex.length;
1542   }
1543 
1544   /**
1545    * Returns the amount of oversight addresses.
1546    */
1547   function extractOversightAddressesIndexLength() returns (uint256) {
1548     return oversightAddressesIndex.length;
1549   }
1550 
1551   /* ---------------  private methods --------------*/
1552 
1553   function activateOversightAddress(address addr) internal {
1554     if (!oversightAddressActive[addr]) {
1555       oversightAddressActive[addr] = true;
1556       oversightAddressesIndex.push(addr);
1557     }
1558   }
1559 
1560   function activateCurrency(address addr) internal {
1561     if (!currencyActive[addr]) {
1562       currencyActive[addr] = true;
1563           approvedIndex.push(addr);
1564     }
1565   }
1566 
1567 }