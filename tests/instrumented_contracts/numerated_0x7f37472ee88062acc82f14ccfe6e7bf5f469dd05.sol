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
181 
182                 auxPartnerBalance = 0;
183 
184                 if (this.balance > 0) {
185                         if (!owner.call.gas(rfGas).value(this.balance)())
186                                 StatEvent("ERROR!");
187                 }
188                 StatEvent("ok");
189 
190         }
191 
192 
193         // ---------------------------------------------------
194         // tokens held reserve the top two bytes for the payid last paid.
195         // this is so holders at the top of the list dont transfer tokens 
196         // to themselves on the bottom of the list thus scamming the 
197         // system. this function deconstructs the tokenheld value.
198         // ---------------------------------------------------
199         function getPayIdAndHeld(uint _tokHeld) internal returns (uint _payId, uint _held)
200         {
201                 _payId = (_tokHeld / (2 ** 48)) & 0xffff;
202                 _held = _tokHeld & 0xffffffffffff;
203         }
204         function getHeld(uint _tokHeld) internal  returns (uint _held)
205         {
206                 _held = _tokHeld & 0xffffffffffff;
207         }
208         // ---------------------------------------------------
209         // allocate a new account by setting alloc to true
210         // set the top to bytes of tokens to cur pay id to leave out of current round
211         // add holder index, bump the num accounts
212         // ---------------------------------------------------
213         function addAccount(address _addr) internal  {
214                 holderAccounts[_addr].alloced = true;
215                 holderAccounts[_addr].tokens = (curPayoutId * (2 ** 48));
216                 holderIndexes[numAccounts++] = _addr;
217         }
218 
219 
220 // --------------------------------------
221 // BEGIN ERC-20 from StandardToken
222 // --------------------------------------
223         function totalSupply() constant returns (uint256 supply)
224         {
225                 if (icoStatus == IcoStatusValue.saleOpen
226                         || icoStatus == IcoStatusValue.anouncement)
227                         supply = maxMintableTokens;
228                 else
229                         supply = totalTokensMinted;
230         }
231 
232         function transfer(address _to, uint256 _value) returns (bool success) {
233 
234                 if ((msg.sender == developers) 
235                         &&  (now < vestTime)) {
236                         //statEvent("Tokens not yet vested.");
237                         return false;
238                 }
239 
240 
241                 //Default assumes totalSupply can't be over max (2^256 - 1).
242                 //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
243                 //Replace the if with this one instead.
244                 //if (holderAccounts[msg.sender] >= _value && balances[_to] + _value > holderAccounts[_to]) {
245 
246                 var (pidFrom, heldFrom) = getPayIdAndHeld(holderAccounts[msg.sender].tokens);
247                 if (heldFrom >= _value && _value > 0) {
248 
249                     holderAccounts[msg.sender].tokens -= _value;
250 
251                     if (!holderAccounts[_to].alloced) {
252                         addAccount(_to);
253                     }
254 
255                     uint newHeld = _value + getHeld(holderAccounts[_to].tokens);
256                     holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
257                     Transfer(msg.sender, _to, _value);
258                     return true;
259                 } else { 
260                         return false; 
261                 }
262         }
263 
264         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
265 
266                 if ((_from == developers) 
267                         &&  (now < vestTime)) {
268                         //statEvent("Tokens not yet vested.");
269                         return false;
270                 }
271 
272 
273         //same as above. Replace this line with the following if you want to protect against wrapping uints.
274         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
275 
276                 var (pidFrom, heldFrom) = getPayIdAndHeld(holderAccounts[_from].tokens);
277                 if (heldFrom >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
278                     holderAccounts[_from].tokens -= _value;
279 
280                     if (!holderAccounts[_to].alloced)
281                         addAccount(_to);
282 
283                     uint newHeld = _value + getHeld(holderAccounts[_to].tokens);
284 
285                     holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
286                     allowed[_from][msg.sender] -= _value;
287                     Transfer(_from, _to, _value);
288                     return true;
289                 } else { 
290                     return false; 
291                 }
292         }
293 
294 
295         function balanceOf(address _owner) constant returns (uint256 balance) {
296                 // vars default to 0
297                 if (holderAccounts[_owner].alloced) {
298                         balance = getHeld(holderAccounts[_owner].tokens);
299                 } 
300         }
301 
302         function approve(address _spender, uint256 _value) returns (bool success) {
303                 allowed[msg.sender][_spender] = _value;
304                 Approval(msg.sender, _spender, _value);
305                 return true;
306         }
307 
308         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
309                 return allowed[_owner][_spender];
310         }
311 // ----------------------------------
312 // END ERC20
313 // ----------------------------------
314 
315   
316         // -------------------------------------------
317         // check the alloced
318         // -------------------------------------------
319         function holderExists(address _addr) returns(bool _exist)
320         {
321                 _exist = holderAccounts[_addr].alloced;
322         }
323 
324 
325 
326         // -------------------------------------------
327         // default payable function.
328         // if sender is e4row  partner, this is a rake fee payment
329         // otherwise this is a token purchase.
330         // tokens only purchaseable between tokenfundingstart and end
331         // -------------------------------------------
332         function () payable {
333                 if (msg.sender == e4_partner) {
334                      feePayment(); // from e4row game escrow contract
335                 } else {
336                      purchaseToken();
337                 }
338         }
339 
340         // -----------------------------
341         // purchase token function - tokens only sold during sale period up until the max tokens
342         // purchase price is tokenPrice.  all units in wei.
343         // purchaser will not be included in current pay run
344         // -----------------------------
345         function purchaseToken() payable {
346 
347                 uint nvalue = msg.value; // being careful to preserve msg.value
348                 address npurchaser = msg.sender;
349                 if (nvalue < tokenPrice) 
350                         throw;
351 
352                 uint qty = nvalue/tokenPrice;
353                 updateIcoStatus();
354                 if (icoStatus != IcoStatusValue.saleOpen) // purchase is closed
355                         throw;
356                 if (totalTokensMinted + qty > maxMintableTokens)
357                         throw;
358                 if (!holderAccounts[npurchaser].alloced)
359                         addAccount(npurchaser);
360 
361                 // purchaser waits for next payrun. otherwise can disrupt cur pay run
362                 uint newHeld = qty + getHeld(holderAccounts[npurchaser].tokens);
363                 holderAccounts[npurchaser].tokens = newHeld | (curPayoutId * (2 ** 48));
364 
365                 totalTokensMinted += qty;
366                 totalTokenFundsReceived += nvalue;
367 
368                 if (totalTokensMinted == maxMintableTokens) {
369                         icoStatus = IcoStatusValue.saleClosed;
370                         //test unnecessary -  if (getNumTokensPurchased() >= minIcoTokenGoal)
371                         doDeveloperGrant();
372                         StatEventI("Purchased,Granted", qty);
373                 } else
374                         StatEventI("Purchased", qty);
375 
376         }
377 
378 
379         // ---------------------------
380         // accept payment from e4row contract
381         // ---------------------------
382         function feePayment() payable  
383         {
384                 if (msg.sender != e4_partner) {
385                         StatEvent("forbidden");
386                         return; // thank you
387                 }
388                 uint nfvalue = msg.value; // preserve value in case changed in dev grant
389 
390                 updateIcoStatus();
391 
392                 holdoverBalance += nfvalue;
393                 partnerCredits += nfvalue;
394                 StatEventI("Payment", nfvalue);
395 
396                 if (holdoverBalance > payoutThreshold
397                         || payoutBalance > 0)
398                         doPayout();
399 
400 
401         }
402 
403         // ---------------------------
404         // set the e4row partner, this is only done once
405         // ---------------------------
406         function setE4RowPartner(address _addr) public
407         {
408         // ONLY owner can set and ONLY ONCE! (unless "unlocked" debug)
409         // once its locked. ONLY ONCE!
410                 if (msg.sender == owner) {
411                         if ((e4_partner == address(0)) || (settingsState == SettingStateValue.debug)) {
412                                 e4_partner = _addr;
413                                 partnerCredits = 0;
414                                 //StatEventI("E4-Set", 0);
415                         } else {
416                                 StatEvent("Already Set");
417                         }
418                 }
419         }
420 
421         // ----------------------------
422         // return the total tokens purchased
423         // ----------------------------
424         function getNumTokensPurchased() constant returns(uint _purchased)
425         {
426                 _purchased = totalTokensMinted-numDevTokens;
427         }
428 
429         // ----------------------------
430         // return the num games as reported from the e4row  contract
431         // ----------------------------
432         function getNumGames() constant returns(uint _games)
433         {
434                 //_games = 0;
435                 if (e4_partner != address(0)) {
436                         iE4RowEscrow pe4 = iE4RowEscrow(e4_partner);
437                         _games = uint(pe4.getNumGamesStarted());
438                 } 
439                 //else
440                 //StatEvent("Empty E4");
441         }
442 
443         // ------------------------------------------------
444         // get the founders, auxPartner, developer
445         // --------------------------------------------------
446         function getSpecialAddresses() constant returns (address _fndr, address _aux, address _dev, address _e4)
447         {
448                 //if (_sender == owner) { // no msg.sender on constant functions at least in mew
449                         _fndr = founderOrg;
450                         _aux = auxPartner;
451                         _dev = developers;
452                         _e4  = e4_partner;
453                 //}
454         }
455 
456 
457 
458         // ----------------------------
459         // update the ico status
460         // ----------------------------
461         function updateIcoStatus() public
462         {
463                 if (icoStatus == IcoStatusValue.succeeded 
464                         || icoStatus == IcoStatusValue.failed)
465                         return;
466                 else if (icoStatus == IcoStatusValue.anouncement) {
467                         if (now > fundingStart && now <= fundingDeadline) {
468                                 icoStatus = IcoStatusValue.saleOpen;
469 
470                         } else if (now > fundingDeadline) {
471                                 // should not be here - this will eventually fail
472                                 icoStatus = IcoStatusValue.saleClosed;
473                         }
474                 } else {
475                         uint numP = getNumTokensPurchased();
476                         uint numG = getNumGames();
477                         if ((now > fundingDeadline && numP < minIcoTokenGoal)
478                                 || (now > usageDeadline && numG < minUsageGoal)) {
479                                 icoStatus = IcoStatusValue.failed;
480                         } else if ((now > fundingDeadline) // dont want to prevent more token sales
481                                 && (numP >= minIcoTokenGoal)
482                                 && (numG >= minUsageGoal)) {
483                                 icoStatus = IcoStatusValue.succeeded; // hooray
484                         }
485                         if (icoStatus == IcoStatusValue.saleOpen
486                                 && ((numP >= maxMintableTokens)
487                                 || (now > fundingDeadline))) {
488                                         icoStatus = IcoStatusValue.saleClosed;
489                                 }
490                 }
491 
492                 if (!developersGranted
493                         && icoStatus != IcoStatusValue.saleOpen 
494                         && icoStatus != IcoStatusValue.anouncement
495                         && getNumTokensPurchased() >= minIcoTokenGoal) {
496                                 doDeveloperGrant(); // grant whenever status goes from open to anything...
497                 }
498 
499 
500         }
501 
502 
503         // ----------------------------
504         // request refund. Caller must call to request and receive refund 
505         // WARNING - withdraw rewards/dividends before calling.
506         // YOU HAVE BEEN WARNED
507         // ----------------------------
508         function requestRefund()
509         {
510                 address nrequester = msg.sender;
511                 updateIcoStatus();
512 
513                 uint ntokens = getHeld(holderAccounts[nrequester].tokens);
514                 if (icoStatus != IcoStatusValue.failed)
515                         StatEvent("No Refund");
516                 else if (ntokens == 0)
517                         StatEvent("No Tokens");
518                 else {
519                         uint nrefund = ntokens * tokenPrice;
520                         if (getNumTokensPurchased() >= minIcoTokenGoal)
521                                 nrefund -= (nrefund /10); // only 90 percent b/c 10 percent payout
522 
523                         holderAccounts[developers].tokens += ntokens;
524                         holderAccounts[nrequester].tokens = 0;
525                         if (holderAccounts[nrequester].balance > 0) {
526                                 // see above warning!!
527                                 if (!holderAccounts[developers].alloced) 
528                                         addAccount(developers);
529                                 holderAccounts[developers].balance += holderAccounts[nrequester].balance;
530                                 holderAccounts[nrequester].balance = 0;
531                         }
532 
533                         if (!nrequester.call.gas(rfGas).value(nrefund)())
534                                 throw;
535                         //StatEventI("Refunded", nrefund);
536                 }
537         }
538 
539 
540 
541         // ---------------------------------------------------
542         // payout rewards to all token holders
543         // use a second holding variable called PayoutBalance to do 
544         // the actual payout from b/c too much gas to iterate thru 
545         // each payee. Only start a new run at most once per "minpayinterval".
546         // Its done in runs of "maxPaysPer"
547         // we use special coding for the holderAccounts to avoid a hack
548         // of getting paid at the top of the list then transfering tokens
549         // to another address at the bottom of the list.
550         // because of that each holderAccounts entry gets the payoutid stamped upon it (top two bytes)
551         // also a token transfer will transfer the payout id.
552         // ---------------------------------------------------
553         function doPayout()  internal
554         {
555                 if (totalTokensMinted == 0)
556                         return;
557 
558                 if ((holdoverBalance > 0) 
559                         && (payoutBalance == 0)
560                         && (now > (lastPayoutTime+minPayInterval))) {
561                         // start a new run
562                         curPayoutId++;
563                         if (curPayoutId >= 32768)
564                                 curPayoutId = 1;
565                         lastPayoutTime = now;
566                         payoutBalance = int(holdoverBalance);
567                         prOrigPayoutBal = payoutBalance;
568                         prOrigTokensMint = totalTokensMinted;
569                         holdoverBalance = 0;
570                         lastPayoutIndex = 0;
571                         StatEventI("StartRun", uint(curPayoutId));
572                 } else if (payoutBalance > 0) {
573                         // work down the p.o.b
574                         uint nAmount;
575                         uint nPerTokDistrib = uint(prOrigPayoutBal)/prOrigTokensMint;
576                         uint paids = 0;
577                         uint i; // intentional
578                         for (i = lastPayoutIndex; (paids < maxPaysPer) && (i < numAccounts) && (payoutBalance > 0); i++ ) {
579                                 address a = holderIndexes[i];
580                                 if (a == address(0)) {
581                                         continue;
582                                 }
583                                 var (pid, held) = getPayIdAndHeld(holderAccounts[a].tokens);
584                                 if ((held > 0) && (pid != curPayoutId)) {
585                                         nAmount = nPerTokDistrib * held;
586                                         if (int(nAmount) <= payoutBalance){
587                                                 holderAccounts[a].balance += nAmount; 
588                                                 holderAccounts[a].tokens = (curPayoutId * (2 ** 48)) | held;
589                                                 payoutBalance -= int(nAmount);
590                                                 paids++;
591                                         }
592                                 }
593                         }
594                         lastPayoutIndex = i;
595                         if (lastPayoutIndex >= numAccounts || payoutBalance <= 0) {
596                                 lastPayoutIndex = 0;
597                                 if (payoutBalance > 0)
598                                         holdoverBalance += uint(payoutBalance);// put back any leftovers
599                                 payoutBalance = 0;
600                                 StatEventI("RunComplete", uint(prOrigPayoutBal) );
601 
602                         } else {
603                                 StatEventI("PayRun", nPerTokDistrib );
604                         }
605                 }
606 
607         }
608 
609 
610         // ----------------------------
611         // sender withdraw entire rewards/dividends
612         // ----------------------------
613         function withdrawDividends() public returns (uint _amount)
614         {
615                 if (holderAccounts[msg.sender].balance == 0) { 
616                         //_amount = 0;
617                         StatEvent("0 Balance");
618                         return;
619                 } else {
620                         if ((msg.sender == developers) 
621                                 &&  (now < vestTime)) {
622                                 //statEvent("Tokens not yet vested.");
623                                 //_amount = 0;
624                                 return;
625                         }
626 
627                         _amount = holderAccounts[msg.sender].balance; 
628                         holderAccounts[msg.sender].balance = 0; 
629                         if (!msg.sender.call.gas(rwGas).value(_amount)())
630                                 throw;
631                         //StatEventI("Paid", _amount);
632 
633                 }
634 
635         }
636 
637         // ----------------------------
638         // set gas for operations
639         // ----------------------------
640         function setOpGas(uint _rm, uint _rf, uint _rw)
641         {
642                 if (msg.sender != owner && msg.sender != developers) {
643                         //StatEvent("only owner calls");
644                         return;
645                 } else {
646                         rmGas = _rm;
647                         rfGas = _rf;
648                         rwGas = _rw;
649                 }
650         }
651 
652         // ----------------------------
653         // get gas for operations
654         // ----------------------------
655         function getOpGas() constant returns (uint _rm, uint _rf, uint _rw)
656         {
657                 _rm = rmGas;
658                 _rf = rfGas;
659                 _rw = rwGas;
660         }
661  
662 
663         // ----------------------------
664         // check rewards.  pass in address of token holder
665         // ----------------------------
666         function checkDividends(address _addr) constant returns(uint _amount)
667         {
668                 if (holderAccounts[_addr].alloced)
669                         _amount = holderAccounts[_addr].balance;
670         }
671 
672 
673         // ------------------------------------------------
674         // icoCheckup - check up call for administrators
675         // after sale is closed if min ico tokens sold, 10 percent will be distributed to 
676         // company to cover various operating expenses
677         // after sale and usage dealines have been met, remaining 90 percent will be distributed to
678         // company.
679         // ------------------------------------------------
680         function icoCheckup() public
681         {
682                 if (msg.sender != owner && msg.sender != developers)
683                         throw;
684 
685                 uint nmsgmask;
686                 //nmsgmask = 0;
687 
688                 if (icoStatus == IcoStatusValue.saleClosed) {
689                         if ((getNumTokensPurchased() >= minIcoTokenGoal)
690                                 && (remunerationStage == 0 )) {
691                                 remunerationStage = 1;
692                                 remunerationBalance = (totalTokenFundsReceived/100)*9; // 9 percent
693                                 auxPartnerBalance =  (totalTokenFundsReceived/100); // 1 percent
694                                 nmsgmask |= 1;
695                         } 
696                 }
697                 if (icoStatus == IcoStatusValue.succeeded) {
698 
699                         if (remunerationStage == 0 ) {
700                                 remunerationStage = 1;
701                                 remunerationBalance = (totalTokenFundsReceived/100)*9; 
702                                 auxPartnerBalance =  (totalTokenFundsReceived/100);
703                                 nmsgmask |= 4;
704                         }
705                         if (remunerationStage == 1) { // we have already suceeded
706                                 remunerationStage = 2;
707                                 remunerationBalance += totalTokenFundsReceived - (totalTokenFundsReceived/10); // 90 percent
708                                 nmsgmask |= 8;
709                         }
710 
711                 }
712 
713                 uint ntmp;
714 
715                 if (remunerationBalance > 0) { 
716                 // only pay one entity per call, dont want to run out of gas
717                                 ntmp = remunerationBalance;
718                                 remunerationBalance = 0;
719                                 if (!founderOrg.call.gas(rmGas).value(ntmp)()) {
720                                         remunerationBalance = ntmp;
721                                         nmsgmask |= 32;
722                                 } else {
723                                         nmsgmask |= 64;
724                                 }
725                 } else  if (auxPartnerBalance > 0) {
726                 // note the "else" only pay one entity per call, dont want to run out of gas
727                         ntmp = auxPartnerBalance;
728                         auxPartnerBalance = 0;
729                         if (!auxPartner.call.gas(rmGas).value(ntmp)()) {
730                                 auxPartnerBalance = ntmp;
731                                 nmsgmask |= 128;
732                         }  else {
733                                 nmsgmask |= 256;
734                         }
735 
736                 } 
737 
738                 StatEventI("ico-checkup", nmsgmask);
739         }
740 
741 
742         // ----------------------------
743         // swap executor
744         // ----------------------------
745         function changeOwner(address _addr) 
746         {
747                 if (msg.sender != owner
748                         || settingsState == SettingStateValue.lockedRelease)
749                          throw;
750 
751                 owner = _addr;
752         }
753 
754         // ----------------------------
755         // swap developers account
756         // ----------------------------
757         function changeDevevoperAccont(address _addr) 
758         {
759                 if (msg.sender != owner
760                         || settingsState == SettingStateValue.lockedRelease)
761                          throw;
762                 developers = _addr;
763         }
764 
765         // ----------------------------
766         // change founder
767         // ----------------------------
768         function changeFounder(address _addr) 
769         {
770                 if (msg.sender != owner
771                         || settingsState == SettingStateValue.lockedRelease)
772                          throw;
773                 founderOrg = _addr;
774         }
775 
776         // ----------------------------
777         // change auxPartner
778         // ----------------------------
779         function changeAuxPartner(address _aux) 
780         {
781                 if (msg.sender != owner
782                         || settingsState == SettingStateValue.lockedRelease)
783                          throw;
784                 auxPartner = _aux;
785         }
786 
787 
788         // ----------------------------
789         // DEBUG ONLY - end this contract, suicide to developers
790         // ----------------------------
791         function haraKiri()
792         {
793                 if (settingsState != SettingStateValue.debug)
794                         throw;
795                 if (msg.sender != owner)
796                          throw;
797                 suicide(developers);
798         }
799 
800         // ----------------------------
801         // get all ico status, funding and usage info
802         // ----------------------------
803         function getIcoInfo() constant returns(IcoStatusValue _status, uint _saleStart, uint _saleEnd, uint _usageEnd, uint _saleGoal, uint _usageGoal, uint _sold, uint _used, uint _funds, uint _credits, uint _remuStage, uint _vest)
804         {
805                 _status = icoStatus;
806                 _saleStart = fundingStart;
807                 _saleEnd = fundingDeadline;
808                 _usageEnd = usageDeadline;
809                 _vest = vestTime;
810                 _saleGoal = minIcoTokenGoal;
811                 _usageGoal = minUsageGoal;
812                 _sold = getNumTokensPurchased();
813                 _used = getNumGames();
814                 _funds = totalTokenFundsReceived;
815                 _credits = partnerCredits;
816                 _remuStage = remunerationStage;
817         }
818 
819         function flushDividends()
820         {
821                 if ((msg.sender != owner) && (msg.sender != developers))
822                         return;
823                 if (holdoverBalance > 0 || payoutBalance > 0)
824                         doPayout();
825         }
826 
827         function doDeveloperGrant() internal
828         {
829                 if (!developersGranted) {
830                         developersGranted = true;
831                         numDevTokens = totalTokensMinted/10;
832                         totalTokensMinted += numDevTokens;
833                         if (!holderAccounts[developers].alloced) 
834                                 addAccount(developers);
835                         uint newHeld = getHeld(holderAccounts[developers].tokens) + numDevTokens;
836                         holderAccounts[developers].tokens = newHeld |  (curPayoutId * (2 ** 48));
837 
838                 }
839         }
840 
841 
842 }