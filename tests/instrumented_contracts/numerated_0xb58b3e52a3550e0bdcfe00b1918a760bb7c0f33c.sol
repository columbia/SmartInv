1 pragma solidity ^ 0.4.21;
2 
3 /**
4  *   @title SafeMath
5  *   @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns(uint256) {
15         assert(b > 0);
16         uint256 c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns(uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 /**
35  *   @title ERC20
36  *   @dev Standart ERC20 token interface
37  */
38 contract ERC20 {
39     function balanceOf(address _owner) public constant returns(uint256);
40     function transfer(address _to, uint256 _value) public returns(bool);
41     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
42     function approve(address _spender, uint256 _value) public returns(bool);
43     function allowance(address _owner, address _spender) public constant returns(uint256);
44     mapping(address => uint256) balances;
45     mapping(address => mapping(address => uint256)) allowed;
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 /**
52  *   @dev CRET token contract
53  */
54 contract CretToken is ERC20 {
55     using SafeMath for uint256;
56     string public name = "CRET TOKEN";
57     string public symbol = "CRET";
58     uint256 public decimals = 18;
59     uint256 public totalSupply = 0;
60     uint256 public riskTokens;
61     uint256 public bountyTokens;
62     uint256 public advisersTokens;
63     uint256 public reserveTokens;
64     uint256 public constant reserveTokensLimit = 5000000 * 1e18; //5mlnM  for reserve fund
65     uint256 public lastBountyStatus;
66     address public teamOneYearFrozen;
67     address public teamHalfYearFrozen;
68     uint256 public timeStamp;
69 
70 
71 
72     // Ico contract address
73     address public owner;
74     event Burn(address indexed from, uint256 value);
75 
76     // Disables token transfers
77     bool public tokensAreFrozen = true;
78 
79     // Allows execution by the owner only
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     
86     
87     constructor (address _owner, address _team, address _team2) public {
88         owner = _owner;
89         timeStamp = now;
90         teamOneYearFrozen = _team;
91         teamHalfYearFrozen = _team2;
92 
93     }
94     
95     
96 
97    /**
98     *   @dev Mint tokens
99     *   @param _investor     address the tokens will be issued to
100     *   @param _value        number of tokens
101     */
102     function mintTokens(address _investor, uint256 _value) external onlyOwner {
103         require(_value > 0);
104         balances[_investor] = balances[_investor].add(_value);
105         totalSupply = totalSupply.add(_value);
106         emit Transfer(0x0, _investor, _value);
107     }
108     
109     
110     function mintRiskTokens(address _investor, uint256 _value) external onlyOwner {
111         balances[_investor] = balances[_investor].add(_value);
112         totalSupply = totalSupply.add(_value);
113         riskTokens = riskTokens.add(_value);
114         emit Transfer(0x0, _investor, _value);
115     }
116     
117     
118     function mintReserveTokens(address _investor, uint256 _value) external onlyOwner {
119         require(reserveTokens.add(_value) <= reserveTokensLimit);
120         balances[_investor] = balances[_investor].add(_value);
121         totalSupply = totalSupply.add(_value);
122         reserveTokens = reserveTokens.add(_value);
123         emit Transfer(0x0, _investor, _value);
124     }
125     
126     
127     function mintAdvisersTokens(address _investor, uint256 _value) external onlyOwner {
128         balances[_investor] = balances[_investor].add(_value);
129         totalSupply = totalSupply.add(_value);
130         advisersTokens = advisersTokens.add(_value);
131         emit Transfer(0x0, _investor, _value);
132     }
133     
134 
135     function mintBountyTokens(address[] _dests, uint256 _value) external onlyOwner {
136         lastBountyStatus = 0;
137         for (uint256 i = 0;i < _dests.length; i++) {
138         address tmp = _dests[i];
139         balances[tmp] = balances[tmp].add(_value);
140         totalSupply = totalSupply.add(_value);
141         bountyTokens = bountyTokens.add(_value);
142         lastBountyStatus++;
143         emit Transfer(0x0, tmp, _value);
144         }
145     }
146     
147 
148 
149    /**
150     *   @dev Enables token transfers
151     */
152     function defrostTokens() external onlyOwner {
153       tokensAreFrozen = false;
154     }
155 
156    /**
157     *   @dev Disables token transfers
158     */
159     function frostTokens() external onlyOwner {
160       tokensAreFrozen = true;
161     }
162 
163    /**
164     *   @dev Burn Tokens
165     *   @param _investor     token holder address which the tokens will be burnt
166     *   @param _value        number of tokens to burn
167     */
168     function burnTokens(address _investor, uint256 _value) external onlyOwner {
169         require(balances[_investor] > 0);
170         balances[_investor] = balances[_investor].sub(_value);
171         totalSupply = totalSupply.sub(_value);
172         emit Burn(_investor, _value);
173     }
174 
175    /**
176     *   @dev Get balance of investor
177     *   @param _owner        investor's address
178     *   @return              balance of investor
179     */
180     function balanceOf(address _owner) public constant returns(uint256) {
181       return balances[_owner];
182     }
183 
184    /**
185     *   @return true if the transfer was successful
186     */
187     function transfer(address _to, uint256 _amount) public returns(bool) {
188         require(!tokensAreFrozen);
189         if(now < (timeStamp + 425 days)){               //365 days + 60 days ICO
190             require(msg.sender != teamOneYearFrozen);
191         } 
192         if(now < (timeStamp + 240 days)){        	// 180 days + 60 days ICO
193             require(msg.sender != teamHalfYearFrozen);
194         }
195 
196         balances[msg.sender] = balances[msg.sender].sub(_amount);
197         balances[_to] = balances[_to].add(_amount);
198         emit Transfer(msg.sender, _to, _amount);
199         return true;
200     }
201 
202    /**
203     *   @return true if the transfer was successful
204     */
205     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool) {
206         require(!tokensAreFrozen);
207         require(_amount <= allowed[_from][msg.sender]);
208         require(_amount <= balances[_from]);
209         if(now < (timeStamp + 425 days)){               //365 days + 60 days ICO 
210             require(msg.sender != teamOneYearFrozen);
211             require(_from != teamOneYearFrozen);
212         }
213         if(now < (timeStamp + 240 days)){        	// 180 days + 60 days ICO
214             require(msg.sender != teamHalfYearFrozen);
215             require(_from != teamHalfYearFrozen);
216         }
217 
218         balances[_from] = balances[_from].sub(_amount);
219         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
220         balances[_to] = balances[_to].add(_amount);
221         emit Transfer(_from, _to, _amount);
222         return true;
223     }
224 
225    /**
226     *   @dev Allows another account/contract to spend some tokens on its behalf
227     * approve has to be called twice in 2 separate transactions - once to
228     *   change the allowance to 0 and secondly to change it to the new allowance value
229     *   @param _spender      approved address
230     *   @param _amount       allowance amount
231     *
232     *   @return true if the approval was successful
233     */
234     function approve(address _spender, uint256 _amount) public returns(bool) {
235         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
236         allowed[msg.sender][_spender] = _amount;
237         emit Approval(msg.sender, _spender, _amount);
238         return true;
239     }
240 
241    /**
242     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
243     *
244     *   @param _owner        the address which owns the funds
245     *   @param _spender      the address which will spend the funds
246     *
247     *   @return              the amount of tokens still avaible for the spender
248     */
249     function allowance(address _owner, address _spender) public constant returns(uint256) {
250         return allowed[_owner][_spender];
251     }
252 }
253 
254 
255 contract CretICO {
256     using SafeMath for uint256;
257     
258     address public TeamFund; //tokens will be frozen for 1 year
259     address public TeamFund2; //tokens will be frozen for a half year
260     address public Companion1;
261     address public Companion2;
262     address public Manager; // Manager controls contract
263     address internal addressCompanion1;
264     address internal addressCompanion2;
265     CretToken public CRET;
266     
267     /**
268     *   @dev Contract constructor function
269     */
270     constructor (
271         address _TeamFund,
272         address _TeamFund2,
273         address _Companion1,
274         address _Companion2,
275         address _Manager
276     )
277         public {
278         TeamFund = _TeamFund;
279         TeamFund2 = _TeamFund2;
280         Manager = _Manager;
281         Companion1 = _Companion1;
282         Companion2 = _Companion2;
283         statusICO = StatusICO.Created;
284         CRET = new CretToken(this, _TeamFund, _TeamFund2);
285     }
286     
287  
288     
289 
290     // Token price parameters
291     uint256 public Rate_Eth = 700; // Rate USD per ETH
292     uint256 public Tokens_Per_Dollar = 10; // CRET token per dollar
293     uint256 public Token_Price = Tokens_Per_Dollar.mul(Rate_Eth); // CRET token per ETH
294     uint256 constant teamPart = 75; //7.5% * 2 = 15% of sold tokens for team 
295     uint256 constant advisersPart = 30; // 3% of sold tokens for advisers
296     uint256 constant riskPart = 10; // 1% of sold tokens for risk fund
297     uint256 constant airdropPart = 10; // 1% of sold tokens for airdrop program
298     uint256 constant SOFT_CAP = 30000000 * 1e18; // tokens without bonus 3 000 000$ in ICO
299     uint256 constant HARD_CAP = 450000000 * 1e18; // tokens without bonus 45 000 000$ in ICO
300     uint256 internal constant maxDeposit = 5000000 * 1e18;
301     uint256 internal constant bonusRange1 = 30000000 * 1e18;
302     uint256 internal constant bonusRange2 = 100000000 * 1e18;
303     uint256 internal constant bonusRange3 = 200000000 * 1e18;
304     uint256 internal constant bonusRange4 = 300000000 * 1e18;
305     uint256 public soldTotal;  // total sold without bonus
306     bool public canIBuy = false;
307     bool public canIWithdraw = false;
308 
309 
310     
311     
312 
313     // Possible ICO statuses
314     enum StatusICO {
315         Created,
316         PreIco,
317         PreIcoFinished,
318         Ico,
319         IcoFinished
320     }
321     
322     
323     StatusICO statusICO;
324 
325     // Mapping
326 
327     mapping(address => uint256) public icoInvestments; // Mapping for remembering investors eth in ICO
328     mapping(address => bool) public returnStatus; // Users can return their funds one time
329     mapping(address => uint256) public tokensIco; // Mapping for remembering tokens of investors who paid at ICO in ether
330     mapping(address => uint256) public tokensIcoInOtherCrypto; // Mapping for remembering tokens of investors who paid at ICO in other crypto
331     mapping(address => uint256) public pureBalance; // Mapping for remembering pure tokens of investors who paid at ICO
332     mapping(address => bool) public kyc;  // investor identification status
333 
334     // Events Log
335     event LogStartPreIco();
336     event LogFinishPreICO();
337     event LogStartIco();
338     event LogFinishICO();
339     event LogBuyForInvestor(address investor, uint256 value);
340     event LogReturnEth(address investor, uint256 eth);
341     event LogReturnOtherCrypto(address investor);
342 
343     // Modifiers
344     // Allows execution by the contract manager only
345     modifier managerOnly {
346         require(msg.sender == Manager);
347         _;
348     }
349     
350     // Allows execution by the companions only
351     modifier companionsOnly {
352         require(msg.sender == Companion1 || msg.sender == Companion2);
353         _;
354     }
355 
356 
357     // passing KYC for investor
358     function passKYC(address _investor) external managerOnly {
359         kyc[_investor] = true;
360     }
361 
362     // Giving a reward from risk managment token
363     function giveRiskToken(address _investor, uint256 _value) external managerOnly {
364         require(_value > 0);
365         uint256 rt = CRET.riskTokens();
366         uint256 decvalue = _value.mul(1 ether);
367         require(rt.add(decvalue) <= soldTotal.div(1000).mul(riskPart));
368         CRET.mintRiskTokens(_investor, decvalue);
369     }
370     
371     function giveAdvisers(address _investor, uint256 _value) external managerOnly {
372         require(_value > 0);
373         uint256 at = CRET.advisersTokens();
374         uint256 decvalue = _value.mul(1 ether);
375         require(at.add(decvalue) <= soldTotal.div(1000).mul(advisersPart)); // 3% for advisers
376         CRET.mintAdvisersTokens(_investor, decvalue);
377     }
378     
379     function giveReserveFund(address _investor, uint256 _value) external managerOnly {
380         require(_value > 0);
381         uint256 decvalue = _value.mul(1 ether);
382         CRET.mintReserveTokens(_investor, decvalue);
383     }
384     
385     function giveBounty(address[] dests, uint256 _value) external managerOnly {
386         require(_value > 0);
387         uint256 bt = CRET.bountyTokens();
388         uint256 decvalue = _value.mul(1 ether);
389         uint256 wantToMint = dests.length.mul(decvalue);
390         require(bt.add(wantToMint) <= soldTotal.div(1000).mul(airdropPart)); 
391         CRET.mintBountyTokens(dests, decvalue);
392 
393     }
394     
395    
396     function pureBalance(address _owner) public constant returns(uint256) {
397       return pureBalance[_owner];
398     }
399     
400     
401     function currentStage() public view returns (string) {
402         if(statusICO == StatusICO.Created){return "Created";}
403         else if(statusICO == StatusICO.PreIco){return  "PreIco";}
404         else if(statusICO == StatusICO.PreIcoFinished){return "PreIcoFinished";}
405         else if(statusICO == StatusICO.Ico){return "Ico";}
406         else if(statusICO == StatusICO.IcoFinished){return "IcoFinished";}
407     }
408 
409    /**
410     *   @dev Set rate of ETH and update token price
411     *   @param _RateEth       current ETH rate
412     */
413     function setRate(uint256 _RateEth) external managerOnly {
414         Rate_Eth = _RateEth;
415         Token_Price = Tokens_Per_Dollar.mul(Rate_Eth);
416     }
417 
418    /**
419     *   
420     *   Start PreICO 
421     */
422     function startPreIco() external managerOnly {
423         require(statusICO == StatusICO.Created); 
424         statusICO = StatusICO.PreIco;
425         emit LogStartPreIco();
426     }
427     
428     /**
429     *   @dev Finish PreIco
430     *   Set Ico status to PreIcoFinished
431     */
432     function finishPreIco() external managerOnly {
433         require(statusICO == StatusICO.PreIco);
434         statusICO = StatusICO.PreIcoFinished;
435         emit LogFinishPreICO();
436     }
437 
438  
439  
440 
441    /**
442     *   @dev Start ICO
443     *   Set ICO status
444     */
445     
446     function setIco() external managerOnly {
447         require(statusICO == StatusICO.PreIcoFinished);
448         statusICO = StatusICO.Ico;
449         canIBuy = true;
450         emit LogStartIco();
451     }
452 
453 
454    /**
455     *   @dev Finish ICO and emit tokens for bounty advisors and team
456     */
457     function finishIco() external managerOnly {
458         require(statusICO == StatusICO.Ico);
459         
460         uint256 teamTokens = soldTotal.div(1000).mul(teamPart);
461         CRET.mintTokens(TeamFund, teamTokens);
462         CRET.mintTokens(TeamFund2, teamTokens);
463         statusICO = StatusICO.IcoFinished;
464         canIBuy = false;
465         if(soldTotal < SOFT_CAP){canIWithdraw = true;}
466         emit LogFinishICO();
467     }
468 
469 
470    /**
471     *   @dev Unfreeze tokens(enable token transfer)
472     */
473     function enableTokensTransfer() external managerOnly {
474         CRET.defrostTokens();
475     }
476 
477     /**
478     *   @dev Freeze tokens(disable token transfers)
479     */
480     function disableTokensTransfer() external managerOnly {
481         require(statusICO != StatusICO.IcoFinished);
482         CRET.frostTokens();
483     }
484 
485    /**
486     *   @dev Fallback function calls function to create tokens
487     *        when investor sends ETH to address of ICO contract
488     */
489     function() external payable {
490         require(canIBuy);
491         require(kyc[msg.sender]);
492         require(msg.value > 0);
493         require(msg.value.mul(Token_Price) <= maxDeposit);
494         require(pureBalance[msg.sender].add(msg.value.mul(Token_Price)) <= maxDeposit);
495         createTokens(msg.sender, msg.value.mul(Token_Price), msg.value);
496     }
497     
498    
499     
500     function buyToken() external payable {
501         require(canIBuy);
502         require(kyc[msg.sender]);
503         require(msg.value > 0);
504         require(msg.value.mul(Token_Price) <= maxDeposit);
505         require(pureBalance[msg.sender].add(msg.value.mul(Token_Price)) <= maxDeposit);
506         createTokens(msg.sender, msg.value.mul(Token_Price), msg.value);
507     }
508     
509     
510     function buyPreIco() external payable {
511         require(msg.value.mul(Token_Price) <= maxDeposit);
512         require(kyc[msg.sender]);
513         require(statusICO == StatusICO.PreIco);
514         require(pureBalance[msg.sender].add(msg.value.mul(Token_Price)) <= maxDeposit);
515         createTokens(msg.sender, msg.value.mul(Token_Price), msg.value);
516     }
517 
518 
519 
520     function buyForInvestor(address _investor, uint256 _value) external managerOnly {
521         uint256 decvalue = _value.mul(1 ether);
522         require(_value > 0);
523         require(kyc[_investor]);
524         require(pureBalance[_investor].add(decvalue) <= maxDeposit);
525         require(decvalue <= maxDeposit);
526         require(statusICO != StatusICO.IcoFinished);
527         require(statusICO != StatusICO.PreIcoFinished);
528         require(statusICO != StatusICO.Created);
529         require(soldTotal.add(decvalue) <= HARD_CAP);
530         uint256 bonus = getBonus(decvalue);
531         uint256 total = decvalue.add(bonus);
532         tokensIcoInOtherCrypto[_investor] = tokensIcoInOtherCrypto[_investor].add(total);
533         soldTotal = soldTotal.add(decvalue);
534         pureBalance[_investor] = pureBalance[_investor].add(decvalue);
535         
536         CRET.mintTokens(_investor, total);
537         emit LogBuyForInvestor(_investor, _value);
538     }
539     
540 
541 
542     function createTokens(address _investor, uint256 _value, uint256 _ethValue) internal {
543         require(_value > 0);
544         require(soldTotal.add(_value) <= HARD_CAP);
545         uint256 bonus = getBonus(_value);
546         uint256 total = _value.add(bonus);
547         tokensIco[_investor] = tokensIco[_investor].add(total);
548         icoInvestments[_investor] = icoInvestments[_investor].add(_ethValue);
549         soldTotal = soldTotal.add(_value);
550         pureBalance[_investor] = pureBalance[_investor].add(_value);
551       
552         CRET.mintTokens(_investor, total);
553     }
554 
555 
556 
557    /**
558     *   @dev Calculates bonus 
559     *   @param _value        amount of tokens
560     *   @return              bonus value
561     */
562     function getBonus(uint256 _value) public view returns(uint256) {
563         uint256 bonus = 0;
564         if (soldTotal <= bonusRange1) {
565             if(soldTotal.add(_value) <= bonusRange1){
566                 bonus = _value.mul(500).div(1000);
567             } else {
568                 uint256 part1 = (soldTotal.add(_value)).sub(bonusRange1);
569                 uint256 part2 = _value.sub(part1);
570                 uint256 bonusPart1 = part1.mul(300).div(1000);
571                 uint256 bonusPart2 = part2.mul(500).div(1000);
572                 bonus = bonusPart1.add(bonusPart2);
573             }
574                                 
575         } else if (soldTotal > bonusRange1 && soldTotal <= bonusRange2) {
576             if(soldTotal.add(_value) <= bonusRange2){
577                 bonus = _value.mul(300).div(1000);
578             } else {
579                 part1 = (soldTotal.add(_value)).sub(bonusRange2);
580                 part2 = _value.sub(part1);
581                 bonusPart1 = part1.mul(200).div(1000);
582                 bonusPart2 = part2.mul(300).div(1000);
583                 bonus = bonusPart1.add(bonusPart2);
584             }
585         } else if (soldTotal > bonusRange2 && soldTotal <= bonusRange3) {
586             if(soldTotal.add(_value) <= bonusRange3){
587                 bonus = _value.mul(200).div(1000);
588             } else {
589                 part1 = (soldTotal.add(_value)).sub(bonusRange3);
590                 part2 = _value.sub(part1);
591                 bonusPart1 = part1.mul(100).div(1000);
592                 bonusPart2 = part2.mul(200).div(1000);
593                 bonus = bonusPart1.add(bonusPart2);
594             }
595         } else if (soldTotal > bonusRange3 && soldTotal <= bonusRange4) {
596             if(soldTotal.add(_value) <= bonusRange4){
597                 bonus = _value.mul(100).div(1000);
598             } else {
599                 part1 = (soldTotal.add(_value)).sub(bonusRange4);
600                 part2 = _value.sub(part1);
601                 bonusPart1 = 0;
602                 bonusPart2 = part2.mul(100).div(1000);
603                 bonus = bonusPart1.add(bonusPart2);
604             }
605         } 
606         return bonus;
607     }
608     
609     
610     
611 
612    /**
613     *   @dev Allows investors to return their investments
614     */
615     function returnEther() public {
616         require(canIWithdraw);
617         require(!returnStatus[msg.sender]);
618         require(icoInvestments[msg.sender] > 0);
619         uint256 eth = 0;
620         uint256 tokens = 0;
621         eth = icoInvestments[msg.sender];
622         tokens = tokensIco[msg.sender];
623         icoInvestments[msg.sender] = 0;
624         tokensIco[msg.sender] = 0;
625         pureBalance[msg.sender] = 0;
626         returnStatus[msg.sender] = true;
627 
628         CRET.burnTokens(msg.sender, tokens);
629         msg.sender.transfer(eth);
630         emit LogReturnEth(msg.sender, eth);
631     }
632 
633    /**
634     *   @dev Burn tokens who paid in other cryptocurrencies
635     */
636     function returnOtherCrypto(address _investor)external managerOnly {
637         require(canIWithdraw);
638         require(tokensIcoInOtherCrypto[_investor] > 0);
639         uint256 tokens = 0;
640         tokens = tokensIcoInOtherCrypto[_investor];
641         tokensIcoInOtherCrypto[_investor] = 0;
642         pureBalance[_investor] = 0;
643 
644         CRET.burnTokens(_investor, tokens);
645         emit LogReturnOtherCrypto(_investor);
646     }
647     
648     
649     /**
650     *   @dev Allows Companions to add consensus address
651     */
652     function consensusAddress(address _investor) external companionsOnly {
653         if(msg.sender == Companion1) {
654             addressCompanion1 = _investor;
655         } else {
656             addressCompanion2 = _investor;
657         }
658     }
659     
660     
661     
662    
663 
664    /**
665     *   @dev Allows Companions withdraw investments
666     */
667     function takeInvestments() external companionsOnly {
668         require(addressCompanion1 != 0x0 && addressCompanion2 != 0x0);
669         require(addressCompanion1 == addressCompanion2);
670         require(soldTotal >= SOFT_CAP);
671         addressCompanion1.transfer(address(this).balance);
672         CRET.defrostTokens();
673         }
674         
675     }
676 
677 
678 // gexabyte.com