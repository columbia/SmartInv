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
207 /**
208  *
209  * @title Hacker Gold
210  * 
211  * The official token powering the hack.ether.camp virtual accelerator.
212  * This is the only way to acquire tokens from startups during the event.
213  *
214  * Whitepaper https://hack.ether.camp/whitepaper
215  *
216  */
217 contract HackerGold is StandardToken {
218 
219     // Name of the token    
220     string public name = "HackerGold";
221 
222     // Decimal places
223     uint8  public decimals = 3;
224     // Token abbreviation        
225     string public symbol = "HKG";
226     
227     // 1 ether = 200 hkg
228     uint BASE_PRICE = 200;
229     // 1 ether = 150 hkg
230     uint MID_PRICE = 150;
231     // 1 ether = 100 hkg
232     uint FIN_PRICE = 100;
233     // Safety cap
234     uint SAFETY_LIMIT = 4000000 ether;
235     // Zeros after the point
236     uint DECIMAL_ZEROS = 1000;
237     
238     // Total value in wei
239     uint totalValue;
240     
241     // Address of multisig wallet holding ether from sale
242     address wallet;
243 
244     // Structure of sale increase milestones
245     struct milestones_struct {
246       uint p1;
247       uint p2; 
248       uint p3;
249       uint p4;
250       uint p5;
251       uint p6;
252     }
253     // Milestones instance
254     milestones_struct milestones;
255     
256     /**
257      * Constructor of the contract.
258      * 
259      * Passes address of the account holding the value.
260      * HackerGold contract itself does not hold any value
261      * 
262      * @param multisig address of MultiSig wallet which will hold the value
263      */
264     function HackerGold(address multisig) {
265         
266         wallet = multisig;
267 
268         // set time periods for sale
269         milestones = milestones_struct(
270         
271           1476972000,  // P1: GMT: 20-Oct-2016 14:00  => The Sale Starts
272           1478181600,  // P2: GMT: 03-Nov-2016 14:00  => 1st Price Ladder 
273           1479391200,  // P3: GMT: 17-Nov-2016 14:00  => Price Stable, 
274                        //                                Hackathon Starts
275           1480600800,  // P4: GMT: 01-Dec-2016 14:00  => 2nd Price Ladder
276           1481810400,  // P5: GMT: 15-Dec-2016 14:00  => Price Stable
277           1482415200   // P6: GMT: 22-Dec-2016 14:00  => Sale Ends, Hackathon Ends
278         );
279                 
280     }
281     
282     
283     /**
284      * Fallback function: called on ether sent.
285      * 
286      * It calls to createHKG function with msg.sender 
287      * as a value for holder argument
288      */
289     function () payable {
290         createHKG(msg.sender);
291     }
292     
293     /**
294      * Creates HKG tokens.
295      * 
296      * Runs sanity checks including safety cap
297      * Then calculates current price by getPrice() function, creates HKG tokens
298      * Finally sends a value of transaction to the wallet
299      * 
300      * Note: due to lack of floating point types in Solidity,
301      * contract assumes that last 3 digits in tokens amount are stood after the point.
302      * It means that if stored HKG balance is 100000, then its real value is 100 HKG
303      * 
304      * @param holder token holder
305      */
306     function createHKG(address holder) payable {
307         
308         if (now < milestones.p1) throw;
309         if (now >= milestones.p6) throw;
310         if (msg.value == 0) throw;
311     
312         // safety cap
313         if (getTotalValue() + msg.value > SAFETY_LIMIT) throw; 
314     
315         uint tokens = msg.value * getPrice() * DECIMAL_ZEROS / 1 ether;
316 
317         totalSupply += tokens;
318         balances[holder] += tokens;
319         totalValue += msg.value;
320         
321         if (!wallet.send(msg.value)) throw;
322     }
323     
324     /**
325      * Denotes complete price structure during the sale.
326      *
327      * @return HKG amount per 1 ETH for the current moment in time
328      */
329     function getPrice() constant returns (uint result) {
330         
331         if (now < milestones.p1) return 0;
332         
333         if (now >= milestones.p1 && now < milestones.p2) {
334         
335             return BASE_PRICE;
336         }
337         
338         if (now >= milestones.p2 && now < milestones.p3) {
339             
340             uint days_in = 1 + (now - milestones.p2) / 1 days; 
341             return BASE_PRICE - days_in * 25 / 7;  // daily decrease 3.5
342         }
343 
344         if (now >= milestones.p3 && now < milestones.p4) {
345         
346             return MID_PRICE;
347         }
348         
349         if (now >= milestones.p4 && now < milestones.p5) {
350             
351             days_in = 1 + (now - milestones.p4) / 1 days; 
352             return MID_PRICE - days_in * 25 / 7;  // daily decrease 3.5
353         }
354 
355         if (now >= milestones.p5 && now < milestones.p6) {
356         
357             return FIN_PRICE;
358         }
359         
360         if (now >= milestones.p6){
361 
362             return 0;
363         }
364 
365      }
366     
367     /**
368      * Returns total stored HKG amount.
369      * 
370      * Contract assumes that last 3 digits of this value are behind the decimal place. i.e. 10001 is 10.001
371      * Thus, result of this function should be divided by 1000 to get HKG value
372      * 
373      * @return result stored HKG amount
374      */
375     function getTotalSupply() constant returns (uint result) {
376         return totalSupply;
377     } 
378 
379     /**
380      * It is used for test purposes.
381      * 
382      * Returns the result of 'now' statement of Solidity language
383      * 
384      * @return unix timestamp for current moment in time
385      */
386     function getNow() constant returns (uint result) {
387         return now;
388     }
389 
390     /**
391      * Returns total value passed through the contract
392      * 
393      * @return result total value in wei
394      */
395     function getTotalValue() constant returns (uint result) {
396         return totalValue;  
397     }
398 }
399 
400 /**
401  * 
402  * EventInfo - imutable class that denotes
403  * the time of the virtual accelerator hack
404  * event
405  * 
406  */
407 contract EventInfo{
408     
409     
410     uint constant HACKATHON_5_WEEKS = 60 * 60 * 24 * 7 * 5;
411     uint constant T_1_WEEK = 60 * 60 * 24 * 7;
412 
413     uint eventStart = 1479391200; // Thu, 17 Nov 2016 14:00:00 GMT
414     uint eventEnd = eventStart + HACKATHON_5_WEEKS;
415     
416     
417     /**
418      * getEventStart - return the start of the event time
419      */ 
420     function getEventStart() constant returns (uint result){        
421        return eventStart;
422     } 
423     
424     /**
425      * getEventEnd - return the end of the event time
426      */ 
427     function getEventEnd() constant returns (uint result){        
428        return eventEnd;
429     } 
430     
431     
432     /**
433      * getVotingStart - the voting starts 1 week after the 
434      *                  event starts
435      */ 
436     function getVotingStart() constant returns (uint result){
437         return eventStart+ T_1_WEEK;
438     }
439 
440     /**
441      * getTradingStart - the DST tokens trading starts 1 week 
442      *                   after the event starts
443      */ 
444     function getTradingStart() constant returns (uint result){
445         return eventStart+ T_1_WEEK;
446     }
447 
448     /**
449      * getNow - helper class to check what time the contract see
450      */
451     function getNow() constant returns (uint result){        
452        return now;
453     } 
454     
455 }
456 
457 /*
458  * DSTContract - DST stands for decentralized startup team.
459  *               the contract ensures funding for a decentralized
460  *               team in 2 phases: 
461  *
462  *                +. Funding by HKG during the hackathon event. 
463  *                +. Funding by Ether after the event is over. 
464  *
465  *               After the funds been collected there is a governence
466  *               mechanism managed by proposition to withdraw funds
467  *               for development usage. 
468  *
469  *               The DST ensures that backers of the projects keeps
470  *               some influence on the project by ability to reject
471  *               propositions they find as non effective. 
472  *
473  *               In very radical occasions the backers may loose 
474  *               the trust in the team completelly, in that case 
475  *               there is an option to propose impeachment process
476  *               completelly removing the execute and assigning new
477  *               person to manage the funds. 
478  *
479  */
480 contract DSTContract is StandardToken{
481 
482     // Zeros after the point
483     uint DECIMAL_ZEROS = 1000;
484     // Proposal lifetime
485     uint PROPOSAL_LIFETIME = 10 days;
486     // Proposal funds threshold, in percents
487     uint PROPOSAL_FUNDS_TH = 20;
488 
489     address   executive; 
490         
491     EventInfo eventInfo;
492     
493     // Indicated where the DST is traded
494     address virtualExchangeAddress;
495     
496     HackerGold hackerGold;
497         
498     mapping (address => uint256) votingRights;
499 
500 
501     // 1 - HKG => DST qty; tokens for 1 HKG
502     uint hkgPrice;
503     
504     // 1 - Ether => DST qty; tokens for 1 Ether
505     uint etherPrice;
506     
507     string public name = "...";                   
508     uint8  public decimals = 3;                 
509     string public symbol = "...";
510     
511     bool ableToIssueTokens = true; 
512     
513     uint preferedQtySold;
514 
515     uint collectedHKG; 
516     uint collectedEther;    
517     
518     // Proposal of the funds spending
519     mapping (bytes32 => Proposal) proposals;
520 
521     enum ProposalCurrency { HKG, ETHER }
522     ProposalCurrency enumDeclaration;
523                   
524        
525     struct Proposal{
526         
527         bytes32 id;
528         uint value;
529 
530         string urlDetails;
531 
532         uint votindEndTS;
533                 
534         uint votesObjecting;
535         
536         address submitter;
537         bool redeemed;
538 
539         ProposalCurrency proposalCurrency;
540         
541         mapping (address => bool) voted;
542     }
543     uint counterProposals;
544     uint timeOfLastProposal;
545     
546     Proposal[] listProposals;
547     
548 
549     /**
550      * Impeachment process proposals
551      */    
552     struct ImpeachmentProposal{
553         
554         string urlDetails;
555         
556         address newExecutive;
557 
558         uint votindEndTS;        
559         uint votesSupporting;
560         
561         mapping (address => bool) voted;        
562     }
563     ImpeachmentProposal lastImpeachmentProposal;
564 
565         
566     /**
567      * 
568      *  DSTContract: ctor for DST token and governence contract
569      *
570      *  @param eventInfoAddr EventInfo: address of object denotes events 
571      *                                  milestones      
572      *  @param hackerGoldAddr HackerGold: address of HackerGold token
573      *
574      *  @param dstName string: dstName: real name of the team
575      *
576      *  @param dstSymbol string: 3 letter symbold of the team
577      *
578      */ 
579     function DSTContract(EventInfo eventInfoAddr, HackerGold hackerGoldAddr, string dstName, string dstSymbol){
580     
581       executive   = msg.sender;  
582       name        = dstName;
583       symbol      = dstSymbol;
584 
585       hackerGold = HackerGold(hackerGoldAddr);
586       eventInfo  = EventInfo(eventInfoAddr);
587     }
588     
589 
590     function() payable
591                onlyAfterEnd {
592         
593         // there is tokens left from hackathon 
594         if (etherPrice == 0) throw;
595         
596         uint tokens = msg.value * etherPrice * DECIMAL_ZEROS / (1 ether);
597         
598         // check if demand of tokens is 
599         // overflow the supply 
600         uint retEther = 0;
601         if (balances[this] < tokens) {
602             
603             tokens = balances[this];
604             retEther = msg.value - tokens / etherPrice * (1 finney);
605         
606             // return left ether 
607             if (!msg.sender.send(retEther)) throw;
608         }
609         
610         
611         // do transfer
612         balances[msg.sender] += tokens;
613         balances[this] -= tokens;
614         
615         // count collected ether 
616         collectedEther += msg.value - retEther; 
617         
618         // rise event
619         BuyForEtherTransaction(msg.sender, collectedEther, totalSupply, etherPrice, tokens);
620         
621     }
622 
623     
624     
625     /**
626      * setHKGPrice - set price: 1HKG => DST tokens qty
627      *
628      *  @param qtyForOneHKG uint: DST tokens for 1 HKG
629      * 
630      */    
631      function setHKGPrice(uint qtyForOneHKG) onlyExecutive  {
632          
633          hkgPrice = qtyForOneHKG;
634          PriceHKGChange(qtyForOneHKG, preferedQtySold, totalSupply);
635      }
636      
637      
638     
639     /**
640      * 
641      * issuePreferedTokens - prefered tokens issued on the hackathon event
642      *                       grant special rights
643      *
644      *  @param qtyForOneHKG uint: price DST tokens for one 1 HKG
645      *  @param qtyToEmit uint: new supply of tokens 
646      * 
647      */
648     function issuePreferedTokens(uint qtyForOneHKG, 
649                                  uint qtyToEmit) onlyExecutive 
650                                                  onlyIfAbleToIssueTokens
651                                                  onlyBeforeEnd
652                                                  onlyAfterTradingStart {
653                 
654         // no issuence is allowed before enlisted on the
655         // exchange 
656         if (virtualExchangeAddress == 0x0) throw;
657             
658         totalSupply    += qtyToEmit;
659         balances[this] += qtyToEmit;
660         hkgPrice = qtyForOneHKG;
661         
662         
663         // now spender can use balance in 
664         // amount of value from owner balance
665         allowed[this][virtualExchangeAddress] += qtyToEmit;
666         
667         // rise event about the transaction
668         Approval(this, virtualExchangeAddress, qtyToEmit);
669         
670         // rise event 
671         DstTokensIssued(hkgPrice, preferedQtySold, totalSupply, qtyToEmit);
672     }
673 
674     
675     
676     
677     /**
678      * 
679      * buyForHackerGold - on the hack event this function is available 
680      *                    the buyer for hacker gold will gain votes to 
681      *                    influence future proposals on the DST
682      *    
683      *  @param hkgValue - qty of this DST tokens for 1 HKG     
684      * 
685      */
686     function buyForHackerGold(uint hkgValue) onlyBeforeEnd 
687                                              returns (bool success) {
688     
689       // validate that the caller is official accelerator HKG Exchange
690       if (msg.sender != virtualExchangeAddress) throw;
691       
692       
693       // transfer token 
694       address sender = tx.origin;
695       uint tokensQty = hkgValue * hkgPrice;
696 
697       // gain voting rights
698       votingRights[sender] +=tokensQty;
699       preferedQtySold += tokensQty;
700       collectedHKG += hkgValue;
701 
702       // do actual transfer
703       transferFrom(this, 
704                    virtualExchangeAddress, tokensQty);
705       transfer(sender, tokensQty);        
706             
707       // rise event       
708       BuyForHKGTransaction(sender, preferedQtySold, totalSupply, hkgPrice, tokensQty);
709         
710       return true;
711     }
712         
713     
714     /**
715      * 
716      * issueTokens - function will issue tokens after the 
717      *               event, able to sell for 1 ether 
718      * 
719      *  @param qtyForOneEther uint: DST tokens for 1 ETH
720      *  @param qtyToEmit uint: new tokens supply
721      *
722      */
723     function issueTokens(uint qtyForOneEther, 
724                          uint qtyToEmit) onlyAfterEnd 
725                                          onlyExecutive
726                                          onlyIfAbleToIssueTokens {
727          
728          balances[this] += qtyToEmit;
729          etherPrice = qtyForOneEther;
730          totalSupply    += qtyToEmit;
731          
732          // rise event  
733          DstTokensIssued(qtyForOneEther, totalSupply, totalSupply, qtyToEmit);
734     }
735      
736     
737     /**
738      * setEtherPrice - change the token price
739      *
740      *  @param qtyForOneEther uint: new price - DST tokens for 1 ETH
741      */     
742     function setEtherPrice(uint qtyForOneEther) onlyAfterEnd
743                                                 onlyExecutive {
744          etherPrice = qtyForOneEther; 
745 
746          // rise event for this
747          NewEtherPrice(qtyForOneEther);
748     }    
749     
750 
751     /**
752      *  disableTokenIssuance - function will disable any 
753      *                         option for future token 
754      *                         issuence
755      */
756     function disableTokenIssuance() onlyExecutive {
757         ableToIssueTokens = false;
758         
759         DisableTokenIssuance();
760     }
761 
762     
763     /**
764      *  burnRemainToken -  eliminated all available for sale
765      *                     tokens. 
766      */
767     function burnRemainToken() onlyExecutive {
768     
769         totalSupply -= balances[this];
770         balances[this] = 0;
771         
772         // rise event for this
773         BurnedAllRemainedTokens();
774     }
775     
776     /**
777      *  submitEtherProposal: submit proposal to use part of the 
778      *                       collected ether funds
779      *
780      *   @param requestValue uint: value in wei 
781      *   @param url string: details of the proposal 
782      */ 
783     function submitEtherProposal(uint requestValue, string url) onlyAfterEnd 
784                                                                 onlyExecutive returns (bytes32 resultId, bool resultSucces) {       
785     
786         // ensure there is no more issuence available 
787         if (ableToIssueTokens) throw;
788             
789         // ensure there is no more tokens available 
790         if (balanceOf(this) > 0) throw;
791 
792         // Possible to submit a proposal once 2 weeks 
793         if (now < (timeOfLastProposal + 2 weeks)) throw;
794             
795         uint percent = collectedEther / 100;
796             
797         if (requestValue > PROPOSAL_FUNDS_TH * percent) throw;
798 
799         // if remained value is less than requested gain all.
800         if (requestValue > this.balance) 
801             requestValue = this.balance;    
802             
803         // set id of the proposal
804         // submit proposal to the map
805         bytes32 id = sha3(msg.data, now);
806         uint timeEnds = now + PROPOSAL_LIFETIME; 
807             
808         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.ETHER);
809         proposals[id] = newProposal;
810         listProposals.push(newProposal);
811             
812         timeOfLastProposal = now;                        
813         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
814         
815         return (id, true);
816     }
817     
818     
819      
820     /**
821      * 
822      * submitHKGProposal - submit proposal to request for 
823      *                     partial HKG funds collected 
824      * 
825      *  @param requestValue uint: value in HKG to request. 
826      *  @param url string: url with details on the proposition 
827      */
828     function submitHKGProposal(uint requestValue, string url) onlyAfterEnd
829                                                               onlyExecutive returns (bytes32 resultId, bool resultSucces){
830         
831 
832         // If there is no 2 months over since the last event.
833         // There is no posible to get any HKG. After 2 months
834         // all the HKG is available. 
835         if (now < (eventInfo.getEventEnd() + 8 weeks)) {
836             throw;
837         }
838 
839         // Possible to submit a proposal once 2 weeks 
840         if (now < (timeOfLastProposal + 2 weeks)) throw;
841 
842         uint percent = preferedQtySold / 100;
843         
844         // validate the amount is legit
845         // first 5 proposals should be less than 20% 
846         if (counterProposals <= 5 && 
847             requestValue     >  PROPOSAL_FUNDS_TH * percent) throw;
848                 
849         // if remained value is less than requested 
850         // gain all.
851         if (requestValue > getHKGOwned()) 
852             requestValue = getHKGOwned();
853         
854         
855         // set id of the proposal
856         // submit proposal to the map
857         bytes32 id = sha3(msg.data, now);
858         uint timeEnds = now + PROPOSAL_LIFETIME; 
859         
860         Proposal memory newProposal = Proposal(id, requestValue, url, timeEnds, 0, msg.sender, false, ProposalCurrency.HKG);
861         proposals[id] = newProposal;
862         listProposals.push(newProposal);
863         
864         ++counterProposals;
865         timeOfLastProposal = now;                
866                 
867         ProposalRequestSubmitted(id, requestValue, timeEnds, url, msg.sender);
868         
869         return (id, true);        
870     }  
871     
872     
873     
874     /**
875      * objectProposal - object previously submitted proposal, 
876      *                  the objection right is obtained by 
877      *                  purchasing prefered tokens on time of 
878      *                  the hackathon.
879      * 
880      *  @param id bytes32 : the id of the proposla to redeem
881      */
882      function objectProposal(bytes32 id){
883          
884         Proposal memory proposal = proposals[id];
885          
886         // check proposal exist 
887         if (proposals[id].id == 0) throw;
888 
889         // check already redeemed
890         if (proposals[id].redeemed) throw;
891          
892         // ensure objection time
893         if (now >= proposals[id].votindEndTS) throw;
894          
895         // ensure not voted  
896         if (proposals[id].voted[msg.sender]) throw;
897          
898          // submit votes
899          uint votes = votingRights[msg.sender];
900          proposals[id].votesObjecting += votes;
901          
902          // mark voted 
903          proposals[id].voted[msg.sender] = true; 
904          
905          uint idx = getIndexByProposalId(id);
906          listProposals[idx] = proposals[id];   
907 
908          ObjectedVote(id, msg.sender, votes);         
909      }
910      
911      
912      function getIndexByProposalId(bytes32 id) returns (uint result){
913          
914          for (uint i = 0; i < listProposals.length; ++i){
915              if (id == listProposals[i].id) return i;
916          }
917      }
918     
919     
920    
921     /**
922      * redeemProposalFunds - redeem funds requested by prior 
923      *                       submitted proposal     
924      * 
925      * @param id bytes32: the id of the proposal to redeem
926      */
927     function redeemProposalFunds(bytes32 id) onlyExecutive {
928 
929         if (proposals[id].id == 0) throw;
930         if (proposals[id].submitter != msg.sender) throw;
931 
932         // ensure objection time
933         if (now < proposals[id].votindEndTS) throw;
934                            
935     
936             // check already redeemed
937         if (proposals[id].redeemed) throw;
938 
939         // check votes objection => 55% of total votes
940         uint objectionThreshold = preferedQtySold / 100 * 55;
941         if (proposals[id].votesObjecting  > objectionThreshold) throw;
942     
943     
944         if (proposals[id].proposalCurrency == ProposalCurrency.HKG){
945             
946             // send hacker gold 
947             hackerGold.transfer(proposals[id].submitter, proposals[id].value);      
948                         
949         } else {
950                         
951            // send ether              
952            bool success = proposals[id].submitter.send(proposals[id].value); 
953 
954            // rise event
955            EtherRedeemAccepted(proposals[id].submitter, proposals[id].value);                              
956         }
957         
958         // execute the proposal 
959         proposals[id].redeemed = true; 
960     }
961     
962     
963     /**
964      *  getAllTheFunds - to ensure there is no deadlock can 
965      *                   can happen, and no case that voting 
966      *                   structure will freeze the funds forever
967      *                   the startup will be able to get all the
968      *                   funds without a proposal required after
969      *                   6 months.
970      * 
971      * 
972      */             
973     function getAllTheFunds() onlyExecutive {
974         
975         // If there is a deadlock in voting participates
976         // the funds can be redeemed completelly in 6 months
977         if (now < (eventInfo.getEventEnd() + 24 weeks)) {
978             throw;
979         }  
980         
981         // all the Ether
982         bool success = msg.sender.send(this.balance);        
983         
984         // all the HKG
985         hackerGold.transfer(msg.sender, getHKGOwned());              
986     }
987     
988     
989     /**
990      * submitImpeachmentProposal - submit request to switch 
991      *                             executive.
992      * 
993      *  @param urlDetails  - details of the impeachment proposal 
994      *  @param newExecutive - address of the new executive 
995      * 
996      */             
997      function submitImpeachmentProposal(string urlDetails, address newExecutive){
998          
999         // to offer impeachment you should have 
1000         // voting rights
1001         if (votingRights[msg.sender] == 0) throw;
1002          
1003         // the submission of the first impeachment 
1004         // proposal is possible only after 3 months
1005         // since the hackathon is over
1006         if (now < (eventInfo.getEventEnd() + 12 weeks)) throw;
1007         
1008                 
1009         // check there is 1 months over since last one
1010         if (lastImpeachmentProposal.votindEndTS != 0 && 
1011             lastImpeachmentProposal.votindEndTS +  2 weeks > now) throw;
1012 
1013 
1014         // submit impeachment proposal
1015         // add the votes of the submitter 
1016         // to the proposal right away
1017         lastImpeachmentProposal = ImpeachmentProposal(urlDetails, newExecutive, now + 2 weeks, votingRights[msg.sender]);
1018         lastImpeachmentProposal.voted[msg.sender] = true;
1019          
1020         // rise event
1021         ImpeachmentProposed(msg.sender, urlDetails, now + 2 weeks, newExecutive);
1022      }
1023     
1024     
1025     /**
1026      * supportImpeachment - vote for impeachment proposal 
1027      *                      that is currently in progress
1028      *
1029      */
1030     function supportImpeachment(){
1031 
1032         // ensure that support is for exist proposal 
1033         if (lastImpeachmentProposal.newExecutive == 0x0) throw;
1034     
1035         // to offer impeachment you should have 
1036         // voting rights
1037         if (votingRights[msg.sender] == 0) throw;
1038         
1039         // check if not voted already 
1040         if (lastImpeachmentProposal.voted[msg.sender]) throw;
1041         
1042         // check if not finished the 2 weeks of voting 
1043         if (lastImpeachmentProposal.votindEndTS + 2 weeks <= now) throw;
1044                 
1045         // support the impeachment
1046         lastImpeachmentProposal.voted[msg.sender] = true;
1047         lastImpeachmentProposal.votesSupporting += votingRights[msg.sender];
1048 
1049         // rise impeachment suppporting event
1050         ImpeachmentSupport(msg.sender, votingRights[msg.sender]);
1051         
1052         // if the vote is over 70% execute the switch 
1053         uint percent = preferedQtySold / 100; 
1054         
1055         if (lastImpeachmentProposal.votesSupporting >= 70 * percent){
1056             executive = lastImpeachmentProposal.newExecutive;
1057             
1058             // impeachment event
1059             ImpeachmentAccepted(executive);
1060         }
1061         
1062     } 
1063     
1064       
1065     
1066     // **************************** //
1067     // *     Constant Getters     * //
1068     // **************************** //
1069     
1070     function votingRightsOf(address _owner) constant returns (uint256 result) {
1071         result = votingRights[_owner];
1072     }
1073     
1074     function getPreferedQtySold() constant returns (uint result){
1075         return preferedQtySold;
1076     }
1077     
1078     function setVirtualExchange(address virtualExchangeAddr){
1079         virtualExchangeAddress = virtualExchangeAddr;
1080     }
1081 
1082     function getHKGOwned() constant returns (uint result){
1083         return hackerGold.balanceOf(this);
1084     }
1085     
1086     function getEtherValue() constant returns (uint result){
1087         return this.balance;
1088     }
1089     
1090     function getExecutive() constant returns (address result){
1091         return executive;
1092     }
1093     
1094     function getHKGPrice() constant returns (uint result){
1095         return hkgPrice;
1096     }
1097 
1098     function getEtherPrice() constant returns (uint result){
1099         return etherPrice;
1100     }
1101     
1102     function getDSTName() constant returns(string result){
1103         return name;
1104     }    
1105     
1106     function getDSTNameBytes() constant returns(bytes32 result){
1107         return convert(name);
1108     }    
1109 
1110     function getDSTSymbol() constant returns(string result){
1111         return symbol;
1112     }    
1113     
1114     function getDSTSymbolBytes() constant returns(bytes32 result){
1115         return convert(symbol);
1116     }    
1117 
1118     function getAddress() constant returns (address result) {
1119         return this;
1120     }
1121     
1122     function getTotalSupply() constant returns (uint result) {
1123         return totalSupply;
1124     } 
1125         
1126     function getCollectedEther() constant returns (uint results) {        
1127         return collectedEther;
1128     }
1129     
1130     function getCounterProposals() constant returns (uint result){
1131         return counterProposals;
1132     }
1133         
1134     function getProposalIdByIndex(uint i) constant returns (bytes32 result){
1135         return listProposals[i].id;
1136     }    
1137 
1138     function getProposalObjectionByIndex(uint i) constant returns (uint result){
1139         return listProposals[i].votesObjecting;
1140     }
1141 
1142     function getProposalValueByIndex(uint i) constant returns (uint result){
1143         return listProposals[i].value;
1144     }                  
1145     
1146     function getCurrentImpeachmentUrlDetails() constant returns (string result){
1147         return lastImpeachmentProposal.urlDetails;
1148     }
1149     
1150     
1151     function getCurrentImpeachmentVotesSupporting() constant returns (uint result){
1152         return lastImpeachmentProposal.votesSupporting;
1153     }
1154     
1155     function convert(string key) returns (bytes32 ret) {
1156             if (bytes(key).length > 32) {
1157                 throw;
1158             }      
1159 
1160             assembly {
1161                 ret := mload(add(key, 32))
1162             }
1163     }    
1164     
1165     
1166     
1167     // ********************* //
1168     // *     Modifiers     * //
1169     // ********************* //    
1170  
1171     modifier onlyBeforeEnd() { if (now  >=  eventInfo.getEventEnd()) throw; _; }
1172     modifier onlyAfterEnd()  { if (now  <   eventInfo.getEventEnd()) throw; _; }
1173     
1174     modifier onlyAfterTradingStart()  { if (now  < eventInfo.getTradingStart()) throw; _; }
1175     
1176     modifier onlyExecutive()     { if (msg.sender != executive) throw; _; }
1177                                        
1178     modifier onlyIfAbleToIssueTokens()  { if (!ableToIssueTokens) throw; _; } 
1179     
1180 
1181     // ****************** //
1182     // *     Events     * //
1183     // ****************** //        
1184 
1185     
1186     event PriceHKGChange(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply);
1187     event BuyForHKGTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneHKG, uint tokensAmount);
1188     event BuyForEtherTransaction(address indexed buyer, uint indexed tokensSold, uint indexed totalSupply, uint qtyForOneEther, uint tokensAmount);
1189 
1190     event DstTokensIssued(uint indexed qtyForOneHKG, uint indexed tokensSold, uint indexed totalSupply, uint qtyToEmit);
1191     
1192     event ProposalRequestSubmitted(bytes32 id, uint value, uint timeEnds, string url, address sender);
1193     
1194     event EtherRedeemAccepted(address sender, uint value);
1195     
1196     event ObjectedVote(bytes32 id, address voter, uint votes);
1197     
1198     event ImpeachmentProposed(address submitter, string urlDetails, uint votindEndTS, address newExecutive);
1199     event ImpeachmentSupport(address supportter, uint votes);
1200     
1201     event ImpeachmentAccepted(address newExecutive);
1202 
1203     event NewEtherPrice(uint newQtyForOneEther);
1204     event DisableTokenIssuance();
1205     
1206     event BurnedAllRemainedTokens();
1207     
1208 }
1209 
1210 
1211  
1212 
1213 /**
1214  *  VirtualExchange -  The exchange is a trading system used
1215  *                     on hack.ether.camp hackathon event to 
1216  *                     support trading a DST tokens for HKG. 
1217  *                    
1218  */
1219 contract VirtualExchange{
1220 
1221     address owner;  
1222     EventInfo eventInfo;
1223  
1224     mapping (bytes32 => address) dstListed;
1225     
1226     HackerGold hackerGold;
1227     
1228     function VirtualExchange(address hackerGoldAddr, address eventInfoAddr){
1229     
1230         owner = msg.sender;
1231         hackerGold = HackerGold(hackerGoldAddr);
1232         eventInfo  = EventInfo(eventInfoAddr);
1233     }
1234     
1235     
1236     /**
1237      * enlist - enlisting one decentralized startup team to 
1238      *          the hack event virtual exchange, making the 
1239      *          DST initated tokens available for acquisition.
1240      * 
1241      *  @param dstAddress - address of the DSTContract 
1242      * 
1243      */ 
1244     function enlist(address dstAddress) onlyBeforeEnd {
1245 
1246         DSTContract dstContract = DSTContract(dstAddress);
1247 
1248         bytes32 symbolBytes = dstContract.getDSTSymbolBytes();
1249 
1250         /* Don't enlist 2 with the same name */
1251         if (isExistByBytes(symbolBytes)) throw;
1252 
1253         // Only owner of the DST can deploy the DST 
1254         if (dstContract.getExecutive() != msg.sender) throw;
1255 
1256         // All good enlist the company
1257         dstListed[symbolBytes] = dstAddress;
1258         
1259         // Indicate to DST which Virtual Exchange is enlisted
1260         dstContract.setVirtualExchange(address(this));
1261         
1262         // rise Enlisted event
1263         Enlisted(dstAddress);
1264     }
1265     
1266    
1267 
1268     /**
1269      *
1270      * buy - on the hackathon timeframe that is the function 
1271      *       that will be the way to buy specific tokens for 
1272      *       startup.
1273      * 
1274      * @param companyNameBytes - the company that is enlisted on the exchange 
1275      *                           and the tokens are available
1276      * 
1277      * @param hkg - the ammount of hkg to spend for aquastion 
1278      *
1279      */
1280     function buy(bytes32 companyNameBytes, uint hkg) onlyBeforeEnd
1281                                                returns (bool success) {
1282 
1283     
1284         // check DST exist 
1285         if (!isExistByBytes(companyNameBytes)) throw;
1286 
1287         // validate availability  
1288         DSTContract dstContract = DSTContract(dstListed[companyNameBytes]);
1289         uint tokensQty = hkg * dstContract.getHKGPrice();
1290 
1291         address veAddress = address(this);        
1292         
1293         // ensure that there is HKG balance
1294         uint valueHKGOwned = hackerGold.balanceOf(msg.sender);        
1295         if (valueHKGOwned < hkg) throw;        
1296         
1297         // ensure that there is HKG token allowed to be spend
1298         uint valueAvailbeOnExchange = hackerGold.allowance(msg.sender, veAddress);
1299         if (valueAvailbeOnExchange < hkg) throw;
1300 
1301         // ensure there is DST tokens for sale
1302         uint dstTokens = dstContract.allowance(dstContract, veAddress);
1303         if (dstTokens < hkg * dstContract.getHKGPrice()) throw;    
1304                         
1305         // Transfer HKG to Virtual Exchange account  
1306         hackerGold.transferFrom(msg.sender, veAddress, hkg);
1307 
1308         // Transfer to dstCotract ownership
1309         hackerGold.transfer(dstContract.getAddress(), hkg);         
1310         
1311         // Call DST to transfer tokens 
1312         dstContract.buyForHackerGold(hkg);            
1313     }
1314         
1315 
1316     // **************************** //
1317     // *     Constant Getters     * //
1318     // **************************** //        
1319     
1320 
1321     function isExistByBytes(bytes32 companyNameBytes) constant returns (bool result) {
1322             
1323         if (dstListed[companyNameBytes] == 0x0) 
1324             return false;
1325         else 
1326             return true;                  
1327     }
1328     
1329     function getEventStart() constant eventInfoSet returns (uint result){
1330         return eventInfo.getEventStart();
1331     }
1332 
1333     function getEventEnd() constant eventInfoSet returns (uint result){
1334         return eventInfo.getEventEnd();
1335     }
1336     
1337     function getNow() constant returns (uint result){
1338         return now;
1339     }
1340     
1341 
1342 
1343     // ********************* //
1344     // *     Modifiers     * //
1345     // ********************* //        
1346     
1347 
1348     modifier onlyOwner()    { if (msg.sender != owner)        throw; _; }
1349     modifier eventInfoSet() { if (eventInfo  == address(0))   throw; _; }
1350     
1351     modifier onlyBeforeEnd() { if (now  >= eventInfo.getEventEnd()) throw; _; }
1352     modifier onlyAfterEnd()  { if (now  <  eventInfo.getEventEnd()) throw; _; }
1353     
1354 
1355     // ****************** //
1356     // *     Events     * //
1357     // ****************** //        
1358     
1359     event Enlisted(address indexed dstContract);
1360     
1361     
1362 }