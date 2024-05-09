1 pragma solidity ^0.4.11;
2 
3 // VERSION LAVA(D)
4 
5 // --------------------------
6 // here's how this works:
7 // the current amount of dividends due to each token-holder's  is:
8 //   previous_due + [ p(x) * t(x)/N ] + [ p(x+1) * t(x+1)/N ] + ...
9 //   where p(x) is the x'th payment received by the contract
10 //         t(x) is the number of tokens held by the token-holder at the time of p(x)
11 //         N    is the total number of tokens, which never changes
12 //
13 // assume that t(x) takes on 3 values, t(a), t(b) and t(c), during periods a, b, and c. then:
14 // factoring:
15 //   current_due = { (t(a) * [p(x) + p(x+1)] ...) +
16 //                   (t(b) * [p(y) + p(y+1)] ...) +
17 //                   (t(c) * [p(z) + p(z+1)] ...) } / N
18 //
19 // or
20 //
21 //   current_due = { (t(a) * period_a_fees) +
22 //                   (t(b) * period_b_fees) +
23 //                   (t(c) * period_c_fees) } / N
24 //
25 // if we designate current_due * N as current-points, then
26 //
27 //   currentPoints = {  (t(a) * period_a_fees) +
28 //                      (t(b) * period_b_fees) +
29 //                      (t(c) * period_c_fees) }
30 //
31 // or more succictly, if we recompute current points before a token-holder's number of
32 // tokens, T, is about to change:
33 //
34 //   currentPoints = previous_points + (T * current-period-fees)
35 //
36 // when we want to do a payout, we'll calculate:
37 //  current_due = current-points / N
38 //
39 // we'll keep track of a token-holder's current-period-points, which is:
40 //   T * current-period-fees
41 // by taking a snapshot of fees collected exactly when the current period began; that is, the when the
42 // number of tokens last changed. that is, we keep a running count of total fees received
43 //
44 //   TotalFeesReceived = p(x) + p(x+1) + p(x+2)
45 //
46 // (which happily is the same for all token holders) then, before any token holder changes their number of
47 // tokens we compute (for that token holder):
48 //
49 //  function calcCurPointsForAcct(acct) {
50 //    currentPoints[acct] += (TotalFeesReceived - lastSnapshot[acct]) * T[acct]
51 //    lastSnapshot[acct] = TotalFeesReceived
52 //  }
53 //
54 // in the withdraw fcn, all we need is:
55 //
56 //  function withdraw(acct) {
57 //    calcCurPointsForAcct(acct);
58 //    current_amount_due = currentPoints[acct] / N
59 //    currentPoints[acct] = 0;
60 //    send(current_amount_due);
61 //  }
62 //
63 //
64 // special provisions for transfers from the old e4row contract (token-split transfers)
65 // -------------------------------------------------------------------------------------
66 // normally when a new acct is created, eg cuz tokens are transferred from one acct to another, we first call
67 // calcCurPointsForAcct(acct) on the old acct; on the new acct we set:
68 //  currentPoints[acct] = 0;
69 //  lastSnapshot[acct] = TotalFeesReceived;
70 //
71 // this starts the new account with no credits for any dividends that have been collected so far, which is what
72 // you would generally want. however, there is a case in which tokens are transferred from the old e4row contract.
73 // in that case the tokens were reserved on this contract all along, and they earn dividends even before they are
74 // assigned to an account. so for token-split transfers:
75 //  currentPoints[acct] = 0;
76 //  lastSnapshot[acct] = 0;
77 //
78 // then immediately call calcCurPointsForAcct(acct) for the new token-split account. he will get credit
79 // for all the accumulated points, from the beginning of time.
80 //
81 // --------------------------
82 
83 
84 // Abstract contract for the full ERC 20 Token standard
85 // https://github.com/ethereum/EIPs/issues/20
86 
87 // ---------------------------------
88 // ABSTRACT standard token class
89 // ---------------------------------
90 contract Token { 
91     function totalSupply() constant returns (uint256 supply);
92     function balanceOf(address _owner) constant returns (uint256 balance);
93     function transfer(address _to, uint256 _value) returns (bool success);
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
95     function approve(address _spender, uint256 _value) returns (bool success);
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
97 
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 
103 // --------------------------
104 //  E4RowRewards - abstract e4 dividend contract
105 // --------------------------
106 contract E4LavaRewards
107 {
108         function checkDividends(address _addr) constant returns(uint _amount);
109         function withdrawDividends() public returns (uint namount);
110         function transferDividends(address _to) returns (bool success);
111 
112 }
113 
114 // --------------------------
115 //  E4ROW (LAVA) - token contract
116 // --------------------------
117 contract E4Lava is Token, E4LavaRewards {
118         event StatEvent(string msg);
119         event StatEventI(string msg, uint val);
120 
121         enum SettingStateValue  {debug, lockedRelease}
122 
123         struct tokenAccount {
124                 bool alloced;       // flag to ascert prior allocation
125                 uint tokens;        // num tokens currently held in this acct
126                 uint currentPoints; // updated before token balance changes, or before a withdrawal. credit for owning tokens
127                 uint lastSnapshot;  // snapshot of global TotalPoints, last time we updated this acct's currentPoints
128         }
129 
130 // -----------------------------
131 //  data storage
132 // ----------------------------------------
133         uint constant NumOrigTokens         = 5762;   // number of old tokens, from original token contract
134         uint constant NewTokensPerOrigToken = 100000; // how many new tokens are created for each from original token
135         uint constant NewTokenSupply        = 5762 * 100000;
136         uint public numToksSwitchedOver;              // count old tokens that have been converted
137         uint public holdoverBalance;                  // funds received, but not yet distributed
138         uint public TotalFeesReceived;                // total fees received from partner contract(s)
139 
140         address public developers;                    // developers token holding address
141         address public owner;                         // deployer executor
142         address public oldE4;                         // addr of old e4 token contract
143         address public oldE4RecycleBin;  // addr to transfer old tokens
144 
145         uint public decimals;
146         string public symbol;
147 
148         mapping (address => tokenAccount) holderAccounts;          // who holds how many tokens (high two bytes contain curPayId)
149         mapping (uint => address) holderIndexes;                   // for iteration thru holder
150         mapping (address => mapping (address => uint256)) allowed; // approvals
151         uint public numAccounts;
152 
153         uint public payoutThreshold;                  // no withdrawals less than this amount, to avoid remainders
154         uint public vestTime;                         // 1 year past sale vest developer tokens
155         uint public rwGas;                            // reward gas
156         uint public optInGas;
157 
158         SettingStateValue public settingsState;
159 
160 
161         // --------------------
162         // contract constructor
163         // --------------------
164         function E4Lava() 
165         {
166                 owner = msg.sender;
167                 developers = msg.sender;
168                 decimals = 2;
169                 symbol = "E4ROW";
170         }
171 
172         // -----------------------------------
173         // use this to reset everything, will never be called after lockRelease
174         // -----------------------------------
175         function applySettings(SettingStateValue qState, uint _threshold, uint _vest, uint _rw, uint _optGas )
176         {
177                 if (msg.sender != owner) 
178                         return;
179 
180                 // these settings are permanently tweakable for performance adjustments
181                 payoutThreshold = _threshold;
182                 rwGas = _rw;
183                 optInGas = _optGas;
184 
185                 // this first test checks if already locked
186                 if (settingsState == SettingStateValue.lockedRelease)
187                         return;
188 
189                 settingsState = qState;
190 
191                 // this second test allows locking without changing other permanent settings
192                 // WARNING, MAKE SURE YOUR'RE HAPPY WITH ALL SETTINGS 
193                 // BEFORE LOCKING
194 
195                 if (qState == SettingStateValue.lockedRelease) {
196                         StatEvent("Locking!");
197                         return;
198                 }
199 
200                 // zero out all token holders.  
201                 // leave alloced on, leave num accounts
202                 // cant delete them anyways
203 
204                 for (uint i = 0; i < numAccounts; i++ ) {
205                         address a = holderIndexes[i];
206                         if (a != address(0)) {
207                                 holderAccounts[a].tokens = 0;
208                                 holderAccounts[a].currentPoints = 0;
209                                 holderAccounts[a].lastSnapshot = 0;
210                         }
211                 }
212 
213                 vestTime = _vest;
214                 numToksSwitchedOver = 0;
215 
216                 if (this.balance > 0) {
217                         if (!owner.call.gas(rwGas).value(this.balance)())
218                                 StatEvent("ERROR!");
219                 }
220                 StatEvent("ok");
221 
222         }
223 
224 
225         // ---------------------------------------------------
226         // allocate a new account by setting alloc to true
227         // add holder index, bump the num accounts
228         // ---------------------------------------------------
229         function addAccount(address _addr) internal  {
230                 holderAccounts[_addr].alloced = true;
231                 holderAccounts[_addr].tokens = 0;
232                 holderAccounts[_addr].currentPoints = 0;
233                 holderAccounts[_addr].lastSnapshot = TotalFeesReceived;
234                 holderIndexes[numAccounts++] = _addr;
235         }
236 
237 
238 // --------------------------------------
239 // BEGIN ERC-20 from StandardToken
240 // --------------------------------------
241 
242         function totalSupply() constant returns (uint256 supply)
243         {
244                 supply = NewTokenSupply;
245         }
246 
247         // ----------------------------
248         // sender transfers tokens to a new acct
249         // do not use this fcn for a token-split transfer from the old token contract!
250         // ----------------------------
251         function transfer(address _to, uint256 _value) returns (bool success) 
252         {
253                 if ((msg.sender == developers) 
254                         &&  (now < vestTime)) {
255                         //statEvent("Tokens not yet vested.");
256                         return false;
257                 }
258 
259                 //Default assumes totalSupply can't be over max (2^256 - 1).
260                 //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
261                 //Replace the if with this one instead.
262                 //if (holderAccounts[msg.sender].tokens >= _value && balances[_to] + _value > holderAccounts[_to]) {
263                 if (holderAccounts[msg.sender].tokens >= _value && _value > 0) {
264                     //first credit sender with points accrued so far.. must do this before number of held tokens changes
265                     calcCurPointsForAcct(msg.sender);
266                     holderAccounts[msg.sender].tokens -= _value;
267                     
268                     if (!holderAccounts[_to].alloced) {
269                         addAccount(_to);
270                     }
271                     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
272                     calcCurPointsForAcct(_to);
273                     holderAccounts[_to].tokens += _value;
274 
275                     Transfer(msg.sender, _to, _value);
276                     return true;
277                 } else { 
278                     return false; 
279                 }
280         }
281 
282 
283         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
284                 if ((_from == developers) 
285                         &&  (now < vestTime)) {
286                         //statEvent("Tokens not yet vested.");
287                         return false;
288                 }
289 
290                 //same as above. Replace this line with the following if you want to protect against wrapping uints.
291                 //if (holderAccounts[_from].tokens >= _value && allowed[_from][msg.sender] >= _value && holderAccounts[_to].tokens + _value > holderAccounts[_to].tokens) {
292                 if (holderAccounts[_from].tokens >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
293 
294                     calcCurPointsForAcct(_from);
295                     holderAccounts[_from].tokens -= _value;
296                     
297                     if (!holderAccounts[_to].alloced) {
298                         addAccount(_to);
299                     }
300                     //credit destination acct with points accrued so far.. must do this before number of held tokens changes
301                     calcCurPointsForAcct(_to);
302                     holderAccounts[_to].tokens += _value;
303 
304                     allowed[_from][msg.sender] -= _value;
305                     Transfer(_from, _to, _value);
306                     return true;
307                 } else { 
308                     return false; 
309                 }
310         }
311 
312 
313         function balanceOf(address _owner) constant returns (uint256 balance) {
314                 balance = holderAccounts[_owner].tokens;
315         }
316 
317         function approve(address _spender, uint256 _value) returns (bool success) {
318                 allowed[msg.sender][_spender] = _value;
319                 Approval(msg.sender, _spender, _value);
320                 return true;
321         }
322 
323         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
324                 return allowed[_owner][_spender];
325         }
326 // ----------------------------------
327 // END ERC20
328 // ----------------------------------
329 
330         // ----------------------------
331         // calc current points for a token holder; that is, points that are due to this token holder for all dividends
332         // received by the contract during the current "period". the period began the last time this fcn was called, at which
333         // time we updated the account's snapshot of the running point count, TotalFeesReceived. during the period the account's
334         // number of tokens must not have changed. so always call this fcn before changing the number of tokens.
335         // ----------------------------
336         function calcCurPointsForAcct(address _acct) {
337               holderAccounts[_acct].currentPoints += (TotalFeesReceived - holderAccounts[_acct].lastSnapshot) * holderAccounts[_acct].tokens;
338               holderAccounts[_acct].lastSnapshot = TotalFeesReceived;
339         }
340 
341 
342         // ---------------------------
343         // accept payment from a partner contract
344         // funds sent here are added to TotalFeesReceived
345         // WARNING! DO NOT CALL THIS FUNCTION LEST YOU LOSE YOUR MONEY
346         // ---------------------------
347         function () payable {
348                 holdoverBalance += msg.value;
349                 TotalFeesReceived += msg.value;
350                 StatEventI("Payment", msg.value);
351         }
352 
353         // ---------------------------
354         // one never knows if this will come in handy.
355         // ---------------------------
356         function blackHole() payable {
357                 StatEventI("adjusted", msg.value);
358         }
359 
360         // ----------------------------
361         // sender withdraw entire rewards/dividends
362         // ----------------------------
363         function withdrawDividends() public returns (uint _amount)
364         {
365                 calcCurPointsForAcct(msg.sender);
366 
367                 _amount = holderAccounts[msg.sender].currentPoints / NewTokenSupply;
368                 if (_amount <= payoutThreshold) {
369                         StatEventI("low Balance", _amount);
370                         return;
371                 } else {
372                         if ((msg.sender == developers) 
373                                 &&  (now < vestTime)) {
374                                 StatEvent("Tokens not yet vested.");
375                                 _amount = 0;
376                                 return;
377                         }
378 
379                         uint _pointsUsed = _amount * NewTokenSupply;
380                         holderAccounts[msg.sender].currentPoints -= _pointsUsed;
381                         holdoverBalance -= _amount;
382                         if (!msg.sender.call.gas(rwGas).value(_amount)())
383                                 throw;
384                 }
385         }
386 
387         // ----------------------------
388         // allow sender to transfer dividends
389         // ----------------------------
390         function transferDividends(address _to) returns (bool success) 
391         {
392                 if ((msg.sender == developers) 
393                         &&  (now < vestTime)) {
394                         //statEvent("Tokens not yet vested.");
395                         return false;
396                 }
397                 calcCurPointsForAcct(msg.sender);
398                 if (holderAccounts[msg.sender].currentPoints == 0) {
399                         StatEvent("Zero balance");
400                         return false;
401                 }
402                 if (!holderAccounts[_to].alloced) {
403                         addAccount(_to);
404                 }
405                 calcCurPointsForAcct(_to);
406                 holderAccounts[_to].currentPoints += holderAccounts[msg.sender].currentPoints;
407                 holderAccounts[msg.sender].currentPoints = 0;
408                 StatEvent("Trasnfered Dividends");
409                 return true;
410         }
411 
412 
413 
414         // ----------------------------
415         // set gas for operations
416         // ----------------------------
417         function setOpGas(uint _rw, uint _optIn)
418         {
419                 if (msg.sender != owner && msg.sender != developers) {
420                         //StatEvent("only owner calls");
421                         return;
422                 } else {
423                         rwGas = _rw;
424                         optInGas = _optIn;
425                 }
426         }
427 
428 
429         // ----------------------------
430         // check rewards.  pass in address of token holder
431         // ----------------------------
432         function checkDividends(address _addr) constant returns(uint _amount)
433         {
434                 if (holderAccounts[_addr].alloced) {
435                    //don't call calcCurPointsForAcct here, cuz this is a constant fcn
436                    uint _currentPoints = holderAccounts[_addr].currentPoints + 
437                         ((TotalFeesReceived - holderAccounts[_addr].lastSnapshot) * holderAccounts[_addr].tokens);
438                    _amount = _currentPoints / NewTokenSupply;
439 
440                 // low balance? let him see it -Etansky
441                   // if (_amount <= payoutThreshold) {
442                   //    _amount = 0;
443                   // }
444 
445                 }
446         }
447 
448 
449 
450         // ----------------------------
451         // swap executor
452         // ----------------------------
453         function changeOwner(address _addr) 
454         {
455                 if (msg.sender != owner
456                         || settingsState == SettingStateValue.lockedRelease)
457                          throw;
458                 owner = _addr;
459         }
460 
461         // ----------------------------
462         // set developers account
463         // ----------------------------
464         function setDeveloper(address _addr) 
465         {
466                 if (msg.sender != owner
467                         || settingsState == SettingStateValue.lockedRelease)
468                          throw;
469                 developers = _addr;
470         }
471 
472         // ----------------------------
473         // set oldE4 Addresses
474         // ----------------------------
475         function setOldE4(address _oldE4, address _oldE4Recyle) 
476         {
477                 if (msg.sender != owner
478                         || settingsState == SettingStateValue.lockedRelease)
479                          throw;
480                 oldE4 = _oldE4;
481                 oldE4RecycleBin = _oldE4Recyle;
482         }
483 
484 
485 
486         // ----------------------------
487         // DEBUG ONLY - end this contract, suicide to developers
488         // ----------------------------
489         function haraKiri()
490         {
491                 if (settingsState != SettingStateValue.debug)
492                         throw;
493                 if (msg.sender != owner)
494                          throw;
495                 suicide(developers);
496         }
497 
498 
499         // ----------------------------
500         // OPT IN FROM CLASSIC.
501         // All old token holders can opt into this new contract by calling this function.
502         // This "transferFrom"s tokens from the old addresses to the new recycleBin address
503         // which is a new address set up on the old contract.  Afterwhich new tokens 
504         // are credited to the old holder.  Also the lastSnapShot is set to 0 then 
505         // calcCredited points are called setting up the new signatoree all of his 
506         // accrued dividends.
507         // ----------------------------
508         function optInFromClassic() public
509         {
510                 if (oldE4 == address(0)) {
511                         StatEvent("config err");
512                         return;
513                 }
514                 // 1. check balance of msg.sender in old contract.
515                 address nrequester = msg.sender;
516 
517                 // 2. make sure account not already allocd (in fact, it's ok if it's allocd, so long
518                 // as it is empty now. the reason for this check is cuz we are going to credit him with
519                 // dividends, according to his token count, from the begin of time.
520                 if (holderAccounts[nrequester].tokens != 0) {
521                         StatEvent("Account has already been allocd!");
522                         return;
523                 }
524 
525                 // 3. check his tok balance
526                 Token iclassic = Token(oldE4);
527                 uint _toks = iclassic.balanceOf(nrequester);
528                 if (_toks == 0) {
529                         StatEvent("Nothing to do");
530                         return;
531                 }
532 
533                 // must be 100 percent of holdings
534                 if (iclassic.allowance(nrequester, address(this)) < _toks) {
535                         StatEvent("Please approve this contract to transfer");
536                         return;
537                 }
538 
539                 // 4, transfer his old toks to recyle bin
540                 iclassic.transferFrom.gas(optInGas)(nrequester, oldE4RecycleBin, _toks);
541 
542                 // todo, error check?
543                 if (iclassic.balanceOf(nrequester) == 0) {
544                         // success, add the account, set the tokens, set snapshot to zero
545                         if (!holderAccounts[nrequester].alloced)
546                                 addAccount(nrequester);
547                         holderAccounts[nrequester].tokens = _toks * NewTokensPerOrigToken;
548                         holderAccounts[nrequester].lastSnapshot = 0;
549                         calcCurPointsForAcct(nrequester);
550                         numToksSwitchedOver += _toks;
551                         // no need to decrement points from a "holding account"
552                         // b/c there is no need to keep it.
553                         StatEvent("Success Switched Over");
554                 } else
555                         StatEvent("Transfer Error! please contact Dev team!");
556 
557 
558         }
559 
560 }