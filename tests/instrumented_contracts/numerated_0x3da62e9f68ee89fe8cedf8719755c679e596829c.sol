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
73   mapping (uint256 => address) public functionCalls;
74   mapping (address => uint256) public functionCalling;
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
103   function resetAction(uint256 hash) internal {
104     address addr = functionCalls[hash];
105     functionCalls[hash] = 0x0;
106     functionCalling[addr] = 0;
107   }
108   function authCancel(address from) external returns (uint8 status) {
109     if (!masterKeys[from] || !trustedClients[msg.sender]) {
110       Unauthorized(from);
111       return 0;
112     }
113     uint256 call = functionCalling[from];
114     if (call == 0) {
115       NothingToCancel(from);
116       return 1;
117     } else {
118       AuthCancel(from, from);
119       functionCalling[from] = 0;
120       functionCalls[call] = 0x0;
121       return 2;
122     }
123   }
124   function cancel() returns (uint8 code) {
125     if (!masterKeys[msg.sender]) {
126       Unauthorized(msg.sender);
127       return 0;
128     }
129     uint256 call = functionCalling[msg.sender];
130     if (call == 0) {
131       NothingToCancel(msg.sender);
132       return 1;
133     } else {
134       AuthCancel(msg.sender, msg.sender);
135       uint256 hash = functionCalling[msg.sender];
136       functionCalling[msg.sender] = 0x0;
137       functionCalls[hash] = 0;
138       return 2;
139     }
140   }
141   function authCall(address from, bytes32 hash) external returns (uint8 code) {
142     if (!masterKeys[from] || !trustedClients[msg.sender]) {
143       Unauthorized(from);
144       return 0;
145     }
146     if (functionCalling[from] == 0) {
147       if (functionCalls[uint256(hash)] == 0x0) {
148         functionCalls[uint256(hash)] = from;
149         functionCalling[from] = uint256(hash);
150         AuthInit(from);
151         return 1;
152       } else { 
153         AuthComplete(functionCalls[uint256(hash)], from);
154         resetAction(uint256(hash));
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
166       if (functionCalls[uint256(hash)] == 0x0) {
167         functionCalls[uint256(hash)] = msg.sender;
168         functionCalling[msg.sender] = uint256(hash);
169         AuthInit(msg.sender);
170       } else { 
171         AuthComplete(functionCalls[uint256(hash)], msg.sender);
172         resetAction(uint256(hash));
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
197 contract TrustClient is StateTransferrable, TrustEvents {
198   address public trustAddress;
199   function setTrust(address addr) setter onlyOwnerUnlocked {
200     trustAddress = addr;
201   }
202   function nameFor(address addr) constant returns (bytes32 name) {
203     return Trust(trustAddress).nameFor(addr);
204   }
205   function cancel() returns (uint8 status) {
206     assert(trustAddress != address(0x0));
207     uint8 code = Trust(trustAddress).authCancel(msg.sender);
208     if (code == 0) Unauthorized(msg.sender);
209     else if (code == 1) NothingToCancel(msg.sender);
210     else if (code == 2) AuthCancel(msg.sender, msg.sender);
211     return code;
212   }
213   modifier multisig (bytes32 hash) {
214     assert(trustAddress != address(0x0));
215     address current = Trust(trustAddress).functionCalls(uint256(hash));
216     uint8 code = Trust(trustAddress).authCall(msg.sender, hash);
217     if (code == 0) Unauthorized(msg.sender);
218     else if (code == 1) AuthInit(msg.sender);
219     else if (code == 2) {
220       AuthComplete(current, msg.sender);
221       _
222     }
223     else if (code == 3) {
224       AuthPending(msg.sender);
225     }
226   }
227 }
228 contract Relay {
229   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success);
230 }
231 contract TokenBase is Owned {
232     bytes32 public standard = 'Token 0.1';
233     bytes32 public name;
234     bytes32 public symbol;
235     uint256 public totalSupply;
236     bool public allowTransactions;
237 
238     event Approval(address indexed from, address indexed spender, uint256 amount);
239 
240     mapping (address => uint256) public balanceOf;
241     mapping (address => mapping (address => uint256)) public allowance;
242 
243     event Transfer(address indexed from, address indexed to, uint256 value);
244 
245     function transfer(address _to, uint256 _value) returns (bool success);
246     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
247     function approve(address _spender, uint256 _value) returns (bool success);
248     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
249 
250     function () {
251         throw;
252     }
253 }
254 
255 contract Precision {
256   uint8 public decimals;
257 }
258 contract Token is TokenBase, Precision {}
259 contract Util {
260   function pow10(uint256 a, uint8 b) internal returns (uint256 result) {
261     for (uint8 i = 0; i < b; i++) {
262       a *= 10;
263     }
264     return a;
265   }
266   function div10(uint256 a, uint8 b) internal returns (uint256 result) {
267     for (uint8 i = 0; i < b; i++) {
268       a /= 10;
269     }
270     return a;
271   }
272   function max(uint256 a, uint256 b) internal returns (uint256 res) {
273     if (a >= b) return a;
274     return b;
275   }
276 }
277 
278 /**
279  * @title DVIP Contract. DCAsset Membership Token contract.
280  *
281  * @author Ray Pulver, ray@decentralizedcapital.com
282  */
283 contract DVIP is Token, StateTransferrable, TrustClient, Util {
284 
285   uint256 public totalSupply;
286 
287   mapping (address => bool) public frozenAccount;
288 
289   mapping (address => address[]) public allowanceIndex;
290   mapping (address => mapping (address => bool)) public allowanceActive;
291   address[] public accountIndex;
292   mapping (address => bool) public accountActive;
293   address public oversightAddress;
294   uint256 public expiry;
295 
296   uint256 public treasuryBalance;
297 
298   bool public isActive;
299   mapping (address => uint256) public exportFee;
300   address[] public exportFeeIndex;
301   mapping (address => bool) exportFeeActive;
302 
303   mapping (address => uint256) public importFee;
304   address[] public importFeeIndex;
305   mapping (address => bool) importFeeActive;
306 
307   event FrozenFunds(address target, bool frozen);
308   event PrecisionSet(address indexed from, uint8 precision);
309   event TransactionsShutDown(address indexed from);
310   event FeeSetup(address indexed from, address indexed target, uint256 amount);
311 
312 
313   /**
314    * Constructor.
315    *
316    */
317   function DVIP() {
318     isActive = true;
319     treasuryBalance = 0;
320     totalSupply = 0;
321     name = "DVIP";
322     symbol = "DVIP";
323     decimals = 6;
324     allowTransactions = true;
325     expiry = 1514764800; //1 jan 2018
326   }
327 
328 
329   /* ---------------  modifiers  --------------*/
330 
331   /**
332    * Makes sure a method is only called by an overseer.
333    */
334   modifier onlyOverseer {
335     assert(msg.sender == oversightAddress);
336     _
337   }
338 
339   /* ---------------  setter methods, only for the unlocked state --------------*/
340 
341 
342   /**
343    * Sets the oversight address (not the contract).
344    *
345    * @param addr The oversight contract address.
346    */
347   function setOversight(address addr) onlyOwnerUnlocked setter {
348     oversightAddress = addr;
349   }
350 
351 
352   /**
353    * Sets the total supply
354    *
355    * @param total Total supply of the asset.
356    */
357   function setTotalSupply(uint256 total) onlyOwnerUnlocked setter {
358     totalSupply = total;
359   }
360 
361   /**
362    * Set the Token Standard the contract applies to.
363    *
364    * @param std the Standard.
365    */
366   function setStandard(bytes32 std) onlyOwnerUnlocked setter {
367     standard = std;
368   }
369 
370   /**
371    * Sets the name of the contraxt
372    *
373    * @param _name the name.
374    */
375   function setName(bytes32 _name) onlyOwnerUnlocked setter {
376     name = _name;
377   }
378 
379   /**
380    * Sets the symbol
381    *
382    * @param sym The Symbol
383    */
384   function setSymbol(bytes32 sym) onlyOwnerUnlocked setter {
385     symbol = sym;
386   }
387 
388   /**
389    * Sets the precision
390    *
391    * @param precision Amount of decimals
392    */
393   function setPrecisionDirect(uint8 precision) onlyOwnerUnlocked {
394     decimals = precision;
395     PrecisionSet(msg.sender, precision);
396   }
397 
398   /**
399    * Sets the balance of a certain account.
400    *
401    * @param addr Address of the account
402    * @param amount Amount of assets to set on the account
403    */
404   function setAccountBalance(address addr, uint256 amount) onlyOwnerUnlocked {
405     balanceOf[addr] = amount;
406     activateAccount(addr);
407   }
408 
409   /**
410    * Sets an allowance from a specific account to a specific account.
411    *
412    * @param from From-part of the allowance
413    * @param to To-part of the allowance
414    * @param amount Amount of the allowance
415    */
416   function setAccountAllowance(address from, address to, uint256 amount) onlyOwnerUnlocked {
417     allowance[from][to] = amount;
418     activateAllowanceRecord(from, to);
419   }
420 
421   /**
422    * Sets the treasure balance to a certain account.
423    *
424    * @param amount Amount of assets to pre-set in the treasury
425    */
426   function setTreasuryBalance(uint256 amount) onlyOwnerUnlocked {
427     treasuryBalance = amount;
428   }
429 
430   /**
431    * Sets a certain account on frozen/unfrozen
432    *
433    * @param addr Account that will be frozen/unfrozen
434    * @param frozen Boolean to freeze or unfreeze
435    */
436   function setAccountFrozenStatus(address addr, bool frozen) onlyOwnerUnlocked {
437     activateAccount(addr);
438     frozenAccount[addr] = frozen;
439   }
440 
441   /**
442    * Sets up a import fee for a certain address.
443    *
444    * @param addr Address that will require fee
445    * @param fee Amount of fee
446    */
447   function setupImportFee(address addr, uint256 fee) onlyOwnerUnlocked {
448     importFee[addr] = fee;
449     activateImportFeeChargeRecord(addr);
450     FeeSetup(msg.sender, addr, fee);
451   }
452  
453   /**
454    * Sets up a export fee for a certain address.
455    *
456    * @param addr Address that will require fee
457    * @param fee Amount of fee
458    */
459   function setupExportFee(address addr, uint256 fee) onlyOwnerUnlocked {
460     exportFee[addr] = fee;
461     activateExportFeeChargeRecord(addr);
462     FeeSetup(msg.sender, addr, fee);
463   }
464 
465   /* ---------------  main token methods  --------------*/
466 
467 
468   /**
469    * @notice Transfer `_amount` from `msg.sender.address()` to `_to`.
470    *
471    * @param _to Address that will receive.
472    * @param _amount Amount to be transferred.
473    */
474   function transfer(address _to, uint256 _amount) returns (bool success) {
475     assert(allowTransactions);
476     assert(!frozenAccount[msg.sender]);
477     assert(balanceOf[msg.sender] >= _amount);
478     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
479     activateAccount(msg.sender);
480     activateAccount(_to);
481     balanceOf[msg.sender] -= _amount;
482     if (_to == address(this)) treasuryBalance += _amount;
483     else balanceOf[_to] += _amount;
484     Transfer(msg.sender, _to, _amount);
485     return true;
486   }
487 
488   /**
489    * @notice Transfer `_amount` from `_from` to `_to`.
490    *
491    * @param _from Origin address
492    * @param _to Address that will receive
493    * @param _amount Amount to be transferred.
494    * @return result of the method call
495    */
496   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
497     assert(allowTransactions);
498     assert(!frozenAccount[msg.sender]);
499     assert(!frozenAccount[_from]);
500     assert(balanceOf[_from] >= _amount);
501     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
502     assert(_amount <= allowance[_from][msg.sender]);
503     balanceOf[_from] -= _amount;
504     balanceOf[_to] += _amount;
505     allowance[_from][msg.sender] -= _amount;
506     activateAccount(_from);
507     activateAccount(_to);
508     activateAccount(msg.sender);
509     Transfer(_from, _to, _amount);
510     return true;
511   }
512 
513   /**
514    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
515    *
516    * @param _spender Address that receives the cheque
517    * @param _amount Amount on the cheque
518    * @param _extraData Consequential contract to be executed by spender in same transcation.
519    * @return result of the method call
520    */
521   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
522     assert(allowTransactions);
523     assert(!frozenAccount[msg.sender]);
524     allowance[msg.sender][_spender] = _amount;
525     activateAccount(msg.sender);
526     activateAccount(_spender);
527     activateAllowanceRecord(msg.sender, _spender);
528     TokenRecipient spender = TokenRecipient(_spender);
529     spender.receiveApproval(msg.sender, _amount, this, _extraData);
530     Approval(msg.sender, _spender, _amount);
531     return true;
532   }
533 
534   /**
535    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
536    *
537    * @param _spender Address that receives the cheque
538    * @param _amount Amount on the cheque
539    * @return result of the method call
540    */
541   function approve(address _spender, uint256 _amount) returns (bool success) {
542     assert(allowTransactions);
543     assert(!frozenAccount[msg.sender]);
544     allowance[msg.sender][_spender] = _amount;
545     activateAccount(msg.sender);
546     activateAccount(_spender);
547     activateAllowanceRecord(msg.sender, _spender);
548     Approval(msg.sender, _spender, _amount);
549     return true;
550   }
551 
552   /* ---------------  multisig admin methods  --------------*/
553 
554 
555 
556   /**
557    * @notice Sets the expiry time in milliseconds since 1970.
558    *
559    * @param ts milliseconds since 1970.
560    *
561    */
562   function setExpiry(uint256 ts) multisig(sha3(msg.data)) {
563     expiry = ts;
564   }
565 
566   /**
567    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
568    *
569    * @param mintedAmount Amount of new tokens to be minted.
570    */
571   function mint(uint256 mintedAmount) multisig(sha3(msg.data)) {
572     treasuryBalance += mintedAmount;
573     totalSupply += mintedAmount;
574   }
575 
576   /**
577    * @notice Destroys `destroyAmount` new tokens from the hotwallet `hotWalletAddress`
578    *
579    * @param destroyAmount Amount of new tokens to be minted.
580    */
581   function destroyTokens(uint256 destroyAmount) multisig(sha3(msg.data)) {
582     assert(treasuryBalance >= destroyAmount);
583     treasuryBalance -= destroyAmount;
584     totalSupply -= destroyAmount;
585   }
586 
587   /**
588    * @notice Transfers `amount` from the treasury to `to`
589    *
590    * @param to Address to transfer to
591    * @param amount Amount to transfer from treasury
592    */
593   function transferFromTreasury(address to, uint256 amount) multisig(sha3(msg.data)) {
594     assert(treasuryBalance >= amount);
595     treasuryBalance -= amount;
596     balanceOf[to] += amount;
597     activateAccount(to);
598   }
599 
600   /* ---------------  fee setting administration methods  --------------*/
601 
602   /**
603    * @notice Sets an import fee of `fee` on address `addr`
604    *
605    * @param addr Address for which the fee is valid
606    * @param addr fee Fee
607    *
608    */
609   function setImportFee(address addr, uint256 fee) multisig(sha3(msg.data)) {
610     uint256 max = 1;
611     max = pow10(1, decimals);
612     assert(fee <= max);
613     importFee[addr] = fee;
614     activateImportFeeChargeRecord(addr);
615   }
616 
617   /**
618    * @notice Sets an export fee of `fee` on address `addr`
619    *
620    * @param addr Address for which the fee is valid
621    * @param addr fee Fee
622    *
623    */
624   function setExportFee(address addr, uint256 fee) multisig(sha3(msg.data)) {
625     uint256 max = 1;
626     max = pow10(1, decimals);
627     assert(fee <= max);
628     exportFee[addr] = fee;
629     activateExportFeeChargeRecord(addr);
630   }
631 
632 
633   /* ---------------  multisig emergency methods --------------*/
634 
635   /**
636    * @notice Sets allow transactions to `allow`
637    *
638    * @param allow Allow or disallow transactions
639    */
640   function voteAllowTransactions(bool allow) multisig(sha3(msg.data)) {
641     assert(allow != allowTransactions);
642     allowTransactions = allow;
643   }
644 
645   /**
646    * @notice Destructs the contract and sends remaining `this.balance` Ether to `beneficiary`
647    *
648    * @param beneficiary Beneficiary of remaining Ether on contract
649    */
650   function voteSuicide(address beneficiary) multisig(sha3(msg.data)) {
651     selfdestruct(beneficiary);
652   }
653 
654   /**
655    * @notice Sets frozen to `freeze` for account `target`
656    *
657    * @param addr Address to be frozen/unfrozen
658    * @param freeze Freeze/unfreeze account
659    */
660   function freezeAccount(address addr, bool freeze) multisig(sha3(msg.data)) {
661     frozenAccount[addr] = freeze;
662     activateAccount(addr);
663   }
664 
665   /**
666    * @notice Seizes `seizeAmount` of tokens from `address` and transfers it to hotwallet
667    *
668    * @param addr Adress to seize tokens from
669    * @param amount Amount of tokens to seize
670    */
671   function seizeTokens(address addr, uint256 amount) multisig(sha3(msg.data)) {
672     assert(balanceOf[addr] >= amount);
673     assert(frozenAccount[addr]);
674     activateAccount(addr);
675     balanceOf[addr] -= amount;
676     treasuryBalance += amount;
677   }
678 
679   /* --------------- fee calculation method ---------------- */
680 
681 
682   /**
683    * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.
684    *
685    * Fee's consist of a possible
686    *    - import fee on transfers to an address
687    *    - export fee on transfers from an address
688    * DVIP ownership on an address
689    *    - reduces fee on a transfer from this address to an import fee-ed address
690    *    - reduces the fee on a transfer to this address from an export fee-ed address
691    * DVIP discount does not work for addresses that have an import fee or export fee set up against them.
692    *
693    * DVIP discount goes up to 100%
694    *
695    * @param from From address
696    * @param to To address
697    * @param amount Amount for which fee needs to be calculated.
698    *
699    */
700   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {
701     uint256 fee = exportFee[from] + importFee[to];
702     if (fee == 0) return 0;
703     uint256 amountHeld;
704     bool discounted = true;
705     uint256 oneDVIPUnit;
706     if (exportFee[from] == 0 && balanceOf[from] != 0 && now < expiry) {
707       amountHeld = balanceOf[from];
708     } else if (importFee[to] == 0 && balanceOf[to] != 0 && now < expiry) {
709       amountHeld = balanceOf[to];
710     } else discounted = false;
711     if (discounted) {
712       oneDVIPUnit = pow10(1, decimals);
713       if (amountHeld > oneDVIPUnit) amountHeld = oneDVIPUnit;
714       uint256 remaining = oneDVIPUnit - amountHeld;
715       return div10(amount*fee*remaining, decimals*2);
716     }
717     return div10(amount*fee, decimals);
718   }
719 
720 
721   /* ---------------  overseer methods for emergency --------------*/
722 
723   /**
724    * @notice Shuts down all transaction and approval options on the asset contract
725    */
726   function shutdownTransactions() onlyOverseer {
727     allowTransactions = false;
728     TransactionsShutDown(msg.sender);
729   }
730 
731   /* ---------------  helper methods for siphoning --------------*/
732 
733   function extractAccountAllowanceRecordLength(address addr) constant returns (uint256 len) {
734     return allowanceIndex[addr].length;
735   }
736 
737   function extractAccountLength() constant returns (uint256 length) {
738     return accountIndex.length;
739   }
740 
741   /* ---------------  private methods --------------*/
742 
743   function activateAccount(address addr) internal {
744     if (!accountActive[addr]) {
745       accountActive[addr] = true;
746       accountIndex.push(addr);
747     }
748   }
749 
750   function activateAllowanceRecord(address from, address to) internal {
751     if (!allowanceActive[from][to]) {
752       allowanceActive[from][to] = true;
753       allowanceIndex[from].push(to);
754     }
755   }
756 
757   function activateExportFeeChargeRecord(address addr) internal {
758     if (!exportFeeActive[addr]) {
759       exportFeeActive[addr] = true;
760       exportFeeIndex.push(addr);
761     }
762   }
763 
764   function activateImportFeeChargeRecord(address addr) internal {
765     if (!importFeeActive[addr]) {
766       importFeeActive[addr] = true;
767       importFeeIndex.push(addr);
768     }
769   }
770   function extractImportFeeChargeLength() returns (uint256 length) {
771     return importFeeIndex.length;
772   }
773 
774   function extractExportFeeChargeLength() returns (uint256 length) {
775     return exportFeeIndex.length;
776   }
777 }
778 
779 /**
780  * @title DCAssetBackend Contract
781  *
782  * @author Ray Pulver, ray@decentralizedcapital.com
783  */
784 contract DCAssetBackend is Owned, Precision, StateTransferrable, TrustClient, Util {
785 
786   bytes32 public standard = 'Token 0.1';
787   bytes32 public name;
788   bytes32 public symbol;
789 
790   bool public allowTransactions;
791 
792   event Approval(address indexed from, address indexed spender, uint256 amount);
793 
794   mapping (address => uint256) public balanceOf;
795   mapping (address => mapping (address => uint256)) public allowance;
796 
797   event Transfer(address indexed from, address indexed to, uint256 value);
798 
799   uint256 public totalSupply;
800 
801   address public hotWalletAddress;
802   address public assetAddress;
803   address public oversightAddress;
804   address public membershipAddress;
805 
806   mapping (address => bool) public frozenAccount;
807 
808   mapping (address => address[]) public allowanceIndex;
809   mapping (address => mapping (address => bool)) public allowanceActive;
810   address[] public accountIndex;
811   mapping (address => bool) public accountActive;
812 
813   bool public isActive;
814   uint256 public treasuryBalance;
815 
816   mapping (address => uint256) public feeCharge;
817   address[] public feeChargeIndex;
818   mapping (address => bool) feeActive;
819 
820   event FrozenFunds(address target, bool frozen);
821   event PrecisionSet(address indexed from, uint8 precision);
822   event TransactionsShutDown(address indexed from);
823   event FeeSetup(address indexed from, address indexed target, uint256 amount);
824 
825 
826   /**
827    * Constructor.
828    *
829    * @param tokenName Name of the Token
830    * @param tokenSymbol The Token Symbol
831    */
832   function DCAssetBackend(bytes32 tokenSymbol, bytes32 tokenName) {
833     isActive = true;
834     name = tokenName;
835     symbol = tokenSymbol;
836     decimals = 6;
837     allowTransactions = true;
838   }
839 
840   /* ---------------  modifiers  --------------*/
841 
842   /**
843    * Makes sure a method is only called by an overseer.
844    */
845   modifier onlyOverseer {
846     assert(msg.sender == oversightAddress);
847     _
848   }
849 
850   /**
851    * Make sure only the front end Asset can call the transfer methods
852    */
853    modifier onlyAsset {
854     assert(msg.sender == assetAddress);
855     _
856    }
857 
858   /* ---------------  setter methods, only for the unlocked state --------------*/
859 
860 
861   /**
862    * Sets the hot wallet contract address
863    *
864    * @param addr Address of the Hotwallet
865    */
866   function setHotWallet(address addr) onlyOwnerUnlocked setter {
867     hotWalletAddress = addr;
868   }
869 
870   /**
871     * Sets the token facade contract address
872     *
873     * @param addr Address of the front-end Asset
874     */
875   function setAsset(address addr) onlyOwnerUnlocked setter {
876     assetAddress = addr;
877   }
878 
879   /**
880    * Sets the membership contract address
881    *
882    * @param addr Address of the membership contract
883    */
884   function setMembership(address addr) onlyOwnerUnlocked setter {
885     membershipAddress = addr;
886   }
887 
888   /**
889    * Sets the oversight address (not the contract).
890    *
891    * @param addr The oversight contract address.
892    */
893   function setOversight(address addr) onlyOwnerUnlocked setter {
894     oversightAddress = addr;
895   }
896 
897   /**
898    * Sets the total supply
899    *
900    * @param total Total supply of the asset.
901    */
902   function setTotalSupply(uint256 total) onlyOwnerUnlocked setter {
903     totalSupply = total;
904   }
905 
906   /**
907    * Set the Token Standard the contract applies to.
908    *
909    * @param std the Standard.
910    */
911   function setStandard(bytes32 std) onlyOwnerUnlocked setter {
912     standard = std;
913   }
914 
915   /**
916    * Sets the name of the contraxt
917    *
918    * @param _name the name.
919    */
920   function setName(bytes32 _name) onlyOwnerUnlocked setter {
921     name = _name;
922   }
923 
924   /**
925    * Sets the symbol
926    *
927    * @param sym The Symbol
928    */
929   function setSymbol(bytes32 sym) onlyOwnerUnlocked setter {
930     symbol = sym;
931   }
932 
933   /**
934    * Sets the precision
935    *
936    * @param precision Amount of decimals
937    */
938   function setPrecisionDirect(uint8 precision) onlyOwnerUnlocked {
939     decimals = precision;
940     PrecisionSet(msg.sender, precision);
941   }
942 
943   /**
944    * Sets the balance of a certain account.
945    *
946    * @param addr Address of the account
947    * @param amount Amount of assets to set on the account
948    */
949   function setAccountBalance(address addr, uint256 amount) onlyOwnerUnlocked {
950     balanceOf[addr] = amount;
951     activateAccount(addr);
952   }
953 
954   /**
955    * Sets an allowance from a specific account to a specific account.
956    *
957    * @param from From-part of the allowance
958    * @param to To-part of the allowance
959    * @param amount Amount of the allowance
960    */
961   function setAccountAllowance(address from, address to, uint256 amount) onlyOwnerUnlocked {
962     allowance[from][to] = amount;
963     activateAllowanceRecord(from, to);
964   }
965 
966   /**
967    * Sets the treasure balance to a certain account.
968    *
969    * @param amount Amount of assets to pre-set in the treasury
970    */
971   function setTreasuryBalance(uint256 amount) onlyOwnerUnlocked {
972     treasuryBalance = amount;
973   }
974 
975   /**
976    * Sets a certain account on frozen/unfrozen
977    *
978    * @param addr Account that will be frozen/unfrozen
979    * @param frozen Boolean to freeze or unfreeze
980    */
981   function setAccountFrozenStatus(address addr, bool frozen) onlyOwnerUnlocked {
982     activateAccount(addr);
983     frozenAccount[addr] = frozen;
984   }
985 
986   /* ---------------  main token methods  --------------*/
987 
988 
989   /**
990    * @notice Transfer `_amount` from `_caller` to `_to`.
991    *
992    * @param _caller Origin address
993    * @param _to Address that will receive.
994    * @param _amount Amount to be transferred.
995    */
996   function transfer(address _caller, address _to, uint256 _amount) onlyAsset returns (bool success) {
997     assert(allowTransactions);
998     assert(!frozenAccount[_caller]);
999     assert(balanceOf[_caller] >= _amount);
1000     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
1001     activateAccount(_caller);
1002     activateAccount(_to);
1003     balanceOf[_caller] -= _amount;
1004     if (_to == address(this)) treasuryBalance += _amount;
1005     else {
1006         uint256 fee = feeFor(_caller, _to, _amount);
1007         balanceOf[_to] += _amount - fee;
1008         treasuryBalance += fee;
1009     }
1010     Transfer(_caller, _to, _amount);
1011     return true;
1012   }
1013 
1014   /**
1015    * @notice Transfer `_amount` from `_from` to `_to`, invoked by `_caller`.
1016    *
1017    * @param _caller Invoker of the call (owner of the allowance)
1018    * @param _from Origin address
1019    * @param _to Address that will receive
1020    * @param _amount Amount to be transferred.
1021    * @return result of the method call
1022    */
1023   function transferFrom(address _caller, address _from, address _to, uint256 _amount) onlyAsset returns (bool success) {
1024     assert(allowTransactions);
1025     assert(!frozenAccount[_caller]);
1026     assert(!frozenAccount[_from]);
1027     assert(balanceOf[_from] >= _amount);
1028     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
1029     assert(_amount <= allowance[_from][_caller]);
1030     balanceOf[_from] -= _amount;
1031     uint256 fee = feeFor(_from, _to, _amount);
1032     balanceOf[_to] += _amount - fee;
1033     treasuryBalance += fee;
1034     allowance[_from][_caller] -= _amount;
1035     activateAccount(_from);
1036     activateAccount(_to);
1037     activateAccount(_caller);
1038     Transfer(_from, _to, _amount);
1039     return true;
1040   }
1041 
1042   /**
1043    * @notice Approve Approves spender `_spender` to transfer `_amount` from `_caller`
1044    *
1045    * @param _caller Address that grants the allowance
1046    * @param _spender Address that receives the cheque
1047    * @param _amount Amount on the cheque
1048    * @param _extraData Consequential contract to be executed by spender in same transcation.
1049    * @return result of the method call
1050    */
1051   function approveAndCall(address _caller, address _spender, uint256 _amount, bytes _extraData) onlyAsset returns (bool success) {
1052     assert(allowTransactions);
1053     assert(!frozenAccount[_caller]);
1054     allowance[_caller][_spender] = _amount;
1055     activateAccount(_caller);
1056     activateAccount(_spender);
1057     activateAllowanceRecord(_caller, _spender);
1058     TokenRecipient spender = TokenRecipient(_spender);
1059     assert(Relay(assetAddress).relayReceiveApproval(_caller, _spender, _amount, _extraData));
1060     Approval(_caller, _spender, _amount);
1061     return true;
1062   }
1063 
1064   /**
1065    * @notice Approve Approves spender `_spender` to transfer `_amount` from `_caller`
1066    *
1067    * @param _caller Address that grants the allowance
1068    * @param _spender Address that receives the cheque
1069    * @param _amount Amount on the cheque
1070    * @return result of the method call
1071    */
1072   function approve(address _caller, address _spender, uint256 _amount) onlyAsset returns (bool success) {
1073     assert(allowTransactions);
1074     assert(!frozenAccount[_caller]);
1075     allowance[_caller][_spender] = _amount;
1076     activateAccount(_caller);
1077     activateAccount(_spender);
1078     activateAllowanceRecord(_caller, _spender);
1079     Approval(_caller, _spender, _amount);
1080     return true;
1081   }
1082 
1083   /* ---------------  multisig admin methods  --------------*/
1084 
1085 
1086   /**
1087    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
1088    *
1089    * @param mintedAmount Amount of new tokens to be minted.
1090    */
1091   function mint(uint256 mintedAmount) multisig(sha3(msg.data)) {
1092     activateAccount(hotWalletAddress);
1093     balanceOf[hotWalletAddress] += mintedAmount;
1094     totalSupply += mintedAmount;
1095   }
1096 
1097   /**
1098    * @notice Destroys `destroyAmount` new tokens from the hotwallet `hotWalletAddress`
1099    *
1100    * @param destroyAmount Amount of new tokens to be minted.
1101    */
1102   function destroyTokens(uint256 destroyAmount) multisig(sha3(msg.data)) {
1103     assert(balanceOf[hotWalletAddress] >= destroyAmount);
1104     activateAccount(hotWalletAddress);
1105     balanceOf[hotWalletAddress] -= destroyAmount;
1106     totalSupply -= destroyAmount;
1107   }
1108 
1109   /**
1110    * @notice Transfers `amount` from the treasury to `to`
1111    *
1112    * @param to Address to transfer to
1113    * @param amount Amount to transfer from treasury
1114    */
1115   function transferFromTreasury(address to, uint256 amount) multisig(sha3(msg.data)) {
1116     assert(treasuryBalance >= amount);
1117     treasuryBalance -= amount;
1118     balanceOf[to] += amount;
1119     activateAccount(to);
1120   }
1121 
1122   /* ---------------  multisig emergency methods --------------*/
1123 
1124   /**
1125    * @notice Sets allow transactions to `allow`
1126    *
1127    * @param allow Allow or disallow transactions
1128    */
1129   function voteAllowTransactions(bool allow) multisig(sha3(msg.data)) {
1130     if (allow == allowTransactions) throw;
1131     allowTransactions = allow;
1132   }
1133 
1134   /**
1135    * @notice Destructs the contract and sends remaining `this.balance` Ether to `beneficiary`
1136    *
1137    * @param beneficiary Beneficiary of remaining Ether on contract
1138    */
1139   function voteSuicide(address beneficiary) multisig(sha3(msg.data)) {
1140     selfdestruct(beneficiary);
1141   }
1142 
1143   /**
1144    * @notice Sets frozen to `freeze` for account `target`
1145    *
1146    * @param addr Address to be frozen/unfrozen
1147    * @param freeze Freeze/unfreeze account
1148    */
1149   function freezeAccount(address addr, bool freeze) multisig(sha3(msg.data)) {
1150     frozenAccount[addr] = freeze;
1151     activateAccount(addr);
1152   }
1153 
1154   /**
1155    * @notice Seizes `seizeAmount` of tokens from `address` and transfers it to hotwallet
1156    *
1157    * @param addr Adress to seize tokens from
1158    * @param amount Amount of tokens to seize
1159    */
1160   function seizeTokens(address addr, uint256 amount) multisig(sha3(msg.data)) {
1161     assert(balanceOf[addr] >= amount);
1162     assert(frozenAccount[addr]);
1163     activateAccount(addr);
1164     balanceOf[addr] -= amount;
1165     balanceOf[hotWalletAddress] += amount;
1166   }
1167 
1168   /* ---------------  overseer methods for emergency --------------*/
1169 
1170   /**
1171    * @notice Shuts down all transaction and approval options on the asset contract
1172    */
1173   function shutdownTransactions() onlyOverseer {
1174     allowTransactions = false;
1175     TransactionsShutDown(msg.sender);
1176   }
1177 
1178   /* ---------------  helper methods for siphoning --------------*/
1179 
1180   function extractAccountAllowanceRecordLength(address addr) returns (uint256 len) {
1181     return allowanceIndex[addr].length;
1182   }
1183 
1184   function extractAccountLength() returns (uint256 length) {
1185     return accountIndex.length;
1186   }
1187 
1188 
1189   /* ---------------  private methods --------------*/
1190 
1191   function activateAccount(address addr) internal {
1192     if (!accountActive[addr]) {
1193       accountActive[addr] = true;
1194       accountIndex.push(addr);
1195     }
1196   }
1197 
1198   function activateAllowanceRecord(address from, address to) internal {
1199     if (!allowanceActive[from][to]) {
1200       allowanceActive[from][to] = true;
1201       allowanceIndex[from].push(to);
1202     }
1203   }
1204   function feeFor(address a, address b, uint256 amount) returns (uint256 value) {
1205     if (membershipAddress == address(0x0)) return 0;
1206     return DVIP(membershipAddress).feeFor(a, b, amount);
1207   }
1208 }
1209 
1210 
1211 /**
1212  * @title DCAssetFacade, Facade for the underlying back-end dcasset token contract. Allow to be updated later.
1213  *
1214  * @author P.S.D. Reitsma, peter@decentralizedcapital.com
1215  *
1216  */
1217 contract DCAsset is TokenBase, StateTransferrable, TrustClient, Relay {
1218 
1219    address public backendContract;
1220 
1221    /**
1222     * Constructor
1223     *
1224     *
1225     */
1226    function DCAsset(address _backendContract) {
1227      backendContract = _backendContract;
1228    }
1229 
1230    function standard() constant returns (bytes32 std) {
1231      return DCAssetBackend(backendContract).standard();
1232    }
1233 
1234    function name() constant returns (bytes32 nm) {
1235      return DCAssetBackend(backendContract).name();
1236    }
1237 
1238    function symbol() constant returns (bytes32 sym) {
1239      return DCAssetBackend(backendContract).symbol();
1240    }
1241 
1242    function decimals() constant returns (uint8 precision) {
1243      return DCAssetBackend(backendContract).decimals();
1244    }
1245   
1246    function allowance(address from, address to) constant returns (uint256 res) {
1247      return DCAssetBackend(backendContract).allowance(from, to);
1248    }
1249 
1250 
1251    /* ---------------  multisig admin methods  --------------*/
1252 
1253 
1254    /**
1255     * @notice Sets the backend contract to `_backendContract`. Can only be switched by multisig.
1256     *
1257     * @param _backendContract Address of the underlying token contract.
1258     */
1259    function setBackend(address _backendContract) multisig(sha3(msg.data)) {
1260      backendContract = _backendContract;
1261    }
1262 
1263    /* ---------------  main token methods  --------------*/
1264 
1265    /**
1266     * @notice Returns the balance of `_address`.
1267     *
1268     * @param _address The address of the balance.
1269     */
1270    function balanceOf(address _address) constant returns (uint256 balance) {
1271       return DCAssetBackend(backendContract).balanceOf(_address);
1272    }
1273 
1274    /**
1275     * @notice Returns the total supply of the token
1276     *
1277     */
1278    function totalSupply() constant returns (uint256 balance) {
1279       return DCAssetBackend(backendContract).totalSupply();
1280    }
1281 
1282   /**
1283    * @notice Transfer `_amount` to `_to`.
1284    *
1285    * @param _to Address that will receive.
1286    * @param _amount Amount to be transferred.
1287    */
1288    function transfer(address _to, uint256 _amount) returns (bool success)  {
1289       if (!DCAssetBackend(backendContract).transfer(msg.sender, _to, _amount)) throw;
1290       Transfer(msg.sender, _to, _amount);
1291       return true;
1292    }
1293 
1294   /**
1295    * @notice Approve Approves spender `_spender` to transfer `_amount`.
1296    *
1297    * @param _spender Address that receives the cheque
1298    * @param _amount Amount on the cheque
1299    * @param _extraData Consequential contract to be executed by spender in same transcation.
1300    * @return result of the method call
1301    */
1302    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
1303       if (!DCAssetBackend(backendContract).approveAndCall(msg.sender, _spender, _amount, _extraData)) throw;
1304       Approval(msg.sender, _spender, _amount);
1305       return true;
1306    }
1307 
1308   /**
1309    * @notice Approve Approves spender `_spender` to transfer `_amount`.
1310    *
1311    * @param _spender Address that receives the cheque
1312    * @param _amount Amount on the cheque
1313    * @return result of the method call
1314    */
1315    function approve(address _spender, uint256 _amount) returns (bool success) {
1316       if (!DCAssetBackend(backendContract).approve(msg.sender, _spender, _amount)) throw;
1317       Approval(msg.sender, _spender, _amount);
1318       return true;
1319    }
1320 
1321   /**
1322    * @notice Transfer `_amount` from `_from` to `_to`.
1323    *
1324    * @param _from Origin address
1325    * @param _to Address that will receive
1326    * @param _amount Amount to be transferred.
1327    * @return result of the method call
1328    */
1329   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
1330       if (!DCAssetBackend(backendContract).transferFrom(msg.sender, _from, _to, _amount)) throw;
1331       Transfer(_from, _to, _amount);
1332       return true;
1333   }
1334 
1335   /**
1336    * @notice Returns fee for transferral of `_amount` from `_from` to `_to`.
1337    *
1338    * @param _from Origin address
1339    * @param _to Address that will receive
1340    * @param _amount Amount to be transferred.
1341    * @return height of the fee
1342    */
1343   function feeFor(address _from, address _to, uint256 _amount) returns (uint256 amount) {
1344       return DCAssetBackend(backendContract).feeFor(_from, _to, _amount);
1345   }
1346 
1347   /* ---------------  to be called by backend  --------------*/
1348 
1349   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
1350      assert(msg.sender == backendContract);
1351      TokenRecipient spender = TokenRecipient(_spender);
1352      spender.receiveApproval(_caller, _amount, this, _extraData);
1353      return true;
1354   }
1355 
1356 }