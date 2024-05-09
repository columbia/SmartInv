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
22 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
34     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
35     // benefit is lost if 'b' is also tested.
36     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37     if (_a == 0) {
38       return 0;
39     }
40 
41     c = _a * _b;
42     assert(c / _a == _b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     // assert(_b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = _a / _b;
52     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
53     return _a / _b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     assert(_b <= _a);
61     return _a - _b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
68     c = _a + _b;
69     assert(c >= _a);
70     return c;
71   }
72 }
73 
74 // File: openzeppelin-solidity/contracts/math/Math.sol
75 
76 /**
77  * @title Math
78  * @dev Assorted math operations
79  */
80 library Math {
81   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
82     return _a >= _b ? _a : _b;
83   }
84 
85   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
86     return _a < _b ? _a : _b;
87   }
88 
89   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
90     return _a >= _b ? _a : _b;
91   }
92 
93   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
94     return _a < _b ? _a : _b;
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
3037 /**
3038  * @title ForceRecoverCollateralImpl
3039  * @author dYdX
3040  *
3041  * This library contains the implementation for the forceRecoverCollateral function of Margin
3042  */
3043 library ForceRecoverCollateralImpl {
3044     using SafeMath for uint256;
3045 
3046     // ============ Events ============
3047 
3048     /**
3049      * Collateral for a position was forcibly recovered
3050      */
3051     event CollateralForceRecovered(
3052         bytes32 indexed positionId,
3053         address indexed recipient,
3054         uint256 amount
3055     );
3056 
3057     // ============ Public Implementation Functions ============
3058 
3059     function forceRecoverCollateralImpl(
3060         MarginState.State storage state,
3061         bytes32 positionId,
3062         address recipient
3063     )
3064         public
3065         returns (uint256)
3066     {
3067         MarginCommon.Position storage position =
3068             MarginCommon.getPositionFromStorage(state, positionId);
3069 
3070         // Can only force recover after either:
3071         // 1) The loan was called and the call period has elapsed
3072         // 2) The maxDuration of the position has elapsed
3073         require( /* solium-disable-next-line */
3074             (
3075                 position.callTimestamp > 0
3076                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3077             ) || (
3078                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3079             ),
3080             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3081         );
3082 
3083         // Ensure lender consent
3084         forceRecoverCollateralOnBehalfOfRecurse(
3085             position.lender,
3086             msg.sender,
3087             positionId,
3088             recipient
3089         );
3090 
3091         // Send the tokens
3092         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3093         Vault(state.VAULT).transferFromVault(
3094             positionId,
3095             position.heldToken,
3096             recipient,
3097             heldTokenRecovered
3098         );
3099 
3100         // Delete the position
3101         // NOTE: Since position is a storage pointer, this will also set all fields on
3102         //       the position variable to 0
3103         MarginCommon.cleanupPosition(
3104             state,
3105             positionId
3106         );
3107 
3108         // Log an event
3109         emit CollateralForceRecovered(
3110             positionId,
3111             recipient,
3112             heldTokenRecovered
3113         );
3114 
3115         return heldTokenRecovered;
3116     }
3117 
3118     // ============ Private Helper-Functions ============
3119 
3120     function forceRecoverCollateralOnBehalfOfRecurse(
3121         address contractAddr,
3122         address recoverer,
3123         bytes32 positionId,
3124         address recipient
3125     )
3126         private
3127     {
3128         // no need to ask for permission
3129         if (recoverer == contractAddr) {
3130             return;
3131         }
3132 
3133         address newContractAddr =
3134             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3135                 recoverer,
3136                 positionId,
3137                 recipient
3138             );
3139 
3140         if (newContractAddr != contractAddr) {
3141             forceRecoverCollateralOnBehalfOfRecurse(
3142                 newContractAddr,
3143                 recoverer,
3144                 positionId,
3145                 recipient
3146             );
3147         }
3148     }
3149 }
3150 
3151 // File: contracts/lib/TypedSignature.sol
3152 
3153 /**
3154  * @title TypedSignature
3155  * @author dYdX
3156  *
3157  * Allows for ecrecovery of signed hashes with three different prepended messages:
3158  * 1) ""
3159  * 2) "\x19Ethereum Signed Message:\n32"
3160  * 3) "\x19Ethereum Signed Message:\n\x20"
3161  */
3162 library TypedSignature {
3163 
3164     // Solidity does not offer guarantees about enum values, so we define them explicitly
3165     uint8 private constant SIGTYPE_INVALID = 0;
3166     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3167     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3168     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3169 
3170     // prepended message with the length of the signed hash in hexadecimal
3171     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3172 
3173     // prepended message with the length of the signed hash in decimal
3174     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3175 
3176     /**
3177      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3178      *
3179      * @param  hash               Hash that was signed (does not include prepended message)
3180      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3181      * @return                    address of the signer of the hash
3182      */
3183     function recover(
3184         bytes32 hash,
3185         bytes signatureWithType
3186     )
3187         internal
3188         pure
3189         returns (address)
3190     {
3191         require(
3192             signatureWithType.length == 66,
3193             "SignatureValidator#validateSignature: invalid signature length"
3194         );
3195 
3196         uint8 sigType = uint8(signatureWithType[0]);
3197 
3198         require(
3199             sigType > uint8(SIGTYPE_INVALID),
3200             "SignatureValidator#validateSignature: invalid signature type"
3201         );
3202         require(
3203             sigType < uint8(SIGTYPE_UNSUPPORTED),
3204             "SignatureValidator#validateSignature: unsupported signature type"
3205         );
3206 
3207         uint8 v = uint8(signatureWithType[1]);
3208         bytes32 r;
3209         bytes32 s;
3210 
3211         /* solium-disable-next-line security/no-inline-assembly */
3212         assembly {
3213             r := mload(add(signatureWithType, 34))
3214             s := mload(add(signatureWithType, 66))
3215         }
3216 
3217         bytes32 signedHash;
3218         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3219             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3220         } else {
3221             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3222             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3223         }
3224 
3225         return ecrecover(
3226             signedHash,
3227             v,
3228             r,
3229             s
3230         );
3231     }
3232 }
3233 
3234 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3235 
3236 /**
3237  * @title LoanOfferingVerifier
3238  * @author dYdX
3239  *
3240  * Interface that smart contracts must implement to be able to make off-chain generated
3241  * loan offerings.
3242  *
3243  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3244  *       to these functions
3245  */
3246 interface LoanOfferingVerifier {
3247 
3248     /**
3249      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3250      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3251      * position.
3252      *
3253      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3254      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3255      * state on a loan.
3256      *
3257      * @param  addresses    Array of addresses:
3258      *
3259      *  [0] = owedToken
3260      *  [1] = heldToken
3261      *  [2] = loan payer
3262      *  [3] = loan owner
3263      *  [4] = loan taker
3264      *  [5] = loan positionOwner
3265      *  [6] = loan fee recipient
3266      *  [7] = loan lender fee token
3267      *  [8] = loan taker fee token
3268      *
3269      * @param  values256    Values corresponding to:
3270      *
3271      *  [0] = loan maximum amount
3272      *  [1] = loan minimum amount
3273      *  [2] = loan minimum heldToken
3274      *  [3] = loan lender fee
3275      *  [4] = loan taker fee
3276      *  [5] = loan expiration timestamp (in seconds)
3277      *  [6] = loan salt
3278      *
3279      * @param  values32     Values corresponding to:
3280      *
3281      *  [0] = loan call time limit (in seconds)
3282      *  [1] = loan maxDuration (in seconds)
3283      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3284      *  [3] = loan interest update period (in seconds)
3285      *
3286      * @param  positionId   Unique ID of the position
3287      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3288      * @return              This address to accept, a different address to ask that contract
3289      */
3290     function verifyLoanOffering(
3291         address[9] addresses,
3292         uint256[7] values256,
3293         uint32[4] values32,
3294         bytes32 positionId,
3295         bytes signature
3296     )
3297         external
3298         /* onlyMargin */
3299         returns (address);
3300 }
3301 
3302 // File: contracts/margin/impl/BorrowShared.sol
3303 
3304 /**
3305  * @title BorrowShared
3306  * @author dYdX
3307  *
3308  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3309  * Both use a Loan Offering and a DEX Order to open or increase a position.
3310  */
3311 library BorrowShared {
3312     using SafeMath for uint256;
3313 
3314     // ============ Structs ============
3315 
3316     struct Tx {
3317         bytes32 positionId;
3318         address owner;
3319         uint256 principal;
3320         uint256 lenderAmount;
3321         MarginCommon.LoanOffering loanOffering;
3322         address exchangeWrapper;
3323         bool depositInHeldToken;
3324         uint256 depositAmount;
3325         uint256 collateralAmount;
3326         uint256 heldTokenFromSell;
3327     }
3328 
3329     // ============ Internal Implementation Functions ============
3330 
3331     /**
3332      * Validate the transaction before exchanging heldToken for owedToken
3333      */
3334     function validateTxPreSell(
3335         MarginState.State storage state,
3336         Tx memory transaction
3337     )
3338         internal
3339     {
3340         assert(transaction.lenderAmount >= transaction.principal);
3341 
3342         require(
3343             transaction.principal > 0,
3344             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3345         );
3346 
3347         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3348         if (transaction.loanOffering.taker != address(0)) {
3349             require(
3350                 msg.sender == transaction.loanOffering.taker,
3351                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3352             );
3353         }
3354 
3355         // If the positionOwner is 0x0 then any address can be set as the position owner.
3356         // Otherwise only the specified positionOwner can be set as the position owner.
3357         if (transaction.loanOffering.positionOwner != address(0)) {
3358             require(
3359                 transaction.owner == transaction.loanOffering.positionOwner,
3360                 "BorrowShared#validateTxPreSell: Invalid position owner"
3361             );
3362         }
3363 
3364         // Require the loan offering to be approved by the payer
3365         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3366             getConsentFromSmartContractLender(transaction);
3367         } else {
3368             require(
3369                 transaction.loanOffering.payer == TypedSignature.recover(
3370                     transaction.loanOffering.loanHash,
3371                     transaction.loanOffering.signature
3372                 ),
3373                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3374             );
3375         }
3376 
3377         // Validate the amount is <= than max and >= min
3378         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3379             state,
3380             transaction.loanOffering.loanHash
3381         );
3382         require(
3383             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3384             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3385         );
3386 
3387         require(
3388             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3389             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3390         );
3391 
3392         require(
3393             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3394             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3395         );
3396 
3397         require(
3398             transaction.owner != address(0),
3399             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3400         );
3401 
3402         require(
3403             transaction.loanOffering.owner != address(0),
3404             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3405         );
3406 
3407         require(
3408             transaction.loanOffering.expirationTimestamp > block.timestamp,
3409             "BorrowShared#validateTxPreSell: Loan offering is expired"
3410         );
3411 
3412         require(
3413             transaction.loanOffering.maxDuration > 0,
3414             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3415         );
3416 
3417         require(
3418             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3419             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3420         );
3421 
3422         // The minimum heldToken is validated after executing the sell
3423         // Position and loan ownership is validated in TransferInternal
3424     }
3425 
3426     /**
3427      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3428      * how much of the loan was used.
3429      */
3430     function doPostSell(
3431         MarginState.State storage state,
3432         Tx memory transaction
3433     )
3434         internal
3435     {
3436         validateTxPostSell(transaction);
3437 
3438         // Transfer feeTokens from trader and lender
3439         transferLoanFees(state, transaction);
3440 
3441         // Update global amounts for the loan
3442         state.loanFills[transaction.loanOffering.loanHash] =
3443             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3444     }
3445 
3446     /**
3447      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3448      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3449      * maxHeldTokenToBuy of heldTokens at most.
3450      */
3451     function doSell(
3452         MarginState.State storage state,
3453         Tx transaction,
3454         bytes orderData,
3455         uint256 maxHeldTokenToBuy
3456     )
3457         internal
3458         returns (uint256)
3459     {
3460         // Move owedTokens from lender to exchange wrapper
3461         pullOwedTokensFromLender(state, transaction);
3462 
3463         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3464         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3465         uint256 sellAmount = transaction.depositInHeldToken ?
3466             transaction.lenderAmount :
3467             transaction.lenderAmount.add(transaction.depositAmount);
3468 
3469         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3470         uint256 heldTokenFromSell = Math.min256(
3471             maxHeldTokenToBuy,
3472             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3473                 msg.sender,
3474                 state.TOKEN_PROXY,
3475                 transaction.loanOffering.heldToken,
3476                 transaction.loanOffering.owedToken,
3477                 sellAmount,
3478                 orderData
3479             )
3480         );
3481 
3482         // Move the tokens to the vault
3483         Vault(state.VAULT).transferToVault(
3484             transaction.positionId,
3485             transaction.loanOffering.heldToken,
3486             transaction.exchangeWrapper,
3487             heldTokenFromSell
3488         );
3489 
3490         // Update collateral amount
3491         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3492 
3493         return heldTokenFromSell;
3494     }
3495 
3496     /**
3497      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3498      * be sold for heldToken.
3499      */
3500     function doDepositOwedToken(
3501         MarginState.State storage state,
3502         Tx transaction
3503     )
3504         internal
3505     {
3506         TokenProxy(state.TOKEN_PROXY).transferTokens(
3507             transaction.loanOffering.owedToken,
3508             msg.sender,
3509             transaction.exchangeWrapper,
3510             transaction.depositAmount
3511         );
3512     }
3513 
3514     /**
3515      * Take the heldToken deposit from the trader and move it to the vault.
3516      */
3517     function doDepositHeldToken(
3518         MarginState.State storage state,
3519         Tx transaction
3520     )
3521         internal
3522     {
3523         Vault(state.VAULT).transferToVault(
3524             transaction.positionId,
3525             transaction.loanOffering.heldToken,
3526             msg.sender,
3527             transaction.depositAmount
3528         );
3529 
3530         // Update collateral amount
3531         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3532     }
3533 
3534     // ============ Private Helper-Functions ============
3535 
3536     function validateTxPostSell(
3537         Tx transaction
3538     )
3539         private
3540         pure
3541     {
3542         uint256 expectedCollateral = transaction.depositInHeldToken ?
3543             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3544             transaction.heldTokenFromSell;
3545         assert(transaction.collateralAmount == expectedCollateral);
3546 
3547         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3548             transaction.lenderAmount,
3549             transaction.loanOffering.rates.maxAmount,
3550             transaction.loanOffering.rates.minHeldToken
3551         );
3552         require(
3553             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3554             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3555         );
3556     }
3557 
3558     function getConsentFromSmartContractLender(
3559         Tx transaction
3560     )
3561         private
3562     {
3563         verifyLoanOfferingRecurse(
3564             transaction.loanOffering.payer,
3565             getLoanOfferingAddresses(transaction),
3566             getLoanOfferingValues256(transaction),
3567             getLoanOfferingValues32(transaction),
3568             transaction.positionId,
3569             transaction.loanOffering.signature
3570         );
3571     }
3572 
3573     function verifyLoanOfferingRecurse(
3574         address contractAddr,
3575         address[9] addresses,
3576         uint256[7] values256,
3577         uint32[4] values32,
3578         bytes32 positionId,
3579         bytes signature
3580     )
3581         private
3582     {
3583         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3584             addresses,
3585             values256,
3586             values32,
3587             positionId,
3588             signature
3589         );
3590 
3591         if (newContractAddr != contractAddr) {
3592             verifyLoanOfferingRecurse(
3593                 newContractAddr,
3594                 addresses,
3595                 values256,
3596                 values32,
3597                 positionId,
3598                 signature
3599             );
3600         }
3601     }
3602 
3603     function pullOwedTokensFromLender(
3604         MarginState.State storage state,
3605         Tx transaction
3606     )
3607         private
3608     {
3609         // Transfer owedToken to the exchange wrapper
3610         TokenProxy(state.TOKEN_PROXY).transferTokens(
3611             transaction.loanOffering.owedToken,
3612             transaction.loanOffering.payer,
3613             transaction.exchangeWrapper,
3614             transaction.lenderAmount
3615         );
3616     }
3617 
3618     function transferLoanFees(
3619         MarginState.State storage state,
3620         Tx transaction
3621     )
3622         private
3623     {
3624         // 0 fee address indicates no fees
3625         if (transaction.loanOffering.feeRecipient == address(0)) {
3626             return;
3627         }
3628 
3629         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3630 
3631         uint256 lenderFee = MathHelpers.getPartialAmount(
3632             transaction.lenderAmount,
3633             transaction.loanOffering.rates.maxAmount,
3634             transaction.loanOffering.rates.lenderFee
3635         );
3636         uint256 takerFee = MathHelpers.getPartialAmount(
3637             transaction.lenderAmount,
3638             transaction.loanOffering.rates.maxAmount,
3639             transaction.loanOffering.rates.takerFee
3640         );
3641 
3642         if (lenderFee > 0) {
3643             proxy.transferTokens(
3644                 transaction.loanOffering.lenderFeeToken,
3645                 transaction.loanOffering.payer,
3646                 transaction.loanOffering.feeRecipient,
3647                 lenderFee
3648             );
3649         }
3650 
3651         if (takerFee > 0) {
3652             proxy.transferTokens(
3653                 transaction.loanOffering.takerFeeToken,
3654                 msg.sender,
3655                 transaction.loanOffering.feeRecipient,
3656                 takerFee
3657             );
3658         }
3659     }
3660 
3661     function getLoanOfferingAddresses(
3662         Tx transaction
3663     )
3664         private
3665         pure
3666         returns (address[9])
3667     {
3668         return [
3669             transaction.loanOffering.owedToken,
3670             transaction.loanOffering.heldToken,
3671             transaction.loanOffering.payer,
3672             transaction.loanOffering.owner,
3673             transaction.loanOffering.taker,
3674             transaction.loanOffering.positionOwner,
3675             transaction.loanOffering.feeRecipient,
3676             transaction.loanOffering.lenderFeeToken,
3677             transaction.loanOffering.takerFeeToken
3678         ];
3679     }
3680 
3681     function getLoanOfferingValues256(
3682         Tx transaction
3683     )
3684         private
3685         pure
3686         returns (uint256[7])
3687     {
3688         return [
3689             transaction.loanOffering.rates.maxAmount,
3690             transaction.loanOffering.rates.minAmount,
3691             transaction.loanOffering.rates.minHeldToken,
3692             transaction.loanOffering.rates.lenderFee,
3693             transaction.loanOffering.rates.takerFee,
3694             transaction.loanOffering.expirationTimestamp,
3695             transaction.loanOffering.salt
3696         ];
3697     }
3698 
3699     function getLoanOfferingValues32(
3700         Tx transaction
3701     )
3702         private
3703         pure
3704         returns (uint32[4])
3705     {
3706         return [
3707             transaction.loanOffering.callTimeLimit,
3708             transaction.loanOffering.maxDuration,
3709             transaction.loanOffering.rates.interestRate,
3710             transaction.loanOffering.rates.interestPeriod
3711         ];
3712     }
3713 }
3714 
3715 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3716 
3717 /**
3718  * @title IncreaseLoanDelegator
3719  * @author dYdX
3720  *
3721  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3722  *
3723  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3724  *       to these functions
3725  */
3726 interface IncreaseLoanDelegator {
3727 
3728     // ============ Public Interface functions ============
3729 
3730     /**
3731      * Function a contract must implement in order to allow additional value to be added onto
3732      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3733      *
3734      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3735      * either revert the entire transaction or that the loan size was successfully increased.
3736      *
3737      * @param  payer           Lender adding additional funds to the position
3738      * @param  positionId      Unique ID of the position
3739      * @param  principalAdded  Principal amount to be added to the position
3740      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
3741      *                         zero if increaseWithoutCounterparty() is used).
3742      * @return                 This address to accept, a different address to ask that contract
3743      */
3744     function increaseLoanOnBehalfOf(
3745         address payer,
3746         bytes32 positionId,
3747         uint256 principalAdded,
3748         uint256 lentAmount
3749     )
3750         external
3751         /* onlyMargin */
3752         returns (address);
3753 }
3754 
3755 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
3756 
3757 /**
3758  * @title IncreasePositionDelegator
3759  * @author dYdX
3760  *
3761  * Interface that smart contracts must implement in order to own position on behalf of other
3762  * accounts
3763  *
3764  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3765  *       to these functions
3766  */
3767 interface IncreasePositionDelegator {
3768 
3769     // ============ Public Interface functions ============
3770 
3771     /**
3772      * Function a contract must implement in order to allow additional value to be added onto
3773      * an owned position. Margin will call this on the owner of a position during increasePosition()
3774      *
3775      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3776      * either revert the entire transaction or that the position size was successfully increased.
3777      *
3778      * @param  trader          Address initiating the addition of funds to the position
3779      * @param  positionId      Unique ID of the position
3780      * @param  principalAdded  Amount of principal to be added to the position
3781      * @return                 This address to accept, a different address to ask that contract
3782      */
3783     function increasePositionOnBehalfOf(
3784         address trader,
3785         bytes32 positionId,
3786         uint256 principalAdded
3787     )
3788         external
3789         /* onlyMargin */
3790         returns (address);
3791 }
3792 
3793 // File: contracts/margin/impl/IncreasePositionImpl.sol
3794 
3795 /**
3796  * @title IncreasePositionImpl
3797  * @author dYdX
3798  *
3799  * This library contains the implementation for the increasePosition function of Margin
3800  */
3801 library IncreasePositionImpl {
3802     using SafeMath for uint256;
3803 
3804     // ============ Events ============
3805 
3806     /*
3807      * A position was increased
3808      */
3809     event PositionIncreased(
3810         bytes32 indexed positionId,
3811         address indexed trader,
3812         address indexed lender,
3813         address positionOwner,
3814         address loanOwner,
3815         bytes32 loanHash,
3816         address loanFeeRecipient,
3817         uint256 amountBorrowed,
3818         uint256 principalAdded,
3819         uint256 heldTokenFromSell,
3820         uint256 depositAmount,
3821         bool    depositInHeldToken
3822     );
3823 
3824     // ============ Public Implementation Functions ============
3825 
3826     function increasePositionImpl(
3827         MarginState.State storage state,
3828         bytes32 positionId,
3829         address[7] addresses,
3830         uint256[8] values256,
3831         uint32[2] values32,
3832         bool depositInHeldToken,
3833         bytes signature,
3834         bytes orderData
3835     )
3836         public
3837         returns (uint256)
3838     {
3839         // Also ensures that the position exists
3840         MarginCommon.Position storage position =
3841             MarginCommon.getPositionFromStorage(state, positionId);
3842 
3843         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
3844             position,
3845             positionId,
3846             addresses,
3847             values256,
3848             values32,
3849             depositInHeldToken,
3850             signature
3851         );
3852 
3853         validateIncrease(state, transaction, position);
3854 
3855         doBorrowAndSell(state, transaction, orderData);
3856 
3857         updateState(
3858             position,
3859             transaction.positionId,
3860             transaction.principal,
3861             transaction.lenderAmount,
3862             transaction.loanOffering.payer
3863         );
3864 
3865         // LOG EVENT
3866         recordPositionIncreased(transaction, position);
3867 
3868         return transaction.lenderAmount;
3869     }
3870 
3871     function increaseWithoutCounterpartyImpl(
3872         MarginState.State storage state,
3873         bytes32 positionId,
3874         uint256 principalToAdd
3875     )
3876         public
3877         returns (uint256)
3878     {
3879         MarginCommon.Position storage position =
3880             MarginCommon.getPositionFromStorage(state, positionId);
3881 
3882         // Disallow adding 0 principal
3883         require(
3884             principalToAdd > 0,
3885             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
3886         );
3887 
3888         // Disallow additions after maximum duration
3889         require(
3890             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
3891             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
3892         );
3893 
3894         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
3895             state,
3896             position,
3897             positionId,
3898             principalToAdd
3899         );
3900 
3901         Vault(state.VAULT).transferToVault(
3902             positionId,
3903             position.heldToken,
3904             msg.sender,
3905             heldTokenAmount
3906         );
3907 
3908         updateState(
3909             position,
3910             positionId,
3911             principalToAdd,
3912             0, // lent amount
3913             msg.sender
3914         );
3915 
3916         emit PositionIncreased(
3917             positionId,
3918             msg.sender,
3919             msg.sender,
3920             position.owner,
3921             position.lender,
3922             "",
3923             address(0),
3924             0,
3925             principalToAdd,
3926             0,
3927             heldTokenAmount,
3928             true
3929         );
3930 
3931         return heldTokenAmount;
3932     }
3933 
3934     // ============ Private Helper-Functions ============
3935 
3936     function doBorrowAndSell(
3937         MarginState.State storage state,
3938         BorrowShared.Tx memory transaction,
3939         bytes orderData
3940     )
3941         private
3942     {
3943         // Calculate the number of heldTokens to add
3944         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
3945             state,
3946             state.positions[transaction.positionId],
3947             transaction.positionId,
3948             transaction.principal
3949         );
3950 
3951         // Do pre-exchange validations
3952         BorrowShared.validateTxPreSell(state, transaction);
3953 
3954         // Calculate and deposit owedToken
3955         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
3956         if (!transaction.depositInHeldToken) {
3957             transaction.depositAmount =
3958                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
3959             BorrowShared.doDepositOwedToken(state, transaction);
3960             maxHeldTokenFromSell = collateralToAdd;
3961         }
3962 
3963         // Sell owedToken for heldToken using the exchange wrapper
3964         transaction.heldTokenFromSell = BorrowShared.doSell(
3965             state,
3966             transaction,
3967             orderData,
3968             maxHeldTokenFromSell
3969         );
3970 
3971         // Calculate and deposit heldToken
3972         if (transaction.depositInHeldToken) {
3973             require(
3974                 transaction.heldTokenFromSell <= collateralToAdd,
3975                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
3976             );
3977             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
3978             BorrowShared.doDepositHeldToken(state, transaction);
3979         }
3980 
3981         // Make sure the actual added collateral is what is expected
3982         assert(transaction.collateralAmount == collateralToAdd);
3983 
3984         // Do post-exchange validations
3985         BorrowShared.doPostSell(state, transaction);
3986     }
3987 
3988     function getOwedTokenDeposit(
3989         BorrowShared.Tx transaction,
3990         uint256 collateralToAdd,
3991         bytes orderData
3992     )
3993         private
3994         view
3995         returns (uint256)
3996     {
3997         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
3998             transaction.loanOffering.heldToken,
3999             transaction.loanOffering.owedToken,
4000             collateralToAdd,
4001             orderData
4002         );
4003 
4004         require(
4005             transaction.lenderAmount <= totalOwedToken,
4006             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4007         );
4008 
4009         return totalOwedToken.sub(transaction.lenderAmount);
4010     }
4011 
4012     function validateIncrease(
4013         MarginState.State storage state,
4014         BorrowShared.Tx transaction,
4015         MarginCommon.Position storage position
4016     )
4017         private
4018         view
4019     {
4020         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4021 
4022         require(
4023             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4024             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4025         );
4026 
4027         // require the position to end no later than the loanOffering's maximum acceptable end time
4028         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4029         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4030         require(
4031             positionEndTimestamp <= offeringEndTimestamp,
4032             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4033         );
4034 
4035         require(
4036             block.timestamp < positionEndTimestamp,
4037             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4038         );
4039     }
4040 
4041     function getCollateralNeededForAddedPrincipal(
4042         MarginState.State storage state,
4043         MarginCommon.Position storage position,
4044         bytes32 positionId,
4045         uint256 principalToAdd
4046     )
4047         private
4048         view
4049         returns (uint256)
4050     {
4051         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4052 
4053         return MathHelpers.getPartialAmountRoundedUp(
4054             principalToAdd,
4055             position.principal,
4056             heldTokenBalance
4057         );
4058     }
4059 
4060     function updateState(
4061         MarginCommon.Position storage position,
4062         bytes32 positionId,
4063         uint256 principalAdded,
4064         uint256 owedTokenLent,
4065         address loanPayer
4066     )
4067         private
4068     {
4069         position.principal = position.principal.add(principalAdded);
4070 
4071         address owner = position.owner;
4072         address lender = position.lender;
4073 
4074         // Ensure owner consent
4075         increasePositionOnBehalfOfRecurse(
4076             owner,
4077             msg.sender,
4078             positionId,
4079             principalAdded
4080         );
4081 
4082         // Ensure lender consent
4083         increaseLoanOnBehalfOfRecurse(
4084             lender,
4085             loanPayer,
4086             positionId,
4087             principalAdded,
4088             owedTokenLent
4089         );
4090     }
4091 
4092     function increasePositionOnBehalfOfRecurse(
4093         address contractAddr,
4094         address trader,
4095         bytes32 positionId,
4096         uint256 principalAdded
4097     )
4098         private
4099     {
4100         // Assume owner approval if not a smart contract and they increased their own position
4101         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4102             return;
4103         }
4104 
4105         address newContractAddr =
4106             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4107                 trader,
4108                 positionId,
4109                 principalAdded
4110             );
4111 
4112         if (newContractAddr != contractAddr) {
4113             increasePositionOnBehalfOfRecurse(
4114                 newContractAddr,
4115                 trader,
4116                 positionId,
4117                 principalAdded
4118             );
4119         }
4120     }
4121 
4122     function increaseLoanOnBehalfOfRecurse(
4123         address contractAddr,
4124         address payer,
4125         bytes32 positionId,
4126         uint256 principalAdded,
4127         uint256 amountLent
4128     )
4129         private
4130     {
4131         // Assume lender approval if not a smart contract and they increased their own loan
4132         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4133             return;
4134         }
4135 
4136         address newContractAddr =
4137             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4138                 payer,
4139                 positionId,
4140                 principalAdded,
4141                 amountLent
4142             );
4143 
4144         if (newContractAddr != contractAddr) {
4145             increaseLoanOnBehalfOfRecurse(
4146                 newContractAddr,
4147                 payer,
4148                 positionId,
4149                 principalAdded,
4150                 amountLent
4151             );
4152         }
4153     }
4154 
4155     function recordPositionIncreased(
4156         BorrowShared.Tx transaction,
4157         MarginCommon.Position storage position
4158     )
4159         private
4160     {
4161         emit PositionIncreased(
4162             transaction.positionId,
4163             msg.sender,
4164             transaction.loanOffering.payer,
4165             position.owner,
4166             position.lender,
4167             transaction.loanOffering.loanHash,
4168             transaction.loanOffering.feeRecipient,
4169             transaction.lenderAmount,
4170             transaction.principal,
4171             transaction.heldTokenFromSell,
4172             transaction.depositAmount,
4173             transaction.depositInHeldToken
4174         );
4175     }
4176 
4177     // ============ Parsing Functions ============
4178 
4179     function parseIncreasePositionTx(
4180         MarginCommon.Position storage position,
4181         bytes32 positionId,
4182         address[7] addresses,
4183         uint256[8] values256,
4184         uint32[2] values32,
4185         bool depositInHeldToken,
4186         bytes signature
4187     )
4188         private
4189         view
4190         returns (BorrowShared.Tx memory)
4191     {
4192         uint256 principal = values256[7];
4193 
4194         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4195             position,
4196             principal,
4197             block.timestamp
4198         );
4199         assert(lenderAmount >= principal);
4200 
4201         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4202             positionId: positionId,
4203             owner: position.owner,
4204             principal: principal,
4205             lenderAmount: lenderAmount,
4206             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4207                 position,
4208                 addresses,
4209                 values256,
4210                 values32,
4211                 signature
4212             ),
4213             exchangeWrapper: addresses[6],
4214             depositInHeldToken: depositInHeldToken,
4215             depositAmount: 0, // set later
4216             collateralAmount: 0, // set later
4217             heldTokenFromSell: 0 // set later
4218         });
4219 
4220         return transaction;
4221     }
4222 
4223     function parseLoanOfferingFromIncreasePositionTx(
4224         MarginCommon.Position storage position,
4225         address[7] addresses,
4226         uint256[8] values256,
4227         uint32[2] values32,
4228         bytes signature
4229     )
4230         private
4231         view
4232         returns (MarginCommon.LoanOffering memory)
4233     {
4234         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4235             owedToken: position.owedToken,
4236             heldToken: position.heldToken,
4237             payer: addresses[0],
4238             owner: position.lender,
4239             taker: addresses[1],
4240             positionOwner: addresses[2],
4241             feeRecipient: addresses[3],
4242             lenderFeeToken: addresses[4],
4243             takerFeeToken: addresses[5],
4244             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4245             expirationTimestamp: values256[5],
4246             callTimeLimit: values32[0],
4247             maxDuration: values32[1],
4248             salt: values256[6],
4249             loanHash: 0,
4250             signature: signature
4251         });
4252 
4253         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4254 
4255         return loanOffering;
4256     }
4257 
4258     function parseLoanOfferingRatesFromIncreasePositionTx(
4259         MarginCommon.Position storage position,
4260         uint256[8] values256
4261     )
4262         private
4263         view
4264         returns (MarginCommon.LoanRates memory)
4265     {
4266         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4267             maxAmount: values256[0],
4268             minAmount: values256[1],
4269             minHeldToken: values256[2],
4270             lenderFee: values256[3],
4271             takerFee: values256[4],
4272             interestRate: position.interestRate,
4273             interestPeriod: position.interestPeriod
4274         });
4275 
4276         return rates;
4277     }
4278 }
4279 
4280 // File: contracts/margin/impl/MarginStorage.sol
4281 
4282 /**
4283  * @title MarginStorage
4284  * @author dYdX
4285  *
4286  * This contract serves as the storage for the entire state of MarginStorage
4287  */
4288 contract MarginStorage {
4289 
4290     MarginState.State state;
4291 
4292 }
4293 
4294 // File: contracts/margin/impl/LoanGetters.sol
4295 
4296 /**
4297  * @title LoanGetters
4298  * @author dYdX
4299  *
4300  * A collection of public constant getter functions that allows reading of the state of any loan
4301  * offering stored in the dYdX protocol.
4302  */
4303 contract LoanGetters is MarginStorage {
4304 
4305     // ============ Public Constant Functions ============
4306 
4307     /**
4308      * Gets the principal amount of a loan offering that is no longer available.
4309      *
4310      * @param  loanHash  Unique hash of the loan offering
4311      * @return           The total unavailable amount of the loan offering, which is equal to the
4312      *                   filled amount plus the canceled amount.
4313      */
4314     function getLoanUnavailableAmount(
4315         bytes32 loanHash
4316     )
4317         external
4318         view
4319         returns (uint256)
4320     {
4321         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4322     }
4323 
4324     /**
4325      * Gets the total amount of owed token lent for a loan.
4326      *
4327      * @param  loanHash  Unique hash of the loan offering
4328      * @return           The total filled amount of the loan offering.
4329      */
4330     function getLoanFilledAmount(
4331         bytes32 loanHash
4332     )
4333         external
4334         view
4335         returns (uint256)
4336     {
4337         return state.loanFills[loanHash];
4338     }
4339 
4340     /**
4341      * Gets the amount of a loan offering that has been canceled.
4342      *
4343      * @param  loanHash  Unique hash of the loan offering
4344      * @return           The total canceled amount of the loan offering.
4345      */
4346     function getLoanCanceledAmount(
4347         bytes32 loanHash
4348     )
4349         external
4350         view
4351         returns (uint256)
4352     {
4353         return state.loanCancels[loanHash];
4354     }
4355 }
4356 
4357 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4358 
4359 /**
4360  * @title CancelMarginCallDelegator
4361  * @author dYdX
4362  *
4363  * Interface that smart contracts must implement in order to let other addresses cancel a
4364  * margin-call for a loan owned by the smart contract.
4365  *
4366  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4367  *       to these functions
4368  */
4369 interface CancelMarginCallDelegator {
4370 
4371     // ============ Public Interface functions ============
4372 
4373     /**
4374      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4375      *
4376      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4377      * either revert the entire transaction or that the margin-call was successfully canceled.
4378      *
4379      * @param  canceler    Address of the caller of the cancelMarginCall function
4380      * @param  positionId  Unique ID of the position
4381      * @return             This address to accept, a different address to ask that contract
4382      */
4383     function cancelMarginCallOnBehalfOf(
4384         address canceler,
4385         bytes32 positionId
4386     )
4387         external
4388         /* onlyMargin */
4389         returns (address);
4390 }
4391 
4392 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4393 
4394 /**
4395  * @title MarginCallDelegator
4396  * @author dYdX
4397  *
4398  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4399  * owned by the smart contract.
4400  *
4401  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4402  *       to these functions
4403  */
4404 interface MarginCallDelegator {
4405 
4406     // ============ Public Interface functions ============
4407 
4408     /**
4409      * Function a contract must implement in order to let other addresses call marginCall().
4410      *
4411      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4412      * either revert the entire transaction or that the loan was successfully margin-called.
4413      *
4414      * @param  caller         Address of the caller of the marginCall function
4415      * @param  positionId     Unique ID of the position
4416      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4417      * @return                This address to accept, a different address to ask that contract
4418      */
4419     function marginCallOnBehalfOf(
4420         address caller,
4421         bytes32 positionId,
4422         uint256 depositAmount
4423     )
4424         external
4425         /* onlyMargin */
4426         returns (address);
4427 }
4428 
4429 // File: contracts/margin/impl/LoanImpl.sol
4430 
4431 /**
4432  * @title LoanImpl
4433  * @author dYdX
4434  *
4435  * This library contains the implementation for the following functions of Margin:
4436  *
4437  *      - marginCall
4438  *      - cancelMarginCallImpl
4439  *      - cancelLoanOffering
4440  */
4441 library LoanImpl {
4442     using SafeMath for uint256;
4443 
4444     // ============ Events ============
4445 
4446     /**
4447      * A position was margin-called
4448      */
4449     event MarginCallInitiated(
4450         bytes32 indexed positionId,
4451         address indexed lender,
4452         address indexed owner,
4453         uint256 requiredDeposit
4454     );
4455 
4456     /**
4457      * A margin call was canceled
4458      */
4459     event MarginCallCanceled(
4460         bytes32 indexed positionId,
4461         address indexed lender,
4462         address indexed owner,
4463         uint256 depositAmount
4464     );
4465 
4466     /**
4467      * A loan offering was canceled before it was used. Any amount less than the
4468      * total for the loan offering can be canceled.
4469      */
4470     event LoanOfferingCanceled(
4471         bytes32 indexed loanHash,
4472         address indexed payer,
4473         address indexed feeRecipient,
4474         uint256 cancelAmount
4475     );
4476 
4477     // ============ Public Implementation Functions ============
4478 
4479     function marginCallImpl(
4480         MarginState.State storage state,
4481         bytes32 positionId,
4482         uint256 requiredDeposit
4483     )
4484         public
4485     {
4486         MarginCommon.Position storage position =
4487             MarginCommon.getPositionFromStorage(state, positionId);
4488 
4489         require(
4490             position.callTimestamp == 0,
4491             "LoanImpl#marginCallImpl: The position has already been margin-called"
4492         );
4493 
4494         // Ensure lender consent
4495         marginCallOnBehalfOfRecurse(
4496             position.lender,
4497             msg.sender,
4498             positionId,
4499             requiredDeposit
4500         );
4501 
4502         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4503         position.requiredDeposit = requiredDeposit;
4504 
4505         emit MarginCallInitiated(
4506             positionId,
4507             position.lender,
4508             position.owner,
4509             requiredDeposit
4510         );
4511     }
4512 
4513     function cancelMarginCallImpl(
4514         MarginState.State storage state,
4515         bytes32 positionId
4516     )
4517         public
4518     {
4519         MarginCommon.Position storage position =
4520             MarginCommon.getPositionFromStorage(state, positionId);
4521 
4522         require(
4523             position.callTimestamp > 0,
4524             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4525         );
4526 
4527         // Ensure lender consent
4528         cancelMarginCallOnBehalfOfRecurse(
4529             position.lender,
4530             msg.sender,
4531             positionId
4532         );
4533 
4534         state.positions[positionId].callTimestamp = 0;
4535         state.positions[positionId].requiredDeposit = 0;
4536 
4537         emit MarginCallCanceled(
4538             positionId,
4539             position.lender,
4540             position.owner,
4541             0
4542         );
4543     }
4544 
4545     function cancelLoanOfferingImpl(
4546         MarginState.State storage state,
4547         address[9] addresses,
4548         uint256[7] values256,
4549         uint32[4]  values32,
4550         uint256    cancelAmount
4551     )
4552         public
4553         returns (uint256)
4554     {
4555         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4556             addresses,
4557             values256,
4558             values32
4559         );
4560 
4561         require(
4562             msg.sender == loanOffering.payer,
4563             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4564         );
4565         require(
4566             loanOffering.expirationTimestamp > block.timestamp,
4567             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4568         );
4569 
4570         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4571             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4572         );
4573         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4574 
4575         // If the loan was already fully canceled, then just return 0 amount was canceled
4576         if (amountToCancel == 0) {
4577             return 0;
4578         }
4579 
4580         state.loanCancels[loanOffering.loanHash] =
4581             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4582 
4583         emit LoanOfferingCanceled(
4584             loanOffering.loanHash,
4585             loanOffering.payer,
4586             loanOffering.feeRecipient,
4587             amountToCancel
4588         );
4589 
4590         return amountToCancel;
4591     }
4592 
4593     // ============ Private Helper-Functions ============
4594 
4595     function marginCallOnBehalfOfRecurse(
4596         address contractAddr,
4597         address who,
4598         bytes32 positionId,
4599         uint256 requiredDeposit
4600     )
4601         private
4602     {
4603         // no need to ask for permission
4604         if (who == contractAddr) {
4605             return;
4606         }
4607 
4608         address newContractAddr =
4609             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4610                 msg.sender,
4611                 positionId,
4612                 requiredDeposit
4613             );
4614 
4615         if (newContractAddr != contractAddr) {
4616             marginCallOnBehalfOfRecurse(
4617                 newContractAddr,
4618                 who,
4619                 positionId,
4620                 requiredDeposit
4621             );
4622         }
4623     }
4624 
4625     function cancelMarginCallOnBehalfOfRecurse(
4626         address contractAddr,
4627         address who,
4628         bytes32 positionId
4629     )
4630         private
4631     {
4632         // no need to ask for permission
4633         if (who == contractAddr) {
4634             return;
4635         }
4636 
4637         address newContractAddr =
4638             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4639                 msg.sender,
4640                 positionId
4641             );
4642 
4643         if (newContractAddr != contractAddr) {
4644             cancelMarginCallOnBehalfOfRecurse(
4645                 newContractAddr,
4646                 who,
4647                 positionId
4648             );
4649         }
4650     }
4651 
4652     // ============ Parsing Functions ============
4653 
4654     function parseLoanOffering(
4655         address[9] addresses,
4656         uint256[7] values256,
4657         uint32[4]  values32
4658     )
4659         private
4660         view
4661         returns (MarginCommon.LoanOffering memory)
4662     {
4663         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4664             owedToken: addresses[0],
4665             heldToken: addresses[1],
4666             payer: addresses[2],
4667             owner: addresses[3],
4668             taker: addresses[4],
4669             positionOwner: addresses[5],
4670             feeRecipient: addresses[6],
4671             lenderFeeToken: addresses[7],
4672             takerFeeToken: addresses[8],
4673             rates: parseLoanOfferRates(values256, values32),
4674             expirationTimestamp: values256[5],
4675             callTimeLimit: values32[0],
4676             maxDuration: values32[1],
4677             salt: values256[6],
4678             loanHash: 0,
4679             signature: new bytes(0)
4680         });
4681 
4682         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4683 
4684         return loanOffering;
4685     }
4686 
4687     function parseLoanOfferRates(
4688         uint256[7] values256,
4689         uint32[4] values32
4690     )
4691         private
4692         pure
4693         returns (MarginCommon.LoanRates memory)
4694     {
4695         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4696             maxAmount: values256[0],
4697             minAmount: values256[1],
4698             minHeldToken: values256[2],
4699             interestRate: values32[2],
4700             lenderFee: values256[3],
4701             takerFee: values256[4],
4702             interestPeriod: values32[3]
4703         });
4704 
4705         return rates;
4706     }
4707 }
4708 
4709 // File: contracts/margin/impl/MarginAdmin.sol
4710 
4711 /**
4712  * @title MarginAdmin
4713  * @author dYdX
4714  *
4715  * Contains admin functions for the Margin contract
4716  * The owner can put Margin into various close-only modes, which will disallow new position creation
4717  */
4718 contract MarginAdmin is Ownable {
4719     // ============ Enums ============
4720 
4721     // All functionality enabled
4722     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4723 
4724     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4725     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4726     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4727 
4728     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4729     // forceRecoverCollateral)
4730     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4731 
4732     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4733     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4734 
4735     // This operation state (and any higher) is invalid
4736     uint8 private constant OPERATION_STATE_INVALID = 4;
4737 
4738     // ============ Events ============
4739 
4740     /**
4741      * Event indicating the operation state has changed
4742      */
4743     event OperationStateChanged(
4744         uint8 from,
4745         uint8 to
4746     );
4747 
4748     // ============ State Variables ============
4749 
4750     uint8 public operationState;
4751 
4752     // ============ Constructor ============
4753 
4754     constructor()
4755         public
4756         Ownable()
4757     {
4758         operationState = OPERATION_STATE_OPERATIONAL;
4759     }
4760 
4761     // ============ Modifiers ============
4762 
4763     modifier onlyWhileOperational() {
4764         require(
4765             operationState == OPERATION_STATE_OPERATIONAL,
4766             "MarginAdmin#onlyWhileOperational: Can only call while operational"
4767         );
4768         _;
4769     }
4770 
4771     modifier cancelLoanOfferingStateControl() {
4772         require(
4773             operationState == OPERATION_STATE_OPERATIONAL
4774             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
4775             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
4776         );
4777         _;
4778     }
4779 
4780     modifier closePositionStateControl() {
4781         require(
4782             operationState == OPERATION_STATE_OPERATIONAL
4783             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
4784             || operationState == OPERATION_STATE_CLOSE_ONLY,
4785             "MarginAdmin#closePositionStateControl: Invalid operation state"
4786         );
4787         _;
4788     }
4789 
4790     modifier closePositionDirectlyStateControl() {
4791         _;
4792     }
4793 
4794     // ============ Owner-Only State-Changing Functions ============
4795 
4796     function setOperationState(
4797         uint8 newState
4798     )
4799         external
4800         onlyOwner
4801     {
4802         require(
4803             newState < OPERATION_STATE_INVALID,
4804             "MarginAdmin#setOperationState: newState is not a valid operation state"
4805         );
4806 
4807         if (newState != operationState) {
4808             emit OperationStateChanged(
4809                 operationState,
4810                 newState
4811             );
4812             operationState = newState;
4813         }
4814     }
4815 }
4816 
4817 // File: contracts/margin/impl/MarginEvents.sol
4818 
4819 /**
4820  * @title MarginEvents
4821  * @author dYdX
4822  *
4823  * Contains events for the Margin contract.
4824  *
4825  * NOTE: Any Margin function libraries that use events will need to both define the event here
4826  *       and copy the event into the library itself as libraries don't support sharing events
4827  */
4828 contract MarginEvents {
4829     // ============ Events ============
4830 
4831     /**
4832      * A position was opened
4833      */
4834     event PositionOpened(
4835         bytes32 indexed positionId,
4836         address indexed trader,
4837         address indexed lender,
4838         bytes32 loanHash,
4839         address owedToken,
4840         address heldToken,
4841         address loanFeeRecipient,
4842         uint256 principal,
4843         uint256 heldTokenFromSell,
4844         uint256 depositAmount,
4845         uint256 interestRate,
4846         uint32  callTimeLimit,
4847         uint32  maxDuration,
4848         bool    depositInHeldToken
4849     );
4850 
4851     /*
4852      * A position was increased
4853      */
4854     event PositionIncreased(
4855         bytes32 indexed positionId,
4856         address indexed trader,
4857         address indexed lender,
4858         address positionOwner,
4859         address loanOwner,
4860         bytes32 loanHash,
4861         address loanFeeRecipient,
4862         uint256 amountBorrowed,
4863         uint256 principalAdded,
4864         uint256 heldTokenFromSell,
4865         uint256 depositAmount,
4866         bool    depositInHeldToken
4867     );
4868 
4869     /**
4870      * A position was closed or partially closed
4871      */
4872     event PositionClosed(
4873         bytes32 indexed positionId,
4874         address indexed closer,
4875         address indexed payoutRecipient,
4876         uint256 closeAmount,
4877         uint256 remainingAmount,
4878         uint256 owedTokenPaidToLender,
4879         uint256 payoutAmount,
4880         uint256 buybackCostInHeldToken,
4881         bool payoutInHeldToken
4882     );
4883 
4884     /**
4885      * Collateral for a position was forcibly recovered
4886      */
4887     event CollateralForceRecovered(
4888         bytes32 indexed positionId,
4889         address indexed recipient,
4890         uint256 amount
4891     );
4892 
4893     /**
4894      * A position was margin-called
4895      */
4896     event MarginCallInitiated(
4897         bytes32 indexed positionId,
4898         address indexed lender,
4899         address indexed owner,
4900         uint256 requiredDeposit
4901     );
4902 
4903     /**
4904      * A margin call was canceled
4905      */
4906     event MarginCallCanceled(
4907         bytes32 indexed positionId,
4908         address indexed lender,
4909         address indexed owner,
4910         uint256 depositAmount
4911     );
4912 
4913     /**
4914      * A loan offering was canceled before it was used. Any amount less than the
4915      * total for the loan offering can be canceled.
4916      */
4917     event LoanOfferingCanceled(
4918         bytes32 indexed loanHash,
4919         address indexed payer,
4920         address indexed feeRecipient,
4921         uint256 cancelAmount
4922     );
4923 
4924     /**
4925      * Additional collateral for a position was posted by the owner
4926      */
4927     event AdditionalCollateralDeposited(
4928         bytes32 indexed positionId,
4929         uint256 amount,
4930         address depositor
4931     );
4932 
4933     /**
4934      * Ownership of a loan was transferred to a new address
4935      */
4936     event LoanTransferred(
4937         bytes32 indexed positionId,
4938         address indexed from,
4939         address indexed to
4940     );
4941 
4942     /**
4943      * Ownership of a position was transferred to a new address
4944      */
4945     event PositionTransferred(
4946         bytes32 indexed positionId,
4947         address indexed from,
4948         address indexed to
4949     );
4950 }
4951 
4952 // File: contracts/margin/impl/OpenPositionImpl.sol
4953 
4954 /**
4955  * @title OpenPositionImpl
4956  * @author dYdX
4957  *
4958  * This library contains the implementation for the openPosition function of Margin
4959  */
4960 library OpenPositionImpl {
4961     using SafeMath for uint256;
4962 
4963     // ============ Events ============
4964 
4965     /**
4966      * A position was opened
4967      */
4968     event PositionOpened(
4969         bytes32 indexed positionId,
4970         address indexed trader,
4971         address indexed lender,
4972         bytes32 loanHash,
4973         address owedToken,
4974         address heldToken,
4975         address loanFeeRecipient,
4976         uint256 principal,
4977         uint256 heldTokenFromSell,
4978         uint256 depositAmount,
4979         uint256 interestRate,
4980         uint32  callTimeLimit,
4981         uint32  maxDuration,
4982         bool    depositInHeldToken
4983     );
4984 
4985     // ============ Public Implementation Functions ============
4986 
4987     function openPositionImpl(
4988         MarginState.State storage state,
4989         address[11] addresses,
4990         uint256[10] values256,
4991         uint32[4] values32,
4992         bool depositInHeldToken,
4993         bytes signature,
4994         bytes orderData
4995     )
4996         public
4997         returns (bytes32)
4998     {
4999         BorrowShared.Tx memory transaction = parseOpenTx(
5000             addresses,
5001             values256,
5002             values32,
5003             depositInHeldToken,
5004             signature
5005         );
5006 
5007         require(
5008             !MarginCommon.positionHasExisted(state, transaction.positionId),
5009             "OpenPositionImpl#openPositionImpl: positionId already exists"
5010         );
5011 
5012         doBorrowAndSell(state, transaction, orderData);
5013 
5014         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5015         recordPositionOpened(
5016             transaction
5017         );
5018 
5019         doStoreNewPosition(
5020             state,
5021             transaction
5022         );
5023 
5024         return transaction.positionId;
5025     }
5026 
5027     // ============ Private Helper-Functions ============
5028 
5029     function doBorrowAndSell(
5030         MarginState.State storage state,
5031         BorrowShared.Tx memory transaction,
5032         bytes orderData
5033     )
5034         private
5035     {
5036         BorrowShared.validateTxPreSell(state, transaction);
5037 
5038         if (transaction.depositInHeldToken) {
5039             BorrowShared.doDepositHeldToken(state, transaction);
5040         } else {
5041             BorrowShared.doDepositOwedToken(state, transaction);
5042         }
5043 
5044         transaction.heldTokenFromSell = BorrowShared.doSell(
5045             state,
5046             transaction,
5047             orderData,
5048             MathHelpers.maxUint256()
5049         );
5050 
5051         BorrowShared.doPostSell(state, transaction);
5052     }
5053 
5054     function doStoreNewPosition(
5055         MarginState.State storage state,
5056         BorrowShared.Tx memory transaction
5057     )
5058         private
5059     {
5060         MarginCommon.storeNewPosition(
5061             state,
5062             transaction.positionId,
5063             MarginCommon.Position({
5064                 owedToken: transaction.loanOffering.owedToken,
5065                 heldToken: transaction.loanOffering.heldToken,
5066                 lender: transaction.loanOffering.owner,
5067                 owner: transaction.owner,
5068                 principal: transaction.principal,
5069                 requiredDeposit: 0,
5070                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5071                 startTimestamp: 0,
5072                 callTimestamp: 0,
5073                 maxDuration: transaction.loanOffering.maxDuration,
5074                 interestRate: transaction.loanOffering.rates.interestRate,
5075                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5076             }),
5077             transaction.loanOffering.payer
5078         );
5079     }
5080 
5081     function recordPositionOpened(
5082         BorrowShared.Tx transaction
5083     )
5084         private
5085     {
5086         emit PositionOpened(
5087             transaction.positionId,
5088             msg.sender,
5089             transaction.loanOffering.payer,
5090             transaction.loanOffering.loanHash,
5091             transaction.loanOffering.owedToken,
5092             transaction.loanOffering.heldToken,
5093             transaction.loanOffering.feeRecipient,
5094             transaction.principal,
5095             transaction.heldTokenFromSell,
5096             transaction.depositAmount,
5097             transaction.loanOffering.rates.interestRate,
5098             transaction.loanOffering.callTimeLimit,
5099             transaction.loanOffering.maxDuration,
5100             transaction.depositInHeldToken
5101         );
5102     }
5103 
5104     // ============ Parsing Functions ============
5105 
5106     function parseOpenTx(
5107         address[11] addresses,
5108         uint256[10] values256,
5109         uint32[4] values32,
5110         bool depositInHeldToken,
5111         bytes signature
5112     )
5113         private
5114         view
5115         returns (BorrowShared.Tx memory)
5116     {
5117         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5118             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5119             owner: addresses[0],
5120             principal: values256[7],
5121             lenderAmount: values256[7],
5122             loanOffering: parseLoanOffering(
5123                 addresses,
5124                 values256,
5125                 values32,
5126                 signature
5127             ),
5128             exchangeWrapper: addresses[10],
5129             depositInHeldToken: depositInHeldToken,
5130             depositAmount: values256[8],
5131             collateralAmount: 0, // set later
5132             heldTokenFromSell: 0 // set later
5133         });
5134 
5135         return transaction;
5136     }
5137 
5138     function parseLoanOffering(
5139         address[11] addresses,
5140         uint256[10] values256,
5141         uint32[4]   values32,
5142         bytes       signature
5143     )
5144         private
5145         view
5146         returns (MarginCommon.LoanOffering memory)
5147     {
5148         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5149             owedToken: addresses[1],
5150             heldToken: addresses[2],
5151             payer: addresses[3],
5152             owner: addresses[4],
5153             taker: addresses[5],
5154             positionOwner: addresses[6],
5155             feeRecipient: addresses[7],
5156             lenderFeeToken: addresses[8],
5157             takerFeeToken: addresses[9],
5158             rates: parseLoanOfferRates(values256, values32),
5159             expirationTimestamp: values256[5],
5160             callTimeLimit: values32[0],
5161             maxDuration: values32[1],
5162             salt: values256[6],
5163             loanHash: 0,
5164             signature: signature
5165         });
5166 
5167         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5168 
5169         return loanOffering;
5170     }
5171 
5172     function parseLoanOfferRates(
5173         uint256[10] values256,
5174         uint32[4] values32
5175     )
5176         private
5177         pure
5178         returns (MarginCommon.LoanRates memory)
5179     {
5180         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5181             maxAmount: values256[0],
5182             minAmount: values256[1],
5183             minHeldToken: values256[2],
5184             lenderFee: values256[3],
5185             takerFee: values256[4],
5186             interestRate: values32[2],
5187             interestPeriod: values32[3]
5188         });
5189 
5190         return rates;
5191     }
5192 }
5193 
5194 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5195 
5196 /**
5197  * @title OpenWithoutCounterpartyImpl
5198  * @author dYdX
5199  *
5200  * This library contains the implementation for the openWithoutCounterparty
5201  * function of Margin
5202  */
5203 library OpenWithoutCounterpartyImpl {
5204 
5205     // ============ Structs ============
5206 
5207     struct Tx {
5208         bytes32 positionId;
5209         address positionOwner;
5210         address owedToken;
5211         address heldToken;
5212         address loanOwner;
5213         uint256 principal;
5214         uint256 deposit;
5215         uint32 callTimeLimit;
5216         uint32 maxDuration;
5217         uint32 interestRate;
5218         uint32 interestPeriod;
5219     }
5220 
5221     // ============ Events ============
5222 
5223     /**
5224      * A position was opened
5225      */
5226     event PositionOpened(
5227         bytes32 indexed positionId,
5228         address indexed trader,
5229         address indexed lender,
5230         bytes32 loanHash,
5231         address owedToken,
5232         address heldToken,
5233         address loanFeeRecipient,
5234         uint256 principal,
5235         uint256 heldTokenFromSell,
5236         uint256 depositAmount,
5237         uint256 interestRate,
5238         uint32  callTimeLimit,
5239         uint32  maxDuration,
5240         bool    depositInHeldToken
5241     );
5242 
5243     // ============ Public Implementation Functions ============
5244 
5245     function openWithoutCounterpartyImpl(
5246         MarginState.State storage state,
5247         address[4] addresses,
5248         uint256[3] values256,
5249         uint32[4]  values32
5250     )
5251         public
5252         returns (bytes32)
5253     {
5254         Tx memory openTx = parseTx(
5255             addresses,
5256             values256,
5257             values32
5258         );
5259 
5260         validate(
5261             state,
5262             openTx
5263         );
5264 
5265         Vault(state.VAULT).transferToVault(
5266             openTx.positionId,
5267             openTx.heldToken,
5268             msg.sender,
5269             openTx.deposit
5270         );
5271 
5272         recordPositionOpened(
5273             openTx
5274         );
5275 
5276         doStoreNewPosition(
5277             state,
5278             openTx
5279         );
5280 
5281         return openTx.positionId;
5282     }
5283 
5284     // ============ Private Helper-Functions ============
5285 
5286     function doStoreNewPosition(
5287         MarginState.State storage state,
5288         Tx memory openTx
5289     )
5290         private
5291     {
5292         MarginCommon.storeNewPosition(
5293             state,
5294             openTx.positionId,
5295             MarginCommon.Position({
5296                 owedToken: openTx.owedToken,
5297                 heldToken: openTx.heldToken,
5298                 lender: openTx.loanOwner,
5299                 owner: openTx.positionOwner,
5300                 principal: openTx.principal,
5301                 requiredDeposit: 0,
5302                 callTimeLimit: openTx.callTimeLimit,
5303                 startTimestamp: 0,
5304                 callTimestamp: 0,
5305                 maxDuration: openTx.maxDuration,
5306                 interestRate: openTx.interestRate,
5307                 interestPeriod: openTx.interestPeriod
5308             }),
5309             msg.sender
5310         );
5311     }
5312 
5313     function validate(
5314         MarginState.State storage state,
5315         Tx memory openTx
5316     )
5317         private
5318         view
5319     {
5320         require(
5321             !MarginCommon.positionHasExisted(state, openTx.positionId),
5322             "openWithoutCounterpartyImpl#validate: positionId already exists"
5323         );
5324 
5325         require(
5326             openTx.principal > 0,
5327             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5328         );
5329 
5330         require(
5331             openTx.owedToken != address(0),
5332             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5333         );
5334 
5335         require(
5336             openTx.owedToken != openTx.heldToken,
5337             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5338         );
5339 
5340         require(
5341             openTx.positionOwner != address(0),
5342             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5343         );
5344 
5345         require(
5346             openTx.loanOwner != address(0),
5347             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5348         );
5349 
5350         require(
5351             openTx.maxDuration > 0,
5352             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5353         );
5354 
5355         require(
5356             openTx.interestPeriod <= openTx.maxDuration,
5357             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5358         );
5359     }
5360 
5361     function recordPositionOpened(
5362         Tx memory openTx
5363     )
5364         private
5365     {
5366         emit PositionOpened(
5367             openTx.positionId,
5368             msg.sender,
5369             msg.sender,
5370             bytes32(0),
5371             openTx.owedToken,
5372             openTx.heldToken,
5373             address(0),
5374             openTx.principal,
5375             0,
5376             openTx.deposit,
5377             openTx.interestRate,
5378             openTx.callTimeLimit,
5379             openTx.maxDuration,
5380             true
5381         );
5382     }
5383 
5384     // ============ Parsing Functions ============
5385 
5386     function parseTx(
5387         address[4] addresses,
5388         uint256[3] values256,
5389         uint32[4]  values32
5390     )
5391         private
5392         view
5393         returns (Tx memory)
5394     {
5395         Tx memory openTx = Tx({
5396             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5397             positionOwner: addresses[0],
5398             owedToken: addresses[1],
5399             heldToken: addresses[2],
5400             loanOwner: addresses[3],
5401             principal: values256[0],
5402             deposit: values256[1],
5403             callTimeLimit: values32[0],
5404             maxDuration: values32[1],
5405             interestRate: values32[2],
5406             interestPeriod: values32[3]
5407         });
5408 
5409         return openTx;
5410     }
5411 }
5412 
5413 // File: contracts/margin/impl/PositionGetters.sol
5414 
5415 /**
5416  * @title PositionGetters
5417  * @author dYdX
5418  *
5419  * A collection of public constant getter functions that allows reading of the state of any position
5420  * stored in the dYdX protocol.
5421  */
5422 contract PositionGetters is MarginStorage {
5423     using SafeMath for uint256;
5424 
5425     // ============ Public Constant Functions ============
5426 
5427     /**
5428      * Gets if a position is currently open.
5429      *
5430      * @param  positionId  Unique ID of the position
5431      * @return             True if the position is exists and is open
5432      */
5433     function containsPosition(
5434         bytes32 positionId
5435     )
5436         external
5437         view
5438         returns (bool)
5439     {
5440         return MarginCommon.containsPositionImpl(state, positionId);
5441     }
5442 
5443     /**
5444      * Gets if a position is currently margin-called.
5445      *
5446      * @param  positionId  Unique ID of the position
5447      * @return             True if the position is margin-called
5448      */
5449     function isPositionCalled(
5450         bytes32 positionId
5451     )
5452         external
5453         view
5454         returns (bool)
5455     {
5456         return (state.positions[positionId].callTimestamp > 0);
5457     }
5458 
5459     /**
5460      * Gets if a position was previously open and is now closed.
5461      *
5462      * @param  positionId  Unique ID of the position
5463      * @return             True if the position is now closed
5464      */
5465     function isPositionClosed(
5466         bytes32 positionId
5467     )
5468         external
5469         view
5470         returns (bool)
5471     {
5472         return state.closedPositions[positionId];
5473     }
5474 
5475     /**
5476      * Gets the total amount of owedToken ever repaid to the lender for a position.
5477      *
5478      * @param  positionId  Unique ID of the position
5479      * @return             Total amount of owedToken ever repaid
5480      */
5481     function getTotalOwedTokenRepaidToLender(
5482         bytes32 positionId
5483     )
5484         external
5485         view
5486         returns (uint256)
5487     {
5488         return state.totalOwedTokenRepaidToLender[positionId];
5489     }
5490 
5491     /**
5492      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5493      *
5494      * @param  positionId  Unique ID of the position
5495      * @return             The amount of heldToken
5496      */
5497     function getPositionBalance(
5498         bytes32 positionId
5499     )
5500         external
5501         view
5502         returns (uint256)
5503     {
5504         return MarginCommon.getPositionBalanceImpl(state, positionId);
5505     }
5506 
5507     /**
5508      * Gets the time until the interest fee charged for the position will increase.
5509      * Returns 1 if the interest fee increases every second.
5510      * Returns 0 if the interest fee will never increase again.
5511      *
5512      * @param  positionId  Unique ID of the position
5513      * @return             The number of seconds until the interest fee will increase
5514      */
5515     function getTimeUntilInterestIncrease(
5516         bytes32 positionId
5517     )
5518         external
5519         view
5520         returns (uint256)
5521     {
5522         MarginCommon.Position storage position =
5523             MarginCommon.getPositionFromStorage(state, positionId);
5524 
5525         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5526             position,
5527             block.timestamp
5528         );
5529 
5530         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5531         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5532             return 0;
5533         } else {
5534             // nextStep is the final second at which the calculated interest fee is the same as it
5535             // is currently, so add 1 to get the correct value
5536             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5537         }
5538     }
5539 
5540     /**
5541      * Gets the amount of owedTokens currently needed to close the position completely, including
5542      * interest fees.
5543      *
5544      * @param  positionId  Unique ID of the position
5545      * @return             The number of owedTokens
5546      */
5547     function getPositionOwedAmount(
5548         bytes32 positionId
5549     )
5550         external
5551         view
5552         returns (uint256)
5553     {
5554         MarginCommon.Position storage position =
5555             MarginCommon.getPositionFromStorage(state, positionId);
5556 
5557         return MarginCommon.calculateOwedAmount(
5558             position,
5559             position.principal,
5560             block.timestamp
5561         );
5562     }
5563 
5564     /**
5565      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5566      * given time, including interest fees.
5567      *
5568      * @param  positionId         Unique ID of the position
5569      * @param  principalToClose   Amount of principal being closed
5570      * @param  timestamp          Block timestamp in seconds of close
5571      * @return                    The number of owedTokens owed
5572      */
5573     function getPositionOwedAmountAtTime(
5574         bytes32 positionId,
5575         uint256 principalToClose,
5576         uint32  timestamp
5577     )
5578         external
5579         view
5580         returns (uint256)
5581     {
5582         MarginCommon.Position storage position =
5583             MarginCommon.getPositionFromStorage(state, positionId);
5584 
5585         require(
5586             timestamp >= position.startTimestamp,
5587             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5588         );
5589 
5590         return MarginCommon.calculateOwedAmount(
5591             position,
5592             principalToClose,
5593             timestamp
5594         );
5595     }
5596 
5597     /**
5598      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5599      * amount to the position at a given time.
5600      *
5601      * @param  positionId      Unique ID of the position
5602      * @param  principalToAdd  Amount being added to principal
5603      * @param  timestamp       Block timestamp in seconds of addition
5604      * @return                 The number of owedTokens that will be borrowed
5605      */
5606     function getLenderAmountForIncreasePositionAtTime(
5607         bytes32 positionId,
5608         uint256 principalToAdd,
5609         uint32  timestamp
5610     )
5611         external
5612         view
5613         returns (uint256)
5614     {
5615         MarginCommon.Position storage position =
5616             MarginCommon.getPositionFromStorage(state, positionId);
5617 
5618         require(
5619             timestamp >= position.startTimestamp,
5620             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5621         );
5622 
5623         return MarginCommon.calculateLenderAmountForIncreasePosition(
5624             position,
5625             principalToAdd,
5626             timestamp
5627         );
5628     }
5629 
5630     // ============ All Properties ============
5631 
5632     /**
5633      * Get a Position by id. This does not validate the position exists. If the position does not
5634      * exist, all 0's will be returned.
5635      *
5636      * @param  positionId  Unique ID of the position
5637      * @return             Addresses corresponding to:
5638      *
5639      *                     [0] = owedToken
5640      *                     [1] = heldToken
5641      *                     [2] = lender
5642      *                     [3] = owner
5643      *
5644      *                     Values corresponding to:
5645      *
5646      *                     [0] = principal
5647      *                     [1] = requiredDeposit
5648      *
5649      *                     Values corresponding to:
5650      *
5651      *                     [0] = callTimeLimit
5652      *                     [1] = startTimestamp
5653      *                     [2] = callTimestamp
5654      *                     [3] = maxDuration
5655      *                     [4] = interestRate
5656      *                     [5] = interestPeriod
5657      */
5658     function getPosition(
5659         bytes32 positionId
5660     )
5661         external
5662         view
5663         returns (
5664             address[4],
5665             uint256[2],
5666             uint32[6]
5667         )
5668     {
5669         MarginCommon.Position storage position = state.positions[positionId];
5670 
5671         return (
5672             [
5673                 position.owedToken,
5674                 position.heldToken,
5675                 position.lender,
5676                 position.owner
5677             ],
5678             [
5679                 position.principal,
5680                 position.requiredDeposit
5681             ],
5682             [
5683                 position.callTimeLimit,
5684                 position.startTimestamp,
5685                 position.callTimestamp,
5686                 position.maxDuration,
5687                 position.interestRate,
5688                 position.interestPeriod
5689             ]
5690         );
5691     }
5692 
5693     // ============ Individual Properties ============
5694 
5695     function getPositionLender(
5696         bytes32 positionId
5697     )
5698         external
5699         view
5700         returns (address)
5701     {
5702         return state.positions[positionId].lender;
5703     }
5704 
5705     function getPositionOwner(
5706         bytes32 positionId
5707     )
5708         external
5709         view
5710         returns (address)
5711     {
5712         return state.positions[positionId].owner;
5713     }
5714 
5715     function getPositionHeldToken(
5716         bytes32 positionId
5717     )
5718         external
5719         view
5720         returns (address)
5721     {
5722         return state.positions[positionId].heldToken;
5723     }
5724 
5725     function getPositionOwedToken(
5726         bytes32 positionId
5727     )
5728         external
5729         view
5730         returns (address)
5731     {
5732         return state.positions[positionId].owedToken;
5733     }
5734 
5735     function getPositionPrincipal(
5736         bytes32 positionId
5737     )
5738         external
5739         view
5740         returns (uint256)
5741     {
5742         return state.positions[positionId].principal;
5743     }
5744 
5745     function getPositionInterestRate(
5746         bytes32 positionId
5747     )
5748         external
5749         view
5750         returns (uint256)
5751     {
5752         return state.positions[positionId].interestRate;
5753     }
5754 
5755     function getPositionRequiredDeposit(
5756         bytes32 positionId
5757     )
5758         external
5759         view
5760         returns (uint256)
5761     {
5762         return state.positions[positionId].requiredDeposit;
5763     }
5764 
5765     function getPositionStartTimestamp(
5766         bytes32 positionId
5767     )
5768         external
5769         view
5770         returns (uint32)
5771     {
5772         return state.positions[positionId].startTimestamp;
5773     }
5774 
5775     function getPositionCallTimestamp(
5776         bytes32 positionId
5777     )
5778         external
5779         view
5780         returns (uint32)
5781     {
5782         return state.positions[positionId].callTimestamp;
5783     }
5784 
5785     function getPositionCallTimeLimit(
5786         bytes32 positionId
5787     )
5788         external
5789         view
5790         returns (uint32)
5791     {
5792         return state.positions[positionId].callTimeLimit;
5793     }
5794 
5795     function getPositionMaxDuration(
5796         bytes32 positionId
5797     )
5798         external
5799         view
5800         returns (uint32)
5801     {
5802         return state.positions[positionId].maxDuration;
5803     }
5804 
5805     function getPositioninterestPeriod(
5806         bytes32 positionId
5807     )
5808         external
5809         view
5810         returns (uint32)
5811     {
5812         return state.positions[positionId].interestPeriod;
5813     }
5814 }
5815 
5816 // File: contracts/margin/impl/TransferImpl.sol
5817 
5818 /**
5819  * @title TransferImpl
5820  * @author dYdX
5821  *
5822  * This library contains the implementation for the transferPosition and transferLoan functions of
5823  * Margin
5824  */
5825 library TransferImpl {
5826 
5827     // ============ Public Implementation Functions ============
5828 
5829     function transferLoanImpl(
5830         MarginState.State storage state,
5831         bytes32 positionId,
5832         address newLender
5833     )
5834         public
5835     {
5836         require(
5837             MarginCommon.containsPositionImpl(state, positionId),
5838             "TransferImpl#transferLoanImpl: Position does not exist"
5839         );
5840 
5841         address originalLender = state.positions[positionId].lender;
5842 
5843         require(
5844             msg.sender == originalLender,
5845             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
5846         );
5847         require(
5848             newLender != originalLender,
5849             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
5850         );
5851 
5852         // Doesn't change the state of positionId; figures out the final owner of loan.
5853         // That is, newLender may pass ownership to a different address.
5854         address finalLender = TransferInternal.grantLoanOwnership(
5855             positionId,
5856             originalLender,
5857             newLender);
5858 
5859         require(
5860             finalLender != originalLender,
5861             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
5862         );
5863 
5864         // Set state only after resolving the new owner (to reduce the number of storage calls)
5865         state.positions[positionId].lender = finalLender;
5866     }
5867 
5868     function transferPositionImpl(
5869         MarginState.State storage state,
5870         bytes32 positionId,
5871         address newOwner
5872     )
5873         public
5874     {
5875         require(
5876             MarginCommon.containsPositionImpl(state, positionId),
5877             "TransferImpl#transferPositionImpl: Position does not exist"
5878         );
5879 
5880         address originalOwner = state.positions[positionId].owner;
5881 
5882         require(
5883             msg.sender == originalOwner,
5884             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
5885         );
5886         require(
5887             newOwner != originalOwner,
5888             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
5889         );
5890 
5891         // Doesn't change the state of positionId; figures out the final owner of position.
5892         // That is, newOwner may pass ownership to a different address.
5893         address finalOwner = TransferInternal.grantPositionOwnership(
5894             positionId,
5895             originalOwner,
5896             newOwner);
5897 
5898         require(
5899             finalOwner != originalOwner,
5900             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
5901         );
5902 
5903         // Set state only after resolving the new owner (to reduce the number of storage calls)
5904         state.positions[positionId].owner = finalOwner;
5905     }
5906 }
5907 
5908 // File: contracts/margin/Margin.sol
5909 
5910 /**
5911  * @title Margin
5912  * @author dYdX
5913  *
5914  * This contract is used to facilitate margin trading as per the dYdX protocol
5915  */
5916 contract Margin is
5917     ReentrancyGuard,
5918     MarginStorage,
5919     MarginEvents,
5920     MarginAdmin,
5921     LoanGetters,
5922     PositionGetters
5923 {
5924 
5925     using SafeMath for uint256;
5926 
5927     // ============ Constructor ============
5928 
5929     constructor(
5930         address vault,
5931         address proxy
5932     )
5933         public
5934         MarginAdmin()
5935     {
5936         state = MarginState.State({
5937             VAULT: vault,
5938             TOKEN_PROXY: proxy
5939         });
5940     }
5941 
5942     // ============ Public State Changing Functions ============
5943 
5944     /**
5945      * Open a margin position. Called by the margin trader who must provide both a
5946      * signed loan offering as well as a DEX Order with which to sell the owedToken.
5947      *
5948      * @param  addresses           Addresses corresponding to:
5949      *
5950      *  [0]  = position owner
5951      *  [1]  = owedToken
5952      *  [2]  = heldToken
5953      *  [3]  = loan payer
5954      *  [4]  = loan owner
5955      *  [5]  = loan taker
5956      *  [6]  = loan position owner
5957      *  [7]  = loan fee recipient
5958      *  [8]  = loan lender fee token
5959      *  [9]  = loan taker fee token
5960      *  [10]  = exchange wrapper address
5961      *
5962      * @param  values256           Values corresponding to:
5963      *
5964      *  [0]  = loan maximum amount
5965      *  [1]  = loan minimum amount
5966      *  [2]  = loan minimum heldToken
5967      *  [3]  = loan lender fee
5968      *  [4]  = loan taker fee
5969      *  [5]  = loan expiration timestamp (in seconds)
5970      *  [6]  = loan salt
5971      *  [7]  = position amount of principal
5972      *  [8]  = deposit amount
5973      *  [9]  = nonce (used to calculate positionId)
5974      *
5975      * @param  values32            Values corresponding to:
5976      *
5977      *  [0] = loan call time limit (in seconds)
5978      *  [1] = loan maxDuration (in seconds)
5979      *  [2] = loan interest rate (annual nominal percentage times 10**6)
5980      *  [3] = loan interest update period (in seconds)
5981      *
5982      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
5983      *                             False if the margin deposit will be in owedToken
5984      *                             and then sold along with the owedToken borrowed from the lender
5985      * @param  signature           If loan payer is an account, then this must be the tightly-packed
5986      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
5987      *                             is a smart contract, these are arbitrary bytes that the contract
5988      *                             will recieve when choosing whether to approve the loan.
5989      * @param  order               Order object to be passed to the exchange wrapper
5990      * @return                     Unique ID for the new position
5991      */
5992     function openPosition(
5993         address[11] addresses,
5994         uint256[10] values256,
5995         uint32[4]   values32,
5996         bool        depositInHeldToken,
5997         bytes       signature,
5998         bytes       order
5999     )
6000         external
6001         onlyWhileOperational
6002         nonReentrant
6003         returns (bytes32)
6004     {
6005         return OpenPositionImpl.openPositionImpl(
6006             state,
6007             addresses,
6008             values256,
6009             values32,
6010             depositInHeldToken,
6011             signature,
6012             order
6013         );
6014     }
6015 
6016     /**
6017      * Open a margin position without a counterparty. The caller will serve as both the
6018      * lender and the position owner
6019      *
6020      * @param  addresses    Addresses corresponding to:
6021      *
6022      *  [0]  = position owner
6023      *  [1]  = owedToken
6024      *  [2]  = heldToken
6025      *  [3]  = loan owner
6026      *
6027      * @param  values256    Values corresponding to:
6028      *
6029      *  [0]  = principal
6030      *  [1]  = deposit amount
6031      *  [2]  = nonce (used to calculate positionId)
6032      *
6033      * @param  values32     Values corresponding to:
6034      *
6035      *  [0] = call time limit (in seconds)
6036      *  [1] = maxDuration (in seconds)
6037      *  [2] = interest rate (annual nominal percentage times 10**6)
6038      *  [3] = interest update period (in seconds)
6039      *
6040      * @return              Unique ID for the new position
6041      */
6042     function openWithoutCounterparty(
6043         address[4] addresses,
6044         uint256[3] values256,
6045         uint32[4]  values32
6046     )
6047         external
6048         onlyWhileOperational
6049         nonReentrant
6050         returns (bytes32)
6051     {
6052         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6053             state,
6054             addresses,
6055             values256,
6056             values32
6057         );
6058     }
6059 
6060     /**
6061      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6062      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6063      * principal added, as it will incorporate interest already earned by the position so far.
6064      *
6065      * @param  positionId          Unique ID of the position
6066      * @param  addresses           Addresses corresponding to:
6067      *
6068      *  [0]  = loan payer
6069      *  [1]  = loan taker
6070      *  [2]  = loan position owner
6071      *  [3]  = loan fee recipient
6072      *  [4]  = loan lender fee token
6073      *  [5]  = loan taker fee token
6074      *  [6]  = exchange wrapper address
6075      *
6076      * @param  values256           Values corresponding to:
6077      *
6078      *  [0]  = loan maximum amount
6079      *  [1]  = loan minimum amount
6080      *  [2]  = loan minimum heldToken
6081      *  [3]  = loan lender fee
6082      *  [4]  = loan taker fee
6083      *  [5]  = loan expiration timestamp (in seconds)
6084      *  [6]  = loan salt
6085      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6086      *                                                           will be >= this amount)
6087      *
6088      * @param  values32            Values corresponding to:
6089      *
6090      *  [0] = loan call time limit (in seconds)
6091      *  [1] = loan maxDuration (in seconds)
6092      *
6093      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6094      *                             False if the margin deposit will be pulled in owedToken
6095      *                             and then sold along with the owedToken borrowed from the lender
6096      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6097      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6098      *                             is a smart contract, these are arbitrary bytes that the contract
6099      *                             will recieve when choosing whether to approve the loan.
6100      * @param  order               Order object to be passed to the exchange wrapper
6101      * @return                     Amount of owedTokens pulled from the lender
6102      */
6103     function increasePosition(
6104         bytes32    positionId,
6105         address[7] addresses,
6106         uint256[8] values256,
6107         uint32[2]  values32,
6108         bool       depositInHeldToken,
6109         bytes      signature,
6110         bytes      order
6111     )
6112         external
6113         onlyWhileOperational
6114         nonReentrant
6115         returns (uint256)
6116     {
6117         return IncreasePositionImpl.increasePositionImpl(
6118             state,
6119             positionId,
6120             addresses,
6121             values256,
6122             values32,
6123             depositInHeldToken,
6124             signature,
6125             order
6126         );
6127     }
6128 
6129     /**
6130      * Increase a position directly by putting up heldToken. The caller will serve as both the
6131      * lender and the position owner
6132      *
6133      * @param  positionId      Unique ID of the position
6134      * @param  principalToAdd  Principal amount to add to the position
6135      * @return                 Amount of heldToken pulled from the msg.sender
6136      */
6137     function increaseWithoutCounterparty(
6138         bytes32 positionId,
6139         uint256 principalToAdd
6140     )
6141         external
6142         onlyWhileOperational
6143         nonReentrant
6144         returns (uint256)
6145     {
6146         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6147             state,
6148             positionId,
6149             principalToAdd
6150         );
6151     }
6152 
6153     /**
6154      * Close a position. May be called by the owner or with the approval of the owner. May provide
6155      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6156      * is sent the resulting payout.
6157      *
6158      * @param  positionId            Unique ID of the position
6159      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6160      *                               closed is also bounded by:
6161      *                               1) The principal of the position
6162      *                               2) The amount allowed by the owner if closer != owner
6163      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6164      * @param  exchangeWrapper       Address of the exchange wrapper
6165      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6166      *                               False to pay out the payoutRecipient in owedToken
6167      * @param  order                 Order object to be passed to the exchange wrapper
6168      * @return                       Values corresponding to:
6169      *                               1) Principal of position closed
6170      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6171      *                                  owedToken otherwise) received by the payoutRecipient
6172      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6173      */
6174     function closePosition(
6175         bytes32 positionId,
6176         uint256 requestedCloseAmount,
6177         address payoutRecipient,
6178         address exchangeWrapper,
6179         bool    payoutInHeldToken,
6180         bytes   order
6181     )
6182         external
6183         closePositionStateControl
6184         nonReentrant
6185         returns (uint256, uint256, uint256)
6186     {
6187         return ClosePositionImpl.closePositionImpl(
6188             state,
6189             positionId,
6190             requestedCloseAmount,
6191             payoutRecipient,
6192             exchangeWrapper,
6193             payoutInHeldToken,
6194             order
6195         );
6196     }
6197 
6198     /**
6199      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6200      *
6201      * @param  positionId            Unique ID of the position
6202      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6203      *                               closed is also bounded by:
6204      *                               1) The principal of the position
6205      *                               2) The amount allowed by the owner if closer != owner
6206      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6207      * @return                       Values corresponding to:
6208      *                               1) Principal amount of position closed
6209      *                               2) Amount of heldToken received by the payoutRecipient
6210      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6211      */
6212     function closePositionDirectly(
6213         bytes32 positionId,
6214         uint256 requestedCloseAmount,
6215         address payoutRecipient
6216     )
6217         external
6218         closePositionDirectlyStateControl
6219         nonReentrant
6220         returns (uint256, uint256, uint256)
6221     {
6222         return ClosePositionImpl.closePositionImpl(
6223             state,
6224             positionId,
6225             requestedCloseAmount,
6226             payoutRecipient,
6227             address(0),
6228             true,
6229             new bytes(0)
6230         );
6231     }
6232 
6233     /**
6234      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6235      * Must be approved by both the position owner and lender.
6236      *
6237      * @param  positionId            Unique ID of the position
6238      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6239      *                               closed is also bounded by:
6240      *                               1) The principal of the position
6241      *                               2) The amount allowed by the owner if closer != owner
6242      *                               3) The amount allowed by the lender if closer != lender
6243      * @return                       Values corresponding to:
6244      *                               1) Principal amount of position closed
6245      *                               2) Amount of heldToken received by the msg.sender
6246      */
6247     function closeWithoutCounterparty(
6248         bytes32 positionId,
6249         uint256 requestedCloseAmount,
6250         address payoutRecipient
6251     )
6252         external
6253         closePositionStateControl
6254         nonReentrant
6255         returns (uint256, uint256)
6256     {
6257         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6258             state,
6259             positionId,
6260             requestedCloseAmount,
6261             payoutRecipient
6262         );
6263     }
6264 
6265     /**
6266      * Margin-call a position. Only callable with the approval of the position lender. After the
6267      * call, the position owner will have time equal to the callTimeLimit of the position to close
6268      * the position. If the owner does not close the position, the lender can recover the collateral
6269      * in the position.
6270      *
6271      * @param  positionId       Unique ID of the position
6272      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6273      *                          the margin-call. Passing in 0 means the margin call cannot be
6274      *                          canceled by depositing
6275      */
6276     function marginCall(
6277         bytes32 positionId,
6278         uint256 requiredDeposit
6279     )
6280         external
6281         nonReentrant
6282     {
6283         LoanImpl.marginCallImpl(
6284             state,
6285             positionId,
6286             requiredDeposit
6287         );
6288     }
6289 
6290     /**
6291      * Cancel a margin-call. Only callable with the approval of the position lender.
6292      *
6293      * @param  positionId  Unique ID of the position
6294      */
6295     function cancelMarginCall(
6296         bytes32 positionId
6297     )
6298         external
6299         onlyWhileOperational
6300         nonReentrant
6301     {
6302         LoanImpl.cancelMarginCallImpl(state, positionId);
6303     }
6304 
6305     /**
6306      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6307      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6308      * but remains unclosed. Only callable with the approval of the position lender.
6309      *
6310      * @param  positionId  Unique ID of the position
6311      * @param  recipient   Address to send the recovered tokens to
6312      * @return             Amount of heldToken recovered
6313      */
6314     function forceRecoverCollateral(
6315         bytes32 positionId,
6316         address recipient
6317     )
6318         external
6319         nonReentrant
6320         returns (uint256)
6321     {
6322         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6323             state,
6324             positionId,
6325             recipient
6326         );
6327     }
6328 
6329     /**
6330      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6331      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6332      *
6333      * @param  positionId       Unique ID of the position
6334      * @param  depositAmount    Additional amount in heldToken to deposit
6335      */
6336     function depositCollateral(
6337         bytes32 positionId,
6338         uint256 depositAmount
6339     )
6340         external
6341         onlyWhileOperational
6342         nonReentrant
6343     {
6344         DepositCollateralImpl.depositCollateralImpl(
6345             state,
6346             positionId,
6347             depositAmount
6348         );
6349     }
6350 
6351     /**
6352      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6353      *
6354      * @param  addresses     Array of addresses:
6355      *
6356      *  [0] = owedToken
6357      *  [1] = heldToken
6358      *  [2] = loan payer
6359      *  [3] = loan owner
6360      *  [4] = loan taker
6361      *  [5] = loan position owner
6362      *  [6] = loan fee recipient
6363      *  [7] = loan lender fee token
6364      *  [8] = loan taker fee token
6365      *
6366      * @param  values256     Values corresponding to:
6367      *
6368      *  [0] = loan maximum amount
6369      *  [1] = loan minimum amount
6370      *  [2] = loan minimum heldToken
6371      *  [3] = loan lender fee
6372      *  [4] = loan taker fee
6373      *  [5] = loan expiration timestamp (in seconds)
6374      *  [6] = loan salt
6375      *
6376      * @param  values32      Values corresponding to:
6377      *
6378      *  [0] = loan call time limit (in seconds)
6379      *  [1] = loan maxDuration (in seconds)
6380      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6381      *  [3] = loan interest update period (in seconds)
6382      *
6383      * @param  cancelAmount  Amount to cancel
6384      * @return               Amount that was canceled
6385      */
6386     function cancelLoanOffering(
6387         address[9] addresses,
6388         uint256[7]  values256,
6389         uint32[4]   values32,
6390         uint256     cancelAmount
6391     )
6392         external
6393         cancelLoanOfferingStateControl
6394         nonReentrant
6395         returns (uint256)
6396     {
6397         return LoanImpl.cancelLoanOfferingImpl(
6398             state,
6399             addresses,
6400             values256,
6401             values32,
6402             cancelAmount
6403         );
6404     }
6405 
6406     /**
6407      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6408      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6409      * must implement the LoanOwner interface.
6410      *
6411      * @param  positionId  Unique ID of the position
6412      * @param  who         New owner of the loan
6413      */
6414     function transferLoan(
6415         bytes32 positionId,
6416         address who
6417     )
6418         external
6419         nonReentrant
6420     {
6421         TransferImpl.transferLoanImpl(
6422             state,
6423             positionId,
6424             who);
6425     }
6426 
6427     /**
6428      * Transfer ownership of a position to a new address. This new address will be entitled to all
6429      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6430      * the PositionOwner interface.
6431      *
6432      * @param  positionId  Unique ID of the position
6433      * @param  who         New owner of the position
6434      */
6435     function transferPosition(
6436         bytes32 positionId,
6437         address who
6438     )
6439         external
6440         nonReentrant
6441     {
6442         TransferImpl.transferPositionImpl(
6443             state,
6444             positionId,
6445             who);
6446     }
6447 
6448     // ============ Public Constant Functions ============
6449 
6450     /**
6451      * Gets the address of the Vault contract that holds and accounts for tokens.
6452      *
6453      * @return  The address of the Vault contract
6454      */
6455     function getVaultAddress()
6456         external
6457         view
6458         returns (address)
6459     {
6460         return state.VAULT;
6461     }
6462 
6463     /**
6464      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6465      * make loans or open/close positions.
6466      *
6467      * @return  The address of the TokenProxy contract
6468      */
6469     function getTokenProxyAddress()
6470         external
6471         view
6472         returns (address)
6473     {
6474         return state.TOKEN_PROXY;
6475     }
6476 }
6477 
6478 // File: contracts/margin/interfaces/ExchangeReader.sol
6479 
6480 /**
6481  * @title ExchangeReader
6482  * @author dYdX
6483  *
6484  * Contract interface that wraps an exchange and provides information about the current state of the
6485  * exchange or particular orders
6486  */
6487 interface ExchangeReader {
6488 
6489     // ============ Public Functions ============
6490 
6491     /**
6492      * Get the maxmimum amount of makerToken for some order
6493      *
6494      * @param  makerToken           Address of makerToken, the token to receive
6495      * @param  takerToken           Address of takerToken, the token to pay
6496      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
6497      * @return                      Maximum amount of makerToken
6498      */
6499     function getMaxMakerAmount(
6500         address makerToken,
6501         address takerToken,
6502         bytes orderData
6503     )
6504         external
6505         view
6506         returns (uint256);
6507 }
6508 
6509 // File: contracts/margin/external/AuctionProxy.sol
6510 
6511 /**
6512  * @title AuctionProxy
6513  * @author dYdX
6514  *
6515  * Contract that automatically sets the close amount for bidding in a Dutch Auction
6516  */
6517 contract AuctionProxy
6518 {
6519     using TokenInteract for address;
6520     using SafeMath for uint256;
6521 
6522     // ============ Structs ============
6523 
6524     struct Position {
6525         address heldToken;
6526         address owedToken;
6527         address owner;
6528         uint256 principal;
6529         uint256 owedTokenOwed;
6530     }
6531 
6532     // ============ State Variables ============
6533 
6534     address public DYDX_MARGIN;
6535 
6536     // ============ Constructor ============
6537 
6538     constructor(
6539         address margin
6540     )
6541         public
6542     {
6543         DYDX_MARGIN = margin;
6544     }
6545 
6546     // ============ Public Functions ============
6547 
6548     /**
6549      * Using the Dutch Auction mechanism, bids on a position that is currently closing.
6550      * Calculates the maximum close amount for a position, exchange, and order.
6551      *
6552      * @param  positionId       Unique ID of the position
6553      * @param  minCloseAmount   The minimum acceptable close amount
6554      * @param  dutchAuction     The address of the Dutch Auction contract to use
6555      * @param  exchangeWrapper  The address of the Exchange Wrapper (and Exchange Reader) to use
6556      * @param  orderData        The order data to pass to the Exchange Wrapper
6557      * @return                  The principal amount of the position that was closed
6558      */
6559     function closePosition(
6560         bytes32 positionId,
6561         uint256 minCloseAmount,
6562         address dutchAuction,
6563         address exchangeWrapper,
6564         bytes   orderData
6565     )
6566         external
6567         returns (uint256)
6568     {
6569         Margin margin = Margin(DYDX_MARGIN);
6570 
6571         if (!margin.containsPosition(positionId)) {
6572             return 0; // if position is closed, return zero instead of throwing
6573         }
6574 
6575         Position memory position = parsePosition(margin, positionId);
6576         uint256 maxCloseAmount = getMaxCloseAmount(position, exchangeWrapper, orderData);
6577 
6578         if (maxCloseAmount == 0) {
6579             return 0; // if order cannot be used, return zero instead of throwing
6580         }
6581 
6582         if (maxCloseAmount < minCloseAmount) {
6583             return 0; // if order is already taken, return zero instead of throwing
6584         }
6585 
6586         margin.closePosition(
6587             positionId,
6588             maxCloseAmount,
6589             dutchAuction,
6590             exchangeWrapper,
6591             true, // payoutInHeldToken
6592             orderData
6593         );
6594 
6595         // give all tokens to the owner
6596         uint256 heldTokenAmount = position.heldToken.balanceOf(address(this));
6597         position.heldToken.transfer(position.owner, heldTokenAmount);
6598 
6599         return maxCloseAmount;
6600     }
6601 
6602     // ============ Private Functions ============
6603 
6604     function parsePosition (
6605         Margin margin,
6606         bytes32 positionId
6607     )
6608         private
6609         view
6610         returns (Position memory)
6611     {
6612         Position memory position;
6613         position.heldToken = margin.getPositionHeldToken(positionId);
6614         position.owedToken = margin.getPositionOwedToken(positionId);
6615         position.owner = margin.getPositionOwner(positionId);
6616         position.principal = margin.getPositionPrincipal(positionId);
6617         position.owedTokenOwed = margin.getPositionOwedAmount(positionId);
6618         return position;
6619     }
6620 
6621     function getMaxCloseAmount(
6622         Position memory position,
6623         address exchangeWrapper,
6624         bytes orderData
6625     )
6626         private
6627         view
6628         returns (uint256)
6629     {
6630         uint256 makerTokenAmount = ExchangeReader(exchangeWrapper).getMaxMakerAmount(
6631             position.owedToken,
6632             position.heldToken,
6633             orderData
6634         );
6635 
6636         // get maximum close amount
6637         uint256 closeAmount = MathHelpers.getPartialAmount(
6638             position.principal,
6639             position.owedTokenOwed,
6640             makerTokenAmount
6641         );
6642 
6643         return closeAmount;
6644     }
6645 }