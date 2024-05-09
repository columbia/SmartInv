1 pragma solidity ^0.4.8;
2 
3 
4 //
5 // FOR REFERENCE - INCLUDE  iE4RowEscrow  (interface) CONTRACT at the top .....
6 //
7 
8 contract iE4RowEscrow {
9         function getNumGamesStarted() constant returns (int ngames);
10 }
11 
12 // Abstract contract for the full ERC 20 Token standard
13 // https://github.com/ethereum/EIPs/issues/20
14 
15 // ---------------------------------
16 // ABSTRACT standard token class
17 // ---------------------------------
18 contract Token { 
19     function totalSupply() constant returns (uint256 supply);
20     function balanceOf(address _owner) constant returns (uint256 balance);
21     function transfer(address _to, uint256 _value) returns (bool success);
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23     function approve(address _spender, uint256 _value) returns (bool success);
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 }
29 
30 
31 // --------------------------
32 //  E4RowRewards - abstract e4 dividend contract
33 // --------------------------
34 contract E4RowRewards
35 {
36         function checkDividends(address _addr) constant returns(uint _amount);
37         function withdrawDividends() public returns (uint namount);
38 }
39 
40 // --------------------------
41 //  Finney Chip - token contract
42 // --------------------------
43 contract E4Token is Token, E4RowRewards {
44         event StatEvent(string msg);
45         event StatEventI(string msg, uint val);
46 
47         enum SettingStateValue  {debug, release, lockedRelease}
48         enum IcoStatusValue {anouncement, saleOpen, saleClosed, failed, succeeded}
49 
50 
51 
52 
53         struct tokenAccount {
54                 bool alloced; // flag to ascert prior allocation
55                 uint tokens; // num tokens
56                 uint balance; // rewards balance
57         }
58 // -----------------------------
59 //  data storage
60 // ----------------------------------------
61         address developers; // developers token holding address
62         address public owner; // deployer executor
63         address founderOrg; // founder orginaization contract
64         address auxPartner; // aux partner (pr/auditing) - 1 percent upon close
65         address e4_partner; // e4row  contract addresses
66 
67 
68         mapping (address => tokenAccount) holderAccounts ; // who holds how many tokens (high two bytes contain curPayId)
69         mapping (uint => address) holderIndexes ; // for iteration thru holder
70         uint numAccounts;
71 
72         uint partnerCredits; // amount partner (e4row)  has paid
73         mapping (address => mapping (address => uint256)) allowed; // approvals
74 
75 
76         uint maxMintableTokens; // ...
77         uint minIcoTokenGoal;// token goal by sale end
78         uint minUsageGoal; //  num games goal by usage deadline
79         uint public  tokenPrice; // price per token
80         uint public payoutThreshold; // threshold till payout
81 
82         uint totalTokenFundsReceived;   // running total of token funds received
83         uint public totalTokensMinted;  // total number of tokens minted
84         uint public holdoverBalance;            // hold this amount until threshhold before reward payout
85         int public payoutBalance;               // hold this amount until threshhold before reward payout
86         int prOrigPayoutBal;                    // original payout balance before run
87         uint prOrigTokensMint;                  // tokens minted at start of pay run
88         uint public curPayoutId;                // current payout id
89         uint public lastPayoutIndex;            // payout idx between run segments
90         uint public maxPaysPer;                 // num pays per segment
91         uint public minPayInterval;             // min interval between start pay run
92 
93 
94         uint fundingStart;              // funding start time immediately after anouncement
95         uint fundingDeadline;           // funding end time
96         uint usageDeadline;             // deadline where minimum usage needs to be met before considered success
97         uint public lastPayoutTime;     // timestamp of last payout time
98         uint vestTime;          // 1 year past sale vest developer tokens
99         uint numDevTokens;      // 10 per cent of tokens after close to developers
100         bool developersGranted;                 // flag
101         uint remunerationStage;         // 0 for not yet, 1 for 10 percent, 2 for remaining  upon succeeded.
102         uint public remunerationBalance;        // remuneration balance to release token funds
103         uint auxPartnerBalance;         // aux partner balance - 1 percent
104         uint rmGas; // remuneration gas
105         uint rwGas; // reward gas
106         uint rfGas; // refund gas
107 
108         IcoStatusValue icoStatus;  // current status of ico
109         SettingStateValue public settingsState;
110 
111 
112         // --------------------
113         // contract constructor
114         // --------------------
115         function E4Token() 
116         {
117                 owner = msg.sender;
118                 developers = msg.sender;
119         }
120 
121         // -----------------------------------
122         // use this to reset everything, will never be called after lockRelease
123         // -----------------------------------
124         function applySettings(SettingStateValue qState, uint _saleStart, uint _saleEnd, uint _usageEnd, uint _minUsage, uint _tokGoal, uint  _maxMintable, uint _threshold, uint _price, uint _mpp, uint _mpi )
125         {
126                 if (msg.sender != owner) 
127                         return;
128 
129                 // these settings are permanently tweakable for performance adjustments
130                 payoutThreshold = _threshold;
131                 maxPaysPer = _mpp;
132                 minPayInterval = _mpi;
133 
134                 if (settingsState == SettingStateValue.lockedRelease)
135                         return;
136 
137                 settingsState = qState;
138                 icoStatus = IcoStatusValue.anouncement;
139 
140                 rmGas = 100000; // remuneration gas
141                 rwGas = 10000; // reward gas
142                 rfGas = 10000; // refund gas
143 
144 
145                 // zero out all token holders.  
146                 // leave alloced on, leave num accounts
147                 // cant delete them anyways
148 
149                 if (totalTokensMinted > 0) {
150                         for (uint i = 0; i < numAccounts; i++ ) {
151                                 address a = holderIndexes[i];
152                                 if (a != address(0)) {
153                                         holderAccounts[a].tokens = 0;
154                                         holderAccounts[a].balance = 0;
155                                 }
156                         }
157                 }
158                 // do not reset numAccounts!
159 
160                 totalTokensMinted = 0; // this will erase
161                 totalTokenFundsReceived = 0; // this will erase.
162                 e4_partner = address(0); // must be reset again
163 
164                 fundingStart =  _saleStart;
165                 fundingDeadline = _saleEnd;
166                 usageDeadline = _usageEnd;
167                 minUsageGoal = _minUsage;
168                 minIcoTokenGoal = _tokGoal;
169                 maxMintableTokens = _maxMintable;
170                 tokenPrice = _price;
171 
172                 vestTime = fundingStart + (365 days);
173                 numDevTokens = 0;
174 
175                 holdoverBalance = 0;
176                 payoutBalance = 0;
177                 curPayoutId = 1;
178                 lastPayoutIndex = 0;
179                 remunerationStage = 0;
180                 remunerationBalance = 0;
181                 auxPartnerBalance = 0;
182                 developersGranted = false;
183                 lastPayoutTime = 0;
184 
185                 if (this.balance > 0) {
186                         if (!owner.call.gas(rfGas).value(this.balance)())
187                                 StatEvent("ERROR!");
188                 }
189                 StatEvent("ok");
190 
191         }
192 
193 
194         // ---------------------------------------------------
195         // tokens held reserve the top two bytes for the payid last paid.
196         // this is so holders at the top of the list dont transfer tokens 
197         // to themselves on the bottom of the list thus scamming the 
198         // system. this function deconstructs the tokenheld value.
199         // ---------------------------------------------------
200         function getPayIdAndHeld(uint _tokHeld) internal returns (uint _payId, uint _held)
201         {
202                 _payId = (_tokHeld / (2 ** 48)) & 0xffff;
203                 _held = _tokHeld & 0xffffffffffff;
204         }
205         function getHeld(uint _tokHeld) internal  returns (uint _held)
206         {
207                 _held = _tokHeld & 0xffffffffffff;
208         }
209         // ---------------------------------------------------
210         // allocate a new account by setting alloc to true
211         // set the top to bytes of tokens to cur pay id to leave out of current round
212         // add holder index, bump the num accounts
213         // ---------------------------------------------------
214         function addAccount(address _addr) internal  {
215                 holderAccounts[_addr].alloced = true;
216                 holderAccounts[_addr].tokens = (curPayoutId * (2 ** 48));
217                 holderIndexes[numAccounts++] = _addr;
218         }
219 
220 
221 // --------------------------------------
222 // BEGIN ERC-20 from StandardToken
223 // --------------------------------------
224         function totalSupply() constant returns (uint256 supply)
225         {
226                 if (icoStatus == IcoStatusValue.saleOpen
227                         || icoStatus == IcoStatusValue.anouncement)
228                         supply = maxMintableTokens;
229                 else
230                         supply = totalTokensMinted;
231         }
232 
233         function transfer(address _to, uint256 _value) returns (bool success) {
234 
235                 if ((msg.sender == developers) 
236                         &&  (now < vestTime)) {
237                         //statEvent("Tokens not yet vested.");
238                         return false;
239                 }
240 
241 
242                 //Default assumes totalSupply can't be over max (2^256 - 1).
243                 //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
244                 //Replace the if with this one instead.
245                 //if (holderAccounts[msg.sender] >= _value && balances[_to] + _value > holderAccounts[_to]) {
246 
247                 var (pidFrom, heldFrom) = getPayIdAndHeld(holderAccounts[msg.sender].tokens);
248                 if (heldFrom >= _value && _value > 0) {
249 
250                     holderAccounts[msg.sender].tokens -= _value;
251 
252                     if (!holderAccounts[_to].alloced) {
253                         addAccount(_to);
254                     }
255 
256                     uint newHeld = _value + getHeld(holderAccounts[_to].tokens);
257                     holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
258                     Transfer(msg.sender, _to, _value);
259                     return true;
260                 } else { 
261                         return false; 
262                 }
263         }
264 
265         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
266 
267                 if ((_from == developers) 
268                         &&  (now < vestTime)) {
269                         //statEvent("Tokens not yet vested.");
270                         return false;
271                 }
272 
273 
274         //same as above. Replace this line with the following if you want to protect against wrapping uints.
275         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
276 
277                 var (pidFrom, heldFrom) = getPayIdAndHeld(holderAccounts[_from].tokens);
278                 if (heldFrom >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
279                     holderAccounts[_from].tokens -= _value;
280 
281                     if (!holderAccounts[_to].alloced)
282                         addAccount(_to);
283 
284                     uint newHeld = _value + getHeld(holderAccounts[_to].tokens);
285 
286                     holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
287                     allowed[_from][msg.sender] -= _value;
288                     Transfer(_from, _to, _value);
289                     return true;
290                 } else { 
291                     return false; 
292                 }
293         }
294 
295 
296         function balanceOf(address _owner) constant returns (uint256 balance) {
297                 // vars default to 0
298                 if (holderAccounts[_owner].alloced) {
299                         balance = getHeld(holderAccounts[_owner].tokens);
300                 } 
301         }
302 
303         function approve(address _spender, uint256 _value) returns (bool success) {
304                 allowed[msg.sender][_spender] = _value;
305                 Approval(msg.sender, _spender, _value);
306                 return true;
307         }
308 
309         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
310                 return allowed[_owner][_spender];
311         }
312 // ----------------------------------
313 // END ERC20
314 // ----------------------------------
315 
316   
317         // -------------------------------------------
318         // check the alloced
319         // -------------------------------------------
320         function holderExists(address _addr) returns(bool _exist)
321         {
322                 _exist = holderAccounts[_addr].alloced;
323         }
324 
325 
326 
327         // -------------------------------------------
328         // default payable function.
329         // if sender is e4row  partner, this is a rake fee payment
330         // otherwise this is a token purchase.
331         // tokens only purchaseable between tokenfundingstart and end
332         // -------------------------------------------
333         function () payable {
334                 if (msg.sender == e4_partner) {
335                      feePayment(); // from e4row game escrow contract
336                 } else {
337                      purchaseToken();
338                 }
339         }
340 
341         // -----------------------------
342         // purchase token function - tokens only sold during sale period up until the max tokens
343         // purchase price is tokenPrice.  all units in wei.
344         // purchaser will not be included in current pay run
345         // -----------------------------
346         function purchaseToken() payable {
347 
348                 uint nvalue = msg.value; // being careful to preserve msg.value
349                 address npurchaser = msg.sender;
350                 if (nvalue < tokenPrice) 
351                         throw;
352 
353                 uint qty = nvalue/tokenPrice;
354                 updateIcoStatus();
355                 if (icoStatus != IcoStatusValue.saleOpen) // purchase is closed
356                         throw;
357                 if (totalTokensMinted + qty > maxMintableTokens)
358                         throw;
359                 if (!holderAccounts[npurchaser].alloced)
360                         addAccount(npurchaser);
361 
362                 // purchaser waits for next payrun. otherwise can disrupt cur pay run
363                 uint newHeld = qty + getHeld(holderAccounts[npurchaser].tokens);
364                 holderAccounts[npurchaser].tokens = newHeld | (curPayoutId * (2 ** 48));
365 
366                 totalTokensMinted += qty;
367                 totalTokenFundsReceived += nvalue;
368 
369                 if (totalTokensMinted == maxMintableTokens) {
370                         icoStatus = IcoStatusValue.saleClosed;
371                         //test unnecessary -  if (getNumTokensPurchased() >= minIcoTokenGoal)
372                         doDeveloperGrant();
373                         StatEventI("Purchased,Granted", qty);
374                 } else
375                         StatEventI("Purchased", qty);
376 
377         }
378 
379 
380         // ---------------------------
381         // accept payment from e4row contract
382         // ---------------------------
383         function feePayment() payable  
384         {
385                 if (msg.sender != e4_partner) {
386                         StatEvent("forbidden");
387                         return; // thank you
388                 }
389                 uint nfvalue = msg.value; // preserve value in case changed in dev grant
390 
391                 updateIcoStatus();
392 
393                 holdoverBalance += nfvalue;
394                 partnerCredits += nfvalue;
395                 StatEventI("Payment", nfvalue);
396 
397                 if (holdoverBalance > payoutThreshold
398                         || payoutBalance > 0)
399                         doPayout();
400 
401 
402         }
403 
404         // ---------------------------
405         // set the e4row partner, this is only done once
406         // ---------------------------
407         function setE4RowPartner(address _addr) public
408         {
409         // ONLY owner can set and ONLY ONCE! (unless "unlocked" debug)
410         // once its locked. ONLY ONCE!
411                 if (msg.sender == owner) {
412                         if ((e4_partner == address(0)) || (settingsState == SettingStateValue.debug)) {
413                                 e4_partner = _addr;
414                                 partnerCredits = 0;
415                                 //StatEventI("E4-Set", 0);
416                         } else {
417                                 StatEvent("Already Set");
418                         }
419                 }
420         }
421 
422         // ----------------------------
423         // return the total tokens purchased
424         // ----------------------------
425         function getNumTokensPurchased() constant returns(uint _purchased)
426         {
427                 _purchased = totalTokensMinted-numDevTokens;
428         }
429 
430         // ----------------------------
431         // return the num games as reported from the e4row  contract
432         // ----------------------------
433         function getNumGames() constant returns(uint _games)
434         {
435                 //_games = 0;
436                 if (e4_partner != address(0)) {
437                         iE4RowEscrow pe4 = iE4RowEscrow(e4_partner);
438                         _games = uint(pe4.getNumGamesStarted());
439                 } 
440                 //else
441                 //StatEvent("Empty E4");
442         }
443 
444         // ------------------------------------------------
445         // get the founders, auxPartner, developer
446         // --------------------------------------------------
447         function getSpecialAddresses() constant returns (address _fndr, address _aux, address _dev, address _e4)
448         {
449                 //if (_sender == owner) { // no msg.sender on constant functions at least in mew
450                         _fndr = founderOrg;
451                         _aux = auxPartner;
452                         _dev = developers;
453                         _e4  = e4_partner;
454                 //}
455         }
456 
457 
458 
459         // ----------------------------
460         // update the ico status
461         // ----------------------------
462         function updateIcoStatus() public
463         {
464                 if (icoStatus == IcoStatusValue.succeeded 
465                         || icoStatus == IcoStatusValue.failed)
466                         return;
467                 else if (icoStatus == IcoStatusValue.anouncement) {
468                         if (now > fundingStart && now <= fundingDeadline) {
469                                 icoStatus = IcoStatusValue.saleOpen;
470 
471                         } else if (now > fundingDeadline) {
472                                 // should not be here - this will eventually fail
473                                 icoStatus = IcoStatusValue.saleClosed;
474                         }
475                 } else {
476                         uint numP = getNumTokensPurchased();
477                         uint numG = getNumGames();
478                         if ((now > fundingDeadline && numP < minIcoTokenGoal)
479                                 || (now > usageDeadline && numG < minUsageGoal)) {
480                                 icoStatus = IcoStatusValue.failed;
481                         } else if ((now > fundingDeadline) // dont want to prevent more token sales
482                                 && (numP >= minIcoTokenGoal)
483                                 && (numG >= minUsageGoal)) {
484                                 icoStatus = IcoStatusValue.succeeded; // hooray
485                         }
486                         if (icoStatus == IcoStatusValue.saleOpen
487                                 && ((numP >= maxMintableTokens)
488                                 || (now > fundingDeadline))) {
489                                         icoStatus = IcoStatusValue.saleClosed;
490                                 }
491                 }
492 
493                 if (!developersGranted
494                         && icoStatus != IcoStatusValue.saleOpen 
495                         && icoStatus != IcoStatusValue.anouncement
496                         && getNumTokensPurchased() >= minIcoTokenGoal) {
497                                 doDeveloperGrant(); // grant whenever status goes from open to anything...
498                 }
499 
500 
501         }
502 
503 
504         // ----------------------------
505         // request refund. Caller must call to request and receive refund 
506         // WARNING - withdraw rewards/dividends before calling.
507         // YOU HAVE BEEN WARNED
508         // ----------------------------
509         function requestRefund()
510         {
511                 address nrequester = msg.sender;
512                 updateIcoStatus();
513 
514                 uint ntokens = getHeld(holderAccounts[nrequester].tokens);
515                 if (icoStatus != IcoStatusValue.failed)
516                         StatEvent("No Refund");
517                 else if (ntokens == 0)
518                         StatEvent("No Tokens");
519                 else {
520                         uint nrefund = ntokens * tokenPrice;
521                         if (getNumTokensPurchased() >= minIcoTokenGoal)
522                                 nrefund -= (nrefund /10); // only 90 percent b/c 10 percent payout
523 
524                         holderAccounts[developers].tokens += ntokens;
525                         holderAccounts[nrequester].tokens = 0;
526                         if (holderAccounts[nrequester].balance > 0) {
527                                 // see above warning!!
528                                 if (!holderAccounts[developers].alloced) 
529                                         addAccount(developers);
530                                 holderAccounts[developers].balance += holderAccounts[nrequester].balance;
531                                 holderAccounts[nrequester].balance = 0;
532                         }
533 
534                         if (!nrequester.call.gas(rfGas).value(nrefund)())
535                                 throw;
536                         //StatEventI("Refunded", nrefund);
537                 }
538         }
539 
540 
541 
542         // ---------------------------------------------------
543         // payout rewards to all token holders
544         // use a second holding variable called PayoutBalance to do 
545         // the actual payout from b/c too much gas to iterate thru 
546         // each payee. Only start a new run at most once per "minpayinterval".
547         // Its done in runs of "maxPaysPer"
548         // we use special coding for the holderAccounts to avoid a hack
549         // of getting paid at the top of the list then transfering tokens
550         // to another address at the bottom of the list.
551         // because of that each holderAccounts entry gets the payoutid stamped upon it (top two bytes)
552         // also a token transfer will transfer the payout id.
553         // ---------------------------------------------------
554         function doPayout()  internal
555         {
556                 if (totalTokensMinted == 0)
557                         return;
558 
559                 if ((holdoverBalance > 0) 
560                         && (payoutBalance == 0)
561                         && (now > (lastPayoutTime+minPayInterval))) {
562                         // start a new run
563                         curPayoutId++;
564                         if (curPayoutId >= 32768)
565                                 curPayoutId = 1;
566                         lastPayoutTime = now;
567                         payoutBalance = int(holdoverBalance);
568                         prOrigPayoutBal = payoutBalance;
569                         prOrigTokensMint = totalTokensMinted;
570                         holdoverBalance = 0;
571                         lastPayoutIndex = 0;
572                         StatEventI("StartRun", uint(curPayoutId));
573                 } else if (payoutBalance > 0) {
574                         // work down the p.o.b
575                         uint nAmount;
576                         uint nPerTokDistrib = uint(prOrigPayoutBal)/prOrigTokensMint;
577                         uint paids = 0;
578                         uint i; // intentional
579                         for (i = lastPayoutIndex; (paids < maxPaysPer) && (i < numAccounts) && (payoutBalance > 0); i++ ) {
580                                 address a = holderIndexes[i];
581                                 if (a == address(0)) {
582                                         continue;
583                                 }
584                                 var (pid, held) = getPayIdAndHeld(holderAccounts[a].tokens);
585                                 if ((held > 0) && (pid != curPayoutId)) {
586                                         nAmount = nPerTokDistrib * held;
587                                         if (int(nAmount) <= payoutBalance){
588                                                 holderAccounts[a].balance += nAmount; 
589                                                 holderAccounts[a].tokens = (curPayoutId * (2 ** 48)) | held;
590                                                 payoutBalance -= int(nAmount);
591                                                 paids++;
592                                         }
593                                 }
594                         }
595                         lastPayoutIndex = i;
596                         if (lastPayoutIndex >= numAccounts || payoutBalance <= 0) {
597                                 lastPayoutIndex = 0;
598                                 if (payoutBalance > 0)
599                                         holdoverBalance += uint(payoutBalance);// put back any leftovers
600                                 payoutBalance = 0;
601                                 StatEventI("RunComplete", uint(prOrigPayoutBal) );
602 
603                         } else {
604                                 StatEventI("PayRun", nPerTokDistrib );
605                         }
606                 }
607 
608         }
609 
610 
611         // ----------------------------
612         // sender withdraw entire rewards/dividends
613         // ----------------------------
614         function withdrawDividends() public returns (uint _amount)
615         {
616                 if (holderAccounts[msg.sender].balance == 0) { 
617                         //_amount = 0;
618                         StatEvent("0 Balance");
619                         return;
620                 } else {
621                         if ((msg.sender == developers) 
622                                 &&  (now < vestTime)) {
623                                 //statEvent("Tokens not yet vested.");
624                                 //_amount = 0;
625                                 return;
626                         }
627 
628                         _amount = holderAccounts[msg.sender].balance; 
629                         holderAccounts[msg.sender].balance = 0; 
630                         if (!msg.sender.call.gas(rwGas).value(_amount)())
631                                 throw;
632                         //StatEventI("Paid", _amount);
633 
634                 }
635 
636         }
637 
638         // ----------------------------
639         // set gas for operations
640         // ----------------------------
641         function setOpGas(uint _rm, uint _rf, uint _rw)
642         {
643                 if (msg.sender != owner && msg.sender != developers) {
644                         //StatEvent("only owner calls");
645                         return;
646                 } else {
647                         rmGas = _rm;
648                         rfGas = _rf;
649                         rwGas = _rw;
650                 }
651         }
652 
653         // ----------------------------
654         // get gas for operations
655         // ----------------------------
656         function getOpGas() constant returns (uint _rm, uint _rf, uint _rw)
657         {
658                 _rm = rmGas;
659                 _rf = rfGas;
660                 _rw = rwGas;
661         }
662  
663 
664         // ----------------------------
665         // check rewards.  pass in address of token holder
666         // ----------------------------
667         function checkDividends(address _addr) constant returns(uint _amount)
668         {
669                 if (holderAccounts[_addr].alloced)
670                         _amount = holderAccounts[_addr].balance;
671         }
672 
673 
674         // ------------------------------------------------
675         // icoCheckup - check up call for administrators
676         // after sale is closed if min ico tokens sold, 10 percent will be distributed to 
677         // company to cover various operating expenses
678         // after sale and usage dealines have been met, remaining 90 percent will be distributed to
679         // company.
680         // ------------------------------------------------
681         function icoCheckup() public
682         {
683                 if (msg.sender != owner && msg.sender != developers)
684                         throw;
685 
686                 uint nmsgmask;
687                 //nmsgmask = 0;
688 
689                 if (icoStatus == IcoStatusValue.saleClosed) {
690                         if ((getNumTokensPurchased() >= minIcoTokenGoal)
691                                 && (remunerationStage == 0 )) {
692                                 remunerationStage = 1;
693                                 remunerationBalance = (totalTokenFundsReceived/100)*9; // 9 percent
694                                 auxPartnerBalance =  (totalTokenFundsReceived/100); // 1 percent
695                                 nmsgmask |= 1;
696                         } 
697                 }
698                 if (icoStatus == IcoStatusValue.succeeded) {
699 
700                         if (remunerationStage == 0 ) {
701                                 remunerationStage = 1;
702                                 remunerationBalance = (totalTokenFundsReceived/100)*9; 
703                                 auxPartnerBalance =  (totalTokenFundsReceived/100);
704                                 nmsgmask |= 4;
705                         }
706                         if (remunerationStage == 1) { // we have already suceeded
707                                 remunerationStage = 2;
708                                 remunerationBalance += totalTokenFundsReceived - (totalTokenFundsReceived/10); // 90 percent
709                                 nmsgmask |= 8;
710                         }
711 
712                 }
713 
714                 uint ntmp;
715 
716                 if (remunerationBalance > 0) { 
717                 // only pay one entity per call, dont want to run out of gas
718                                 ntmp = remunerationBalance;
719                                 remunerationBalance = 0;
720                                 if (!founderOrg.call.gas(rmGas).value(ntmp)()) {
721                                         remunerationBalance = ntmp;
722                                         nmsgmask |= 32;
723                                 } else {
724                                         nmsgmask |= 64;
725                                 }
726                 } else  if (auxPartnerBalance > 0) {
727                 // note the "else" only pay one entity per call, dont want to run out of gas
728                         ntmp = auxPartnerBalance;
729                         auxPartnerBalance = 0;
730                         if (!auxPartner.call.gas(rmGas).value(ntmp)()) {
731                                 auxPartnerBalance = ntmp;
732                                 nmsgmask |= 128;
733                         }  else {
734                                 nmsgmask |= 256;
735                         }
736 
737                 } 
738 
739                 StatEventI("ico-checkup", nmsgmask);
740         }
741 
742 
743         // ----------------------------
744         // swap executor
745         // ----------------------------
746         function changeOwner(address _addr) 
747         {
748                 if (msg.sender != owner
749                         || settingsState == SettingStateValue.lockedRelease)
750                          throw;
751 
752                 owner = _addr;
753         }
754 
755         // ----------------------------
756         // swap developers account
757         // ----------------------------
758         function changeDevevoperAccont(address _addr) 
759         {
760                 if (msg.sender != owner
761                         || settingsState == SettingStateValue.lockedRelease)
762                          throw;
763                 developers = _addr;
764         }
765 
766         // ----------------------------
767         // change founder
768         // ----------------------------
769         function changeFounder(address _addr) 
770         {
771                 if (msg.sender != owner
772                         || settingsState == SettingStateValue.lockedRelease)
773                          throw;
774                 founderOrg = _addr;
775         }
776 
777         // ----------------------------
778         // change auxPartner
779         // ----------------------------
780         function changeAuxPartner(address _aux) 
781         {
782                 if (msg.sender != owner
783                         || settingsState == SettingStateValue.lockedRelease)
784                          throw;
785                 auxPartner = _aux;
786         }
787 
788 
789         // ----------------------------
790         // DEBUG ONLY - end this contract, suicide to developers
791         // ----------------------------
792         function haraKiri()
793         {
794                 if (settingsState != SettingStateValue.debug)
795                         throw;
796                 if (msg.sender != owner)
797                          throw;
798                 suicide(developers);
799         }
800 
801         // ----------------------------
802         // get all ico status, funding and usage info
803         // ----------------------------
804         function getIcoInfo() constant returns(IcoStatusValue _status, uint _saleStart, uint _saleEnd, uint _usageEnd, uint _saleGoal, uint _usageGoal, uint _sold, uint _used, uint _funds, uint _credits, uint _remuStage, uint _vest)
805         {
806                 _status = icoStatus;
807                 _saleStart = fundingStart;
808                 _saleEnd = fundingDeadline;
809                 _usageEnd = usageDeadline;
810                 _vest = vestTime;
811                 _saleGoal = minIcoTokenGoal;
812                 _usageGoal = minUsageGoal;
813                 _sold = getNumTokensPurchased();
814                 _used = getNumGames();
815                 _funds = totalTokenFundsReceived;
816                 _credits = partnerCredits;
817                 _remuStage = remunerationStage;
818         }
819 
820         function flushDividends()
821         {
822                 if ((msg.sender != owner) && (msg.sender != developers))
823                         return;
824                 if (holdoverBalance > 0 || payoutBalance > 0)
825                         doPayout();
826         }
827 
828         function doDeveloperGrant() internal
829         {
830                 if (!developersGranted) {
831                         developersGranted = true;
832                         numDevTokens = totalTokensMinted/10;
833                         totalTokensMinted += numDevTokens;
834                         if (!holderAccounts[developers].alloced) 
835                                 addAccount(developers);
836                         uint newHeld = getHeld(holderAccounts[developers].tokens) + numDevTokens;
837                         holderAccounts[developers].tokens = newHeld |  (curPayoutId * (2 ** 48));
838 
839                 }
840         }
841 
842 
843 }