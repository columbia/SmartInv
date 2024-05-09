1 pragma solidity ^0.4.15;
2 
3 contract Addresses {
4 
5     //2%
6     address public bounty;
7     
8     //5%
9     address public successFee;
10 
11     //93%
12     address public addr1;
13 
14     //93%
15     address public addr2;
16 
17     //93%
18     address public addr3;
19 
20     //93%
21     address public addr4;
22 
23 
24   function Addresses() {
25 
26       //2%       //ORIGINAL
27       bounty = 0x0064952457905eBFB9c0292200A74B1d7414F081;
28                  //TEST
29    //   bounty = 0x1626079328312cdb1e731a934a547c6d81b3ee2c;
30       
31       //5%       //ORIGINAL
32       successFee = 0xdA39e0Ce2adf93129D04F53176c7Bfaaae8B051a;
33                  //TEST
34     //  successFee = 0xf280dacf47f33f442cf5fa9d20abaef4b6e9ca12;
35 
36     //93%       //ORIGINAL
37       addr1 = 0x300b848558DC06E32658fFB8D59C859D0812CA6C;
38 
39       //93%       //ORIGINAL
40       addr2 = 0x4388AD192b0DaaDBBaa86Be0AE7499b8D44C5f75;
41 
42       //93%       //ORIGINAL
43       addr3 = 0x40C9E2D0807289b4c24B0e2c34277BDd7FaCfd87;
44 
45       //93%       //ORIGINAL
46       addr4 = 0x4E3B219684b9570D0d81Cc13E5c0aAcafe2323B1;
47       
48 
49      /* //93%       //TEST
50       addr1 = 0x1626079328312cdb1e731a934a547c6d81b3ee2c;
51 
52       //93%       //TEST
53       addr2 = 0x1626079328312cdb1e731a934a547c6d81b3ee2c;
54 
55       //93%       //TEST
56       addr3 = 0x1626079328312cdb1e731a934a547c6d81b3ee2c;
57 
58       //93%       //TEST
59       addr4 = 0x1626079328312cdb1e731a934a547c6d81b3ee2c;*/
60   }
61 
62 }
63 
64 library SafeMath {
65     
66   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
67     uint256 c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71  
72   function div(uint256 a, uint256 b) internal constant returns (uint256) {
73     uint256 c = a / b;
74     return c;
75   }
76  
77   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81  
82   function add(uint256 a, uint256 b) internal constant returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 
88   function mod(uint256 a, uint256 b) internal constant returns (uint256) {
89     uint256 c = a % b;
90     return c;
91   }
92   
93 }
94 
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) constant returns (uint256);
98   function transfer(address to, uint256 value) returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) constant returns (uint256);
104   function transferFrom(address from, address to, uint256 value) returns (bool);
105   function approve(address spender, uint256 value) returns (bool);
106   function approve(address _owner, address _spender, uint256 _value) returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 contract Migrations {
111   address public owner;
112   uint public last_completed_migration;
113 
114   modifier restricted() {
115     if (msg.sender == owner) _;
116   }
117 
118   function Migrations() {
119     owner = msg.sender;
120   }
121 
122   function setCompleted(uint completed) restricted {
123     last_completed_migration = completed;
124   }
125 
126   function upgrade(address new_address) restricted {
127     Migrations upgraded = Migrations(new_address);
128     upgraded.setCompleted(last_completed_migration);
129   }
130 }
131 
132 contract Ownable {
133     
134   address public owner;
135  
136   function Ownable() {
137     owner = msg.sender;
138   }
139 
140   modifier onlyOwner() {
141     require(msg.sender == owner);
142     _;
143   }
144 
145   function transferOwnership(address newOwner) onlyOwner {
146     require(newOwner != address(0));      
147     owner = newOwner;
148   }
149  
150 }
151 
152 contract BasicToken is ERC20Basic {
153     
154   using SafeMath for uint256;
155  
156   mapping(address => uint256) balances;
157 
158   //18.10.2017 23:59 UTC
159   uint256 ico_finish = 1508284740;
160 
161   modifier isFreeze() {
162     if(now < ico_finish) {
163       revert();
164     }
165     _;
166   }
167 
168   function transfer(address _to, uint256 _value) isFreeze returns (bool) {
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     Transfer(msg.sender, _to, _value);
172     return true;
173   }
174  
175   function balanceOf(address _owner) constant returns (uint256 balance) {
176     return balances[_owner];
177   }
178  
179 }
180 
181 contract StandardToken is ERC20, BasicToken {
182  
183   mapping (address => mapping (address => uint256)) allowed;
184 
185   //14.10.2017 23:59 UTC
186   uint256 ico_finish = 1508025540;
187 
188   modifier isFreeze() {
189     if(now < ico_finish) {
190       revert();
191     }
192     _;
193   }
194  
195   function transferFrom(address _from, address _to, uint256 _value) isFreeze returns (bool) {
196     var _allowance = allowed[_from][msg.sender];
197  
198     balances[_to] = balances[_to].add(_value);
199     balances[_from] = balances[_from].sub(_value);
200     allowed[_from][msg.sender] = _allowance.sub(_value);
201     Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   function approve(address _spender, uint256 _value) returns (bool) {
206  
207     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
208  
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   function approve(address _owner, address _spender, uint256 _value) returns (bool) {
215  
216     allowed[_owner][_spender] = _value;
217     Approval(_owner, _spender, _value);
218     return true;
219   }
220  
221   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
222     return allowed[_owner][_spender];
223   }
224  
225 }
226 
227 contract MintableToken is StandardToken, Ownable {
228 
229   using SafeMath for uint256;
230 
231   bool mintingFinished = false;
232 
233   uint256 mintedTokens = 0;
234 
235   event Mint(address indexed to, uint256 amount);
236 
237   event MintFinished();
238 
239   event ShowInfo(uint256 _info, string _message);
240 
241   function setTotalSupply(uint256 _amount) public onlyOwner returns(uint256) {
242     totalSupply = _amount;
243     return totalSupply;
244   }
245 
246   function getTotalTokenCount() public constant returns(uint256) {
247     return totalSupply;
248   }
249 
250   modifier canMint() {
251     require(!mintingFinished);
252     _;
253   }
254 
255   function finishMinting() public onlyOwner {
256     mintingFinished = true;
257   }
258   
259   function mint(address _address, uint256 _tokens) canMint onlyOwner public {
260 
261     require(mintedTokens < totalSupply);
262 
263     Mint(_address, _tokens);
264 
265     balances[_address] = balances[_address].add(_tokens);
266 
267     mintedTokens = mintedTokens.add(_tokens);
268   }
269 
270   function burnTokens(address _address) onlyOwner public {
271     balances[_address] = 0;
272     totalSupply = 0;
273     mintedTokens = 0;
274   }
275 
276   function burnFinish() onlyOwner public {
277     totalSupply = mintedTokens;
278   }
279 
280 }
281 
282 contract SingleTokenCoin is MintableToken {
283     
284     string public constant name = "Start mining";
285     
286     string public constant symbol = "STM";
287     
288     uint32 public constant decimals = 2;
289     
290 }
291 
292 contract WrapperOraclize {
293     function update(string datasource, string arg) payable;
294     function update(uint timestamp, string datasource, string arg) payable;
295     function getWrapperBalance() constant returns(uint256);
296     function getWrapperData() constant returns(bytes32);
297     function getPrice(string datasource) constant returns(uint256);
298     function() external payable;
299 }
300 
301 contract Crowdsale is Ownable {
302 
303   string public ETHUSD;
304 
305   event ShowPrice(string price);
306 
307     using SafeMath for uint256;
308 
309     SingleTokenCoin public token = new SingleTokenCoin();
310 
311     Addresses private addresses = new Addresses();
312 
313     WrapperOraclize private wrapper = WrapperOraclize(0xfC484c66daE464CC6055d7a4782Ec8761dc9842F);
314 
315     uint256 private ico_start;
316     uint256 private ico_finish;
317 
318     uint256 private rate;
319 
320     uint256 private decimals;
321 
322     uint256 private tax;
323 
324     //Time-based Bonus Program
325     uint256 private firstBonusPhase;
326     uint256 private firstExtraBonus;
327 
328     uint256 private secondBonusPhase;
329     uint256 private secondExtraBonus;
330 
331     uint256 private thirdBonusPhase;
332     uint256 private thirdExtraBonus;
333 
334     uint256 private fourBonusPhase;
335     uint256 private fourExtraBonus;
336 
337     //Withdrow Phases
338     bool private firstWithdrowPhase;
339     bool private secondWithdrowPhase;
340     bool private thirdWithdrowPhase;
341     bool private fourWithdrowPhase;
342 
343     uint256 private firstWithdrowAmount;
344     uint256 private secondWithdrowAmount;
345     uint256 private thirdWithdrowAmount;
346     uint256 private fourWithdrowAmount;
347 
348     uint256 private totalETH;
349 
350     uint256 private totalAmount;
351 
352     bool private initialize = false;
353     
354     bool public mintingFinished = false;
355 
356     //Storage for ICO Buyers ETH
357     mapping(address => uint256) private ico_buyers_eth;
358 
359     //Storage for ICO Buyers Token
360     mapping(address => uint256) private ico_buyers_token;
361 
362     address[] private investors;
363 
364     mapping(address => bytes32) private privilegedWallets;
365     mapping(address => uint256) private manualAddresses;
366 
367     address[] private manualAddressesCount;
368 
369     address[] private privilegedWalletsCount;
370 
371     bytes32 private g = "granted";
372 
373     bytes32 private r = "revorked";
374 
375     uint256 private soldTokens;
376     uint256 private mincup;
377 
378     uint256 private minPrice;
379 
380     event ShowInfo(uint256 _info);
381     event ShowInfoStr(string _info);
382     event ShowInfoBool(bool _info);
383 
384     function Crowdsale() {
385 
386       //set calculate rate from USD
387       rate = 3546099290780141; //0.0003 ETH //temp
388 
389       decimals = 35460992907801; // 0.0000003 ETH // 2 decimals
390 
391       tax = 36000000000000000; //tax && minimum price ~10$
392 
393       //minPrice = decimals + tax; // ~10$
394 
395       //18.09.2017 15:00 UTC (1505746800)
396       ico_start = 1505746800;
397 
398       //17.10.2017 23:59 UTC (1508284740)
399       ico_finish = 1508284740;
400 
401       totalAmount = 1020000000;
402 
403       // 500 000 STM with 2 decimals
404       mincup = 50000000;
405       
406       mintingFinished = false;
407 
408       setTotalSupply();
409 
410       //Time-Based Bonus Phase
411       firstBonusPhase = ico_start.add(24 hours);
412       firstExtraBonus = 25;
413 
414       secondBonusPhase = ico_start.add(168 hours);
415       secondExtraBonus = 15;
416 
417       thirdBonusPhase = ico_start.add(336 hours);
418       thirdExtraBonus = 10;
419 
420       fourBonusPhase = ico_start.add(480 hours);
421       fourExtraBonus = 5;
422 
423       //Withdrow Phases
424       firstWithdrowPhase = false;
425       secondWithdrowPhase = false;
426       thirdWithdrowPhase = false;
427       fourWithdrowPhase = false;
428 
429       firstWithdrowAmount = 50000000;
430       secondWithdrowAmount = 200000000;
431       thirdWithdrowAmount = 500000000;
432       fourWithdrowAmount = 1020000000;
433 
434       totalETH = 0;
435 
436       soldTokens = 0;
437 
438       privilegedWalletsCount.push(msg.sender);
439       privilegedWallets[msg.sender] = g;
440 
441     }
442 
443       modifier canMint() {
444         require(!mintingFinished);
445         _;
446       }
447 
448     function() external payable {
449       mint();
450     }
451 
452   function bytesToUInt(bytes32 v) constant returns (uint ret) {
453         if (v == 0x0) {
454             revert();
455         }
456 
457         uint digit;
458 
459         for (uint i = 0; i < 32; i++) {
460             digit = uint((uint(v) / (2 ** (8 * (31 - i)))) & 0xff);
461             if (digit == 0 || digit == 46) {
462                 break;
463             }
464             else if (digit < 48 || digit > 57) {
465                 revert();
466             }
467             ret *= 10;
468             ret += (digit - 48);
469         }
470         return ret;
471     }
472 
473   function calculateRate() public payable returns(uint256) {
474     bytes32 result = getWrapperData();
475     uint256 usd = bytesToUInt(result);
476 
477     uint256 price = 1 ether / usd; //price for 1 STM
478 
479     return price;
480   }
481 
482     function calculateWithdrow() private {
483       if (!firstWithdrowPhase && soldTokens >= firstWithdrowAmount && soldTokens < secondWithdrowAmount) {
484         sendToOwners(this.balance);
485       } else {
486         if (!secondWithdrowPhase && soldTokens >= secondWithdrowAmount && soldTokens < thirdWithdrowAmount) {
487           sendToOwners(this.balance);
488         } else {
489           if (!thirdWithdrowPhase && soldTokens >= thirdWithdrowAmount && soldTokens < fourWithdrowAmount) {
490             sendToOwners(this.balance);
491           } else {
492             if (!fourWithdrowPhase && soldTokens >= fourWithdrowAmount) {
493               sendToOwners(this.balance);
494             }
495           }
496         }
497       }
498     }
499 
500     modifier isInitialize() {
501       require(!initialize);
502       _;
503     }
504 
505     function setTotalSupply() private isInitialize onlyOwner returns(uint256) {
506       initialize = true;
507       return token.setTotalSupply(totalAmount);
508     }
509 
510     function sendToAddress(address _address, uint256 _tokens) canMint public {
511 
512       if (grantedWallets(msg.sender) == false) {
513         revert();      
514       }
515 
516       ShowInfo(_tokens);
517 
518       uint256 currentTokens = _tokens;
519 
520       uint256 timeBonus = calculateBonusForHours(currentTokens);
521 
522       uint256 allTokens = currentTokens.add(timeBonus);   
523 
524       token.approve(_address, this, allTokens);      
525 
526       saveInfoAboutInvestors(_address, 0, allTokens, true);         
527 
528       token.mint(_address, allTokens);
529 
530       soldTokens = soldTokens + allTokens;
531       calculateWithdrow();
532     }
533 
534     modifier isRefund() {
535       if (msg.value < tax) {
536         refund(msg.value);
537         revert();
538       }
539       _;
540     }
541 
542     function grantedWallets(address _address) private returns(bool) {
543       if (privilegedWallets[_address] == g) {
544         return true;
545       }
546       return false;
547     }
548 
549     modifier isICOFinished() {
550       if (now > ico_finish) {
551         finishMinting();
552         refund(msg.value);
553         revert();
554       }
555       _;
556     }
557 
558     function getTokens() public constant returns(uint256) {
559       token.getTotalTokenCount();
560     }
561 
562     function setPrivelegedWallet(address _address) public onlyOwner returns(bool) {
563       if (privilegedWalletsCount.length == 2) {
564         revert();
565       }
566 
567       if (privilegedWallets[_address] != g && privilegedWallets[_address] != r) {
568         privilegedWalletsCount.push(_address);
569       }
570 
571       privilegedWallets[_address] = g;
572 
573       return true;
574     }
575 
576     function setTransferOwnership(address _address) public onlyOwner {
577 
578       removePrivelegedWallet(msg.sender);
579       setPrivelegedWallet(_address);
580 
581       transferOwnership(_address);
582     }
583 
584     function removePrivelegedWallet(address _address) public onlyOwner {
585       if (privilegedWallets[_address] == g) {
586         privilegedWallets[_address] = r;
587         delete privilegedWalletsCount[0];
588       } else {
589         revert();
590       }
591     }
592 
593     //only for demonstrate Test Version
594     function setICODate(uint256 _time) public onlyOwner {
595       ico_start = _time;
596       ShowInfo(_time);
597     }
598 
599     function getICODate() public constant returns(uint256) {
600       return ico_start;
601     }
602 
603     function mint() public isRefund canMint isICOFinished payable {
604 
605       rate = calculateRate();
606 
607       decimals = rate / 100; //price for 0.01 STM
608 
609       uint256 remainder = msg.value.mod(decimals);
610 
611       uint256 eth = msg.value.sub(remainder);
612 
613       if (remainder != 0) {
614         refund(remainder);
615       }
616 
617       totalETH = totalETH + eth;
618 
619       uint currentRate = rate / 100; //2 decimals
620 
621       uint256 tokens = eth.div(currentRate);
622       uint256 timeBonus = calculateBonusForHours(tokens);
623 
624       uint256 allTokens = tokens.add(timeBonus) + 100; // +100 - oraclize Tax
625 
626       saveInfoAboutInvestors(msg.sender, eth, allTokens, false);
627 
628       token.mint(msg.sender, allTokens);
629 
630       soldTokens = soldTokens + allTokens;
631       calculateWithdrow();
632     }
633 
634     function saveInfoAboutInvestors(address _address, uint256 _amount, uint256 _tokens, bool _isManual) private {
635 
636       if (!_isManual) {
637         if (ico_buyers_token[_address] == 0) {
638           investors.push(_address);
639         }
640 
641         // Store ETH of Investor
642         ico_buyers_eth[_address] = ico_buyers_eth[_address].add(_amount);
643 
644         // Store Token of Investor
645         ico_buyers_token[_address] = ico_buyers_token[_address].add(_tokens);
646       
647       } else {
648         if(manualAddresses[_address] == 0) {
649           manualAddressesCount.push(_address);
650         }
651 
652         manualAddresses[_address] = manualAddresses[_address].add(_tokens);
653       }
654     }
655 
656     function getManualByAddress(address _address) public constant returns(uint256) {
657       return manualAddresses[_address];
658     }
659 
660     function getManualInvestorsCount() public constant returns(uint256) {
661       return manualAddressesCount.length;
662     }
663 
664     function getManualAddress(uint _index) public constant returns(address) {
665       return manualAddressesCount[_index];
666     }
667 
668     function finishMinting() public onlyOwner {
669       if(mintingFinished) {
670         revert();
671       }
672 
673       token.finishMinting();
674 
675 
676       ShowInfoBool(mintingFinished);
677       mintingFinished = true;
678       ShowInfoBool(mintingFinished);
679       
680       if (soldTokens < mincup) {
681         if(investors.length != 0) {
682           for (uint256 i=0; i < investors.length; i++) {
683             address addr = investors[i];  
684             token.burnTokens(addr);
685           }
686         }
687         
688         if(manualAddressesCount.length != 0) {
689           for (uint256 j=0; j < manualAddressesCount.length; j++) {
690             address manualAddr = manualAddressesCount[j];
691             token.burnTokens(manualAddr);
692           }
693         }
694       }
695 
696       token.burnFinish();
697     }
698 
699     function getFinishStatus() public constant returns(bool) {
700       return mintingFinished;
701     }
702 
703     function manualRefund() public {
704       if (mintingFinished) {
705         if(ico_buyers_eth[msg.sender] != 0) {
706           uint256 amount = ico_buyers_eth[msg.sender];
707           msg.sender.transfer(amount);
708           ico_buyers_eth[msg.sender] = 0;
709         } else {
710           revert();
711         }
712       } else {
713         revert();
714       }
715       
716     }
717 
718     function refund(uint256 _amount) private {
719       msg.sender.transfer(_amount);
720     }
721 
722     function refund(address _address, uint256 _amount) private {
723       _address.transfer(_amount);
724     }
725 
726     function getTokensManual(address _address) public constant returns(uint256) {
727       return manualAddresses[_address];
728     }
729 
730     function calculateBonusForHours(uint256 _tokens) private returns(uint256) {
731 
732       //Calculate for first bonus program
733       if (now >= ico_start && now <= firstBonusPhase ) {
734         return _tokens.mul(firstExtraBonus).div(100);
735       }
736 
737       //Calculate for second bonus program
738       if (now > firstBonusPhase && now <= secondBonusPhase ) {
739         return _tokens.mul(secondExtraBonus).div(100);
740       }
741 
742       //Calculate for third bonus program
743       if (now > secondBonusPhase && now <= thirdBonusPhase ) {
744         return _tokens.mul(thirdExtraBonus).div(100);
745       }
746 
747       //Calculate for four bonus program
748       if (now > thirdBonusPhase && now <= fourBonusPhase ) {
749         return _tokens.mul(fourExtraBonus).div(100);
750       }
751 
752       return 0;
753     }
754 
755     function sendToOwners(uint256 _amount) private {
756       uint256 twoPercent = _amount.mul(2).div(100);
757       uint256 fivePercent = _amount.mul(5).div(100);
758       uint256 nineThreePercent = _amount.mul(93).div(100);
759 
760 // ----------ADDRESSES FOR PRODUCTION-------------
761 
762       //NineThree Percent
763       addresses.addr1().transfer(nineThreePercent);
764       addresses.addr2().transfer(nineThreePercent);
765       addresses.addr3().transfer(nineThreePercent);
766       addresses.addr4().transfer(nineThreePercent);
767 
768       if (!firstWithdrowPhase) {
769         addresses.addr1().transfer(nineThreePercent);
770         firstWithdrowPhase = true;
771       } else {
772         if (!secondWithdrowPhase) {
773           addresses.addr2().transfer(nineThreePercent);   
774           secondWithdrowPhase = true;       
775         } else {
776           if (!thirdWithdrowPhase) {
777             addresses.addr3().transfer(nineThreePercent);
778             thirdWithdrowPhase = true;                
779           } else {
780             if (!fourWithdrowPhase) {
781               addresses.addr4().transfer(nineThreePercent);
782               fourWithdrowPhase = true;                      
783             }
784           }
785         }
786       }
787 
788 
789       //Five Percent
790       addresses.successFee().transfer(fivePercent);
791       
792       //Two Percent
793       addresses.bounty().transfer(twoPercent);
794       
795     }
796 
797     function getBalanceContract() public constant returns(uint256) {
798       return this.balance;
799     }
800 
801     function getSoldToken() public constant returns(uint256) {
802       return soldTokens;
803     }
804 
805     function getInvestorsTokens(address _address) public constant returns(uint256) {
806       return ico_buyers_token[_address];
807     }
808 
809     function getInvestorsETH(address _address) public constant returns(uint256) {
810       return ico_buyers_eth[_address];
811     }
812 
813     function getInvestors() public constant returns(uint256) {
814       return investors.length;
815     }
816 
817     function getInvestorByValue(address _address) public constant returns(uint256) {
818       return ico_buyers_eth[_address];
819     }
820 
821     //only for test version
822     function transfer(address _from, address _to, uint256 _amount) public returns(bool) {
823       return token.transferFrom(_from, _to, _amount);
824     }
825 
826     function getInvestorByIndex(uint256 _index) public constant returns(address) {
827       return investors[_index];
828     }
829 
830     function getLeftToken() public constant returns(uint256) {
831       if(token.totalSupply() != 0) {
832         return token.totalSupply() - soldTokens;
833       } else {
834         return soldTokens;
835       }
836     }
837 
838     function getTotalToken() public constant returns(uint256) {
839       return token.totalSupply();
840     }
841 
842     function getTotalETH() public constant returns(uint256) {
843       return totalETH;
844     }
845 
846     function getCurrentPrice() public constant returns(uint256) {
847       
848       uint256 secondDiscount = calculateBonusForHours(rate);
849 
850       uint256 investorDiscount = rate.sub(secondDiscount);
851 
852       return investorDiscount * 10; //minimum 10$ //~10STM
853     }
854 
855     function getContractAddress() public constant returns(address) {
856       return this;
857     }
858 
859     function getOwner() public constant returns(address) {
860       return owner;
861     }
862 
863     function sendOracleData() public payable {
864         if (msg.value != 0) {
865             wrapper.transfer(msg.value);
866         }
867       
868       wrapper.update("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
869     }
870 
871     function getQueryPrice(string datasource) constant returns(uint256) {
872       return wrapper.getPrice(datasource);
873     }
874 
875     function checkWrapperBalance() public constant returns(uint256) {
876       return wrapper.getWrapperBalance();
877     }
878 
879     function getWrapperData() constant returns(bytes32) {
880       return wrapper.getWrapperData();
881     }
882 }