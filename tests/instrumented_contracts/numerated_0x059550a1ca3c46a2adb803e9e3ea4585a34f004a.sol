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
22 // File: canonical-weth/contracts/WETH9.sol
23 
24 contract WETH9 {
25     string public name     = "Wrapped Ether";
26     string public symbol   = "WETH";
27     uint8  public decimals = 18;
28 
29     event  Approval(address indexed src, address indexed guy, uint wad);
30     event  Transfer(address indexed src, address indexed dst, uint wad);
31     event  Deposit(address indexed dst, uint wad);
32     event  Withdrawal(address indexed src, uint wad);
33 
34     mapping (address => uint)                       public  balanceOf;
35     mapping (address => mapping (address => uint))  public  allowance;
36 
37     function() external payable {
38         deposit();
39     }
40     function deposit() public payable {
41         balanceOf[msg.sender] += msg.value;
42         emit Deposit(msg.sender, msg.value);
43     }
44     function withdraw(uint wad) public {
45         require(balanceOf[msg.sender] >= wad);
46         balanceOf[msg.sender] -= wad;
47         msg.sender.transfer(wad);
48         emit Withdrawal(msg.sender, wad);
49     }
50 
51     function totalSupply() public view returns (uint) {
52         return address(this).balance;
53     }
54 
55     function approve(address guy, uint wad) public returns (bool) {
56         allowance[msg.sender][guy] = wad;
57         emit Approval(msg.sender, guy, wad);
58         return true;
59     }
60 
61     function transfer(address dst, uint wad) public returns (bool) {
62         return transferFrom(msg.sender, dst, wad);
63     }
64 
65     function transferFrom(address src, address dst, uint wad)
66         public
67         returns (bool)
68     {
69         require(balanceOf[src] >= wad);
70 
71         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
72             require(allowance[src][msg.sender] >= wad);
73             allowance[src][msg.sender] -= wad;
74         }
75 
76         balanceOf[src] -= wad;
77         balanceOf[dst] += wad;
78 
79         emit Transfer(src, dst, wad);
80 
81         return true;
82     }
83 }
84 
85 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
97     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
98     // benefit is lost if 'b' is also tested.
99     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100     if (_a == 0) {
101       return 0;
102     }
103 
104     c = _a * _b;
105     assert(c / _a == _b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     // assert(_b > 0); // Solidity automatically throws when dividing by 0
114     // uint256 c = _a / _b;
115     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
116     return _a / _b;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
123     assert(_b <= _a);
124     return _a - _b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
131     c = _a + _b;
132     assert(c >= _a);
133     return c;
134   }
135 }
136 
137 // File: openzeppelin-solidity/contracts/math/Math.sol
138 
139 /**
140  * @title Math
141  * @dev Assorted math operations
142  */
143 library Math {
144   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
145     return _a >= _b ? _a : _b;
146   }
147 
148   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
149     return _a < _b ? _a : _b;
150   }
151 
152   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
153     return _a >= _b ? _a : _b;
154   }
155 
156   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
157     return _a < _b ? _a : _b;
158   }
159 }
160 
161 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
162 
163 /**
164  * @title Ownable
165  * @dev The Ownable contract has an owner address, and provides basic authorization control
166  * functions, this simplifies the implementation of "user permissions".
167  */
168 contract Ownable {
169   address public owner;
170 
171   event OwnershipRenounced(address indexed previousOwner);
172   event OwnershipTransferred(
173     address indexed previousOwner,
174     address indexed newOwner
175   );
176 
177   /**
178    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
179    * account.
180    */
181   constructor() public {
182     owner = msg.sender;
183   }
184 
185   /**
186    * @dev Throws if called by any account other than the owner.
187    */
188   modifier onlyOwner() {
189     require(msg.sender == owner);
190     _;
191   }
192 
193   /**
194    * @dev Allows the current owner to relinquish control of the contract.
195    * @notice Renouncing to ownership will leave the contract without an owner.
196    * It will not be possible to call the functions with the `onlyOwner`
197    * modifier anymore.
198    */
199   function renounceOwnership() public onlyOwner {
200     emit OwnershipRenounced(owner);
201     owner = address(0);
202   }
203 
204   /**
205    * @dev Allows the current owner to transfer control of the contract to a newOwner.
206    * @param _newOwner The address to transfer ownership to.
207    */
208   function transferOwnership(address _newOwner) public onlyOwner {
209     _transferOwnership(_newOwner);
210   }
211 
212   /**
213    * @dev Transfers control of the contract to a newOwner.
214    * @param _newOwner The address to transfer ownership to.
215    */
216   function _transferOwnership(address _newOwner) internal {
217     require(_newOwner != address(0));
218     emit OwnershipTransferred(owner, _newOwner);
219     owner = _newOwner;
220   }
221 }
222 
223 // File: contracts/lib/AccessControlledBase.sol
224 
225 /**
226  * @title AccessControlledBase
227  * @author dYdX
228  *
229  * Base functionality for access control. Requires an implementation to
230  * provide a way to grant and optionally revoke access
231  */
232 contract AccessControlledBase {
233     // ============ State Variables ============
234 
235     mapping (address => bool) public authorized;
236 
237     // ============ Events ============
238 
239     event AccessGranted(
240         address who
241     );
242 
243     event AccessRevoked(
244         address who
245     );
246 
247     // ============ Modifiers ============
248 
249     modifier requiresAuthorization() {
250         require(
251             authorized[msg.sender],
252             "AccessControlledBase#requiresAuthorization: Sender not authorized"
253         );
254         _;
255     }
256 }
257 
258 // File: contracts/lib/StaticAccessControlled.sol
259 
260 /**
261  * @title StaticAccessControlled
262  * @author dYdX
263  *
264  * Allows for functions to be access controled
265  * Permissions cannot be changed after a grace period
266  */
267 contract StaticAccessControlled is AccessControlledBase, Ownable {
268     using SafeMath for uint256;
269 
270     // ============ State Variables ============
271 
272     // Timestamp after which no additional access can be granted
273     uint256 public GRACE_PERIOD_EXPIRATION;
274 
275     // ============ Constructor ============
276 
277     constructor(
278         uint256 gracePeriod
279     )
280         public
281         Ownable()
282     {
283         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
284     }
285 
286     // ============ Owner-Only State-Changing Functions ============
287 
288     function grantAccess(
289         address who
290     )
291         external
292         onlyOwner
293     {
294         require(
295             block.timestamp < GRACE_PERIOD_EXPIRATION,
296             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
297         );
298 
299         emit AccessGranted(who);
300         authorized[who] = true;
301     }
302 }
303 
304 // File: contracts/lib/GeneralERC20.sol
305 
306 /**
307  * @title GeneralERC20
308  * @author dYdX
309  *
310  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
311  * that we dont automatically revert when calling non-compliant tokens that have no return value for
312  * transfer(), transferFrom(), or approve().
313  */
314 interface GeneralERC20 {
315     function totalSupply(
316     )
317         external
318         view
319         returns (uint256);
320 
321     function balanceOf(
322         address who
323     )
324         external
325         view
326         returns (uint256);
327 
328     function allowance(
329         address owner,
330         address spender
331     )
332         external
333         view
334         returns (uint256);
335 
336     function transfer(
337         address to,
338         uint256 value
339     )
340         external;
341 
342     function transferFrom(
343         address from,
344         address to,
345         uint256 value
346     )
347         external;
348 
349     function approve(
350         address spender,
351         uint256 value
352     )
353         external;
354 }
355 
356 // File: contracts/lib/TokenInteract.sol
357 
358 /**
359  * @title TokenInteract
360  * @author dYdX
361  *
362  * This library contains functions for interacting with ERC20 tokens
363  */
364 library TokenInteract {
365     function balanceOf(
366         address token,
367         address owner
368     )
369         internal
370         view
371         returns (uint256)
372     {
373         return GeneralERC20(token).balanceOf(owner);
374     }
375 
376     function allowance(
377         address token,
378         address owner,
379         address spender
380     )
381         internal
382         view
383         returns (uint256)
384     {
385         return GeneralERC20(token).allowance(owner, spender);
386     }
387 
388     function approve(
389         address token,
390         address spender,
391         uint256 amount
392     )
393         internal
394     {
395         GeneralERC20(token).approve(spender, amount);
396 
397         require(
398             checkSuccess(),
399             "TokenInteract#approve: Approval failed"
400         );
401     }
402 
403     function transfer(
404         address token,
405         address to,
406         uint256 amount
407     )
408         internal
409     {
410         address from = address(this);
411         if (
412             amount == 0
413             || from == to
414         ) {
415             return;
416         }
417 
418         GeneralERC20(token).transfer(to, amount);
419 
420         require(
421             checkSuccess(),
422             "TokenInteract#transfer: Transfer failed"
423         );
424     }
425 
426     function transferFrom(
427         address token,
428         address from,
429         address to,
430         uint256 amount
431     )
432         internal
433     {
434         if (
435             amount == 0
436             || from == to
437         ) {
438             return;
439         }
440 
441         GeneralERC20(token).transferFrom(from, to, amount);
442 
443         require(
444             checkSuccess(),
445             "TokenInteract#transferFrom: TransferFrom failed"
446         );
447     }
448 
449     // ============ Private Helper-Functions ============
450 
451     /**
452      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
453      * function returned 0 bytes or 32 bytes that are not all-zero.
454      */
455     function checkSuccess(
456     )
457         private
458         pure
459         returns (bool)
460     {
461         uint256 returnValue = 0;
462 
463         /* solium-disable-next-line security/no-inline-assembly */
464         assembly {
465             // check number of bytes returned from last function call
466             switch returndatasize
467 
468             // no bytes returned: assume success
469             case 0x0 {
470                 returnValue := 1
471             }
472 
473             // 32 bytes returned: check if non-zero
474             case 0x20 {
475                 // copy 32 bytes into scratch space
476                 returndatacopy(0x0, 0x0, 0x20)
477 
478                 // load those bytes into returnValue
479                 returnValue := mload(0x0)
480             }
481 
482             // not sure what was returned: dont mark as success
483             default { }
484         }
485 
486         return returnValue != 0;
487     }
488 }
489 
490 // File: contracts/margin/TokenProxy.sol
491 
492 /**
493  * @title TokenProxy
494  * @author dYdX
495  *
496  * Used to transfer tokens between addresses which have set allowance on this contract.
497  */
498 contract TokenProxy is StaticAccessControlled {
499     using SafeMath for uint256;
500 
501     // ============ Constructor ============
502 
503     constructor(
504         uint256 gracePeriod
505     )
506         public
507         StaticAccessControlled(gracePeriod)
508     {}
509 
510     // ============ Authorized-Only State Changing Functions ============
511 
512     /**
513      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
514      *
515      * @param  token  The address of the ERC20 token
516      * @param  from   The address to transfer token from
517      * @param  to     The address to transfer tokens to
518      * @param  value  The number of tokens to transfer
519      */
520     function transferTokens(
521         address token,
522         address from,
523         address to,
524         uint256 value
525     )
526         external
527         requiresAuthorization
528     {
529         TokenInteract.transferFrom(
530             token,
531             from,
532             to,
533             value
534         );
535     }
536 
537     // ============ Public Constant Functions ============
538 
539     /**
540      * Getter function to get the amount of token that the proxy is able to move for a particular
541      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
542      *
543      * @param  who    The owner of the tokens
544      * @param  token  The address of the ERC20 token
545      * @return        The number of tokens able to be moved by the proxy from the address specified
546      */
547     function available(
548         address who,
549         address token
550     )
551         external
552         view
553         returns (uint256)
554     {
555         return Math.min256(
556             TokenInteract.allowance(token, who, address(this)),
557             TokenInteract.balanceOf(token, who)
558         );
559     }
560 }
561 
562 // File: contracts/margin/Vault.sol
563 
564 /**
565  * @title Vault
566  * @author dYdX
567  *
568  * Holds and transfers tokens in vaults denominated by id
569  *
570  * Vault only supports ERC20 tokens, and will not accept any tokens that require
571  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
572  */
573 contract Vault is StaticAccessControlled
574 {
575     using SafeMath for uint256;
576 
577     // ============ Events ============
578 
579     event ExcessTokensWithdrawn(
580         address indexed token,
581         address indexed to,
582         address caller
583     );
584 
585     // ============ State Variables ============
586 
587     // Address of the TokenProxy contract. Used for moving tokens.
588     address public TOKEN_PROXY;
589 
590     // Map from vault ID to map from token address to amount of that token attributed to the
591     // particular vault ID.
592     mapping (bytes32 => mapping (address => uint256)) public balances;
593 
594     // Map from token address to total amount of that token attributed to some account.
595     mapping (address => uint256) public totalBalances;
596 
597     // ============ Constructor ============
598 
599     constructor(
600         address proxy,
601         uint256 gracePeriod
602     )
603         public
604         StaticAccessControlled(gracePeriod)
605     {
606         TOKEN_PROXY = proxy;
607     }
608 
609     // ============ Owner-Only State-Changing Functions ============
610 
611     /**
612      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
613      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
614      * will be accounted for and will not be withdrawable by this function.
615      *
616      * @param  token  ERC20 token address
617      * @param  to     Address to transfer tokens to
618      * @return        Amount of tokens withdrawn
619      */
620     function withdrawExcessToken(
621         address token,
622         address to
623     )
624         external
625         onlyOwner
626         returns (uint256)
627     {
628         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
629         uint256 accountedBalance = totalBalances[token];
630         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
631 
632         require(
633             withdrawableBalance != 0,
634             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
635         );
636 
637         TokenInteract.transfer(token, to, withdrawableBalance);
638 
639         emit ExcessTokensWithdrawn(token, to, msg.sender);
640 
641         return withdrawableBalance;
642     }
643 
644     // ============ Authorized-Only State-Changing Functions ============
645 
646     /**
647      * Transfers tokens from an address (that has approved the proxy) to the vault.
648      *
649      * @param  id      The vault which will receive the tokens
650      * @param  token   ERC20 token address
651      * @param  from    Address from which the tokens will be taken
652      * @param  amount  Number of the token to be sent
653      */
654     function transferToVault(
655         bytes32 id,
656         address token,
657         address from,
658         uint256 amount
659     )
660         external
661         requiresAuthorization
662     {
663         // First send tokens to this contract
664         TokenProxy(TOKEN_PROXY).transferTokens(
665             token,
666             from,
667             address(this),
668             amount
669         );
670 
671         // Then increment balances
672         balances[id][token] = balances[id][token].add(amount);
673         totalBalances[token] = totalBalances[token].add(amount);
674 
675         // This should always be true. If not, something is very wrong
676         assert(totalBalances[token] >= balances[id][token]);
677 
678         validateBalance(token);
679     }
680 
681     /**
682      * Transfers a certain amount of funds to an address.
683      *
684      * @param  id      The vault from which to send the tokens
685      * @param  token   ERC20 token address
686      * @param  to      Address to transfer tokens to
687      * @param  amount  Number of the token to be sent
688      */
689     function transferFromVault(
690         bytes32 id,
691         address token,
692         address to,
693         uint256 amount
694     )
695         external
696         requiresAuthorization
697     {
698         // Next line also asserts that (balances[id][token] >= amount);
699         balances[id][token] = balances[id][token].sub(amount);
700 
701         // Next line also asserts that (totalBalances[token] >= amount);
702         totalBalances[token] = totalBalances[token].sub(amount);
703 
704         // This should always be true. If not, something is very wrong
705         assert(totalBalances[token] >= balances[id][token]);
706 
707         // Do the sending
708         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
709 
710         // Final validation
711         validateBalance(token);
712     }
713 
714     // ============ Private Helper-Functions ============
715 
716     /**
717      * Verifies that this contract is in control of at least as many tokens as accounted for
718      *
719      * @param  token  Address of ERC20 token
720      */
721     function validateBalance(
722         address token
723     )
724         private
725         view
726     {
727         // The actual balance could be greater than totalBalances[token] because anyone
728         // can send tokens to the contract's address which cannot be accounted for
729         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
730     }
731 }
732 
733 // File: contracts/lib/ReentrancyGuard.sol
734 
735 /**
736  * @title ReentrancyGuard
737  * @author dYdX
738  *
739  * Optimized version of the well-known ReentrancyGuard contract
740  */
741 contract ReentrancyGuard {
742     uint256 private _guardCounter = 1;
743 
744     modifier nonReentrant() {
745         uint256 localCounter = _guardCounter + 1;
746         _guardCounter = localCounter;
747         _;
748         require(
749             _guardCounter == localCounter,
750             "Reentrancy check failure"
751         );
752     }
753 }
754 
755 // File: openzeppelin-solidity/contracts/AddressUtils.sol
756 
757 /**
758  * Utility library of inline functions on addresses
759  */
760 library AddressUtils {
761 
762   /**
763    * Returns whether the target address is a contract
764    * @dev This function will return false if invoked during the constructor of a contract,
765    * as the code is not actually created until after the constructor finishes.
766    * @param _addr address to check
767    * @return whether the target address is a contract
768    */
769   function isContract(address _addr) internal view returns (bool) {
770     uint256 size;
771     // XXX Currently there is no better way to check if there is a contract in an address
772     // than to check the size of the code at that address.
773     // See https://ethereum.stackexchange.com/a/14016/36603
774     // for more details about how this works.
775     // TODO Check this again before the Serenity release, because all addresses will be
776     // contracts then.
777     // solium-disable-next-line security/no-inline-assembly
778     assembly { size := extcodesize(_addr) }
779     return size > 0;
780   }
781 
782 }
783 
784 // File: contracts/lib/Fraction.sol
785 
786 /**
787  * @title Fraction
788  * @author dYdX
789  *
790  * This library contains implementations for fraction structs.
791  */
792 library Fraction {
793     struct Fraction128 {
794         uint128 num;
795         uint128 den;
796     }
797 }
798 
799 // File: contracts/lib/FractionMath.sol
800 
801 /**
802  * @title FractionMath
803  * @author dYdX
804  *
805  * This library contains safe math functions for manipulating fractions.
806  */
807 library FractionMath {
808     using SafeMath for uint256;
809     using SafeMath for uint128;
810 
811     /**
812      * Returns a Fraction128 that is equal to a + b
813      *
814      * @param  a  The first Fraction128
815      * @param  b  The second Fraction128
816      * @return    The result (sum)
817      */
818     function add(
819         Fraction.Fraction128 memory a,
820         Fraction.Fraction128 memory b
821     )
822         internal
823         pure
824         returns (Fraction.Fraction128 memory)
825     {
826         uint256 left = a.num.mul(b.den);
827         uint256 right = b.num.mul(a.den);
828         uint256 denominator = a.den.mul(b.den);
829 
830         // if left + right overflows, prevent overflow
831         if (left + right < left) {
832             left = left.div(2);
833             right = right.div(2);
834             denominator = denominator.div(2);
835         }
836 
837         return bound(left.add(right), denominator);
838     }
839 
840     /**
841      * Returns a Fraction128 that is equal to a - (1/2)^d
842      *
843      * @param  a  The Fraction128
844      * @param  d  The power of (1/2)
845      * @return    The result
846      */
847     function sub1Over(
848         Fraction.Fraction128 memory a,
849         uint128 d
850     )
851         internal
852         pure
853         returns (Fraction.Fraction128 memory)
854     {
855         if (a.den % d == 0) {
856             return bound(
857                 a.num.sub(a.den.div(d)),
858                 a.den
859             );
860         }
861         return bound(
862             a.num.mul(d).sub(a.den),
863             a.den.mul(d)
864         );
865     }
866 
867     /**
868      * Returns a Fraction128 that is equal to a / d
869      *
870      * @param  a  The first Fraction128
871      * @param  d  The divisor
872      * @return    The result (quotient)
873      */
874     function div(
875         Fraction.Fraction128 memory a,
876         uint128 d
877     )
878         internal
879         pure
880         returns (Fraction.Fraction128 memory)
881     {
882         if (a.num % d == 0) {
883             return bound(
884                 a.num.div(d),
885                 a.den
886             );
887         }
888         return bound(
889             a.num,
890             a.den.mul(d)
891         );
892     }
893 
894     /**
895      * Returns a Fraction128 that is equal to a * b.
896      *
897      * @param  a  The first Fraction128
898      * @param  b  The second Fraction128
899      * @return    The result (product)
900      */
901     function mul(
902         Fraction.Fraction128 memory a,
903         Fraction.Fraction128 memory b
904     )
905         internal
906         pure
907         returns (Fraction.Fraction128 memory)
908     {
909         return bound(
910             a.num.mul(b.num),
911             a.den.mul(b.den)
912         );
913     }
914 
915     /**
916      * Returns a fraction from two uint256's. Fits them into uint128 if necessary.
917      *
918      * @param  num  The numerator
919      * @param  den  The denominator
920      * @return      The Fraction128 that matches num/den most closely
921      */
922     /* solium-disable-next-line security/no-assign-params */
923     function bound(
924         uint256 num,
925         uint256 den
926     )
927         internal
928         pure
929         returns (Fraction.Fraction128 memory)
930     {
931         uint256 max = num > den ? num : den;
932         uint256 first128Bits = (max >> 128);
933         if (first128Bits != 0) {
934             first128Bits += 1;
935             num /= first128Bits;
936             den /= first128Bits;
937         }
938 
939         assert(den != 0); // coverage-enable-line
940         assert(den < 2**128);
941         assert(num < 2**128);
942 
943         return Fraction.Fraction128({
944             num: uint128(num),
945             den: uint128(den)
946         });
947     }
948 
949     /**
950      * Returns an in-memory copy of a Fraction128
951      *
952      * @param  a  The Fraction128 to copy
953      * @return    A copy of the Fraction128
954      */
955     function copy(
956         Fraction.Fraction128 memory a
957     )
958         internal
959         pure
960         returns (Fraction.Fraction128 memory)
961     {
962         validate(a);
963         return Fraction.Fraction128({ num: a.num, den: a.den });
964     }
965 
966     // ============ Private Helper-Functions ============
967 
968     /**
969      * Asserts that a Fraction128 is valid (i.e. the denominator is non-zero)
970      *
971      * @param  a  The Fraction128 to validate
972      */
973     function validate(
974         Fraction.Fraction128 memory a
975     )
976         private
977         pure
978     {
979         assert(a.den != 0); // coverage-enable-line
980     }
981 }
982 
983 // File: contracts/lib/Exponent.sol
984 
985 /**
986  * @title Exponent
987  * @author dYdX
988  *
989  * This library contains an implementation for calculating e^X for arbitrary fraction X
990  */
991 library Exponent {
992     using SafeMath for uint256;
993     using FractionMath for Fraction.Fraction128;
994 
995     // ============ Constants ============
996 
997     // 2**128 - 1
998     uint128 constant public MAX_NUMERATOR = 340282366920938463463374607431768211455;
999 
1000     // Number of precomputed integers, X, for E^((1/2)^X)
1001     uint256 constant public MAX_PRECOMPUTE_PRECISION = 32;
1002 
1003     // Number of precomputed integers, X, for E^X
1004     uint256 constant public NUM_PRECOMPUTED_INTEGERS = 32;
1005 
1006     // ============ Public Implementation Functions ============
1007 
1008     /**
1009      * Returns e^X for any fraction X
1010      *
1011      * @param  X                    The exponent
1012      * @param  precomputePrecision  Accuracy of precomputed terms
1013      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1014      * @return                      e^X
1015      */
1016     function exp(
1017         Fraction.Fraction128 memory X,
1018         uint256 precomputePrecision,
1019         uint256 maclaurinPrecision
1020     )
1021         internal
1022         pure
1023         returns (Fraction.Fraction128 memory)
1024     {
1025         require(
1026             precomputePrecision <= MAX_PRECOMPUTE_PRECISION,
1027             "Exponent#exp: Precompute precision over maximum"
1028         );
1029 
1030         Fraction.Fraction128 memory Xcopy = X.copy();
1031         if (Xcopy.num == 0) { // e^0 = 1
1032             return ONE();
1033         }
1034 
1035         // get the integer value of the fraction (example: 9/4 is 2.25 so has integerValue of 2)
1036         uint256 integerX = uint256(Xcopy.num).div(Xcopy.den);
1037 
1038         // if X is less than 1, then just calculate X
1039         if (integerX == 0) {
1040             return expHybrid(Xcopy, precomputePrecision, maclaurinPrecision);
1041         }
1042 
1043         // get e^integerX
1044         Fraction.Fraction128 memory expOfInt =
1045             getPrecomputedEToThe(integerX % NUM_PRECOMPUTED_INTEGERS);
1046         while (integerX >= NUM_PRECOMPUTED_INTEGERS) {
1047             expOfInt = expOfInt.mul(getPrecomputedEToThe(NUM_PRECOMPUTED_INTEGERS));
1048             integerX -= NUM_PRECOMPUTED_INTEGERS;
1049         }
1050 
1051         // multiply e^integerX by e^decimalX
1052         Fraction.Fraction128 memory decimalX = Fraction.Fraction128({
1053             num: Xcopy.num % Xcopy.den,
1054             den: Xcopy.den
1055         });
1056         return expHybrid(decimalX, precomputePrecision, maclaurinPrecision).mul(expOfInt);
1057     }
1058 
1059     /**
1060      * Returns e^X for any X < 1. Multiplies precomputed values to get close to the real value, then
1061      * Maclaurin Series approximation to reduce error.
1062      *
1063      * @param  X                    Exponent
1064      * @param  precomputePrecision  Accuracy of precomputed terms
1065      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1066      * @return                      e^X
1067      */
1068     function expHybrid(
1069         Fraction.Fraction128 memory X,
1070         uint256 precomputePrecision,
1071         uint256 maclaurinPrecision
1072     )
1073         internal
1074         pure
1075         returns (Fraction.Fraction128 memory)
1076     {
1077         assert(precomputePrecision <= MAX_PRECOMPUTE_PRECISION);
1078         assert(X.num < X.den);
1079         // will also throw if precomputePrecision is larger than the array length in getDenominator
1080 
1081         Fraction.Fraction128 memory Xtemp = X.copy();
1082         if (Xtemp.num == 0) { // e^0 = 1
1083             return ONE();
1084         }
1085 
1086         Fraction.Fraction128 memory result = ONE();
1087 
1088         uint256 d = 1; // 2^i
1089         for (uint256 i = 1; i <= precomputePrecision; i++) {
1090             d *= 2;
1091 
1092             // if Fraction > 1/d, subtract 1/d and multiply result by precomputed e^(1/d)
1093             if (d.mul(Xtemp.num) >= Xtemp.den) {
1094                 Xtemp = Xtemp.sub1Over(uint128(d));
1095                 result = result.mul(getPrecomputedEToTheHalfToThe(i));
1096             }
1097         }
1098         return result.mul(expMaclaurin(Xtemp, maclaurinPrecision));
1099     }
1100 
1101     /**
1102      * Returns e^X for any X, using Maclaurin Series approximation
1103      *
1104      * e^X = SUM(X^n / n!) for n >= 0
1105      * e^X = 1 + X/1! + X^2/2! + X^3/3! ...
1106      *
1107      * @param  X           Exponent
1108      * @param  precision   Accuracy of Maclaurin terms
1109      * @return             e^X
1110      */
1111     function expMaclaurin(
1112         Fraction.Fraction128 memory X,
1113         uint256 precision
1114     )
1115         internal
1116         pure
1117         returns (Fraction.Fraction128 memory)
1118     {
1119         Fraction.Fraction128 memory Xcopy = X.copy();
1120         if (Xcopy.num == 0) { // e^0 = 1
1121             return ONE();
1122         }
1123 
1124         Fraction.Fraction128 memory result = ONE();
1125         Fraction.Fraction128 memory Xtemp = ONE();
1126         for (uint256 i = 1; i <= precision; i++) {
1127             Xtemp = Xtemp.mul(Xcopy.div(uint128(i)));
1128             result = result.add(Xtemp);
1129         }
1130         return result;
1131     }
1132 
1133     /**
1134      * Returns a fraction roughly equaling E^((1/2)^x) for integer x
1135      */
1136     function getPrecomputedEToTheHalfToThe(
1137         uint256 x
1138     )
1139         internal
1140         pure
1141         returns (Fraction.Fraction128 memory)
1142     {
1143         assert(x <= MAX_PRECOMPUTE_PRECISION);
1144 
1145         uint128 denominator = [
1146             125182886983370532117250726298150828301,
1147             206391688497133195273760705512282642279,
1148             265012173823417992016237332255925138361,
1149             300298134811882980317033350418940119802,
1150             319665700530617779809390163992561606014,
1151             329812979126047300897653247035862915816,
1152             335006777809430963166468914297166288162,
1153             337634268532609249517744113622081347950,
1154             338955731696479810470146282672867036734,
1155             339618401537809365075354109784799900812,
1156             339950222128463181389559457827561204959,
1157             340116253979683015278260491021941090650,
1158             340199300311581465057079429423749235412,
1159             340240831081268226777032180141478221816,
1160             340261598367316729254995498374473399540,
1161             340271982485676106947851156443492415142,
1162             340277174663693808406010255284800906112,
1163             340279770782412691177936847400746725466,
1164             340281068849199706686796915841848278311,
1165             340281717884450116236033378667952410919,
1166             340282042402539547492367191008339680733,
1167             340282204661700319870089970029119685699,
1168             340282285791309720262481214385569134454,
1169             340282326356121674011576912006427792656,
1170             340282346638529464274601981200276914173,
1171             340282356779733812753265346086924801364,
1172             340282361850336100329388676752133324799,
1173             340282364385637272451648746721404212564,
1174             340282365653287865596328444437856608255,
1175             340282366287113163939555716675618384724,
1176             340282366604025813553891209601455838559,
1177             340282366762482138471739420386372790954,
1178             340282366841710300958333641874363209044
1179         ][x];
1180         return Fraction.Fraction128({
1181             num: MAX_NUMERATOR,
1182             den: denominator
1183         });
1184     }
1185 
1186     /**
1187      * Returns a fraction roughly equaling E^(x) for integer x
1188      */
1189     function getPrecomputedEToThe(
1190         uint256 x
1191     )
1192         internal
1193         pure
1194         returns (Fraction.Fraction128 memory)
1195     {
1196         assert(x <= NUM_PRECOMPUTED_INTEGERS);
1197 
1198         uint128 denominator = [
1199             340282366920938463463374607431768211455,
1200             125182886983370532117250726298150828301,
1201             46052210507670172419625860892627118820,
1202             16941661466271327126146327822211253888,
1203             6232488952727653950957829210887653621,
1204             2292804553036637136093891217529878878,
1205             843475657686456657683449904934172134,
1206             310297353591408453462393329342695980,
1207             114152017036184782947077973323212575,
1208             41994180235864621538772677139808695,
1209             15448795557622704876497742989562086,
1210             5683294276510101335127414470015662,
1211             2090767122455392675095471286328463,
1212             769150240628514374138961856925097,
1213             282954560699298259527814398449860,
1214             104093165666968799599694528310221,
1215             38293735615330848145349245349513,
1216             14087478058534870382224480725096,
1217             5182493555688763339001418388912,
1218             1906532833141383353974257736699,
1219             701374233231058797338605168652,
1220             258021160973090761055471434334,
1221             94920680509187392077350434438,
1222             34919366901332874995585576427,
1223             12846117181722897538509298435,
1224             4725822410035083116489797150,
1225             1738532907279185132707372378,
1226             639570514388029575350057932,
1227             235284843422800231081973821,
1228             86556456714490055457751527,
1229             31842340925906738090071268,
1230             11714142585413118080082437,
1231             4309392228124372433711936
1232         ][x];
1233         return Fraction.Fraction128({
1234             num: MAX_NUMERATOR,
1235             den: denominator
1236         });
1237     }
1238 
1239     // ============ Private Helper-Functions ============
1240 
1241     function ONE()
1242         private
1243         pure
1244         returns (Fraction.Fraction128 memory)
1245     {
1246         return Fraction.Fraction128({ num: 1, den: 1 });
1247     }
1248 }
1249 
1250 // File: contracts/lib/MathHelpers.sol
1251 
1252 /**
1253  * @title MathHelpers
1254  * @author dYdX
1255  *
1256  * This library helps with common math functions in Solidity
1257  */
1258 library MathHelpers {
1259     using SafeMath for uint256;
1260 
1261     /**
1262      * Calculates partial value given a numerator and denominator.
1263      *
1264      * @param  numerator    Numerator
1265      * @param  denominator  Denominator
1266      * @param  target       Value to calculate partial of
1267      * @return              target * numerator / denominator
1268      */
1269     function getPartialAmount(
1270         uint256 numerator,
1271         uint256 denominator,
1272         uint256 target
1273     )
1274         internal
1275         pure
1276         returns (uint256)
1277     {
1278         return numerator.mul(target).div(denominator);
1279     }
1280 
1281     /**
1282      * Calculates partial value given a numerator and denominator, rounded up.
1283      *
1284      * @param  numerator    Numerator
1285      * @param  denominator  Denominator
1286      * @param  target       Value to calculate partial of
1287      * @return              Rounded-up result of target * numerator / denominator
1288      */
1289     function getPartialAmountRoundedUp(
1290         uint256 numerator,
1291         uint256 denominator,
1292         uint256 target
1293     )
1294         internal
1295         pure
1296         returns (uint256)
1297     {
1298         return divisionRoundedUp(numerator.mul(target), denominator);
1299     }
1300 
1301     /**
1302      * Calculates division given a numerator and denominator, rounded up.
1303      *
1304      * @param  numerator    Numerator.
1305      * @param  denominator  Denominator.
1306      * @return              Rounded-up result of numerator / denominator
1307      */
1308     function divisionRoundedUp(
1309         uint256 numerator,
1310         uint256 denominator
1311     )
1312         internal
1313         pure
1314         returns (uint256)
1315     {
1316         assert(denominator != 0); // coverage-enable-line
1317         if (numerator == 0) {
1318             return 0;
1319         }
1320         return numerator.sub(1).div(denominator).add(1);
1321     }
1322 
1323     /**
1324      * Calculates and returns the maximum value for a uint256 in solidity
1325      *
1326      * @return  The maximum value for uint256
1327      */
1328     function maxUint256(
1329     )
1330         internal
1331         pure
1332         returns (uint256)
1333     {
1334         return 2 ** 256 - 1;
1335     }
1336 
1337     /**
1338      * Calculates and returns the maximum value for a uint256 in solidity
1339      *
1340      * @return  The maximum value for uint256
1341      */
1342     function maxUint32(
1343     )
1344         internal
1345         pure
1346         returns (uint32)
1347     {
1348         return 2 ** 32 - 1;
1349     }
1350 
1351     /**
1352      * Returns the number of bits in a uint256. That is, the lowest number, x, such that n >> x == 0
1353      *
1354      * @param  n  The uint256 to get the number of bits in
1355      * @return    The number of bits in n
1356      */
1357     function getNumBits(
1358         uint256 n
1359     )
1360         internal
1361         pure
1362         returns (uint256)
1363     {
1364         uint256 first = 0;
1365         uint256 last = 256;
1366         while (first < last) {
1367             uint256 check = (first + last) / 2;
1368             if ((n >> check) == 0) {
1369                 last = check;
1370             } else {
1371                 first = check + 1;
1372             }
1373         }
1374         assert(first <= 256);
1375         return first;
1376     }
1377 }
1378 
1379 // File: contracts/margin/impl/InterestImpl.sol
1380 
1381 /**
1382  * @title InterestImpl
1383  * @author dYdX
1384  *
1385  * A library that calculates continuously compounded interest for principal, time period, and
1386  * interest rate.
1387  */
1388 library InterestImpl {
1389     using SafeMath for uint256;
1390     using FractionMath for Fraction.Fraction128;
1391 
1392     // ============ Constants ============
1393 
1394     uint256 constant DEFAULT_PRECOMPUTE_PRECISION = 11;
1395 
1396     uint256 constant DEFAULT_MACLAURIN_PRECISION = 5;
1397 
1398     uint256 constant MAXIMUM_EXPONENT = 80;
1399 
1400     uint128 constant E_TO_MAXIUMUM_EXPONENT = 55406223843935100525711733958316613;
1401 
1402     // ============ Public Implementation Functions ============
1403 
1404     /**
1405      * Returns total tokens owed after accruing interest. Continuously compounding and accurate to
1406      * roughly 10^18 decimal places. Continuously compounding interest follows the formula:
1407      * I = P * e^(R*T)
1408      *
1409      * @param  principal           Principal of the interest calculation
1410      * @param  interestRate        Annual nominal interest percentage times 10**6.
1411      *                             (example: 5% = 5e6)
1412      * @param  secondsOfInterest   Number of seconds that interest has been accruing
1413      * @return                     Total amount of tokens owed. Greater than tokenAmount.
1414      */
1415     function getCompoundedInterest(
1416         uint256 principal,
1417         uint256 interestRate,
1418         uint256 secondsOfInterest
1419     )
1420         public
1421         pure
1422         returns (uint256)
1423     {
1424         uint256 numerator = interestRate.mul(secondsOfInterest);
1425         uint128 denominator = (10**8) * (365 * 1 days);
1426 
1427         // interestRate and secondsOfInterest should both be uint32
1428         assert(numerator < 2**128);
1429 
1430         // fraction representing (Rate * Time)
1431         Fraction.Fraction128 memory rt = Fraction.Fraction128({
1432             num: uint128(numerator),
1433             den: denominator
1434         });
1435 
1436         // calculate e^(RT)
1437         Fraction.Fraction128 memory eToRT;
1438         if (numerator.div(denominator) >= MAXIMUM_EXPONENT) {
1439             // degenerate case: cap calculation
1440             eToRT = Fraction.Fraction128({
1441                 num: E_TO_MAXIUMUM_EXPONENT,
1442                 den: 1
1443             });
1444         } else {
1445             // normal case: calculate e^(RT)
1446             eToRT = Exponent.exp(
1447                 rt,
1448                 DEFAULT_PRECOMPUTE_PRECISION,
1449                 DEFAULT_MACLAURIN_PRECISION
1450             );
1451         }
1452 
1453         // e^X for positive X should be greater-than or equal to 1
1454         assert(eToRT.num >= eToRT.den);
1455 
1456         return safeMultiplyUint256ByFraction(principal, eToRT);
1457     }
1458 
1459     // ============ Private Helper-Functions ============
1460 
1461     /**
1462      * Returns n * f, trying to prevent overflow as much as possible. Assumes that the numerator
1463      * and denominator of f are less than 2**128.
1464      */
1465     function safeMultiplyUint256ByFraction(
1466         uint256 n,
1467         Fraction.Fraction128 memory f
1468     )
1469         private
1470         pure
1471         returns (uint256)
1472     {
1473         uint256 term1 = n.div(2 ** 128); // first 128 bits
1474         uint256 term2 = n % (2 ** 128); // second 128 bits
1475 
1476         // uncommon scenario, requires n >= 2**128. calculates term1 = term1 * f
1477         if (term1 > 0) {
1478             term1 = term1.mul(f.num);
1479             uint256 numBits = MathHelpers.getNumBits(term1);
1480 
1481             // reduce rounding error by shifting all the way to the left before dividing
1482             term1 = MathHelpers.divisionRoundedUp(
1483                 term1 << (uint256(256).sub(numBits)),
1484                 f.den);
1485 
1486             // continue shifting or reduce shifting to get the right number
1487             if (numBits > 128) {
1488                 term1 = term1 << (numBits.sub(128));
1489             } else if (numBits < 128) {
1490                 term1 = term1 >> (uint256(128).sub(numBits));
1491             }
1492         }
1493 
1494         // calculates term2 = term2 * f
1495         term2 = MathHelpers.getPartialAmountRoundedUp(
1496             f.num,
1497             f.den,
1498             term2
1499         );
1500 
1501         return term1.add(term2);
1502     }
1503 }
1504 
1505 // File: contracts/margin/impl/MarginState.sol
1506 
1507 /**
1508  * @title MarginState
1509  * @author dYdX
1510  *
1511  * Contains state for the Margin contract. Also used by libraries that implement Margin functions.
1512  */
1513 library MarginState {
1514     struct State {
1515         // Address of the Vault contract
1516         address VAULT;
1517 
1518         // Address of the TokenProxy contract
1519         address TOKEN_PROXY;
1520 
1521         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1522         // already been filled.
1523         mapping (bytes32 => uint256) loanFills;
1524 
1525         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1526         // already been canceled.
1527         mapping (bytes32 => uint256) loanCancels;
1528 
1529         // Mapping from positionId -> Position, which stores all the open margin positions.
1530         mapping (bytes32 => MarginCommon.Position) positions;
1531 
1532         // Mapping from positionId -> bool, which stores whether the position has previously been
1533         // open, but is now closed.
1534         mapping (bytes32 => bool) closedPositions;
1535 
1536         // Mapping from positionId -> uint256, which stores the total amount of owedToken that has
1537         // ever been repaid to the lender for each position. Does not reset.
1538         mapping (bytes32 => uint256) totalOwedTokenRepaidToLender;
1539     }
1540 }
1541 
1542 // File: contracts/margin/interfaces/lender/LoanOwner.sol
1543 
1544 /**
1545  * @title LoanOwner
1546  * @author dYdX
1547  *
1548  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
1549  *
1550  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1551  *       to these functions
1552  */
1553 interface LoanOwner {
1554 
1555     // ============ Public Interface functions ============
1556 
1557     /**
1558      * Function a contract must implement in order to receive ownership of a loan sell via the
1559      * transferLoan function or the atomic-assign to the "owner" field in a loan offering.
1560      *
1561      * @param  from        Address of the previous owner
1562      * @param  positionId  Unique ID of the position
1563      * @return             This address to keep ownership, a different address to pass-on ownership
1564      */
1565     function receiveLoanOwnership(
1566         address from,
1567         bytes32 positionId
1568     )
1569         external
1570         /* onlyMargin */
1571         returns (address);
1572 }
1573 
1574 // File: contracts/margin/interfaces/owner/PositionOwner.sol
1575 
1576 /**
1577  * @title PositionOwner
1578  * @author dYdX
1579  *
1580  * Interface that smart contracts must implement in order to own position on behalf of other
1581  * accounts
1582  *
1583  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1584  *       to these functions
1585  */
1586 interface PositionOwner {
1587 
1588     // ============ Public Interface functions ============
1589 
1590     /**
1591      * Function a contract must implement in order to receive ownership of a position via the
1592      * transferPosition function or the atomic-assign to the "owner" field when opening a position.
1593      *
1594      * @param  from        Address of the previous owner
1595      * @param  positionId  Unique ID of the position
1596      * @return             This address to keep ownership, a different address to pass-on ownership
1597      */
1598     function receivePositionOwnership(
1599         address from,
1600         bytes32 positionId
1601     )
1602         external
1603         /* onlyMargin */
1604         returns (address);
1605 }
1606 
1607 // File: contracts/margin/impl/TransferInternal.sol
1608 
1609 /**
1610  * @title TransferInternal
1611  * @author dYdX
1612  *
1613  * This library contains the implementation for transferring ownership of loans and positions.
1614  */
1615 library TransferInternal {
1616 
1617     // ============ Events ============
1618 
1619     /**
1620      * Ownership of a loan was transferred to a new address
1621      */
1622     event LoanTransferred(
1623         bytes32 indexed positionId,
1624         address indexed from,
1625         address indexed to
1626     );
1627 
1628     /**
1629      * Ownership of a postion was transferred to a new address
1630      */
1631     event PositionTransferred(
1632         bytes32 indexed positionId,
1633         address indexed from,
1634         address indexed to
1635     );
1636 
1637     // ============ Internal Implementation Functions ============
1638 
1639     /**
1640      * Returns either the address of the new loan owner, or the address to which they wish to
1641      * pass ownership of the loan. This function does not actually set the state of the position
1642      *
1643      * @param  positionId  The Unique ID of the position
1644      * @param  oldOwner    The previous owner of the loan
1645      * @param  newOwner    The intended owner of the loan
1646      * @return             The address that the intended owner wishes to assign the loan to (may be
1647      *                     the same as the intended owner).
1648      */
1649     function grantLoanOwnership(
1650         bytes32 positionId,
1651         address oldOwner,
1652         address newOwner
1653     )
1654         internal
1655         returns (address)
1656     {
1657         // log event except upon position creation
1658         if (oldOwner != address(0)) {
1659             emit LoanTransferred(positionId, oldOwner, newOwner);
1660         }
1661 
1662         if (AddressUtils.isContract(newOwner)) {
1663             address nextOwner =
1664                 LoanOwner(newOwner).receiveLoanOwnership(oldOwner, positionId);
1665             if (nextOwner != newOwner) {
1666                 return grantLoanOwnership(positionId, newOwner, nextOwner);
1667             }
1668         }
1669 
1670         require(
1671             newOwner != address(0),
1672             "TransferInternal#grantLoanOwnership: New owner did not consent to owning loan"
1673         );
1674 
1675         return newOwner;
1676     }
1677 
1678     /**
1679      * Returns either the address of the new position owner, or the address to which they wish to
1680      * pass ownership of the position. This function does not actually set the state of the position
1681      *
1682      * @param  positionId  The Unique ID of the position
1683      * @param  oldOwner    The previous owner of the position
1684      * @param  newOwner    The intended owner of the position
1685      * @return             The address that the intended owner wishes to assign the position to (may
1686      *                     be the same as the intended owner).
1687      */
1688     function grantPositionOwnership(
1689         bytes32 positionId,
1690         address oldOwner,
1691         address newOwner
1692     )
1693         internal
1694         returns (address)
1695     {
1696         // log event except upon position creation
1697         if (oldOwner != address(0)) {
1698             emit PositionTransferred(positionId, oldOwner, newOwner);
1699         }
1700 
1701         if (AddressUtils.isContract(newOwner)) {
1702             address nextOwner =
1703                 PositionOwner(newOwner).receivePositionOwnership(oldOwner, positionId);
1704             if (nextOwner != newOwner) {
1705                 return grantPositionOwnership(positionId, newOwner, nextOwner);
1706             }
1707         }
1708 
1709         require(
1710             newOwner != address(0),
1711             "TransferInternal#grantPositionOwnership: New owner did not consent to owning position"
1712         );
1713 
1714         return newOwner;
1715     }
1716 }
1717 
1718 // File: contracts/lib/TimestampHelper.sol
1719 
1720 /**
1721  * @title TimestampHelper
1722  * @author dYdX
1723  *
1724  * Helper to get block timestamps in other formats
1725  */
1726 library TimestampHelper {
1727     function getBlockTimestamp32()
1728         internal
1729         view
1730         returns (uint32)
1731     {
1732         // Should not still be in-use in the year 2106
1733         assert(uint256(uint32(block.timestamp)) == block.timestamp);
1734 
1735         assert(block.timestamp > 0);
1736 
1737         return uint32(block.timestamp);
1738     }
1739 }
1740 
1741 // File: contracts/margin/impl/MarginCommon.sol
1742 
1743 /**
1744  * @title MarginCommon
1745  * @author dYdX
1746  *
1747  * This library contains common functions for implementations of public facing Margin functions
1748  */
1749 library MarginCommon {
1750     using SafeMath for uint256;
1751 
1752     // ============ Structs ============
1753 
1754     struct Position {
1755         address owedToken;       // Immutable
1756         address heldToken;       // Immutable
1757         address lender;
1758         address owner;
1759         uint256 principal;
1760         uint256 requiredDeposit;
1761         uint32  callTimeLimit;   // Immutable
1762         uint32  startTimestamp;  // Immutable, cannot be 0
1763         uint32  callTimestamp;
1764         uint32  maxDuration;     // Immutable
1765         uint32  interestRate;    // Immutable
1766         uint32  interestPeriod;  // Immutable
1767     }
1768 
1769     struct LoanOffering {
1770         address   owedToken;
1771         address   heldToken;
1772         address   payer;
1773         address   owner;
1774         address   taker;
1775         address   positionOwner;
1776         address   feeRecipient;
1777         address   lenderFeeToken;
1778         address   takerFeeToken;
1779         LoanRates rates;
1780         uint256   expirationTimestamp;
1781         uint32    callTimeLimit;
1782         uint32    maxDuration;
1783         uint256   salt;
1784         bytes32   loanHash;
1785         bytes     signature;
1786     }
1787 
1788     struct LoanRates {
1789         uint256 maxAmount;
1790         uint256 minAmount;
1791         uint256 minHeldToken;
1792         uint256 lenderFee;
1793         uint256 takerFee;
1794         uint32  interestRate;
1795         uint32  interestPeriod;
1796     }
1797 
1798     // ============ Internal Implementation Functions ============
1799 
1800     function storeNewPosition(
1801         MarginState.State storage state,
1802         bytes32 positionId,
1803         Position memory position,
1804         address loanPayer
1805     )
1806         internal
1807     {
1808         assert(!positionHasExisted(state, positionId));
1809         assert(position.owedToken != address(0));
1810         assert(position.heldToken != address(0));
1811         assert(position.owedToken != position.heldToken);
1812         assert(position.owner != address(0));
1813         assert(position.lender != address(0));
1814         assert(position.maxDuration != 0);
1815         assert(position.interestPeriod <= position.maxDuration);
1816         assert(position.callTimestamp == 0);
1817         assert(position.requiredDeposit == 0);
1818 
1819         state.positions[positionId].owedToken = position.owedToken;
1820         state.positions[positionId].heldToken = position.heldToken;
1821         state.positions[positionId].principal = position.principal;
1822         state.positions[positionId].callTimeLimit = position.callTimeLimit;
1823         state.positions[positionId].startTimestamp = TimestampHelper.getBlockTimestamp32();
1824         state.positions[positionId].maxDuration = position.maxDuration;
1825         state.positions[positionId].interestRate = position.interestRate;
1826         state.positions[positionId].interestPeriod = position.interestPeriod;
1827 
1828         state.positions[positionId].owner = TransferInternal.grantPositionOwnership(
1829             positionId,
1830             (position.owner != msg.sender) ? msg.sender : address(0),
1831             position.owner
1832         );
1833 
1834         state.positions[positionId].lender = TransferInternal.grantLoanOwnership(
1835             positionId,
1836             (position.lender != loanPayer) ? loanPayer : address(0),
1837             position.lender
1838         );
1839     }
1840 
1841     function getPositionIdFromNonce(
1842         uint256 nonce
1843     )
1844         internal
1845         view
1846         returns (bytes32)
1847     {
1848         return keccak256(abi.encodePacked(msg.sender, nonce));
1849     }
1850 
1851     function getUnavailableLoanOfferingAmountImpl(
1852         MarginState.State storage state,
1853         bytes32 loanHash
1854     )
1855         internal
1856         view
1857         returns (uint256)
1858     {
1859         return state.loanFills[loanHash].add(state.loanCancels[loanHash]);
1860     }
1861 
1862     function cleanupPosition(
1863         MarginState.State storage state,
1864         bytes32 positionId
1865     )
1866         internal
1867     {
1868         delete state.positions[positionId];
1869         state.closedPositions[positionId] = true;
1870     }
1871 
1872     function calculateOwedAmount(
1873         Position storage position,
1874         uint256 closeAmount,
1875         uint256 endTimestamp
1876     )
1877         internal
1878         view
1879         returns (uint256)
1880     {
1881         uint256 timeElapsed = calculateEffectiveTimeElapsed(position, endTimestamp);
1882 
1883         return InterestImpl.getCompoundedInterest(
1884             closeAmount,
1885             position.interestRate,
1886             timeElapsed
1887         );
1888     }
1889 
1890     /**
1891      * Calculates time elapsed rounded up to the nearest interestPeriod
1892      */
1893     function calculateEffectiveTimeElapsed(
1894         Position storage position,
1895         uint256 timestamp
1896     )
1897         internal
1898         view
1899         returns (uint256)
1900     {
1901         uint256 elapsed = timestamp.sub(position.startTimestamp);
1902 
1903         // round up to interestPeriod
1904         uint256 period = position.interestPeriod;
1905         if (period > 1) {
1906             elapsed = MathHelpers.divisionRoundedUp(elapsed, period).mul(period);
1907         }
1908 
1909         // bound by maxDuration
1910         return Math.min256(
1911             elapsed,
1912             position.maxDuration
1913         );
1914     }
1915 
1916     function calculateLenderAmountForIncreasePosition(
1917         Position storage position,
1918         uint256 principalToAdd,
1919         uint256 endTimestamp
1920     )
1921         internal
1922         view
1923         returns (uint256)
1924     {
1925         uint256 timeElapsed = calculateEffectiveTimeElapsedForNewLender(position, endTimestamp);
1926 
1927         return InterestImpl.getCompoundedInterest(
1928             principalToAdd,
1929             position.interestRate,
1930             timeElapsed
1931         );
1932     }
1933 
1934     function getLoanOfferingHash(
1935         LoanOffering loanOffering
1936     )
1937         internal
1938         view
1939         returns (bytes32)
1940     {
1941         return keccak256(
1942             abi.encodePacked(
1943                 address(this),
1944                 loanOffering.owedToken,
1945                 loanOffering.heldToken,
1946                 loanOffering.payer,
1947                 loanOffering.owner,
1948                 loanOffering.taker,
1949                 loanOffering.positionOwner,
1950                 loanOffering.feeRecipient,
1951                 loanOffering.lenderFeeToken,
1952                 loanOffering.takerFeeToken,
1953                 getValuesHash(loanOffering)
1954             )
1955         );
1956     }
1957 
1958     function getPositionBalanceImpl(
1959         MarginState.State storage state,
1960         bytes32 positionId
1961     )
1962         internal
1963         view
1964         returns(uint256)
1965     {
1966         return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
1967     }
1968 
1969     function containsPositionImpl(
1970         MarginState.State storage state,
1971         bytes32 positionId
1972     )
1973         internal
1974         view
1975         returns (bool)
1976     {
1977         return state.positions[positionId].startTimestamp != 0;
1978     }
1979 
1980     function positionHasExisted(
1981         MarginState.State storage state,
1982         bytes32 positionId
1983     )
1984         internal
1985         view
1986         returns (bool)
1987     {
1988         return containsPositionImpl(state, positionId) || state.closedPositions[positionId];
1989     }
1990 
1991     function getPositionFromStorage(
1992         MarginState.State storage state,
1993         bytes32 positionId
1994     )
1995         internal
1996         view
1997         returns (Position storage)
1998     {
1999         Position storage position = state.positions[positionId];
2000 
2001         require(
2002             position.startTimestamp != 0,
2003             "MarginCommon#getPositionFromStorage: The position does not exist"
2004         );
2005 
2006         return position;
2007     }
2008 
2009     // ============ Private Helper-Functions ============
2010 
2011     /**
2012      * Calculates time elapsed rounded down to the nearest interestPeriod
2013      */
2014     function calculateEffectiveTimeElapsedForNewLender(
2015         Position storage position,
2016         uint256 timestamp
2017     )
2018         private
2019         view
2020         returns (uint256)
2021     {
2022         uint256 elapsed = timestamp.sub(position.startTimestamp);
2023 
2024         // round down to interestPeriod
2025         uint256 period = position.interestPeriod;
2026         if (period > 1) {
2027             elapsed = elapsed.div(period).mul(period);
2028         }
2029 
2030         // bound by maxDuration
2031         return Math.min256(
2032             elapsed,
2033             position.maxDuration
2034         );
2035     }
2036 
2037     function getValuesHash(
2038         LoanOffering loanOffering
2039     )
2040         private
2041         pure
2042         returns (bytes32)
2043     {
2044         return keccak256(
2045             abi.encodePacked(
2046                 loanOffering.rates.maxAmount,
2047                 loanOffering.rates.minAmount,
2048                 loanOffering.rates.minHeldToken,
2049                 loanOffering.rates.lenderFee,
2050                 loanOffering.rates.takerFee,
2051                 loanOffering.expirationTimestamp,
2052                 loanOffering.salt,
2053                 loanOffering.callTimeLimit,
2054                 loanOffering.maxDuration,
2055                 loanOffering.rates.interestRate,
2056                 loanOffering.rates.interestPeriod
2057             )
2058         );
2059     }
2060 }
2061 
2062 // File: contracts/margin/interfaces/PayoutRecipient.sol
2063 
2064 /**
2065  * @title PayoutRecipient
2066  * @author dYdX
2067  *
2068  * Interface that smart contracts must implement in order to be the payoutRecipient in a
2069  * closePosition transaction.
2070  *
2071  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2072  *       to these functions
2073  */
2074 interface PayoutRecipient {
2075 
2076     // ============ Public Interface functions ============
2077 
2078     /**
2079      * Function a contract must implement in order to receive payout from being the payoutRecipient
2080      * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.
2081      *
2082      * @param  positionId         Unique ID of the position
2083      * @param  closeAmount        Amount of the position that was closed
2084      * @param  closer             Address of the account or contract that closed the position
2085      * @param  positionOwner      Address of the owner of the position
2086      * @param  heldToken          Address of the ERC20 heldToken
2087      * @param  payout             Number of tokens received from the payout
2088      * @param  totalHeldToken     Total amount of heldToken removed from vault during close
2089      * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken
2090      * @return                    True if approved by the receiver
2091      */
2092     function receiveClosePositionPayout(
2093         bytes32 positionId,
2094         uint256 closeAmount,
2095         address closer,
2096         address positionOwner,
2097         address heldToken,
2098         uint256 payout,
2099         uint256 totalHeldToken,
2100         bool    payoutInHeldToken
2101     )
2102         external
2103         /* onlyMargin */
2104         returns (bool);
2105 }
2106 
2107 // File: contracts/margin/interfaces/lender/CloseLoanDelegator.sol
2108 
2109 /**
2110  * @title CloseLoanDelegator
2111  * @author dYdX
2112  *
2113  * Interface that smart contracts must implement in order to let other addresses close a loan
2114  * owned by the smart contract.
2115  *
2116  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2117  *       to these functions
2118  */
2119 interface CloseLoanDelegator {
2120 
2121     // ============ Public Interface functions ============
2122 
2123     /**
2124      * Function a contract must implement in order to let other addresses call
2125      * closeWithoutCounterparty().
2126      *
2127      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2128      * either revert the entire transaction or that (at most) the specified amount of the loan was
2129      * successfully closed.
2130      *
2131      * @param  closer           Address of the caller of closeWithoutCounterparty()
2132      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2133      * @param  positionId       Unique ID of the position
2134      * @param  requestedAmount  Requested principal amount of the loan to close
2135      * @return                  1) This address to accept, a different address to ask that contract
2136      *                          2) The maximum amount that this contract is allowing
2137      */
2138     function closeLoanOnBehalfOf(
2139         address closer,
2140         address payoutRecipient,
2141         bytes32 positionId,
2142         uint256 requestedAmount
2143     )
2144         external
2145         /* onlyMargin */
2146         returns (address, uint256);
2147 }
2148 
2149 // File: contracts/margin/interfaces/owner/ClosePositionDelegator.sol
2150 
2151 /**
2152  * @title ClosePositionDelegator
2153  * @author dYdX
2154  *
2155  * Interface that smart contracts must implement in order to let other addresses close a position
2156  * owned by the smart contract, allowing more complex logic to control positions.
2157  *
2158  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2159  *       to these functions
2160  */
2161 interface ClosePositionDelegator {
2162 
2163     // ============ Public Interface functions ============
2164 
2165     /**
2166      * Function a contract must implement in order to let other addresses call closePosition().
2167      *
2168      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2169      * either revert the entire transaction or that (at-most) the specified amount of the position
2170      * was successfully closed.
2171      *
2172      * @param  closer           Address of the caller of the closePosition() function
2173      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2174      * @param  positionId       Unique ID of the position
2175      * @param  requestedAmount  Requested principal amount of the position to close
2176      * @return                  1) This address to accept, a different address to ask that contract
2177      *                          2) The maximum amount that this contract is allowing
2178      */
2179     function closeOnBehalfOf(
2180         address closer,
2181         address payoutRecipient,
2182         bytes32 positionId,
2183         uint256 requestedAmount
2184     )
2185         external
2186         /* onlyMargin */
2187         returns (address, uint256);
2188 }
2189 
2190 // File: contracts/margin/impl/ClosePositionShared.sol
2191 
2192 /**
2193  * @title ClosePositionShared
2194  * @author dYdX
2195  *
2196  * This library contains shared functionality between ClosePositionImpl and
2197  * CloseWithoutCounterpartyImpl
2198  */
2199 library ClosePositionShared {
2200     using SafeMath for uint256;
2201 
2202     // ============ Structs ============
2203 
2204     struct CloseTx {
2205         bytes32 positionId;
2206         uint256 originalPrincipal;
2207         uint256 closeAmount;
2208         uint256 owedTokenOwed;
2209         uint256 startingHeldTokenBalance;
2210         uint256 availableHeldToken;
2211         address payoutRecipient;
2212         address owedToken;
2213         address heldToken;
2214         address positionOwner;
2215         address positionLender;
2216         address exchangeWrapper;
2217         bool    payoutInHeldToken;
2218     }
2219 
2220     // ============ Internal Implementation Functions ============
2221 
2222     function closePositionStateUpdate(
2223         MarginState.State storage state,
2224         CloseTx memory transaction
2225     )
2226         internal
2227     {
2228         // Delete the position, or just decrease the principal
2229         if (transaction.closeAmount == transaction.originalPrincipal) {
2230             MarginCommon.cleanupPosition(state, transaction.positionId);
2231         } else {
2232             assert(
2233                 transaction.originalPrincipal == state.positions[transaction.positionId].principal
2234             );
2235             state.positions[transaction.positionId].principal =
2236                 transaction.originalPrincipal.sub(transaction.closeAmount);
2237         }
2238     }
2239 
2240     function sendTokensToPayoutRecipient(
2241         MarginState.State storage state,
2242         ClosePositionShared.CloseTx memory transaction,
2243         uint256 buybackCostInHeldToken,
2244         uint256 receivedOwedToken
2245     )
2246         internal
2247         returns (uint256)
2248     {
2249         uint256 payout;
2250 
2251         if (transaction.payoutInHeldToken) {
2252             // Send remaining heldToken to payoutRecipient
2253             payout = transaction.availableHeldToken.sub(buybackCostInHeldToken);
2254 
2255             Vault(state.VAULT).transferFromVault(
2256                 transaction.positionId,
2257                 transaction.heldToken,
2258                 transaction.payoutRecipient,
2259                 payout
2260             );
2261         } else {
2262             assert(transaction.exchangeWrapper != address(0));
2263 
2264             payout = receivedOwedToken.sub(transaction.owedTokenOwed);
2265 
2266             TokenProxy(state.TOKEN_PROXY).transferTokens(
2267                 transaction.owedToken,
2268                 transaction.exchangeWrapper,
2269                 transaction.payoutRecipient,
2270                 payout
2271             );
2272         }
2273 
2274         if (AddressUtils.isContract(transaction.payoutRecipient)) {
2275             require(
2276                 PayoutRecipient(transaction.payoutRecipient).receiveClosePositionPayout(
2277                     transaction.positionId,
2278                     transaction.closeAmount,
2279                     msg.sender,
2280                     transaction.positionOwner,
2281                     transaction.heldToken,
2282                     payout,
2283                     transaction.availableHeldToken,
2284                     transaction.payoutInHeldToken
2285                 ),
2286                 "ClosePositionShared#sendTokensToPayoutRecipient: Payout recipient does not consent"
2287             );
2288         }
2289 
2290         // The ending heldToken balance of the vault should be the starting heldToken balance
2291         // minus the available heldToken amount
2292         assert(
2293             MarginCommon.getPositionBalanceImpl(state, transaction.positionId)
2294             == transaction.startingHeldTokenBalance.sub(transaction.availableHeldToken)
2295         );
2296 
2297         return payout;
2298     }
2299 
2300     function createCloseTx(
2301         MarginState.State storage state,
2302         bytes32 positionId,
2303         uint256 requestedAmount,
2304         address payoutRecipient,
2305         address exchangeWrapper,
2306         bool payoutInHeldToken,
2307         bool isWithoutCounterparty
2308     )
2309         internal
2310         returns (CloseTx memory)
2311     {
2312         // Validate
2313         require(
2314             payoutRecipient != address(0),
2315             "ClosePositionShared#createCloseTx: Payout recipient cannot be 0"
2316         );
2317         require(
2318             requestedAmount > 0,
2319             "ClosePositionShared#createCloseTx: Requested close amount cannot be 0"
2320         );
2321 
2322         MarginCommon.Position storage position =
2323             MarginCommon.getPositionFromStorage(state, positionId);
2324 
2325         uint256 closeAmount = getApprovedAmount(
2326             position,
2327             positionId,
2328             requestedAmount,
2329             payoutRecipient,
2330             isWithoutCounterparty
2331         );
2332 
2333         return parseCloseTx(
2334             state,
2335             position,
2336             positionId,
2337             closeAmount,
2338             payoutRecipient,
2339             exchangeWrapper,
2340             payoutInHeldToken,
2341             isWithoutCounterparty
2342         );
2343     }
2344 
2345     // ============ Private Helper-Functions ============
2346 
2347     function getApprovedAmount(
2348         MarginCommon.Position storage position,
2349         bytes32 positionId,
2350         uint256 requestedAmount,
2351         address payoutRecipient,
2352         bool requireLenderApproval
2353     )
2354         private
2355         returns (uint256)
2356     {
2357         // Ensure enough principal
2358         uint256 allowedAmount = Math.min256(requestedAmount, position.principal);
2359 
2360         // Ensure owner consent
2361         allowedAmount = closePositionOnBehalfOfRecurse(
2362             position.owner,
2363             msg.sender,
2364             payoutRecipient,
2365             positionId,
2366             allowedAmount
2367         );
2368 
2369         // Ensure lender consent
2370         if (requireLenderApproval) {
2371             allowedAmount = closeLoanOnBehalfOfRecurse(
2372                 position.lender,
2373                 msg.sender,
2374                 payoutRecipient,
2375                 positionId,
2376                 allowedAmount
2377             );
2378         }
2379 
2380         assert(allowedAmount > 0);
2381         assert(allowedAmount <= position.principal);
2382         assert(allowedAmount <= requestedAmount);
2383 
2384         return allowedAmount;
2385     }
2386 
2387     function closePositionOnBehalfOfRecurse(
2388         address contractAddr,
2389         address closer,
2390         address payoutRecipient,
2391         bytes32 positionId,
2392         uint256 closeAmount
2393     )
2394         private
2395         returns (uint256)
2396     {
2397         // no need to ask for permission
2398         if (closer == contractAddr) {
2399             return closeAmount;
2400         }
2401 
2402         (
2403             address newContractAddr,
2404             uint256 newCloseAmount
2405         ) = ClosePositionDelegator(contractAddr).closeOnBehalfOf(
2406             closer,
2407             payoutRecipient,
2408             positionId,
2409             closeAmount
2410         );
2411 
2412         require(
2413             newCloseAmount <= closeAmount,
2414             "ClosePositionShared#closePositionRecurse: newCloseAmount is greater than closeAmount"
2415         );
2416         require(
2417             newCloseAmount > 0,
2418             "ClosePositionShared#closePositionRecurse: newCloseAmount is zero"
2419         );
2420 
2421         if (newContractAddr != contractAddr) {
2422             closePositionOnBehalfOfRecurse(
2423                 newContractAddr,
2424                 closer,
2425                 payoutRecipient,
2426                 positionId,
2427                 newCloseAmount
2428             );
2429         }
2430 
2431         return newCloseAmount;
2432     }
2433 
2434     function closeLoanOnBehalfOfRecurse(
2435         address contractAddr,
2436         address closer,
2437         address payoutRecipient,
2438         bytes32 positionId,
2439         uint256 closeAmount
2440     )
2441         private
2442         returns (uint256)
2443     {
2444         // no need to ask for permission
2445         if (closer == contractAddr) {
2446             return closeAmount;
2447         }
2448 
2449         (
2450             address newContractAddr,
2451             uint256 newCloseAmount
2452         ) = CloseLoanDelegator(contractAddr).closeLoanOnBehalfOf(
2453                 closer,
2454                 payoutRecipient,
2455                 positionId,
2456                 closeAmount
2457             );
2458 
2459         require(
2460             newCloseAmount <= closeAmount,
2461             "ClosePositionShared#closeLoanRecurse: newCloseAmount is greater than closeAmount"
2462         );
2463         require(
2464             newCloseAmount > 0,
2465             "ClosePositionShared#closeLoanRecurse: newCloseAmount is zero"
2466         );
2467 
2468         if (newContractAddr != contractAddr) {
2469             closeLoanOnBehalfOfRecurse(
2470                 newContractAddr,
2471                 closer,
2472                 payoutRecipient,
2473                 positionId,
2474                 newCloseAmount
2475             );
2476         }
2477 
2478         return newCloseAmount;
2479     }
2480 
2481     // ============ Parsing Functions ============
2482 
2483     function parseCloseTx(
2484         MarginState.State storage state,
2485         MarginCommon.Position storage position,
2486         bytes32 positionId,
2487         uint256 closeAmount,
2488         address payoutRecipient,
2489         address exchangeWrapper,
2490         bool payoutInHeldToken,
2491         bool isWithoutCounterparty
2492     )
2493         private
2494         view
2495         returns (CloseTx memory)
2496     {
2497         uint256 startingHeldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
2498 
2499         uint256 availableHeldToken = MathHelpers.getPartialAmount(
2500             closeAmount,
2501             position.principal,
2502             startingHeldTokenBalance
2503         );
2504         uint256 owedTokenOwed = 0;
2505 
2506         if (!isWithoutCounterparty) {
2507             owedTokenOwed = MarginCommon.calculateOwedAmount(
2508                 position,
2509                 closeAmount,
2510                 block.timestamp
2511             );
2512         }
2513 
2514         return CloseTx({
2515             positionId: positionId,
2516             originalPrincipal: position.principal,
2517             closeAmount: closeAmount,
2518             owedTokenOwed: owedTokenOwed,
2519             startingHeldTokenBalance: startingHeldTokenBalance,
2520             availableHeldToken: availableHeldToken,
2521             payoutRecipient: payoutRecipient,
2522             owedToken: position.owedToken,
2523             heldToken: position.heldToken,
2524             positionOwner: position.owner,
2525             positionLender: position.lender,
2526             exchangeWrapper: exchangeWrapper,
2527             payoutInHeldToken: payoutInHeldToken
2528         });
2529     }
2530 }
2531 
2532 // File: contracts/margin/interfaces/ExchangeWrapper.sol
2533 
2534 /**
2535  * @title ExchangeWrapper
2536  * @author dYdX
2537  *
2538  * Contract interface that Exchange Wrapper smart contracts must implement in order to interface
2539  * with other smart contracts through a common interface.
2540  */
2541 interface ExchangeWrapper {
2542 
2543     // ============ Public Functions ============
2544 
2545     /**
2546      * Exchange some amount of takerToken for makerToken.
2547      *
2548      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
2549      *                              cannot always be trusted as it is set at the discretion of the
2550      *                              msg.sender)
2551      * @param  receiver             Address to set allowance on once the trade has completed
2552      * @param  makerToken           Address of makerToken, the token to receive
2553      * @param  takerToken           Address of takerToken, the token to pay
2554      * @param  requestedFillAmount  Amount of takerToken being paid
2555      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
2556      * @return                      The amount of makerToken received
2557      */
2558     function exchange(
2559         address tradeOriginator,
2560         address receiver,
2561         address makerToken,
2562         address takerToken,
2563         uint256 requestedFillAmount,
2564         bytes orderData
2565     )
2566         external
2567         returns (uint256);
2568 
2569     /**
2570      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
2571      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
2572      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
2573      * than desiredMakerToken
2574      *
2575      * @param  makerToken         Address of makerToken, the token to receive
2576      * @param  takerToken         Address of takerToken, the token to pay
2577      * @param  desiredMakerToken  Amount of makerToken requested
2578      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
2579      * @return                    Amount of takerToken the needed to complete the transaction
2580      */
2581     function getExchangeCost(
2582         address makerToken,
2583         address takerToken,
2584         uint256 desiredMakerToken,
2585         bytes orderData
2586     )
2587         external
2588         view
2589         returns (uint256);
2590 }
2591 
2592 // File: contracts/margin/impl/ClosePositionImpl.sol
2593 
2594 /**
2595  * @title ClosePositionImpl
2596  * @author dYdX
2597  *
2598  * This library contains the implementation for the closePosition function of Margin
2599  */
2600 library ClosePositionImpl {
2601     using SafeMath for uint256;
2602 
2603     // ============ Events ============
2604 
2605     /**
2606      * A position was closed or partially closed
2607      */
2608     event PositionClosed(
2609         bytes32 indexed positionId,
2610         address indexed closer,
2611         address indexed payoutRecipient,
2612         uint256 closeAmount,
2613         uint256 remainingAmount,
2614         uint256 owedTokenPaidToLender,
2615         uint256 payoutAmount,
2616         uint256 buybackCostInHeldToken,
2617         bool    payoutInHeldToken
2618     );
2619 
2620     // ============ Public Implementation Functions ============
2621 
2622     function closePositionImpl(
2623         MarginState.State storage state,
2624         bytes32 positionId,
2625         uint256 requestedCloseAmount,
2626         address payoutRecipient,
2627         address exchangeWrapper,
2628         bool payoutInHeldToken,
2629         bytes memory orderData
2630     )
2631         public
2632         returns (uint256, uint256, uint256)
2633     {
2634         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2635             state,
2636             positionId,
2637             requestedCloseAmount,
2638             payoutRecipient,
2639             exchangeWrapper,
2640             payoutInHeldToken,
2641             false
2642         );
2643 
2644         (
2645             uint256 buybackCostInHeldToken,
2646             uint256 receivedOwedToken
2647         ) = returnOwedTokensToLender(
2648             state,
2649             transaction,
2650             orderData
2651         );
2652 
2653         uint256 payout = ClosePositionShared.sendTokensToPayoutRecipient(
2654             state,
2655             transaction,
2656             buybackCostInHeldToken,
2657             receivedOwedToken
2658         );
2659 
2660         ClosePositionShared.closePositionStateUpdate(state, transaction);
2661 
2662         logEventOnClose(
2663             transaction,
2664             buybackCostInHeldToken,
2665             payout
2666         );
2667 
2668         return (
2669             transaction.closeAmount,
2670             payout,
2671             transaction.owedTokenOwed
2672         );
2673     }
2674 
2675     // ============ Private Helper-Functions ============
2676 
2677     function returnOwedTokensToLender(
2678         MarginState.State storage state,
2679         ClosePositionShared.CloseTx memory transaction,
2680         bytes memory orderData
2681     )
2682         private
2683         returns (uint256, uint256)
2684     {
2685         uint256 buybackCostInHeldToken = 0;
2686         uint256 receivedOwedToken = 0;
2687         uint256 lenderOwedToken = transaction.owedTokenOwed;
2688 
2689         // Setting exchangeWrapper to 0x000... indicates owedToken should be taken directly
2690         // from msg.sender
2691         if (transaction.exchangeWrapper == address(0)) {
2692             require(
2693                 transaction.payoutInHeldToken,
2694                 "ClosePositionImpl#returnOwedTokensToLender: Cannot payout in owedToken"
2695             );
2696 
2697             // No DEX Order; send owedTokens directly from the closer to the lender
2698             TokenProxy(state.TOKEN_PROXY).transferTokens(
2699                 transaction.owedToken,
2700                 msg.sender,
2701                 transaction.positionLender,
2702                 lenderOwedToken
2703             );
2704         } else {
2705             // Buy back owedTokens using DEX Order and send to lender
2706             (buybackCostInHeldToken, receivedOwedToken) = buyBackOwedToken(
2707                 state,
2708                 transaction,
2709                 orderData
2710             );
2711 
2712             // If no owedToken needed for payout: give lender all owedToken, even if more than owed
2713             if (transaction.payoutInHeldToken) {
2714                 assert(receivedOwedToken >= lenderOwedToken);
2715                 lenderOwedToken = receivedOwedToken;
2716             }
2717 
2718             // Transfer owedToken from the exchange wrapper to the lender
2719             TokenProxy(state.TOKEN_PROXY).transferTokens(
2720                 transaction.owedToken,
2721                 transaction.exchangeWrapper,
2722                 transaction.positionLender,
2723                 lenderOwedToken
2724             );
2725         }
2726 
2727         state.totalOwedTokenRepaidToLender[transaction.positionId] =
2728             state.totalOwedTokenRepaidToLender[transaction.positionId].add(lenderOwedToken);
2729 
2730         return (buybackCostInHeldToken, receivedOwedToken);
2731     }
2732 
2733     function buyBackOwedToken(
2734         MarginState.State storage state,
2735         ClosePositionShared.CloseTx transaction,
2736         bytes memory orderData
2737     )
2738         private
2739         returns (uint256, uint256)
2740     {
2741         // Ask the exchange wrapper the cost in heldToken to buy back the close
2742         // amount of owedToken
2743         uint256 buybackCostInHeldToken;
2744 
2745         if (transaction.payoutInHeldToken) {
2746             buybackCostInHeldToken = ExchangeWrapper(transaction.exchangeWrapper)
2747                 .getExchangeCost(
2748                     transaction.owedToken,
2749                     transaction.heldToken,
2750                     transaction.owedTokenOwed,
2751                     orderData
2752                 );
2753 
2754             // Require enough available heldToken to pay for the buyback
2755             require(
2756                 buybackCostInHeldToken <= transaction.availableHeldToken,
2757                 "ClosePositionImpl#buyBackOwedToken: Not enough available heldToken"
2758             );
2759         } else {
2760             buybackCostInHeldToken = transaction.availableHeldToken;
2761         }
2762 
2763         // Send the requisite heldToken to do the buyback from vault to exchange wrapper
2764         Vault(state.VAULT).transferFromVault(
2765             transaction.positionId,
2766             transaction.heldToken,
2767             transaction.exchangeWrapper,
2768             buybackCostInHeldToken
2769         );
2770 
2771         // Trade the heldToken for the owedToken
2772         uint256 receivedOwedToken = ExchangeWrapper(transaction.exchangeWrapper).exchange(
2773             msg.sender,
2774             state.TOKEN_PROXY,
2775             transaction.owedToken,
2776             transaction.heldToken,
2777             buybackCostInHeldToken,
2778             orderData
2779         );
2780 
2781         require(
2782             receivedOwedToken >= transaction.owedTokenOwed,
2783             "ClosePositionImpl#buyBackOwedToken: Did not receive enough owedToken"
2784         );
2785 
2786         return (buybackCostInHeldToken, receivedOwedToken);
2787     }
2788 
2789     function logEventOnClose(
2790         ClosePositionShared.CloseTx transaction,
2791         uint256 buybackCostInHeldToken,
2792         uint256 payout
2793     )
2794         private
2795     {
2796         emit PositionClosed(
2797             transaction.positionId,
2798             msg.sender,
2799             transaction.payoutRecipient,
2800             transaction.closeAmount,
2801             transaction.originalPrincipal.sub(transaction.closeAmount),
2802             transaction.owedTokenOwed,
2803             payout,
2804             buybackCostInHeldToken,
2805             transaction.payoutInHeldToken
2806         );
2807     }
2808 
2809 }
2810 
2811 // File: contracts/margin/impl/CloseWithoutCounterpartyImpl.sol
2812 
2813 /**
2814  * @title CloseWithoutCounterpartyImpl
2815  * @author dYdX
2816  *
2817  * This library contains the implementation for the closeWithoutCounterpartyImpl function of
2818  * Margin
2819  */
2820 library CloseWithoutCounterpartyImpl {
2821     using SafeMath for uint256;
2822 
2823     // ============ Events ============
2824 
2825     /**
2826      * A position was closed or partially closed
2827      */
2828     event PositionClosed(
2829         bytes32 indexed positionId,
2830         address indexed closer,
2831         address indexed payoutRecipient,
2832         uint256 closeAmount,
2833         uint256 remainingAmount,
2834         uint256 owedTokenPaidToLender,
2835         uint256 payoutAmount,
2836         uint256 buybackCostInHeldToken,
2837         bool payoutInHeldToken
2838     );
2839 
2840     // ============ Public Implementation Functions ============
2841 
2842     function closeWithoutCounterpartyImpl(
2843         MarginState.State storage state,
2844         bytes32 positionId,
2845         uint256 requestedCloseAmount,
2846         address payoutRecipient
2847     )
2848         public
2849         returns (uint256, uint256)
2850     {
2851         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2852             state,
2853             positionId,
2854             requestedCloseAmount,
2855             payoutRecipient,
2856             address(0),
2857             true,
2858             true
2859         );
2860 
2861         uint256 heldTokenPayout = ClosePositionShared.sendTokensToPayoutRecipient(
2862             state,
2863             transaction,
2864             0, // No buyback cost
2865             0  // Did not receive any owedToken
2866         );
2867 
2868         ClosePositionShared.closePositionStateUpdate(state, transaction);
2869 
2870         logEventOnCloseWithoutCounterparty(transaction);
2871 
2872         return (
2873             transaction.closeAmount,
2874             heldTokenPayout
2875         );
2876     }
2877 
2878     // ============ Private Helper-Functions ============
2879 
2880     function logEventOnCloseWithoutCounterparty(
2881         ClosePositionShared.CloseTx transaction
2882     )
2883         private
2884     {
2885         emit PositionClosed(
2886             transaction.positionId,
2887             msg.sender,
2888             transaction.payoutRecipient,
2889             transaction.closeAmount,
2890             transaction.originalPrincipal.sub(transaction.closeAmount),
2891             0,
2892             transaction.availableHeldToken,
2893             0,
2894             true
2895         );
2896     }
2897 }
2898 
2899 // File: contracts/margin/interfaces/owner/DepositCollateralDelegator.sol
2900 
2901 /**
2902  * @title DepositCollateralDelegator
2903  * @author dYdX
2904  *
2905  * Interface that smart contracts must implement in order to let other addresses deposit heldTokens
2906  * into a position owned by the smart contract.
2907  *
2908  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2909  *       to these functions
2910  */
2911 interface DepositCollateralDelegator {
2912 
2913     // ============ Public Interface functions ============
2914 
2915     /**
2916      * Function a contract must implement in order to let other addresses call depositCollateral().
2917      *
2918      * @param  depositor   Address of the caller of the depositCollateral() function
2919      * @param  positionId  Unique ID of the position
2920      * @param  amount      Requested deposit amount
2921      * @return             This address to accept, a different address to ask that contract
2922      */
2923     function depositCollateralOnBehalfOf(
2924         address depositor,
2925         bytes32 positionId,
2926         uint256 amount
2927     )
2928         external
2929         /* onlyMargin */
2930         returns (address);
2931 }
2932 
2933 // File: contracts/margin/impl/DepositCollateralImpl.sol
2934 
2935 /**
2936  * @title DepositCollateralImpl
2937  * @author dYdX
2938  *
2939  * This library contains the implementation for the deposit function of Margin
2940  */
2941 library DepositCollateralImpl {
2942     using SafeMath for uint256;
2943 
2944     // ============ Events ============
2945 
2946     /**
2947      * Additional collateral for a position was posted by the owner
2948      */
2949     event AdditionalCollateralDeposited(
2950         bytes32 indexed positionId,
2951         uint256 amount,
2952         address depositor
2953     );
2954 
2955     /**
2956      * A margin call was canceled
2957      */
2958     event MarginCallCanceled(
2959         bytes32 indexed positionId,
2960         address indexed lender,
2961         address indexed owner,
2962         uint256 depositAmount
2963     );
2964 
2965     // ============ Public Implementation Functions ============
2966 
2967     function depositCollateralImpl(
2968         MarginState.State storage state,
2969         bytes32 positionId,
2970         uint256 depositAmount
2971     )
2972         public
2973     {
2974         MarginCommon.Position storage position =
2975             MarginCommon.getPositionFromStorage(state, positionId);
2976 
2977         require(
2978             depositAmount > 0,
2979             "DepositCollateralImpl#depositCollateralImpl: Deposit amount cannot be 0"
2980         );
2981 
2982         // Ensure owner consent
2983         depositCollateralOnBehalfOfRecurse(
2984             position.owner,
2985             msg.sender,
2986             positionId,
2987             depositAmount
2988         );
2989 
2990         Vault(state.VAULT).transferToVault(
2991             positionId,
2992             position.heldToken,
2993             msg.sender,
2994             depositAmount
2995         );
2996 
2997         // cancel margin call if applicable
2998         bool marginCallCanceled = false;
2999         uint256 requiredDeposit = position.requiredDeposit;
3000         if (position.callTimestamp > 0 && requiredDeposit > 0) {
3001             if (depositAmount >= requiredDeposit) {
3002                 position.requiredDeposit = 0;
3003                 position.callTimestamp = 0;
3004                 marginCallCanceled = true;
3005             } else {
3006                 position.requiredDeposit = position.requiredDeposit.sub(depositAmount);
3007             }
3008         }
3009 
3010         emit AdditionalCollateralDeposited(
3011             positionId,
3012             depositAmount,
3013             msg.sender
3014         );
3015 
3016         if (marginCallCanceled) {
3017             emit MarginCallCanceled(
3018                 positionId,
3019                 position.lender,
3020                 msg.sender,
3021                 depositAmount
3022             );
3023         }
3024     }
3025 
3026     // ============ Private Helper-Functions ============
3027 
3028     function depositCollateralOnBehalfOfRecurse(
3029         address contractAddr,
3030         address depositor,
3031         bytes32 positionId,
3032         uint256 amount
3033     )
3034         private
3035     {
3036         // no need to ask for permission
3037         if (depositor == contractAddr) {
3038             return;
3039         }
3040 
3041         address newContractAddr =
3042             DepositCollateralDelegator(contractAddr).depositCollateralOnBehalfOf(
3043                 depositor,
3044                 positionId,
3045                 amount
3046             );
3047 
3048         // if not equal, recurse
3049         if (newContractAddr != contractAddr) {
3050             depositCollateralOnBehalfOfRecurse(
3051                 newContractAddr,
3052                 depositor,
3053                 positionId,
3054                 amount
3055             );
3056         }
3057     }
3058 }
3059 
3060 // File: contracts/margin/interfaces/lender/ForceRecoverCollateralDelegator.sol
3061 
3062 /**
3063  * @title ForceRecoverCollateralDelegator
3064  * @author dYdX
3065  *
3066  * Interface that smart contracts must implement in order to let other addresses
3067  * forceRecoverCollateral() a loan owned by the smart contract.
3068  *
3069  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3070  *       to these functions
3071  */
3072 interface ForceRecoverCollateralDelegator {
3073 
3074     // ============ Public Interface functions ============
3075 
3076     /**
3077      * Function a contract must implement in order to let other addresses call
3078      * forceRecoverCollateral().
3079      *
3080      * NOTE: If not returning zero address (or not reverting), this contract must assume that Margin
3081      * will either revert the entire transaction or that the collateral was forcibly recovered.
3082      *
3083      * @param  recoverer   Address of the caller of the forceRecoverCollateral() function
3084      * @param  positionId  Unique ID of the position
3085      * @param  recipient   Address to send the recovered tokens to
3086      * @return             This address to accept, a different address to ask that contract
3087      */
3088     function forceRecoverCollateralOnBehalfOf(
3089         address recoverer,
3090         bytes32 positionId,
3091         address recipient
3092     )
3093         external
3094         /* onlyMargin */
3095         returns (address);
3096 }
3097 
3098 // File: contracts/margin/impl/ForceRecoverCollateralImpl.sol
3099 
3100 /**
3101  * @title ForceRecoverCollateralImpl
3102  * @author dYdX
3103  *
3104  * This library contains the implementation for the forceRecoverCollateral function of Margin
3105  */
3106 library ForceRecoverCollateralImpl {
3107     using SafeMath for uint256;
3108 
3109     // ============ Events ============
3110 
3111     /**
3112      * Collateral for a position was forcibly recovered
3113      */
3114     event CollateralForceRecovered(
3115         bytes32 indexed positionId,
3116         address indexed recipient,
3117         uint256 amount
3118     );
3119 
3120     // ============ Public Implementation Functions ============
3121 
3122     function forceRecoverCollateralImpl(
3123         MarginState.State storage state,
3124         bytes32 positionId,
3125         address recipient
3126     )
3127         public
3128         returns (uint256)
3129     {
3130         MarginCommon.Position storage position =
3131             MarginCommon.getPositionFromStorage(state, positionId);
3132 
3133         // Can only force recover after either:
3134         // 1) The loan was called and the call period has elapsed
3135         // 2) The maxDuration of the position has elapsed
3136         require( /* solium-disable-next-line */
3137             (
3138                 position.callTimestamp > 0
3139                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3140             ) || (
3141                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3142             ),
3143             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3144         );
3145 
3146         // Ensure lender consent
3147         forceRecoverCollateralOnBehalfOfRecurse(
3148             position.lender,
3149             msg.sender,
3150             positionId,
3151             recipient
3152         );
3153 
3154         // Send the tokens
3155         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3156         Vault(state.VAULT).transferFromVault(
3157             positionId,
3158             position.heldToken,
3159             recipient,
3160             heldTokenRecovered
3161         );
3162 
3163         // Delete the position
3164         // NOTE: Since position is a storage pointer, this will also set all fields on
3165         //       the position variable to 0
3166         MarginCommon.cleanupPosition(
3167             state,
3168             positionId
3169         );
3170 
3171         // Log an event
3172         emit CollateralForceRecovered(
3173             positionId,
3174             recipient,
3175             heldTokenRecovered
3176         );
3177 
3178         return heldTokenRecovered;
3179     }
3180 
3181     // ============ Private Helper-Functions ============
3182 
3183     function forceRecoverCollateralOnBehalfOfRecurse(
3184         address contractAddr,
3185         address recoverer,
3186         bytes32 positionId,
3187         address recipient
3188     )
3189         private
3190     {
3191         // no need to ask for permission
3192         if (recoverer == contractAddr) {
3193             return;
3194         }
3195 
3196         address newContractAddr =
3197             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3198                 recoverer,
3199                 positionId,
3200                 recipient
3201             );
3202 
3203         if (newContractAddr != contractAddr) {
3204             forceRecoverCollateralOnBehalfOfRecurse(
3205                 newContractAddr,
3206                 recoverer,
3207                 positionId,
3208                 recipient
3209             );
3210         }
3211     }
3212 }
3213 
3214 // File: contracts/lib/TypedSignature.sol
3215 
3216 /**
3217  * @title TypedSignature
3218  * @author dYdX
3219  *
3220  * Allows for ecrecovery of signed hashes with three different prepended messages:
3221  * 1) ""
3222  * 2) "\x19Ethereum Signed Message:\n32"
3223  * 3) "\x19Ethereum Signed Message:\n\x20"
3224  */
3225 library TypedSignature {
3226 
3227     // Solidity does not offer guarantees about enum values, so we define them explicitly
3228     uint8 private constant SIGTYPE_INVALID = 0;
3229     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3230     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3231     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3232 
3233     // prepended message with the length of the signed hash in hexadecimal
3234     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3235 
3236     // prepended message with the length of the signed hash in decimal
3237     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3238 
3239     /**
3240      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3241      *
3242      * @param  hash               Hash that was signed (does not include prepended message)
3243      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3244      * @return                    address of the signer of the hash
3245      */
3246     function recover(
3247         bytes32 hash,
3248         bytes signatureWithType
3249     )
3250         internal
3251         pure
3252         returns (address)
3253     {
3254         require(
3255             signatureWithType.length == 66,
3256             "SignatureValidator#validateSignature: invalid signature length"
3257         );
3258 
3259         uint8 sigType = uint8(signatureWithType[0]);
3260 
3261         require(
3262             sigType > uint8(SIGTYPE_INVALID),
3263             "SignatureValidator#validateSignature: invalid signature type"
3264         );
3265         require(
3266             sigType < uint8(SIGTYPE_UNSUPPORTED),
3267             "SignatureValidator#validateSignature: unsupported signature type"
3268         );
3269 
3270         uint8 v = uint8(signatureWithType[1]);
3271         bytes32 r;
3272         bytes32 s;
3273 
3274         /* solium-disable-next-line security/no-inline-assembly */
3275         assembly {
3276             r := mload(add(signatureWithType, 34))
3277             s := mload(add(signatureWithType, 66))
3278         }
3279 
3280         bytes32 signedHash;
3281         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3282             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3283         } else {
3284             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3285             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3286         }
3287 
3288         return ecrecover(
3289             signedHash,
3290             v,
3291             r,
3292             s
3293         );
3294     }
3295 }
3296 
3297 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3298 
3299 /**
3300  * @title LoanOfferingVerifier
3301  * @author dYdX
3302  *
3303  * Interface that smart contracts must implement to be able to make off-chain generated
3304  * loan offerings.
3305  *
3306  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3307  *       to these functions
3308  */
3309 interface LoanOfferingVerifier {
3310 
3311     /**
3312      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3313      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3314      * position.
3315      *
3316      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3317      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3318      * state on a loan.
3319      *
3320      * @param  addresses    Array of addresses:
3321      *
3322      *  [0] = owedToken
3323      *  [1] = heldToken
3324      *  [2] = loan payer
3325      *  [3] = loan owner
3326      *  [4] = loan taker
3327      *  [5] = loan positionOwner
3328      *  [6] = loan fee recipient
3329      *  [7] = loan lender fee token
3330      *  [8] = loan taker fee token
3331      *
3332      * @param  values256    Values corresponding to:
3333      *
3334      *  [0] = loan maximum amount
3335      *  [1] = loan minimum amount
3336      *  [2] = loan minimum heldToken
3337      *  [3] = loan lender fee
3338      *  [4] = loan taker fee
3339      *  [5] = loan expiration timestamp (in seconds)
3340      *  [6] = loan salt
3341      *
3342      * @param  values32     Values corresponding to:
3343      *
3344      *  [0] = loan call time limit (in seconds)
3345      *  [1] = loan maxDuration (in seconds)
3346      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3347      *  [3] = loan interest update period (in seconds)
3348      *
3349      * @param  positionId   Unique ID of the position
3350      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3351      * @return              This address to accept, a different address to ask that contract
3352      */
3353     function verifyLoanOffering(
3354         address[9] addresses,
3355         uint256[7] values256,
3356         uint32[4] values32,
3357         bytes32 positionId,
3358         bytes signature
3359     )
3360         external
3361         /* onlyMargin */
3362         returns (address);
3363 }
3364 
3365 // File: contracts/margin/impl/BorrowShared.sol
3366 
3367 /**
3368  * @title BorrowShared
3369  * @author dYdX
3370  *
3371  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3372  * Both use a Loan Offering and a DEX Order to open or increase a position.
3373  */
3374 library BorrowShared {
3375     using SafeMath for uint256;
3376 
3377     // ============ Structs ============
3378 
3379     struct Tx {
3380         bytes32 positionId;
3381         address owner;
3382         uint256 principal;
3383         uint256 lenderAmount;
3384         MarginCommon.LoanOffering loanOffering;
3385         address exchangeWrapper;
3386         bool depositInHeldToken;
3387         uint256 depositAmount;
3388         uint256 collateralAmount;
3389         uint256 heldTokenFromSell;
3390     }
3391 
3392     // ============ Internal Implementation Functions ============
3393 
3394     /**
3395      * Validate the transaction before exchanging heldToken for owedToken
3396      */
3397     function validateTxPreSell(
3398         MarginState.State storage state,
3399         Tx memory transaction
3400     )
3401         internal
3402     {
3403         assert(transaction.lenderAmount >= transaction.principal);
3404 
3405         require(
3406             transaction.principal > 0,
3407             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3408         );
3409 
3410         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3411         if (transaction.loanOffering.taker != address(0)) {
3412             require(
3413                 msg.sender == transaction.loanOffering.taker,
3414                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3415             );
3416         }
3417 
3418         // If the positionOwner is 0x0 then any address can be set as the position owner.
3419         // Otherwise only the specified positionOwner can be set as the position owner.
3420         if (transaction.loanOffering.positionOwner != address(0)) {
3421             require(
3422                 transaction.owner == transaction.loanOffering.positionOwner,
3423                 "BorrowShared#validateTxPreSell: Invalid position owner"
3424             );
3425         }
3426 
3427         // Require the loan offering to be approved by the payer
3428         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3429             getConsentFromSmartContractLender(transaction);
3430         } else {
3431             require(
3432                 transaction.loanOffering.payer == TypedSignature.recover(
3433                     transaction.loanOffering.loanHash,
3434                     transaction.loanOffering.signature
3435                 ),
3436                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3437             );
3438         }
3439 
3440         // Validate the amount is <= than max and >= min
3441         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3442             state,
3443             transaction.loanOffering.loanHash
3444         );
3445         require(
3446             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3447             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3448         );
3449 
3450         require(
3451             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3452             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3453         );
3454 
3455         require(
3456             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3457             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3458         );
3459 
3460         require(
3461             transaction.owner != address(0),
3462             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3463         );
3464 
3465         require(
3466             transaction.loanOffering.owner != address(0),
3467             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3468         );
3469 
3470         require(
3471             transaction.loanOffering.expirationTimestamp > block.timestamp,
3472             "BorrowShared#validateTxPreSell: Loan offering is expired"
3473         );
3474 
3475         require(
3476             transaction.loanOffering.maxDuration > 0,
3477             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3478         );
3479 
3480         require(
3481             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3482             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3483         );
3484 
3485         // The minimum heldToken is validated after executing the sell
3486         // Position and loan ownership is validated in TransferInternal
3487     }
3488 
3489     /**
3490      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3491      * how much of the loan was used.
3492      */
3493     function doPostSell(
3494         MarginState.State storage state,
3495         Tx memory transaction
3496     )
3497         internal
3498     {
3499         validateTxPostSell(transaction);
3500 
3501         // Transfer feeTokens from trader and lender
3502         transferLoanFees(state, transaction);
3503 
3504         // Update global amounts for the loan
3505         state.loanFills[transaction.loanOffering.loanHash] =
3506             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3507     }
3508 
3509     /**
3510      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3511      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3512      * maxHeldTokenToBuy of heldTokens at most.
3513      */
3514     function doSell(
3515         MarginState.State storage state,
3516         Tx transaction,
3517         bytes orderData,
3518         uint256 maxHeldTokenToBuy
3519     )
3520         internal
3521         returns (uint256)
3522     {
3523         // Move owedTokens from lender to exchange wrapper
3524         pullOwedTokensFromLender(state, transaction);
3525 
3526         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3527         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3528         uint256 sellAmount = transaction.depositInHeldToken ?
3529             transaction.lenderAmount :
3530             transaction.lenderAmount.add(transaction.depositAmount);
3531 
3532         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3533         uint256 heldTokenFromSell = Math.min256(
3534             maxHeldTokenToBuy,
3535             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3536                 msg.sender,
3537                 state.TOKEN_PROXY,
3538                 transaction.loanOffering.heldToken,
3539                 transaction.loanOffering.owedToken,
3540                 sellAmount,
3541                 orderData
3542             )
3543         );
3544 
3545         // Move the tokens to the vault
3546         Vault(state.VAULT).transferToVault(
3547             transaction.positionId,
3548             transaction.loanOffering.heldToken,
3549             transaction.exchangeWrapper,
3550             heldTokenFromSell
3551         );
3552 
3553         // Update collateral amount
3554         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3555 
3556         return heldTokenFromSell;
3557     }
3558 
3559     /**
3560      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3561      * be sold for heldToken.
3562      */
3563     function doDepositOwedToken(
3564         MarginState.State storage state,
3565         Tx transaction
3566     )
3567         internal
3568     {
3569         TokenProxy(state.TOKEN_PROXY).transferTokens(
3570             transaction.loanOffering.owedToken,
3571             msg.sender,
3572             transaction.exchangeWrapper,
3573             transaction.depositAmount
3574         );
3575     }
3576 
3577     /**
3578      * Take the heldToken deposit from the trader and move it to the vault.
3579      */
3580     function doDepositHeldToken(
3581         MarginState.State storage state,
3582         Tx transaction
3583     )
3584         internal
3585     {
3586         Vault(state.VAULT).transferToVault(
3587             transaction.positionId,
3588             transaction.loanOffering.heldToken,
3589             msg.sender,
3590             transaction.depositAmount
3591         );
3592 
3593         // Update collateral amount
3594         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3595     }
3596 
3597     // ============ Private Helper-Functions ============
3598 
3599     function validateTxPostSell(
3600         Tx transaction
3601     )
3602         private
3603         pure
3604     {
3605         uint256 expectedCollateral = transaction.depositInHeldToken ?
3606             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3607             transaction.heldTokenFromSell;
3608         assert(transaction.collateralAmount == expectedCollateral);
3609 
3610         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3611             transaction.lenderAmount,
3612             transaction.loanOffering.rates.maxAmount,
3613             transaction.loanOffering.rates.minHeldToken
3614         );
3615         require(
3616             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3617             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3618         );
3619     }
3620 
3621     function getConsentFromSmartContractLender(
3622         Tx transaction
3623     )
3624         private
3625     {
3626         verifyLoanOfferingRecurse(
3627             transaction.loanOffering.payer,
3628             getLoanOfferingAddresses(transaction),
3629             getLoanOfferingValues256(transaction),
3630             getLoanOfferingValues32(transaction),
3631             transaction.positionId,
3632             transaction.loanOffering.signature
3633         );
3634     }
3635 
3636     function verifyLoanOfferingRecurse(
3637         address contractAddr,
3638         address[9] addresses,
3639         uint256[7] values256,
3640         uint32[4] values32,
3641         bytes32 positionId,
3642         bytes signature
3643     )
3644         private
3645     {
3646         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3647             addresses,
3648             values256,
3649             values32,
3650             positionId,
3651             signature
3652         );
3653 
3654         if (newContractAddr != contractAddr) {
3655             verifyLoanOfferingRecurse(
3656                 newContractAddr,
3657                 addresses,
3658                 values256,
3659                 values32,
3660                 positionId,
3661                 signature
3662             );
3663         }
3664     }
3665 
3666     function pullOwedTokensFromLender(
3667         MarginState.State storage state,
3668         Tx transaction
3669     )
3670         private
3671     {
3672         // Transfer owedToken to the exchange wrapper
3673         TokenProxy(state.TOKEN_PROXY).transferTokens(
3674             transaction.loanOffering.owedToken,
3675             transaction.loanOffering.payer,
3676             transaction.exchangeWrapper,
3677             transaction.lenderAmount
3678         );
3679     }
3680 
3681     function transferLoanFees(
3682         MarginState.State storage state,
3683         Tx transaction
3684     )
3685         private
3686     {
3687         // 0 fee address indicates no fees
3688         if (transaction.loanOffering.feeRecipient == address(0)) {
3689             return;
3690         }
3691 
3692         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3693 
3694         uint256 lenderFee = MathHelpers.getPartialAmount(
3695             transaction.lenderAmount,
3696             transaction.loanOffering.rates.maxAmount,
3697             transaction.loanOffering.rates.lenderFee
3698         );
3699         uint256 takerFee = MathHelpers.getPartialAmount(
3700             transaction.lenderAmount,
3701             transaction.loanOffering.rates.maxAmount,
3702             transaction.loanOffering.rates.takerFee
3703         );
3704 
3705         if (lenderFee > 0) {
3706             proxy.transferTokens(
3707                 transaction.loanOffering.lenderFeeToken,
3708                 transaction.loanOffering.payer,
3709                 transaction.loanOffering.feeRecipient,
3710                 lenderFee
3711             );
3712         }
3713 
3714         if (takerFee > 0) {
3715             proxy.transferTokens(
3716                 transaction.loanOffering.takerFeeToken,
3717                 msg.sender,
3718                 transaction.loanOffering.feeRecipient,
3719                 takerFee
3720             );
3721         }
3722     }
3723 
3724     function getLoanOfferingAddresses(
3725         Tx transaction
3726     )
3727         private
3728         pure
3729         returns (address[9])
3730     {
3731         return [
3732             transaction.loanOffering.owedToken,
3733             transaction.loanOffering.heldToken,
3734             transaction.loanOffering.payer,
3735             transaction.loanOffering.owner,
3736             transaction.loanOffering.taker,
3737             transaction.loanOffering.positionOwner,
3738             transaction.loanOffering.feeRecipient,
3739             transaction.loanOffering.lenderFeeToken,
3740             transaction.loanOffering.takerFeeToken
3741         ];
3742     }
3743 
3744     function getLoanOfferingValues256(
3745         Tx transaction
3746     )
3747         private
3748         pure
3749         returns (uint256[7])
3750     {
3751         return [
3752             transaction.loanOffering.rates.maxAmount,
3753             transaction.loanOffering.rates.minAmount,
3754             transaction.loanOffering.rates.minHeldToken,
3755             transaction.loanOffering.rates.lenderFee,
3756             transaction.loanOffering.rates.takerFee,
3757             transaction.loanOffering.expirationTimestamp,
3758             transaction.loanOffering.salt
3759         ];
3760     }
3761 
3762     function getLoanOfferingValues32(
3763         Tx transaction
3764     )
3765         private
3766         pure
3767         returns (uint32[4])
3768     {
3769         return [
3770             transaction.loanOffering.callTimeLimit,
3771             transaction.loanOffering.maxDuration,
3772             transaction.loanOffering.rates.interestRate,
3773             transaction.loanOffering.rates.interestPeriod
3774         ];
3775     }
3776 }
3777 
3778 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3779 
3780 /**
3781  * @title IncreaseLoanDelegator
3782  * @author dYdX
3783  *
3784  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3785  *
3786  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3787  *       to these functions
3788  */
3789 interface IncreaseLoanDelegator {
3790 
3791     // ============ Public Interface functions ============
3792 
3793     /**
3794      * Function a contract must implement in order to allow additional value to be added onto
3795      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3796      *
3797      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3798      * either revert the entire transaction or that the loan size was successfully increased.
3799      *
3800      * @param  payer           Lender adding additional funds to the position
3801      * @param  positionId      Unique ID of the position
3802      * @param  principalAdded  Principal amount to be added to the position
3803      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
3804      *                         zero if increaseWithoutCounterparty() is used).
3805      * @return                 This address to accept, a different address to ask that contract
3806      */
3807     function increaseLoanOnBehalfOf(
3808         address payer,
3809         bytes32 positionId,
3810         uint256 principalAdded,
3811         uint256 lentAmount
3812     )
3813         external
3814         /* onlyMargin */
3815         returns (address);
3816 }
3817 
3818 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
3819 
3820 /**
3821  * @title IncreasePositionDelegator
3822  * @author dYdX
3823  *
3824  * Interface that smart contracts must implement in order to own position on behalf of other
3825  * accounts
3826  *
3827  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3828  *       to these functions
3829  */
3830 interface IncreasePositionDelegator {
3831 
3832     // ============ Public Interface functions ============
3833 
3834     /**
3835      * Function a contract must implement in order to allow additional value to be added onto
3836      * an owned position. Margin will call this on the owner of a position during increasePosition()
3837      *
3838      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3839      * either revert the entire transaction or that the position size was successfully increased.
3840      *
3841      * @param  trader          Address initiating the addition of funds to the position
3842      * @param  positionId      Unique ID of the position
3843      * @param  principalAdded  Amount of principal to be added to the position
3844      * @return                 This address to accept, a different address to ask that contract
3845      */
3846     function increasePositionOnBehalfOf(
3847         address trader,
3848         bytes32 positionId,
3849         uint256 principalAdded
3850     )
3851         external
3852         /* onlyMargin */
3853         returns (address);
3854 }
3855 
3856 // File: contracts/margin/impl/IncreasePositionImpl.sol
3857 
3858 /**
3859  * @title IncreasePositionImpl
3860  * @author dYdX
3861  *
3862  * This library contains the implementation for the increasePosition function of Margin
3863  */
3864 library IncreasePositionImpl {
3865     using SafeMath for uint256;
3866 
3867     // ============ Events ============
3868 
3869     /*
3870      * A position was increased
3871      */
3872     event PositionIncreased(
3873         bytes32 indexed positionId,
3874         address indexed trader,
3875         address indexed lender,
3876         address positionOwner,
3877         address loanOwner,
3878         bytes32 loanHash,
3879         address loanFeeRecipient,
3880         uint256 amountBorrowed,
3881         uint256 principalAdded,
3882         uint256 heldTokenFromSell,
3883         uint256 depositAmount,
3884         bool    depositInHeldToken
3885     );
3886 
3887     // ============ Public Implementation Functions ============
3888 
3889     function increasePositionImpl(
3890         MarginState.State storage state,
3891         bytes32 positionId,
3892         address[7] addresses,
3893         uint256[8] values256,
3894         uint32[2] values32,
3895         bool depositInHeldToken,
3896         bytes signature,
3897         bytes orderData
3898     )
3899         public
3900         returns (uint256)
3901     {
3902         // Also ensures that the position exists
3903         MarginCommon.Position storage position =
3904             MarginCommon.getPositionFromStorage(state, positionId);
3905 
3906         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
3907             position,
3908             positionId,
3909             addresses,
3910             values256,
3911             values32,
3912             depositInHeldToken,
3913             signature
3914         );
3915 
3916         validateIncrease(state, transaction, position);
3917 
3918         doBorrowAndSell(state, transaction, orderData);
3919 
3920         updateState(
3921             position,
3922             transaction.positionId,
3923             transaction.principal,
3924             transaction.lenderAmount,
3925             transaction.loanOffering.payer
3926         );
3927 
3928         // LOG EVENT
3929         recordPositionIncreased(transaction, position);
3930 
3931         return transaction.lenderAmount;
3932     }
3933 
3934     function increaseWithoutCounterpartyImpl(
3935         MarginState.State storage state,
3936         bytes32 positionId,
3937         uint256 principalToAdd
3938     )
3939         public
3940         returns (uint256)
3941     {
3942         MarginCommon.Position storage position =
3943             MarginCommon.getPositionFromStorage(state, positionId);
3944 
3945         // Disallow adding 0 principal
3946         require(
3947             principalToAdd > 0,
3948             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
3949         );
3950 
3951         // Disallow additions after maximum duration
3952         require(
3953             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
3954             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
3955         );
3956 
3957         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
3958             state,
3959             position,
3960             positionId,
3961             principalToAdd
3962         );
3963 
3964         Vault(state.VAULT).transferToVault(
3965             positionId,
3966             position.heldToken,
3967             msg.sender,
3968             heldTokenAmount
3969         );
3970 
3971         updateState(
3972             position,
3973             positionId,
3974             principalToAdd,
3975             0, // lent amount
3976             msg.sender
3977         );
3978 
3979         emit PositionIncreased(
3980             positionId,
3981             msg.sender,
3982             msg.sender,
3983             position.owner,
3984             position.lender,
3985             "",
3986             address(0),
3987             0,
3988             principalToAdd,
3989             0,
3990             heldTokenAmount,
3991             true
3992         );
3993 
3994         return heldTokenAmount;
3995     }
3996 
3997     // ============ Private Helper-Functions ============
3998 
3999     function doBorrowAndSell(
4000         MarginState.State storage state,
4001         BorrowShared.Tx memory transaction,
4002         bytes orderData
4003     )
4004         private
4005     {
4006         // Calculate the number of heldTokens to add
4007         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
4008             state,
4009             state.positions[transaction.positionId],
4010             transaction.positionId,
4011             transaction.principal
4012         );
4013 
4014         // Do pre-exchange validations
4015         BorrowShared.validateTxPreSell(state, transaction);
4016 
4017         // Calculate and deposit owedToken
4018         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
4019         if (!transaction.depositInHeldToken) {
4020             transaction.depositAmount =
4021                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
4022             BorrowShared.doDepositOwedToken(state, transaction);
4023             maxHeldTokenFromSell = collateralToAdd;
4024         }
4025 
4026         // Sell owedToken for heldToken using the exchange wrapper
4027         transaction.heldTokenFromSell = BorrowShared.doSell(
4028             state,
4029             transaction,
4030             orderData,
4031             maxHeldTokenFromSell
4032         );
4033 
4034         // Calculate and deposit heldToken
4035         if (transaction.depositInHeldToken) {
4036             require(
4037                 transaction.heldTokenFromSell <= collateralToAdd,
4038                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
4039             );
4040             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
4041             BorrowShared.doDepositHeldToken(state, transaction);
4042         }
4043 
4044         // Make sure the actual added collateral is what is expected
4045         assert(transaction.collateralAmount == collateralToAdd);
4046 
4047         // Do post-exchange validations
4048         BorrowShared.doPostSell(state, transaction);
4049     }
4050 
4051     function getOwedTokenDeposit(
4052         BorrowShared.Tx transaction,
4053         uint256 collateralToAdd,
4054         bytes orderData
4055     )
4056         private
4057         view
4058         returns (uint256)
4059     {
4060         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
4061             transaction.loanOffering.heldToken,
4062             transaction.loanOffering.owedToken,
4063             collateralToAdd,
4064             orderData
4065         );
4066 
4067         require(
4068             transaction.lenderAmount <= totalOwedToken,
4069             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4070         );
4071 
4072         return totalOwedToken.sub(transaction.lenderAmount);
4073     }
4074 
4075     function validateIncrease(
4076         MarginState.State storage state,
4077         BorrowShared.Tx transaction,
4078         MarginCommon.Position storage position
4079     )
4080         private
4081         view
4082     {
4083         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4084 
4085         require(
4086             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4087             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4088         );
4089 
4090         // require the position to end no later than the loanOffering's maximum acceptable end time
4091         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4092         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4093         require(
4094             positionEndTimestamp <= offeringEndTimestamp,
4095             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4096         );
4097 
4098         require(
4099             block.timestamp < positionEndTimestamp,
4100             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4101         );
4102     }
4103 
4104     function getCollateralNeededForAddedPrincipal(
4105         MarginState.State storage state,
4106         MarginCommon.Position storage position,
4107         bytes32 positionId,
4108         uint256 principalToAdd
4109     )
4110         private
4111         view
4112         returns (uint256)
4113     {
4114         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4115 
4116         return MathHelpers.getPartialAmountRoundedUp(
4117             principalToAdd,
4118             position.principal,
4119             heldTokenBalance
4120         );
4121     }
4122 
4123     function updateState(
4124         MarginCommon.Position storage position,
4125         bytes32 positionId,
4126         uint256 principalAdded,
4127         uint256 owedTokenLent,
4128         address loanPayer
4129     )
4130         private
4131     {
4132         position.principal = position.principal.add(principalAdded);
4133 
4134         address owner = position.owner;
4135         address lender = position.lender;
4136 
4137         // Ensure owner consent
4138         increasePositionOnBehalfOfRecurse(
4139             owner,
4140             msg.sender,
4141             positionId,
4142             principalAdded
4143         );
4144 
4145         // Ensure lender consent
4146         increaseLoanOnBehalfOfRecurse(
4147             lender,
4148             loanPayer,
4149             positionId,
4150             principalAdded,
4151             owedTokenLent
4152         );
4153     }
4154 
4155     function increasePositionOnBehalfOfRecurse(
4156         address contractAddr,
4157         address trader,
4158         bytes32 positionId,
4159         uint256 principalAdded
4160     )
4161         private
4162     {
4163         // Assume owner approval if not a smart contract and they increased their own position
4164         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4165             return;
4166         }
4167 
4168         address newContractAddr =
4169             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4170                 trader,
4171                 positionId,
4172                 principalAdded
4173             );
4174 
4175         if (newContractAddr != contractAddr) {
4176             increasePositionOnBehalfOfRecurse(
4177                 newContractAddr,
4178                 trader,
4179                 positionId,
4180                 principalAdded
4181             );
4182         }
4183     }
4184 
4185     function increaseLoanOnBehalfOfRecurse(
4186         address contractAddr,
4187         address payer,
4188         bytes32 positionId,
4189         uint256 principalAdded,
4190         uint256 amountLent
4191     )
4192         private
4193     {
4194         // Assume lender approval if not a smart contract and they increased their own loan
4195         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4196             return;
4197         }
4198 
4199         address newContractAddr =
4200             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4201                 payer,
4202                 positionId,
4203                 principalAdded,
4204                 amountLent
4205             );
4206 
4207         if (newContractAddr != contractAddr) {
4208             increaseLoanOnBehalfOfRecurse(
4209                 newContractAddr,
4210                 payer,
4211                 positionId,
4212                 principalAdded,
4213                 amountLent
4214             );
4215         }
4216     }
4217 
4218     function recordPositionIncreased(
4219         BorrowShared.Tx transaction,
4220         MarginCommon.Position storage position
4221     )
4222         private
4223     {
4224         emit PositionIncreased(
4225             transaction.positionId,
4226             msg.sender,
4227             transaction.loanOffering.payer,
4228             position.owner,
4229             position.lender,
4230             transaction.loanOffering.loanHash,
4231             transaction.loanOffering.feeRecipient,
4232             transaction.lenderAmount,
4233             transaction.principal,
4234             transaction.heldTokenFromSell,
4235             transaction.depositAmount,
4236             transaction.depositInHeldToken
4237         );
4238     }
4239 
4240     // ============ Parsing Functions ============
4241 
4242     function parseIncreasePositionTx(
4243         MarginCommon.Position storage position,
4244         bytes32 positionId,
4245         address[7] addresses,
4246         uint256[8] values256,
4247         uint32[2] values32,
4248         bool depositInHeldToken,
4249         bytes signature
4250     )
4251         private
4252         view
4253         returns (BorrowShared.Tx memory)
4254     {
4255         uint256 principal = values256[7];
4256 
4257         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4258             position,
4259             principal,
4260             block.timestamp
4261         );
4262         assert(lenderAmount >= principal);
4263 
4264         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4265             positionId: positionId,
4266             owner: position.owner,
4267             principal: principal,
4268             lenderAmount: lenderAmount,
4269             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4270                 position,
4271                 addresses,
4272                 values256,
4273                 values32,
4274                 signature
4275             ),
4276             exchangeWrapper: addresses[6],
4277             depositInHeldToken: depositInHeldToken,
4278             depositAmount: 0, // set later
4279             collateralAmount: 0, // set later
4280             heldTokenFromSell: 0 // set later
4281         });
4282 
4283         return transaction;
4284     }
4285 
4286     function parseLoanOfferingFromIncreasePositionTx(
4287         MarginCommon.Position storage position,
4288         address[7] addresses,
4289         uint256[8] values256,
4290         uint32[2] values32,
4291         bytes signature
4292     )
4293         private
4294         view
4295         returns (MarginCommon.LoanOffering memory)
4296     {
4297         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4298             owedToken: position.owedToken,
4299             heldToken: position.heldToken,
4300             payer: addresses[0],
4301             owner: position.lender,
4302             taker: addresses[1],
4303             positionOwner: addresses[2],
4304             feeRecipient: addresses[3],
4305             lenderFeeToken: addresses[4],
4306             takerFeeToken: addresses[5],
4307             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4308             expirationTimestamp: values256[5],
4309             callTimeLimit: values32[0],
4310             maxDuration: values32[1],
4311             salt: values256[6],
4312             loanHash: 0,
4313             signature: signature
4314         });
4315 
4316         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4317 
4318         return loanOffering;
4319     }
4320 
4321     function parseLoanOfferingRatesFromIncreasePositionTx(
4322         MarginCommon.Position storage position,
4323         uint256[8] values256
4324     )
4325         private
4326         view
4327         returns (MarginCommon.LoanRates memory)
4328     {
4329         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4330             maxAmount: values256[0],
4331             minAmount: values256[1],
4332             minHeldToken: values256[2],
4333             lenderFee: values256[3],
4334             takerFee: values256[4],
4335             interestRate: position.interestRate,
4336             interestPeriod: position.interestPeriod
4337         });
4338 
4339         return rates;
4340     }
4341 }
4342 
4343 // File: contracts/margin/impl/MarginStorage.sol
4344 
4345 /**
4346  * @title MarginStorage
4347  * @author dYdX
4348  *
4349  * This contract serves as the storage for the entire state of MarginStorage
4350  */
4351 contract MarginStorage {
4352 
4353     MarginState.State state;
4354 
4355 }
4356 
4357 // File: contracts/margin/impl/LoanGetters.sol
4358 
4359 /**
4360  * @title LoanGetters
4361  * @author dYdX
4362  *
4363  * A collection of public constant getter functions that allows reading of the state of any loan
4364  * offering stored in the dYdX protocol.
4365  */
4366 contract LoanGetters is MarginStorage {
4367 
4368     // ============ Public Constant Functions ============
4369 
4370     /**
4371      * Gets the principal amount of a loan offering that is no longer available.
4372      *
4373      * @param  loanHash  Unique hash of the loan offering
4374      * @return           The total unavailable amount of the loan offering, which is equal to the
4375      *                   filled amount plus the canceled amount.
4376      */
4377     function getLoanUnavailableAmount(
4378         bytes32 loanHash
4379     )
4380         external
4381         view
4382         returns (uint256)
4383     {
4384         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4385     }
4386 
4387     /**
4388      * Gets the total amount of owed token lent for a loan.
4389      *
4390      * @param  loanHash  Unique hash of the loan offering
4391      * @return           The total filled amount of the loan offering.
4392      */
4393     function getLoanFilledAmount(
4394         bytes32 loanHash
4395     )
4396         external
4397         view
4398         returns (uint256)
4399     {
4400         return state.loanFills[loanHash];
4401     }
4402 
4403     /**
4404      * Gets the amount of a loan offering that has been canceled.
4405      *
4406      * @param  loanHash  Unique hash of the loan offering
4407      * @return           The total canceled amount of the loan offering.
4408      */
4409     function getLoanCanceledAmount(
4410         bytes32 loanHash
4411     )
4412         external
4413         view
4414         returns (uint256)
4415     {
4416         return state.loanCancels[loanHash];
4417     }
4418 }
4419 
4420 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4421 
4422 /**
4423  * @title CancelMarginCallDelegator
4424  * @author dYdX
4425  *
4426  * Interface that smart contracts must implement in order to let other addresses cancel a
4427  * margin-call for a loan owned by the smart contract.
4428  *
4429  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4430  *       to these functions
4431  */
4432 interface CancelMarginCallDelegator {
4433 
4434     // ============ Public Interface functions ============
4435 
4436     /**
4437      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4438      *
4439      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4440      * either revert the entire transaction or that the margin-call was successfully canceled.
4441      *
4442      * @param  canceler    Address of the caller of the cancelMarginCall function
4443      * @param  positionId  Unique ID of the position
4444      * @return             This address to accept, a different address to ask that contract
4445      */
4446     function cancelMarginCallOnBehalfOf(
4447         address canceler,
4448         bytes32 positionId
4449     )
4450         external
4451         /* onlyMargin */
4452         returns (address);
4453 }
4454 
4455 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4456 
4457 /**
4458  * @title MarginCallDelegator
4459  * @author dYdX
4460  *
4461  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4462  * owned by the smart contract.
4463  *
4464  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4465  *       to these functions
4466  */
4467 interface MarginCallDelegator {
4468 
4469     // ============ Public Interface functions ============
4470 
4471     /**
4472      * Function a contract must implement in order to let other addresses call marginCall().
4473      *
4474      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4475      * either revert the entire transaction or that the loan was successfully margin-called.
4476      *
4477      * @param  caller         Address of the caller of the marginCall function
4478      * @param  positionId     Unique ID of the position
4479      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4480      * @return                This address to accept, a different address to ask that contract
4481      */
4482     function marginCallOnBehalfOf(
4483         address caller,
4484         bytes32 positionId,
4485         uint256 depositAmount
4486     )
4487         external
4488         /* onlyMargin */
4489         returns (address);
4490 }
4491 
4492 // File: contracts/margin/impl/LoanImpl.sol
4493 
4494 /**
4495  * @title LoanImpl
4496  * @author dYdX
4497  *
4498  * This library contains the implementation for the following functions of Margin:
4499  *
4500  *      - marginCall
4501  *      - cancelMarginCallImpl
4502  *      - cancelLoanOffering
4503  */
4504 library LoanImpl {
4505     using SafeMath for uint256;
4506 
4507     // ============ Events ============
4508 
4509     /**
4510      * A position was margin-called
4511      */
4512     event MarginCallInitiated(
4513         bytes32 indexed positionId,
4514         address indexed lender,
4515         address indexed owner,
4516         uint256 requiredDeposit
4517     );
4518 
4519     /**
4520      * A margin call was canceled
4521      */
4522     event MarginCallCanceled(
4523         bytes32 indexed positionId,
4524         address indexed lender,
4525         address indexed owner,
4526         uint256 depositAmount
4527     );
4528 
4529     /**
4530      * A loan offering was canceled before it was used. Any amount less than the
4531      * total for the loan offering can be canceled.
4532      */
4533     event LoanOfferingCanceled(
4534         bytes32 indexed loanHash,
4535         address indexed payer,
4536         address indexed feeRecipient,
4537         uint256 cancelAmount
4538     );
4539 
4540     // ============ Public Implementation Functions ============
4541 
4542     function marginCallImpl(
4543         MarginState.State storage state,
4544         bytes32 positionId,
4545         uint256 requiredDeposit
4546     )
4547         public
4548     {
4549         MarginCommon.Position storage position =
4550             MarginCommon.getPositionFromStorage(state, positionId);
4551 
4552         require(
4553             position.callTimestamp == 0,
4554             "LoanImpl#marginCallImpl: The position has already been margin-called"
4555         );
4556 
4557         // Ensure lender consent
4558         marginCallOnBehalfOfRecurse(
4559             position.lender,
4560             msg.sender,
4561             positionId,
4562             requiredDeposit
4563         );
4564 
4565         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4566         position.requiredDeposit = requiredDeposit;
4567 
4568         emit MarginCallInitiated(
4569             positionId,
4570             position.lender,
4571             position.owner,
4572             requiredDeposit
4573         );
4574     }
4575 
4576     function cancelMarginCallImpl(
4577         MarginState.State storage state,
4578         bytes32 positionId
4579     )
4580         public
4581     {
4582         MarginCommon.Position storage position =
4583             MarginCommon.getPositionFromStorage(state, positionId);
4584 
4585         require(
4586             position.callTimestamp > 0,
4587             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4588         );
4589 
4590         // Ensure lender consent
4591         cancelMarginCallOnBehalfOfRecurse(
4592             position.lender,
4593             msg.sender,
4594             positionId
4595         );
4596 
4597         state.positions[positionId].callTimestamp = 0;
4598         state.positions[positionId].requiredDeposit = 0;
4599 
4600         emit MarginCallCanceled(
4601             positionId,
4602             position.lender,
4603             position.owner,
4604             0
4605         );
4606     }
4607 
4608     function cancelLoanOfferingImpl(
4609         MarginState.State storage state,
4610         address[9] addresses,
4611         uint256[7] values256,
4612         uint32[4]  values32,
4613         uint256    cancelAmount
4614     )
4615         public
4616         returns (uint256)
4617     {
4618         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4619             addresses,
4620             values256,
4621             values32
4622         );
4623 
4624         require(
4625             msg.sender == loanOffering.payer,
4626             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4627         );
4628         require(
4629             loanOffering.expirationTimestamp > block.timestamp,
4630             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4631         );
4632 
4633         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4634             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4635         );
4636         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4637 
4638         // If the loan was already fully canceled, then just return 0 amount was canceled
4639         if (amountToCancel == 0) {
4640             return 0;
4641         }
4642 
4643         state.loanCancels[loanOffering.loanHash] =
4644             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4645 
4646         emit LoanOfferingCanceled(
4647             loanOffering.loanHash,
4648             loanOffering.payer,
4649             loanOffering.feeRecipient,
4650             amountToCancel
4651         );
4652 
4653         return amountToCancel;
4654     }
4655 
4656     // ============ Private Helper-Functions ============
4657 
4658     function marginCallOnBehalfOfRecurse(
4659         address contractAddr,
4660         address who,
4661         bytes32 positionId,
4662         uint256 requiredDeposit
4663     )
4664         private
4665     {
4666         // no need to ask for permission
4667         if (who == contractAddr) {
4668             return;
4669         }
4670 
4671         address newContractAddr =
4672             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4673                 msg.sender,
4674                 positionId,
4675                 requiredDeposit
4676             );
4677 
4678         if (newContractAddr != contractAddr) {
4679             marginCallOnBehalfOfRecurse(
4680                 newContractAddr,
4681                 who,
4682                 positionId,
4683                 requiredDeposit
4684             );
4685         }
4686     }
4687 
4688     function cancelMarginCallOnBehalfOfRecurse(
4689         address contractAddr,
4690         address who,
4691         bytes32 positionId
4692     )
4693         private
4694     {
4695         // no need to ask for permission
4696         if (who == contractAddr) {
4697             return;
4698         }
4699 
4700         address newContractAddr =
4701             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4702                 msg.sender,
4703                 positionId
4704             );
4705 
4706         if (newContractAddr != contractAddr) {
4707             cancelMarginCallOnBehalfOfRecurse(
4708                 newContractAddr,
4709                 who,
4710                 positionId
4711             );
4712         }
4713     }
4714 
4715     // ============ Parsing Functions ============
4716 
4717     function parseLoanOffering(
4718         address[9] addresses,
4719         uint256[7] values256,
4720         uint32[4]  values32
4721     )
4722         private
4723         view
4724         returns (MarginCommon.LoanOffering memory)
4725     {
4726         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4727             owedToken: addresses[0],
4728             heldToken: addresses[1],
4729             payer: addresses[2],
4730             owner: addresses[3],
4731             taker: addresses[4],
4732             positionOwner: addresses[5],
4733             feeRecipient: addresses[6],
4734             lenderFeeToken: addresses[7],
4735             takerFeeToken: addresses[8],
4736             rates: parseLoanOfferRates(values256, values32),
4737             expirationTimestamp: values256[5],
4738             callTimeLimit: values32[0],
4739             maxDuration: values32[1],
4740             salt: values256[6],
4741             loanHash: 0,
4742             signature: new bytes(0)
4743         });
4744 
4745         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4746 
4747         return loanOffering;
4748     }
4749 
4750     function parseLoanOfferRates(
4751         uint256[7] values256,
4752         uint32[4] values32
4753     )
4754         private
4755         pure
4756         returns (MarginCommon.LoanRates memory)
4757     {
4758         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4759             maxAmount: values256[0],
4760             minAmount: values256[1],
4761             minHeldToken: values256[2],
4762             interestRate: values32[2],
4763             lenderFee: values256[3],
4764             takerFee: values256[4],
4765             interestPeriod: values32[3]
4766         });
4767 
4768         return rates;
4769     }
4770 }
4771 
4772 // File: contracts/margin/impl/MarginAdmin.sol
4773 
4774 /**
4775  * @title MarginAdmin
4776  * @author dYdX
4777  *
4778  * Contains admin functions for the Margin contract
4779  * The owner can put Margin into various close-only modes, which will disallow new position creation
4780  */
4781 contract MarginAdmin is Ownable {
4782     // ============ Enums ============
4783 
4784     // All functionality enabled
4785     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4786 
4787     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4788     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4789     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4790 
4791     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4792     // forceRecoverCollateral)
4793     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4794 
4795     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4796     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4797 
4798     // This operation state (and any higher) is invalid
4799     uint8 private constant OPERATION_STATE_INVALID = 4;
4800 
4801     // ============ Events ============
4802 
4803     /**
4804      * Event indicating the operation state has changed
4805      */
4806     event OperationStateChanged(
4807         uint8 from,
4808         uint8 to
4809     );
4810 
4811     // ============ State Variables ============
4812 
4813     uint8 public operationState;
4814 
4815     // ============ Constructor ============
4816 
4817     constructor()
4818         public
4819         Ownable()
4820     {
4821         operationState = OPERATION_STATE_OPERATIONAL;
4822     }
4823 
4824     // ============ Modifiers ============
4825 
4826     modifier onlyWhileOperational() {
4827         require(
4828             operationState == OPERATION_STATE_OPERATIONAL,
4829             "MarginAdmin#onlyWhileOperational: Can only call while operational"
4830         );
4831         _;
4832     }
4833 
4834     modifier cancelLoanOfferingStateControl() {
4835         require(
4836             operationState == OPERATION_STATE_OPERATIONAL
4837             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
4838             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
4839         );
4840         _;
4841     }
4842 
4843     modifier closePositionStateControl() {
4844         require(
4845             operationState == OPERATION_STATE_OPERATIONAL
4846             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
4847             || operationState == OPERATION_STATE_CLOSE_ONLY,
4848             "MarginAdmin#closePositionStateControl: Invalid operation state"
4849         );
4850         _;
4851     }
4852 
4853     modifier closePositionDirectlyStateControl() {
4854         _;
4855     }
4856 
4857     // ============ Owner-Only State-Changing Functions ============
4858 
4859     function setOperationState(
4860         uint8 newState
4861     )
4862         external
4863         onlyOwner
4864     {
4865         require(
4866             newState < OPERATION_STATE_INVALID,
4867             "MarginAdmin#setOperationState: newState is not a valid operation state"
4868         );
4869 
4870         if (newState != operationState) {
4871             emit OperationStateChanged(
4872                 operationState,
4873                 newState
4874             );
4875             operationState = newState;
4876         }
4877     }
4878 }
4879 
4880 // File: contracts/margin/impl/MarginEvents.sol
4881 
4882 /**
4883  * @title MarginEvents
4884  * @author dYdX
4885  *
4886  * Contains events for the Margin contract.
4887  *
4888  * NOTE: Any Margin function libraries that use events will need to both define the event here
4889  *       and copy the event into the library itself as libraries don't support sharing events
4890  */
4891 contract MarginEvents {
4892     // ============ Events ============
4893 
4894     /**
4895      * A position was opened
4896      */
4897     event PositionOpened(
4898         bytes32 indexed positionId,
4899         address indexed trader,
4900         address indexed lender,
4901         bytes32 loanHash,
4902         address owedToken,
4903         address heldToken,
4904         address loanFeeRecipient,
4905         uint256 principal,
4906         uint256 heldTokenFromSell,
4907         uint256 depositAmount,
4908         uint256 interestRate,
4909         uint32  callTimeLimit,
4910         uint32  maxDuration,
4911         bool    depositInHeldToken
4912     );
4913 
4914     /*
4915      * A position was increased
4916      */
4917     event PositionIncreased(
4918         bytes32 indexed positionId,
4919         address indexed trader,
4920         address indexed lender,
4921         address positionOwner,
4922         address loanOwner,
4923         bytes32 loanHash,
4924         address loanFeeRecipient,
4925         uint256 amountBorrowed,
4926         uint256 principalAdded,
4927         uint256 heldTokenFromSell,
4928         uint256 depositAmount,
4929         bool    depositInHeldToken
4930     );
4931 
4932     /**
4933      * A position was closed or partially closed
4934      */
4935     event PositionClosed(
4936         bytes32 indexed positionId,
4937         address indexed closer,
4938         address indexed payoutRecipient,
4939         uint256 closeAmount,
4940         uint256 remainingAmount,
4941         uint256 owedTokenPaidToLender,
4942         uint256 payoutAmount,
4943         uint256 buybackCostInHeldToken,
4944         bool payoutInHeldToken
4945     );
4946 
4947     /**
4948      * Collateral for a position was forcibly recovered
4949      */
4950     event CollateralForceRecovered(
4951         bytes32 indexed positionId,
4952         address indexed recipient,
4953         uint256 amount
4954     );
4955 
4956     /**
4957      * A position was margin-called
4958      */
4959     event MarginCallInitiated(
4960         bytes32 indexed positionId,
4961         address indexed lender,
4962         address indexed owner,
4963         uint256 requiredDeposit
4964     );
4965 
4966     /**
4967      * A margin call was canceled
4968      */
4969     event MarginCallCanceled(
4970         bytes32 indexed positionId,
4971         address indexed lender,
4972         address indexed owner,
4973         uint256 depositAmount
4974     );
4975 
4976     /**
4977      * A loan offering was canceled before it was used. Any amount less than the
4978      * total for the loan offering can be canceled.
4979      */
4980     event LoanOfferingCanceled(
4981         bytes32 indexed loanHash,
4982         address indexed payer,
4983         address indexed feeRecipient,
4984         uint256 cancelAmount
4985     );
4986 
4987     /**
4988      * Additional collateral for a position was posted by the owner
4989      */
4990     event AdditionalCollateralDeposited(
4991         bytes32 indexed positionId,
4992         uint256 amount,
4993         address depositor
4994     );
4995 
4996     /**
4997      * Ownership of a loan was transferred to a new address
4998      */
4999     event LoanTransferred(
5000         bytes32 indexed positionId,
5001         address indexed from,
5002         address indexed to
5003     );
5004 
5005     /**
5006      * Ownership of a position was transferred to a new address
5007      */
5008     event PositionTransferred(
5009         bytes32 indexed positionId,
5010         address indexed from,
5011         address indexed to
5012     );
5013 }
5014 
5015 // File: contracts/margin/impl/OpenPositionImpl.sol
5016 
5017 /**
5018  * @title OpenPositionImpl
5019  * @author dYdX
5020  *
5021  * This library contains the implementation for the openPosition function of Margin
5022  */
5023 library OpenPositionImpl {
5024     using SafeMath for uint256;
5025 
5026     // ============ Events ============
5027 
5028     /**
5029      * A position was opened
5030      */
5031     event PositionOpened(
5032         bytes32 indexed positionId,
5033         address indexed trader,
5034         address indexed lender,
5035         bytes32 loanHash,
5036         address owedToken,
5037         address heldToken,
5038         address loanFeeRecipient,
5039         uint256 principal,
5040         uint256 heldTokenFromSell,
5041         uint256 depositAmount,
5042         uint256 interestRate,
5043         uint32  callTimeLimit,
5044         uint32  maxDuration,
5045         bool    depositInHeldToken
5046     );
5047 
5048     // ============ Public Implementation Functions ============
5049 
5050     function openPositionImpl(
5051         MarginState.State storage state,
5052         address[11] addresses,
5053         uint256[10] values256,
5054         uint32[4] values32,
5055         bool depositInHeldToken,
5056         bytes signature,
5057         bytes orderData
5058     )
5059         public
5060         returns (bytes32)
5061     {
5062         BorrowShared.Tx memory transaction = parseOpenTx(
5063             addresses,
5064             values256,
5065             values32,
5066             depositInHeldToken,
5067             signature
5068         );
5069 
5070         require(
5071             !MarginCommon.positionHasExisted(state, transaction.positionId),
5072             "OpenPositionImpl#openPositionImpl: positionId already exists"
5073         );
5074 
5075         doBorrowAndSell(state, transaction, orderData);
5076 
5077         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5078         recordPositionOpened(
5079             transaction
5080         );
5081 
5082         doStoreNewPosition(
5083             state,
5084             transaction
5085         );
5086 
5087         return transaction.positionId;
5088     }
5089 
5090     // ============ Private Helper-Functions ============
5091 
5092     function doBorrowAndSell(
5093         MarginState.State storage state,
5094         BorrowShared.Tx memory transaction,
5095         bytes orderData
5096     )
5097         private
5098     {
5099         BorrowShared.validateTxPreSell(state, transaction);
5100 
5101         if (transaction.depositInHeldToken) {
5102             BorrowShared.doDepositHeldToken(state, transaction);
5103         } else {
5104             BorrowShared.doDepositOwedToken(state, transaction);
5105         }
5106 
5107         transaction.heldTokenFromSell = BorrowShared.doSell(
5108             state,
5109             transaction,
5110             orderData,
5111             MathHelpers.maxUint256()
5112         );
5113 
5114         BorrowShared.doPostSell(state, transaction);
5115     }
5116 
5117     function doStoreNewPosition(
5118         MarginState.State storage state,
5119         BorrowShared.Tx memory transaction
5120     )
5121         private
5122     {
5123         MarginCommon.storeNewPosition(
5124             state,
5125             transaction.positionId,
5126             MarginCommon.Position({
5127                 owedToken: transaction.loanOffering.owedToken,
5128                 heldToken: transaction.loanOffering.heldToken,
5129                 lender: transaction.loanOffering.owner,
5130                 owner: transaction.owner,
5131                 principal: transaction.principal,
5132                 requiredDeposit: 0,
5133                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5134                 startTimestamp: 0,
5135                 callTimestamp: 0,
5136                 maxDuration: transaction.loanOffering.maxDuration,
5137                 interestRate: transaction.loanOffering.rates.interestRate,
5138                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5139             }),
5140             transaction.loanOffering.payer
5141         );
5142     }
5143 
5144     function recordPositionOpened(
5145         BorrowShared.Tx transaction
5146     )
5147         private
5148     {
5149         emit PositionOpened(
5150             transaction.positionId,
5151             msg.sender,
5152             transaction.loanOffering.payer,
5153             transaction.loanOffering.loanHash,
5154             transaction.loanOffering.owedToken,
5155             transaction.loanOffering.heldToken,
5156             transaction.loanOffering.feeRecipient,
5157             transaction.principal,
5158             transaction.heldTokenFromSell,
5159             transaction.depositAmount,
5160             transaction.loanOffering.rates.interestRate,
5161             transaction.loanOffering.callTimeLimit,
5162             transaction.loanOffering.maxDuration,
5163             transaction.depositInHeldToken
5164         );
5165     }
5166 
5167     // ============ Parsing Functions ============
5168 
5169     function parseOpenTx(
5170         address[11] addresses,
5171         uint256[10] values256,
5172         uint32[4] values32,
5173         bool depositInHeldToken,
5174         bytes signature
5175     )
5176         private
5177         view
5178         returns (BorrowShared.Tx memory)
5179     {
5180         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5181             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5182             owner: addresses[0],
5183             principal: values256[7],
5184             lenderAmount: values256[7],
5185             loanOffering: parseLoanOffering(
5186                 addresses,
5187                 values256,
5188                 values32,
5189                 signature
5190             ),
5191             exchangeWrapper: addresses[10],
5192             depositInHeldToken: depositInHeldToken,
5193             depositAmount: values256[8],
5194             collateralAmount: 0, // set later
5195             heldTokenFromSell: 0 // set later
5196         });
5197 
5198         return transaction;
5199     }
5200 
5201     function parseLoanOffering(
5202         address[11] addresses,
5203         uint256[10] values256,
5204         uint32[4]   values32,
5205         bytes       signature
5206     )
5207         private
5208         view
5209         returns (MarginCommon.LoanOffering memory)
5210     {
5211         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5212             owedToken: addresses[1],
5213             heldToken: addresses[2],
5214             payer: addresses[3],
5215             owner: addresses[4],
5216             taker: addresses[5],
5217             positionOwner: addresses[6],
5218             feeRecipient: addresses[7],
5219             lenderFeeToken: addresses[8],
5220             takerFeeToken: addresses[9],
5221             rates: parseLoanOfferRates(values256, values32),
5222             expirationTimestamp: values256[5],
5223             callTimeLimit: values32[0],
5224             maxDuration: values32[1],
5225             salt: values256[6],
5226             loanHash: 0,
5227             signature: signature
5228         });
5229 
5230         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5231 
5232         return loanOffering;
5233     }
5234 
5235     function parseLoanOfferRates(
5236         uint256[10] values256,
5237         uint32[4] values32
5238     )
5239         private
5240         pure
5241         returns (MarginCommon.LoanRates memory)
5242     {
5243         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5244             maxAmount: values256[0],
5245             minAmount: values256[1],
5246             minHeldToken: values256[2],
5247             lenderFee: values256[3],
5248             takerFee: values256[4],
5249             interestRate: values32[2],
5250             interestPeriod: values32[3]
5251         });
5252 
5253         return rates;
5254     }
5255 }
5256 
5257 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5258 
5259 /**
5260  * @title OpenWithoutCounterpartyImpl
5261  * @author dYdX
5262  *
5263  * This library contains the implementation for the openWithoutCounterparty
5264  * function of Margin
5265  */
5266 library OpenWithoutCounterpartyImpl {
5267 
5268     // ============ Structs ============
5269 
5270     struct Tx {
5271         bytes32 positionId;
5272         address positionOwner;
5273         address owedToken;
5274         address heldToken;
5275         address loanOwner;
5276         uint256 principal;
5277         uint256 deposit;
5278         uint32 callTimeLimit;
5279         uint32 maxDuration;
5280         uint32 interestRate;
5281         uint32 interestPeriod;
5282     }
5283 
5284     // ============ Events ============
5285 
5286     /**
5287      * A position was opened
5288      */
5289     event PositionOpened(
5290         bytes32 indexed positionId,
5291         address indexed trader,
5292         address indexed lender,
5293         bytes32 loanHash,
5294         address owedToken,
5295         address heldToken,
5296         address loanFeeRecipient,
5297         uint256 principal,
5298         uint256 heldTokenFromSell,
5299         uint256 depositAmount,
5300         uint256 interestRate,
5301         uint32  callTimeLimit,
5302         uint32  maxDuration,
5303         bool    depositInHeldToken
5304     );
5305 
5306     // ============ Public Implementation Functions ============
5307 
5308     function openWithoutCounterpartyImpl(
5309         MarginState.State storage state,
5310         address[4] addresses,
5311         uint256[3] values256,
5312         uint32[4]  values32
5313     )
5314         public
5315         returns (bytes32)
5316     {
5317         Tx memory openTx = parseTx(
5318             addresses,
5319             values256,
5320             values32
5321         );
5322 
5323         validate(
5324             state,
5325             openTx
5326         );
5327 
5328         Vault(state.VAULT).transferToVault(
5329             openTx.positionId,
5330             openTx.heldToken,
5331             msg.sender,
5332             openTx.deposit
5333         );
5334 
5335         recordPositionOpened(
5336             openTx
5337         );
5338 
5339         doStoreNewPosition(
5340             state,
5341             openTx
5342         );
5343 
5344         return openTx.positionId;
5345     }
5346 
5347     // ============ Private Helper-Functions ============
5348 
5349     function doStoreNewPosition(
5350         MarginState.State storage state,
5351         Tx memory openTx
5352     )
5353         private
5354     {
5355         MarginCommon.storeNewPosition(
5356             state,
5357             openTx.positionId,
5358             MarginCommon.Position({
5359                 owedToken: openTx.owedToken,
5360                 heldToken: openTx.heldToken,
5361                 lender: openTx.loanOwner,
5362                 owner: openTx.positionOwner,
5363                 principal: openTx.principal,
5364                 requiredDeposit: 0,
5365                 callTimeLimit: openTx.callTimeLimit,
5366                 startTimestamp: 0,
5367                 callTimestamp: 0,
5368                 maxDuration: openTx.maxDuration,
5369                 interestRate: openTx.interestRate,
5370                 interestPeriod: openTx.interestPeriod
5371             }),
5372             msg.sender
5373         );
5374     }
5375 
5376     function validate(
5377         MarginState.State storage state,
5378         Tx memory openTx
5379     )
5380         private
5381         view
5382     {
5383         require(
5384             !MarginCommon.positionHasExisted(state, openTx.positionId),
5385             "openWithoutCounterpartyImpl#validate: positionId already exists"
5386         );
5387 
5388         require(
5389             openTx.principal > 0,
5390             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5391         );
5392 
5393         require(
5394             openTx.owedToken != address(0),
5395             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5396         );
5397 
5398         require(
5399             openTx.owedToken != openTx.heldToken,
5400             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5401         );
5402 
5403         require(
5404             openTx.positionOwner != address(0),
5405             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5406         );
5407 
5408         require(
5409             openTx.loanOwner != address(0),
5410             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5411         );
5412 
5413         require(
5414             openTx.maxDuration > 0,
5415             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5416         );
5417 
5418         require(
5419             openTx.interestPeriod <= openTx.maxDuration,
5420             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5421         );
5422     }
5423 
5424     function recordPositionOpened(
5425         Tx memory openTx
5426     )
5427         private
5428     {
5429         emit PositionOpened(
5430             openTx.positionId,
5431             msg.sender,
5432             msg.sender,
5433             bytes32(0),
5434             openTx.owedToken,
5435             openTx.heldToken,
5436             address(0),
5437             openTx.principal,
5438             0,
5439             openTx.deposit,
5440             openTx.interestRate,
5441             openTx.callTimeLimit,
5442             openTx.maxDuration,
5443             true
5444         );
5445     }
5446 
5447     // ============ Parsing Functions ============
5448 
5449     function parseTx(
5450         address[4] addresses,
5451         uint256[3] values256,
5452         uint32[4]  values32
5453     )
5454         private
5455         view
5456         returns (Tx memory)
5457     {
5458         Tx memory openTx = Tx({
5459             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5460             positionOwner: addresses[0],
5461             owedToken: addresses[1],
5462             heldToken: addresses[2],
5463             loanOwner: addresses[3],
5464             principal: values256[0],
5465             deposit: values256[1],
5466             callTimeLimit: values32[0],
5467             maxDuration: values32[1],
5468             interestRate: values32[2],
5469             interestPeriod: values32[3]
5470         });
5471 
5472         return openTx;
5473     }
5474 }
5475 
5476 // File: contracts/margin/impl/PositionGetters.sol
5477 
5478 /**
5479  * @title PositionGetters
5480  * @author dYdX
5481  *
5482  * A collection of public constant getter functions that allows reading of the state of any position
5483  * stored in the dYdX protocol.
5484  */
5485 contract PositionGetters is MarginStorage {
5486     using SafeMath for uint256;
5487 
5488     // ============ Public Constant Functions ============
5489 
5490     /**
5491      * Gets if a position is currently open.
5492      *
5493      * @param  positionId  Unique ID of the position
5494      * @return             True if the position is exists and is open
5495      */
5496     function containsPosition(
5497         bytes32 positionId
5498     )
5499         external
5500         view
5501         returns (bool)
5502     {
5503         return MarginCommon.containsPositionImpl(state, positionId);
5504     }
5505 
5506     /**
5507      * Gets if a position is currently margin-called.
5508      *
5509      * @param  positionId  Unique ID of the position
5510      * @return             True if the position is margin-called
5511      */
5512     function isPositionCalled(
5513         bytes32 positionId
5514     )
5515         external
5516         view
5517         returns (bool)
5518     {
5519         return (state.positions[positionId].callTimestamp > 0);
5520     }
5521 
5522     /**
5523      * Gets if a position was previously open and is now closed.
5524      *
5525      * @param  positionId  Unique ID of the position
5526      * @return             True if the position is now closed
5527      */
5528     function isPositionClosed(
5529         bytes32 positionId
5530     )
5531         external
5532         view
5533         returns (bool)
5534     {
5535         return state.closedPositions[positionId];
5536     }
5537 
5538     /**
5539      * Gets the total amount of owedToken ever repaid to the lender for a position.
5540      *
5541      * @param  positionId  Unique ID of the position
5542      * @return             Total amount of owedToken ever repaid
5543      */
5544     function getTotalOwedTokenRepaidToLender(
5545         bytes32 positionId
5546     )
5547         external
5548         view
5549         returns (uint256)
5550     {
5551         return state.totalOwedTokenRepaidToLender[positionId];
5552     }
5553 
5554     /**
5555      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5556      *
5557      * @param  positionId  Unique ID of the position
5558      * @return             The amount of heldToken
5559      */
5560     function getPositionBalance(
5561         bytes32 positionId
5562     )
5563         external
5564         view
5565         returns (uint256)
5566     {
5567         return MarginCommon.getPositionBalanceImpl(state, positionId);
5568     }
5569 
5570     /**
5571      * Gets the time until the interest fee charged for the position will increase.
5572      * Returns 1 if the interest fee increases every second.
5573      * Returns 0 if the interest fee will never increase again.
5574      *
5575      * @param  positionId  Unique ID of the position
5576      * @return             The number of seconds until the interest fee will increase
5577      */
5578     function getTimeUntilInterestIncrease(
5579         bytes32 positionId
5580     )
5581         external
5582         view
5583         returns (uint256)
5584     {
5585         MarginCommon.Position storage position =
5586             MarginCommon.getPositionFromStorage(state, positionId);
5587 
5588         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5589             position,
5590             block.timestamp
5591         );
5592 
5593         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5594         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5595             return 0;
5596         } else {
5597             // nextStep is the final second at which the calculated interest fee is the same as it
5598             // is currently, so add 1 to get the correct value
5599             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5600         }
5601     }
5602 
5603     /**
5604      * Gets the amount of owedTokens currently needed to close the position completely, including
5605      * interest fees.
5606      *
5607      * @param  positionId  Unique ID of the position
5608      * @return             The number of owedTokens
5609      */
5610     function getPositionOwedAmount(
5611         bytes32 positionId
5612     )
5613         external
5614         view
5615         returns (uint256)
5616     {
5617         MarginCommon.Position storage position =
5618             MarginCommon.getPositionFromStorage(state, positionId);
5619 
5620         return MarginCommon.calculateOwedAmount(
5621             position,
5622             position.principal,
5623             block.timestamp
5624         );
5625     }
5626 
5627     /**
5628      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5629      * given time, including interest fees.
5630      *
5631      * @param  positionId         Unique ID of the position
5632      * @param  principalToClose   Amount of principal being closed
5633      * @param  timestamp          Block timestamp in seconds of close
5634      * @return                    The number of owedTokens owed
5635      */
5636     function getPositionOwedAmountAtTime(
5637         bytes32 positionId,
5638         uint256 principalToClose,
5639         uint32  timestamp
5640     )
5641         external
5642         view
5643         returns (uint256)
5644     {
5645         MarginCommon.Position storage position =
5646             MarginCommon.getPositionFromStorage(state, positionId);
5647 
5648         require(
5649             timestamp >= position.startTimestamp,
5650             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5651         );
5652 
5653         return MarginCommon.calculateOwedAmount(
5654             position,
5655             principalToClose,
5656             timestamp
5657         );
5658     }
5659 
5660     /**
5661      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5662      * amount to the position at a given time.
5663      *
5664      * @param  positionId      Unique ID of the position
5665      * @param  principalToAdd  Amount being added to principal
5666      * @param  timestamp       Block timestamp in seconds of addition
5667      * @return                 The number of owedTokens that will be borrowed
5668      */
5669     function getLenderAmountForIncreasePositionAtTime(
5670         bytes32 positionId,
5671         uint256 principalToAdd,
5672         uint32  timestamp
5673     )
5674         external
5675         view
5676         returns (uint256)
5677     {
5678         MarginCommon.Position storage position =
5679             MarginCommon.getPositionFromStorage(state, positionId);
5680 
5681         require(
5682             timestamp >= position.startTimestamp,
5683             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5684         );
5685 
5686         return MarginCommon.calculateLenderAmountForIncreasePosition(
5687             position,
5688             principalToAdd,
5689             timestamp
5690         );
5691     }
5692 
5693     // ============ All Properties ============
5694 
5695     /**
5696      * Get a Position by id. This does not validate the position exists. If the position does not
5697      * exist, all 0's will be returned.
5698      *
5699      * @param  positionId  Unique ID of the position
5700      * @return             Addresses corresponding to:
5701      *
5702      *                     [0] = owedToken
5703      *                     [1] = heldToken
5704      *                     [2] = lender
5705      *                     [3] = owner
5706      *
5707      *                     Values corresponding to:
5708      *
5709      *                     [0] = principal
5710      *                     [1] = requiredDeposit
5711      *
5712      *                     Values corresponding to:
5713      *
5714      *                     [0] = callTimeLimit
5715      *                     [1] = startTimestamp
5716      *                     [2] = callTimestamp
5717      *                     [3] = maxDuration
5718      *                     [4] = interestRate
5719      *                     [5] = interestPeriod
5720      */
5721     function getPosition(
5722         bytes32 positionId
5723     )
5724         external
5725         view
5726         returns (
5727             address[4],
5728             uint256[2],
5729             uint32[6]
5730         )
5731     {
5732         MarginCommon.Position storage position = state.positions[positionId];
5733 
5734         return (
5735             [
5736                 position.owedToken,
5737                 position.heldToken,
5738                 position.lender,
5739                 position.owner
5740             ],
5741             [
5742                 position.principal,
5743                 position.requiredDeposit
5744             ],
5745             [
5746                 position.callTimeLimit,
5747                 position.startTimestamp,
5748                 position.callTimestamp,
5749                 position.maxDuration,
5750                 position.interestRate,
5751                 position.interestPeriod
5752             ]
5753         );
5754     }
5755 
5756     // ============ Individual Properties ============
5757 
5758     function getPositionLender(
5759         bytes32 positionId
5760     )
5761         external
5762         view
5763         returns (address)
5764     {
5765         return state.positions[positionId].lender;
5766     }
5767 
5768     function getPositionOwner(
5769         bytes32 positionId
5770     )
5771         external
5772         view
5773         returns (address)
5774     {
5775         return state.positions[positionId].owner;
5776     }
5777 
5778     function getPositionHeldToken(
5779         bytes32 positionId
5780     )
5781         external
5782         view
5783         returns (address)
5784     {
5785         return state.positions[positionId].heldToken;
5786     }
5787 
5788     function getPositionOwedToken(
5789         bytes32 positionId
5790     )
5791         external
5792         view
5793         returns (address)
5794     {
5795         return state.positions[positionId].owedToken;
5796     }
5797 
5798     function getPositionPrincipal(
5799         bytes32 positionId
5800     )
5801         external
5802         view
5803         returns (uint256)
5804     {
5805         return state.positions[positionId].principal;
5806     }
5807 
5808     function getPositionInterestRate(
5809         bytes32 positionId
5810     )
5811         external
5812         view
5813         returns (uint256)
5814     {
5815         return state.positions[positionId].interestRate;
5816     }
5817 
5818     function getPositionRequiredDeposit(
5819         bytes32 positionId
5820     )
5821         external
5822         view
5823         returns (uint256)
5824     {
5825         return state.positions[positionId].requiredDeposit;
5826     }
5827 
5828     function getPositionStartTimestamp(
5829         bytes32 positionId
5830     )
5831         external
5832         view
5833         returns (uint32)
5834     {
5835         return state.positions[positionId].startTimestamp;
5836     }
5837 
5838     function getPositionCallTimestamp(
5839         bytes32 positionId
5840     )
5841         external
5842         view
5843         returns (uint32)
5844     {
5845         return state.positions[positionId].callTimestamp;
5846     }
5847 
5848     function getPositionCallTimeLimit(
5849         bytes32 positionId
5850     )
5851         external
5852         view
5853         returns (uint32)
5854     {
5855         return state.positions[positionId].callTimeLimit;
5856     }
5857 
5858     function getPositionMaxDuration(
5859         bytes32 positionId
5860     )
5861         external
5862         view
5863         returns (uint32)
5864     {
5865         return state.positions[positionId].maxDuration;
5866     }
5867 
5868     function getPositioninterestPeriod(
5869         bytes32 positionId
5870     )
5871         external
5872         view
5873         returns (uint32)
5874     {
5875         return state.positions[positionId].interestPeriod;
5876     }
5877 }
5878 
5879 // File: contracts/margin/impl/TransferImpl.sol
5880 
5881 /**
5882  * @title TransferImpl
5883  * @author dYdX
5884  *
5885  * This library contains the implementation for the transferPosition and transferLoan functions of
5886  * Margin
5887  */
5888 library TransferImpl {
5889 
5890     // ============ Public Implementation Functions ============
5891 
5892     function transferLoanImpl(
5893         MarginState.State storage state,
5894         bytes32 positionId,
5895         address newLender
5896     )
5897         public
5898     {
5899         require(
5900             MarginCommon.containsPositionImpl(state, positionId),
5901             "TransferImpl#transferLoanImpl: Position does not exist"
5902         );
5903 
5904         address originalLender = state.positions[positionId].lender;
5905 
5906         require(
5907             msg.sender == originalLender,
5908             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
5909         );
5910         require(
5911             newLender != originalLender,
5912             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
5913         );
5914 
5915         // Doesn't change the state of positionId; figures out the final owner of loan.
5916         // That is, newLender may pass ownership to a different address.
5917         address finalLender = TransferInternal.grantLoanOwnership(
5918             positionId,
5919             originalLender,
5920             newLender);
5921 
5922         require(
5923             finalLender != originalLender,
5924             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
5925         );
5926 
5927         // Set state only after resolving the new owner (to reduce the number of storage calls)
5928         state.positions[positionId].lender = finalLender;
5929     }
5930 
5931     function transferPositionImpl(
5932         MarginState.State storage state,
5933         bytes32 positionId,
5934         address newOwner
5935     )
5936         public
5937     {
5938         require(
5939             MarginCommon.containsPositionImpl(state, positionId),
5940             "TransferImpl#transferPositionImpl: Position does not exist"
5941         );
5942 
5943         address originalOwner = state.positions[positionId].owner;
5944 
5945         require(
5946             msg.sender == originalOwner,
5947             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
5948         );
5949         require(
5950             newOwner != originalOwner,
5951             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
5952         );
5953 
5954         // Doesn't change the state of positionId; figures out the final owner of position.
5955         // That is, newOwner may pass ownership to a different address.
5956         address finalOwner = TransferInternal.grantPositionOwnership(
5957             positionId,
5958             originalOwner,
5959             newOwner);
5960 
5961         require(
5962             finalOwner != originalOwner,
5963             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
5964         );
5965 
5966         // Set state only after resolving the new owner (to reduce the number of storage calls)
5967         state.positions[positionId].owner = finalOwner;
5968     }
5969 }
5970 
5971 // File: contracts/margin/Margin.sol
5972 
5973 /**
5974  * @title Margin
5975  * @author dYdX
5976  *
5977  * This contract is used to facilitate margin trading as per the dYdX protocol
5978  */
5979 contract Margin is
5980     ReentrancyGuard,
5981     MarginStorage,
5982     MarginEvents,
5983     MarginAdmin,
5984     LoanGetters,
5985     PositionGetters
5986 {
5987 
5988     using SafeMath for uint256;
5989 
5990     // ============ Constructor ============
5991 
5992     constructor(
5993         address vault,
5994         address proxy
5995     )
5996         public
5997         MarginAdmin()
5998     {
5999         state = MarginState.State({
6000             VAULT: vault,
6001             TOKEN_PROXY: proxy
6002         });
6003     }
6004 
6005     // ============ Public State Changing Functions ============
6006 
6007     /**
6008      * Open a margin position. Called by the margin trader who must provide both a
6009      * signed loan offering as well as a DEX Order with which to sell the owedToken.
6010      *
6011      * @param  addresses           Addresses corresponding to:
6012      *
6013      *  [0]  = position owner
6014      *  [1]  = owedToken
6015      *  [2]  = heldToken
6016      *  [3]  = loan payer
6017      *  [4]  = loan owner
6018      *  [5]  = loan taker
6019      *  [6]  = loan position owner
6020      *  [7]  = loan fee recipient
6021      *  [8]  = loan lender fee token
6022      *  [9]  = loan taker fee token
6023      *  [10]  = exchange wrapper address
6024      *
6025      * @param  values256           Values corresponding to:
6026      *
6027      *  [0]  = loan maximum amount
6028      *  [1]  = loan minimum amount
6029      *  [2]  = loan minimum heldToken
6030      *  [3]  = loan lender fee
6031      *  [4]  = loan taker fee
6032      *  [5]  = loan expiration timestamp (in seconds)
6033      *  [6]  = loan salt
6034      *  [7]  = position amount of principal
6035      *  [8]  = deposit amount
6036      *  [9]  = nonce (used to calculate positionId)
6037      *
6038      * @param  values32            Values corresponding to:
6039      *
6040      *  [0] = loan call time limit (in seconds)
6041      *  [1] = loan maxDuration (in seconds)
6042      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6043      *  [3] = loan interest update period (in seconds)
6044      *
6045      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6046      *                             False if the margin deposit will be in owedToken
6047      *                             and then sold along with the owedToken borrowed from the lender
6048      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6049      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6050      *                             is a smart contract, these are arbitrary bytes that the contract
6051      *                             will recieve when choosing whether to approve the loan.
6052      * @param  order               Order object to be passed to the exchange wrapper
6053      * @return                     Unique ID for the new position
6054      */
6055     function openPosition(
6056         address[11] addresses,
6057         uint256[10] values256,
6058         uint32[4]   values32,
6059         bool        depositInHeldToken,
6060         bytes       signature,
6061         bytes       order
6062     )
6063         external
6064         onlyWhileOperational
6065         nonReentrant
6066         returns (bytes32)
6067     {
6068         return OpenPositionImpl.openPositionImpl(
6069             state,
6070             addresses,
6071             values256,
6072             values32,
6073             depositInHeldToken,
6074             signature,
6075             order
6076         );
6077     }
6078 
6079     /**
6080      * Open a margin position without a counterparty. The caller will serve as both the
6081      * lender and the position owner
6082      *
6083      * @param  addresses    Addresses corresponding to:
6084      *
6085      *  [0]  = position owner
6086      *  [1]  = owedToken
6087      *  [2]  = heldToken
6088      *  [3]  = loan owner
6089      *
6090      * @param  values256    Values corresponding to:
6091      *
6092      *  [0]  = principal
6093      *  [1]  = deposit amount
6094      *  [2]  = nonce (used to calculate positionId)
6095      *
6096      * @param  values32     Values corresponding to:
6097      *
6098      *  [0] = call time limit (in seconds)
6099      *  [1] = maxDuration (in seconds)
6100      *  [2] = interest rate (annual nominal percentage times 10**6)
6101      *  [3] = interest update period (in seconds)
6102      *
6103      * @return              Unique ID for the new position
6104      */
6105     function openWithoutCounterparty(
6106         address[4] addresses,
6107         uint256[3] values256,
6108         uint32[4]  values32
6109     )
6110         external
6111         onlyWhileOperational
6112         nonReentrant
6113         returns (bytes32)
6114     {
6115         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6116             state,
6117             addresses,
6118             values256,
6119             values32
6120         );
6121     }
6122 
6123     /**
6124      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6125      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6126      * principal added, as it will incorporate interest already earned by the position so far.
6127      *
6128      * @param  positionId          Unique ID of the position
6129      * @param  addresses           Addresses corresponding to:
6130      *
6131      *  [0]  = loan payer
6132      *  [1]  = loan taker
6133      *  [2]  = loan position owner
6134      *  [3]  = loan fee recipient
6135      *  [4]  = loan lender fee token
6136      *  [5]  = loan taker fee token
6137      *  [6]  = exchange wrapper address
6138      *
6139      * @param  values256           Values corresponding to:
6140      *
6141      *  [0]  = loan maximum amount
6142      *  [1]  = loan minimum amount
6143      *  [2]  = loan minimum heldToken
6144      *  [3]  = loan lender fee
6145      *  [4]  = loan taker fee
6146      *  [5]  = loan expiration timestamp (in seconds)
6147      *  [6]  = loan salt
6148      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6149      *                                                           will be >= this amount)
6150      *
6151      * @param  values32            Values corresponding to:
6152      *
6153      *  [0] = loan call time limit (in seconds)
6154      *  [1] = loan maxDuration (in seconds)
6155      *
6156      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6157      *                             False if the margin deposit will be pulled in owedToken
6158      *                             and then sold along with the owedToken borrowed from the lender
6159      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6160      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6161      *                             is a smart contract, these are arbitrary bytes that the contract
6162      *                             will recieve when choosing whether to approve the loan.
6163      * @param  order               Order object to be passed to the exchange wrapper
6164      * @return                     Amount of owedTokens pulled from the lender
6165      */
6166     function increasePosition(
6167         bytes32    positionId,
6168         address[7] addresses,
6169         uint256[8] values256,
6170         uint32[2]  values32,
6171         bool       depositInHeldToken,
6172         bytes      signature,
6173         bytes      order
6174     )
6175         external
6176         onlyWhileOperational
6177         nonReentrant
6178         returns (uint256)
6179     {
6180         return IncreasePositionImpl.increasePositionImpl(
6181             state,
6182             positionId,
6183             addresses,
6184             values256,
6185             values32,
6186             depositInHeldToken,
6187             signature,
6188             order
6189         );
6190     }
6191 
6192     /**
6193      * Increase a position directly by putting up heldToken. The caller will serve as both the
6194      * lender and the position owner
6195      *
6196      * @param  positionId      Unique ID of the position
6197      * @param  principalToAdd  Principal amount to add to the position
6198      * @return                 Amount of heldToken pulled from the msg.sender
6199      */
6200     function increaseWithoutCounterparty(
6201         bytes32 positionId,
6202         uint256 principalToAdd
6203     )
6204         external
6205         onlyWhileOperational
6206         nonReentrant
6207         returns (uint256)
6208     {
6209         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6210             state,
6211             positionId,
6212             principalToAdd
6213         );
6214     }
6215 
6216     /**
6217      * Close a position. May be called by the owner or with the approval of the owner. May provide
6218      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6219      * is sent the resulting payout.
6220      *
6221      * @param  positionId            Unique ID of the position
6222      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6223      *                               closed is also bounded by:
6224      *                               1) The principal of the position
6225      *                               2) The amount allowed by the owner if closer != owner
6226      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6227      * @param  exchangeWrapper       Address of the exchange wrapper
6228      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6229      *                               False to pay out the payoutRecipient in owedToken
6230      * @param  order                 Order object to be passed to the exchange wrapper
6231      * @return                       Values corresponding to:
6232      *                               1) Principal of position closed
6233      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6234      *                                  owedToken otherwise) received by the payoutRecipient
6235      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6236      */
6237     function closePosition(
6238         bytes32 positionId,
6239         uint256 requestedCloseAmount,
6240         address payoutRecipient,
6241         address exchangeWrapper,
6242         bool    payoutInHeldToken,
6243         bytes   order
6244     )
6245         external
6246         closePositionStateControl
6247         nonReentrant
6248         returns (uint256, uint256, uint256)
6249     {
6250         return ClosePositionImpl.closePositionImpl(
6251             state,
6252             positionId,
6253             requestedCloseAmount,
6254             payoutRecipient,
6255             exchangeWrapper,
6256             payoutInHeldToken,
6257             order
6258         );
6259     }
6260 
6261     /**
6262      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6263      *
6264      * @param  positionId            Unique ID of the position
6265      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6266      *                               closed is also bounded by:
6267      *                               1) The principal of the position
6268      *                               2) The amount allowed by the owner if closer != owner
6269      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6270      * @return                       Values corresponding to:
6271      *                               1) Principal amount of position closed
6272      *                               2) Amount of heldToken received by the payoutRecipient
6273      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6274      */
6275     function closePositionDirectly(
6276         bytes32 positionId,
6277         uint256 requestedCloseAmount,
6278         address payoutRecipient
6279     )
6280         external
6281         closePositionDirectlyStateControl
6282         nonReentrant
6283         returns (uint256, uint256, uint256)
6284     {
6285         return ClosePositionImpl.closePositionImpl(
6286             state,
6287             positionId,
6288             requestedCloseAmount,
6289             payoutRecipient,
6290             address(0),
6291             true,
6292             new bytes(0)
6293         );
6294     }
6295 
6296     /**
6297      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6298      * Must be approved by both the position owner and lender.
6299      *
6300      * @param  positionId            Unique ID of the position
6301      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6302      *                               closed is also bounded by:
6303      *                               1) The principal of the position
6304      *                               2) The amount allowed by the owner if closer != owner
6305      *                               3) The amount allowed by the lender if closer != lender
6306      * @return                       Values corresponding to:
6307      *                               1) Principal amount of position closed
6308      *                               2) Amount of heldToken received by the msg.sender
6309      */
6310     function closeWithoutCounterparty(
6311         bytes32 positionId,
6312         uint256 requestedCloseAmount,
6313         address payoutRecipient
6314     )
6315         external
6316         closePositionStateControl
6317         nonReentrant
6318         returns (uint256, uint256)
6319     {
6320         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6321             state,
6322             positionId,
6323             requestedCloseAmount,
6324             payoutRecipient
6325         );
6326     }
6327 
6328     /**
6329      * Margin-call a position. Only callable with the approval of the position lender. After the
6330      * call, the position owner will have time equal to the callTimeLimit of the position to close
6331      * the position. If the owner does not close the position, the lender can recover the collateral
6332      * in the position.
6333      *
6334      * @param  positionId       Unique ID of the position
6335      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6336      *                          the margin-call. Passing in 0 means the margin call cannot be
6337      *                          canceled by depositing
6338      */
6339     function marginCall(
6340         bytes32 positionId,
6341         uint256 requiredDeposit
6342     )
6343         external
6344         nonReentrant
6345     {
6346         LoanImpl.marginCallImpl(
6347             state,
6348             positionId,
6349             requiredDeposit
6350         );
6351     }
6352 
6353     /**
6354      * Cancel a margin-call. Only callable with the approval of the position lender.
6355      *
6356      * @param  positionId  Unique ID of the position
6357      */
6358     function cancelMarginCall(
6359         bytes32 positionId
6360     )
6361         external
6362         onlyWhileOperational
6363         nonReentrant
6364     {
6365         LoanImpl.cancelMarginCallImpl(state, positionId);
6366     }
6367 
6368     /**
6369      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6370      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6371      * but remains unclosed. Only callable with the approval of the position lender.
6372      *
6373      * @param  positionId  Unique ID of the position
6374      * @param  recipient   Address to send the recovered tokens to
6375      * @return             Amount of heldToken recovered
6376      */
6377     function forceRecoverCollateral(
6378         bytes32 positionId,
6379         address recipient
6380     )
6381         external
6382         nonReentrant
6383         returns (uint256)
6384     {
6385         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6386             state,
6387             positionId,
6388             recipient
6389         );
6390     }
6391 
6392     /**
6393      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6394      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6395      *
6396      * @param  positionId       Unique ID of the position
6397      * @param  depositAmount    Additional amount in heldToken to deposit
6398      */
6399     function depositCollateral(
6400         bytes32 positionId,
6401         uint256 depositAmount
6402     )
6403         external
6404         onlyWhileOperational
6405         nonReentrant
6406     {
6407         DepositCollateralImpl.depositCollateralImpl(
6408             state,
6409             positionId,
6410             depositAmount
6411         );
6412     }
6413 
6414     /**
6415      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6416      *
6417      * @param  addresses     Array of addresses:
6418      *
6419      *  [0] = owedToken
6420      *  [1] = heldToken
6421      *  [2] = loan payer
6422      *  [3] = loan owner
6423      *  [4] = loan taker
6424      *  [5] = loan position owner
6425      *  [6] = loan fee recipient
6426      *  [7] = loan lender fee token
6427      *  [8] = loan taker fee token
6428      *
6429      * @param  values256     Values corresponding to:
6430      *
6431      *  [0] = loan maximum amount
6432      *  [1] = loan minimum amount
6433      *  [2] = loan minimum heldToken
6434      *  [3] = loan lender fee
6435      *  [4] = loan taker fee
6436      *  [5] = loan expiration timestamp (in seconds)
6437      *  [6] = loan salt
6438      *
6439      * @param  values32      Values corresponding to:
6440      *
6441      *  [0] = loan call time limit (in seconds)
6442      *  [1] = loan maxDuration (in seconds)
6443      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6444      *  [3] = loan interest update period (in seconds)
6445      *
6446      * @param  cancelAmount  Amount to cancel
6447      * @return               Amount that was canceled
6448      */
6449     function cancelLoanOffering(
6450         address[9] addresses,
6451         uint256[7]  values256,
6452         uint32[4]   values32,
6453         uint256     cancelAmount
6454     )
6455         external
6456         cancelLoanOfferingStateControl
6457         nonReentrant
6458         returns (uint256)
6459     {
6460         return LoanImpl.cancelLoanOfferingImpl(
6461             state,
6462             addresses,
6463             values256,
6464             values32,
6465             cancelAmount
6466         );
6467     }
6468 
6469     /**
6470      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6471      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6472      * must implement the LoanOwner interface.
6473      *
6474      * @param  positionId  Unique ID of the position
6475      * @param  who         New owner of the loan
6476      */
6477     function transferLoan(
6478         bytes32 positionId,
6479         address who
6480     )
6481         external
6482         nonReentrant
6483     {
6484         TransferImpl.transferLoanImpl(
6485             state,
6486             positionId,
6487             who);
6488     }
6489 
6490     /**
6491      * Transfer ownership of a position to a new address. This new address will be entitled to all
6492      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6493      * the PositionOwner interface.
6494      *
6495      * @param  positionId  Unique ID of the position
6496      * @param  who         New owner of the position
6497      */
6498     function transferPosition(
6499         bytes32 positionId,
6500         address who
6501     )
6502         external
6503         nonReentrant
6504     {
6505         TransferImpl.transferPositionImpl(
6506             state,
6507             positionId,
6508             who);
6509     }
6510 
6511     // ============ Public Constant Functions ============
6512 
6513     /**
6514      * Gets the address of the Vault contract that holds and accounts for tokens.
6515      *
6516      * @return  The address of the Vault contract
6517      */
6518     function getVaultAddress()
6519         external
6520         view
6521         returns (address)
6522     {
6523         return state.VAULT;
6524     }
6525 
6526     /**
6527      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6528      * make loans or open/close positions.
6529      *
6530      * @return  The address of the TokenProxy contract
6531      */
6532     function getTokenProxyAddress()
6533         external
6534         view
6535         returns (address)
6536     {
6537         return state.TOKEN_PROXY;
6538     }
6539 }
6540 
6541 // File: contracts/margin/external/PayableMarginMinter.sol
6542 
6543 /**
6544  * @title PayableMarginMinter
6545  * @author dYdX
6546  *
6547  * Contract for allowing anyone to mint short or margin-long tokens using a payable function
6548  */
6549 contract PayableMarginMinter is ReentrancyGuard {
6550     using TokenInteract for address;
6551 
6552     // ============ State Variables ============
6553 
6554     address public DYDX_MARGIN;
6555 
6556     address public WETH;
6557 
6558     // ============ Constructor ============
6559 
6560     constructor(
6561         address margin,
6562         address weth
6563     )
6564         public
6565     {
6566         DYDX_MARGIN = margin;
6567         WETH = weth;
6568 
6569         // WETH approval of maxInt does not decrease
6570         address tokenProxy = Margin(DYDX_MARGIN).getTokenProxyAddress();
6571         WETH.approve(tokenProxy, MathHelpers.maxUint256());
6572     }
6573 
6574     // ============ Public Functions ============
6575 
6576     /**
6577      * Fallback function. Disallows ether to be sent to this contract without data except when
6578      * unwrapping WETH.
6579      */
6580     function ()
6581         external
6582         payable
6583     {
6584         require( // coverage-disable-line
6585             msg.sender == WETH,
6586             "PayableMarginMinter#fallback: Cannot recieve ETH directly unless unwrapping WETH"
6587         );
6588     }
6589 
6590     /**
6591      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6592      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6593      * principal added, as it will incorporate interest already earned by the position so far.
6594      *
6595      * @param  addresses           Addresses corresponding to:
6596      *
6597      *  [0]  = loan payer
6598      *  [1]  = loan taker
6599      *  [2]  = loan position owner
6600      *  [3]  = loan fee recipient
6601      *  [4]  = loan lender fee token
6602      *  [5]  = loan taker fee token
6603      *  [6]  = exchange wrapper address
6604      *
6605      * @param  values256           Values corresponding to:
6606      *
6607      *  [0]  = loan maximum amount
6608      *  [1]  = loan minimum amount
6609      *  [2]  = loan minimum heldToken
6610      *  [3]  = loan lender fee
6611      *  [4]  = loan taker fee
6612      *  [5]  = loan expiration timestamp (in seconds)
6613      *  [6]  = loan salt
6614      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6615      *                                                           will be >= this amount)
6616      *
6617      * @param  values32            Values corresponding to:
6618      *
6619      *  [0] = loan call time limit (in seconds)
6620      *  [1] = loan maxDuration (in seconds)
6621      *
6622      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6623      *                             False if the margin deposit will be in owedToken
6624      *                             and then sold along with the owedToken borrowed from the lender
6625      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6626      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6627      *                             is a smart contract, these are arbitrary bytes that the contract
6628      *                             will recieve when choosing whether to approve the loan.
6629      * @param  order               Order object to be passed to the exchange wrapper
6630      * @return                     Amount of owedTokens pulled from the lender
6631      */
6632     function mintMarginTokens(
6633         bytes32    positionId,
6634         address[7] addresses,
6635         uint256[8] values256,
6636         uint32[2]  values32,
6637         bool       depositInHeldToken,
6638         bytes      signature,
6639         bytes      order
6640     )
6641         external
6642         payable
6643         nonReentrant
6644         returns (uint256)
6645     {
6646         // wrap all eth
6647         WETH9(WETH).deposit.value(msg.value)();
6648 
6649         // mint the margin tokens
6650         Margin(DYDX_MARGIN).increasePosition(
6651             positionId,
6652             addresses,
6653             values256,
6654             values32,
6655             depositInHeldToken,
6656             signature,
6657             order
6658         );
6659 
6660         // send the margin tokens back to the user
6661         address marginTokenContract = Margin(DYDX_MARGIN).getPositionOwner(positionId);
6662         uint256 numTokens = marginTokenContract.balanceOf(address(this));
6663         marginTokenContract.transfer(msg.sender, numTokens);
6664 
6665         // unwrap any leftover WETH and send eth back to the user
6666         uint256 leftoverEth = WETH.balanceOf(address(this));
6667         if (leftoverEth > 0) {
6668             WETH9(WETH).withdraw(leftoverEth);
6669             msg.sender.transfer(leftoverEth);
6670         }
6671 
6672         return numTokens;
6673     }
6674 }