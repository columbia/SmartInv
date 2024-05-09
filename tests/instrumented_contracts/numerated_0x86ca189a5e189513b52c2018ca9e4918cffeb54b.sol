1 pragma solidity ^0.4.11;
2 
3 // VERSION LAVA(I)
4 
5 
6 // --------------------------
7 // here's how this works:
8 // the current amount of dividends due to each token-holder's  is:
9 //   previous_due + [ p(x) * t(x)/N ] + [ p(x+1) * t(x+1)/N ] + ...
10 //   where p(x) is the x'th payment received by the contract
11 //         t(x) is the number of tokens held by the token-holder at the time of p(x)
12 //         N    is the total number of tokens, which never changes
13 //
14 // assume that t(x) takes on 3 values, t(a), t(b) and t(c), during periods a, b, and c. then:
15 // factoring:
16 //   current_due = { (t(a) * [p(x) + p(x+1)] ...) +
17 //                   (t(b) * [p(y) + p(y+1)] ...) +
18 //                   (t(c) * [p(z) + p(z+1)] ...) } / N
19 //
20 // or
21 //
22 //   current_due = { (t(a) * period_a_fees) +
23 //                   (t(b) * period_b_fees) +
24 //                   (t(c) * period_c_fees) } / N
25 //
26 // if we designate current_due * N as current-points, then
27 //
28 //   currentPoints = {  (t(a) * period_a_fees) +
29 //                      (t(b) * period_b_fees) +
30 //                      (t(c) * period_c_fees) }
31 //
32 // or more succictly, if we recompute current points before a token-holder's number of
33 // tokens, T, is about to change:
34 //
35 //   currentPoints = previous_points + (T * current-period-fees)
36 //
37 // when we want to do a payout, we'll calculate:
38 //  current_due = current-points / N
39 //
40 // we'll keep track of a token-holder's current-period-points, which is:
41 //   T * current-period-fees
42 // by taking a snapshot of fees collected exactly when the current period began; that is, the when the
43 // number of tokens last changed. that is, we keep a running count of total fees received
44 //
45 //   TotalFeesReceived = p(x) + p(x+1) + p(x+2)
46 //
47 // (which happily is the same for all token holders) then, before any token holder changes their number of
48 // tokens we compute (for that token holder):
49 //
50 //  function calcCurPointsForAcct(acct) {
51 //    currentPoints[acct] += (TotalFeesReceived - lastSnapshot[acct]) * T[acct]
52 //    lastSnapshot[acct] = TotalFeesReceived
53 //  }
54 //
55 // in the withdraw fcn, all we need is:
56 //
57 //  function withdraw(acct) {
58 //    calcCurPointsForAcct(acct);
59 //    current_amount_due = currentPoints[acct] / N
60 //    currentPoints[acct] = 0;
61 //    send(current_amount_due);
62 //  }
63 //
64 //
65 // special provisions for transfers from the old e4row contract (token-split transfers)
66 // -------------------------------------------------------------------------------------
67 // normally when a new acct is created, eg cuz tokens are transferred from one acct to another, we first call
68 // calcCurPointsForAcct(acct) on the old acct; on the new acct we set:
69 //  currentPoints[acct] = 0;
70 //  lastSnapshot[acct] = TotalFeesReceived;
71 //
72 // this starts the new account with no credits for any dividends that have been collected so far, which is what
73 // you would generally want. however, there is a case in which tokens are transferred from the old e4row contract.
74 // in that case the tokens were reserved on this contract all along, and they earn dividends even before they are
75 // assigned to an account. so for token-split transfers:
76 //  currentPoints[acct] = 0;
77 //  lastSnapshot[acct] = 0;
78 //
79 // then immediately call calcCurPointsForAcct(acct) for the new token-split account. he will get credit
80 // for all the accumulated points, from the beginning of time.
81 //
82 // --------------------------
83 
84 
85 // Abstract contract for the full ERC 20 Token standard
86 // https://github.com/ethereum/EIPs/issues/20
87 
88 // ---------------------------------
89 // ABSTRACT standard token class
90 // ---------------------------------
91 contract Token {
92     function totalSupply() constant returns (uint256 supply);
93     function balanceOf(address _owner) constant returns (uint256 balance);
94     function transfer(address _to, uint256 _value) returns (bool success);
95     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
96     function approve(address _spender, uint256 _value) returns (bool success);
97     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
98 
99     event Transfer(address indexed _from, address indexed _to, uint256 _value);
100     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101 }
102 
103 
104 // --------------------------
105 //  E4RowRewards - abstract e4 dividend contract
106 // --------------------------
107 contract E4LavaRewards
108 {
109         function checkDividends(address _addr) constant returns(uint _amount);
110         function withdrawDividends() public returns (uint namount);
111         function transferDividends(address _to) returns (bool success);
112         function getAccountInfo(address _addr) constant returns(uint _tokens, uint _snapshot, uint _points);
113 
114 }
115 
116 // --------------------------
117 //  E4LavaOptin - abstract e4 optin contract
118 // --------------------------
119 contract E4LavaOptIn
120 {
121         function optInFromClassic() public;
122 }
123 
124 
125 // --------------------------
126 //  E4ROW (LAVA) - token contract
127 // --------------------------
128 contract E4Lava is Token, E4LavaRewards, E4LavaOptIn {
129         event StatEvent(string msg);
130         event StatEventI(string msg, uint val);
131 
132         enum SettingStateValue  {debug, lockedRelease}
133 
134         struct tokenAccount {
135                 bool alloced;       // flag to ascert prior allocation
136                 uint tokens;        // num tokens currently held in this acct
137                 uint currentPoints; // updated before token balance changes, or before a withdrawal. credit for owning tokens
138                 uint lastSnapshot;  // snapshot of global TotalPoints, last time we updated this acct's currentPoints
139         }
140 
141 // -----------------------------
142 //  data storage
143 // ----------------------------------------
144         uint constant NumOrigTokens         = 5762;   // number of old tokens, from original token contract
145         uint constant NewTokensPerOrigToken = 100000; // how many new tokens are created for each from original token
146         uint constant NewTokenSupply        = 5762 * 100000;
147         uint public numToksSwitchedOver;              // count old tokens that have been converted
148         uint public holdoverBalance;                  // funds received, but not yet distributed
149         uint public TotalFeesReceived;                // total fees received from partner contract(s)
150 
151         address public developers;                    // developers token holding address
152         address public owner;                         // deployer executor
153         address public oldE4;                         // addr of old e4 token contract
154         address public oldE4RecycleBin;               // addr to transfer old tokens
155 
156         uint public decimals;
157         string public symbol;
158 
159         mapping (address => tokenAccount) holderAccounts;          // who holds how many tokens (high two bytes contain curPayId)
160         mapping (uint => address) holderIndexes;                   // for iteration thru holder
161         mapping (address => mapping (address => uint256)) allowed; // approvals
162         uint public numAccounts;
163 
164         uint public payoutThreshold;                  // no withdrawals less than this amount, to avoid remainders
165         uint public rwGas;                            // reward gas
166         uint public optInXferGas;                     // gas used when optInFromClassic calls xfer on old contract
167         uint public optInFcnMinGas;                   // gas we need for the optInFromClassic fcn, *excluding* optInXferGas
168         uint public vestTime = 1525219201;            // 1 year past sale vest developer tokens
169 
170         SettingStateValue public settingsState;
171 
172 
173         // --------------------
174         // contract constructor
175         // --------------------
176         function E4Lava()
177         {
178                 owner = msg.sender;
179                 developers = msg.sender;
180                 decimals = 2;
181                 symbol = "E4ROW";
182         }
183 
184         // -----------------------------------
185         // use this to reset everything, will never be called after lockRelease
186         // -----------------------------------
187         function applySettings(SettingStateValue qState, uint _threshold, uint _rw, uint _optXferGas, uint _optFcnGas )
188         {
189                 if (msg.sender != owner)
190                         return;
191 
192                 // these settings are permanently tweakable for performance adjustments
193                 payoutThreshold = _threshold;
194                 rwGas = _rw;
195                 optInXferGas = _optXferGas;
196                 optInFcnMinGas = _optFcnGas;
197 
198                 // this first test checks if already locked
199                 if (settingsState == SettingStateValue.lockedRelease)
200                         return;
201 
202                 settingsState = qState;
203 
204                 // this second test allows locking without changing other permanent settings
205                 // WARNING, MAKE SURE YOUR'RE HAPPY WITH ALL SETTINGS
206                 // BEFORE LOCKING
207 
208                 if (qState == SettingStateValue.lockedRelease) {
209                         StatEvent("Locking!");
210                         return;
211                 }
212 
213                 // zero out all token holders.
214                 // leave alloced on, leave num accounts
215                 // cant delete them anyways
216 
217                 for (uint i = 0; i < numAccounts; i++ ) {
218                         address a = holderIndexes[i];
219                         if (a != address(0)) {
220                                 holderAccounts[a].tokens = 0;
221                                 holderAccounts[a].currentPoints = 0;
222                                 holderAccounts[a].lastSnapshot = 0;
223                         }
224                 }
225 
226                 numToksSwitchedOver = 0;
227 
228                 if (this.balance > 0) {
229                         if (!owner.call.gas(rwGas).value(this.balance)())
230                                 StatEvent("ERROR!");
231                 }
232                 StatEvent("ok");
233 
234         }
235 
236 
237         // ---------------------------------------------------
238         // allocate a new account by setting alloc to true
239         // add holder index, bump the num accounts
240         // ---------------------------------------------------
241         function addAccount(address _addr) internal  {
242                 holderAccounts[_addr].alloced = true;
243                 holderAccounts[_addr].tokens = 0;
244                 holderAccounts[_addr].currentPoints = 0;
245                 holderAccounts[_addr].lastSnapshot = TotalFeesReceived;
246                 holderIndexes[numAccounts++] = _addr;
247         }
248 
249 
250 // --------------------------------------
251 // BEGIN ERC-20 from StandardToken
252 // --------------------------------------
253 
254         function totalSupply() constant returns (uint256 supply)
255         {
256                 supply = NewTokenSupply;
257         }
258 
259         // ----------------------------
260         // sender transfers tokens to a new acct
261         // do not use this fcn for a token-split transfer from the old token contract!
262         // ----------------------------
263         function transfer(address _to, uint256 _value) returns (bool success)
264         {
265                 if ((msg.sender == developers)
266                         &&  (now < vestTime)) {
267                         //statEvent("Tokens not yet vested.");
268                         return false;
269                 }
270 
271                 //Default assumes totalSupply can't be over max (2^256 - 1).
272                 //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
273                 //Replace the if with this one instead.
274                 //if (holderAccounts[msg.sender].tokens >= _value && balances[_to] + _value > holderAccounts[_to]) {
275                 if (holderAccounts[msg.sender].tokens >= _value && _value > 0) {
276                     //first credit sender with points accrued so far.. must do this before number of held tokens changes
277                     calcCurPointsForAcct(msg.sender);
278                     holderAccounts[msg.sender].tokens -= _value;
279 
280                     if (!holderAccounts[_to].alloced) {
281                         addAccount(_to);
282                     }
283                     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
284                     calcCurPointsForAcct(_to);
285                     holderAccounts[_to].tokens += _value;
286 
287                     Transfer(msg.sender, _to, _value);
288                     return true;
289                 } else {
290                     return false;
291                 }
292         }
293 
294 
295         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
296                 if ((_from == developers)
297                         &&  (now < vestTime)) {
298                         //statEvent("Tokens not yet vested.");
299                         return false;
300                 }
301 
302                 //same as above. Replace this line with the following if you want to protect against wrapping uints.
303                 //if (holderAccounts[_from].tokens >= _value && allowed[_from][msg.sender] >= _value && holderAccounts[_to].tokens + _value > holderAccounts[_to].tokens) {
304                 if (holderAccounts[_from].tokens >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
305 
306                     calcCurPointsForAcct(_from);
307                     holderAccounts[_from].tokens -= _value;
308 
309                     if (!holderAccounts[_to].alloced) {
310                         addAccount(_to);
311                     }
312                     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
313                     calcCurPointsForAcct(_to);
314                     holderAccounts[_to].tokens += _value;
315 
316                     allowed[_from][msg.sender] -= _value;
317                     Transfer(_from, _to, _value);
318                     return true;
319                 } else {
320                     return false;
321                 }
322         }
323 
324 
325         function balanceOf(address _owner) constant returns (uint256 balance) {
326                 balance = holderAccounts[_owner].tokens;
327         }
328 
329         function approve(address _spender, uint256 _value) returns (bool success) {
330                 allowed[msg.sender][_spender] = _value;
331                 Approval(msg.sender, _spender, _value);
332                 return true;
333         }
334 
335         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
336                 return allowed[_owner][_spender];
337         }
338 // ----------------------------------
339 // END ERC20
340 // ----------------------------------
341 
342         // ----------------------------
343         // calc current points for a token holder; that is, points that are due to this token holder for all dividends
344         // received by the contract during the current "period". the period began the last time this fcn was called, at which
345         // time we updated the account's snapshot of the running point count, TotalFeesReceived. during the period the account's
346         // number of tokens must not have changed. so always call this fcn before changing the number of tokens.
347         // ----------------------------
348         function calcCurPointsForAcct(address _acct) internal {
349               holderAccounts[_acct].currentPoints += (TotalFeesReceived - holderAccounts[_acct].lastSnapshot) * holderAccounts[_acct].tokens;
350               holderAccounts[_acct].lastSnapshot = TotalFeesReceived;
351         }
352 
353 
354         // ---------------------------
355         // accept payment from a partner contract
356         // funds sent here are added to TotalFeesReceived
357         // WARNING! DO NOT CALL THIS FUNCTION LEST YOU LOSE YOUR MONEY
358         // ---------------------------
359         function () payable {
360                 holdoverBalance += msg.value;
361                 TotalFeesReceived += msg.value;
362                 StatEventI("Payment", msg.value);
363         }
364 
365         // ---------------------------
366         // one never knows if this will come in handy.
367         // ---------------------------
368         function blackHole() payable {
369                 StatEventI("adjusted", msg.value);
370         }
371 
372         // ----------------------------
373         // sender withdraw entire rewards/dividends
374         // ----------------------------
375         function withdrawDividends() public returns (uint _amount)
376         {
377                 calcCurPointsForAcct(msg.sender);
378 
379                 _amount = holderAccounts[msg.sender].currentPoints / NewTokenSupply;
380                 if (_amount <= payoutThreshold) {
381                         StatEventI("low Balance", _amount);
382                         return;
383                 } else {
384                         if ((msg.sender == developers)
385                                 &&  (now < vestTime)) {
386                                 StatEvent("Tokens not yet vested.");
387                                 _amount = 0;
388                                 return;
389                         }
390 
391                         uint _pointsUsed = _amount * NewTokenSupply;
392                         holderAccounts[msg.sender].currentPoints -= _pointsUsed;
393                         holdoverBalance -= _amount;
394                         if (!msg.sender.call.gas(rwGas).value(_amount)())
395                                 throw;
396                 }
397         }
398 
399         // ----------------------------
400         // allow sender to transfer dividends
401         // ----------------------------
402         function transferDividends(address _to) returns (bool success)
403         {
404                 if ((msg.sender == developers)
405                         &&  (now < vestTime)) {
406                         //statEvent("Tokens not yet vested.");
407                         return false;
408                 }
409                 calcCurPointsForAcct(msg.sender);
410                 if (holderAccounts[msg.sender].currentPoints == 0) {
411                         StatEvent("Zero balance");
412                         return false;
413                 }
414                 if (!holderAccounts[_to].alloced) {
415                         addAccount(_to);
416                 }
417                 calcCurPointsForAcct(_to);
418                 holderAccounts[_to].currentPoints += holderAccounts[msg.sender].currentPoints;
419                 holderAccounts[msg.sender].currentPoints = 0;
420                 StatEvent("Trasnfered Dividends");
421                 return true;
422         }
423 
424 
425 
426         // ----------------------------
427         // set gas for operations
428         // ----------------------------
429         function setOpGas(uint _rw, uint _optXferGas, uint _optFcnGas)
430         {
431                 if (msg.sender != owner && msg.sender != developers) {
432                         //StatEvent("only owner calls");
433                         return;
434                 } else {
435                         rwGas = _rw;
436                         optInXferGas = _optXferGas;
437                         optInFcnMinGas = _optFcnGas;
438                 }
439         }
440 
441 
442         // ----------------------------
443         // check rewards.  pass in address of token holder
444         // ----------------------------
445         function checkDividends(address _addr) constant returns(uint _amount)
446         {
447                 if (holderAccounts[_addr].alloced) {
448                    //don't call calcCurPointsForAcct here, cuz this is a constant fcn
449                    uint _currentPoints = holderAccounts[_addr].currentPoints +
450                         ((TotalFeesReceived - holderAccounts[_addr].lastSnapshot) * holderAccounts[_addr].tokens);
451                    _amount = _currentPoints / NewTokenSupply;
452 
453                 // low balance? let him see it -Etansky
454                   // if (_amount <= payoutThreshold) {
455                   //    _amount = 0;
456                   // }
457 
458                 }
459         }
460 
461 
462 
463         // ----------------------------
464         // swap executor
465         // ----------------------------
466         function changeOwner(address _addr)
467         {
468                 if (msg.sender != owner
469                         || settingsState == SettingStateValue.lockedRelease)
470                          throw;
471                 owner = _addr;
472         }
473 
474         // ----------------------------
475         // set developers account
476         // ----------------------------
477         function setDeveloper(address _addr)
478         {
479                 if (msg.sender != owner
480                         || settingsState == SettingStateValue.lockedRelease)
481                          throw;
482                 developers = _addr;
483         }
484 
485         // ----------------------------
486         // set oldE4 Addresses
487         // ----------------------------
488         function setOldE4(address _oldE4, address _oldE4Recyle)
489         {
490                 if (msg.sender != owner
491                         || settingsState == SettingStateValue.lockedRelease)
492                          throw;
493                 oldE4 = _oldE4;
494                 oldE4RecycleBin = _oldE4Recyle;
495         }
496 
497         // ----------------------------
498         // get account info
499         // ----------------------------
500         function getAccountInfo(address _addr) constant returns(uint _tokens, uint _snapshot, uint _points)
501         {
502                 _tokens = holderAccounts[_addr].tokens;
503                 _snapshot = holderAccounts[_addr].lastSnapshot;
504                 _points = holderAccounts[_addr].currentPoints;
505         }
506 
507 
508         // ----------------------------
509         // DEBUG ONLY - end this contract, suicide to developers
510         // ----------------------------
511         function haraKiri()
512         {
513                 if (settingsState != SettingStateValue.debug)
514                         throw;
515                 if (msg.sender != owner)
516                          throw;
517                 suicide(developers);
518         }
519 
520 
521         // ----------------------------
522         // OPT IN FROM CLASSIC.
523         // All old token holders can opt into this new contract by calling this function.
524         // This "transferFrom"s tokens from the old addresses to the new recycleBin address
525         // which is a new address set up on the old contract.  Afterwhich new tokens
526         // are credited to the old holder.  Also the lastSnapShot is set to 0 then
527         // calcCredited points are called setting up the new signatoree all of his
528         // accrued dividends.
529         // ----------------------------
530         function optInFromClassic() public
531         {
532                 if (oldE4 == address(0)) {
533                         StatEvent("config err");
534                         return;
535                 }
536                 // 1. check balance of msg.sender in old contract.
537                 address nrequester = msg.sender;
538 
539                 // 2. make sure account not already allocd (in fact, it's ok if it's allocd, so long
540                 // as it is empty now. the reason for this check is cuz we are going to credit him with
541                 // dividends, according to his token count, from the begin of time.
542                 if (holderAccounts[nrequester].tokens != 0) {
543                         StatEvent("Account has already has tokens!");
544                         return;
545                 }
546 
547                 // 3. check his tok balance
548                 Token iclassic = Token(oldE4);
549                 uint _toks = iclassic.balanceOf(nrequester);
550                 if (_toks == 0) {
551                         StatEvent("Nothing to do");
552                         return;
553                 }
554 
555                 // must be 100 percent of holdings
556                 if (iclassic.allowance(nrequester, address(this)) < _toks) {
557                         StatEvent("Please approve this contract to transfer");
558                         return;
559                 }
560 
561                 // 4. before we do the transfer, make sure that we have at least enough gas for the
562                 // transfer plus the remainder of this fcn.
563                 if (msg.gas < optInXferGas + optInFcnMinGas)
564                         throw;
565 
566                 // 5. transfer his old toks to recyle bin
567                 iclassic.transferFrom.gas(optInXferGas)(nrequester, oldE4RecycleBin, _toks);
568 
569                 // todo, error check?
570                 if (iclassic.balanceOf(nrequester) == 0) {
571                         // success, add the account, set the tokens, set snapshot to zero
572                         if (!holderAccounts[nrequester].alloced)
573                                 addAccount(nrequester);
574                         holderAccounts[nrequester].tokens = _toks * NewTokensPerOrigToken;
575                         holderAccounts[nrequester].lastSnapshot = 0;
576                         calcCurPointsForAcct(nrequester);
577                         numToksSwitchedOver += _toks;
578                         // no need to decrement points from a "holding account"
579                         // b/c there is no need to keep it.
580                         StatEvent("Success Switched Over");
581                 } else
582                         StatEvent("Transfer Error! please contact Dev team!");
583 
584 
585         }
586 
587 
588 
589 }