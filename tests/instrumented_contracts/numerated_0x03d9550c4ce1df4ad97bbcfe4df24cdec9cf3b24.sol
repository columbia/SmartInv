1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 /*
5 
6     Copyright 2018 dYdX Trading Inc.
7 
8     Licensed under the Apache License, Version 2.0 (the "License");
9     you may not use this file except in compliance with the License.
10     You may obtain a copy of the License at
11 
12     http://www.apache.org/licenses/LICENSE-2.0
13 
14     Unless required by applicable law or agreed to in writing, software
15     distributed under the License is distributed on an "AS IS" BASIS,
16     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
17     See the License for the specific language governing permissions and
18     limitations under the License.
19 
20 */
21 
22 // File: openzeppelin-solidity/contracts/math/Math.sol
23 
24 /**
25  * @title Math
26  * @dev Assorted math operations
27  */
28 library Math {
29   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
30     return _a >= _b ? _a : _b;
31   }
32 
33   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
34     return _a < _b ? _a : _b;
35   }
36 
37   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
38     return _a >= _b ? _a : _b;
39   }
40 
41   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     return _a < _b ? _a : _b;
43   }
44 }
45 
46 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (_a == 0) {
62       return 0;
63     }
64 
65     c = _a * _b;
66     assert(c / _a == _b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     // assert(_b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = _a / _b;
76     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
77     return _a / _b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     assert(_b <= _a);
85     return _a - _b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
92     c = _a + _b;
93     assert(c >= _a);
94     return c;
95   }
96 }
97 
98 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
99 
100 /**
101  * @title Ownable
102  * @dev The Ownable contract has an owner address, and provides basic authorization control
103  * functions, this simplifies the implementation of "user permissions".
104  */
105 contract Ownable {
106   address public owner;
107 
108   event OwnershipRenounced(address indexed previousOwner);
109   event OwnershipTransferred(
110     address indexed previousOwner,
111     address indexed newOwner
112   );
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to relinquish control of the contract.
132    * @notice Renouncing to ownership will leave the contract without an owner.
133    * It will not be possible to call the functions with the `onlyOwner`
134    * modifier anymore.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address _newOwner) public onlyOwner {
146     _transferOwnership(_newOwner);
147   }
148 
149   /**
150    * @dev Transfers control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function _transferOwnership(address _newOwner) internal {
154     require(_newOwner != address(0));
155     emit OwnershipTransferred(owner, _newOwner);
156     owner = _newOwner;
157   }
158 }
159 
160 // File: contracts/lib/AccessControlledBase.sol
161 
162 /**
163  * @title AccessControlledBase
164  * @author dYdX
165  *
166  * Base functionality for access control. Requires an implementation to
167  * provide a way to grant and optionally revoke access
168  */
169 contract AccessControlledBase {
170     // ============ State Variables ============
171 
172     mapping (address => bool) public authorized;
173 
174     // ============ Events ============
175 
176     event AccessGranted(
177         address who
178     );
179 
180     event AccessRevoked(
181         address who
182     );
183 
184     // ============ Modifiers ============
185 
186     modifier requiresAuthorization() {
187         require(
188             authorized[msg.sender],
189             "AccessControlledBase#requiresAuthorization: Sender not authorized"
190         );
191         _;
192     }
193 }
194 
195 // File: contracts/lib/StaticAccessControlled.sol
196 
197 /**
198  * @title StaticAccessControlled
199  * @author dYdX
200  *
201  * Allows for functions to be access controled
202  * Permissions cannot be changed after a grace period
203  */
204 contract StaticAccessControlled is AccessControlledBase, Ownable {
205     using SafeMath for uint256;
206 
207     // ============ State Variables ============
208 
209     // Timestamp after which no additional access can be granted
210     uint256 public GRACE_PERIOD_EXPIRATION;
211 
212     // ============ Constructor ============
213 
214     constructor(
215         uint256 gracePeriod
216     )
217         public
218         Ownable()
219     {
220         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
221     }
222 
223     // ============ Owner-Only State-Changing Functions ============
224 
225     function grantAccess(
226         address who
227     )
228         external
229         onlyOwner
230     {
231         require(
232             block.timestamp < GRACE_PERIOD_EXPIRATION,
233             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
234         );
235 
236         emit AccessGranted(who);
237         authorized[who] = true;
238     }
239 }
240 
241 // File: contracts/lib/GeneralERC20.sol
242 
243 /**
244  * @title GeneralERC20
245  * @author dYdX
246  *
247  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
248  * that we dont automatically revert when calling non-compliant tokens that have no return value for
249  * transfer(), transferFrom(), or approve().
250  */
251 interface GeneralERC20 {
252     function totalSupply(
253     )
254         external
255         view
256         returns (uint256);
257 
258     function balanceOf(
259         address who
260     )
261         external
262         view
263         returns (uint256);
264 
265     function allowance(
266         address owner,
267         address spender
268     )
269         external
270         view
271         returns (uint256);
272 
273     function transfer(
274         address to,
275         uint256 value
276     )
277         external;
278 
279     function transferFrom(
280         address from,
281         address to,
282         uint256 value
283     )
284         external;
285 
286     function approve(
287         address spender,
288         uint256 value
289     )
290         external;
291 }
292 
293 // File: contracts/lib/TokenInteract.sol
294 
295 /**
296  * @title TokenInteract
297  * @author dYdX
298  *
299  * This library contains functions for interacting with ERC20 tokens
300  */
301 library TokenInteract {
302     function balanceOf(
303         address token,
304         address owner
305     )
306         internal
307         view
308         returns (uint256)
309     {
310         return GeneralERC20(token).balanceOf(owner);
311     }
312 
313     function allowance(
314         address token,
315         address owner,
316         address spender
317     )
318         internal
319         view
320         returns (uint256)
321     {
322         return GeneralERC20(token).allowance(owner, spender);
323     }
324 
325     function approve(
326         address token,
327         address spender,
328         uint256 amount
329     )
330         internal
331     {
332         GeneralERC20(token).approve(spender, amount);
333 
334         require(
335             checkSuccess(),
336             "TokenInteract#approve: Approval failed"
337         );
338     }
339 
340     function transfer(
341         address token,
342         address to,
343         uint256 amount
344     )
345         internal
346     {
347         address from = address(this);
348         if (
349             amount == 0
350             || from == to
351         ) {
352             return;
353         }
354 
355         GeneralERC20(token).transfer(to, amount);
356 
357         require(
358             checkSuccess(),
359             "TokenInteract#transfer: Transfer failed"
360         );
361     }
362 
363     function transferFrom(
364         address token,
365         address from,
366         address to,
367         uint256 amount
368     )
369         internal
370     {
371         if (
372             amount == 0
373             || from == to
374         ) {
375             return;
376         }
377 
378         GeneralERC20(token).transferFrom(from, to, amount);
379 
380         require(
381             checkSuccess(),
382             "TokenInteract#transferFrom: TransferFrom failed"
383         );
384     }
385 
386     // ============ Private Helper-Functions ============
387 
388     /**
389      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
390      * function returned 0 bytes or 32 bytes that are not all-zero.
391      */
392     function checkSuccess(
393     )
394         private
395         pure
396         returns (bool)
397     {
398         uint256 returnValue = 0;
399 
400         /* solium-disable-next-line security/no-inline-assembly */
401         assembly {
402             // check number of bytes returned from last function call
403             switch returndatasize
404 
405             // no bytes returned: assume success
406             case 0x0 {
407                 returnValue := 1
408             }
409 
410             // 32 bytes returned: check if non-zero
411             case 0x20 {
412                 // copy 32 bytes into scratch space
413                 returndatacopy(0x0, 0x0, 0x20)
414 
415                 // load those bytes into returnValue
416                 returnValue := mload(0x0)
417             }
418 
419             // not sure what was returned: dont mark as success
420             default { }
421         }
422 
423         return returnValue != 0;
424     }
425 }
426 
427 // File: contracts/margin/TokenProxy.sol
428 
429 /**
430  * @title TokenProxy
431  * @author dYdX
432  *
433  * Used to transfer tokens between addresses which have set allowance on this contract.
434  */
435 contract TokenProxy is StaticAccessControlled {
436     using SafeMath for uint256;
437 
438     // ============ Constructor ============
439 
440     constructor(
441         uint256 gracePeriod
442     )
443         public
444         StaticAccessControlled(gracePeriod)
445     {}
446 
447     // ============ Authorized-Only State Changing Functions ============
448 
449     /**
450      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
451      *
452      * @param  token  The address of the ERC20 token
453      * @param  from   The address to transfer token from
454      * @param  to     The address to transfer tokens to
455      * @param  value  The number of tokens to transfer
456      */
457     function transferTokens(
458         address token,
459         address from,
460         address to,
461         uint256 value
462     )
463         external
464         requiresAuthorization
465     {
466         TokenInteract.transferFrom(
467             token,
468             from,
469             to,
470             value
471         );
472     }
473 
474     // ============ Public Constant Functions ============
475 
476     /**
477      * Getter function to get the amount of token that the proxy is able to move for a particular
478      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
479      *
480      * @param  who    The owner of the tokens
481      * @param  token  The address of the ERC20 token
482      * @return        The number of tokens able to be moved by the proxy from the address specified
483      */
484     function available(
485         address who,
486         address token
487     )
488         external
489         view
490         returns (uint256)
491     {
492         return Math.min256(
493             TokenInteract.allowance(token, who, address(this)),
494             TokenInteract.balanceOf(token, who)
495         );
496     }
497 }
498 
499 // File: contracts/margin/Vault.sol
500 
501 /**
502  * @title Vault
503  * @author dYdX
504  *
505  * Holds and transfers tokens in vaults denominated by id
506  *
507  * Vault only supports ERC20 tokens, and will not accept any tokens that require
508  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
509  */
510 contract Vault is StaticAccessControlled
511 {
512     using SafeMath for uint256;
513 
514     // ============ Events ============
515 
516     event ExcessTokensWithdrawn(
517         address indexed token,
518         address indexed to,
519         address caller
520     );
521 
522     // ============ State Variables ============
523 
524     // Address of the TokenProxy contract. Used for moving tokens.
525     address public TOKEN_PROXY;
526 
527     // Map from vault ID to map from token address to amount of that token attributed to the
528     // particular vault ID.
529     mapping (bytes32 => mapping (address => uint256)) public balances;
530 
531     // Map from token address to total amount of that token attributed to some account.
532     mapping (address => uint256) public totalBalances;
533 
534     // ============ Constructor ============
535 
536     constructor(
537         address proxy,
538         uint256 gracePeriod
539     )
540         public
541         StaticAccessControlled(gracePeriod)
542     {
543         TOKEN_PROXY = proxy;
544     }
545 
546     // ============ Owner-Only State-Changing Functions ============
547 
548     /**
549      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
550      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
551      * will be accounted for and will not be withdrawable by this function.
552      *
553      * @param  token  ERC20 token address
554      * @param  to     Address to transfer tokens to
555      * @return        Amount of tokens withdrawn
556      */
557     function withdrawExcessToken(
558         address token,
559         address to
560     )
561         external
562         onlyOwner
563         returns (uint256)
564     {
565         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
566         uint256 accountedBalance = totalBalances[token];
567         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
568 
569         require(
570             withdrawableBalance != 0,
571             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
572         );
573 
574         TokenInteract.transfer(token, to, withdrawableBalance);
575 
576         emit ExcessTokensWithdrawn(token, to, msg.sender);
577 
578         return withdrawableBalance;
579     }
580 
581     // ============ Authorized-Only State-Changing Functions ============
582 
583     /**
584      * Transfers tokens from an address (that has approved the proxy) to the vault.
585      *
586      * @param  id      The vault which will receive the tokens
587      * @param  token   ERC20 token address
588      * @param  from    Address from which the tokens will be taken
589      * @param  amount  Number of the token to be sent
590      */
591     function transferToVault(
592         bytes32 id,
593         address token,
594         address from,
595         uint256 amount
596     )
597         external
598         requiresAuthorization
599     {
600         // First send tokens to this contract
601         TokenProxy(TOKEN_PROXY).transferTokens(
602             token,
603             from,
604             address(this),
605             amount
606         );
607 
608         // Then increment balances
609         balances[id][token] = balances[id][token].add(amount);
610         totalBalances[token] = totalBalances[token].add(amount);
611 
612         // This should always be true. If not, something is very wrong
613         assert(totalBalances[token] >= balances[id][token]);
614 
615         validateBalance(token);
616     }
617 
618     /**
619      * Transfers a certain amount of funds to an address.
620      *
621      * @param  id      The vault from which to send the tokens
622      * @param  token   ERC20 token address
623      * @param  to      Address to transfer tokens to
624      * @param  amount  Number of the token to be sent
625      */
626     function transferFromVault(
627         bytes32 id,
628         address token,
629         address to,
630         uint256 amount
631     )
632         external
633         requiresAuthorization
634     {
635         // Next line also asserts that (balances[id][token] >= amount);
636         balances[id][token] = balances[id][token].sub(amount);
637 
638         // Next line also asserts that (totalBalances[token] >= amount);
639         totalBalances[token] = totalBalances[token].sub(amount);
640 
641         // This should always be true. If not, something is very wrong
642         assert(totalBalances[token] >= balances[id][token]);
643 
644         // Do the sending
645         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
646 
647         // Final validation
648         validateBalance(token);
649     }
650 
651     // ============ Private Helper-Functions ============
652 
653     /**
654      * Verifies that this contract is in control of at least as many tokens as accounted for
655      *
656      * @param  token  Address of ERC20 token
657      */
658     function validateBalance(
659         address token
660     )
661         private
662         view
663     {
664         // The actual balance could be greater than totalBalances[token] because anyone
665         // can send tokens to the contract's address which cannot be accounted for
666         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
667     }
668 }
669 
670 // File: contracts/lib/ReentrancyGuard.sol
671 
672 /**
673  * @title ReentrancyGuard
674  * @author dYdX
675  *
676  * Optimized version of the well-known ReentrancyGuard contract
677  */
678 contract ReentrancyGuard {
679     uint256 private _guardCounter = 1;
680 
681     modifier nonReentrant() {
682         uint256 localCounter = _guardCounter + 1;
683         _guardCounter = localCounter;
684         _;
685         require(
686             _guardCounter == localCounter,
687             "Reentrancy check failure"
688         );
689     }
690 }
691 
692 // File: openzeppelin-solidity/contracts/AddressUtils.sol
693 
694 /**
695  * Utility library of inline functions on addresses
696  */
697 library AddressUtils {
698 
699   /**
700    * Returns whether the target address is a contract
701    * @dev This function will return false if invoked during the constructor of a contract,
702    * as the code is not actually created until after the constructor finishes.
703    * @param _addr address to check
704    * @return whether the target address is a contract
705    */
706   function isContract(address _addr) internal view returns (bool) {
707     uint256 size;
708     // XXX Currently there is no better way to check if there is a contract in an address
709     // than to check the size of the code at that address.
710     // See https://ethereum.stackexchange.com/a/14016/36603
711     // for more details about how this works.
712     // TODO Check this again before the Serenity release, because all addresses will be
713     // contracts then.
714     // solium-disable-next-line security/no-inline-assembly
715     assembly { size := extcodesize(_addr) }
716     return size > 0;
717   }
718 
719 }
720 
721 // File: contracts/lib/Fraction.sol
722 
723 /**
724  * @title Fraction
725  * @author dYdX
726  *
727  * This library contains implementations for fraction structs.
728  */
729 library Fraction {
730     struct Fraction128 {
731         uint128 num;
732         uint128 den;
733     }
734 }
735 
736 // File: contracts/lib/FractionMath.sol
737 
738 /**
739  * @title FractionMath
740  * @author dYdX
741  *
742  * This library contains safe math functions for manipulating fractions.
743  */
744 library FractionMath {
745     using SafeMath for uint256;
746     using SafeMath for uint128;
747 
748     /**
749      * Returns a Fraction128 that is equal to a + b
750      *
751      * @param  a  The first Fraction128
752      * @param  b  The second Fraction128
753      * @return    The result (sum)
754      */
755     function add(
756         Fraction.Fraction128 memory a,
757         Fraction.Fraction128 memory b
758     )
759         internal
760         pure
761         returns (Fraction.Fraction128 memory)
762     {
763         uint256 left = a.num.mul(b.den);
764         uint256 right = b.num.mul(a.den);
765         uint256 denominator = a.den.mul(b.den);
766 
767         // if left + right overflows, prevent overflow
768         if (left + right < left) {
769             left = left.div(2);
770             right = right.div(2);
771             denominator = denominator.div(2);
772         }
773 
774         return bound(left.add(right), denominator);
775     }
776 
777     /**
778      * Returns a Fraction128 that is equal to a - (1/2)^d
779      *
780      * @param  a  The Fraction128
781      * @param  d  The power of (1/2)
782      * @return    The result
783      */
784     function sub1Over(
785         Fraction.Fraction128 memory a,
786         uint128 d
787     )
788         internal
789         pure
790         returns (Fraction.Fraction128 memory)
791     {
792         if (a.den % d == 0) {
793             return bound(
794                 a.num.sub(a.den.div(d)),
795                 a.den
796             );
797         }
798         return bound(
799             a.num.mul(d).sub(a.den),
800             a.den.mul(d)
801         );
802     }
803 
804     /**
805      * Returns a Fraction128 that is equal to a / d
806      *
807      * @param  a  The first Fraction128
808      * @param  d  The divisor
809      * @return    The result (quotient)
810      */
811     function div(
812         Fraction.Fraction128 memory a,
813         uint128 d
814     )
815         internal
816         pure
817         returns (Fraction.Fraction128 memory)
818     {
819         if (a.num % d == 0) {
820             return bound(
821                 a.num.div(d),
822                 a.den
823             );
824         }
825         return bound(
826             a.num,
827             a.den.mul(d)
828         );
829     }
830 
831     /**
832      * Returns a Fraction128 that is equal to a * b.
833      *
834      * @param  a  The first Fraction128
835      * @param  b  The second Fraction128
836      * @return    The result (product)
837      */
838     function mul(
839         Fraction.Fraction128 memory a,
840         Fraction.Fraction128 memory b
841     )
842         internal
843         pure
844         returns (Fraction.Fraction128 memory)
845     {
846         return bound(
847             a.num.mul(b.num),
848             a.den.mul(b.den)
849         );
850     }
851 
852     /**
853      * Returns a fraction from two uint256's. Fits them into uint128 if necessary.
854      *
855      * @param  num  The numerator
856      * @param  den  The denominator
857      * @return      The Fraction128 that matches num/den most closely
858      */
859     /* solium-disable-next-line security/no-assign-params */
860     function bound(
861         uint256 num,
862         uint256 den
863     )
864         internal
865         pure
866         returns (Fraction.Fraction128 memory)
867     {
868         uint256 max = num > den ? num : den;
869         uint256 first128Bits = (max >> 128);
870         if (first128Bits != 0) {
871             first128Bits += 1;
872             num /= first128Bits;
873             den /= first128Bits;
874         }
875 
876         assert(den != 0); // coverage-enable-line
877         assert(den < 2**128);
878         assert(num < 2**128);
879 
880         return Fraction.Fraction128({
881             num: uint128(num),
882             den: uint128(den)
883         });
884     }
885 
886     /**
887      * Returns an in-memory copy of a Fraction128
888      *
889      * @param  a  The Fraction128 to copy
890      * @return    A copy of the Fraction128
891      */
892     function copy(
893         Fraction.Fraction128 memory a
894     )
895         internal
896         pure
897         returns (Fraction.Fraction128 memory)
898     {
899         validate(a);
900         return Fraction.Fraction128({ num: a.num, den: a.den });
901     }
902 
903     // ============ Private Helper-Functions ============
904 
905     /**
906      * Asserts that a Fraction128 is valid (i.e. the denominator is non-zero)
907      *
908      * @param  a  The Fraction128 to validate
909      */
910     function validate(
911         Fraction.Fraction128 memory a
912     )
913         private
914         pure
915     {
916         assert(a.den != 0); // coverage-enable-line
917     }
918 }
919 
920 // File: contracts/lib/Exponent.sol
921 
922 /**
923  * @title Exponent
924  * @author dYdX
925  *
926  * This library contains an implementation for calculating e^X for arbitrary fraction X
927  */
928 library Exponent {
929     using SafeMath for uint256;
930     using FractionMath for Fraction.Fraction128;
931 
932     // ============ Constants ============
933 
934     // 2**128 - 1
935     uint128 constant public MAX_NUMERATOR = 340282366920938463463374607431768211455;
936 
937     // Number of precomputed integers, X, for E^((1/2)^X)
938     uint256 constant public MAX_PRECOMPUTE_PRECISION = 32;
939 
940     // Number of precomputed integers, X, for E^X
941     uint256 constant public NUM_PRECOMPUTED_INTEGERS = 32;
942 
943     // ============ Public Implementation Functions ============
944 
945     /**
946      * Returns e^X for any fraction X
947      *
948      * @param  X                    The exponent
949      * @param  precomputePrecision  Accuracy of precomputed terms
950      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
951      * @return                      e^X
952      */
953     function exp(
954         Fraction.Fraction128 memory X,
955         uint256 precomputePrecision,
956         uint256 maclaurinPrecision
957     )
958         internal
959         pure
960         returns (Fraction.Fraction128 memory)
961     {
962         require(
963             precomputePrecision <= MAX_PRECOMPUTE_PRECISION,
964             "Exponent#exp: Precompute precision over maximum"
965         );
966 
967         Fraction.Fraction128 memory Xcopy = X.copy();
968         if (Xcopy.num == 0) { // e^0 = 1
969             return ONE();
970         }
971 
972         // get the integer value of the fraction (example: 9/4 is 2.25 so has integerValue of 2)
973         uint256 integerX = uint256(Xcopy.num).div(Xcopy.den);
974 
975         // if X is less than 1, then just calculate X
976         if (integerX == 0) {
977             return expHybrid(Xcopy, precomputePrecision, maclaurinPrecision);
978         }
979 
980         // get e^integerX
981         Fraction.Fraction128 memory expOfInt =
982             getPrecomputedEToThe(integerX % NUM_PRECOMPUTED_INTEGERS);
983         while (integerX >= NUM_PRECOMPUTED_INTEGERS) {
984             expOfInt = expOfInt.mul(getPrecomputedEToThe(NUM_PRECOMPUTED_INTEGERS));
985             integerX -= NUM_PRECOMPUTED_INTEGERS;
986         }
987 
988         // multiply e^integerX by e^decimalX
989         Fraction.Fraction128 memory decimalX = Fraction.Fraction128({
990             num: Xcopy.num % Xcopy.den,
991             den: Xcopy.den
992         });
993         return expHybrid(decimalX, precomputePrecision, maclaurinPrecision).mul(expOfInt);
994     }
995 
996     /**
997      * Returns e^X for any X < 1. Multiplies precomputed values to get close to the real value, then
998      * Maclaurin Series approximation to reduce error.
999      *
1000      * @param  X                    Exponent
1001      * @param  precomputePrecision  Accuracy of precomputed terms
1002      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1003      * @return                      e^X
1004      */
1005     function expHybrid(
1006         Fraction.Fraction128 memory X,
1007         uint256 precomputePrecision,
1008         uint256 maclaurinPrecision
1009     )
1010         internal
1011         pure
1012         returns (Fraction.Fraction128 memory)
1013     {
1014         assert(precomputePrecision <= MAX_PRECOMPUTE_PRECISION);
1015         assert(X.num < X.den);
1016         // will also throw if precomputePrecision is larger than the array length in getDenominator
1017 
1018         Fraction.Fraction128 memory Xtemp = X.copy();
1019         if (Xtemp.num == 0) { // e^0 = 1
1020             return ONE();
1021         }
1022 
1023         Fraction.Fraction128 memory result = ONE();
1024 
1025         uint256 d = 1; // 2^i
1026         for (uint256 i = 1; i <= precomputePrecision; i++) {
1027             d *= 2;
1028 
1029             // if Fraction > 1/d, subtract 1/d and multiply result by precomputed e^(1/d)
1030             if (d.mul(Xtemp.num) >= Xtemp.den) {
1031                 Xtemp = Xtemp.sub1Over(uint128(d));
1032                 result = result.mul(getPrecomputedEToTheHalfToThe(i));
1033             }
1034         }
1035         return result.mul(expMaclaurin(Xtemp, maclaurinPrecision));
1036     }
1037 
1038     /**
1039      * Returns e^X for any X, using Maclaurin Series approximation
1040      *
1041      * e^X = SUM(X^n / n!) for n >= 0
1042      * e^X = 1 + X/1! + X^2/2! + X^3/3! ...
1043      *
1044      * @param  X           Exponent
1045      * @param  precision   Accuracy of Maclaurin terms
1046      * @return             e^X
1047      */
1048     function expMaclaurin(
1049         Fraction.Fraction128 memory X,
1050         uint256 precision
1051     )
1052         internal
1053         pure
1054         returns (Fraction.Fraction128 memory)
1055     {
1056         Fraction.Fraction128 memory Xcopy = X.copy();
1057         if (Xcopy.num == 0) { // e^0 = 1
1058             return ONE();
1059         }
1060 
1061         Fraction.Fraction128 memory result = ONE();
1062         Fraction.Fraction128 memory Xtemp = ONE();
1063         for (uint256 i = 1; i <= precision; i++) {
1064             Xtemp = Xtemp.mul(Xcopy.div(uint128(i)));
1065             result = result.add(Xtemp);
1066         }
1067         return result;
1068     }
1069 
1070     /**
1071      * Returns a fraction roughly equaling E^((1/2)^x) for integer x
1072      */
1073     function getPrecomputedEToTheHalfToThe(
1074         uint256 x
1075     )
1076         internal
1077         pure
1078         returns (Fraction.Fraction128 memory)
1079     {
1080         assert(x <= MAX_PRECOMPUTE_PRECISION);
1081 
1082         uint128 denominator = [
1083             125182886983370532117250726298150828301,
1084             206391688497133195273760705512282642279,
1085             265012173823417992016237332255925138361,
1086             300298134811882980317033350418940119802,
1087             319665700530617779809390163992561606014,
1088             329812979126047300897653247035862915816,
1089             335006777809430963166468914297166288162,
1090             337634268532609249517744113622081347950,
1091             338955731696479810470146282672867036734,
1092             339618401537809365075354109784799900812,
1093             339950222128463181389559457827561204959,
1094             340116253979683015278260491021941090650,
1095             340199300311581465057079429423749235412,
1096             340240831081268226777032180141478221816,
1097             340261598367316729254995498374473399540,
1098             340271982485676106947851156443492415142,
1099             340277174663693808406010255284800906112,
1100             340279770782412691177936847400746725466,
1101             340281068849199706686796915841848278311,
1102             340281717884450116236033378667952410919,
1103             340282042402539547492367191008339680733,
1104             340282204661700319870089970029119685699,
1105             340282285791309720262481214385569134454,
1106             340282326356121674011576912006427792656,
1107             340282346638529464274601981200276914173,
1108             340282356779733812753265346086924801364,
1109             340282361850336100329388676752133324799,
1110             340282364385637272451648746721404212564,
1111             340282365653287865596328444437856608255,
1112             340282366287113163939555716675618384724,
1113             340282366604025813553891209601455838559,
1114             340282366762482138471739420386372790954,
1115             340282366841710300958333641874363209044
1116         ][x];
1117         return Fraction.Fraction128({
1118             num: MAX_NUMERATOR,
1119             den: denominator
1120         });
1121     }
1122 
1123     /**
1124      * Returns a fraction roughly equaling E^(x) for integer x
1125      */
1126     function getPrecomputedEToThe(
1127         uint256 x
1128     )
1129         internal
1130         pure
1131         returns (Fraction.Fraction128 memory)
1132     {
1133         assert(x <= NUM_PRECOMPUTED_INTEGERS);
1134 
1135         uint128 denominator = [
1136             340282366920938463463374607431768211455,
1137             125182886983370532117250726298150828301,
1138             46052210507670172419625860892627118820,
1139             16941661466271327126146327822211253888,
1140             6232488952727653950957829210887653621,
1141             2292804553036637136093891217529878878,
1142             843475657686456657683449904934172134,
1143             310297353591408453462393329342695980,
1144             114152017036184782947077973323212575,
1145             41994180235864621538772677139808695,
1146             15448795557622704876497742989562086,
1147             5683294276510101335127414470015662,
1148             2090767122455392675095471286328463,
1149             769150240628514374138961856925097,
1150             282954560699298259527814398449860,
1151             104093165666968799599694528310221,
1152             38293735615330848145349245349513,
1153             14087478058534870382224480725096,
1154             5182493555688763339001418388912,
1155             1906532833141383353974257736699,
1156             701374233231058797338605168652,
1157             258021160973090761055471434334,
1158             94920680509187392077350434438,
1159             34919366901332874995585576427,
1160             12846117181722897538509298435,
1161             4725822410035083116489797150,
1162             1738532907279185132707372378,
1163             639570514388029575350057932,
1164             235284843422800231081973821,
1165             86556456714490055457751527,
1166             31842340925906738090071268,
1167             11714142585413118080082437,
1168             4309392228124372433711936
1169         ][x];
1170         return Fraction.Fraction128({
1171             num: MAX_NUMERATOR,
1172             den: denominator
1173         });
1174     }
1175 
1176     // ============ Private Helper-Functions ============
1177 
1178     function ONE()
1179         private
1180         pure
1181         returns (Fraction.Fraction128 memory)
1182     {
1183         return Fraction.Fraction128({ num: 1, den: 1 });
1184     }
1185 }
1186 
1187 // File: contracts/lib/MathHelpers.sol
1188 
1189 /**
1190  * @title MathHelpers
1191  * @author dYdX
1192  *
1193  * This library helps with common math functions in Solidity
1194  */
1195 library MathHelpers {
1196     using SafeMath for uint256;
1197 
1198     /**
1199      * Calculates partial value given a numerator and denominator.
1200      *
1201      * @param  numerator    Numerator
1202      * @param  denominator  Denominator
1203      * @param  target       Value to calculate partial of
1204      * @return              target * numerator / denominator
1205      */
1206     function getPartialAmount(
1207         uint256 numerator,
1208         uint256 denominator,
1209         uint256 target
1210     )
1211         internal
1212         pure
1213         returns (uint256)
1214     {
1215         return numerator.mul(target).div(denominator);
1216     }
1217 
1218     /**
1219      * Calculates partial value given a numerator and denominator, rounded up.
1220      *
1221      * @param  numerator    Numerator
1222      * @param  denominator  Denominator
1223      * @param  target       Value to calculate partial of
1224      * @return              Rounded-up result of target * numerator / denominator
1225      */
1226     function getPartialAmountRoundedUp(
1227         uint256 numerator,
1228         uint256 denominator,
1229         uint256 target
1230     )
1231         internal
1232         pure
1233         returns (uint256)
1234     {
1235         return divisionRoundedUp(numerator.mul(target), denominator);
1236     }
1237 
1238     /**
1239      * Calculates division given a numerator and denominator, rounded up.
1240      *
1241      * @param  numerator    Numerator.
1242      * @param  denominator  Denominator.
1243      * @return              Rounded-up result of numerator / denominator
1244      */
1245     function divisionRoundedUp(
1246         uint256 numerator,
1247         uint256 denominator
1248     )
1249         internal
1250         pure
1251         returns (uint256)
1252     {
1253         assert(denominator != 0); // coverage-enable-line
1254         if (numerator == 0) {
1255             return 0;
1256         }
1257         return numerator.sub(1).div(denominator).add(1);
1258     }
1259 
1260     /**
1261      * Calculates and returns the maximum value for a uint256 in solidity
1262      *
1263      * @return  The maximum value for uint256
1264      */
1265     function maxUint256(
1266     )
1267         internal
1268         pure
1269         returns (uint256)
1270     {
1271         return 2 ** 256 - 1;
1272     }
1273 
1274     /**
1275      * Calculates and returns the maximum value for a uint256 in solidity
1276      *
1277      * @return  The maximum value for uint256
1278      */
1279     function maxUint32(
1280     )
1281         internal
1282         pure
1283         returns (uint32)
1284     {
1285         return 2 ** 32 - 1;
1286     }
1287 
1288     /**
1289      * Returns the number of bits in a uint256. That is, the lowest number, x, such that n >> x == 0
1290      *
1291      * @param  n  The uint256 to get the number of bits in
1292      * @return    The number of bits in n
1293      */
1294     function getNumBits(
1295         uint256 n
1296     )
1297         internal
1298         pure
1299         returns (uint256)
1300     {
1301         uint256 first = 0;
1302         uint256 last = 256;
1303         while (first < last) {
1304             uint256 check = (first + last) / 2;
1305             if ((n >> check) == 0) {
1306                 last = check;
1307             } else {
1308                 first = check + 1;
1309             }
1310         }
1311         assert(first <= 256);
1312         return first;
1313     }
1314 }
1315 
1316 // File: contracts/margin/impl/InterestImpl.sol
1317 
1318 /**
1319  * @title InterestImpl
1320  * @author dYdX
1321  *
1322  * A library that calculates continuously compounded interest for principal, time period, and
1323  * interest rate.
1324  */
1325 library InterestImpl {
1326     using SafeMath for uint256;
1327     using FractionMath for Fraction.Fraction128;
1328 
1329     // ============ Constants ============
1330 
1331     uint256 constant DEFAULT_PRECOMPUTE_PRECISION = 11;
1332 
1333     uint256 constant DEFAULT_MACLAURIN_PRECISION = 5;
1334 
1335     uint256 constant MAXIMUM_EXPONENT = 80;
1336 
1337     uint128 constant E_TO_MAXIUMUM_EXPONENT = 55406223843935100525711733958316613;
1338 
1339     // ============ Public Implementation Functions ============
1340 
1341     /**
1342      * Returns total tokens owed after accruing interest. Continuously compounding and accurate to
1343      * roughly 10^18 decimal places. Continuously compounding interest follows the formula:
1344      * I = P * e^(R*T)
1345      *
1346      * @param  principal           Principal of the interest calculation
1347      * @param  interestRate        Annual nominal interest percentage times 10**6.
1348      *                             (example: 5% = 5e6)
1349      * @param  secondsOfInterest   Number of seconds that interest has been accruing
1350      * @return                     Total amount of tokens owed. Greater than tokenAmount.
1351      */
1352     function getCompoundedInterest(
1353         uint256 principal,
1354         uint256 interestRate,
1355         uint256 secondsOfInterest
1356     )
1357         public
1358         pure
1359         returns (uint256)
1360     {
1361         uint256 numerator = interestRate.mul(secondsOfInterest);
1362         uint128 denominator = (10**8) * (365 * 1 days);
1363 
1364         // interestRate and secondsOfInterest should both be uint32
1365         assert(numerator < 2**128);
1366 
1367         // fraction representing (Rate * Time)
1368         Fraction.Fraction128 memory rt = Fraction.Fraction128({
1369             num: uint128(numerator),
1370             den: denominator
1371         });
1372 
1373         // calculate e^(RT)
1374         Fraction.Fraction128 memory eToRT;
1375         if (numerator.div(denominator) >= MAXIMUM_EXPONENT) {
1376             // degenerate case: cap calculation
1377             eToRT = Fraction.Fraction128({
1378                 num: E_TO_MAXIUMUM_EXPONENT,
1379                 den: 1
1380             });
1381         } else {
1382             // normal case: calculate e^(RT)
1383             eToRT = Exponent.exp(
1384                 rt,
1385                 DEFAULT_PRECOMPUTE_PRECISION,
1386                 DEFAULT_MACLAURIN_PRECISION
1387             );
1388         }
1389 
1390         // e^X for positive X should be greater-than or equal to 1
1391         assert(eToRT.num >= eToRT.den);
1392 
1393         return safeMultiplyUint256ByFraction(principal, eToRT);
1394     }
1395 
1396     // ============ Private Helper-Functions ============
1397 
1398     /**
1399      * Returns n * f, trying to prevent overflow as much as possible. Assumes that the numerator
1400      * and denominator of f are less than 2**128.
1401      */
1402     function safeMultiplyUint256ByFraction(
1403         uint256 n,
1404         Fraction.Fraction128 memory f
1405     )
1406         private
1407         pure
1408         returns (uint256)
1409     {
1410         uint256 term1 = n.div(2 ** 128); // first 128 bits
1411         uint256 term2 = n % (2 ** 128); // second 128 bits
1412 
1413         // uncommon scenario, requires n >= 2**128. calculates term1 = term1 * f
1414         if (term1 > 0) {
1415             term1 = term1.mul(f.num);
1416             uint256 numBits = MathHelpers.getNumBits(term1);
1417 
1418             // reduce rounding error by shifting all the way to the left before dividing
1419             term1 = MathHelpers.divisionRoundedUp(
1420                 term1 << (uint256(256).sub(numBits)),
1421                 f.den);
1422 
1423             // continue shifting or reduce shifting to get the right number
1424             if (numBits > 128) {
1425                 term1 = term1 << (numBits.sub(128));
1426             } else if (numBits < 128) {
1427                 term1 = term1 >> (uint256(128).sub(numBits));
1428             }
1429         }
1430 
1431         // calculates term2 = term2 * f
1432         term2 = MathHelpers.getPartialAmountRoundedUp(
1433             f.num,
1434             f.den,
1435             term2
1436         );
1437 
1438         return term1.add(term2);
1439     }
1440 }
1441 
1442 // File: contracts/margin/impl/MarginState.sol
1443 
1444 /**
1445  * @title MarginState
1446  * @author dYdX
1447  *
1448  * Contains state for the Margin contract. Also used by libraries that implement Margin functions.
1449  */
1450 library MarginState {
1451     struct State {
1452         // Address of the Vault contract
1453         address VAULT;
1454 
1455         // Address of the TokenProxy contract
1456         address TOKEN_PROXY;
1457 
1458         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1459         // already been filled.
1460         mapping (bytes32 => uint256) loanFills;
1461 
1462         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1463         // already been canceled.
1464         mapping (bytes32 => uint256) loanCancels;
1465 
1466         // Mapping from positionId -> Position, which stores all the open margin positions.
1467         mapping (bytes32 => MarginCommon.Position) positions;
1468 
1469         // Mapping from positionId -> bool, which stores whether the position has previously been
1470         // open, but is now closed.
1471         mapping (bytes32 => bool) closedPositions;
1472 
1473         // Mapping from positionId -> uint256, which stores the total amount of owedToken that has
1474         // ever been repaid to the lender for each position. Does not reset.
1475         mapping (bytes32 => uint256) totalOwedTokenRepaidToLender;
1476     }
1477 }
1478 
1479 // File: contracts/margin/interfaces/lender/LoanOwner.sol
1480 
1481 /**
1482  * @title LoanOwner
1483  * @author dYdX
1484  *
1485  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
1486  *
1487  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1488  *       to these functions
1489  */
1490 interface LoanOwner {
1491 
1492     // ============ Public Interface functions ============
1493 
1494     /**
1495      * Function a contract must implement in order to receive ownership of a loan sell via the
1496      * transferLoan function or the atomic-assign to the "owner" field in a loan offering.
1497      *
1498      * @param  from        Address of the previous owner
1499      * @param  positionId  Unique ID of the position
1500      * @return             This address to keep ownership, a different address to pass-on ownership
1501      */
1502     function receiveLoanOwnership(
1503         address from,
1504         bytes32 positionId
1505     )
1506         external
1507         /* onlyMargin */
1508         returns (address);
1509 }
1510 
1511 // File: contracts/margin/interfaces/owner/PositionOwner.sol
1512 
1513 /**
1514  * @title PositionOwner
1515  * @author dYdX
1516  *
1517  * Interface that smart contracts must implement in order to own position on behalf of other
1518  * accounts
1519  *
1520  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1521  *       to these functions
1522  */
1523 interface PositionOwner {
1524 
1525     // ============ Public Interface functions ============
1526 
1527     /**
1528      * Function a contract must implement in order to receive ownership of a position via the
1529      * transferPosition function or the atomic-assign to the "owner" field when opening a position.
1530      *
1531      * @param  from        Address of the previous owner
1532      * @param  positionId  Unique ID of the position
1533      * @return             This address to keep ownership, a different address to pass-on ownership
1534      */
1535     function receivePositionOwnership(
1536         address from,
1537         bytes32 positionId
1538     )
1539         external
1540         /* onlyMargin */
1541         returns (address);
1542 }
1543 
1544 // File: contracts/margin/impl/TransferInternal.sol
1545 
1546 /**
1547  * @title TransferInternal
1548  * @author dYdX
1549  *
1550  * This library contains the implementation for transferring ownership of loans and positions.
1551  */
1552 library TransferInternal {
1553 
1554     // ============ Events ============
1555 
1556     /**
1557      * Ownership of a loan was transferred to a new address
1558      */
1559     event LoanTransferred(
1560         bytes32 indexed positionId,
1561         address indexed from,
1562         address indexed to
1563     );
1564 
1565     /**
1566      * Ownership of a postion was transferred to a new address
1567      */
1568     event PositionTransferred(
1569         bytes32 indexed positionId,
1570         address indexed from,
1571         address indexed to
1572     );
1573 
1574     // ============ Internal Implementation Functions ============
1575 
1576     /**
1577      * Returns either the address of the new loan owner, or the address to which they wish to
1578      * pass ownership of the loan. This function does not actually set the state of the position
1579      *
1580      * @param  positionId  The Unique ID of the position
1581      * @param  oldOwner    The previous owner of the loan
1582      * @param  newOwner    The intended owner of the loan
1583      * @return             The address that the intended owner wishes to assign the loan to (may be
1584      *                     the same as the intended owner).
1585      */
1586     function grantLoanOwnership(
1587         bytes32 positionId,
1588         address oldOwner,
1589         address newOwner
1590     )
1591         internal
1592         returns (address)
1593     {
1594         // log event except upon position creation
1595         if (oldOwner != address(0)) {
1596             emit LoanTransferred(positionId, oldOwner, newOwner);
1597         }
1598 
1599         if (AddressUtils.isContract(newOwner)) {
1600             address nextOwner =
1601                 LoanOwner(newOwner).receiveLoanOwnership(oldOwner, positionId);
1602             if (nextOwner != newOwner) {
1603                 return grantLoanOwnership(positionId, newOwner, nextOwner);
1604             }
1605         }
1606 
1607         require(
1608             newOwner != address(0),
1609             "TransferInternal#grantLoanOwnership: New owner did not consent to owning loan"
1610         );
1611 
1612         return newOwner;
1613     }
1614 
1615     /**
1616      * Returns either the address of the new position owner, or the address to which they wish to
1617      * pass ownership of the position. This function does not actually set the state of the position
1618      *
1619      * @param  positionId  The Unique ID of the position
1620      * @param  oldOwner    The previous owner of the position
1621      * @param  newOwner    The intended owner of the position
1622      * @return             The address that the intended owner wishes to assign the position to (may
1623      *                     be the same as the intended owner).
1624      */
1625     function grantPositionOwnership(
1626         bytes32 positionId,
1627         address oldOwner,
1628         address newOwner
1629     )
1630         internal
1631         returns (address)
1632     {
1633         // log event except upon position creation
1634         if (oldOwner != address(0)) {
1635             emit PositionTransferred(positionId, oldOwner, newOwner);
1636         }
1637 
1638         if (AddressUtils.isContract(newOwner)) {
1639             address nextOwner =
1640                 PositionOwner(newOwner).receivePositionOwnership(oldOwner, positionId);
1641             if (nextOwner != newOwner) {
1642                 return grantPositionOwnership(positionId, newOwner, nextOwner);
1643             }
1644         }
1645 
1646         require(
1647             newOwner != address(0),
1648             "TransferInternal#grantPositionOwnership: New owner did not consent to owning position"
1649         );
1650 
1651         return newOwner;
1652     }
1653 }
1654 
1655 // File: contracts/lib/TimestampHelper.sol
1656 
1657 /**
1658  * @title TimestampHelper
1659  * @author dYdX
1660  *
1661  * Helper to get block timestamps in other formats
1662  */
1663 library TimestampHelper {
1664     function getBlockTimestamp32()
1665         internal
1666         view
1667         returns (uint32)
1668     {
1669         // Should not still be in-use in the year 2106
1670         assert(uint256(uint32(block.timestamp)) == block.timestamp);
1671 
1672         assert(block.timestamp > 0);
1673 
1674         return uint32(block.timestamp);
1675     }
1676 }
1677 
1678 // File: contracts/margin/impl/MarginCommon.sol
1679 
1680 /**
1681  * @title MarginCommon
1682  * @author dYdX
1683  *
1684  * This library contains common functions for implementations of public facing Margin functions
1685  */
1686 library MarginCommon {
1687     using SafeMath for uint256;
1688 
1689     // ============ Structs ============
1690 
1691     struct Position {
1692         address owedToken;       // Immutable
1693         address heldToken;       // Immutable
1694         address lender;
1695         address owner;
1696         uint256 principal;
1697         uint256 requiredDeposit;
1698         uint32  callTimeLimit;   // Immutable
1699         uint32  startTimestamp;  // Immutable, cannot be 0
1700         uint32  callTimestamp;
1701         uint32  maxDuration;     // Immutable
1702         uint32  interestRate;    // Immutable
1703         uint32  interestPeriod;  // Immutable
1704     }
1705 
1706     struct LoanOffering {
1707         address   owedToken;
1708         address   heldToken;
1709         address   payer;
1710         address   owner;
1711         address   taker;
1712         address   positionOwner;
1713         address   feeRecipient;
1714         address   lenderFeeToken;
1715         address   takerFeeToken;
1716         LoanRates rates;
1717         uint256   expirationTimestamp;
1718         uint32    callTimeLimit;
1719         uint32    maxDuration;
1720         uint256   salt;
1721         bytes32   loanHash;
1722         bytes     signature;
1723     }
1724 
1725     struct LoanRates {
1726         uint256 maxAmount;
1727         uint256 minAmount;
1728         uint256 minHeldToken;
1729         uint256 lenderFee;
1730         uint256 takerFee;
1731         uint32  interestRate;
1732         uint32  interestPeriod;
1733     }
1734 
1735     // ============ Internal Implementation Functions ============
1736 
1737     function storeNewPosition(
1738         MarginState.State storage state,
1739         bytes32 positionId,
1740         Position memory position,
1741         address loanPayer
1742     )
1743         internal
1744     {
1745         assert(!positionHasExisted(state, positionId));
1746         assert(position.owedToken != address(0));
1747         assert(position.heldToken != address(0));
1748         assert(position.owedToken != position.heldToken);
1749         assert(position.owner != address(0));
1750         assert(position.lender != address(0));
1751         assert(position.maxDuration != 0);
1752         assert(position.interestPeriod <= position.maxDuration);
1753         assert(position.callTimestamp == 0);
1754         assert(position.requiredDeposit == 0);
1755 
1756         state.positions[positionId].owedToken = position.owedToken;
1757         state.positions[positionId].heldToken = position.heldToken;
1758         state.positions[positionId].principal = position.principal;
1759         state.positions[positionId].callTimeLimit = position.callTimeLimit;
1760         state.positions[positionId].startTimestamp = TimestampHelper.getBlockTimestamp32();
1761         state.positions[positionId].maxDuration = position.maxDuration;
1762         state.positions[positionId].interestRate = position.interestRate;
1763         state.positions[positionId].interestPeriod = position.interestPeriod;
1764 
1765         state.positions[positionId].owner = TransferInternal.grantPositionOwnership(
1766             positionId,
1767             (position.owner != msg.sender) ? msg.sender : address(0),
1768             position.owner
1769         );
1770 
1771         state.positions[positionId].lender = TransferInternal.grantLoanOwnership(
1772             positionId,
1773             (position.lender != loanPayer) ? loanPayer : address(0),
1774             position.lender
1775         );
1776     }
1777 
1778     function getPositionIdFromNonce(
1779         uint256 nonce
1780     )
1781         internal
1782         view
1783         returns (bytes32)
1784     {
1785         return keccak256(abi.encodePacked(msg.sender, nonce));
1786     }
1787 
1788     function getUnavailableLoanOfferingAmountImpl(
1789         MarginState.State storage state,
1790         bytes32 loanHash
1791     )
1792         internal
1793         view
1794         returns (uint256)
1795     {
1796         return state.loanFills[loanHash].add(state.loanCancels[loanHash]);
1797     }
1798 
1799     function cleanupPosition(
1800         MarginState.State storage state,
1801         bytes32 positionId
1802     )
1803         internal
1804     {
1805         delete state.positions[positionId];
1806         state.closedPositions[positionId] = true;
1807     }
1808 
1809     function calculateOwedAmount(
1810         Position storage position,
1811         uint256 closeAmount,
1812         uint256 endTimestamp
1813     )
1814         internal
1815         view
1816         returns (uint256)
1817     {
1818         uint256 timeElapsed = calculateEffectiveTimeElapsed(position, endTimestamp);
1819 
1820         return InterestImpl.getCompoundedInterest(
1821             closeAmount,
1822             position.interestRate,
1823             timeElapsed
1824         );
1825     }
1826 
1827     /**
1828      * Calculates time elapsed rounded up to the nearest interestPeriod
1829      */
1830     function calculateEffectiveTimeElapsed(
1831         Position storage position,
1832         uint256 timestamp
1833     )
1834         internal
1835         view
1836         returns (uint256)
1837     {
1838         uint256 elapsed = timestamp.sub(position.startTimestamp);
1839 
1840         // round up to interestPeriod
1841         uint256 period = position.interestPeriod;
1842         if (period > 1) {
1843             elapsed = MathHelpers.divisionRoundedUp(elapsed, period).mul(period);
1844         }
1845 
1846         // bound by maxDuration
1847         return Math.min256(
1848             elapsed,
1849             position.maxDuration
1850         );
1851     }
1852 
1853     function calculateLenderAmountForIncreasePosition(
1854         Position storage position,
1855         uint256 principalToAdd,
1856         uint256 endTimestamp
1857     )
1858         internal
1859         view
1860         returns (uint256)
1861     {
1862         uint256 timeElapsed = calculateEffectiveTimeElapsedForNewLender(position, endTimestamp);
1863 
1864         return InterestImpl.getCompoundedInterest(
1865             principalToAdd,
1866             position.interestRate,
1867             timeElapsed
1868         );
1869     }
1870 
1871     function getLoanOfferingHash(
1872         LoanOffering loanOffering
1873     )
1874         internal
1875         view
1876         returns (bytes32)
1877     {
1878         return keccak256(
1879             abi.encodePacked(
1880                 address(this),
1881                 loanOffering.owedToken,
1882                 loanOffering.heldToken,
1883                 loanOffering.payer,
1884                 loanOffering.owner,
1885                 loanOffering.taker,
1886                 loanOffering.positionOwner,
1887                 loanOffering.feeRecipient,
1888                 loanOffering.lenderFeeToken,
1889                 loanOffering.takerFeeToken,
1890                 getValuesHash(loanOffering)
1891             )
1892         );
1893     }
1894 
1895     function getPositionBalanceImpl(
1896         MarginState.State storage state,
1897         bytes32 positionId
1898     )
1899         internal
1900         view
1901         returns(uint256)
1902     {
1903         return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
1904     }
1905 
1906     function containsPositionImpl(
1907         MarginState.State storage state,
1908         bytes32 positionId
1909     )
1910         internal
1911         view
1912         returns (bool)
1913     {
1914         return state.positions[positionId].startTimestamp != 0;
1915     }
1916 
1917     function positionHasExisted(
1918         MarginState.State storage state,
1919         bytes32 positionId
1920     )
1921         internal
1922         view
1923         returns (bool)
1924     {
1925         return containsPositionImpl(state, positionId) || state.closedPositions[positionId];
1926     }
1927 
1928     function getPositionFromStorage(
1929         MarginState.State storage state,
1930         bytes32 positionId
1931     )
1932         internal
1933         view
1934         returns (Position storage)
1935     {
1936         Position storage position = state.positions[positionId];
1937 
1938         require(
1939             position.startTimestamp != 0,
1940             "MarginCommon#getPositionFromStorage: The position does not exist"
1941         );
1942 
1943         return position;
1944     }
1945 
1946     // ============ Private Helper-Functions ============
1947 
1948     /**
1949      * Calculates time elapsed rounded down to the nearest interestPeriod
1950      */
1951     function calculateEffectiveTimeElapsedForNewLender(
1952         Position storage position,
1953         uint256 timestamp
1954     )
1955         private
1956         view
1957         returns (uint256)
1958     {
1959         uint256 elapsed = timestamp.sub(position.startTimestamp);
1960 
1961         // round down to interestPeriod
1962         uint256 period = position.interestPeriod;
1963         if (period > 1) {
1964             elapsed = elapsed.div(period).mul(period);
1965         }
1966 
1967         // bound by maxDuration
1968         return Math.min256(
1969             elapsed,
1970             position.maxDuration
1971         );
1972     }
1973 
1974     function getValuesHash(
1975         LoanOffering loanOffering
1976     )
1977         private
1978         pure
1979         returns (bytes32)
1980     {
1981         return keccak256(
1982             abi.encodePacked(
1983                 loanOffering.rates.maxAmount,
1984                 loanOffering.rates.minAmount,
1985                 loanOffering.rates.minHeldToken,
1986                 loanOffering.rates.lenderFee,
1987                 loanOffering.rates.takerFee,
1988                 loanOffering.expirationTimestamp,
1989                 loanOffering.salt,
1990                 loanOffering.callTimeLimit,
1991                 loanOffering.maxDuration,
1992                 loanOffering.rates.interestRate,
1993                 loanOffering.rates.interestPeriod
1994             )
1995         );
1996     }
1997 }
1998 
1999 // File: contracts/margin/interfaces/PayoutRecipient.sol
2000 
2001 /**
2002  * @title PayoutRecipient
2003  * @author dYdX
2004  *
2005  * Interface that smart contracts must implement in order to be the payoutRecipient in a
2006  * closePosition transaction.
2007  *
2008  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2009  *       to these functions
2010  */
2011 interface PayoutRecipient {
2012 
2013     // ============ Public Interface functions ============
2014 
2015     /**
2016      * Function a contract must implement in order to receive payout from being the payoutRecipient
2017      * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.
2018      *
2019      * @param  positionId         Unique ID of the position
2020      * @param  closeAmount        Amount of the position that was closed
2021      * @param  closer             Address of the account or contract that closed the position
2022      * @param  positionOwner      Address of the owner of the position
2023      * @param  heldToken          Address of the ERC20 heldToken
2024      * @param  payout             Number of tokens received from the payout
2025      * @param  totalHeldToken     Total amount of heldToken removed from vault during close
2026      * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken
2027      * @return                    True if approved by the receiver
2028      */
2029     function receiveClosePositionPayout(
2030         bytes32 positionId,
2031         uint256 closeAmount,
2032         address closer,
2033         address positionOwner,
2034         address heldToken,
2035         uint256 payout,
2036         uint256 totalHeldToken,
2037         bool    payoutInHeldToken
2038     )
2039         external
2040         /* onlyMargin */
2041         returns (bool);
2042 }
2043 
2044 // File: contracts/margin/interfaces/lender/CloseLoanDelegator.sol
2045 
2046 /**
2047  * @title CloseLoanDelegator
2048  * @author dYdX
2049  *
2050  * Interface that smart contracts must implement in order to let other addresses close a loan
2051  * owned by the smart contract.
2052  *
2053  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2054  *       to these functions
2055  */
2056 interface CloseLoanDelegator {
2057 
2058     // ============ Public Interface functions ============
2059 
2060     /**
2061      * Function a contract must implement in order to let other addresses call
2062      * closeWithoutCounterparty().
2063      *
2064      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2065      * either revert the entire transaction or that (at most) the specified amount of the loan was
2066      * successfully closed.
2067      *
2068      * @param  closer           Address of the caller of closeWithoutCounterparty()
2069      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2070      * @param  positionId       Unique ID of the position
2071      * @param  requestedAmount  Requested principal amount of the loan to close
2072      * @return                  1) This address to accept, a different address to ask that contract
2073      *                          2) The maximum amount that this contract is allowing
2074      */
2075     function closeLoanOnBehalfOf(
2076         address closer,
2077         address payoutRecipient,
2078         bytes32 positionId,
2079         uint256 requestedAmount
2080     )
2081         external
2082         /* onlyMargin */
2083         returns (address, uint256);
2084 }
2085 
2086 // File: contracts/margin/interfaces/owner/ClosePositionDelegator.sol
2087 
2088 /**
2089  * @title ClosePositionDelegator
2090  * @author dYdX
2091  *
2092  * Interface that smart contracts must implement in order to let other addresses close a position
2093  * owned by the smart contract, allowing more complex logic to control positions.
2094  *
2095  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2096  *       to these functions
2097  */
2098 interface ClosePositionDelegator {
2099 
2100     // ============ Public Interface functions ============
2101 
2102     /**
2103      * Function a contract must implement in order to let other addresses call closePosition().
2104      *
2105      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2106      * either revert the entire transaction or that (at-most) the specified amount of the position
2107      * was successfully closed.
2108      *
2109      * @param  closer           Address of the caller of the closePosition() function
2110      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2111      * @param  positionId       Unique ID of the position
2112      * @param  requestedAmount  Requested principal amount of the position to close
2113      * @return                  1) This address to accept, a different address to ask that contract
2114      *                          2) The maximum amount that this contract is allowing
2115      */
2116     function closeOnBehalfOf(
2117         address closer,
2118         address payoutRecipient,
2119         bytes32 positionId,
2120         uint256 requestedAmount
2121     )
2122         external
2123         /* onlyMargin */
2124         returns (address, uint256);
2125 }
2126 
2127 // File: contracts/margin/impl/ClosePositionShared.sol
2128 
2129 /**
2130  * @title ClosePositionShared
2131  * @author dYdX
2132  *
2133  * This library contains shared functionality between ClosePositionImpl and
2134  * CloseWithoutCounterpartyImpl
2135  */
2136 library ClosePositionShared {
2137     using SafeMath for uint256;
2138 
2139     // ============ Structs ============
2140 
2141     struct CloseTx {
2142         bytes32 positionId;
2143         uint256 originalPrincipal;
2144         uint256 closeAmount;
2145         uint256 owedTokenOwed;
2146         uint256 startingHeldTokenBalance;
2147         uint256 availableHeldToken;
2148         address payoutRecipient;
2149         address owedToken;
2150         address heldToken;
2151         address positionOwner;
2152         address positionLender;
2153         address exchangeWrapper;
2154         bool    payoutInHeldToken;
2155     }
2156 
2157     // ============ Internal Implementation Functions ============
2158 
2159     function closePositionStateUpdate(
2160         MarginState.State storage state,
2161         CloseTx memory transaction
2162     )
2163         internal
2164     {
2165         // Delete the position, or just decrease the principal
2166         if (transaction.closeAmount == transaction.originalPrincipal) {
2167             MarginCommon.cleanupPosition(state, transaction.positionId);
2168         } else {
2169             assert(
2170                 transaction.originalPrincipal == state.positions[transaction.positionId].principal
2171             );
2172             state.positions[transaction.positionId].principal =
2173                 transaction.originalPrincipal.sub(transaction.closeAmount);
2174         }
2175     }
2176 
2177     function sendTokensToPayoutRecipient(
2178         MarginState.State storage state,
2179         ClosePositionShared.CloseTx memory transaction,
2180         uint256 buybackCostInHeldToken,
2181         uint256 receivedOwedToken
2182     )
2183         internal
2184         returns (uint256)
2185     {
2186         uint256 payout;
2187 
2188         if (transaction.payoutInHeldToken) {
2189             // Send remaining heldToken to payoutRecipient
2190             payout = transaction.availableHeldToken.sub(buybackCostInHeldToken);
2191 
2192             Vault(state.VAULT).transferFromVault(
2193                 transaction.positionId,
2194                 transaction.heldToken,
2195                 transaction.payoutRecipient,
2196                 payout
2197             );
2198         } else {
2199             assert(transaction.exchangeWrapper != address(0));
2200 
2201             payout = receivedOwedToken.sub(transaction.owedTokenOwed);
2202 
2203             TokenProxy(state.TOKEN_PROXY).transferTokens(
2204                 transaction.owedToken,
2205                 transaction.exchangeWrapper,
2206                 transaction.payoutRecipient,
2207                 payout
2208             );
2209         }
2210 
2211         if (AddressUtils.isContract(transaction.payoutRecipient)) {
2212             require(
2213                 PayoutRecipient(transaction.payoutRecipient).receiveClosePositionPayout(
2214                     transaction.positionId,
2215                     transaction.closeAmount,
2216                     msg.sender,
2217                     transaction.positionOwner,
2218                     transaction.heldToken,
2219                     payout,
2220                     transaction.availableHeldToken,
2221                     transaction.payoutInHeldToken
2222                 ),
2223                 "ClosePositionShared#sendTokensToPayoutRecipient: Payout recipient does not consent"
2224             );
2225         }
2226 
2227         // The ending heldToken balance of the vault should be the starting heldToken balance
2228         // minus the available heldToken amount
2229         assert(
2230             MarginCommon.getPositionBalanceImpl(state, transaction.positionId)
2231             == transaction.startingHeldTokenBalance.sub(transaction.availableHeldToken)
2232         );
2233 
2234         return payout;
2235     }
2236 
2237     function createCloseTx(
2238         MarginState.State storage state,
2239         bytes32 positionId,
2240         uint256 requestedAmount,
2241         address payoutRecipient,
2242         address exchangeWrapper,
2243         bool payoutInHeldToken,
2244         bool isWithoutCounterparty
2245     )
2246         internal
2247         returns (CloseTx memory)
2248     {
2249         // Validate
2250         require(
2251             payoutRecipient != address(0),
2252             "ClosePositionShared#createCloseTx: Payout recipient cannot be 0"
2253         );
2254         require(
2255             requestedAmount > 0,
2256             "ClosePositionShared#createCloseTx: Requested close amount cannot be 0"
2257         );
2258 
2259         MarginCommon.Position storage position =
2260             MarginCommon.getPositionFromStorage(state, positionId);
2261 
2262         uint256 closeAmount = getApprovedAmount(
2263             position,
2264             positionId,
2265             requestedAmount,
2266             payoutRecipient,
2267             isWithoutCounterparty
2268         );
2269 
2270         return parseCloseTx(
2271             state,
2272             position,
2273             positionId,
2274             closeAmount,
2275             payoutRecipient,
2276             exchangeWrapper,
2277             payoutInHeldToken,
2278             isWithoutCounterparty
2279         );
2280     }
2281 
2282     // ============ Private Helper-Functions ============
2283 
2284     function getApprovedAmount(
2285         MarginCommon.Position storage position,
2286         bytes32 positionId,
2287         uint256 requestedAmount,
2288         address payoutRecipient,
2289         bool requireLenderApproval
2290     )
2291         private
2292         returns (uint256)
2293     {
2294         // Ensure enough principal
2295         uint256 allowedAmount = Math.min256(requestedAmount, position.principal);
2296 
2297         // Ensure owner consent
2298         allowedAmount = closePositionOnBehalfOfRecurse(
2299             position.owner,
2300             msg.sender,
2301             payoutRecipient,
2302             positionId,
2303             allowedAmount
2304         );
2305 
2306         // Ensure lender consent
2307         if (requireLenderApproval) {
2308             allowedAmount = closeLoanOnBehalfOfRecurse(
2309                 position.lender,
2310                 msg.sender,
2311                 payoutRecipient,
2312                 positionId,
2313                 allowedAmount
2314             );
2315         }
2316 
2317         assert(allowedAmount > 0);
2318         assert(allowedAmount <= position.principal);
2319         assert(allowedAmount <= requestedAmount);
2320 
2321         return allowedAmount;
2322     }
2323 
2324     function closePositionOnBehalfOfRecurse(
2325         address contractAddr,
2326         address closer,
2327         address payoutRecipient,
2328         bytes32 positionId,
2329         uint256 closeAmount
2330     )
2331         private
2332         returns (uint256)
2333     {
2334         // no need to ask for permission
2335         if (closer == contractAddr) {
2336             return closeAmount;
2337         }
2338 
2339         (
2340             address newContractAddr,
2341             uint256 newCloseAmount
2342         ) = ClosePositionDelegator(contractAddr).closeOnBehalfOf(
2343             closer,
2344             payoutRecipient,
2345             positionId,
2346             closeAmount
2347         );
2348 
2349         require(
2350             newCloseAmount <= closeAmount,
2351             "ClosePositionShared#closePositionRecurse: newCloseAmount is greater than closeAmount"
2352         );
2353         require(
2354             newCloseAmount > 0,
2355             "ClosePositionShared#closePositionRecurse: newCloseAmount is zero"
2356         );
2357 
2358         if (newContractAddr != contractAddr) {
2359             closePositionOnBehalfOfRecurse(
2360                 newContractAddr,
2361                 closer,
2362                 payoutRecipient,
2363                 positionId,
2364                 newCloseAmount
2365             );
2366         }
2367 
2368         return newCloseAmount;
2369     }
2370 
2371     function closeLoanOnBehalfOfRecurse(
2372         address contractAddr,
2373         address closer,
2374         address payoutRecipient,
2375         bytes32 positionId,
2376         uint256 closeAmount
2377     )
2378         private
2379         returns (uint256)
2380     {
2381         // no need to ask for permission
2382         if (closer == contractAddr) {
2383             return closeAmount;
2384         }
2385 
2386         (
2387             address newContractAddr,
2388             uint256 newCloseAmount
2389         ) = CloseLoanDelegator(contractAddr).closeLoanOnBehalfOf(
2390                 closer,
2391                 payoutRecipient,
2392                 positionId,
2393                 closeAmount
2394             );
2395 
2396         require(
2397             newCloseAmount <= closeAmount,
2398             "ClosePositionShared#closeLoanRecurse: newCloseAmount is greater than closeAmount"
2399         );
2400         require(
2401             newCloseAmount > 0,
2402             "ClosePositionShared#closeLoanRecurse: newCloseAmount is zero"
2403         );
2404 
2405         if (newContractAddr != contractAddr) {
2406             closeLoanOnBehalfOfRecurse(
2407                 newContractAddr,
2408                 closer,
2409                 payoutRecipient,
2410                 positionId,
2411                 newCloseAmount
2412             );
2413         }
2414 
2415         return newCloseAmount;
2416     }
2417 
2418     // ============ Parsing Functions ============
2419 
2420     function parseCloseTx(
2421         MarginState.State storage state,
2422         MarginCommon.Position storage position,
2423         bytes32 positionId,
2424         uint256 closeAmount,
2425         address payoutRecipient,
2426         address exchangeWrapper,
2427         bool payoutInHeldToken,
2428         bool isWithoutCounterparty
2429     )
2430         private
2431         view
2432         returns (CloseTx memory)
2433     {
2434         uint256 startingHeldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
2435 
2436         uint256 availableHeldToken = MathHelpers.getPartialAmount(
2437             closeAmount,
2438             position.principal,
2439             startingHeldTokenBalance
2440         );
2441         uint256 owedTokenOwed = 0;
2442 
2443         if (!isWithoutCounterparty) {
2444             owedTokenOwed = MarginCommon.calculateOwedAmount(
2445                 position,
2446                 closeAmount,
2447                 block.timestamp
2448             );
2449         }
2450 
2451         return CloseTx({
2452             positionId: positionId,
2453             originalPrincipal: position.principal,
2454             closeAmount: closeAmount,
2455             owedTokenOwed: owedTokenOwed,
2456             startingHeldTokenBalance: startingHeldTokenBalance,
2457             availableHeldToken: availableHeldToken,
2458             payoutRecipient: payoutRecipient,
2459             owedToken: position.owedToken,
2460             heldToken: position.heldToken,
2461             positionOwner: position.owner,
2462             positionLender: position.lender,
2463             exchangeWrapper: exchangeWrapper,
2464             payoutInHeldToken: payoutInHeldToken
2465         });
2466     }
2467 }
2468 
2469 // File: contracts/margin/interfaces/ExchangeWrapper.sol
2470 
2471 /**
2472  * @title ExchangeWrapper
2473  * @author dYdX
2474  *
2475  * Contract interface that Exchange Wrapper smart contracts must implement in order to interface
2476  * with other smart contracts through a common interface.
2477  */
2478 interface ExchangeWrapper {
2479 
2480     // ============ Public Functions ============
2481 
2482     /**
2483      * Exchange some amount of takerToken for makerToken.
2484      *
2485      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
2486      *                              cannot always be trusted as it is set at the discretion of the
2487      *                              msg.sender)
2488      * @param  receiver             Address to set allowance on once the trade has completed
2489      * @param  makerToken           Address of makerToken, the token to receive
2490      * @param  takerToken           Address of takerToken, the token to pay
2491      * @param  requestedFillAmount  Amount of takerToken being paid
2492      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
2493      * @return                      The amount of makerToken received
2494      */
2495     function exchange(
2496         address tradeOriginator,
2497         address receiver,
2498         address makerToken,
2499         address takerToken,
2500         uint256 requestedFillAmount,
2501         bytes orderData
2502     )
2503         external
2504         returns (uint256);
2505 
2506     /**
2507      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
2508      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
2509      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
2510      * than desiredMakerToken
2511      *
2512      * @param  makerToken         Address of makerToken, the token to receive
2513      * @param  takerToken         Address of takerToken, the token to pay
2514      * @param  desiredMakerToken  Amount of makerToken requested
2515      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
2516      * @return                    Amount of takerToken the needed to complete the transaction
2517      */
2518     function getExchangeCost(
2519         address makerToken,
2520         address takerToken,
2521         uint256 desiredMakerToken,
2522         bytes orderData
2523     )
2524         external
2525         view
2526         returns (uint256);
2527 }
2528 
2529 // File: contracts/margin/impl/ClosePositionImpl.sol
2530 
2531 /**
2532  * @title ClosePositionImpl
2533  * @author dYdX
2534  *
2535  * This library contains the implementation for the closePosition function of Margin
2536  */
2537 library ClosePositionImpl {
2538     using SafeMath for uint256;
2539 
2540     // ============ Events ============
2541 
2542     /**
2543      * A position was closed or partially closed
2544      */
2545     event PositionClosed(
2546         bytes32 indexed positionId,
2547         address indexed closer,
2548         address indexed payoutRecipient,
2549         uint256 closeAmount,
2550         uint256 remainingAmount,
2551         uint256 owedTokenPaidToLender,
2552         uint256 payoutAmount,
2553         uint256 buybackCostInHeldToken,
2554         bool    payoutInHeldToken
2555     );
2556 
2557     // ============ Public Implementation Functions ============
2558 
2559     function closePositionImpl(
2560         MarginState.State storage state,
2561         bytes32 positionId,
2562         uint256 requestedCloseAmount,
2563         address payoutRecipient,
2564         address exchangeWrapper,
2565         bool payoutInHeldToken,
2566         bytes memory orderData
2567     )
2568         public
2569         returns (uint256, uint256, uint256)
2570     {
2571         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2572             state,
2573             positionId,
2574             requestedCloseAmount,
2575             payoutRecipient,
2576             exchangeWrapper,
2577             payoutInHeldToken,
2578             false
2579         );
2580 
2581         (
2582             uint256 buybackCostInHeldToken,
2583             uint256 receivedOwedToken
2584         ) = returnOwedTokensToLender(
2585             state,
2586             transaction,
2587             orderData
2588         );
2589 
2590         uint256 payout = ClosePositionShared.sendTokensToPayoutRecipient(
2591             state,
2592             transaction,
2593             buybackCostInHeldToken,
2594             receivedOwedToken
2595         );
2596 
2597         ClosePositionShared.closePositionStateUpdate(state, transaction);
2598 
2599         logEventOnClose(
2600             transaction,
2601             buybackCostInHeldToken,
2602             payout
2603         );
2604 
2605         return (
2606             transaction.closeAmount,
2607             payout,
2608             transaction.owedTokenOwed
2609         );
2610     }
2611 
2612     // ============ Private Helper-Functions ============
2613 
2614     function returnOwedTokensToLender(
2615         MarginState.State storage state,
2616         ClosePositionShared.CloseTx memory transaction,
2617         bytes memory orderData
2618     )
2619         private
2620         returns (uint256, uint256)
2621     {
2622         uint256 buybackCostInHeldToken = 0;
2623         uint256 receivedOwedToken = 0;
2624         uint256 lenderOwedToken = transaction.owedTokenOwed;
2625 
2626         // Setting exchangeWrapper to 0x000... indicates owedToken should be taken directly
2627         // from msg.sender
2628         if (transaction.exchangeWrapper == address(0)) {
2629             require(
2630                 transaction.payoutInHeldToken,
2631                 "ClosePositionImpl#returnOwedTokensToLender: Cannot payout in owedToken"
2632             );
2633 
2634             // No DEX Order; send owedTokens directly from the closer to the lender
2635             TokenProxy(state.TOKEN_PROXY).transferTokens(
2636                 transaction.owedToken,
2637                 msg.sender,
2638                 transaction.positionLender,
2639                 lenderOwedToken
2640             );
2641         } else {
2642             // Buy back owedTokens using DEX Order and send to lender
2643             (buybackCostInHeldToken, receivedOwedToken) = buyBackOwedToken(
2644                 state,
2645                 transaction,
2646                 orderData
2647             );
2648 
2649             // If no owedToken needed for payout: give lender all owedToken, even if more than owed
2650             if (transaction.payoutInHeldToken) {
2651                 assert(receivedOwedToken >= lenderOwedToken);
2652                 lenderOwedToken = receivedOwedToken;
2653             }
2654 
2655             // Transfer owedToken from the exchange wrapper to the lender
2656             TokenProxy(state.TOKEN_PROXY).transferTokens(
2657                 transaction.owedToken,
2658                 transaction.exchangeWrapper,
2659                 transaction.positionLender,
2660                 lenderOwedToken
2661             );
2662         }
2663 
2664         state.totalOwedTokenRepaidToLender[transaction.positionId] =
2665             state.totalOwedTokenRepaidToLender[transaction.positionId].add(lenderOwedToken);
2666 
2667         return (buybackCostInHeldToken, receivedOwedToken);
2668     }
2669 
2670     function buyBackOwedToken(
2671         MarginState.State storage state,
2672         ClosePositionShared.CloseTx transaction,
2673         bytes memory orderData
2674     )
2675         private
2676         returns (uint256, uint256)
2677     {
2678         // Ask the exchange wrapper the cost in heldToken to buy back the close
2679         // amount of owedToken
2680         uint256 buybackCostInHeldToken;
2681 
2682         if (transaction.payoutInHeldToken) {
2683             buybackCostInHeldToken = ExchangeWrapper(transaction.exchangeWrapper)
2684                 .getExchangeCost(
2685                     transaction.owedToken,
2686                     transaction.heldToken,
2687                     transaction.owedTokenOwed,
2688                     orderData
2689                 );
2690 
2691             // Require enough available heldToken to pay for the buyback
2692             require(
2693                 buybackCostInHeldToken <= transaction.availableHeldToken,
2694                 "ClosePositionImpl#buyBackOwedToken: Not enough available heldToken"
2695             );
2696         } else {
2697             buybackCostInHeldToken = transaction.availableHeldToken;
2698         }
2699 
2700         // Send the requisite heldToken to do the buyback from vault to exchange wrapper
2701         Vault(state.VAULT).transferFromVault(
2702             transaction.positionId,
2703             transaction.heldToken,
2704             transaction.exchangeWrapper,
2705             buybackCostInHeldToken
2706         );
2707 
2708         // Trade the heldToken for the owedToken
2709         uint256 receivedOwedToken = ExchangeWrapper(transaction.exchangeWrapper).exchange(
2710             msg.sender,
2711             state.TOKEN_PROXY,
2712             transaction.owedToken,
2713             transaction.heldToken,
2714             buybackCostInHeldToken,
2715             orderData
2716         );
2717 
2718         require(
2719             receivedOwedToken >= transaction.owedTokenOwed,
2720             "ClosePositionImpl#buyBackOwedToken: Did not receive enough owedToken"
2721         );
2722 
2723         return (buybackCostInHeldToken, receivedOwedToken);
2724     }
2725 
2726     function logEventOnClose(
2727         ClosePositionShared.CloseTx transaction,
2728         uint256 buybackCostInHeldToken,
2729         uint256 payout
2730     )
2731         private
2732     {
2733         emit PositionClosed(
2734             transaction.positionId,
2735             msg.sender,
2736             transaction.payoutRecipient,
2737             transaction.closeAmount,
2738             transaction.originalPrincipal.sub(transaction.closeAmount),
2739             transaction.owedTokenOwed,
2740             payout,
2741             buybackCostInHeldToken,
2742             transaction.payoutInHeldToken
2743         );
2744     }
2745 
2746 }
2747 
2748 // File: contracts/margin/impl/CloseWithoutCounterpartyImpl.sol
2749 
2750 /**
2751  * @title CloseWithoutCounterpartyImpl
2752  * @author dYdX
2753  *
2754  * This library contains the implementation for the closeWithoutCounterpartyImpl function of
2755  * Margin
2756  */
2757 library CloseWithoutCounterpartyImpl {
2758     using SafeMath for uint256;
2759 
2760     // ============ Events ============
2761 
2762     /**
2763      * A position was closed or partially closed
2764      */
2765     event PositionClosed(
2766         bytes32 indexed positionId,
2767         address indexed closer,
2768         address indexed payoutRecipient,
2769         uint256 closeAmount,
2770         uint256 remainingAmount,
2771         uint256 owedTokenPaidToLender,
2772         uint256 payoutAmount,
2773         uint256 buybackCostInHeldToken,
2774         bool payoutInHeldToken
2775     );
2776 
2777     // ============ Public Implementation Functions ============
2778 
2779     function closeWithoutCounterpartyImpl(
2780         MarginState.State storage state,
2781         bytes32 positionId,
2782         uint256 requestedCloseAmount,
2783         address payoutRecipient
2784     )
2785         public
2786         returns (uint256, uint256)
2787     {
2788         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2789             state,
2790             positionId,
2791             requestedCloseAmount,
2792             payoutRecipient,
2793             address(0),
2794             true,
2795             true
2796         );
2797 
2798         uint256 heldTokenPayout = ClosePositionShared.sendTokensToPayoutRecipient(
2799             state,
2800             transaction,
2801             0, // No buyback cost
2802             0  // Did not receive any owedToken
2803         );
2804 
2805         ClosePositionShared.closePositionStateUpdate(state, transaction);
2806 
2807         logEventOnCloseWithoutCounterparty(transaction);
2808 
2809         return (
2810             transaction.closeAmount,
2811             heldTokenPayout
2812         );
2813     }
2814 
2815     // ============ Private Helper-Functions ============
2816 
2817     function logEventOnCloseWithoutCounterparty(
2818         ClosePositionShared.CloseTx transaction
2819     )
2820         private
2821     {
2822         emit PositionClosed(
2823             transaction.positionId,
2824             msg.sender,
2825             transaction.payoutRecipient,
2826             transaction.closeAmount,
2827             transaction.originalPrincipal.sub(transaction.closeAmount),
2828             0,
2829             transaction.availableHeldToken,
2830             0,
2831             true
2832         );
2833     }
2834 }
2835 
2836 // File: contracts/margin/interfaces/owner/DepositCollateralDelegator.sol
2837 
2838 /**
2839  * @title DepositCollateralDelegator
2840  * @author dYdX
2841  *
2842  * Interface that smart contracts must implement in order to let other addresses deposit heldTokens
2843  * into a position owned by the smart contract.
2844  *
2845  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2846  *       to these functions
2847  */
2848 interface DepositCollateralDelegator {
2849 
2850     // ============ Public Interface functions ============
2851 
2852     /**
2853      * Function a contract must implement in order to let other addresses call depositCollateral().
2854      *
2855      * @param  depositor   Address of the caller of the depositCollateral() function
2856      * @param  positionId  Unique ID of the position
2857      * @param  amount      Requested deposit amount
2858      * @return             This address to accept, a different address to ask that contract
2859      */
2860     function depositCollateralOnBehalfOf(
2861         address depositor,
2862         bytes32 positionId,
2863         uint256 amount
2864     )
2865         external
2866         /* onlyMargin */
2867         returns (address);
2868 }
2869 
2870 // File: contracts/margin/impl/DepositCollateralImpl.sol
2871 
2872 /**
2873  * @title DepositCollateralImpl
2874  * @author dYdX
2875  *
2876  * This library contains the implementation for the deposit function of Margin
2877  */
2878 library DepositCollateralImpl {
2879     using SafeMath for uint256;
2880 
2881     // ============ Events ============
2882 
2883     /**
2884      * Additional collateral for a position was posted by the owner
2885      */
2886     event AdditionalCollateralDeposited(
2887         bytes32 indexed positionId,
2888         uint256 amount,
2889         address depositor
2890     );
2891 
2892     /**
2893      * A margin call was canceled
2894      */
2895     event MarginCallCanceled(
2896         bytes32 indexed positionId,
2897         address indexed lender,
2898         address indexed owner,
2899         uint256 depositAmount
2900     );
2901 
2902     // ============ Public Implementation Functions ============
2903 
2904     function depositCollateralImpl(
2905         MarginState.State storage state,
2906         bytes32 positionId,
2907         uint256 depositAmount
2908     )
2909         public
2910     {
2911         MarginCommon.Position storage position =
2912             MarginCommon.getPositionFromStorage(state, positionId);
2913 
2914         require(
2915             depositAmount > 0,
2916             "DepositCollateralImpl#depositCollateralImpl: Deposit amount cannot be 0"
2917         );
2918 
2919         // Ensure owner consent
2920         depositCollateralOnBehalfOfRecurse(
2921             position.owner,
2922             msg.sender,
2923             positionId,
2924             depositAmount
2925         );
2926 
2927         Vault(state.VAULT).transferToVault(
2928             positionId,
2929             position.heldToken,
2930             msg.sender,
2931             depositAmount
2932         );
2933 
2934         // cancel margin call if applicable
2935         bool marginCallCanceled = false;
2936         uint256 requiredDeposit = position.requiredDeposit;
2937         if (position.callTimestamp > 0 && requiredDeposit > 0) {
2938             if (depositAmount >= requiredDeposit) {
2939                 position.requiredDeposit = 0;
2940                 position.callTimestamp = 0;
2941                 marginCallCanceled = true;
2942             } else {
2943                 position.requiredDeposit = position.requiredDeposit.sub(depositAmount);
2944             }
2945         }
2946 
2947         emit AdditionalCollateralDeposited(
2948             positionId,
2949             depositAmount,
2950             msg.sender
2951         );
2952 
2953         if (marginCallCanceled) {
2954             emit MarginCallCanceled(
2955                 positionId,
2956                 position.lender,
2957                 msg.sender,
2958                 depositAmount
2959             );
2960         }
2961     }
2962 
2963     // ============ Private Helper-Functions ============
2964 
2965     function depositCollateralOnBehalfOfRecurse(
2966         address contractAddr,
2967         address depositor,
2968         bytes32 positionId,
2969         uint256 amount
2970     )
2971         private
2972     {
2973         // no need to ask for permission
2974         if (depositor == contractAddr) {
2975             return;
2976         }
2977 
2978         address newContractAddr =
2979             DepositCollateralDelegator(contractAddr).depositCollateralOnBehalfOf(
2980                 depositor,
2981                 positionId,
2982                 amount
2983             );
2984 
2985         // if not equal, recurse
2986         if (newContractAddr != contractAddr) {
2987             depositCollateralOnBehalfOfRecurse(
2988                 newContractAddr,
2989                 depositor,
2990                 positionId,
2991                 amount
2992             );
2993         }
2994     }
2995 }
2996 
2997 // File: contracts/margin/interfaces/lender/ForceRecoverCollateralDelegator.sol
2998 
2999 /**
3000  * @title ForceRecoverCollateralDelegator
3001  * @author dYdX
3002  *
3003  * Interface that smart contracts must implement in order to let other addresses
3004  * forceRecoverCollateral() a loan owned by the smart contract.
3005  *
3006  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3007  *       to these functions
3008  */
3009 interface ForceRecoverCollateralDelegator {
3010 
3011     // ============ Public Interface functions ============
3012 
3013     /**
3014      * Function a contract must implement in order to let other addresses call
3015      * forceRecoverCollateral().
3016      *
3017      * NOTE: If not returning zero address (or not reverting), this contract must assume that Margin
3018      * will either revert the entire transaction or that the collateral was forcibly recovered.
3019      *
3020      * @param  recoverer   Address of the caller of the forceRecoverCollateral() function
3021      * @param  positionId  Unique ID of the position
3022      * @param  recipient   Address to send the recovered tokens to
3023      * @return             This address to accept, a different address to ask that contract
3024      */
3025     function forceRecoverCollateralOnBehalfOf(
3026         address recoverer,
3027         bytes32 positionId,
3028         address recipient
3029     )
3030         external
3031         /* onlyMargin */
3032         returns (address);
3033 }
3034 
3035 // File: contracts/margin/impl/ForceRecoverCollateralImpl.sol
3036 
3037 /* solium-disable-next-line max-len*/
3038 
3039 /**
3040  * @title ForceRecoverCollateralImpl
3041  * @author dYdX
3042  *
3043  * This library contains the implementation for the forceRecoverCollateral function of Margin
3044  */
3045 library ForceRecoverCollateralImpl {
3046     using SafeMath for uint256;
3047 
3048     // ============ Events ============
3049 
3050     /**
3051      * Collateral for a position was forcibly recovered
3052      */
3053     event CollateralForceRecovered(
3054         bytes32 indexed positionId,
3055         address indexed recipient,
3056         uint256 amount
3057     );
3058 
3059     // ============ Public Implementation Functions ============
3060 
3061     function forceRecoverCollateralImpl(
3062         MarginState.State storage state,
3063         bytes32 positionId,
3064         address recipient
3065     )
3066         public
3067         returns (uint256)
3068     {
3069         MarginCommon.Position storage position =
3070             MarginCommon.getPositionFromStorage(state, positionId);
3071 
3072         // Can only force recover after either:
3073         // 1) The loan was called and the call period has elapsed
3074         // 2) The maxDuration of the position has elapsed
3075         require( /* solium-disable-next-line */
3076             (
3077                 position.callTimestamp > 0
3078                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3079             ) || (
3080                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3081             ),
3082             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3083         );
3084 
3085         // Ensure lender consent
3086         forceRecoverCollateralOnBehalfOfRecurse(
3087             position.lender,
3088             msg.sender,
3089             positionId,
3090             recipient
3091         );
3092 
3093         // Send the tokens
3094         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3095         Vault(state.VAULT).transferFromVault(
3096             positionId,
3097             position.heldToken,
3098             recipient,
3099             heldTokenRecovered
3100         );
3101 
3102         // Delete the position
3103         // NOTE: Since position is a storage pointer, this will also set all fields on
3104         //       the position variable to 0
3105         MarginCommon.cleanupPosition(
3106             state,
3107             positionId
3108         );
3109 
3110         // Log an event
3111         emit CollateralForceRecovered(
3112             positionId,
3113             recipient,
3114             heldTokenRecovered
3115         );
3116 
3117         return heldTokenRecovered;
3118     }
3119 
3120     // ============ Private Helper-Functions ============
3121 
3122     function forceRecoverCollateralOnBehalfOfRecurse(
3123         address contractAddr,
3124         address recoverer,
3125         bytes32 positionId,
3126         address recipient
3127     )
3128         private
3129     {
3130         // no need to ask for permission
3131         if (recoverer == contractAddr) {
3132             return;
3133         }
3134 
3135         address newContractAddr =
3136             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3137                 recoverer,
3138                 positionId,
3139                 recipient
3140             );
3141 
3142         if (newContractAddr != contractAddr) {
3143             forceRecoverCollateralOnBehalfOfRecurse(
3144                 newContractAddr,
3145                 recoverer,
3146                 positionId,
3147                 recipient
3148             );
3149         }
3150     }
3151 }
3152 
3153 // File: contracts/lib/TypedSignature.sol
3154 
3155 /**
3156  * @title TypedSignature
3157  * @author dYdX
3158  *
3159  * Allows for ecrecovery of signed hashes with three different prepended messages:
3160  * 1) ""
3161  * 2) "\x19Ethereum Signed Message:\n32"
3162  * 3) "\x19Ethereum Signed Message:\n\x20"
3163  */
3164 library TypedSignature {
3165 
3166     // Solidity does not offer guarantees about enum values, so we define them explicitly
3167     uint8 private constant SIGTYPE_INVALID = 0;
3168     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3169     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3170     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3171 
3172     // prepended message with the length of the signed hash in hexadecimal
3173     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3174 
3175     // prepended message with the length of the signed hash in decimal
3176     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3177 
3178     /**
3179      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3180      *
3181      * @param  hash               Hash that was signed (does not include prepended message)
3182      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3183      * @return                    address of the signer of the hash
3184      */
3185     function recover(
3186         bytes32 hash,
3187         bytes signatureWithType
3188     )
3189         internal
3190         pure
3191         returns (address)
3192     {
3193         require(
3194             signatureWithType.length == 66,
3195             "SignatureValidator#validateSignature: invalid signature length"
3196         );
3197 
3198         uint8 sigType = uint8(signatureWithType[0]);
3199 
3200         require(
3201             sigType > uint8(SIGTYPE_INVALID),
3202             "SignatureValidator#validateSignature: invalid signature type"
3203         );
3204         require(
3205             sigType < uint8(SIGTYPE_UNSUPPORTED),
3206             "SignatureValidator#validateSignature: unsupported signature type"
3207         );
3208 
3209         uint8 v = uint8(signatureWithType[1]);
3210         bytes32 r;
3211         bytes32 s;
3212 
3213         /* solium-disable-next-line security/no-inline-assembly */
3214         assembly {
3215             r := mload(add(signatureWithType, 34))
3216             s := mload(add(signatureWithType, 66))
3217         }
3218 
3219         bytes32 signedHash;
3220         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3221             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3222         } else {
3223             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3224             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3225         }
3226 
3227         return ecrecover(
3228             signedHash,
3229             v,
3230             r,
3231             s
3232         );
3233     }
3234 }
3235 
3236 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3237 
3238 /**
3239  * @title LoanOfferingVerifier
3240  * @author dYdX
3241  *
3242  * Interface that smart contracts must implement to be able to make off-chain generated
3243  * loan offerings.
3244  *
3245  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3246  *       to these functions
3247  */
3248 interface LoanOfferingVerifier {
3249 
3250     /**
3251      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3252      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3253      * position.
3254      *
3255      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3256      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3257      * state on a loan.
3258      *
3259      * @param  addresses    Array of addresses:
3260      *
3261      *  [0] = owedToken
3262      *  [1] = heldToken
3263      *  [2] = loan payer
3264      *  [3] = loan owner
3265      *  [4] = loan taker
3266      *  [5] = loan positionOwner
3267      *  [6] = loan fee recipient
3268      *  [7] = loan lender fee token
3269      *  [8] = loan taker fee token
3270      *
3271      * @param  values256    Values corresponding to:
3272      *
3273      *  [0] = loan maximum amount
3274      *  [1] = loan minimum amount
3275      *  [2] = loan minimum heldToken
3276      *  [3] = loan lender fee
3277      *  [4] = loan taker fee
3278      *  [5] = loan expiration timestamp (in seconds)
3279      *  [6] = loan salt
3280      *
3281      * @param  values32     Values corresponding to:
3282      *
3283      *  [0] = loan call time limit (in seconds)
3284      *  [1] = loan maxDuration (in seconds)
3285      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3286      *  [3] = loan interest update period (in seconds)
3287      *
3288      * @param  positionId   Unique ID of the position
3289      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3290      * @return              This address to accept, a different address to ask that contract
3291      */
3292     function verifyLoanOffering(
3293         address[9] addresses,
3294         uint256[7] values256,
3295         uint32[4] values32,
3296         bytes32 positionId,
3297         bytes signature
3298     )
3299         external
3300         /* onlyMargin */
3301         returns (address);
3302 }
3303 
3304 // File: contracts/margin/impl/BorrowShared.sol
3305 
3306 /**
3307  * @title BorrowShared
3308  * @author dYdX
3309  *
3310  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3311  * Both use a Loan Offering and a DEX Order to open or increase a position.
3312  */
3313 library BorrowShared {
3314     using SafeMath for uint256;
3315 
3316     // ============ Structs ============
3317 
3318     struct Tx {
3319         bytes32 positionId;
3320         address owner;
3321         uint256 principal;
3322         uint256 lenderAmount;
3323         MarginCommon.LoanOffering loanOffering;
3324         address exchangeWrapper;
3325         bool depositInHeldToken;
3326         uint256 depositAmount;
3327         uint256 collateralAmount;
3328         uint256 heldTokenFromSell;
3329     }
3330 
3331     // ============ Internal Implementation Functions ============
3332 
3333     /**
3334      * Validate the transaction before exchanging heldToken for owedToken
3335      */
3336     function validateTxPreSell(
3337         MarginState.State storage state,
3338         Tx memory transaction
3339     )
3340         internal
3341     {
3342         assert(transaction.lenderAmount >= transaction.principal);
3343 
3344         require(
3345             transaction.principal > 0,
3346             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3347         );
3348 
3349         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3350         if (transaction.loanOffering.taker != address(0)) {
3351             require(
3352                 msg.sender == transaction.loanOffering.taker,
3353                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3354             );
3355         }
3356 
3357         // If the positionOwner is 0x0 then any address can be set as the position owner.
3358         // Otherwise only the specified positionOwner can be set as the position owner.
3359         if (transaction.loanOffering.positionOwner != address(0)) {
3360             require(
3361                 transaction.owner == transaction.loanOffering.positionOwner,
3362                 "BorrowShared#validateTxPreSell: Invalid position owner"
3363             );
3364         }
3365 
3366         // Require the loan offering to be approved by the payer
3367         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3368             getConsentFromSmartContractLender(transaction);
3369         } else {
3370             require(
3371                 transaction.loanOffering.payer == TypedSignature.recover(
3372                     transaction.loanOffering.loanHash,
3373                     transaction.loanOffering.signature
3374                 ),
3375                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3376             );
3377         }
3378 
3379         // Validate the amount is <= than max and >= min
3380         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3381             state,
3382             transaction.loanOffering.loanHash
3383         );
3384         require(
3385             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3386             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3387         );
3388 
3389         require(
3390             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3391             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3392         );
3393 
3394         require(
3395             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3396             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3397         );
3398 
3399         require(
3400             transaction.owner != address(0),
3401             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3402         );
3403 
3404         require(
3405             transaction.loanOffering.owner != address(0),
3406             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3407         );
3408 
3409         require(
3410             transaction.loanOffering.expirationTimestamp > block.timestamp,
3411             "BorrowShared#validateTxPreSell: Loan offering is expired"
3412         );
3413 
3414         require(
3415             transaction.loanOffering.maxDuration > 0,
3416             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3417         );
3418 
3419         require(
3420             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3421             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3422         );
3423 
3424         // The minimum heldToken is validated after executing the sell
3425         // Position and loan ownership is validated in TransferInternal
3426     }
3427 
3428     /**
3429      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3430      * how much of the loan was used.
3431      */
3432     function doPostSell(
3433         MarginState.State storage state,
3434         Tx memory transaction
3435     )
3436         internal
3437     {
3438         validateTxPostSell(transaction);
3439 
3440         // Transfer feeTokens from trader and lender
3441         transferLoanFees(state, transaction);
3442 
3443         // Update global amounts for the loan
3444         state.loanFills[transaction.loanOffering.loanHash] =
3445             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3446     }
3447 
3448     /**
3449      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3450      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3451      * maxHeldTokenToBuy of heldTokens at most.
3452      */
3453     function doSell(
3454         MarginState.State storage state,
3455         Tx transaction,
3456         bytes orderData,
3457         uint256 maxHeldTokenToBuy
3458     )
3459         internal
3460         returns (uint256)
3461     {
3462         // Move owedTokens from lender to exchange wrapper
3463         pullOwedTokensFromLender(state, transaction);
3464 
3465         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3466         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3467         uint256 sellAmount = transaction.depositInHeldToken ?
3468             transaction.lenderAmount :
3469             transaction.lenderAmount.add(transaction.depositAmount);
3470 
3471         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3472         uint256 heldTokenFromSell = Math.min256(
3473             maxHeldTokenToBuy,
3474             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3475                 msg.sender,
3476                 state.TOKEN_PROXY,
3477                 transaction.loanOffering.heldToken,
3478                 transaction.loanOffering.owedToken,
3479                 sellAmount,
3480                 orderData
3481             )
3482         );
3483 
3484         // Move the tokens to the vault
3485         Vault(state.VAULT).transferToVault(
3486             transaction.positionId,
3487             transaction.loanOffering.heldToken,
3488             transaction.exchangeWrapper,
3489             heldTokenFromSell
3490         );
3491 
3492         // Update collateral amount
3493         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3494 
3495         return heldTokenFromSell;
3496     }
3497 
3498     /**
3499      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3500      * be sold for heldToken.
3501      */
3502     function doDepositOwedToken(
3503         MarginState.State storage state,
3504         Tx transaction
3505     )
3506         internal
3507     {
3508         TokenProxy(state.TOKEN_PROXY).transferTokens(
3509             transaction.loanOffering.owedToken,
3510             msg.sender,
3511             transaction.exchangeWrapper,
3512             transaction.depositAmount
3513         );
3514     }
3515 
3516     /**
3517      * Take the heldToken deposit from the trader and move it to the vault.
3518      */
3519     function doDepositHeldToken(
3520         MarginState.State storage state,
3521         Tx transaction
3522     )
3523         internal
3524     {
3525         Vault(state.VAULT).transferToVault(
3526             transaction.positionId,
3527             transaction.loanOffering.heldToken,
3528             msg.sender,
3529             transaction.depositAmount
3530         );
3531 
3532         // Update collateral amount
3533         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3534     }
3535 
3536     // ============ Private Helper-Functions ============
3537 
3538     function validateTxPostSell(
3539         Tx transaction
3540     )
3541         private
3542         pure
3543     {
3544         uint256 expectedCollateral = transaction.depositInHeldToken ?
3545             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3546             transaction.heldTokenFromSell;
3547         assert(transaction.collateralAmount == expectedCollateral);
3548 
3549         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3550             transaction.lenderAmount,
3551             transaction.loanOffering.rates.maxAmount,
3552             transaction.loanOffering.rates.minHeldToken
3553         );
3554         require(
3555             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3556             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3557         );
3558     }
3559 
3560     function getConsentFromSmartContractLender(
3561         Tx transaction
3562     )
3563         private
3564     {
3565         verifyLoanOfferingRecurse(
3566             transaction.loanOffering.payer,
3567             getLoanOfferingAddresses(transaction),
3568             getLoanOfferingValues256(transaction),
3569             getLoanOfferingValues32(transaction),
3570             transaction.positionId,
3571             transaction.loanOffering.signature
3572         );
3573     }
3574 
3575     function verifyLoanOfferingRecurse(
3576         address contractAddr,
3577         address[9] addresses,
3578         uint256[7] values256,
3579         uint32[4] values32,
3580         bytes32 positionId,
3581         bytes signature
3582     )
3583         private
3584     {
3585         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3586             addresses,
3587             values256,
3588             values32,
3589             positionId,
3590             signature
3591         );
3592 
3593         if (newContractAddr != contractAddr) {
3594             verifyLoanOfferingRecurse(
3595                 newContractAddr,
3596                 addresses,
3597                 values256,
3598                 values32,
3599                 positionId,
3600                 signature
3601             );
3602         }
3603     }
3604 
3605     function pullOwedTokensFromLender(
3606         MarginState.State storage state,
3607         Tx transaction
3608     )
3609         private
3610     {
3611         // Transfer owedToken to the exchange wrapper
3612         TokenProxy(state.TOKEN_PROXY).transferTokens(
3613             transaction.loanOffering.owedToken,
3614             transaction.loanOffering.payer,
3615             transaction.exchangeWrapper,
3616             transaction.lenderAmount
3617         );
3618     }
3619 
3620     function transferLoanFees(
3621         MarginState.State storage state,
3622         Tx transaction
3623     )
3624         private
3625     {
3626         // 0 fee address indicates no fees
3627         if (transaction.loanOffering.feeRecipient == address(0)) {
3628             return;
3629         }
3630 
3631         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3632 
3633         uint256 lenderFee = MathHelpers.getPartialAmount(
3634             transaction.lenderAmount,
3635             transaction.loanOffering.rates.maxAmount,
3636             transaction.loanOffering.rates.lenderFee
3637         );
3638         uint256 takerFee = MathHelpers.getPartialAmount(
3639             transaction.lenderAmount,
3640             transaction.loanOffering.rates.maxAmount,
3641             transaction.loanOffering.rates.takerFee
3642         );
3643 
3644         if (lenderFee > 0) {
3645             proxy.transferTokens(
3646                 transaction.loanOffering.lenderFeeToken,
3647                 transaction.loanOffering.payer,
3648                 transaction.loanOffering.feeRecipient,
3649                 lenderFee
3650             );
3651         }
3652 
3653         if (takerFee > 0) {
3654             proxy.transferTokens(
3655                 transaction.loanOffering.takerFeeToken,
3656                 msg.sender,
3657                 transaction.loanOffering.feeRecipient,
3658                 takerFee
3659             );
3660         }
3661     }
3662 
3663     function getLoanOfferingAddresses(
3664         Tx transaction
3665     )
3666         private
3667         pure
3668         returns (address[9])
3669     {
3670         return [
3671             transaction.loanOffering.owedToken,
3672             transaction.loanOffering.heldToken,
3673             transaction.loanOffering.payer,
3674             transaction.loanOffering.owner,
3675             transaction.loanOffering.taker,
3676             transaction.loanOffering.positionOwner,
3677             transaction.loanOffering.feeRecipient,
3678             transaction.loanOffering.lenderFeeToken,
3679             transaction.loanOffering.takerFeeToken
3680         ];
3681     }
3682 
3683     function getLoanOfferingValues256(
3684         Tx transaction
3685     )
3686         private
3687         pure
3688         returns (uint256[7])
3689     {
3690         return [
3691             transaction.loanOffering.rates.maxAmount,
3692             transaction.loanOffering.rates.minAmount,
3693             transaction.loanOffering.rates.minHeldToken,
3694             transaction.loanOffering.rates.lenderFee,
3695             transaction.loanOffering.rates.takerFee,
3696             transaction.loanOffering.expirationTimestamp,
3697             transaction.loanOffering.salt
3698         ];
3699     }
3700 
3701     function getLoanOfferingValues32(
3702         Tx transaction
3703     )
3704         private
3705         pure
3706         returns (uint32[4])
3707     {
3708         return [
3709             transaction.loanOffering.callTimeLimit,
3710             transaction.loanOffering.maxDuration,
3711             transaction.loanOffering.rates.interestRate,
3712             transaction.loanOffering.rates.interestPeriod
3713         ];
3714     }
3715 }
3716 
3717 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3718 
3719 /**
3720  * @title IncreaseLoanDelegator
3721  * @author dYdX
3722  *
3723  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3724  *
3725  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3726  *       to these functions
3727  */
3728 interface IncreaseLoanDelegator {
3729 
3730     // ============ Public Interface functions ============
3731 
3732     /**
3733      * Function a contract must implement in order to allow additional value to be added onto
3734      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3735      *
3736      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3737      * either revert the entire transaction or that the loan size was successfully increased.
3738      *
3739      * @param  payer           Lender adding additional funds to the position
3740      * @param  positionId      Unique ID of the position
3741      * @param  principalAdded  Principal amount to be added to the position
3742      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
3743      *                         zero if increaseWithoutCounterparty() is used).
3744      * @return                 This address to accept, a different address to ask that contract
3745      */
3746     function increaseLoanOnBehalfOf(
3747         address payer,
3748         bytes32 positionId,
3749         uint256 principalAdded,
3750         uint256 lentAmount
3751     )
3752         external
3753         /* onlyMargin */
3754         returns (address);
3755 }
3756 
3757 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
3758 
3759 /**
3760  * @title IncreasePositionDelegator
3761  * @author dYdX
3762  *
3763  * Interface that smart contracts must implement in order to own position on behalf of other
3764  * accounts
3765  *
3766  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3767  *       to these functions
3768  */
3769 interface IncreasePositionDelegator {
3770 
3771     // ============ Public Interface functions ============
3772 
3773     /**
3774      * Function a contract must implement in order to allow additional value to be added onto
3775      * an owned position. Margin will call this on the owner of a position during increasePosition()
3776      *
3777      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3778      * either revert the entire transaction or that the position size was successfully increased.
3779      *
3780      * @param  trader          Address initiating the addition of funds to the position
3781      * @param  positionId      Unique ID of the position
3782      * @param  principalAdded  Amount of principal to be added to the position
3783      * @return                 This address to accept, a different address to ask that contract
3784      */
3785     function increasePositionOnBehalfOf(
3786         address trader,
3787         bytes32 positionId,
3788         uint256 principalAdded
3789     )
3790         external
3791         /* onlyMargin */
3792         returns (address);
3793 }
3794 
3795 // File: contracts/margin/impl/IncreasePositionImpl.sol
3796 
3797 /**
3798  * @title IncreasePositionImpl
3799  * @author dYdX
3800  *
3801  * This library contains the implementation for the increasePosition function of Margin
3802  */
3803 library IncreasePositionImpl {
3804     using SafeMath for uint256;
3805 
3806     // ============ Events ============
3807 
3808     /*
3809      * A position was increased
3810      */
3811     event PositionIncreased(
3812         bytes32 indexed positionId,
3813         address indexed trader,
3814         address indexed lender,
3815         address positionOwner,
3816         address loanOwner,
3817         bytes32 loanHash,
3818         address loanFeeRecipient,
3819         uint256 amountBorrowed,
3820         uint256 principalAdded,
3821         uint256 heldTokenFromSell,
3822         uint256 depositAmount,
3823         bool    depositInHeldToken
3824     );
3825 
3826     // ============ Public Implementation Functions ============
3827 
3828     function increasePositionImpl(
3829         MarginState.State storage state,
3830         bytes32 positionId,
3831         address[7] addresses,
3832         uint256[8] values256,
3833         uint32[2] values32,
3834         bool depositInHeldToken,
3835         bytes signature,
3836         bytes orderData
3837     )
3838         public
3839         returns (uint256)
3840     {
3841         // Also ensures that the position exists
3842         MarginCommon.Position storage position =
3843             MarginCommon.getPositionFromStorage(state, positionId);
3844 
3845         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
3846             position,
3847             positionId,
3848             addresses,
3849             values256,
3850             values32,
3851             depositInHeldToken,
3852             signature
3853         );
3854 
3855         validateIncrease(state, transaction, position);
3856 
3857         doBorrowAndSell(state, transaction, orderData);
3858 
3859         updateState(
3860             position,
3861             transaction.positionId,
3862             transaction.principal,
3863             transaction.lenderAmount,
3864             transaction.loanOffering.payer
3865         );
3866 
3867         // LOG EVENT
3868         recordPositionIncreased(transaction, position);
3869 
3870         return transaction.lenderAmount;
3871     }
3872 
3873     function increaseWithoutCounterpartyImpl(
3874         MarginState.State storage state,
3875         bytes32 positionId,
3876         uint256 principalToAdd
3877     )
3878         public
3879         returns (uint256)
3880     {
3881         MarginCommon.Position storage position =
3882             MarginCommon.getPositionFromStorage(state, positionId);
3883 
3884         // Disallow adding 0 principal
3885         require(
3886             principalToAdd > 0,
3887             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
3888         );
3889 
3890         // Disallow additions after maximum duration
3891         require(
3892             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
3893             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
3894         );
3895 
3896         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
3897             state,
3898             position,
3899             positionId,
3900             principalToAdd
3901         );
3902 
3903         Vault(state.VAULT).transferToVault(
3904             positionId,
3905             position.heldToken,
3906             msg.sender,
3907             heldTokenAmount
3908         );
3909 
3910         updateState(
3911             position,
3912             positionId,
3913             principalToAdd,
3914             0, // lent amount
3915             msg.sender
3916         );
3917 
3918         emit PositionIncreased(
3919             positionId,
3920             msg.sender,
3921             msg.sender,
3922             position.owner,
3923             position.lender,
3924             "",
3925             address(0),
3926             0,
3927             principalToAdd,
3928             0,
3929             heldTokenAmount,
3930             true
3931         );
3932 
3933         return heldTokenAmount;
3934     }
3935 
3936     // ============ Private Helper-Functions ============
3937 
3938     function doBorrowAndSell(
3939         MarginState.State storage state,
3940         BorrowShared.Tx memory transaction,
3941         bytes orderData
3942     )
3943         private
3944     {
3945         // Calculate the number of heldTokens to add
3946         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
3947             state,
3948             state.positions[transaction.positionId],
3949             transaction.positionId,
3950             transaction.principal
3951         );
3952 
3953         // Do pre-exchange validations
3954         BorrowShared.validateTxPreSell(state, transaction);
3955 
3956         // Calculate and deposit owedToken
3957         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
3958         if (!transaction.depositInHeldToken) {
3959             transaction.depositAmount =
3960                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
3961             BorrowShared.doDepositOwedToken(state, transaction);
3962             maxHeldTokenFromSell = collateralToAdd;
3963         }
3964 
3965         // Sell owedToken for heldToken using the exchange wrapper
3966         transaction.heldTokenFromSell = BorrowShared.doSell(
3967             state,
3968             transaction,
3969             orderData,
3970             maxHeldTokenFromSell
3971         );
3972 
3973         // Calculate and deposit heldToken
3974         if (transaction.depositInHeldToken) {
3975             require(
3976                 transaction.heldTokenFromSell <= collateralToAdd,
3977                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
3978             );
3979             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
3980             BorrowShared.doDepositHeldToken(state, transaction);
3981         }
3982 
3983         // Make sure the actual added collateral is what is expected
3984         assert(transaction.collateralAmount == collateralToAdd);
3985 
3986         // Do post-exchange validations
3987         BorrowShared.doPostSell(state, transaction);
3988     }
3989 
3990     function getOwedTokenDeposit(
3991         BorrowShared.Tx transaction,
3992         uint256 collateralToAdd,
3993         bytes orderData
3994     )
3995         private
3996         view
3997         returns (uint256)
3998     {
3999         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
4000             transaction.loanOffering.heldToken,
4001             transaction.loanOffering.owedToken,
4002             collateralToAdd,
4003             orderData
4004         );
4005 
4006         require(
4007             transaction.lenderAmount <= totalOwedToken,
4008             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4009         );
4010 
4011         return totalOwedToken.sub(transaction.lenderAmount);
4012     }
4013 
4014     function validateIncrease(
4015         MarginState.State storage state,
4016         BorrowShared.Tx transaction,
4017         MarginCommon.Position storage position
4018     )
4019         private
4020         view
4021     {
4022         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4023 
4024         require(
4025             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4026             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4027         );
4028 
4029         // require the position to end no later than the loanOffering's maximum acceptable end time
4030         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4031         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4032         require(
4033             positionEndTimestamp <= offeringEndTimestamp,
4034             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4035         );
4036 
4037         require(
4038             block.timestamp < positionEndTimestamp,
4039             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4040         );
4041     }
4042 
4043     function getCollateralNeededForAddedPrincipal(
4044         MarginState.State storage state,
4045         MarginCommon.Position storage position,
4046         bytes32 positionId,
4047         uint256 principalToAdd
4048     )
4049         private
4050         view
4051         returns (uint256)
4052     {
4053         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4054 
4055         return MathHelpers.getPartialAmountRoundedUp(
4056             principalToAdd,
4057             position.principal,
4058             heldTokenBalance
4059         );
4060     }
4061 
4062     function updateState(
4063         MarginCommon.Position storage position,
4064         bytes32 positionId,
4065         uint256 principalAdded,
4066         uint256 owedTokenLent,
4067         address loanPayer
4068     )
4069         private
4070     {
4071         position.principal = position.principal.add(principalAdded);
4072 
4073         address owner = position.owner;
4074         address lender = position.lender;
4075 
4076         // Ensure owner consent
4077         increasePositionOnBehalfOfRecurse(
4078             owner,
4079             msg.sender,
4080             positionId,
4081             principalAdded
4082         );
4083 
4084         // Ensure lender consent
4085         increaseLoanOnBehalfOfRecurse(
4086             lender,
4087             loanPayer,
4088             positionId,
4089             principalAdded,
4090             owedTokenLent
4091         );
4092     }
4093 
4094     function increasePositionOnBehalfOfRecurse(
4095         address contractAddr,
4096         address trader,
4097         bytes32 positionId,
4098         uint256 principalAdded
4099     )
4100         private
4101     {
4102         // Assume owner approval if not a smart contract and they increased their own position
4103         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4104             return;
4105         }
4106 
4107         address newContractAddr =
4108             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4109                 trader,
4110                 positionId,
4111                 principalAdded
4112             );
4113 
4114         if (newContractAddr != contractAddr) {
4115             increasePositionOnBehalfOfRecurse(
4116                 newContractAddr,
4117                 trader,
4118                 positionId,
4119                 principalAdded
4120             );
4121         }
4122     }
4123 
4124     function increaseLoanOnBehalfOfRecurse(
4125         address contractAddr,
4126         address payer,
4127         bytes32 positionId,
4128         uint256 principalAdded,
4129         uint256 amountLent
4130     )
4131         private
4132     {
4133         // Assume lender approval if not a smart contract and they increased their own loan
4134         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4135             return;
4136         }
4137 
4138         address newContractAddr =
4139             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4140                 payer,
4141                 positionId,
4142                 principalAdded,
4143                 amountLent
4144             );
4145 
4146         if (newContractAddr != contractAddr) {
4147             increaseLoanOnBehalfOfRecurse(
4148                 newContractAddr,
4149                 payer,
4150                 positionId,
4151                 principalAdded,
4152                 amountLent
4153             );
4154         }
4155     }
4156 
4157     function recordPositionIncreased(
4158         BorrowShared.Tx transaction,
4159         MarginCommon.Position storage position
4160     )
4161         private
4162     {
4163         emit PositionIncreased(
4164             transaction.positionId,
4165             msg.sender,
4166             transaction.loanOffering.payer,
4167             position.owner,
4168             position.lender,
4169             transaction.loanOffering.loanHash,
4170             transaction.loanOffering.feeRecipient,
4171             transaction.lenderAmount,
4172             transaction.principal,
4173             transaction.heldTokenFromSell,
4174             transaction.depositAmount,
4175             transaction.depositInHeldToken
4176         );
4177     }
4178 
4179     // ============ Parsing Functions ============
4180 
4181     function parseIncreasePositionTx(
4182         MarginCommon.Position storage position,
4183         bytes32 positionId,
4184         address[7] addresses,
4185         uint256[8] values256,
4186         uint32[2] values32,
4187         bool depositInHeldToken,
4188         bytes signature
4189     )
4190         private
4191         view
4192         returns (BorrowShared.Tx memory)
4193     {
4194         uint256 principal = values256[7];
4195 
4196         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4197             position,
4198             principal,
4199             block.timestamp
4200         );
4201         assert(lenderAmount >= principal);
4202 
4203         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4204             positionId: positionId,
4205             owner: position.owner,
4206             principal: principal,
4207             lenderAmount: lenderAmount,
4208             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4209                 position,
4210                 addresses,
4211                 values256,
4212                 values32,
4213                 signature
4214             ),
4215             exchangeWrapper: addresses[6],
4216             depositInHeldToken: depositInHeldToken,
4217             depositAmount: 0, // set later
4218             collateralAmount: 0, // set later
4219             heldTokenFromSell: 0 // set later
4220         });
4221 
4222         return transaction;
4223     }
4224 
4225     function parseLoanOfferingFromIncreasePositionTx(
4226         MarginCommon.Position storage position,
4227         address[7] addresses,
4228         uint256[8] values256,
4229         uint32[2] values32,
4230         bytes signature
4231     )
4232         private
4233         view
4234         returns (MarginCommon.LoanOffering memory)
4235     {
4236         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4237             owedToken: position.owedToken,
4238             heldToken: position.heldToken,
4239             payer: addresses[0],
4240             owner: position.lender,
4241             taker: addresses[1],
4242             positionOwner: addresses[2],
4243             feeRecipient: addresses[3],
4244             lenderFeeToken: addresses[4],
4245             takerFeeToken: addresses[5],
4246             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4247             expirationTimestamp: values256[5],
4248             callTimeLimit: values32[0],
4249             maxDuration: values32[1],
4250             salt: values256[6],
4251             loanHash: 0,
4252             signature: signature
4253         });
4254 
4255         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4256 
4257         return loanOffering;
4258     }
4259 
4260     function parseLoanOfferingRatesFromIncreasePositionTx(
4261         MarginCommon.Position storage position,
4262         uint256[8] values256
4263     )
4264         private
4265         view
4266         returns (MarginCommon.LoanRates memory)
4267     {
4268         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4269             maxAmount: values256[0],
4270             minAmount: values256[1],
4271             minHeldToken: values256[2],
4272             lenderFee: values256[3],
4273             takerFee: values256[4],
4274             interestRate: position.interestRate,
4275             interestPeriod: position.interestPeriod
4276         });
4277 
4278         return rates;
4279     }
4280 }
4281 
4282 // File: contracts/margin/impl/MarginStorage.sol
4283 
4284 /**
4285  * @title MarginStorage
4286  * @author dYdX
4287  *
4288  * This contract serves as the storage for the entire state of MarginStorage
4289  */
4290 contract MarginStorage {
4291 
4292     MarginState.State state;
4293 
4294 }
4295 
4296 // File: contracts/margin/impl/LoanGetters.sol
4297 
4298 /**
4299  * @title LoanGetters
4300  * @author dYdX
4301  *
4302  * A collection of public constant getter functions that allows reading of the state of any loan
4303  * offering stored in the dYdX protocol.
4304  */
4305 contract LoanGetters is MarginStorage {
4306 
4307     // ============ Public Constant Functions ============
4308 
4309     /**
4310      * Gets the principal amount of a loan offering that is no longer available.
4311      *
4312      * @param  loanHash  Unique hash of the loan offering
4313      * @return           The total unavailable amount of the loan offering, which is equal to the
4314      *                   filled amount plus the canceled amount.
4315      */
4316     function getLoanUnavailableAmount(
4317         bytes32 loanHash
4318     )
4319         external
4320         view
4321         returns (uint256)
4322     {
4323         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4324     }
4325 
4326     /**
4327      * Gets the total amount of owed token lent for a loan.
4328      *
4329      * @param  loanHash  Unique hash of the loan offering
4330      * @return           The total filled amount of the loan offering.
4331      */
4332     function getLoanFilledAmount(
4333         bytes32 loanHash
4334     )
4335         external
4336         view
4337         returns (uint256)
4338     {
4339         return state.loanFills[loanHash];
4340     }
4341 
4342     /**
4343      * Gets the amount of a loan offering that has been canceled.
4344      *
4345      * @param  loanHash  Unique hash of the loan offering
4346      * @return           The total canceled amount of the loan offering.
4347      */
4348     function getLoanCanceledAmount(
4349         bytes32 loanHash
4350     )
4351         external
4352         view
4353         returns (uint256)
4354     {
4355         return state.loanCancels[loanHash];
4356     }
4357 }
4358 
4359 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4360 
4361 /**
4362  * @title CancelMarginCallDelegator
4363  * @author dYdX
4364  *
4365  * Interface that smart contracts must implement in order to let other addresses cancel a
4366  * margin-call for a loan owned by the smart contract.
4367  *
4368  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4369  *       to these functions
4370  */
4371 interface CancelMarginCallDelegator {
4372 
4373     // ============ Public Interface functions ============
4374 
4375     /**
4376      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4377      *
4378      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4379      * either revert the entire transaction or that the margin-call was successfully canceled.
4380      *
4381      * @param  canceler    Address of the caller of the cancelMarginCall function
4382      * @param  positionId  Unique ID of the position
4383      * @return             This address to accept, a different address to ask that contract
4384      */
4385     function cancelMarginCallOnBehalfOf(
4386         address canceler,
4387         bytes32 positionId
4388     )
4389         external
4390         /* onlyMargin */
4391         returns (address);
4392 }
4393 
4394 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4395 
4396 /**
4397  * @title MarginCallDelegator
4398  * @author dYdX
4399  *
4400  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4401  * owned by the smart contract.
4402  *
4403  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4404  *       to these functions
4405  */
4406 interface MarginCallDelegator {
4407 
4408     // ============ Public Interface functions ============
4409 
4410     /**
4411      * Function a contract must implement in order to let other addresses call marginCall().
4412      *
4413      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4414      * either revert the entire transaction or that the loan was successfully margin-called.
4415      *
4416      * @param  caller         Address of the caller of the marginCall function
4417      * @param  positionId     Unique ID of the position
4418      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4419      * @return                This address to accept, a different address to ask that contract
4420      */
4421     function marginCallOnBehalfOf(
4422         address caller,
4423         bytes32 positionId,
4424         uint256 depositAmount
4425     )
4426         external
4427         /* onlyMargin */
4428         returns (address);
4429 }
4430 
4431 // File: contracts/margin/impl/LoanImpl.sol
4432 
4433 /**
4434  * @title LoanImpl
4435  * @author dYdX
4436  *
4437  * This library contains the implementation for the following functions of Margin:
4438  *
4439  *      - marginCall
4440  *      - cancelMarginCallImpl
4441  *      - cancelLoanOffering
4442  */
4443 library LoanImpl {
4444     using SafeMath for uint256;
4445 
4446     // ============ Events ============
4447 
4448     /**
4449      * A position was margin-called
4450      */
4451     event MarginCallInitiated(
4452         bytes32 indexed positionId,
4453         address indexed lender,
4454         address indexed owner,
4455         uint256 requiredDeposit
4456     );
4457 
4458     /**
4459      * A margin call was canceled
4460      */
4461     event MarginCallCanceled(
4462         bytes32 indexed positionId,
4463         address indexed lender,
4464         address indexed owner,
4465         uint256 depositAmount
4466     );
4467 
4468     /**
4469      * A loan offering was canceled before it was used. Any amount less than the
4470      * total for the loan offering can be canceled.
4471      */
4472     event LoanOfferingCanceled(
4473         bytes32 indexed loanHash,
4474         address indexed payer,
4475         address indexed feeRecipient,
4476         uint256 cancelAmount
4477     );
4478 
4479     // ============ Public Implementation Functions ============
4480 
4481     function marginCallImpl(
4482         MarginState.State storage state,
4483         bytes32 positionId,
4484         uint256 requiredDeposit
4485     )
4486         public
4487     {
4488         MarginCommon.Position storage position =
4489             MarginCommon.getPositionFromStorage(state, positionId);
4490 
4491         require(
4492             position.callTimestamp == 0,
4493             "LoanImpl#marginCallImpl: The position has already been margin-called"
4494         );
4495 
4496         // Ensure lender consent
4497         marginCallOnBehalfOfRecurse(
4498             position.lender,
4499             msg.sender,
4500             positionId,
4501             requiredDeposit
4502         );
4503 
4504         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4505         position.requiredDeposit = requiredDeposit;
4506 
4507         emit MarginCallInitiated(
4508             positionId,
4509             position.lender,
4510             position.owner,
4511             requiredDeposit
4512         );
4513     }
4514 
4515     function cancelMarginCallImpl(
4516         MarginState.State storage state,
4517         bytes32 positionId
4518     )
4519         public
4520     {
4521         MarginCommon.Position storage position =
4522             MarginCommon.getPositionFromStorage(state, positionId);
4523 
4524         require(
4525             position.callTimestamp > 0,
4526             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4527         );
4528 
4529         // Ensure lender consent
4530         cancelMarginCallOnBehalfOfRecurse(
4531             position.lender,
4532             msg.sender,
4533             positionId
4534         );
4535 
4536         state.positions[positionId].callTimestamp = 0;
4537         state.positions[positionId].requiredDeposit = 0;
4538 
4539         emit MarginCallCanceled(
4540             positionId,
4541             position.lender,
4542             position.owner,
4543             0
4544         );
4545     }
4546 
4547     function cancelLoanOfferingImpl(
4548         MarginState.State storage state,
4549         address[9] addresses,
4550         uint256[7] values256,
4551         uint32[4]  values32,
4552         uint256    cancelAmount
4553     )
4554         public
4555         returns (uint256)
4556     {
4557         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4558             addresses,
4559             values256,
4560             values32
4561         );
4562 
4563         require(
4564             msg.sender == loanOffering.payer,
4565             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4566         );
4567         require(
4568             loanOffering.expirationTimestamp > block.timestamp,
4569             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4570         );
4571 
4572         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4573             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4574         );
4575         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4576 
4577         // If the loan was already fully canceled, then just return 0 amount was canceled
4578         if (amountToCancel == 0) {
4579             return 0;
4580         }
4581 
4582         state.loanCancels[loanOffering.loanHash] =
4583             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4584 
4585         emit LoanOfferingCanceled(
4586             loanOffering.loanHash,
4587             loanOffering.payer,
4588             loanOffering.feeRecipient,
4589             amountToCancel
4590         );
4591 
4592         return amountToCancel;
4593     }
4594 
4595     // ============ Private Helper-Functions ============
4596 
4597     function marginCallOnBehalfOfRecurse(
4598         address contractAddr,
4599         address who,
4600         bytes32 positionId,
4601         uint256 requiredDeposit
4602     )
4603         private
4604     {
4605         // no need to ask for permission
4606         if (who == contractAddr) {
4607             return;
4608         }
4609 
4610         address newContractAddr =
4611             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4612                 msg.sender,
4613                 positionId,
4614                 requiredDeposit
4615             );
4616 
4617         if (newContractAddr != contractAddr) {
4618             marginCallOnBehalfOfRecurse(
4619                 newContractAddr,
4620                 who,
4621                 positionId,
4622                 requiredDeposit
4623             );
4624         }
4625     }
4626 
4627     function cancelMarginCallOnBehalfOfRecurse(
4628         address contractAddr,
4629         address who,
4630         bytes32 positionId
4631     )
4632         private
4633     {
4634         // no need to ask for permission
4635         if (who == contractAddr) {
4636             return;
4637         }
4638 
4639         address newContractAddr =
4640             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4641                 msg.sender,
4642                 positionId
4643             );
4644 
4645         if (newContractAddr != contractAddr) {
4646             cancelMarginCallOnBehalfOfRecurse(
4647                 newContractAddr,
4648                 who,
4649                 positionId
4650             );
4651         }
4652     }
4653 
4654     // ============ Parsing Functions ============
4655 
4656     function parseLoanOffering(
4657         address[9] addresses,
4658         uint256[7] values256,
4659         uint32[4]  values32
4660     )
4661         private
4662         view
4663         returns (MarginCommon.LoanOffering memory)
4664     {
4665         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4666             owedToken: addresses[0],
4667             heldToken: addresses[1],
4668             payer: addresses[2],
4669             owner: addresses[3],
4670             taker: addresses[4],
4671             positionOwner: addresses[5],
4672             feeRecipient: addresses[6],
4673             lenderFeeToken: addresses[7],
4674             takerFeeToken: addresses[8],
4675             rates: parseLoanOfferRates(values256, values32),
4676             expirationTimestamp: values256[5],
4677             callTimeLimit: values32[0],
4678             maxDuration: values32[1],
4679             salt: values256[6],
4680             loanHash: 0,
4681             signature: new bytes(0)
4682         });
4683 
4684         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4685 
4686         return loanOffering;
4687     }
4688 
4689     function parseLoanOfferRates(
4690         uint256[7] values256,
4691         uint32[4] values32
4692     )
4693         private
4694         pure
4695         returns (MarginCommon.LoanRates memory)
4696     {
4697         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4698             maxAmount: values256[0],
4699             minAmount: values256[1],
4700             minHeldToken: values256[2],
4701             interestRate: values32[2],
4702             lenderFee: values256[3],
4703             takerFee: values256[4],
4704             interestPeriod: values32[3]
4705         });
4706 
4707         return rates;
4708     }
4709 }
4710 
4711 // File: contracts/margin/impl/MarginAdmin.sol
4712 
4713 /**
4714  * @title MarginAdmin
4715  * @author dYdX
4716  *
4717  * Contains admin functions for the Margin contract
4718  * The owner can put Margin into various close-only modes, which will disallow new position creation
4719  */
4720 contract MarginAdmin is Ownable {
4721     // ============ Enums ============
4722 
4723     // All functionality enabled
4724     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4725 
4726     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4727     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4728     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4729 
4730     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4731     // forceRecoverCollateral)
4732     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4733 
4734     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4735     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4736 
4737     // This operation state (and any higher) is invalid
4738     uint8 private constant OPERATION_STATE_INVALID = 4;
4739 
4740     // ============ Events ============
4741 
4742     /**
4743      * Event indicating the operation state has changed
4744      */
4745     event OperationStateChanged(
4746         uint8 from,
4747         uint8 to
4748     );
4749 
4750     // ============ State Variables ============
4751 
4752     uint8 public operationState;
4753 
4754     // ============ Constructor ============
4755 
4756     constructor()
4757         public
4758         Ownable()
4759     {
4760         operationState = OPERATION_STATE_OPERATIONAL;
4761     }
4762 
4763     // ============ Modifiers ============
4764 
4765     modifier onlyWhileOperational() {
4766         require(
4767             operationState == OPERATION_STATE_OPERATIONAL,
4768             "MarginAdmin#onlyWhileOperational: Can only call while operational"
4769         );
4770         _;
4771     }
4772 
4773     modifier cancelLoanOfferingStateControl() {
4774         require(
4775             operationState == OPERATION_STATE_OPERATIONAL
4776             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
4777             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
4778         );
4779         _;
4780     }
4781 
4782     modifier closePositionStateControl() {
4783         require(
4784             operationState == OPERATION_STATE_OPERATIONAL
4785             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
4786             || operationState == OPERATION_STATE_CLOSE_ONLY,
4787             "MarginAdmin#closePositionStateControl: Invalid operation state"
4788         );
4789         _;
4790     }
4791 
4792     modifier closePositionDirectlyStateControl() {
4793         _;
4794     }
4795 
4796     // ============ Owner-Only State-Changing Functions ============
4797 
4798     function setOperationState(
4799         uint8 newState
4800     )
4801         external
4802         onlyOwner
4803     {
4804         require(
4805             newState < OPERATION_STATE_INVALID,
4806             "MarginAdmin#setOperationState: newState is not a valid operation state"
4807         );
4808 
4809         if (newState != operationState) {
4810             emit OperationStateChanged(
4811                 operationState,
4812                 newState
4813             );
4814             operationState = newState;
4815         }
4816     }
4817 }
4818 
4819 // File: contracts/margin/impl/MarginEvents.sol
4820 
4821 /**
4822  * @title MarginEvents
4823  * @author dYdX
4824  *
4825  * Contains events for the Margin contract.
4826  *
4827  * NOTE: Any Margin function libraries that use events will need to both define the event here
4828  *       and copy the event into the library itself as libraries don't support sharing events
4829  */
4830 contract MarginEvents {
4831     // ============ Events ============
4832 
4833     /**
4834      * A position was opened
4835      */
4836     event PositionOpened(
4837         bytes32 indexed positionId,
4838         address indexed trader,
4839         address indexed lender,
4840         bytes32 loanHash,
4841         address owedToken,
4842         address heldToken,
4843         address loanFeeRecipient,
4844         uint256 principal,
4845         uint256 heldTokenFromSell,
4846         uint256 depositAmount,
4847         uint256 interestRate,
4848         uint32  callTimeLimit,
4849         uint32  maxDuration,
4850         bool    depositInHeldToken
4851     );
4852 
4853     /*
4854      * A position was increased
4855      */
4856     event PositionIncreased(
4857         bytes32 indexed positionId,
4858         address indexed trader,
4859         address indexed lender,
4860         address positionOwner,
4861         address loanOwner,
4862         bytes32 loanHash,
4863         address loanFeeRecipient,
4864         uint256 amountBorrowed,
4865         uint256 principalAdded,
4866         uint256 heldTokenFromSell,
4867         uint256 depositAmount,
4868         bool    depositInHeldToken
4869     );
4870 
4871     /**
4872      * A position was closed or partially closed
4873      */
4874     event PositionClosed(
4875         bytes32 indexed positionId,
4876         address indexed closer,
4877         address indexed payoutRecipient,
4878         uint256 closeAmount,
4879         uint256 remainingAmount,
4880         uint256 owedTokenPaidToLender,
4881         uint256 payoutAmount,
4882         uint256 buybackCostInHeldToken,
4883         bool payoutInHeldToken
4884     );
4885 
4886     /**
4887      * Collateral for a position was forcibly recovered
4888      */
4889     event CollateralForceRecovered(
4890         bytes32 indexed positionId,
4891         address indexed recipient,
4892         uint256 amount
4893     );
4894 
4895     /**
4896      * A position was margin-called
4897      */
4898     event MarginCallInitiated(
4899         bytes32 indexed positionId,
4900         address indexed lender,
4901         address indexed owner,
4902         uint256 requiredDeposit
4903     );
4904 
4905     /**
4906      * A margin call was canceled
4907      */
4908     event MarginCallCanceled(
4909         bytes32 indexed positionId,
4910         address indexed lender,
4911         address indexed owner,
4912         uint256 depositAmount
4913     );
4914 
4915     /**
4916      * A loan offering was canceled before it was used. Any amount less than the
4917      * total for the loan offering can be canceled.
4918      */
4919     event LoanOfferingCanceled(
4920         bytes32 indexed loanHash,
4921         address indexed payer,
4922         address indexed feeRecipient,
4923         uint256 cancelAmount
4924     );
4925 
4926     /**
4927      * Additional collateral for a position was posted by the owner
4928      */
4929     event AdditionalCollateralDeposited(
4930         bytes32 indexed positionId,
4931         uint256 amount,
4932         address depositor
4933     );
4934 
4935     /**
4936      * Ownership of a loan was transferred to a new address
4937      */
4938     event LoanTransferred(
4939         bytes32 indexed positionId,
4940         address indexed from,
4941         address indexed to
4942     );
4943 
4944     /**
4945      * Ownership of a position was transferred to a new address
4946      */
4947     event PositionTransferred(
4948         bytes32 indexed positionId,
4949         address indexed from,
4950         address indexed to
4951     );
4952 }
4953 
4954 // File: contracts/margin/impl/OpenPositionImpl.sol
4955 
4956 /**
4957  * @title OpenPositionImpl
4958  * @author dYdX
4959  *
4960  * This library contains the implementation for the openPosition function of Margin
4961  */
4962 library OpenPositionImpl {
4963     using SafeMath for uint256;
4964 
4965     // ============ Events ============
4966 
4967     /**
4968      * A position was opened
4969      */
4970     event PositionOpened(
4971         bytes32 indexed positionId,
4972         address indexed trader,
4973         address indexed lender,
4974         bytes32 loanHash,
4975         address owedToken,
4976         address heldToken,
4977         address loanFeeRecipient,
4978         uint256 principal,
4979         uint256 heldTokenFromSell,
4980         uint256 depositAmount,
4981         uint256 interestRate,
4982         uint32  callTimeLimit,
4983         uint32  maxDuration,
4984         bool    depositInHeldToken
4985     );
4986 
4987     // ============ Public Implementation Functions ============
4988 
4989     function openPositionImpl(
4990         MarginState.State storage state,
4991         address[11] addresses,
4992         uint256[10] values256,
4993         uint32[4] values32,
4994         bool depositInHeldToken,
4995         bytes signature,
4996         bytes orderData
4997     )
4998         public
4999         returns (bytes32)
5000     {
5001         BorrowShared.Tx memory transaction = parseOpenTx(
5002             addresses,
5003             values256,
5004             values32,
5005             depositInHeldToken,
5006             signature
5007         );
5008 
5009         require(
5010             !MarginCommon.positionHasExisted(state, transaction.positionId),
5011             "OpenPositionImpl#openPositionImpl: positionId already exists"
5012         );
5013 
5014         doBorrowAndSell(state, transaction, orderData);
5015 
5016         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5017         recordPositionOpened(
5018             transaction
5019         );
5020 
5021         doStoreNewPosition(
5022             state,
5023             transaction
5024         );
5025 
5026         return transaction.positionId;
5027     }
5028 
5029     // ============ Private Helper-Functions ============
5030 
5031     function doBorrowAndSell(
5032         MarginState.State storage state,
5033         BorrowShared.Tx memory transaction,
5034         bytes orderData
5035     )
5036         private
5037     {
5038         BorrowShared.validateTxPreSell(state, transaction);
5039 
5040         if (transaction.depositInHeldToken) {
5041             BorrowShared.doDepositHeldToken(state, transaction);
5042         } else {
5043             BorrowShared.doDepositOwedToken(state, transaction);
5044         }
5045 
5046         transaction.heldTokenFromSell = BorrowShared.doSell(
5047             state,
5048             transaction,
5049             orderData,
5050             MathHelpers.maxUint256()
5051         );
5052 
5053         BorrowShared.doPostSell(state, transaction);
5054     }
5055 
5056     function doStoreNewPosition(
5057         MarginState.State storage state,
5058         BorrowShared.Tx memory transaction
5059     )
5060         private
5061     {
5062         MarginCommon.storeNewPosition(
5063             state,
5064             transaction.positionId,
5065             MarginCommon.Position({
5066                 owedToken: transaction.loanOffering.owedToken,
5067                 heldToken: transaction.loanOffering.heldToken,
5068                 lender: transaction.loanOffering.owner,
5069                 owner: transaction.owner,
5070                 principal: transaction.principal,
5071                 requiredDeposit: 0,
5072                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5073                 startTimestamp: 0,
5074                 callTimestamp: 0,
5075                 maxDuration: transaction.loanOffering.maxDuration,
5076                 interestRate: transaction.loanOffering.rates.interestRate,
5077                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5078             }),
5079             transaction.loanOffering.payer
5080         );
5081     }
5082 
5083     function recordPositionOpened(
5084         BorrowShared.Tx transaction
5085     )
5086         private
5087     {
5088         emit PositionOpened(
5089             transaction.positionId,
5090             msg.sender,
5091             transaction.loanOffering.payer,
5092             transaction.loanOffering.loanHash,
5093             transaction.loanOffering.owedToken,
5094             transaction.loanOffering.heldToken,
5095             transaction.loanOffering.feeRecipient,
5096             transaction.principal,
5097             transaction.heldTokenFromSell,
5098             transaction.depositAmount,
5099             transaction.loanOffering.rates.interestRate,
5100             transaction.loanOffering.callTimeLimit,
5101             transaction.loanOffering.maxDuration,
5102             transaction.depositInHeldToken
5103         );
5104     }
5105 
5106     // ============ Parsing Functions ============
5107 
5108     function parseOpenTx(
5109         address[11] addresses,
5110         uint256[10] values256,
5111         uint32[4] values32,
5112         bool depositInHeldToken,
5113         bytes signature
5114     )
5115         private
5116         view
5117         returns (BorrowShared.Tx memory)
5118     {
5119         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5120             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5121             owner: addresses[0],
5122             principal: values256[7],
5123             lenderAmount: values256[7],
5124             loanOffering: parseLoanOffering(
5125                 addresses,
5126                 values256,
5127                 values32,
5128                 signature
5129             ),
5130             exchangeWrapper: addresses[10],
5131             depositInHeldToken: depositInHeldToken,
5132             depositAmount: values256[8],
5133             collateralAmount: 0, // set later
5134             heldTokenFromSell: 0 // set later
5135         });
5136 
5137         return transaction;
5138     }
5139 
5140     function parseLoanOffering(
5141         address[11] addresses,
5142         uint256[10] values256,
5143         uint32[4]   values32,
5144         bytes       signature
5145     )
5146         private
5147         view
5148         returns (MarginCommon.LoanOffering memory)
5149     {
5150         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5151             owedToken: addresses[1],
5152             heldToken: addresses[2],
5153             payer: addresses[3],
5154             owner: addresses[4],
5155             taker: addresses[5],
5156             positionOwner: addresses[6],
5157             feeRecipient: addresses[7],
5158             lenderFeeToken: addresses[8],
5159             takerFeeToken: addresses[9],
5160             rates: parseLoanOfferRates(values256, values32),
5161             expirationTimestamp: values256[5],
5162             callTimeLimit: values32[0],
5163             maxDuration: values32[1],
5164             salt: values256[6],
5165             loanHash: 0,
5166             signature: signature
5167         });
5168 
5169         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5170 
5171         return loanOffering;
5172     }
5173 
5174     function parseLoanOfferRates(
5175         uint256[10] values256,
5176         uint32[4] values32
5177     )
5178         private
5179         pure
5180         returns (MarginCommon.LoanRates memory)
5181     {
5182         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5183             maxAmount: values256[0],
5184             minAmount: values256[1],
5185             minHeldToken: values256[2],
5186             lenderFee: values256[3],
5187             takerFee: values256[4],
5188             interestRate: values32[2],
5189             interestPeriod: values32[3]
5190         });
5191 
5192         return rates;
5193     }
5194 }
5195 
5196 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5197 
5198 /**
5199  * @title OpenWithoutCounterpartyImpl
5200  * @author dYdX
5201  *
5202  * This library contains the implementation for the openWithoutCounterparty
5203  * function of Margin
5204  */
5205 library OpenWithoutCounterpartyImpl {
5206 
5207     // ============ Structs ============
5208 
5209     struct Tx {
5210         bytes32 positionId;
5211         address positionOwner;
5212         address owedToken;
5213         address heldToken;
5214         address loanOwner;
5215         uint256 principal;
5216         uint256 deposit;
5217         uint32 callTimeLimit;
5218         uint32 maxDuration;
5219         uint32 interestRate;
5220         uint32 interestPeriod;
5221     }
5222 
5223     // ============ Events ============
5224 
5225     /**
5226      * A position was opened
5227      */
5228     event PositionOpened(
5229         bytes32 indexed positionId,
5230         address indexed trader,
5231         address indexed lender,
5232         bytes32 loanHash,
5233         address owedToken,
5234         address heldToken,
5235         address loanFeeRecipient,
5236         uint256 principal,
5237         uint256 heldTokenFromSell,
5238         uint256 depositAmount,
5239         uint256 interestRate,
5240         uint32  callTimeLimit,
5241         uint32  maxDuration,
5242         bool    depositInHeldToken
5243     );
5244 
5245     // ============ Public Implementation Functions ============
5246 
5247     function openWithoutCounterpartyImpl(
5248         MarginState.State storage state,
5249         address[4] addresses,
5250         uint256[3] values256,
5251         uint32[4]  values32
5252     )
5253         public
5254         returns (bytes32)
5255     {
5256         Tx memory openTx = parseTx(
5257             addresses,
5258             values256,
5259             values32
5260         );
5261 
5262         validate(
5263             state,
5264             openTx
5265         );
5266 
5267         Vault(state.VAULT).transferToVault(
5268             openTx.positionId,
5269             openTx.heldToken,
5270             msg.sender,
5271             openTx.deposit
5272         );
5273 
5274         recordPositionOpened(
5275             openTx
5276         );
5277 
5278         doStoreNewPosition(
5279             state,
5280             openTx
5281         );
5282 
5283         return openTx.positionId;
5284     }
5285 
5286     // ============ Private Helper-Functions ============
5287 
5288     function doStoreNewPosition(
5289         MarginState.State storage state,
5290         Tx memory openTx
5291     )
5292         private
5293     {
5294         MarginCommon.storeNewPosition(
5295             state,
5296             openTx.positionId,
5297             MarginCommon.Position({
5298                 owedToken: openTx.owedToken,
5299                 heldToken: openTx.heldToken,
5300                 lender: openTx.loanOwner,
5301                 owner: openTx.positionOwner,
5302                 principal: openTx.principal,
5303                 requiredDeposit: 0,
5304                 callTimeLimit: openTx.callTimeLimit,
5305                 startTimestamp: 0,
5306                 callTimestamp: 0,
5307                 maxDuration: openTx.maxDuration,
5308                 interestRate: openTx.interestRate,
5309                 interestPeriod: openTx.interestPeriod
5310             }),
5311             msg.sender
5312         );
5313     }
5314 
5315     function validate(
5316         MarginState.State storage state,
5317         Tx memory openTx
5318     )
5319         private
5320         view
5321     {
5322         require(
5323             !MarginCommon.positionHasExisted(state, openTx.positionId),
5324             "openWithoutCounterpartyImpl#validate: positionId already exists"
5325         );
5326 
5327         require(
5328             openTx.principal > 0,
5329             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5330         );
5331 
5332         require(
5333             openTx.owedToken != address(0),
5334             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5335         );
5336 
5337         require(
5338             openTx.owedToken != openTx.heldToken,
5339             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5340         );
5341 
5342         require(
5343             openTx.positionOwner != address(0),
5344             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5345         );
5346 
5347         require(
5348             openTx.loanOwner != address(0),
5349             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5350         );
5351 
5352         require(
5353             openTx.maxDuration > 0,
5354             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5355         );
5356 
5357         require(
5358             openTx.interestPeriod <= openTx.maxDuration,
5359             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5360         );
5361     }
5362 
5363     function recordPositionOpened(
5364         Tx memory openTx
5365     )
5366         private
5367     {
5368         emit PositionOpened(
5369             openTx.positionId,
5370             msg.sender,
5371             msg.sender,
5372             bytes32(0),
5373             openTx.owedToken,
5374             openTx.heldToken,
5375             address(0),
5376             openTx.principal,
5377             0,
5378             openTx.deposit,
5379             openTx.interestRate,
5380             openTx.callTimeLimit,
5381             openTx.maxDuration,
5382             true
5383         );
5384     }
5385 
5386     // ============ Parsing Functions ============
5387 
5388     function parseTx(
5389         address[4] addresses,
5390         uint256[3] values256,
5391         uint32[4]  values32
5392     )
5393         private
5394         view
5395         returns (Tx memory)
5396     {
5397         Tx memory openTx = Tx({
5398             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5399             positionOwner: addresses[0],
5400             owedToken: addresses[1],
5401             heldToken: addresses[2],
5402             loanOwner: addresses[3],
5403             principal: values256[0],
5404             deposit: values256[1],
5405             callTimeLimit: values32[0],
5406             maxDuration: values32[1],
5407             interestRate: values32[2],
5408             interestPeriod: values32[3]
5409         });
5410 
5411         return openTx;
5412     }
5413 }
5414 
5415 // File: contracts/margin/impl/PositionGetters.sol
5416 
5417 /**
5418  * @title PositionGetters
5419  * @author dYdX
5420  *
5421  * A collection of public constant getter functions that allows reading of the state of any position
5422  * stored in the dYdX protocol.
5423  */
5424 contract PositionGetters is MarginStorage {
5425     using SafeMath for uint256;
5426 
5427     // ============ Public Constant Functions ============
5428 
5429     /**
5430      * Gets if a position is currently open.
5431      *
5432      * @param  positionId  Unique ID of the position
5433      * @return             True if the position is exists and is open
5434      */
5435     function containsPosition(
5436         bytes32 positionId
5437     )
5438         external
5439         view
5440         returns (bool)
5441     {
5442         return MarginCommon.containsPositionImpl(state, positionId);
5443     }
5444 
5445     /**
5446      * Gets if a position is currently margin-called.
5447      *
5448      * @param  positionId  Unique ID of the position
5449      * @return             True if the position is margin-called
5450      */
5451     function isPositionCalled(
5452         bytes32 positionId
5453     )
5454         external
5455         view
5456         returns (bool)
5457     {
5458         return (state.positions[positionId].callTimestamp > 0);
5459     }
5460 
5461     /**
5462      * Gets if a position was previously open and is now closed.
5463      *
5464      * @param  positionId  Unique ID of the position
5465      * @return             True if the position is now closed
5466      */
5467     function isPositionClosed(
5468         bytes32 positionId
5469     )
5470         external
5471         view
5472         returns (bool)
5473     {
5474         return state.closedPositions[positionId];
5475     }
5476 
5477     /**
5478      * Gets the total amount of owedToken ever repaid to the lender for a position.
5479      *
5480      * @param  positionId  Unique ID of the position
5481      * @return             Total amount of owedToken ever repaid
5482      */
5483     function getTotalOwedTokenRepaidToLender(
5484         bytes32 positionId
5485     )
5486         external
5487         view
5488         returns (uint256)
5489     {
5490         return state.totalOwedTokenRepaidToLender[positionId];
5491     }
5492 
5493     /**
5494      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5495      *
5496      * @param  positionId  Unique ID of the position
5497      * @return             The amount of heldToken
5498      */
5499     function getPositionBalance(
5500         bytes32 positionId
5501     )
5502         external
5503         view
5504         returns (uint256)
5505     {
5506         return MarginCommon.getPositionBalanceImpl(state, positionId);
5507     }
5508 
5509     /**
5510      * Gets the time until the interest fee charged for the position will increase.
5511      * Returns 1 if the interest fee increases every second.
5512      * Returns 0 if the interest fee will never increase again.
5513      *
5514      * @param  positionId  Unique ID of the position
5515      * @return             The number of seconds until the interest fee will increase
5516      */
5517     function getTimeUntilInterestIncrease(
5518         bytes32 positionId
5519     )
5520         external
5521         view
5522         returns (uint256)
5523     {
5524         MarginCommon.Position storage position =
5525             MarginCommon.getPositionFromStorage(state, positionId);
5526 
5527         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5528             position,
5529             block.timestamp
5530         );
5531 
5532         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5533         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5534             return 0;
5535         } else {
5536             // nextStep is the final second at which the calculated interest fee is the same as it
5537             // is currently, so add 1 to get the correct value
5538             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5539         }
5540     }
5541 
5542     /**
5543      * Gets the amount of owedTokens currently needed to close the position completely, including
5544      * interest fees.
5545      *
5546      * @param  positionId  Unique ID of the position
5547      * @return             The number of owedTokens
5548      */
5549     function getPositionOwedAmount(
5550         bytes32 positionId
5551     )
5552         external
5553         view
5554         returns (uint256)
5555     {
5556         MarginCommon.Position storage position =
5557             MarginCommon.getPositionFromStorage(state, positionId);
5558 
5559         return MarginCommon.calculateOwedAmount(
5560             position,
5561             position.principal,
5562             block.timestamp
5563         );
5564     }
5565 
5566     /**
5567      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5568      * given time, including interest fees.
5569      *
5570      * @param  positionId         Unique ID of the position
5571      * @param  principalToClose   Amount of principal being closed
5572      * @param  timestamp          Block timestamp in seconds of close
5573      * @return                    The number of owedTokens owed
5574      */
5575     function getPositionOwedAmountAtTime(
5576         bytes32 positionId,
5577         uint256 principalToClose,
5578         uint32  timestamp
5579     )
5580         external
5581         view
5582         returns (uint256)
5583     {
5584         MarginCommon.Position storage position =
5585             MarginCommon.getPositionFromStorage(state, positionId);
5586 
5587         require(
5588             timestamp >= position.startTimestamp,
5589             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5590         );
5591 
5592         return MarginCommon.calculateOwedAmount(
5593             position,
5594             principalToClose,
5595             timestamp
5596         );
5597     }
5598 
5599     /**
5600      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5601      * amount to the position at a given time.
5602      *
5603      * @param  positionId      Unique ID of the position
5604      * @param  principalToAdd  Amount being added to principal
5605      * @param  timestamp       Block timestamp in seconds of addition
5606      * @return                 The number of owedTokens that will be borrowed
5607      */
5608     function getLenderAmountForIncreasePositionAtTime(
5609         bytes32 positionId,
5610         uint256 principalToAdd,
5611         uint32  timestamp
5612     )
5613         external
5614         view
5615         returns (uint256)
5616     {
5617         MarginCommon.Position storage position =
5618             MarginCommon.getPositionFromStorage(state, positionId);
5619 
5620         require(
5621             timestamp >= position.startTimestamp,
5622             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5623         );
5624 
5625         return MarginCommon.calculateLenderAmountForIncreasePosition(
5626             position,
5627             principalToAdd,
5628             timestamp
5629         );
5630     }
5631 
5632     // ============ All Properties ============
5633 
5634     /**
5635      * Get a Position by id. This does not validate the position exists. If the position does not
5636      * exist, all 0's will be returned.
5637      *
5638      * @param  positionId  Unique ID of the position
5639      * @return             Addresses corresponding to:
5640      *
5641      *                     [0] = owedToken
5642      *                     [1] = heldToken
5643      *                     [2] = lender
5644      *                     [3] = owner
5645      *
5646      *                     Values corresponding to:
5647      *
5648      *                     [0] = principal
5649      *                     [1] = requiredDeposit
5650      *
5651      *                     Values corresponding to:
5652      *
5653      *                     [0] = callTimeLimit
5654      *                     [1] = startTimestamp
5655      *                     [2] = callTimestamp
5656      *                     [3] = maxDuration
5657      *                     [4] = interestRate
5658      *                     [5] = interestPeriod
5659      */
5660     function getPosition(
5661         bytes32 positionId
5662     )
5663         external
5664         view
5665         returns (
5666             address[4],
5667             uint256[2],
5668             uint32[6]
5669         )
5670     {
5671         MarginCommon.Position storage position = state.positions[positionId];
5672 
5673         return (
5674             [
5675                 position.owedToken,
5676                 position.heldToken,
5677                 position.lender,
5678                 position.owner
5679             ],
5680             [
5681                 position.principal,
5682                 position.requiredDeposit
5683             ],
5684             [
5685                 position.callTimeLimit,
5686                 position.startTimestamp,
5687                 position.callTimestamp,
5688                 position.maxDuration,
5689                 position.interestRate,
5690                 position.interestPeriod
5691             ]
5692         );
5693     }
5694 
5695     // ============ Individual Properties ============
5696 
5697     function getPositionLender(
5698         bytes32 positionId
5699     )
5700         external
5701         view
5702         returns (address)
5703     {
5704         return state.positions[positionId].lender;
5705     }
5706 
5707     function getPositionOwner(
5708         bytes32 positionId
5709     )
5710         external
5711         view
5712         returns (address)
5713     {
5714         return state.positions[positionId].owner;
5715     }
5716 
5717     function getPositionHeldToken(
5718         bytes32 positionId
5719     )
5720         external
5721         view
5722         returns (address)
5723     {
5724         return state.positions[positionId].heldToken;
5725     }
5726 
5727     function getPositionOwedToken(
5728         bytes32 positionId
5729     )
5730         external
5731         view
5732         returns (address)
5733     {
5734         return state.positions[positionId].owedToken;
5735     }
5736 
5737     function getPositionPrincipal(
5738         bytes32 positionId
5739     )
5740         external
5741         view
5742         returns (uint256)
5743     {
5744         return state.positions[positionId].principal;
5745     }
5746 
5747     function getPositionInterestRate(
5748         bytes32 positionId
5749     )
5750         external
5751         view
5752         returns (uint256)
5753     {
5754         return state.positions[positionId].interestRate;
5755     }
5756 
5757     function getPositionRequiredDeposit(
5758         bytes32 positionId
5759     )
5760         external
5761         view
5762         returns (uint256)
5763     {
5764         return state.positions[positionId].requiredDeposit;
5765     }
5766 
5767     function getPositionStartTimestamp(
5768         bytes32 positionId
5769     )
5770         external
5771         view
5772         returns (uint32)
5773     {
5774         return state.positions[positionId].startTimestamp;
5775     }
5776 
5777     function getPositionCallTimestamp(
5778         bytes32 positionId
5779     )
5780         external
5781         view
5782         returns (uint32)
5783     {
5784         return state.positions[positionId].callTimestamp;
5785     }
5786 
5787     function getPositionCallTimeLimit(
5788         bytes32 positionId
5789     )
5790         external
5791         view
5792         returns (uint32)
5793     {
5794         return state.positions[positionId].callTimeLimit;
5795     }
5796 
5797     function getPositionMaxDuration(
5798         bytes32 positionId
5799     )
5800         external
5801         view
5802         returns (uint32)
5803     {
5804         return state.positions[positionId].maxDuration;
5805     }
5806 
5807     function getPositioninterestPeriod(
5808         bytes32 positionId
5809     )
5810         external
5811         view
5812         returns (uint32)
5813     {
5814         return state.positions[positionId].interestPeriod;
5815     }
5816 }
5817 
5818 // File: contracts/margin/impl/TransferImpl.sol
5819 
5820 /**
5821  * @title TransferImpl
5822  * @author dYdX
5823  *
5824  * This library contains the implementation for the transferPosition and transferLoan functions of
5825  * Margin
5826  */
5827 library TransferImpl {
5828 
5829     // ============ Public Implementation Functions ============
5830 
5831     function transferLoanImpl(
5832         MarginState.State storage state,
5833         bytes32 positionId,
5834         address newLender
5835     )
5836         public
5837     {
5838         require(
5839             MarginCommon.containsPositionImpl(state, positionId),
5840             "TransferImpl#transferLoanImpl: Position does not exist"
5841         );
5842 
5843         address originalLender = state.positions[positionId].lender;
5844 
5845         require(
5846             msg.sender == originalLender,
5847             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
5848         );
5849         require(
5850             newLender != originalLender,
5851             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
5852         );
5853 
5854         // Doesn't change the state of positionId; figures out the final owner of loan.
5855         // That is, newLender may pass ownership to a different address.
5856         address finalLender = TransferInternal.grantLoanOwnership(
5857             positionId,
5858             originalLender,
5859             newLender);
5860 
5861         require(
5862             finalLender != originalLender,
5863             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
5864         );
5865 
5866         // Set state only after resolving the new owner (to reduce the number of storage calls)
5867         state.positions[positionId].lender = finalLender;
5868     }
5869 
5870     function transferPositionImpl(
5871         MarginState.State storage state,
5872         bytes32 positionId,
5873         address newOwner
5874     )
5875         public
5876     {
5877         require(
5878             MarginCommon.containsPositionImpl(state, positionId),
5879             "TransferImpl#transferPositionImpl: Position does not exist"
5880         );
5881 
5882         address originalOwner = state.positions[positionId].owner;
5883 
5884         require(
5885             msg.sender == originalOwner,
5886             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
5887         );
5888         require(
5889             newOwner != originalOwner,
5890             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
5891         );
5892 
5893         // Doesn't change the state of positionId; figures out the final owner of position.
5894         // That is, newOwner may pass ownership to a different address.
5895         address finalOwner = TransferInternal.grantPositionOwnership(
5896             positionId,
5897             originalOwner,
5898             newOwner);
5899 
5900         require(
5901             finalOwner != originalOwner,
5902             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
5903         );
5904 
5905         // Set state only after resolving the new owner (to reduce the number of storage calls)
5906         state.positions[positionId].owner = finalOwner;
5907     }
5908 }
5909 
5910 // File: contracts/margin/Margin.sol
5911 
5912 /**
5913  * @title Margin
5914  * @author dYdX
5915  *
5916  * This contract is used to facilitate margin trading as per the dYdX protocol
5917  */
5918 contract Margin is
5919     ReentrancyGuard,
5920     MarginStorage,
5921     MarginEvents,
5922     MarginAdmin,
5923     LoanGetters,
5924     PositionGetters
5925 {
5926 
5927     using SafeMath for uint256;
5928 
5929     // ============ Constructor ============
5930 
5931     constructor(
5932         address vault,
5933         address proxy
5934     )
5935         public
5936         MarginAdmin()
5937     {
5938         state = MarginState.State({
5939             VAULT: vault,
5940             TOKEN_PROXY: proxy
5941         });
5942     }
5943 
5944     // ============ Public State Changing Functions ============
5945 
5946     /**
5947      * Open a margin position. Called by the margin trader who must provide both a
5948      * signed loan offering as well as a DEX Order with which to sell the owedToken.
5949      *
5950      * @param  addresses           Addresses corresponding to:
5951      *
5952      *  [0]  = position owner
5953      *  [1]  = owedToken
5954      *  [2]  = heldToken
5955      *  [3]  = loan payer
5956      *  [4]  = loan owner
5957      *  [5]  = loan taker
5958      *  [6]  = loan position owner
5959      *  [7]  = loan fee recipient
5960      *  [8]  = loan lender fee token
5961      *  [9]  = loan taker fee token
5962      *  [10]  = exchange wrapper address
5963      *
5964      * @param  values256           Values corresponding to:
5965      *
5966      *  [0]  = loan maximum amount
5967      *  [1]  = loan minimum amount
5968      *  [2]  = loan minimum heldToken
5969      *  [3]  = loan lender fee
5970      *  [4]  = loan taker fee
5971      *  [5]  = loan expiration timestamp (in seconds)
5972      *  [6]  = loan salt
5973      *  [7]  = position amount of principal
5974      *  [8]  = deposit amount
5975      *  [9]  = nonce (used to calculate positionId)
5976      *
5977      * @param  values32            Values corresponding to:
5978      *
5979      *  [0] = loan call time limit (in seconds)
5980      *  [1] = loan maxDuration (in seconds)
5981      *  [2] = loan interest rate (annual nominal percentage times 10**6)
5982      *  [3] = loan interest update period (in seconds)
5983      *
5984      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
5985      *                             False if the margin deposit will be in owedToken
5986      *                             and then sold along with the owedToken borrowed from the lender
5987      * @param  signature           If loan payer is an account, then this must be the tightly-packed
5988      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
5989      *                             is a smart contract, these are arbitrary bytes that the contract
5990      *                             will recieve when choosing whether to approve the loan.
5991      * @param  order               Order object to be passed to the exchange wrapper
5992      * @return                     Unique ID for the new position
5993      */
5994     function openPosition(
5995         address[11] addresses,
5996         uint256[10] values256,
5997         uint32[4]   values32,
5998         bool        depositInHeldToken,
5999         bytes       signature,
6000         bytes       order
6001     )
6002         external
6003         onlyWhileOperational
6004         nonReentrant
6005         returns (bytes32)
6006     {
6007         return OpenPositionImpl.openPositionImpl(
6008             state,
6009             addresses,
6010             values256,
6011             values32,
6012             depositInHeldToken,
6013             signature,
6014             order
6015         );
6016     }
6017 
6018     /**
6019      * Open a margin position without a counterparty. The caller will serve as both the
6020      * lender and the position owner
6021      *
6022      * @param  addresses    Addresses corresponding to:
6023      *
6024      *  [0]  = position owner
6025      *  [1]  = owedToken
6026      *  [2]  = heldToken
6027      *  [3]  = loan owner
6028      *
6029      * @param  values256    Values corresponding to:
6030      *
6031      *  [0]  = principal
6032      *  [1]  = deposit amount
6033      *  [2]  = nonce (used to calculate positionId)
6034      *
6035      * @param  values32     Values corresponding to:
6036      *
6037      *  [0] = call time limit (in seconds)
6038      *  [1] = maxDuration (in seconds)
6039      *  [2] = interest rate (annual nominal percentage times 10**6)
6040      *  [3] = interest update period (in seconds)
6041      *
6042      * @return              Unique ID for the new position
6043      */
6044     function openWithoutCounterparty(
6045         address[4] addresses,
6046         uint256[3] values256,
6047         uint32[4]  values32
6048     )
6049         external
6050         onlyWhileOperational
6051         nonReentrant
6052         returns (bytes32)
6053     {
6054         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6055             state,
6056             addresses,
6057             values256,
6058             values32
6059         );
6060     }
6061 
6062     /**
6063      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6064      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6065      * principal added, as it will incorporate interest already earned by the position so far.
6066      *
6067      * @param  positionId          Unique ID of the position
6068      * @param  addresses           Addresses corresponding to:
6069      *
6070      *  [0]  = loan payer
6071      *  [1]  = loan taker
6072      *  [2]  = loan position owner
6073      *  [3]  = loan fee recipient
6074      *  [4]  = loan lender fee token
6075      *  [5]  = loan taker fee token
6076      *  [6]  = exchange wrapper address
6077      *
6078      * @param  values256           Values corresponding to:
6079      *
6080      *  [0]  = loan maximum amount
6081      *  [1]  = loan minimum amount
6082      *  [2]  = loan minimum heldToken
6083      *  [3]  = loan lender fee
6084      *  [4]  = loan taker fee
6085      *  [5]  = loan expiration timestamp (in seconds)
6086      *  [6]  = loan salt
6087      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6088      *                                                           will be >= this amount)
6089      *
6090      * @param  values32            Values corresponding to:
6091      *
6092      *  [0] = loan call time limit (in seconds)
6093      *  [1] = loan maxDuration (in seconds)
6094      *
6095      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6096      *                             False if the margin deposit will be pulled in owedToken
6097      *                             and then sold along with the owedToken borrowed from the lender
6098      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6099      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6100      *                             is a smart contract, these are arbitrary bytes that the contract
6101      *                             will recieve when choosing whether to approve the loan.
6102      * @param  order               Order object to be passed to the exchange wrapper
6103      * @return                     Amount of owedTokens pulled from the lender
6104      */
6105     function increasePosition(
6106         bytes32    positionId,
6107         address[7] addresses,
6108         uint256[8] values256,
6109         uint32[2]  values32,
6110         bool       depositInHeldToken,
6111         bytes      signature,
6112         bytes      order
6113     )
6114         external
6115         onlyWhileOperational
6116         nonReentrant
6117         returns (uint256)
6118     {
6119         return IncreasePositionImpl.increasePositionImpl(
6120             state,
6121             positionId,
6122             addresses,
6123             values256,
6124             values32,
6125             depositInHeldToken,
6126             signature,
6127             order
6128         );
6129     }
6130 
6131     /**
6132      * Increase a position directly by putting up heldToken. The caller will serve as both the
6133      * lender and the position owner
6134      *
6135      * @param  positionId      Unique ID of the position
6136      * @param  principalToAdd  Principal amount to add to the position
6137      * @return                 Amount of heldToken pulled from the msg.sender
6138      */
6139     function increaseWithoutCounterparty(
6140         bytes32 positionId,
6141         uint256 principalToAdd
6142     )
6143         external
6144         onlyWhileOperational
6145         nonReentrant
6146         returns (uint256)
6147     {
6148         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6149             state,
6150             positionId,
6151             principalToAdd
6152         );
6153     }
6154 
6155     /**
6156      * Close a position. May be called by the owner or with the approval of the owner. May provide
6157      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6158      * is sent the resulting payout.
6159      *
6160      * @param  positionId            Unique ID of the position
6161      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6162      *                               closed is also bounded by:
6163      *                               1) The principal of the position
6164      *                               2) The amount allowed by the owner if closer != owner
6165      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6166      * @param  exchangeWrapper       Address of the exchange wrapper
6167      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6168      *                               False to pay out the payoutRecipient in owedToken
6169      * @param  order                 Order object to be passed to the exchange wrapper
6170      * @return                       Values corresponding to:
6171      *                               1) Principal of position closed
6172      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6173      *                                  owedToken otherwise) received by the payoutRecipient
6174      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6175      */
6176     function closePosition(
6177         bytes32 positionId,
6178         uint256 requestedCloseAmount,
6179         address payoutRecipient,
6180         address exchangeWrapper,
6181         bool    payoutInHeldToken,
6182         bytes   order
6183     )
6184         external
6185         closePositionStateControl
6186         nonReentrant
6187         returns (uint256, uint256, uint256)
6188     {
6189         return ClosePositionImpl.closePositionImpl(
6190             state,
6191             positionId,
6192             requestedCloseAmount,
6193             payoutRecipient,
6194             exchangeWrapper,
6195             payoutInHeldToken,
6196             order
6197         );
6198     }
6199 
6200     /**
6201      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6202      *
6203      * @param  positionId            Unique ID of the position
6204      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6205      *                               closed is also bounded by:
6206      *                               1) The principal of the position
6207      *                               2) The amount allowed by the owner if closer != owner
6208      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6209      * @return                       Values corresponding to:
6210      *                               1) Principal amount of position closed
6211      *                               2) Amount of heldToken received by the payoutRecipient
6212      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6213      */
6214     function closePositionDirectly(
6215         bytes32 positionId,
6216         uint256 requestedCloseAmount,
6217         address payoutRecipient
6218     )
6219         external
6220         closePositionDirectlyStateControl
6221         nonReentrant
6222         returns (uint256, uint256, uint256)
6223     {
6224         return ClosePositionImpl.closePositionImpl(
6225             state,
6226             positionId,
6227             requestedCloseAmount,
6228             payoutRecipient,
6229             address(0),
6230             true,
6231             new bytes(0)
6232         );
6233     }
6234 
6235     /**
6236      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6237      * Must be approved by both the position owner and lender.
6238      *
6239      * @param  positionId            Unique ID of the position
6240      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6241      *                               closed is also bounded by:
6242      *                               1) The principal of the position
6243      *                               2) The amount allowed by the owner if closer != owner
6244      *                               3) The amount allowed by the lender if closer != lender
6245      * @return                       Values corresponding to:
6246      *                               1) Principal amount of position closed
6247      *                               2) Amount of heldToken received by the msg.sender
6248      */
6249     function closeWithoutCounterparty(
6250         bytes32 positionId,
6251         uint256 requestedCloseAmount,
6252         address payoutRecipient
6253     )
6254         external
6255         closePositionStateControl
6256         nonReentrant
6257         returns (uint256, uint256)
6258     {
6259         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6260             state,
6261             positionId,
6262             requestedCloseAmount,
6263             payoutRecipient
6264         );
6265     }
6266 
6267     /**
6268      * Margin-call a position. Only callable with the approval of the position lender. After the
6269      * call, the position owner will have time equal to the callTimeLimit of the position to close
6270      * the position. If the owner does not close the position, the lender can recover the collateral
6271      * in the position.
6272      *
6273      * @param  positionId       Unique ID of the position
6274      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6275      *                          the margin-call. Passing in 0 means the margin call cannot be
6276      *                          canceled by depositing
6277      */
6278     function marginCall(
6279         bytes32 positionId,
6280         uint256 requiredDeposit
6281     )
6282         external
6283         nonReentrant
6284     {
6285         LoanImpl.marginCallImpl(
6286             state,
6287             positionId,
6288             requiredDeposit
6289         );
6290     }
6291 
6292     /**
6293      * Cancel a margin-call. Only callable with the approval of the position lender.
6294      *
6295      * @param  positionId  Unique ID of the position
6296      */
6297     function cancelMarginCall(
6298         bytes32 positionId
6299     )
6300         external
6301         onlyWhileOperational
6302         nonReentrant
6303     {
6304         LoanImpl.cancelMarginCallImpl(state, positionId);
6305     }
6306 
6307     /**
6308      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6309      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6310      * but remains unclosed. Only callable with the approval of the position lender.
6311      *
6312      * @param  positionId  Unique ID of the position
6313      * @param  recipient   Address to send the recovered tokens to
6314      * @return             Amount of heldToken recovered
6315      */
6316     function forceRecoverCollateral(
6317         bytes32 positionId,
6318         address recipient
6319     )
6320         external
6321         nonReentrant
6322         returns (uint256)
6323     {
6324         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6325             state,
6326             positionId,
6327             recipient
6328         );
6329     }
6330 
6331     /**
6332      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6333      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6334      *
6335      * @param  positionId       Unique ID of the position
6336      * @param  depositAmount    Additional amount in heldToken to deposit
6337      */
6338     function depositCollateral(
6339         bytes32 positionId,
6340         uint256 depositAmount
6341     )
6342         external
6343         onlyWhileOperational
6344         nonReentrant
6345     {
6346         DepositCollateralImpl.depositCollateralImpl(
6347             state,
6348             positionId,
6349             depositAmount
6350         );
6351     }
6352 
6353     /**
6354      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6355      *
6356      * @param  addresses     Array of addresses:
6357      *
6358      *  [0] = owedToken
6359      *  [1] = heldToken
6360      *  [2] = loan payer
6361      *  [3] = loan owner
6362      *  [4] = loan taker
6363      *  [5] = loan position owner
6364      *  [6] = loan fee recipient
6365      *  [7] = loan lender fee token
6366      *  [8] = loan taker fee token
6367      *
6368      * @param  values256     Values corresponding to:
6369      *
6370      *  [0] = loan maximum amount
6371      *  [1] = loan minimum amount
6372      *  [2] = loan minimum heldToken
6373      *  [3] = loan lender fee
6374      *  [4] = loan taker fee
6375      *  [5] = loan expiration timestamp (in seconds)
6376      *  [6] = loan salt
6377      *
6378      * @param  values32      Values corresponding to:
6379      *
6380      *  [0] = loan call time limit (in seconds)
6381      *  [1] = loan maxDuration (in seconds)
6382      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6383      *  [3] = loan interest update period (in seconds)
6384      *
6385      * @param  cancelAmount  Amount to cancel
6386      * @return               Amount that was canceled
6387      */
6388     function cancelLoanOffering(
6389         address[9] addresses,
6390         uint256[7]  values256,
6391         uint32[4]   values32,
6392         uint256     cancelAmount
6393     )
6394         external
6395         cancelLoanOfferingStateControl
6396         nonReentrant
6397         returns (uint256)
6398     {
6399         return LoanImpl.cancelLoanOfferingImpl(
6400             state,
6401             addresses,
6402             values256,
6403             values32,
6404             cancelAmount
6405         );
6406     }
6407 
6408     /**
6409      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6410      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6411      * must implement the LoanOwner interface.
6412      *
6413      * @param  positionId  Unique ID of the position
6414      * @param  who         New owner of the loan
6415      */
6416     function transferLoan(
6417         bytes32 positionId,
6418         address who
6419     )
6420         external
6421         nonReentrant
6422     {
6423         TransferImpl.transferLoanImpl(
6424             state,
6425             positionId,
6426             who);
6427     }
6428 
6429     /**
6430      * Transfer ownership of a position to a new address. This new address will be entitled to all
6431      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6432      * the PositionOwner interface.
6433      *
6434      * @param  positionId  Unique ID of the position
6435      * @param  who         New owner of the position
6436      */
6437     function transferPosition(
6438         bytes32 positionId,
6439         address who
6440     )
6441         external
6442         nonReentrant
6443     {
6444         TransferImpl.transferPositionImpl(
6445             state,
6446             positionId,
6447             who);
6448     }
6449 
6450     // ============ Public Constant Functions ============
6451 
6452     /**
6453      * Gets the address of the Vault contract that holds and accounts for tokens.
6454      *
6455      * @return  The address of the Vault contract
6456      */
6457     function getVaultAddress()
6458         external
6459         view
6460         returns (address)
6461     {
6462         return state.VAULT;
6463     }
6464 
6465     /**
6466      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6467      * make loans or open/close positions.
6468      *
6469      * @return  The address of the TokenProxy contract
6470      */
6471     function getTokenProxyAddress()
6472         external
6473         view
6474         returns (address)
6475     {
6476         return state.TOKEN_PROXY;
6477     }
6478 }
6479 
6480 // File: contracts/margin/interfaces/OnlyMargin.sol
6481 
6482 /**
6483  * @title OnlyMargin
6484  * @author dYdX
6485  *
6486  * Contract to store the address of the main Margin contract and trust only that address to call
6487  * certain functions.
6488  */
6489 contract OnlyMargin {
6490 
6491     // ============ Constants ============
6492 
6493     // Address of the known and trusted Margin contract on the blockchain
6494     address public DYDX_MARGIN;
6495 
6496     // ============ Constructor ============
6497 
6498     constructor(
6499         address margin
6500     )
6501         public
6502     {
6503         DYDX_MARGIN = margin;
6504     }
6505 
6506     // ============ Modifiers ============
6507 
6508     modifier onlyMargin()
6509     {
6510         require(
6511             msg.sender == DYDX_MARGIN,
6512             "OnlyMargin#onlyMargin: Only Margin can call"
6513         );
6514 
6515         _;
6516     }
6517 }
6518 
6519 // File: contracts/margin/external/lib/LoanOfferingParser.sol
6520 
6521 /**
6522  * @title LoanOfferingParser
6523  * @author dYdX
6524  *
6525  * Contract for LoanOfferingVerifiers to parse arguments
6526  */
6527 contract LoanOfferingParser {
6528 
6529     // ============ Parsing Functions ============
6530 
6531     function parseLoanOffering(
6532         address[9] addresses,
6533         uint256[7] values256,
6534         uint32[4] values32,
6535         bytes signature
6536     )
6537         internal
6538         pure
6539         returns (MarginCommon.LoanOffering memory)
6540     {
6541         MarginCommon.LoanOffering memory loanOffering;
6542 
6543         fillLoanOfferingAddresses(loanOffering, addresses);
6544         fillLoanOfferingValues256(loanOffering, values256);
6545         fillLoanOfferingValues32(loanOffering, values32);
6546         loanOffering.signature = signature;
6547 
6548         return loanOffering;
6549     }
6550 
6551     function fillLoanOfferingAddresses(
6552         MarginCommon.LoanOffering memory loanOffering,
6553         address[9] addresses
6554     )
6555         private
6556         pure
6557     {
6558         loanOffering.owedToken = addresses[0];
6559         loanOffering.heldToken = addresses[1];
6560         loanOffering.payer = addresses[2];
6561         loanOffering.owner = addresses[3];
6562         loanOffering.taker = addresses[4];
6563         loanOffering.positionOwner = addresses[5];
6564         loanOffering.feeRecipient = addresses[6];
6565         loanOffering.lenderFeeToken = addresses[7];
6566         loanOffering.takerFeeToken = addresses[8];
6567     }
6568 
6569     function fillLoanOfferingValues256(
6570         MarginCommon.LoanOffering memory loanOffering,
6571         uint256[7] values256
6572     )
6573         private
6574         pure
6575     {
6576         loanOffering.rates.maxAmount = values256[0];
6577         loanOffering.rates.minAmount = values256[1];
6578         loanOffering.rates.minHeldToken = values256[2];
6579         loanOffering.rates.lenderFee = values256[3];
6580         loanOffering.rates.takerFee = values256[4];
6581         loanOffering.expirationTimestamp = values256[5];
6582         loanOffering.salt = values256[6];
6583     }
6584 
6585     function fillLoanOfferingValues32(
6586         MarginCommon.LoanOffering memory loanOffering,
6587         uint32[4] values32
6588     )
6589         private
6590         pure
6591     {
6592         loanOffering.callTimeLimit = values32[0];
6593         loanOffering.maxDuration = values32[1];
6594         loanOffering.rates.interestRate = values32[2];
6595         loanOffering.rates.interestPeriod = values32[3];
6596     }
6597 }
6598 
6599 // File: contracts/margin/external/lib/MarginHelper.sol
6600 
6601 /**
6602  * @title MarginHelper
6603  * @author dYdX
6604  *
6605  * This library contains helper functions for interacting with Margin
6606  */
6607 library MarginHelper {
6608     function getPosition(
6609         address DYDX_MARGIN,
6610         bytes32 positionId
6611     )
6612         internal
6613         view
6614         returns (MarginCommon.Position memory)
6615     {
6616         (
6617             address[4] memory addresses,
6618             uint256[2] memory values256,
6619             uint32[6]  memory values32
6620         ) = Margin(DYDX_MARGIN).getPosition(positionId);
6621 
6622         return MarginCommon.Position({
6623             owedToken: addresses[0],
6624             heldToken: addresses[1],
6625             lender: addresses[2],
6626             owner: addresses[3],
6627             principal: values256[0],
6628             requiredDeposit: values256[1],
6629             callTimeLimit: values32[0],
6630             startTimestamp: values32[1],
6631             callTimestamp: values32[2],
6632             maxDuration: values32[3],
6633             interestRate: values32[4],
6634             interestPeriod: values32[5]
6635         });
6636     }
6637 }
6638 
6639 // File: contracts/margin/external/BucketLender/BucketLender.sol
6640 
6641 /* solium-disable-next-line max-len*/
6642 
6643 /**
6644  * @title BucketLender
6645  * @author dYdX
6646  *
6647  * On-chain shared lender that allows anyone to deposit tokens into this contract to be used to
6648  * lend tokens for a particular margin position.
6649  *
6650  * - Each bucket has three variables:
6651  *   - Available Amount
6652  *     - The available amount of tokens that the bucket has to lend out
6653  *   - Outstanding Principal
6654  *     - The amount of principal that the bucket is responsible for in the margin position
6655  *   - Weight
6656  *     - Used to keep track of each account's weighted ownership within a bucket
6657  *     - Relative weight between buckets is meaningless
6658  *     - Only accounts' relative weight within a bucket matters
6659  *
6660  * - Token Deposits:
6661  *   - Go into a particular bucket, determined by time since the start of the position
6662  *     - If the position has not started: bucket = 0
6663  *     - If the position has started:     bucket = ceiling(time_since_start / BUCKET_TIME)
6664  *     - This is always the highest bucket; no higher bucket yet exists
6665  *   - Increase the bucket's Available Amount
6666  *   - Increase the bucket's weight and the account's weight in that bucket
6667  *
6668  * - Token Withdrawals:
6669  *   - Can be from any bucket with available amount
6670  *   - Decrease the bucket's Available Amount
6671  *   - Decrease the bucket's weight and the account's weight in that bucket
6672  *
6673  * - Increasing the Position (Lending):
6674  *   - The lowest buckets with Available Amount are used first
6675  *   - Decreases Available Amount
6676  *   - Increases Outstanding Principal
6677  *
6678  * - Decreasing the Position (Being Paid-Back)
6679  *   - The highest buckets with Outstanding Principal are paid back first
6680  *   - Decreases Outstanding Principal
6681  *   - Increases Available Amount
6682  *
6683  *
6684  * - Over time, this gives highest interest rates to earlier buckets, but disallows withdrawals from
6685  *   those buckets for a longer period of time.
6686  * - Deposits in the same bucket earn the same interest rate.
6687  * - Lenders can withdraw their funds at any time if they are not being lent (and are therefore not
6688  *   making the maximum interest).
6689  * - The highest bucket with Outstanding Principal is always less-than-or-equal-to the lowest bucket
6690      with Available Amount
6691  */
6692 contract BucketLender is
6693     Ownable,
6694     OnlyMargin,
6695     LoanOwner,
6696     IncreaseLoanDelegator,
6697     MarginCallDelegator,
6698     CancelMarginCallDelegator,
6699     ForceRecoverCollateralDelegator,
6700     LoanOfferingParser,
6701     LoanOfferingVerifier,
6702     ReentrancyGuard
6703 {
6704     using SafeMath for uint256;
6705     using TokenInteract for address;
6706 
6707     // ============ Events ============
6708 
6709     event Deposit(
6710         address indexed beneficiary,
6711         uint256 bucket,
6712         uint256 amount,
6713         uint256 weight
6714     );
6715 
6716     event Withdraw(
6717         address indexed withdrawer,
6718         uint256 bucket,
6719         uint256 weight,
6720         uint256 owedTokenWithdrawn,
6721         uint256 heldTokenWithdrawn
6722     );
6723 
6724     event PrincipalIncreased(
6725         uint256 principalTotal,
6726         uint256 bucketNumber,
6727         uint256 principalForBucket,
6728         uint256 amount
6729     );
6730 
6731     event PrincipalDecreased(
6732         uint256 principalTotal,
6733         uint256 bucketNumber,
6734         uint256 principalForBucket,
6735         uint256 amount
6736     );
6737 
6738     event AvailableIncreased(
6739         uint256 availableTotal,
6740         uint256 bucketNumber,
6741         uint256 availableForBucket,
6742         uint256 amount
6743     );
6744 
6745     event AvailableDecreased(
6746         uint256 availableTotal,
6747         uint256 bucketNumber,
6748         uint256 availableForBucket,
6749         uint256 amount
6750     );
6751 
6752     // ============ State Variables ============
6753 
6754     /**
6755      * Available Amount is the amount of tokens that is available to be lent by each bucket.
6756      * These tokens are also available to be withdrawn by the accounts that have weight in the
6757      * bucket.
6758      */
6759     // Available Amount for each bucket
6760     mapping(uint256 => uint256) public availableForBucket;
6761 
6762     // Total Available Amount
6763     uint256 public availableTotal;
6764 
6765     /**
6766      * Outstanding Principal is the share of the margin position's principal that each bucket
6767      * is responsible for. That is, each bucket with Outstanding Principal is owed
6768      * (Outstanding Principal)*E^(RT) owedTokens in repayment.
6769      */
6770     // Outstanding Principal for each bucket
6771     mapping(uint256 => uint256) public principalForBucket;
6772 
6773     // Total Outstanding Principal
6774     uint256 public principalTotal;
6775 
6776     /**
6777      * Weight determines an account's proportional share of a bucket. Relative weights have no
6778      * meaning if they are not for the same bucket. Likewise, the relative weight of two buckets has
6779      * no meaning. However, the relative weight of two accounts within the same bucket is equal to
6780      * the accounts' shares in the bucket and are therefore proportional to the payout that they
6781      * should expect from withdrawing from that bucket.
6782      */
6783     // Weight for each account in each bucket
6784     mapping(uint256 => mapping(address => uint256)) public weightForBucketForAccount;
6785 
6786     // Total Weight for each bucket
6787     mapping(uint256 => uint256) public weightForBucket;
6788 
6789     /**
6790      * The critical bucket is:
6791      * - Greater-than-or-equal-to The highest bucket with Outstanding Principal
6792      * - Less-than-or-equal-to the lowest bucket with Available Amount
6793      *
6794      * It is equal to both of these values in most cases except in an edge cases where the two
6795      * buckets are different. This value is cached to find such a bucket faster than looping through
6796      * all possible buckets.
6797      */
6798     uint256 public criticalBucket = 0;
6799 
6800     /**
6801      * Latest cached value for totalOwedTokenRepaidToLender.
6802      * This number updates on the dYdX Margin base protocol whenever the position is
6803      * partially-closed, but this contract is not notified at that time. Therefore, it is updated
6804      * upon increasing the position or when depositing/withdrawing
6805      */
6806     uint256 public cachedRepaidAmount = 0;
6807 
6808     // True if the position was closed from force-recovering the collateral
6809     bool public wasForceClosed = false;
6810 
6811     // ============ Constants ============
6812 
6813     // Unique ID of the position
6814     bytes32 public POSITION_ID;
6815 
6816     // Address of the token held in the position as collateral
6817     address public HELD_TOKEN;
6818 
6819     // Address of the token being lent
6820     address public OWED_TOKEN;
6821 
6822     // Time between new buckets
6823     uint32 public BUCKET_TIME;
6824 
6825     // Interest rate of the position
6826     uint32 public INTEREST_RATE;
6827 
6828     // Interest period of the position
6829     uint32 public INTEREST_PERIOD;
6830 
6831     // Maximum duration of the position
6832     uint32 public MAX_DURATION;
6833 
6834     // Margin-call time-limit of the position
6835     uint32 public CALL_TIMELIMIT;
6836 
6837     // (NUMERATOR/DENOMINATOR) denotes the minimum collateralization ratio of the position
6838     uint32 public MIN_HELD_TOKEN_NUMERATOR;
6839     uint32 public MIN_HELD_TOKEN_DENOMINATOR;
6840 
6841     // Accounts that are permitted to margin-call positions (or cancel the margin call)
6842     mapping(address => bool) public TRUSTED_MARGIN_CALLERS;
6843 
6844     // Accounts that are permitted to withdraw on behalf of any address
6845     mapping(address => bool) public TRUSTED_WITHDRAWERS;
6846 
6847     // ============ Constructor ============
6848 
6849     constructor(
6850         address margin,
6851         bytes32 positionId,
6852         address heldToken,
6853         address owedToken,
6854         uint32[7] parameters,
6855         address[] trustedMarginCallers,
6856         address[] trustedWithdrawers
6857     )
6858         public
6859         OnlyMargin(margin)
6860     {
6861         POSITION_ID = positionId;
6862         HELD_TOKEN = heldToken;
6863         OWED_TOKEN = owedToken;
6864 
6865         require(
6866             parameters[0] != 0,
6867             "BucketLender#constructor: BUCKET_TIME cannot be zero"
6868         );
6869         BUCKET_TIME = parameters[0];
6870         INTEREST_RATE = parameters[1];
6871         INTEREST_PERIOD = parameters[2];
6872         MAX_DURATION = parameters[3];
6873         CALL_TIMELIMIT = parameters[4];
6874         MIN_HELD_TOKEN_NUMERATOR = parameters[5];
6875         MIN_HELD_TOKEN_DENOMINATOR = parameters[6];
6876 
6877         // Initialize TRUSTED_MARGIN_CALLERS and TRUSTED_WITHDRAWERS
6878         uint256 i = 0;
6879         for (i = 0; i < trustedMarginCallers.length; i++) {
6880             TRUSTED_MARGIN_CALLERS[trustedMarginCallers[i]] = true;
6881         }
6882         for (i = 0; i < trustedWithdrawers.length; i++) {
6883             TRUSTED_WITHDRAWERS[trustedWithdrawers[i]] = true;
6884         }
6885 
6886         // Set maximum allowance on proxy
6887         OWED_TOKEN.approve(
6888             Margin(margin).getTokenProxyAddress(),
6889             MathHelpers.maxUint256()
6890         );
6891     }
6892 
6893     // ============ Modifiers ============
6894 
6895     modifier onlyPosition(bytes32 positionId) {
6896         require(
6897             POSITION_ID == positionId,
6898             "BucketLender#onlyPosition: Incorrect position"
6899         );
6900         _;
6901     }
6902 
6903     // ============ Margin-Only State-Changing Functions ============
6904 
6905     /**
6906      * Function a smart contract must implement to be able to consent to a loan. The loan offering
6907      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
6908      * position.
6909      *
6910      * @param  addresses    Loan offering addresses
6911      * @param  values256    Loan offering uint256s
6912      * @param  values32     Loan offering uint32s
6913      * @param  positionId   Unique ID of the position
6914      * @param  signature    Arbitrary bytes
6915      * @return              This address to accept, a different address to ask that contract
6916      */
6917     function verifyLoanOffering(
6918         address[9] addresses,
6919         uint256[7] values256,
6920         uint32[4] values32,
6921         bytes32 positionId,
6922         bytes signature
6923     )
6924         external
6925         onlyMargin
6926         nonReentrant
6927         onlyPosition(positionId)
6928         returns (address)
6929     {
6930         require(
6931             Margin(DYDX_MARGIN).containsPosition(POSITION_ID),
6932             "BucketLender#verifyLoanOffering: This contract should not open a new position"
6933         );
6934 
6935         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
6936             addresses,
6937             values256,
6938             values32,
6939             signature
6940         );
6941 
6942         // CHECK ADDRESSES
6943         assert(loanOffering.owedToken == OWED_TOKEN);
6944         assert(loanOffering.heldToken == HELD_TOKEN);
6945         assert(loanOffering.payer == address(this));
6946         assert(loanOffering.owner == address(this));
6947         require(
6948             loanOffering.taker == address(0),
6949             "BucketLender#verifyLoanOffering: loanOffering.taker is non-zero"
6950         );
6951         require(
6952             loanOffering.feeRecipient == address(0),
6953             "BucketLender#verifyLoanOffering: loanOffering.feeRecipient is non-zero"
6954         );
6955         require(
6956             loanOffering.positionOwner == address(0),
6957             "BucketLender#verifyLoanOffering: loanOffering.positionOwner is non-zero"
6958         );
6959         require(
6960             loanOffering.lenderFeeToken == address(0),
6961             "BucketLender#verifyLoanOffering: loanOffering.lenderFeeToken is non-zero"
6962         );
6963         require(
6964             loanOffering.takerFeeToken == address(0),
6965             "BucketLender#verifyLoanOffering: loanOffering.takerFeeToken is non-zero"
6966         );
6967 
6968         // CHECK VALUES256
6969         require(
6970             loanOffering.rates.maxAmount == MathHelpers.maxUint256(),
6971             "BucketLender#verifyLoanOffering: loanOffering.maxAmount is incorrect"
6972         );
6973         require(
6974             loanOffering.rates.minAmount == 0,
6975             "BucketLender#verifyLoanOffering: loanOffering.minAmount is non-zero"
6976         );
6977         require(
6978             loanOffering.rates.minHeldToken == 0,
6979             "BucketLender#verifyLoanOffering: loanOffering.minHeldToken is non-zero"
6980         );
6981         require(
6982             loanOffering.rates.lenderFee == 0,
6983             "BucketLender#verifyLoanOffering: loanOffering.lenderFee is non-zero"
6984         );
6985         require(
6986             loanOffering.rates.takerFee == 0,
6987             "BucketLender#verifyLoanOffering: loanOffering.takerFee is non-zero"
6988         );
6989         require(
6990             loanOffering.expirationTimestamp == MathHelpers.maxUint256(),
6991             "BucketLender#verifyLoanOffering: expirationTimestamp is incorrect"
6992         );
6993         require(
6994             loanOffering.salt == 0,
6995             "BucketLender#verifyLoanOffering: loanOffering.salt is non-zero"
6996         );
6997 
6998         // CHECK VALUES32
6999         require(
7000             loanOffering.callTimeLimit == MathHelpers.maxUint32(),
7001             "BucketLender#verifyLoanOffering: loanOffering.callTimelimit is incorrect"
7002         );
7003         require(
7004             loanOffering.maxDuration == MathHelpers.maxUint32(),
7005             "BucketLender#verifyLoanOffering: loanOffering.maxDuration is incorrect"
7006         );
7007         assert(loanOffering.rates.interestRate == INTEREST_RATE);
7008         assert(loanOffering.rates.interestPeriod == INTEREST_PERIOD);
7009 
7010         // no need to require anything about loanOffering.signature
7011 
7012         return address(this);
7013     }
7014 
7015     /**
7016      * Called by the Margin contract when anyone transfers ownership of a loan to this contract.
7017      * This function initializes this contract and returns this address to indicate to Margin
7018      * that it is willing to take ownership of the loan.
7019      *
7020      * @param  from        Address of the previous owner
7021      * @param  positionId  Unique ID of the position
7022      * @return             This address on success, throw otherwise
7023      */
7024     function receiveLoanOwnership(
7025         address from,
7026         bytes32 positionId
7027     )
7028         external
7029         onlyMargin
7030         nonReentrant
7031         onlyPosition(positionId)
7032         returns (address)
7033     {
7034         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
7035         uint256 initialPrincipal = position.principal;
7036         uint256 minHeldToken = MathHelpers.getPartialAmount(
7037             uint256(MIN_HELD_TOKEN_NUMERATOR),
7038             uint256(MIN_HELD_TOKEN_DENOMINATOR),
7039             initialPrincipal
7040         );
7041 
7042         assert(initialPrincipal > 0);
7043         assert(principalTotal == 0);
7044         assert(from != address(this)); // position must be opened without lending from this position
7045 
7046         require(
7047             position.owedToken == OWED_TOKEN,
7048             "BucketLender#receiveLoanOwnership: Position owedToken mismatch"
7049         );
7050         require(
7051             position.heldToken == HELD_TOKEN,
7052             "BucketLender#receiveLoanOwnership: Position heldToken mismatch"
7053         );
7054         require(
7055             position.maxDuration == MAX_DURATION,
7056             "BucketLender#receiveLoanOwnership: Position maxDuration mismatch"
7057         );
7058         require(
7059             position.callTimeLimit == CALL_TIMELIMIT,
7060             "BucketLender#receiveLoanOwnership: Position callTimeLimit mismatch"
7061         );
7062         require(
7063             position.interestRate == INTEREST_RATE,
7064             "BucketLender#receiveLoanOwnership: Position interestRate mismatch"
7065         );
7066         require(
7067             position.interestPeriod == INTEREST_PERIOD,
7068             "BucketLender#receiveLoanOwnership: Position interestPeriod mismatch"
7069         );
7070         require(
7071             Margin(DYDX_MARGIN).getPositionBalance(POSITION_ID) >= minHeldToken,
7072             "BucketLender#receiveLoanOwnership: Not enough heldToken as collateral"
7073         );
7074 
7075         // set relevant constants
7076         principalForBucket[0] = initialPrincipal;
7077         principalTotal = initialPrincipal;
7078         weightForBucket[0] = weightForBucket[0].add(initialPrincipal);
7079         weightForBucketForAccount[0][from] =
7080             weightForBucketForAccount[0][from].add(initialPrincipal);
7081 
7082         return address(this);
7083     }
7084 
7085     /**
7086      * Called by Margin when additional value is added onto the position this contract
7087      * is lending for. Balance is added to the address that loaned the additional tokens.
7088      *
7089      * @param  payer           Address that loaned the additional tokens
7090      * @param  positionId      Unique ID of the position
7091      * @param  principalAdded  Amount that was added to the position
7092      * @param  lentAmount      Amount of owedToken lent
7093      * @return                 This address to accept, a different address to ask that contract
7094      */
7095     function increaseLoanOnBehalfOf(
7096         address payer,
7097         bytes32 positionId,
7098         uint256 principalAdded,
7099         uint256 lentAmount
7100     )
7101         external
7102         onlyMargin
7103         nonReentrant
7104         onlyPosition(positionId)
7105         returns (address)
7106     {
7107         Margin margin = Margin(DYDX_MARGIN);
7108 
7109         require(
7110             payer == address(this),
7111             "BucketLender#increaseLoanOnBehalfOf: Other lenders cannot lend for this position"
7112         );
7113         require(
7114             !margin.isPositionCalled(POSITION_ID),
7115             "BucketLender#increaseLoanOnBehalfOf: No lending while the position is margin-called"
7116         );
7117 
7118         // This function is only called after the state has been updated in the base protocol;
7119         // thus, the principal in the base protocol will equal the principal after the increase
7120         uint256 principalAfterIncrease = margin.getPositionPrincipal(POSITION_ID);
7121         uint256 principalBeforeIncrease = principalAfterIncrease.sub(principalAdded);
7122 
7123         // principalTotal was the principal after the previous increase
7124         accountForClose(principalTotal.sub(principalBeforeIncrease));
7125 
7126         accountForIncrease(principalAdded, lentAmount);
7127 
7128         assert(principalTotal == principalAfterIncrease);
7129 
7130         return address(this);
7131     }
7132 
7133     /**
7134      * Function a contract must implement in order to let other addresses call marginCall().
7135      *
7136      * @param  caller         Address of the caller of the marginCall function
7137      * @param  positionId     Unique ID of the position
7138      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
7139      * @return                This address to accept, a different address to ask that contract
7140      */
7141     function marginCallOnBehalfOf(
7142         address caller,
7143         bytes32 positionId,
7144         uint256 depositAmount
7145     )
7146         external
7147         onlyMargin
7148         nonReentrant
7149         onlyPosition(positionId)
7150         returns (address)
7151     {
7152         require(
7153             TRUSTED_MARGIN_CALLERS[caller],
7154             "BucketLender#marginCallOnBehalfOf: Margin-caller must be trusted"
7155         );
7156         require(
7157             depositAmount == 0, // prevents depositing from canceling the margin-call
7158             "BucketLender#marginCallOnBehalfOf: Deposit amount must be zero"
7159         );
7160 
7161         return address(this);
7162     }
7163 
7164     /**
7165      * Function a contract must implement in order to let other addresses call cancelMarginCall().
7166      *
7167      * @param  canceler    Address of the caller of the cancelMarginCall function
7168      * @param  positionId  Unique ID of the position
7169      * @return             This address to accept, a different address to ask that contract
7170      */
7171     function cancelMarginCallOnBehalfOf(
7172         address canceler,
7173         bytes32 positionId
7174     )
7175         external
7176         onlyMargin
7177         nonReentrant
7178         onlyPosition(positionId)
7179         returns (address)
7180     {
7181         require(
7182             TRUSTED_MARGIN_CALLERS[canceler],
7183             "BucketLender#cancelMarginCallOnBehalfOf: Margin-call-canceler must be trusted"
7184         );
7185 
7186         return address(this);
7187     }
7188 
7189     /**
7190      * Function a contract must implement in order to let other addresses call
7191      * forceRecoverCollateral().
7192      *
7193      *  param  recoverer   Address of the caller of the forceRecoverCollateral() function
7194      * @param  positionId  Unique ID of the position
7195      * @param  recipient   Address to send the recovered tokens to
7196      * @return             This address to accept, a different address to ask that contract
7197      */
7198     function forceRecoverCollateralOnBehalfOf(
7199         address /* recoverer */,
7200         bytes32 positionId,
7201         address recipient
7202     )
7203         external
7204         onlyMargin
7205         nonReentrant
7206         onlyPosition(positionId)
7207         returns (address)
7208     {
7209         return forceRecoverCollateralInternal(recipient);
7210     }
7211 
7212     // ============ Public State-Changing Functions ============
7213 
7214     /**
7215      * Allow anyone to recalculate the Outstanding Principal and Available Amount for the buckets if
7216      * part of the position has been closed since the last position increase.
7217      */
7218     function rebalanceBuckets()
7219         external
7220         nonReentrant
7221     {
7222         rebalanceBucketsInternal();
7223     }
7224 
7225     /**
7226      * Allows users to deposit owedToken into this contract. Allowance must be set on this contract
7227      * for "token" in at least the amount "amount".
7228      *
7229      * @param  beneficiary  The account that will be entitled to this depoit
7230      * @param  amount       The amount of owedToken to deposit
7231      * @return              The bucket number that was deposited into
7232      */
7233     function deposit(
7234         address beneficiary,
7235         uint256 amount
7236     )
7237         external
7238         nonReentrant
7239         returns (uint256)
7240     {
7241         Margin margin = Margin(DYDX_MARGIN);
7242         bytes32 positionId = POSITION_ID;
7243 
7244         require(
7245             beneficiary != address(0),
7246             "BucketLender#deposit: Beneficiary cannot be the zero address"
7247         );
7248         require(
7249             amount != 0,
7250             "BucketLender#deposit: Cannot deposit zero tokens"
7251         );
7252         require(
7253             !margin.isPositionClosed(positionId),
7254             "BucketLender#deposit: Cannot deposit after the position is closed"
7255         );
7256         require(
7257             !margin.isPositionCalled(positionId),
7258             "BucketLender#deposit: Cannot deposit while the position is margin-called"
7259         );
7260 
7261         rebalanceBucketsInternal();
7262 
7263         OWED_TOKEN.transferFrom(
7264             msg.sender,
7265             address(this),
7266             amount
7267         );
7268 
7269         uint256 bucket = getCurrentBucket();
7270 
7271         uint256 effectiveAmount = availableForBucket[bucket].add(getBucketOwedAmount(bucket));
7272 
7273         uint256 weightToAdd = 0;
7274         if (effectiveAmount == 0) {
7275             weightToAdd = amount; // first deposit in bucket
7276         } else {
7277             weightToAdd = MathHelpers.getPartialAmount(
7278                 amount,
7279                 effectiveAmount,
7280                 weightForBucket[bucket]
7281             );
7282         }
7283 
7284         require(
7285             weightToAdd != 0,
7286             "BucketLender#deposit: Cannot deposit for zero weight"
7287         );
7288 
7289         // update state
7290         updateAvailable(bucket, amount, true);
7291         weightForBucketForAccount[bucket][beneficiary] =
7292             weightForBucketForAccount[bucket][beneficiary].add(weightToAdd);
7293         weightForBucket[bucket] = weightForBucket[bucket].add(weightToAdd);
7294 
7295         emit Deposit(
7296             beneficiary,
7297             bucket,
7298             amount,
7299             weightToAdd
7300         );
7301 
7302         return bucket;
7303     }
7304 
7305     /**
7306      * Allows users to withdraw their lent funds. An account can withdraw its weighted share of the
7307      * bucket.
7308      *
7309      * While the position is open, a bucket's share is equal to:
7310      *   Owed Token: (Available Amount) + (Outstanding Principal) * (1 + interest)
7311      *   Held Token: 0
7312      *
7313      * After the position is closed, a bucket's share is equal to:
7314      *   Owed Token: (Available Amount)
7315      *   Held Token: (Held Token Balance) * (Outstanding Principal) / (Total Outstanding Principal)
7316      *
7317      * @param  buckets      The bucket numbers to withdraw from
7318      * @param  maxWeights   The maximum weight to withdraw from each bucket. The amount of tokens
7319      *                      withdrawn will be at least this amount, but not necessarily more.
7320      *                      Withdrawing the same weight from different buckets does not necessarily
7321      *                      return the same amounts from those buckets. In order to withdraw as many
7322      *                      tokens as possible, use the maximum uint256.
7323      * @param  onBehalfOf   The address to withdraw on behalf of
7324      * @return              1) The number of owedTokens withdrawn
7325      *                      2) The number of heldTokens withdrawn
7326      */
7327     function withdraw(
7328         uint256[] buckets,
7329         uint256[] maxWeights,
7330         address onBehalfOf
7331     )
7332         external
7333         nonReentrant
7334         returns (uint256, uint256)
7335     {
7336         require(
7337             buckets.length == maxWeights.length,
7338             "BucketLender#withdraw: The lengths of the input arrays must match"
7339         );
7340         if (onBehalfOf != msg.sender) {
7341             require(
7342                 TRUSTED_WITHDRAWERS[msg.sender],
7343                 "BucketLender#withdraw: Only trusted withdrawers can withdraw on behalf of others"
7344             );
7345         }
7346 
7347         rebalanceBucketsInternal();
7348 
7349         // decide if some bucket is unable to be withdrawn from (is locked)
7350         // the zero value represents no-lock
7351         uint256 lockedBucket = 0;
7352         if (
7353             Margin(DYDX_MARGIN).containsPosition(POSITION_ID) &&
7354             criticalBucket == getCurrentBucket()
7355         ) {
7356             lockedBucket = criticalBucket;
7357         }
7358 
7359         uint256[2] memory results; // [0] = totalOwedToken, [1] = totalHeldToken
7360 
7361         uint256 maxHeldToken = 0;
7362         if (wasForceClosed) {
7363             maxHeldToken = HELD_TOKEN.balanceOf(address(this));
7364         }
7365 
7366         for (uint256 i = 0; i < buckets.length; i++) {
7367             uint256 bucket = buckets[i];
7368 
7369             // prevent withdrawing from the current bucket if it is also the critical bucket
7370             if ((bucket != 0) && (bucket == lockedBucket)) {
7371                 continue;
7372             }
7373 
7374             (uint256 owedTokenForBucket, uint256 heldTokenForBucket) = withdrawSingleBucket(
7375                 onBehalfOf,
7376                 bucket,
7377                 maxWeights[i],
7378                 maxHeldToken
7379             );
7380 
7381             results[0] = results[0].add(owedTokenForBucket);
7382             results[1] = results[1].add(heldTokenForBucket);
7383         }
7384 
7385         // Transfer share of owedToken
7386         OWED_TOKEN.transfer(msg.sender, results[0]);
7387         HELD_TOKEN.transfer(msg.sender, results[1]);
7388 
7389         return (results[0], results[1]);
7390     }
7391 
7392     /**
7393      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
7394      * including (but not limited-to) token airdrops. Any tokens moved to this contract by calling
7395      * deposit() will be accounted for and will not be withdrawable by this function.
7396      *
7397      * @param  token  ERC20 token address
7398      * @param  to     Address to transfer tokens to
7399      * @return        Amount of tokens withdrawn
7400      */
7401     function withdrawExcessToken(
7402         address token,
7403         address to
7404     )
7405         external
7406         onlyOwner
7407         returns (uint256)
7408     {
7409         rebalanceBucketsInternal();
7410 
7411         uint256 amount = token.balanceOf(address(this));
7412 
7413         if (token == OWED_TOKEN) {
7414             amount = amount.sub(availableTotal);
7415         } else if (token == HELD_TOKEN) {
7416             require(
7417                 !wasForceClosed,
7418                 "BucketLender#withdrawExcessToken: heldToken cannot be withdrawn if force-closed"
7419             );
7420         }
7421 
7422         token.transfer(to, amount);
7423         return amount;
7424     }
7425 
7426     // ============ Public Getter Functions ============
7427 
7428     /**
7429      * Get the current bucket number that funds will be deposited into. This is also the highest
7430      * bucket so far.
7431      *
7432      * @return The highest bucket and the one that funds will be deposited into
7433      */
7434     function getCurrentBucket()
7435         public
7436         view
7437         returns (uint256)
7438     {
7439         // load variables from storage;
7440         Margin margin = Margin(DYDX_MARGIN);
7441         bytes32 positionId = POSITION_ID;
7442         uint32 bucketTime = BUCKET_TIME;
7443 
7444         assert(!margin.isPositionClosed(positionId));
7445 
7446         // if position not created, allow deposits in the first bucket
7447         if (!margin.containsPosition(positionId)) {
7448             return 0;
7449         }
7450 
7451         // return the number of BUCKET_TIME periods elapsed since the position start, rounded-up
7452         uint256 startTimestamp = margin.getPositionStartTimestamp(positionId);
7453         return block.timestamp.sub(startTimestamp).div(bucketTime).add(1);
7454     }
7455 
7456     /**
7457      * Gets the outstanding amount of owedToken owed to a bucket. This is the principal amount of
7458      * the bucket multiplied by the interest accrued in the position. If the position is closed,
7459      * then any outstanding principal will never be repaid in the form of owedToken.
7460      *
7461      * @param  bucket  The bucket number
7462      * @return         The amount of owedToken that this bucket expects to be paid-back if the posi
7463      */
7464     function getBucketOwedAmount(
7465         uint256 bucket
7466     )
7467         public
7468         view
7469         returns (uint256)
7470     {
7471         // if the position is completely closed, then the outstanding principal will never be repaid
7472         if (Margin(DYDX_MARGIN).isPositionClosed(POSITION_ID)) {
7473             return 0;
7474         }
7475 
7476         uint256 lentPrincipal = principalForBucket[bucket];
7477 
7478         // the bucket has no outstanding principal
7479         if (lentPrincipal == 0) {
7480             return 0;
7481         }
7482 
7483         // get the total amount of owedToken that would be paid back at this time
7484         uint256 owedAmount = Margin(DYDX_MARGIN).getPositionOwedAmountAtTime(
7485             POSITION_ID,
7486             principalTotal,
7487             uint32(block.timestamp)
7488         );
7489 
7490         // return the bucket's share
7491         return MathHelpers.getPartialAmount(
7492             lentPrincipal,
7493             principalTotal,
7494             owedAmount
7495         );
7496     }
7497 
7498     // ============ Internal Functions ============
7499 
7500     function forceRecoverCollateralInternal(
7501         address recipient
7502     )
7503         internal
7504         returns (address)
7505     {
7506         require(
7507             recipient == address(this),
7508             "BucketLender#forceRecoverCollateralOnBehalfOf: Recipient must be this contract"
7509         );
7510 
7511         rebalanceBucketsInternal();
7512 
7513         wasForceClosed = true;
7514 
7515         return address(this);
7516     }
7517 
7518     // ============ Private Helper Functions ============
7519 
7520     /**
7521      * Recalculates the Outstanding Principal and Available Amount for the buckets. Only changes the
7522      * state if part of the position has been closed since the last position increase.
7523      */
7524     function rebalanceBucketsInternal()
7525         private
7526     {
7527         // if force-closed, don't update the outstanding principal values; they are needed to repay
7528         // lenders with heldToken
7529         if (wasForceClosed) {
7530             return;
7531         }
7532 
7533         uint256 marginPrincipal = Margin(DYDX_MARGIN).getPositionPrincipal(POSITION_ID);
7534 
7535         accountForClose(principalTotal.sub(marginPrincipal));
7536 
7537         assert(principalTotal == marginPrincipal);
7538     }
7539 
7540     /**
7541      * Updates the state variables at any time. Only does anything after the position has been
7542      * closed or partially-closed since the last time this function was called.
7543      *
7544      * - Increases the available amount in the highest buckets with outstanding principal
7545      * - Decreases the principal amount in those buckets
7546      *
7547      * @param  principalRemoved  Amount of principal closed since the last update
7548      */
7549     function accountForClose(
7550         uint256 principalRemoved
7551     )
7552         private
7553     {
7554         if (principalRemoved == 0) {
7555             return;
7556         }
7557 
7558         uint256 newRepaidAmount = Margin(DYDX_MARGIN).getTotalOwedTokenRepaidToLender(POSITION_ID);
7559         assert(newRepaidAmount.sub(cachedRepaidAmount) >= principalRemoved);
7560 
7561         uint256 principalToSub = principalRemoved;
7562         uint256 availableToAdd = newRepaidAmount.sub(cachedRepaidAmount);
7563         uint256 criticalBucketTemp = criticalBucket;
7564 
7565         // loop over buckets in reverse order starting with the critical bucket
7566         for (
7567             uint256 bucket = criticalBucketTemp;
7568             principalToSub > 0;
7569             bucket--
7570         ) {
7571             assert(bucket <= criticalBucketTemp); // no underflow on bucket
7572 
7573             uint256 principalTemp = Math.min256(principalToSub, principalForBucket[bucket]);
7574             if (principalTemp == 0) {
7575                 continue;
7576             }
7577             uint256 availableTemp = MathHelpers.getPartialAmount(
7578                 principalTemp,
7579                 principalToSub,
7580                 availableToAdd
7581             );
7582 
7583             updateAvailable(bucket, availableTemp, true);
7584             updatePrincipal(bucket, principalTemp, false);
7585 
7586             principalToSub = principalToSub.sub(principalTemp);
7587             availableToAdd = availableToAdd.sub(availableTemp);
7588 
7589             criticalBucketTemp = bucket;
7590         }
7591 
7592         assert(principalToSub == 0);
7593         assert(availableToAdd == 0);
7594 
7595         setCriticalBucket(criticalBucketTemp);
7596 
7597         cachedRepaidAmount = newRepaidAmount;
7598     }
7599 
7600     /**
7601      * Updates the state variables when a position is increased.
7602      *
7603      * - Decreases the available amount in the lowest buckets with available token
7604      * - Increases the principal amount in those buckets
7605      *
7606      * @param  principalAdded  Amount of principal added to the position
7607      * @param  lentAmount      Amount of owedToken lent
7608      */
7609     function accountForIncrease(
7610         uint256 principalAdded,
7611         uint256 lentAmount
7612     )
7613         private
7614     {
7615         require(
7616             lentAmount <= availableTotal,
7617             "BucketLender#accountForIncrease: No lending not-accounted-for funds"
7618         );
7619 
7620         uint256 principalToAdd = principalAdded;
7621         uint256 availableToSub = lentAmount;
7622         uint256 criticalBucketTemp;
7623 
7624         // loop over buckets in order starting from the critical bucket
7625         uint256 lastBucket = getCurrentBucket();
7626         for (
7627             uint256 bucket = criticalBucket;
7628             principalToAdd > 0;
7629             bucket++
7630         ) {
7631             assert(bucket <= lastBucket); // should never go past the last bucket
7632 
7633             uint256 availableTemp = Math.min256(availableToSub, availableForBucket[bucket]);
7634             if (availableTemp == 0) {
7635                 continue;
7636             }
7637             uint256 principalTemp = MathHelpers.getPartialAmount(
7638                 availableTemp,
7639                 availableToSub,
7640                 principalToAdd
7641             );
7642 
7643             updateAvailable(bucket, availableTemp, false);
7644             updatePrincipal(bucket, principalTemp, true);
7645 
7646             principalToAdd = principalToAdd.sub(principalTemp);
7647             availableToSub = availableToSub.sub(availableTemp);
7648 
7649             criticalBucketTemp = bucket;
7650         }
7651 
7652         assert(principalToAdd == 0);
7653         assert(availableToSub == 0);
7654 
7655         setCriticalBucket(criticalBucketTemp);
7656     }
7657 
7658     /**
7659      * Withdraw
7660      *
7661      * @param  onBehalfOf    The account for which to withdraw for
7662      * @param  bucket        The bucket number to withdraw from
7663      * @param  maxWeight     The maximum weight to withdraw
7664      * @param  maxHeldToken  The total amount of heldToken that has been force-recovered
7665      * @return               1) The number of owedTokens withdrawn
7666      *                       2) The number of heldTokens withdrawn
7667      */
7668     function withdrawSingleBucket(
7669         address onBehalfOf,
7670         uint256 bucket,
7671         uint256 maxWeight,
7672         uint256 maxHeldToken
7673     )
7674         private
7675         returns (uint256, uint256)
7676     {
7677         // calculate the user's share
7678         uint256 bucketWeight = weightForBucket[bucket];
7679         if (bucketWeight == 0) {
7680             return (0, 0);
7681         }
7682 
7683         uint256 userWeight = weightForBucketForAccount[bucket][onBehalfOf];
7684         uint256 weightToWithdraw = Math.min256(maxWeight, userWeight);
7685         if (weightToWithdraw == 0) {
7686             return (0, 0);
7687         }
7688 
7689         // update state
7690         weightForBucket[bucket] = weightForBucket[bucket].sub(weightToWithdraw);
7691         weightForBucketForAccount[bucket][onBehalfOf] = userWeight.sub(weightToWithdraw);
7692 
7693         // calculate for owedToken
7694         uint256 owedTokenToWithdraw = withdrawOwedToken(
7695             bucket,
7696             weightToWithdraw,
7697             bucketWeight
7698         );
7699 
7700         // calculate for heldToken
7701         uint256 heldTokenToWithdraw = withdrawHeldToken(
7702             bucket,
7703             weightToWithdraw,
7704             bucketWeight,
7705             maxHeldToken
7706         );
7707 
7708         emit Withdraw(
7709             onBehalfOf,
7710             bucket,
7711             weightToWithdraw,
7712             owedTokenToWithdraw,
7713             heldTokenToWithdraw
7714         );
7715 
7716         return (owedTokenToWithdraw, heldTokenToWithdraw);
7717     }
7718 
7719     /**
7720      * Helper function to withdraw earned owedToken from this contract.
7721      *
7722      * @param  bucket        The bucket number to withdraw from
7723      * @param  userWeight    The amount of weight the user is using to withdraw
7724      * @param  bucketWeight  The total weight of the bucket
7725      * @return               The amount of owedToken being withdrawn
7726      */
7727     function withdrawOwedToken(
7728         uint256 bucket,
7729         uint256 userWeight,
7730         uint256 bucketWeight
7731     )
7732         private
7733         returns (uint256)
7734     {
7735         // amount to return for the bucket
7736         uint256 owedTokenToWithdraw = MathHelpers.getPartialAmount(
7737             userWeight,
7738             bucketWeight,
7739             availableForBucket[bucket].add(getBucketOwedAmount(bucket))
7740         );
7741 
7742         // check that there is enough token to give back
7743         require(
7744             owedTokenToWithdraw <= availableForBucket[bucket],
7745             "BucketLender#withdrawOwedToken: There must be enough available owedToken"
7746         );
7747 
7748         // update amounts
7749         updateAvailable(bucket, owedTokenToWithdraw, false);
7750 
7751         return owedTokenToWithdraw;
7752     }
7753 
7754     /**
7755      * Helper function to withdraw heldToken from this contract.
7756      *
7757      * @param  bucket        The bucket number to withdraw from
7758      * @param  userWeight    The amount of weight the user is using to withdraw
7759      * @param  bucketWeight  The total weight of the bucket
7760      * @param  maxHeldToken  The total amount of heldToken available to withdraw
7761      * @return               The amount of heldToken being withdrawn
7762      */
7763     function withdrawHeldToken(
7764         uint256 bucket,
7765         uint256 userWeight,
7766         uint256 bucketWeight,
7767         uint256 maxHeldToken
7768     )
7769         private
7770         returns (uint256)
7771     {
7772         if (maxHeldToken == 0) {
7773             return 0;
7774         }
7775 
7776         // user's principal for the bucket
7777         uint256 principalForBucketForAccount = MathHelpers.getPartialAmount(
7778             userWeight,
7779             bucketWeight,
7780             principalForBucket[bucket]
7781         );
7782 
7783         uint256 heldTokenToWithdraw = MathHelpers.getPartialAmount(
7784             principalForBucketForAccount,
7785             principalTotal,
7786             maxHeldToken
7787         );
7788 
7789         updatePrincipal(bucket, principalForBucketForAccount, false);
7790 
7791         return heldTokenToWithdraw;
7792     }
7793 
7794     // ============ Setter Functions ============
7795 
7796     /**
7797      * Changes the critical bucket variable
7798      *
7799      * @param  bucket  The value to set criticalBucket to
7800      */
7801     function setCriticalBucket(
7802         uint256 bucket
7803     )
7804         private
7805     {
7806         // don't spend the gas to sstore unless we need to change the value
7807         if (criticalBucket == bucket) {
7808             return;
7809         }
7810 
7811         criticalBucket = bucket;
7812     }
7813 
7814     /**
7815      * Changes the available owedToken amount. This changes both the variable to track the total
7816      * amount as well as the variable to track a particular bucket.
7817      *
7818      * @param  bucket    The bucket number
7819      * @param  amount    The amount to change the available amount by
7820      * @param  increase  True if positive change, false if negative change
7821      */
7822     function updateAvailable(
7823         uint256 bucket,
7824         uint256 amount,
7825         bool increase
7826     )
7827         private
7828     {
7829         if (amount == 0) {
7830             return;
7831         }
7832 
7833         uint256 newTotal;
7834         uint256 newForBucket;
7835 
7836         if (increase) {
7837             newTotal = availableTotal.add(amount);
7838             newForBucket = availableForBucket[bucket].add(amount);
7839             emit AvailableIncreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7840         } else {
7841             newTotal = availableTotal.sub(amount);
7842             newForBucket = availableForBucket[bucket].sub(amount);
7843             emit AvailableDecreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7844         }
7845 
7846         availableTotal = newTotal;
7847         availableForBucket[bucket] = newForBucket;
7848     }
7849 
7850     /**
7851      * Changes the principal amount. This changes both the variable to track the total
7852      * amount as well as the variable to track a particular bucket.
7853      *
7854      * @param  bucket    The bucket number
7855      * @param  amount    The amount to change the principal amount by
7856      * @param  increase  True if positive change, false if negative change
7857      */
7858     function updatePrincipal(
7859         uint256 bucket,
7860         uint256 amount,
7861         bool increase
7862     )
7863         private
7864     {
7865         if (amount == 0) {
7866             return;
7867         }
7868 
7869         uint256 newTotal;
7870         uint256 newForBucket;
7871 
7872         if (increase) {
7873             newTotal = principalTotal.add(amount);
7874             newForBucket = principalForBucket[bucket].add(amount);
7875             emit PrincipalIncreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7876         } else {
7877             newTotal = principalTotal.sub(amount);
7878             newForBucket = principalForBucket[bucket].sub(amount);
7879             emit PrincipalDecreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7880         }
7881 
7882         principalTotal = newTotal;
7883         principalForBucket[bucket] = newForBucket;
7884     }
7885 }
7886 
7887 // File: contracts/margin/external/BucketLender/BucketLenderWithRecoveryDelay.sol
7888 
7889 /**
7890  * @title BucketLenderWithRecoveryDelay
7891  * @author dYdX
7892  *
7893  * Extension of BucketLender that delays the force-recovery time
7894  */
7895 contract BucketLenderWithRecoveryDelay is BucketLender
7896 {
7897     // ============ State Variables ============
7898 
7899     // number of seconds after position has closed that must be waited before force-recovering
7900     uint256 public RECOVERY_DELAY;
7901 
7902     // ============ Constructor ============
7903 
7904     constructor(
7905         address margin,
7906         bytes32 positionId,
7907         address heldToken,
7908         address owedToken,
7909         uint32[7] parameters,
7910         address[] trustedMarginCallers,
7911         address[] trustedWithdrawers,
7912         uint256 recoveryDelay
7913     )
7914         public
7915         BucketLender(
7916             margin,
7917             positionId,
7918             heldToken,
7919             owedToken,
7920             parameters,
7921             trustedMarginCallers,
7922             trustedWithdrawers
7923         )
7924     {
7925         RECOVERY_DELAY = recoveryDelay;
7926     }
7927 
7928     // ============ Margin-Only State-Changing Functions ============
7929 
7930     // Overrides the function in BucketLender
7931     function forceRecoverCollateralOnBehalfOf(
7932         address /* recoverer */,
7933         bytes32 positionId,
7934         address recipient
7935     )
7936         external
7937         onlyMargin
7938         nonReentrant
7939         onlyPosition(positionId)
7940         returns (address)
7941     {
7942         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, positionId);
7943         uint256 positionEnd = uint256(position.startTimestamp).add(position.maxDuration);
7944         if (position.callTimestamp > 0) {
7945             uint256 marginCallEnd = uint256(position.callTimestamp).add(position.callTimeLimit);
7946             positionEnd = Math.min256(positionEnd, marginCallEnd);
7947         }
7948 
7949         require (
7950             block.timestamp >= positionEnd.add(RECOVERY_DELAY),
7951             "BucketLenderWithRecoveryDelay#forceRecoverCollateralOnBehalfOf: Recovery too early"
7952         );
7953 
7954         return forceRecoverCollateralInternal(recipient);
7955     }
7956 }