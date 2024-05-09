1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: contracts/Discounts.sol
39 
40 library Discounts {
41   using SafeMath for uint256;
42 
43   /**************************************************************************
44    * TYPES
45    *************************************************************************/
46 
47   /*
48    * Top-level struct for grouping of tiers with a base purchase rate
49    */
50   struct Collection {
51     Tier[] tiers;
52 
53     // number of tokens per wei
54     uint256 baseRate;
55   }
56 
57   /*
58    * Struct for a given tier - discount and availability
59    */
60   struct Tier {
61     // discount the set purchase price, expressed in basis points (‱)
62     // range (0‱ .. 10,000‱) corresponds to (0.00% .. 100.00%)
63     uint256 discount;
64 
65     // number of remaining available tokens in tier
66     uint256 available;
67   }
68 
69   // upper-bound of basis point scale
70   uint256 public constant MAX_DISCOUNT = 10000;
71 
72 
73   /**************************************************************************
74    * CREATE
75    *************************************************************************/
76 
77   /*
78    * @dev Add a new tier at the end of the list
79    * @param _discount - Discount in basis points
80    * @param _available - Available supply at tier
81    */
82   function addTier(
83     Collection storage self,
84     uint256 _discount,
85     uint256 _available
86   )
87     internal
88   {
89     self.tiers.push(Tier({
90       discount: _discount,
91       available: _available
92     }));
93   }
94 
95 
96   /**************************************************************************
97    * PURCHASE
98    *************************************************************************/
99 
100   /*
101    * @dev Subtracts supply from tiers starting at a minimum, using up funds
102    * @param _amount - Maximum number of tokens to purchase
103    * @param _funds - Allowance in Wei
104    * @param _minimumTier - Minimum tier to start purchasing from
105    * @return Total tokens purchased and remaining funds in wei
106    */
107   function purchaseTokens(
108     Collection storage self,
109     uint256 _amount,
110     uint256 _funds,
111     uint256 _minimumTier
112   )
113     internal
114     returns (
115       uint256 purchased,
116       uint256 remaining
117     )
118   {
119     uint256 issue = 0; // tracks total tokens to issue
120     remaining = _funds;
121 
122     uint256 available;  // var for available tokens at tier
123     uint256 spend; // amount spent at tier
124     uint256 affordable;  // var for # funds can pay for at tier
125     uint256 purchase; // var for # to purchase at tier
126 
127     // for each tier starting at minimum
128     // draw from the sent funds and count tokens to issue
129     for (var i = _minimumTier; i < self.tiers.length && issue < _amount; i++) {
130       // get the available tokens left at each tier
131       available = self.tiers[i].available;
132 
133       // compute the maximum tokens that the funds can pay for
134       affordable = _computeTokensPurchasedAtTier(self, i, remaining);
135 
136       // either purchase what the funds can afford, or the whole supply
137       // at the tier
138       if (affordable < available) {
139         purchase = affordable;
140       } else {
141         purchase = available;
142       }
143 
144       // limit the amount purchased up to specified amount
145       // use safemath here in case of unknown overflow risk
146       if (purchase.add(issue) > _amount) {
147         purchase = _amount.sub(issue);
148       }
149 
150       spend = _computeCostForTokensAtTier(self, i, purchase);
151 
152       // decrease available supply at tier
153       self.tiers[i].available -= purchase;
154 
155       // increase tokens to issue
156       issue += purchase;
157 
158       // decrement funds to proceed
159       remaining -= spend;
160     }
161 
162     return (issue, remaining);
163   }
164 
165 
166   /**************************************************************************
167    * PRICE MATH
168    *************************************************************************/
169 
170   // @return total number of tokens for an amount of wei, discount-adjusted
171   function _computeTokensPurchasedAtTier(
172     Collection storage self,
173     uint256 _tier,
174     uint256 _wei
175   )
176     private
177     view
178     returns (uint256)
179   {
180     var paidBasis = MAX_DISCOUNT.sub(self.tiers[_tier].discount);
181 
182     return _wei.mul(self.baseRate).mul(MAX_DISCOUNT) / paidBasis;
183   }
184 
185   // @return cost in wei for that many tokens
186   function _computeCostForTokensAtTier(
187     Collection storage self,
188     uint256 _tier,
189     uint256 _tokens
190   )
191     private
192     view
193     returns (uint256)
194   {
195     var paidBasis = MAX_DISCOUNT.sub(self.tiers[_tier].discount);
196 
197     var numerator = _tokens.mul(paidBasis);
198     var denominator = MAX_DISCOUNT.mul(self.baseRate);
199 
200     var floor = _tokens.mul(paidBasis).div(
201       MAX_DISCOUNT.mul(self.baseRate)
202     );
203 
204     // must round up cost to next wei (cause token computation rounds down)
205     if (numerator % denominator != 0) {
206       floor = floor + 1;
207     }
208 
209     return floor;
210   }
211 }
212 
213 // File: contracts/Limits.sol
214 
215 library Limits {
216   using SafeMath for uint256;
217 
218   struct PurchaseRecord {
219     uint256 blockNumber;
220     uint256 amount;
221   }
222 
223   struct Window {
224     uint256 amount;  // # of tokens
225     uint256 duration;  // # of blocks
226 
227     mapping (address => PurchaseRecord) purchases;
228   }
229 
230   /*
231    * Record a purchase towards a purchaser's cap limit
232    * @dev resets the purchaser's cap if the window duration has been met
233    * @param _participant - purchaser
234    * @param _amount - token amount of new purchase
235    */
236   function recordPurchase(
237     Window storage self,
238     address _participant,
239     uint256 _amount
240   )
241     internal
242   {
243     var blocksLeft = getBlocksUntilReset(self, _participant);
244     var record = self.purchases[_participant];
245 
246     if (blocksLeft == 0) {
247       record.amount = _amount;
248       record.blockNumber = block.number;
249     } else {
250       record.amount = record.amount.add(_amount);
251     }
252   }
253 
254   /*
255    * Retrieve the current limit for a given participant, based on previous
256    * purchase history
257    * @param _participant - Purchaser
258    * @return amount of tokens left for participant with cap
259    */
260   function getLimit(Window storage self, address _participant)
261     public
262     view
263     returns (uint256 _amount)
264   {
265     var blocksLeft = getBlocksUntilReset(self, _participant);
266 
267     if (blocksLeft == 0) {
268       return self.amount;
269     } else {
270       return self.amount.sub(self.purchases[_participant].amount);
271     }
272   }
273 
274   function getBlocksUntilReset(Window storage self, address _participant)
275     public
276     view
277     returns (uint256 _blocks)
278   {
279     var expires = self.purchases[_participant].blockNumber + self.duration;
280     if (block.number > expires) {
281       return 0;
282     } else {
283       return expires - block.number;
284     }
285   }
286 }
287 
288 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
289 
290 /**
291  * @title Ownable
292  * @dev The Ownable contract has an owner address, and provides basic authorization control
293  * functions, this simplifies the implementation of "user permissions".
294  */
295 contract Ownable {
296   address public owner;
297 
298 
299   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301 
302   /**
303    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304    * account.
305    */
306   function Ownable() public {
307     owner = msg.sender;
308   }
309 
310 
311   /**
312    * @dev Throws if called by any account other than the owner.
313    */
314   modifier onlyOwner() {
315     require(msg.sender == owner);
316     _;
317   }
318 
319 
320   /**
321    * @dev Allows the current owner to transfer control of the contract to a newOwner.
322    * @param newOwner The address to transfer ownership to.
323    */
324   function transferOwnership(address newOwner) public onlyOwner {
325     require(newOwner != address(0));
326     OwnershipTransferred(owner, newOwner);
327     owner = newOwner;
328   }
329 
330 }
331 
332 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
333 
334 /**
335  * @title Claimable
336  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
337  * This allows the new owner to accept the transfer.
338  */
339 contract Claimable is Ownable {
340   address public pendingOwner;
341 
342   /**
343    * @dev Modifier throws if called by any account other than the pendingOwner.
344    */
345   modifier onlyPendingOwner() {
346     require(msg.sender == pendingOwner);
347     _;
348   }
349 
350   /**
351    * @dev Allows the current owner to set the pendingOwner address.
352    * @param newOwner The address to transfer ownership to.
353    */
354   function transferOwnership(address newOwner) onlyOwner public {
355     pendingOwner = newOwner;
356   }
357 
358   /**
359    * @dev Allows the pendingOwner address to finalize the transfer.
360    */
361   function claimOwnership() onlyPendingOwner public {
362     OwnershipTransferred(owner, pendingOwner);
363     owner = pendingOwner;
364     pendingOwner = address(0);
365   }
366 }
367 
368 // File: contracts/SeeToken.sol
369 
370 /**
371  * @title SEE Token
372  * Not a full ERC20 token - prohibits transferring. Serves as a record of
373  * account, to redeem for real tokens after launch.
374  */
375 contract SeeToken is Claimable {
376   using SafeMath for uint256;
377 
378   string public constant name = "See Presale Token";
379   string public constant symbol = "SEE";
380   uint8 public constant decimals = 18;
381 
382   uint256 public totalSupply;
383   mapping (address => uint256) balances;
384 
385   event Issue(address to, uint256 amount);
386 
387   /**
388    * @dev Issue new tokens
389    * @param _to The address that will receive the minted tokens
390    * @param _amount the amount of new tokens to issue
391    */
392   function issue(address _to, uint256 _amount) onlyOwner public {
393     totalSupply = totalSupply.add(_amount);
394     balances[_to] = balances[_to].add(_amount);
395 
396     Issue(_to, _amount);
397   }
398 
399   /**
400    * @dev Get the balance for a particular token holder
401    * @param _holder The token holder's address
402    * @return The holder's balance
403    */
404   function balanceOf(address _holder) public view returns (uint256 balance) {
405     balance = balances[_holder];
406   }
407 }
408 
409 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
410 
411 /**
412  * @title Pausable
413  * @dev Base contract which allows children to implement an emergency stop mechanism.
414  */
415 contract Pausable is Ownable {
416   event Pause();
417   event Unpause();
418 
419   bool public paused = false;
420 
421 
422   /**
423    * @dev Modifier to make a function callable only when the contract is not paused.
424    */
425   modifier whenNotPaused() {
426     require(!paused);
427     _;
428   }
429 
430   /**
431    * @dev Modifier to make a function callable only when the contract is paused.
432    */
433   modifier whenPaused() {
434     require(paused);
435     _;
436   }
437 
438   /**
439    * @dev called by the owner to pause, triggers stopped state
440    */
441   function pause() onlyOwner whenNotPaused public {
442     paused = true;
443     Pause();
444   }
445 
446   /**
447    * @dev called by the owner to unpause, returns to normal state
448    */
449   function unpause() onlyOwner whenPaused public {
450     paused = false;
451     Unpause();
452   }
453 }
454 
455 // File: contracts/Presale.sol
456 
457 contract Presale is Claimable, Pausable {
458   using Discounts for Discounts.Collection;
459   using Limits for Limits.Window;
460 
461   struct Participant {
462     bool authorized;
463 
464     uint256 minimumTier;
465   }
466 
467 
468   /**************************************************************************
469    * STORAGE / EVENTS
470    *************************************************************************/
471 
472   SeeToken token;
473   Discounts.Collection discounts;
474   Limits.Window cap;
475 
476   mapping (address => Participant) participants;
477 
478 
479   event Tier(uint256 discount, uint256 available);
480 
481 
482   /**************************************************************************
483    * CONSTRUCTOR / LIFECYCLE
484    *************************************************************************/
485 
486   function Presale(address _token)
487     public
488   {
489     token = SeeToken(_token);
490 
491     paused = true;
492   }
493 
494   /*
495    * @dev (Done as part of migration) Claims ownership of token contract
496    */
497   function claimToken() public {
498     token.claimOwnership();
499   }
500 
501   /*
502    * Allow purchase
503    * @dev while paused
504    */
505   function unpause()
506     onlyOwner
507     whenPaused
508     whenRateSet
509     whenCapped
510     whenOwnsToken
511     public
512   {
513     super.unpause();
514   }
515 
516 
517   /**************************************************************************
518    * ADMIN INTERFACE
519    *************************************************************************/
520 
521   /*
522    * Set the base purchase rate for the token
523    * @param _purchaseRate - number of tokens granted per wei
524    */
525   function setRate(uint256 _purchaseRate)
526     onlyOwner
527     whenPaused
528     public
529   {
530     discounts.baseRate = _purchaseRate;
531   }
532 
533   /*
534    * Specify purchasing limits for a single account: the limit of tokens
535    * that a participant may purchase in a set amount of time (blocks)
536    * @param _amount - Number of tokens
537    * @param _duration - Number of blocks
538    */
539   function limitPurchasing(uint256 _amount, uint256 _duration)
540     onlyOwner
541     whenPaused
542     public
543   {
544     cap.amount = _amount;
545     cap.duration = _duration;
546   }
547 
548   /*
549    * Add a tier with a given discount and available supply
550    * @param _discount - Discount in basis points
551    * @param _available - Available supply at tier
552    */
553   function addTier(uint256 _discount, uint256 _available)
554     onlyOwner
555     whenPaused
556     public
557   {
558     discounts.addTier(_discount, _available);
559 
560     Tier(_discount, _available);
561   }
562 
563   /*
564    * Authorize a group of participants for a tier
565    * @param _minimumTier - minimum tier for list of participants
566    * @param _participants - array of authorized addresses
567    */
568   function authorizeForTier(uint256 _minimumTier, address[] _authorized)
569     onlyOwner
570     public
571   {
572     for (uint256 i = 0; i < _authorized.length; i++) {
573       participants[_authorized[i]] = Participant({
574         authorized: true,
575         minimumTier: _minimumTier
576       });
577     }
578   }
579 
580   /*
581    * Withdraw balance from presale
582    */
583   function withdraw()
584     onlyOwner
585     public
586   {
587     owner.transfer(this.balance);
588   }
589 
590 
591   /**************************************************************************
592    * PURCHASE INTERFACE
593    *************************************************************************/
594 
595   /*
596    * Fallback (default) function.
597    * @dev Forwards to `purchaseTokens()`
598    */
599   function ()
600     public
601     payable
602   {
603     purchaseTokens();
604   }
605 
606   /*
607    * Public purchase interface for authorized Dragon Holders
608    * @dev Purchases tokens starting in authorized minimum tier
609    */
610   function purchaseTokens()
611     onlyAuthorized
612     whenNotPaused
613     public
614     payable
615   {
616     var limit = cap.getLimit(msg.sender);
617 
618     var (purchased, refund) = discounts.purchaseTokens(
619       limit,
620       msg.value,
621       participants[msg.sender].minimumTier
622     );
623 
624     cap.recordPurchase(msg.sender, purchased);
625 
626     // issue new tokens
627     token.issue(msg.sender, purchased);
628 
629     // if there are funds left, send refund
630     if (refund > 0) {
631       msg.sender.transfer(refund);
632     }
633   }
634 
635 
636   /**************************************************************************
637    * PRICING / AVAILABILITY - VIEW INTERFACE
638    *************************************************************************/
639 
640   /*
641    * Get terms for purchasing limit window
642    * @return number of tokens and duration in blocks
643    */
644   function getPurchaseLimit()
645     public
646     view
647     returns (uint256 _amount, uint256 _duration)
648   {
649     _amount = cap.amount;
650     _duration = cap.duration;
651   }
652 
653   /*
654    * Get tiers currently set up, with discounts and available supplies
655    * @return array of tuples (discount, available)
656    */
657   function getTiers()
658     public
659     view
660     returns (uint256[2][])
661   {
662     var records = discounts.tiers;
663     uint256[2][] memory tiers = new uint256[2][](records.length);
664 
665     for (uint256 i = 0; i < records.length; i++) {
666       tiers[i][0] = records[i].discount;
667       tiers[i][1] = records[i].available;
668     }
669 
670     return tiers;
671   }
672 
673   /*
674    * Get available supply for each tier for a given participant
675    * @dev starts at minimum tier for participant (requiring auth)
676    * @return available supply by tier index, zeroes for non-auth
677    */
678   function getAvailability(address _participant)
679     public
680     view
681     returns (uint256[])
682   {
683     var participant = participants[_participant];
684     uint256 minimumTier = participant.minimumTier;
685 
686     // minor HACK - if the participant isn't authorized, just set the
687     // minimum tier above the bounds
688     if (!participant.authorized) {
689       minimumTier = discounts.tiers.length;
690     }
691 
692     uint256[] memory tiers = new uint256[](discounts.tiers.length);
693 
694     for (uint256 i = minimumTier; i < tiers.length; i++) {
695       tiers[i] = discounts.tiers[i].available;
696     }
697 
698     return tiers;
699   }
700 
701 
702   /**************************************************************************
703    * MODIFIERS
704    *************************************************************************/
705 
706   /*
707    * @dev require participant is whitelist-authorized
708    */
709   modifier onlyAuthorized() {
710     require(participants[msg.sender].authorized);
711     _;
712   }
713 
714   /*
715    * @dev baseRate will default to 0
716    */
717   modifier whenRateSet() {
718     require(discounts.baseRate != 0);
719     _;
720   }
721 
722   /*
723    * @dev to prevent accidentally capping at 0
724    */
725   modifier whenCapped() {
726     require(cap.amount != 0);
727     _;
728   }
729 
730   /*
731    * @dev asserts zeppelin Claimable workflow is finalized
732    */
733   modifier whenOwnsToken() {
734     require(token.owner() == address(this));
735     _;
736   }
737 }