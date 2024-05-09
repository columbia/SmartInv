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
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant returns (uint256);
67   function transfer(address to, uint256 value) returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant returns (uint256);
73   function transferFrom(address from, address to, uint256 value) returns (bool);
74   function approve(address spender, uint256 value) returns (bool);
75   function approve(address _owner, address _spender, uint256 _value) returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 contract Ownable {
81     
82   address public owner;
83  
84   function Ownable() {
85     owner = msg.sender;
86   }
87 
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   function transferOwnership(address newOwner) onlyOwner {
94     require(newOwner != address(0));      
95     owner = newOwner;
96   }
97  
98 }
99 
100 library SafeMath {
101     
102   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
103     uint256 c = a * b;
104     assert(a == 0 || c / a == b);
105     return c;
106   }
107  
108   function div(uint256 a, uint256 b) internal constant returns (uint256) {
109     uint256 c = a / b;
110     return c;
111   }
112  
113   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
114     assert(b <= a);
115     return a - b;
116   }
117  
118   function add(uint256 a, uint256 b) internal constant returns (uint256) {
119     uint256 c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 
124   function mod(uint256 a, uint256 b) internal constant returns (uint256) {
125     uint256 c = a % b;
126     return c;
127   }
128   
129 }
130 
131 contract BasicToken is ERC20Basic {
132     
133   using SafeMath for uint256;
134  
135   mapping(address => uint256) balances;
136 
137   //18.10.2017 23:59 UTC
138   uint256 ico_finish = 1508284740;
139 
140   modifier isFreeze() {
141     if(now < ico_finish) {
142       revert();
143     }
144     _;
145   }
146 
147   function transfer(address _to, uint256 _value) isFreeze returns (bool) {
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153  
154   function balanceOf(address _owner) constant returns (uint256 balance) {
155     return balances[_owner];
156   }
157  
158 }
159 
160 contract Migrations {
161   address public owner;
162   uint public last_completed_migration;
163 
164   modifier restricted() {
165     if (msg.sender == owner) _;
166   }
167 
168   function Migrations() {
169     owner = msg.sender;
170   }
171 
172   function setCompleted(uint completed) restricted {
173     last_completed_migration = completed;
174   }
175 
176   function upgrade(address new_address) restricted {
177     Migrations upgraded = Migrations(new_address);
178     upgraded.setCompleted(last_completed_migration);
179   }
180 }
181 
182 contract StandardToken is ERC20, BasicToken {
183  
184   mapping (address => mapping (address => uint256)) allowed;
185 
186   //14.10.2017 23:59 UTC
187   uint256 ico_finish = 1508025540;
188 
189   modifier isFreeze() {
190     if(now < ico_finish) {
191       revert();
192     }
193     _;
194   }
195  
196   function transferFrom(address _from, address _to, uint256 _value) isFreeze returns (bool) {
197     var _allowance = allowed[_from][msg.sender];
198  
199     balances[_to] = balances[_to].add(_value);
200     balances[_from] = balances[_from].sub(_value);
201     allowed[_from][msg.sender] = _allowance.sub(_value);
202     Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   function approve(address _spender, uint256 _value) returns (bool) {
207  
208     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
209  
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   function approve(address _owner, address _spender, uint256 _value) returns (bool) {
216  
217     allowed[_owner][_spender] = _value;
218     Approval(_owner, _spender, _value);
219     return true;
220   }
221  
222   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
223     return allowed[_owner][_spender];
224   }
225  
226 }
227 
228 contract MintableToken is StandardToken, Ownable {
229 
230   using SafeMath for uint256;
231 
232   event Mint(address indexed to, uint256 amount);
233 
234   event MintFinished();
235 
236   event ShowInfo(uint256 _info, string _message);
237 
238   function setTotalSupply(uint256 _amount) public onlyOwner returns(uint256) {
239     totalSupply = _amount;
240     return totalSupply;
241   }
242 
243   function getTotalTokenCount() public constant returns(uint256) {
244     return totalSupply;
245   }
246   
247   function mint(address _address, uint256 _tokens) public {
248 
249     Mint(_address, _tokens);
250 
251     balances[_address] = balances[_address].add(_tokens);
252   }
253 
254   function burnTokens(address _address) public {
255     balances[_address] = 0;
256     totalSupply = 0;
257   }
258 
259 }
260 
261 contract SingleTokenCoin is MintableToken {
262     
263     string public constant name = "Start mining";
264     
265     string public constant symbol = "STM";
266     
267     uint32 public constant decimals = 2;
268     
269 }
270 
271 // ---------ALERT---------
272 // Before deploy to Main Net uncomment all *ADDRESSES FOR PRODUCTION* comment 
273 // Before deploy to Main Net change rinkeby.etherscan.io to etherscan.io 
274 // Before deploy to Main Net check all ICO dates in all .sol files
275 // Before deploy to Main Net check all Comment in .sol and .js files
276 // Before deploy to Main Net check all code area with '* 100' & '/ 100' for .js files
277 
278 //----------CHECK----------
279 //Get back tokens
280 //Resetup condition with mincup
281 //Resetup withdrow
282 //Resetup send ETH to investors
283 //Recalculate rate with oraclize
284 
285 contract WrapperOraclize {
286     function update(string datasource, string arg) payable;
287     function update(uint timestamp, string datasource, string arg) payable;
288     function getWrapperBalance() constant returns(uint256);
289     function getWrapperData() constant returns(bytes32);
290     function getPrice(string datasource) constant returns(uint256);
291     function() external payable;
292 }
293 
294 contract Crowdsale is Ownable {
295 
296   string public ETHUSD;
297 
298   event ShowPrice(string price);
299 
300     using SafeMath for uint256;
301 
302     SingleTokenCoin public token = new SingleTokenCoin();
303 
304     Addresses private addresses = new Addresses();
305 
306     WrapperOraclize private wrapper = WrapperOraclize(0xfC484c66daE464CC6055d7a4782Ec8761dc9842F);
307 
308     uint256 private ico_start;
309     uint256 private ico_finish;
310 
311     uint256 private rate;
312 
313     uint256 private decimals;
314 
315     uint256 private tax;
316 
317     //Time-based Bonus Program
318     uint256 private firstBonusPhase;
319     uint256 private firstExtraBonus;
320 
321     uint256 private secondBonusPhase;
322     uint256 private secondExtraBonus;
323 
324     uint256 private thirdBonusPhase;
325     uint256 private thirdExtraBonus;
326 
327     uint256 private fourBonusPhase;
328     uint256 private fourExtraBonus;
329 
330     //Withdrow Phases
331     bool private firstWithdrowPhase;
332     bool private secondWithdrowPhase;
333     bool private thirdWithdrowPhase;
334     bool private fourWithdrowPhase;
335 
336     uint256 private firstWithdrowAmount;
337     uint256 private secondWithdrowAmount;
338     uint256 private thirdWithdrowAmount;
339     uint256 private fourWithdrowAmount;
340 
341     uint256 private totalETH;
342 
343     uint256 private totalAmount;
344 
345     bool private initialize = false;
346     
347     bool public mintingFinished = false;
348 
349     //Storage for ICO Buyers ETH
350     mapping(address => uint256) private ico_buyers_eth;
351 
352     //Storage for ICO Buyers Token
353     mapping(address => uint256) private ico_buyers_token;
354 
355     address[] private investors;
356 
357     mapping(address => bytes32) private privilegedWallets;
358     mapping(address => uint256) private manualAddresses;
359 
360     address[] private manualAddressesCount;
361 
362     address[] private privilegedWalletsCount;
363 
364     bytes32 private g = "granted";
365 
366     bytes32 private r = "revorked";
367 
368     uint256 private soldTokens;
369     uint256 private mincup;
370 
371     uint256 private minPrice;
372 
373     event ShowInfo(uint256 _info);
374     event ShowInfoStr(string _info);
375     event ShowInfoBool(bool _info);
376 
377     function Crowdsale() {
378 
379       //set calculate rate from USD
380       rate = 3546099290780141; //0.0003 ETH //temp
381 
382       decimals = 35460992907801; // 0.0000003 ETH // 2 decimals
383 
384       tax = 36000000000000000; //tax && minimum price ~10$
385 
386       //minPrice = decimals + tax; // ~10$
387 
388       //18.09.2017 15:00 UTC (1505746800)
389       ico_start = 1505746800;
390 
391       //17.10.2017 23:59 UTC (1508284740)
392       ico_finish = 1508284740;
393 
394       totalAmount = 1020000000;
395 
396       // 500 000 STM with 2 decimals
397       mincup = 50000000;
398       
399       mintingFinished = false;
400 
401       setTotalSupply();
402 
403       //Time-Based Bonus Phase
404       firstBonusPhase = ico_start.add(24 hours);
405       firstExtraBonus = 25;
406 
407       secondBonusPhase = ico_start.add(168 hours);
408       secondExtraBonus = 15;
409 
410       thirdBonusPhase = ico_start.add(336 hours);
411       thirdExtraBonus = 10;
412 
413       fourBonusPhase = ico_start.add(480 hours);
414       fourExtraBonus = 5;
415 
416       //Withdrow Phases
417       firstWithdrowPhase = false;
418       secondWithdrowPhase = false;
419       thirdWithdrowPhase = false;
420       fourWithdrowPhase = false;
421 
422       firstWithdrowAmount = 50000000;
423       secondWithdrowAmount = 200000000;
424       thirdWithdrowAmount = 500000000;
425       fourWithdrowAmount = 1020000000;
426 
427       totalETH = 0;
428 
429       soldTokens = 0;
430 
431       privilegedWalletsCount.push(msg.sender);
432       privilegedWallets[msg.sender] = g;
433 
434     }
435 
436       modifier canMint() {
437         require(!mintingFinished);
438         _;
439       }
440 
441     function() external payable {
442       mint();
443     }
444 
445   function bytesToUInt(bytes32 v) constant returns (uint ret) {
446         if (v == 0x0) {
447             revert();
448         }
449 
450         uint digit;
451 
452         for (uint i = 0; i < 32; i++) {
453             digit = uint((uint(v) / (2 ** (8 * (31 - i)))) & 0xff);
454             if (digit == 0 || digit == 46) {
455                 break;
456             }
457             else if (digit < 48 || digit > 57) {
458                 revert();
459             }
460             ret *= 10;
461             ret += (digit - 48);
462         }
463         return ret;
464     }
465 
466   function calculateRate() public payable returns(uint256) {
467     bytes32 result = getWrapperData();
468     uint256 usd = bytesToUInt(result);
469 
470     uint256 price = 1 ether / usd; //price for 1 STM
471 
472     return price;
473   }
474 
475     function calculateWithdrow() private {
476       if (!firstWithdrowPhase && soldTokens >= firstWithdrowAmount && soldTokens < secondWithdrowAmount) {
477         sendToOwners(this.balance);
478       } else {
479         if (!secondWithdrowPhase && soldTokens >= secondWithdrowAmount && soldTokens < thirdWithdrowAmount) {
480           sendToOwners(this.balance);
481         } else {
482           if (!thirdWithdrowPhase && soldTokens >= thirdWithdrowAmount && soldTokens < fourWithdrowAmount) {
483             sendToOwners(this.balance);
484           } else {
485             if (!fourWithdrowPhase && soldTokens >= fourWithdrowAmount) {
486               sendToOwners(this.balance);
487             }
488           }
489         }
490       }
491     }
492 
493     modifier isInitialize() {
494       require(!initialize);
495       _;
496     }
497 
498     function setTotalSupply() private isInitialize onlyOwner returns(uint256) {
499       initialize = true;
500       return token.setTotalSupply(totalAmount);
501     }
502 
503     function sendToAddress(address _address, uint256 _tokens) canMint public {
504 
505       if (grantedWallets(msg.sender) == false) {
506         revert();      
507       }
508 
509       ShowInfo(_tokens);
510 
511       uint256 currentTokens = _tokens;
512 
513       uint256 timeBonus = calculateBonusForHours(currentTokens);
514 
515       uint256 allTokens = currentTokens.add(timeBonus);   
516 
517       token.approve(_address, this, allTokens);      
518 
519       saveInfoAboutInvestors(_address, 0, allTokens, true);         
520 
521       token.mint(_address, allTokens);
522 
523       soldTokens = soldTokens + allTokens;
524       calculateWithdrow();
525     }
526 
527     modifier isRefund() {
528       if (msg.value < tax) {
529         refund(msg.value);
530         revert();
531       }
532       _;
533     }
534 
535     function grantedWallets(address _address) private returns(bool) {
536       if (privilegedWallets[_address] == g) {
537         return true;
538       }
539       return false;
540     }
541 
542     modifier isICOFinished() {
543       if (now > ico_finish) {
544         finishMinting();
545         refund(msg.value);
546         revert();
547       }
548       _;
549     }
550 
551     function getTokens() public constant returns(uint256) {
552       token.getTotalTokenCount();
553     }
554 
555     function setPrivelegedWallet(address _address) public onlyOwner returns(bool) {
556       if (privilegedWalletsCount.length == 2) {
557         revert();
558       }
559 
560       if (privilegedWallets[_address] != g && privilegedWallets[_address] != r) {
561         privilegedWalletsCount.push(_address);
562       }
563 
564       privilegedWallets[_address] = g;
565 
566       return true;
567     }
568 
569     function setTransferOwnership(address _address) public onlyOwner {
570 
571       removePrivelegedWallet(msg.sender);
572       setPrivelegedWallet(_address);
573 
574       transferOwnership(_address);
575     }
576 
577     function removePrivelegedWallet(address _address) public onlyOwner {
578       if (privilegedWallets[_address] == g) {
579         privilegedWallets[_address] = r;
580         delete privilegedWalletsCount[0];
581       } else {
582         revert();
583       }
584     }
585 
586     //only for demonstrate Test Version
587     function setICODate(uint256 _time) public onlyOwner {
588       ico_start = _time;
589       ShowInfo(_time);
590     }
591 
592     function getICODate() public constant returns(uint256) {
593       return ico_start;
594     }
595 
596     function mint() public isRefund canMint isICOFinished payable {
597 
598       rate = calculateRate();
599 
600       decimals = rate / 100; //price for 0.01 STM
601 
602       uint256 remainder = msg.value.mod(decimals);
603 
604       uint256 eth = msg.value.sub(remainder);
605 
606       if (remainder != 0) {
607         refund(remainder);
608       }
609 
610       totalETH = totalETH + eth;
611 
612       uint currentRate = rate / 100; //2 decimals
613 
614       uint256 tokens = eth.div(currentRate);
615       uint256 timeBonus = calculateBonusForHours(tokens);
616 
617       uint256 allTokens = tokens.add(timeBonus) + 100; // +100 - oraclize Tax
618 
619       saveInfoAboutInvestors(msg.sender, eth, allTokens, false);
620 
621       token.mint(msg.sender, allTokens);
622 
623       soldTokens = soldTokens + allTokens;
624       calculateWithdrow();
625     }
626 
627     function saveInfoAboutInvestors(address _address, uint256 _amount, uint256 _tokens, bool _isManual) private {
628 
629       if (!_isManual) {
630         if (ico_buyers_token[_address] == 0) {
631           investors.push(_address);
632         }
633 
634         // Store ETH of Investor
635         ico_buyers_eth[_address] = ico_buyers_eth[_address].add(_amount);
636 
637         // Store Token of Investor
638         ico_buyers_token[_address] = ico_buyers_token[_address].add(_tokens);
639       
640       } else {
641         if(manualAddresses[_address] == 0) {
642           manualAddressesCount.push(_address);
643         }
644 
645         manualAddresses[_address] = manualAddresses[_address].add(_tokens);
646       }
647     }
648 
649     function getManualByAddress(address _address) public constant returns(uint256) {
650       return manualAddresses[_address];
651     }
652 
653     function getManualInvestorsCount() public constant returns(uint256) {
654       return manualAddressesCount.length;
655     }
656 
657     function getManualAddress(uint _index) public constant returns(address) {
658       return manualAddressesCount[_index];
659     }
660 
661     function finishMinting() public onlyOwner {
662       if(mintingFinished) {
663         revert();
664       }
665 
666       ShowInfoBool(mintingFinished);
667       mintingFinished = true;
668       ShowInfoBool(mintingFinished);
669       
670       if (soldTokens < mincup) {
671         if(investors.length != 0) {
672           for (uint256 i=0; i < investors.length; i++) {
673             address addr = investors[i];          
674             token.burnTokens(addr);
675           }
676         }
677         
678         if(manualAddressesCount.length != 0) {
679           for (uint256 j=0; j < manualAddressesCount.length; j++) {
680             address manualAddr = manualAddressesCount[j];
681             token.burnTokens(manualAddr);
682           }
683         }
684       }
685     }
686 
687     function getFinishStatus() public constant returns(bool) {
688       return mintingFinished;
689     }
690 
691     function manualRefund() public {
692       if (mintingFinished) {
693         if(ico_buyers_eth[msg.sender] != 0) {
694           uint256 amount = ico_buyers_eth[msg.sender];
695           msg.sender.transfer(amount);
696           ico_buyers_eth[msg.sender] = 0;
697         } else {
698           revert();
699         }
700       } else {
701         revert();
702       }
703       
704     }
705 
706     function refund(uint256 _amount) private {
707       msg.sender.transfer(_amount);
708     }
709 
710     function refund(address _address, uint256 _amount) private {
711       _address.transfer(_amount);
712     }
713 
714     function getTokensManual(address _address) public constant returns(uint256) {
715       return manualAddresses[_address];
716     }
717 
718     function calculateBonusForHours(uint256 _tokens) private returns(uint256) {
719 
720       //Calculate for first bonus program
721       if (now >= ico_start && now <= firstBonusPhase ) {
722         return _tokens.mul(firstExtraBonus).div(100);
723       }
724 
725       //Calculate for second bonus program
726       if (now > firstBonusPhase && now <= secondBonusPhase ) {
727         return _tokens.mul(secondExtraBonus).div(100);
728       }
729 
730       //Calculate for third bonus program
731       if (now > secondBonusPhase && now <= thirdBonusPhase ) {
732         return _tokens.mul(thirdExtraBonus).div(100);
733       }
734 
735       //Calculate for four bonus program
736       if (now > thirdBonusPhase && now <= fourBonusPhase ) {
737         return _tokens.mul(fourExtraBonus).div(100);
738       }
739 
740       return 0;
741     }
742 
743     function sendToOwners(uint256 _amount) private {
744       uint256 twoPercent = _amount.mul(2).div(100);
745       uint256 fivePercent = _amount.mul(5).div(100);
746       uint256 nineThreePercent = _amount.mul(93).div(100);
747 
748 // ----------ADDRESSES FOR PRODUCTION-------------
749 
750       //NineThree Percent
751       addresses.addr1().transfer(nineThreePercent);
752       addresses.addr2().transfer(nineThreePercent);
753       addresses.addr3().transfer(nineThreePercent);
754       addresses.addr4().transfer(nineThreePercent);
755 
756       if (!firstWithdrowPhase) {
757         addresses.addr1().transfer(nineThreePercent);
758         firstWithdrowPhase = true;
759       } else {
760         if (!secondWithdrowPhase) {
761           addresses.addr2().transfer(nineThreePercent);   
762           secondWithdrowPhase = true;       
763         } else {
764           if (!thirdWithdrowPhase) {
765             addresses.addr3().transfer(nineThreePercent);
766             thirdWithdrowPhase = true;                
767           } else {
768             if (!fourWithdrowPhase) {
769               addresses.addr4().transfer(nineThreePercent);
770               fourWithdrowPhase = true;                      
771             }
772           }
773         }
774       }
775 
776 
777       //Five Percent
778       addresses.successFee().transfer(fivePercent);
779       
780       //Two Percent
781       addresses.bounty().transfer(twoPercent);
782       
783     }
784 
785     function getBalanceContract() public constant returns(uint256) {
786       return this.balance;
787     }
788 
789     function getSoldToken() public constant returns(uint256) {
790       return soldTokens;
791     }
792 
793     function getInvestorsTokens(address _address) public constant returns(uint256) {
794       return ico_buyers_token[_address];
795     }
796 
797     function getInvestorsETH(address _address) public constant returns(uint256) {
798       return ico_buyers_eth[_address];
799     }
800 
801     function getInvestors() public constant returns(uint256) {
802       return investors.length;
803     }
804 
805     function getInvestorByValue(address _address) public constant returns(uint256) {
806       return ico_buyers_eth[_address];
807     }
808 
809     //only for test version
810     function transfer(address _from, address _to, uint256 _amount) public returns(bool) {
811       return token.transferFrom(_from, _to, _amount);
812     }
813 
814     function getInvestorByIndex(uint256 _index) public constant returns(address) {
815       return investors[_index];
816     }
817 
818     function getLeftToken() public constant returns(uint256) {
819       if(token.totalSupply() != 0) {
820         return token.totalSupply() - soldTokens;
821       } else {
822         return soldTokens;
823       }
824     }
825 
826     function getTotalToken() public constant returns(uint256) {
827       return token.totalSupply();
828     }
829 
830     function getTotalETH() public constant returns(uint256) {
831       return totalETH;
832     }
833 
834     function getCurrentPrice() public constant returns(uint256) {
835       
836       uint256 secondDiscount = calculateBonusForHours(rate);
837 
838       uint256 investorDiscount = rate.sub(secondDiscount);
839 
840       return investorDiscount * 10; //minimum 10$ //~10STM
841     }
842 
843     function getContractAddress() public constant returns(address) {
844       return this;
845     }
846 
847     function getOwner() public constant returns(address) {
848       return owner;
849     }
850 
851     function sendOracleData() public payable {
852         if (msg.value != 0) {
853             wrapper.transfer(msg.value);
854         }
855       
856       wrapper.update("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
857     }
858 
859     function getQueryPrice(string datasource) constant returns(uint256) {
860       return wrapper.getPrice(datasource);
861     }
862 
863     function checkWrapperBalance() public constant returns(uint256) {
864       return wrapper.getWrapperBalance();
865     }
866 
867     function getWrapperData() constant returns(bytes32) {
868       return wrapper.getWrapperData();
869     }
870 }