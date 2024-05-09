1 pragma solidity ^0.4.19;
2 
3 /*
4 *
5 * Domain on day 1: https://etherbonds.io/
6 *
7 * This contract implements bond contracts on the Ethereum blockchain
8 * - You can buy a bond for ETH (NominalPrice)
9 * - While buying you can set a desirable MaturityDate
10 * - After you reach the MaturityDate you can redeem the bond for the MaturityPrice
11 * - MaturityPrice is always greater than the NominalPrice
12 * - greater the MaturityDate = higher profit
13 * - You can't redeem a bond after MaxRedeemTime
14 * 
15 * For example, you bought a bond for 1 ETH which will mature in 1 month for 63% profit.
16 * After the month you can redeem the bond and receive your 1.63 ETH.
17 *
18 * If you don't want to wait for your bond maturity you can sell it to another investor. 
19 * For example you bought a 1 year bond, 6 months have passed and you urgently need money. 
20 * You can sell the bond on a secondary market to other investors before the maturity date.
21 * You can also redeem your bond prematurely but only for a part of the nominal price.
22 *
23 * !!! THIS IS A HIGH RISK INVESTMENT ASSET !!!
24 * !!! THIS IS GAMBLING !!!
25 * !!! THIS IS A PONZI SCHEME !!!
26 * All funds invested are going to prev investors for the exception of FounderFee and AgentFee
27 *
28 * Bonds are generating profit due to NEW and NEW investors BUYING them
29 * If the contract has no ETH in it you will FAIL to redeem your bond
30 * However as soon as new bonds will be issued the contract will receive ETH and
31 * you will be able to redeem the bond.
32 *
33 * You can also refer a friend for 10% of the bonds he buys. Your friend will also receive a referral bonus for trading with your code!
34 *
35 */
36 
37 /*
38 * ------------------------------
39 * Main functions are:
40 * Buy() - to buy a new issued bond
41 * Redeem() - to redeem your bond for profit 
42 *
43 * BuyOnSecondaryMarket() - to buy a bond from other investors
44 * PlaceSellOrder() - to place your bond on the secondary market for selling
45 * CancelSellOrder() - stop selling your bond
46 * Withdraw() - to withdraw agant commission or funds after selling a bond on the secondary market
47 * ------------------------------
48 */
49 
50 /**
51 /* Math operations with safety checks
52 */
53 contract SafeMath 
54 {
55     function mul(uint a, uint b) internal pure returns (uint) 
56     {
57         uint c = a * b;
58         assert(a == 0 || c / a == b);
59         return c;
60     }
61 
62     function div(uint a, uint b) internal pure returns (uint) 
63     {
64         assert(b > 0);
65         uint c = a / b;
66         assert(a == b * c + a % b);
67         return c;
68     }
69 
70     function sub(uint a, uint b) internal pure returns (uint) 
71     {
72         assert(b <= a);
73         return a - b;
74     }
75 
76     function add(uint a, uint b) internal pure returns (uint) 
77     {
78         uint c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 
83     function assert(bool assertion) internal pure
84     {
85         if (!assertion) 
86         {
87             revert();
88         }   
89     }
90 }
91 
92 contract EtherBonds is SafeMath
93 {
94     /* A founder can write here useful information */
95     /* For example current domain name or report a problem */
96     string public README = "STATUS_OK";
97     
98     /* You can refer a friend and you will be receiving a bonus for EACH his deal */
99     /* The friend will also have a bonus but only once */
100     /* You should have at least one bond in your history to be an agent */
101     /* Just ask your friend to specify your wallet address with his FIRST deal */
102     uint32 AgentBonusInPercent = 10;
103     /* A user gets a bonus for adding an agent for his first deal */
104     uint32 UserRefBonusInPercent = 3;
105     
106     /* How long it takes for a bond to mature  */
107     uint32 MinMaturityTimeInDays = 30; // don't set less than 15 days
108     uint32 MaxMaturityTimeInDays = 240;
109     
110     /* Minimum price of a bond */
111     uint MinNominalBondPrice = 0.006 ether;
112     
113     /* How much % of your bond you can redeem prematurely */
114     uint32 PrematureRedeemPartInPercent = 25;
115     /* How much this option costs */
116     uint32 PrematureRedeemCostInPercent = 20;
117     
118     /* Be careful! */
119     /* If you don't redeem your bond AFTER its maturity date */
120     /* the bond will become irredeemable! */
121     uint32 RedeemRangeInDays = 1;
122     uint32 ExtraRedeemRangeInDays = 3;
123     /* However you can prolong your redeem period for a price */
124     uint32 ExtraRedeemRangeCostInPercent = 10;
125     
126     /* Founder takes a fee for each bond sold */
127     /* There is no way for a founder to take all the contract's money, fonder takes only the fee */
128     address public Founder;
129     uint32 public FounderFeeInPercent = 5;
130     
131     /* Events */
132     event Issued(uint32 bondId, address owner);
133     event Sold(uint32 bondId, address seller, address buyer, uint price);
134     event SellOrderPlaced(uint32 bondId, address seller);
135     event SellOrderCanceled(uint32 bondId, address seller);
136     event Redeemed(uint32 bondId, address owner);
137     
138     struct Bond 
139     {
140         /* Unique ID of a bond */
141         uint32 id;
142         
143         address owner;
144         
145         uint32 issueTime;
146         uint32 maturityTime;
147         uint32 redeemTime;
148         
149         /* A bond can't be redeemed after this date */
150         uint32 maxRedeemTime;
151         bool canBeRedeemedPrematurely;
152         
153         uint nominalPrice;
154         uint maturityPrice;
155         
156         /* You can resell your bond to another user */
157         uint sellingPrice;
158     }
159     uint32 NextBondID = 1;
160     mapping(uint32 => Bond) public Bonds;
161     
162     struct UserInfo
163     {
164         /* This address will receive commission for this user trading */
165         address agent;
166         
167         uint32 totalBonds;
168         mapping(uint32 => uint32) bonds;
169     }
170     mapping(address => UserInfo) public Users;
171 
172     mapping(address => uint) public Balances;
173 
174     /* MAIN */
175     
176     function EtherBonds() public 
177     {
178         Founder = msg.sender;
179     }
180     
181     function ContractInfo() 
182         public view returns(
183             string readme,
184             uint32 agentBonusInPercent,
185             uint32 userRefBonusInPercent,
186             uint32 minMaturityTimeInDays,
187             uint32 maxMaturityTimeInDays,
188             uint minNominalBondPrice,
189             uint32 prematureRedeemPartInPercent,
190             uint32 prematureRedeemCostInPercent,
191             uint32 redeemRangeInDays,
192             uint32 extraRedeemRangeInDays,
193             uint32 extraRedeemRangeCostInPercent,
194             uint32 nextBondID,
195             uint balance
196             )
197     {
198         readme = README;
199         agentBonusInPercent = AgentBonusInPercent;
200         userRefBonusInPercent = UserRefBonusInPercent;
201         minMaturityTimeInDays = MinMaturityTimeInDays;
202         maxMaturityTimeInDays = MaxMaturityTimeInDays;
203         minNominalBondPrice = MinNominalBondPrice;
204         prematureRedeemPartInPercent = PrematureRedeemPartInPercent;
205         prematureRedeemCostInPercent = PrematureRedeemCostInPercent;
206         redeemRangeInDays = RedeemRangeInDays;
207         extraRedeemRangeInDays = ExtraRedeemRangeInDays;
208         extraRedeemRangeCostInPercent = ExtraRedeemRangeCostInPercent;
209         nextBondID = NextBondID;
210         balance = this.balance;
211     }
212     
213     /* This function calcs how much profit will a bond bring */
214     function MaturityPrice(
215         uint nominalPrice, 
216         uint32 maturityTimeInDays,
217         bool hasExtraRedeemRange,
218         bool canBeRedeemedPrematurely,
219         bool hasRefBonus
220         ) 
221         public view returns(uint)
222     {
223         uint nominalPriceModifierInPercent = 100;
224         
225         if (hasExtraRedeemRange)
226         {
227             nominalPriceModifierInPercent = sub(
228                 nominalPriceModifierInPercent, 
229                 ExtraRedeemRangeCostInPercent
230                 );
231         }
232         
233         if (canBeRedeemedPrematurely)
234         {
235             nominalPriceModifierInPercent = sub(
236                 nominalPriceModifierInPercent, 
237                 PrematureRedeemCostInPercent
238                 );
239         }
240         
241         if (hasRefBonus)
242         {
243             nominalPriceModifierInPercent = add(
244                 nominalPriceModifierInPercent, 
245                 UserRefBonusInPercent
246                 );
247         }
248         
249         nominalPrice = div(
250             mul(nominalPrice, nominalPriceModifierInPercent), 
251             100
252             );
253         
254         //y = 1.177683 - 0.02134921*x + 0.001112346*x^2 - 0.000010194*x^3 + 0.00000005298844*x^4
255         /*
256         15days        +7%
257         30days       +30%
258         60days      +138%
259         120days     +700%
260         240days    +9400% 
261         */
262         
263         uint x = maturityTimeInDays;
264         
265         /* The formula will break if x < 15 */
266         require(x >= 15);
267         
268         var a = mul(2134921000, x);
269         var b = mul(mul(111234600, x), x);
270         var c = mul(mul(mul(1019400, x), x), x);
271         var d = mul(mul(mul(mul(5298, x), x), x), x);
272         
273         var k = sub(sub(add(add(117168300000, b), d), a), c);
274         k = div(k, 10000000);
275         
276         return div(mul(nominalPrice, k), 10000);
277     }
278     
279     /* This function checks if you can change your bond back to money */
280     function CanBeRedeemed(Bond bond) 
281         internal view returns(bool) 
282     {
283         return 
284             bond.issueTime > 0 &&                       // a bond should be issued
285             bond.owner != 0 &&                          // it should should have an owner
286             bond.redeemTime == 0 &&                     // it should not be already redeemed
287             bond.sellingPrice == 0 &&                   // it should not be reserved for selling
288             (
289                 !IsPremature(bond.maturityTime) ||      // it should be mature / be redeemable prematurely 
290                 bond.canBeRedeemedPrematurely
291             ) &&       
292             block.timestamp <= bond.maxRedeemTime;      // be careful, you can't redeem too old bonds
293     }
294     
295     /* For some external checkings we gonna to wrap this in a function */
296     function IsPremature(uint maturityTime)
297         public view returns(bool) 
298     {
299         return maturityTime > block.timestamp;
300     }
301     
302     /* This is how you buy bonds on the primary market */
303     function Buy(
304         uint32 maturityTimeInDays,
305         bool hasExtraRedeemRange,
306         bool canBeRedeemedPrematurely,
307         address agent // you can leave it 0
308         ) 
309         public payable
310     {
311         /* We don't issue bonds cheaper than MinNominalBondPrice*/
312         require(msg.value >= MinNominalBondPrice);
313         
314         /* We don't issue bonds out of allowed maturity range */
315         require(
316             maturityTimeInDays >= MinMaturityTimeInDays && 
317             maturityTimeInDays <= MaxMaturityTimeInDays
318             );
319             
320         /* You can have a bonus on your first deal if specify an agent */
321         bool hasRefBonus = false;
322             
323         /* On your first deal ...  */
324         if (Users[msg.sender].agent == 0 && Users[msg.sender].totalBonds == 0)
325         {
326             /* ... you may specify an agent and get a bonus for this ... */
327             if (agent != 0)
328             {
329                 /* ... the agent should have some bonds behind him */
330                 if (Users[agent].totalBonds > 0)
331                 {
332                     Users[msg.sender].agent = agent;
333                     hasRefBonus = true;
334                 }
335                 else
336                 {
337                     agent = 0;
338                 }
339             }
340         }
341         /* On all your next deals you will have the same agent as on the first one */
342         else
343         {
344             agent = Users[msg.sender].agent;
345         }
346             
347         /* Issuing a new bond */
348         Bond memory newBond;
349         newBond.id = NextBondID;
350         newBond.owner = msg.sender;
351         newBond.issueTime = uint32(block.timestamp);
352         newBond.canBeRedeemedPrematurely = canBeRedeemedPrematurely;
353         
354         /* You cant redeem your bond for profit untill this date */
355         newBond.maturityTime = 
356             newBond.issueTime + maturityTimeInDays*24*60*60;
357         
358         /* Your time to redeem is limited */    
359         newBond.maxRedeemTime = 
360             newBond.maturityTime + (hasExtraRedeemRange?ExtraRedeemRangeInDays:RedeemRangeInDays)*24*60*60;
361         
362         newBond.nominalPrice = msg.value;
363         
364         newBond.maturityPrice = MaturityPrice(
365             newBond.nominalPrice,
366             maturityTimeInDays,
367             hasExtraRedeemRange,
368             canBeRedeemedPrematurely,
369             hasRefBonus
370             );
371         
372         Bonds[newBond.id] = newBond;
373         NextBondID += 1;
374         
375         /* Linking the bond to the owner so later he can easily find it */
376         var user = Users[newBond.owner];
377         user.bonds[user.totalBonds] = newBond.id;
378         user.totalBonds += 1;
379         
380         /* Notify all users about the issuing event */
381         Issued(newBond.id, newBond.owner);
382         
383         /* Founder's fee */
384         uint moneyToFounder = div(
385             mul(newBond.nominalPrice, FounderFeeInPercent), 
386             100
387             );
388         /* Agent bonus */
389         uint moneyToAgent = div(
390             mul(newBond.nominalPrice, AgentBonusInPercent), 
391             100
392             );
393         
394         if (agent != 0 && moneyToAgent > 0)
395         {
396             /* Agent can potentially block user's trading attempts, so we dont use just .transfer*/
397             Balances[agent] = add(Balances[agent], moneyToAgent);
398         }
399         
400         /* Founder always gets his fee */
401         require(moneyToFounder > 0);
402         
403         Founder.transfer(moneyToFounder);
404     }
405     
406     /* You can also buy bonds on secondary market from other users */
407     function BuyOnSecondaryMarket(uint32 bondId) 
408         public payable
409     {
410         var bond = Bonds[bondId];
411         
412         /* A bond you are buying should be issued */
413         require(bond.issueTime > 0);
414         /* Checking, if the bond is a valuable asset */
415         require(bond.redeemTime == 0 && block.timestamp < bond.maxRedeemTime);
416         
417         var price = bond.sellingPrice;
418         /* You can only buy a bond if an owner is selling it */
419         require(price > 0);
420         /* You should have enough money to pay the owner */
421         require(price <= msg.value);
422         
423         /* It's ok if you accidentally transfer more money, we will send them back */
424         var residue = msg.value - price;
425         
426         /* Transfering the bond */
427         var oldOwner = bond.owner;
428         var newOwner = msg.sender;
429         require(newOwner != 0 && newOwner != oldOwner);
430         
431         bond.sellingPrice = 0;
432         bond.owner = newOwner;
433         
434         var user = Users[bond.owner];
435         user.bonds[user.totalBonds] = bond.id;
436         user.totalBonds += 1;
437         
438         /* Doublechecking the price */
439         require(add(price, residue) == msg.value);
440         
441         /* Notify all users about the exchange event */
442         Sold(bond.id, oldOwner, newOwner, price);
443         
444         /* Old owner can potentially block user's trading attempts, so we dont use just .transfer*/
445         Balances[oldOwner] = add(Balances[oldOwner], price);
446         
447         if (residue > 0)
448         {
449             /* If there is residue we will send it back */
450             newOwner.transfer(residue);
451         }
452     }
453     
454     /* You can sell your bond on the secondary market */
455     function PlaceSellOrder(uint32 bondId, uint sellingPrice) 
456         public
457     {
458         /* To protect from an accidental selling by 0 price */
459         /* The selling price should be in Wei */
460         require(sellingPrice >= MinNominalBondPrice);
461         
462         var bond = Bonds[bondId];
463         
464         /* A bond you are selling should be issued */
465         require(bond.issueTime > 0);
466         /* You can't update selling price, please, call CancelSellOrder beforehand */
467         require(bond.sellingPrice == 0);
468         /* You can't sell useless bonds */
469         require(bond.redeemTime == 0 && block.timestamp < bond.maxRedeemTime);
470         /* You should own a bond you're selling */
471         require(bond.owner == msg.sender);
472         
473         bond.sellingPrice = sellingPrice;
474         
475         /* Notify all users about you wanting to sell the bond */
476         SellOrderPlaced(bond.id, bond.owner);
477     }
478     
479     /* You can cancel your sell order */
480     function CancelSellOrder(uint32 bondId) 
481         public
482     {
483         var bond = Bonds[bondId];
484         
485         /* Bond should be reserved for selling */
486         require(bond.sellingPrice > 0);
487         
488         /* You should own a bond which sell order you're cancelling */
489         require(bond.owner == msg.sender);
490         
491         bond.sellingPrice = 0;
492         
493         /* Notify all users about cancelling the selling order */
494         SellOrderCanceled(bond.id, bond.owner);
495     }
496     
497     /* Sometimes we can't just use .transfer for a security reason */
498     function Withdraw()
499         public
500     {
501         require(Balances[msg.sender] > 0);
502 
503         /* Don't forget about double entering in .transfer! */
504         var money = Balances[msg.sender];
505         Balances[msg.sender] = 0;
506 
507         msg.sender.transfer(money);
508     }
509 
510     /* You can redeem bonds back to the contract for profit */
511     /* But you need to wait till maturityTime */
512     /* This is the key function where you get profit for a bond you own */
513     function Redeem(uint32 bondId) 
514         public
515     {
516         var bond = Bonds[bondId];
517         
518         require(CanBeRedeemed(bond));
519         
520         /* You should own a bond you redeem */
521         require(bond.owner == msg.sender);
522         
523         /* If a bond has redeemTime it has been redeemed */
524         bond.redeemTime = uint32(block.timestamp);
525         
526         /* If it's a premature redeem you will only get 
527         PrematureRedeemPartInPercent of nominalPrice back */
528         if (IsPremature(bond.maturityTime))
529         {
530             bond.maturityPrice = div(
531                 mul(bond.nominalPrice, PrematureRedeemPartInPercent), 
532                 100
533                 );
534         }
535         
536         /* Notify all users about the redeem event */
537         Redeemed(bond.id, bond.owner);
538         
539         /* Transfer funds to the owner */
540         /* This is how you earn money */
541         bond.owner.transfer(bond.maturityPrice);
542     }
543     
544     /* Be carefull, this function can return a bound of a differet owner
545     if the bond was sold. Always check the bond owner */
546     function UserBondByOffset(uint32 offset) 
547         public view 
548         returns(
549             uint32 bondId,
550             bool canBeRedeemed,
551             bool isPremature
552             ) 
553     {
554         var bond = Bonds[Users[msg.sender].bonds[offset]];
555         
556         bondId = bond.id;
557         canBeRedeemed = CanBeRedeemed(bond);
558         isPremature = IsPremature(bond.maturityTime);
559     }
560     
561     function BondInfoById(uint32 bondId) 
562         public view 
563         returns(
564             bool canBeRedeemed,
565             bool isPremature
566             ) 
567     {
568         var bond = Bonds[bondId];
569         
570         canBeRedeemed = CanBeRedeemed(bond);
571         isPremature = IsPremature(bond.maturityTime);
572     }
573     
574     /* ADMIN */
575      
576     function AdmChange_README(string value) public
577     {
578         require(msg.sender == Founder);
579         
580         README = value;
581     }
582 }