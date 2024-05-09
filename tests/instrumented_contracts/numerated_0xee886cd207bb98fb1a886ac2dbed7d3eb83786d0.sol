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
142     if (!masterKeys[from] && !trustedClients[msg.sender]) {
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
196 contract TrustClient is StateTransferrable, TrustEvents {
197   address public trustAddress;
198   function setTrust(address addr) setter onlyOwnerUnlocked {
199     trustAddress = addr;
200   }
201   function nameFor(address addr) constant returns (bytes32 name) {
202     return Trust(trustAddress).nameFor(addr);
203   }
204   function cancel() returns (uint8 status) {
205     assert(trustAddress != address(0x0));
206     uint8 code = Trust(trustAddress).authCancel(msg.sender);
207     if (code == 0) Unauthorized(msg.sender);
208     else if (code == 1) NothingToCancel(msg.sender);
209     else if (code == 2) AuthCancel(msg.sender, msg.sender);
210     return code;
211   }
212   modifier multisig (bytes32 hash) {
213     assert(trustAddress != address(0x0));
214     address current = Trust(trustAddress).functionCalls(uint256(hash));
215     uint8 code = Trust(trustAddress).authCall(msg.sender, hash);
216     if (code == 0) Unauthorized(msg.sender);
217     else if (code == 1) AuthInit(msg.sender);
218     else if (code == 2) {
219       AuthComplete(current, msg.sender);
220       _
221     }
222     else if (code == 3) {
223       AuthPending(msg.sender);
224     }
225   }
226 }
227 contract Relay {
228   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success);
229 }
230 contract TokenBase is Owned {
231     bytes32 public standard = 'Token 0.1';
232     bytes32 public name;
233     bytes32 public symbol;
234     uint256 public totalSupply;
235     bool public allowTransactions;
236 
237     event Approval(address indexed from, address indexed spender, uint256 amount);
238 
239     mapping (address => uint256) public balanceOf;
240     mapping (address => mapping (address => uint256)) public allowance;
241 
242     event Transfer(address indexed from, address indexed to, uint256 value);
243 
244     function transfer(address _to, uint256 _value) returns (bool success);
245     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
246     function approve(address _spender, uint256 _value) returns (bool success);
247     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
248 
249     function () {
250         throw;
251     }
252 }
253 
254 contract Precision {
255   uint8 public decimals;
256 }
257 contract Token is TokenBase, Precision {}
258 contract Util {
259   function pow10(uint256 a, uint8 b) internal returns (uint256 result) {
260     for (uint8 i = 0; i < b; i++) {
261       a *= 10;
262     }
263     return a;
264   }
265   function div10(uint256 a, uint8 b) internal returns (uint256 result) {
266     for (uint8 i = 0; i < b; i++) {
267       a /= 10;
268     }
269     return a;
270   }
271   function max(uint256 a, uint256 b) internal returns (uint256 res) {
272     if (a >= b) return a;
273     return b;
274   }
275 }
276 
277 /**
278  * @title DVIP Contract. DCAsset Membership Token contract.
279  *
280  * @author Ray Pulver, ray@decentralizedcapital.com
281  */
282 contract DVIP is Token, StateTransferrable, TrustClient, Util {
283 
284   uint256 public totalSupply;
285 
286   mapping (address => bool) public frozenAccount;
287 
288   mapping (address => address[]) public allowanceIndex;
289   mapping (address => mapping (address => bool)) public allowanceActive;
290   address[] public accountIndex;
291   mapping (address => bool) public accountActive;
292   address public oversightAddress;
293   uint256 public expiry;
294 
295   uint256 public treasuryBalance;
296 
297   bool public isActive;
298   mapping (address => uint256) public exportFee;
299   address[] public exportFeeIndex;
300   mapping (address => bool) exportFeeActive;
301 
302   mapping (address => uint256) public importFee;
303   address[] public importFeeIndex;
304   mapping (address => bool) importFeeActive;
305 
306   event FrozenFunds(address target, bool frozen);
307   event PrecisionSet(address indexed from, uint8 precision);
308   event TransactionsShutDown(address indexed from);
309   event FeeSetup(address indexed from, address indexed target, uint256 amount);
310 
311 
312   /**
313    * Constructor.
314    *
315    */
316   function DVIP() {
317     isActive = true;
318     treasuryBalance = 0;
319     totalSupply = 0;
320     name = "DVIP";
321     symbol = "DVIP";
322     decimals = 6;
323     allowTransactions = true;
324     expiry = 1514764800; //1 jan 2018
325   }
326 
327 
328   /* ---------------  modifiers  --------------*/
329 
330   /**
331    * Makes sure a method is only called by an overseer.
332    */
333   modifier onlyOverseer {
334     assert(msg.sender == oversightAddress);
335     _
336   }
337 
338   /* ---------------  setter methods, only for the unlocked state --------------*/
339 
340 
341   /**
342    * Sets the oversight address (not the contract).
343    *
344    * @param addr The oversight contract address.
345    */
346   function setOversight(address addr) onlyOwnerUnlocked setter {
347     oversightAddress = addr;
348   }
349 
350 
351   /**
352    * Sets the total supply
353    *
354    * @param total Total supply of the asset.
355    */
356   function setTotalSupply(uint256 total) onlyOwnerUnlocked setter {
357     totalSupply = total;
358   }
359 
360   /**
361    * Set the Token Standard the contract applies to.
362    *
363    * @param std the Standard.
364    */
365   function setStandard(bytes32 std) onlyOwnerUnlocked setter {
366     standard = std;
367   }
368 
369   /**
370    * Sets the name of the contraxt
371    *
372    * @param _name the name.
373    */
374   function setName(bytes32 _name) onlyOwnerUnlocked setter {
375     name = _name;
376   }
377 
378   /**
379    * Sets the symbol
380    *
381    * @param sym The Symbol
382    */
383   function setSymbol(bytes32 sym) onlyOwnerUnlocked setter {
384     symbol = sym;
385   }
386 
387   /**
388    * Sets the precision
389    *
390    * @param precision Amount of decimals
391    */
392   function setPrecisionDirect(uint8 precision) onlyOwnerUnlocked {
393     decimals = precision;
394     PrecisionSet(msg.sender, precision);
395   }
396 
397   /**
398    * Sets the balance of a certain account.
399    *
400    * @param addr Address of the account
401    * @param amount Amount of assets to set on the account
402    */
403   function setAccountBalance(address addr, uint256 amount) onlyOwnerUnlocked {
404     balanceOf[addr] = amount;
405     activateAccount(addr);
406   }
407 
408   /**
409    * Sets an allowance from a specific account to a specific account.
410    *
411    * @param from From-part of the allowance
412    * @param to To-part of the allowance
413    * @param amount Amount of the allowance
414    */
415   function setAccountAllowance(address from, address to, uint256 amount) onlyOwnerUnlocked {
416     allowance[from][to] = amount;
417     activateAllowanceRecord(from, to);
418   }
419 
420   /**
421    * Sets the treasure balance to a certain account.
422    *
423    * @param amount Amount of assets to pre-set in the treasury
424    */
425   function setTreasuryBalance(uint256 amount) onlyOwnerUnlocked {
426     treasuryBalance = amount;
427   }
428 
429   /**
430    * Sets a certain account on frozen/unfrozen
431    *
432    * @param addr Account that will be frozen/unfrozen
433    * @param frozen Boolean to freeze or unfreeze
434    */
435   function setAccountFrozenStatus(address addr, bool frozen) onlyOwnerUnlocked {
436     activateAccount(addr);
437     frozenAccount[addr] = frozen;
438   }
439 
440   /**
441    * Sets up a import fee for a certain address.
442    *
443    * @param addr Address that will require fee
444    * @param fee Amount of fee
445    */
446   function setupImportFee(address addr, uint256 fee) onlyOwnerUnlocked {
447     importFee[addr] = fee;
448     activateImportFeeChargeRecord(addr);
449     FeeSetup(msg.sender, addr, fee);
450   }
451  
452   /**
453    * Sets up a export fee for a certain address.
454    *
455    * @param addr Address that will require fee
456    * @param fee Amount of fee
457    */
458   function setupExportFee(address addr, uint256 fee) onlyOwnerUnlocked {
459     exportFee[addr] = fee;
460     activateExportFeeChargeRecord(addr);
461     FeeSetup(msg.sender, addr, fee);
462   }
463 
464   /* ---------------  main token methods  --------------*/
465 
466 
467   /**
468    * @notice Transfer `_amount` from `msg.sender.address()` to `_to`.
469    *
470    * @param _to Address that will receive.
471    * @param _amount Amount to be transferred.
472    */
473   function transfer(address _to, uint256 _amount) returns (bool success) {
474     assert(allowTransactions);
475     assert(!frozenAccount[msg.sender]);
476     assert(balanceOf[msg.sender] >= _amount);
477     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
478     activateAccount(msg.sender);
479     activateAccount(_to);
480     balanceOf[msg.sender] -= _amount;
481     if (_to == address(this)) treasuryBalance += _amount;
482     else balanceOf[_to] += _amount;
483     Transfer(msg.sender, _to, _amount);
484     return true;
485   }
486 
487   /**
488    * @notice Transfer `_amount` from `_from` to `_to`.
489    *
490    * @param _from Origin address
491    * @param _to Address that will receive
492    * @param _amount Amount to be transferred.
493    * @return result of the method call
494    */
495   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
496     assert(allowTransactions);
497     assert(!frozenAccount[msg.sender]);
498     assert(!frozenAccount[_from]);
499     assert(balanceOf[_from] >= _amount);
500     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
501     assert(_amount <= allowance[_from][msg.sender]);
502     balanceOf[_from] -= _amount;
503     balanceOf[_to] += _amount;
504     allowance[_from][msg.sender] -= _amount;
505     activateAccount(_from);
506     activateAccount(_to);
507     activateAccount(msg.sender);
508     Transfer(_from, _to, _amount);
509     return true;
510   }
511 
512   /**
513    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
514    *
515    * @param _spender Address that receives the cheque
516    * @param _amount Amount on the cheque
517    * @param _extraData Consequential contract to be executed by spender in same transcation.
518    * @return result of the method call
519    */
520   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
521     assert(allowTransactions);
522     assert(!frozenAccount[msg.sender]);
523     allowance[msg.sender][_spender] = _amount;
524     activateAccount(msg.sender);
525     activateAccount(_spender);
526     activateAllowanceRecord(msg.sender, _spender);
527     TokenRecipient spender = TokenRecipient(_spender);
528     spender.receiveApproval(msg.sender, _amount, this, _extraData);
529     Approval(msg.sender, _spender, _amount);
530     return true;
531   }
532 
533   /**
534    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
535    *
536    * @param _spender Address that receives the cheque
537    * @param _amount Amount on the cheque
538    * @return result of the method call
539    */
540   function approve(address _spender, uint256 _amount) returns (bool success) {
541     assert(allowTransactions);
542     assert(!frozenAccount[msg.sender]);
543     allowance[msg.sender][_spender] = _amount;
544     activateAccount(msg.sender);
545     activateAccount(_spender);
546     activateAllowanceRecord(msg.sender, _spender);
547     Approval(msg.sender, _spender, _amount);
548     return true;
549   }
550 
551   /* ---------------  multisig admin methods  --------------*/
552 
553 
554 
555   /**
556    * @notice Sets the expiry time in milliseconds since 1970.
557    *
558    * @param ts milliseconds since 1970.
559    *
560    */
561   function setExpiry(uint256 ts) multisig(sha3(msg.data)) {
562     expiry = ts;
563   }
564 
565   /**
566    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
567    *
568    * @param mintedAmount Amount of new tokens to be minted.
569    */
570   function mint(uint256 mintedAmount) multisig(sha3(msg.data)) {
571     treasuryBalance += mintedAmount;
572     totalSupply += mintedAmount;
573   }
574 
575   /**
576    * @notice Destroys `destroyAmount` new tokens from the hotwallet `hotWalletAddress`
577    *
578    * @param destroyAmount Amount of new tokens to be minted.
579    */
580   function destroyTokens(uint256 destroyAmount) multisig(sha3(msg.data)) {
581     assert(treasuryBalance >= destroyAmount);
582     treasuryBalance -= destroyAmount;
583     totalSupply -= destroyAmount;
584   }
585 
586   /**
587    * @notice Transfers `amount` from the treasury to `to`
588    *
589    * @param to Address to transfer to
590    * @param amount Amount to transfer from treasury
591    */
592   function transferFromTreasury(address to, uint256 amount) multisig(sha3(msg.data)) {
593     assert(treasuryBalance >= amount);
594     treasuryBalance -= amount;
595     balanceOf[to] += amount;
596     activateAccount(to);
597   }
598 
599   /* ---------------  fee setting administration methods  --------------*/
600 
601   /**
602    * @notice Sets an import fee of `fee` on address `addr`
603    *
604    * @param addr Address for which the fee is valid
605    * @param addr fee Fee
606    *
607    */
608   function setImportFee(address addr, uint256 fee) multisig(sha3(msg.data)) {
609     uint256 max = 1;
610     max = pow10(1, decimals);
611     assert(fee <= max);
612     importFee[addr] = fee;
613     activateImportFeeChargeRecord(addr);
614   }
615 
616   /**
617    * @notice Sets an export fee of `fee` on address `addr`
618    *
619    * @param addr Address for which the fee is valid
620    * @param addr fee Fee
621    *
622    */
623   function setExportFee(address addr, uint256 fee) multisig(sha3(msg.data)) {
624     uint256 max = 1;
625     max = pow10(1, decimals);
626     assert(fee <= max);
627     exportFee[addr] = fee;
628     activateExportFeeChargeRecord(addr);
629   }
630 
631 
632   /* ---------------  multisig emergency methods --------------*/
633 
634   /**
635    * @notice Sets allow transactions to `allow`
636    *
637    * @param allow Allow or disallow transactions
638    */
639   function voteAllowTransactions(bool allow) multisig(sha3(msg.data)) {
640     assert(allow != allowTransactions);
641     allowTransactions = allow;
642   }
643 
644   /**
645    * @notice Destructs the contract and sends remaining `this.balance` Ether to `beneficiary`
646    *
647    * @param beneficiary Beneficiary of remaining Ether on contract
648    */
649   function voteSuicide(address beneficiary) multisig(sha3(msg.data)) {
650     selfdestruct(beneficiary);
651   }
652 
653   /**
654    * @notice Sets frozen to `freeze` for account `target`
655    *
656    * @param addr Address to be frozen/unfrozen
657    * @param freeze Freeze/unfreeze account
658    */
659   function freezeAccount(address addr, bool freeze) multisig(sha3(msg.data)) {
660     frozenAccount[addr] = freeze;
661     activateAccount(addr);
662   }
663 
664   /**
665    * @notice Seizes `seizeAmount` of tokens from `address` and transfers it to hotwallet
666    *
667    * @param addr Adress to seize tokens from
668    * @param amount Amount of tokens to seize
669    */
670   function seizeTokens(address addr, uint256 amount) multisig(sha3(msg.data)) {
671     assert(balanceOf[addr] >= amount);
672     assert(frozenAccount[addr]);
673     activateAccount(addr);
674     balanceOf[addr] -= amount;
675     treasuryBalance += amount;
676   }
677 
678   /* --------------- fee calculation method ---------------- */
679 
680 
681   /**
682    * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.
683    *
684    * Fee's consist of a possible
685    *    - import fee on transfers to an address
686    *    - export fee on transfers from an address
687    * DVIP ownership on an address
688    *    - reduces fee on a transfer from this address to an import fee-ed address
689    *    - reduces the fee on a transfer to this address from an export fee-ed address
690    * DVIP discount does not work for addresses that have an import fee or export fee set up against them.
691    *
692    * DVIP discount goes up to 100%
693    *
694    * @param from From address
695    * @param to To address
696    * @param amount Amount for which fee needs to be calculated.
697    *
698    */
699   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {
700     uint256 fee = exportFee[from] + importFee[to];
701     if (fee == 0) return 0;
702     uint256 amountHeld;
703     bool discounted = true;
704     uint256 oneDVIPUnit;
705     if (exportFee[from] == 0 && balanceOf[from] != 0 && now < expiry) {
706       amountHeld = balanceOf[from];
707     } else if (importFee[to] == 0 && balanceOf[to] != 0 && now < expiry) {
708       amountHeld = balanceOf[to];
709     } else discounted = false;
710     if (discounted) {
711       oneDVIPUnit = pow10(1, decimals);
712       if (amountHeld > oneDVIPUnit) amountHeld = oneDVIPUnit;
713       uint256 remaining = oneDVIPUnit - amountHeld;
714       return div10(amount*fee*remaining, decimals*2);
715     }
716     return div10(amount*fee, decimals);
717   }
718 
719 
720   /* ---------------  overseer methods for emergency --------------*/
721 
722   /**
723    * @notice Shuts down all transaction and approval options on the asset contract
724    */
725   function shutdownTransactions() onlyOverseer {
726     allowTransactions = false;
727     TransactionsShutDown(msg.sender);
728   }
729 
730   /* ---------------  helper methods for siphoning --------------*/
731 
732   function extractAccountAllowanceRecordLength(address addr) constant returns (uint256 len) {
733     return allowanceIndex[addr].length;
734   }
735 
736   function extractAccountLength() constant returns (uint256 length) {
737     return accountIndex.length;
738   }
739 
740   /* ---------------  private methods --------------*/
741 
742   function activateAccount(address addr) internal {
743     if (!accountActive[addr]) {
744       accountActive[addr] = true;
745       accountIndex.push(addr);
746     }
747   }
748 
749   function activateAllowanceRecord(address from, address to) internal {
750     if (!allowanceActive[from][to]) {
751       allowanceActive[from][to] = true;
752       allowanceIndex[from].push(to);
753     }
754   }
755 
756   function activateExportFeeChargeRecord(address addr) internal {
757     if (!exportFeeActive[addr]) {
758       exportFeeActive[addr] = true;
759       exportFeeIndex.push(addr);
760     }
761   }
762 
763   function activateImportFeeChargeRecord(address addr) internal {
764     if (!importFeeActive[addr]) {
765       importFeeActive[addr] = true;
766       importFeeIndex.push(addr);
767     }
768   }
769   function extractImportFeeChargeLength() returns (uint256 length) {
770     return importFeeIndex.length;
771   }
772 
773   function extractExportFeeChargeLength() returns (uint256 length) {
774     return exportFeeIndex.length;
775   }
776 }
777 
778 /**
779  * @title DCAssetBackend Contract
780  *
781  * @author Ray Pulver, ray@decentralizedcapital.com
782  */
783 contract DCAssetBackend is Owned, Precision, StateTransferrable, TrustClient, Util {
784 
785   bytes32 public standard = 'Token 0.1';
786   bytes32 public name;
787   bytes32 public symbol;
788 
789   bool public allowTransactions;
790 
791   event Approval(address indexed from, address indexed spender, uint256 amount);
792 
793   mapping (address => uint256) public balanceOf;
794   mapping (address => mapping (address => uint256)) public allowance;
795 
796   event Transfer(address indexed from, address indexed to, uint256 value);
797 
798   uint256 public totalSupply;
799 
800   address public hotWalletAddress;
801   address public assetAddress;
802   address public oversightAddress;
803   address public membershipAddress;
804 
805   mapping (address => bool) public frozenAccount;
806 
807   mapping (address => address[]) public allowanceIndex;
808   mapping (address => mapping (address => bool)) public allowanceActive;
809   address[] public accountIndex;
810   mapping (address => bool) public accountActive;
811 
812   bool public isActive;
813   uint256 public treasuryBalance;
814 
815   mapping (address => uint256) public feeCharge;
816   address[] public feeChargeIndex;
817   mapping (address => bool) feeActive;
818 
819   event FrozenFunds(address target, bool frozen);
820   event PrecisionSet(address indexed from, uint8 precision);
821   event TransactionsShutDown(address indexed from);
822   event FeeSetup(address indexed from, address indexed target, uint256 amount);
823 
824 
825   /**
826    * Constructor.
827    *
828    * @param tokenName Name of the Token
829    * @param tokenSymbol The Token Symbol
830    */
831   function DCAssetBackend(bytes32 tokenSymbol, bytes32 tokenName) {
832     isActive = true;
833     name = tokenName;
834     symbol = tokenSymbol;
835     decimals = 6;
836     allowTransactions = true;
837   }
838 
839   /* ---------------  modifiers  --------------*/
840 
841   /**
842    * Makes sure a method is only called by an overseer.
843    */
844   modifier onlyOverseer {
845     assert(msg.sender == oversightAddress);
846     _
847   }
848 
849   /**
850    * Make sure only the front end Asset can call the transfer methods
851    */
852    modifier onlyAsset {
853     assert(msg.sender == assetAddress);
854     _
855    }
856 
857   /* ---------------  setter methods, only for the unlocked state --------------*/
858 
859 
860   /**
861    * Sets the hot wallet contract address
862    *
863    * @param addr Address of the Hotwallet
864    */
865   function setHotWallet(address addr) onlyOwnerUnlocked setter {
866     hotWalletAddress = addr;
867   }
868 
869   /**
870     * Sets the token facade contract address
871     *
872     * @param addr Address of the front-end Asset
873     */
874   function setAsset(address addr) onlyOwnerUnlocked setter {
875     assetAddress = addr;
876   }
877 
878   /**
879    * Sets the membership contract address
880    *
881    * @param addr Address of the membership contract
882    */
883   function setMembership(address addr) onlyOwnerUnlocked setter {
884     membershipAddress = addr;
885   }
886 
887   /**
888    * Sets the oversight address (not the contract).
889    *
890    * @param addr The oversight contract address.
891    */
892   function setOversight(address addr) onlyOwnerUnlocked setter {
893     oversightAddress = addr;
894   }
895 
896   /**
897    * Sets the total supply
898    *
899    * @param total Total supply of the asset.
900    */
901   function setTotalSupply(uint256 total) onlyOwnerUnlocked setter {
902     totalSupply = total;
903   }
904 
905   /**
906    * Set the Token Standard the contract applies to.
907    *
908    * @param std the Standard.
909    */
910   function setStandard(bytes32 std) onlyOwnerUnlocked setter {
911     standard = std;
912   }
913 
914   /**
915    * Sets the name of the contraxt
916    *
917    * @param _name the name.
918    */
919   function setName(bytes32 _name) onlyOwnerUnlocked setter {
920     name = _name;
921   }
922 
923   /**
924    * Sets the symbol
925    *
926    * @param sym The Symbol
927    */
928   function setSymbol(bytes32 sym) onlyOwnerUnlocked setter {
929     symbol = sym;
930   }
931 
932   /**
933    * Sets the precision
934    *
935    * @param precision Amount of decimals
936    */
937   function setPrecisionDirect(uint8 precision) onlyOwnerUnlocked {
938     decimals = precision;
939     PrecisionSet(msg.sender, precision);
940   }
941 
942   /**
943    * Sets the balance of a certain account.
944    *
945    * @param addr Address of the account
946    * @param amount Amount of assets to set on the account
947    */
948   function setAccountBalance(address addr, uint256 amount) onlyOwnerUnlocked {
949     balanceOf[addr] = amount;
950     activateAccount(addr);
951   }
952 
953   /**
954    * Sets an allowance from a specific account to a specific account.
955    *
956    * @param from From-part of the allowance
957    * @param to To-part of the allowance
958    * @param amount Amount of the allowance
959    */
960   function setAccountAllowance(address from, address to, uint256 amount) onlyOwnerUnlocked {
961     allowance[from][to] = amount;
962     activateAllowanceRecord(from, to);
963   }
964 
965   /**
966    * Sets the treasure balance to a certain account.
967    *
968    * @param amount Amount of assets to pre-set in the treasury
969    */
970   function setTreasuryBalance(uint256 amount) onlyOwnerUnlocked {
971     treasuryBalance = amount;
972   }
973 
974   /**
975    * Sets a certain account on frozen/unfrozen
976    *
977    * @param addr Account that will be frozen/unfrozen
978    * @param frozen Boolean to freeze or unfreeze
979    */
980   function setAccountFrozenStatus(address addr, bool frozen) onlyOwnerUnlocked {
981     activateAccount(addr);
982     frozenAccount[addr] = frozen;
983   }
984 
985   /* ---------------  main token methods  --------------*/
986 
987 
988   /**
989    * @notice Transfer `_amount` from `_caller` to `_to`.
990    *
991    * @param _caller Origin address
992    * @param _to Address that will receive.
993    * @param _amount Amount to be transferred.
994    */
995   function transfer(address _caller, address _to, uint256 _amount) onlyAsset returns (bool success) {
996     assert(allowTransactions);
997     assert(!frozenAccount[_caller]);
998     assert(balanceOf[_caller] >= _amount);
999     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
1000     activateAccount(_caller);
1001     activateAccount(_to);
1002     balanceOf[_caller] -= _amount;
1003     if (_to == address(this)) treasuryBalance += _amount;
1004     else {
1005         uint256 fee = feeFor(_caller, _to, _amount);
1006         balanceOf[_to] += _amount - fee;
1007         treasuryBalance += fee;
1008     }
1009     Transfer(_caller, _to, _amount);
1010     return true;
1011   }
1012 
1013   /**
1014    * @notice Transfer `_amount` from `_from` to `_to`, invoked by `_caller`.
1015    *
1016    * @param _caller Invoker of the call (owner of the allowance)
1017    * @param _from Origin address
1018    * @param _to Address that will receive
1019    * @param _amount Amount to be transferred.
1020    * @return result of the method call
1021    */
1022   function transferFrom(address _caller, address _from, address _to, uint256 _amount) onlyAsset returns (bool success) {
1023     assert(allowTransactions);
1024     assert(!frozenAccount[_caller]);
1025     assert(!frozenAccount[_from]);
1026     assert(balanceOf[_from] >= _amount);
1027     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
1028     assert(_amount <= allowance[_from][_caller]);
1029     balanceOf[_from] -= _amount;
1030     uint256 fee = feeFor(_from, _to, _amount);
1031     balanceOf[_to] += _amount - fee;
1032     treasuryBalance += fee;
1033     allowance[_from][_caller] -= _amount;
1034     activateAccount(_from);
1035     activateAccount(_to);
1036     activateAccount(_caller);
1037     Transfer(_from, _to, _amount);
1038     return true;
1039   }
1040 
1041   /**
1042    * @notice Approve Approves spender `_spender` to transfer `_amount` from `_caller`
1043    *
1044    * @param _caller Address that grants the allowance
1045    * @param _spender Address that receives the cheque
1046    * @param _amount Amount on the cheque
1047    * @param _extraData Consequential contract to be executed by spender in same transcation.
1048    * @return result of the method call
1049    */
1050   function approveAndCall(address _caller, address _spender, uint256 _amount, bytes _extraData) onlyAsset returns (bool success) {
1051     assert(allowTransactions);
1052     assert(!frozenAccount[_caller]);
1053     allowance[_caller][_spender] = _amount;
1054     activateAccount(_caller);
1055     activateAccount(_spender);
1056     activateAllowanceRecord(_caller, _spender);
1057     TokenRecipient spender = TokenRecipient(_spender);
1058     assert(Relay(assetAddress).relayReceiveApproval(_caller, _spender, _amount, _extraData));
1059     Approval(_caller, _spender, _amount);
1060     return true;
1061   }
1062 
1063   /**
1064    * @notice Approve Approves spender `_spender` to transfer `_amount` from `_caller`
1065    *
1066    * @param _caller Address that grants the allowance
1067    * @param _spender Address that receives the cheque
1068    * @param _amount Amount on the cheque
1069    * @return result of the method call
1070    */
1071   function approve(address _caller, address _spender, uint256 _amount) onlyAsset returns (bool success) {
1072     assert(allowTransactions);
1073     assert(!frozenAccount[_caller]);
1074     allowance[_caller][_spender] = _amount;
1075     activateAccount(_caller);
1076     activateAccount(_spender);
1077     activateAllowanceRecord(_caller, _spender);
1078     Approval(_caller, _spender, _amount);
1079     return true;
1080   }
1081 
1082   /* ---------------  multisig admin methods  --------------*/
1083 
1084 
1085   /**
1086    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
1087    *
1088    * @param mintedAmount Amount of new tokens to be minted.
1089    */
1090   function mint(uint256 mintedAmount) multisig(sha3(msg.data)) {
1091     activateAccount(hotWalletAddress);
1092     balanceOf[hotWalletAddress] += mintedAmount;
1093     totalSupply += mintedAmount;
1094   }
1095 
1096   /**
1097    * @notice Destroys `destroyAmount` new tokens from the hotwallet `hotWalletAddress`
1098    *
1099    * @param destroyAmount Amount of new tokens to be minted.
1100    */
1101   function destroyTokens(uint256 destroyAmount) multisig(sha3(msg.data)) {
1102     assert(balanceOf[hotWalletAddress] >= destroyAmount);
1103     activateAccount(hotWalletAddress);
1104     balanceOf[hotWalletAddress] -= destroyAmount;
1105     totalSupply -= destroyAmount;
1106   }
1107 
1108   /**
1109    * @notice Transfers `amount` from the treasury to `to`
1110    *
1111    * @param to Address to transfer to
1112    * @param amount Amount to transfer from treasury
1113    */
1114   function transferFromTreasury(address to, uint256 amount) multisig(sha3(msg.data)) {
1115     assert(treasuryBalance >= amount);
1116     treasuryBalance -= amount;
1117     balanceOf[to] += amount;
1118     activateAccount(to);
1119   }
1120 
1121   /* ---------------  multisig emergency methods --------------*/
1122 
1123   /**
1124    * @notice Sets allow transactions to `allow`
1125    *
1126    * @param allow Allow or disallow transactions
1127    */
1128   function voteAllowTransactions(bool allow) multisig(sha3(msg.data)) {
1129     if (allow == allowTransactions) throw;
1130     allowTransactions = allow;
1131   }
1132 
1133   /**
1134    * @notice Destructs the contract and sends remaining `this.balance` Ether to `beneficiary`
1135    *
1136    * @param beneficiary Beneficiary of remaining Ether on contract
1137    */
1138   function voteSuicide(address beneficiary) multisig(sha3(msg.data)) {
1139     selfdestruct(beneficiary);
1140   }
1141 
1142   /**
1143    * @notice Sets frozen to `freeze` for account `target`
1144    *
1145    * @param addr Address to be frozen/unfrozen
1146    * @param freeze Freeze/unfreeze account
1147    */
1148   function freezeAccount(address addr, bool freeze) multisig(sha3(msg.data)) {
1149     frozenAccount[addr] = freeze;
1150     activateAccount(addr);
1151   }
1152 
1153   /**
1154    * @notice Seizes `seizeAmount` of tokens from `address` and transfers it to hotwallet
1155    *
1156    * @param addr Adress to seize tokens from
1157    * @param amount Amount of tokens to seize
1158    */
1159   function seizeTokens(address addr, uint256 amount) multisig(sha3(msg.data)) {
1160     assert(balanceOf[addr] >= amount);
1161     assert(frozenAccount[addr]);
1162     activateAccount(addr);
1163     balanceOf[addr] -= amount;
1164     balanceOf[hotWalletAddress] += amount;
1165   }
1166 
1167   /* ---------------  overseer methods for emergency --------------*/
1168 
1169   /**
1170    * @notice Shuts down all transaction and approval options on the asset contract
1171    */
1172   function shutdownTransactions() onlyOverseer {
1173     allowTransactions = false;
1174     TransactionsShutDown(msg.sender);
1175   }
1176 
1177   /* ---------------  helper methods for siphoning --------------*/
1178 
1179   function extractAccountAllowanceRecordLength(address addr) returns (uint256 len) {
1180     return allowanceIndex[addr].length;
1181   }
1182 
1183   function extractAccountLength() returns (uint256 length) {
1184     return accountIndex.length;
1185   }
1186 
1187 
1188   /* ---------------  private methods --------------*/
1189 
1190   function activateAccount(address addr) internal {
1191     if (!accountActive[addr]) {
1192       accountActive[addr] = true;
1193       accountIndex.push(addr);
1194     }
1195   }
1196 
1197   function activateAllowanceRecord(address from, address to) internal {
1198     if (!allowanceActive[from][to]) {
1199       allowanceActive[from][to] = true;
1200       allowanceIndex[from].push(to);
1201     }
1202   }
1203   function feeFor(address a, address b, uint256 amount) returns (uint256 value) {
1204     if (membershipAddress == address(0x0)) return 0;
1205     return DVIP(membershipAddress).feeFor(a, b, amount);
1206   }
1207 }
1208 
1209 
1210 /**
1211  * @title DCAssetFacade, Facade for the underlying back-end dcasset token contract. Allow to be updated later.
1212  *
1213  * @author P.S.D. Reitsma, peter@decentralizedcapital.com
1214  *
1215  */
1216 contract DCAsset is TokenBase, StateTransferrable, TrustClient, Relay {
1217 
1218    address public backendContract;
1219 
1220    /**
1221     * Constructor
1222     *
1223     *
1224     */
1225    function DCAsset(address _backendContract) {
1226      backendContract = _backendContract;
1227    }
1228 
1229    function standard() constant returns (bytes32 std) {
1230      return DCAssetBackend(backendContract).standard();
1231    }
1232 
1233    function name() constant returns (bytes32 nm) {
1234      return DCAssetBackend(backendContract).name();
1235    }
1236 
1237    function symbol() constant returns (bytes32 sym) {
1238      return DCAssetBackend(backendContract).symbol();
1239    }
1240 
1241    function decimals() constant returns (uint8 precision) {
1242      return DCAssetBackend(backendContract).decimals();
1243    }
1244   
1245    function allowance(address from, address to) constant returns (uint256 res) {
1246      return DCAssetBackend(backendContract).allowance(from, to);
1247    }
1248 
1249 
1250    /* ---------------  multisig admin methods  --------------*/
1251 
1252 
1253    /**
1254     * @notice Sets the backend contract to `_backendContract`. Can only be switched by multisig.
1255     *
1256     * @param _backendContract Address of the underlying token contract.
1257     */
1258    function setBackend(address _backendContract) multisig(sha3(msg.data)) {
1259      backendContract = _backendContract;
1260    }
1261 
1262    /* ---------------  main token methods  --------------*/
1263 
1264    /**
1265     * @notice Returns the balance of `_address`.
1266     *
1267     * @param _address The address of the balance.
1268     */
1269    function balanceOf(address _address) constant returns (uint256 balance) {
1270       return DCAssetBackend(backendContract).balanceOf(_address);
1271    }
1272 
1273    /**
1274     * @notice Returns the total supply of the token
1275     *
1276     */
1277    function totalSupply() constant returns (uint256 balance) {
1278       return DCAssetBackend(backendContract).totalSupply();
1279    }
1280 
1281   /**
1282    * @notice Transfer `_amount` to `_to`.
1283    *
1284    * @param _to Address that will receive.
1285    * @param _amount Amount to be transferred.
1286    */
1287    function transfer(address _to, uint256 _amount) returns (bool success)  {
1288       if (!DCAssetBackend(backendContract).transfer(msg.sender, _to, _amount)) throw;
1289       Transfer(msg.sender, _to, _amount);
1290       return true;
1291    }
1292 
1293   /**
1294    * @notice Approve Approves spender `_spender` to transfer `_amount`.
1295    *
1296    * @param _spender Address that receives the cheque
1297    * @param _amount Amount on the cheque
1298    * @param _extraData Consequential contract to be executed by spender in same transcation.
1299    * @return result of the method call
1300    */
1301    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
1302       if (!DCAssetBackend(backendContract).approveAndCall(msg.sender, _spender, _amount, _extraData)) throw;
1303       Approval(msg.sender, _spender, _amount);
1304       return true;
1305    }
1306 
1307   /**
1308    * @notice Approve Approves spender `_spender` to transfer `_amount`.
1309    *
1310    * @param _spender Address that receives the cheque
1311    * @param _amount Amount on the cheque
1312    * @return result of the method call
1313    */
1314    function approve(address _spender, uint256 _amount) returns (bool success) {
1315       if (!DCAssetBackend(backendContract).approve(msg.sender, _spender, _amount)) throw;
1316       Approval(msg.sender, _spender, _amount);
1317       return true;
1318    }
1319 
1320   /**
1321    * @notice Transfer `_amount` from `_from` to `_to`.
1322    *
1323    * @param _from Origin address
1324    * @param _to Address that will receive
1325    * @param _amount Amount to be transferred.
1326    * @return result of the method call
1327    */
1328   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
1329       if (!DCAssetBackend(backendContract).transferFrom(msg.sender, _from, _to, _amount)) throw;
1330       Transfer(_from, _to, _amount);
1331       return true;
1332   }
1333 
1334   /**
1335    * @notice Returns fee for transferral of `_amount` from `_from` to `_to`.
1336    *
1337    * @param _from Origin address
1338    * @param _to Address that will receive
1339    * @param _amount Amount to be transferred.
1340    * @return height of the fee
1341    */
1342   function feeFor(address _from, address _to, uint256 _amount) returns (uint256 amount) {
1343       return DCAssetBackend(backendContract).feeFor(_from, _to, _amount);
1344   }
1345 
1346   /* ---------------  to be called by backend  --------------*/
1347 
1348   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
1349      assert(msg.sender == backendContract);
1350      TokenRecipient spender = TokenRecipient(_spender);
1351      spender.receiveApproval(_caller, _amount, this, _extraData);
1352      return true;
1353   }
1354 
1355 }