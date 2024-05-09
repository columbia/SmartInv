1 pragma solidity ^0.4.18;
2 
3  
4 
5  
6 
7 /**besed on  OpenZeppelin**/
8 
9 /**gutalik team 1.0v**/
10 
11 /**
12 
13  * @title SafeMath
14 
15  * @dev Math operations with safety checks that throw on error
16 
17  */
18 
19 library SafeMath {
20 
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22 
23     if (a == 0) {
24 
25       return 0;
26 
27     }
28 
29     uint256 c = a * b;
30 
31     assert(c / a == b);
32 
33     return c;
34 
35   }
36 
37  
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40 
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42 
43     uint256 c = a / b;
44 
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47     return c;
48 
49   }
50 
51  
52 
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54 
55     assert(b <= a);
56 
57     return a - b;
58 
59   }
60 
61  
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64 
65     uint256 c = a + b;
66 
67     assert(c >= a);
68 
69     return c;
70 
71   }
72 
73 }
74 
75  
76 
77 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
78 
79  
80 
81 /**
82 
83  * @title ERC20Basic
84 
85  * @dev Simpler version of ERC20 interface
86 
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88 
89  */
90 
91 contract ERC20Basic {
92 
93   uint256 public totalSupply;
94 
95   function balanceOf(address who) public view returns (uint256);
96 
97   function transfer(address to, uint256 value) public returns (bool);
98 
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 
101 }
102 
103  
104 
105 // File: zeppelin-solidity/contracts/token/BasicToken.sol
106 
107  
108 
109 /**
110 
111  * @title Basic token
112 
113  * @dev Basic version of StandardToken, with no allowances.
114 
115  */
116 
117 contract BasicToken is ERC20Basic {
118 
119   using SafeMath for uint256;
120 
121  
122 
123   mapping(address => uint256) balances;
124 
125   mapping(address => bool) internal locks;
126 
127   mapping(address => mapping(address => uint256)) internal allowed;
128 
129  
130 
131   /**
132 
133   * @dev transfer token for a specified address
134 
135   * @param _to The address to transfer to.
136 
137   * @param _value The amount to be transferred.
138 
139   */
140 
141   function transfer(address _to, uint256 _value) public returns (bool) {
142 
143     require(_to != address(0));
144 
145     require(_value <= balances[msg.sender]);
146 
147  
148 
149     // SafeMath.sub will throw if there is not enough balance.
150 
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152 
153     balances[_to] = balances[_to].add(_value);
154 
155     Transfer(msg.sender, _to, _value);
156 
157     return true;
158 
159   }
160 
161  
162 
163   /**
164 
165   * @dev Gets the balance of the specified address.
166 
167   * @param _owner The address to query the the balance of.
168 
169   * @return An uint256 representing the amount owned by the passed address.
170 
171   */
172 
173   function balanceOf(address _owner) public view returns (uint256 balance) {
174 
175     return balances[_owner];
176 
177   }
178 
179   
180 
181  
182 
183 }
184 
185  
186 
187 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
188 
189  
190 
191 /**
192 
193  * @title Burnable Token
194 
195  * @dev Token that can be irreversibly burned (destroyed).
196 
197  */
198 
199 contract BurnableToken is BasicToken {
200 
201  
202 
203     event Burn(address indexed burner, uint256 value);
204 
205  
206 
207     /**
208 
209      * @dev Burns a specific amount of tokens.
210 
211      * @param _value The amount of token to be burned.
212 
213      */
214 
215     function burn(uint256 _value) public {
216 
217         require(_value <= balances[msg.sender]);
218 
219         // no need to require value <= totalSupply, since that would imply the
220 
221         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
222 
223  
224 
225         address burner = msg.sender;
226 
227         balances[burner] = balances[burner].sub(_value);
228 
229         totalSupply = totalSupply.sub(_value);
230 
231         Burn(burner, _value);
232 
233     }
234 
235  
236 
237     
238 
239 }
240 
241  
242 
243 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
244 
245  
246 
247 /**
248 
249  * @title Ownable
250 
251  * @dev The Ownable contract has an owner address, and provides basic authorization control
252 
253  * functions, this simplifies the implementation of "user permissions".
254 
255  */
256 
257 contract Ownable {
258 
259   address public owner;
260 
261  
262 
263  
264 
265   function Ownable() public {
266 
267     owner = msg.sender;
268 
269   }
270 
271  
272 
273  
274 
275   modifier onlyOwner() {
276 
277     require(msg.sender == owner);
278 
279     _;
280 
281   }
282 
283 }
284 
285 contract Pausable is Ownable {
286 
287   event Pause();
288 
289   event Unpause();
290 
291  
292 
293   bool public paused = false;
294 
295  
296 
297  
298 
299   /**
300 
301    * @dev Modifier to make a function callable only when the contract is not paused.
302 
303    */
304 
305   modifier whenNotPaused() {
306 
307     require(!paused);
308 
309     _;
310 
311   }
312 
313  
314 
315   /**
316 
317    * @dev Modifier to make a function callable only when the contract is paused.
318 
319    */
320 
321   modifier whenPaused() {
322 
323     require(paused);
324 
325     _;
326 
327   }
328 
329  
330 
331   /**
332 
333    * @dev called by the owner to pause, triggers stopped state
334 
335    */
336 
337   function pause() onlyOwner whenNotPaused public {
338 
339     paused = true;
340 
341      Pause();
342 
343   }
344 
345  
346 
347   /**
348 
349    * @dev called by the owner to unpause, returns to normal state
350 
351    */
352 
353   function unpause() onlyOwner whenPaused public {
354 
355     paused = false;
356 
357      Unpause();
358 
359   }
360 
361  
362 
363     
364 
365 }
366 
367  
368 
369  
370 
371 // File: zeppelin-solidity/contracts/token/ERC20.sol
372 
373  
374 
375 /**
376 
377  * @title ERC20 interface
378 
379  * @dev see https://github.com/ethereum/EIPs/issues/20
380 
381  */
382 
383 contract ERC20 is ERC20Basic {
384 
385   function allowance(address owner, address spender) public view returns (uint256);
386 
387   function transferFrom(address from, address to, uint256 value) public returns (bool);
388 
389   function approve(address spender, uint256 value) public returns (bool);
390 
391   event Approval(address indexed owner, address indexed spender, uint256 value);
392 
393 }
394 
395  
396 
397 // File: zeppelin-solidity/contracts/token/StandardToken.sol
398 
399  
400 
401 /**
402 
403  * @title Standard ERC20 token
404 
405  *
406 
407  * @dev Implementation of the basic standard token.
408 
409  * @dev https://github.com/ethereum/EIPs/issues/20
410 
411  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
412 
413  */
414 
415 contract StandardToken is ERC20, BasicToken {
416 
417  
418 
419   mapping (address => mapping (address => uint256)) internal allowed;
420 
421  
422 
423  
424 
425   /**
426 
427    * @dev Transfer tokens from one address to another
428 
429    * @param _from address The address which you want to send tokens from
430 
431    * @param _to address The address which you want to transfer to
432 
433    * @param _value uint256 the amount of tokens to be transferred
434 
435    */
436 
437   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
438 
439     require(_to != address(0));
440 
441     require(_value <= balances[_from]);
442 
443     require(_value <= allowed[_from][msg.sender]);
444 
445  
446 
447     balances[_from] = balances[_from].sub(_value);
448 
449     balances[_to] = balances[_to].add(_value);
450 
451     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
452 
453     Transfer(_from, _to, _value);
454 
455     return true;
456 
457   }
458 
459  
460 
461   /**
462 
463    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
464 
465    *
466 
467    * Beware that changing an allowance with this method brings the risk that someone may use both the old
468 
469    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
470 
471    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
472 
473    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
474 
475    * @param _spender The address which will spend the funds.
476 
477    * @param _value The amount of tokens to be spent.
478 
479    */
480 
481   function approve(address _spender, uint256 _value) public returns (bool) {
482 
483     allowed[msg.sender][_spender] = _value;
484 
485     Approval(msg.sender, _spender, _value);
486 
487     return true;
488 
489   }
490 
491  
492 
493   /**
494 
495    * @dev Function to check the amount of tokens that an owner allowed to a spender.
496 
497    * @param _owner address The address which owns the funds.
498 
499    * @param _spender address The address which will spend the funds.
500 
501    * @return A uint256 specifying the amount of tokens still available for the spender.
502 
503    */
504 
505   function allowance(address _owner, address _spender) public view returns (uint256) {
506 
507     return allowed[_owner][_spender];
508 
509   }
510 
511  
512 
513   /**
514 
515    * @dev Increase the amount of tokens that an owner allowed to a spender.
516 
517    *
518 
519    * approve should be called when allowed[_spender] == 0. To increment
520 
521    * allowed value is better to use this function to avoid 2 calls (and wait until
522 
523    * the first transaction is mined)
524 
525    * From MonolithDAO Token.sol
526 
527    * @param _spender The address which will spend the funds.
528 
529    * @param _addedValue The amount of tokens to increase the allowance by.
530 
531    */
532 
533   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
534 
535     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
536 
537     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
538 
539     return true;
540 
541   }
542 
543  
544 
545   /**
546 
547    * @dev Decrease the amount of tokens that an owner allowed to a spender.
548 
549    *
550 
551    * approve should be called when allowed[_spender] == 0. To decrement
552 
553    * allowed value is better to use this function to avoid 2 calls (and wait until
554 
555    * the first transaction is mined)
556 
557    * From MonolithDAO Token.sol
558 
559    * @param _spender The address which will spend the funds.
560 
561    * @param _subtractedValue The amount of tokens to decrease the allowance by.
562 
563    */
564 
565   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
566 
567     uint oldValue = allowed[msg.sender][_spender];
568 
569     if (_subtractedValue > oldValue) {
570 
571       allowed[msg.sender][_spender] = 0;
572 
573     } else {
574 
575       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
576 
577     }
578 
579     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
580 
581     return true;
582 
583   }
584 
585  
586 
587 }
588 
589  
590 
591 // File: zeppelin-solidity/contracts/token/MintableToken.sol
592 
593  
594 
595 /**
596 
597  * @title Mintable token
598 
599  * @dev Simple ERC20 Token example, with mintable token creation
600 
601  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
602 
603  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
604 
605  */
606 
607  
608 
609 contract MintableToken is StandardToken, Ownable {
610 
611   event Mint(address indexed to, uint256 amount);
612 
613   event MintFinished();
614 
615  
616 
617   bool public mintingFinished = false;
618 
619  
620 
621  
622 
623   modifier canMint() {
624 
625     require(!mintingFinished);
626 
627     _;
628 
629   }
630 
631  
632 
633   /**
634 
635    * @dev Function to mint tokens
636 
637    * @param _to The address that will receive the minted tokens.
638 
639    * @param _amount The amount of tokens to mint.
640 
641    * @return A boolean that indicates if the operation was successful.
642 
643    */
644 
645   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
646 
647     totalSupply = totalSupply.add(_amount);
648 
649     balances[_to] = balances[_to].add(_amount);
650 
651     Mint(_to, _amount);
652 
653     Transfer(address(0), _to, _amount);
654 
655     return true;
656 
657   }
658 
659  
660 
661 }
662 
663  
664 
665 // File: zeppelin-solidity/contracts/token/CappedToken.sol
666 
667  
668 
669 /**
670 
671  * @title Capped token
672 
673  * @dev Mintable token with a token cap.
674 
675  */
676 
677  
678 
679 contract CappedToken is MintableToken {
680 
681  
682 
683   uint256 public cap;
684 
685  
686 
687   function CappedToken(uint256 _cap) public {
688 
689     require(_cap > 0);
690 
691     cap = _cap;
692 
693   }
694 
695  
696 
697   /**
698 
699    * @dev Function to mint tokens
700 
701    * @param _to The address that will receive the minted tokens.
702 
703    * @param _amount The amount of tokens to mint.
704 
705    * @return A boolean that indicates if the operation was successful.
706 
707    */
708 
709   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
710 
711     require(totalSupply.add(_amount) <= cap);
712 
713  
714 
715     return super.mint(_to, _amount);
716 
717   }
718 
719  
720 
721 }
722 
723  
724 
725 // File: zeppelin-solidity/contracts/token/DetailedERC20.sol
726 
727  
728 
729 contract DetailedERC20 is ERC20 {
730 
731   string public name;
732 
733   string public symbol;
734 
735   uint8 public decimals;
736 
737  
738 
739   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
740 
741     name = _name;
742 
743     symbol = _symbol;
744 
745     decimals = _decimals;
746 
747   }
748 
749   
750 
751 }
752 
753  
754 
755  
756 
757  
758 
759  
760 
761  
762 
763  
764 
765 contract Feminism is DetailedERC20, StandardToken, BurnableToken, CappedToken, Pausable {
766 
767   /**
768 
769    * @dev Set the maximum issuance cap and token details.
770 
771    */
772 
773   function Feminism()
774 
775     DetailedERC20('Feminism', 'femi', 18)
776 
777     CappedToken( 50 * (10**9) * (10**18) )
778 
779   public {
780 
781  
782 
783   }
784 
785   
786 
787 }