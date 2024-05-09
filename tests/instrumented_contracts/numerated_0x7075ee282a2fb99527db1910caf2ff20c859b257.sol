1 pragma solidity ^0.4.23; 
2 
3   
4 
5 /** 
6 
7 * @title ERC20Basic 
8 
9 * @dev Simpler version of ERC20 interface 
10 
11 * @dev see https://github.com/ethereum/EIPs/issues/179 
12 
13 */ 
14 
15 contract ERC20Basic { 
16 
17   function totalSupply() public view returns (uint256); 
18 
19   function balanceOf(address who) public view returns (uint256); 
20 
21   function transfer(address to, uint256 value) public returns (bool); 
22 
23   event Transfer(address indexed from, address indexed to, uint256 value); 
24 
25 } 
26 
27   
28 
29 /** 
30 
31 * @title SafeMath 
32 
33 * @dev Math operations with safety checks that throw on error 
34 
35 */ 
36 
37 library SafeMath { 
38 
39   
40 
41   /** 
42 
43   * @dev Multiplies two numbers, throws on overflow. 
44 
45   */ 
46 
47   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) { 
48 
49     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the 
50 
51     // benefit is lost if 'b' is also tested. 
52 
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522 
54 
55     if (a == 0) { 
56 
57       return 0; 
58 
59     } 
60 
61   
62 
63     c = a * b; 
64 
65     assert(c / a == b); 
66 
67     return c; 
68 
69   } 
70 
71   
72 
73   /** 
74 
75   * @dev Integer division of two numbers, truncating the quotient. 
76 
77   */ 
78 
79   function div(uint256 a, uint256 b) internal pure returns (uint256) { 
80 
81     // assert(b > 0); // Solidity automatically throws when dividing by 0 
82 
83     // uint256 c = a / b; 
84 
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold 
86 
87     return a / b; 
88 
89   } 
90 
91   
92 
93   /** 
94 
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend). 
96 
97   */ 
98 
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) { 
100 
101     assert(b <= a); 
102 
103     return a - b; 
104 
105   } 
106 
107   
108 
109   /** 
110 
111   * @dev Adds two numbers, throws on overflow. 
112 
113   */ 
114 
115   function add(uint256 a, uint256 b) internal pure returns (uint256 c) { 
116 
117     c = a + b; 
118 
119     assert(c >= a); 
120 
121     return c; 
122 
123   } 
124 
125 } 
126 
127   
128 
129 /** 
130 
131 * @title Basic token 
132 
133 * @dev Basic version of StandardToken, with no allowances. 
134 
135 */ 
136 
137 contract BasicToken is ERC20Basic { 
138 
139   using SafeMath for uint256; 
140 
141   
142 
143   mapping(address => uint256) balances; 
144 
145   
146 
147   uint256 totalSupply_; 
148 
149   
150 
151   /** 
152 
153   * @dev total number of tokens in existence 
154 
155   */ 
156 
157   function totalSupply() public view returns (uint256) { 
158 
159     return totalSupply_; 
160 
161   } 
162 
163   
164 
165   /** 
166 
167   * @dev transfer token for a specified address 
168 
169   * @param _to The address to transfer to. 
170 
171   * @param _value The amount to be transferred. 
172 
173   */ 
174 
175   function transfer(address _to, uint256 _value) public returns (bool) { 
176 
177     require(_to != address(0)); 
178 
179     require(_value <= balances[msg.sender]); 
180 
181   
182 
183     balances[msg.sender] = balances[msg.sender].sub(_value); 
184 
185     balances[_to] = balances[_to].add(_value); 
186 
187     emit Transfer(msg.sender, _to, _value); 
188 
189     return true; 
190 
191   } 
192 
193   
194 
195   /** 
196 
197   * @dev Gets the balance of the specified address. 
198 
199   * @param _owner The address to query the the balance of. 
200 
201   * @return An uint256 representing the amount owned by the passed address. 
202 
203   */ 
204 
205   function balanceOf(address _owner) public view returns (uint256) { 
206 
207     return balances[_owner]; 
208 
209   } 
210 
211   
212 
213 } 
214 
215   
216 
217 /** 
218 
219 * @title ERC20 interface 
220 
221 * @dev see https://github.com/ethereum/EIPs/issues/20 
222 
223 */ 
224 
225 contract ERC20 is ERC20Basic { 
226 
227   function allowance(address owner, address spender) 
228 
229     public view returns (uint256); 
230 
231   
232 
233   function transferFrom(address from, address to, uint256 value) 
234 
235     public returns (bool); 
236 
237   
238 
239   function approve(address spender, uint256 value) public returns (bool); 
240 
241   event Approval( 
242 
243     address indexed owner, 
244 
245     address indexed spender, 
246 
247     uint256 value 
248 
249   ); 
250 
251 } 
252 
253   
254 
255 /** 
256 
257 * @title Standard ERC20 token 
258 
259 * 
260 
261 * @dev Implementation of the basic standard token. 
262 
263 * @dev https://github.com/ethereum/EIPs/issues/20 
264 
265 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol 
266 
267 */ 
268 
269 contract StandardToken is ERC20, BasicToken { 
270 
271   
272 
273   mapping (address => mapping (address => uint256)) internal allowed; 
274 
275   
276 
277   
278 
279   /** 
280 
281    * @dev Transfer tokens from one address to another 
282 
283    * @param _from address The address which you want to send tokens from 
284 
285    * @param _to address The address which you want to transfer to 
286 
287    * @param _value uint256 the amount of tokens to be transferred 
288 
289    */ 
290 
291   function transferFrom( 
292 
293     address _from, 
294 
295     address _to, 
296 
297     uint256 _value 
298 
299   ) 
300 
301     public 
302 
303     returns (bool) 
304 
305   { 
306 
307     require(_to != address(0)); 
308 
309     require(_value <= balances[_from]); 
310 
311     require(_value <= allowed[_from][msg.sender]); 
312 
313   
314 
315     balances[_from] = balances[_from].sub(_value); 
316 
317     balances[_to] = balances[_to].add(_value); 
318 
319     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
320 
321     emit Transfer(_from, _to, _value); 
322 
323     return true; 
324 
325   } 
326 
327   
328 
329   /** 
330 
331    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender. 
332 
333    * 
334 
335    * Beware that changing an allowance with this method brings the risk that someone may use both the old 
336 
337    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this 
338 
339    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards: 
340 
341    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
342 
343    * @param _spender The address which will spend the funds. 
344 
345    * @param _value The amount of tokens to be spent. 
346 
347    */ 
348 
349   function approve(address _spender, uint256 _value) public returns (bool) { 
350 
351     allowed[msg.sender][_spender] = _value; 
352 
353     emit Approval(msg.sender, _spender, _value); 
354 
355     return true; 
356 
357   } 
358 
359   
360 
361   /** 
362 
363    * @dev Function to check the amount of tokens that an owner allowed to a spender. 
364 
365    * @param _owner address The address which owns the funds. 
366 
367    * @param _spender address The address which will spend the funds. 
368 
369    * @return A uint256 specifying the amount of tokens still available for the spender. 
370 
371    */ 
372 
373   function allowance( 
374 
375     address _owner, 
376 
377     address _spender 
378 
379    ) 
380 
381     public 
382 
383     view 
384 
385     returns (uint256) 
386 
387   { 
388 
389     return allowed[_owner][_spender]; 
390 
391   } 
392 
393   
394 
395   /** 
396 
397    * @dev Increase the amount of tokens that an owner allowed to a spender. 
398 
399    * 
400 
401    * approve should be called when allowed[_spender] == 0. To increment 
402 
403    * allowed value is better to use this function to avoid 2 calls (and wait until 
404 
405    * the first transaction is mined) 
406 
407    * From MonolithDAO Token.sol 
408 
409    * @param _spender The address which will spend the funds. 
410 
411    * @param _addedValue The amount of tokens to increase the allowance by. 
412 
413    */ 
414 
415   function increaseApproval( 
416 
417     address _spender, 
418 
419     uint _addedValue 
420 
421   ) 
422 
423     public 
424 
425     returns (bool) 
426 
427   { 
428 
429     allowed[msg.sender][_spender] = ( 
430 
431       allowed[msg.sender][_spender].add(_addedValue)); 
432 
433     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
434 
435     return true; 
436 
437   } 
438 
439   
440 
441   /** 
442 
443    * @dev Decrease the amount of tokens that an owner allowed to a spender. 
444 
445    * 
446 
447    * approve should be called when allowed[_spender] == 0. To decrement 
448 
449    * allowed value is better to use this function to avoid 2 calls (and wait until 
450 
451    * the first transaction is mined) 
452 
453    * From MonolithDAO Token.sol 
454 
455    * @param _spender The address which will spend the funds. 
456 
457    * @param _subtractedValue The amount of tokens to decrease the allowance by. 
458 
459    */ 
460 
461   function decreaseApproval( 
462 
463     address _spender, 
464 
465     uint _subtractedValue 
466 
467   ) 
468 
469     public 
470 
471     returns (bool) 
472 
473   { 
474 
475     uint oldValue = allowed[msg.sender][_spender]; 
476 
477     if (_subtractedValue > oldValue) { 
478 
479       allowed[msg.sender][_spender] = 0; 
480 
481     } else { 
482 
483       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue); 
484 
485     } 
486 
487     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
488 
489     return true; 
490 
491   } 
492 
493   
494 
495 } 
496 
497   
498 
499 /** 
500 
501 * @title Ownable 
502 
503 * @dev The Ownable contract has an owner address, and provides basic authorization control 
504 
505 * functions, this simplifies the implementation of "user permissions". 
506 
507 */ 
508 
509 contract Ownable { 
510 
511   address public owner; 
512 
513   
514 
515   
516 
517   event OwnershipRenounced(address indexed previousOwner); 
518 
519   event OwnershipTransferred( 
520 
521     address indexed previousOwner, 
522 
523     address indexed newOwner 
524 
525   ); 
526 
527   
528 
529   
530 
531   /** 
532 
533    * @dev The Ownable constructor sets the original `owner` of the contract to the sender 
534 
535    * account. 
536 
537    */ 
538 
539   constructor() public { 
540 
541     owner = msg.sender; 
542 
543   } 
544 
545   
546 
547   /** 
548 
549    * @dev Throws if called by any account other than the owner. 
550 
551    */ 
552 
553   modifier onlyOwner() { 
554 
555     require(msg.sender == owner); 
556 
557     _; 
558 
559   } 
560 
561   
562 
563   /** 
564 
565    * @dev Allows the current owner to relinquish control of the contract. 
566 
567    */ 
568 
569   function renounceOwnership() public onlyOwner { 
570 
571     emit OwnershipRenounced(owner); 
572 
573     owner = address(0); 
574 
575   } 
576 
577   
578 
579   /** 
580 
581    * @dev Allows the current owner to transfer control of the contract to a newOwner. 
582 
583    * @param _newOwner The address to transfer ownership to. 
584 
585    */ 
586 
587   function transferOwnership(address _newOwner) public onlyOwner { 
588 
589     _transferOwnership(_newOwner); 
590 
591   } 
592 
593   
594 
595   /** 
596 
597    * @dev Transfers control of the contract to a newOwner. 
598 
599    * @param _newOwner The address to transfer ownership to. 
600 
601    */ 
602 
603   function _transferOwnership(address _newOwner) internal { 
604 
605     require(_newOwner != address(0)); 
606 
607     emit OwnershipTransferred(owner, _newOwner); 
608 
609     owner = _newOwner; 
610 
611   } 
612 
613 } 
614 
615   
616 
617 /** 
618 
619 * @title Pausable 
620 
621 * @dev Base contract which allows children to implement an emergency stop mechanism. 
622 
623 */ 
624 
625 contract Pausable is Ownable { 
626 
627   event Pause(); 
628 
629   event Unpause(); 
630 
631   
632 
633   bool public paused = false; 
634 
635   
636 
637   
638 
639   /** 
640 
641    * @dev Modifier to make a function callable only when the contract is not paused. 
642 
643    */ 
644 
645   modifier whenNotPaused() { 
646 
647     require(!paused); 
648 
649     _; 
650 
651   } 
652 
653   
654 
655   /** 
656 
657    * @dev Modifier to make a function callable only when the contract is paused. 
658 
659    */ 
660 
661   modifier whenPaused() { 
662 
663     require(paused); 
664 
665     _; 
666 
667   } 
668 
669   
670 
671   /** 
672 
673    * @dev called by the owner to pause, triggers stopped state 
674 
675    */ 
676 
677   function pause() onlyOwner whenNotPaused public { 
678 
679     paused = true; 
680 
681     emit Pause(); 
682 
683   } 
684 
685   
686 
687   /** 
688 
689    * @dev called by the owner to unpause, returns to normal state 
690 
691    */ 
692 
693   function unpause() onlyOwner whenPaused public { 
694 
695     paused = false; 
696 
697     emit Unpause(); 
698 
699   } 
700 
701 } 
702 
703   
704 
705 /** 
706 
707 * @title Pausable token 
708 
709 * @dev StandardToken modified with pausable transfers. 
710 
711 **/ 
712 
713 contract PausableToken is StandardToken, Pausable { 
714 
715   
716 
717   function transfer( 
718 
719     address _to, 
720 
721     uint256 _value 
722 
723   ) 
724 
725     public 
726 
727     whenNotPaused 
728 
729     returns (bool) 
730 
731   { 
732 
733     return super.transfer(_to, _value); 
734 
735   } 
736 
737   
738 
739   function transferFrom( 
740 
741     address _from, 
742 
743     address _to, 
744 
745     uint256 _value 
746 
747   ) 
748 
749     public 
750 
751     whenNotPaused 
752 
753     returns (bool) 
754 
755   { 
756 
757     return super.transferFrom(_from, _to, _value); 
758 
759   } 
760 
761   
762 
763   function approve( 
764 
765     address _spender, 
766 
767     uint256 _value 
768 
769   ) 
770 
771     public 
772 
773     whenNotPaused 
774 
775     returns (bool) 
776 
777   { 
778 
779     return super.approve(_spender, _value); 
780 
781   } 
782 
783   
784 
785   function increaseApproval( 
786 
787     address _spender, 
788 
789     uint _addedValue 
790 
791   ) 
792 
793     public 
794 
795     whenNotPaused 
796 
797     returns (bool success) 
798 
799   { 
800 
801     return super.increaseApproval(_spender, _addedValue); 
802 
803   } 
804 
805   
806 
807   function decreaseApproval( 
808 
809     address _spender, 
810 
811     uint _subtractedValue 
812 
813   ) 
814 
815     public 
816 
817     whenNotPaused 
818 
819     returns (bool success) 
820 
821   { 
822 
823     return super.decreaseApproval(_spender, _subtractedValue); 
824 
825   } 
826 
827 } 
828 
829   
830 
831 contract YenCoin is PausableToken { 
832 
833 string public name = "YenCoin"; 
834 
835 string public symbol = "YENC"; 
836 
837 uint8 public decimals = 18; 
838 
839 uint public INITIAL_SUPPLY = 10000 * 10 ** uint(decimals); 
840 
841   
842 
843 constructor() public { 
844 
845   totalSupply_ = INITIAL_SUPPLY; 
846 
847   balances[msg.sender] = INITIAL_SUPPLY; 
848 
849 } 
850 
851   
852 
853 function distribute(address[] addresses, uint256[] amounts) onlyOwner whenNotPaused public { 
854 
855      require(addresses.length == amounts.length); 
856 
857      for (uint i = 0; i < addresses.length; i++) { 
858 
859          super.transfer(addresses[i], amounts[i]); 
860 
861      } 
862 
863   } 
864 
865   
866 
867 }