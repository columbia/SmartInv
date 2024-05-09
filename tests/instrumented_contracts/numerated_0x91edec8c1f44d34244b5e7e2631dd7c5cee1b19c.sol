1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6 
7  * @title SafeMath
8 
9  * @dev Math operations with safety checks that throw on error
10 
11  */
12 
13 library SafeMath {
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16 
17         if (a == 0) {
18 
19             return 0;
20 
21         }
22 
23         uint256 c = a * b;
24 
25         assert(c / a == b);
26 
27         return c;
28 
29     }
30 
31 
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34 
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36 
37         uint256 c = a / b;
38 
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40 
41         return c;
42 
43     }
44 
45 
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48 
49         assert(b <= a);
50 
51         return a - b;
52 
53     }
54 
55 
56 
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58 
59         uint256 c = a + b;
60 
61         assert(c >= a);
62 
63         return c;
64 
65     }
66 
67 }
68 
69 
70 
71 
72 
73 /**
74 
75  * @title Ownable
76 
77  * @dev The Ownable contract has an owner address, and provides basic authorization
78 
79  *      control functions, this simplifies the implementation of "user permissions".
80 
81  */
82 
83 contract Ownable {
84 
85     address public owner;
86 
87 
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91 
92 
93     /**
94 
95      * @dev The Ownable constructor sets the original `owner` of the contract to the
96 
97      *      sender account.
98 
99      */
100 
101     function Ownable() public {
102 
103         owner = msg.sender;
104 
105     }
106 
107 
108 
109     /**
110 
111      * @dev Throws if called by any account other than the owner.
112 
113      */
114 
115     modifier onlyOwner() {
116 
117         require(msg.sender == owner);
118 
119         _;
120 
121     }
122 
123 
124 
125     /**
126 
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128 
129      * @param newOwner The address to transfer ownership to.
130 
131      */
132 
133     function transferOwnership(address newOwner) onlyOwner public {
134 
135         require(newOwner != address(0));
136 
137         OwnershipTransferred(owner, newOwner);
138 
139         owner = newOwner;
140 
141     }
142 
143 }
144 
145 
146 
147 
148 
149 /**
150 
151  * @title ERC223
152 
153  * @dev ERC223 contract interface with ERC20 functions and events
154 
155  *      Fully backward compatible with ERC20
156 
157  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
158 
159  */
160 
161 contract ERC223 {
162 
163     uint public totalSupply;
164 
165 
166 
167     // ERC223 and ERC20 functions and events
168 
169     function balanceOf(address who) public view returns (uint);
170 
171     function totalSupply() public view returns (uint256 _supply);
172 
173     function transfer(address to, uint value) public returns (bool ok);
174 
175     function transfer(address to, uint value, bytes data) public returns (bool ok);
176 
177     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
178 
179     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
180 
181 
182 
183     // ERC223 functions
184 
185     function name() public view returns (string _name);
186 
187     function symbol() public view returns (string _symbol);
188 
189     function decimals() public view returns (uint8 _decimals);
190 
191 
192 
193     // ERC20 functions and events
194 
195     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
196 
197     function approve(address _spender, uint256 _value) public returns (bool success);
198 
199     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
200 
201     event Transfer(address indexed _from, address indexed _to, uint256 _value);
202 
203     event Approval(address indexed _owner, address indexed _spender, uint _value);
204 
205 }
206 
207 
208 
209 
210 
211 /**
212 
213  * @title ContractReceiver
214 
215  * @dev Contract that is working with ERC223 tokens
216 
217  */
218 
219  contract ContractReceiver {
220 
221 
222 
223     struct TKN {
224 
225         address sender;
226 
227         uint value;
228 
229         bytes data;
230 
231         bytes4 sig;
232 
233     }
234 
235 
236 
237     function tokenFallback(address _from, uint _value, bytes _data) public pure {
238 
239         TKN memory tkn;
240 
241         tkn.sender = _from;
242 
243         tkn.value = _value;
244 
245         tkn.data = _data;
246 
247         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
248 
249         tkn.sig = bytes4(u);
250 
251 
252 
253         /**
254 
255          * tkn variable is analogue of msg variable of Ether transaction
256 
257          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
258 
259          * tkn.value the number of tokens that were sent (analogue of msg.value)
260 
261          * tkn.data is data of token transaction (analogue of msg.data)
262 
263          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
264 
265          */
266 
267     }
268 
269 }
270 
271 
272 
273 
274 
275 /**
276 
277  * @title YELLQASH
278 
279  * @author YELLQASH
280 
281  * @dev YELLQASH is an ERC223 Token with ERC20 functions and events
282 
283  *      Fully backward compatible with ERC20
284 
285  */
286 
287 contract YELLQASH is ERC223, Ownable {
288 
289     using SafeMath for uint256;
290 
291 
292 
293     string public name = "YELLQASH";
294 
295     string public symbol = "YELL";
296 
297     uint8 public decimals = 8;
298 
299     uint256 public totalSupply = 15e9 * 1e8;
300 
301     uint256 public distributeAmount = 0;
302 
303     bool public mintingFinished = false;
304 
305 
306 
307     mapping(address => uint256) public balanceOf;
308 
309     mapping(address => mapping (address => uint256)) public allowance;
310 
311     mapping (address => bool) public frozenAccount;
312 
313     mapping (address => uint256) public unlockUnixTime;
314 
315     
316 
317     event FrozenFunds(address indexed target, bool frozen);
318 
319     event LockedFunds(address indexed target, uint256 locked);
320 
321     event Burn(address indexed from, uint256 amount);
322 
323     event Mint(address indexed to, uint256 amount);
324 
325     event MintFinished();
326 
327 
328 
329     /** 
330 
331      * @dev Constructor is called only once and can not be called again
332 
333      */
334 
335     function YELLQASH() public {
336         balanceOf[msg.sender] = totalSupply;
337 
338     }
339 
340 
341 
342     function name() public view returns (string _name) {
343 
344         return name;
345 
346     }
347 
348 
349 
350     function symbol() public view returns (string _symbol) {
351 
352         return symbol;
353 
354     }
355 
356 
357 
358     function decimals() public view returns (uint8 _decimals) {
359 
360         return decimals;
361 
362     }
363 
364 
365 
366     function totalSupply() public view returns (uint256 _totalSupply) {
367 
368         return totalSupply;
369 
370     }
371 
372 
373 
374     function balanceOf(address _owner) public view returns (uint256 balance) {
375 
376         return balanceOf[_owner];
377 
378     }
379 
380 
381 
382     /**
383 
384      * @dev Prevent targets from sending or receiving tokens
385 
386      * @param targets Addresses to be frozen
387 
388      * @param isFrozen either to freeze it or not
389 
390      */
391 
392     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
393 
394         require(targets.length > 0);
395 
396 
397 
398         for (uint j = 0; j < targets.length; j++) {
399 
400             require(targets[j] != 0x0);
401 
402             frozenAccount[targets[j]] = isFrozen;
403 
404             FrozenFunds(targets[j], isFrozen);
405 
406         }
407 
408     }
409 
410 
411 
412     /**
413 
414      * @dev Prevent targets from sending or receiving tokens by setting Unix times
415 
416      * @param targets Addresses to be locked funds
417 
418      * @param unixTimes Unix times when locking up will be finished
419 
420      */
421 
422     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
423 
424         require(targets.length > 0
425 
426                 && targets.length == unixTimes.length);
427 
428 
429 
430         for(uint j = 0; j < targets.length; j++){
431 
432             require(unlockUnixTime[targets[j]] < unixTimes[j]);
433 
434             unlockUnixTime[targets[j]] = unixTimes[j];
435 
436             LockedFunds(targets[j], unixTimes[j]);
437 
438         }
439 
440     }
441 
442 
443 
444     /**
445 
446      * @dev Function that is called when a user or another contract wants to transfer funds
447 
448      */
449 
450     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
451 
452         require(_value > 0
453 
454                 && frozenAccount[msg.sender] == false
455 
456                 && frozenAccount[_to] == false
457 
458                 && now > unlockUnixTime[msg.sender]
459 
460                 && now > unlockUnixTime[_to]);
461 
462 
463 
464         if (isContract(_to)) {
465 
466             require(balanceOf[msg.sender] >= _value);
467 
468             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
469 
470             balanceOf[_to] = balanceOf[_to].add(_value);
471 
472             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
473 
474             Transfer(msg.sender, _to, _value, _data);
475 
476             Transfer(msg.sender, _to, _value);
477 
478             return true;
479 
480         } else {
481 
482             return transferToAddress(_to, _value, _data);
483 
484         }
485 
486     }
487 
488 
489 
490     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
491 
492         require(_value > 0
493 
494                 && frozenAccount[msg.sender] == false
495 
496                 && frozenAccount[_to] == false
497 
498                 && now > unlockUnixTime[msg.sender]
499 
500                 && now > unlockUnixTime[_to]);
501 
502 
503 
504         if (isContract(_to)) {
505 
506             return transferToContract(_to, _value, _data);
507 
508         } else {
509 
510             return transferToAddress(_to, _value, _data);
511 
512         }
513 
514     }
515 
516 
517 
518     /**
519 
520      * @dev Standard function transfer similar to ERC20 transfer with no _data
521 
522      *      Added due to backwards compatibility reasons
523 
524      */
525 
526     function transfer(address _to, uint _value) public returns (bool success) {
527 
528         require(_value > 0
529 
530                 && frozenAccount[msg.sender] == false
531 
532                 && frozenAccount[_to] == false
533 
534                 && now > unlockUnixTime[msg.sender]
535 
536                 && now > unlockUnixTime[_to]);
537 
538 
539 
540         bytes memory empty;
541 
542         if (isContract(_to)) {
543 
544             return transferToContract(_to, _value, empty);
545 
546         } else {
547 
548             return transferToAddress(_to, _value, empty);
549 
550         }
551 
552     }
553 
554 
555 
556     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
557 
558     function isContract(address _addr) private view returns (bool is_contract) {
559 
560         uint length;
561 
562         assembly {
563 
564             //retrieve the size of the code on target address, this needs assembly
565 
566             length := extcodesize(_addr)
567 
568         }
569 
570         return (length > 0);
571 
572     }
573 
574 
575 
576     // function that is called when transaction target is an address
577 
578     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
579 
580         require(balanceOf[msg.sender] >= _value);
581 
582         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
583 
584         balanceOf[_to] = balanceOf[_to].add(_value);
585 
586         Transfer(msg.sender, _to, _value, _data);
587 
588         Transfer(msg.sender, _to, _value);
589 
590         return true;
591 
592     }
593 
594 
595 
596     // function that is called when transaction target is a contract
597 
598     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
599 
600         require(balanceOf[msg.sender] >= _value);
601 
602         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
603 
604         balanceOf[_to] = balanceOf[_to].add(_value);
605 
606         ContractReceiver receiver = ContractReceiver(_to);
607 
608         receiver.tokenFallback(msg.sender, _value, _data);
609 
610         Transfer(msg.sender, _to, _value, _data);
611 
612         Transfer(msg.sender, _to, _value);
613 
614         return true;
615 
616     }
617 
618 
619 
620     /**
621 
622      * @dev Transfer tokens from one address to another
623 
624      *      Added due to backwards compatibility with ERC20
625 
626      * @param _from address The address which you want to send tokens from
627 
628      * @param _to address The address which you want to transfer to
629 
630      * @param _value uint256 the amount of tokens to be transferred
631 
632      */
633 
634     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
635 
636         require(_to != address(0)
637 
638                 && _value > 0
639 
640                 && balanceOf[_from] >= _value
641 
642                 && allowance[_from][msg.sender] >= _value
643 
644                 && frozenAccount[_from] == false
645 
646                 && frozenAccount[_to] == false
647 
648                 && now > unlockUnixTime[_from]
649 
650                 && now > unlockUnixTime[_to]);
651 
652 
653 
654         balanceOf[_from] = balanceOf[_from].sub(_value);
655 
656         balanceOf[_to] = balanceOf[_to].add(_value);
657 
658         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
659 
660         Transfer(_from, _to, _value);
661 
662         return true;
663 
664     }
665 
666 
667 
668     /**
669 
670      * @dev Allows _spender to spend no more than _value tokens in your behalf
671 
672      *      Added due to backwards compatibility with ERC20
673 
674      * @param _spender The address authorized to spend
675 
676      * @param _value the max amount they can spend
677 
678      */
679 
680     function approve(address _spender, uint256 _value) public returns (bool success) {
681 
682         allowance[msg.sender][_spender] = _value;
683 
684         Approval(msg.sender, _spender, _value);
685 
686         return true;
687 
688     }
689 
690 
691 
692     /**
693 
694      * @dev Function to check the amount of tokens that an owner allowed to a spender
695 
696      *      Added due to backwards compatibility with ERC20
697 
698      * @param _owner address The address which owns the funds
699 
700      * @param _spender address The address which will spend the funds
701 
702      */
703 
704     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
705 
706         return allowance[_owner][_spender];
707 
708     }
709 
710 
711 
712     /**
713 
714      * @dev Burns a specific amount of tokens.
715 
716      * @param _from The address that will burn the tokens.
717 
718      * @param _unitAmount The amount of token to be burned.
719 
720      */
721 
722     function burn(address _from, uint256 _unitAmount) onlyOwner public {
723 
724         require(_unitAmount > 0
725 
726                 && balanceOf[_from] >= _unitAmount);
727 
728 
729 
730         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
731 
732         totalSupply = totalSupply.sub(_unitAmount);
733 
734         Burn(_from, _unitAmount);
735 
736     }
737 
738 
739 
740     modifier canMint() {
741 
742         require(!mintingFinished);
743 
744         _;
745 
746     }
747 
748 
749 
750     /**
751 
752      * @dev Function to mint tokens
753 
754      * @param _to The address that will receive the minted tokens.
755 
756      * @param _unitAmount The amount of tokens to mint.
757 
758      */
759 
760     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
761 
762         require(_unitAmount > 0);
763 
764         
765 
766         totalSupply = totalSupply.add(_unitAmount);
767 
768         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
769 
770         Mint(_to, _unitAmount);
771 
772         Transfer(address(0), _to, _unitAmount);
773 
774         return true;
775 
776     }
777 
778 
779 
780     /**
781 
782      * @dev Function to stop minting new tokens.
783 
784      */
785 
786     function finishMinting() onlyOwner canMint public returns (bool) {
787 
788         mintingFinished = true;
789 
790         MintFinished();
791 
792         return true;
793 
794     }
795 
796 
797 
798     /**
799 
800      * @dev Function to distribute tokens to the list of addresses by the provided amount
801 
802      */
803 
804     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
805 
806         require(amount > 0 
807 
808                 && addresses.length > 0
809 
810                 && frozenAccount[msg.sender] == false
811 
812                 && now > unlockUnixTime[msg.sender]);
813 
814 
815 
816         amount = amount.mul(1e8);
817 
818         uint256 totalAmount = amount.mul(addresses.length);
819 
820         require(balanceOf[msg.sender] >= totalAmount);
821 
822         
823 
824         for (uint j = 0; j < addresses.length; j++) {
825 
826             require(addresses[j] != 0x0
827 
828                     && frozenAccount[addresses[j]] == false
829 
830                     && now > unlockUnixTime[addresses[j]]);
831 
832 
833 
834             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
835 
836             Transfer(msg.sender, addresses[j], amount);
837 
838         }
839 
840         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
841 
842         return true;
843 
844     }
845 
846 
847 
848     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
849 
850         require(addresses.length > 0
851 
852                 && addresses.length == amounts.length
853 
854                 && frozenAccount[msg.sender] == false
855 
856                 && now > unlockUnixTime[msg.sender]);
857 
858                 
859 
860         uint256 totalAmount = 0;
861 
862         
863 
864         for(uint j = 0; j < addresses.length; j++){
865 
866             require(amounts[j] > 0
867 
868                     && addresses[j] != 0x0
869 
870                     && frozenAccount[addresses[j]] == false
871 
872                     && now > unlockUnixTime[addresses[j]]);
873 
874                     
875 
876             amounts[j] = amounts[j].mul(1e8);
877 
878             totalAmount = totalAmount.add(amounts[j]);
879 
880         }
881 
882         require(balanceOf[msg.sender] >= totalAmount);
883 
884         
885 
886         for (j = 0; j < addresses.length; j++) {
887 
888             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
889 
890             Transfer(msg.sender, addresses[j], amounts[j]);
891 
892         }
893 
894         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
895 
896         return true;
897 
898     }
899 
900 
901 
902     /**
903 
904      * @dev Function to collect tokens from the list of addresses
905 
906      */
907 
908     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
909 
910         require(addresses.length > 0
911 
912                 && addresses.length == amounts.length);
913 
914 
915 
916         uint256 totalAmount = 0;
917 
918         
919 
920         for (uint j = 0; j < addresses.length; j++) {
921 
922             require(amounts[j] > 0
923 
924                     && addresses[j] != 0x0
925 
926                     && frozenAccount[addresses[j]] == false
927 
928                     && now > unlockUnixTime[addresses[j]]);
929 
930                     
931 
932             amounts[j] = amounts[j].mul(1e8);
933 
934             require(balanceOf[addresses[j]] >= amounts[j]);
935 
936             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
937 
938             totalAmount = totalAmount.add(amounts[j]);
939 
940             Transfer(addresses[j], msg.sender, amounts[j]);
941 
942         }
943 
944         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
945 
946         return true;
947 
948     }
949 
950 
951 
952     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
953 
954         distributeAmount = _unitAmount;
955 
956     }
957 
958     
959 
960     /**
961 
962      * @dev Function to distribute tokens to the msg.sender automatically
963 
964      *      If distributeAmount is 0, this function doesn't work
965 
966      */
967 
968     function autoDistribute() payable public {
969 
970         require(distributeAmount > 0
971 
972                 && balanceOf[owner] >= distributeAmount
973 
974                 && frozenAccount[msg.sender] == false
975 
976                 && now > unlockUnixTime[msg.sender]);
977 
978         if(msg.value > 0) owner.transfer(msg.value);
979 
980         
981 
982         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
983 
984         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
985 
986         Transfer(owner, msg.sender, distributeAmount);
987 
988     }
989 
990 
991 
992     /**
993 
994      * @dev fallback function
995 
996      */
997 
998     function() payable public {
999 
1000         autoDistribute();
1001 
1002     }
1003 
1004 }