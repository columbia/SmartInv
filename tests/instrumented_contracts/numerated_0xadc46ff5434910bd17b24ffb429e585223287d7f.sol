1 /*
2 
3 DVIP Terms of Service
4 
5 The following Terms of Service specify the agreement between Decentralized Capital Ltd. (DC) and the purchaser of DVIP Memberships (customer/member). By purchasing, using, or possessing the DVIP token you agree to be legally bound by these terms, which shall take effect immediately upon purchase of the membership.
6 
7 
8 1. Rights of DVIP Membership holders: Each membership entitles the customer to ZERO transaction fees on all on-chain transfers of DC Assets, and ½ off fees for purchasing and redeeming DC Assets through Crypto Capital. DVIP also entitles the customer to discounts on select future Decentralized Capital Ltd. services. These discounts only apply to the fees specified on the DC website. DC is not responsible for any fees charged by third parties including, but not limited to, dapps, exchanges, Crypto Capital, and Coinapult.
9 
10 2. DVIP membership rights expire on January 1st, 2020. Upon expiration of membership benefits, each 1/100th of a token is redeemable for an additional $1.50 in fees on eligible DC products. This additional discount expires on January 1st, 2022.
11 
12 3. Customers can purchase more than one membership, but only one membership can be active at a time for any one wallet. Under no circumstances are members eligible for a refund on the DVIP purchase.
13 
14 4. DVIP tokens are not equity in Decentralized Capital ltd. and do not give holders any power over Decentralized Capital ltd. including, but not limited to, shareholder voting, a claim on assets, or input into how Decentralized Capital ltd. is governed and managed.
15 
16 5. Possession of the DVIP token operates as proof of membership, and DVIP tokens can be transferred to any other wallet on Ethereum. If the DVIP token is transferred to a 3rd party, the membership benefits no longer pertain to the original party. In the event of a transfer, membership benefits will apply only AFTER a one week incubation period; any withdrawal initiated prior to the end of this incubation period will be charged the standard transaction fee. DC reserves the right to adjust the duration of the incubation period; the incubation period will never be more than one month. Changes to the DVIP balance will reset the incubation period for any DVIP that is not fully incubated. Active DVIP is not affected by balance changes.
17 
18 6. DVIP membership benefits are only available to individual users. Platforms such as exchanges and dapps can hold DVIP, but the transaction fee discounts specified in section 1 will not apply.
19 
20 7. Membership benefits are executed via the DC smart contract system; the DC membership must be held in the wallet used for DC Asset transactions in order for the discounts to apply. No transaction fees will be waived for members who receive transactions using a wallet that does not hold their DVIP tokens.
21 
22 8. In the event of bankruptcy: DVIP is valid until January 1st, 2020. In the event that Decentralized Capital Ltd. ceases operations, DVIP does not represent any claim on company assets nor does Decentralized Capital Ltd. have any further commitment to holders of DVIP, such as a refund on the purchase of the DVIP.
23 
24 9. Future Sale of DVIP: Total DVIP supply is capped at 2,000, 1,500 of which are available for purchase during this initial sale. Any DVIP not sold in the initial membership sale will be destroyed, further reducing the total supply of DVIP. The remaining 500 memberships will be sold at a later date.
25 
26 10. DVIP Buyback Rights: Decentralized Capital Ltd. reserves the right to repurchase the DVIP from token holders at any time. Repurchase will occur at the average price of all markets where DVIP is listed.
27 
28 11. Entire Agreement. The foregoing Membership Terms & Conditions contain the entire terms and agreements in connection with Member's participation in the DC service and no representations, inducements, promises or agreement, or otherwise, between DC and the Member not included herein, shall be of any force or effect. If any of the foregoing terms or provisions shall be invalid or unenforceable, the remaining terms and provisions hereof shall not be affected.
29 
30 12. This agreement shall be governed by and construed under, and the legal relations among the parties hereto shall be determined in accordance with, the laws of the United Kingdom of Great Britain and Northern Ireland.
31 
32 */
33 
34 contract Assertive {
35   function assert(bool assertion) {
36     if (!assertion) throw;
37   }
38 }
39 
40 contract Owned is Assertive {
41   address public owner;
42   event SetOwner(address indexed previousOwner, address indexed newOwner);
43   function Owned () {
44     owner = msg.sender;
45   }
46   modifier onlyOwner {
47     assert(msg.sender == owner);
48     _
49   }
50   function setOwner(address newOwner) onlyOwner {
51     SetOwner(owner, newOwner);
52     owner = newOwner;
53   }
54 }
55 
56 contract StateTransferrable is Owned {
57   bool internal locked;
58   event Locked(address indexed from);
59   event PropertySet(address indexed from);
60   modifier onlyIfUnlocked {
61     assert(!locked);
62     _
63   }
64   modifier setter {
65     _
66     PropertySet(msg.sender);
67   }
68   modifier onlyOwnerUnlocked {
69     assert(!locked && msg.sender == owner);
70     _
71   }
72   function lock() onlyOwner onlyIfUnlocked {
73     locked = true;
74     Locked(msg.sender);
75   }
76   function isLocked() returns (bool status) {
77     return locked;
78   }
79 }
80 
81 contract TokenRecipient {
82   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
83 }
84 
85 contract Relay {
86   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success);
87 }
88 
89 contract TokenBase is Owned {
90     bytes32 public standard = 'Token 0.1';
91     bytes32 public name;
92     bytes32 public symbol;
93     bool public allowTransactions;
94     uint256 public totalSupply;
95 
96     event Approval(address indexed from, address indexed spender, uint256 amount);
97 
98     mapping (address => uint256) public balanceOf;
99     mapping (address => mapping (address => uint256)) public allowance;
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     function transfer(address _to, uint256 _value) returns (bool success);
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
105     function approve(address _spender, uint256 _value) returns (bool success);
106     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
107 
108     function () {
109         throw;
110     }
111 }
112 
113 contract TrustEvents {
114   event AuthInit(address indexed from);
115   event AuthComplete(address indexed from, address indexed with);
116   event AuthPending(address indexed from);
117   event Unauthorized(address indexed from);
118   event InitCancel(address indexed from);
119   event NothingToCancel(address indexed from);
120   event SetMasterKey(address indexed from);
121   event AuthCancel(address indexed from, address indexed with);
122 }
123 
124 contract Trust is StateTransferrable, TrustEvents {
125 
126   mapping (address => bool) public masterKeys;
127   mapping (address => bytes32) public nameRegistry;
128   address[] public masterKeyIndex;
129   mapping (address => bool) public masterKeyActive;
130   mapping (address => bool) public trustedClients;
131   mapping (uint256 => address) public functionCalls;
132   mapping (address => uint256) public functionCalling;
133 
134   /* ---------------  modifiers  --------------*/
135 
136   modifier multisig (bytes32 hash) {
137     if (!masterKeys[msg.sender]) {
138       Unauthorized(msg.sender);
139     } else if (functionCalling[msg.sender] == 0) {
140       if (functionCalls[uint256(hash)] == 0x0) {
141         functionCalls[uint256(hash)] = msg.sender;
142         functionCalling[msg.sender] = uint256(hash);
143         AuthInit(msg.sender);
144       } else {
145         AuthComplete(functionCalls[uint256(hash)], msg.sender);
146         resetAction(uint256(hash));
147         _
148       }
149     } else {
150       AuthPending(msg.sender);
151     }
152   }
153 
154   /* ---------------  setter methods, only for the unlocked state --------------*/
155 
156   /**
157    * @notice Sets a master key
158    *
159    * @param addr Address
160    */
161   function setMasterKey(address addr) onlyOwnerUnlocked {
162     assert(!masterKeys[addr]);
163     activateMasterKey(addr);
164     masterKeys[addr] = true;
165     SetMasterKey(msg.sender);
166   }
167 
168   /**
169    * @notice Adds a trusted client
170    *
171    * @param addr Address
172    */
173   function setTrustedClient(address addr) onlyOwnerUnlocked setter {
174     trustedClients[addr] = true;
175   }
176 
177   /* ---------------  methods to be called by a Master Key  --------------*/
178 
179 
180 
181   /* ---------------  multisig admin methods  --------------*/
182 
183   /**
184    * @notice remove contract `addr` from the list of trusted contracts
185    *
186    * @param addr Address of client contract to be removed
187    */
188   function untrustClient(address addr) multisig(sha3(msg.data)) {
189     trustedClients[addr] = false;
190   }
191 
192   /**
193    * @notice add contract `addr` to the list of trusted contracts
194    *
195    * @param addr Address of contract to be added
196    */
197   function trustClient(address addr) multisig(sha3(msg.data)) {
198     trustedClients[addr] = true;
199   }
200 
201   /**
202    * @notice remove key `addr` to the list of master keys
203    *
204    * @param addr Address of the masterkey
205    */
206   function voteOutMasterKey(address addr) multisig(sha3(msg.data)) {
207     assert(masterKeys[addr]);
208     masterKeys[addr] = false;
209   }
210 
211   /**
212    * @notice add key `addr` to the list of master keys
213    *
214    * @param addr Address of the masterkey
215    */
216   function voteInMasterKey(address addr) multisig(sha3(msg.data)) {
217     assert(!masterKeys[addr]);
218     activateMasterKey(addr);
219     masterKeys[addr] = true;
220   }
221 
222   /* ---------------  methods to be called by Trusted Client Contracts  --------------*/
223 
224 
225   /**
226    * @notice Cancel outstanding multisig method call from address `from`. Called from trusted clients.
227    *
228    * @param from Address that issued the call that needs to be cancelled
229    */
230   function authCancel(address from) external returns (uint8 status) {
231     if (!masterKeys[from] || !trustedClients[msg.sender]) {
232       Unauthorized(from);
233       return 0;
234     }
235     uint256 call = functionCalling[from];
236     if (call == 0) {
237       NothingToCancel(from);
238       return 1;
239     } else {
240       AuthCancel(from, from);
241       functionCalling[from] = 0;
242       functionCalls[call] = 0x0;
243       return 2;
244     }
245   }
246 
247   /**
248    * @notice Authorize multisig call on a trusted client. Called from trusted clients.
249    *
250    * @param from Address from which call is made.
251    * @param hash of method call
252    */
253   function authCall(address from, bytes32 hash) external returns (uint8 code) {
254     if (!masterKeys[from] || !trustedClients[msg.sender]) {
255       Unauthorized(from);
256       return 0;
257     }
258     if (functionCalling[from] == 0) {
259       if (functionCalls[uint256(hash)] == 0x0) {
260         functionCalls[uint256(hash)] = from;
261         functionCalling[from] = uint256(hash);
262         AuthInit(from);
263         return 1;
264       } else {
265         AuthComplete(functionCalls[uint256(hash)], from);
266         resetAction(uint256(hash));
267         return 2;
268       }
269     } else {
270       AuthPending(from);
271       return 3;
272     }
273   }
274 
275   /* ---------------  methods to be called directly on the contract --------------*/
276 
277   /**
278    * @notice cancel any outstanding multisig call
279    *
280    */
281   function cancel() returns (uint8 code) {
282     if (!masterKeys[msg.sender]) {
283       Unauthorized(msg.sender);
284       return 0;
285     }
286     uint256 call = functionCalling[msg.sender];
287     if (call == 0) {
288       NothingToCancel(msg.sender);
289       return 1;
290     } else {
291       AuthCancel(msg.sender, msg.sender);
292       uint256 hash = functionCalling[msg.sender];
293       functionCalling[msg.sender] = 0x0;
294       functionCalls[hash] = 0;
295       return 2;
296     }
297   }
298 
299   /* ---------------  private methods --------------*/
300 
301   function resetAction(uint256 hash) internal {
302     address addr = functionCalls[hash];
303     functionCalls[hash] = 0x0;
304     functionCalling[addr] = 0;
305   }
306 
307   function activateMasterKey(address addr) internal {
308     if (!masterKeyActive[addr]) {
309       masterKeyActive[addr] = true;
310       masterKeyIndex.push(addr);
311     }
312   }
313 
314   /* ---------------  helper methods for siphoning --------------*/
315 
316   function extractMasterKeyIndexLength() returns (uint256 length) {
317     return masterKeyIndex.length;
318   }
319 
320 }
321 
322 
323 contract TrustClient is StateTransferrable, TrustEvents {
324 
325   address public trustAddress;
326 
327   modifier multisig (bytes32 hash) {
328     assert(trustAddress != address(0x0));
329     address current = Trust(trustAddress).functionCalls(uint256(hash));
330     uint8 code = Trust(trustAddress).authCall(msg.sender, hash);
331     if (code == 0) Unauthorized(msg.sender);
332     else if (code == 1) AuthInit(msg.sender);
333     else if (code == 2) {
334       AuthComplete(current, msg.sender);
335       _
336     }
337     else if (code == 3) {
338       AuthPending(msg.sender);
339     }
340   }
341   
342   function setTrust(address addr) setter onlyOwnerUnlocked {
343     trustAddress = addr;
344   }
345 
346   function cancel() returns (uint8 status) {
347     assert(trustAddress != address(0x0));
348     uint8 code = Trust(trustAddress).authCancel(msg.sender);
349     if (code == 0) Unauthorized(msg.sender);
350     else if (code == 1) NothingToCancel(msg.sender);
351     else if (code == 2) AuthCancel(msg.sender, msg.sender);
352     return code;
353   }
354 
355 }
356 
357 contract DVIPBackend {
358   uint8 public decimals;
359   function assert(bool assertion) {
360     if (!assertion) throw;
361   }
362   bytes32 public standard = 'Token 0.1';
363   bytes32 public name;
364   bytes32 public symbol;
365   bool public allowTransactions;
366   uint256 public totalSupply;
367 
368   event Approval(address indexed from, address indexed spender, uint256 amount);
369   event PropertySet(address indexed from);
370 
371   mapping (address => uint256) public balanceOf;
372   mapping (address => mapping (address => uint256)) public allowance;
373 
374 /*
375   mapping (address => bool) public balanceOfActive;
376   address[] public balanceOfIndex;
377 */
378 
379 /*
380   mapping (address => bool) public allowanceActive;
381   address[] public allowanceIndex;
382 
383   mapping (address => mapping (address => bool)) public allowanceRecordActive;
384   mapping (address => address[]) public allowanceRecordIndex;
385 */
386 
387   event Transfer(address indexed from, address indexed to, uint256 value);
388 
389   uint256 public baseFeeDivisor;
390   uint256 public feeDivisor;
391   uint256 public singleDVIPQty;
392 
393   function () {
394     throw;
395   }
396 
397   bool public locked;
398   address public owner;
399 
400   modifier onlyOwnerUnlocked {
401     assert(msg.sender == owner && !locked);
402     _
403   }
404 
405   modifier onlyOwner {
406     assert(msg.sender == owner);
407     _
408   }
409 
410   function lock() onlyOwnerUnlocked returns (bool success) {
411     locked = true;
412     PropertySet(msg.sender);
413     return true;
414   }
415 
416   function setOwner(address _address) onlyOwner returns (bool success) {
417     owner = _address;
418     PropertySet(msg.sender);
419     return true;
420   }
421 
422   uint256 public expiry;
423   uint8 public feeDecimals;
424 
425   struct Validity {
426     uint256 last;
427     uint256 ts;
428   }
429 
430   mapping (address => Validity) public validAfter;
431   uint256 public mustHoldFor;
432   address public hotwalletAddress;
433   address public frontendAddress;
434   mapping (address => bool) public frozenAccount;
435 /*
436   mapping (address => bool) public frozenAccountActive;
437   address[] public frozenAccountIndex;
438 */
439   mapping (address => uint256) public exportFee;
440 /*
441   mapping (address => bool) public exportFeeActive;
442   address[] public exportFeeIndex;
443 */
444 
445   event FeeSetup(address indexed from, address indexed target, uint256 amount);
446   event Processed(address indexed sender);
447 
448   modifier onlyAsset {
449     if (msg.sender != frontendAddress) throw;
450     _
451   }
452 
453   /**
454    * Constructor.
455    *
456    */
457   function DVIPBackend(address _hotwalletAddress, address _frontendAddress) {
458     owner = msg.sender;
459     hotwalletAddress = _hotwalletAddress;
460     frontendAddress = _frontendAddress;
461     allowTransactions = true;
462     totalSupply = 0;
463     name = "DVIP";
464     symbol = "DVIP";
465     feeDecimals = 6;
466     decimals = 1;
467     expiry = 1514764800; //1 jan 2018
468     mustHoldFor = 604800;
469     precalculate();
470   }
471 
472   function setHotwallet(address _address) onlyOwnerUnlocked {
473     hotwalletAddress = _address;
474     PropertySet(msg.sender);
475   }
476 
477   function setFrontend(address _address) onlyOwnerUnlocked {
478     frontendAddress = _address;
479     PropertySet(msg.sender);
480   } 
481 
482   /**
483    * @notice Transfer `_amount` from `msg.sender.address()` to `_to`.
484    *
485    * @param _to Address that will receive.
486    * @param _amount Amount to be transferred.
487    */
488   function transfer(address caller, address _to, uint256 _amount) onlyAsset returns (bool success) {
489     assert(allowTransactions);
490     assert(balanceOf[caller] >= _amount);
491     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
492     assert(!frozenAccount[caller]);
493     assert(!frozenAccount[_to]);
494     balanceOf[caller] -= _amount;
495     // activateBalance(caller);
496     // activateBalance(_to);
497     uint256 preBalance = balanceOf[_to];
498     balanceOf[_to] += _amount;
499     bool alreadyMax = preBalance >= singleDVIPQty;
500     if (!alreadyMax) {
501       if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;
502       validAfter[_to].ts = now;
503     }
504     if (validAfter[caller].last > balanceOf[caller]) validAfter[caller].last = balanceOf[caller];
505     Transfer(caller, _to, _amount);
506     return true;
507   }
508 
509   /**
510    * @notice Transfer `_amount` from `_from` to `_to`.
511    *
512    * @param _from Origin address
513    * @param _to Address that will receive
514    * @param _amount Amount to be transferred.
515    * @return result of the method call
516    */
517   function transferFrom(address caller, address _from, address _to, uint256 _amount) onlyAsset returns (bool success) {
518     assert(allowTransactions);
519     assert(balanceOf[_from] >= _amount);
520     assert(balanceOf[_to] + _amount >= balanceOf[_to]);
521     assert(_amount <= allowance[_from][caller]);
522     assert(!frozenAccount[caller]);
523     assert(!frozenAccount[_from]);
524     assert(!frozenAccount[_to]);
525     balanceOf[_from] -= _amount;
526     uint256 preBalance = balanceOf[_to];
527     balanceOf[_to] += _amount;
528     // activateBalance(_from);
529     // activateBalance(_to);
530     allowance[_from][caller] -= _amount;
531     bool alreadyMax = preBalance >= singleDVIPQty;
532     if (!alreadyMax) {
533       if (now >= validAfter[_to].ts + mustHoldFor) validAfter[_to].last = preBalance;
534       validAfter[_to].ts = now;
535     }
536     if (validAfter[_from].last > balanceOf[_from]) validAfter[_from].last = balanceOf[_from];
537     Transfer(_from, _to, _amount);
538     return true;
539   }
540 
541   /**
542    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
543    *
544    * @param _spender Address that receives the cheque
545    * @param _amount Amount on the cheque
546    * @param _extraData Consequential contract to be executed by spender in same transcation.
547    * @return result of the method call
548    */
549   function approveAndCall(address caller, address _spender, uint256 _amount, bytes _extraData) onlyAsset returns (bool success) {
550     assert(allowTransactions);
551     allowance[caller][_spender] = _amount;
552     // activateAllowance(caller, _spender);
553     Relay(frontendAddress).relayReceiveApproval(caller, _spender, _amount, _extraData);
554     Approval(caller, _spender, _amount);
555     return true;
556   }
557 
558   /**
559    * @notice Approve spender `_spender` to transfer `_amount` from `msg.sender.address()`
560    *
561    * @param _spender Address that receives the cheque
562    * @param _amount Amount on the cheque
563    * @return result of the method call
564    */
565   function approve(address caller, address _spender, uint256 _amount) onlyAsset returns (bool success) {
566     assert(allowTransactions);
567     allowance[caller][_spender] = _amount;
568     // activateAllowance(caller, _spender);
569     Approval(caller, _spender, _amount);
570     return true;
571   }
572 
573   /* ---------------  multisig admin methods  --------------*/
574 
575 
576 
577   /**
578    * @notice Sets the expiry time in milliseconds since 1970.
579    *
580    * @param ts milliseconds since 1970.
581    *
582    */
583   function setExpiry(uint256 ts) onlyOwner {
584     expiry = ts;
585     Processed(msg.sender);
586   }
587 
588   /**
589    * @notice Mints `mintedAmount` new tokens to the hotwallet `hotWalletAddress`.
590    *
591    * @param mintedAmount Amount of new tokens to be minted.
592    */
593   function mint(uint256 mintedAmount) onlyOwner {
594     balanceOf[hotwalletAddress] += mintedAmount;
595    // activateBalance(hotwalletAddress);
596     totalSupply += mintedAmount;
597     Processed(msg.sender);
598   }
599 
600   function freezeAccount(address target, bool frozen) onlyOwner {
601     frozenAccount[target] = frozen;
602     // activateFrozenAccount(target);
603     Processed(msg.sender);
604   }
605 
606   function seizeTokens(address target, uint256 amount) onlyOwner {
607     assert(balanceOf[target] >= amount);
608     assert(frozenAccount[target]);
609     balanceOf[target] -= amount;
610     balanceOf[hotwalletAddress] += amount;
611     Transfer(target, hotwalletAddress, amount);
612   }
613 
614   function destroyTokens(uint256 amt) onlyOwner {
615     assert(balanceOf[hotwalletAddress] >= amt);
616     balanceOf[hotwalletAddress] -= amt;
617     Processed(msg.sender);
618   }
619 
620   /**
621    * @notice Sets an export fee of `fee` on address `addr`
622    *
623    * @param addr Address for which the fee is valid
624    * @param addr fee Fee
625    *
626    */
627   function setExportFee(address addr, uint256 fee) onlyOwner {
628     exportFee[addr] = fee;
629    // activateExportFee(addr);
630     Processed(msg.sender);
631   }
632 
633   function setHoldingPeriod(uint256 ts) onlyOwner {
634     mustHoldFor = ts;
635     Processed(msg.sender);
636   }
637 
638   function setAllowTransactions(bool allow) onlyOwner {
639     allowTransactions = allow;
640     Processed(msg.sender);
641   }
642 
643   /* --------------- fee calculation method ---------------- */
644 
645   /**
646    * @notice 'Returns the fee for a transfer from `from` to `to` on an amount `amount`.
647    *
648    * Fee's consist of a possible
649    *    - import fee on transfers to an address
650    *    - export fee on transfers from an address
651    * DVIP ownership on an address
652    *    - reduces fee on a transfer from this address to an import fee-ed address
653    *    - reduces the fee on a transfer to this address from an export fee-ed address
654    * DVIP discount does not work for addresses that have an import fee or export fee set up against them.
655    *
656    * DVIP discount goes up to 100%
657    *
658    * @param from From address
659    * @param to To address
660    * @param amount Amount for which fee needs to be calculated.
661    *
662    */
663   function feeFor(address from, address to, uint256 amount) constant external returns (uint256 value) {
664     uint256 fee = exportFee[from];
665     if (fee == 0) return 0;
666     if (now >= expiry) return amount*fee / baseFeeDivisor;
667     uint256 amountHeld;
668     if (balanceOf[to] != 0) {
669       if (validAfter[to].ts + mustHoldFor < now) amountHeld = balanceOf[to];
670       else amountHeld = validAfter[to].last;
671       if (amountHeld >= singleDVIPQty) return 0;
672       return amount*fee*(singleDVIPQty - amountHeld) / feeDivisor;
673     } else return amount*fee / baseFeeDivisor;
674   }
675   function precalculate() internal returns (bool success) {
676     baseFeeDivisor = pow10(1, feeDecimals);
677     feeDivisor = pow10(1, feeDecimals + decimals);
678     singleDVIPQty = pow10(1, decimals);
679   }
680   function div10(uint256 a, uint8 b) internal returns (uint256 result) {
681     for (uint8 i = 0; i < b; i++) {
682       a /= 10;
683     }
684     return a;
685   }
686   function pow10(uint256 a, uint8 b) internal returns (uint256 result) {
687     for (uint8 i = 0; i < b; i++) {
688       a *= 10;
689     }
690     return a;
691   }
692   /*
693   function activateBalance(address address_) internal {
694     if (!balanceOfActive[address_]) {
695       balanceOfActive[address_] = true;
696       balanceOfIndex.push(address_);
697     }
698   }
699   function activateFrozenAccount(address address_) internal {
700     if (!frozenAccountActive[address_]) {
701       frozenAccountActive[address_] = true;
702       frozenAccountIndex.push(address_);
703     }
704   }
705   function activateAllowance(address from, address to) internal {
706     if (!allowanceActive[from]) {
707       allowanceActive[from] = true;
708       allowanceIndex.push(from);
709     }
710     if (!allowanceRecordActive[from][to]) {
711       allowanceRecordActive[from][to] = true;
712       allowanceRecordIndex[from].push(to);
713     }
714   }
715   function activateExportFee(address address_) internal {
716     if (!exportFeeActive[address_]) {
717       exportFeeActive[address_] = true;
718       exportFeeIndex.push(address_);
719     }
720   }
721   function extractBalanceOfLength() constant returns (uint256 length) {
722     return balanceOfIndex.length;
723   }
724   function extractAllowanceLength() constant returns (uint256 length) {
725     return allowanceIndex.length;
726   }
727   function extractAllowanceRecordLength(address from) constant returns (uint256 length) {
728     return allowanceRecordIndex[from].length;
729   }
730   function extractFrozenAccountLength() constant returns (uint256 length) {
731     return frozenAccountIndex.length;
732   }
733   function extractFeeLength() constant returns (uint256 length) {
734     return exportFeeIndex.length;
735   }
736   */
737 }
738 
739 /**
740  * @title DVIP
741  *
742  * @author Raymond Pulver IV
743  *
744  */
745 contract DVIP is TokenBase, StateTransferrable, TrustClient, Relay {
746 
747    address public backendContract;
748 
749    /**
750     * Constructor
751     *
752     *
753     */
754    function DVIP(address _backendContract) {
755      backendContract = _backendContract;
756    }
757 
758    function standard() constant returns (bytes32 std) {
759      return DVIPBackend(backendContract).standard();
760    }
761 
762    function name() constant returns (bytes32 nm) {
763      return DVIPBackend(backendContract).name();
764    }
765 
766    function symbol() constant returns (bytes32 sym) {
767      return DVIPBackend(backendContract).symbol();
768    }
769 
770    function decimals() constant returns (uint8 precision) {
771      return DVIPBackend(backendContract).decimals();
772    }
773   
774    function allowance(address from, address to) constant returns (uint256 res) {
775      return DVIPBackend(backendContract).allowance(from, to);
776    }
777 
778 
779    /* ---------------  multisig admin methods  --------------*/
780 
781 
782    /**
783     * @notice Sets the backend contract to `_backendContract`. Can only be switched by multisig.
784     *
785     * @param _backendContract Address of the underlying token contract.
786     */
787    function setBackend(address _backendContract) multisig(sha3(msg.data)) {
788      backendContract = _backendContract;
789    }
790    function setBackendOwner(address _backendContract) onlyOwnerUnlocked {
791      backendContract = _backendContract;
792    }
793 
794    /* ---------------  main token methods  --------------*/
795 
796    /**
797     * @notice Returns the balance of `_address`.
798     *
799     * @param _address The address of the balance.
800     */
801    function balanceOf(address _address) constant returns (uint256 balance) {
802       return DVIPBackend(backendContract).balanceOf(_address);
803    }
804 
805    /**
806     * @notice Returns the total supply of the token
807     *
808     */
809    function totalSupply() constant returns (uint256 balance) {
810       return DVIPBackend(backendContract).totalSupply();
811    }
812 
813   /**
814    * @notice Transfer `_amount` to `_to`.
815    *
816    * @param _to Address that will receive.
817    * @param _amount Amount to be transferred.
818    */
819    function transfer(address _to, uint256 _amount) returns (bool success)  {
820       if (!DVIPBackend(backendContract).transfer(msg.sender, _to, _amount)) throw;
821       Transfer(msg.sender, _to, _amount);
822       return true;
823    }
824 
825   /**
826    * @notice Approve Approves spender `_spender` to transfer `_amount`.
827    *
828    * @param _spender Address that receives the cheque
829    * @param _amount Amount on the cheque
830    * @param _extraData Consequential contract to be executed by spender in same transcation.
831    * @return result of the method call
832    */
833    function approveAndCall(address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
834       if (!DVIPBackend(backendContract).approveAndCall(msg.sender, _spender, _amount, _extraData)) throw;
835       Approval(msg.sender, _spender, _amount);
836       return true;
837    }
838 
839   /**
840    * @notice Approve Approves spender `_spender` to transfer `_amount`.
841    *
842    * @param _spender Address that receives the cheque
843    * @param _amount Amount on the cheque
844    * @return result of the method call
845    */
846    function approve(address _spender, uint256 _amount) returns (bool success) {
847       if (!DVIPBackend(backendContract).approve(msg.sender, _spender, _amount)) throw;
848       Approval(msg.sender, _spender, _amount);
849       return true;
850    }
851 
852   /**
853    * @notice Transfer `_amount` from `_from` to `_to`.
854    *
855    * @param _from Origin address
856    * @param _to Address that will receive
857    * @param _amount Amount to be transferred.
858    * @return result of the method call
859    */
860   function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
861       if (!DVIPBackend(backendContract).transferFrom(msg.sender, _from, _to, _amount)) throw;
862       Transfer(_from, _to, _amount);
863       return true;
864   }
865 
866   /**
867    * @notice Returns fee for transferral of `_amount` from `_from` to `_to`.
868    *
869    * @param _from Origin address
870    * @param _to Address that will receive
871    * @param _amount Amount to be transferred.
872    * @return height of the fee
873    */
874   function feeFor(address _from, address _to, uint256 _amount) constant returns (uint256 amount) {
875       return DVIPBackend(backendContract).feeFor(_from, _to, _amount);
876   }
877 
878   /* ---------------  to be called by backend  --------------*/
879 
880   function relayReceiveApproval(address _caller, address _spender, uint256 _amount, bytes _extraData) returns (bool success) {
881      assert(msg.sender == backendContract);
882      TokenRecipient spender = TokenRecipient(_spender);
883      spender.receiveApproval(_caller, _amount, this, _extraData);
884      return true;
885   }
886 
887 }