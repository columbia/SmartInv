1 pragma solidity ^0.4.0;
2 
3 /*
4  * Token - is a smart contract interface 
5  * for managing common functionality of 
6  * a token.
7  *
8  * ERC.20 Token standard: https://github.com/eth ereum/EIPs/issues/20
9  */
10 contract TokenInterface {
11 
12         
13     // total amount of tokens
14     uint totalSupplyVar;
15 
16     
17     /**
18      *
19      * balanceOf() - constant function check concrete tokens balance  
20      *
21      *  @param owner - account owner
22      *  
23      *  @return the value of balance 
24      */                               
25     function balanceOf(address owner) constant returns (uint256 balance);
26     
27     function transfer(address to, uint256 value) returns (bool success);
28 
29     function transferFrom(address from, address to, uint256 value) returns (bool success);
30 
31     /**
32      *
33      * approve() - function approves to a person to spend some tokens from 
34      *           owner balance. 
35      *
36      *  @param spender - person whom this right been granted.
37      *  @param value   - value to spend.
38      * 
39      *  @return true in case of succes, otherwise failure
40      * 
41      */
42     function approve(address spender, uint256 value) returns (bool success);
43 
44     /**
45      *
46      * allowance() - constant function to check how much is 
47      *               permitted to spend to 3rd person from owner balance
48      *
49      *  @param owner   - owner of the balance
50      *  @param spender - permitted to spend from this balance person 
51      *  
52      *  @return - remaining right to spend 
53      * 
54      */
55     function allowance(address owner, address spender) constant returns (uint256 remaining);
56     
57     function totalSupply() constant returns (uint256 totalSupply){
58         return totalSupplyVar;    
59     }
60 
61     // events notifications
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 pragma solidity ^0.4.2;
67 
68 /*
69  * StandardToken - is a smart contract  
70  * for managing common functionality of 
71  * a token.
72  *
73  * ERC.20 Token standard: 
74  *         https://github.com/eth ereum/EIPs/issues/20
75  */
76 contract StandardToken is TokenInterface {
77 
78 
79     // token ownership
80     mapping (address => uint256) balances;
81 
82     // spending permision management
83     mapping (address => mapping (address => uint256)) allowed;
84     
85     
86     
87     function StandardToken(){
88     }
89     
90     
91     /**
92      * transfer() - transfer tokens from msg.sender balance 
93      *              to requested account
94      *
95      *  @param to    - target address to transfer tokens
96      *  @param value - ammount of tokens to transfer
97      *
98      *  @return - success / failure of the transaction
99      */    
100     function transfer(address to, uint256 value) returns (bool success) {
101         
102         
103         if (balances[msg.sender] >= value && value > 0) {
104 
105             // do actual tokens transfer       
106             balances[msg.sender] -= value;
107             balances[to]         += value;
108             
109             // rise the Transfer event
110             Transfer(msg.sender, to, value);
111             return true;
112         } else {
113             
114             return false; 
115         }
116     }
117     
118     
119 
120     
121     /**
122      * transferFrom() - used to move allowed funds from other owner
123      *                  account 
124      *
125      *  @param from  - move funds from account
126      *  @param to    - move funds to account
127      *  @param value - move the value 
128      *
129      *  @return - return true on success false otherwise 
130      */
131     function transferFrom(address from, address to, uint256 value) returns (bool success) {
132     
133         if ( balances[from] >= value && 
134              allowed[from][msg.sender] >= value && 
135              value > 0) {
136                                           
137     
138             // do the actual transfer
139             balances[from] -= value;    
140             balances[to]   += value;            
141             
142 
143             // addjust the permision, after part of 
144             // permited to spend value was used
145             allowed[from][msg.sender] -= value;
146             
147             // rise the Transfer event
148             Transfer(from, to, value);
149             return true;
150         } else { 
151             
152             return false; 
153         }
154     }
155 
156     
157 
158     
159     /**
160      *
161      * balanceOf() - constant function check concrete tokens balance  
162      *
163      *  @param owner - account owner
164      *  
165      *  @return the value of balance 
166      */                               
167     function balanceOf(address owner) constant returns (uint256 balance) {
168         return balances[owner];
169     }
170 
171     
172     
173     /**
174      *
175      * approve() - function approves to a person to spend some tokens from 
176      *           owner balance. 
177      *
178      *  @param spender - person whom this right been granted.
179      *  @param value   - value to spend.
180      * 
181      *  @return true in case of succes, otherwise failure
182      * 
183      */
184     function approve(address spender, uint256 value) returns (bool success) {
185         
186         
187         
188         // now spender can use balance in 
189         // ammount of value from owner balance
190         allowed[msg.sender][spender] = value;
191         
192         // rise event about the transaction
193         Approval(msg.sender, spender, value);
194         
195         return true;
196     }
197     
198 
199     /**
200      *
201      * allowance() - constant function to check how mouch is 
202      *               permited to spend to 3rd person from owner balance
203      *
204      *  @param owner   - owner of the balance
205      *  @param spender - permited to spend from this balance person 
206      *  
207      *  @return - remaining right to spend 
208      * 
209      */
210     function allowance(address owner, address spender) constant returns (uint256 remaining) {
211       return allowed[owner][spender];
212     }
213 
214 }
215 
216 
217 pragma solidity ^0.4.6;
218 
219 /**
220  * 
221  * EventInfo - imutable class that denotes
222  * the time of the virtual accelerator hack
223  * event
224  * 
225  */
226 contract EventInfo{
227     
228     
229     uint constant HACKATHON_5_WEEKS = 60 * 60 * 24 * 7 * 5;
230     uint constant T_1_WEEK = 60 * 60 * 24 * 7;
231 
232     uint eventStart = 1479391200; // Thu, 17 Nov 2016 14:00:00 GMT
233     uint eventEnd = eventStart + HACKATHON_5_WEEKS;
234     
235     
236     /**
237      * getEventStart - return the start of the event time
238      */ 
239     function getEventStart() constant returns (uint result){        
240        return eventStart;
241     } 
242     
243     /**
244      * getEventEnd - return the end of the event time
245      */ 
246     function getEventEnd() constant returns (uint result){        
247        return eventEnd;
248     } 
249     
250     
251     /**
252      * getVotingStart - the voting starts 1 week after the 
253      *                  event starts
254      */ 
255     function getVotingStart() constant returns (uint result){
256         return eventStart+ T_1_WEEK;
257     }
258 
259     /**
260      * getTradingStart - the DST tokens trading starts 1 week 
261      *                   after the event starts
262      */ 
263     function getTradingStart() constant returns (uint result){
264         return eventStart+ T_1_WEEK;
265     }
266 
267     /**
268      * getNow - helper class to check what time the contract see
269      */
270     function getNow() constant returns (uint result){        
271        return now;
272     } 
273     
274 }
275 
276 pragma solidity ^0.4.0;
277 
278 /**
279  *
280  * @title Hacker Gold
281  * 
282  * The official token powering the hack.ether.camp virtual accelerator.
283  * This is the only way to acquire tokens from startups during the event.
284  *
285  * Whitepaper https://hack.ether.camp/whitepaper
286  *
287  */
288 contract HackerGold is StandardToken {
289 
290     // Name of the token    
291     string public name = "HackerGold";
292 
293     // Decimal places
294     uint8  public decimals = 3;
295     // Token abbreviation        
296     string public symbol = "HKG";
297     
298     // 1 ether = 200 hkg
299     uint BASE_PRICE = 200;
300     // 1 ether = 150 hkg
301     uint MID_PRICE = 150;
302     // 1 ether = 100 hkg
303     uint FIN_PRICE = 100;
304     // Safety cap
305     uint SAFETY_LIMIT = 4000000 ether;
306     // Zeros after the point
307     uint DECIMAL_ZEROS = 1000;
308     
309     // Total value in wei
310     uint totalValue;
311     
312     // Address of multisig wallet holding ether from sale
313     address wallet;
314 
315     // Structure of sale increase milestones
316     struct milestones_struct {
317       uint p1;
318       uint p2; 
319       uint p3;
320       uint p4;
321       uint p5;
322       uint p6;
323     }
324     // Milestones instance
325     milestones_struct milestones;
326     
327     /**
328      * Constructor of the contract.
329      * 
330      * Passes address of the account holding the value.
331      * HackerGold contract itself does not hold any value
332      * 
333      * @param multisig address of MultiSig wallet which will hold the value
334      */
335     function HackerGold(address multisig) {
336         
337         wallet = multisig;
338 
339         // set time periods for sale
340         milestones = milestones_struct(
341         
342           1476972000,  // P1: GMT: 20-Oct-2016 14:00  => The Sale Starts
343           1478181600,  // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
344           1479391200,  // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
345                        //                                Hackathon Starts
346           1480600800,  // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
347           1481810400,  // P5: GMT: 15-Dec-2016 14:00  => Price Stable
348           1482415200   // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
349         );
350         
351         // assign recovery balance
352         totalSupplyVar   = 16110893000;
353         balances[0x342e62732b76875da9305083ea8ae63125a4e667] = 16110893000;
354         totalValue    = 85362 ether;        
355     }
356     
357     
358     /**
359      * Fallback function: called on ether sent.
360      * 
361      * It calls to createHKG function with msg.sender 
362      * as a value for holder argument
363      */
364     function () payable {
365         createHKG(msg.sender);
366     }
367     
368     /**
369      * Creates HKG tokens.
370      * 
371      * Runs sanity checks including safety cap
372      * Then calculates current price by getPrice() function, creates HKG tokens
373      * Finally sends a value of transaction to the wallet
374      * 
375      * Note: due to lack of floating point types in Solidity,
376      * contract assumes that last 3 digits in tokens amount are stood after the point.
377      * It means that if stored HKG balance is 100000, then its real value is 100 HKG
378      * 
379      * @param holder token holder
380      */
381     function createHKG(address holder) payable {
382         
383         if (now < milestones.p1) throw;
384         if (now >= milestones.p6) throw;
385         if (msg.value == 0) throw;
386     
387         // safety cap
388         if (getTotalValue() + msg.value > SAFETY_LIMIT) throw; 
389     
390         uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
391 
392         totalSupplyVar += tokens;
393         balances[holder] += tokens;
394         totalValue += msg.value;
395         
396         if (!wallet.send(msg.value)) throw;
397     }
398     
399     /**
400      * Denotes complete price structure during the sale.
401      *
402      * @return HKG amount per 1 ETH for the current moment in time
403      */
404     function getPrice() constant returns (uint result) {
405         
406         if (now < milestones.p1) return 0;
407         
408         if (now >= milestones.p1 && now < milestones.p2) {
409         
410             return BASE_PRICE;
411         }
412         
413         if (now >= milestones.p2 && now < milestones.p3) {
414             
415             uint days_in = 1 + (now - milestones.p2) / 1 days; 
416             return BASE_PRICE - days_in * 25 / 7;  // daily decrease 3.5
417         }
418 
419         if (now >= milestones.p3 && now < milestones.p4) {
420         
421             return MID_PRICE;
422         }
423         
424         if (now >= milestones.p4 && now < milestones.p5) {
425             
426             days_in = 1 + (now - milestones.p4) / 1 days; 
427             return MID_PRICE - days_in * 25 / 7;  // daily decrease 3.5
428         }
429 
430         if (now >= milestones.p5 && now < milestones.p6) {
431         
432             return FIN_PRICE;
433         }
434         
435         if (now >= milestones.p6){
436 
437             return 0;
438         }
439 
440      }
441     
442     /**
443      * Returns total stored HKG amount.
444      * 
445      * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
446      * Thus, result of this function should be divided by 1000 to get HKG value
447      * 
448      * @return result stored HKG amount
449      */
450     function getTotalSupply() constant returns (uint result) {
451         return totalSupplyVar;
452     } 
453 
454     /**
455      * It is used for test purposes.
456      * 
457      * Returns the result of 'now' statement of Solidity language
458      * 
459      * @return unix timestamp for current moment in time
460      */
461     function getNow() constant returns (uint result) {
462         return now;
463     }
464 
465     /**
466      * Returns total value passed through the contract
467      * 
468      * @return result total value in wei
469      */
470     function getTotalValue() constant returns (uint result) {
471         return totalValue;  
472     }
473 }
474 
475 pragma solidity ^0.4.6;
476 
477 /*
478  * DSTContract - DST stands for decentralized startup team.
479  *               the contract ensures funding for a decentralized
480  *               team in 2 phases: 
481  *
482  *                +. Funding by HKG during the hackathon event. 
483  *                +. Funding by Ether after the event is over. 
484  *
485  *               After the funds been collected there is a governence
486  *               mechanism managed by proposition to withdraw funds
487  *               for development usage. 
488  *
489  *               The DST ensures that backers of the projects keeps
490  *               some influence on the project by ability to reject
491  *               propositions they find as non effective. 
492  *
493  *               In very radical occasions the backers may loose 
494  *               the trust in the team completelly, in that case 
495  *               there is an option to propose impeachment process
496  *               completelly removing the execute and assigning new
497  *               person to manage the funds. 
498  *
499  */
500 contract DSTContract is StandardToken{
501 
502     // Zeros after the point
503     uint DECIMAL_ZEROS = 1000;
504     // Proposal lifetime
505     uint PROPOSAL_LIFETIME = 10 days;
506     // Proposal funds threshold, in percents
507     uint PROPOSAL_FUNDS_TH = 20;
508 
509     address   executive; 
510         
511     EventInfo eventInfo;
512     
513     // Indicated where the DST is traded
514     address virtualExchangeAddress;
515     
516     HackerGold hackerGold;
517         
518     mapping (address => uint256) votingRights;
519 
520 
521     // 1 - HKG => DST qty; tokens for 1 HKG
522     uint hkgPrice;
523     
524     // 1 - Ether => DST qty; tokens for 1 Ether
525     uint etherPrice;
526     
527     string public name = "...";                   
528     uint8  public decimals = 3;                 
529     string public symbol = "...";
530     
531     bool ableToIssueTokens = true; 
532     
533     uint preferedQtySold;
534 
535     uint collectedHKG; 
536     uint collectedEther;    
537     
538     // Proposal of the funds spending
539     mapping (bytes32 => Proposal) proposals;
540 
541     enum ProposalCurrency { HKG, ETHER }
542     ProposalCurrency enumDeclaration;
543                   
544        
545     struct Proposal{
546         
547         bytes32 id;
548         uint value;
549 
550         string urlDetails;
551 
552         uint votindEndTS;
553                 
554         uint votesObjecting;
555         
556         address submitter;
557         bool redeemed;
558 
559         ProposalCurrency proposalCurrency;
560         
561         mapping (address => bool) voted;
562     }
563     uint counterProposals;
564     uint timeOfLastProposal;
565     
566     Proposal[] listProposals;
567     
568 
569     /**
570      * Impeachment process proposals
571      */    
572     struct ImpeachmentProposal{
573         
574         string urlDetails;
575         
576         address newExecutive;
577 
578         uint votindEndTS;        
579         uint votesSupporting;
580         
581         mapping (address => bool) voted;        
582     }
583     ImpeachmentProposal lastImpeachmentProposal;
584 
585         
586     /**
587      * 
588      *  DSTContract: ctor for DST token and governence contract
589      *
590      *  @param eventInfoAddr EventInfo: address of object denotes events 
591      *                                  milestones      
592      *  @param hackerGoldAddr HackerGold: address of HackerGold token
593      *
594      *  @param dstName string: dstName: real name of the team
595      *
596      *  @param dstSymbol string: 3 letter symbold of the team
597      *
598      */ 
599     function DSTContract(EventInfo eventInfoAddr, HackerGold hackerGoldAddr, string dstName, string dstSymbol){
600     
601       executive   = msg.sender;  
602       name        = dstName;
603       symbol      = dstSymbol;
604 
605       hackerGold = HackerGold(hackerGoldAddr);
606       eventInfo  = EventInfo(eventInfoAddr);
607     }
608     
609 
610     function() payable
611                onlyAfterEnd {
612         
613         // there is tokens left from hackathon 
614         if (etherPrice == 0) throw;
615         
616         uint tokens = msg.value * etherPrice * DECIMAL_ZEROS / (1 ether);
617         
618         // check if demand of tokens is 
619         // overflow the supply 
620         uint retEther = 0;
621         if (balances[this] < tokens) {
622             
623             tokens = balances[this];
624             retEther = msg.value - tokens / etherPrice * (1 finney);
625         
626             // return left ether 
627             if (!msg.sender.send(retEther)) throw;
628         }
629         
630         
631         // do transfer
632         balances[msg.sender] += tokens;
633         balances[this] -= tokens;
634         
635         // count collected ether 
636         collectedEther += msg.value - retEther; 
637         
638         // rise event
639         BuyForEtherTransaction(msg.sender, collectedEther, totalSupplyVar, etherPrice, tokens);
640         
641     }
642 
643     
644     
645     /**
646      * setHKGPrice - set price: 1HKG => DST tokens qty
647      *
648      *  @param qtyForOneHKG uint: DST tokens for 1 HKG
649      * 
650      */    
651      function setHKGPrice(uint qtyForOneHKG) onlyExecutive  {
652          
653          hkgPrice = qtyForOneHKG;
654          PriceHKGChange(qtyForOneHKG, preferedQtySold, totalSupplyVar);
655      }
656      
657      
658     
659     /**
660      * 
661      * issuePreferedTokens - prefered tokens issued on the hackathon event
662      *                       grant special rights
663      *
664      *  @param qtyForOneHKG uint: price DST tokens for one 1 HKG
665      *  @param qtyToEmit uint: new supply of tokens 
666      * 
667      */
668     function issuePreferedTokens(uint qtyForOneHKG, 
669                                  uint256 qtyToEmit) onlyExecutive 
670                                                  onlyIfAbleToIssueTokens
671                                                  onlyBeforeEnd
672                                                  onlyAfterTradingStart {
673                 
674         // no issuence is allowed before enlisted on the
675         // exchange 
676         if (virtualExchangeAddress == 0x0) throw;
677             
678         totalSupplyVar += qtyToEmit;
679         balances[this] += qtyToEmit;
680         hkgPrice = qtyForOneHKG;
681         
682         
683         // now spender can use balance in 
684         // amount of value from owner balance
685         allowed[this][virtualExchangeAddress] += qtyToEmit;
686         
687         // rise event about the transaction
688         Approval(this, virtualExchangeAddress, qtyToEmit);
689         
690         // rise event 
691         DstTokensIssued(hkgPrice, preferedQtySold, totalSupplyVar, qtyToEmit);
692     }
693 
694     
695     
696     
697     /**
698      * 
699      * buyForHackerGold - on the hack event this function is available 
700      *                    the buyer for hacker gold will gain votes to 
701      *                    influence future proposals on the DST
702      *    
703      *  @param hkgValue - qty of this DST tokens for 1 HKG     
704      * 
705      */
706     function buyForHackerGold(uint hkgValue) onlyBeforeEnd 
707                                              returns (bool success) {
708     
709       // validate that the caller is official accelerator HKG Exchange
710       if (msg.sender != virtualExchangeAddress) throw;
711       
712       
713       // transfer token 
714       address sender = tx.origin;
715       uint tokensQty = hkgValue * hkgPrice;
716 
717       // gain voting rights
718       votingRights[sender] +=tokensQty;
719       preferedQtySold += tokensQty;
720       collectedHKG += hkgValue;
721 
722       // do actual transfer
723       transferFrom(this, 
724                    virtualExchangeAddress, tokensQty);
725       transfer(sender, tokensQty);        
726             
727       // rise event       
728       BuyForHKGTransaction(sender, preferedQtySold, totalSupplyVar, hkgPrice, tokensQty);
729         
730       return true;
731     }
732         
733     
734     /**
735      * 
736      * issueTokens - function will issue tokens after the 
737      *               event, able to sell for 1 ether 
738      * 
739      *  @param qtyForOneEther uint: DST tokens for 1 ETH
740      *  @param qtyToEmit uint: new tokens supply
741      *
742      */
743     function issueTokens(uint qtyForOneEther, 
744                          uint qtyToEmit) onlyAfterEnd 
745                                          onlyExecutive
746                                          onlyIfAbleToIssueTokens {
747          
748          balances[this] += qtyToEmit;
749          etherPrice = qtyForOneEther;
750          totalSupplyVar    += qtyToEmit;
751          
752          // rise event  
753          DstTokensIssued(qtyForOneEther, totalSupplyVar, totalSupplyVar, qtyToEmit);
754     }
755      
756     
757     /**
758      * setEtherPrice - change the token price
759      *
760      *  @param qtyForOneEther uint: new price - DST tokens for 1 ETH
761      */     
762     function setEtherPrice(uint qtyForOneEther) onlyAfterEnd
763                                                 onlyExecutive {
764          etherPrice = qtyForOneEther; 
765 
766          // rise event for this
767          NewEtherPrice(qtyForOneEther);
768     }    
769     
770 
771     /**
772      *  disableTokenIssuance - function will disable any 
773      *                         option for future token 
774      *                         issuence
775      */
776     function disableTokenIssuance() onlyExecutive {
777         ableToIssueTokens = false;
778         
779         DisableTokenIssuance();
780     }
781 
782     
783     /**
784      *  burnRemainToken -  eliminated all available for sale
785      *                     tokens. 
786      */
787     function burnRemainToken() onlyExecutive {
788     
789         totalSupplyVar -= balances[this];
790         balances[this] = 0;
791         
792         // rise event for this
793         BurnedAllRemainedTokens();
794     }
795     
796     /**
797      *  submitEtherProposal: submit proposal to use part of the 
798      *                       collected ether funds
799      *
800      *   @param requestValue uint: value in wei 
801      *   @param url string: details of the proposal 
802      */ 
803     function submitEtherProposal(uint requestValue, string url) onlyAfterEnd 
804                                                                 onlyExecutive returns (bytes32 resultId, bool resultSucces) {       
805     
806         // ensure there is no more issuence available 
807         if (ableToIssueTokens) throw;
808             
809         // ensure there is no more tokens available 
810         if (balanceOf(this) > 0) throw;
811 
812         // Possible to submit a proposal once 2 weeks 
813         if (now < (timeOfLastProposal + 2 weeks)) throw;
814             
815         uint percent = collectedEther / 100;
816             
817         if (requestValue > PROPOSAL_FUNDS_TH * percent) throw;
818 
819         // if remained value is less than requested gain all.
820         if (requestValue > this.balance) 
821             requestValue = this.balance;    
822             
823         // set id of the proposal
824         // submit proposal to the map
825         bytes32 id = sha3(msg.data, now);
826         uint timeEnds = now + PROPOSAL_LIFETIME; 
827             
828         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.ETHER);
829         proposals[id] = newProposal;
830         listProposals.push(newProposal);
831             
832         timeOfLastProposal = now;                        
833         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
834         
835         return (id, true);
836     }
837     
838     
839      
840     /**
841      * 
842      * submitHKGProposal - submit proposal to request for 
843      *                     partial HKG funds collected 
844      * 
845      *  @param requestValue uint: value in HKG to request. 
846      *  @param url string: url with details on the proposition 
847      */
848     function submitHKGProposal(uint requestValue, string url) onlyAfterEnd
849                                                               onlyExecutive returns (bytes32 resultId, bool resultSucces){
850         
851 
852         // If there is no 2 months over since the last event.
853         // There is no posible to get any HKG. After 2 months
854         // all the HKG is available. 
855         if (now < (eventInfo.getEventEnd() + 8 weeks)) {
856             throw;
857         }
858 
859         // Possible to submit a proposal once 2 weeks 
860         if (now < (timeOfLastProposal + 2 weeks)) throw;
861 
862         uint percent = preferedQtySold / 100;
863         
864         // validate the amount is legit
865         // first 5 proposals should be less than 20% 
866         if (counterProposals <= 5 && 
867             requestValue     >  PROPOSAL_FUNDS_TH * percent) throw;
868                 
869         // if remained value is less than requested 
870         // gain all.
871         if (requestValue > getHKGOwned()) 
872             requestValue = getHKGOwned();
873         
874         
875         // set id of the proposal
876         // submit proposal to the map
877         bytes32 id = sha3(msg.data, now);
878         uint timeEnds = now + PROPOSAL_LIFETIME; 
879         
880         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.HKG);
881         proposals[id] = newProposal;
882         listProposals.push(newProposal);
883         
884         ++counterProposals;
885         timeOfLastProposal = now;                
886                 
887         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
888         
889         return (id, true);        
890     }  
891     
892     
893     
894     /**
895      * objectProposal - object previously submitted proposal, 
896      *                  the objection right is obtained by 
897      *                  purchasing prefered tokens on time of 
898      *                  the hackathon.
899      * 
900      *  @param id bytes32 : the id of the proposla to redeem
901      */
902      function objectProposal(bytes32 id){
903          
904         Proposal memory proposal = proposals[id];
905          
906         // check proposal exist 
907         if (proposals[id].id == 0) throw;
908 
909         // check already redeemed
910         if (proposals[id].redeemed) throw;
911          
912         // ensure objection time
913         if (now >= proposals[id].votindEndTS) throw;
914          
915         // ensure not voted  
916         if (proposals[id].voted[msg.sender]) throw;
917          
918          // submit votes
919          uint votes = votingRights[msg.sender];
920          proposals[id].votesObjecting += votes;
921          
922          // mark voted 
923          proposals[id].voted[msg.sender] = true; 
924          
925          uint idx = getIndexByProposalId(id);
926          listProposals[idx] = proposals[id];   
927 
928          ObjectedVote(id, msg.sender, votes);         
929      }
930      
931      
932      function getIndexByProposalId(bytes32 id) returns (uint result){
933          
934          for (uint i = 0; i < listProposals.length; ++i){
935              if (id == listProposals[i].id) return i;
936          }
937      }
938     
939     
940    
941     /**
942      * redeemProposalFunds - redeem funds requested by prior 
943      *                       submitted proposal     
944      * 
945      * @param id bytes32: the id of the proposal to redeem
946      */
947     function redeemProposalFunds(bytes32 id) onlyExecutive {
948 
949         if (proposals[id].id == 0) throw;
950         if (proposals[id].submitter != msg.sender) throw;
951 
952         // ensure objection time
953         if (now < proposals[id].votindEndTS) throw;
954                            
955     
956             // check already redeemed
957         if (proposals[id].redeemed) throw;
958 
959         // check votes objection => 55% of total votes
960         uint objectionThreshold = preferedQtySold / 100 * 55;
961         if (proposals[id].votesObjecting  > objectionThreshold) throw;
962     
963     
964         if (proposals[id].proposalCurrency == ProposalCurrency.HKG){
965             
966             // send hacker gold 
967             hackerGold.transfer(proposals[id].submitter, proposals[id].value);      
968                         
969         } else {
970                         
971            // send ether              
972            bool success = proposals[id].submitter.send(proposals[id].value); 
973 
974            // rise event
975            EtherRedeemAccepted(proposals[id].submitter, proposals[id].value);                              
976         }
977         
978         // execute the proposal 
979         proposals[id].redeemed = true; 
980     }
981     
982     
983     /**
984      *  getAllTheFunds - to ensure there is no deadlock can 
985      *                   can happen, and no case that voting 
986      *                   structure will freeze the funds forever
987      *                   the startup will be able to get all the
988      *                   funds without a proposal required after
989      *                   6 months.
990      * 
991      * 
992      */             
993     function getAllTheFunds() onlyExecutive {
994         
995         // If there is a deadlock in voting participates
996         // the funds can be redeemed completelly in 6 months
997         if (now < (eventInfo.getEventEnd() + 24 weeks)) {
998             throw;
999         }  
1000         
1001         // all the Ether
1002         bool success = msg.sender.send(this.balance);        
1003         
1004         // all the HKG
1005         hackerGold.transfer(msg.sender, getHKGOwned());              
1006     }
1007     
1008     
1009     /**
1010      * submitImpeachmentProposal - submit request to switch 
1011      *                             executive.
1012      * 
1013      *  @param urlDetails  - details of the impeachment proposal 
1014      *  @param newExecutive - address of the new executive 
1015      * 
1016      */             
1017      function submitImpeachmentProposal(string urlDetails, address newExecutive){
1018          
1019         // to offer impeachment you should have 
1020         // voting rights
1021         if (votingRights[msg.sender] == 0) throw;
1022          
1023         // the submission of the first impeachment 
1024         // proposal is possible only after 3 months
1025         // since the hackathon is over
1026         if (now < (eventInfo.getEventEnd() + 12 weeks)) throw;
1027         
1028                 
1029         // check there is 1 months over since last one
1030         if (lastImpeachmentProposal.votindEndTS != 0 && 
1031             lastImpeachmentProposal.votindEndTS +  2 weeks > now) throw;
1032 
1033 
1034         // submit impeachment proposal
1035         // add the votes of the submitter 
1036         // to the proposal right away
1037         lastImpeachmentProposal = ImpeachmentProposal(urlDetails, newExecutive, now + 2 weeks, votingRights[msg.sender]);
1038         lastImpeachmentProposal.voted[msg.sender] = true;
1039          
1040         // rise event
1041         ImpeachmentProposed(msg.sender, urlDetails, now + 2 weeks, newExecutive);
1042      }
1043     
1044     
1045     /**
1046      * supportImpeachment - vote for impeachment proposal 
1047      *                      that is currently in progress
1048      *
1049      */
1050     function supportImpeachment(){
1051 
1052         // ensure that support is for exist proposal 
1053         if (lastImpeachmentProposal.newExecutive == 0x0) throw;
1054     
1055         // to offer impeachment you should have 
1056         // voting rights
1057         if (votingRights[msg.sender] == 0) throw;
1058         
1059         // check if not voted already 
1060         if (lastImpeachmentProposal.voted[msg.sender]) throw;
1061         
1062         // check if not finished the 2 weeks of voting 
1063         if (lastImpeachmentProposal.votindEndTS + 2 weeks <= now) throw;
1064                 
1065         // support the impeachment
1066         lastImpeachmentProposal.voted[msg.sender] = true;
1067         lastImpeachmentProposal.votesSupporting += votingRights[msg.sender];
1068 
1069         // rise impeachment suppporting event
1070         ImpeachmentSupport(msg.sender, votingRights[msg.sender]);
1071         
1072         // if the vote is over 70% execute the switch 
1073         uint percent = preferedQtySold / 100; 
1074         
1075         if (lastImpeachmentProposal.votesSupporting >= 70 * percent){
1076             executive = lastImpeachmentProposal.newExecutive;
1077             
1078             // impeachment event
1079             ImpeachmentAccepted(executive);
1080         }
1081         
1082     } 
1083     
1084       
1085     
1086     // **************************** //
1087     // *     Constant Getters     * //
1088     // **************************** //
1089     
1090     function votingRightsOf(address _owner) constant returns (uint256 result) {
1091         result = votingRights[_owner];
1092     }
1093     
1094     function getPreferedQtySold() constant returns (uint result){
1095         return preferedQtySold;
1096     }
1097     
1098     function setVirtualExchange(address virtualExchangeAddr){
1099         if (virtualExchangeAddress != 0x0) throw;
1100         virtualExchangeAddress = virtualExchangeAddr;
1101     }
1102 
1103     function getHKGOwned() constant returns (uint result){
1104         return hackerGold.balanceOf(this);
1105     }
1106     
1107     function getEtherValue() constant returns (uint result){
1108         return this.balance;
1109     }
1110     
1111     function getExecutive() constant returns (address result){
1112         return executive;
1113     }
1114     
1115     function getHKGPrice() constant returns (uint result){
1116         return hkgPrice;
1117     }
1118 
1119     function getEtherPrice() constant returns (uint result){
1120         return etherPrice;
1121     }
1122     
1123     function getDSTName() constant returns(string result){
1124         return name;
1125     }    
1126     
1127     function getDSTNameBytes() constant returns(bytes32 result){
1128         return convert(name);
1129     }    
1130 
1131     function getDSTSymbol() constant returns(string result){
1132         return symbol;
1133     }    
1134     
1135     function getDSTSymbolBytes() constant returns(bytes32 result){
1136         return convert(symbol);
1137     }    
1138 
1139     function getAddress() constant returns (address result) {
1140         return this;
1141     }
1142     
1143     function getTotalSupply() constant returns (uint result) {
1144         return totalSupplyVar;
1145     } 
1146         
1147     function getCollectedEther() constant returns (uint results) {        
1148         return collectedEther;
1149     }
1150     
1151     function getCounterProposals() constant returns (uint result){
1152         return counterProposals;
1153     }
1154         
1155     function getProposalIdByIndex(uint i) constant returns (bytes32 result){
1156         return listProposals[i].id;
1157     }    
1158 
1159     function getProposalObjectionByIndex(uint i) constant returns (uint result){
1160         return listProposals[i].votesObjecting;
1161     }
1162 
1163     function getProposalValueByIndex(uint i) constant returns (uint result){
1164         return listProposals[i].value;
1165     }                  
1166     
1167     function getCurrentImpeachmentUrlDetails() constant returns (string result){
1168         return lastImpeachmentProposal.urlDetails;
1169     }
1170     
1171     
1172     function getCurrentImpeachmentVotesSupporting() constant returns (uint result){
1173         return lastImpeachmentProposal.votesSupporting;
1174     }
1175     
1176     function convert(string key) returns (bytes32 ret) {
1177             if (bytes(key).length > 32) {
1178                 throw;
1179             }      
1180 
1181             assembly {
1182                 ret := mload(add(key, 32))
1183             }
1184     }    
1185     
1186     // Emergency Fix limited by time functions
1187     function setVoteRight(address voter, uint ammount){
1188         
1189         // limited by [24 Jan 2017 00:00:00 GMT]
1190         if (now > 1485216000) throw;
1191 
1192         // limited by one account to fix 
1193         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1194 
1195         votingRights[voter] = ammount;
1196     }
1197     
1198     // Emergency Fix limited by time functions
1199     function setBalance(address owner, uint ammount){
1200 
1201         // limited by [24 Jan 2017 00:00:00 GMT]
1202         if (now > 1485216000) throw;
1203         
1204         // limited by one account to fix 
1205         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1206         
1207         balances[owner] = ammount;
1208     }
1209     
1210     // Emergency Fix limited by time functions
1211     function setInternalInfo(address fixExecutive, uint fixTotalSupply, uint256 fixPreferedQtySold, 
1212             uint256 fixCollectedHKG, uint fixCollectedEther){
1213 
1214         // limited by [24 Jan 2017 00:00:00 GMT]
1215         if (now > 1485216000) throw;
1216         
1217         // limited by one account to fix 
1218         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1219         
1220         executive = fixExecutive;
1221         totalSupplyVar = fixTotalSupply;
1222         preferedQtySold = fixPreferedQtySold;
1223         collectedHKG = fixCollectedHKG;
1224         collectedEther = fixCollectedEther;
1225     }
1226     
1227     
1228     // ********************* //
1229     // *     Modifiers     * //
1230     // ********************* //    
1231  
1232     modifier onlyBeforeEnd() { if (now  >=  eventInfo.getEventEnd()) throw; _; }
1233     modifier onlyAfterEnd()  { if (now  <   eventInfo.getEventEnd()) throw; _; }
1234     
1235     modifier onlyAfterTradingStart()  { if (now  < eventInfo.getTradingStart()) throw; _; }
1236     
1237     modifier onlyExecutive()     { if (msg.sender != executive) throw; _; }
1238                                        
1239     modifier onlyIfAbleToIssueTokens()  { if (!ableToIssueTokens) throw; _; } 
1240     
1241 
1242     // ****************** //
1243     // *     Events     * //
1244     // ****************** //        
1245 
1246     
1247     event PriceHKGChange(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply);
1248     event BuyForHKGTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneHKG, uint tokensAmount);
1249     event BuyForEtherTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneEther, uint tokensAmount);
1250 
1251     event DstTokensIssued(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply, uint qtyToEmit);
1252     
1253     event ProposalRequestSubmitted(bytes32 id, uint value, uint timeEnds, string url, address sender);
1254     
1255     event EtherRedeemAccepted(address sender, uint value);
1256     
1257     event ObjectedVote(bytes32 id, address voter, uint votes);
1258     
1259     event ImpeachmentProposed(address submitter, string urlDetails, uint votindEndTS, address newExecutive);
1260     event ImpeachmentSupport(address supportter, uint votes);
1261     
1262     event ImpeachmentAccepted(address newExecutive);
1263 
1264     event NewEtherPrice(uint newQtyForOneEther);
1265     event DisableTokenIssuance();
1266     
1267     event BurnedAllRemainedTokens();
1268     
1269 }