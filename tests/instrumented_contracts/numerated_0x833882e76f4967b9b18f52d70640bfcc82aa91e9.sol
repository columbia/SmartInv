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
14     uint totalSupply;
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
57     // events notifications
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 
63 /*
64  * StandardToken - is a smart contract  
65  * for managing common functionality of 
66  * a token.
67  *
68  * ERC.20 Token standard: 
69  *         https://github.com/eth ereum/EIPs/issues/20
70  */
71 contract StandardToken is TokenInterface {
72 
73 
74     // token ownership
75     mapping (address => uint256) balances;
76 
77     // spending permision management
78     mapping (address => mapping (address => uint256)) allowed;
79     
80     
81     
82     function StandardToken(){
83     }
84     
85     
86     /**
87      * transfer() - transfer tokens from msg.sender balance 
88      *              to requested account
89      *
90      *  @param to    - target address to transfer tokens
91      *  @param value - ammount of tokens to transfer
92      *
93      *  @return - success / failure of the transaction
94      */    
95     function transfer(address to, uint256 value) returns (bool success) {
96         
97         
98         if (balances[msg.sender] >= value && value > 0) {
99 
100             // do actual tokens transfer       
101             balances[msg.sender] -= value;
102             balances[to]         += value;
103             
104             // rise the Transfer event
105             Transfer(msg.sender, to, value);
106             return true;
107         } else {
108             
109             return false; 
110         }
111     }
112     
113     
114 
115     
116     /**
117      * transferFrom() - 
118      *
119      *  @param from  - 
120      *  @param to    - 
121      *  @param value - 
122      *
123      *  @return 
124      */
125     function transferFrom(address from, address to, uint256 value) returns (bool success) {
126     
127         if ( balances[from] >= value && 
128              allowed[from][msg.sender] >= value && 
129              value > 0) {
130                                           
131     
132             // do the actual transfer
133             balances[from] -= value;    
134             balances[to] =+ value;            
135             
136 
137             // addjust the permision, after part of 
138             // permited to spend value was used
139             allowed[from][msg.sender] -= value;
140             
141             // rise the Transfer event
142             Transfer(from, to, value);
143             return true;
144         } else { 
145             
146             return false; 
147         }
148     }
149 
150     
151 
152     
153     /**
154      *
155      * balanceOf() - constant function check concrete tokens balance  
156      *
157      *  @param owner - account owner
158      *  
159      *  @return the value of balance 
160      */                               
161     function balanceOf(address owner) constant returns (uint256 balance) {
162         return balances[owner];
163     }
164 
165     
166     
167     /**
168      *
169      * approve() - function approves to a person to spend some tokens from 
170      *           owner balance. 
171      *
172      *  @param spender - person whom this right been granted.
173      *  @param value   - value to spend.
174      * 
175      *  @return true in case of succes, otherwise failure
176      * 
177      */
178     function approve(address spender, uint256 value) returns (bool success) {
179         
180         // now spender can use balance in 
181         // ammount of value from owner balance
182         allowed[msg.sender][spender] = value;
183         
184         // rise event about the transaction
185         Approval(msg.sender, spender, value);
186         
187         return true;
188     }
189 
190     /**
191      *
192      * allowance() - constant function to check how mouch is 
193      *               permited to spend to 3rd person from owner balance
194      *
195      *  @param owner   - owner of the balance
196      *  @param spender - permited to spend from this balance person 
197      *  
198      *  @return - remaining right to spend 
199      * 
200      */
201     function allowance(address owner, address spender) constant returns (uint256 remaining) {
202       return allowed[owner][spender];
203     }
204 
205 }
206 
207 
208 /**
209  *
210  * @title Hacker Gold
211  * 
212  * The official token powering the hack.ether.camp virtual accelerator.
213  * This is the only way to acquire tokens from startups during the event.
214  *
215  * Whitepaper https://hack.ether.camp/whitepaper
216  *
217  */
218 contract HackerGold is StandardToken {
219 
220     // Name of the token    
221     string public name = "HackerGold";
222 
223     // Decimal places
224     uint8  public decimals = 3;
225     // Token abbreviation        
226     string public symbol = "HKG";
227     
228     // 1 ether = 200 hkg
229     uint BASE_PRICE = 200;
230     // 1 ether = 150 hkg
231     uint MID_PRICE = 150;
232     // 1 ether = 100 hkg
233     uint FIN_PRICE = 100;
234     // Safety cap
235     uint SAFETY_LIMIT = 4000000 ether;
236     // Zeros after the point
237     uint DECIMAL_ZEROS = 1000;
238     
239     // Total value in wei
240     uint totalValue;
241     
242     // Address of multisig wallet holding ether from sale
243     address wallet;
244 
245     // Structure of sale increase milestones
246     struct milestones_struct {
247       uint p1;
248       uint p2; 
249       uint p3;
250       uint p4;
251       uint p5;
252       uint p6;
253     }
254     // Milestones instance
255     milestones_struct milestones;
256     
257     /**
258      * Constructor of the contract.
259      * 
260      * Passes address of the account holding the value.
261      * HackerGold contract itself does not hold any value
262      * 
263      * @param multisig address of MultiSig wallet which will hold the value
264      */
265     function HackerGold(address multisig) {
266         
267         wallet = multisig;
268 
269         // set time periods for sale
270         milestones = milestones_struct(
271         
272           1476972000,  // P1: GMT: 20-Oct-2016 14:00  => The Sale Starts
273           1478181600,  // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
274           1479391200,  // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
275                        //                                Hackathon Starts
276           1480600800,  // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
277           1481810400,  // P5: GMT: 15-Dec-2016 14:00  => Price Stable
278           1482415200   // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
279         );
280                 
281     }
282     
283     
284     /**
285      * Fallback function: called on ether sent.
286      * 
287      * It calls to createHKG function with msg.sender 
288      * as a value for holder argument
289      */
290     function () payable {
291         createHKG(msg.sender);
292     }
293     
294     /**
295      * Creates HKG tokens.
296      * 
297      * Runs sanity checks including safety cap
298      * Then calculates current price by getPrice() function, creates HKG tokens
299      * Finally sends a value of transaction to the wallet
300      * 
301      * Note: due to lack of floating point types in Solidity,
302      * contract assumes that last 3 digits in tokens amount are stood after the point.
303      * It means that if stored HKG balance is 100000, then its real value is 100 HKG
304      * 
305      * @param holder token holder
306      */
307     function createHKG(address holder) payable {
308         
309         if (now < milestones.p1) throw;
310         if (now >= milestones.p6) throw;
311         if (msg.value == 0) throw;
312     
313         // safety cap
314         if (getTotalValue() + msg.value > SAFETY_LIMIT) throw; 
315     
316         uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
317 
318         totalSupply += tokens;
319         balances[holder] += tokens;
320         totalValue += msg.value;
321         
322         if (!wallet.send(msg.value)) throw;
323     }
324     
325     /**
326      * Denotes complete price structure during the sale.
327      *
328      * @return HKG amount per 1 ETH for the current moment in time
329      */
330     function getPrice() constant returns (uint result) {
331         
332         if (now < milestones.p1) return 0;
333         
334         if (now >= milestones.p1 && now < milestones.p2) {
335         
336             return BASE_PRICE;
337         }
338         
339         if (now >= milestones.p2 && now < milestones.p3) {
340             
341             uint days_in = 1 + (now - milestones.p2) / 1 days; 
342             return BASE_PRICE - days_in * 25 / 7;  // daily decrease 3.5
343         }
344 
345         if (now >= milestones.p3 && now < milestones.p4) {
346         
347             return MID_PRICE;
348         }
349         
350         if (now >= milestones.p4 && now < milestones.p5) {
351             
352             days_in = 1 + (now - milestones.p4) / 1 days; 
353             return MID_PRICE - days_in * 25 / 7;  // daily decrease 3.5
354         }
355 
356         if (now >= milestones.p5 && now < milestones.p6) {
357         
358             return FIN_PRICE;
359         }
360         
361         if (now >= milestones.p6){
362 
363             return 0;
364         }
365 
366      }
367     
368     /**
369      * Returns total stored HKG amount.
370      * 
371      * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
372      * Thus, result of this function should be divided by 1000 to get HKG value
373      * 
374      * @return result stored HKG amount
375      */
376     function getTotalSupply() constant returns (uint result) {
377         return totalSupply;
378     } 
379 
380     /**
381      * It is used for test purposes.
382      * 
383      * Returns the result of 'now' statement of Solidity language
384      * 
385      * @return unix timestamp for current moment in time
386      */
387     function getNow() constant returns (uint result) {
388         return now;
389     }
390 
391     /**
392      * Returns total value passed through the contract
393      * 
394      * @return result total value in wei
395      */
396     function getTotalValue() constant returns (uint result) {
397         return totalValue;  
398     }
399 }
400 
401 contract DSTContract is StandardToken{
402 
403     // Zeros after the point
404     uint DECIMAL_ZEROS = 1000;
405     // Proposal lifetime
406     uint PROPOSAL_LIFETIME = 10 days;
407     // Proposal funds threshold, in percents
408     uint PROPOSAL_FUNDS_TH = 20;
409 
410     address   executive; 
411         
412     EventInfo eventInfo;
413     
414     // Indicated where the DST is traded
415     address virtualExchangeAddress;
416     
417     HackerGold hackerGold;
418         
419     mapping (address => uint256) votingRights;
420 
421 
422     // 1 - HKG => DST qty; tokens for 1 HKG
423     uint hkgPrice;
424     
425     // 1 - Ether => DST qty; tokens for 1 Ether
426     uint etherPrice;
427     
428     string public name = "...";                   
429     uint8  public decimals = 3;                 
430     string public symbol = "...";
431     
432     bool ableToIssueTokens = true; 
433     
434     uint preferedQtySold;
435 
436     uint collectedHKG; 
437     uint collectedEther;    
438     
439     // Proposal of the funds spending
440     mapping (bytes32 => Proposal) proposals;
441 
442     enum ProposalCurrency { HKG, ETHER }
443     ProposalCurrency enumDeclaration;
444                   
445        
446     struct Proposal{
447         
448         bytes32 id;
449         uint value;
450 
451         string urlDetails;
452 
453         uint votindEndTS;
454                 
455         uint votesObjecting;
456         
457         address submitter;
458         bool redeemed;
459 
460         ProposalCurrency proposalCurrency;
461         
462         mapping (address => bool) voted;
463     }
464     uint counterProposals;
465     uint timeOfLastProposal;
466     
467     Proposal[] listProposals;
468     
469 
470     /**
471      * Impeachment process proposals
472      */    
473     struct ImpeachmentProposal{
474         
475         string urlDetails;
476         
477         address newExecutive;
478 
479         uint votindEndTS;        
480         uint votesSupporting;
481         
482         mapping (address => bool) voted;        
483     }
484     ImpeachmentProposal lastImpeachmentProposal;
485 
486         
487     /**
488      * 
489      *  DSTContract: ctor for DST token and governence contract
490      *
491      *  @param eventInfoAddr EventInfo: address of object denotes events 
492      *                                  milestones      
493      *  @param hackerGoldAddr HackerGold: address of HackerGold token
494      *
495      *  @param dstName string: dstName: real name of the team
496      *
497      *  @param dstSymbol string: 3 letter symbold of the team
498      *
499      */ 
500     function DSTContract(EventInfo eventInfoAddr, HackerGold hackerGoldAddr, string dstName, string dstSymbol){
501     
502       executive   = msg.sender;  
503       name        = dstName;
504       symbol      = dstSymbol;
505 
506       hackerGold = HackerGold(hackerGoldAddr);
507       eventInfo  = EventInfo(eventInfoAddr);
508     }
509     
510 
511     function() payable
512                onlyAfterEnd {
513         
514         // there is tokens left from hackathon 
515         if (etherPrice == 0) throw;
516         
517         uint tokens = msg.value * etherPrice * DECIMAL_ZEROS / (1 ether);
518         
519         // check if demand of tokens is 
520         // overflow the supply 
521         uint retEther = 0;
522         if (balances[this] < tokens) {
523             
524             tokens = balances[this];
525             retEther = msg.value - tokens / etherPrice * (1 finney);
526         
527             // return left ether 
528             if (!msg.sender.send(retEther)) throw;
529         }
530         
531         
532         // do transfer
533         balances[msg.sender] += tokens;
534         balances[this] -= tokens;
535         
536         // count collected ether 
537         collectedEther += msg.value - retEther; 
538         
539         // rise event
540         BuyForEtherTransaction(msg.sender, collectedEther, totalSupply, etherPrice, tokens);
541         
542     }
543 
544     
545     
546     /**
547      * setHKGPrice - set price: 1HKG => DST tokens qty
548      *
549      *  @param qtyForOneHKG uint: DST tokens for 1 HKG
550      * 
551      */    
552      function setHKGPrice(uint qtyForOneHKG) onlyExecutive  {
553          
554          hkgPrice = qtyForOneHKG;
555          PriceHKGChange(qtyForOneHKG, preferedQtySold, totalSupply);
556      }
557      
558      
559     
560     /**
561      * 
562      * issuePreferedTokens - prefered tokens issued on the hackathon event
563      *                       grant special rights
564      *
565      *  @param qtyForOneHKG uint: price DST tokens for one 1 HKG
566      *  @param qtyToEmit uint: new supply of tokens 
567      * 
568      */
569     function issuePreferedTokens(uint qtyForOneHKG, 
570                                  uint qtyToEmit) onlyExecutive 
571                                                  onlyIfAbleToIssueTokens
572                                                  onlyBeforeEnd
573                                                  onlyAfterTradingStart {
574                 
575         // no issuence is allowed before enlisted on the
576         // exchange 
577         if (virtualExchangeAddress == 0x0) throw;
578             
579         totalSupply    += qtyToEmit;
580         balances[this] += qtyToEmit;
581         hkgPrice = qtyForOneHKG;
582         
583         
584         // now spender can use balance in 
585         // amount of value from owner balance
586         allowed[this][virtualExchangeAddress] += qtyToEmit;
587         
588         // rise event about the transaction
589         Approval(this, virtualExchangeAddress, qtyToEmit);
590         
591         // rise event 
592         DstTokensIssued(hkgPrice, preferedQtySold, totalSupply, qtyToEmit);
593     }
594 
595     
596     
597     
598     /**
599      * 
600      * buyForHackerGold - on the hack event this function is available 
601      *                    the buyer for hacker gold will gain votes to 
602      *                    influence future proposals on the DST
603      *    
604      *  @param hkgValue - qty of this DST tokens for 1 HKG     
605      * 
606      */
607     function buyForHackerGold(uint hkgValue) onlyBeforeEnd 
608                                              returns (bool success) {
609     
610       // validate that the caller is official accelerator HKG Exchange
611       if (msg.sender != virtualExchangeAddress) throw;
612       
613       
614       // transfer token 
615       address sender = tx.origin;
616       uint tokensQty = hkgValue * hkgPrice;
617 
618       // gain voting rights
619       votingRights[sender] +=tokensQty;
620       preferedQtySold += tokensQty;
621       collectedHKG += hkgValue;
622 
623       // do actual transfer
624       transferFrom(this, 
625                    virtualExchangeAddress, tokensQty);
626       transfer(sender, tokensQty);        
627             
628       // rise event       
629       BuyForHKGTransaction(sender, preferedQtySold, totalSupply, hkgPrice, tokensQty);
630         
631       return true;
632     }
633         
634     
635     /**
636      * 
637      * issueTokens - function will issue tokens after the 
638      *               event, able to sell for 1 ether 
639      * 
640      *  @param qtyForOneEther uint: DST tokens for 1 ETH
641      *  @param qtyToEmit uint: new tokens supply
642      *
643      */
644     function issueTokens(uint qtyForOneEther, 
645                          uint qtyToEmit) onlyAfterEnd 
646                                          onlyExecutive
647                                          onlyIfAbleToIssueTokens {
648          
649          balances[this] += qtyToEmit;
650          etherPrice = qtyForOneEther;
651          totalSupply    += qtyToEmit;
652          
653          // rise event  
654          DstTokensIssued(qtyForOneEther, totalSupply, totalSupply, qtyToEmit);
655     }
656      
657     
658     /**
659      * setEtherPrice - change the token price
660      *
661      *  @param qtyForOneEther uint: new price - DST tokens for 1 ETH
662      */     
663     function setEtherPrice(uint qtyForOneEther) onlyAfterEnd
664                                                 onlyExecutive {
665          etherPrice = qtyForOneEther; 
666 
667          // rise event for this
668          NewEtherPrice(qtyForOneEther);
669     }    
670     
671 
672     /**
673      *  disableTokenIssuance - function will disable any 
674      *                         option for future token 
675      *                         issuence
676      */
677     function disableTokenIssuance() onlyExecutive {
678         ableToIssueTokens = false;
679         
680         DisableTokenIssuance();
681     }
682 
683     
684     /**
685      *  burnRemainToken -  eliminated all available for sale
686      *                     tokens. 
687      */
688     function burnRemainToken() onlyExecutive {
689     
690         totalSupply -= balances[this];
691         balances[this] = 0;
692         
693         // rise event for this
694         BurnedAllRemainedTokens();
695     }
696     
697     /**
698      *  submitEtherProposal: submit proposal to use part of the 
699      *                       collected ether funds
700      *
701      *   @param requestValue uint: value in wei 
702      *   @param url string: details of the proposal 
703      */ 
704     function submitEtherProposal(uint requestValue, string url) onlyAfterEnd 
705                                                                 onlyExecutive returns (bytes32 resultId, bool resultSucces) {       
706     
707         // ensure there is no more issuence available 
708         if (ableToIssueTokens) throw;
709             
710         // ensure there is no more tokens available 
711         if (balanceOf(this) > 0) throw;
712 
713         // Possible to submit a proposal once 2 weeks 
714         if (now < (timeOfLastProposal + 2 weeks)) throw;
715             
716         uint percent = collectedEther / 100;
717             
718         if (requestValue > PROPOSAL_FUNDS_TH * percent) throw;
719 
720         // if remained value is less than requested gain all.
721         if (requestValue > this.balance) 
722             requestValue = this.balance;    
723             
724         // set id of the proposal
725         // submit proposal to the map
726         bytes32 id = sha3(msg.data, now);
727         uint timeEnds = now + PROPOSAL_LIFETIME; 
728             
729         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.ETHER);
730         proposals[id] = newProposal;
731         listProposals.push(newProposal);
732             
733         timeOfLastProposal = now;                        
734         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
735         
736         return (id, true);
737     }
738     
739     
740      
741     /**
742      * 
743      * submitHKGProposal - submit proposal to request for 
744      *                     partial HKG funds collected 
745      * 
746      *  @param requestValue uint: value in HKG to request. 
747      *  @param url string: url with details on the proposition 
748      */
749     function submitHKGProposal(uint requestValue, string url) onlyAfterEnd
750                                                               onlyExecutive returns (bytes32 resultId, bool resultSucces){
751         
752 
753         // If there is no 2 months over since the last event.
754         // There is no posible to get any HKG. After 2 months
755         // all the HKG is available. 
756         if (now < (eventInfo.getEventEnd() + 8 weeks)) {
757             throw;
758         }
759 
760         // Possible to submit a proposal once 2 weeks 
761         if (now < (timeOfLastProposal + 2 weeks)) throw;
762 
763         uint percent = preferedQtySold / 100;
764         
765         // validate the amount is legit
766         // first 5 proposals should be less than 20% 
767         if (counterProposals <= 5 && 
768             requestValue     >  PROPOSAL_FUNDS_TH * percent) throw;
769                 
770         // if remained value is less than requested 
771         // gain all.
772         if (requestValue > getHKGOwned()) 
773             requestValue = getHKGOwned();
774         
775         
776         // set id of the proposal
777         // submit proposal to the map
778         bytes32 id = sha3(msg.data, now);
779         uint timeEnds = now + PROPOSAL_LIFETIME; 
780         
781         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.HKG);
782         proposals[id] = newProposal;
783         listProposals.push(newProposal);
784         
785         ++counterProposals;
786         timeOfLastProposal = now;                
787                 
788         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
789         
790         return (id, true);        
791     }  
792     
793     
794     
795     /**
796      * objectProposal - object previously submitted proposal, 
797      *                  the objection right is obtained by 
798      *                  purchasing prefered tokens on time of 
799      *                  the hackathon.
800      * 
801      *  @param id bytes32 : the id of the proposla to redeem
802      */
803      function objectProposal(bytes32 id){
804          
805         Proposal memory proposal = proposals[id];
806          
807         // check proposal exist 
808         if (proposals[id].id == 0) throw;
809 
810         // check already redeemed
811         if (proposals[id].redeemed) throw;
812          
813         // ensure objection time
814         if (now >= proposals[id].votindEndTS) throw;
815          
816         // ensure not voted  
817         if (proposals[id].voted[msg.sender]) throw;
818          
819          // submit votes
820          uint votes = votingRights[msg.sender];
821          proposals[id].votesObjecting += votes;
822          
823          // mark voted 
824          proposals[id].voted[msg.sender] = true; 
825          
826          uint idx = getIndexByProposalId(id);
827          listProposals[idx] = proposals[id];   
828 
829          ObjectedVote(id, msg.sender, votes);         
830      }
831      
832      
833      function getIndexByProposalId(bytes32 id) returns (uint result){
834          
835          for (uint i = 0; i < listProposals.length; ++i){
836              if (id == listProposals[i].id) return i;
837          }
838      }
839     
840     
841    
842     /**
843      * redeemProposalFunds - redeem funds requested by prior 
844      *                       submitted proposal     
845      * 
846      * @param id bytes32: the id of the proposal to redeem
847      */
848     function redeemProposalFunds(bytes32 id) onlyExecutive {
849 
850         if (proposals[id].id == 0) throw;
851         if (proposals[id].submitter != msg.sender) throw;
852 
853         // ensure objection time
854         if (now < proposals[id].votindEndTS) throw;
855                            
856     
857             // check already redeemed
858         if (proposals[id].redeemed) throw;
859 
860         // check votes objection => 55% of total votes
861         uint objectionThreshold = preferedQtySold / 100 * 55;
862         if (proposals[id].votesObjecting  > objectionThreshold) throw;
863     
864     
865         if (proposals[id].proposalCurrency == ProposalCurrency.HKG){
866             
867             // send hacker gold 
868             hackerGold.transfer(proposals[id].submitter, proposals[id].value);      
869                         
870         } else {
871                         
872            // send ether              
873            bool success = proposals[id].submitter.send(proposals[id].value); 
874 
875            // rise event
876            EtherRedeemAccepted(proposals[id].submitter, proposals[id].value);                              
877         }
878         
879         // execute the proposal 
880         proposals[id].redeemed = true; 
881     }
882     
883     
884     /**
885      *  getAllTheFunds - to ensure there is no deadlock can 
886      *                   can happen, and no case that voting 
887      *                   structure will freeze the funds forever
888      *                   the startup will be able to get all the
889      *                   funds without a proposal required after
890      *                   6 months.
891      * 
892      * 
893      */             
894     function getAllTheFunds() onlyExecutive {
895         
896         // If there is a deadlock in voting participates
897         // the funds can be redeemed completelly in 6 months
898         if (now < (eventInfo.getEventEnd() + 24 weeks)) {
899             throw;
900         }  
901         
902         // all the Ether
903         bool success = msg.sender.send(this.balance);        
904         
905         // all the HKG
906         hackerGold.transfer(msg.sender, getHKGOwned());              
907     }
908     
909     
910     /**
911      * submitImpeachmentProposal - submit request to switch 
912      *                             executive.
913      * 
914      *  @param urlDetails  - details of the impeachment proposal 
915      *  @param newExecutive - address of the new executive 
916      * 
917      */             
918      function submitImpeachmentProposal(string urlDetails, address newExecutive){
919          
920         // to offer impeachment you should have 
921         // voting rights
922         if (votingRights[msg.sender] == 0) throw;
923          
924         // the submission of the first impeachment 
925         // proposal is possible only after 3 months
926         // since the hackathon is over
927         if (now < (eventInfo.getEventEnd() + 12 weeks)) throw;
928         
929                 
930         // check there is 1 months over since last one
931         if (lastImpeachmentProposal.votindEndTS != 0 && 
932             lastImpeachmentProposal.votindEndTS +  2 weeks > now) throw;
933 
934 
935         // submit impeachment proposal
936         // add the votes of the submitter 
937         // to the proposal right away
938         lastImpeachmentProposal = ImpeachmentProposal(urlDetails, newExecutive, now + 2 weeks, votingRights[msg.sender]);
939         lastImpeachmentProposal.voted[msg.sender] = true;
940          
941         // rise event
942         ImpeachmentProposed(msg.sender, urlDetails, now + 2 weeks, newExecutive);
943      }
944     
945     
946     /**
947      * supportImpeachment - vote for impeachment proposal 
948      *                      that is currently in progress
949      *
950      */
951     function supportImpeachment(){
952 
953         // ensure that support is for exist proposal 
954         if (lastImpeachmentProposal.newExecutive == 0x0) throw;
955     
956         // to offer impeachment you should have 
957         // voting rights
958         if (votingRights[msg.sender] == 0) throw;
959         
960         // check if not voted already 
961         if (lastImpeachmentProposal.voted[msg.sender]) throw;
962         
963         // check if not finished the 2 weeks of voting 
964         if (lastImpeachmentProposal.votindEndTS + 2 weeks <= now) throw;
965                 
966         // support the impeachment
967         lastImpeachmentProposal.voted[msg.sender] = true;
968         lastImpeachmentProposal.votesSupporting += votingRights[msg.sender];
969 
970         // rise impeachment suppporting event
971         ImpeachmentSupport(msg.sender, votingRights[msg.sender]);
972         
973         // if the vote is over 70% execute the switch 
974         uint percent = preferedQtySold / 100; 
975         
976         if (lastImpeachmentProposal.votesSupporting >= 70 * percent){
977             executive = lastImpeachmentProposal.newExecutive;
978             
979             // impeachment event
980             ImpeachmentAccepted(executive);
981         }
982         
983     } 
984     
985       
986     
987     // **************************** //
988     // *     Constant Getters     * //
989     // **************************** //
990     
991     function votingRightsOf(address _owner) constant returns (uint256 result) {
992         result = votingRights[_owner];
993     }
994     
995     function getPreferedQtySold() constant returns (uint result){
996         return preferedQtySold;
997     }
998     
999     function setVirtualExchange(address virtualExchangeAddr){
1000         if (virtualExchangeAddress != 0x0) throw;
1001         virtualExchangeAddress = virtualExchangeAddr;
1002     }
1003 
1004     function getHKGOwned() constant returns (uint result){
1005         return hackerGold.balanceOf(this);
1006     }
1007     
1008     function getEtherValue() constant returns (uint result){
1009         return this.balance;
1010     }
1011     
1012     function getExecutive() constant returns (address result){
1013         return executive;
1014     }
1015     
1016     function getHKGPrice() constant returns (uint result){
1017         return hkgPrice;
1018     }
1019 
1020     function getEtherPrice() constant returns (uint result){
1021         return etherPrice;
1022     }
1023     
1024     function getDSTName() constant returns(string result){
1025         return name;
1026     }    
1027     
1028     function getDSTNameBytes() constant returns(bytes32 result){
1029         return convert(name);
1030     }    
1031 
1032     function getDSTSymbol() constant returns(string result){
1033         return symbol;
1034     }    
1035     
1036     function getDSTSymbolBytes() constant returns(bytes32 result){
1037         return convert(symbol);
1038     }    
1039 
1040     function getAddress() constant returns (address result) {
1041         return this;
1042     }
1043     
1044     function getTotalSupply() constant returns (uint result) {
1045         return totalSupply;
1046     } 
1047         
1048     function getCollectedEther() constant returns (uint results) {        
1049         return collectedEther;
1050     }
1051     
1052     function getCounterProposals() constant returns (uint result){
1053         return counterProposals;
1054     }
1055         
1056     function getProposalIdByIndex(uint i) constant returns (bytes32 result){
1057         return listProposals[i].id;
1058     }    
1059 
1060     function getProposalObjectionByIndex(uint i) constant returns (uint result){
1061         return listProposals[i].votesObjecting;
1062     }
1063 
1064     function getProposalValueByIndex(uint i) constant returns (uint result){
1065         return listProposals[i].value;
1066     }                  
1067     
1068     function getCurrentImpeachmentUrlDetails() constant returns (string result){
1069         return lastImpeachmentProposal.urlDetails;
1070     }
1071     
1072     
1073     function getCurrentImpeachmentVotesSupporting() constant returns (uint result){
1074         return lastImpeachmentProposal.votesSupporting;
1075     }
1076     
1077     function convert(string key) returns (bytes32 ret) {
1078             if (bytes(key).length > 32) {
1079                 throw;
1080             }      
1081 
1082             assembly {
1083                 ret := mload(add(key, 32))
1084             }
1085     }    
1086     
1087     
1088     
1089     // ********************* //
1090     // *     Modifiers     * //
1091     // ********************* //    
1092  
1093     modifier onlyBeforeEnd() { if (now  >=  eventInfo.getEventEnd()) throw; _; }
1094     modifier onlyAfterEnd()  { if (now  <   eventInfo.getEventEnd()) throw; _; }
1095     
1096     modifier onlyAfterTradingStart()  { if (now  < eventInfo.getTradingStart()) throw; _; }
1097     
1098     modifier onlyExecutive()     { if (msg.sender != executive) throw; _; }
1099                                        
1100     modifier onlyIfAbleToIssueTokens()  { if (!ableToIssueTokens) throw; _; } 
1101     
1102 
1103     // ****************** //
1104     // *     Events     * //
1105     // ****************** //        
1106 
1107     
1108     event PriceHKGChange(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply);
1109     event BuyForHKGTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneHKG, uint tokensAmount);
1110     event BuyForEtherTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneEther, uint tokensAmount);
1111 
1112     event DstTokensIssued(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply, uint qtyToEmit);
1113     
1114     event ProposalRequestSubmitted(bytes32 id, uint value, uint timeEnds, string url, address sender);
1115     
1116     event EtherRedeemAccepted(address sender, uint value);
1117     
1118     event ObjectedVote(bytes32 id, address voter, uint votes);
1119     
1120     event ImpeachmentProposed(address submitter, string urlDetails, uint votindEndTS, address newExecutive);
1121     event ImpeachmentSupport(address supportter, uint votes);
1122     
1123     event ImpeachmentAccepted(address newExecutive);
1124 
1125     event NewEtherPrice(uint newQtyForOneEther);
1126     event DisableTokenIssuance();
1127     
1128     event BurnedAllRemainedTokens();
1129     
1130 }
1131 
1132 
1133  
1134 contract EventInfo{
1135     
1136     
1137     uint constant HACKATHON_5_WEEKS = 60 * 60 * 24 * 7 * 5;
1138     uint constant T_1_WEEK = 60 * 60 * 24 * 7;
1139 
1140     uint eventStart = 1479391200; // Thu, 17 Nov 2016 14:00:00 GMT
1141     uint eventEnd = eventStart + HACKATHON_5_WEEKS;
1142     
1143     
1144     /**
1145      * getEventStart - return the start of the event time
1146      */ 
1147     function getEventStart() constant returns (uint result){        
1148        return eventStart;
1149     } 
1150     
1151     /**
1152      * getEventEnd - return the end of the event time
1153      */ 
1154     function getEventEnd() constant returns (uint result){        
1155        return eventEnd;
1156     } 
1157     
1158     
1159     /**
1160      * getVotingStart - the voting starts 1 week after the 
1161      *                  event starts
1162      */ 
1163     function getVotingStart() constant returns (uint result){
1164         return eventStart+ T_1_WEEK;
1165     }
1166 
1167     /**
1168      * getTradingStart - the DST tokens trading starts 1 week 
1169      *                   after the event starts
1170      */ 
1171     function getTradingStart() constant returns (uint result){
1172         return eventStart+ T_1_WEEK;
1173     }
1174 
1175     /**
1176      * getNow - helper class to check what time the contract see
1177      */
1178     function getNow() constant returns (uint result){        
1179        return now;
1180     } 
1181     
1182 }