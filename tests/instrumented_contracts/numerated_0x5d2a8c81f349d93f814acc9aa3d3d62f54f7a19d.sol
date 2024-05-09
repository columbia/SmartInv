1 //! By Parity Technologies, 2017.
2 //! Released under the Apache Licence 2.
3 
4 pragma solidity ^0.4.15;
5 
6 // ECR20 standard token interface
7 contract Token {
8   event Transfer(address indexed from, address indexed to, uint256 value);
9   event Approval(address indexed owner, address indexed spender, uint256 value);
10 
11   function balanceOf(address _owner) constant returns (uint256 balance);
12   function transfer(address _to, uint256 _value) returns (bool success);
13   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14   function approve(address _spender, uint256 _value) returns (bool success);
15   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
16 }
17 
18 // Owner-specific contract interface
19 contract Owned {
20   event NewOwner(address indexed old, address indexed current);
21 
22   modifier only_owner {
23     require (msg.sender == owner);
24     _;
25   }
26 
27   address public owner = msg.sender;
28 
29   function setOwner(address _new) only_owner {
30     NewOwner(owner, _new);
31     owner = _new;
32   }
33 }
34 
35 /// Stripped down certifier interface.
36 contract Certifier {
37   function certified(address _who) constant returns (bool);
38 }
39 
40 // BasicCoin, ECR20 tokens that all belong to the owner for sending around
41 contract AmberToken is Token, Owned {
42   struct Account {
43     // Balance is always less than or equal totalSupply since totalSupply is increased straight away of when releasing locked tokens.
44     uint balance;
45     mapping (address => uint) allowanceOf;
46 
47     // TokensPerPhase is always less than or equal to totalSupply since anything added to it is UNLOCK_PHASES times lower than added to totalSupply.
48     uint tokensPerPhase;
49     uint nextPhase;
50   }
51 
52   event Minted(address indexed who, uint value);
53   event MintedLocked(address indexed who, uint value);
54 
55   function AmberToken() {}
56 
57   // Mint a certain number of tokens.
58   // _value has to be bounded not to overflow.
59   function mint(address _who, uint _value)
60     only_owner
61     public
62   {
63     accounts[_who].balance += _value;
64     totalSupply += _value;
65     Minted(_who, _value);
66   }
67 
68   // Mint a certain number of tokens that are locked up.
69   // _value has to be bounded not to overflow.
70   function mintLocked(address _who, uint _value)
71     only_owner
72     public
73   {
74     accounts[_who].tokensPerPhase += _value / UNLOCK_PHASES;
75     totalSupply += _value;
76     MintedLocked(_who, _value);
77   }
78 
79   /// Finalise any minting operations. Resets the owner and causes normal tokens
80   /// to be liquid. Also begins the countdown for locked-up tokens.
81   function finalise()
82     only_owner
83     public
84   {
85     locked = false;
86     owner = 0;
87     phaseStart = now;
88   }
89 
90   /// Return the current unlock-phase. Won't work until after the contract
91   /// has `finalise()` called.
92   function currentPhase()
93     public
94     constant
95     returns (uint)
96   {
97     require (phaseStart > 0);
98     uint p = (now - phaseStart) / PHASE_DURATION;
99     return p > UNLOCK_PHASES ? UNLOCK_PHASES : p;
100   }
101 
102   /// Unlock any now freeable tokens that are locked up for account `_who`.
103   function unlockTokens(address _who)
104     public
105   {
106     uint phase = currentPhase();
107     uint tokens = accounts[_who].tokensPerPhase;
108     uint nextPhase = accounts[_who].nextPhase;
109     if (tokens > 0 && phase > nextPhase) {
110       accounts[_who].balance += tokens * (phase - nextPhase);
111       accounts[_who].nextPhase = phase;
112     }
113   }
114 
115   // Transfer tokens between accounts.
116   function transfer(address _to, uint256 _value)
117     when_owns(msg.sender, _value)
118     when_liquid
119     returns (bool)
120   {
121     Transfer(msg.sender, _to, _value);
122     accounts[msg.sender].balance -= _value;
123     accounts[_to].balance += _value;
124 
125     return true;
126   }
127 
128   // Transfer via allowance.
129   function transferFrom(address _from, address _to, uint256 _value)
130     when_owns(_from, _value)
131     when_has_allowance(_from, msg.sender, _value)
132     when_liquid
133     returns (bool)
134   {
135     Transfer(_from, _to, _value);
136     accounts[_from].allowanceOf[msg.sender] -= _value;
137     accounts[_from].balance -= _value;
138     accounts[_to].balance += _value;
139 
140     return true;
141   }
142 
143   // Approve allowances
144   function approve(address _spender, uint256 _value)
145     when_liquid
146     returns (bool)
147   {
148     // Mitigate the race condition described here:
149     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150     require (_value == 0 || accounts[msg.sender].allowanceOf[_spender] == 0);
151     Approval(msg.sender, _spender, _value);
152     accounts[msg.sender].allowanceOf[_spender] = _value;
153 
154     return true;
155   }
156 
157   // Get the balance of a specific address.
158   function balanceOf(address _who) constant returns (uint256) {
159     return accounts[_who].balance;
160   }
161 
162   // Available allowance
163   function allowance(address _owner, address _spender)
164     constant
165     returns (uint256)
166   {
167     return accounts[_owner].allowanceOf[_spender];
168   }
169 
170   // The balance should be available
171   modifier when_owns(address _owner, uint _amount) {
172     require (accounts[_owner].balance >= _amount);
173     _;
174   }
175 
176   // An allowance should be available
177   modifier when_has_allowance(address _owner, address _spender, uint _amount) {
178     require (accounts[_owner].allowanceOf[_spender] >= _amount);
179     _;
180   }
181 
182   // Tokens must not be locked.
183   modifier when_liquid {
184     require (!locked);
185     _;
186   }
187 
188   /// Usual token descriptors.
189   string constant public name = "Amber Token";
190   uint8 constant public decimals = 18;
191   string constant public symbol = "AMB";
192 
193   // Are the tokens non-transferrable?
194   bool public locked = true;
195 
196   // Phase information for slow-release tokens.
197   uint public phaseStart = 0;
198   uint public constant PHASE_DURATION = 180 days;
199   uint public constant UNLOCK_PHASES = 4;
200 
201   // available token supply
202   uint public totalSupply;
203 
204   // storage and mapping of all balances & allowances
205   mapping (address => Account) accounts;
206 }
207 
208 /// Will accept Ether "contributions" and record each both as a log and in a
209 /// queryable record.
210 contract AmbrosusSale {
211   /// Constructor.
212   function AmbrosusSale() {
213     tokens = new AmberToken();
214     tokens.mint(0x00C269e9D02188E39C9922386De631c6AED5b4d4, 144590975014280560863612000);
215     saleRevenue += 144590975014280560863612000;
216     totalSold += 144590975014280560863612000;
217 
218   }
219 
220   // Can only be called by the administrator.
221   modifier only_admin { require (msg.sender == ADMINISTRATOR); _; }
222   // Can only be called by the prepurchaser.
223   modifier only_prepurchaser { require (msg.sender == PREPURCHASER); _; }
224 
225   // The transaction params are valid for buying in.
226   modifier is_valid_buyin { require (tx.gasprice <= MAX_BUYIN_GAS_PRICE && msg.value >= MIN_BUYIN_VALUE); _; }
227   // Requires the hard cap to be respected given the desired amount for `buyin`.
228   modifier is_under_cap_with(uint buyin) { require (buyin + saleRevenue <= MAX_REVENUE); _; }
229   // Requires sender to be certified.
230   modifier only_certified(address who) { require (CERTIFIER.certified(who)); _; }
231 
232   /*
233     Sale life cycle:
234     1. Not yet started.
235     2. Started, further purchases possible.
236       a. Normal operation (next step can be 2b or 3)
237       b. Paused (next step can be 2a or 3)
238     3. Complete (equivalent to Allocation Lifecycle 2 & 3).
239   */
240 
241   // Can only be called by prior to the period (1).
242   modifier only_before_period { require (now < BEGIN_TIME); _; }
243   // Can only be called during the period when not paused (2a).
244   modifier only_during_period { require (now >= BEGIN_TIME && now < END_TIME && !isPaused); _; }
245   // Can only be called during the period when paused (2b)
246   modifier only_during_paused_period { require (now >= BEGIN_TIME && now < END_TIME && isPaused); _; }
247   // Can only be called after the period (3).
248   modifier only_after_sale { require (now >= END_TIME || saleRevenue >= MAX_REVENUE); _; }
249 
250   /*
251     Allocation life cycle:
252     1. Uninitialised (sale not yet started/ended, equivalent to Sale Lifecycle 1 & 2).
253     2. Initialised, not yet completed (further allocations possible).
254     3. Completed (no further allocations possible).
255   */
256 
257   // Only when allocations have not yet been initialised (1).
258   modifier when_allocations_uninitialised { require (!allocationsInitialised); _; }
259   // Only when sufficient allocations remain for making this liquid allocation (2).
260   modifier when_allocatable_liquid(uint amount) { require (liquidAllocatable >= amount); _; }
261   // Only when sufficient allocations remain for making this locked allocation (2).
262   modifier when_allocatable_locked(uint amount) { require (lockedAllocatable >= amount); _; }
263   // Only when no further allocations are possible (3).
264   modifier when_allocations_complete { require (allocationsInitialised && liquidAllocatable == 0 && lockedAllocatable == 0); _; }
265 
266   /// Note a pre-ICO sale.
267   event Prepurchased(address indexed recipient, uint etherPaid, uint amberSold);
268   /// Some contribution `amount` received from `recipient`.
269   event Purchased(address indexed recipient, uint amount);
270   /// Some contribution `amount` received from `recipient`.
271   event SpecialPurchased(address indexed recipient, uint etherPaid, uint amberSold);
272   /// Period paused abnormally.
273   event Paused();
274   /// Period restarted after abnormal halt.
275   event Unpaused();
276   /// Some contribution `amount` received from `recipient`.
277   event Allocated(address indexed recipient, uint amount, bool liquid);
278 
279   /// Note a prepurchase that has already happened.
280   /// Up to owner to ensure that values do not overflow.
281   ///
282   /// Preconditions: !sale_started
283   /// Writes {Tokens, Sale}
284   function notePrepurchase(address _who, uint _etherPaid, uint _amberSold)
285     only_prepurchaser
286     only_before_period
287     public
288   {
289     // Admin ensures bounded value.
290     tokens.mint(_who, _amberSold);
291     saleRevenue += _etherPaid;
292     totalSold += _amberSold;
293     Prepurchased(_who, _etherPaid, _amberSold);
294   }
295 
296   /// Make a purchase from a privileged account. No KYC is required and a
297   /// preferential buyin rate may be given.
298   ///
299   /// Preconditions: !paused, sale_ongoing
300   /// Postconditions: !paused, ?!sale_ongoing
301   /// Writes {Tokens, Sale}
302   function specialPurchase()
303     only_before_period
304     is_under_cap_with(msg.value)
305     payable
306     public
307   {
308     uint256 bought = buyinReturn(msg.sender) * msg.value;
309     require (bought > 0);   // be kind and don't punish the idiots.
310 
311     // Bounded value, see STANDARD_BUYIN.
312     tokens.mint(msg.sender, bought);
313     TREASURY.transfer(msg.value);
314     saleRevenue += msg.value;
315     totalSold += bought;
316     SpecialPurchased(msg.sender, msg.value, bought);
317    }
318 
319   /// Let sender make a purchase to their account.
320   ///
321   /// Preconditions: !paused, sale_ongoing
322   /// Postconditions: ?!sale_ongoing
323   /// Writes {Tokens, Sale}
324   function ()
325     only_certified(msg.sender)
326     payable
327     public
328   {
329     processPurchase(msg.sender);
330   }
331 
332   /// Let sender make a standard purchase; AMB goes into another account.
333   ///
334   /// Preconditions: !paused, sale_ongoing
335   /// Postconditions: ?!sale_ongoing
336   /// Writes {Tokens, Sale}
337   function purchaseTo(address _recipient)
338     only_certified(msg.sender)
339     payable
340     public
341   {
342     processPurchase(_recipient);
343   }
344 
345   /// Receive a contribution from `_recipient`.
346   ///
347   /// Preconditions: !paused, sale_ongoing
348   /// Postconditions: ?!sale_ongoing
349   /// Writes {Tokens, Sale}
350   function processPurchase(address _recipient)
351     only_during_period
352     is_valid_buyin
353     is_under_cap_with(msg.value)
354     private
355   {
356     // Bounded value, see STANDARD_BUYIN.
357     tokens.mint(_recipient, msg.value * STANDARD_BUYIN);
358     TREASURY.transfer(msg.value);
359     saleRevenue += msg.value;
360     totalSold += msg.value * STANDARD_BUYIN;
361     Purchased(_recipient, msg.value);
362   }
363 
364   /// Determine purchase price for a given address.
365   function buyinReturn(address _who)
366     constant
367     public
368     returns (uint)
369   {
370     // Chinese exchanges.
371     if (
372       _who == CHINESE_EXCHANGE_1 || _who == CHINESE_EXCHANGE_2 ||
373       _who == CHINESE_EXCHANGE_3 || _who == CHINESE_EXCHANGE_4
374     )
375       return CHINESE_EXCHANGE_BUYIN;
376 
377     // BTCSuisse tier 1
378     if (_who == BTC_SUISSE_TIER_1)
379       return STANDARD_BUYIN;
380     // BTCSuisse tier 2
381     if (_who == BTC_SUISSE_TIER_2)
382       return TIER_2_BUYIN;
383     // BTCSuisse tier 3
384     if (_who == BTC_SUISSE_TIER_3)
385       return TIER_3_BUYIN;
386     // BTCSuisse tier 4
387     if (_who == BTC_SUISSE_TIER_4)
388       return TIER_4_BUYIN;
389 
390     return 0;
391   }
392 
393   /// Halt the contribution period. Any attempt at contributing will fail.
394   ///
395   /// Preconditions: !paused, sale_ongoing
396   /// Postconditions: paused
397   /// Writes {Paused}
398   function pause()
399     only_admin
400     only_during_period
401     public
402   {
403     isPaused = true;
404     Paused();
405   }
406 
407   /// Unhalt the contribution period.
408   ///
409   /// Preconditions: paused
410   /// Postconditions: !paused
411   /// Writes {Paused}
412   function unpause()
413     only_admin
414     only_during_paused_period
415     public
416   {
417     isPaused = false;
418     Unpaused();
419   }
420 
421   /// Called once by anybody after the sale ends.
422   /// Initialises the specific values (i.e. absolute token quantities) of the
423   /// allowed liquid/locked allocations.
424   ///
425   /// Preconditions: !allocations_initialised
426   /// Postconditions: allocations_initialised, !allocations_complete
427   /// Writes {Allocations}
428   function initialiseAllocations()
429     public
430     only_after_sale
431     when_allocations_uninitialised
432   {
433     allocationsInitialised = true;
434     liquidAllocatable = LIQUID_ALLOCATION_PPM * totalSold / SALES_ALLOCATION_PPM;
435     lockedAllocatable = LOCKED_ALLOCATION_PPM * totalSold / SALES_ALLOCATION_PPM;
436   }
437 
438   /// Preallocate a liquid portion of tokens.
439   /// Admin may call this to allocate a share of the liquid tokens.
440   /// Up to admin to ensure that value does not overflow.
441   ///
442   /// Preconditions: allocations_initialised
443   /// Postconditions: ?allocations_complete
444   /// Writes {Allocations, Tokens}
445   function allocateLiquid(address _who, uint _value)
446     only_admin
447     when_allocatable_liquid(_value)
448     public
449   {
450     // Admin ensures bounded value.
451     tokens.mint(_who, _value);
452     liquidAllocatable -= _value;
453     Allocated(_who, _value, true);
454   }
455 
456   /// Preallocate a locked-up portion of tokens.
457   /// Admin may call this to allocate a share of the locked tokens.
458   /// Up to admin to ensure that value does not overflow and _value is divisible by UNLOCK_PHASES.
459   ///
460   /// Preconditions: allocations_initialised
461   /// Postconditions: ?allocations_complete
462   /// Writes {Allocations, Tokens}
463   function allocateLocked(address _who, uint _value)
464     only_admin
465     when_allocatable_locked(_value)
466     public
467   {
468     // Admin ensures bounded value.
469     tokens.mintLocked(_who, _value);
470     lockedAllocatable -= _value;
471     Allocated(_who, _value, false);
472   }
473 
474   /// End of the sale and token allocation; retire this contract.
475   /// Once called, no more tokens can be minted, basic tokens are now liquid.
476   /// Anyone can call, but only once this contract can properly be retired.
477   ///
478   /// Preconditions: allocations_complete
479   /// Postconditions: liquid_tokens_transferable, this_is_dead
480   /// Writes {Tokens}
481   function finalise()
482     when_allocations_complete
483     public
484   {
485     tokens.finalise();
486   }
487 
488   //////
489   // STATE
490   //////
491 
492   // How much is enough?
493   uint public constant MIN_BUYIN_VALUE = 10000000000000000;
494   // Max gas price for buyins.
495   uint public constant MAX_BUYIN_GAS_PRICE = 25000000000;
496   // The exposed hard cap.
497   uint public constant MAX_REVENUE = 425203 ether;
498 
499   // The total share of tokens, expressed in PPM, allocated to pre-ICO and ICO.
500   uint constant public SALES_ALLOCATION_PPM = 400000;
501   // The total share of tokens, expressed in PPM, the admin may later allocate, as locked tokens.
502   uint constant public LOCKED_ALLOCATION_PPM = 337000;
503   // The total share of tokens, expressed in PPM, the admin may later allocate, as liquid tokens.
504   uint constant public LIQUID_ALLOCATION_PPM = 263000;
505 
506   /// The certifier resource. TODO: set address
507   Certifier public constant CERTIFIER = Certifier(0x7b1Ab331546F021A40bd4D09fFb802261CaACcc9);
508   // Who can halt/unhalt/kill?
509   address public constant ADMINISTRATOR = 0x11bf17b890a80080a8f9c1673d2951296a6f3d91;
510   // Who can prepurchase?
511   address public constant PREPURCHASER = 0x00D426e9F24E0F426706A1aBf96E375014684C78;
512   // Who gets the stash? Should not release funds during minting process.
513   address public constant TREASURY = 0x00D426e9F24E0F426706A1aBf96E375014684C78;
514   // When does the contribution period begin?
515   uint public constant BEGIN_TIME = 1505779200;
516   // How long does the sale last for?
517   uint public constant DURATION = 30 days;
518   // When does the period end?
519   uint public constant END_TIME = BEGIN_TIME + DURATION;
520 
521   // The privileged buyin accounts.
522   address public constant BTC_SUISSE_TIER_1 = 0x53B3D4f98fcb6f0920096fe1cCCa0E4327Da7a1D;
523   address public constant BTC_SUISSE_TIER_2 = 0x642fDd12b1Dd27b9E19758F0AefC072dae7Ab996;
524   address public constant BTC_SUISSE_TIER_3 = 0x64175446A1e3459c3E9D650ec26420BA90060d28;
525   address public constant BTC_SUISSE_TIER_4 = 0xB17C2f9a057a2640309e41358a22Cf00f8B51626;
526   address public constant CHINESE_EXCHANGE_1 = 0x36f548fAB37Fcd39cA8725B8fA214fcd784FE0A3;
527   address public constant CHINESE_EXCHANGE_2 = 0x877Da872D223AB3D073Ab6f9B4bb27540E387C5F;
528   address public constant CHINESE_EXCHANGE_3 = 0xCcC088ec38A4dbc15Ba269A176883F6ba302eD8d;
529   // TODO: set address
530   address public constant CHINESE_EXCHANGE_4 = 0;
531 
532   // Tokens per eth for the various buy-in rates.
533   // 1e8 ETH in existence, means at most 1.5e11 issued.
534   uint public constant STANDARD_BUYIN = 1000;
535   uint public constant TIER_2_BUYIN = 1111;
536   uint public constant TIER_3_BUYIN = 1250;
537   uint public constant TIER_4_BUYIN = 1429;
538   uint public constant CHINESE_EXCHANGE_BUYIN = 1087;
539 
540   //////
541   // State Subset: Allocations
542   //
543   // Invariants:
544   // !allocationsInitialised ||
545   //   (liquidAllocatable + tokens.liquidAllocated) / LIQUID_ALLOCATION_PPM == totalSold / SALES_ALLOCATION_PPM &&
546   //   (lockedAllocatable + tokens.lockedAllocated) / LOCKED_ALLOCATION_PPM == totalSold / SALES_ALLOCATION_PPM
547   //
548   // when_allocations_complete || (now < END_TIME && saleRevenue < MAX_REVENUE)
549 
550   // Have post-sale token allocations been initialised?
551   bool public allocationsInitialised = false;
552   // How many liquid tokens may yet be allocated?
553   uint public liquidAllocatable;
554   // How many locked tokens may yet be allocated?
555   uint public lockedAllocatable;
556 
557   //////
558   // State Subset: Sale
559   //
560   // Invariants:
561   // saleRevenue <= MAX_REVENUE
562 
563   // Total amount raised in both presale and sale, in Wei.
564   // Assuming TREASURY locks funds, so can not exceed total amount of Ether 1e8.
565   uint public saleRevenue = 0;
566   // Total amount minted in both presale and sale, in AMB * 10^-18.
567   // Assuming the TREASURY locks funds, msg.value * STANDARD_BUYIN will be less than 1.5e11.
568   uint public totalSold = 0;
569 
570   //////
571   // State Subset: Tokens
572 
573   // The contract which gets called whenever anything is received.
574   AmberToken public tokens;
575 
576   //////
577   // State Subset: Pause
578 
579   // Are contributions abnormally paused?
580   bool public isPaused = false;
581 }