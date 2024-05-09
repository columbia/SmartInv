1 pragma solidity ^0.4.11;                                                                                                           
2                                                                                                                                    
3 // VERSION LAVA(J)                                                                                                                 
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
227                 holdoverBalance = 0;
228                 TotalFeesReceived = 0;
229 
230                 if (this.balance > 0) {
231                         if (!owner.call.gas(rwGas).value(this.balance)())
232                                 StatEvent("ERROR!");
233                 }
234                 StatEvent("ok");
235 
236         }
237 
238 
239         // ---------------------------------------------------
240         // allocate a new account by setting alloc to true
241         // add holder index, bump the num accounts
242         // ---------------------------------------------------
243         function addAccount(address _addr) internal  {
244                 holderAccounts[_addr].alloced = true;
245                 holderAccounts[_addr].tokens = 0;
246                 holderAccounts[_addr].currentPoints = 0;
247                 holderAccounts[_addr].lastSnapshot = TotalFeesReceived;
248                 holderIndexes[numAccounts++] = _addr;
249         }
250 
251 
252 // --------------------------------------
253 // BEGIN ERC-20 from StandardToken
254 // --------------------------------------
255 
256         function totalSupply() constant returns (uint256 supply)
257         {
258                 supply = NewTokenSupply;
259         }
260 
261         // ----------------------------
262         // sender transfers tokens to a new acct
263         // do not use this fcn for a token-split transfer from the old token contract!
264         // ----------------------------
265         function transfer(address _to, uint256 _value) returns (bool success)
266         {
267                 if ((msg.sender == developers)
268                         &&  (now < vestTime)) {
269                         //statEvent("Tokens not yet vested.");
270                         return false;
271                 }
272 
273                 //Default assumes totalSupply can't be over max (2^256 - 1).
274                 //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
275                 //Replace the if with this one instead.
276                 //if (holderAccounts[msg.sender].tokens >= _value && balances[_to] + _value > holderAccounts[_to]) {
277                 if (holderAccounts[msg.sender].tokens >= _value && _value > 0) {
278                     //first credit sender with points accrued so far.. must do this before number of held tokens changes
279                     calcCurPointsForAcct(msg.sender);
280                     holderAccounts[msg.sender].tokens -= _value;
281 
282                     if (!holderAccounts[_to].alloced) {
283                         addAccount(_to);
284                     }
285                     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
286                     calcCurPointsForAcct(_to);
287                     holderAccounts[_to].tokens += _value;
288 
289                     Transfer(msg.sender, _to, _value);
290                     return true;
291                 } else {
292                     return false;
293                 }
294         }
295 
296 
297         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
298                 if ((_from == developers)
299                         &&  (now < vestTime)) {
300                         //statEvent("Tokens not yet vested.");
301                         return false;
302                 }
303 
304                 //same as above. Replace this line with the following if you want to protect against wrapping uints.
305                 //if (holderAccounts[_from].tokens >= _value && allowed[_from][msg.sender] >= _value && holderAccounts[_to].tokens + _value > holderAccounts[_to].tokens) {
306                 if (holderAccounts[_from].tokens >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
307 
308                     calcCurPointsForAcct(_from);
309                     holderAccounts[_from].tokens -= _value;
310 
311                     if (!holderAccounts[_to].alloced) {
312                         addAccount(_to);
313                     }
314                     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
315                     calcCurPointsForAcct(_to);
316                     holderAccounts[_to].tokens += _value;
317 
318                     allowed[_from][msg.sender] -= _value;
319                     Transfer(_from, _to, _value);
320                     return true;
321                 } else {
322                     return false;
323                 }
324         }
325 
326 
327         function balanceOf(address _owner) constant returns (uint256 balance) {
328                 balance = holderAccounts[_owner].tokens;
329         }
330 
331         function approve(address _spender, uint256 _value) returns (bool success) {
332                 allowed[msg.sender][_spender] = _value;
333                 Approval(msg.sender, _spender, _value);
334                 return true;
335         }
336 
337         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
338                 return allowed[_owner][_spender];
339         }
340 // ----------------------------------
341 // END ERC20
342 // ----------------------------------
343 
344         // ----------------------------
345         // calc current points for a token holder; that is, points that are due to this token holder for all dividends
346         // received by the contract during the current "period". the period began the last time this fcn was called, at which
347         // time we updated the account's snapshot of the running point count, TotalFeesReceived. during the period the account's
348         // number of tokens must not have changed. so always call this fcn before changing the number of tokens.
349         // ----------------------------
350         function calcCurPointsForAcct(address _acct) internal {
351               holderAccounts[_acct].currentPoints += (TotalFeesReceived - holderAccounts[_acct].lastSnapshot) * holderAccounts[_acct].tokens;
352               holderAccounts[_acct].lastSnapshot = TotalFeesReceived;
353         }
354 
355 
356         // ---------------------------
357         // accept payment from a partner contract
358         // funds sent here are added to TotalFeesReceived
359         // WARNING! DO NOT CALL THIS FUNCTION LEST YOU LOSE YOUR MONEY
360         // ---------------------------
361         function () payable {
362                 holdoverBalance += msg.value;
363                 TotalFeesReceived += msg.value;
364                 StatEventI("Payment", msg.value);
365         }
366 
367         // ---------------------------
368         // one never knows if this will come in handy.
369         // ---------------------------
370         function blackHole() payable {
371                 StatEventI("adjusted", msg.value);
372         }
373 
374         // ----------------------------
375         // sender withdraw entire rewards/dividends
376         // ----------------------------
377         function withdrawDividends() public returns (uint _amount)
378         {
379                 calcCurPointsForAcct(msg.sender);
380 
381                 _amount = holderAccounts[msg.sender].currentPoints / NewTokenSupply;
382                 if (_amount <= payoutThreshold) {
383                         StatEventI("low Balance", _amount);
384                         return;
385                 } else {
386                         if ((msg.sender == developers)
387                                 &&  (now < vestTime)) {
388                                 StatEvent("Tokens not yet vested.");
389                                 _amount = 0;
390                                 return;
391                         }
392 
393                         uint _pointsUsed = _amount * NewTokenSupply;
394                         holderAccounts[msg.sender].currentPoints -= _pointsUsed;
395                         holdoverBalance -= _amount;
396                         if (!msg.sender.call.gas(rwGas).value(_amount)())
397                                 throw;
398                 }
399         }
400 
401         // ----------------------------
402         // allow sender to transfer dividends
403         // ----------------------------
404         function transferDividends(address _to) returns (bool success)
405         {
406                 if ((msg.sender == developers)
407                         &&  (now < vestTime)) {
408                         //statEvent("Tokens not yet vested.");
409                         return false;
410                 }
411                 calcCurPointsForAcct(msg.sender);
412                 if (holderAccounts[msg.sender].currentPoints == 0) {
413                         StatEvent("Zero balance");
414                         return false;
415                 }
416                 if (!holderAccounts[_to].alloced) {
417                         addAccount(_to);
418                 }
419                 calcCurPointsForAcct(_to);
420                 holderAccounts[_to].currentPoints += holderAccounts[msg.sender].currentPoints;
421                 holderAccounts[msg.sender].currentPoints = 0;
422                 StatEvent("Trasnfered Dividends");
423                 return true;
424         }
425 
426 
427 
428         // ----------------------------
429         // set gas for operations
430         // ----------------------------
431         function setOpGas(uint _rw, uint _optXferGas, uint _optFcnGas)
432         {
433                 if (msg.sender != owner && msg.sender != developers) {
434                         //StatEvent("only owner calls");
435                         return;
436                 } else {
437                         rwGas = _rw;
438                         optInXferGas = _optXferGas;
439                         optInFcnMinGas = _optFcnGas;
440                 }
441         }
442 
443 
444         // ----------------------------
445         // check rewards.  pass in address of token holder
446         // ----------------------------
447         function checkDividends(address _addr) constant returns(uint _amount)
448         {
449                 if (holderAccounts[_addr].alloced) {
450                    //don't call calcCurPointsForAcct here, cuz this is a constant fcn
451                    uint _currentPoints = holderAccounts[_addr].currentPoints +
452                         ((TotalFeesReceived - holderAccounts[_addr].lastSnapshot) * holderAccounts[_addr].tokens);
453                    _amount = _currentPoints / NewTokenSupply;
454 
455                 // low balance? let him see it -Etansky
456                   // if (_amount <= payoutThreshold) {
457                   //    _amount = 0;
458                   // }
459 
460                 }
461         }
462 
463 
464 
465         // ----------------------------
466         // swap executor
467         // ----------------------------
468         function changeOwner(address _addr)
469         {
470                 if (msg.sender != owner
471                         || settingsState == SettingStateValue.lockedRelease)
472                          throw;
473                 owner = _addr;
474         }
475 
476         // ----------------------------
477         // set developers account
478         // ----------------------------
479         function setDeveloper(address _addr)
480         {
481                 if (msg.sender != owner
482                         || settingsState == SettingStateValue.lockedRelease)
483                          throw;
484                 developers = _addr;
485         }
486 
487         // ----------------------------
488         // set oldE4 Addresses
489         // ----------------------------
490         function setOldE4(address _oldE4, address _oldE4Recyle)
491         {
492                 if (msg.sender != owner
493                         || settingsState == SettingStateValue.lockedRelease)
494                          throw;
495                 oldE4 = _oldE4;
496                 oldE4RecycleBin = _oldE4Recyle;
497         }
498 
499         // ----------------------------
500         // get account info
501         // ----------------------------
502         function getAccountInfo(address _addr) constant returns(uint _tokens, uint _snapshot, uint _points)
503         {
504                 _tokens = holderAccounts[_addr].tokens;
505                 _snapshot = holderAccounts[_addr].lastSnapshot;
506                 _points = holderAccounts[_addr].currentPoints;
507         }
508 
509 
510         // ----------------------------
511         // DEBUG ONLY - end this contract, suicide to developers
512         // ----------------------------
513         function haraKiri()
514         {
515                 if (settingsState != SettingStateValue.debug)
516                         throw;
517                 if (msg.sender != owner)
518                          throw;
519                 suicide(developers);
520         }
521 
522 
523         // ----------------------------
524         // OPT IN FROM CLASSIC.
525         // All old token holders can opt into this new contract by calling this function.
526         // This "transferFrom"s tokens from the old addresses to the new recycleBin address
527         // which is a new address set up on the old contract.  Afterwhich new tokens
528         // are credited to the old holder.  Also the lastSnapShot is set to 0 then
529         // calcCredited points are called setting up the new signatoree all of his
530         // accrued dividends.
531         // ----------------------------
532         function optInFromClassic() public
533         {
534                 if (oldE4 == address(0)) {
535                         StatEvent("config err");
536                         return;
537                 }
538                 // 1. check balance of msg.sender in old contract.
539                 address nrequester = msg.sender;
540 
541                 // 2. make sure account not already allocd (in fact, it's ok if it's allocd, so long
542                 // as it is empty now. the reason for this check is cuz we are going to credit him with
543                 // dividends, according to his token count, from the begin of time.
544                 if (holderAccounts[nrequester].tokens != 0) {
545                         StatEvent("Account has already has tokens!");
546                         return;
547                 }
548 
549                 // 3. check his tok balance
550                 Token iclassic = Token(oldE4);
551                 uint _toks = iclassic.balanceOf(nrequester);
552                 if (_toks == 0) {
553                         StatEvent("Nothing to do");
554                         return;
555                 }
556 
557                 // must be 100 percent of holdings
558                 if (iclassic.allowance(nrequester, address(this)) < _toks) {
559                         StatEvent("Please approve this contract to transfer");
560                         return;
561                 }
562 
563                 // 4. before we do the transfer, make sure that we have at least enough gas for the
564                 // transfer plus the remainder of this fcn.
565                 if (msg.gas < optInXferGas + optInFcnMinGas)
566                         throw;
567 
568                 // 5. transfer his old toks to recyle bin
569                 iclassic.transferFrom.gas(optInXferGas)(nrequester, oldE4RecycleBin, _toks);
570 
571                 // todo, error check?
572                 if (iclassic.balanceOf(nrequester) == 0) {
573                         // success, add the account, set the tokens, set snapshot to zero
574                         if (!holderAccounts[nrequester].alloced)
575                                 addAccount(nrequester);
576                         holderAccounts[nrequester].tokens = _toks * NewTokensPerOrigToken;
577                         holderAccounts[nrequester].lastSnapshot = 0;
578                         calcCurPointsForAcct(nrequester);
579                         numToksSwitchedOver += _toks;
580                         // no need to decrement points from a "holding account"
581                         // b/c there is no need to keep it.
582                         StatEvent("Success Switched Over");
583                 } else
584                         StatEvent("Transfer Error! please contact Dev team!");
585 
586 
587         }
588 
589 
590 
591 }