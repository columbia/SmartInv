1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-06
3 */
4 
5 pragma solidity ^0.6.0;
6 
7 contract UniversalFinance {
8    
9    /**
10    * using safemath for uint256
11     */
12      using SafeMath for uint256;
13 
14    
15 
16     event onWithdraw(
17         address indexed customerAddress,
18         uint256 ethereumWithdrawn
19     );
20    
21     /**
22     events for transfer
23      */
24 
25     event Transfer(
26         address indexed from,
27         address indexed to,
28         uint256 tokens
29     );
30 
31     /**
32     * Approved Events
33      */
34 
35     event Approved(
36         address indexed spender,
37         address indexed recipient,
38         uint256 tokens
39     );
40 
41     /**
42     * buy Event
43      */
44 
45      event Buy(
46          address buyer,
47          uint256 tokensTransfered
48      );
49    
50    /**
51     * sell Event
52      */
53 
54      event Sell(
55          address seller,
56          uint256 calculatedEtherTransfer
57      );
58      
59      event Reward(
60        address indexed to,
61        uint256 rewardAmount,
62        uint256 level
63     );
64 
65    /** configurable variables
66    *  name it should be decided on constructor
67     */
68     string public tokenName;
69 
70     /** configurable variables
71    *  symbol it should be decided on constructor
72     */
73 
74     string public tokenSymbol;
75    
76     /** configurable variables
77    *  decimal it should be decided on constructor
78     */
79 
80     uint8 internal decimal;
81 
82     /** configurable variables
83  
84    
85     /**
86     * owner address
87      */
88 
89      address public owner;
90 
91      /**
92      current price
93       */
94     uint256 internal ethDecimal = 1000000000000000000;
95     uint256 public currentPrice;
96     uint256 public initialPrice = 10000000000000;
97     uint256 public initialPriceIncrement = 0;
98     uint256 public basePrice = 400;
99     /**
100     totalSupply
101      */
102 
103     uint256 public _totalSupply;
104    
105     uint256 public _circulatedSupply = 0;
106     uint256 public basePrice1 = 10000000000000;
107     uint256 public basePrice2 = 250000000000000;
108     uint256 public basePrice3 = 450000000000000;
109     uint256 public basePrice4 = 800000000000000;
110     uint256 public basePrice5 = 1375000000000000;
111     uint256 public basePrice6 = 2750000000000000;
112     uint256 public basePrice7 = 4500000000000000;
113     uint256 public basePrice8 = 8250000000000000;
114     uint256 public basePrice9 = 13250000000000000;
115     uint256 public basePrice10 = 20500000000000000;
116     uint256 public basePrice11 = 32750000000000000;
117     uint256 public basePrice12 = 56250000000000000;
118     uint256 public basePrice13 = 103750000000000000;
119     uint256 public basePrice14 = 179750000000000000;
120     uint256 public basePrice15 = 298350000000000000;
121     uint256 public basePrice16 = 533350000000000000;
122     uint256 public basePrice17 = 996250000000000000;
123     uint256 public basePrice18 = 1780750000000000000;
124     uint256 public basePrice19 = 2983350000000000000;
125     uint256 public basePrice20 = 5108000000000000000;
126     uint256 public basePrice21 = 8930500000000000000;
127     uint256 public basePrice22 = 15136500000000000000;
128    
129    
130        
131          
132 
133    mapping(address => uint256) private tokenBalances;
134    mapping(address => uint256) private allTimeTokenBal;
135 
136 //   mapping (address => mapping (address => uint256 )) private _allowances;
137    mapping(address => address) public genTree;
138 //   mapping(address => uint256) internal rewardBalanceLedger_;
139 //   mapping (address => mapping (uint256 => uint256 )) private levelCommission;
140 
141     /**
142     modifier for checking onlyOwner
143      */
144 
145      modifier onlyOwner() {
146          require(msg.sender == owner,"Caller is not the owner");
147          _;
148      }
149 
150     constructor(string memory _tokenName, string  memory _tokenSymbol, uint256 totalSupply) public
151     {
152         //sonk = msg.sender;
153        
154         /**
155         * set owner value msg.sender
156          */
157         owner = msg.sender;
158 
159         /**
160         * set name for contract
161          */
162 
163          tokenName = _tokenName;
164 
165          /**
166         * set symbol for contract
167          */
168 
169         /**
170         * set decimals
171          */
172 
173          decimal = 0;
174 
175          /**
176          set tokenSymbol
177           */
178 
179         tokenSymbol =  _tokenSymbol;
180 
181          /**
182          set Current Price
183           */
184 
185           currentPrice = initialPrice + initialPriceIncrement;
186 
187          
188           _totalSupply = totalSupply;
189           //_mint(owner,_totalSupply);
190 
191        
192     }
193    
194     function geAllTimeTokenBalane(address _hodl) external view returns(uint256) {
195             return allTimeTokenBal[_hodl];
196      }
197    
198     /*function getRewardBalane(address _hodl) external view returns(uint256) {
199             return rewardBalanceLedger_[_hodl];
200      }*/
201    
202    function taxDeduction(uint256 incomingEther) public pure returns(uint256)  {
203          
204         uint256 deduction = incomingEther * 22500/100000;
205         return deduction;
206          
207     }
208    
209     function getTaxedEther(uint256 incomingEther) public pure returns(uint256)  {
210          
211         uint256 deduction = incomingEther * 22500/100000;
212         uint256 taxedEther = incomingEther - deduction;
213         return taxedEther;
214          
215     }
216    
217    function etherToToken(uint256 incomingEther) public view returns(uint256)  {
218          
219         uint256 deduction = incomingEther * 22500/100000;
220         uint256 taxedEther = incomingEther - deduction;
221         uint256 tokenToTransfer = taxedEther.div(currentPrice);
222         return tokenToTransfer;
223          
224     }
225    
226    
227     function tokenToEther(uint256 tokenToSell) public view returns(uint256)  {
228          
229         uint256 convertedEther = tokenToSell * (currentPrice - (currentPrice/100));
230         return convertedEther;
231          
232     }
233    
234    
235     function transferEther(address payable receiver,uint256 _value) external onlyOwner returns (bool) {
236         require(msg.sender == owner, 'You are not owner');
237         receiver.transfer(_value);
238         return true;
239      }
240      
241      
242     /**
243     get TokenName
244      */
245     function name() public view returns(string memory) {
246         return tokenName;
247     }
248 
249     /**
250     get symbol
251      */
252 
253      function symbol() public view returns(string memory) {
254          return tokenSymbol;
255      }
256 
257      /**
258      get decimals
259       */
260 
261       function decimals() public view returns(uint8){
262             return decimal;
263       }
264      
265       /**
266       getTotalsupply of contract
267        */
268 
269     function totalSupply() external view returns(uint256) {
270             return _totalSupply;
271     }
272 
273     /**
274     * balance of of token hodl.
275      */
276 
277      function balanceOf(address _hodl) external view returns(uint256) {
278             return tokenBalances[_hodl];
279      }
280 
281     /**
282     get current price
283      */
284 
285      function getCurrentPrice() external view returns(uint256) {
286          return currentPrice;
287      }
288 
289      /**
290      * update current price
291      * notice this is only done by owner  
292       */
293 
294       function updateCurrentPrice(uint256 _newPrice) external onlyOwner returns (bool) {
295           currentPrice = _newPrice;
296           return true;
297       }
298       
299      
300      
301      /*function contractAddress() public view returns(address) {
302          return address(this);
303      }*/
304 
305      /* function levelWiseBalance(address _hodl, uint256 level) external view returns (uint256) {
306         return levelCommission[_hodl][level];
307       }*/
308       /**
309       buy Tokens from Ethereum.
310        */
311 
312      function buy(address _referredBy) external payable returns (bool) {
313          require(_referredBy != msg.sender, "Self reference not allowed");
314         /* if(_referredBy == msg.sender){
315              return false;
316          }else{
317          if(tokenBalances[msg.sender] > 5000){
318              return false;
319          }
320          else{*/
321          address buyer = msg.sender;
322          uint256 etherValue = msg.value;
323          uint256 circulation = etherValue.div(currentPrice);
324          uint256 taxedTokenAmount = taxedTokenTransfer(etherValue);
325          require(taxedTokenAmount > 0, "Can not buy 0 tokens.");
326          require(taxedTokenAmount <= 5000, "Maximum Buying Reached.");
327          require(taxedTokenAmount.add(allTimeTokenBal[msg.sender]) <= 5000, "Maximum Buying Reached.");
328          genTree[msg.sender] = _referredBy;
329          _mint(buyer,taxedTokenAmount,circulation);
330          emit Buy(buyer,taxedTokenAmount);
331          return true;
332          /*}
333          }*/
334      }
335      
336      receive() external payable {
337          require((allTimeTokenBal[msg.sender] + msg.value) <= 5000, "Maximum Buying Reached.");
338          genTree[msg.sender] = address(0);
339          address buyer = msg.sender;
340          uint256 etherValue = msg.value;
341          uint256 actualTokenQty = etherValue.div(currentPrice);
342          uint256 calculatedTokens = taxedTokenTransfer(etherValue);
343          require(calculatedTokens <= 5000, "Maximum Buying Reached.");
344          _mint(buyer,calculatedTokens,actualTokenQty);
345          emit Buy(buyer,calculatedTokens);
346          
347      }
348      
349      function priceAlgoBuy(uint256 tokenQty) internal{
350          if(_circulatedSupply >= 0 && _circulatedSupply <= 600000){
351              currentPrice = basePrice1;
352              basePrice1 = currentPrice;
353          }
354          if(_circulatedSupply > 600000 && _circulatedSupply <= 1100000){
355              initialPriceIncrement = tokenQty*300000000;
356              currentPrice = basePrice2 + initialPriceIncrement;
357              basePrice2 = currentPrice;
358          }
359          if(_circulatedSupply > 1100000 && _circulatedSupply <= 1550000){
360              initialPriceIncrement = tokenQty*450000000;
361              currentPrice = basePrice3 + initialPriceIncrement;
362              basePrice3 = currentPrice;
363          }
364          if(_circulatedSupply > 1550000 && _circulatedSupply <= 1960000){
365              initialPriceIncrement = tokenQty*675000000;
366              currentPrice = basePrice4 + initialPriceIncrement;
367              basePrice4 = currentPrice;
368          }if(_circulatedSupply > 1960000 && _circulatedSupply <= 2310000){
369              initialPriceIncrement = tokenQty*2350000000;
370              currentPrice = basePrice5 + initialPriceIncrement;
371              basePrice5 = currentPrice;
372          }
373          if(_circulatedSupply > 2310000 && _circulatedSupply <= 2640000){
374              initialPriceIncrement = tokenQty*3025000000;
375              currentPrice = basePrice6 + initialPriceIncrement;
376              basePrice6 = currentPrice;
377          }
378          if(_circulatedSupply > 2640000 && _circulatedSupply <= 2950000){
379              initialPriceIncrement = tokenQty*5725000000;
380              currentPrice = basePrice7 + initialPriceIncrement;
381              basePrice7 = currentPrice;
382          }
383          if(_circulatedSupply > 2950000 && _circulatedSupply <= 3240000){
384              initialPriceIncrement = tokenQty*8525000000;
385              currentPrice = basePrice8 + initialPriceIncrement;
386              basePrice8 = currentPrice;
387          }
388          
389          if(_circulatedSupply > 3240000 && _circulatedSupply <= 3510000){
390              initialPriceIncrement = tokenQty*13900000000;
391              currentPrice = basePrice9 + initialPriceIncrement;
392              basePrice9 = currentPrice;
393              
394          }if(_circulatedSupply > 3510000 && _circulatedSupply <= 3770000){
395              initialPriceIncrement = tokenQty*20200000000;
396              currentPrice = basePrice10 + initialPriceIncrement;
397              basePrice10 = currentPrice;
398              
399          }if(_circulatedSupply > 3770000 && _circulatedSupply <= 4020000){
400              initialPriceIncrement = tokenQty*50000000000;
401              currentPrice = basePrice11 + initialPriceIncrement;
402              basePrice11 = currentPrice;
403              
404          }if(_circulatedSupply > 4020000 && _circulatedSupply <= 4260000){
405              initialPriceIncrement = tokenQty*133325000000;
406              currentPrice = basePrice12 + initialPriceIncrement;
407              basePrice12 = currentPrice;
408              
409          }if(_circulatedSupply > 4260000 && _circulatedSupply <= 4490000){
410              initialPriceIncrement = tokenQty*239125000000;
411              currentPrice = basePrice13 + initialPriceIncrement;
412              basePrice13 = currentPrice;
413              
414          }
415          if(_circulatedSupply > 4490000 && _circulatedSupply <= 4700000){
416              initialPriceIncrement = tokenQty*394050000000;
417              currentPrice = basePrice14 + initialPriceIncrement;
418              basePrice14 = currentPrice;
419              
420          }
421          if(_circulatedSupply > 4700000 && _circulatedSupply <= 4900000){
422              initialPriceIncrement = tokenQty*689500000000;
423              currentPrice = basePrice15 + initialPriceIncrement;
424              basePrice15 = currentPrice;
425              
426          }
427          if(_circulatedSupply > 4900000 && _circulatedSupply <= 5080000){
428              initialPriceIncrement = tokenQty*1465275000000;
429              currentPrice = basePrice16 + initialPriceIncrement;
430              basePrice16 = currentPrice;
431              
432          }
433          
434           if(_circulatedSupply > 5080000 && _circulatedSupply <= 5220000){
435              initialPriceIncrement = tokenQty*3158925000000;
436              currentPrice = basePrice17 + initialPriceIncrement;
437              basePrice17 = currentPrice;
438              
439          }
440          
441           if(_circulatedSupply > 5220000 && _circulatedSupply <= 5350000){
442              initialPriceIncrement = tokenQty*5726925000000;
443              currentPrice = basePrice18 + initialPriceIncrement;
444              basePrice18 = currentPrice;
445              
446          }
447          
448           if(_circulatedSupply > 5350000 && _circulatedSupply <= 5460000){
449              initialPriceIncrement = tokenQty*13108175000000;
450              currentPrice = basePrice19 + initialPriceIncrement;
451              basePrice19 = currentPrice;
452              
453          }
454          
455           if(_circulatedSupply > 5460000 && _circulatedSupply <= 5540000){
456              initialPriceIncrement = tokenQty*34687500000000;
457              currentPrice = basePrice20 + initialPriceIncrement;
458              basePrice20 = currentPrice;
459              
460          }
461          if(_circulatedSupply > 5540000 && _circulatedSupply <= 5580000){
462              initialPriceIncrement = tokenQty*120043750000000;
463              currentPrice = basePrice21 + initialPriceIncrement;
464              basePrice21 = currentPrice;
465              
466          }
467          if(_circulatedSupply > 5580000 && _circulatedSupply <= 5600000){
468              initialPriceIncrement = tokenQty*404100000000000;
469              currentPrice = basePrice22 + initialPriceIncrement;
470              basePrice22 = currentPrice;
471          }
472      }
473      
474      
475       function priceAlgoSell(uint256 tokenQty) internal{
476          if(_circulatedSupply >= 0 && _circulatedSupply < 600000){
477              initialPriceIncrement = tokenQty*300000;
478              currentPrice = basePrice1 - initialPriceIncrement;
479              basePrice1 = currentPrice;
480          }
481          if(_circulatedSupply >= 600000 && _circulatedSupply <= 1100000){
482              initialPriceIncrement = tokenQty*300000000;
483              currentPrice = basePrice2 - initialPriceIncrement;
484              basePrice2 = currentPrice;
485          }
486          if(_circulatedSupply > 1100000 && _circulatedSupply <= 1550000){
487              initialPriceIncrement = tokenQty*450000000;
488              currentPrice = basePrice3 - initialPriceIncrement;
489              basePrice3 = currentPrice;
490          }
491          if(_circulatedSupply > 1550000 && _circulatedSupply <= 1960000){
492              initialPriceIncrement = tokenQty*675000000;
493              currentPrice = basePrice4 - initialPriceIncrement;
494              basePrice4 = currentPrice;
495          }if(_circulatedSupply > 1960000 && _circulatedSupply <= 2310000){
496              initialPriceIncrement = tokenQty*2350000000;
497              currentPrice = basePrice5 - initialPriceIncrement;
498              basePrice5 = currentPrice;
499          }
500          if(_circulatedSupply > 2310000 && _circulatedSupply <= 2640000){
501              initialPriceIncrement = tokenQty*3025000000;
502              currentPrice = basePrice6 - initialPriceIncrement;
503              basePrice6 = currentPrice;
504          }
505          if(_circulatedSupply > 2640000 && _circulatedSupply <= 2950000){
506              initialPriceIncrement = tokenQty*5725000000;
507              currentPrice = basePrice7 - initialPriceIncrement;
508              basePrice7 = currentPrice;
509          }
510          if(_circulatedSupply > 2950000 && _circulatedSupply <= 3240000){
511              initialPriceIncrement = tokenQty*8525000000;
512              currentPrice = basePrice8 - initialPriceIncrement;
513              basePrice8 = currentPrice;
514          }
515          
516          if(_circulatedSupply > 3240000 && _circulatedSupply <= 3510000){
517              initialPriceIncrement = tokenQty*13900000000;
518              currentPrice = basePrice9 - initialPriceIncrement;
519              basePrice9 = currentPrice;
520              
521          }if(_circulatedSupply > 3510000 && _circulatedSupply <= 3770000){
522              initialPriceIncrement = tokenQty*20200000000;
523              currentPrice = basePrice10 - initialPriceIncrement;
524              basePrice10 = currentPrice;
525              
526          }if(_circulatedSupply > 3770000 && _circulatedSupply <= 4020000){
527              initialPriceIncrement = tokenQty*50000000000;
528              currentPrice = basePrice11 - initialPriceIncrement;
529              basePrice11 = currentPrice;
530              
531          }if(_circulatedSupply > 4020000 && _circulatedSupply <= 4260000){
532              initialPriceIncrement = tokenQty*133325000000;
533              currentPrice = basePrice12 - initialPriceIncrement;
534              basePrice12 = currentPrice;
535              
536          }if(_circulatedSupply > 4260000 && _circulatedSupply <= 4490000){
537              initialPriceIncrement = tokenQty*239125000000;
538              currentPrice = basePrice13 - initialPriceIncrement;
539              basePrice13 = currentPrice;
540              
541          }
542          if(_circulatedSupply > 4490000 && _circulatedSupply <= 4700000){
543              initialPriceIncrement = tokenQty*394050000000;
544              currentPrice = basePrice14 - initialPriceIncrement;
545              basePrice14 = currentPrice;
546              
547          }
548          if(_circulatedSupply > 4700000 && _circulatedSupply <= 4900000){
549              initialPriceIncrement = tokenQty*689500000000;
550              currentPrice = basePrice15 - initialPriceIncrement;
551              basePrice15 = currentPrice;
552              
553          }
554          if(_circulatedSupply > 4900000 && _circulatedSupply <= 5080000){
555              initialPriceIncrement = tokenQty*1465275000000;
556              currentPrice = basePrice16 - initialPriceIncrement;
557              basePrice16 = currentPrice;
558              
559          }
560          
561           if(_circulatedSupply > 5080000 && _circulatedSupply <= 5220000){
562              initialPriceIncrement = tokenQty*3158925000000;
563              currentPrice = basePrice17 - initialPriceIncrement;
564              basePrice17 = currentPrice;
565              
566          }
567          
568           if(_circulatedSupply > 5220000 && _circulatedSupply <= 5350000){
569              initialPriceIncrement = tokenQty*5726925000000;
570              currentPrice = basePrice18 - initialPriceIncrement;
571              basePrice18 = currentPrice;
572              
573          }
574          
575           if(_circulatedSupply > 5350000 && _circulatedSupply <= 5460000){
576              initialPriceIncrement = tokenQty*13108175000000;
577              currentPrice = basePrice19 - initialPriceIncrement;
578              basePrice19 = currentPrice;
579              
580          }
581          
582           if(_circulatedSupply > 5460000 && _circulatedSupply <= 5540000){
583              initialPriceIncrement = tokenQty*34687500000000;
584              currentPrice = basePrice20 - initialPriceIncrement;
585              basePrice20 = currentPrice;
586              
587          }
588          if(_circulatedSupply > 5540000 && _circulatedSupply <= 5580000){
589              initialPriceIncrement = tokenQty*120043750000000;
590              currentPrice = basePrice21 - initialPriceIncrement;
591              basePrice21 = currentPrice;
592              
593          }
594          if(_circulatedSupply > 5580000 && _circulatedSupply <= 5600000){
595              initialPriceIncrement = tokenQty*404100000000000;
596              currentPrice = basePrice22 - initialPriceIncrement;
597              basePrice22 = currentPrice;
598          }
599      }
600      
601      
602    /* function distributeRewards(uint256 _amountToDistribute, address _idToDistribute)
603     internal
604     {
605        
606         for(uint256 i=0; i<15; i++)
607         {
608             address referrer = genTree[_idToDistribute];
609             uint256 holdingAmount = ((currentPrice/ethDecimal) * basePrice) *tokenBalances[referrer];
610             if(referrer != address(0))
611             {
612                 if(i == 0 && holdingAmount>=100){
613                     rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[0]/10000);
614                     levelCommission[referrer][i+1].add(_amountToDistribute*percent_[0]/10000);
615                 }else if((i == 1) && holdingAmount>=200){
616                     rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[1]/10000);
617                     levelCommission[referrer][i+1].add(_amountToDistribute*percent_[1]/10000);
618                 }else if((i == 2) && holdingAmount>=200){
619                     rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[2]/10000);
620                     levelCommission[referrer][i+1].add(_amountToDistribute*percent_[2]/10000);
621                 }else if((i == 3) && holdingAmount>=300){
622                     rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[3]/10000);
623                     levelCommission[referrer][i+1].add(_amountToDistribute*percent_[3]/10000);
624                 }else if((i >= 4 && i<= 9) && holdingAmount>=300){
625                     rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[4]/10000);
626                     levelCommission[referrer][i+1].add(_amountToDistribute*percent_[4]/10000);
627                 }else if((i >= 10 && i<= 12) && holdingAmount>=400){
628                     rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[5]/10000);
629                     levelCommission[referrer][i+1].add(_amountToDistribute*percent_[5]/10000);
630                 }else if((i >= 13 && i<15) && holdingAmount>=500){
631                     rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[6]/10000);
632                     levelCommission[referrer][i+1].add(_amountToDistribute*percent_[6]/10000);
633                 }else{
634                    
635                 }
636                
637                 _idToDistribute = referrer;
638                 //emit Reward(referrer,(_amountToDistribute*_amountToDistribute[i]*100)/10,i);
639             }else{
640                
641             }
642         }
643        
644     }*/
645 
646     /**
647     calculation logic for buy function
648      */
649 
650      function taxedTokenTransfer(uint256 incomingEther) internal view returns(uint256) {
651             uint256 deduction = incomingEther * 22500/100000;
652             uint256 taxedEther = incomingEther - deduction;
653             uint256 tokenToTransfer = taxedEther.div(currentPrice);
654             return tokenToTransfer;
655      }
656 
657      /**
658      * sell method for ether.
659       */
660 
661      function sell(uint256 tokenToSell) external returns(bool){
662           require(_circulatedSupply > 0, "no circulated tokens");
663           require(tokenToSell > 0, "can not sell 0 token");
664           require(tokenToSell <= tokenBalances[msg.sender], "not enough tokens to transact");
665           require(tokenToSell.add(_circulatedSupply) <= _totalSupply, "exceeded total supply");
666           uint256 convertedEthers = etherValueTransfer(tokenToSell);
667           msg.sender.transfer(convertedEthers);
668           _burn(msg.sender,tokenToSell);
669           emit Sell(msg.sender,convertedEthers);
670           return true;
671      }
672      
673      
674      
675 
676      function etherValueTransfer(uint256 tokenToSell) internal view returns(uint256) {
677          uint256 convertedEther = tokenToSell * (currentPrice - currentPrice/100);
678         return convertedEther;
679      }
680 
681 
682     function accumulatedEther() external onlyOwner view returns (uint256) {
683         return address(this).balance;
684     }
685    
686     /**
687      * @dev Moves tokens `amount` from `sender` to `recipient`.
688      *
689      * This is internal function is equivalent to {transfer}, and can be used to
690      * e.g. implement automatic token fees, slashing mechanisms, etc.
691      *
692      * Emits a {Transfer} event.
693      *
694      * Requirements:
695      *
696      * - `sender` cannot be the zero address.
697      * - `recipient` cannot be the zero address.
698      * - `sender` must have a balance of at least `amount`.
699      */
700 
701     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
702         require(sender != address(0), "ERC20: transfer from the zero address");
703         require(recipient != address(0), "ERC20: transfer to the zero address");
704         emit Transfer(sender, recipient, amount);
705         tokenBalances[sender] = tokenBalances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
706         tokenBalances[recipient] = tokenBalances[recipient].add(amount);
707     }
708 
709    
710      /*function _approve(address spender, address recipient, uint256 amount) internal virtual {
711         require(owner != address(0), "ERC20: approve from the zero address");
712         require(spender != address(0), "ERC20: approve to the zero address");
713         _allowances[spender][recipient] = amount;
714         emit Approved(spender, recipient, amount);
715     }*/
716 
717 
718     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
719      * the total supply.
720      *
721      * Emits a {Transfer} event with `from` set to the zero address.
722      *
723      * Requirements
724      *
725      * - `to` cannot be the zero address.
726      */
727 
728     function _mint(address account, uint256 amount, uint256 circulation) internal  {
729         require(account != address(0), "ERC20: mint to the zero address");
730        /* if(account == owner){
731             emit Transfer(address(0), account, amount);
732             tokenBalances[owner] = tokenBalances[owner].add(amount);
733         }else{*/
734             emit Transfer(address(this), account, amount);
735             tokenBalances[account] = tokenBalances[account].add(amount);
736             allTimeTokenBal[account] = allTimeTokenBal[account].add(amount);
737             _circulatedSupply = _circulatedSupply.add(circulation);
738             priceAlgoBuy(circulation);
739         /*}*/
740        
741     }
742 
743     /**
744      * @dev Destroys `amount` tokens from `account`, reducing the
745      * total supply.
746      *
747      * Emits a {Transfer} event with `to` set to the zero address.
748      *
749      * Requirements
750      *
751      * - `account` cannot be the zero address.
752      * - `account` must have at least `amount` tokens.
753      */
754 
755     function _burn(address account, uint256 amount) internal {
756         require(account != address(0), "ERC20: burn from the zero address");
757         emit Transfer(account, address(this), amount);
758         tokenBalances[account] = tokenBalances[account].sub(amount);
759         //tokenBalances[owner] = tokenBalances[owner].add(amount);
760         _circulatedSupply = _circulatedSupply.sub(amount);
761         allTimeTokenBal[account] = allTimeTokenBal[account].sub(amount);
762         priceAlgoSell(amount);
763     }
764 
765     function _msgSender() internal view returns (address ){
766         return msg.sender;
767     }
768  
769 }
770 
771 
772 library SafeMath {
773     /**
774      * @dev Returns the addition of two unsigned integers, reverting on
775      * overflow.
776      *
777      * Counterpart to Solidity's `+` operator.
778      *
779      * Requirements:
780      *
781      * - Addition cannot overflow.
782      */
783     function add(uint256 a, uint256 b) internal pure returns (uint256) {
784         uint256 c = a + b;
785         require(c >= a, "SafeMath: addition overflow");
786 
787         return c;
788     }
789 
790     /**
791      * @dev Returns the subtraction of two unsigned integers, reverting on
792      * overflow (when the result is negative).
793      *
794      * Counterpart to Solidity's `-` operator.
795      *
796      * Requirements:
797      *
798      * - Subtraction cannot overflow.
799      */
800     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
801         return sub(a, b, "SafeMath: subtraction overflow");
802     }
803 
804     /**
805      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
806      * overflow (when the result is negative).
807      *
808      * Counterpart to Solidity's `-` operator.
809      *
810      * Requirements:
811      *
812      * - Subtraction cannot overflow.
813      */
814     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
815         require(b <= a, errorMessage);
816         uint256 c = a - b;
817 
818         return c;
819     }
820 
821     /**
822      * @dev Returns the multiplication of two unsigned integers, reverting on
823      * overflow.
824      *
825      * Counterpart to Solidity's `*` operator.
826      *
827      * Requirements:
828      *
829      * - Multiplication cannot overflow.
830      */
831     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
832         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
833         // benefit is lost if 'b' is also tested.
834         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
835         if (a == 0) {
836             return 0;
837         }
838 
839         uint256 c = a * b;
840         require(c / a == b, "SafeMath: multiplication overflow");
841 
842         return c;
843     }
844 
845     /**
846      * @dev Returns the integer division of two unsigned integers. Reverts on
847      * division by zero. The result is rounded towards zero.
848      *
849      * Counterpart to Solidity's `/` operator. Note: this function uses a
850      * `revert` opcode (which leaves remaining gas untouched) while Solidity
851      * uses an invalid opcode to revert (consuming all remaining gas).
852      *
853      * Requirements:
854      *
855      * - The divisor cannot be zero.
856      */
857     function div(uint256 a, uint256 b) internal pure returns (uint256) {
858         return div(a, b, "SafeMath: division by zero");
859     }
860 
861     /**
862      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
863      * division by zero. The result is rounded towards zero.
864      *
865      * Counterpart to Solidity's `/` operator. Note: this function uses a
866      * `revert` opcode (which leaves remaining gas untouched) while Solidity
867      * uses an invalid opcode to revert (consuming all remaining gas).
868      *
869      * Requirements:
870      *
871      * - The divisor cannot be zero.
872      */
873     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
874         require(b > 0, errorMessage);
875         uint256 c = a / b;
876         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
877 
878         return c;
879     }
880 
881     /**
882      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
883      * Reverts when dividing by zero.
884      *
885      * Counterpart to Solidity's `%` operator. This function uses a `revert`
886      * opcode (which leaves remaining gas untouched) while Solidity uses an
887      * invalid opcode to revert (consuming all remaining gas).
888      *
889      * Requirements:
890      *
891      * - The divisor cannot be zero.
892      */
893     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
894         return mod(a, b, "SafeMath: modulo by zero");
895     }
896 
897     /**
898      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
899      * Reverts with custom message when dividing by zero.
900      *
901      * Counterpart to Solidity's `%` operator. This function uses a `revert`
902      * opcode (which leaves remaining gas untouched) while Solidity uses an
903      * invalid opcode to revert (consuming all remaining gas).
904      *
905      * Requirements:
906      *
907      * - The divisor cannot be zero.
908      */
909     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
910         require(b != 0, errorMessage);
911         return a % b;
912     }
913 }