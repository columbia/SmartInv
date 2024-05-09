1 // Appics tokensale smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 
4 pragma solidity ^ 0.4.15;
5 
6 /**
7  *   @title SafeMath
8  *   @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal constant returns(uint256) {
18         assert(b > 0);
19         uint256 c = a / b;
20         assert(a == b * c + a % b);
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal constant returns(uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal constant returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  *   @title ERC20
39  *   @dev Standart ERC20 token interface
40  */
41 contract ERC20 {
42     uint256 public totalSupply = 0;
43     mapping(address => uint256) balances;
44     mapping(address => mapping(address => uint256)) allowed;
45     function balanceOf(address _owner) public constant returns(uint256);
46     function transfer(address _to, uint256 _value) public returns(bool);
47     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
48     function approve(address _spender, uint256 _value) public returns(bool);
49     function allowance(address _owner, address _spender) public constant returns(uint256);
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 /**
55 *   @title AppicsICO contract  - takes funds from users and issues tokens
56 */
57 contract AppicsICO {
58     // XAP - Appics token contract
59     AppicsToken public XAP = new AppicsToken(this);
60     using SafeMath for uint256;
61     mapping (address => string) public  keys;
62 
63     // Token price parameters
64     // These parametes can be changed only by manager of contract
65     uint256 public Rate_Eth = 700; // Rate USD per ETH
66     uint256 public Tokens_Per_Dollar_Numerator = 20;// Appics token = 0.15$
67     uint256 public Tokens_Per_Dollar_Denominator = 3;// Appics token = 0.15$
68     
69     // Crowdfunding parameters
70     uint256 constant AppicsPart = 20; // 20% of TotalSupply for Appics
71     uint256 constant EcosystemPart = 20; // 20% of TotalSupply for Ecosystem
72     uint256 constant SteemitPart = 5; // 5% of TotalSupply for Steemit
73     uint256 constant BountyPart = 5; // 5% of TotalSupply for Bounty
74     uint256 constant icoPart = 50; // 50% of TotalSupply for PublicICO and PrivateOffer
75     uint256 constant PreSaleHardCap = 12500000*1e18;
76     uint256 constant RoundAHardCap = 25000000*1e18;
77     uint256 constant RoundBHardCap = 30000000*1e18;
78     uint256 constant RoundCHardCap = 30000000*1e18;
79     uint256 constant RoundDHardCap = 22500000*1e18;
80     uint256 public PreSaleSold = 0;
81     uint256 public RoundASold = 0;
82     uint256 public RoundBSold = 0;
83     uint256 public RoundCSold = 0;
84     uint256 public RoundDSold = 0;        
85     uint256 constant TENTHOUSENDLIMIT = 66666666666666666666666;
86     // Output ethereum addresses
87     address public Company;
88     address public AppicsFund;
89     address public EcosystemFund;
90     address public SteemitFund;
91     address public BountyFund;
92     address public Manager; // Manager controls contract
93     address public Controller_Address1; // First address that is used to buy tokens for other cryptos
94     address public Controller_Address2; // Second address that is used to buy tokens for other cryptos
95     address public Controller_Address3; // Third address that is used to buy tokens for other cryptos
96     address public Oracle; // Oracle address
97 
98     // Possible ICO statuses
99     enum StatusICO {
100         Created,
101         PreSaleStarted,
102         PreSalePaused,
103         PreSaleFinished,
104         RoundAStarted,
105         RoundAPaused,
106         RoundAFinished,
107         RoundBStarted,
108         RoundBPaused,
109         RoundBFinished,
110         RoundCStarted,
111         RoundCPaused,
112         RoundCFinished,
113         RoundDStarted,
114         RoundDPaused,
115         RoundDFinished
116     }
117 
118     StatusICO statusICO = StatusICO.Created;
119 
120     // Events Log
121     event LogStartPreSaleRound();
122     event LogPausePreSaleRound();
123     event LogFinishPreSaleRound(
124         address AppicsFund, 
125         address EcosystemFund,
126         address SteemitFund,
127         address BountyFund
128     );
129     event LogStartRoundA();
130     event LogPauseRoundA();
131     event LogFinishRoundA(
132         address AppicsFund, 
133         address EcosystemFund,
134         address SteemitFund,
135         address BountyFund
136     );
137     event LogStartRoundB();
138     event LogPauseRoundB();
139     event LogFinishRoundB(
140         address AppicsFund, 
141         address EcosystemFund,
142         address SteemitFund,
143         address BountyFund
144     );
145     event LogStartRoundC();
146     event LogPauseRoundC();
147     event LogFinishRoundC(
148         address AppicsFund, 
149         address EcosystemFund,
150         address SteemitFund,
151         address BountyFund
152     );
153     event LogStartRoundD();
154     event LogPauseRoundD();
155     event LogFinishRoundD(
156         address AppicsFund, 
157         address EcosystemFund,
158         address SteemitFund,
159         address BountyFund
160     );
161     event LogBuyForInvestor(address investor, uint256 aidValue, string txHash);
162     event LogRegister(address investor, string key);
163 
164     // Modifiers
165     // Allows execution by the oracle only
166     modifier oracleOnly {
167         require(msg.sender == Oracle);
168         _;
169     }
170     // Allows execution by the contract manager only
171     modifier managerOnly {
172         require(msg.sender == Manager);
173         _;
174     }
175     // Allows execution by the one of controllers only
176     modifier controllersOnly {
177         require(
178             (msg.sender == Controller_Address1) || 
179             (msg.sender == Controller_Address2) || 
180             (msg.sender == Controller_Address3)
181         );
182         _;
183     }
184     // Allows execution if the any round started only
185     modifier startedOnly {
186         require(
187             (statusICO == StatusICO.PreSaleStarted) || 
188             (statusICO == StatusICO.RoundAStarted) || 
189             (statusICO == StatusICO.RoundBStarted) ||
190             (statusICO == StatusICO.RoundCStarted) ||
191             (statusICO == StatusICO.RoundDStarted)
192         );
193         _;
194     }
195     // Allows execution if the any round finished only
196     modifier finishedOnly {
197         require(
198             (statusICO == StatusICO.PreSaleFinished) || 
199             (statusICO == StatusICO.RoundAFinished) || 
200             (statusICO == StatusICO.RoundBFinished) ||
201             (statusICO == StatusICO.RoundCFinished) ||
202             (statusICO == StatusICO.RoundDFinished)
203         );
204         _;
205     }
206 
207 
208    /**
209     *   @dev Contract constructor function
210     */
211     function AppicsICO(
212         address _Company,
213         address _AppicsFund,
214         address _EcosystemFund,
215         address _SteemitFund,
216         address _BountyFund,
217         address _Manager,
218         address _Controller_Address1,
219         address _Controller_Address2,
220         address _Controller_Address3,
221         address _Oracle
222     )
223         public {
224         Company = _Company;
225         AppicsFund = _AppicsFund;
226         EcosystemFund = _EcosystemFund;
227         SteemitFund = _SteemitFund;
228         BountyFund = _BountyFund;
229         Manager = _Manager;
230         Controller_Address1 = _Controller_Address1;
231         Controller_Address2 = _Controller_Address2;
232         Controller_Address3 = _Controller_Address3;
233         Oracle = _Oracle;
234     }
235 
236    /**
237     *   @dev Set rate of ETH and update token price
238     *   @param _RateEth       current ETH rate
239     */
240     function setRate(uint256 _RateEth) external oracleOnly {
241         Rate_Eth = _RateEth;
242     }
243 
244    /**
245     *   @dev Start Pre-Sale
246     *   Set ICO status to PreSaleStarted
247     */
248     function startPreSaleRound() external managerOnly {
249         require(statusICO == StatusICO.Created || statusICO == StatusICO.PreSalePaused);
250         statusICO = StatusICO.PreSaleStarted;
251         LogStartPreSaleRound();
252     }
253 
254    /**
255     *   @dev Pause Pre-Sale
256     *   Set Ico status to PreSalePaused
257     */
258     function pausePreSaleRound() external managerOnly {
259         require(statusICO == StatusICO.PreSaleStarted);
260         statusICO = StatusICO.PreSalePaused;
261         LogPausePreSaleRound();
262     }
263 
264 
265    /**
266     *   @dev Finish Pre-Sale and mint tokens for AppicsFund, EcosystemFund, SteemitFund,
267         RewardFund and ReferralFund
268     *   Set Ico status to PreSaleFinished
269     */
270     function finishPreSaleRound() external managerOnly {
271         require(statusICO == StatusICO.PreSaleStarted || statusICO == StatusICO.PreSalePaused);
272         uint256 totalAmount = PreSaleSold.mul(100).div(icoPart);
273         XAP.mintTokens(AppicsFund, AppicsPart.mul(totalAmount).div(100));
274         XAP.mintTokens(EcosystemFund, EcosystemPart.mul(totalAmount).div(100));
275         XAP.mintTokens(SteemitFund, SteemitPart.mul(totalAmount).div(100));
276         XAP.mintTokens(BountyFund, BountyPart.mul(totalAmount).div(100));
277         statusICO = StatusICO.PreSaleFinished;
278         LogFinishPreSaleRound(AppicsFund, EcosystemFund, SteemitFund, BountyFund);
279 
280     }
281    
282    /**
283     *   @dev Start Round A
284     *   Set ICO status to RoundAStarted
285     */
286     function startRoundA() external managerOnly {
287         require(statusICO == StatusICO.PreSaleFinished || statusICO == StatusICO.RoundAPaused);
288         statusICO = StatusICO.RoundAStarted;
289         LogStartRoundA();
290     }
291 
292    /**
293     *   @dev Pause Round A
294     *   Set Ico status to RoundAPaused
295     */
296     function pauseRoundA() external managerOnly {
297         require(statusICO == StatusICO.RoundAStarted);
298         statusICO = StatusICO.RoundAPaused;
299         LogPauseRoundA();
300     }
301 
302 
303    /**
304     *   @dev Finish Round A and mint tokens AppicsFund, EcosystemFund, SteemitFund,
305         RewardFund and ReferralFund
306     *   Set Ico status to RoundAFinished
307     */
308     function finishRoundA() external managerOnly {
309         require(statusICO == StatusICO.RoundAStarted || statusICO == StatusICO.RoundAPaused);
310         uint256 totalAmount = RoundASold.mul(100).div(icoPart);
311         XAP.mintTokens(AppicsFund, AppicsPart.mul(totalAmount).div(100));
312         XAP.mintTokens(EcosystemFund, EcosystemPart.mul(totalAmount).div(100));
313         XAP.mintTokens(SteemitFund, SteemitPart.mul(totalAmount).div(100));
314         XAP.mintTokens(BountyFund, BountyPart.mul(totalAmount).div(100));
315         statusICO = StatusICO.RoundAFinished;
316         LogFinishRoundA(AppicsFund, EcosystemFund, SteemitFund, BountyFund);
317     }
318 
319    /**
320     *   @dev Start Round B
321     *   Set ICO status to RoundBStarted
322     */
323     function startRoundB() external managerOnly {
324         require(statusICO == StatusICO.RoundAFinished || statusICO == StatusICO.RoundBPaused);
325         statusICO = StatusICO.RoundBStarted;
326         LogStartRoundB();
327     }
328 
329    /**
330     *   @dev Pause Round B
331     *   Set Ico status to RoundBPaused
332     */
333     function pauseRoundB() external managerOnly {
334         require(statusICO == StatusICO.RoundBStarted);
335         statusICO = StatusICO.RoundBPaused;
336         LogPauseRoundB();
337     }
338 
339 
340    /**
341     *   @dev Finish Round B and mint tokens AppicsFund, EcosystemFund, SteemitFund,
342         RewardFund and ReferralFund
343     *   Set Ico status to RoundBFinished
344     */
345     function finishRoundB() external managerOnly {
346         require(statusICO == StatusICO.RoundBStarted || statusICO == StatusICO.RoundBPaused);
347         uint256 totalAmount = RoundBSold.mul(100).div(icoPart);
348         XAP.mintTokens(AppicsFund, AppicsPart.mul(totalAmount).div(100));
349         XAP.mintTokens(EcosystemFund, EcosystemPart.mul(totalAmount).div(100));
350         XAP.mintTokens(SteemitFund, SteemitPart.mul(totalAmount).div(100));
351         XAP.mintTokens(BountyFund, BountyPart.mul(totalAmount).div(100));
352         statusICO = StatusICO.RoundBFinished;
353         LogFinishRoundB(AppicsFund, EcosystemFund, SteemitFund, BountyFund);
354     }
355 
356    /**
357     *   @dev Start Round C
358     *   Set ICO status to RoundCStarted
359     */
360     function startRoundC() external managerOnly {
361         require(statusICO == StatusICO.RoundBFinished || statusICO == StatusICO.RoundCPaused);
362         statusICO = StatusICO.RoundCStarted;
363         LogStartRoundC();
364     }
365 
366    /**
367     *   @dev Pause Round C
368     *   Set Ico status to RoundCPaused
369     */
370     function pauseRoundC() external managerOnly {
371         require(statusICO == StatusICO.RoundCStarted);
372         statusICO = StatusICO.RoundCPaused;
373         LogPauseRoundC();
374     }
375 
376 
377    /**
378     *   @dev Finish Round C and mint tokens AppicsFund, EcosystemFund, SteemitFund,
379         RewardFund and ReferralFund
380     *   Set Ico status to RoundCStarted
381     */
382     function finishRoundC() external managerOnly {
383         require(statusICO == StatusICO.RoundCStarted || statusICO == StatusICO.RoundCPaused);
384         uint256 totalAmount = RoundCSold.mul(100).div(icoPart);
385         XAP.mintTokens(AppicsFund, AppicsPart.mul(totalAmount).div(100));
386         XAP.mintTokens(EcosystemFund, EcosystemPart.mul(totalAmount).div(100));
387         XAP.mintTokens(SteemitFund, SteemitPart.mul(totalAmount).div(100));
388         XAP.mintTokens(BountyFund, BountyPart.mul(totalAmount).div(100));
389         statusICO = StatusICO.RoundCFinished;
390         LogFinishRoundC(AppicsFund, EcosystemFund, SteemitFund, BountyFund);
391     }
392 
393    /**
394     *   @dev Start Round D
395     *   Set ICO status to RoundDStarted
396     */
397     function startRoundD() external managerOnly {
398         require(statusICO == StatusICO.RoundCFinished || statusICO == StatusICO.RoundDPaused);
399         statusICO = StatusICO.RoundDStarted;
400         LogStartRoundD();
401     }
402 
403    /**
404     *   @dev Pause Round D
405     *   Set Ico status to RoundDPaused
406     */
407     function pauseRoundD() external managerOnly {
408         require(statusICO == StatusICO.RoundDStarted);
409         statusICO = StatusICO.RoundDPaused;
410         LogPauseRoundD();
411     }
412 
413 
414    /**
415     *   @dev Finish Round D and mint tokens AppicsFund, EcosystemFund, SteemitFund,
416         RewardFund and ReferralFund
417     *   Set Ico status to RoundDFinished
418     */
419     function finishRoundD() external managerOnly {
420         require(statusICO == StatusICO.RoundDStarted || statusICO == StatusICO.RoundDPaused);
421         uint256 totalAmount = RoundDSold.mul(100).div(icoPart);
422         XAP.mintTokens(AppicsFund, AppicsPart.mul(totalAmount).div(100));
423         XAP.mintTokens(EcosystemFund, EcosystemPart.mul(totalAmount).div(100));
424         XAP.mintTokens(SteemitFund, SteemitPart.mul(totalAmount).div(100));
425         XAP.mintTokens(BountyFund, BountyPart.mul(totalAmount).div(100));
426         statusICO = StatusICO.RoundDFinished;
427         LogFinishRoundD(AppicsFund, EcosystemFund, SteemitFund, BountyFund);
428     }    
429 
430 
431    /**
432     *   @dev Enable token transfers
433     */
434     function unfreeze() external managerOnly {
435         XAP.defrostTokens();
436     }
437 
438    /**
439     *   @dev Disable token transfers
440     */
441     function freeze() external managerOnly {
442         XAP.frostTokens();
443     }
444 
445    /**
446     *   @dev Fallback function calls buyTokens() function to buy tokens
447     *        when investor sends ETH to address of ICO contract
448     */
449     function() external payable {
450         uint256 tokens; 
451         tokens = msg.value.mul(Tokens_Per_Dollar_Numerator).mul(Rate_Eth);
452         // rounding tokens amount:
453         tokens = tokens.div(Tokens_Per_Dollar_Denominator);
454         buyTokens(msg.sender, tokens);
455     }
456 
457    /**
458     *   @dev Issues tokens for users who made purchases in other cryptocurrencies
459     *   @param _investor     address the tokens will be issued to
460     *   @param _xapValue     number of Appics tokens
461     *   @param _txHash       transaction hash of investor's payment
462     */
463     function buyForInvestor(
464         address _investor,
465         uint256 _xapValue,
466         string _txHash
467     )
468         external
469         controllersOnly
470         startedOnly {
471         buyTokens(_investor, _xapValue);        
472         LogBuyForInvestor(_investor, _xapValue, _txHash);
473     }
474 
475 
476    /**
477     *   @dev Issue tokens for investors who paid in ether
478     *   @param _investor     address which the tokens will be issued to
479     *   @param _xapValue     number of Appics tokens
480     */
481     function buyTokens(address _investor, uint256 _xapValue) internal startedOnly {
482         require(_xapValue > 0);
483         uint256 bonus = getBonus(_xapValue);
484         uint256 total = _xapValue.add(bonus);
485         if (statusICO == StatusICO.PreSaleStarted) {
486             require (PreSaleSold.add(total) <= PreSaleHardCap);
487             require(_xapValue > TENTHOUSENDLIMIT);
488             PreSaleSold = PreSaleSold.add(total);
489         }
490         if (statusICO == StatusICO.RoundAStarted) {
491             require (RoundASold.add(total) <= RoundAHardCap);
492             RoundASold = RoundASold.add(total);
493         }
494         if (statusICO == StatusICO.RoundBStarted) {
495             require (RoundBSold.add(total) <= RoundBHardCap);
496             RoundBSold = RoundBSold.add(total);
497         }
498         if (statusICO == StatusICO.RoundCStarted) {
499             require (RoundCSold.add(total) <= RoundCHardCap);
500             RoundCSold = RoundCSold.add(total);
501         }
502         if (statusICO == StatusICO.RoundDStarted) {
503             require (RoundDSold.add(total) <= RoundDHardCap);
504             RoundDSold = RoundDSold.add(total);
505         }
506         XAP.mintTokens(_investor, total);
507     }
508 
509    /**
510     *   @dev Calculates bonus
511     *   @param _value        amount of tokens
512     *   @return              bonus value
513     */
514     function getBonus(uint256 _value)
515         public
516         constant
517         returns(uint256)
518     {
519         uint256 bonus = 0;
520         if (statusICO == StatusICO.PreSaleStarted) {
521             bonus = _value.mul(20).div(100);
522         }
523         if (statusICO == StatusICO.RoundAStarted) {
524             bonus = _value.mul(15).div(100); 
525         }
526         if (statusICO == StatusICO.RoundBStarted) {
527             bonus = _value.mul(10).div(100); 
528         }
529         if (statusICO == StatusICO.RoundCStarted) {
530             bonus = _value.mul(5).div(100); 
531         }
532         return bonus;
533     }
534     
535     function register(string _key) public {
536         keys[msg.sender] = _key;
537         LogRegister(msg.sender, _key);
538     }
539 
540 
541    /**
542     *   @dev Allows Company withdraw investments when round is over
543     */
544     function withdrawEther() external managerOnly finishedOnly{
545         Company.transfer(this.balance);
546     }
547 
548 }
549 
550 
551 /**
552  *   @title 
553  *   @dev Appics token contract
554  */
555 contract AppicsToken is ERC20 {
556     using SafeMath for uint256;
557     string public name = "Appics";
558     string public symbol = "XAP";
559     uint256 public decimals = 18;
560 
561     // Ico contract address
562     address public ico;
563     event Burn(address indexed from, uint256 value);
564 
565     // Disables/enables token transfers
566     bool public tokensAreFrozen = true;
567 
568     // Allows execution by the ico only
569     modifier icoOnly {
570         require(msg.sender == ico);
571         _;
572     }
573 
574    /**
575     *   @dev Contract constructor function sets Ico address
576     *   @param _ico          ico address
577     */
578     function AppicsToken(address _ico) public {
579         ico = _ico;
580     }
581 
582    /**
583     *   @dev Mint tokens
584     *   @param _holder       beneficiary address the tokens will be issued to
585     *   @param _value        number of tokens to issue
586     */
587     function mintTokens(address _holder, uint256 _value) external icoOnly {
588         require(_value > 0);
589         balances[_holder] = balances[_holder].add(_value);
590         totalSupply = totalSupply.add(_value);
591         Transfer(0x0, _holder, _value);
592     }
593 
594    /**
595     *   @dev Enables token transfers
596     */
597     function defrostTokens() external icoOnly {
598       tokensAreFrozen = false;
599     }
600 
601     /**
602     *   @dev Disables token transfers
603     */
604     function frostTokens() external icoOnly {
605       tokensAreFrozen = true;
606     }
607 
608    /**
609     *   @dev Burn Tokens
610     *   @param _investor     token holder address which the tokens will be burnt
611     *   @param _value        number of tokens to burn
612     */
613     function burnTokens(address _investor, uint256 _value) external icoOnly {
614         require(balances[_investor] > 0);
615         totalSupply = totalSupply.sub(_value);
616         balances[_investor] = balances[_investor].sub(_value);
617         Burn(_investor, _value);
618     }
619 
620    /**
621     *   @dev Get balance of investor
622     *   @param _owner        investor's address
623     *   @return              balance of investor
624     */
625     function balanceOf(address _owner) public constant returns(uint256) {
626       return balances[_owner];
627     }
628 
629    /**
630     *   @dev Send coins
631     *   throws on any error rather then return a false flag to minimize
632     *   user errors
633     *   @param _to           target address
634     *   @param _amount       transfer amount
635     *
636     *   @return true if the transfer was successful
637     */
638     function transfer(address _to, uint256 _amount) public returns(bool) {
639         require(!tokensAreFrozen);
640         balances[msg.sender] = balances[msg.sender].sub(_amount);
641         balances[_to] = balances[_to].add(_amount);
642         Transfer(msg.sender, _to, _amount);
643         return true;
644     }
645 
646    /**
647     *   @dev An account/contract attempts to get the coins
648     *   throws on any error rather then return a false flag to minimize user errors
649     *
650     *   @param _from         source address
651     *   @param _to           target address
652     *   @param _amount       transfer amount
653     *
654     *   @return true if the transfer was successful
655     */
656     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool) {
657         require(!tokensAreFrozen);
658         balances[_from] = balances[_from].sub(_amount);
659         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
660         balances[_to] = balances[_to].add(_amount);
661         Transfer(_from, _to, _amount);
662         return true;
663     }
664 
665    /**
666     *   @dev Allows another account/contract to spend some tokens on its behalf
667     *   throws on any error rather then return a false flag to minimize user errors
668     *
669     *   also, to minimize the risk of the approve/transferFrom attack vector
670     *   approve has to be called twice in 2 separate transactions - once to
671     *   change the allowance to 0 and secondly to change it to the new allowance
672     *   value
673     *
674     *   @param _spender      approved address
675     *   @param _amount       allowance amount
676     *
677     *   @return true if the approval was successful
678     */
679     function approve(address _spender, uint256 _amount) public returns(bool) {
680         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
681         allowed[msg.sender][_spender] = _amount;
682         Approval(msg.sender, _spender, _amount);
683         return true;
684     }
685 
686    /**
687     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
688     *
689     *   @param _owner        the address which owns the funds
690     *   @param _spender      the address which will spend the funds
691     *
692     *   @return              the amount of tokens still avaible for the spender
693     */
694     function allowance(address _owner, address _spender) public constant returns(uint256) {
695         return allowed[_owner][_spender];
696     }
697 }