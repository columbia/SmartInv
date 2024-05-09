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
66 
67 /*
68  * StandardToken - is a smart contract  
69  * for managing common functionality of 
70  * a token.
71  *
72  * ERC.20 Token standard: 
73  *         https://github.com/eth ereum/EIPs/issues/20
74  */
75 contract StandardToken is TokenInterface {
76 
77 
78     // token ownership
79     mapping (address => uint256) balances;
80 
81     // spending permision management
82     mapping (address => mapping (address => uint256)) allowed;
83     
84     
85     
86     function StandardToken(){
87     }
88     
89     
90     /**
91      * transfer() - transfer tokens from msg.sender balance 
92      *              to requested account
93      *
94      *  @param to    - target address to transfer tokens
95      *  @param value - ammount of tokens to transfer
96      *
97      *  @return - success / failure of the transaction
98      */    
99     function transfer(address to, uint256 value) returns (bool success) {
100         
101         
102         if (balances[msg.sender] >= value && value > 0) {
103 
104             // do actual tokens transfer       
105             balances[msg.sender] -= value;
106             balances[to]         += value;
107             
108             // rise the Transfer event
109             Transfer(msg.sender, to, value);
110             return true;
111         } else {
112             
113             return false; 
114         }
115     }
116     
117     
118 
119     
120     /**
121      * transferFrom() - used to move allowed funds from other owner
122      *                  account 
123      *
124      *  @param from  - move funds from account
125      *  @param to    - move funds to account
126      *  @param value - move the value 
127      *
128      *  @return - return true on success false otherwise 
129      */
130     function transferFrom(address from, address to, uint256 value) returns (bool success) {
131     
132         if ( balances[from] >= value && 
133              allowed[from][msg.sender] >= value && 
134              value > 0) {
135                                           
136     
137             // do the actual transfer
138             balances[from] -= value;    
139             balances[to]   += value;            
140             
141 
142             // addjust the permision, after part of 
143             // permited to spend value was used
144             allowed[from][msg.sender] -= value;
145             
146             // rise the Transfer event
147             Transfer(from, to, value);
148             return true;
149         } else { 
150             
151             return false; 
152         }
153     }
154 
155     
156 
157     
158     /**
159      *
160      * balanceOf() - constant function check concrete tokens balance  
161      *
162      *  @param owner - account owner
163      *  
164      *  @return the value of balance 
165      */                               
166     function balanceOf(address owner) constant returns (uint256 balance) {
167         return balances[owner];
168     }
169 
170     
171     
172     /**
173      *
174      * approve() - function approves to a person to spend some tokens from 
175      *           owner balance. 
176      *
177      *  @param spender - person whom this right been granted.
178      *  @param value   - value to spend.
179      * 
180      *  @return true in case of succes, otherwise failure
181      * 
182      */
183     function approve(address spender, uint256 value) returns (bool success) {
184         
185         
186         
187         // now spender can use balance in 
188         // ammount of value from owner balance
189         allowed[msg.sender][spender] = value;
190         
191         // rise event about the transaction
192         Approval(msg.sender, spender, value);
193         
194         return true;
195     }
196     
197 
198     /**
199      *
200      * allowance() - constant function to check how mouch is 
201      *               permited to spend to 3rd person from owner balance
202      *
203      *  @param owner   - owner of the balance
204      *  @param spender - permited to spend from this balance person 
205      *  
206      *  @return - remaining right to spend 
207      * 
208      */
209     function allowance(address owner, address spender) constant returns (uint256 remaining) {
210       return allowed[owner][spender];
211     }
212 
213 }
214 
215 
216 /**
217  *
218  * @title Hacker Gold
219  * 
220  * The official token powering the hack.ether.camp virtual accelerator.
221  * This is the only way to acquire tokens from startups during the event.
222  *
223  * Whitepaper https://hack.ether.camp/whitepaper
224  *
225  */
226 contract HackerGold is StandardToken {
227 
228     // Name of the token    
229     string public name = "HackerGold";
230 
231     // Decimal places
232     uint8  public decimals = 3;
233     // Token abbreviation        
234     string public symbol = "HKG";
235     
236     // 1 ether = 200 hkg
237     uint BASE_PRICE = 200;
238     // 1 ether = 150 hkg
239     uint MID_PRICE = 150;
240     // 1 ether = 100 hkg
241     uint FIN_PRICE = 100;
242     // Safety cap
243     uint SAFETY_LIMIT = 4000000 ether;
244     // Zeros after the point
245     uint DECIMAL_ZEROS = 1000;
246     
247     // Total value in wei
248     uint totalValue;
249     
250     // Address of multisig wallet holding ether from sale
251     address wallet;
252 
253     // Structure of sale increase milestones
254     struct milestones_struct {
255       uint p1;
256       uint p2; 
257       uint p3;
258       uint p4;
259       uint p5;
260       uint p6;
261     }
262     // Milestones instance
263     milestones_struct milestones;
264     
265     /**
266      * Constructor of the contract.
267      * 
268      * Passes address of the account holding the value.
269      * HackerGold contract itself does not hold any value
270      * 
271      * @param multisig address of MultiSig wallet which will hold the value
272      */
273     function HackerGold(address multisig) {
274         
275         wallet = multisig;
276 
277         // set time periods for sale
278         milestones = milestones_struct(
279         
280           1476972000,  // P1: GMT: 20-Oct-2016 14:00  => The Sale Starts
281           1478181600,  // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
282           1479391200,  // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
283                        //                                Hackathon Starts
284           1480600800,  // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
285           1481810400,  // P5: GMT: 15-Dec-2016 14:00  => Price Stable
286           1482415200   // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
287         );
288         
289         // assign recovery balance
290         totalSupplyVar   = 16110893000;
291         balances[0x342e62732b76875da9305083ea8ae63125a4e667] = 16110893000;
292         totalValue    = 85362 ether;        
293     }
294     
295     
296     /**
297      * Fallback function: called on ether sent.
298      * 
299      * It calls to createHKG function with msg.sender 
300      * as a value for holder argument
301      */
302     function () payable {
303         createHKG(msg.sender);
304     }
305     
306     /**
307      * Creates HKG tokens.
308      * 
309      * Runs sanity checks including safety cap
310      * Then calculates current price by getPrice() function, creates HKG tokens
311      * Finally sends a value of transaction to the wallet
312      * 
313      * Note: due to lack of floating point types in Solidity,
314      * contract assumes that last 3 digits in tokens amount are stood after the point.
315      * It means that if stored HKG balance is 100000, then its real value is 100 HKG
316      * 
317      * @param holder token holder
318      */
319     function createHKG(address holder) payable {
320         
321         if (now < milestones.p1) throw;
322         if (now >= milestones.p6) throw;
323         if (msg.value == 0) throw;
324     
325         // safety cap
326         if (getTotalValue() + msg.value > SAFETY_LIMIT) throw; 
327     
328         uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
329 
330         totalSupplyVar += tokens;
331         balances[holder] += tokens;
332         totalValue += msg.value;
333         
334         if (!wallet.send(msg.value)) throw;
335     }
336     
337     /**
338      * Denotes complete price structure during the sale.
339      *
340      * @return HKG amount per 1 ETH for the current moment in time
341      */
342     function getPrice() constant returns (uint result) {
343         
344         if (now < milestones.p1) return 0;
345         
346         if (now >= milestones.p1 && now < milestones.p2) {
347         
348             return BASE_PRICE;
349         }
350         
351         if (now >= milestones.p2 && now < milestones.p3) {
352             
353             uint days_in = 1 + (now - milestones.p2) / 1 days; 
354             return BASE_PRICE - days_in * 25 / 7;  // daily decrease 3.5
355         }
356 
357         if (now >= milestones.p3 && now < milestones.p4) {
358         
359             return MID_PRICE;
360         }
361         
362         if (now >= milestones.p4 && now < milestones.p5) {
363             
364             days_in = 1 + (now - milestones.p4) / 1 days; 
365             return MID_PRICE - days_in * 25 / 7;  // daily decrease 3.5
366         }
367 
368         if (now >= milestones.p5 && now < milestones.p6) {
369         
370             return FIN_PRICE;
371         }
372         
373         if (now >= milestones.p6){
374 
375             return 0;
376         }
377 
378      }
379     
380     /**
381      * Returns total stored HKG amount.
382      * 
383      * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
384      * Thus, result of this function should be divided by 1000 to get HKG value
385      * 
386      * @return result stored HKG amount
387      */
388     function getTotalSupply() constant returns (uint result) {
389         return totalSupplyVar;
390     } 
391 
392     /**
393      * It is used for test purposes.
394      * 
395      * Returns the result of 'now' statement of Solidity language
396      * 
397      * @return unix timestamp for current moment in time
398      */
399     function getNow() constant returns (uint result) {
400         return now;
401     }
402 
403     /**
404      * Returns total value passed through the contract
405      * 
406      * @return result total value in wei
407      */
408     function getTotalValue() constant returns (uint result) {
409         return totalValue;  
410     }
411 }
412 
413 
414 /**
415  * 
416  * EventInfo - imutable class that denotes
417  * the time of the virtual accelerator hack
418  * event
419  * 
420  */
421 contract EventInfo{
422     
423     
424     uint constant HACKATHON_5_WEEKS = 60 * 60 * 24 * 7 * 5;
425     uint constant T_1_WEEK = 60 * 60 * 24 * 7;
426 
427     uint eventStart = 1479391200; // Thu, 17 Nov 2016 14:00:00 GMT
428     uint eventEnd = eventStart + HACKATHON_5_WEEKS;
429     
430     
431     /**
432      * getEventStart - return the start of the event time
433      */ 
434     function getEventStart() constant returns (uint result){        
435        return eventStart;
436     } 
437     
438     /**
439      * getEventEnd - return the end of the event time
440      */ 
441     function getEventEnd() constant returns (uint result){        
442        return eventEnd;
443     } 
444     
445     
446     /**
447      * getVotingStart - the voting starts 1 week after the 
448      *                  event starts
449      */ 
450     function getVotingStart() constant returns (uint result){
451         return eventStart+ T_1_WEEK;
452     }
453 
454     /**
455      * getTradingStart - the DST tokens trading starts 1 week 
456      *                   after the event starts
457      */ 
458     function getTradingStart() constant returns (uint result){
459         return eventStart+ T_1_WEEK;
460     }
461 
462     /**
463      * getNow - helper class to check what time the contract see
464      */
465     function getNow() constant returns (uint result){        
466        return now;
467     } 
468     
469 }
470 
471 
472 /*
473  * DSTContract - DST stands for decentralized startup team.
474  *               the contract ensures funding for a decentralized
475  *               team in 2 phases: 
476  *
477  *                +. Funding by HKG during the hackathon event. 
478  *                +. Funding by Ether after the event is over. 
479  *
480  *               After the funds been collected there is a governence
481  *               mechanism managed by proposition to withdraw funds
482  *               for development usage. 
483  *
484  *               The DST ensures that backers of the projects keeps
485  *               some influence on the project by ability to reject
486  *               propositions they find as non effective. 
487  *
488  *               In very radical occasions the backers may loose 
489  *               the trust in the team completelly, in that case 
490  *               there is an option to propose impeachment process
491  *               completelly removing the execute and assigning new
492  *               person to manage the funds. 
493  *
494  */
495 contract DSTContract is StandardToken{
496 
497     // Zeros after the point
498     uint DECIMAL_ZEROS = 1000;
499     // Proposal lifetime
500     uint PROPOSAL_LIFETIME = 10 days;
501     // Proposal funds threshold, in percents
502     uint PROPOSAL_FUNDS_TH = 20;
503 
504     address   executive; 
505         
506     EventInfo eventInfo;
507     
508     // Indicated where the DST is traded
509     address virtualExchangeAddress;
510     
511     HackerGold hackerGold;
512         
513     mapping (address => uint256) votingRights;
514 
515 
516     // 1 - HKG => DST qty; tokens for 1 HKG
517     uint hkgPrice;
518     
519     // 1 - Ether => DST qty; tokens for 1 Ether
520     uint etherPrice;
521     
522     string public name = "...";                   
523     uint8  public decimals = 3;                 
524     string public symbol = "...";
525     
526     bool ableToIssueTokens = true; 
527     
528     uint preferedQtySold;
529 
530     uint collectedHKG; 
531     uint collectedEther;    
532     
533     // Proposal of the funds spending
534     mapping (bytes32 => Proposal) proposals;
535 
536     enum ProposalCurrency { HKG, ETHER }
537     ProposalCurrency enumDeclaration;
538                   
539        
540     struct Proposal{
541         
542         bytes32 id;
543         uint value;
544 
545         string urlDetails;
546 
547         uint votindEndTS;
548                 
549         uint votesObjecting;
550         
551         address submitter;
552         bool redeemed;
553 
554         ProposalCurrency proposalCurrency;
555         
556         mapping (address => bool) voted;
557     }
558     uint counterProposals;
559     uint timeOfLastProposal;
560     
561     Proposal[] listProposals;
562     
563 
564     /**
565      * Impeachment process proposals
566      */    
567     struct ImpeachmentProposal{
568         
569         string urlDetails;
570         
571         address newExecutive;
572 
573         uint votindEndTS;        
574         uint votesSupporting;
575         
576         mapping (address => bool) voted;        
577     }
578     ImpeachmentProposal lastImpeachmentProposal;
579 
580         
581     /**
582      * 
583      *  DSTContract: ctor for DST token and governence contract
584      *
585      *  @param eventInfoAddr EventInfo: address of object denotes events 
586      *                                  milestones      
587      *  @param hackerGoldAddr HackerGold: address of HackerGold token
588      *
589      *  @param dstName string: dstName: real name of the team
590      *
591      *  @param dstSymbol string: 3 letter symbold of the team
592      *
593      */ 
594     function DSTContract(EventInfo eventInfoAddr, HackerGold hackerGoldAddr, string dstName, string dstSymbol){
595     
596       executive   = msg.sender;  
597       name        = dstName;
598       symbol      = dstSymbol;
599 
600       hackerGold = HackerGold(hackerGoldAddr);
601       eventInfo  = EventInfo(eventInfoAddr);
602     }
603     
604 
605     function() payable
606                onlyAfterEnd {
607         
608         // there is tokens left from hackathon 
609         if (etherPrice == 0) throw;
610         
611         uint tokens = msg.value * etherPrice * DECIMAL_ZEROS / (1 ether);
612         
613         // check if demand of tokens is 
614         // overflow the supply 
615         uint retEther = 0;
616         if (balances[this] < tokens) {
617             
618             tokens = balances[this];
619             retEther = msg.value - tokens / etherPrice * (1 finney);
620         
621             // return left ether 
622             if (!msg.sender.send(retEther)) throw;
623         }
624         
625         
626         // do transfer
627         balances[msg.sender] += tokens;
628         balances[this] -= tokens;
629         
630         // count collected ether 
631         collectedEther += msg.value - retEther; 
632         
633         // rise event
634         BuyForEtherTransaction(msg.sender, collectedEther, totalSupplyVar, etherPrice, tokens);
635         
636     }
637 
638     
639     
640     /**
641      * setHKGPrice - set price: 1HKG => DST tokens qty
642      *
643      *  @param qtyForOneHKG uint: DST tokens for 1 HKG
644      * 
645      */    
646      function setHKGPrice(uint qtyForOneHKG) onlyExecutive  {
647          
648          hkgPrice = qtyForOneHKG;
649          PriceHKGChange(qtyForOneHKG, preferedQtySold, totalSupplyVar);
650      }
651      
652      
653     
654     /**
655      * 
656      * issuePreferedTokens - prefered tokens issued on the hackathon event
657      *                       grant special rights
658      *
659      *  @param qtyForOneHKG uint: price DST tokens for one 1 HKG
660      *  @param qtyToEmit uint: new supply of tokens 
661      * 
662      */
663     function issuePreferedTokens(uint qtyForOneHKG, 
664                                  uint256 qtyToEmit) onlyExecutive 
665                                                  onlyIfAbleToIssueTokens
666                                                  onlyBeforeEnd
667                                                  onlyAfterTradingStart {
668                 
669         // no issuence is allowed before enlisted on the
670         // exchange 
671         if (virtualExchangeAddress == 0x0) throw;
672             
673         totalSupplyVar += qtyToEmit;
674         balances[this] += qtyToEmit;
675         hkgPrice = qtyForOneHKG;
676         
677         
678         // now spender can use balance in 
679         // amount of value from owner balance
680         allowed[this][virtualExchangeAddress] += qtyToEmit;
681         
682         // rise event about the transaction
683         Approval(this, virtualExchangeAddress, qtyToEmit);
684         
685         // rise event 
686         DstTokensIssued(hkgPrice, preferedQtySold, totalSupplyVar, qtyToEmit);
687     }
688 
689     
690     
691     
692     /**
693      * 
694      * buyForHackerGold - on the hack event this function is available 
695      *                    the buyer for hacker gold will gain votes to 
696      *                    influence future proposals on the DST
697      *    
698      *  @param hkgValue - qty of this DST tokens for 1 HKG     
699      * 
700      */
701     function buyForHackerGold(uint hkgValue) onlyBeforeEnd 
702                                              returns (bool success) {
703     
704       // validate that the caller is official accelerator HKG Exchange
705       if (msg.sender != virtualExchangeAddress) throw;
706       
707       
708       // transfer token 
709       address sender = tx.origin;
710       uint tokensQty = hkgValue * hkgPrice;
711 
712       // gain voting rights
713       votingRights[sender] +=tokensQty;
714       preferedQtySold += tokensQty;
715       collectedHKG += hkgValue;
716 
717       // do actual transfer
718       transferFrom(this, 
719                    virtualExchangeAddress, tokensQty);
720       transfer(sender, tokensQty);        
721             
722       // rise event       
723       BuyForHKGTransaction(sender, preferedQtySold, totalSupplyVar, hkgPrice, tokensQty);
724         
725       return true;
726     }
727         
728     
729     /**
730      * 
731      * issueTokens - function will issue tokens after the 
732      *               event, able to sell for 1 ether 
733      * 
734      *  @param qtyForOneEther uint: DST tokens for 1 ETH
735      *  @param qtyToEmit uint: new tokens supply
736      *
737      */
738     function issueTokens(uint qtyForOneEther, 
739                          uint qtyToEmit) onlyAfterEnd 
740                                          onlyExecutive
741                                          onlyIfAbleToIssueTokens {
742          
743          balances[this] += qtyToEmit;
744          etherPrice = qtyForOneEther;
745          totalSupplyVar    += qtyToEmit;
746          
747          // rise event  
748          DstTokensIssued(qtyForOneEther, totalSupplyVar, totalSupplyVar, qtyToEmit);
749     }
750      
751     
752     /**
753      * setEtherPrice - change the token price
754      *
755      *  @param qtyForOneEther uint: new price - DST tokens for 1 ETH
756      */     
757     function setEtherPrice(uint qtyForOneEther) onlyAfterEnd
758                                                 onlyExecutive {
759          etherPrice = qtyForOneEther; 
760 
761          // rise event for this
762          NewEtherPrice(qtyForOneEther);
763     }    
764     
765 
766     /**
767      *  disableTokenIssuance - function will disable any 
768      *                         option for future token 
769      *                         issuence
770      */
771     function disableTokenIssuance() onlyExecutive {
772         ableToIssueTokens = false;
773         
774         DisableTokenIssuance();
775     }
776 
777     
778     /**
779      *  burnRemainToken -  eliminated all available for sale
780      *                     tokens. 
781      */
782     function burnRemainToken() onlyExecutive {
783     
784         totalSupplyVar -= balances[this];
785         balances[this] = 0;
786         
787         // rise event for this
788         BurnedAllRemainedTokens();
789     }
790     
791     /**
792      *  submitEtherProposal: submit proposal to use part of the 
793      *                       collected ether funds
794      *
795      *   @param requestValue uint: value in wei 
796      *   @param url string: details of the proposal 
797      */ 
798     function submitEtherProposal(uint requestValue, string url) onlyAfterEnd 
799                                                                 onlyExecutive returns (bytes32 resultId, bool resultSucces) {       
800     
801         // ensure there is no more issuence available 
802         if (ableToIssueTokens) throw;
803             
804         // ensure there is no more tokens available 
805         if (balanceOf(this) > 0) throw;
806 
807         // Possible to submit a proposal once 2 weeks 
808         if (now < (timeOfLastProposal + 2 weeks)) throw;
809             
810         uint percent = collectedEther / 100;
811             
812         if (requestValue > PROPOSAL_FUNDS_TH * percent) throw;
813 
814         // if remained value is less than requested gain all.
815         if (requestValue > this.balance) 
816             requestValue = this.balance;    
817             
818         // set id of the proposal
819         // submit proposal to the map
820         bytes32 id = sha3(msg.data, now);
821         uint timeEnds = now + PROPOSAL_LIFETIME; 
822             
823         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.ETHER);
824         proposals[id] = newProposal;
825         listProposals.push(newProposal);
826             
827         timeOfLastProposal = now;                        
828         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
829         
830         return (id, true);
831     }
832     
833     
834      
835     /**
836      * 
837      * submitHKGProposal - submit proposal to request for 
838      *                     partial HKG funds collected 
839      * 
840      *  @param requestValue uint: value in HKG to request. 
841      *  @param url string: url with details on the proposition 
842      */
843     function submitHKGProposal(uint requestValue, string url) onlyAfterEnd
844                                                               onlyExecutive returns (bytes32 resultId, bool resultSucces){
845         
846 
847         // If there is no 2 months over since the last event.
848         // There is no posible to get any HKG. After 2 months
849         // all the HKG is available. 
850         if (now < (eventInfo.getEventEnd() + 8 weeks)) {
851             throw;
852         }
853 
854         // Possible to submit a proposal once 2 weeks 
855         if (now < (timeOfLastProposal + 2 weeks)) throw;
856 
857         uint percent = preferedQtySold / 100;
858         
859         // validate the amount is legit
860         // first 5 proposals should be less than 20% 
861         if (counterProposals <= 5 && 
862             requestValue     >  PROPOSAL_FUNDS_TH * percent) throw;
863                 
864         // if remained value is less than requested 
865         // gain all.
866         if (requestValue > getHKGOwned()) 
867             requestValue = getHKGOwned();
868         
869         
870         // set id of the proposal
871         // submit proposal to the map
872         bytes32 id = sha3(msg.data, now);
873         uint timeEnds = now + PROPOSAL_LIFETIME; 
874         
875         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.HKG);
876         proposals[id] = newProposal;
877         listProposals.push(newProposal);
878         
879         ++counterProposals;
880         timeOfLastProposal = now;                
881                 
882         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
883         
884         return (id, true);        
885     }  
886     
887     
888     
889     /**
890      * objectProposal - object previously submitted proposal, 
891      *                  the objection right is obtained by 
892      *                  purchasing prefered tokens on time of 
893      *                  the hackathon.
894      * 
895      *  @param id bytes32 : the id of the proposla to redeem
896      */
897      function objectProposal(bytes32 id){
898          
899         Proposal memory proposal = proposals[id];
900          
901         // check proposal exist 
902         if (proposals[id].id == 0) throw;
903 
904         // check already redeemed
905         if (proposals[id].redeemed) throw;
906          
907         // ensure objection time
908         if (now >= proposals[id].votindEndTS) throw;
909          
910         // ensure not voted  
911         if (proposals[id].voted[msg.sender]) throw;
912          
913          // submit votes
914          uint votes = votingRights[msg.sender];
915          proposals[id].votesObjecting += votes;
916          
917          // mark voted 
918          proposals[id].voted[msg.sender] = true; 
919          
920          uint idx = getIndexByProposalId(id);
921          listProposals[idx] = proposals[id];   
922 
923          ObjectedVote(id, msg.sender, votes);         
924      }
925      
926      
927      function getIndexByProposalId(bytes32 id) returns (uint result){
928          
929          for (uint i = 0; i < listProposals.length; ++i){
930              if (id == listProposals[i].id) return i;
931          }
932      }
933     
934     
935    
936     /**
937      * redeemProposalFunds - redeem funds requested by prior 
938      *                       submitted proposal     
939      * 
940      * @param id bytes32: the id of the proposal to redeem
941      */
942     function redeemProposalFunds(bytes32 id) onlyExecutive {
943 
944         if (proposals[id].id == 0) throw;
945         if (proposals[id].submitter != msg.sender) throw;
946 
947         // ensure objection time
948         if (now < proposals[id].votindEndTS) throw;
949                            
950     
951             // check already redeemed
952         if (proposals[id].redeemed) throw;
953 
954         // check votes objection => 55% of total votes
955         uint objectionThreshold = preferedQtySold / 100 * 55;
956         if (proposals[id].votesObjecting  > objectionThreshold) throw;
957     
958     
959         if (proposals[id].proposalCurrency == ProposalCurrency.HKG){
960             
961             // send hacker gold 
962             hackerGold.transfer(proposals[id].submitter, proposals[id].value);      
963                         
964         } else {
965                         
966            // send ether              
967            bool success = proposals[id].submitter.send(proposals[id].value); 
968 
969            // rise event
970            EtherRedeemAccepted(proposals[id].submitter, proposals[id].value);                              
971         }
972         
973         // execute the proposal 
974         proposals[id].redeemed = true; 
975     }
976     
977     
978     /**
979      *  getAllTheFunds - to ensure there is no deadlock can 
980      *                   can happen, and no case that voting 
981      *                   structure will freeze the funds forever
982      *                   the startup will be able to get all the
983      *                   funds without a proposal required after
984      *                   6 months.
985      * 
986      * 
987      */             
988     function getAllTheFunds() onlyExecutive {
989         
990         // If there is a deadlock in voting participates
991         // the funds can be redeemed completelly in 6 months
992         if (now < (eventInfo.getEventEnd() + 24 weeks)) {
993             throw;
994         }  
995         
996         // all the Ether
997         bool success = msg.sender.send(this.balance);        
998         
999         // all the HKG
1000         hackerGold.transfer(msg.sender, getHKGOwned());              
1001     }
1002     
1003     
1004     /**
1005      * submitImpeachmentProposal - submit request to switch 
1006      *                             executive.
1007      * 
1008      *  @param urlDetails  - details of the impeachment proposal 
1009      *  @param newExecutive - address of the new executive 
1010      * 
1011      */             
1012      function submitImpeachmentProposal(string urlDetails, address newExecutive){
1013          
1014         // to offer impeachment you should have 
1015         // voting rights
1016         if (votingRights[msg.sender] == 0) throw;
1017          
1018         // the submission of the first impeachment 
1019         // proposal is possible only after 3 months
1020         // since the hackathon is over
1021         if (now < (eventInfo.getEventEnd() + 12 weeks)) throw;
1022         
1023                 
1024         // check there is 1 months over since last one
1025         if (lastImpeachmentProposal.votindEndTS != 0 && 
1026             lastImpeachmentProposal.votindEndTS +  2 weeks > now) throw;
1027 
1028 
1029         // submit impeachment proposal
1030         // add the votes of the submitter 
1031         // to the proposal right away
1032         lastImpeachmentProposal = ImpeachmentProposal(urlDetails, newExecutive, now + 2 weeks, votingRights[msg.sender]);
1033         lastImpeachmentProposal.voted[msg.sender] = true;
1034          
1035         // rise event
1036         ImpeachmentProposed(msg.sender, urlDetails, now + 2 weeks, newExecutive);
1037      }
1038     
1039     
1040     /**
1041      * supportImpeachment - vote for impeachment proposal 
1042      *                      that is currently in progress
1043      *
1044      */
1045     function supportImpeachment(){
1046 
1047         // ensure that support is for exist proposal 
1048         if (lastImpeachmentProposal.newExecutive == 0x0) throw;
1049     
1050         // to offer impeachment you should have 
1051         // voting rights
1052         if (votingRights[msg.sender] == 0) throw;
1053         
1054         // check if not voted already 
1055         if (lastImpeachmentProposal.voted[msg.sender]) throw;
1056         
1057         // check if not finished the 2 weeks of voting 
1058         if (lastImpeachmentProposal.votindEndTS + 2 weeks <= now) throw;
1059                 
1060         // support the impeachment
1061         lastImpeachmentProposal.voted[msg.sender] = true;
1062         lastImpeachmentProposal.votesSupporting += votingRights[msg.sender];
1063 
1064         // rise impeachment suppporting event
1065         ImpeachmentSupport(msg.sender, votingRights[msg.sender]);
1066         
1067         // if the vote is over 70% execute the switch 
1068         uint percent = preferedQtySold / 100; 
1069         
1070         if (lastImpeachmentProposal.votesSupporting >= 70 * percent){
1071             executive = lastImpeachmentProposal.newExecutive;
1072             
1073             // impeachment event
1074             ImpeachmentAccepted(executive);
1075         }
1076         
1077     } 
1078     
1079       
1080     
1081     // **************************** //
1082     // *     Constant Getters     * //
1083     // **************************** //
1084     
1085     function votingRightsOf(address _owner) constant returns (uint256 result) {
1086         result = votingRights[_owner];
1087     }
1088     
1089     function getPreferedQtySold() constant returns (uint result){
1090         return preferedQtySold;
1091     }
1092     
1093     function setVirtualExchange(address virtualExchangeAddr){
1094         if (virtualExchangeAddress != 0x0) throw;
1095         virtualExchangeAddress = virtualExchangeAddr;
1096     }
1097 
1098     function getHKGOwned() constant returns (uint result){
1099         return hackerGold.balanceOf(this);
1100     }
1101     
1102     function getEtherValue() constant returns (uint result){
1103         return this.balance;
1104     }
1105     
1106     function getExecutive() constant returns (address result){
1107         return executive;
1108     }
1109     
1110     function getHKGPrice() constant returns (uint result){
1111         return hkgPrice;
1112     }
1113 
1114     function getEtherPrice() constant returns (uint result){
1115         return etherPrice;
1116     }
1117     
1118     function getDSTName() constant returns(string result){
1119         return name;
1120     }    
1121     
1122     function getDSTNameBytes() constant returns(bytes32 result){
1123         return convert(name);
1124     }    
1125 
1126     function getDSTSymbol() constant returns(string result){
1127         return symbol;
1128     }    
1129     
1130     function getDSTSymbolBytes() constant returns(bytes32 result){
1131         return convert(symbol);
1132     }    
1133 
1134     function getAddress() constant returns (address result) {
1135         return this;
1136     }
1137     
1138     function getTotalSupply() constant returns (uint result) {
1139         return totalSupplyVar;
1140     } 
1141         
1142     function getCollectedEther() constant returns (uint results) {        
1143         return collectedEther;
1144     }
1145     
1146     function getCounterProposals() constant returns (uint result){
1147         return counterProposals;
1148     }
1149         
1150     function getProposalIdByIndex(uint i) constant returns (bytes32 result){
1151         return listProposals[i].id;
1152     }    
1153 
1154     function getProposalObjectionByIndex(uint i) constant returns (uint result){
1155         return listProposals[i].votesObjecting;
1156     }
1157 
1158     function getProposalValueByIndex(uint i) constant returns (uint result){
1159         return listProposals[i].value;
1160     }                  
1161     
1162     function getCurrentImpeachmentUrlDetails() constant returns (string result){
1163         return lastImpeachmentProposal.urlDetails;
1164     }
1165     
1166     
1167     function getCurrentImpeachmentVotesSupporting() constant returns (uint result){
1168         return lastImpeachmentProposal.votesSupporting;
1169     }
1170     
1171     function convert(string key) returns (bytes32 ret) {
1172             if (bytes(key).length > 32) {
1173                 throw;
1174             }      
1175 
1176             assembly {
1177                 ret := mload(add(key, 32))
1178             }
1179     }    
1180     
1181     // Emergency Fix limited by time functions
1182     function setVoteRight(address voter, uint ammount){
1183         
1184         // limited by [12 Jan 2017 00:00:00 GMT]
1185         if (now > 1484179200) throw;
1186 
1187         // limited by one account to fix 
1188         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1189 
1190         votingRights[voter] = ammount;
1191     }
1192     
1193     // Emergency Fix limited by time functions
1194     function setBalance(address owner, uint ammount){
1195 
1196         // limited by [12 Jan 2017 00:00:00 GMT]
1197         if (now > 1484179200) throw;
1198         
1199         // limited by one account to fix 
1200         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1201         
1202         balances[owner] = ammount;
1203     }
1204     
1205     // Emergency Fix limited by time functions
1206     function setInternalInfo(address fixExecutive, uint fixTotalSupply, uint256 fixPreferedQtySold, 
1207             uint256 fixCollectedHKG, uint fixCollectedEther){
1208 
1209         // limited by [12 Jan 2017 00:00:00 GMT]
1210         if (now > 1484179200) throw;
1211         
1212         // limited by one account to fix 
1213         if (msg.sender != 0x342e62732b76875da9305083ea8ae63125a4e667) throw;
1214         
1215         executive = fixExecutive;
1216         totalSupplyVar = fixTotalSupply;
1217         preferedQtySold = fixPreferedQtySold;
1218         collectedHKG = fixCollectedHKG;
1219         collectedEther = fixCollectedEther;
1220     }
1221     
1222     
1223     // ********************* //
1224     // *     Modifiers     * //
1225     // ********************* //    
1226  
1227     modifier onlyBeforeEnd() { if (now  >=  eventInfo.getEventEnd()) throw; _; }
1228     modifier onlyAfterEnd()  { if (now  <   eventInfo.getEventEnd()) throw; _; }
1229     
1230     modifier onlyAfterTradingStart()  { if (now  < eventInfo.getTradingStart()) throw; _; }
1231     
1232     modifier onlyExecutive()     { if (msg.sender != executive) throw; _; }
1233                                        
1234     modifier onlyIfAbleToIssueTokens()  { if (!ableToIssueTokens) throw; _; } 
1235     
1236 
1237     // ****************** //
1238     // *     Events     * //
1239     // ****************** //        
1240 
1241     
1242     event PriceHKGChange(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply);
1243     event BuyForHKGTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneHKG, uint tokensAmount);
1244     event BuyForEtherTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneEther, uint tokensAmount);
1245 
1246     event DstTokensIssued(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply, uint qtyToEmit);
1247     
1248     event ProposalRequestSubmitted(bytes32 id, uint value, uint timeEnds, string url, address sender);
1249     
1250     event EtherRedeemAccepted(address sender, uint value);
1251     
1252     event ObjectedVote(bytes32 id, address voter, uint votes);
1253     
1254     event ImpeachmentProposed(address submitter, string urlDetails, uint votindEndTS, address newExecutive);
1255     event ImpeachmentSupport(address supportter, uint votes);
1256     
1257     event ImpeachmentAccepted(address newExecutive);
1258 
1259     event NewEtherPrice(uint newQtyForOneEther);
1260     event DisableTokenIssuance();
1261     
1262     event BurnedAllRemainedTokens();
1263     
1264 }