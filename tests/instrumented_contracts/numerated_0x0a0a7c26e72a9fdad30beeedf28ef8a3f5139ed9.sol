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
474 pragma solidity ^0.4.6;
475 
476 /*
477  * DSTContract - DST stands for decentralized startup team.
478  *               the contract ensures funding for a decentralized
479  *               team in 2 phases: 
480  *
481  *                +. Funding by HKG during the hackathon event. 
482  *                +. Funding by Ether after the event is over. 
483  *
484  *               After the funds been collected there is a governence
485  *               mechanism managed by proposition to withdraw funds
486  *               for development usage. 
487  *
488  *               The DST ensures that backers of the projects keeps
489  *               some influence on the project by ability to reject
490  *               propositions they find as non effective. 
491  *
492  *               In very radical occasions the backers may loose 
493  *               the trust in the team completelly, in that case 
494  *               there is an option to propose impeachment process
495  *               completelly removing the execute and assigning new
496  *               person to manage the funds. 
497  *
498  */
499 contract DSTContract is StandardToken{
500 
501     // Zeros after the point
502     uint DECIMAL_ZEROS = 1000;
503     // Proposal lifetime
504     uint PROPOSAL_LIFETIME = 10 days;
505     // Proposal funds threshold, in percents
506     uint PROPOSAL_FUNDS_TH = 20;
507 
508     address   executive; 
509         
510     EventInfo eventInfo;
511     
512     // Indicated where the DST is traded
513     address virtualExchangeAddress;
514     
515     HackerGold hackerGold;
516         
517     mapping (address => uint256) votingRights;
518 
519 
520     // 1 - HKG => DST qty; tokens for 1 HKG
521     uint hkgPrice;
522     
523     // 1 - Ether => DST qty; tokens for 1 Ether
524     uint etherPrice;
525     
526     string public name = "...";                   
527     uint8  public decimals = 3;                 
528     string public symbol = "...";
529     
530     bool ableToIssueTokens = true; 
531     
532     uint preferedQtySold;
533 
534     uint collectedHKG; 
535     uint collectedEther;    
536     
537     // Proposal of the funds spending
538     mapping (bytes32 => Proposal) proposals;
539 
540     enum ProposalCurrency { HKG, ETHER }
541     ProposalCurrency enumDeclaration;
542                   
543        
544     struct Proposal{
545         
546         bytes32 id;
547         uint value;
548 
549         string urlDetails;
550 
551         uint votindEndTS;
552                 
553         uint votesObjecting;
554         
555         address submitter;
556         bool redeemed;
557 
558         ProposalCurrency proposalCurrency;
559         
560         mapping (address => bool) voted;
561     }
562     uint counterProposals;
563     uint timeOfLastProposal;
564     
565     Proposal[] listProposals;
566     
567 
568     /**
569      * Impeachment process proposals
570      */    
571     struct ImpeachmentProposal{
572         
573         string urlDetails;
574         
575         address newExecutive;
576 
577         uint votindEndTS;        
578         uint votesSupporting;
579         
580         mapping (address => bool) voted;        
581     }
582     ImpeachmentProposal lastImpeachmentProposal;
583 
584         
585     /**
586      * 
587      *  DSTContract: ctor for DST token and governence contract
588      *
589      *  @param eventInfoAddr EventInfo: address of object denotes events 
590      *                                  milestones      
591      *  @param hackerGoldAddr HackerGold: address of HackerGold token
592      *
593      *  @param dstName string: dstName: real name of the team
594      *
595      *  @param dstSymbol string: 3 letter symbold of the team
596      *
597      */ 
598     function DSTContract(EventInfo eventInfoAddr, HackerGold hackerGoldAddr, string dstName, string dstSymbol){
599     
600       executive   = msg.sender;  
601       name        = dstName;
602       symbol      = dstSymbol;
603 
604       hackerGold = HackerGold(hackerGoldAddr);
605       eventInfo  = EventInfo(eventInfoAddr);
606     }
607     
608 
609     function() payable
610                onlyAfterEnd {
611         
612         // there is tokens left from hackathon 
613         if (etherPrice == 0) throw;
614         
615         uint tokens = msg.value * etherPrice * DECIMAL_ZEROS / (1 ether);
616         
617         // check if demand of tokens is 
618         // overflow the supply 
619         uint retEther = 0;
620         if (balances[this] < tokens) {
621             
622             tokens = balances[this];
623             retEther = msg.value - tokens / etherPrice * (1 finney);
624         
625             // return left ether 
626             if (!msg.sender.send(retEther)) throw;
627         }
628         
629         
630         // do transfer
631         balances[msg.sender] += tokens;
632         balances[this] -= tokens;
633         
634         // count collected ether 
635         collectedEther += msg.value - retEther; 
636         
637         // rise event
638         BuyForEtherTransaction(msg.sender, collectedEther, totalSupplyVar, etherPrice, tokens);
639         
640     }
641 
642     
643     
644     /**
645      * setHKGPrice - set price: 1HKG => DST tokens qty
646      *
647      *  @param qtyForOneHKG uint: DST tokens for 1 HKG
648      * 
649      */    
650      function setHKGPrice(uint qtyForOneHKG) onlyExecutive  {
651          
652          hkgPrice = qtyForOneHKG;
653          PriceHKGChange(qtyForOneHKG, preferedQtySold, totalSupplyVar);
654      }
655      
656      
657     
658     /**
659      * 
660      * issuePreferedTokens - prefered tokens issued on the hackathon event
661      *                       grant special rights
662      *
663      *  @param qtyForOneHKG uint: price DST tokens for one 1 HKG
664      *  @param qtyToEmit uint: new supply of tokens 
665      * 
666      */
667     function issuePreferedTokens(uint qtyForOneHKG, 
668                                  uint256 qtyToEmit) onlyExecutive 
669                                                  onlyIfAbleToIssueTokens
670                                                  onlyBeforeEnd
671                                                  onlyAfterTradingStart {
672                 
673         // no issuence is allowed before enlisted on the
674         // exchange 
675         if (virtualExchangeAddress == 0x0) throw;
676             
677         totalSupplyVar += qtyToEmit;
678         balances[this] += qtyToEmit;
679         hkgPrice = qtyForOneHKG;
680         
681         
682         // now spender can use balance in 
683         // amount of value from owner balance
684         allowed[this][virtualExchangeAddress] += qtyToEmit;
685         
686         // rise event about the transaction
687         Approval(this, virtualExchangeAddress, qtyToEmit);
688         
689         // rise event 
690         DstTokensIssued(hkgPrice, preferedQtySold, totalSupplyVar, qtyToEmit);
691     }
692 
693     
694     
695     
696     /**
697      * 
698      * buyForHackerGold - on the hack event this function is available 
699      *                    the buyer for hacker gold will gain votes to 
700      *                    influence future proposals on the DST
701      *    
702      *  @param hkgValue - qty of this DST tokens for 1 HKG     
703      * 
704      */
705     function buyForHackerGold(uint hkgValue) onlyBeforeEnd 
706                                              returns (bool success) {
707     
708       // validate that the caller is official accelerator HKG Exchange
709       if (msg.sender != virtualExchangeAddress) throw;
710       
711       
712       // transfer token 
713       address sender = tx.origin;
714       uint tokensQty = hkgValue * hkgPrice;
715 
716       // gain voting rights
717       votingRights[sender] +=tokensQty;
718       preferedQtySold += tokensQty;
719       collectedHKG += hkgValue;
720 
721       // do actual transfer
722       transferFrom(this, 
723                    virtualExchangeAddress, tokensQty);
724       transfer(sender, tokensQty);        
725             
726       // rise event       
727       BuyForHKGTransaction(sender, preferedQtySold, totalSupplyVar, hkgPrice, tokensQty);
728         
729       return true;
730     }
731         
732     
733     /**
734      * 
735      * issueTokens - function will issue tokens after the 
736      *               event, able to sell for 1 ether 
737      * 
738      *  @param qtyForOneEther uint: DST tokens for 1 ETH
739      *  @param qtyToEmit uint: new tokens supply
740      *
741      */
742     function issueTokens(uint qtyForOneEther, 
743                          uint qtyToEmit) onlyAfterEnd 
744                                          onlyExecutive
745                                          onlyIfAbleToIssueTokens {
746          
747          balances[this] += qtyToEmit;
748          etherPrice = qtyForOneEther;
749          totalSupplyVar    += qtyToEmit;
750          
751          // rise event  
752          DstTokensIssued(qtyForOneEther, totalSupplyVar, totalSupplyVar, qtyToEmit);
753     }
754      
755     
756     /**
757      * setEtherPrice - change the token price
758      *
759      *  @param qtyForOneEther uint: new price - DST tokens for 1 ETH
760      */     
761     function setEtherPrice(uint qtyForOneEther) onlyAfterEnd
762                                                 onlyExecutive {
763          etherPrice = qtyForOneEther; 
764 
765          // rise event for this
766          NewEtherPrice(qtyForOneEther);
767     }    
768     
769 
770     /**
771      *  disableTokenIssuance - function will disable any 
772      *                         option for future token 
773      *                         issuence
774      */
775     function disableTokenIssuance() onlyExecutive {
776         ableToIssueTokens = false;
777         
778         DisableTokenIssuance();
779     }
780 
781     
782     /**
783      *  burnRemainToken -  eliminated all available for sale
784      *                     tokens. 
785      */
786     function burnRemainToken() onlyExecutive {
787     
788         totalSupplyVar -= balances[this];
789         balances[this] = 0;
790         
791         // rise event for this
792         BurnedAllRemainedTokens();
793     }
794     
795     /**
796      *  submitEtherProposal: submit proposal to use part of the 
797      *                       collected ether funds
798      *
799      *   @param requestValue uint: value in wei 
800      *   @param url string: details of the proposal 
801      */ 
802     function submitEtherProposal(uint requestValue, string url) onlyAfterEnd 
803                                                                 onlyExecutive returns (bytes32 resultId, bool resultSucces) {       
804     
805         // ensure there is no more issuence available 
806         if (ableToIssueTokens) throw;
807             
808         // ensure there is no more tokens available 
809         if (balanceOf(this) > 0) throw;
810 
811         // Possible to submit a proposal once 2 weeks 
812         if (now < (timeOfLastProposal + 2 weeks)) throw;
813             
814         uint percent = collectedEther / 100;
815             
816         if (requestValue > PROPOSAL_FUNDS_TH * percent) throw;
817 
818         // if remained value is less than requested gain all.
819         if (requestValue > this.balance) 
820             requestValue = this.balance;    
821             
822         // set id of the proposal
823         // submit proposal to the map
824         bytes32 id = sha3(msg.data, now);
825         uint timeEnds = now + PROPOSAL_LIFETIME; 
826             
827         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.ETHER);
828         proposals[id] = newProposal;
829         listProposals.push(newProposal);
830             
831         timeOfLastProposal = now;                        
832         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
833         
834         return (id, true);
835     }
836     
837     
838      
839     /**
840      * 
841      * submitHKGProposal - submit proposal to request for 
842      *                     partial HKG funds collected 
843      * 
844      *  @param requestValue uint: value in HKG to request. 
845      *  @param url string: url with details on the proposition 
846      */
847     function submitHKGProposal(uint requestValue, string url) onlyAfterEnd
848                                                               onlyExecutive returns (bytes32 resultId, bool resultSucces){
849         
850 
851         // If there is no 2 months over since the last event.
852         // There is no posible to get any HKG. After 2 months
853         // all the HKG is available. 
854         if (now < (eventInfo.getEventEnd() + 8 weeks)) {
855             throw;
856         }
857 
858         // Possible to submit a proposal once 2 weeks 
859         if (now < (timeOfLastProposal + 2 weeks)) throw;
860 
861         uint percent = preferedQtySold / 100;
862         
863         // validate the amount is legit
864         // first 5 proposals should be less than 20% 
865         if (counterProposals <= 5 && 
866             requestValue     >  PROPOSAL_FUNDS_TH * percent) throw;
867                 
868         // if remained value is less than requested 
869         // gain all.
870         if (requestValue > getHKGOwned()) 
871             requestValue = getHKGOwned();
872         
873         
874         // set id of the proposal
875         // submit proposal to the map
876         bytes32 id = sha3(msg.data, now);
877         uint timeEnds = now + PROPOSAL_LIFETIME; 
878         
879         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.HKG);
880         proposals[id] = newProposal;
881         listProposals.push(newProposal);
882         
883         ++counterProposals;
884         timeOfLastProposal = now;                
885                 
886         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
887         
888         return (id, true);        
889     }  
890     
891     
892     
893     /**
894      * objectProposal - object previously submitted proposal, 
895      *                  the objection right is obtained by 
896      *                  purchasing prefered tokens on time of 
897      *                  the hackathon.
898      * 
899      *  @param id bytes32 : the id of the proposla to redeem
900      */
901      function objectProposal(bytes32 id){
902          
903         Proposal memory proposal = proposals[id];
904          
905         // check proposal exist 
906         if (proposals[id].id == 0) throw;
907 
908         // check already redeemed
909         if (proposals[id].redeemed) throw;
910          
911         // ensure objection time
912         if (now >= proposals[id].votindEndTS) throw;
913          
914         // ensure not voted  
915         if (proposals[id].voted[msg.sender]) throw;
916          
917          // submit votes
918          uint votes = votingRights[msg.sender];
919          proposals[id].votesObjecting += votes;
920          
921          // mark voted 
922          proposals[id].voted[msg.sender] = true; 
923          
924          uint idx = getIndexByProposalId(id);
925          listProposals[idx] = proposals[id];   
926 
927          ObjectedVote(id, msg.sender, votes);         
928      }
929      
930      
931      function getIndexByProposalId(bytes32 id) returns (uint result){
932          
933          for (uint i = 0; i < listProposals.length; ++i){
934              if (id == listProposals[i].id) return i;
935          }
936      }
937     
938     
939    
940     /**
941      * redeemProposalFunds - redeem funds requested by prior 
942      *                       submitted proposal     
943      * 
944      * @param id bytes32: the id of the proposal to redeem
945      */
946     function redeemProposalFunds(bytes32 id) onlyExecutive {
947 
948         if (proposals[id].id == 0) throw;
949         if (proposals[id].submitter != msg.sender) throw;
950 
951         // ensure objection time
952         if (now < proposals[id].votindEndTS) throw;
953                            
954     
955             // check already redeemed
956         if (proposals[id].redeemed) throw;
957 
958         // check votes objection => 55% of total votes
959         uint objectionThreshold = preferedQtySold / 100 * 55;
960         if (proposals[id].votesObjecting  > objectionThreshold) throw;
961     
962     
963         if (proposals[id].proposalCurrency == ProposalCurrency.HKG){
964             
965             // send hacker gold 
966             hackerGold.transfer(proposals[id].submitter, proposals[id].value);      
967                         
968         } else {
969                         
970            // send ether              
971            bool success = proposals[id].submitter.send(proposals[id].value); 
972 
973            // rise event
974            EtherRedeemAccepted(proposals[id].submitter, proposals[id].value);                              
975         }
976         
977         // execute the proposal 
978         proposals[id].redeemed = true; 
979     }
980     
981     
982     /**
983      *  getAllTheFunds - to ensure there is no deadlock can 
984      *                   can happen, and no case that voting 
985      *                   structure will freeze the funds forever
986      *                   the startup will be able to get all the
987      *                   funds without a proposal required after
988      *                   6 months.
989      * 
990      * 
991      */             
992     function getAllTheFunds() onlyExecutive {
993         
994         // If there is a deadlock in voting participates
995         // the funds can be redeemed completelly in 6 months
996         if (now < (eventInfo.getEventEnd() + 24 weeks)) {
997             throw;
998         }  
999         
1000         // all the Ether
1001         bool success = msg.sender.send(this.balance);        
1002         
1003         // all the HKG
1004         hackerGold.transfer(msg.sender, getHKGOwned());              
1005     }
1006     
1007     
1008     /**
1009      * submitImpeachmentProposal - submit request to switch 
1010      *                             executive.
1011      * 
1012      *  @param urlDetails  - details of the impeachment proposal 
1013      *  @param newExecutive - address of the new executive 
1014      * 
1015      */             
1016      function submitImpeachmentProposal(string urlDetails, address newExecutive){
1017          
1018         // to offer impeachment you should have 
1019         // voting rights
1020         if (votingRights[msg.sender] == 0) throw;
1021          
1022         // the submission of the first impeachment 
1023         // proposal is possible only after 3 months
1024         // since the hackathon is over
1025         if (now < (eventInfo.getEventEnd() + 12 weeks)) throw;
1026         
1027                 
1028         // check there is 1 months over since last one
1029         if (lastImpeachmentProposal.votindEndTS != 0 && 
1030             lastImpeachmentProposal.votindEndTS +  2 weeks > now) throw;
1031 
1032 
1033         // submit impeachment proposal
1034         // add the votes of the submitter 
1035         // to the proposal right away
1036         lastImpeachmentProposal = ImpeachmentProposal(urlDetails, newExecutive, now + 2 weeks, votingRights[msg.sender]);
1037         lastImpeachmentProposal.voted[msg.sender] = true;
1038          
1039         // rise event
1040         ImpeachmentProposed(msg.sender, urlDetails, now + 2 weeks, newExecutive);
1041      }
1042     
1043     
1044     /**
1045      * supportImpeachment - vote for impeachment proposal 
1046      *                      that is currently in progress
1047      *
1048      */
1049     function supportImpeachment(){
1050 
1051         // ensure that support is for exist proposal 
1052         if (lastImpeachmentProposal.newExecutive == 0x0) throw;
1053     
1054         // to offer impeachment you should have 
1055         // voting rights
1056         if (votingRights[msg.sender] == 0) throw;
1057         
1058         // check if not voted already 
1059         if (lastImpeachmentProposal.voted[msg.sender]) throw;
1060         
1061         // check if not finished the 2 weeks of voting 
1062         if (lastImpeachmentProposal.votindEndTS + 2 weeks <= now) throw;
1063                 
1064         // support the impeachment
1065         lastImpeachmentProposal.voted[msg.sender] = true;
1066         lastImpeachmentProposal.votesSupporting += votingRights[msg.sender];
1067 
1068         // rise impeachment suppporting event
1069         ImpeachmentSupport(msg.sender, votingRights[msg.sender]);
1070         
1071         // if the vote is over 70% execute the switch 
1072         uint percent = preferedQtySold / 100; 
1073         
1074         if (lastImpeachmentProposal.votesSupporting >= 70 * percent){
1075             executive = lastImpeachmentProposal.newExecutive;
1076             
1077             // impeachment event
1078             ImpeachmentAccepted(executive);
1079         }
1080         
1081     } 
1082     
1083       
1084     
1085     // **************************** //
1086     // *     Constant Getters     * //
1087     // **************************** //
1088     
1089     function votingRightsOf(address _owner) constant returns (uint256 result) {
1090         result = votingRights[_owner];
1091     }
1092     
1093     function getPreferedQtySold() constant returns (uint result){
1094         return preferedQtySold;
1095     }
1096     
1097     function setVirtualExchange(address virtualExchangeAddr){
1098         if (virtualExchangeAddress != 0x0) throw;
1099         virtualExchangeAddress = virtualExchangeAddr;
1100     }
1101 
1102     function getHKGOwned() constant returns (uint result){
1103         return hackerGold.balanceOf(this);
1104     }
1105     
1106     function getEtherValue() constant returns (uint result){
1107         return this.balance;
1108     }
1109     
1110     function getExecutive() constant returns (address result){
1111         return executive;
1112     }
1113     
1114     function getHKGPrice() constant returns (uint result){
1115         return hkgPrice;
1116     }
1117 
1118     function getEtherPrice() constant returns (uint result){
1119         return etherPrice;
1120     }
1121     
1122     function getDSTName() constant returns(string result){
1123         return name;
1124     }    
1125     
1126     function getDSTNameBytes() constant returns(bytes32 result){
1127         return convert(name);
1128     }    
1129 
1130     function getDSTSymbol() constant returns(string result){
1131         return symbol;
1132     }    
1133     
1134     function getDSTSymbolBytes() constant returns(bytes32 result){
1135         return convert(symbol);
1136     }    
1137 
1138     function getAddress() constant returns (address result) {
1139         return this;
1140     }
1141     
1142     function getTotalSupply() constant returns (uint result) {
1143         return totalSupplyVar;
1144     } 
1145         
1146     function getCollectedEther() constant returns (uint results) {        
1147         return collectedEther;
1148     }
1149     
1150     function getCounterProposals() constant returns (uint result){
1151         return counterProposals;
1152     }
1153         
1154     function getProposalIdByIndex(uint i) constant returns (bytes32 result){
1155         return listProposals[i].id;
1156     }    
1157 
1158     function getProposalObjectionByIndex(uint i) constant returns (uint result){
1159         return listProposals[i].votesObjecting;
1160     }
1161 
1162     function getProposalValueByIndex(uint i) constant returns (uint result){
1163         return listProposals[i].value;
1164     }                  
1165     
1166     function getCurrentImpeachmentUrlDetails() constant returns (string result){
1167         return lastImpeachmentProposal.urlDetails;
1168     }
1169     
1170     
1171     function getCurrentImpeachmentVotesSupporting() constant returns (uint result){
1172         return lastImpeachmentProposal.votesSupporting;
1173     }
1174     
1175     function convert(string key) returns (bytes32 ret) {
1176             if (bytes(key).length > 32) {
1177                 throw;
1178             }      
1179 
1180             assembly {
1181                 ret := mload(add(key, 32))
1182             }
1183     }    
1184     
1185     // Emergency Fix limited by time functions
1186     function setVoteRight(address voter, uint ammount){
1187         
1188         // limited by [17 Jan 2017 00:00:00 GMT]
1189         if (now > 1484611200) throw;
1190 
1191         // limited by one account to fix 
1192         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1193 
1194         votingRights[voter] = ammount;
1195     }
1196     
1197     // Emergency Fix limited by time functions
1198     function setBalance(address owner, uint ammount){
1199 
1200         // limited by [17 Jan 2017 00:00:00 GMT]
1201         if (now > 1484611200) throw;
1202         
1203         // limited by one account to fix 
1204         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1205         
1206         balances[owner] = ammount;
1207     }
1208     
1209     // Emergency Fix limited by time functions
1210     function setInternalInfo(address fixExecutive, uint fixTotalSupply, uint256 fixPreferedQtySold, 
1211             uint256 fixCollectedHKG, uint fixCollectedEther){
1212 
1213         // limited by [17 Jan 2017 00:00:00 GMT]
1214         if (now > 1484611200) throw;
1215         
1216         // limited by one account to fix 
1217         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1218         
1219         executive = fixExecutive;
1220         totalSupplyVar = fixTotalSupply;
1221         preferedQtySold = fixPreferedQtySold;
1222         collectedHKG = fixCollectedHKG;
1223         collectedEther = fixCollectedEther;
1224     }
1225     
1226     
1227     // ********************* //
1228     // *     Modifiers     * //
1229     // ********************* //    
1230  
1231     modifier onlyBeforeEnd() { if (now  >=  eventInfo.getEventEnd()) throw; _; }
1232     modifier onlyAfterEnd()  { if (now  <   eventInfo.getEventEnd()) throw; _; }
1233     
1234     modifier onlyAfterTradingStart()  { if (now  < eventInfo.getTradingStart()) throw; _; }
1235     
1236     modifier onlyExecutive()     { if (msg.sender != executive) throw; _; }
1237                                        
1238     modifier onlyIfAbleToIssueTokens()  { if (!ableToIssueTokens) throw; _; } 
1239     
1240 
1241     // ****************** //
1242     // *     Events     * //
1243     // ****************** //        
1244 
1245     
1246     event PriceHKGChange(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply);
1247     event BuyForHKGTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneHKG, uint tokensAmount);
1248     event BuyForEtherTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneEther, uint tokensAmount);
1249 
1250     event DstTokensIssued(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply, uint qtyToEmit);
1251     
1252     event ProposalRequestSubmitted(bytes32 id, uint value, uint timeEnds, string url, address sender);
1253     
1254     event EtherRedeemAccepted(address sender, uint value);
1255     
1256     event ObjectedVote(bytes32 id, address voter, uint votes);
1257     
1258     event ImpeachmentProposed(address submitter, string urlDetails, uint votindEndTS, address newExecutive);
1259     event ImpeachmentSupport(address supportter, uint votes);
1260     
1261     event ImpeachmentAccepted(address newExecutive);
1262 
1263     event NewEtherPrice(uint newQtyForOneEther);
1264     event DisableTokenIssuance();
1265     
1266     event BurnedAllRemainedTokens();
1267     
1268 }