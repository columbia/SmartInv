1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4 
5   function balanceOf(address who) public constant returns (uint256);
6 
7   function transfer(address to, uint256 value) public returns (bool);
8 
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 
11 }
12 
13 contract ERC20 is ERC20Basic {
14 
15   function allowance(address owner, address spender) public constant returns (uint256);
16 
17   function transferFrom(address from, address to, uint256 value) public returns (bool);
18 
19   function approve(address spender, uint256 value) public returns (bool);
20 
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23 }
24 
25 contract ERC223 is ERC20 {
26 
27 
28 
29     function name() constant returns (string _name);
30 
31     function symbol() constant returns (string _symbol);
32 
33     function decimals() constant returns (uint8 _decimals);
34 
35 
36 
37     function transfer(address to, uint256 value, bytes data) returns (bool);
38 
39 
40 
41 }
42 
43 contract ERC223ReceivingContract {
44 
45     function tokenFallback(address _from, uint256 _value, bytes _data);
46 
47 }
48 
49 contract KnowledgeTokenInterface is ERC223{
50 
51     event Mint(address indexed to, uint256 amount);
52 
53 
54 
55     function changeMinter(address newAddress) returns (bool);
56 
57     function mint(address _to, uint256 _amount) returns (bool);
58 
59 }
60 
61 contract Ownable {
62 
63   address public owner;
64 
65 
66 
67 
68 
69   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71 
72 
73 
74 
75   /**
76 
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78 
79    * account.
80 
81    */
82 
83   function Ownable() {
84 
85     owner = msg.sender;
86 
87   }
88 
89 
90 
91 
92 
93   /**
94 
95    * @dev Throws if called by any account other than the owner.
96 
97    */
98 
99   modifier onlyOwner() {
100 
101     require(msg.sender == owner);
102 
103     _;
104 
105   }
106 
107 
108 
109 
110 
111   /**
112 
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114 
115    * @param newOwner The address to transfer ownership to.
116 
117    */
118 
119   function transferOwnership(address newOwner) onlyOwner public {
120 
121     require(newOwner != address(0));
122 
123     OwnershipTransferred(owner, newOwner);
124 
125     owner = newOwner;
126 
127   }
128 
129 
130 
131 }
132 
133 library SafeMath {
134 
135   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
136 
137     uint256 c = a * b;
138 
139     assert(a == 0 || c / a == b);
140 
141     return c;
142 
143   }
144 
145 
146 
147   function div(uint256 a, uint256 b) internal constant returns (uint256) {
148 
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150 
151     uint256 c = a / b;
152 
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155     return c;
156 
157   }
158 
159 
160 
161   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
162 
163     assert(b <= a);
164 
165     return a - b;
166 
167   }
168 
169 
170 
171   function add(uint256 a, uint256 b) internal constant returns (uint256) {
172 
173     uint256 c = a + b;
174 
175     assert(c >= a);
176 
177     return c;
178 
179   }
180 
181 }
182 
183 contract WitcoinCrowdsale is Ownable {
184 
185     using SafeMath for uint256;
186 
187 
188 
189     // The token being sold
190 
191     WitCoin public token;
192 
193 
194 
195     // refund vault used to hold funds while crowdsale is running
196 
197     RefundVault public vault;
198 
199 
200 
201     // minimum amount of tokens to be issued
202 
203     uint256 public goal;
204 
205 
206 
207     // start and end timestamps where investments are allowed (both inclusive)
208 
209     uint256 public startTime;
210 
211     uint256 public startPresale;
212 
213     uint256 public endTime;
214 
215     uint256 public endRefundingingTime;
216 
217 
218 
219     // address where funds are collected
220 
221     address public wallet;
222 
223 
224 
225     // how many token units a buyer gets per ether
226 
227     uint256 public rate;
228 
229 
230 
231     // amount of raised money in wei
232 
233     uint256 public weiRaised;
234 
235 
236 
237     // amount of tokens sold
238 
239     uint256 public tokensSold;
240 
241 
242 
243     // amount of tokens distributed
244 
245     uint256 public tokensDistributed;
246 
247 
248 
249     // token decimals
250 
251     uint256 public decimals;
252 
253 
254 
255     // total of tokens sold in the presale time
256 
257     uint256 public totalTokensPresale;
258 
259 
260 
261     // total of tokens sold in the sale time (includes presale)
262 
263     uint256 public totalTokensSale;
264 
265 
266 
267     // minimum amount of witcoins bought
268 
269     uint256 public minimumWitcoins;
270 
271 
272 
273     /**
274 
275      * event for token purchase logging
276 
277      * @param purchaser who paid for the tokens
278 
279      * @param beneficiary who got the tokens
280 
281      * @param value weis paid for purchase
282 
283      * @param amount amount of tokens purchased
284 
285      */
286 
287     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
288 
289 
290 
291     function WitcoinCrowdsale(address witAddress, address receiver) {
292 
293         token = WitCoin(witAddress);
294 
295         decimals = token.decimals();
296 
297         startTime = 1508137200; // 1508137200 = 2017-10-16 07:00:00 GMT
298 
299         startPresale = 1507618800; // 1507618800 = 2017-10-10 07:00:00 GMT
300 
301         endTime = 1509973200; // 2017-11-06 13:00:00 GMT
302 
303         endRefundingingTime = 1527840776; // 01/06/2018
304 
305         rate = 880; // 1 ether = 880 witcoins
306 
307         wallet = receiver;
308 
309         goal = 1000000 * (10 ** decimals); // 1M witcoins
310 
311 
312 
313         totalTokensPresale = 1000000 * (10 ** decimals) * 65 / 100; // 65% of 1M witcoins
314 
315         totalTokensSale = 8000000 * (10 ** decimals) * 65 / 100; // 65% of 8M witcoins
316 
317         minimumWitcoins = 100 * (10 ** decimals); // 100 witcoins
318 
319         tokensDistributed = 0;
320 
321 
322 
323         vault = new RefundVault(wallet);
324 
325     }
326 
327 
328 
329     // fallback function to buy tokens
330 
331     function () payable {
332 
333         buyTokens(msg.sender);
334 
335     }
336 
337 
338 
339     // main token purchase function
340 
341     function buyTokens(address beneficiary) public payable {
342 
343         require(beneficiary != 0x0);
344 
345 
346 
347         uint256 weiAmount = msg.value;
348 
349 
350 
351         // calculate token amount to be created
352 
353         uint256 tokens = weiAmount.mul(rate)/1000000000000000000;
354 
355         tokens = tokens * (10 ** decimals);
356 
357 
358 
359         // calculate bonus
360 
361         tokens = calculateBonus(tokens);
362 
363 
364 
365         require(validPurchase(tokens));
366 
367 
368 
369         // update state
370 
371         weiRaised = weiRaised.add(weiAmount);
372 
373         tokensSold = tokensSold.add(tokens);
374 
375 
376 
377         token.mint(beneficiary, tokens);
378 
379         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
380 
381 
382 
383         forwardFunds();
384 
385     }
386 
387 
388 
389     // altercoin token purchase function
390 
391     function buyTokensAltercoins(address beneficiary, uint256 tokens) onlyOwner public {
392 
393         require(beneficiary != 0x0);
394 
395 
396 
397         // calculate bonus
398 
399         uint256 tokensBonused = calculateBonus(tokens);
400 
401 
402 
403         require(validPurchase(tokensBonused));
404 
405 
406 
407         // update state
408 
409         tokensSold = tokensSold.add(tokensBonused);
410 
411 
412 
413         token.mint(beneficiary, tokensBonused);
414 
415         TokenPurchase(msg.sender, beneficiary, 0, tokensBonused);
416 
417     }
418 
419 
420 
421     // send the ether to the fund collection wallet
422 
423     function forwardFunds() internal {
424 
425         vault.deposit.value(msg.value)(msg.sender);
426 
427     }
428 
429 
430 
431     // number of tokens issued after applying presale and sale bonuses
432 
433     function calculateBonus(uint256 tokens) internal returns (uint256) {
434 
435         uint256 bonusedTokens = tokens;
436 
437 
438 
439         // Pre-Sale Bonus
440 
441         if (presale()) {
442 
443             if (tokensSold <= 250000 * (10 ** decimals)) bonusedTokens = bonusedTokens.mul(130)/100;
444 
445             else if (tokensSold <= 500000 * (10 ** decimals)) bonusedTokens = bonusedTokens.mul(125)/100;
446 
447             else if (tokensSold <= 750000 * (10 ** decimals)) bonusedTokens = bonusedTokens.mul(120)/100;
448 
449             else if (tokensSold <= 1000000 * (10 ** decimals)) bonusedTokens = bonusedTokens.mul(115)/100;
450 
451         }
452 
453 
454 
455         // Sale Bonus
456 
457         if (sale()) {
458 
459             if (bonusedTokens > 2500 * (10 ** decimals)) {
460 
461                 if (bonusedTokens <= 80000 * (10 ** decimals)) bonusedTokens = bonusedTokens.mul(105)/100;
462 
463                 else if (bonusedTokens <= 800000 * (10 ** decimals)) bonusedTokens = bonusedTokens.mul(110)/100;
464 
465                 else if (bonusedTokens > 800000 * (10 ** decimals)) bonusedTokens = bonusedTokens.mul(120)/100;
466 
467             }
468 
469         }
470 
471 
472 
473         return bonusedTokens;
474 
475     }
476 
477 
478 
479     // presale and sale constraints
480 
481     function validPurchase(uint256 tokens) internal returns (bool) {
482 
483         bool withinPeriod = presale() || sale();
484 
485         bool underLimits = (presale() && tokensSold + tokens <= totalTokensPresale) || (sale() && tokensSold + tokens <= totalTokensSale);
486 
487         bool overMinimum = tokens >= minimumWitcoins;
488 
489         return withinPeriod && underLimits && overMinimum;
490 
491     }
492 
493 
494 
495     function validPurchaseBonus(uint256 tokens) public returns (bool) {
496 
497         uint256 bonusedTokens = calculateBonus(tokens);
498 
499         return validPurchase(bonusedTokens);
500 
501     }
502 
503 
504 
505     // is presale time?
506 
507     function presale() public returns(bool) {
508 
509         return now >= startPresale && now < startTime;
510 
511     }
512 
513 
514 
515     // is sale time?
516 
517     function sale() public returns(bool) {
518 
519         return now >= startTime && now <= endTime;
520 
521     }
522 
523 
524 
525     // finalize crowdsale
526 
527     function finalize() onlyOwner public {
528 
529         require(now > endTime);
530 
531 
532 
533         if (tokensSold < goal) {
534 
535             vault.enableRefunds();
536 
537         } else {
538 
539             vault.close();
540 
541         }
542 
543     }
544 
545 
546 
547     function finalized() public returns(bool) {
548 
549         return vault.finalized();
550 
551     }
552 
553 
554 
555     // if crowdsale is unsuccessful, investors can claim refunds here
556 
557     function claimRefund() public returns(bool) {
558 
559         vault.refund(msg.sender);
560 
561     }
562 
563 
564 
565     function finalizeRefunding() onlyOwner public {
566 
567         require(now > endRefundingingTime);
568 
569 
570 
571         vault.finalizeEnableRefunds();
572 
573     }
574 
575 
576 
577     // Distribute tokens, only when goal reached
578 
579     // As written in https://witcoin.io:
580 
581     //   1%  bounties
582 
583     //   5%  nir-vana platform
584 
585     //   10% Team
586 
587     //   19% Witcoin.club
588 
589     function distributeTokens() onlyOwner public {
590 
591         require(tokensSold >= goal);
592 
593         require(tokensSold - tokensDistributed > 100);
594 
595 
596 
597         uint256 toDistribute = tokensSold - tokensDistributed;
598 
599 
600 
601         address bounties = 0x057Afd5422524d5Ca20218d07048300832323360;
602 
603         address nirvana = 0x094d57AdaBa2278de6D1f3e2F975f14248C3775F;
604 
605         address team = 0x7eC9d37163F4F1D1fD7E92B79B73d910088Aa2e7;
606 
607         address club = 0xb2c032aF1336A1482eB2FE1815Ef301A2ea4fE0A;
608 
609 
610 
611         uint256 bTokens = toDistribute * 1 / 65;
612 
613         uint256 nTokens = toDistribute * 5 / 65;
614 
615         uint256 tTokens = toDistribute * 10 / 65;
616 
617         uint256 cTokens = toDistribute * 19 / 65;
618 
619 
620 
621         token.mint(bounties, bTokens);
622 
623         token.mint(nirvana, nTokens);
624 
625         token.mint(team, tTokens);
626 
627         token.mint(club, cTokens);
628 
629 
630 
631         tokensDistributed = tokensDistributed.add(toDistribute);
632 
633     }
634 
635 
636 
637 }
638 
639 contract RefundVault is Ownable {
640 
641   using SafeMath for uint256;
642 
643 
644 
645   enum State { Active, Refunding, Closed }
646 
647 
648 
649   mapping (address => uint256) public deposited;
650 
651   address public wallet;
652 
653   State public state;
654 
655 
656 
657   event Closed();
658 
659   event RefundsEnabled();
660 
661   event Refunded(address indexed beneficiary, uint256 weiAmount);
662 
663 
664 
665   function RefundVault(address _wallet) {
666 
667     require(_wallet != 0x0);
668 
669 
670 
671     wallet = _wallet;
672 
673     state = State.Active;
674 
675   }
676 
677 
678 
679   function deposit(address investor) onlyOwner public payable {
680 
681     require(state == State.Active);
682 
683     deposited[investor] = deposited[investor].add(msg.value);
684 
685   }
686 
687 
688 
689   function close() onlyOwner public {
690 
691     require(state == State.Active);
692 
693 
694 
695     state = State.Closed;
696 
697     Closed();
698 
699     wallet.transfer(this.balance);
700 
701   }
702 
703 
704 
705   function enableRefunds() onlyOwner public {
706 
707     require(state == State.Active);
708 
709 
710 
711     state = State.Refunding;
712 
713     RefundsEnabled();
714 
715   }
716 
717 
718 
719   function finalizeEnableRefunds() onlyOwner public {
720 
721     require(state == State.Refunding);
722 
723     state = State.Closed;
724 
725     Closed();
726 
727     wallet.transfer(this.balance);
728 
729   }
730 
731 
732 
733   function refund(address investor) onlyOwner public {
734 
735     require(state == State.Refunding);
736 
737 
738 
739     uint256 depositedValue = deposited[investor];
740 
741     deposited[investor] = 0;
742 
743     investor.transfer(depositedValue);
744 
745     Refunded(investor, depositedValue);
746 
747   }
748 
749 
750 
751   function finalized() public returns(bool) {
752 
753     return state != State.Active;
754 
755   }
756 
757 }
758 
759 contract ERC20BasicToken is ERC20Basic {
760 
761   using SafeMath for uint256;
762 
763 
764 
765   mapping(address => uint256) balances;
766 
767   uint256 public totalSupply;
768 
769 
770 
771   /**
772 
773   * @dev transfer token for a specified address
774 
775   * @param _to The address to transfer to.
776 
777   * @param _value The amount to be transferred.
778 
779   */
780 
781   function transfer(address _to, uint256 _value) public returns (bool) {
782 
783     require(_to != address(0));
784 
785 
786 
787     // SafeMath.sub will throw if there is not enough balance.
788 
789     balances[msg.sender] = balances[msg.sender].sub(_value);
790 
791     balances[_to] = balances[_to].add(_value);
792 
793     Transfer(msg.sender, _to, _value);
794 
795     return true;
796 
797   }
798 
799 
800 
801   /**
802 
803   * @dev Gets the balance of the specified address.
804 
805   * @param _owner The address to query the the balance of.
806 
807   * @return An uint256 representing the amount owned by the passed address.
808 
809   */
810 
811   function balanceOf(address _owner) public constant returns (uint256 balance) {
812 
813     return balances[_owner];
814 
815   }
816 
817 
818 
819   function totalSupply() constant returns (uint256 _totalSupply) {
820 
821     return totalSupply;
822 
823   }
824 
825 
826 
827 }
828 
829 contract ERC20Token is ERC20, ERC20BasicToken {
830 
831 
832 
833   mapping (address => mapping (address => uint256)) allowed;
834 
835 
836 
837   /**
838 
839    * @dev Transfer tokens from one address to another
840 
841    * @param _from address The address which you want to send tokens from
842 
843    * @param _to address The address which you want to transfer to
844 
845    * @param _value uint256 the amount of tokens to be transferred
846 
847    */
848 
849   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
850 
851     require(_to != address(0));
852 
853 
854 
855     uint256 _allowance = allowed[_from][msg.sender];
856 
857 
858 
859     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
860 
861     // require (_value <= _allowance);
862 
863 
864 
865     balances[_from] = balances[_from].sub(_value);
866 
867     balances[_to] = balances[_to].add(_value);
868 
869     allowed[_from][msg.sender] = _allowance.sub(_value);
870 
871     Transfer(_from, _to, _value);
872 
873     return true;
874 
875   }
876 
877 
878 
879   /**
880 
881    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
882 
883    *
884 
885    * Beware that changing an allowance with this method brings the risk that someone may use both the old
886 
887    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
888 
889    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
890 
891    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
892 
893    * @param _spender The address which will spend the funds.
894 
895    * @param _value The amount of tokens to be spent.
896 
897    */
898 
899   function approve(address _spender, uint256 _value) public returns (bool) {
900 
901     allowed[msg.sender][_spender] = _value;
902 
903     Approval(msg.sender, _spender, _value);
904 
905     return true;
906 
907   }
908 
909 
910 
911   /**
912 
913    * @dev Function to check the amount of tokens that an owner allowed to a spender.
914 
915    * @param _owner address The address which owns the funds.
916 
917    * @param _spender address The address which will spend the funds.
918 
919    * @return A uint256 specifying the amount of tokens still available for the spender.
920 
921    */
922 
923   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
924 
925     return allowed[_owner][_spender];
926 
927   }
928 
929 
930 
931   /**
932 
933    * approve should be called when allowed[_spender] == 0. To increment
934 
935    * allowed value is better to use this function to avoid 2 calls (and wait until
936 
937    * the first transaction is mined)
938 
939    * From MonolithDAO Token.sol
940 
941    */
942 
943   function increaseApproval (address _spender, uint _addedValue)
944 
945     returns (bool success) {
946 
947     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
948 
949     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
950 
951     return true;
952 
953   }
954 
955 
956 
957   function decreaseApproval (address _spender, uint _subtractedValue)
958 
959     returns (bool success) {
960 
961     uint oldValue = allowed[msg.sender][_spender];
962 
963     if (_subtractedValue > oldValue) {
964 
965       allowed[msg.sender][_spender] = 0;
966 
967     } else {
968 
969       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
970 
971     }
972 
973     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
974 
975     return true;
976 
977   }
978 
979 
980 
981 }
982 
983 contract ERC223Token is ERC223, ERC20Token {
984 
985     using SafeMath for uint256;
986 
987 
988 
989     string public name;
990 
991 
992 
993     string public symbol;
994 
995 
996 
997     uint8 public decimals;
998 
999 
1000 
1001 
1002 
1003     // Function to access name of token .
1004 
1005     function name() constant returns (string _name) {
1006 
1007         return name;
1008 
1009     }
1010 
1011     // Function to access symbol of token .
1012 
1013     function symbol() constant returns (string _symbol) {
1014 
1015         return symbol;
1016 
1017     }
1018 
1019     // Function to access decimals of token .
1020 
1021     function decimals() constant returns (uint8 _decimals) {
1022 
1023         return decimals;
1024 
1025     }
1026 
1027 
1028 
1029 
1030 
1031     // Function that is called when a user or another contract wants to transfer funds .
1032 
1033     function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {
1034 
1035         if (isContract(_to)) {
1036 
1037             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
1038 
1039             receiver.tokenFallback(msg.sender, _value, _data);
1040 
1041         }
1042 
1043         return super.transfer(_to, _value);
1044 
1045     }
1046 
1047 
1048 
1049     // Standard function transfer similar to ERC20 transfer with no _data .
1050 
1051     // Added due to backwards compatibility reasons .
1052 
1053     function transfer(address _to, uint256 _value) returns (bool success) {
1054 
1055         if (isContract(_to)) {
1056 
1057             bytes memory empty;
1058 
1059             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
1060 
1061             receiver.tokenFallback(msg.sender, _value, empty);
1062 
1063         }
1064 
1065         return super.transfer(_to, _value);
1066 
1067     }
1068 
1069 
1070 
1071     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
1072 
1073     function isContract(address _addr) private returns (bool is_contract) {
1074 
1075         uint length;
1076 
1077         assembly {
1078 
1079             length := extcodesize(_addr)
1080 
1081         }
1082 
1083         return (length > 0);
1084 
1085     }
1086 
1087 
1088 
1089 }
1090 
1091 contract KnowledgeToken is KnowledgeTokenInterface, Ownable, ERC223Token {
1092 
1093 
1094 
1095     address public minter;
1096 
1097 
1098 
1099     modifier onlyMinter() {
1100 
1101         // Only minter is allowed to proceed.
1102 
1103         require (msg.sender == minter);
1104 
1105         _;
1106 
1107     }
1108 
1109 
1110 
1111     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
1112 
1113         totalSupply = totalSupply.add(_amount);
1114 
1115         balances[_to] = balances[_to].add(_amount);
1116 
1117         Transfer(0x0, _to, _amount);
1118 
1119         Mint(_to, _amount);
1120 
1121         return true;
1122 
1123     }
1124 
1125 
1126 
1127     function changeMinter(address newAddress) public onlyOwner returns (bool)
1128 
1129     {
1130 
1131         minter = newAddress;
1132 
1133     }
1134 
1135 }
1136 
1137 contract WitCoin is KnowledgeToken{
1138 
1139 
1140 
1141     function WitCoin() {
1142 
1143         totalSupply = 0;
1144 
1145         name = "Witcoin";
1146 
1147         symbol = "WIT";
1148 
1149         decimals = 8;
1150 
1151     }
1152 
1153 
1154 
1155 }