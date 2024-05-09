1 contract ERC20TokenInterface {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}   
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 contract XaurumProxyERC20 is ERC20TokenInterface {
39 
40     bool public xaurumProxyWorking;
41 
42     XaurumToken xaurumTokenReference; 
43 
44     address proxyCurrator;
45     address owner;
46     address dev;
47 
48     /* Public variables of the token */
49     string public standard = 'XaurumERCProxy';
50     string public name = 'Xaurum';
51     string public symbol = 'XAUR';
52     uint8 public decimals = 8;
53 
54 
55     modifier isWorking(){
56         if (xaurumProxyWorking && !xaurumTokenReference.lockdown()){
57             _
58         }
59     }
60 
61     function XaurumProxyERC20(){
62         dev = msg.sender;
63         xaurumProxyWorking = true;
64     }
65 
66     function setTokenReference(address _xaurumTokenAress) returns (bool){
67         if (msg.sender == proxyCurrator){
68             xaurumTokenReference = XaurumToken(_xaurumTokenAress);
69             return true;
70         }
71         return false;
72     }
73 
74     function EnableDisableTokenProxy() returns (bool){
75         if (msg.sender == proxyCurrator){        
76             xaurumProxyWorking = !xaurumProxyWorking;
77             return true;
78         }
79         return false;
80     }
81 
82     function setProxyCurrator(address _newCurratorAdress) returns (bool){
83         if (msg.sender == owner || msg.sender == dev){        
84             proxyCurrator = _newCurratorAdress;
85             return true;
86         }
87         return false;
88     }
89 
90     function setOwner(address _newOwnerAdress) returns (bool){
91         if ( msg.sender == dev ){        
92             owner = _newOwnerAdress;
93             return true;
94         }
95         return false;
96     }
97 
98     function totalSupply() constant returns (uint256 supply) {
99         return xaurumTokenReference.totalSupply();
100     }
101 
102     function balanceOf(address _owner) constant returns (uint256 balance) {
103         return xaurumTokenReference.balanceOf(_owner);
104     }
105 
106     function transfer(address _to, uint256 _value) isWorking returns (bool success) {
107         bool answerStatus;
108         address sentFrom;
109         address sentTo;
110         uint256 sentToAmount;
111         address burningAddress;
112         uint256 burningAmount;
113 
114         (answerStatus, sentFrom, sentTo, sentToAmount, burningAddress, burningAmount) = xaurumTokenReference.transferViaProxy(msg.sender, _to, _value);
115         if(answerStatus){
116             Transfer(sentFrom, sentTo, sentToAmount);
117             Transfer(sentFrom, burningAddress, burningAmount);
118             return true;
119         }
120         return false;
121     }
122 
123     function transferFrom(address _from, address _to, uint256 _value) isWorking returns (bool success) {
124         bool answerStatus;
125         address sentFrom;
126         address sentTo;
127         uint256 sentToAmount;
128         address burningAddress;
129         uint256 burningAmount;
130 
131         (answerStatus, sentFrom, sentTo, sentToAmount, burningAddress, burningAmount) = xaurumTokenReference.transferFromViaProxy(msg.sender, _from, _to, _value);
132         if(answerStatus){
133             Transfer(sentFrom, sentTo, sentToAmount);
134             Transfer(sentFrom, burningAddress, burningAmount);
135             return true;
136         }
137         return false;
138     }
139 
140     function approve(address _spender, uint256 _value) isWorking returns (bool success) {
141         if (xaurumTokenReference.approveFromProxy(msg.sender, _spender, _value)){
142             Approval(msg.sender, _spender, _value);
143             return true;
144         }
145         return false;
146     }
147 
148     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149         return xaurumTokenReference.allowanceFromProxy(msg.sender, _owner, _spender);
150     } 
151 }
152 
153 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
154 
155 contract XaurumToken {
156     
157     /* Public variables of the token */
158     string public standard = 'Xaurum v1.0';
159     string public name = 'Xaurum';
160     string public symbol = 'XAUR';
161     uint8 public decimals = 8;
162 
163     uint256 public totalSupply = 0;
164     uint256 public totalGoldSupply = 0;
165     bool public lockdown = false;
166     uint256 numberOfCoinages;
167 
168     /* Private variabiles for the token */
169     mapping (address => uint256) balances;
170     mapping (address => mapping (address => uint256)) allowed;
171     mapping (address => uint) lockedAccounts;
172 
173     /* Events */
174     event Transfer(address indexed from, address indexed to, uint256 value);
175     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
176     event Burn(address from, uint256 value, BurningType burningType);
177     event Melt(uint256 xaurAmount, uint256 goldAmount);
178     event Coinage(uint256 coinageId, uint256 usdAmount, uint256 xaurAmount, uint256 goldAmount, uint256 totalGoldSupply, uint256 totalSupply);
179 
180     /*enums*/
181     enum BurningType { TxtFee, AllyDonation, ServiceFee }
182 
183    /* Contracts */
184     XaurumMeltingContract public meltingContract;
185     function setMeltingContract(address _meltingContractAddress){
186         if (msg.sender == owner || msg.sender == dev){
187             meltingContract = XaurumMeltingContract(_meltingContractAddress);
188         }
189     }
190 
191     XaurumDataContract public dataContract;
192     function setDataContract(address _dataContractAddress){
193         if (msg.sender == owner || msg.sender == dev){
194             dataContract = XaurumDataContract(_dataContractAddress);
195         }
196     }
197 
198     XaurumCoinageContract public coinageContract;
199     function setCoinageContract(address _coinageContractAddress){
200         if (msg.sender == owner || msg.sender == dev){
201             coinageContract = XaurumCoinageContract(_coinageContractAddress);
202         }
203     }
204 
205     XaurmProxyContract public proxyContract;
206     function setProxyContract(address _proxyContractAddress){
207         if (msg.sender == owner || msg.sender == dev){
208             proxyContract = XaurmProxyContract(_proxyContractAddress);
209         }
210     }
211 
212     XaurumAlliesContract public alliesContract;
213     function setAlliesContract(address _alliesContractAddress){
214         if (msg.sender == owner || msg.sender == dev){
215             alliesContract = XaurumAlliesContract(_alliesContractAddress);
216         }
217     }
218     
219     
220     
221 
222     /* owner */
223     address public owner;
224     function setOwner(address _newOwnerAdress) returns (bool){
225         if ( msg.sender == dev ){        
226             owner = _newOwnerAdress;
227             return true;
228         }
229         return false;
230     }
231 
232     address public dev;
233 
234     /* Xaur for gas */
235     address xaurForGasCurrator;
236     function setXauForGasCurrator(address _curratorAddress){
237         if (msg.sender == owner || msg.sender == dev){
238             xaurForGasCurrator = _curratorAddress;
239         }
240     }
241 
242     /* Burrning */
243     address public burningAdress;
244 
245     /* Constructor */
246     function XaurumToken(address _burningAddress) { 
247         burningAdress = _burningAddress;
248         lockdown = false;
249         dev = msg.sender;
250        
251         
252         // initial
253          numberOfCoinages += 1;
254          balances[0x097B7b672fe0dc3eF61f53B954B3DCC86382e7B9] += 5999319593600000;
255          totalSupply += 5999319593600000;
256          totalGoldSupply += 1696620000000;
257          Coinage(numberOfCoinages, 0, 5999319593600000, 1696620000000, totalGoldSupply, totalSupply);      
258 		
259 
260         // Mint 1
261          numberOfCoinages += 1;
262          balances[0x097B7b672fe0dc3eF61f53B954B3DCC86382e7B9] += 1588947591000000;
263          totalSupply += 1588947591000000;
264          totalGoldSupply += 1106042126000;
265          Coinage(numberOfCoinages, 60611110000000, 1588947591000000, 1106042126000, totalGoldSupply, totalSupply);
266         		
267 		
268         // Mint 2
269          numberOfCoinages += 1;
270          balances[0x097B7b672fe0dc3eF61f53B954B3DCC86382e7B9] += 151127191000000;
271          totalSupply += 151127191000000;
272          totalGoldSupply += 110134338200;
273          Coinage(numberOfCoinages, 6035361000000, 151127191000000, 110134338200, totalGoldSupply, totalSupply);
274         
275 		
276 		   // Mint 3
277          numberOfCoinages += 1;
278          balances[0x097B7b672fe0dc3eF61f53B954B3DCC86382e7B9] += 63789854418800;
279          totalSupply += 63789854418800;
280          totalGoldSupply +=  46701000000;
281          Coinage(numberOfCoinages, 2559215000000, 63789854418800, 46701000000, totalGoldSupply, totalSupply);
282         
283 
284 		   // Mint 4
285          numberOfCoinages += 1;
286          balances[0x097B7b672fe0dc3eF61f53B954B3DCC86382e7B9] +=  393015011191000;
287          totalSupply += 393015011191000;
288          totalGoldSupply +=  290692000000;
289          Coinage(numberOfCoinages, 15929931000000, 393015011191000, 290692000000, totalGoldSupply, totalSupply);
290         
291 
292 		   // Mint 5
293          numberOfCoinages += 1;
294          balances[0x097B7b672fe0dc3eF61f53B954B3DCC86382e7B9] +=  49394793870000;
295          totalSupply += 49394793870000;
296          totalGoldSupply +=  36891368614;
297          Coinage(numberOfCoinages, 2021647000000, 49394793870000, 36891368614, totalGoldSupply, totalSupply);
298     }
299     
300     function freezeCoin(){
301         if (msg.sender == owner || msg.sender == dev){
302             lockdown = !lockdown;
303         }
304     }
305 
306     /* Get balance of the account */
307     function balanceOf(address _owner) constant returns (uint256 balance) {
308         return balances[_owner];
309     }
310 
311     /* Send coins */
312     function transfer(address _to, uint256 _amount) returns (bool status) {
313         uint256 goldFee = dataContract.goldFee();
314 
315         if (balances[msg.sender] >= _amount &&                                  // Check if the sender has enough
316             balances[_to] + _amount > balances[_to] &&                          // Check for overflows
317             _amount > goldFee &&                                                // Check if there is something left after burning fee
318             !lockdown &&                                                        // Check if coin is on lockdown
319             lockedAccounts[msg.sender] <= block.number) {                       // Check if the account is locked
320             balances[msg.sender] -= _amount;                                    // Subtract from the sender minus the fee
321             balances[_to] += (_amount - goldFee );                              // Add the same to the recipient
322             Transfer(msg.sender, _to, (_amount - goldFee ));                    // Notify anyone listening that this transfer took place
323             doBurn(msg.sender, goldFee, BurningType.TxtFee);                    // Notify anyone listening that this burn took place
324             return true;
325         } else {
326             return false;
327         }
328     }
329     
330     /* A contract attempts to get the coins and sends them*/
331     function transferFrom(address _from, address _to, uint256 _amount) returns (bool status) {
332         uint256 goldFee = dataContract.goldFee();
333 
334         if (balances[_from] >= _amount &&                                  // Check if the sender has enough
335             balances[_to] + _amount > balances[_to] &&                          // Check for overflows
336             _amount > goldFee &&                                                // Check if there is something left after burning fee
337             !lockdown &&                                                        // Check if coin is on lockdown
338             lockedAccounts[_from] <= block.number) {                       // Check if the account is locked
339             if (_amount > allowed[_from][msg.sender]){                          // Check allowance
340                 return false;
341             }
342             balances[_from] -= _amount;                                    // Subtract from the sender minus the fee
343             balances[_to] += (_amount - goldFee);                               // Add the same to the recipient
344             Transfer(_from, _to, (_amount - goldFee));                     // Notify anyone listening that this transfer took place
345             doBurn(_from, goldFee, BurningType.TxtFee);                    
346             allowed[_from][msg.sender] -= _amount;                              // Update allowance
347             return true;
348         } else {
349             return false;
350         }
351     }
352     
353     /* Allow another contract to spend some tokens in your behalf */
354     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
355         returns (bool success) {
356         allowed[msg.sender][_spender] = _value;
357         tokenRecipient spender = tokenRecipient(_spender);
358         spender.receiveApproval(msg.sender, _value, this, _extraData);
359         return true;
360     }
361 
362      function approve(address _spender, uint256 _value) returns (bool success) {
363         allowed[msg.sender][_spender] = _value;
364         Approval(msg.sender, _spender, _value);
365         return true;
366     }
367 
368     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
369       return allowed[_owner][_spender];
370     }
371 
372     /* Send coins via proxy */
373     function transferViaProxy(address _source, address _to, uint256 _amount) returns (bool status, address sendFrom, address sentTo, uint256 sentToAmount, address burnAddress, uint256 burnAmount){
374         if (!proxyContract.isProxyLegit(msg.sender)){                                        // Check if proxy is legit
375             return (false, 0, 0, 0, 0, 0);
376         }
377 
378         uint256 goldFee = dataContract.goldFee();
379 
380         if (balances[_source] >= _amount &&                                     // Check if the sender has enough
381             balances[_to] + _amount > balances[_to] &&                          // Check for overflows
382             _amount > goldFee &&                                                // Check if there is something left after burning fee
383             !lockdown &&                                                        // Check if coin is on lockdown
384             lockedAccounts[_source] <= block.number) {                          // Check if the account is locked
385             
386             balances[_source] -= _amount;                                       // Subtract from the sender minus the fee
387             balances[_to] += (_amount - goldFee );                              // Add the same to the recipient
388             Transfer(_source, _to, ( _amount - goldFee ));                    // Notify anyone listening that this transfer took place
389             doBurn(_source, goldFee, BurningType.TxtFee);                         // Notify anyone listening that this burn took place
390         
391             return (true, _source, _to, (_amount - goldFee), burningAdress, goldFee);
392         } else {
393             return (false, 0, 0, 0, 0, 0);
394         }
395     }
396     
397     /* a contract attempts to get the coins and sends them via proxy */
398     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (bool status, address sendFrom, address sentTo, uint256 sentToAmount, address burnAddress, uint256 burnAmount) {
399         if (!proxyContract.isProxyLegit(msg.sender)){                                            // Check if proxy is legit
400             return (false, 0, 0, 0, 0, 0);
401         }
402 
403         uint256 goldFee = dataContract.goldFee();
404 
405         if (balances[_from] >= _amount &&                                       // Check if the sender has enough
406             balances[_to] + _amount > balances[_to] &&                          // Check for overflows
407             _amount > goldFee &&                                                // Check if there is something left after burning fee
408             !lockdown &&                                                        // Check if coin is on lockdown
409             lockedAccounts[_from] <= block.number) {                            // Check if the account is locked
410 
411             if (_amount > allowed[_from][_source]){                             // Check allowance
412                 return (false, 0, 0, 0, 0, 0); 
413             }               
414 
415             balances[_from] -= _amount;                                         // Subtract from the sender minus the fee
416             balances[_to] += ( _amount - goldFee );                             // Add the same to the recipient
417             Transfer(_from, _to, ( _amount - goldFee ));                        // Notify anyone listening that this transfer took place
418             doBurn(_from, goldFee, BurningType.TxtFee);
419             allowed[_from][_source] -= _amount;                                 // Update allowance
420             return (true, _from, _to, (_amount - goldFee), burningAdress, goldFee);
421         } else {
422             return (false, 0, 0, 0, 0, 0);
423         }
424     }
425     
426      function approveFromProxy(address _source, address _spender, uint256 _value) returns (bool success) {
427         if (!proxyContract.isProxyLegit(msg.sender)){                                        // Check if proxy is legit
428             return false;
429         }
430         allowed[_source][_spender] = _value;
431         Approval(_source, _spender, _value);
432         return true;
433     }
434 
435     function allowanceFromProxy(address _source, address _owner, address _spender) constant returns (uint256 remaining) {
436       return allowed[_owner][_spender];
437     }
438     
439     /* -----------------------------------------------------------------------*/
440     
441     /* Lock account for X amount of blocks */
442     function lockAccount(uint _block) returns (bool answer){
443         if (lockedAccounts[msg.sender] < block.number + _block){
444             lockedAccounts[msg.sender] = block.number + _block;
445             return true;
446         }
447         return false;
448     }
449 
450     function isAccountLocked(address _accountAddress) returns (bool){
451         if (lockedAccounts[_accountAddress] > block.number){
452             return true;
453         }
454         return false;
455     }
456     
457     ///
458     /// Xaur for gas region
459     ///
460 
461     /* user get small amout of wei for a small amout of Xaur */
462     function getGasForXau(address _to) returns (bool sucess){
463         uint256 xaurForGasLimit = dataContract.xaurForGasLimit();
464         uint256 weiForXau = dataContract.weiForXau();
465 
466         if (balances[msg.sender] > xaurForGasLimit && 
467             balances[xaurForGasCurrator] < balances[xaurForGasCurrator]  + xaurForGasLimit &&
468             this.balance > dataContract.weiForXau()) {
469             if (_to.send(dataContract.weiForXau())){
470                 balances[msg.sender] -= xaurForGasLimit;
471                 balances[xaurForGasCurrator] += xaurForGasLimit;
472                 return true;
473             }
474         } 
475         return false;
476     }
477     
478     /* Currator fills eth through this function */
479     function fillGas(){
480         if (msg.sender != xaurForGasCurrator) { 
481             throw; 
482         }
483     }
484 
485     ///
486     /// Melting region
487     ///
488 
489     function doMelt(uint256 _xaurAmount, uint256 _goldAmount) returns (bool){
490         if (msg.sender == address(meltingContract)){
491             totalSupply -= _xaurAmount;
492             totalGoldSupply -= _goldAmount;
493             Melt(_xaurAmount, _goldAmount);
494             return true;
495         }
496         return false;
497     }
498     
499     ///
500     /// Proxy region
501     ///
502 
503     
504 
505     ///
506     /// Coinage region
507     ///
508     function doCoinage(address[] _coinageAddresses, uint256[] _coinageAmounts, uint256 _usdAmount, uint256 _xaurCoined, uint256 _goldBought) returns (bool){
509         if (msg.sender == address(coinageContract) && 
510             _coinageAddresses.length == _coinageAmounts.length){
511             
512             totalSupply += _xaurCoined;
513             totalGoldSupply += _goldBought;
514             numberOfCoinages += 1;
515             Coinage(numberOfCoinages, _usdAmount, _xaurCoined, _goldBought, totalGoldSupply, totalSupply);
516             for (uint256 cnt = 0; cnt < _coinageAddresses.length; cnt++){
517                 balances[_coinageAddresses[cnt]] += _coinageAmounts[cnt]; 
518             }
519             return true;
520         }
521         return false;
522     }
523 
524     ///
525     /// Burining region
526     ///
527     function doBurn(address _from, uint256 _amountToBurn, BurningType _burningType) internal {
528         balances[burningAdress] += _amountToBurn;                              // Burn the fee
529         totalSupply -= _amountToBurn;                                          // Edit total supply
530         Burn(_from, _amountToBurn, _burningType);                              // Notify anyone listening that this burn took place
531     }
532 
533     function doBurnFromContract(address _from, uint256 _amount) returns (bool){
534         if (msg.sender == address(alliesContract)){
535             balances[_from] -= _amount;
536             doBurn(_from, _amount, BurningType.AllyDonation);
537             return true;
538         }
539         else if(msg.sender == address(coinageContract)){
540             balances[_from] -= _amount;
541             doBurn(_from, _amount, BurningType.ServiceFee);
542             return true;
543         }
544         else{
545             return false;
546         }
547 
548     }
549 
550     /* This unnamed function is called whenever someone tries to send ether to it */
551     function () {
552         throw;     // Prevents accidental sending of ether
553     }
554 }
555 
556 contract XaurumMeltingContract {}
557 
558 contract XaurumAlliesContract {}
559 
560 contract XaurumCoinageContract {}
561 
562 contract XaurmProxyContract{
563 
564     address public owner;
565     address public curator;
566     address public dev;
567 
568     function XaurmProxyContract(){
569         dev = msg.sender;
570     }
571 
572     function setProxyCurrator(address _newCurratorAdress) returns (bool){
573         if (msg.sender == owner || msg.sender == dev){        
574             curator = _newCurratorAdress;
575             return true;
576         }
577         return false;
578     }
579 
580     function setOwner(address _newOwnerAdress) returns (bool){
581         if ( msg.sender == dev ){        
582             owner = _newOwnerAdress;
583             return true;
584         }
585         return false;
586     }
587 
588     /* Proxy Contract */
589     
590     address[] approvedProxys; 
591     mapping (address => bool) proxyList;
592     
593     /* Adds new proxy to proxy lists and grants him the permission to use transferViaProxy */
594     function addNewProxy(address _proxyAdress){
595         if(msg.sender == curator){
596             proxyList[_proxyAdress] = true;
597             approvedProxys.push(_proxyAdress);
598         }
599     }
600 
601     function isProxyLegit(address _proxyAddress) returns (bool){
602         return proxyList[_proxyAddress];
603     }
604     
605     function getApprovedProxys() returns (address[] proxys){
606         return approvedProxys;
607     }
608 
609     function () {
610         throw;
611     }
612 }
613 
614 contract XaurumDataContract {
615 
616     /* Minting data */
617     uint256 public xauToEur;
618     uint256 public goldToEur;
619     uint256 public mintingDataUpdatedAtBlock;
620 
621     /* Gas for xaur data */
622     uint256 public xaurForGasLimit;
623     uint256 public weiForXau;
624     uint256 public gasForXaurDataUpdateAtBlock;
625 
626     /* Other data */
627     uint256 public goldFee;
628     uint256 public goldFeeDataUpdatedAtBlock;
629 
630     address public owner;
631     address public curator;
632     address public dev;
633 
634     function XaurumDataContract(){
635         xaurForGasLimit = 100000000;
636         weiForXau = 100000000000000000;
637         goldFee = 50000000;
638        // dev = _dev;
639 	   dev = msg.sender;
640     }
641 
642     function setProxyCurrator(address _newCurratorAdress) returns (bool){
643         if (msg.sender == owner || msg.sender == dev){        
644             curator = _newCurratorAdress;
645             return true;
646         }
647         return false;
648     }
649 
650     function setOwner(address _newOwnerAdress) returns (bool){
651         if ( msg.sender == dev ){        
652             owner = _newOwnerAdress;
653             return true;
654         }
655         return false;
656     }
657 
658     function updateMintingData(uint256 _xauToEur, uint256 _goldToEur) returns (bool status){
659         if (msg.sender == curator || msg.sender == dev){
660             xauToEur = _xauToEur;
661             goldToEur = _goldToEur;
662             mintingDataUpdatedAtBlock = block.number;
663             return true;
664         }
665         return false;
666     }
667 
668     function updateGasForXaurData(uint256 _xaurForGasLimit, uint256 _weiForXau) returns (bool status){
669         if (msg.sender == curator || msg.sender == dev){
670             xaurForGasLimit = _xaurForGasLimit;
671             weiForXau = _weiForXau;
672             gasForXaurDataUpdateAtBlock = block.number;
673             return true;
674         }
675         return false;
676     }
677 
678     function updateGoldFeeData(uint256 _goldFee) returns (bool status){
679         if (msg.sender == curator || msg.sender == dev){
680             goldFee = _goldFee;
681             goldFeeDataUpdatedAtBlock = block.number;
682             return true;
683         }
684         return false;
685     }
686 
687     function () {
688         throw;
689     }
690 }