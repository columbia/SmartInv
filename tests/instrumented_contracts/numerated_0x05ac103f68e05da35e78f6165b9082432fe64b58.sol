1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/IETokenProxy.sol
4 
5 /**
6  * MIT License
7  *
8  * Copyright (c) 2019 eToroX Labs
9  *
10  * Permission is hereby granted, free of charge, to any person obtaining a copy
11  * of this software and associated documentation files (the "Software"), to deal
12  * in the Software without restriction, including without limitation the rights
13  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14  * copies of the Software, and to permit persons to whom the Software is
15  * furnished to do so, subject to the following conditions:
16  *
17  * The above copyright notice and this permission notice shall be included in all
18  * copies or substantial portions of the Software.
19  *
20  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
23  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
26  * SOFTWARE.
27  */
28 
29 pragma solidity 0.4.24;
30 
31 /**
32  * @title Interface of an upgradable token
33  * @dev See implementation for
34  */
35 interface IETokenProxy {
36 
37     /* solium-disable zeppelin/missing-natspec-comments */
38 
39     /* Taken from ERC20Detailed in openzeppelin-solidity */
40     function nameProxy(address sender) external view returns(string);
41 
42     function symbolProxy(address sender)
43         external
44         view
45         returns(string);
46 
47     function decimalsProxy(address sender)
48         external
49         view
50         returns(uint8);
51 
52     /* Taken from IERC20 in openzeppelin-solidity */
53     function totalSupplyProxy(address sender)
54         external
55         view
56         returns (uint256);
57 
58     function balanceOfProxy(address sender, address who)
59         external
60         view
61         returns (uint256);
62 
63     function allowanceProxy(address sender,
64                             address owner,
65                             address spender)
66         external
67         view
68         returns (uint256);
69 
70     function transferProxy(address sender, address to, uint256 value)
71         external
72         returns (bool);
73 
74     function approveProxy(address sender,
75                           address spender,
76                           uint256 value)
77         external
78         returns (bool);
79 
80     function transferFromProxy(address sender,
81                                address from,
82                                address to,
83                                uint256 value)
84         external
85         returns (bool);
86 
87     function mintProxy(address sender, address to, uint256 value)
88         external
89         returns (bool);
90 
91     function changeMintingRecipientProxy(address sender,
92                                          address mintingRecip)
93         external;
94 
95     function burnProxy(address sender, uint256 value) external;
96 
97     function burnFromProxy(address sender,
98                            address from,
99                            uint256 value)
100         external;
101 
102     function increaseAllowanceProxy(address sender,
103                                     address spender,
104                                     uint addedValue)
105         external
106         returns (bool success);
107 
108     function decreaseAllowanceProxy(address sender,
109                                     address spender,
110                                     uint subtractedValue)
111         external
112         returns (bool success);
113 
114     function pauseProxy(address sender) external;
115 
116     function unpauseProxy(address sender) external;
117 
118     function pausedProxy(address sender) external view returns (bool);
119 
120     function finalizeUpgrade() external;
121 }
122 
123 // File: contracts/token/IEToken.sol
124 
125 /**
126  * MIT License
127  *
128  * Copyright (c) 2019 eToroX Labs
129  *
130  * Permission is hereby granted, free of charge, to any person obtaining a copy
131  * of this software and associated documentation files (the "Software"), to deal
132  * in the Software without restriction, including without limitation the rights
133  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
134  * copies of the Software, and to permit persons to whom the Software is
135  * furnished to do so, subject to the following conditions:
136  *
137  * The above copyright notice and this permission notice shall be included in all
138  * copies or substantial portions of the Software.
139  *
140  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
141  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
142  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
143  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
144  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
145  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
146  * SOFTWARE.
147  */
148 
149 pragma solidity 0.4.24;
150 
151 
152 /**
153  * @title EToken interface
154  * @dev The interface comprising an EToken contract
155  * This interface is a superset of the ERC20 interface defined at
156  * https://github.com/ethereum/EIPs/issues/20
157  */
158 interface IEToken {
159 
160     /* solium-disable zeppelin/missing-natspec-comments */
161 
162     function upgrade(IETokenProxy upgradedToken) external;
163 
164     /* Taken from ERC20Detailed in openzeppelin-solidity */
165     function name() external view returns(string);
166 
167     function symbol() external view returns(string);
168 
169     function decimals() external view returns(uint8);
170 
171     /* Taken from IERC20 in openzeppelin-solidity */
172     function totalSupply() external view returns (uint256);
173 
174     function balanceOf(address who) external view returns (uint256);
175 
176     function allowance(address owner, address spender)
177         external view returns (uint256);
178 
179     function transfer(address to, uint256 value) external returns (bool);
180 
181     function approve(address spender, uint256 value)
182         external
183         returns (bool);
184 
185     function transferFrom(address from, address to, uint256 value)
186         external
187         returns (bool);
188 
189     /* Taken from ERC20Mintable */
190     function mint(address to, uint256 value) external returns (bool);
191 
192     /* Taken from ERC20Burnable */
193     function burn(uint256 value) external;
194 
195     function burnFrom(address from, uint256 value) external;
196 
197     /* Taken from ERC20Pausable */
198     function increaseAllowance(
199         address spender,
200         uint addedValue
201     )
202         external
203         returns (bool success);
204 
205     function pause() external;
206 
207     function unpause() external;
208 
209     function paused() external view returns (bool);
210 
211     function decreaseAllowance(
212         address spender,
213         uint subtractedValue
214     )
215         external
216         returns (bool success);
217 
218     event Transfer(
219         address indexed from,
220         address indexed to,
221         uint256 value
222     );
223 
224     event Approval(
225         address indexed owner,
226         address indexed spender,
227         uint256 value
228     );
229 
230 }
231 
232 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
233 
234 /**
235  * @title Ownable
236  * @dev The Ownable contract has an owner address, and provides basic authorization control
237  * functions, this simplifies the implementation of "user permissions".
238  */
239 contract Ownable {
240   address private _owner;
241 
242   event OwnershipTransferred(
243     address indexed previousOwner,
244     address indexed newOwner
245   );
246 
247   /**
248    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
249    * account.
250    */
251   constructor() internal {
252     _owner = msg.sender;
253     emit OwnershipTransferred(address(0), _owner);
254   }
255 
256   /**
257    * @return the address of the owner.
258    */
259   function owner() public view returns(address) {
260     return _owner;
261   }
262 
263   /**
264    * @dev Throws if called by any account other than the owner.
265    */
266   modifier onlyOwner() {
267     require(isOwner());
268     _;
269   }
270 
271   /**
272    * @return true if `msg.sender` is the owner of the contract.
273    */
274   function isOwner() public view returns(bool) {
275     return msg.sender == _owner;
276   }
277 
278   /**
279    * @dev Allows the current owner to relinquish control of the contract.
280    * @notice Renouncing to ownership will leave the contract without an owner.
281    * It will not be possible to call the functions with the `onlyOwner`
282    * modifier anymore.
283    */
284   function renounceOwnership() public onlyOwner {
285     emit OwnershipTransferred(_owner, address(0));
286     _owner = address(0);
287   }
288 
289   /**
290    * @dev Allows the current owner to transfer control of the contract to a newOwner.
291    * @param newOwner The address to transfer ownership to.
292    */
293   function transferOwnership(address newOwner) public onlyOwner {
294     _transferOwnership(newOwner);
295   }
296 
297   /**
298    * @dev Transfers control of the contract to a newOwner.
299    * @param newOwner The address to transfer ownership to.
300    */
301   function _transferOwnership(address newOwner) internal {
302     require(newOwner != address(0));
303     emit OwnershipTransferred(_owner, newOwner);
304     _owner = newOwner;
305   }
306 }
307 
308 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
309 
310 /**
311  * @title SafeMath
312  * @dev Math operations with safety checks that revert on error
313  */
314 library SafeMath {
315 
316   /**
317   * @dev Multiplies two numbers, reverts on overflow.
318   */
319   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
320     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
321     // benefit is lost if 'b' is also tested.
322     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
323     if (a == 0) {
324       return 0;
325     }
326 
327     uint256 c = a * b;
328     require(c / a == b);
329 
330     return c;
331   }
332 
333   /**
334   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
335   */
336   function div(uint256 a, uint256 b) internal pure returns (uint256) {
337     require(b > 0); // Solidity only automatically asserts when dividing by 0
338     uint256 c = a / b;
339     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
340 
341     return c;
342   }
343 
344   /**
345   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
346   */
347   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
348     require(b <= a);
349     uint256 c = a - b;
350 
351     return c;
352   }
353 
354   /**
355   * @dev Adds two numbers, reverts on overflow.
356   */
357   function add(uint256 a, uint256 b) internal pure returns (uint256) {
358     uint256 c = a + b;
359     require(c >= a);
360 
361     return c;
362   }
363 
364   /**
365   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
366   * reverts when dividing by zero.
367   */
368   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
369     require(b != 0);
370     return a % b;
371   }
372 }
373 
374 // File: contracts/token/ERC20/Storage.sol
375 
376 /**
377  * MIT License
378  *
379  * Copyright (c) 2019 eToroX Labs
380  *
381  * Permission is hereby granted, free of charge, to any person obtaining a copy
382  * of this software and associated documentation files (the "Software"), to deal
383  * in the Software without restriction, including without limitation the rights
384  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
385  * copies of the Software, and to permit persons to whom the Software is
386  * furnished to do so, subject to the following conditions:
387  *
388  * The above copyright notice and this permission notice shall be included in all
389  * copies or substantial portions of the Software.
390  *
391  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
392  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
393  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
394  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
395  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
396  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
397  * SOFTWARE.
398  */
399 
400 pragma solidity 0.4.24;
401 
402 
403 
404 /**
405  * @title External ERC20 Storage
406  *
407  * @dev The storage contract used in ExternalERC20 token. This contract can
408  * provide storage for exactly one contract, referred to as the implementor,
409  * inheriting from the ExternalERC20 contract. Only the current implementor or
410  * the owner can transfer the implementorship. Change of state is only allowed
411  * by the implementor.
412  */
413 contract Storage is Ownable {
414     using SafeMath for uint256;
415 
416     mapping (address => uint256) private balances;
417     mapping (address => mapping (address => uint256)) private allowed;
418     uint256 private totalSupply;
419 
420     address private _implementor;
421 
422     event StorageImplementorTransferred(address indexed from,
423                                         address indexed to);
424 
425     /**
426      * @dev Contructor.
427      * @param owner The address of the owner of the contract.
428      * Must not be the zero address.
429      * @param implementor The address of the contract that is
430      * allowed to change state. Must not be the zero address.
431      */
432     constructor(address owner, address implementor) public {
433 
434         require(
435             owner != address(0),
436             "Owner should not be the zero address"
437         );
438 
439         require(
440             implementor != address(0),
441             "Implementor should not be the zero address"
442         );
443 
444         transferOwnership(owner);
445         _implementor = implementor;
446     }
447 
448     /**
449      * @dev Return whether the sender is an implementor.
450      */
451     function isImplementor() public view returns(bool) {
452         return msg.sender == _implementor;
453     }
454 
455     /**
456      * @dev Sets new balance.
457      * Can only be done by owner or implementor contract.
458      */
459     function setBalance(address owner,
460                         uint256 value)
461         public
462         onlyImplementor
463     {
464         balances[owner] = value;
465     }
466 
467     /**
468      * @dev Increases the balances relatively
469      * @param owner the address for which to increase balance
470      * @param addedValue the value to increase with
471      */
472     function increaseBalance(address owner, uint256 addedValue)
473         public
474         onlyImplementor
475     {
476         balances[owner] = balances[owner].add(addedValue);
477     }
478 
479     /**
480      * @dev Decreases the balances relatively
481      * @param owner the address for which to decrease balance
482      * @param subtractedValue the value to decrease with
483      */
484     function decreaseBalance(address owner, uint256 subtractedValue)
485         public
486         onlyImplementor
487     {
488         balances[owner] = balances[owner].sub(subtractedValue);
489     }
490 
491     /**
492      * @dev Can only be done by owner or implementor contract.
493      * @return The current balance of owner
494      */
495     function getBalance(address owner)
496         public
497         view
498         returns (uint256)
499     {
500         return balances[owner];
501     }
502 
503     /**
504      * @dev Sets new allowance.
505      * Can only be called by implementor contract.
506      */
507     function setAllowed(address owner,
508                         address spender,
509                         uint256 value)
510         public
511         onlyImplementor
512     {
513         allowed[owner][spender] = value;
514     }
515 
516     /**
517      * @dev Increases the allowance relatively
518      * @param owner the address for which to allow from
519      * @param spender the addres for which the allowance increase is granted
520      * @param addedValue the value to increase with
521      */
522     function increaseAllowed(
523         address owner,
524         address spender,
525         uint256 addedValue
526     )
527         public
528         onlyImplementor
529     {
530         allowed[owner][spender] = allowed[owner][spender].add(addedValue);
531     }
532 
533     /**
534      * @dev Decreases the allowance relatively
535      * @param owner the address for which to allow from
536      * @param spender the addres for which the allowance decrease is granted
537      * @param subtractedValue the value to decrease with
538      */
539     function decreaseAllowed(
540         address owner,
541         address spender,
542         uint256 subtractedValue
543     )
544         public
545         onlyImplementor
546     {
547         allowed[owner][spender] = allowed[owner][spender].sub(subtractedValue);
548     }
549 
550     /**
551      * @dev Can only be called by implementor contract.
552      * @return The current allowance for spender from owner
553      */
554     function getAllowed(address owner,
555                         address spender)
556         public
557         view
558         returns (uint256)
559     {
560         return allowed[owner][spender];
561     }
562 
563     /**
564      * @dev Change totalSupply.
565      * Can only be called by implementor contract.
566      */
567     function setTotalSupply(uint256 value)
568         public
569         onlyImplementor
570     {
571         totalSupply = value;
572     }
573 
574     /**
575      * @dev Can only be called by implementor contract.
576      * @return Current supply
577      */
578     function getTotalSupply()
579         public
580         view
581         returns (uint256)
582     {
583         return totalSupply;
584     }
585 
586     /**
587      * @dev Transfer implementor to new contract
588      * Can only be called by owner or implementor contract.
589      */
590     function transferImplementor(address newImplementor)
591         public
592         requireNonZero(newImplementor)
593         onlyImplementorOrOwner
594     {
595         require(newImplementor != _implementor,
596                 "Cannot transfer to same implementor as existing");
597         address curImplementor = _implementor;
598         _implementor = newImplementor;
599         emit StorageImplementorTransferred(curImplementor, newImplementor);
600     }
601 
602     /**
603      * @dev Asserts that sender is either owner or implementor.
604      */
605     modifier onlyImplementorOrOwner() {
606         require(isImplementor() || isOwner(), "Is not implementor or owner");
607         _;
608     }
609 
610     /**
611      * @dev Asserts that sender is the implementor.
612      */
613     modifier onlyImplementor() {
614         require(isImplementor(), "Is not implementor");
615         _;
616     }
617 
618     /**
619      * @dev Asserts that the given address is not the null-address
620      */
621     modifier requireNonZero(address addr) {
622         require(addr != address(0), "Expected a non-zero address");
623         _;
624     }
625 }
626 
627 // File: contracts/token/ERC20/ERC20.sol
628 
629 /**
630  * MIT License
631  *
632  * Copyright (c) 2019 eToroX Labs
633  *
634  * Permission is hereby granted, free of charge, to any person obtaining a copy
635  * of this software and associated documentation files (the "Software"), to deal
636  * in the Software without restriction, including without limitation the rights
637  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
638  * copies of the Software, and to permit persons to whom the Software is
639  * furnished to do so, subject to the following conditions:
640  *
641  * The above copyright notice and this permission notice shall be included in all
642  * copies or substantial portions of the Software.
643  *
644  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
645  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
646  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
647  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
648  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
649  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
650  * SOFTWARE.
651  */
652 
653 pragma solidity 0.4.24;
654 
655 
656 
657 /**
658  * @title Internal implementation of ERC20 functionality with support
659  * for a separate storage contract
660  */
661 contract ERC20 {
662     using SafeMath for uint256;
663 
664     Storage private externalStorage;
665 
666     string private name_;
667     string private symbol_;
668     uint8 private decimals_;
669 
670     event Transfer(
671         address indexed from,
672         address indexed to,
673         uint256 value
674     );
675 
676     event Approval(
677         address indexed owner,
678         address indexed spender,
679         uint256 value
680     );
681 
682     /**
683      * @dev Constructor
684      * @param name The ERC20 detailed token name
685      * @param symbol The ERC20 detailed symbol name
686      * @param decimals Determines the number of decimals of this token
687      * @param _externalStorage The external storage contract.
688      * Should be zero address if shouldCreateStorage is true.
689      * @param initialDeployment Defines whether it should
690      * create a new external storage. Should be false if
691      * externalERC20Storage is defined.
692      */
693     constructor(
694         string name,
695         string symbol,
696         uint8 decimals,
697         Storage _externalStorage,
698         bool initialDeployment
699     )
700         public
701     {
702 
703         require(
704             (_externalStorage != address(0) && (!initialDeployment)) ||
705             (_externalStorage == address(0) && initialDeployment),
706             "Cannot both create external storage and use the provided one.");
707 
708         name_ = name;
709         symbol_ = symbol;
710         decimals_ = decimals;
711 
712         if (initialDeployment) {
713             externalStorage = new Storage(msg.sender, this);
714         } else {
715             externalStorage = _externalStorage;
716         }
717     }
718 
719     /**
720      * @return The storage used by this contract
721      */
722     function getExternalStorage() public view returns(Storage) {
723         return externalStorage;
724     }
725 
726     /**
727      * @return the name of the token.
728      */
729     function _name() internal view returns(string) {
730         return name_;
731     }
732 
733     /**
734      * @return the symbol of the token.
735      */
736     function _symbol() internal view returns(string) {
737         return symbol_;
738     }
739 
740     /**
741      * @return the number of decimals of the token.
742      */
743     function _decimals() internal view returns(uint8) {
744         return decimals_;
745     }
746 
747     /**
748      * @dev Total number of tokens in existence
749      */
750     function _totalSupply() internal view returns (uint256) {
751         return externalStorage.getTotalSupply();
752     }
753 
754     /**
755      * @dev Gets the balance of the specified address.
756      * @param owner The address to query the balance of.
757      * @return An uint256 representing the amount owned by the passed address.
758      */
759     function _balanceOf(address owner) internal view returns (uint256) {
760         return externalStorage.getBalance(owner);
761     }
762 
763     /**
764      * @dev Function to check the amount of tokens that an owner allowed to a spender.
765      * @param owner address The address which owns the funds.
766      * @param spender address The address which will spend the funds.
767      * @return A uint256 specifying the amount of tokens still available for the spender.
768      */
769     function _allowance(address owner, address spender)
770         internal
771         view
772         returns (uint256)
773     {
774         return externalStorage.getAllowed(owner, spender);
775     }
776 
777     /**
778      * @dev Transfer token for a specified addresses
779      * @param originSender The address to transfer from.
780      * @param to The address to transfer to.
781      * @param value The amount to be transferred.
782      */
783     function _transfer(address originSender, address to, uint256 value)
784         internal
785         returns (bool)
786     {
787         require(to != address(0));
788 
789         externalStorage.decreaseBalance(originSender, value);
790         externalStorage.increaseBalance(to, value);
791 
792         emit Transfer(originSender, to, value);
793 
794         return true;
795     }
796 
797     /**
798      * @dev Approve the passed address to spend the specified amount
799      * of tokens on behalf of msg.sender.  Beware that changing an
800      * allowance with this method brings the risk that someone may use
801      * both the old and the new allowance by unfortunate transaction
802      * ordering. One possible solution to mitigate this race condition
803      * is to first reduce the spender's allowance to 0 and set the
804      * desired value afterwards:
805      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
806      * @param originSender the original transaction sender
807      * @param spender The address which will spend the funds.
808      * @param value The amount of tokens to be spent.
809      */
810     function _approve(address originSender, address spender, uint256 value)
811         internal
812         returns (bool)
813     {
814         require(spender != address(0));
815 
816         externalStorage.setAllowed(originSender, spender, value);
817         emit Approval(originSender, spender, value);
818 
819         return true;
820     }
821 
822     /**
823      * @dev Transfer tokens from one address to another
824      * @param originSender the original transaction sender
825      * @param from address The address which you want to send tokens from
826      * @param to address The address which you want to transfer to
827      * @param value uint256 the amount of tokens to be transferred
828      */
829     function _transferFrom(
830         address originSender,
831         address from,
832         address to,
833         uint256 value
834     )
835         internal
836         returns (bool)
837     {
838 
839         externalStorage.decreaseAllowed(from, originSender, value);
840 
841         _transfer(from, to, value);
842 
843         emit Approval(
844             from,
845             originSender,
846             externalStorage.getAllowed(from, originSender)
847         );
848 
849         return true;
850     }
851 
852     /**
853      * @dev Increase the amount of tokens that an owner allowed to a spender.
854      * approve should be called when allowed_[_spender] == 0. To increment
855      * allowed value is better to use this function to avoid 2 calls (and wait until
856      * the first transaction is mined)
857      * From MonolithDAO Token.sol
858      * @param originSender the original transaction sender
859      * @param spender The address which will spend the funds.
860      * @param addedValue The amount of tokens to increase the allowance by.
861      */
862     function _increaseAllowance(
863         address originSender,
864         address spender,
865         uint256 addedValue
866     )
867         internal
868         returns (bool)
869     {
870         require(spender != address(0));
871 
872         externalStorage.increaseAllowed(originSender, spender, addedValue);
873 
874         emit Approval(
875             originSender, spender,
876             externalStorage.getAllowed(originSender, spender)
877         );
878 
879         return true;
880     }
881 
882     /**
883      * @dev Decrease the amount of tokens that an owner allowed to a
884      * spender.  approve should be called when allowed_[_spender] ==
885      * 0. To decrement allowed value is better to use this function to
886      * avoid 2 calls (and wait until the first transaction is mined)
887      * From MonolithDAO Token.sol
888      * @param originSender the original transaction sender
889      * @param spender The address which will spend the funds.
890      * @param subtractedValue The amount of tokens to decrease the allowance by.
891      */
892     function _decreaseAllowance(
893         address originSender,
894         address spender,
895         uint256 subtractedValue
896     )
897         internal
898         returns (bool)
899     {
900         require(spender != address(0));
901 
902         externalStorage.decreaseAllowed(originSender,
903                                         spender,
904                                         subtractedValue);
905 
906         emit Approval(
907             originSender, spender,
908             externalStorage.getAllowed(originSender, spender)
909         );
910 
911         return true;
912     }
913 
914     /**
915      * @dev Internal function that mints an amount of the token and assigns it to
916      * an account. This encapsulates the modification of balances such that the
917      * proper events are emitted.
918      * @param account The account that will receive the created tokens.
919      * @param value The amount that will be created.
920      */
921     function _mint(address account, uint256 value) internal returns (bool)
922     {
923         require(account != 0);
924 
925         externalStorage.setTotalSupply(
926             externalStorage.getTotalSupply().add(value));
927         externalStorage.increaseBalance(account, value);
928 
929         emit Transfer(address(0), account, value);
930 
931         return true;
932     }
933 
934     /**
935      * @dev Internal function that burns an amount of the token of a given
936      * account.
937      * @param originSender The account whose tokens will be burnt.
938      * @param value The amount that will be burnt.
939      */
940     function _burn(address originSender, uint256 value) internal returns (bool)
941     {
942         require(originSender != 0);
943 
944         externalStorage.setTotalSupply(
945             externalStorage.getTotalSupply().sub(value));
946         externalStorage.decreaseBalance(originSender, value);
947 
948         emit Transfer(originSender, address(0), value);
949 
950         return true;
951     }
952 
953     /**
954      * @dev Internal function that burns an amount of the token of a given
955      * account, deducting from the sender's allowance for said account. Uses the
956      * internal burn function.
957      * @param originSender the original transaction sender
958      * @param account The account whose tokens will be burnt.
959      * @param value The amount that will be burnt.
960      */
961     function _burnFrom(address originSender, address account, uint256 value)
962         internal
963         returns (bool)
964     {
965         require(value <= externalStorage.getAllowed(account, originSender));
966 
967         externalStorage.decreaseAllowed(account, originSender, value);
968         _burn(account, value);
969 
970         emit Approval(account, originSender,
971                       externalStorage.getAllowed(account, originSender));
972 
973         return true;
974     }
975 }
976 
977 // File: contracts/token/UpgradeSupport.sol
978 
979 /**
980  * MIT License
981  *
982  * Copyright (c) 2019 eToroX Labs
983  *
984  * Permission is hereby granted, free of charge, to any person obtaining a copy
985  * of this software and associated documentation files (the "Software"), to deal
986  * in the Software without restriction, including without limitation the rights
987  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
988  * copies of the Software, and to permit persons to whom the Software is
989  * furnished to do so, subject to the following conditions:
990  *
991  * The above copyright notice and this permission notice shall be included in all
992  * copies or substantial portions of the Software.
993  *
994  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
995  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
996  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
997  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
998  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
999  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1000  * SOFTWARE.
1001  */
1002 
1003 pragma solidity 0.4.24;
1004 
1005 
1006 
1007 
1008 /**
1009  * @title Functionality supporting contract upgradability
1010  */
1011 contract UpgradeSupport is Ownable, ERC20 {
1012 
1013     event Upgraded(address indexed to);
1014     event UpgradeFinalized(address indexed upgradedFrom);
1015 
1016     /**
1017      * @dev Holds the address of the contract that was upgraded from
1018      */
1019     address private _upgradedFrom;
1020     bool private enabled;
1021     IETokenProxy private upgradedToken;
1022 
1023     /**
1024      * @dev Constructor
1025      * @param initialDeployment Set to true if this is the initial deployment of
1026      * the token. If true it automtically creates a new ExternalERC20Storage.
1027      * Also, it acts as a confirmation of intention which interlocks
1028      * upgradedFrom as follows: If initialDeployment is true, then
1029      * upgradedFrom must be the zero address. Otherwise, upgradedFrom must not
1030      * be the zero address. The same applies to externalERC20Storage, which must
1031      * be set to the zero address if initialDeployment is true.
1032      * @param upgradedFrom The token contract that this contract upgrades. Set
1033      * to address(0) for initial deployments
1034      */
1035     constructor(bool initialDeployment, address upgradedFrom) internal {
1036         require((upgradedFrom != address(0) && (!initialDeployment)) ||
1037                 (upgradedFrom == address(0) && initialDeployment),
1038                 "Cannot both be upgraded and initial deployment.");
1039 
1040         if (! initialDeployment) {
1041             // Pause until explicitly unpaused by upgraded contract
1042             enabled = false;
1043             _upgradedFrom = upgradedFrom;
1044         } else {
1045             enabled = true;
1046         }
1047     }
1048 
1049     modifier upgradeExists() {
1050         require(_upgradedFrom != address(0),
1051                 "Must have a contract to upgrade from");
1052         _;
1053     }
1054 
1055     /**
1056      * @dev Called by the upgraded contract in order to mark the finalization of
1057      * the upgrade and activate the new contract
1058      */
1059     function finalizeUpgrade()
1060         external
1061         upgradeExists
1062         onlyProxy
1063     {
1064         enabled = true;
1065         emit UpgradeFinalized(msg.sender);
1066     }
1067 
1068     /**
1069      * Upgrades the current token
1070      * @param _upgradedToken The address of the token that this token
1071      * should be upgraded to
1072      */
1073     function upgrade(IETokenProxy _upgradedToken) public onlyOwner {
1074         require(!isUpgraded(), "Token is already upgraded");
1075         require(_upgradedToken != IETokenProxy(0),
1076                 "Cannot upgrade to null address");
1077         require(_upgradedToken != IETokenProxy(this),
1078                 "Cannot upgrade to myself");
1079         require(getExternalStorage().isImplementor(),
1080                 "I don't own my storage. This will end badly.");
1081 
1082         upgradedToken = _upgradedToken;
1083         getExternalStorage().transferImplementor(_upgradedToken);
1084         _upgradedToken.finalizeUpgrade();
1085         emit Upgraded(_upgradedToken);
1086     }
1087 
1088     /**
1089      * @return Is this token upgraded
1090      */
1091     function isUpgraded() public view returns (bool) {
1092         return upgradedToken != IETokenProxy(0);
1093     }
1094 
1095     /**
1096      * @return The token that this was upgraded to
1097      */
1098     function getUpgradedToken() public view returns (IETokenProxy) {
1099         return upgradedToken;
1100     }
1101 
1102     /**
1103      * @dev Only allow the old contract to access the functions with explicit
1104      * sender passing
1105      */
1106     modifier onlyProxy () {
1107         require(msg.sender == _upgradedFrom,
1108                 "Proxy is the only allowed caller");
1109         _;
1110     }
1111 
1112     /**
1113      * @dev Allows execution if token is enabled, i.e. it is the
1114      * initial deployment or is upgraded from a contract which has
1115      * called the finalizeUpgrade function.
1116      */
1117     modifier isEnabled () {
1118         require(enabled, "Token disabled");
1119         _;
1120     }
1121 }
1122 
1123 // File: openzeppelin-solidity/contracts/access/Roles.sol
1124 
1125 /**
1126  * @title Roles
1127  * @dev Library for managing addresses assigned to a Role.
1128  */
1129 library Roles {
1130   struct Role {
1131     mapping (address => bool) bearer;
1132   }
1133 
1134   /**
1135    * @dev give an account access to this role
1136    */
1137   function add(Role storage role, address account) internal {
1138     require(account != address(0));
1139     require(!has(role, account));
1140 
1141     role.bearer[account] = true;
1142   }
1143 
1144   /**
1145    * @dev remove an account's access to this role
1146    */
1147   function remove(Role storage role, address account) internal {
1148     require(account != address(0));
1149     require(has(role, account));
1150 
1151     role.bearer[account] = false;
1152   }
1153 
1154   /**
1155    * @dev check if an account has this role
1156    * @return bool
1157    */
1158   function has(Role storage role, address account)
1159     internal
1160     view
1161     returns (bool)
1162   {
1163     require(account != address(0));
1164     return role.bearer[account];
1165   }
1166 }
1167 
1168 // File: contracts/token/access/roles/PauserRole.sol
1169 
1170 /**
1171  * MIT License
1172  *
1173  * Copyright (c) 2019 eToroX Labs
1174  *
1175  * Permission is hereby granted, free of charge, to any person obtaining a copy
1176  * of this software and associated documentation files (the "Software"), to deal
1177  * in the Software without restriction, including without limitation the rights
1178  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1179  * copies of the Software, and to permit persons to whom the Software is
1180  * furnished to do so, subject to the following conditions:
1181  *
1182  * The above copyright notice and this permission notice shall be included in all
1183  * copies or substantial portions of the Software.
1184  *
1185  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1186  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1187  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1188  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1189  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1190  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1191  * SOFTWARE.
1192  */
1193 
1194 pragma solidity 0.4.24;
1195 
1196 
1197 
1198 /** @title Contract managing the pauser role */
1199 contract PauserRole is Ownable {
1200     using Roles for Roles.Role;
1201 
1202     event PauserAdded(address indexed account);
1203     event PauserRemoved(address indexed account);
1204 
1205     Roles.Role private pausers;
1206 
1207     constructor() internal {
1208         _addPauser(msg.sender);
1209     }
1210 
1211     modifier onlyPauser() {
1212         require(isPauser(msg.sender), "not pauser");
1213         _;
1214     }
1215 
1216     modifier requirePauser(address account) {
1217         require(isPauser(account), "not pauser");
1218         _;
1219     }
1220 
1221     /**
1222      * @dev Checks if account is pauser
1223      * @param account Account to check
1224      * @return Boolean indicating if account is pauser
1225      */
1226     function isPauser(address account) public view returns (bool) {
1227         return pausers.has(account);
1228     }
1229 
1230     /**
1231      * @dev Adds a pauser account. Is only callable by owner.
1232      * @param account Address to be added
1233      */
1234     function addPauser(address account) public onlyOwner {
1235         _addPauser(account);
1236     }
1237 
1238     /**
1239      * @dev Removes a pauser account. Is only callable by owner.
1240      * @param account Address to be removed
1241      */
1242     function removePauser(address account) public onlyOwner {
1243         _removePauser(account);
1244     }
1245 
1246     /** @dev Allows a privileged holder to renounce their role */
1247     function renouncePauser() public {
1248         _removePauser(msg.sender);
1249     }
1250 
1251     /** @dev Internal implementation of addPauser */
1252     function _addPauser(address account) internal {
1253         pausers.add(account);
1254         emit PauserAdded(account);
1255     }
1256 
1257     /** @dev Internal implementation of removePauser */
1258     function _removePauser(address account) internal {
1259         pausers.remove(account);
1260         emit PauserRemoved(account);
1261     }
1262 }
1263 
1264 // File: contracts/token/access/Pausable.sol
1265 
1266 /**
1267  * MIT License
1268  *
1269  * Copyright (c) 2019 eToroX Labs
1270  *
1271  * Permission is hereby granted, free of charge, to any person obtaining a copy
1272  * of this software and associated documentation files (the "Software"), to deal
1273  * in the Software without restriction, including without limitation the rights
1274  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1275  * copies of the Software, and to permit persons to whom the Software is
1276  * furnished to do so, subject to the following conditions:
1277  *
1278  * The above copyright notice and this permission notice shall be included in all
1279  * copies or substantial portions of the Software.
1280  *
1281  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1282  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1283  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1284  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1285  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1286  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1287  * SOFTWARE.
1288  */
1289 
1290 pragma solidity 0.4.24;
1291 
1292 
1293 /**
1294  * @title Pausable
1295  * @dev Base contract which allows children to implement an emergency stop mechanism.
1296  */
1297 contract Pausable is PauserRole {
1298     event Paused(address account);
1299     event Unpaused(address account);
1300 
1301     bool private paused_;
1302 
1303     constructor() internal {
1304         paused_ = false;
1305     }
1306 
1307     /**
1308      * @return true if the contract is paused, false otherwise.
1309      */
1310     function _paused() internal view returns(bool) {
1311         return paused_;
1312     }
1313 
1314     /**
1315      * @dev Modifier to make a function callable only when the contract is not paused.
1316      */
1317     modifier whenNotPaused() {
1318         require(!paused_);
1319         _;
1320     }
1321 
1322     /**
1323      * @dev Modifier to make a function callable only when the contract is paused.
1324      */
1325     modifier whenPaused() {
1326         require(paused_);
1327         _;
1328     }
1329 
1330     /**
1331      * @dev Modifier to make a function callable if a specified account is pauser.
1332      * @param account the address of the account to check
1333      */
1334     modifier requireIsPauser(address account) {
1335         require(isPauser(account));
1336         _;
1337     }
1338 
1339     /**
1340      * @dev Called by the owner to pause, triggers stopped state
1341      * @param originSender the original sender of this method
1342      */
1343     function _pause(address originSender)
1344         internal
1345     {
1346         paused_ = true;
1347         emit Paused(originSender);
1348     }
1349 
1350     /**
1351      * @dev Called by the owner to unpause, returns to normal state
1352      * @param originSender the original sender of this method
1353      */
1354     function _unpause(address originSender)
1355         internal
1356     {
1357         paused_ = false;
1358         emit Unpaused(originSender);
1359     }
1360 }
1361 
1362 // File: contracts/token/access/roles/WhitelistAdminRole.sol
1363 
1364 /**
1365  * MIT License
1366  *
1367  * Copyright (c) 2019 eToroX Labs
1368  *
1369  * Permission is hereby granted, free of charge, to any person obtaining a copy
1370  * of this software and associated documentation files (the "Software"), to deal
1371  * in the Software without restriction, including without limitation the rights
1372  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1373  * copies of the Software, and to permit persons to whom the Software is
1374  * furnished to do so, subject to the following conditions:
1375  *
1376  * The above copyright notice and this permission notice shall be included in all
1377  * copies or substantial portions of the Software.
1378  *
1379  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1380  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1381  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1382  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1383  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1384  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1385  * SOFTWARE.
1386  */
1387 
1388 pragma solidity 0.4.24;
1389 
1390 
1391 
1392 /** @title Contract managing the whitelist admin role */
1393 contract WhitelistAdminRole is Ownable {
1394     using Roles for Roles.Role;
1395 
1396     event WhitelistAdminAdded(address indexed account);
1397     event WhitelistAdminRemoved(address indexed account);
1398 
1399     Roles.Role private whitelistAdmins;
1400 
1401     constructor() internal {
1402         _addWhitelistAdmin(msg.sender);
1403     }
1404 
1405     modifier onlyWhitelistAdmin() {
1406         require(isWhitelistAdmin(msg.sender), "not whitelistAdmin");
1407         _;
1408     }
1409 
1410     modifier requireWhitelistAdmin(address account) {
1411         require(isWhitelistAdmin(account), "not whitelistAdmin");
1412         _;
1413     }
1414 
1415     /**
1416      * @dev Checks if account is whitelist dmin
1417      * @param account Account to check
1418      * @return Boolean indicating if account is whitelist admin
1419      */
1420     function isWhitelistAdmin(address account) public view returns (bool) {
1421         return whitelistAdmins.has(account);
1422     }
1423 
1424     /**
1425      * @dev Adds a whitelist admin account. Is only callable by owner.
1426      * @param account Address to be added
1427      */
1428     function addWhitelistAdmin(address account) public onlyOwner {
1429         _addWhitelistAdmin(account);
1430     }
1431 
1432     /**
1433      * @dev Removes a whitelist admin account. Is only callable by owner.
1434      * @param account Address to be removed
1435      */
1436     function removeWhitelistAdmin(address account) public onlyOwner {
1437         _removeWhitelistAdmin(account);
1438     }
1439 
1440     /** @dev Allows a privileged holder to renounce their role */
1441     function renounceWhitelistAdmin() public {
1442         _removeWhitelistAdmin(msg.sender);
1443     }
1444 
1445     /** @dev Internal implementation of addWhitelistAdmin */
1446     function _addWhitelistAdmin(address account) internal {
1447         whitelistAdmins.add(account);
1448         emit WhitelistAdminAdded(account);
1449     }
1450 
1451     /** @dev Internal implementation of removeWhitelistAdmin */
1452     function _removeWhitelistAdmin(address account) internal {
1453         whitelistAdmins.remove(account);
1454         emit WhitelistAdminRemoved(account);
1455     }
1456 }
1457 
1458 // File: contracts/token/access/roles/BlacklistAdminRole.sol
1459 
1460 /**
1461  * MIT License
1462  *
1463  * Copyright (c) 2019 eToroX Labs
1464  *
1465  * Permission is hereby granted, free of charge, to any person obtaining a copy
1466  * of this software and associated documentation files (the "Software"), to deal
1467  * in the Software without restriction, including without limitation the rights
1468  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1469  * copies of the Software, and to permit persons to whom the Software is
1470  * furnished to do so, subject to the following conditions:
1471  *
1472  * The above copyright notice and this permission notice shall be included in all
1473  * copies or substantial portions of the Software.
1474  *
1475  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1476  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1477  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1478  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1479  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1480  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1481  * SOFTWARE.
1482  */
1483 
1484 pragma solidity 0.4.24;
1485 
1486 
1487 
1488 /** @title Contract managing the blacklist admin role */
1489 contract BlacklistAdminRole is Ownable {
1490     using Roles for Roles.Role;
1491 
1492     event BlacklistAdminAdded(address indexed account);
1493     event BlacklistAdminRemoved(address indexed account);
1494 
1495     Roles.Role private blacklistAdmins;
1496 
1497     constructor() internal {
1498         _addBlacklistAdmin(msg.sender);
1499     }
1500 
1501     modifier onlyBlacklistAdmin() {
1502         require(isBlacklistAdmin(msg.sender), "not blacklistAdmin");
1503         _;
1504     }
1505 
1506     modifier requireBlacklistAdmin(address account) {
1507         require(isBlacklistAdmin(account), "not blacklistAdmin");
1508         _;
1509     }
1510 
1511     /**
1512      * @dev Checks if account is blacklist admin
1513      * @param account Account to check
1514      * @return Boolean indicating if account is blacklist admin
1515      */
1516     function isBlacklistAdmin(address account) public view returns (bool) {
1517         return blacklistAdmins.has(account);
1518     }
1519 
1520     /**
1521      * @dev Adds a blacklist admin account. Is only callable by owner.
1522      * @param account Address to be added
1523      */
1524     function addBlacklistAdmin(address account) public onlyOwner {
1525         _addBlacklistAdmin(account);
1526     }
1527 
1528     /**
1529      * @dev Removes a blacklist admin account. Is only callable by owner
1530      * @param account Address to be removed
1531      */
1532     function removeBlacklistAdmin(address account) public onlyOwner {
1533         _removeBlacklistAdmin(account);
1534     }
1535 
1536     /** @dev Allows privilege holder to renounce their role */
1537     function renounceBlacklistAdmin() public {
1538         _removeBlacklistAdmin(msg.sender);
1539     }
1540 
1541     /** @dev Internal implementation of addBlacklistAdmin */
1542     function _addBlacklistAdmin(address account) internal {
1543         blacklistAdmins.add(account);
1544         emit BlacklistAdminAdded(account);
1545     }
1546 
1547     /** @dev Internal implementation of removeBlacklistAdmin */
1548     function _removeBlacklistAdmin(address account) internal {
1549         blacklistAdmins.remove(account);
1550         emit BlacklistAdminRemoved(account);
1551     }
1552 }
1553 
1554 // File: contracts/token/access/Accesslist.sol
1555 
1556 /**
1557  * MIT License
1558  *
1559  * Copyright (c) 2019 eToroX Labs
1560  *
1561  * Permission is hereby granted, free of charge, to any person obtaining a copy
1562  * of this software and associated documentation files (the "Software"), to deal
1563  * in the Software without restriction, including without limitation the rights
1564  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1565  * copies of the Software, and to permit persons to whom the Software is
1566  * furnished to do so, subject to the following conditions:
1567  *
1568  * The above copyright notice and this permission notice shall be included in all
1569  * copies or substantial portions of the Software.
1570  *
1571  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1572  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1573  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1574  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1575  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1576  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1577  * SOFTWARE.
1578  */
1579 
1580 pragma solidity 0.4.24;
1581 
1582 
1583 
1584 
1585 /**
1586  * @title The Accesslist contract
1587  * @dev Contract that contains a whitelist and a blacklist and manages them
1588  */
1589 contract Accesslist is WhitelistAdminRole, BlacklistAdminRole {
1590     using Roles for Roles.Role;
1591 
1592     event WhitelistAdded(address indexed account);
1593     event WhitelistRemoved(address indexed account);
1594     event BlacklistAdded(address indexed account);
1595     event BlacklistRemoved(address indexed account);
1596 
1597     Roles.Role private whitelist;
1598     Roles.Role private blacklist;
1599 
1600     /**
1601      * @dev Calls internal function _addWhitelisted
1602      * to add given address to whitelist
1603      * @param account Address to be added
1604      */
1605     function addWhitelisted(address account)
1606         public
1607         onlyWhitelistAdmin
1608     {
1609         _addWhitelisted(account);
1610     }
1611 
1612     /**
1613      * @dev Calls internal function _removeWhitelisted
1614      * to remove given address from the whitelist
1615      * @param account Address to be removed
1616      */
1617     function removeWhitelisted(address account)
1618         public
1619         onlyWhitelistAdmin
1620     {
1621         _removeWhitelisted(account);
1622     }
1623 
1624     /**
1625      * @dev Calls internal function _addBlacklisted
1626      * to add given address to blacklist
1627      * @param account Address to be added
1628      */
1629     function addBlacklisted(address account)
1630         public
1631         onlyBlacklistAdmin
1632     {
1633         _addBlacklisted(account);
1634     }
1635 
1636     /**
1637      * @dev Calls internal function _removeBlacklisted
1638      * to remove given address from blacklist
1639      * @param account Address to be removed
1640      */
1641     function removeBlacklisted(address account)
1642         public
1643         onlyBlacklistAdmin
1644     {
1645         _removeBlacklisted(account);
1646     }
1647 
1648     /**
1649      * @dev Checks to see if the given address is whitelisted
1650      * @param account Address to be checked
1651      * @return true if address is whitelisted
1652      */
1653     function isWhitelisted(address account)
1654         public
1655         view
1656         returns (bool)
1657     {
1658         return whitelist.has(account);
1659     }
1660 
1661     /**
1662      * @dev Checks to see if given address is blacklisted
1663      * @param account Address to be checked
1664      * @return true if address is blacklisted
1665      */
1666     function isBlacklisted(address account)
1667         public
1668         view
1669         returns (bool)
1670     {
1671         return blacklist.has(account);
1672     }
1673 
1674     /**
1675      * @dev Checks to see if given address is whitelisted and not blacklisted
1676      * @param account Address to be checked
1677      * @return true if address has access
1678      */
1679     function hasAccess(address account)
1680         public
1681         view
1682         returns (bool)
1683     {
1684         return isWhitelisted(account) && !isBlacklisted(account);
1685     }
1686 
1687 
1688     /**
1689      * @dev Adds given address to the whitelist
1690      * @param account Address to be added
1691      */
1692     function _addWhitelisted(address account) internal {
1693         whitelist.add(account);
1694         emit WhitelistAdded(account);
1695     }
1696 
1697     /**
1698      * @dev Removes given address to the whitelist
1699      * @param account Address to be removed
1700      */
1701     function _removeWhitelisted(address account) internal {
1702         whitelist.remove(account);
1703         emit WhitelistRemoved(account);
1704     }
1705 
1706     /**
1707      * @dev Adds given address to the blacklist
1708      * @param account Address to be added
1709      */
1710     function _addBlacklisted(address account) internal {
1711         blacklist.add(account);
1712         emit BlacklistAdded(account);
1713     }
1714 
1715     /**
1716      * @dev Removes given address to the blacklist
1717      * @param account Address to be removed
1718      */
1719     function _removeBlacklisted(address account) internal {
1720         blacklist.remove(account);
1721         emit BlacklistRemoved(account);
1722     }
1723 }
1724 
1725 // File: contracts/token/access/AccesslistGuarded.sol
1726 
1727 /**
1728  * MIT License
1729  *
1730  * Copyright (c) 2019 eToroX Labs
1731  *
1732  * Permission is hereby granted, free of charge, to any person obtaining a copy
1733  * of this software and associated documentation files (the "Software"), to deal
1734  * in the Software without restriction, including without limitation the rights
1735  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1736  * copies of the Software, and to permit persons to whom the Software is
1737  * furnished to do so, subject to the following conditions:
1738  *
1739  * The above copyright notice and this permission notice shall be included in all
1740  * copies or substantial portions of the Software.
1741  *
1742  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1743  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1744  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1745  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1746  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1747  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1748  * SOFTWARE.
1749  */
1750 
1751 pragma solidity 0.4.24;
1752 
1753 
1754 /**
1755  * @title The AccesslistGuarded contract
1756  * @dev Contract containing an accesslist and
1757  * modifiers to ensure proper access
1758  */
1759 contract AccesslistGuarded {
1760 
1761     Accesslist private accesslist;
1762     bool private whitelistEnabled;
1763 
1764     /**
1765      * @dev Constructor. Checks if the accesslist is a zero address
1766      * @param _accesslist The access list
1767      * @param _whitelistEnabled If the whitelist is enabled
1768      */
1769     constructor(
1770         Accesslist _accesslist,
1771         bool _whitelistEnabled
1772     )
1773         public
1774     {
1775         require(
1776             _accesslist != Accesslist(0),
1777             "Supplied accesslist is null"
1778         );
1779         accesslist = _accesslist;
1780         whitelistEnabled = _whitelistEnabled;
1781     }
1782 
1783     /**
1784      * @dev Modifier that requires given address
1785      * to be whitelisted and not blacklisted
1786      * @param account address to be checked
1787      */
1788     modifier requireHasAccess(address account) {
1789         require(hasAccess(account), "no access");
1790         _;
1791     }
1792 
1793     /**
1794      * @dev Modifier that requires the message sender
1795      * to be whitelisted and not blacklisted
1796      */
1797     modifier onlyHasAccess() {
1798         require(hasAccess(msg.sender), "no access");
1799         _;
1800     }
1801 
1802     /**
1803      * @dev Modifier that requires given address
1804      * to be whitelisted
1805      * @param account address to be checked
1806      */
1807     modifier requireWhitelisted(address account) {
1808         require(isWhitelisted(account), "no access");
1809         _;
1810     }
1811 
1812     /**
1813      * @dev Modifier that requires message sender
1814      * to be whitelisted
1815      */
1816     modifier onlyWhitelisted() {
1817         require(isWhitelisted(msg.sender), "no access");
1818         _;
1819     }
1820 
1821     /**
1822      * @dev Modifier that requires given address
1823      * to not be blacklisted
1824      * @param account address to be checked
1825      */
1826     modifier requireNotBlacklisted(address account) {
1827         require(isNotBlacklisted(account), "no access");
1828         _;
1829     }
1830 
1831     /**
1832      * @dev Modifier that requires message sender
1833      * to not be blacklisted
1834      */
1835     modifier onlyNotBlacklisted() {
1836         require(isNotBlacklisted(msg.sender), "no access");
1837         _;
1838     }
1839 
1840     /**
1841      * @dev Returns whether account has access.
1842      * If whitelist is enabled a whitelist check is also made,
1843      * otherwise it only checks for blacklisting.
1844      * @param account Address to be checked
1845      * @return true if address has access or is not blacklisted when whitelist
1846      * is disabled
1847      */
1848     function hasAccess(address account) public view returns (bool) {
1849         if (whitelistEnabled) {
1850             return accesslist.hasAccess(account);
1851         } else {
1852             return isNotBlacklisted(account);
1853         }
1854     }
1855 
1856     /**
1857      * @dev Returns whether account is whitelisted
1858      * @param account Address to be checked
1859      * @return true if address is whitelisted
1860      */
1861     function isWhitelisted(address account) public view returns (bool) {
1862         return accesslist.isWhitelisted(account);
1863     }
1864 
1865     /**
1866      * @dev Returns whether account is not blacklisted
1867      * @param account Address to be checked
1868      * @return true if address is not blacklisted
1869      */
1870     function isNotBlacklisted(address account) public view returns (bool) {
1871         return !accesslist.isBlacklisted(account);
1872     }
1873 }
1874 
1875 // File: contracts/token/access/roles/BurnerRole.sol
1876 
1877 /**
1878  * MIT License
1879  *
1880  * Copyright (c) 2019 eToroX Labs
1881  *
1882  * Permission is hereby granted, free of charge, to any person obtaining a copy
1883  * of this software and associated documentation files (the "Software"), to deal
1884  * in the Software without restriction, including without limitation the rights
1885  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1886  * copies of the Software, and to permit persons to whom the Software is
1887  * furnished to do so, subject to the following conditions:
1888  *
1889  * The above copyright notice and this permission notice shall be included in all
1890  * copies or substantial portions of the Software.
1891  *
1892  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1893  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1894  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1895  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1896  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1897  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1898  * SOFTWARE.
1899  */
1900 
1901 pragma solidity 0.4.24;
1902 
1903 
1904 
1905 /** @title Contract managing the burner role */
1906 contract BurnerRole is Ownable {
1907     using Roles for Roles.Role;
1908 
1909     event BurnerAdded(address indexed account);
1910     event BurnerRemoved(address indexed account);
1911 
1912     Roles.Role private burners;
1913 
1914     constructor() Ownable() internal {
1915         _addBurner(msg.sender);
1916     }
1917 
1918     modifier onlyBurner() {
1919         require(isBurner(msg.sender), "not burner");
1920         _;
1921     }
1922 
1923     modifier requireBurner(address account) {
1924         require(isBurner(account), "not burner");
1925         _;
1926     }
1927 
1928     /**
1929      * @dev Checks if account is burner
1930      * @param account Account to check
1931      * @return Boolean indicating if account is burner
1932      */
1933     function isBurner(address account) public view returns (bool) {
1934         return burners.has(account);
1935     }
1936 
1937     /**
1938      * @dev Adds a burner account
1939      * @dev Is only callable by owner
1940      * @param account Address to be added
1941      */
1942     function addBurner(address account) public onlyOwner {
1943         _addBurner(account);
1944     }
1945 
1946     /**
1947      * @dev Removes a burner account
1948      * @dev Is only callable by owner
1949      * @param account Address to be removed
1950      */
1951     function removeBurner(address account) public onlyOwner {
1952         _removeBurner(account);
1953     }
1954 
1955     /** @dev Allows a privileged holder to renounce their role */
1956     function renounceBurner() public {
1957         _removeBurner(msg.sender);
1958     }
1959 
1960     /** @dev Internal implementation of addBurner */
1961     function _addBurner(address account) internal {
1962         burners.add(account);
1963         emit BurnerAdded(account);
1964     }
1965 
1966     /** @dev Internal implementation of removeBurner */
1967     function _removeBurner(address account) internal {
1968         burners.remove(account);
1969         emit BurnerRemoved(account);
1970     }
1971 }
1972 
1973 // File: contracts/token/access/roles/MinterRole.sol
1974 
1975 /**
1976  * MIT License
1977  *
1978  * Copyright (c) 2019 eToroX Labs
1979  *
1980  * Permission is hereby granted, free of charge, to any person obtaining a copy
1981  * of this software and associated documentation files (the "Software"), to deal
1982  * in the Software without restriction, including without limitation the rights
1983  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1984  * copies of the Software, and to permit persons to whom the Software is
1985  * furnished to do so, subject to the following conditions:
1986  *
1987  * The above copyright notice and this permission notice shall be included in all
1988  * copies or substantial portions of the Software.
1989  *
1990  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1991  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1992  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1993  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1994  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1995  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1996  * SOFTWARE.
1997  */
1998 
1999 pragma solidity 0.4.24;
2000 
2001 
2002 
2003 /** @title The minter role contract */
2004 contract MinterRole is Ownable {
2005     using Roles for Roles.Role;
2006 
2007     event MinterAdded(address indexed account);
2008     event MinterRemoved(address indexed account);
2009 
2010     Roles.Role private minters;
2011 
2012     /**
2013      * @dev Checks if the message sender is a minter
2014      */
2015     modifier onlyMinter() {
2016         require(isMinter(msg.sender), "not minter");
2017         _;
2018     }
2019 
2020     /**
2021      * @dev Checks if the given address is a minter
2022      * @param account Address to be checked
2023      */
2024     modifier requireMinter(address account) {
2025         require(isMinter(account), "not minter");
2026         _;
2027     }
2028 
2029     /**
2030      * @dev Checks if given address is a minter
2031      * @param account Address to be checked
2032      * @return Is the address a minter
2033      */
2034     function isMinter(address account) public view returns (bool) {
2035         return minters.has(account);
2036     }
2037 
2038     /**
2039      * @dev Calls internal function _addMinter with the given address.
2040      * Can only be called by the owner.
2041      * @param account Address to be passed
2042      */
2043     function addMinter(address account) public onlyOwner {
2044         _addMinter(account);
2045     }
2046 
2047     /**
2048      * @dev Calls internal function _removeMinter with the given address.
2049      * Can only be called by the owner.
2050      * @param account Address to be passed
2051      */
2052     function removeMinter(address account) public onlyOwner {
2053         _removeMinter(account);
2054     }
2055 
2056     /**
2057      * @dev Calls internal function _removeMinter with message sender
2058      * as the parameter
2059      */
2060     function renounceMinter() public {
2061         _removeMinter(msg.sender);
2062     }
2063 
2064     /**
2065      * @dev Adds the given address to minters
2066      * @param account Address to be added
2067      */
2068     function _addMinter(address account) internal {
2069         minters.add(account);
2070         emit MinterAdded(account);
2071     }
2072 
2073     /**
2074      * @dev Removes given address from minters
2075      * @param account Address to be removed.
2076      */
2077     function _removeMinter(address account) internal {
2078         minters.remove(account);
2079         emit MinterRemoved(account);
2080     }
2081 }
2082 
2083 // File: contracts/token/access/RestrictedMinter.sol
2084 
2085 /**
2086  * MIT License
2087  *
2088  * Copyright (c) 2019 eToroX Labs
2089  *
2090  * Permission is hereby granted, free of charge, to any person obtaining a copy
2091  * of this software and associated documentation files (the "Software"), to deal
2092  * in the Software without restriction, including without limitation the rights
2093  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2094  * copies of the Software, and to permit persons to whom the Software is
2095  * furnished to do so, subject to the following conditions:
2096  *
2097  * The above copyright notice and this permission notice shall be included in all
2098  * copies or substantial portions of the Software.
2099  *
2100  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2101  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2102  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2103  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2104  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2105  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2106  * SOFTWARE.
2107  */
2108 
2109 pragma solidity 0.4.24;
2110 
2111 
2112 /**
2113  * @title Restricted minter
2114  * @dev Implements the notion of a restricted minter which is only
2115  * able to mint to a single specified account. Only the owner may
2116  * change this account.
2117  */
2118 contract RestrictedMinter  {
2119 
2120     address private mintingRecipientAccount;
2121 
2122     event MintingRecipientAccountChanged(address prev, address next);
2123 
2124     /**
2125      * @dev constructor. Sets minting recipient to given address
2126      * @param _mintingRecipientAccount address to be set to recipient
2127      */
2128     constructor(address _mintingRecipientAccount) internal {
2129         _changeMintingRecipient(msg.sender, _mintingRecipientAccount);
2130     }
2131 
2132     modifier requireMintingRecipient(address account) {
2133         require(account == mintingRecipientAccount,
2134                 "is not mintingRecpientAccount");
2135         _;
2136     }
2137 
2138     /**
2139      * @return The current minting recipient account address
2140      */
2141     function getMintingRecipient() public view returns (address) {
2142         return mintingRecipientAccount;
2143     }
2144 
2145     /**
2146      * @dev Internal function allowing the owner to change the current minting recipient account
2147      * @param originSender The sender address of the request
2148      * @param _mintingRecipientAccount address of new minting recipient
2149      */
2150     function _changeMintingRecipient(
2151         address originSender,
2152         address _mintingRecipientAccount
2153     )
2154         internal
2155     {
2156         originSender;
2157 
2158         require(_mintingRecipientAccount != address(0),
2159                 "zero minting recipient");
2160         address prev = mintingRecipientAccount;
2161         mintingRecipientAccount = _mintingRecipientAccount;
2162         emit MintingRecipientAccountChanged(prev, mintingRecipientAccount);
2163     }
2164 
2165 }
2166 
2167 // File: contracts/token/access/ETokenGuarded.sol
2168 
2169 /**
2170  * MIT License
2171  *
2172  * Copyright (c) 2019 eToroX Labs
2173  *
2174  * Permission is hereby granted, free of charge, to any person obtaining a copy
2175  * of this software and associated documentation files (the "Software"), to deal
2176  * in the Software without restriction, including without limitation the rights
2177  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2178  * copies of the Software, and to permit persons to whom the Software is
2179  * furnished to do so, subject to the following conditions:
2180  *
2181  * The above copyright notice and this permission notice shall be included in all
2182  * copies or substantial portions of the Software.
2183  *
2184  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2185  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2186  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2187  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2188  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2189  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2190  * SOFTWARE.
2191  */
2192 
2193 pragma solidity 0.4.24;
2194 
2195 
2196 
2197 
2198 
2199 
2200 
2201 
2202 
2203 
2204 /**
2205  * @title EToken access guards
2206  * @dev This contract implements access guards for functions comprising
2207  * the EToken public API. Since these functions may be called through
2208  * a proxy, access checks does not rely on the implicit value of
2209  * msg.sender but rather on the originSender parameter which is passed
2210  * to the functions of this contract. The value of originSender is
2211  * captured from msg.sender at the initial landing-point of the
2212  * request.
2213  */
2214 contract ETokenGuarded is
2215     Pausable,
2216     ERC20,
2217     UpgradeSupport,
2218     AccesslistGuarded,
2219     BurnerRole,
2220     MinterRole,
2221     RestrictedMinter
2222 {
2223 
2224     modifier requireOwner(address addr) {
2225         require(owner() == addr, "is not owner");
2226         _;
2227     }
2228 
2229     /**
2230      * @dev Constructor
2231      * @param name The ERC20 detailed token name
2232      * @param symbol The ERC20 detailed symbol name
2233      * @param decimals Determines the number of decimals of this token
2234      * @param accesslist Address of a deployed whitelist contract
2235      * @param whitelistEnabled Create token with whitelist enabled
2236      * @param externalStorage The external storage contract.
2237      * Should be zero address if shouldCreateStorage is true.
2238      * @param initialDeployment Defines whether it should
2239      * create a new external storage. Should be false if
2240      * externalERC20Storage is defined.
2241      */
2242     constructor(
2243         string name,
2244         string symbol,
2245         uint8 decimals,
2246         Accesslist accesslist,
2247         bool whitelistEnabled,
2248         Storage externalStorage,
2249         address initialMintingRecipient,
2250         bool initialDeployment
2251     )
2252         internal
2253         ERC20(name, symbol, decimals, externalStorage, initialDeployment)
2254         AccesslistGuarded(accesslist, whitelistEnabled)
2255         RestrictedMinter(initialMintingRecipient)
2256     {
2257 
2258     }
2259 
2260     /**
2261      * @dev Permission enforcing wrapper around the functionality of
2262      * EToken.name. Also see the general documentation for this
2263      * contract.
2264      */
2265     function nameGuarded(address originSender)
2266         internal
2267         view
2268         returns(string)
2269     {
2270         // Silence warnings
2271         originSender;
2272 
2273         return _name();
2274     }
2275 
2276     /**
2277      * @dev Permission enforcing wrapper around the functionality of
2278      * EToken.symbol. Also see the general documentation for this
2279      * contract.
2280      */
2281     function symbolGuarded(address originSender)
2282         internal
2283         view
2284         returns(string)
2285     {
2286         // Silence warnings
2287         originSender;
2288 
2289         return _symbol();
2290     }
2291 
2292     /**
2293      * @dev Permission enforcing wrapper around the functionality of
2294      * EToken.decimals. Also see the general documentation for this
2295      * contract.
2296      */
2297     function decimalsGuarded(address originSender)
2298         internal
2299         view
2300         returns(uint8)
2301     {
2302         // Silence warnings
2303         originSender;
2304 
2305         return _decimals();
2306     }
2307 
2308     /**
2309      * @dev Permission enforcing wrapper around the functionality of
2310      * EToken.totalSupply. Also see the general documentation for this
2311      * contract.
2312      */
2313     function totalSupplyGuarded(address originSender)
2314         internal
2315         view
2316         isEnabled
2317         returns(uint256)
2318     {
2319         // Silence warnings
2320         originSender;
2321 
2322         return _totalSupply();
2323     }
2324 
2325     /**
2326      * @dev Permission enforcing wrapper around the functionality of
2327      * EToken.balanceOf. Also see the general documentation for this
2328      * contract.
2329      */
2330     function balanceOfGuarded(address originSender, address who)
2331         internal
2332         view
2333         isEnabled
2334         returns(uint256)
2335     {
2336         // Silence warnings
2337         originSender;
2338 
2339         return _balanceOf(who);
2340     }
2341 
2342     /**
2343      * @dev Permission enforcing wrapper around the functionality of
2344      * EToken.allowance. Also see the general documentation for this
2345      * contract.
2346      */
2347     function allowanceGuarded(
2348         address originSender,
2349         address owner,
2350         address spender
2351     )
2352         internal
2353         view
2354         isEnabled
2355         returns(uint256)
2356     {
2357         // Silence warnings
2358         originSender;
2359 
2360         return _allowance(owner, spender);
2361     }
2362 
2363     /**
2364      * @dev Permission enforcing wrapper around the functionality of
2365      * EToken.transfer. Also see the general documentation for this
2366      * contract.
2367      */
2368     function transferGuarded(address originSender, address to, uint256 value)
2369         internal
2370         isEnabled
2371         whenNotPaused
2372         requireHasAccess(to)
2373         requireHasAccess(originSender)
2374         returns (bool)
2375     {
2376         _transfer(originSender, to, value);
2377         return true;
2378     }
2379 
2380     /**
2381      * @dev Permission enforcing wrapper around the functionality of
2382      * EToken.approve. Also see the general documentation for this
2383      * contract.
2384      */
2385     function approveGuarded(
2386         address originSender,
2387         address spender,
2388         uint256 value
2389     )
2390         internal
2391         isEnabled
2392         whenNotPaused
2393         requireHasAccess(spender)
2394         requireHasAccess(originSender)
2395         returns (bool)
2396     {
2397         _approve(originSender, spender, value);
2398         return true;
2399     }
2400 
2401 
2402     /**
2403      * @dev Permission enforcing wrapper around the functionality of
2404      * EToken.transferFrom. Also see the documentation for this
2405      * contract.
2406      */
2407     function transferFromGuarded(
2408         address originSender,
2409         address from,
2410         address to,
2411         uint256 value
2412     )
2413         internal
2414         isEnabled
2415         whenNotPaused
2416         requireHasAccess(originSender)
2417         requireHasAccess(from)
2418         requireHasAccess(to)
2419         returns (bool)
2420     {
2421         _transferFrom(
2422             originSender,
2423             from,
2424             to,
2425             value
2426         );
2427         return true;
2428     }
2429 
2430 
2431     /**
2432      * @dev Permission enforcing wrapper around the functionality of
2433      * EToken.increaseAllowance, Also see the general documentation
2434      * for this contract.
2435      */
2436     function increaseAllowanceGuarded(
2437         address originSender,
2438         address spender,
2439         uint256 addedValue
2440     )
2441         internal
2442         isEnabled
2443         whenNotPaused
2444         requireHasAccess(originSender)
2445         requireHasAccess(spender)
2446         returns (bool)
2447     {
2448         _increaseAllowance(originSender, spender, addedValue);
2449         return true;
2450     }
2451 
2452     /**
2453      * @dev Permission enforcing wrapper around the functionality of
2454      * EToken.decreaseAllowance. Also see the general documentation
2455      * for this contract.
2456      */
2457     function decreaseAllowanceGuarded(
2458         address originSender,
2459         address spender,
2460         uint256 subtractedValue
2461     )
2462         internal
2463         isEnabled
2464         whenNotPaused
2465         requireHasAccess(originSender)
2466         requireHasAccess(spender)
2467         returns (bool)  {
2468         _decreaseAllowance(originSender, spender, subtractedValue);
2469         return true;
2470     }
2471 
2472     /**
2473      * @dev Permission enforcing wrapper around the functionality of
2474      * EToken.burn. Also see the general documentation for this
2475      * contract.
2476      */
2477     function burnGuarded(address originSender, uint256 value)
2478         internal
2479         isEnabled
2480         requireBurner(originSender)
2481     {
2482         _burn(originSender, value);
2483     }
2484 
2485     /**
2486      * @dev Permission enforcing wrapper around the functionality of
2487      * EToken.burnFrom. Also see the general documentation for this
2488      * contract.
2489      */
2490     function burnFromGuarded(address originSender, address from, uint256 value)
2491         internal
2492         isEnabled
2493         requireBurner(originSender)
2494     {
2495         _burnFrom(originSender, from, value);
2496     }
2497 
2498     /**
2499      * @dev Permission enforcing wrapper around the functionality of
2500      * EToken.mint. Also see the general documentation for this
2501      * contract.
2502      */
2503     function mintGuarded(address originSender, address to, uint256 value)
2504         internal
2505         isEnabled
2506         requireMinter(originSender)
2507         requireMintingRecipient(to)
2508         returns (bool success)
2509     {
2510         // Silence warnings
2511         originSender;
2512 
2513         _mint(to, value);
2514         return true;
2515     }
2516 
2517     /**
2518      * @dev Permission enforcing wrapper around the functionality of
2519      * EToken.changeMintingRecipient. Also see the general
2520      * documentation for this contract.
2521      */
2522     function changeMintingRecipientGuarded(
2523         address originSender,
2524         address mintingRecip
2525     )
2526         internal
2527         isEnabled
2528         requireOwner(originSender)
2529     {
2530         _changeMintingRecipient(originSender, mintingRecip);
2531     }
2532 
2533     /**
2534      * @dev Permission enforcing wrapper around the functionality of
2535      * EToken.pause. Also see the general documentation for this
2536      * contract.
2537      */
2538     function pauseGuarded(address originSender)
2539         internal
2540         isEnabled
2541         requireIsPauser(originSender)
2542         whenNotPaused
2543     {
2544         _pause(originSender);
2545     }
2546 
2547     /**
2548      * @dev Permission enforcing wrapper around the functionality of
2549      * EToken.unpause. Also see the general documentation for this
2550      * contract.
2551      */
2552     function unpauseGuarded(address originSender)
2553         internal
2554         isEnabled
2555         requireIsPauser(originSender)
2556         whenPaused
2557     {
2558         _unpause(originSender);
2559     }
2560 
2561     /**
2562      * @dev Permission enforcing wrapper around the functionality of
2563      * EToken.paused. Also see the general documentation for this
2564      * contract.
2565      */
2566     function pausedGuarded(address originSender)
2567         internal
2568         view
2569         isEnabled
2570         returns (bool)
2571     {
2572         // Silence warnings
2573         originSender;
2574         return _paused();
2575     }
2576 }
2577 
2578 // File: contracts/token/ETokenProxy.sol
2579 
2580 /**
2581  * MIT License
2582  *
2583  * Copyright (c) 2019 eToroX Labs
2584  *
2585  * Permission is hereby granted, free of charge, to any person obtaining a copy
2586  * of this software and associated documentation files (the "Software"), to deal
2587  * in the Software without restriction, including without limitation the rights
2588  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2589  * copies of the Software, and to permit persons to whom the Software is
2590  * furnished to do so, subject to the following conditions:
2591  *
2592  * The above copyright notice and this permission notice shall be included in all
2593  * copies or substantial portions of the Software.
2594  *
2595  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2596  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2597  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2598  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2599  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2600  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2601  * SOFTWARE.
2602  */
2603 
2604 pragma solidity 0.4.24;
2605 
2606 
2607 
2608 
2609 /**
2610  * @title EToken upgradability proxy
2611  * For every call received the following takes place:
2612  * If this token is upgraded, all calls are forwarded to the proxy
2613  * interface of the new contract thereby forming a chain of proxy
2614  * calls.
2615  * If this token is not upgraded, that is, it is the most recent
2616  * generation of ETokens, then calls are forwarded directly to the
2617  * ETokenGuarded interface which performs access
2618  */
2619 contract ETokenProxy is IETokenProxy, ETokenGuarded {
2620 
2621     /**
2622      * @dev Constructor
2623      * @param name The ERC20 detailed token name
2624      * @param symbol The ERC20 detailed symbol name
2625      * @param decimals Determines the number of decimals of this token
2626      * @param accesslist Address of a deployed whitelist contract
2627      * @param whitelistEnabled Create token with whitelist enabled
2628      * @param externalStorage The external storage contract.
2629      * Should be zero address if shouldCreateStorage is true.
2630      * @param initialDeployment Set to true if this is the initial deployment of
2631      * the token. If true it automtically creates a new ExternalERC20Storage.
2632      * Also, it acts as a confirmation of intention which interlocks
2633      * upgradedFrom as follows: If initialDeployment is true, then
2634      * upgradedFrom must be the zero address. Otherwise, upgradedFrom must not
2635      * be the zero address. The same applies to externalERC20Storage, which must
2636      * be set to the zero address if initialDeployment is true.
2637      * @param upgradedFrom The token contract that this contract upgrades. Set
2638      * to address(0) for initial deployments
2639      */
2640     constructor(
2641         string name,
2642         string symbol,
2643         uint8 decimals,
2644         Accesslist accesslist,
2645         bool whitelistEnabled,
2646         Storage externalStorage,
2647         address initialMintingRecipient,
2648         address upgradedFrom,
2649         bool initialDeployment
2650     )
2651         internal
2652         UpgradeSupport(initialDeployment, upgradedFrom)
2653         ETokenGuarded(
2654             name,
2655             symbol,
2656             decimals,
2657             accesslist,
2658             whitelistEnabled,
2659             externalStorage,
2660             initialMintingRecipient,
2661             initialDeployment
2662         )
2663     {
2664 
2665     }
2666 
2667     /** Like EToken.name but proxies calls as described in the
2668         documentation for the declaration of this contract. */
2669     function nameProxy(address sender)
2670         external
2671         view
2672         isEnabled
2673         onlyProxy
2674         returns(string)
2675     {
2676         if (isUpgraded()) {
2677             return getUpgradedToken().nameProxy(sender);
2678         } else {
2679             return nameGuarded(sender);
2680         }
2681     }
2682 
2683     /** Like EToken.symbol but proxies calls as described in the
2684         documentation for the declaration of this contract. */
2685     function symbolProxy(address sender)
2686         external
2687         view
2688         isEnabled
2689         onlyProxy
2690         returns(string)
2691     {
2692         if (isUpgraded()) {
2693             return getUpgradedToken().symbolProxy(sender);
2694         } else {
2695             return symbolGuarded(sender);
2696         }
2697     }
2698 
2699     /** Like EToken.decimals but proxies calls as described in the
2700         documentation for the declaration of this contract. */
2701     function decimalsProxy(address sender)
2702         external
2703         view
2704         isEnabled
2705         onlyProxy
2706         returns(uint8)
2707     {
2708         if (isUpgraded()) {
2709             return getUpgradedToken().decimalsProxy(sender);
2710         } else {
2711             return decimalsGuarded(sender);
2712         }
2713     }
2714 
2715     /** Like EToken.symbol but proxies calls as described in the
2716         documentation for the declaration of this contract. */
2717     function totalSupplyProxy(address sender)
2718         external
2719         view
2720         isEnabled
2721         onlyProxy
2722         returns (uint256)
2723     {
2724         if (isUpgraded()) {
2725             return getUpgradedToken().totalSupplyProxy(sender);
2726         } else {
2727             return totalSupplyGuarded(sender);
2728         }
2729     }
2730 
2731     /** Like EToken.symbol but proxies calls as described in the
2732         documentation for the declaration of this contract. */
2733     function balanceOfProxy(address sender, address who)
2734         external
2735         view
2736         isEnabled
2737         onlyProxy
2738         returns (uint256)
2739     {
2740         if (isUpgraded()) {
2741             return getUpgradedToken().balanceOfProxy(sender, who);
2742         } else {
2743             return balanceOfGuarded(sender, who);
2744         }
2745     }
2746 
2747     /** Like EToken.symbol but proxies calls as described in the
2748         documentation for the declaration of this contract. */
2749     function allowanceProxy(address sender, address owner, address spender)
2750         external
2751         view
2752         isEnabled
2753         onlyProxy
2754         returns (uint256)
2755     {
2756         if (isUpgraded()) {
2757             return getUpgradedToken().allowanceProxy(sender, owner, spender);
2758         } else {
2759             return allowanceGuarded(sender, owner, spender);
2760         }
2761     }
2762 
2763 
2764     /** Like EToken.symbol but proxies calls as described in the
2765         documentation for the declaration of this contract. */
2766     function transferProxy(address sender, address to, uint256 value)
2767         external
2768         isEnabled
2769         onlyProxy
2770         returns (bool)
2771     {
2772         if (isUpgraded()) {
2773             return getUpgradedToken().transferProxy(sender, to, value);
2774         } else {
2775             return transferGuarded(sender, to, value);
2776         }
2777 
2778     }
2779 
2780     /** Like EToken.symbol but proxies calls as described in the
2781         documentation for the declaration of this contract. */
2782     function approveProxy(address sender, address spender, uint256 value)
2783         external
2784         isEnabled
2785         onlyProxy
2786         returns (bool)
2787     {
2788 
2789         if (isUpgraded()) {
2790             return getUpgradedToken().approveProxy(sender, spender, value);
2791         } else {
2792             return approveGuarded(sender, spender, value);
2793         }
2794     }
2795 
2796     /** Like EToken.symbol but proxies calls as described in the
2797         documentation for the declaration of this contract. */
2798     function transferFromProxy(
2799         address sender,
2800         address from,
2801         address to,
2802         uint256 value
2803     )
2804         external
2805         isEnabled
2806         onlyProxy
2807         returns (bool)
2808     {
2809         if (isUpgraded()) {
2810             getUpgradedToken().transferFromProxy(
2811                 sender,
2812                 from,
2813                 to,
2814                 value
2815             );
2816         } else {
2817             transferFromGuarded(
2818                 sender,
2819                 from,
2820                 to,
2821                 value
2822             );
2823         }
2824     }
2825 
2826     /** Like EToken. but proxies calls as described in the
2827         documentation for the declaration of this contract. */
2828     function mintProxy(address sender, address to, uint256 value)
2829         external
2830         isEnabled
2831         onlyProxy
2832         returns (bool)
2833     {
2834         if (isUpgraded()) {
2835             return getUpgradedToken().mintProxy(sender, to, value);
2836         } else {
2837             return mintGuarded(sender, to, value);
2838         }
2839     }
2840 
2841     /** Like EToken.changeMintingRecipient but proxies calls as
2842         described in the documentation for the declaration of this
2843         contract. */
2844     function changeMintingRecipientProxy(address sender,
2845                                          address mintingRecip)
2846         external
2847         isEnabled
2848         onlyProxy
2849     {
2850         if (isUpgraded()) {
2851             getUpgradedToken().changeMintingRecipientProxy(sender, mintingRecip);
2852         } else {
2853             changeMintingRecipientGuarded(sender, mintingRecip);
2854         }
2855     }
2856 
2857     /** Like EToken.burn but proxies calls as described in the
2858         documentation for the declaration of this contract. */
2859     function burnProxy(address sender, uint256 value)
2860         external
2861         isEnabled
2862         onlyProxy
2863     {
2864         if (isUpgraded()) {
2865             getUpgradedToken().burnProxy(sender, value);
2866         } else {
2867             burnGuarded(sender, value);
2868         }
2869     }
2870 
2871     /** Like EToken.burnFrom but proxies calls as described in the
2872         documentation for the declaration of this contract. */
2873     function burnFromProxy(address sender, address from, uint256 value)
2874         external
2875         isEnabled
2876         onlyProxy
2877     {
2878         if (isUpgraded()) {
2879             getUpgradedToken().burnFromProxy(sender, from, value);
2880         } else {
2881             burnFromGuarded(sender, from, value);
2882         }
2883     }
2884 
2885     /** Like EToken.increaseAllowance but proxies calls as described
2886         in the documentation for the declaration of this contract. */
2887     function increaseAllowanceProxy(
2888         address sender,
2889         address spender,
2890         uint addedValue
2891     )
2892         external
2893         isEnabled
2894         onlyProxy
2895         returns (bool)
2896     {
2897         if (isUpgraded()) {
2898             return getUpgradedToken().increaseAllowanceProxy(
2899                 sender, spender, addedValue);
2900         } else {
2901             return increaseAllowanceGuarded(sender, spender, addedValue);
2902         }
2903     }
2904 
2905     /** Like EToken.decreaseAllowance but proxies calls as described
2906         in the documentation for the declaration of this contract. */
2907     function decreaseAllowanceProxy(
2908         address sender,
2909         address spender,
2910         uint subtractedValue
2911     )
2912         external
2913         isEnabled
2914         onlyProxy
2915         returns (bool)
2916     {
2917         if (isUpgraded()) {
2918             return getUpgradedToken().decreaseAllowanceProxy(
2919                 sender, spender, subtractedValue);
2920         } else {
2921             return decreaseAllowanceGuarded(sender, spender, subtractedValue);
2922         }
2923     }
2924 
2925     /** Like EToken.pause but proxies calls as described
2926         in the documentation for the declaration of this contract. */
2927     function pauseProxy(address sender)
2928         external
2929         isEnabled
2930         onlyProxy
2931     {
2932         if (isUpgraded()) {
2933             getUpgradedToken().pauseProxy(sender);
2934         } else {
2935             pauseGuarded(sender);
2936         }
2937     }
2938 
2939     /** Like EToken.unpause but proxies calls as described
2940         in the documentation for the declaration of this contract. */
2941     function unpauseProxy(address sender)
2942         external
2943         isEnabled
2944         onlyProxy
2945     {
2946         if (isUpgraded()) {
2947             getUpgradedToken().unpauseProxy(sender);
2948         } else {
2949             unpauseGuarded(sender);
2950         }
2951     }
2952 
2953     /** Like EToken.paused but proxies calls as described
2954         in the documentation for the declaration of this contract. */
2955     function pausedProxy(address sender)
2956         external
2957         view
2958         isEnabled
2959         onlyProxy
2960         returns (bool)
2961     {
2962         if (isUpgraded()) {
2963             return getUpgradedToken().pausedProxy(sender);
2964         } else {
2965             return pausedGuarded(sender);
2966         }
2967     }
2968 }
2969 
2970 // File: contracts/token/EToken.sol
2971 
2972 /**
2973  * MIT License
2974  *
2975  * Copyright (c) 2019 eToroX Labs
2976  *
2977  * Permission is hereby granted, free of charge, to any person obtaining a copy
2978  * of this software and associated documentation files (the "Software"), to deal
2979  * in the Software without restriction, including without limitation the rights
2980  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2981  * copies of the Software, and to permit persons to whom the Software is
2982  * furnished to do so, subject to the following conditions:
2983  *
2984  * The above copyright notice and this permission notice shall be included in all
2985  * copies or substantial portions of the Software.
2986  *
2987  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2988  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2989  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2990  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2991  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2992  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2993  * SOFTWARE.
2994  */
2995 
2996 pragma solidity 0.4.24;
2997 
2998 
2999 
3000 /** @title Main EToken contract */
3001 contract EToken is IEToken, ETokenProxy {
3002 
3003     /**
3004      * @param name The name of the token
3005      * @param symbol The symbol of the token
3006      * @param decimals The number of decimals of the token
3007      * @param accesslist Address of a deployed whitelist contract
3008      * @param whitelistEnabled Create token with whitelist enabled
3009      * @param externalStorage Address of a deployed ERC20 storage contract
3010      * @param initialMintingRecipient The initial minting recipient of the token
3011      * @param upgradedFrom The token contract that this contract upgrades. Set
3012      * to address(0) for initial deployments
3013      * @param initialDeployment Set to true if this is the initial deployment of
3014      * the token. If true it automtically creates a new ExternalERC20Storage.
3015      * Also, it acts as a confirmation of intention which interlocks
3016      * upgradedFrom as follows: If initialDeployment is true, then
3017      * upgradedFrom must be the zero address. Otherwise, upgradedFrom must not
3018      * be the zero address. The same applies to externalERC20Storage, which must
3019      * be set to the zero address if initialDeployment is true.
3020      */
3021     constructor(
3022         string name,
3023         string symbol,
3024         uint8 decimals,
3025         Accesslist accesslist,
3026         bool whitelistEnabled,
3027         Storage externalStorage,
3028         address initialMintingRecipient,
3029         address upgradedFrom,
3030         bool initialDeployment
3031     )
3032         public
3033         ETokenProxy(
3034             name,
3035             symbol,
3036             decimals,
3037             accesslist,
3038             whitelistEnabled,
3039             externalStorage,
3040             initialMintingRecipient,
3041             upgradedFrom,
3042             initialDeployment
3043         )
3044     {
3045 
3046     }
3047 
3048     /**
3049      * @dev Proxies call to new token if this token is upgraded
3050      * @return the name of the token.
3051      */
3052     function name() public view returns(string) {
3053         if (isUpgraded()) {
3054             return getUpgradedToken().nameProxy(msg.sender);
3055         } else {
3056             return nameGuarded(msg.sender);
3057         }
3058     }
3059 
3060     /**
3061      * @dev Proxies call to new token if this token is upgraded
3062      * @return the symbol of the token.
3063      */
3064     function symbol() public view returns(string) {
3065         if (isUpgraded()) {
3066             return getUpgradedToken().symbolProxy(msg.sender);
3067         } else {
3068             return symbolGuarded(msg.sender);
3069         }
3070     }
3071 
3072     /**
3073      * @return the number of decimals of the token.
3074      */
3075     function decimals() public view returns(uint8) {
3076         if (isUpgraded()) {
3077             return getUpgradedToken().decimalsProxy(msg.sender);
3078         } else {
3079             return decimalsGuarded(msg.sender);
3080         }
3081     }
3082 
3083     /**
3084      * @dev Proxies call to new token if this token is upgraded
3085      * @return Total number of tokens in existence
3086      */
3087     function totalSupply() public view returns (uint256) {
3088         if (isUpgraded()) {
3089             return getUpgradedToken().totalSupplyProxy(msg.sender);
3090         } else {
3091             return totalSupplyGuarded(msg.sender);
3092         }
3093     }
3094 
3095     /**
3096      * @dev Gets the balance of the specified address.
3097      * @dev Proxies call to new token if this token is upgraded
3098      * @param who The address to query the balance of.
3099      * @return An uint256 representing the amount owned by the passed address.
3100      */
3101     function balanceOf(address who) public view returns (uint256) {
3102         if (isUpgraded()) {
3103             return getUpgradedToken().balanceOfProxy(msg.sender, who);
3104         } else {
3105             return balanceOfGuarded(msg.sender, who);
3106         }
3107     }
3108 
3109     /**
3110      * @dev Function to check the amount of tokens that an owner
3111      * allowed to a spender.
3112      * @dev Proxies call to new token if this token is upgraded
3113      * @param owner address The address which owns the funds.
3114      * @param spender address The address which will spend the funds.
3115      * @return A uint256 specifying the amount of tokens still available
3116      * for the spender.
3117      */
3118     function allowance(address owner, address spender)
3119         public
3120         view
3121         returns (uint256)
3122     {
3123         if (isUpgraded()) {
3124             return getUpgradedToken().allowanceProxy(
3125                 msg.sender,
3126                 owner,
3127                 spender
3128             );
3129         } else {
3130             return allowanceGuarded(msg.sender, owner, spender);
3131         }
3132     }
3133 
3134 
3135     /**
3136      * @dev Transfer token for a specified address
3137      * @dev Proxies call to new token if this token is upgraded
3138      * @param to The address to transfer to.
3139      * @param value The amount to be transferred.
3140      */
3141     function transfer(address to, uint256 value) public returns (bool) {
3142         if (isUpgraded()) {
3143             return getUpgradedToken().transferProxy(msg.sender, to, value);
3144         } else {
3145             return transferGuarded(msg.sender, to, value);
3146         }
3147     }
3148 
3149     /**
3150      * @dev Approve the passed address to spend the specified amount
3151      * of tokens on behalf of msg.sender.  Beware that changing an
3152      * allowance with this method brings the risk that someone may use
3153      * both the old and the new allowance by unfortunate transaction
3154      * ordering. One possible solution to mitigate this race condition
3155      * is to first reduce the spender's allowance to 0 and set the
3156      * desired value afterwards:
3157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
3158      * @dev Proxies call to new token if this token is upgraded
3159      * @param spender The address which will spend the funds.
3160      * @param value The amount of tokens to be spent.
3161      */
3162     function approve(address spender, uint256 value) public returns (bool) {
3163         if (isUpgraded()) {
3164             return getUpgradedToken().approveProxy(msg.sender, spender, value);
3165         } else {
3166             return approveGuarded(msg.sender, spender, value);
3167         }
3168     }
3169 
3170     /**
3171      * @dev Transfer tokens from one address to another
3172      * @dev Proxies call to new token if this token is upgraded
3173      * @param from address The address which you want to send tokens from
3174      * @param to address The address which you want to transfer to
3175      * @param value uint256 the amount of tokens to be transferred
3176      */
3177     function transferFrom(address from, address to, uint256 value)
3178         public
3179         returns (bool)
3180     {
3181         if (isUpgraded()) {
3182             return getUpgradedToken().transferFromProxy(
3183                 msg.sender,
3184                 from,
3185                 to,
3186                 value
3187             );
3188         } else {
3189             return transferFromGuarded(
3190                 msg.sender,
3191                 from,
3192                 to,
3193                 value
3194             );
3195         }
3196     }
3197 
3198     /**
3199      * @dev Function to mint tokens
3200      * @dev Proxies call to new token if this token is upgraded
3201      * @param to The address that will receive the minted tokens.
3202      * @param value The amount of tokens to mint.
3203      * @return A boolean that indicates if the operation was successful.
3204      */
3205     function mint(address to, uint256 value) public returns (bool) {
3206         if (isUpgraded()) {
3207             return getUpgradedToken().mintProxy(msg.sender, to, value);
3208         } else {
3209             return mintGuarded(msg.sender, to, value);
3210         }
3211     }
3212 
3213     /**
3214      * @dev Burns a specific amount of tokens.
3215      * @dev Proxies call to new token if this token is upgraded
3216      * @param value The amount of token to be burned.
3217      */
3218     function burn(uint256 value) public {
3219         if (isUpgraded()) {
3220             getUpgradedToken().burnProxy(msg.sender, value);
3221         } else {
3222             burnGuarded(msg.sender, value);
3223         }
3224     }
3225 
3226     /**
3227      * @dev Burns a specific amount of tokens from the target address
3228      * and decrements allowance
3229      * @dev Proxies call to new token if this token is upgraded
3230      * @param from address The address which you want to send tokens from
3231      * @param value uint256 The amount of token to be burned
3232      */
3233     function burnFrom(address from, uint256 value) public {
3234         if (isUpgraded()) {
3235             getUpgradedToken().burnFromProxy(msg.sender, from, value);
3236         } else {
3237             burnFromGuarded(msg.sender, from, value);
3238         }
3239     }
3240 
3241     /**
3242      * @dev Increase the amount of tokens that an owner allowed to a spender.
3243      * approve should be called when allowed_[_spender] == 0. To increment
3244      * allowed value is better to use this function to avoid 2 calls (and wait until
3245      * the first transaction is mined)
3246      * From MonolithDAO Token.sol
3247      * @dev Proxies call to new token if this token is upgraded
3248      * @param spender The address which will spend the funds.
3249      * @param addedValue The amount of tokens to increase the allowance by.
3250      */
3251     function increaseAllowance(
3252         address spender,
3253         uint addedValue
3254     )
3255         public
3256         returns (bool success)
3257     {
3258         if (isUpgraded()) {
3259             return getUpgradedToken().increaseAllowanceProxy(
3260                 msg.sender,
3261                 spender,
3262                 addedValue
3263             );
3264         } else {
3265             return increaseAllowanceGuarded(msg.sender, spender, addedValue);
3266         }
3267     }
3268 
3269     /**
3270      * @dev Decrease the amount of tokens that an owner allowed to a spender.
3271      * approve should be called when allowed_[_spender] == 0. To decrement
3272      * allowed value is better to use this function to avoid 2 calls (and wait until
3273      * the first transaction is mined)
3274      * From MonolithDAO Token.sol
3275      * @dev Proxies call to new token if this token is upgraded
3276      * @param spender The address which will spend the funds.
3277      * @param subtractedValue The amount of tokens to decrease the allowance by.
3278      */
3279     function decreaseAllowance(
3280         address spender,
3281         uint subtractedValue
3282     )
3283         public
3284         returns (bool success)
3285     {
3286         if (isUpgraded()) {
3287             return getUpgradedToken().decreaseAllowanceProxy(
3288                 msg.sender,
3289                 spender,
3290                 subtractedValue
3291             );
3292         } else {
3293             return super.decreaseAllowanceGuarded(
3294                 msg.sender,
3295                 spender,
3296                 subtractedValue
3297             );
3298         }
3299     }
3300 
3301     /**
3302      * @dev Allows the owner to change the current minting recipient account
3303      * @param mintingRecip address of new minting recipient
3304      */
3305     function changeMintingRecipient(address mintingRecip) public {
3306         if (isUpgraded()) {
3307             getUpgradedToken().changeMintingRecipientProxy(
3308                 msg.sender,
3309                 mintingRecip
3310             );
3311         } else {
3312             changeMintingRecipientGuarded(msg.sender, mintingRecip);
3313         }
3314     }
3315 
3316     /**
3317      * Allows a pauser to pause the current token.
3318      */
3319     function pause() public {
3320         if (isUpgraded()) {
3321             getUpgradedToken().pauseProxy(msg.sender);
3322         } else {
3323             pauseGuarded(msg.sender);
3324         }
3325     }
3326 
3327     /**
3328      * Allows a pauser to unpause the current token.
3329      */
3330     function unpause() public {
3331         if (isUpgraded()) {
3332             getUpgradedToken().unpauseProxy(msg.sender);
3333         } else {
3334             unpauseGuarded(msg.sender);
3335         }
3336     }
3337 
3338     /**
3339      * @return true if the contract is paused, false otherwise.
3340      */
3341     function paused() public view returns (bool) {
3342         if (isUpgraded()) {
3343             return getUpgradedToken().pausedProxy(msg.sender);
3344         } else {
3345             return pausedGuarded(msg.sender);
3346         }
3347     }
3348 }