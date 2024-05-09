1 pragma solidity 0.4.15;
2 
3 pragma solidity 0.4.15;
4 
5 /**
6  * @title MultiOwnable
7  * allows creating contracts with up to 16 owners with their shares
8  */
9 contract MultiOwnable {
10     /** a single owner record */
11     struct Owner {
12         address recipient;
13         uint share;
14     }
15 
16     /** contract owners */
17     Owner[] public owners;
18 
19     /**
20      * Returns total owners count
21      * @return count - owners count
22      */
23     function ownersCount ()   constant   returns (uint count) {  
24         return owners.length;
25     }
26 
27     /**
28      * Returns owner's info
29      * @param  idx - index of the owner
30      * @return owner - owner's info
31      */
32     function owner (uint idx)   constant   returns (address owner_dot_recipient, uint owner_dot_share) {  
33 Owner memory owner;
34 
35         owner = owners[idx];
36     owner_dot_recipient = address(owner.recipient);
37 owner_dot_share = uint(owner.share);}
38 
39     /** reverse lookup helper */
40     mapping (address => bool) ownersIdx;
41 
42     /**
43      * Creates the contract with up to 16 owners
44      * shares must be > 0
45      */
46     function MultiOwnable (address[16] _owners_dot_recipient, uint[16] _owners_dot_share)   {  
47 Owner[16] memory _owners;
48 
49 for(uint __recipient_iterator__ = 0; __recipient_iterator__ < _owners_dot_recipient.length;__recipient_iterator__++)
50   _owners[__recipient_iterator__].recipient = address(_owners_dot_recipient[__recipient_iterator__]);
51 for(uint __share_iterator__ = 0; __share_iterator__ < _owners_dot_share.length;__share_iterator__++)
52   _owners[__share_iterator__].share = uint(_owners_dot_share[__share_iterator__]);
53         for(var idx = 0; idx < _owners_dot_recipient.length; idx++) {
54             if(_owners[idx].recipient != 0) {
55                 owners.push(_owners[idx]);
56                 assert(owners[idx].share > 0);
57                 ownersIdx[_owners[idx].recipient] = true;
58             }
59         }
60     }
61 
62     /**
63      * Function with this modifier can be called only by one of owners
64      */
65     modifier onlyOneOfOwners() {
66         require(ownersIdx[msg.sender]);
67         _;
68     }
69 
70 
71 }
72 
73 
74 pragma solidity 0.4.15;
75 
76 pragma solidity 0.4.15;
77 
78 /**
79  * Basic interface for contracts, following ERC20 standard
80  */
81 contract ERC20Token {
82     
83 
84     /**
85      * Triggered when tokens are transferred.
86      * @param from - address tokens were transfered from
87      * @param to - address tokens were transfered to
88      * @param value - amount of tokens transfered
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * Triggered whenever allowance status changes
94      * @param owner - tokens owner, allowance changed for
95      * @param spender - tokens spender, allowance changed for
96      * @param value - new allowance value (overwriting the old value)
97      */
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 
100     /**
101      * Returns total supply of tokens ever emitted
102      * @return totalSupply - total supply of tokens ever emitted
103      */
104     function totalSupply() constant returns (uint256 totalSupply);
105 
106     /**
107      * Returns `owner` balance of tokens
108      * @param owner address to request balance for
109      * @return balance - token balance of `owner`
110      */
111     function balanceOf(address owner) constant returns (uint256 balance);
112 
113     /**
114      * Transfers `amount` of tokens to `to` address
115      * @param  to - address to transfer to
116      * @param  value - amount of tokens to transfer
117      * @return success - `true` if the transfer was succesful, `false` otherwise
118      */
119     function transfer(address to, uint256 value) returns (bool success);
120 
121     /**
122      * Transfers `value` tokens from `from` address to `to`
123      * the sender needs to have allowance for this operation
124      * @param  from - address to take tokens from
125      * @param  to - address to send tokens to
126      * @param  value - amount of tokens to send
127      * @return success - `true` if the transfer was succesful, `false` otherwise
128      */
129     function transferFrom(address from, address to, uint256 value) returns (bool success);
130 
131     /**
132      * Allow spender to withdraw from your account, multiple times, up to the value amount.
133      * If this function is called again it overwrites the current allowance with `value`.
134      * this function is required for some DEX functionality
135      * @param spender - address to give allowance to
136      * @param value - the maximum amount of tokens allowed for spending
137      * @return success - `true` if the allowance was given, `false` otherwise
138      */
139     function approve(address spender, uint256 value) returns (bool success);
140 
141     /**
142      * Returns the amount which `spender` is still allowed to withdraw from `owner`
143      * @param  owner - tokens owner
144      * @param  spender - addres to request allowance for
145      * @return remaining - remaining allowance (token count)
146      */
147     function allowance(address owner, address spender) constant returns (uint256 remaining);
148 }
149 
150 
151 /**
152  * @title Blind Croupier Token
153  * WIN fixed supply Token, used for Blind Croupier TokenDistribution
154  */
155  contract WIN is ERC20Token {
156     
157 
158     string public constant symbol = "WIN";
159     string public constant name = "WIN";
160 
161     uint8 public constant decimals = 7;
162     uint256 constant TOKEN = 10**7;
163     uint256 constant MILLION = 10**6;
164     uint256 public totalTokenSupply = 500 * MILLION * TOKEN;
165 
166     /** balances of each accounts */
167     mapping(address => uint256) balances;
168 
169     /** amount of tokens approved for transfer */
170     mapping(address => mapping (address => uint256)) allowed;
171 
172     /** Triggered when `owner` destroys `amount` tokens */
173     event Destroyed(address indexed owner, uint256 amount);
174 
175     /**
176      * Constucts the token, and supplies the creator with `totalTokenSupply` tokens
177      */
178     function WIN ()   { 
179         balances[msg.sender] = totalTokenSupply;
180     }
181 
182     /**
183      * Returns total supply of tokens ever emitted
184      * @return result - total supply of tokens ever emitted
185      */
186     function totalSupply ()  constant  returns (uint256 result) { 
187         result = totalTokenSupply;
188     }
189 
190     /**
191     * Returns `owner` balance of tokens
192     * @param owner address to request balance for
193     * @return balance - token balance of `owner`
194     */
195     function balanceOf (address owner)  constant  returns (uint256 balance) { 
196         return balances[owner];
197     }
198 
199     /**
200      * Transfers `amount` of tokens to `to` address
201      * @param  to - address to transfer to
202      * @param  amount - amount of tokens to transfer
203      * @return success - `true` if the transfer was succesful, `false` otherwise
204      */
205     function transfer (address to, uint256 amount)   returns (bool success) { 
206         if(balances[msg.sender] < amount)
207             return false;
208 
209         if(amount <= 0)
210             return false;
211 
212         if(balances[to] + amount <= balances[to])
213             return false;
214 
215         balances[msg.sender] -= amount;
216         balances[to] += amount;
217         Transfer(msg.sender, to, amount);
218         return true;
219     }
220 
221     /**
222      * Transfers `amount` tokens from `from` address to `to`
223      * the sender needs to have allowance for this operation
224      * @param  from - address to take tokens from
225      * @param  to - address to send tokens to
226      * @param  amount - amount of tokens to send
227      * @return success - `true` if the transfer was succesful, `false` otherwise
228      */
229     function transferFrom (address from, address to, uint256 amount)   returns (bool success) { 
230         if (balances[from] < amount)
231             return false;
232 
233         if(allowed[from][msg.sender] < amount)
234             return false;
235 
236         if(amount == 0)
237             return false;
238 
239         if(balances[to] + amount <= balances[to])
240             return false;
241 
242         balances[from] -= amount;
243         allowed[from][msg.sender] -= amount;
244         balances[to] += amount;
245         Transfer(from, to, amount);
246         return true;
247     }
248 
249     /**
250      * Allow spender to withdraw from your account, multiple times, up to the amount amount.
251      * If this function is called again it overwrites the current allowance with `amount`.
252      * this function is required for some DEX functionality
253      * @param spender - address to give allowance to
254      * @param amount - the maximum amount of tokens allowed for spending
255      * @return success - `true` if the allowance was given, `false` otherwise
256      */
257     function approve (address spender, uint256 amount)   returns (bool success) { 
258        allowed[msg.sender][spender] = amount;
259        Approval(msg.sender, spender, amount);
260        return true;
261    }
262 
263     /**
264      * Returns the amount which `spender` is still allowed to withdraw from `owner`
265      * @param  owner - tokens owner
266      * @param  spender - addres to request allowance for
267      * @return remaining - remaining allowance (token count)
268      */
269     function allowance (address owner, address spender)  constant  returns (uint256 remaining) { 
270         return allowed[owner][spender];
271     }
272 
273      /**
274       * Destroys `amount` of tokens permanently, they cannot be restored
275       * @return success - `true` if `amount` of tokens were destroyed, `false` otherwise
276       */
277     function destroy (uint256 amount)   returns (bool success) { 
278         if(amount == 0) return false;
279         if(balances[msg.sender] < amount) return false;
280         balances[msg.sender] -= amount;
281         totalTokenSupply -= amount;
282         Destroyed(msg.sender, amount);
283     }
284 }
285 
286 pragma solidity 0.4.15;
287 
288 /**
289  * @title Various Math utilities
290  */
291 library Math {
292      /** 1/1000, 1000 uint = 1 */
293 
294     /**
295      * Returns `promille` promille of `value`
296      * e.g. `takePromille(5000, 1) == 5`
297      * @param value - uint to take promille value
298      * @param promille - promille value
299      * @return result - `value * promille / 1000`
300      */
301     function takePromille (uint value, uint promille)  constant  returns (uint result) { 
302         result = value * promille / 1000;
303     }
304 
305     /**
306      * Returns `value` with added `promille` promille
307      * @param value - uint to add promille to
308      * @param promille - promille value to add
309      * @return result - `value + value * promille / 1000`
310      */
311     function addPromille (uint value, uint promille)  constant  returns (uint result) { 
312         result = value + takePromille(value, promille);
313     }
314 }
315 
316 
317 /**
318  * @title Blind Croupier TokenDistribution
319  * It possesses some `WIN` tokens.
320  * The distribution is divided into many 'periods'.
321  * The zero one is `Presale` with `TOKENS_FOR_PRESALE` tokens
322  * It's ended when all tokens are sold or manually with `endPresale()` function
323  * The length of first period is `FIRST_PERIOD_DURATION`.
324  * The length of other periods is `PERIOD_DURATION`.
325  * During each period, `TOKENS_PER_PERIOD` are offered for sale (`TOKENS_PER_FIRST_PERIOD` for the first one)
326  * Investors send their money to the contract
327  * and call `claimAllTokens()` function to get `WIN` tokens.
328  * Period 0 Token price is `PRESALE_TOKEN_PRICE`
329  * Period 1 Token price is `SALE_INITIAL_TOKEN_PRICE`
330  * Period 2+ price is determined by the following rules:
331  * If more than `TOKENS_TO_INCREASE_NEXT_PRICE * TOKENS_PER_PERIOD / 1000`
332  * were sold during the period, the price of the Tokens for the next period
333  * is increased by `PERIOD_PRICE_INCREASE` promille,
334  * if ALL tokens were sold, price is increased by `FULLY_SOLD_PRICE_INCREASE` promille
335  * Otherwise, the price remains the same.
336  */
337 contract BlindCroupierTokenDistribution is MultiOwnable {
338     
339     
340     
341     
342     
343     
344 
345     uint256 constant TOKEN = 10**7;
346     uint256 constant MILLION = 10**6;
347 
348     uint256 constant MINIMUM_DEPOSIT = 100 finney; /** minimum deposit accepted to bank */
349     uint256 constant PRESALE_TOKEN_PRICE = 0.00035 ether / TOKEN;
350     uint256 constant SALE_INITIAL_TOKEN_PRICE = 0.0005 ether / TOKEN;
351 
352     uint256 constant TOKENS_FOR_PRESALE = 5 * MILLION * TOKEN; /** 5M tokens */
353     uint256 constant TOKENS_PER_FIRST_PERIOD = 15 * MILLION * TOKEN; /** 15M tokens */
354     uint256 constant TOKENS_PER_PERIOD = 1 * MILLION * TOKEN; /** 1M tokens */
355     uint256 constant FIRST_PERIOD_DURATION = 161 hours; /** duration of 1st sale period */
356     uint256 constant PERIOD_DURATION = 23 hours; /** duration of all other sale periods */
357     uint256 constant PERIOD_PRICE_INCREASE = 5; /** `next_token_price = old_token_price + old_token_price * PERIOD_PRICE_INCREASE / 1000` */
358     uint256 constant FULLY_SOLD_PRICE_INCREASE = 10; /** to increase price if ALL tokens sold */
359     uint256 constant TOKENS_TO_INCREASE_NEXT_PRICE = 800; /** the price is increased if `sold_tokens > period_tokens * TOKENS_TO_INCREASE_NEXT_PRICE / 1000` */
360 
361     uint256 constant NEVER = 0;
362     uint16 constant UNKNOWN_COUNTRY = 0;
363 
364     /**
365      * State of Blind Croupier crowdsale
366      */
367     enum State {
368         NotStarted,
369         Presale,
370         Sale
371     }
372 
373     uint256 public totalUnclaimedTokens; /** total amount of tokens, TokenDistribution owns to investors */
374     uint256 public totalTokensSold; /** total amount of Tokens sold during the TokenDistribution */
375     uint256 public totalTokensDestroyed; /** total amount of Tokens destroyed by this contract */
376 
377     mapping(address => uint256) public unclaimedTokensForInvestor; /** unclaimed tokens for each investor */
378 
379     /**
380      * One token sale period information
381      */
382     struct Period {
383         uint256 startTime;
384         uint256 endTime;
385         uint256 tokenPrice;
386         uint256 tokensSold;
387     }
388 
389     /**
390      * Emited when `investor` sends `amount` of money to the Bank
391      * @param investor - address, sending the money
392      * @param amount - Wei sent
393      */
394     event Deposited(address indexed investor, uint256 amount, uint256 tokenCount);
395 
396     /**
397      * Emited when a new period is opened
398      * @param periodIndex - index of new period
399      * @param tokenPrice - price of WIN Token in new period
400      */
401     event PeriodStarted(uint periodIndex, uint256 tokenPrice, uint256 tokensToSale, uint256 startTime, uint256 endTime, uint256 now);
402 
403     /**
404      * Emited when `investor` claims `claimed` tokens
405      * @param investor - address getting the Tokens
406      * @param claimed - amount of Tokens claimed
407      */
408     event TokensClaimed(address indexed investor, uint256 claimed);
409 
410     /** current Token sale period */
411     uint public currentPeriod = 0;
412 
413     /** information about past and current periods, by periods index, starting from `0` */
414     mapping(uint => Period) periods;
415 
416     /** WIN tokens contract  */
417     WIN public win;
418 
419     /** The state of the crowdsale - `NotStarted`, `Presale`, `Sale` */
420     State public state;
421 
422     /** the counter of investment by a country code (3-digit ISO 3166 code) */
423     mapping(uint16 => uint256) investmentsByCountries;
424 
425     /**
426      * Returns amount of Wei invested by the specified country
427      * @param country - 3-digit country code
428      */
429     function getInvestmentsByCountry (uint16 country)   constant   returns (uint256 investment) {  
430         investment = investmentsByCountries[country];
431     }
432 
433     /**
434      * Returns the Token price in the current period
435      * @return tokenPrice - current Token price
436      */
437     function getTokenPrice ()   constant   returns (uint256 tokenPrice) {  
438         tokenPrice = periods[currentPeriod].tokenPrice;
439     }
440 
441     /**
442      * Returns the Token price for the period requested
443      * @param periodIndex - the period index
444      * @return tokenPrice - Token price for the period
445      */
446     function getTokenPriceForPeriod (uint periodIndex)   constant   returns (uint256 tokenPrice) {  
447         tokenPrice = periods[periodIndex].tokenPrice;
448     }
449 
450     /**
451      * Returns the amount of Tokens sold
452      * @param period - period index to get tokens for
453      * @return tokensSold - amount of tokens sold
454      */
455     function getTokensSold (uint period)   constant   returns (uint256 tokensSold) {  
456         return periods[period].tokensSold;
457     }
458 
459     /**
460      * Returns `true` if TokenDistribution has enough tokens for the current period
461      * and thus going on
462      * @return active - `true` if TokenDistribution is going on, `false` otherwise
463      */
464     function isActive ()   constant   returns (bool active) {  
465         return win.balanceOf(this) >= totalUnclaimedTokens + tokensForPeriod(currentPeriod) - periods[currentPeriod].tokensSold;
466     }
467 
468     /**
469      * Accepts money deposit and makes record
470      * minimum deposit is MINIMUM_DEPOSIT
471      * @param beneficiar - the address to receive Tokens
472      * @param countryCode - 3-digit country code
473      * @dev if `msg.value < MINIMUM_DEPOSIT` throws
474      */
475     function deposit (address beneficiar, uint16 countryCode)   payable  {  
476         require(msg.value >= MINIMUM_DEPOSIT);
477         require(state == State.Sale || state == State.Presale);
478 
479         /* this should end any finished period before starting any operations */
480         tick();
481 
482         /* check if have enough tokens for the current period
483          * if not, the call fails until tokens are deposited to the contract
484          */
485         require(isActive());
486 
487         uint256 tokensBought = msg.value / getTokenPrice();
488 
489         if(periods[currentPeriod].tokensSold + tokensBought >= tokensForPeriod(currentPeriod)) {
490             tokensBought = tokensForPeriod(currentPeriod) - periods[currentPeriod].tokensSold;
491         }
492 
493         uint256 moneySpent = getTokenPrice() * tokensBought;
494 
495         investmentsByCountries[countryCode] += moneySpent;
496 
497         if(tokensBought > 0) {
498             assert(moneySpent <= msg.value);
499 
500             /* return the rest */
501             if(msg.value > moneySpent) {
502                 msg.sender.transfer(msg.value - moneySpent);
503             }
504 
505             periods[currentPeriod].tokensSold += tokensBought;
506             unclaimedTokensForInvestor[beneficiar] += tokensBought;
507             totalUnclaimedTokens += tokensBought;
508             totalTokensSold += tokensBought;
509             Deposited(msg.sender, moneySpent, tokensBought);
510         }
511 
512         /* if all tokens are sold, get to the next period */
513         tick();
514     }
515 
516     /**
517      * See `deposit` function
518      */
519     function() payable {
520         deposit(msg.sender, UNKNOWN_COUNTRY);
521     }
522 
523     /**
524      * Creates the contract and sets the owners
525      * @param owners_dot_recipient - array of 16 owner records  (MultiOwnable.Owner.recipient fields)
526 * @param owners_dot_share - array of 16 owner records  (MultiOwnable.Owner.share fields)
527      */
528     function BlindCroupierTokenDistribution (address[16] owners_dot_recipient, uint[16] owners_dot_share)   MultiOwnable(owners_dot_recipient, owners_dot_share)  {  
529 MultiOwnable.Owner[16] memory owners;
530 
531 for(uint __recipient_iterator__ = 0; __recipient_iterator__ < owners_dot_recipient.length;__recipient_iterator__++)
532   owners[__recipient_iterator__].recipient = address(owners_dot_recipient[__recipient_iterator__]);
533 for(uint __share_iterator__ = 0; __share_iterator__ < owners_dot_share.length;__share_iterator__++)
534   owners[__share_iterator__].share = uint(owners_dot_share[__share_iterator__]);
535         state = State.NotStarted;
536     }
537 
538     /**
539      * Begins the crowdsale (presale period)
540      * @param tokenContractAddress - address of the `WIN` contract (token holder)
541      * @dev must be called by one of owners
542      */
543     function startPresale (address tokenContractAddress)   onlyOneOfOwners  {  
544         require(state == State.NotStarted);
545 
546         win = WIN(tokenContractAddress);
547 
548         assert(win.balanceOf(this) >= tokensForPeriod(0));
549 
550         periods[0] = Period(now, NEVER, PRESALE_TOKEN_PRICE, 0);
551         PeriodStarted(0,
552             PRESALE_TOKEN_PRICE,
553             tokensForPeriod(currentPeriod),
554             now,
555             NEVER,
556             now);
557         state = State.Presale;
558     }
559 
560     /**
561      * Ends the presale and begins period 1 of the crowdsale
562      * @dev must be called by one of owners
563      */
564     function endPresale ()   onlyOneOfOwners  {  
565         require(state == State.Presale);
566         state = State.Sale;
567         nextPeriod();
568     }
569 
570     /**
571      * Returns a time interval for a specific `period`
572      * @param  period - period index to count interval for
573      * @return startTime - timestamp of period start time (INCLUSIVE)
574      * @return endTime - timestamp of period end time (INCLUSIVE)
575      */
576     function periodTimeFrame (uint period)   constant   returns (uint256 startTime, uint256 endTime) {  
577         require(period <= currentPeriod);
578 
579         startTime = periods[period].startTime;
580         endTime = periods[period].endTime;
581     }
582 
583     /**
584      * Returns `true` if the time for the `period` has already passed
585      */
586     function isPeriodTimePassed (uint period)   constant   returns (bool finished) {  
587         require(periods[period].startTime > 0);
588 
589         uint256 endTime = periods[period].endTime;
590 
591         if(endTime == NEVER) {
592             return false;
593         }
594 
595         return (endTime < now);
596     }
597 
598     /**
599      * Returns `true` if `period` has already finished (time passed or tokens sold)
600      */
601     function isPeriodClosed (uint period)   constant   returns (bool finished) {  
602         return period < currentPeriod;
603     }
604 
605     /**
606      * Returns `true` if all tokens for the `period` has been sold
607      */
608     function isPeriodAllTokensSold (uint period)   constant   returns (bool finished) {  
609         return periods[period].tokensSold == tokensForPeriod(period);
610     }
611 
612     /**
613      * Returns unclaimed Tokens count for the caller
614      * @return tokens - amount of unclaimed Tokens for the caller
615      */
616     function unclaimedTokens ()   constant   returns (uint256 tokens) {  
617         return unclaimedTokensForInvestor[msg.sender];
618     }
619 
620     /**
621      * Transfers all the tokens stored for this `investor` to his address
622      * @param investor - investor to claim tokens for
623      */
624     function claimAllTokensForInvestor (address investor)   {  
625         assert(totalUnclaimedTokens >= unclaimedTokensForInvestor[investor]);
626         totalUnclaimedTokens -= unclaimedTokensForInvestor[investor];
627         win.transfer(investor, unclaimedTokensForInvestor[investor]);
628         TokensClaimed(investor, unclaimedTokensForInvestor[investor]);
629         unclaimedTokensForInvestor[investor] = 0;
630     }
631 
632     /**
633      * Claims all the tokens for the sender
634      * @dev efficiently calling `claimAllForInvestor(msg.sender)`
635      */
636     function claimAllTokens ()   {  
637         claimAllTokensForInvestor(msg.sender);
638     }
639 
640     /**
641      * Returns the total token count for the period specified
642      * @param  period - period number
643      * @return tokens - total tokens count
644      */
645     function tokensForPeriod (uint period)   constant   returns (uint256 tokens) {  
646         if(period == 0) {
647             return TOKENS_FOR_PRESALE;
648         } else if(period == 1) {
649             return TOKENS_PER_FIRST_PERIOD;
650         } else {
651             return TOKENS_PER_PERIOD;
652         }
653     }
654 
655     /**
656      * Returns the duration of the sale (not presale) period
657      * @param  period - the period number
658      * @return duration - duration in seconds
659      */
660     function periodDuration (uint period)   constant   returns (uint256 duration) {  
661         require(period > 0);
662 
663         if(period == 1) {
664             return FIRST_PERIOD_DURATION;
665         } else {
666             return PERIOD_DURATION;
667         }
668     }
669 
670     /**
671      * Finishes the current period and starts a new one
672      */
673     function nextPeriod() internal {
674         uint256 oldPrice = periods[currentPeriod].tokenPrice;
675         uint256 newPrice;
676         if(currentPeriod == 0) {
677             newPrice = SALE_INITIAL_TOKEN_PRICE;
678         } else if(periods[currentPeriod].tokensSold  == tokensForPeriod(currentPeriod)) {
679             newPrice = Math.addPromille(oldPrice, FULLY_SOLD_PRICE_INCREASE);
680         } else if(periods[currentPeriod].tokensSold >= Math.takePromille(tokensForPeriod(currentPeriod), TOKENS_TO_INCREASE_NEXT_PRICE)) {
681             newPrice = Math.addPromille(oldPrice, PERIOD_PRICE_INCREASE);
682         } else {
683             newPrice = oldPrice;
684         }
685 
686         /* destroy unsold tokens */
687         if(periods[currentPeriod].tokensSold < tokensForPeriod(currentPeriod)) {
688             uint256 toDestroy = tokensForPeriod(currentPeriod) - periods[currentPeriod].tokensSold;
689             /* do not destroy if we don't have enough to pay investors */
690             uint256 balance = win.balanceOf(this);
691             if(balance < toDestroy + totalUnclaimedTokens) {
692                 toDestroy = (balance - totalUnclaimedTokens);
693             }
694             win.destroy(toDestroy);
695             totalTokensDestroyed += toDestroy;
696         }
697 
698         /* if we are force ending the period set in the future or without end time,
699          * set end time to now
700          */
701         if(periods[currentPeriod].endTime > now ||
702             periods[currentPeriod].endTime == NEVER) {
703             periods[currentPeriod].endTime = now;
704         }
705 
706         uint256 duration = periodDuration(currentPeriod + 1);
707 
708         periods[currentPeriod + 1] = Period(
709             periods[currentPeriod].endTime,
710             periods[currentPeriod].endTime + duration,
711             newPrice,
712             0);
713 
714         currentPeriod++;
715 
716         PeriodStarted(currentPeriod,
717             newPrice,
718             tokensForPeriod(currentPeriod),
719             periods[currentPeriod].startTime,
720             periods[currentPeriod].endTime,
721             now);
722     }
723 
724     /**
725      * To be called as frequently as required by any external party
726      * Will check if 1 or more periods have finished and move on to the next
727      */
728     function tick ()   {  
729         if(!isActive()) {
730             return;
731         }
732 
733         while(state == State.Sale &&
734             (isPeriodTimePassed(currentPeriod) ||
735             isPeriodAllTokensSold(currentPeriod))) {
736             nextPeriod();
737         }
738     }
739 
740     /**
741      * Withdraws the money to be spent to Blind Croupier Project needs
742      * @param  amount - amount of Wei to withdraw (total)
743      */
744     function withdraw (uint256 amount)   onlyOneOfOwners  {  
745         require(this.balance >= amount);
746 
747         uint totalShares = 0;
748         for(var idx = 0; idx < owners.length; idx++) {
749             totalShares += owners[idx].share;
750         }
751 
752         for(idx = 0; idx < owners.length; idx++) {
753             owners[idx].recipient.transfer(amount * owners[idx].share / totalShares);
754         }
755     }
756 }