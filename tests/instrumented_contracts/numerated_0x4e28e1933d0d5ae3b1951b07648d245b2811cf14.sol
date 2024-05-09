1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 
4 // File: canonical-weth/contracts/WETH9.sol
5 
6 contract WETH9 {
7     string public name     = "Wrapped Ether";
8     string public symbol   = "WETH";
9     uint8  public decimals = 18;
10 
11     event  Approval(address indexed src, address indexed guy, uint wad);
12     event  Transfer(address indexed src, address indexed dst, uint wad);
13     event  Deposit(address indexed dst, uint wad);
14     event  Withdrawal(address indexed src, uint wad);
15 
16     mapping (address => uint)                       public  balanceOf;
17     mapping (address => mapping (address => uint))  public  allowance;
18 
19     function() external payable {
20         deposit();
21     }
22     function deposit() public payable {
23         balanceOf[msg.sender] += msg.value;
24         emit Deposit(msg.sender, msg.value);
25     }
26     function withdraw(uint wad) public {
27         require(balanceOf[msg.sender] >= wad);
28         balanceOf[msg.sender] -= wad;
29         msg.sender.transfer(wad);
30         emit Withdrawal(msg.sender, wad);
31     }
32 
33     function totalSupply() public view returns (uint) {
34         return address(this).balance;
35     }
36 
37     function approve(address guy, uint wad) public returns (bool) {
38         allowance[msg.sender][guy] = wad;
39         emit Approval(msg.sender, guy, wad);
40         return true;
41     }
42 
43     function transfer(address dst, uint wad) public returns (bool) {
44         return transferFrom(msg.sender, dst, wad);
45     }
46 
47     function transferFrom(address src, address dst, uint wad)
48         public
49         returns (bool)
50     {
51         require(balanceOf[src] >= wad);
52 
53         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
54             require(allowance[src][msg.sender] >= wad);
55             allowance[src][msg.sender] -= wad;
56         }
57 
58         balanceOf[src] -= wad;
59         balanceOf[dst] += wad;
60 
61         emit Transfer(src, dst, wad);
62 
63         return true;
64     }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/Math.sol
68 
69 /**
70  * @title Math
71  * @dev Assorted math operations
72  */
73 library Math {
74   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
75     return _a >= _b ? _a : _b;
76   }
77 
78   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
79     return _a < _b ? _a : _b;
80   }
81 
82   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
83     return _a >= _b ? _a : _b;
84   }
85 
86   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
87     return _a < _b ? _a : _b;
88   }
89 }
90 
91 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (_a == 0) {
107       return 0;
108     }
109 
110     c = _a * _b;
111     assert(c / _a == _b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     // assert(_b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = _a / _b;
121     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
122     return _a / _b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
129     assert(_b <= _a);
130     return _a - _b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
137     c = _a + _b;
138     assert(c >= _a);
139     return c;
140   }
141 }
142 
143 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
144 
145 /**
146  * @title Ownable
147  * @dev The Ownable contract has an owner address, and provides basic authorization control
148  * functions, this simplifies the implementation of "user permissions".
149  */
150 contract Ownable {
151   address public owner;
152 
153   event OwnershipRenounced(address indexed previousOwner);
154   event OwnershipTransferred(
155     address indexed previousOwner,
156     address indexed newOwner
157   );
158 
159   /**
160    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
161    * account.
162    */
163   constructor() public {
164     owner = msg.sender;
165   }
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175   /**
176    * @dev Allows the current owner to relinquish control of the contract.
177    * @notice Renouncing to ownership will leave the contract without an owner.
178    * It will not be possible to call the functions with the `onlyOwner`
179    * modifier anymore.
180    */
181   function renounceOwnership() public onlyOwner {
182     emit OwnershipRenounced(owner);
183     owner = address(0);
184   }
185 
186   /**
187    * @dev Allows the current owner to transfer control of the contract to a newOwner.
188    * @param _newOwner The address to transfer ownership to.
189    */
190   function transferOwnership(address _newOwner) public onlyOwner {
191     _transferOwnership(_newOwner);
192   }
193 
194   /**
195    * @dev Transfers control of the contract to a newOwner.
196    * @param _newOwner The address to transfer ownership to.
197    */
198   function _transferOwnership(address _newOwner) internal {
199     require(_newOwner != address(0));
200     emit OwnershipTransferred(owner, _newOwner);
201     owner = _newOwner;
202   }
203 }
204 
205 // File: contracts/lib/AccessControlledBase.sol
206 
207 /**
208  * @title AccessControlledBase
209  * @author dYdX
210  *
211  * Base functionality for access control. Requires an implementation to
212  * provide a way to grant and optionally revoke access
213  */
214 contract AccessControlledBase {
215     // ============ State Variables ============
216 
217     mapping (address => bool) public authorized;
218 
219     // ============ Events ============
220 
221     event AccessGranted(
222         address who
223     );
224 
225     event AccessRevoked(
226         address who
227     );
228 
229     // ============ Modifiers ============
230 
231     modifier requiresAuthorization() {
232         require(
233             authorized[msg.sender],
234             "AccessControlledBase#requiresAuthorization: Sender not authorized"
235         );
236         _;
237     }
238 }
239 
240 // File: contracts/lib/StaticAccessControlled.sol
241 
242 /**
243  * @title StaticAccessControlled
244  * @author dYdX
245  *
246  * Allows for functions to be access controled
247  * Permissions cannot be changed after a grace period
248  */
249 contract StaticAccessControlled is AccessControlledBase, Ownable {
250     using SafeMath for uint256;
251 
252     // ============ State Variables ============
253 
254     // Timestamp after which no additional access can be granted
255     uint256 public GRACE_PERIOD_EXPIRATION;
256 
257     // ============ Constructor ============
258 
259     constructor(
260         uint256 gracePeriod
261     )
262         public
263         Ownable()
264     {
265         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
266     }
267 
268     // ============ Owner-Only State-Changing Functions ============
269 
270     function grantAccess(
271         address who
272     )
273         external
274         onlyOwner
275     {
276         require(
277             block.timestamp < GRACE_PERIOD_EXPIRATION,
278             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
279         );
280 
281         emit AccessGranted(who);
282         authorized[who] = true;
283     }
284 }
285 
286 // File: contracts/lib/GeneralERC20.sol
287 
288 /**
289  * @title GeneralERC20
290  * @author dYdX
291  *
292  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
293  * that we dont automatically revert when calling non-compliant tokens that have no return value for
294  * transfer(), transferFrom(), or approve().
295  */
296 interface GeneralERC20 {
297     function totalSupply(
298     )
299         external
300         view
301         returns (uint256);
302 
303     function balanceOf(
304         address who
305     )
306         external
307         view
308         returns (uint256);
309 
310     function allowance(
311         address owner,
312         address spender
313     )
314         external
315         view
316         returns (uint256);
317 
318     function transfer(
319         address to,
320         uint256 value
321     )
322         external;
323 
324     function transferFrom(
325         address from,
326         address to,
327         uint256 value
328     )
329         external;
330 
331     function approve(
332         address spender,
333         uint256 value
334     )
335         external;
336 }
337 
338 // File: contracts/lib/TokenInteract.sol
339 
340 /**
341  * @title TokenInteract
342  * @author dYdX
343  *
344  * This library contains basic functions for interacting with ERC20 tokens
345  */
346 library TokenInteract {
347     function balanceOf(
348         address token,
349         address owner
350     )
351         internal
352         view
353         returns (uint256)
354     {
355         return GeneralERC20(token).balanceOf(owner);
356     }
357 
358     function allowance(
359         address token,
360         address owner,
361         address spender
362     )
363         internal
364         view
365         returns (uint256)
366     {
367         return GeneralERC20(token).allowance(owner, spender);
368     }
369 
370     function approve(
371         address token,
372         address spender,
373         uint256 amount
374     )
375         internal
376     {
377         GeneralERC20(token).approve(spender, amount);
378 
379         require(
380             checkSuccess(),
381             "TokenInteract#approve: Approval failed"
382         );
383     }
384 
385     function transfer(
386         address token,
387         address to,
388         uint256 amount
389     )
390         internal
391     {
392         address from = address(this);
393         if (
394             amount == 0
395             || from == to
396         ) {
397             return;
398         }
399 
400         GeneralERC20(token).transfer(to, amount);
401 
402         require(
403             checkSuccess(),
404             "TokenInteract#transfer: Transfer failed"
405         );
406     }
407 
408     function transferFrom(
409         address token,
410         address from,
411         address to,
412         uint256 amount
413     )
414         internal
415     {
416         if (
417             amount == 0
418             || from == to
419         ) {
420             return;
421         }
422 
423         GeneralERC20(token).transferFrom(from, to, amount);
424 
425         require(
426             checkSuccess(),
427             "TokenInteract#transferFrom: TransferFrom failed"
428         );
429     }
430 
431     // ============ Private Helper-Functions ============
432 
433     /**
434      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
435      * function returned 0 bytes or 32 bytes that are not all-zero.
436      */
437     function checkSuccess(
438     )
439         private
440         pure
441         returns (bool)
442     {
443         uint256 returnValue = 0;
444 
445         /* solium-disable-next-line security/no-inline-assembly */
446         assembly {
447             // check number of bytes returned from last function call
448             switch returndatasize
449 
450             // no bytes returned: assume success
451             case 0x0 {
452                 returnValue := 1
453             }
454 
455             // 32 bytes returned: check if non-zero
456             case 0x20 {
457                 // copy 32 bytes into scratch space
458                 returndatacopy(0x0, 0x0, 0x20)
459 
460                 // load those bytes into returnValue
461                 returnValue := mload(0x0)
462             }
463 
464             // not sure what was returned: dont mark as success
465             default { }
466         }
467 
468         return returnValue != 0;
469     }
470 }
471 
472 // File: contracts/margin/TokenProxy.sol
473 
474 /**
475  * @title TokenProxy
476  * @author dYdX
477  *
478  * Used to transfer tokens between addresses which have set allowance on this contract.
479  */
480 contract TokenProxy is StaticAccessControlled {
481     using SafeMath for uint256;
482 
483     // ============ Constructor ============
484 
485     constructor(
486         uint256 gracePeriod
487     )
488         public
489         StaticAccessControlled(gracePeriod)
490     {}
491 
492     // ============ Authorized-Only State Changing Functions ============
493 
494     /**
495      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
496      *
497      * @param  token  The address of the ERC20 token
498      * @param  from   The address to transfer token from
499      * @param  to     The address to transfer tokens to
500      * @param  value  The number of tokens to transfer
501      */
502     function transferTokens(
503         address token,
504         address from,
505         address to,
506         uint256 value
507     )
508         external
509         requiresAuthorization
510     {
511         TokenInteract.transferFrom(
512             token,
513             from,
514             to,
515             value
516         );
517     }
518 
519     // ============ Public Constant Functions ============
520 
521     /**
522      * Getter function to get the amount of token that the proxy is able to move for a particular
523      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
524      *
525      * @param  who    The owner of the tokens
526      * @param  token  The address of the ERC20 token
527      * @return        The number of tokens able to be moved by the proxy from the address specified
528      */
529     function available(
530         address who,
531         address token
532     )
533         external
534         view
535         returns (uint256)
536     {
537         return Math.min256(
538             TokenInteract.allowance(token, who, address(this)),
539             TokenInteract.balanceOf(token, who)
540         );
541     }
542 }
543 
544 // File: contracts/margin/Vault.sol
545 
546 /**
547  * @title Vault
548  * @author dYdX
549  *
550  * Holds and transfers tokens in vaults denominated by id
551  *
552  * Vault only supports ERC20 tokens, and will not accept any tokens that require
553  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
554  */
555 contract Vault is StaticAccessControlled
556 {
557     using SafeMath for uint256;
558 
559     // ============ Events ============
560 
561     event ExcessTokensWithdrawn(
562         address indexed token,
563         address indexed to,
564         address caller
565     );
566 
567     // ============ State Variables ============
568 
569     // Address of the TokenProxy contract. Used for moving tokens.
570     address public TOKEN_PROXY;
571 
572     // Map from vault ID to map from token address to amount of that token attributed to the
573     // particular vault ID.
574     mapping (bytes32 => mapping (address => uint256)) public balances;
575 
576     // Map from token address to total amount of that token attributed to some account.
577     mapping (address => uint256) public totalBalances;
578 
579     // ============ Constructor ============
580 
581     constructor(
582         address proxy,
583         uint256 gracePeriod
584     )
585         public
586         StaticAccessControlled(gracePeriod)
587     {
588         TOKEN_PROXY = proxy;
589     }
590 
591     // ============ Owner-Only State-Changing Functions ============
592 
593     /**
594      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
595      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
596      * will be accounted for and will not be withdrawable by this function.
597      *
598      * @param  token  ERC20 token address
599      * @param  to     Address to transfer tokens to
600      * @return        Amount of tokens withdrawn
601      */
602     function withdrawExcessToken(
603         address token,
604         address to
605     )
606         external
607         onlyOwner
608         returns (uint256)
609     {
610         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
611         uint256 accountedBalance = totalBalances[token];
612         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
613 
614         require(
615             withdrawableBalance != 0,
616             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
617         );
618 
619         TokenInteract.transfer(token, to, withdrawableBalance);
620 
621         emit ExcessTokensWithdrawn(token, to, msg.sender);
622 
623         return withdrawableBalance;
624     }
625 
626     // ============ Authorized-Only State-Changing Functions ============
627 
628     /**
629      * Transfers tokens from an address (that has approved the proxy) to the vault.
630      *
631      * @param  id      The vault which will receive the tokens
632      * @param  token   ERC20 token address
633      * @param  from    Address from which the tokens will be taken
634      * @param  amount  Number of the token to be sent
635      */
636     function transferToVault(
637         bytes32 id,
638         address token,
639         address from,
640         uint256 amount
641     )
642         external
643         requiresAuthorization
644     {
645         // First send tokens to this contract
646         TokenProxy(TOKEN_PROXY).transferTokens(
647             token,
648             from,
649             address(this),
650             amount
651         );
652 
653         // Then increment balances
654         balances[id][token] = balances[id][token].add(amount);
655         totalBalances[token] = totalBalances[token].add(amount);
656 
657         // This should always be true. If not, something is very wrong
658         assert(totalBalances[token] >= balances[id][token]);
659 
660         validateBalance(token);
661     }
662 
663     /**
664      * Transfers a certain amount of funds to an address.
665      *
666      * @param  id      The vault from which to send the tokens
667      * @param  token   ERC20 token address
668      * @param  to      Address to transfer tokens to
669      * @param  amount  Number of the token to be sent
670      */
671     function transferFromVault(
672         bytes32 id,
673         address token,
674         address to,
675         uint256 amount
676     )
677         external
678         requiresAuthorization
679     {
680         // Next line also asserts that (balances[id][token] >= amount);
681         balances[id][token] = balances[id][token].sub(amount);
682 
683         // Next line also asserts that (totalBalances[token] >= amount);
684         totalBalances[token] = totalBalances[token].sub(amount);
685 
686         // This should always be true. If not, something is very wrong
687         assert(totalBalances[token] >= balances[id][token]);
688 
689         // Do the sending
690         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
691 
692         // Final validation
693         validateBalance(token);
694     }
695 
696     // ============ Private Helper-Functions ============
697 
698     /**
699      * Verifies that this contract is in control of at least as many tokens as accounted for
700      *
701      * @param  token  Address of ERC20 token
702      */
703     function validateBalance(
704         address token
705     )
706         private
707         view
708     {
709         // The actual balance could be greater than totalBalances[token] because anyone
710         // can send tokens to the contract's address which cannot be accounted for
711         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
712     }
713 }
714 
715 // File: contracts/lib/ReentrancyGuard.sol
716 
717 /**
718  * @title ReentrancyGuard
719  * @author dYdX
720  *
721  * Optimized version of the well-known ReentrancyGuard contract
722  */
723 contract ReentrancyGuard {
724     uint256 private _guardCounter = 1;
725 
726     modifier nonReentrant() {
727         uint256 localCounter = _guardCounter + 1;
728         _guardCounter = localCounter;
729         _;
730         require(
731             _guardCounter == localCounter,
732             "Reentrancy check failure"
733         );
734     }
735 }
736 
737 // File: openzeppelin-solidity/contracts/AddressUtils.sol
738 
739 /**
740  * Utility library of inline functions on addresses
741  */
742 library AddressUtils {
743 
744   /**
745    * Returns whether the target address is a contract
746    * @dev This function will return false if invoked during the constructor of a contract,
747    * as the code is not actually created until after the constructor finishes.
748    * @param _addr address to check
749    * @return whether the target address is a contract
750    */
751   function isContract(address _addr) internal view returns (bool) {
752     uint256 size;
753     // XXX Currently there is no better way to check if there is a contract in an address
754     // than to check the size of the code at that address.
755     // See https://ethereum.stackexchange.com/a/14016/36603
756     // for more details about how this works.
757     // TODO Check this again before the Serenity release, because all addresses will be
758     // contracts then.
759     // solium-disable-next-line security/no-inline-assembly
760     assembly { size := extcodesize(_addr) }
761     return size > 0;
762   }
763 
764 }
765 
766 // File: contracts/lib/Fraction.sol
767 
768 /**
769  * @title Fraction
770  * @author dYdX
771  *
772  * This library contains implementations for fraction structs.
773  */
774 library Fraction {
775     struct Fraction128 {
776         uint128 num;
777         uint128 den;
778     }
779 }
780 
781 // File: contracts/lib/FractionMath.sol
782 
783 /**
784  * @title FractionMath
785  * @author dYdX
786  *
787  * This library contains safe math functions for manipulating fractions.
788  */
789 library FractionMath {
790     using SafeMath for uint256;
791     using SafeMath for uint128;
792 
793     /**
794      * Returns a Fraction128 that is equal to a + b
795      *
796      * @param  a  The first Fraction128
797      * @param  b  The second Fraction128
798      * @return    The result (sum)
799      */
800     function add(
801         Fraction.Fraction128 memory a,
802         Fraction.Fraction128 memory b
803     )
804         internal
805         pure
806         returns (Fraction.Fraction128 memory)
807     {
808         uint256 left = a.num.mul(b.den);
809         uint256 right = b.num.mul(a.den);
810         uint256 denominator = a.den.mul(b.den);
811 
812         // if left + right overflows, prevent overflow
813         if (left + right < left) {
814             left = left.div(2);
815             right = right.div(2);
816             denominator = denominator.div(2);
817         }
818 
819         return bound(left.add(right), denominator);
820     }
821 
822     /**
823      * Returns a Fraction128 that is equal to a - (1/2)^d
824      *
825      * @param  a  The Fraction128
826      * @param  d  The power of (1/2)
827      * @return    The result
828      */
829     function sub1Over(
830         Fraction.Fraction128 memory a,
831         uint128 d
832     )
833         internal
834         pure
835         returns (Fraction.Fraction128 memory)
836     {
837         if (a.den % d == 0) {
838             return bound(
839                 a.num.sub(a.den.div(d)),
840                 a.den
841             );
842         }
843         return bound(
844             a.num.mul(d).sub(a.den),
845             a.den.mul(d)
846         );
847     }
848 
849     /**
850      * Returns a Fraction128 that is equal to a / d
851      *
852      * @param  a  The first Fraction128
853      * @param  d  The divisor
854      * @return    The result (quotient)
855      */
856     function div(
857         Fraction.Fraction128 memory a,
858         uint128 d
859     )
860         internal
861         pure
862         returns (Fraction.Fraction128 memory)
863     {
864         if (a.num % d == 0) {
865             return bound(
866                 a.num.div(d),
867                 a.den
868             );
869         }
870         return bound(
871             a.num,
872             a.den.mul(d)
873         );
874     }
875 
876     /**
877      * Returns a Fraction128 that is equal to a * b.
878      *
879      * @param  a  The first Fraction128
880      * @param  b  The second Fraction128
881      * @return    The result (product)
882      */
883     function mul(
884         Fraction.Fraction128 memory a,
885         Fraction.Fraction128 memory b
886     )
887         internal
888         pure
889         returns (Fraction.Fraction128 memory)
890     {
891         return bound(
892             a.num.mul(b.num),
893             a.den.mul(b.den)
894         );
895     }
896 
897     /**
898      * Returns a fraction from two uint256's. Fits them into uint128 if necessary.
899      *
900      * @param  num  The numerator
901      * @param  den  The denominator
902      * @return      The Fraction128 that matches num/den most closely
903      */
904     /* solium-disable-next-line security/no-assign-params */
905     function bound(
906         uint256 num,
907         uint256 den
908     )
909         internal
910         pure
911         returns (Fraction.Fraction128 memory)
912     {
913         uint256 max = num > den ? num : den;
914         uint256 first128Bits = (max >> 128);
915         if (first128Bits != 0) {
916             first128Bits += 1;
917             num /= first128Bits;
918             den /= first128Bits;
919         }
920 
921         assert(den != 0); // coverage-enable-line
922         assert(den < 2**128);
923         assert(num < 2**128);
924 
925         return Fraction.Fraction128({
926             num: uint128(num),
927             den: uint128(den)
928         });
929     }
930 
931     /**
932      * Returns an in-memory copy of a Fraction128
933      *
934      * @param  a  The Fraction128 to copy
935      * @return    A copy of the Fraction128
936      */
937     function copy(
938         Fraction.Fraction128 memory a
939     )
940         internal
941         pure
942         returns (Fraction.Fraction128 memory)
943     {
944         validate(a);
945         return Fraction.Fraction128({ num: a.num, den: a.den });
946     }
947 
948     // ============ Private Helper-Functions ============
949 
950     /**
951      * Asserts that a Fraction128 is valid (i.e. the denominator is non-zero)
952      *
953      * @param  a  The Fraction128 to validate
954      */
955     function validate(
956         Fraction.Fraction128 memory a
957     )
958         private
959         pure
960     {
961         assert(a.den != 0); // coverage-enable-line
962     }
963 }
964 
965 // File: contracts/lib/Exponent.sol
966 
967 /**
968  * @title Exponent
969  * @author dYdX
970  *
971  * This library contains an implementation for calculating e^X for arbitrary fraction X
972  */
973 library Exponent {
974     using SafeMath for uint256;
975     using FractionMath for Fraction.Fraction128;
976 
977     // ============ Constants ============
978 
979     // 2**128 - 1
980     uint128 constant public MAX_NUMERATOR = 340282366920938463463374607431768211455;
981 
982     // Number of precomputed integers, X, for E^((1/2)^X)
983     uint256 constant public MAX_PRECOMPUTE_PRECISION = 32;
984 
985     // Number of precomputed integers, X, for E^X
986     uint256 constant public NUM_PRECOMPUTED_INTEGERS = 32;
987 
988     // ============ Public Implementation Functions ============
989 
990     /**
991      * Returns e^X for any fraction X
992      *
993      * @param  X                    The exponent
994      * @param  precomputePrecision  Accuracy of precomputed terms
995      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
996      * @return                      e^X
997      */
998     function exp(
999         Fraction.Fraction128 memory X,
1000         uint256 precomputePrecision,
1001         uint256 maclaurinPrecision
1002     )
1003         internal
1004         pure
1005         returns (Fraction.Fraction128 memory)
1006     {
1007         require(
1008             precomputePrecision <= MAX_PRECOMPUTE_PRECISION,
1009             "Exponent#exp: Precompute precision over maximum"
1010         );
1011 
1012         Fraction.Fraction128 memory Xcopy = X.copy();
1013         if (Xcopy.num == 0) { // e^0 = 1
1014             return ONE();
1015         }
1016 
1017         // get the integer value of the fraction (example: 9/4 is 2.25 so has integerValue of 2)
1018         uint256 integerX = uint256(Xcopy.num).div(Xcopy.den);
1019 
1020         // if X is less than 1, then just calculate X
1021         if (integerX == 0) {
1022             return expHybrid(Xcopy, precomputePrecision, maclaurinPrecision);
1023         }
1024 
1025         // get e^integerX
1026         Fraction.Fraction128 memory expOfInt =
1027             getPrecomputedEToThe(integerX % NUM_PRECOMPUTED_INTEGERS);
1028         while (integerX >= NUM_PRECOMPUTED_INTEGERS) {
1029             expOfInt = expOfInt.mul(getPrecomputedEToThe(NUM_PRECOMPUTED_INTEGERS));
1030             integerX -= NUM_PRECOMPUTED_INTEGERS;
1031         }
1032 
1033         // multiply e^integerX by e^decimalX
1034         Fraction.Fraction128 memory decimalX = Fraction.Fraction128({
1035             num: Xcopy.num % Xcopy.den,
1036             den: Xcopy.den
1037         });
1038         return expHybrid(decimalX, precomputePrecision, maclaurinPrecision).mul(expOfInt);
1039     }
1040 
1041     /**
1042      * Returns e^X for any X < 1. Multiplies precomputed values to get close to the real value, then
1043      * Maclaurin Series approximation to reduce error.
1044      *
1045      * @param  X                    Exponent
1046      * @param  precomputePrecision  Accuracy of precomputed terms
1047      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1048      * @return                      e^X
1049      */
1050     function expHybrid(
1051         Fraction.Fraction128 memory X,
1052         uint256 precomputePrecision,
1053         uint256 maclaurinPrecision
1054     )
1055         internal
1056         pure
1057         returns (Fraction.Fraction128 memory)
1058     {
1059         assert(precomputePrecision <= MAX_PRECOMPUTE_PRECISION);
1060         assert(X.num < X.den);
1061         // will also throw if precomputePrecision is larger than the array length in getDenominator
1062 
1063         Fraction.Fraction128 memory Xtemp = X.copy();
1064         if (Xtemp.num == 0) { // e^0 = 1
1065             return ONE();
1066         }
1067 
1068         Fraction.Fraction128 memory result = ONE();
1069 
1070         uint256 d = 1; // 2^i
1071         for (uint256 i = 1; i <= precomputePrecision; i++) {
1072             d *= 2;
1073 
1074             // if Fraction > 1/d, subtract 1/d and multiply result by precomputed e^(1/d)
1075             if (d.mul(Xtemp.num) >= Xtemp.den) {
1076                 Xtemp = Xtemp.sub1Over(uint128(d));
1077                 result = result.mul(getPrecomputedEToTheHalfToThe(i));
1078             }
1079         }
1080         return result.mul(expMaclaurin(Xtemp, maclaurinPrecision));
1081     }
1082 
1083     /**
1084      * Returns e^X for any X, using Maclaurin Series approximation
1085      *
1086      * e^X = SUM(X^n / n!) for n >= 0
1087      * e^X = 1 + X/1! + X^2/2! + X^3/3! ...
1088      *
1089      * @param  X           Exponent
1090      * @param  precision   Accuracy of Maclaurin terms
1091      * @return             e^X
1092      */
1093     function expMaclaurin(
1094         Fraction.Fraction128 memory X,
1095         uint256 precision
1096     )
1097         internal
1098         pure
1099         returns (Fraction.Fraction128 memory)
1100     {
1101         Fraction.Fraction128 memory Xcopy = X.copy();
1102         if (Xcopy.num == 0) { // e^0 = 1
1103             return ONE();
1104         }
1105 
1106         Fraction.Fraction128 memory result = ONE();
1107         Fraction.Fraction128 memory Xtemp = ONE();
1108         for (uint256 i = 1; i <= precision; i++) {
1109             Xtemp = Xtemp.mul(Xcopy.div(uint128(i)));
1110             result = result.add(Xtemp);
1111         }
1112         return result;
1113     }
1114 
1115     /**
1116      * Returns a fraction roughly equaling E^((1/2)^x) for integer x
1117      */
1118     function getPrecomputedEToTheHalfToThe(
1119         uint256 x
1120     )
1121         internal
1122         pure
1123         returns (Fraction.Fraction128 memory)
1124     {
1125         assert(x <= MAX_PRECOMPUTE_PRECISION);
1126 
1127         uint128 denominator = [
1128             125182886983370532117250726298150828301,
1129             206391688497133195273760705512282642279,
1130             265012173823417992016237332255925138361,
1131             300298134811882980317033350418940119802,
1132             319665700530617779809390163992561606014,
1133             329812979126047300897653247035862915816,
1134             335006777809430963166468914297166288162,
1135             337634268532609249517744113622081347950,
1136             338955731696479810470146282672867036734,
1137             339618401537809365075354109784799900812,
1138             339950222128463181389559457827561204959,
1139             340116253979683015278260491021941090650,
1140             340199300311581465057079429423749235412,
1141             340240831081268226777032180141478221816,
1142             340261598367316729254995498374473399540,
1143             340271982485676106947851156443492415142,
1144             340277174663693808406010255284800906112,
1145             340279770782412691177936847400746725466,
1146             340281068849199706686796915841848278311,
1147             340281717884450116236033378667952410919,
1148             340282042402539547492367191008339680733,
1149             340282204661700319870089970029119685699,
1150             340282285791309720262481214385569134454,
1151             340282326356121674011576912006427792656,
1152             340282346638529464274601981200276914173,
1153             340282356779733812753265346086924801364,
1154             340282361850336100329388676752133324799,
1155             340282364385637272451648746721404212564,
1156             340282365653287865596328444437856608255,
1157             340282366287113163939555716675618384724,
1158             340282366604025813553891209601455838559,
1159             340282366762482138471739420386372790954,
1160             340282366841710300958333641874363209044
1161         ][x];
1162         return Fraction.Fraction128({
1163             num: MAX_NUMERATOR,
1164             den: denominator
1165         });
1166     }
1167 
1168     /**
1169      * Returns a fraction roughly equaling E^(x) for integer x
1170      */
1171     function getPrecomputedEToThe(
1172         uint256 x
1173     )
1174         internal
1175         pure
1176         returns (Fraction.Fraction128 memory)
1177     {
1178         assert(x <= NUM_PRECOMPUTED_INTEGERS);
1179 
1180         uint128 denominator = [
1181             340282366920938463463374607431768211455,
1182             125182886983370532117250726298150828301,
1183             46052210507670172419625860892627118820,
1184             16941661466271327126146327822211253888,
1185             6232488952727653950957829210887653621,
1186             2292804553036637136093891217529878878,
1187             843475657686456657683449904934172134,
1188             310297353591408453462393329342695980,
1189             114152017036184782947077973323212575,
1190             41994180235864621538772677139808695,
1191             15448795557622704876497742989562086,
1192             5683294276510101335127414470015662,
1193             2090767122455392675095471286328463,
1194             769150240628514374138961856925097,
1195             282954560699298259527814398449860,
1196             104093165666968799599694528310221,
1197             38293735615330848145349245349513,
1198             14087478058534870382224480725096,
1199             5182493555688763339001418388912,
1200             1906532833141383353974257736699,
1201             701374233231058797338605168652,
1202             258021160973090761055471434334,
1203             94920680509187392077350434438,
1204             34919366901332874995585576427,
1205             12846117181722897538509298435,
1206             4725822410035083116489797150,
1207             1738532907279185132707372378,
1208             639570514388029575350057932,
1209             235284843422800231081973821,
1210             86556456714490055457751527,
1211             31842340925906738090071268,
1212             11714142585413118080082437,
1213             4309392228124372433711936
1214         ][x];
1215         return Fraction.Fraction128({
1216             num: MAX_NUMERATOR,
1217             den: denominator
1218         });
1219     }
1220 
1221     // ============ Private Helper-Functions ============
1222 
1223     function ONE()
1224         private
1225         pure
1226         returns (Fraction.Fraction128 memory)
1227     {
1228         return Fraction.Fraction128({ num: 1, den: 1 });
1229     }
1230 }
1231 
1232 // File: contracts/lib/MathHelpers.sol
1233 
1234 /**
1235  * @title MathHelpers
1236  * @author dYdX
1237  *
1238  * This library helps with common math functions in Solidity
1239  */
1240 library MathHelpers {
1241     using SafeMath for uint256;
1242 
1243     /**
1244      * Calculates partial value given a numerator and denominator.
1245      *
1246      * @param  numerator    Numerator
1247      * @param  denominator  Denominator
1248      * @param  target       Value to calculate partial of
1249      * @return              target * numerator / denominator
1250      */
1251     function getPartialAmount(
1252         uint256 numerator,
1253         uint256 denominator,
1254         uint256 target
1255     )
1256         internal
1257         pure
1258         returns (uint256)
1259     {
1260         return numerator.mul(target).div(denominator);
1261     }
1262 
1263     /**
1264      * Calculates partial value given a numerator and denominator, rounded up.
1265      *
1266      * @param  numerator    Numerator
1267      * @param  denominator  Denominator
1268      * @param  target       Value to calculate partial of
1269      * @return              Rounded-up result of target * numerator / denominator
1270      */
1271     function getPartialAmountRoundedUp(
1272         uint256 numerator,
1273         uint256 denominator,
1274         uint256 target
1275     )
1276         internal
1277         pure
1278         returns (uint256)
1279     {
1280         return divisionRoundedUp(numerator.mul(target), denominator);
1281     }
1282 
1283     /**
1284      * Calculates division given a numerator and denominator, rounded up.
1285      *
1286      * @param  numerator    Numerator.
1287      * @param  denominator  Denominator.
1288      * @return              Rounded-up result of numerator / denominator
1289      */
1290     function divisionRoundedUp(
1291         uint256 numerator,
1292         uint256 denominator
1293     )
1294         internal
1295         pure
1296         returns (uint256)
1297     {
1298         assert(denominator != 0); // coverage-enable-line
1299         if (numerator == 0) {
1300             return 0;
1301         }
1302         return numerator.sub(1).div(denominator).add(1);
1303     }
1304 
1305     /**
1306      * Calculates and returns the maximum value for a uint256 in solidity
1307      *
1308      * @return  The maximum value for uint256
1309      */
1310     function maxUint256(
1311     )
1312         internal
1313         pure
1314         returns (uint256)
1315     {
1316         return 2 ** 256 - 1;
1317     }
1318 
1319     /**
1320      * Calculates and returns the maximum value for a uint256 in solidity
1321      *
1322      * @return  The maximum value for uint256
1323      */
1324     function maxUint32(
1325     )
1326         internal
1327         pure
1328         returns (uint32)
1329     {
1330         return 2 ** 32 - 1;
1331     }
1332 
1333     /**
1334      * Returns the number of bits in a uint256. That is, the lowest number, x, such that n >> x == 0
1335      *
1336      * @param  n  The uint256 to get the number of bits in
1337      * @return    The number of bits in n
1338      */
1339     function getNumBits(
1340         uint256 n
1341     )
1342         internal
1343         pure
1344         returns (uint256)
1345     {
1346         uint256 first = 0;
1347         uint256 last = 256;
1348         while (first < last) {
1349             uint256 check = (first + last) / 2;
1350             if ((n >> check) == 0) {
1351                 last = check;
1352             } else {
1353                 first = check + 1;
1354             }
1355         }
1356         assert(first <= 256);
1357         return first;
1358     }
1359 }
1360 
1361 // File: contracts/margin/impl/InterestImpl.sol
1362 
1363 /**
1364  * @title InterestImpl
1365  * @author dYdX
1366  *
1367  * A library that calculates continuously compounded interest for principal, time period, and
1368  * interest rate.
1369  */
1370 library InterestImpl {
1371     using SafeMath for uint256;
1372     using FractionMath for Fraction.Fraction128;
1373 
1374     // ============ Constants ============
1375 
1376     uint256 constant DEFAULT_PRECOMPUTE_PRECISION = 11;
1377 
1378     uint256 constant DEFAULT_MACLAURIN_PRECISION = 5;
1379 
1380     uint256 constant MAXIMUM_EXPONENT = 80;
1381 
1382     uint128 constant E_TO_MAXIUMUM_EXPONENT = 55406223843935100525711733958316613;
1383 
1384     // ============ Public Implementation Functions ============
1385 
1386     /**
1387      * Returns total tokens owed after accruing interest. Continuously compounding and accurate to
1388      * roughly 10^18 decimal places. Continuously compounding interest follows the formula:
1389      * I = P * e^(R*T)
1390      *
1391      * @param  principal           Principal of the interest calculation
1392      * @param  interestRate        Annual nominal interest percentage times 10**6.
1393      *                             (example: 5% = 5e6)
1394      * @param  secondsOfInterest   Number of seconds that interest has been accruing
1395      * @return                     Total amount of tokens owed. Greater than tokenAmount.
1396      */
1397     function getCompoundedInterest(
1398         uint256 principal,
1399         uint256 interestRate,
1400         uint256 secondsOfInterest
1401     )
1402         public
1403         pure
1404         returns (uint256)
1405     {
1406         uint256 numerator = interestRate.mul(secondsOfInterest);
1407         uint128 denominator = (10**8) * (365 * 1 days);
1408 
1409         // interestRate and secondsOfInterest should both be uint32
1410         assert(numerator < 2**128);
1411 
1412         // fraction representing (Rate * Time)
1413         Fraction.Fraction128 memory rt = Fraction.Fraction128({
1414             num: uint128(numerator),
1415             den: denominator
1416         });
1417 
1418         // calculate e^(RT)
1419         Fraction.Fraction128 memory eToRT;
1420         if (numerator.div(denominator) >= MAXIMUM_EXPONENT) {
1421             // degenerate case: cap calculation
1422             eToRT = Fraction.Fraction128({
1423                 num: E_TO_MAXIUMUM_EXPONENT,
1424                 den: 1
1425             });
1426         } else {
1427             // normal case: calculate e^(RT)
1428             eToRT = Exponent.exp(
1429                 rt,
1430                 DEFAULT_PRECOMPUTE_PRECISION,
1431                 DEFAULT_MACLAURIN_PRECISION
1432             );
1433         }
1434 
1435         // e^X for positive X should be greater-than or equal to 1
1436         assert(eToRT.num >= eToRT.den);
1437 
1438         return safeMultiplyUint256ByFraction(principal, eToRT);
1439     }
1440 
1441     // ============ Private Helper-Functions ============
1442 
1443     /**
1444      * Returns n * f, trying to prevent overflow as much as possible. Assumes that the numerator
1445      * and denominator of f are less than 2**128.
1446      */
1447     function safeMultiplyUint256ByFraction(
1448         uint256 n,
1449         Fraction.Fraction128 memory f
1450     )
1451         private
1452         pure
1453         returns (uint256)
1454     {
1455         uint256 term1 = n.div(2 ** 128); // first 128 bits
1456         uint256 term2 = n % (2 ** 128); // second 128 bits
1457 
1458         // uncommon scenario, requires n >= 2**128. calculates term1 = term1 * f
1459         if (term1 > 0) {
1460             term1 = term1.mul(f.num);
1461             uint256 numBits = MathHelpers.getNumBits(term1);
1462 
1463             // reduce rounding error by shifting all the way to the left before dividing
1464             term1 = MathHelpers.divisionRoundedUp(
1465                 term1 << (uint256(256).sub(numBits)),
1466                 f.den);
1467 
1468             // continue shifting or reduce shifting to get the right number
1469             if (numBits > 128) {
1470                 term1 = term1 << (numBits.sub(128));
1471             } else if (numBits < 128) {
1472                 term1 = term1 >> (uint256(128).sub(numBits));
1473             }
1474         }
1475 
1476         // calculates term2 = term2 * f
1477         term2 = MathHelpers.getPartialAmountRoundedUp(
1478             f.num,
1479             f.den,
1480             term2
1481         );
1482 
1483         return term1.add(term2);
1484     }
1485 }
1486 
1487 // File: contracts/margin/impl/MarginState.sol
1488 
1489 /**
1490  * @title MarginState
1491  * @author dYdX
1492  *
1493  * Contains state for the Margin contract. Also used by libraries that implement Margin functions.
1494  */
1495 library MarginState {
1496     struct State {
1497         // Address of the Vault contract
1498         address VAULT;
1499 
1500         // Address of the TokenProxy contract
1501         address TOKEN_PROXY;
1502 
1503         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1504         // already been filled.
1505         mapping (bytes32 => uint256) loanFills;
1506 
1507         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1508         // already been canceled.
1509         mapping (bytes32 => uint256) loanCancels;
1510 
1511         // Mapping from positionId -> Position, which stores all the open margin positions.
1512         mapping (bytes32 => MarginCommon.Position) positions;
1513 
1514         // Mapping from positionId -> bool, which stores whether the position has previously been
1515         // open, but is now closed.
1516         mapping (bytes32 => bool) closedPositions;
1517 
1518         // Mapping from positionId -> uint256, which stores the total amount of owedToken that has
1519         // ever been repaid to the lender for each position. Does not reset.
1520         mapping (bytes32 => uint256) totalOwedTokenRepaidToLender;
1521     }
1522 }
1523 
1524 // File: contracts/margin/interfaces/lender/LoanOwner.sol
1525 
1526 /**
1527  * @title LoanOwner
1528  * @author dYdX
1529  *
1530  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
1531  *
1532  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1533  *       to these functions
1534  */
1535 interface LoanOwner {
1536 
1537     // ============ Public Interface functions ============
1538 
1539     /**
1540      * Function a contract must implement in order to receive ownership of a loan sell via the
1541      * transferLoan function or the atomic-assign to the "owner" field in a loan offering.
1542      *
1543      * @param  from        Address of the previous owner
1544      * @param  positionId  Unique ID of the position
1545      * @return             This address to keep ownership, a different address to pass-on ownership
1546      */
1547     function receiveLoanOwnership(
1548         address from,
1549         bytes32 positionId
1550     )
1551         external
1552         /* onlyMargin */
1553         returns (address);
1554 }
1555 
1556 // File: contracts/margin/interfaces/owner/PositionOwner.sol
1557 
1558 /**
1559  * @title PositionOwner
1560  * @author dYdX
1561  *
1562  * Interface that smart contracts must implement in order to own position on behalf of other
1563  * accounts
1564  *
1565  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1566  *       to these functions
1567  */
1568 interface PositionOwner {
1569 
1570     // ============ Public Interface functions ============
1571 
1572     /**
1573      * Function a contract must implement in order to receive ownership of a position via the
1574      * transferPosition function or the atomic-assign to the "owner" field when opening a position.
1575      *
1576      * @param  from        Address of the previous owner
1577      * @param  positionId  Unique ID of the position
1578      * @return             This address to keep ownership, a different address to pass-on ownership
1579      */
1580     function receivePositionOwnership(
1581         address from,
1582         bytes32 positionId
1583     )
1584         external
1585         /* onlyMargin */
1586         returns (address);
1587 }
1588 
1589 // File: contracts/margin/impl/TransferInternal.sol
1590 
1591 /**
1592  * @title TransferInternal
1593  * @author dYdX
1594  *
1595  * This library contains the implementation for transferring ownership of loans and positions.
1596  */
1597 library TransferInternal {
1598 
1599     // ============ Events ============
1600 
1601     /**
1602      * Ownership of a loan was transferred to a new address
1603      */
1604     event LoanTransferred(
1605         bytes32 indexed positionId,
1606         address indexed from,
1607         address indexed to
1608     );
1609 
1610     /**
1611      * Ownership of a postion was transferred to a new address
1612      */
1613     event PositionTransferred(
1614         bytes32 indexed positionId,
1615         address indexed from,
1616         address indexed to
1617     );
1618 
1619     // ============ Internal Implementation Functions ============
1620 
1621     /**
1622      * Returns either the address of the new loan owner, or the address to which they wish to
1623      * pass ownership of the loan. This function does not actually set the state of the position
1624      *
1625      * @param  positionId  The Unique ID of the position
1626      * @param  oldOwner    The previous owner of the loan
1627      * @param  newOwner    The intended owner of the loan
1628      * @return             The address that the intended owner wishes to assign the loan to (may be
1629      *                     the same as the intended owner).
1630      */
1631     function grantLoanOwnership(
1632         bytes32 positionId,
1633         address oldOwner,
1634         address newOwner
1635     )
1636         internal
1637         returns (address)
1638     {
1639         // log event except upon position creation
1640         if (oldOwner != address(0)) {
1641             emit LoanTransferred(positionId, oldOwner, newOwner);
1642         }
1643 
1644         if (AddressUtils.isContract(newOwner)) {
1645             address nextOwner =
1646                 LoanOwner(newOwner).receiveLoanOwnership(oldOwner, positionId);
1647             if (nextOwner != newOwner) {
1648                 return grantLoanOwnership(positionId, newOwner, nextOwner);
1649             }
1650         }
1651 
1652         require(
1653             newOwner != address(0),
1654             "TransferInternal#grantLoanOwnership: New owner did not consent to owning loan"
1655         );
1656 
1657         return newOwner;
1658     }
1659 
1660     /**
1661      * Returns either the address of the new position owner, or the address to which they wish to
1662      * pass ownership of the position. This function does not actually set the state of the position
1663      *
1664      * @param  positionId  The Unique ID of the position
1665      * @param  oldOwner    The previous owner of the position
1666      * @param  newOwner    The intended owner of the position
1667      * @return             The address that the intended owner wishes to assign the position to (may
1668      *                     be the same as the intended owner).
1669      */
1670     function grantPositionOwnership(
1671         bytes32 positionId,
1672         address oldOwner,
1673         address newOwner
1674     )
1675         internal
1676         returns (address)
1677     {
1678         // log event except upon position creation
1679         if (oldOwner != address(0)) {
1680             emit PositionTransferred(positionId, oldOwner, newOwner);
1681         }
1682 
1683         if (AddressUtils.isContract(newOwner)) {
1684             address nextOwner =
1685                 PositionOwner(newOwner).receivePositionOwnership(oldOwner, positionId);
1686             if (nextOwner != newOwner) {
1687                 return grantPositionOwnership(positionId, newOwner, nextOwner);
1688             }
1689         }
1690 
1691         require(
1692             newOwner != address(0),
1693             "TransferInternal#grantPositionOwnership: New owner did not consent to owning position"
1694         );
1695 
1696         return newOwner;
1697     }
1698 }
1699 
1700 // File: contracts/lib/TimestampHelper.sol
1701 
1702 /**
1703  * @title TimestampHelper
1704  * @author dYdX
1705  *
1706  * Helper to get block timestamps in other formats
1707  */
1708 library TimestampHelper {
1709     function getBlockTimestamp32()
1710         internal
1711         view
1712         returns (uint32)
1713     {
1714         // Should not still be in-use in the year 2106
1715         assert(uint256(uint32(block.timestamp)) == block.timestamp);
1716 
1717         assert(block.timestamp > 0);
1718 
1719         return uint32(block.timestamp);
1720     }
1721 }
1722 
1723 // File: contracts/margin/impl/MarginCommon.sol
1724 
1725 /**
1726  * @title MarginCommon
1727  * @author dYdX
1728  *
1729  * This library contains common functions for implementations of public facing Margin functions
1730  */
1731 library MarginCommon {
1732     using SafeMath for uint256;
1733 
1734     // ============ Structs ============
1735 
1736     struct Position {
1737         address owedToken;       // Immutable
1738         address heldToken;       // Immutable
1739         address lender;
1740         address owner;
1741         uint256 principal;
1742         uint256 requiredDeposit;
1743         uint32  callTimeLimit;   // Immutable
1744         uint32  startTimestamp;  // Immutable, cannot be 0
1745         uint32  callTimestamp;
1746         uint32  maxDuration;     // Immutable
1747         uint32  interestRate;    // Immutable
1748         uint32  interestPeriod;  // Immutable
1749     }
1750 
1751     struct LoanOffering {
1752         address   owedToken;
1753         address   heldToken;
1754         address   payer;
1755         address   owner;
1756         address   taker;
1757         address   positionOwner;
1758         address   feeRecipient;
1759         address   lenderFeeToken;
1760         address   takerFeeToken;
1761         LoanRates rates;
1762         uint256   expirationTimestamp;
1763         uint32    callTimeLimit;
1764         uint32    maxDuration;
1765         uint256   salt;
1766         bytes32   loanHash;
1767         bytes     signature;
1768     }
1769 
1770     struct LoanRates {
1771         uint256 maxAmount;
1772         uint256 minAmount;
1773         uint256 minHeldToken;
1774         uint256 lenderFee;
1775         uint256 takerFee;
1776         uint32  interestRate;
1777         uint32  interestPeriod;
1778     }
1779 
1780     // ============ Internal Implementation Functions ============
1781 
1782     function storeNewPosition(
1783         MarginState.State storage state,
1784         bytes32 positionId,
1785         Position memory position,
1786         address loanPayer
1787     )
1788         internal
1789     {
1790         assert(!positionHasExisted(state, positionId));
1791         assert(position.owedToken != address(0));
1792         assert(position.heldToken != address(0));
1793         assert(position.owedToken != position.heldToken);
1794         assert(position.owner != address(0));
1795         assert(position.lender != address(0));
1796         assert(position.maxDuration != 0);
1797         assert(position.interestPeriod <= position.maxDuration);
1798         assert(position.callTimestamp == 0);
1799         assert(position.requiredDeposit == 0);
1800 
1801         state.positions[positionId].owedToken = position.owedToken;
1802         state.positions[positionId].heldToken = position.heldToken;
1803         state.positions[positionId].principal = position.principal;
1804         state.positions[positionId].callTimeLimit = position.callTimeLimit;
1805         state.positions[positionId].startTimestamp = TimestampHelper.getBlockTimestamp32();
1806         state.positions[positionId].maxDuration = position.maxDuration;
1807         state.positions[positionId].interestRate = position.interestRate;
1808         state.positions[positionId].interestPeriod = position.interestPeriod;
1809 
1810         state.positions[positionId].owner = TransferInternal.grantPositionOwnership(
1811             positionId,
1812             (position.owner != msg.sender) ? msg.sender : address(0),
1813             position.owner
1814         );
1815 
1816         state.positions[positionId].lender = TransferInternal.grantLoanOwnership(
1817             positionId,
1818             (position.lender != loanPayer) ? loanPayer : address(0),
1819             position.lender
1820         );
1821     }
1822 
1823     function getPositionIdFromNonce(
1824         uint256 nonce
1825     )
1826         internal
1827         view
1828         returns (bytes32)
1829     {
1830         return keccak256(abi.encodePacked(msg.sender, nonce));
1831     }
1832 
1833     function getUnavailableLoanOfferingAmountImpl(
1834         MarginState.State storage state,
1835         bytes32 loanHash
1836     )
1837         internal
1838         view
1839         returns (uint256)
1840     {
1841         return state.loanFills[loanHash].add(state.loanCancels[loanHash]);
1842     }
1843 
1844     function cleanupPosition(
1845         MarginState.State storage state,
1846         bytes32 positionId
1847     )
1848         internal
1849     {
1850         delete state.positions[positionId];
1851         state.closedPositions[positionId] = true;
1852     }
1853 
1854     function calculateOwedAmount(
1855         Position storage position,
1856         uint256 closeAmount,
1857         uint256 endTimestamp
1858     )
1859         internal
1860         view
1861         returns (uint256)
1862     {
1863         uint256 timeElapsed = calculateEffectiveTimeElapsed(position, endTimestamp);
1864 
1865         return InterestImpl.getCompoundedInterest(
1866             closeAmount,
1867             position.interestRate,
1868             timeElapsed
1869         );
1870     }
1871 
1872     /**
1873      * Calculates time elapsed rounded up to the nearest interestPeriod
1874      */
1875     function calculateEffectiveTimeElapsed(
1876         Position storage position,
1877         uint256 timestamp
1878     )
1879         internal
1880         view
1881         returns (uint256)
1882     {
1883         uint256 elapsed = timestamp.sub(position.startTimestamp);
1884 
1885         // round up to interestPeriod
1886         uint256 period = position.interestPeriod;
1887         if (period > 1) {
1888             elapsed = MathHelpers.divisionRoundedUp(elapsed, period).mul(period);
1889         }
1890 
1891         // bound by maxDuration
1892         return Math.min256(
1893             elapsed,
1894             position.maxDuration
1895         );
1896     }
1897 
1898     function calculateLenderAmountForIncreasePosition(
1899         Position storage position,
1900         uint256 principalToAdd,
1901         uint256 endTimestamp
1902     )
1903         internal
1904         view
1905         returns (uint256)
1906     {
1907         uint256 timeElapsed = calculateEffectiveTimeElapsedForNewLender(position, endTimestamp);
1908 
1909         return InterestImpl.getCompoundedInterest(
1910             principalToAdd,
1911             position.interestRate,
1912             timeElapsed
1913         );
1914     }
1915 
1916     function getLoanOfferingHash(
1917         LoanOffering loanOffering
1918     )
1919         internal
1920         view
1921         returns (bytes32)
1922     {
1923         return keccak256(
1924             abi.encodePacked(
1925                 address(this),
1926                 loanOffering.owedToken,
1927                 loanOffering.heldToken,
1928                 loanOffering.payer,
1929                 loanOffering.owner,
1930                 loanOffering.taker,
1931                 loanOffering.positionOwner,
1932                 loanOffering.feeRecipient,
1933                 loanOffering.lenderFeeToken,
1934                 loanOffering.takerFeeToken,
1935                 getValuesHash(loanOffering)
1936             )
1937         );
1938     }
1939 
1940     function getPositionBalanceImpl(
1941         MarginState.State storage state,
1942         bytes32 positionId
1943     )
1944         internal
1945         view
1946         returns(uint256)
1947     {
1948         return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
1949     }
1950 
1951     function containsPositionImpl(
1952         MarginState.State storage state,
1953         bytes32 positionId
1954     )
1955         internal
1956         view
1957         returns (bool)
1958     {
1959         return state.positions[positionId].startTimestamp != 0;
1960     }
1961 
1962     function positionHasExisted(
1963         MarginState.State storage state,
1964         bytes32 positionId
1965     )
1966         internal
1967         view
1968         returns (bool)
1969     {
1970         return containsPositionImpl(state, positionId) || state.closedPositions[positionId];
1971     }
1972 
1973     function getPositionFromStorage(
1974         MarginState.State storage state,
1975         bytes32 positionId
1976     )
1977         internal
1978         view
1979         returns (Position storage)
1980     {
1981         Position storage position = state.positions[positionId];
1982 
1983         require(
1984             position.startTimestamp != 0,
1985             "MarginCommon#getPositionFromStorage: The position does not exist"
1986         );
1987 
1988         return position;
1989     }
1990 
1991     // ============ Private Helper-Functions ============
1992 
1993     /**
1994      * Calculates time elapsed rounded down to the nearest interestPeriod
1995      */
1996     function calculateEffectiveTimeElapsedForNewLender(
1997         Position storage position,
1998         uint256 timestamp
1999     )
2000         private
2001         view
2002         returns (uint256)
2003     {
2004         uint256 elapsed = timestamp.sub(position.startTimestamp);
2005 
2006         // round down to interestPeriod
2007         uint256 period = position.interestPeriod;
2008         if (period > 1) {
2009             elapsed = elapsed.div(period).mul(period);
2010         }
2011 
2012         // bound by maxDuration
2013         return Math.min256(
2014             elapsed,
2015             position.maxDuration
2016         );
2017     }
2018 
2019     function getValuesHash(
2020         LoanOffering loanOffering
2021     )
2022         private
2023         pure
2024         returns (bytes32)
2025     {
2026         return keccak256(
2027             abi.encodePacked(
2028                 loanOffering.rates.maxAmount,
2029                 loanOffering.rates.minAmount,
2030                 loanOffering.rates.minHeldToken,
2031                 loanOffering.rates.lenderFee,
2032                 loanOffering.rates.takerFee,
2033                 loanOffering.expirationTimestamp,
2034                 loanOffering.salt,
2035                 loanOffering.callTimeLimit,
2036                 loanOffering.maxDuration,
2037                 loanOffering.rates.interestRate,
2038                 loanOffering.rates.interestPeriod
2039             )
2040         );
2041     }
2042 }
2043 
2044 // File: contracts/margin/interfaces/PayoutRecipient.sol
2045 
2046 /**
2047  * @title PayoutRecipient
2048  * @author dYdX
2049  *
2050  * Interface that smart contracts must implement in order to be the payoutRecipient in a
2051  * closePosition transaction.
2052  *
2053  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2054  *       to these functions
2055  */
2056 interface PayoutRecipient {
2057 
2058     // ============ Public Interface functions ============
2059 
2060     /**
2061      * Function a contract must implement in order to receive payout from being the payoutRecipient
2062      * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.
2063      *
2064      * @param  positionId         Unique ID of the position
2065      * @param  closeAmount        Amount of the position that was closed
2066      * @param  closer             Address of the account or contract that closed the position
2067      * @param  positionOwner      Address of the owner of the position
2068      * @param  heldToken          Address of the ERC20 heldToken
2069      * @param  payout             Number of tokens received from the payout
2070      * @param  totalHeldToken     Total amount of heldToken removed from vault during close
2071      * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken
2072      * @return                    True if approved by the receiver
2073      */
2074     function receiveClosePositionPayout(
2075         bytes32 positionId,
2076         uint256 closeAmount,
2077         address closer,
2078         address positionOwner,
2079         address heldToken,
2080         uint256 payout,
2081         uint256 totalHeldToken,
2082         bool    payoutInHeldToken
2083     )
2084         external
2085         /* onlyMargin */
2086         returns (bool);
2087 }
2088 
2089 // File: contracts/margin/interfaces/lender/CloseLoanDelegator.sol
2090 
2091 /**
2092  * @title CloseLoanDelegator
2093  * @author dYdX
2094  *
2095  * Interface that smart contracts must implement in order to let other addresses close a loan
2096  * owned by the smart contract.
2097  *
2098  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2099  *       to these functions
2100  */
2101 interface CloseLoanDelegator {
2102 
2103     // ============ Public Interface functions ============
2104 
2105     /**
2106      * Function a contract must implement in order to let other addresses call
2107      * closeWithoutCounterparty().
2108      *
2109      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2110      * either revert the entire transaction or that (at most) the specified amount of the loan was
2111      * successfully closed.
2112      *
2113      * @param  closer           Address of the caller of closeWithoutCounterparty()
2114      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2115      * @param  positionId       Unique ID of the position
2116      * @param  requestedAmount  Requested principal amount of the loan to close
2117      * @return                  1) This address to accept, a different address to ask that contract
2118      *                          2) The maximum amount that this contract is allowing
2119      */
2120     function closeLoanOnBehalfOf(
2121         address closer,
2122         address payoutRecipient,
2123         bytes32 positionId,
2124         uint256 requestedAmount
2125     )
2126         external
2127         /* onlyMargin */
2128         returns (address, uint256);
2129 }
2130 
2131 // File: contracts/margin/interfaces/owner/ClosePositionDelegator.sol
2132 
2133 /**
2134  * @title ClosePositionDelegator
2135  * @author dYdX
2136  *
2137  * Interface that smart contracts must implement in order to let other addresses close a position
2138  * owned by the smart contract, allowing more complex logic to control positions.
2139  *
2140  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2141  *       to these functions
2142  */
2143 interface ClosePositionDelegator {
2144 
2145     // ============ Public Interface functions ============
2146 
2147     /**
2148      * Function a contract must implement in order to let other addresses call closePosition().
2149      *
2150      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2151      * either revert the entire transaction or that (at-most) the specified amount of the position
2152      * was successfully closed.
2153      *
2154      * @param  closer           Address of the caller of the closePosition() function
2155      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2156      * @param  positionId       Unique ID of the position
2157      * @param  requestedAmount  Requested principal amount of the position to close
2158      * @return                  1) This address to accept, a different address to ask that contract
2159      *                          2) The maximum amount that this contract is allowing
2160      */
2161     function closeOnBehalfOf(
2162         address closer,
2163         address payoutRecipient,
2164         bytes32 positionId,
2165         uint256 requestedAmount
2166     )
2167         external
2168         /* onlyMargin */
2169         returns (address, uint256);
2170 }
2171 
2172 // File: contracts/margin/impl/ClosePositionShared.sol
2173 
2174 /**
2175  * @title ClosePositionShared
2176  * @author dYdX
2177  *
2178  * This library contains shared functionality between ClosePositionImpl and
2179  * CloseWithoutCounterpartyImpl
2180  */
2181 library ClosePositionShared {
2182     using SafeMath for uint256;
2183 
2184     // ============ Structs ============
2185 
2186     struct CloseTx {
2187         bytes32 positionId;
2188         uint256 originalPrincipal;
2189         uint256 closeAmount;
2190         uint256 owedTokenOwed;
2191         uint256 startingHeldTokenBalance;
2192         uint256 availableHeldToken;
2193         address payoutRecipient;
2194         address owedToken;
2195         address heldToken;
2196         address positionOwner;
2197         address positionLender;
2198         address exchangeWrapper;
2199         bool    payoutInHeldToken;
2200     }
2201 
2202     // ============ Internal Implementation Functions ============
2203 
2204     function closePositionStateUpdate(
2205         MarginState.State storage state,
2206         CloseTx memory transaction
2207     )
2208         internal
2209     {
2210         // Delete the position, or just decrease the principal
2211         if (transaction.closeAmount == transaction.originalPrincipal) {
2212             MarginCommon.cleanupPosition(state, transaction.positionId);
2213         } else {
2214             assert(
2215                 transaction.originalPrincipal == state.positions[transaction.positionId].principal
2216             );
2217             state.positions[transaction.positionId].principal =
2218                 transaction.originalPrincipal.sub(transaction.closeAmount);
2219         }
2220     }
2221 
2222     function sendTokensToPayoutRecipient(
2223         MarginState.State storage state,
2224         ClosePositionShared.CloseTx memory transaction,
2225         uint256 buybackCostInHeldToken,
2226         uint256 receivedOwedToken
2227     )
2228         internal
2229         returns (uint256)
2230     {
2231         uint256 payout;
2232 
2233         if (transaction.payoutInHeldToken) {
2234             // Send remaining heldToken to payoutRecipient
2235             payout = transaction.availableHeldToken.sub(buybackCostInHeldToken);
2236 
2237             Vault(state.VAULT).transferFromVault(
2238                 transaction.positionId,
2239                 transaction.heldToken,
2240                 transaction.payoutRecipient,
2241                 payout
2242             );
2243         } else {
2244             assert(transaction.exchangeWrapper != address(0));
2245 
2246             payout = receivedOwedToken.sub(transaction.owedTokenOwed);
2247 
2248             TokenProxy(state.TOKEN_PROXY).transferTokens(
2249                 transaction.owedToken,
2250                 transaction.exchangeWrapper,
2251                 transaction.payoutRecipient,
2252                 payout
2253             );
2254         }
2255 
2256         if (AddressUtils.isContract(transaction.payoutRecipient)) {
2257             require(
2258                 PayoutRecipient(transaction.payoutRecipient).receiveClosePositionPayout(
2259                     transaction.positionId,
2260                     transaction.closeAmount,
2261                     msg.sender,
2262                     transaction.positionOwner,
2263                     transaction.heldToken,
2264                     payout,
2265                     transaction.availableHeldToken,
2266                     transaction.payoutInHeldToken
2267                 ),
2268                 "ClosePositionShared#sendTokensToPayoutRecipient: Payout recipient does not consent"
2269             );
2270         }
2271 
2272         // The ending heldToken balance of the vault should be the starting heldToken balance
2273         // minus the available heldToken amount
2274         assert(
2275             MarginCommon.getPositionBalanceImpl(state, transaction.positionId)
2276             == transaction.startingHeldTokenBalance.sub(transaction.availableHeldToken)
2277         );
2278 
2279         return payout;
2280     }
2281 
2282     function createCloseTx(
2283         MarginState.State storage state,
2284         bytes32 positionId,
2285         uint256 requestedAmount,
2286         address payoutRecipient,
2287         address exchangeWrapper,
2288         bool payoutInHeldToken,
2289         bool isWithoutCounterparty
2290     )
2291         internal
2292         returns (CloseTx memory)
2293     {
2294         // Validate
2295         require(
2296             payoutRecipient != address(0),
2297             "ClosePositionShared#createCloseTx: Payout recipient cannot be 0"
2298         );
2299         require(
2300             requestedAmount > 0,
2301             "ClosePositionShared#createCloseTx: Requested close amount cannot be 0"
2302         );
2303 
2304         MarginCommon.Position storage position =
2305             MarginCommon.getPositionFromStorage(state, positionId);
2306 
2307         uint256 closeAmount = getApprovedAmount(
2308             position,
2309             positionId,
2310             requestedAmount,
2311             payoutRecipient,
2312             isWithoutCounterparty
2313         );
2314 
2315         return parseCloseTx(
2316             state,
2317             position,
2318             positionId,
2319             closeAmount,
2320             payoutRecipient,
2321             exchangeWrapper,
2322             payoutInHeldToken,
2323             isWithoutCounterparty
2324         );
2325     }
2326 
2327     // ============ Private Helper-Functions ============
2328 
2329     function getApprovedAmount(
2330         MarginCommon.Position storage position,
2331         bytes32 positionId,
2332         uint256 requestedAmount,
2333         address payoutRecipient,
2334         bool requireLenderApproval
2335     )
2336         private
2337         returns (uint256)
2338     {
2339         // Ensure enough principal
2340         uint256 allowedAmount = Math.min256(requestedAmount, position.principal);
2341 
2342         // Ensure owner consent
2343         allowedAmount = closePositionOnBehalfOfRecurse(
2344             position.owner,
2345             msg.sender,
2346             payoutRecipient,
2347             positionId,
2348             allowedAmount
2349         );
2350 
2351         // Ensure lender consent
2352         if (requireLenderApproval) {
2353             allowedAmount = closeLoanOnBehalfOfRecurse(
2354                 position.lender,
2355                 msg.sender,
2356                 payoutRecipient,
2357                 positionId,
2358                 allowedAmount
2359             );
2360         }
2361 
2362         assert(allowedAmount > 0);
2363         assert(allowedAmount <= position.principal);
2364         assert(allowedAmount <= requestedAmount);
2365 
2366         return allowedAmount;
2367     }
2368 
2369     function closePositionOnBehalfOfRecurse(
2370         address contractAddr,
2371         address closer,
2372         address payoutRecipient,
2373         bytes32 positionId,
2374         uint256 closeAmount
2375     )
2376         private
2377         returns (uint256)
2378     {
2379         // no need to ask for permission
2380         if (closer == contractAddr) {
2381             return closeAmount;
2382         }
2383 
2384         (
2385             address newContractAddr,
2386             uint256 newCloseAmount
2387         ) = ClosePositionDelegator(contractAddr).closeOnBehalfOf(
2388             closer,
2389             payoutRecipient,
2390             positionId,
2391             closeAmount
2392         );
2393 
2394         require(
2395             newCloseAmount <= closeAmount,
2396             "ClosePositionShared#closePositionRecurse: newCloseAmount is greater than closeAmount"
2397         );
2398         require(
2399             newCloseAmount > 0,
2400             "ClosePositionShared#closePositionRecurse: newCloseAmount is zero"
2401         );
2402 
2403         if (newContractAddr != contractAddr) {
2404             closePositionOnBehalfOfRecurse(
2405                 newContractAddr,
2406                 closer,
2407                 payoutRecipient,
2408                 positionId,
2409                 newCloseAmount
2410             );
2411         }
2412 
2413         return newCloseAmount;
2414     }
2415 
2416     function closeLoanOnBehalfOfRecurse(
2417         address contractAddr,
2418         address closer,
2419         address payoutRecipient,
2420         bytes32 positionId,
2421         uint256 closeAmount
2422     )
2423         private
2424         returns (uint256)
2425     {
2426         // no need to ask for permission
2427         if (closer == contractAddr) {
2428             return closeAmount;
2429         }
2430 
2431         (
2432             address newContractAddr,
2433             uint256 newCloseAmount
2434         ) = CloseLoanDelegator(contractAddr).closeLoanOnBehalfOf(
2435                 closer,
2436                 payoutRecipient,
2437                 positionId,
2438                 closeAmount
2439             );
2440 
2441         require(
2442             newCloseAmount <= closeAmount,
2443             "ClosePositionShared#closeLoanRecurse: newCloseAmount is greater than closeAmount"
2444         );
2445         require(
2446             newCloseAmount > 0,
2447             "ClosePositionShared#closeLoanRecurse: newCloseAmount is zero"
2448         );
2449 
2450         if (newContractAddr != contractAddr) {
2451             closeLoanOnBehalfOfRecurse(
2452                 newContractAddr,
2453                 closer,
2454                 payoutRecipient,
2455                 positionId,
2456                 newCloseAmount
2457             );
2458         }
2459 
2460         return newCloseAmount;
2461     }
2462 
2463     // ============ Parsing Functions ============
2464 
2465     function parseCloseTx(
2466         MarginState.State storage state,
2467         MarginCommon.Position storage position,
2468         bytes32 positionId,
2469         uint256 closeAmount,
2470         address payoutRecipient,
2471         address exchangeWrapper,
2472         bool payoutInHeldToken,
2473         bool isWithoutCounterparty
2474     )
2475         private
2476         view
2477         returns (CloseTx memory)
2478     {
2479         uint256 startingHeldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
2480 
2481         uint256 availableHeldToken = MathHelpers.getPartialAmount(
2482             closeAmount,
2483             position.principal,
2484             startingHeldTokenBalance
2485         );
2486         uint256 owedTokenOwed = 0;
2487 
2488         if (!isWithoutCounterparty) {
2489             owedTokenOwed = MarginCommon.calculateOwedAmount(
2490                 position,
2491                 closeAmount,
2492                 block.timestamp
2493             );
2494         }
2495 
2496         return CloseTx({
2497             positionId: positionId,
2498             originalPrincipal: position.principal,
2499             closeAmount: closeAmount,
2500             owedTokenOwed: owedTokenOwed,
2501             startingHeldTokenBalance: startingHeldTokenBalance,
2502             availableHeldToken: availableHeldToken,
2503             payoutRecipient: payoutRecipient,
2504             owedToken: position.owedToken,
2505             heldToken: position.heldToken,
2506             positionOwner: position.owner,
2507             positionLender: position.lender,
2508             exchangeWrapper: exchangeWrapper,
2509             payoutInHeldToken: payoutInHeldToken
2510         });
2511     }
2512 }
2513 
2514 // File: contracts/margin/interfaces/ExchangeWrapper.sol
2515 
2516 /**
2517  * @title ExchangeWrapper
2518  * @author dYdX
2519  *
2520  * Contract interface that Exchange Wrapper smart contracts must implement in order to interface
2521  * with other smart contracts through a common interface.
2522  */
2523 interface ExchangeWrapper {
2524 
2525     // ============ Public Functions ============
2526 
2527     /**
2528      * Exchange some amount of takerToken for makerToken.
2529      *
2530      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
2531      *                              cannot always be trusted as it is set at the discretion of the
2532      *                              msg.sender)
2533      * @param  receiver             Address to set allowance on once the trade has completed
2534      * @param  makerToken           Address of makerToken, the token to receive
2535      * @param  takerToken           Address of takerToken, the token to pay
2536      * @param  requestedFillAmount  Amount of takerToken being paid
2537      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
2538      * @return                      The amount of makerToken received
2539      */
2540     function exchange(
2541         address tradeOriginator,
2542         address receiver,
2543         address makerToken,
2544         address takerToken,
2545         uint256 requestedFillAmount,
2546         bytes orderData
2547     )
2548         external
2549         returns (uint256);
2550 
2551     /**
2552      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
2553      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
2554      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
2555      * than desiredMakerToken
2556      *
2557      * @param  makerToken         Address of makerToken, the token to receive
2558      * @param  takerToken         Address of takerToken, the token to pay
2559      * @param  desiredMakerToken  Amount of makerToken requested
2560      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
2561      * @return                    Amount of takerToken the needed to complete the transaction
2562      */
2563     function getExchangeCost(
2564         address makerToken,
2565         address takerToken,
2566         uint256 desiredMakerToken,
2567         bytes orderData
2568     )
2569         external
2570         view
2571         returns (uint256);
2572 }
2573 
2574 // File: contracts/margin/impl/ClosePositionImpl.sol
2575 
2576 /**
2577  * @title ClosePositionImpl
2578  * @author dYdX
2579  *
2580  * This library contains the implementation for the closePosition function of Margin
2581  */
2582 library ClosePositionImpl {
2583     using SafeMath for uint256;
2584 
2585     // ============ Events ============
2586 
2587     /**
2588      * A position was closed or partially closed
2589      */
2590     event PositionClosed(
2591         bytes32 indexed positionId,
2592         address indexed closer,
2593         address indexed payoutRecipient,
2594         uint256 closeAmount,
2595         uint256 remainingAmount,
2596         uint256 owedTokenPaidToLender,
2597         uint256 payoutAmount,
2598         uint256 buybackCostInHeldToken,
2599         bool    payoutInHeldToken
2600     );
2601 
2602     // ============ Public Implementation Functions ============
2603 
2604     function closePositionImpl(
2605         MarginState.State storage state,
2606         bytes32 positionId,
2607         uint256 requestedCloseAmount,
2608         address payoutRecipient,
2609         address exchangeWrapper,
2610         bool payoutInHeldToken,
2611         bytes memory orderData
2612     )
2613         public
2614         returns (uint256, uint256, uint256)
2615     {
2616         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2617             state,
2618             positionId,
2619             requestedCloseAmount,
2620             payoutRecipient,
2621             exchangeWrapper,
2622             payoutInHeldToken,
2623             false
2624         );
2625 
2626         (
2627             uint256 buybackCostInHeldToken,
2628             uint256 receivedOwedToken
2629         ) = returnOwedTokensToLender(
2630             state,
2631             transaction,
2632             orderData
2633         );
2634 
2635         uint256 payout = ClosePositionShared.sendTokensToPayoutRecipient(
2636             state,
2637             transaction,
2638             buybackCostInHeldToken,
2639             receivedOwedToken
2640         );
2641 
2642         ClosePositionShared.closePositionStateUpdate(state, transaction);
2643 
2644         logEventOnClose(
2645             transaction,
2646             buybackCostInHeldToken,
2647             payout
2648         );
2649 
2650         return (
2651             transaction.closeAmount,
2652             payout,
2653             transaction.owedTokenOwed
2654         );
2655     }
2656 
2657     // ============ Private Helper-Functions ============
2658 
2659     function returnOwedTokensToLender(
2660         MarginState.State storage state,
2661         ClosePositionShared.CloseTx memory transaction,
2662         bytes memory orderData
2663     )
2664         private
2665         returns (uint256, uint256)
2666     {
2667         uint256 buybackCostInHeldToken = 0;
2668         uint256 receivedOwedToken = 0;
2669         uint256 lenderOwedToken = transaction.owedTokenOwed;
2670 
2671         // Setting exchangeWrapper to 0x000... indicates owedToken should be taken directly
2672         // from msg.sender
2673         if (transaction.exchangeWrapper == address(0)) {
2674             require(
2675                 transaction.payoutInHeldToken,
2676                 "ClosePositionImpl#returnOwedTokensToLender: Cannot payout in owedToken"
2677             );
2678 
2679             // No DEX Order; send owedTokens directly from the closer to the lender
2680             TokenProxy(state.TOKEN_PROXY).transferTokens(
2681                 transaction.owedToken,
2682                 msg.sender,
2683                 transaction.positionLender,
2684                 lenderOwedToken
2685             );
2686         } else {
2687             // Buy back owedTokens using DEX Order and send to lender
2688             (buybackCostInHeldToken, receivedOwedToken) = buyBackOwedToken(
2689                 state,
2690                 transaction,
2691                 orderData
2692             );
2693 
2694             // If no owedToken needed for payout: give lender all owedToken, even if more than owed
2695             if (transaction.payoutInHeldToken) {
2696                 assert(receivedOwedToken >= lenderOwedToken);
2697                 lenderOwedToken = receivedOwedToken;
2698             }
2699 
2700             // Transfer owedToken from the exchange wrapper to the lender
2701             TokenProxy(state.TOKEN_PROXY).transferTokens(
2702                 transaction.owedToken,
2703                 transaction.exchangeWrapper,
2704                 transaction.positionLender,
2705                 lenderOwedToken
2706             );
2707         }
2708 
2709         state.totalOwedTokenRepaidToLender[transaction.positionId] =
2710             state.totalOwedTokenRepaidToLender[transaction.positionId].add(lenderOwedToken);
2711 
2712         return (buybackCostInHeldToken, receivedOwedToken);
2713     }
2714 
2715     function buyBackOwedToken(
2716         MarginState.State storage state,
2717         ClosePositionShared.CloseTx transaction,
2718         bytes memory orderData
2719     )
2720         private
2721         returns (uint256, uint256)
2722     {
2723         // Ask the exchange wrapper the cost in heldToken to buy back the close
2724         // amount of owedToken
2725         uint256 buybackCostInHeldToken;
2726 
2727         if (transaction.payoutInHeldToken) {
2728             buybackCostInHeldToken = ExchangeWrapper(transaction.exchangeWrapper)
2729                 .getExchangeCost(
2730                     transaction.owedToken,
2731                     transaction.heldToken,
2732                     transaction.owedTokenOwed,
2733                     orderData
2734                 );
2735 
2736             // Require enough available heldToken to pay for the buyback
2737             require(
2738                 buybackCostInHeldToken <= transaction.availableHeldToken,
2739                 "ClosePositionImpl#buyBackOwedToken: Not enough available heldToken"
2740             );
2741         } else {
2742             buybackCostInHeldToken = transaction.availableHeldToken;
2743         }
2744 
2745         // Send the requisite heldToken to do the buyback from vault to exchange wrapper
2746         Vault(state.VAULT).transferFromVault(
2747             transaction.positionId,
2748             transaction.heldToken,
2749             transaction.exchangeWrapper,
2750             buybackCostInHeldToken
2751         );
2752 
2753         // Trade the heldToken for the owedToken
2754         uint256 receivedOwedToken = ExchangeWrapper(transaction.exchangeWrapper).exchange(
2755             msg.sender,
2756             state.TOKEN_PROXY,
2757             transaction.owedToken,
2758             transaction.heldToken,
2759             buybackCostInHeldToken,
2760             orderData
2761         );
2762 
2763         require(
2764             receivedOwedToken >= transaction.owedTokenOwed,
2765             "ClosePositionImpl#buyBackOwedToken: Did not receive enough owedToken"
2766         );
2767 
2768         return (buybackCostInHeldToken, receivedOwedToken);
2769     }
2770 
2771     function logEventOnClose(
2772         ClosePositionShared.CloseTx transaction,
2773         uint256 buybackCostInHeldToken,
2774         uint256 payout
2775     )
2776         private
2777     {
2778         emit PositionClosed(
2779             transaction.positionId,
2780             msg.sender,
2781             transaction.payoutRecipient,
2782             transaction.closeAmount,
2783             transaction.originalPrincipal.sub(transaction.closeAmount),
2784             transaction.owedTokenOwed,
2785             payout,
2786             buybackCostInHeldToken,
2787             transaction.payoutInHeldToken
2788         );
2789     }
2790 
2791 }
2792 
2793 // File: contracts/margin/impl/CloseWithoutCounterpartyImpl.sol
2794 
2795 /**
2796  * @title CloseWithoutCounterpartyImpl
2797  * @author dYdX
2798  *
2799  * This library contains the implementation for the closeWithoutCounterpartyImpl function of
2800  * Margin
2801  */
2802 library CloseWithoutCounterpartyImpl {
2803     using SafeMath for uint256;
2804 
2805     // ============ Events ============
2806 
2807     /**
2808      * A position was closed or partially closed
2809      */
2810     event PositionClosed(
2811         bytes32 indexed positionId,
2812         address indexed closer,
2813         address indexed payoutRecipient,
2814         uint256 closeAmount,
2815         uint256 remainingAmount,
2816         uint256 owedTokenPaidToLender,
2817         uint256 payoutAmount,
2818         uint256 buybackCostInHeldToken,
2819         bool payoutInHeldToken
2820     );
2821 
2822     // ============ Public Implementation Functions ============
2823 
2824     function closeWithoutCounterpartyImpl(
2825         MarginState.State storage state,
2826         bytes32 positionId,
2827         uint256 requestedCloseAmount,
2828         address payoutRecipient
2829     )
2830         public
2831         returns (uint256, uint256)
2832     {
2833         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2834             state,
2835             positionId,
2836             requestedCloseAmount,
2837             payoutRecipient,
2838             address(0),
2839             true,
2840             true
2841         );
2842 
2843         uint256 heldTokenPayout = ClosePositionShared.sendTokensToPayoutRecipient(
2844             state,
2845             transaction,
2846             0, // No buyback cost
2847             0  // Did not receive any owedToken
2848         );
2849 
2850         ClosePositionShared.closePositionStateUpdate(state, transaction);
2851 
2852         logEventOnCloseWithoutCounterparty(transaction);
2853 
2854         return (
2855             transaction.closeAmount,
2856             heldTokenPayout
2857         );
2858     }
2859 
2860     // ============ Private Helper-Functions ============
2861 
2862     function logEventOnCloseWithoutCounterparty(
2863         ClosePositionShared.CloseTx transaction
2864     )
2865         private
2866     {
2867         emit PositionClosed(
2868             transaction.positionId,
2869             msg.sender,
2870             transaction.payoutRecipient,
2871             transaction.closeAmount,
2872             transaction.originalPrincipal.sub(transaction.closeAmount),
2873             0,
2874             transaction.availableHeldToken,
2875             0,
2876             true
2877         );
2878     }
2879 }
2880 
2881 // File: contracts/margin/interfaces/owner/DepositCollateralDelegator.sol
2882 
2883 /**
2884  * @title DepositCollateralDelegator
2885  * @author dYdX
2886  *
2887  * Interface that smart contracts must implement in order to let other addresses deposit heldTokens
2888  * into a position owned by the smart contract.
2889  *
2890  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2891  *       to these functions
2892  */
2893 interface DepositCollateralDelegator {
2894 
2895     // ============ Public Interface functions ============
2896 
2897     /**
2898      * Function a contract must implement in order to let other addresses call depositCollateral().
2899      *
2900      * @param  depositor   Address of the caller of the depositCollateral() function
2901      * @param  positionId  Unique ID of the position
2902      * @param  amount      Requested deposit amount
2903      * @return             This address to accept, a different address to ask that contract
2904      */
2905     function depositCollateralOnBehalfOf(
2906         address depositor,
2907         bytes32 positionId,
2908         uint256 amount
2909     )
2910         external
2911         /* onlyMargin */
2912         returns (address);
2913 }
2914 
2915 // File: contracts/margin/impl/DepositCollateralImpl.sol
2916 
2917 /**
2918  * @title DepositCollateralImpl
2919  * @author dYdX
2920  *
2921  * This library contains the implementation for the deposit function of Margin
2922  */
2923 library DepositCollateralImpl {
2924     using SafeMath for uint256;
2925 
2926     // ============ Events ============
2927 
2928     /**
2929      * Additional collateral for a position was posted by the owner
2930      */
2931     event AdditionalCollateralDeposited(
2932         bytes32 indexed positionId,
2933         uint256 amount,
2934         address depositor
2935     );
2936 
2937     /**
2938      * A margin call was canceled
2939      */
2940     event MarginCallCanceled(
2941         bytes32 indexed positionId,
2942         address indexed lender,
2943         address indexed owner,
2944         uint256 depositAmount
2945     );
2946 
2947     // ============ Public Implementation Functions ============
2948 
2949     function depositCollateralImpl(
2950         MarginState.State storage state,
2951         bytes32 positionId,
2952         uint256 depositAmount
2953     )
2954         public
2955     {
2956         MarginCommon.Position storage position =
2957             MarginCommon.getPositionFromStorage(state, positionId);
2958 
2959         require(
2960             depositAmount > 0,
2961             "DepositCollateralImpl#depositCollateralImpl: Deposit amount cannot be 0"
2962         );
2963 
2964         // Ensure owner consent
2965         depositCollateralOnBehalfOfRecurse(
2966             position.owner,
2967             msg.sender,
2968             positionId,
2969             depositAmount
2970         );
2971 
2972         Vault(state.VAULT).transferToVault(
2973             positionId,
2974             position.heldToken,
2975             msg.sender,
2976             depositAmount
2977         );
2978 
2979         // cancel margin call if applicable
2980         bool marginCallCanceled = false;
2981         uint256 requiredDeposit = position.requiredDeposit;
2982         if (position.callTimestamp > 0 && requiredDeposit > 0) {
2983             if (depositAmount >= requiredDeposit) {
2984                 position.requiredDeposit = 0;
2985                 position.callTimestamp = 0;
2986                 marginCallCanceled = true;
2987             } else {
2988                 position.requiredDeposit = position.requiredDeposit.sub(depositAmount);
2989             }
2990         }
2991 
2992         emit AdditionalCollateralDeposited(
2993             positionId,
2994             depositAmount,
2995             msg.sender
2996         );
2997 
2998         if (marginCallCanceled) {
2999             emit MarginCallCanceled(
3000                 positionId,
3001                 position.lender,
3002                 msg.sender,
3003                 depositAmount
3004             );
3005         }
3006     }
3007 
3008     // ============ Private Helper-Functions ============
3009 
3010     function depositCollateralOnBehalfOfRecurse(
3011         address contractAddr,
3012         address depositor,
3013         bytes32 positionId,
3014         uint256 amount
3015     )
3016         private
3017     {
3018         // no need to ask for permission
3019         if (depositor == contractAddr) {
3020             return;
3021         }
3022 
3023         address newContractAddr =
3024             DepositCollateralDelegator(contractAddr).depositCollateralOnBehalfOf(
3025                 depositor,
3026                 positionId,
3027                 amount
3028             );
3029 
3030         // if not equal, recurse
3031         if (newContractAddr != contractAddr) {
3032             depositCollateralOnBehalfOfRecurse(
3033                 newContractAddr,
3034                 depositor,
3035                 positionId,
3036                 amount
3037             );
3038         }
3039     }
3040 }
3041 
3042 // File: contracts/margin/interfaces/lender/ForceRecoverCollateralDelegator.sol
3043 
3044 /**
3045  * @title ForceRecoverCollateralDelegator
3046  * @author dYdX
3047  *
3048  * Interface that smart contracts must implement in order to let other addresses
3049  * forceRecoverCollateral() a loan owned by the smart contract.
3050  *
3051  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3052  *       to these functions
3053  */
3054 interface ForceRecoverCollateralDelegator {
3055 
3056     // ============ Public Interface functions ============
3057 
3058     /**
3059      * Function a contract must implement in order to let other addresses call
3060      * forceRecoverCollateral().
3061      *
3062      * NOTE: If not returning zero address (or not reverting), this contract must assume that Margin
3063      * will either revert the entire transaction or that the collateral was forcibly recovered.
3064      *
3065      * @param  recoverer   Address of the caller of the forceRecoverCollateral() function
3066      * @param  positionId  Unique ID of the position
3067      * @param  recipient   Address to send the recovered tokens to
3068      * @return             This address to accept, a different address to ask that contract
3069      */
3070     function forceRecoverCollateralOnBehalfOf(
3071         address recoverer,
3072         bytes32 positionId,
3073         address recipient
3074     )
3075         external
3076         /* onlyMargin */
3077         returns (address);
3078 }
3079 
3080 // File: contracts/margin/impl/ForceRecoverCollateralImpl.sol
3081 
3082 /* solium-disable-next-line max-len*/
3083 
3084 /**
3085  * @title ForceRecoverCollateralImpl
3086  * @author dYdX
3087  *
3088  * This library contains the implementation for the forceRecoverCollateral function of Margin
3089  */
3090 library ForceRecoverCollateralImpl {
3091     using SafeMath for uint256;
3092 
3093     // ============ Events ============
3094 
3095     /**
3096      * Collateral for a position was forcibly recovered
3097      */
3098     event CollateralForceRecovered(
3099         bytes32 indexed positionId,
3100         address indexed recipient,
3101         uint256 amount
3102     );
3103 
3104     // ============ Public Implementation Functions ============
3105 
3106     function forceRecoverCollateralImpl(
3107         MarginState.State storage state,
3108         bytes32 positionId,
3109         address recipient
3110     )
3111         public
3112         returns (uint256)
3113     {
3114         MarginCommon.Position storage position =
3115             MarginCommon.getPositionFromStorage(state, positionId);
3116 
3117         // Can only force recover after either:
3118         // 1) The loan was called and the call period has elapsed
3119         // 2) The maxDuration of the position has elapsed
3120         require( /* solium-disable-next-line */
3121             (
3122                 position.callTimestamp > 0
3123                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3124             ) || (
3125                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3126             ),
3127             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3128         );
3129 
3130         // Ensure lender consent
3131         forceRecoverCollateralOnBehalfOfRecurse(
3132             position.lender,
3133             msg.sender,
3134             positionId,
3135             recipient
3136         );
3137 
3138         // Send the tokens
3139         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3140         Vault(state.VAULT).transferFromVault(
3141             positionId,
3142             position.heldToken,
3143             recipient,
3144             heldTokenRecovered
3145         );
3146 
3147         // Delete the position
3148         // NOTE: Since position is a storage pointer, this will also set all fields on
3149         //       the position variable to 0
3150         MarginCommon.cleanupPosition(
3151             state,
3152             positionId
3153         );
3154 
3155         // Log an event
3156         emit CollateralForceRecovered(
3157             positionId,
3158             recipient,
3159             heldTokenRecovered
3160         );
3161 
3162         return heldTokenRecovered;
3163     }
3164 
3165     // ============ Private Helper-Functions ============
3166 
3167     function forceRecoverCollateralOnBehalfOfRecurse(
3168         address contractAddr,
3169         address recoverer,
3170         bytes32 positionId,
3171         address recipient
3172     )
3173         private
3174     {
3175         // no need to ask for permission
3176         if (recoverer == contractAddr) {
3177             return;
3178         }
3179 
3180         address newContractAddr =
3181             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3182                 recoverer,
3183                 positionId,
3184                 recipient
3185             );
3186 
3187         if (newContractAddr != contractAddr) {
3188             forceRecoverCollateralOnBehalfOfRecurse(
3189                 newContractAddr,
3190                 recoverer,
3191                 positionId,
3192                 recipient
3193             );
3194         }
3195     }
3196 }
3197 
3198 // File: contracts/lib/TypedSignature.sol
3199 
3200 /**
3201  * @title TypedSignature
3202  * @author dYdX
3203  *
3204  * Allows for ecrecovery of signed hashes with three different prepended messages:
3205  * 1) ""
3206  * 2) "\x19Ethereum Signed Message:\n32"
3207  * 3) "\x19Ethereum Signed Message:\n\x20"
3208  */
3209 library TypedSignature {
3210 
3211     // Solidity does not offer guarantees about enum values, so we define them explicitly
3212     uint8 private constant SIGTYPE_INVALID = 0;
3213     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3214     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3215     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3216 
3217     // prepended message with the length of the signed hash in hexadecimal
3218     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3219 
3220     // prepended message with the length of the signed hash in decimal
3221     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3222 
3223     /**
3224      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3225      *
3226      * @param  hash               Hash that was signed (does not include prepended message)
3227      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3228      * @return                    address of the signer of the hash
3229      */
3230     function recover(
3231         bytes32 hash,
3232         bytes signatureWithType
3233     )
3234         internal
3235         pure
3236         returns (address)
3237     {
3238         require(
3239             signatureWithType.length == 66,
3240             "SignatureValidator#validateSignature: invalid signature length"
3241         );
3242 
3243         uint8 sigType = uint8(signatureWithType[0]);
3244 
3245         require(
3246             sigType > uint8(SIGTYPE_INVALID),
3247             "SignatureValidator#validateSignature: invalid signature type"
3248         );
3249         require(
3250             sigType < uint8(SIGTYPE_UNSUPPORTED),
3251             "SignatureValidator#validateSignature: unsupported signature type"
3252         );
3253 
3254         uint8 v = uint8(signatureWithType[1]);
3255         bytes32 r;
3256         bytes32 s;
3257 
3258         /* solium-disable-next-line security/no-inline-assembly */
3259         assembly {
3260             r := mload(add(signatureWithType, 34))
3261             s := mload(add(signatureWithType, 66))
3262         }
3263 
3264         bytes32 signedHash;
3265         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3266             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3267         } else {
3268             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3269             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3270         }
3271 
3272         return ecrecover(
3273             signedHash,
3274             v,
3275             r,
3276             s
3277         );
3278     }
3279 }
3280 
3281 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3282 
3283 /**
3284  * @title LoanOfferingVerifier
3285  * @author dYdX
3286  *
3287  * Interface that smart contracts must implement to be able to make off-chain generated
3288  * loan offerings.
3289  *
3290  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3291  *       to these functions
3292  */
3293 interface LoanOfferingVerifier {
3294 
3295     /**
3296      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3297      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3298      * position.
3299      *
3300      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3301      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3302      * state on a loan.
3303      *
3304      * @param  addresses    Array of addresses:
3305      *
3306      *  [0] = owedToken
3307      *  [1] = heldToken
3308      *  [2] = loan payer
3309      *  [3] = loan owner
3310      *  [4] = loan taker
3311      *  [5] = loan positionOwner
3312      *  [6] = loan fee recipient
3313      *  [7] = loan lender fee token
3314      *  [8] = loan taker fee token
3315      *
3316      * @param  values256    Values corresponding to:
3317      *
3318      *  [0] = loan maximum amount
3319      *  [1] = loan minimum amount
3320      *  [2] = loan minimum heldToken
3321      *  [3] = loan lender fee
3322      *  [4] = loan taker fee
3323      *  [5] = loan expiration timestamp (in seconds)
3324      *  [6] = loan salt
3325      *
3326      * @param  values32     Values corresponding to:
3327      *
3328      *  [0] = loan call time limit (in seconds)
3329      *  [1] = loan maxDuration (in seconds)
3330      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3331      *  [3] = loan interest update period (in seconds)
3332      *
3333      * @param  positionId   Unique ID of the position
3334      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3335      * @return              This address to accept, a different address to ask that contract
3336      */
3337     function verifyLoanOffering(
3338         address[9] addresses,
3339         uint256[7] values256,
3340         uint32[4] values32,
3341         bytes32 positionId,
3342         bytes signature
3343     )
3344         external
3345         /* onlyMargin */
3346         returns (address);
3347 }
3348 
3349 // File: contracts/margin/impl/BorrowShared.sol
3350 
3351 /**
3352  * @title BorrowShared
3353  * @author dYdX
3354  *
3355  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3356  * Both use a Loan Offering and a DEX Order to open or increase a position.
3357  */
3358 library BorrowShared {
3359     using SafeMath for uint256;
3360 
3361     // ============ Structs ============
3362 
3363     struct Tx {
3364         bytes32 positionId;
3365         address owner;
3366         uint256 principal;
3367         uint256 lenderAmount;
3368         MarginCommon.LoanOffering loanOffering;
3369         address exchangeWrapper;
3370         bool depositInHeldToken;
3371         uint256 depositAmount;
3372         uint256 collateralAmount;
3373         uint256 heldTokenFromSell;
3374     }
3375 
3376     // ============ Internal Implementation Functions ============
3377 
3378     /**
3379      * Validate the transaction before exchanging heldToken for owedToken
3380      */
3381     function validateTxPreSell(
3382         MarginState.State storage state,
3383         Tx memory transaction
3384     )
3385         internal
3386     {
3387         assert(transaction.lenderAmount >= transaction.principal);
3388 
3389         require(
3390             transaction.principal > 0,
3391             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3392         );
3393 
3394         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3395         if (transaction.loanOffering.taker != address(0)) {
3396             require(
3397                 msg.sender == transaction.loanOffering.taker,
3398                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3399             );
3400         }
3401 
3402         // If the positionOwner is 0x0 then any address can be set as the position owner.
3403         // Otherwise only the specified positionOwner can be set as the position owner.
3404         if (transaction.loanOffering.positionOwner != address(0)) {
3405             require(
3406                 transaction.owner == transaction.loanOffering.positionOwner,
3407                 "BorrowShared#validateTxPreSell: Invalid position owner"
3408             );
3409         }
3410 
3411         // Require the loan offering to be approved by the payer
3412         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3413             getConsentFromSmartContractLender(transaction);
3414         } else {
3415             require(
3416                 transaction.loanOffering.payer == TypedSignature.recover(
3417                     transaction.loanOffering.loanHash,
3418                     transaction.loanOffering.signature
3419                 ),
3420                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3421             );
3422         }
3423 
3424         // Validate the amount is <= than max and >= min
3425         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3426             state,
3427             transaction.loanOffering.loanHash
3428         );
3429         require(
3430             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3431             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3432         );
3433 
3434         require(
3435             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3436             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3437         );
3438 
3439         require(
3440             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3441             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3442         );
3443 
3444         require(
3445             transaction.owner != address(0),
3446             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3447         );
3448 
3449         require(
3450             transaction.loanOffering.owner != address(0),
3451             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3452         );
3453 
3454         require(
3455             transaction.loanOffering.expirationTimestamp > block.timestamp,
3456             "BorrowShared#validateTxPreSell: Loan offering is expired"
3457         );
3458 
3459         require(
3460             transaction.loanOffering.maxDuration > 0,
3461             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3462         );
3463 
3464         require(
3465             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3466             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3467         );
3468 
3469         // The minimum heldToken is validated after executing the sell
3470         // Position and loan ownership is validated in TransferInternal
3471     }
3472 
3473     /**
3474      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3475      * how much of the loan was used.
3476      */
3477     function doPostSell(
3478         MarginState.State storage state,
3479         Tx memory transaction
3480     )
3481         internal
3482     {
3483         validateTxPostSell(transaction);
3484 
3485         // Transfer feeTokens from trader and lender
3486         transferLoanFees(state, transaction);
3487 
3488         // Update global amounts for the loan
3489         state.loanFills[transaction.loanOffering.loanHash] =
3490             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3491     }
3492 
3493     /**
3494      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3495      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3496      * maxHeldTokenToBuy of heldTokens at most.
3497      */
3498     function doSell(
3499         MarginState.State storage state,
3500         Tx transaction,
3501         bytes orderData,
3502         uint256 maxHeldTokenToBuy
3503     )
3504         internal
3505         returns (uint256)
3506     {
3507         // Move owedTokens from lender to exchange wrapper
3508         pullOwedTokensFromLender(state, transaction);
3509 
3510         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3511         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3512         uint256 sellAmount = transaction.depositInHeldToken ?
3513             transaction.lenderAmount :
3514             transaction.lenderAmount.add(transaction.depositAmount);
3515 
3516         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3517         uint256 heldTokenFromSell = Math.min256(
3518             maxHeldTokenToBuy,
3519             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3520                 msg.sender,
3521                 state.TOKEN_PROXY,
3522                 transaction.loanOffering.heldToken,
3523                 transaction.loanOffering.owedToken,
3524                 sellAmount,
3525                 orderData
3526             )
3527         );
3528 
3529         // Move the tokens to the vault
3530         Vault(state.VAULT).transferToVault(
3531             transaction.positionId,
3532             transaction.loanOffering.heldToken,
3533             transaction.exchangeWrapper,
3534             heldTokenFromSell
3535         );
3536 
3537         // Update collateral amount
3538         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3539 
3540         return heldTokenFromSell;
3541     }
3542 
3543     /**
3544      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3545      * be sold for heldToken.
3546      */
3547     function doDepositOwedToken(
3548         MarginState.State storage state,
3549         Tx transaction
3550     )
3551         internal
3552     {
3553         TokenProxy(state.TOKEN_PROXY).transferTokens(
3554             transaction.loanOffering.owedToken,
3555             msg.sender,
3556             transaction.exchangeWrapper,
3557             transaction.depositAmount
3558         );
3559     }
3560 
3561     /**
3562      * Take the heldToken deposit from the trader and move it to the vault.
3563      */
3564     function doDepositHeldToken(
3565         MarginState.State storage state,
3566         Tx transaction
3567     )
3568         internal
3569     {
3570         Vault(state.VAULT).transferToVault(
3571             transaction.positionId,
3572             transaction.loanOffering.heldToken,
3573             msg.sender,
3574             transaction.depositAmount
3575         );
3576 
3577         // Update collateral amount
3578         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3579     }
3580 
3581     // ============ Private Helper-Functions ============
3582 
3583     function validateTxPostSell(
3584         Tx transaction
3585     )
3586         private
3587         pure
3588     {
3589         uint256 expectedCollateral = transaction.depositInHeldToken ?
3590             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3591             transaction.heldTokenFromSell;
3592         assert(transaction.collateralAmount == expectedCollateral);
3593 
3594         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3595             transaction.lenderAmount,
3596             transaction.loanOffering.rates.maxAmount,
3597             transaction.loanOffering.rates.minHeldToken
3598         );
3599         require(
3600             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3601             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3602         );
3603     }
3604 
3605     function getConsentFromSmartContractLender(
3606         Tx transaction
3607     )
3608         private
3609     {
3610         verifyLoanOfferingRecurse(
3611             transaction.loanOffering.payer,
3612             getLoanOfferingAddresses(transaction),
3613             getLoanOfferingValues256(transaction),
3614             getLoanOfferingValues32(transaction),
3615             transaction.positionId,
3616             transaction.loanOffering.signature
3617         );
3618     }
3619 
3620     function verifyLoanOfferingRecurse(
3621         address contractAddr,
3622         address[9] addresses,
3623         uint256[7] values256,
3624         uint32[4] values32,
3625         bytes32 positionId,
3626         bytes signature
3627     )
3628         private
3629     {
3630         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3631             addresses,
3632             values256,
3633             values32,
3634             positionId,
3635             signature
3636         );
3637 
3638         if (newContractAddr != contractAddr) {
3639             verifyLoanOfferingRecurse(
3640                 newContractAddr,
3641                 addresses,
3642                 values256,
3643                 values32,
3644                 positionId,
3645                 signature
3646             );
3647         }
3648     }
3649 
3650     function pullOwedTokensFromLender(
3651         MarginState.State storage state,
3652         Tx transaction
3653     )
3654         private
3655     {
3656         // Transfer owedToken to the exchange wrapper
3657         TokenProxy(state.TOKEN_PROXY).transferTokens(
3658             transaction.loanOffering.owedToken,
3659             transaction.loanOffering.payer,
3660             transaction.exchangeWrapper,
3661             transaction.lenderAmount
3662         );
3663     }
3664 
3665     function transferLoanFees(
3666         MarginState.State storage state,
3667         Tx transaction
3668     )
3669         private
3670     {
3671         // 0 fee address indicates no fees
3672         if (transaction.loanOffering.feeRecipient == address(0)) {
3673             return;
3674         }
3675 
3676         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3677 
3678         uint256 lenderFee = MathHelpers.getPartialAmount(
3679             transaction.lenderAmount,
3680             transaction.loanOffering.rates.maxAmount,
3681             transaction.loanOffering.rates.lenderFee
3682         );
3683         uint256 takerFee = MathHelpers.getPartialAmount(
3684             transaction.lenderAmount,
3685             transaction.loanOffering.rates.maxAmount,
3686             transaction.loanOffering.rates.takerFee
3687         );
3688 
3689         if (lenderFee > 0) {
3690             proxy.transferTokens(
3691                 transaction.loanOffering.lenderFeeToken,
3692                 transaction.loanOffering.payer,
3693                 transaction.loanOffering.feeRecipient,
3694                 lenderFee
3695             );
3696         }
3697 
3698         if (takerFee > 0) {
3699             proxy.transferTokens(
3700                 transaction.loanOffering.takerFeeToken,
3701                 msg.sender,
3702                 transaction.loanOffering.feeRecipient,
3703                 takerFee
3704             );
3705         }
3706     }
3707 
3708     function getLoanOfferingAddresses(
3709         Tx transaction
3710     )
3711         private
3712         pure
3713         returns (address[9])
3714     {
3715         return [
3716             transaction.loanOffering.owedToken,
3717             transaction.loanOffering.heldToken,
3718             transaction.loanOffering.payer,
3719             transaction.loanOffering.owner,
3720             transaction.loanOffering.taker,
3721             transaction.loanOffering.positionOwner,
3722             transaction.loanOffering.feeRecipient,
3723             transaction.loanOffering.lenderFeeToken,
3724             transaction.loanOffering.takerFeeToken
3725         ];
3726     }
3727 
3728     function getLoanOfferingValues256(
3729         Tx transaction
3730     )
3731         private
3732         pure
3733         returns (uint256[7])
3734     {
3735         return [
3736             transaction.loanOffering.rates.maxAmount,
3737             transaction.loanOffering.rates.minAmount,
3738             transaction.loanOffering.rates.minHeldToken,
3739             transaction.loanOffering.rates.lenderFee,
3740             transaction.loanOffering.rates.takerFee,
3741             transaction.loanOffering.expirationTimestamp,
3742             transaction.loanOffering.salt
3743         ];
3744     }
3745 
3746     function getLoanOfferingValues32(
3747         Tx transaction
3748     )
3749         private
3750         pure
3751         returns (uint32[4])
3752     {
3753         return [
3754             transaction.loanOffering.callTimeLimit,
3755             transaction.loanOffering.maxDuration,
3756             transaction.loanOffering.rates.interestRate,
3757             transaction.loanOffering.rates.interestPeriod
3758         ];
3759     }
3760 }
3761 
3762 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3763 
3764 /**
3765  * @title IncreaseLoanDelegator
3766  * @author dYdX
3767  *
3768  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3769  *
3770  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3771  *       to these functions
3772  */
3773 interface IncreaseLoanDelegator {
3774 
3775     // ============ Public Interface functions ============
3776 
3777     /**
3778      * Function a contract must implement in order to allow additional value to be added onto
3779      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3780      *
3781      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3782      * either revert the entire transaction or that the loan size was successfully increased.
3783      *
3784      * @param  payer           Lender adding additional funds to the position
3785      * @param  positionId      Unique ID of the position
3786      * @param  principalAdded  Principal amount to be added to the position
3787      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
3788      *                         zero if increaseWithoutCounterparty() is used).
3789      * @return                 This address to accept, a different address to ask that contract
3790      */
3791     function increaseLoanOnBehalfOf(
3792         address payer,
3793         bytes32 positionId,
3794         uint256 principalAdded,
3795         uint256 lentAmount
3796     )
3797         external
3798         /* onlyMargin */
3799         returns (address);
3800 }
3801 
3802 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
3803 
3804 /**
3805  * @title IncreasePositionDelegator
3806  * @author dYdX
3807  *
3808  * Interface that smart contracts must implement in order to own position on behalf of other
3809  * accounts
3810  *
3811  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3812  *       to these functions
3813  */
3814 interface IncreasePositionDelegator {
3815 
3816     // ============ Public Interface functions ============
3817 
3818     /**
3819      * Function a contract must implement in order to allow additional value to be added onto
3820      * an owned position. Margin will call this on the owner of a position during increasePosition()
3821      *
3822      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3823      * either revert the entire transaction or that the position size was successfully increased.
3824      *
3825      * @param  trader          Address initiating the addition of funds to the position
3826      * @param  positionId      Unique ID of the position
3827      * @param  principalAdded  Amount of principal to be added to the position
3828      * @return                 This address to accept, a different address to ask that contract
3829      */
3830     function increasePositionOnBehalfOf(
3831         address trader,
3832         bytes32 positionId,
3833         uint256 principalAdded
3834     )
3835         external
3836         /* onlyMargin */
3837         returns (address);
3838 }
3839 
3840 // File: contracts/margin/impl/IncreasePositionImpl.sol
3841 
3842 /**
3843  * @title IncreasePositionImpl
3844  * @author dYdX
3845  *
3846  * This library contains the implementation for the increasePosition function of Margin
3847  */
3848 library IncreasePositionImpl {
3849     using SafeMath for uint256;
3850 
3851     // ============ Events ============
3852 
3853     /*
3854      * A position was increased
3855      */
3856     event PositionIncreased(
3857         bytes32 indexed positionId,
3858         address indexed trader,
3859         address indexed lender,
3860         address positionOwner,
3861         address loanOwner,
3862         bytes32 loanHash,
3863         address loanFeeRecipient,
3864         uint256 amountBorrowed,
3865         uint256 principalAdded,
3866         uint256 heldTokenFromSell,
3867         uint256 depositAmount,
3868         bool    depositInHeldToken
3869     );
3870 
3871     // ============ Public Implementation Functions ============
3872 
3873     function increasePositionImpl(
3874         MarginState.State storage state,
3875         bytes32 positionId,
3876         address[7] addresses,
3877         uint256[8] values256,
3878         uint32[2] values32,
3879         bool depositInHeldToken,
3880         bytes signature,
3881         bytes orderData
3882     )
3883         public
3884         returns (uint256)
3885     {
3886         // Also ensures that the position exists
3887         MarginCommon.Position storage position =
3888             MarginCommon.getPositionFromStorage(state, positionId);
3889 
3890         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
3891             position,
3892             positionId,
3893             addresses,
3894             values256,
3895             values32,
3896             depositInHeldToken,
3897             signature
3898         );
3899 
3900         validateIncrease(state, transaction, position);
3901 
3902         doBorrowAndSell(state, transaction, orderData);
3903 
3904         updateState(
3905             position,
3906             transaction.positionId,
3907             transaction.principal,
3908             transaction.lenderAmount,
3909             transaction.loanOffering.payer
3910         );
3911 
3912         // LOG EVENT
3913         recordPositionIncreased(transaction, position);
3914 
3915         return transaction.lenderAmount;
3916     }
3917 
3918     function increaseWithoutCounterpartyImpl(
3919         MarginState.State storage state,
3920         bytes32 positionId,
3921         uint256 principalToAdd
3922     )
3923         public
3924         returns (uint256)
3925     {
3926         MarginCommon.Position storage position =
3927             MarginCommon.getPositionFromStorage(state, positionId);
3928 
3929         // Disallow adding 0 principal
3930         require(
3931             principalToAdd > 0,
3932             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
3933         );
3934 
3935         // Disallow additions after maximum duration
3936         require(
3937             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
3938             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
3939         );
3940 
3941         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
3942             state,
3943             position,
3944             positionId,
3945             principalToAdd
3946         );
3947 
3948         Vault(state.VAULT).transferToVault(
3949             positionId,
3950             position.heldToken,
3951             msg.sender,
3952             heldTokenAmount
3953         );
3954 
3955         updateState(
3956             position,
3957             positionId,
3958             principalToAdd,
3959             0, // lent amount
3960             msg.sender
3961         );
3962 
3963         emit PositionIncreased(
3964             positionId,
3965             msg.sender,
3966             msg.sender,
3967             position.owner,
3968             position.lender,
3969             "",
3970             address(0),
3971             0,
3972             principalToAdd,
3973             0,
3974             heldTokenAmount,
3975             true
3976         );
3977 
3978         return heldTokenAmount;
3979     }
3980 
3981     // ============ Private Helper-Functions ============
3982 
3983     function doBorrowAndSell(
3984         MarginState.State storage state,
3985         BorrowShared.Tx memory transaction,
3986         bytes orderData
3987     )
3988         private
3989     {
3990         // Calculate the number of heldTokens to add
3991         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
3992             state,
3993             state.positions[transaction.positionId],
3994             transaction.positionId,
3995             transaction.principal
3996         );
3997 
3998         // Do pre-exchange validations
3999         BorrowShared.validateTxPreSell(state, transaction);
4000 
4001         // Calculate and deposit owedToken
4002         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
4003         if (!transaction.depositInHeldToken) {
4004             transaction.depositAmount =
4005                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
4006             BorrowShared.doDepositOwedToken(state, transaction);
4007             maxHeldTokenFromSell = collateralToAdd;
4008         }
4009 
4010         // Sell owedToken for heldToken using the exchange wrapper
4011         transaction.heldTokenFromSell = BorrowShared.doSell(
4012             state,
4013             transaction,
4014             orderData,
4015             maxHeldTokenFromSell
4016         );
4017 
4018         // Calculate and deposit heldToken
4019         if (transaction.depositInHeldToken) {
4020             require(
4021                 transaction.heldTokenFromSell <= collateralToAdd,
4022                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
4023             );
4024             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
4025             BorrowShared.doDepositHeldToken(state, transaction);
4026         }
4027 
4028         // Make sure the actual added collateral is what is expected
4029         assert(transaction.collateralAmount == collateralToAdd);
4030 
4031         // Do post-exchange validations
4032         BorrowShared.doPostSell(state, transaction);
4033     }
4034 
4035     function getOwedTokenDeposit(
4036         BorrowShared.Tx transaction,
4037         uint256 collateralToAdd,
4038         bytes orderData
4039     )
4040         private
4041         view
4042         returns (uint256)
4043     {
4044         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
4045             transaction.loanOffering.heldToken,
4046             transaction.loanOffering.owedToken,
4047             collateralToAdd,
4048             orderData
4049         );
4050 
4051         require(
4052             transaction.lenderAmount <= totalOwedToken,
4053             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4054         );
4055 
4056         return totalOwedToken.sub(transaction.lenderAmount);
4057     }
4058 
4059     function validateIncrease(
4060         MarginState.State storage state,
4061         BorrowShared.Tx transaction,
4062         MarginCommon.Position storage position
4063     )
4064         private
4065         view
4066     {
4067         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4068 
4069         require(
4070             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4071             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4072         );
4073 
4074         // require the position to end no later than the loanOffering's maximum acceptable end time
4075         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4076         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4077         require(
4078             positionEndTimestamp <= offeringEndTimestamp,
4079             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4080         );
4081 
4082         require(
4083             block.timestamp < positionEndTimestamp,
4084             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4085         );
4086     }
4087 
4088     function getCollateralNeededForAddedPrincipal(
4089         MarginState.State storage state,
4090         MarginCommon.Position storage position,
4091         bytes32 positionId,
4092         uint256 principalToAdd
4093     )
4094         private
4095         view
4096         returns (uint256)
4097     {
4098         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4099 
4100         return MathHelpers.getPartialAmountRoundedUp(
4101             principalToAdd,
4102             position.principal,
4103             heldTokenBalance
4104         );
4105     }
4106 
4107     function updateState(
4108         MarginCommon.Position storage position,
4109         bytes32 positionId,
4110         uint256 principalAdded,
4111         uint256 owedTokenLent,
4112         address loanPayer
4113     )
4114         private
4115     {
4116         position.principal = position.principal.add(principalAdded);
4117 
4118         address owner = position.owner;
4119         address lender = position.lender;
4120 
4121         // Ensure owner consent
4122         increasePositionOnBehalfOfRecurse(
4123             owner,
4124             msg.sender,
4125             positionId,
4126             principalAdded
4127         );
4128 
4129         // Ensure lender consent
4130         increaseLoanOnBehalfOfRecurse(
4131             lender,
4132             loanPayer,
4133             positionId,
4134             principalAdded,
4135             owedTokenLent
4136         );
4137     }
4138 
4139     function increasePositionOnBehalfOfRecurse(
4140         address contractAddr,
4141         address trader,
4142         bytes32 positionId,
4143         uint256 principalAdded
4144     )
4145         private
4146     {
4147         // Assume owner approval if not a smart contract and they increased their own position
4148         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4149             return;
4150         }
4151 
4152         address newContractAddr =
4153             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4154                 trader,
4155                 positionId,
4156                 principalAdded
4157             );
4158 
4159         if (newContractAddr != contractAddr) {
4160             increasePositionOnBehalfOfRecurse(
4161                 newContractAddr,
4162                 trader,
4163                 positionId,
4164                 principalAdded
4165             );
4166         }
4167     }
4168 
4169     function increaseLoanOnBehalfOfRecurse(
4170         address contractAddr,
4171         address payer,
4172         bytes32 positionId,
4173         uint256 principalAdded,
4174         uint256 amountLent
4175     )
4176         private
4177     {
4178         // Assume lender approval if not a smart contract and they increased their own loan
4179         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4180             return;
4181         }
4182 
4183         address newContractAddr =
4184             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4185                 payer,
4186                 positionId,
4187                 principalAdded,
4188                 amountLent
4189             );
4190 
4191         if (newContractAddr != contractAddr) {
4192             increaseLoanOnBehalfOfRecurse(
4193                 newContractAddr,
4194                 payer,
4195                 positionId,
4196                 principalAdded,
4197                 amountLent
4198             );
4199         }
4200     }
4201 
4202     function recordPositionIncreased(
4203         BorrowShared.Tx transaction,
4204         MarginCommon.Position storage position
4205     )
4206         private
4207     {
4208         emit PositionIncreased(
4209             transaction.positionId,
4210             msg.sender,
4211             transaction.loanOffering.payer,
4212             position.owner,
4213             position.lender,
4214             transaction.loanOffering.loanHash,
4215             transaction.loanOffering.feeRecipient,
4216             transaction.lenderAmount,
4217             transaction.principal,
4218             transaction.heldTokenFromSell,
4219             transaction.depositAmount,
4220             transaction.depositInHeldToken
4221         );
4222     }
4223 
4224     // ============ Parsing Functions ============
4225 
4226     function parseIncreasePositionTx(
4227         MarginCommon.Position storage position,
4228         bytes32 positionId,
4229         address[7] addresses,
4230         uint256[8] values256,
4231         uint32[2] values32,
4232         bool depositInHeldToken,
4233         bytes signature
4234     )
4235         private
4236         view
4237         returns (BorrowShared.Tx memory)
4238     {
4239         uint256 principal = values256[7];
4240 
4241         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4242             position,
4243             principal,
4244             block.timestamp
4245         );
4246         assert(lenderAmount >= principal);
4247 
4248         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4249             positionId: positionId,
4250             owner: position.owner,
4251             principal: principal,
4252             lenderAmount: lenderAmount,
4253             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4254                 position,
4255                 addresses,
4256                 values256,
4257                 values32,
4258                 signature
4259             ),
4260             exchangeWrapper: addresses[6],
4261             depositInHeldToken: depositInHeldToken,
4262             depositAmount: 0, // set later
4263             collateralAmount: 0, // set later
4264             heldTokenFromSell: 0 // set later
4265         });
4266 
4267         return transaction;
4268     }
4269 
4270     function parseLoanOfferingFromIncreasePositionTx(
4271         MarginCommon.Position storage position,
4272         address[7] addresses,
4273         uint256[8] values256,
4274         uint32[2] values32,
4275         bytes signature
4276     )
4277         private
4278         view
4279         returns (MarginCommon.LoanOffering memory)
4280     {
4281         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4282             owedToken: position.owedToken,
4283             heldToken: position.heldToken,
4284             payer: addresses[0],
4285             owner: position.lender,
4286             taker: addresses[1],
4287             positionOwner: addresses[2],
4288             feeRecipient: addresses[3],
4289             lenderFeeToken: addresses[4],
4290             takerFeeToken: addresses[5],
4291             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4292             expirationTimestamp: values256[5],
4293             callTimeLimit: values32[0],
4294             maxDuration: values32[1],
4295             salt: values256[6],
4296             loanHash: 0,
4297             signature: signature
4298         });
4299 
4300         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4301 
4302         return loanOffering;
4303     }
4304 
4305     function parseLoanOfferingRatesFromIncreasePositionTx(
4306         MarginCommon.Position storage position,
4307         uint256[8] values256
4308     )
4309         private
4310         view
4311         returns (MarginCommon.LoanRates memory)
4312     {
4313         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4314             maxAmount: values256[0],
4315             minAmount: values256[1],
4316             minHeldToken: values256[2],
4317             lenderFee: values256[3],
4318             takerFee: values256[4],
4319             interestRate: position.interestRate,
4320             interestPeriod: position.interestPeriod
4321         });
4322 
4323         return rates;
4324     }
4325 }
4326 
4327 // File: contracts/margin/impl/MarginStorage.sol
4328 
4329 /**
4330  * @title MarginStorage
4331  * @author dYdX
4332  *
4333  * This contract serves as the storage for the entire state of MarginStorage
4334  */
4335 contract MarginStorage {
4336 
4337     MarginState.State state;
4338 
4339 }
4340 
4341 // File: contracts/margin/impl/LoanGetters.sol
4342 
4343 /**
4344  * @title LoanGetters
4345  * @author dYdX
4346  *
4347  * A collection of public constant getter functions that allows reading of the state of any loan
4348  * offering stored in the dYdX protocol.
4349  */
4350 contract LoanGetters is MarginStorage {
4351 
4352     // ============ Public Constant Functions ============
4353 
4354     /**
4355      * Gets the principal amount of a loan offering that is no longer available.
4356      *
4357      * @param  loanHash  Unique hash of the loan offering
4358      * @return           The total unavailable amount of the loan offering, which is equal to the
4359      *                   filled amount plus the canceled amount.
4360      */
4361     function getLoanUnavailableAmount(
4362         bytes32 loanHash
4363     )
4364         external
4365         view
4366         returns (uint256)
4367     {
4368         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4369     }
4370 
4371     /**
4372      * Gets the total amount of owed token lent for a loan.
4373      *
4374      * @param  loanHash  Unique hash of the loan offering
4375      * @return           The total filled amount of the loan offering.
4376      */
4377     function getLoanFilledAmount(
4378         bytes32 loanHash
4379     )
4380         external
4381         view
4382         returns (uint256)
4383     {
4384         return state.loanFills[loanHash];
4385     }
4386 
4387     /**
4388      * Gets the amount of a loan offering that has been canceled.
4389      *
4390      * @param  loanHash  Unique hash of the loan offering
4391      * @return           The total canceled amount of the loan offering.
4392      */
4393     function getLoanCanceledAmount(
4394         bytes32 loanHash
4395     )
4396         external
4397         view
4398         returns (uint256)
4399     {
4400         return state.loanCancels[loanHash];
4401     }
4402 }
4403 
4404 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4405 
4406 /**
4407  * @title CancelMarginCallDelegator
4408  * @author dYdX
4409  *
4410  * Interface that smart contracts must implement in order to let other addresses cancel a
4411  * margin-call for a loan owned by the smart contract.
4412  *
4413  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4414  *       to these functions
4415  */
4416 interface CancelMarginCallDelegator {
4417 
4418     // ============ Public Interface functions ============
4419 
4420     /**
4421      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4422      *
4423      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4424      * either revert the entire transaction or that the margin-call was successfully canceled.
4425      *
4426      * @param  canceler    Address of the caller of the cancelMarginCall function
4427      * @param  positionId  Unique ID of the position
4428      * @return             This address to accept, a different address to ask that contract
4429      */
4430     function cancelMarginCallOnBehalfOf(
4431         address canceler,
4432         bytes32 positionId
4433     )
4434         external
4435         /* onlyMargin */
4436         returns (address);
4437 }
4438 
4439 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4440 
4441 /**
4442  * @title MarginCallDelegator
4443  * @author dYdX
4444  *
4445  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4446  * owned by the smart contract.
4447  *
4448  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4449  *       to these functions
4450  */
4451 interface MarginCallDelegator {
4452 
4453     // ============ Public Interface functions ============
4454 
4455     /**
4456      * Function a contract must implement in order to let other addresses call marginCall().
4457      *
4458      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4459      * either revert the entire transaction or that the loan was successfully margin-called.
4460      *
4461      * @param  caller         Address of the caller of the marginCall function
4462      * @param  positionId     Unique ID of the position
4463      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4464      * @return                This address to accept, a different address to ask that contract
4465      */
4466     function marginCallOnBehalfOf(
4467         address caller,
4468         bytes32 positionId,
4469         uint256 depositAmount
4470     )
4471         external
4472         /* onlyMargin */
4473         returns (address);
4474 }
4475 
4476 // File: contracts/margin/impl/LoanImpl.sol
4477 
4478 /**
4479  * @title LoanImpl
4480  * @author dYdX
4481  *
4482  * This library contains the implementation for the following functions of Margin:
4483  *
4484  *      - marginCall
4485  *      - cancelMarginCallImpl
4486  *      - cancelLoanOffering
4487  */
4488 library LoanImpl {
4489     using SafeMath for uint256;
4490 
4491     // ============ Events ============
4492 
4493     /**
4494      * A position was margin-called
4495      */
4496     event MarginCallInitiated(
4497         bytes32 indexed positionId,
4498         address indexed lender,
4499         address indexed owner,
4500         uint256 requiredDeposit
4501     );
4502 
4503     /**
4504      * A margin call was canceled
4505      */
4506     event MarginCallCanceled(
4507         bytes32 indexed positionId,
4508         address indexed lender,
4509         address indexed owner,
4510         uint256 depositAmount
4511     );
4512 
4513     /**
4514      * A loan offering was canceled before it was used. Any amount less than the
4515      * total for the loan offering can be canceled.
4516      */
4517     event LoanOfferingCanceled(
4518         bytes32 indexed loanHash,
4519         address indexed payer,
4520         address indexed feeRecipient,
4521         uint256 cancelAmount
4522     );
4523 
4524     // ============ Public Implementation Functions ============
4525 
4526     function marginCallImpl(
4527         MarginState.State storage state,
4528         bytes32 positionId,
4529         uint256 requiredDeposit
4530     )
4531         public
4532     {
4533         MarginCommon.Position storage position =
4534             MarginCommon.getPositionFromStorage(state, positionId);
4535 
4536         require(
4537             position.callTimestamp == 0,
4538             "LoanImpl#marginCallImpl: The position has already been margin-called"
4539         );
4540 
4541         // Ensure lender consent
4542         marginCallOnBehalfOfRecurse(
4543             position.lender,
4544             msg.sender,
4545             positionId,
4546             requiredDeposit
4547         );
4548 
4549         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4550         position.requiredDeposit = requiredDeposit;
4551 
4552         emit MarginCallInitiated(
4553             positionId,
4554             position.lender,
4555             position.owner,
4556             requiredDeposit
4557         );
4558     }
4559 
4560     function cancelMarginCallImpl(
4561         MarginState.State storage state,
4562         bytes32 positionId
4563     )
4564         public
4565     {
4566         MarginCommon.Position storage position =
4567             MarginCommon.getPositionFromStorage(state, positionId);
4568 
4569         require(
4570             position.callTimestamp > 0,
4571             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4572         );
4573 
4574         // Ensure lender consent
4575         cancelMarginCallOnBehalfOfRecurse(
4576             position.lender,
4577             msg.sender,
4578             positionId
4579         );
4580 
4581         state.positions[positionId].callTimestamp = 0;
4582         state.positions[positionId].requiredDeposit = 0;
4583 
4584         emit MarginCallCanceled(
4585             positionId,
4586             position.lender,
4587             position.owner,
4588             0
4589         );
4590     }
4591 
4592     function cancelLoanOfferingImpl(
4593         MarginState.State storage state,
4594         address[9] addresses,
4595         uint256[7] values256,
4596         uint32[4]  values32,
4597         uint256    cancelAmount
4598     )
4599         public
4600         returns (uint256)
4601     {
4602         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4603             addresses,
4604             values256,
4605             values32
4606         );
4607 
4608         require(
4609             msg.sender == loanOffering.payer,
4610             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4611         );
4612         require(
4613             loanOffering.expirationTimestamp > block.timestamp,
4614             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4615         );
4616 
4617         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4618             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4619         );
4620         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4621 
4622         // If the loan was already fully canceled, then just return 0 amount was canceled
4623         if (amountToCancel == 0) {
4624             return 0;
4625         }
4626 
4627         state.loanCancels[loanOffering.loanHash] =
4628             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4629 
4630         emit LoanOfferingCanceled(
4631             loanOffering.loanHash,
4632             loanOffering.payer,
4633             loanOffering.feeRecipient,
4634             amountToCancel
4635         );
4636 
4637         return amountToCancel;
4638     }
4639 
4640     // ============ Private Helper-Functions ============
4641 
4642     function marginCallOnBehalfOfRecurse(
4643         address contractAddr,
4644         address who,
4645         bytes32 positionId,
4646         uint256 requiredDeposit
4647     )
4648         private
4649     {
4650         // no need to ask for permission
4651         if (who == contractAddr) {
4652             return;
4653         }
4654 
4655         address newContractAddr =
4656             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4657                 msg.sender,
4658                 positionId,
4659                 requiredDeposit
4660             );
4661 
4662         if (newContractAddr != contractAddr) {
4663             marginCallOnBehalfOfRecurse(
4664                 newContractAddr,
4665                 who,
4666                 positionId,
4667                 requiredDeposit
4668             );
4669         }
4670     }
4671 
4672     function cancelMarginCallOnBehalfOfRecurse(
4673         address contractAddr,
4674         address who,
4675         bytes32 positionId
4676     )
4677         private
4678     {
4679         // no need to ask for permission
4680         if (who == contractAddr) {
4681             return;
4682         }
4683 
4684         address newContractAddr =
4685             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4686                 msg.sender,
4687                 positionId
4688             );
4689 
4690         if (newContractAddr != contractAddr) {
4691             cancelMarginCallOnBehalfOfRecurse(
4692                 newContractAddr,
4693                 who,
4694                 positionId
4695             );
4696         }
4697     }
4698 
4699     // ============ Parsing Functions ============
4700 
4701     function parseLoanOffering(
4702         address[9] addresses,
4703         uint256[7] values256,
4704         uint32[4]  values32
4705     )
4706         private
4707         view
4708         returns (MarginCommon.LoanOffering memory)
4709     {
4710         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4711             owedToken: addresses[0],
4712             heldToken: addresses[1],
4713             payer: addresses[2],
4714             owner: addresses[3],
4715             taker: addresses[4],
4716             positionOwner: addresses[5],
4717             feeRecipient: addresses[6],
4718             lenderFeeToken: addresses[7],
4719             takerFeeToken: addresses[8],
4720             rates: parseLoanOfferRates(values256, values32),
4721             expirationTimestamp: values256[5],
4722             callTimeLimit: values32[0],
4723             maxDuration: values32[1],
4724             salt: values256[6],
4725             loanHash: 0,
4726             signature: new bytes(0)
4727         });
4728 
4729         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4730 
4731         return loanOffering;
4732     }
4733 
4734     function parseLoanOfferRates(
4735         uint256[7] values256,
4736         uint32[4] values32
4737     )
4738         private
4739         pure
4740         returns (MarginCommon.LoanRates memory)
4741     {
4742         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4743             maxAmount: values256[0],
4744             minAmount: values256[1],
4745             minHeldToken: values256[2],
4746             interestRate: values32[2],
4747             lenderFee: values256[3],
4748             takerFee: values256[4],
4749             interestPeriod: values32[3]
4750         });
4751 
4752         return rates;
4753     }
4754 }
4755 
4756 // File: contracts/margin/impl/MarginAdmin.sol
4757 
4758 /**
4759  * @title MarginAdmin
4760  * @author dYdX
4761  *
4762  * Contains admin functions for the Margin contract
4763  * The owner can put Margin into various close-only modes, which will disallow new position creation
4764  */
4765 contract MarginAdmin is Ownable {
4766     // ============ Enums ============
4767 
4768     // All functionality enabled
4769     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4770 
4771     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4772     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4773     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4774 
4775     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4776     // forceRecoverCollateral)
4777     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4778 
4779     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4780     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4781 
4782     // This operation state (and any higher) is invalid
4783     uint8 private constant OPERATION_STATE_INVALID = 4;
4784 
4785     // ============ Events ============
4786 
4787     /**
4788      * Event indicating the operation state has changed
4789      */
4790     event OperationStateChanged(
4791         uint8 from,
4792         uint8 to
4793     );
4794 
4795     // ============ State Variables ============
4796 
4797     uint8 public operationState;
4798 
4799     // ============ Constructor ============
4800 
4801     constructor()
4802         public
4803         Ownable()
4804     {
4805         operationState = OPERATION_STATE_OPERATIONAL;
4806     }
4807 
4808     // ============ Modifiers ============
4809 
4810     modifier onlyWhileOperational() {
4811         require(
4812             operationState == OPERATION_STATE_OPERATIONAL,
4813             "MarginAdmin#onlyWhileOperational: Can only call while operational"
4814         );
4815         _;
4816     }
4817 
4818     modifier cancelLoanOfferingStateControl() {
4819         require(
4820             operationState == OPERATION_STATE_OPERATIONAL
4821             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
4822             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
4823         );
4824         _;
4825     }
4826 
4827     modifier closePositionStateControl() {
4828         require(
4829             operationState == OPERATION_STATE_OPERATIONAL
4830             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
4831             || operationState == OPERATION_STATE_CLOSE_ONLY,
4832             "MarginAdmin#closePositionStateControl: Invalid operation state"
4833         );
4834         _;
4835     }
4836 
4837     modifier closePositionDirectlyStateControl() {
4838         _;
4839     }
4840 
4841     // ============ Owner-Only State-Changing Functions ============
4842 
4843     function setOperationState(
4844         uint8 newState
4845     )
4846         external
4847         onlyOwner
4848     {
4849         require(
4850             newState < OPERATION_STATE_INVALID,
4851             "MarginAdmin#setOperationState: newState is not a valid operation state"
4852         );
4853 
4854         if (newState != operationState) {
4855             emit OperationStateChanged(
4856                 operationState,
4857                 newState
4858             );
4859             operationState = newState;
4860         }
4861     }
4862 }
4863 
4864 // File: contracts/margin/impl/MarginEvents.sol
4865 
4866 /**
4867  * @title MarginEvents
4868  * @author dYdX
4869  *
4870  * Contains events for the Margin contract.
4871  *
4872  * NOTE: Any Margin function libraries that use events will need to both define the event here
4873  *       and copy the event into the library itself as libraries don't support sharing events
4874  */
4875 contract MarginEvents {
4876     // ============ Events ============
4877 
4878     /**
4879      * A position was opened
4880      */
4881     event PositionOpened(
4882         bytes32 indexed positionId,
4883         address indexed trader,
4884         address indexed lender,
4885         bytes32 loanHash,
4886         address owedToken,
4887         address heldToken,
4888         address loanFeeRecipient,
4889         uint256 principal,
4890         uint256 heldTokenFromSell,
4891         uint256 depositAmount,
4892         uint256 interestRate,
4893         uint32  callTimeLimit,
4894         uint32  maxDuration,
4895         bool    depositInHeldToken
4896     );
4897 
4898     /*
4899      * A position was increased
4900      */
4901     event PositionIncreased(
4902         bytes32 indexed positionId,
4903         address indexed trader,
4904         address indexed lender,
4905         address positionOwner,
4906         address loanOwner,
4907         bytes32 loanHash,
4908         address loanFeeRecipient,
4909         uint256 amountBorrowed,
4910         uint256 principalAdded,
4911         uint256 heldTokenFromSell,
4912         uint256 depositAmount,
4913         bool    depositInHeldToken
4914     );
4915 
4916     /**
4917      * A position was closed or partially closed
4918      */
4919     event PositionClosed(
4920         bytes32 indexed positionId,
4921         address indexed closer,
4922         address indexed payoutRecipient,
4923         uint256 closeAmount,
4924         uint256 remainingAmount,
4925         uint256 owedTokenPaidToLender,
4926         uint256 payoutAmount,
4927         uint256 buybackCostInHeldToken,
4928         bool payoutInHeldToken
4929     );
4930 
4931     /**
4932      * Collateral for a position was forcibly recovered
4933      */
4934     event CollateralForceRecovered(
4935         bytes32 indexed positionId,
4936         address indexed recipient,
4937         uint256 amount
4938     );
4939 
4940     /**
4941      * A position was margin-called
4942      */
4943     event MarginCallInitiated(
4944         bytes32 indexed positionId,
4945         address indexed lender,
4946         address indexed owner,
4947         uint256 requiredDeposit
4948     );
4949 
4950     /**
4951      * A margin call was canceled
4952      */
4953     event MarginCallCanceled(
4954         bytes32 indexed positionId,
4955         address indexed lender,
4956         address indexed owner,
4957         uint256 depositAmount
4958     );
4959 
4960     /**
4961      * A loan offering was canceled before it was used. Any amount less than the
4962      * total for the loan offering can be canceled.
4963      */
4964     event LoanOfferingCanceled(
4965         bytes32 indexed loanHash,
4966         address indexed payer,
4967         address indexed feeRecipient,
4968         uint256 cancelAmount
4969     );
4970 
4971     /**
4972      * Additional collateral for a position was posted by the owner
4973      */
4974     event AdditionalCollateralDeposited(
4975         bytes32 indexed positionId,
4976         uint256 amount,
4977         address depositor
4978     );
4979 
4980     /**
4981      * Ownership of a loan was transferred to a new address
4982      */
4983     event LoanTransferred(
4984         bytes32 indexed positionId,
4985         address indexed from,
4986         address indexed to
4987     );
4988 
4989     /**
4990      * Ownership of a position was transferred to a new address
4991      */
4992     event PositionTransferred(
4993         bytes32 indexed positionId,
4994         address indexed from,
4995         address indexed to
4996     );
4997 }
4998 
4999 // File: contracts/margin/impl/OpenPositionImpl.sol
5000 
5001 /**
5002  * @title OpenPositionImpl
5003  * @author dYdX
5004  *
5005  * This library contains the implementation for the openPosition function of Margin
5006  */
5007 library OpenPositionImpl {
5008     using SafeMath for uint256;
5009 
5010     // ============ Events ============
5011 
5012     /**
5013      * A position was opened
5014      */
5015     event PositionOpened(
5016         bytes32 indexed positionId,
5017         address indexed trader,
5018         address indexed lender,
5019         bytes32 loanHash,
5020         address owedToken,
5021         address heldToken,
5022         address loanFeeRecipient,
5023         uint256 principal,
5024         uint256 heldTokenFromSell,
5025         uint256 depositAmount,
5026         uint256 interestRate,
5027         uint32  callTimeLimit,
5028         uint32  maxDuration,
5029         bool    depositInHeldToken
5030     );
5031 
5032     // ============ Public Implementation Functions ============
5033 
5034     function openPositionImpl(
5035         MarginState.State storage state,
5036         address[11] addresses,
5037         uint256[10] values256,
5038         uint32[4] values32,
5039         bool depositInHeldToken,
5040         bytes signature,
5041         bytes orderData
5042     )
5043         public
5044         returns (bytes32)
5045     {
5046         BorrowShared.Tx memory transaction = parseOpenTx(
5047             addresses,
5048             values256,
5049             values32,
5050             depositInHeldToken,
5051             signature
5052         );
5053 
5054         require(
5055             !MarginCommon.positionHasExisted(state, transaction.positionId),
5056             "OpenPositionImpl#openPositionImpl: positionId already exists"
5057         );
5058 
5059         doBorrowAndSell(state, transaction, orderData);
5060 
5061         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5062         recordPositionOpened(
5063             transaction
5064         );
5065 
5066         doStoreNewPosition(
5067             state,
5068             transaction
5069         );
5070 
5071         return transaction.positionId;
5072     }
5073 
5074     // ============ Private Helper-Functions ============
5075 
5076     function doBorrowAndSell(
5077         MarginState.State storage state,
5078         BorrowShared.Tx memory transaction,
5079         bytes orderData
5080     )
5081         private
5082     {
5083         BorrowShared.validateTxPreSell(state, transaction);
5084 
5085         if (transaction.depositInHeldToken) {
5086             BorrowShared.doDepositHeldToken(state, transaction);
5087         } else {
5088             BorrowShared.doDepositOwedToken(state, transaction);
5089         }
5090 
5091         transaction.heldTokenFromSell = BorrowShared.doSell(
5092             state,
5093             transaction,
5094             orderData,
5095             MathHelpers.maxUint256()
5096         );
5097 
5098         BorrowShared.doPostSell(state, transaction);
5099     }
5100 
5101     function doStoreNewPosition(
5102         MarginState.State storage state,
5103         BorrowShared.Tx memory transaction
5104     )
5105         private
5106     {
5107         MarginCommon.storeNewPosition(
5108             state,
5109             transaction.positionId,
5110             MarginCommon.Position({
5111                 owedToken: transaction.loanOffering.owedToken,
5112                 heldToken: transaction.loanOffering.heldToken,
5113                 lender: transaction.loanOffering.owner,
5114                 owner: transaction.owner,
5115                 principal: transaction.principal,
5116                 requiredDeposit: 0,
5117                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5118                 startTimestamp: 0,
5119                 callTimestamp: 0,
5120                 maxDuration: transaction.loanOffering.maxDuration,
5121                 interestRate: transaction.loanOffering.rates.interestRate,
5122                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5123             }),
5124             transaction.loanOffering.payer
5125         );
5126     }
5127 
5128     function recordPositionOpened(
5129         BorrowShared.Tx transaction
5130     )
5131         private
5132     {
5133         emit PositionOpened(
5134             transaction.positionId,
5135             msg.sender,
5136             transaction.loanOffering.payer,
5137             transaction.loanOffering.loanHash,
5138             transaction.loanOffering.owedToken,
5139             transaction.loanOffering.heldToken,
5140             transaction.loanOffering.feeRecipient,
5141             transaction.principal,
5142             transaction.heldTokenFromSell,
5143             transaction.depositAmount,
5144             transaction.loanOffering.rates.interestRate,
5145             transaction.loanOffering.callTimeLimit,
5146             transaction.loanOffering.maxDuration,
5147             transaction.depositInHeldToken
5148         );
5149     }
5150 
5151     // ============ Parsing Functions ============
5152 
5153     function parseOpenTx(
5154         address[11] addresses,
5155         uint256[10] values256,
5156         uint32[4] values32,
5157         bool depositInHeldToken,
5158         bytes signature
5159     )
5160         private
5161         view
5162         returns (BorrowShared.Tx memory)
5163     {
5164         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5165             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5166             owner: addresses[0],
5167             principal: values256[7],
5168             lenderAmount: values256[7],
5169             loanOffering: parseLoanOffering(
5170                 addresses,
5171                 values256,
5172                 values32,
5173                 signature
5174             ),
5175             exchangeWrapper: addresses[10],
5176             depositInHeldToken: depositInHeldToken,
5177             depositAmount: values256[8],
5178             collateralAmount: 0, // set later
5179             heldTokenFromSell: 0 // set later
5180         });
5181 
5182         return transaction;
5183     }
5184 
5185     function parseLoanOffering(
5186         address[11] addresses,
5187         uint256[10] values256,
5188         uint32[4]   values32,
5189         bytes       signature
5190     )
5191         private
5192         view
5193         returns (MarginCommon.LoanOffering memory)
5194     {
5195         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5196             owedToken: addresses[1],
5197             heldToken: addresses[2],
5198             payer: addresses[3],
5199             owner: addresses[4],
5200             taker: addresses[5],
5201             positionOwner: addresses[6],
5202             feeRecipient: addresses[7],
5203             lenderFeeToken: addresses[8],
5204             takerFeeToken: addresses[9],
5205             rates: parseLoanOfferRates(values256, values32),
5206             expirationTimestamp: values256[5],
5207             callTimeLimit: values32[0],
5208             maxDuration: values32[1],
5209             salt: values256[6],
5210             loanHash: 0,
5211             signature: signature
5212         });
5213 
5214         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5215 
5216         return loanOffering;
5217     }
5218 
5219     function parseLoanOfferRates(
5220         uint256[10] values256,
5221         uint32[4] values32
5222     )
5223         private
5224         pure
5225         returns (MarginCommon.LoanRates memory)
5226     {
5227         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5228             maxAmount: values256[0],
5229             minAmount: values256[1],
5230             minHeldToken: values256[2],
5231             lenderFee: values256[3],
5232             takerFee: values256[4],
5233             interestRate: values32[2],
5234             interestPeriod: values32[3]
5235         });
5236 
5237         return rates;
5238     }
5239 }
5240 
5241 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5242 
5243 /**
5244  * @title OpenWithoutCounterpartyImpl
5245  * @author dYdX
5246  *
5247  * This library contains the implementation for the openWithoutCounterparty
5248  * function of Margin
5249  */
5250 library OpenWithoutCounterpartyImpl {
5251 
5252     // ============ Structs ============
5253 
5254     struct Tx {
5255         bytes32 positionId;
5256         address positionOwner;
5257         address owedToken;
5258         address heldToken;
5259         address loanOwner;
5260         uint256 principal;
5261         uint256 deposit;
5262         uint32 callTimeLimit;
5263         uint32 maxDuration;
5264         uint32 interestRate;
5265         uint32 interestPeriod;
5266     }
5267 
5268     // ============ Events ============
5269 
5270     /**
5271      * A position was opened
5272      */
5273     event PositionOpened(
5274         bytes32 indexed positionId,
5275         address indexed trader,
5276         address indexed lender,
5277         bytes32 loanHash,
5278         address owedToken,
5279         address heldToken,
5280         address loanFeeRecipient,
5281         uint256 principal,
5282         uint256 heldTokenFromSell,
5283         uint256 depositAmount,
5284         uint256 interestRate,
5285         uint32  callTimeLimit,
5286         uint32  maxDuration,
5287         bool    depositInHeldToken
5288     );
5289 
5290     // ============ Public Implementation Functions ============
5291 
5292     function openWithoutCounterpartyImpl(
5293         MarginState.State storage state,
5294         address[4] addresses,
5295         uint256[3] values256,
5296         uint32[4]  values32
5297     )
5298         public
5299         returns (bytes32)
5300     {
5301         Tx memory openTx = parseTx(
5302             addresses,
5303             values256,
5304             values32
5305         );
5306 
5307         validate(
5308             state,
5309             openTx
5310         );
5311 
5312         Vault(state.VAULT).transferToVault(
5313             openTx.positionId,
5314             openTx.heldToken,
5315             msg.sender,
5316             openTx.deposit
5317         );
5318 
5319         recordPositionOpened(
5320             openTx
5321         );
5322 
5323         doStoreNewPosition(
5324             state,
5325             openTx
5326         );
5327 
5328         return openTx.positionId;
5329     }
5330 
5331     // ============ Private Helper-Functions ============
5332 
5333     function doStoreNewPosition(
5334         MarginState.State storage state,
5335         Tx memory openTx
5336     )
5337         private
5338     {
5339         MarginCommon.storeNewPosition(
5340             state,
5341             openTx.positionId,
5342             MarginCommon.Position({
5343                 owedToken: openTx.owedToken,
5344                 heldToken: openTx.heldToken,
5345                 lender: openTx.loanOwner,
5346                 owner: openTx.positionOwner,
5347                 principal: openTx.principal,
5348                 requiredDeposit: 0,
5349                 callTimeLimit: openTx.callTimeLimit,
5350                 startTimestamp: 0,
5351                 callTimestamp: 0,
5352                 maxDuration: openTx.maxDuration,
5353                 interestRate: openTx.interestRate,
5354                 interestPeriod: openTx.interestPeriod
5355             }),
5356             msg.sender
5357         );
5358     }
5359 
5360     function validate(
5361         MarginState.State storage state,
5362         Tx memory openTx
5363     )
5364         private
5365         view
5366     {
5367         require(
5368             !MarginCommon.positionHasExisted(state, openTx.positionId),
5369             "openWithoutCounterpartyImpl#validate: positionId already exists"
5370         );
5371 
5372         require(
5373             openTx.principal > 0,
5374             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5375         );
5376 
5377         require(
5378             openTx.owedToken != address(0),
5379             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5380         );
5381 
5382         require(
5383             openTx.owedToken != openTx.heldToken,
5384             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5385         );
5386 
5387         require(
5388             openTx.positionOwner != address(0),
5389             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5390         );
5391 
5392         require(
5393             openTx.loanOwner != address(0),
5394             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5395         );
5396 
5397         require(
5398             openTx.maxDuration > 0,
5399             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5400         );
5401 
5402         require(
5403             openTx.interestPeriod <= openTx.maxDuration,
5404             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5405         );
5406     }
5407 
5408     function recordPositionOpened(
5409         Tx memory openTx
5410     )
5411         private
5412     {
5413         emit PositionOpened(
5414             openTx.positionId,
5415             msg.sender,
5416             msg.sender,
5417             bytes32(0),
5418             openTx.owedToken,
5419             openTx.heldToken,
5420             address(0),
5421             openTx.principal,
5422             0,
5423             openTx.deposit,
5424             openTx.interestRate,
5425             openTx.callTimeLimit,
5426             openTx.maxDuration,
5427             true
5428         );
5429     }
5430 
5431     // ============ Parsing Functions ============
5432 
5433     function parseTx(
5434         address[4] addresses,
5435         uint256[3] values256,
5436         uint32[4]  values32
5437     )
5438         private
5439         view
5440         returns (Tx memory)
5441     {
5442         Tx memory openTx = Tx({
5443             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5444             positionOwner: addresses[0],
5445             owedToken: addresses[1],
5446             heldToken: addresses[2],
5447             loanOwner: addresses[3],
5448             principal: values256[0],
5449             deposit: values256[1],
5450             callTimeLimit: values32[0],
5451             maxDuration: values32[1],
5452             interestRate: values32[2],
5453             interestPeriod: values32[3]
5454         });
5455 
5456         return openTx;
5457     }
5458 }
5459 
5460 // File: contracts/margin/impl/PositionGetters.sol
5461 
5462 /**
5463  * @title PositionGetters
5464  * @author dYdX
5465  *
5466  * A collection of public constant getter functions that allows reading of the state of any position
5467  * stored in the dYdX protocol.
5468  */
5469 contract PositionGetters is MarginStorage {
5470     using SafeMath for uint256;
5471 
5472     // ============ Public Constant Functions ============
5473 
5474     /**
5475      * Gets if a position is currently open.
5476      *
5477      * @param  positionId  Unique ID of the position
5478      * @return             True if the position is exists and is open
5479      */
5480     function containsPosition(
5481         bytes32 positionId
5482     )
5483         external
5484         view
5485         returns (bool)
5486     {
5487         return MarginCommon.containsPositionImpl(state, positionId);
5488     }
5489 
5490     /**
5491      * Gets if a position is currently margin-called.
5492      *
5493      * @param  positionId  Unique ID of the position
5494      * @return             True if the position is margin-called
5495      */
5496     function isPositionCalled(
5497         bytes32 positionId
5498     )
5499         external
5500         view
5501         returns (bool)
5502     {
5503         return (state.positions[positionId].callTimestamp > 0);
5504     }
5505 
5506     /**
5507      * Gets if a position was previously open and is now closed.
5508      *
5509      * @param  positionId  Unique ID of the position
5510      * @return             True if the position is now closed
5511      */
5512     function isPositionClosed(
5513         bytes32 positionId
5514     )
5515         external
5516         view
5517         returns (bool)
5518     {
5519         return state.closedPositions[positionId];
5520     }
5521 
5522     /**
5523      * Gets the total amount of owedToken ever repaid to the lender for a position.
5524      *
5525      * @param  positionId  Unique ID of the position
5526      * @return             Total amount of owedToken ever repaid
5527      */
5528     function getTotalOwedTokenRepaidToLender(
5529         bytes32 positionId
5530     )
5531         external
5532         view
5533         returns (uint256)
5534     {
5535         return state.totalOwedTokenRepaidToLender[positionId];
5536     }
5537 
5538     /**
5539      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5540      *
5541      * @param  positionId  Unique ID of the position
5542      * @return             The amount of heldToken
5543      */
5544     function getPositionBalance(
5545         bytes32 positionId
5546     )
5547         external
5548         view
5549         returns (uint256)
5550     {
5551         return MarginCommon.getPositionBalanceImpl(state, positionId);
5552     }
5553 
5554     /**
5555      * Gets the time until the interest fee charged for the position will increase.
5556      * Returns 1 if the interest fee increases every second.
5557      * Returns 0 if the interest fee will never increase again.
5558      *
5559      * @param  positionId  Unique ID of the position
5560      * @return             The number of seconds until the interest fee will increase
5561      */
5562     function getTimeUntilInterestIncrease(
5563         bytes32 positionId
5564     )
5565         external
5566         view
5567         returns (uint256)
5568     {
5569         MarginCommon.Position storage position =
5570             MarginCommon.getPositionFromStorage(state, positionId);
5571 
5572         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5573             position,
5574             block.timestamp
5575         );
5576 
5577         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5578         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5579             return 0;
5580         } else {
5581             // nextStep is the final second at which the calculated interest fee is the same as it
5582             // is currently, so add 1 to get the correct value
5583             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5584         }
5585     }
5586 
5587     /**
5588      * Gets the amount of owedTokens currently needed to close the position completely, including
5589      * interest fees.
5590      *
5591      * @param  positionId  Unique ID of the position
5592      * @return             The number of owedTokens
5593      */
5594     function getPositionOwedAmount(
5595         bytes32 positionId
5596     )
5597         external
5598         view
5599         returns (uint256)
5600     {
5601         MarginCommon.Position storage position =
5602             MarginCommon.getPositionFromStorage(state, positionId);
5603 
5604         return MarginCommon.calculateOwedAmount(
5605             position,
5606             position.principal,
5607             block.timestamp
5608         );
5609     }
5610 
5611     /**
5612      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5613      * given time, including interest fees.
5614      *
5615      * @param  positionId         Unique ID of the position
5616      * @param  principalToClose   Amount of principal being closed
5617      * @param  timestamp          Block timestamp in seconds of close
5618      * @return                    The number of owedTokens owed
5619      */
5620     function getPositionOwedAmountAtTime(
5621         bytes32 positionId,
5622         uint256 principalToClose,
5623         uint32  timestamp
5624     )
5625         external
5626         view
5627         returns (uint256)
5628     {
5629         MarginCommon.Position storage position =
5630             MarginCommon.getPositionFromStorage(state, positionId);
5631 
5632         require(
5633             timestamp >= position.startTimestamp,
5634             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5635         );
5636 
5637         return MarginCommon.calculateOwedAmount(
5638             position,
5639             principalToClose,
5640             timestamp
5641         );
5642     }
5643 
5644     /**
5645      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5646      * amount to the position at a given time.
5647      *
5648      * @param  positionId      Unique ID of the position
5649      * @param  principalToAdd  Amount being added to principal
5650      * @param  timestamp       Block timestamp in seconds of addition
5651      * @return                 The number of owedTokens that will be borrowed
5652      */
5653     function getLenderAmountForIncreasePositionAtTime(
5654         bytes32 positionId,
5655         uint256 principalToAdd,
5656         uint32  timestamp
5657     )
5658         external
5659         view
5660         returns (uint256)
5661     {
5662         MarginCommon.Position storage position =
5663             MarginCommon.getPositionFromStorage(state, positionId);
5664 
5665         require(
5666             timestamp >= position.startTimestamp,
5667             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5668         );
5669 
5670         return MarginCommon.calculateLenderAmountForIncreasePosition(
5671             position,
5672             principalToAdd,
5673             timestamp
5674         );
5675     }
5676 
5677     // ============ All Properties ============
5678 
5679     /**
5680      * Get a Position by id. This does not validate the position exists. If the position does not
5681      * exist, all 0's will be returned.
5682      *
5683      * @param  positionId  Unique ID of the position
5684      * @return             Addresses corresponding to:
5685      *
5686      *                     [0] = owedToken
5687      *                     [1] = heldToken
5688      *                     [2] = lender
5689      *                     [3] = owner
5690      *
5691      *                     Values corresponding to:
5692      *
5693      *                     [0] = principal
5694      *                     [1] = requiredDeposit
5695      *
5696      *                     Values corresponding to:
5697      *
5698      *                     [0] = callTimeLimit
5699      *                     [1] = startTimestamp
5700      *                     [2] = callTimestamp
5701      *                     [3] = maxDuration
5702      *                     [4] = interestRate
5703      *                     [5] = interestPeriod
5704      */
5705     function getPosition(
5706         bytes32 positionId
5707     )
5708         external
5709         view
5710         returns (
5711             address[4],
5712             uint256[2],
5713             uint32[6]
5714         )
5715     {
5716         MarginCommon.Position storage position = state.positions[positionId];
5717 
5718         return (
5719             [
5720                 position.owedToken,
5721                 position.heldToken,
5722                 position.lender,
5723                 position.owner
5724             ],
5725             [
5726                 position.principal,
5727                 position.requiredDeposit
5728             ],
5729             [
5730                 position.callTimeLimit,
5731                 position.startTimestamp,
5732                 position.callTimestamp,
5733                 position.maxDuration,
5734                 position.interestRate,
5735                 position.interestPeriod
5736             ]
5737         );
5738     }
5739 
5740     // ============ Individual Properties ============
5741 
5742     function getPositionLender(
5743         bytes32 positionId
5744     )
5745         external
5746         view
5747         returns (address)
5748     {
5749         return state.positions[positionId].lender;
5750     }
5751 
5752     function getPositionOwner(
5753         bytes32 positionId
5754     )
5755         external
5756         view
5757         returns (address)
5758     {
5759         return state.positions[positionId].owner;
5760     }
5761 
5762     function getPositionHeldToken(
5763         bytes32 positionId
5764     )
5765         external
5766         view
5767         returns (address)
5768     {
5769         return state.positions[positionId].heldToken;
5770     }
5771 
5772     function getPositionOwedToken(
5773         bytes32 positionId
5774     )
5775         external
5776         view
5777         returns (address)
5778     {
5779         return state.positions[positionId].owedToken;
5780     }
5781 
5782     function getPositionPrincipal(
5783         bytes32 positionId
5784     )
5785         external
5786         view
5787         returns (uint256)
5788     {
5789         return state.positions[positionId].principal;
5790     }
5791 
5792     function getPositionInterestRate(
5793         bytes32 positionId
5794     )
5795         external
5796         view
5797         returns (uint256)
5798     {
5799         return state.positions[positionId].interestRate;
5800     }
5801 
5802     function getPositionRequiredDeposit(
5803         bytes32 positionId
5804     )
5805         external
5806         view
5807         returns (uint256)
5808     {
5809         return state.positions[positionId].requiredDeposit;
5810     }
5811 
5812     function getPositionStartTimestamp(
5813         bytes32 positionId
5814     )
5815         external
5816         view
5817         returns (uint32)
5818     {
5819         return state.positions[positionId].startTimestamp;
5820     }
5821 
5822     function getPositionCallTimestamp(
5823         bytes32 positionId
5824     )
5825         external
5826         view
5827         returns (uint32)
5828     {
5829         return state.positions[positionId].callTimestamp;
5830     }
5831 
5832     function getPositionCallTimeLimit(
5833         bytes32 positionId
5834     )
5835         external
5836         view
5837         returns (uint32)
5838     {
5839         return state.positions[positionId].callTimeLimit;
5840     }
5841 
5842     function getPositionMaxDuration(
5843         bytes32 positionId
5844     )
5845         external
5846         view
5847         returns (uint32)
5848     {
5849         return state.positions[positionId].maxDuration;
5850     }
5851 
5852     function getPositioninterestPeriod(
5853         bytes32 positionId
5854     )
5855         external
5856         view
5857         returns (uint32)
5858     {
5859         return state.positions[positionId].interestPeriod;
5860     }
5861 }
5862 
5863 // File: contracts/margin/impl/TransferImpl.sol
5864 
5865 /**
5866  * @title TransferImpl
5867  * @author dYdX
5868  *
5869  * This library contains the implementation for the transferPosition and transferLoan functions of
5870  * Margin
5871  */
5872 library TransferImpl {
5873 
5874     // ============ Public Implementation Functions ============
5875 
5876     function transferLoanImpl(
5877         MarginState.State storage state,
5878         bytes32 positionId,
5879         address newLender
5880     )
5881         public
5882     {
5883         require(
5884             MarginCommon.containsPositionImpl(state, positionId),
5885             "TransferImpl#transferLoanImpl: Position does not exist"
5886         );
5887 
5888         address originalLender = state.positions[positionId].lender;
5889 
5890         require(
5891             msg.sender == originalLender,
5892             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
5893         );
5894         require(
5895             newLender != originalLender,
5896             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
5897         );
5898 
5899         // Doesn't change the state of positionId; figures out the final owner of loan.
5900         // That is, newLender may pass ownership to a different address.
5901         address finalLender = TransferInternal.grantLoanOwnership(
5902             positionId,
5903             originalLender,
5904             newLender);
5905 
5906         require(
5907             finalLender != originalLender,
5908             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
5909         );
5910 
5911         // Set state only after resolving the new owner (to reduce the number of storage calls)
5912         state.positions[positionId].lender = finalLender;
5913     }
5914 
5915     function transferPositionImpl(
5916         MarginState.State storage state,
5917         bytes32 positionId,
5918         address newOwner
5919     )
5920         public
5921     {
5922         require(
5923             MarginCommon.containsPositionImpl(state, positionId),
5924             "TransferImpl#transferPositionImpl: Position does not exist"
5925         );
5926 
5927         address originalOwner = state.positions[positionId].owner;
5928 
5929         require(
5930             msg.sender == originalOwner,
5931             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
5932         );
5933         require(
5934             newOwner != originalOwner,
5935             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
5936         );
5937 
5938         // Doesn't change the state of positionId; figures out the final owner of position.
5939         // That is, newOwner may pass ownership to a different address.
5940         address finalOwner = TransferInternal.grantPositionOwnership(
5941             positionId,
5942             originalOwner,
5943             newOwner);
5944 
5945         require(
5946             finalOwner != originalOwner,
5947             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
5948         );
5949 
5950         // Set state only after resolving the new owner (to reduce the number of storage calls)
5951         state.positions[positionId].owner = finalOwner;
5952     }
5953 }
5954 
5955 // File: contracts/margin/Margin.sol
5956 
5957 /**
5958  * @title Margin
5959  * @author dYdX
5960  *
5961  * This contract is used to facilitate margin trading as per the dYdX protocol
5962  */
5963 contract Margin is
5964     ReentrancyGuard,
5965     MarginStorage,
5966     MarginEvents,
5967     MarginAdmin,
5968     LoanGetters,
5969     PositionGetters
5970 {
5971 
5972     using SafeMath for uint256;
5973 
5974     // ============ Constructor ============
5975 
5976     constructor(
5977         address vault,
5978         address proxy
5979     )
5980         public
5981         MarginAdmin()
5982     {
5983         state = MarginState.State({
5984             VAULT: vault,
5985             TOKEN_PROXY: proxy
5986         });
5987     }
5988 
5989     // ============ Public State Changing Functions ============
5990 
5991     /**
5992      * Open a margin position. Called by the margin trader who must provide both a
5993      * signed loan offering as well as a DEX Order with which to sell the owedToken.
5994      *
5995      * @param  addresses           Addresses corresponding to:
5996      *
5997      *  [0]  = position owner
5998      *  [1]  = owedToken
5999      *  [2]  = heldToken
6000      *  [3]  = loan payer
6001      *  [4]  = loan owner
6002      *  [5]  = loan taker
6003      *  [6]  = loan position owner
6004      *  [7]  = loan fee recipient
6005      *  [8]  = loan lender fee token
6006      *  [9]  = loan taker fee token
6007      *  [10]  = exchange wrapper address
6008      *
6009      * @param  values256           Values corresponding to:
6010      *
6011      *  [0]  = loan maximum amount
6012      *  [1]  = loan minimum amount
6013      *  [2]  = loan minimum heldToken
6014      *  [3]  = loan lender fee
6015      *  [4]  = loan taker fee
6016      *  [5]  = loan expiration timestamp (in seconds)
6017      *  [6]  = loan salt
6018      *  [7]  = position amount of principal
6019      *  [8]  = deposit amount
6020      *  [9]  = nonce (used to calculate positionId)
6021      *
6022      * @param  values32            Values corresponding to:
6023      *
6024      *  [0] = loan call time limit (in seconds)
6025      *  [1] = loan maxDuration (in seconds)
6026      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6027      *  [3] = loan interest update period (in seconds)
6028      *
6029      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6030      *                             False if the margin deposit will be in owedToken
6031      *                             and then sold along with the owedToken borrowed from the lender
6032      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6033      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6034      *                             is a smart contract, these are arbitrary bytes that the contract
6035      *                             will recieve when choosing whether to approve the loan.
6036      * @param  order               Order object to be passed to the exchange wrapper
6037      * @return                     Unique ID for the new position
6038      */
6039     function openPosition(
6040         address[11] addresses,
6041         uint256[10] values256,
6042         uint32[4]   values32,
6043         bool        depositInHeldToken,
6044         bytes       signature,
6045         bytes       order
6046     )
6047         external
6048         onlyWhileOperational
6049         nonReentrant
6050         returns (bytes32)
6051     {
6052         return OpenPositionImpl.openPositionImpl(
6053             state,
6054             addresses,
6055             values256,
6056             values32,
6057             depositInHeldToken,
6058             signature,
6059             order
6060         );
6061     }
6062 
6063     /**
6064      * Open a margin position without a counterparty. The caller will serve as both the
6065      * lender and the position owner
6066      *
6067      * @param  addresses    Addresses corresponding to:
6068      *
6069      *  [0]  = position owner
6070      *  [1]  = owedToken
6071      *  [2]  = heldToken
6072      *  [3]  = loan owner
6073      *
6074      * @param  values256    Values corresponding to:
6075      *
6076      *  [0]  = principal
6077      *  [1]  = deposit amount
6078      *  [2]  = nonce (used to calculate positionId)
6079      *
6080      * @param  values32     Values corresponding to:
6081      *
6082      *  [0] = call time limit (in seconds)
6083      *  [1] = maxDuration (in seconds)
6084      *  [2] = interest rate (annual nominal percentage times 10**6)
6085      *  [3] = interest update period (in seconds)
6086      *
6087      * @return              Unique ID for the new position
6088      */
6089     function openWithoutCounterparty(
6090         address[4] addresses,
6091         uint256[3] values256,
6092         uint32[4]  values32
6093     )
6094         external
6095         onlyWhileOperational
6096         nonReentrant
6097         returns (bytes32)
6098     {
6099         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6100             state,
6101             addresses,
6102             values256,
6103             values32
6104         );
6105     }
6106 
6107     /**
6108      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6109      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6110      * principal added, as it will incorporate interest already earned by the position so far.
6111      *
6112      * @param  positionId          Unique ID of the position
6113      * @param  addresses           Addresses corresponding to:
6114      *
6115      *  [0]  = loan payer
6116      *  [1]  = loan taker
6117      *  [2]  = loan position owner
6118      *  [3]  = loan fee recipient
6119      *  [4]  = loan lender fee token
6120      *  [5]  = loan taker fee token
6121      *  [6]  = exchange wrapper address
6122      *
6123      * @param  values256           Values corresponding to:
6124      *
6125      *  [0]  = loan maximum amount
6126      *  [1]  = loan minimum amount
6127      *  [2]  = loan minimum heldToken
6128      *  [3]  = loan lender fee
6129      *  [4]  = loan taker fee
6130      *  [5]  = loan expiration timestamp (in seconds)
6131      *  [6]  = loan salt
6132      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6133      *                                                           will be >= this amount)
6134      *
6135      * @param  values32            Values corresponding to:
6136      *
6137      *  [0] = loan call time limit (in seconds)
6138      *  [1] = loan maxDuration (in seconds)
6139      *
6140      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6141      *                             False if the margin deposit will be pulled in owedToken
6142      *                             and then sold along with the owedToken borrowed from the lender
6143      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6144      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6145      *                             is a smart contract, these are arbitrary bytes that the contract
6146      *                             will recieve when choosing whether to approve the loan.
6147      * @param  order               Order object to be passed to the exchange wrapper
6148      * @return                     Amount of owedTokens pulled from the lender
6149      */
6150     function increasePosition(
6151         bytes32    positionId,
6152         address[7] addresses,
6153         uint256[8] values256,
6154         uint32[2]  values32,
6155         bool       depositInHeldToken,
6156         bytes      signature,
6157         bytes      order
6158     )
6159         external
6160         onlyWhileOperational
6161         nonReentrant
6162         returns (uint256)
6163     {
6164         return IncreasePositionImpl.increasePositionImpl(
6165             state,
6166             positionId,
6167             addresses,
6168             values256,
6169             values32,
6170             depositInHeldToken,
6171             signature,
6172             order
6173         );
6174     }
6175 
6176     /**
6177      * Increase a position directly by putting up heldToken. The caller will serve as both the
6178      * lender and the position owner
6179      *
6180      * @param  positionId      Unique ID of the position
6181      * @param  principalToAdd  Principal amount to add to the position
6182      * @return                 Amount of heldToken pulled from the msg.sender
6183      */
6184     function increaseWithoutCounterparty(
6185         bytes32 positionId,
6186         uint256 principalToAdd
6187     )
6188         external
6189         onlyWhileOperational
6190         nonReentrant
6191         returns (uint256)
6192     {
6193         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6194             state,
6195             positionId,
6196             principalToAdd
6197         );
6198     }
6199 
6200     /**
6201      * Close a position. May be called by the owner or with the approval of the owner. May provide
6202      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6203      * is sent the resulting payout.
6204      *
6205      * @param  positionId            Unique ID of the position
6206      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6207      *                               closed is also bounded by:
6208      *                               1) The principal of the position
6209      *                               2) The amount allowed by the owner if closer != owner
6210      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6211      * @param  exchangeWrapper       Address of the exchange wrapper
6212      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6213      *                               False to pay out the payoutRecipient in owedToken
6214      * @param  order                 Order object to be passed to the exchange wrapper
6215      * @return                       Values corresponding to:
6216      *                               1) Principal of position closed
6217      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6218      *                                  owedToken otherwise) received by the payoutRecipient
6219      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6220      */
6221     function closePosition(
6222         bytes32 positionId,
6223         uint256 requestedCloseAmount,
6224         address payoutRecipient,
6225         address exchangeWrapper,
6226         bool    payoutInHeldToken,
6227         bytes   order
6228     )
6229         external
6230         closePositionStateControl
6231         nonReentrant
6232         returns (uint256, uint256, uint256)
6233     {
6234         return ClosePositionImpl.closePositionImpl(
6235             state,
6236             positionId,
6237             requestedCloseAmount,
6238             payoutRecipient,
6239             exchangeWrapper,
6240             payoutInHeldToken,
6241             order
6242         );
6243     }
6244 
6245     /**
6246      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6247      *
6248      * @param  positionId            Unique ID of the position
6249      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6250      *                               closed is also bounded by:
6251      *                               1) The principal of the position
6252      *                               2) The amount allowed by the owner if closer != owner
6253      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6254      * @return                       Values corresponding to:
6255      *                               1) Principal amount of position closed
6256      *                               2) Amount of heldToken received by the payoutRecipient
6257      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6258      */
6259     function closePositionDirectly(
6260         bytes32 positionId,
6261         uint256 requestedCloseAmount,
6262         address payoutRecipient
6263     )
6264         external
6265         closePositionDirectlyStateControl
6266         nonReentrant
6267         returns (uint256, uint256, uint256)
6268     {
6269         return ClosePositionImpl.closePositionImpl(
6270             state,
6271             positionId,
6272             requestedCloseAmount,
6273             payoutRecipient,
6274             address(0),
6275             true,
6276             new bytes(0)
6277         );
6278     }
6279 
6280     /**
6281      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6282      * Must be approved by both the position owner and lender.
6283      *
6284      * @param  positionId            Unique ID of the position
6285      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6286      *                               closed is also bounded by:
6287      *                               1) The principal of the position
6288      *                               2) The amount allowed by the owner if closer != owner
6289      *                               3) The amount allowed by the lender if closer != lender
6290      * @return                       Values corresponding to:
6291      *                               1) Principal amount of position closed
6292      *                               2) Amount of heldToken received by the msg.sender
6293      */
6294     function closeWithoutCounterparty(
6295         bytes32 positionId,
6296         uint256 requestedCloseAmount,
6297         address payoutRecipient
6298     )
6299         external
6300         closePositionStateControl
6301         nonReentrant
6302         returns (uint256, uint256)
6303     {
6304         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6305             state,
6306             positionId,
6307             requestedCloseAmount,
6308             payoutRecipient
6309         );
6310     }
6311 
6312     /**
6313      * Margin-call a position. Only callable with the approval of the position lender. After the
6314      * call, the position owner will have time equal to the callTimeLimit of the position to close
6315      * the position. If the owner does not close the position, the lender can recover the collateral
6316      * in the position.
6317      *
6318      * @param  positionId       Unique ID of the position
6319      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6320      *                          the margin-call. Passing in 0 means the margin call cannot be
6321      *                          canceled by depositing
6322      */
6323     function marginCall(
6324         bytes32 positionId,
6325         uint256 requiredDeposit
6326     )
6327         external
6328         nonReentrant
6329     {
6330         LoanImpl.marginCallImpl(
6331             state,
6332             positionId,
6333             requiredDeposit
6334         );
6335     }
6336 
6337     /**
6338      * Cancel a margin-call. Only callable with the approval of the position lender.
6339      *
6340      * @param  positionId  Unique ID of the position
6341      */
6342     function cancelMarginCall(
6343         bytes32 positionId
6344     )
6345         external
6346         onlyWhileOperational
6347         nonReentrant
6348     {
6349         LoanImpl.cancelMarginCallImpl(state, positionId);
6350     }
6351 
6352     /**
6353      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6354      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6355      * but remains unclosed. Only callable with the approval of the position lender.
6356      *
6357      * @param  positionId  Unique ID of the position
6358      * @param  recipient   Address to send the recovered tokens to
6359      * @return             Amount of heldToken recovered
6360      */
6361     function forceRecoverCollateral(
6362         bytes32 positionId,
6363         address recipient
6364     )
6365         external
6366         nonReentrant
6367         returns (uint256)
6368     {
6369         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6370             state,
6371             positionId,
6372             recipient
6373         );
6374     }
6375 
6376     /**
6377      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6378      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6379      *
6380      * @param  positionId       Unique ID of the position
6381      * @param  depositAmount    Additional amount in heldToken to deposit
6382      */
6383     function depositCollateral(
6384         bytes32 positionId,
6385         uint256 depositAmount
6386     )
6387         external
6388         onlyWhileOperational
6389         nonReentrant
6390     {
6391         DepositCollateralImpl.depositCollateralImpl(
6392             state,
6393             positionId,
6394             depositAmount
6395         );
6396     }
6397 
6398     /**
6399      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6400      *
6401      * @param  addresses     Array of addresses:
6402      *
6403      *  [0] = owedToken
6404      *  [1] = heldToken
6405      *  [2] = loan payer
6406      *  [3] = loan owner
6407      *  [4] = loan taker
6408      *  [5] = loan position owner
6409      *  [6] = loan fee recipient
6410      *  [7] = loan lender fee token
6411      *  [8] = loan taker fee token
6412      *
6413      * @param  values256     Values corresponding to:
6414      *
6415      *  [0] = loan maximum amount
6416      *  [1] = loan minimum amount
6417      *  [2] = loan minimum heldToken
6418      *  [3] = loan lender fee
6419      *  [4] = loan taker fee
6420      *  [5] = loan expiration timestamp (in seconds)
6421      *  [6] = loan salt
6422      *
6423      * @param  values32      Values corresponding to:
6424      *
6425      *  [0] = loan call time limit (in seconds)
6426      *  [1] = loan maxDuration (in seconds)
6427      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6428      *  [3] = loan interest update period (in seconds)
6429      *
6430      * @param  cancelAmount  Amount to cancel
6431      * @return               Amount that was canceled
6432      */
6433     function cancelLoanOffering(
6434         address[9] addresses,
6435         uint256[7]  values256,
6436         uint32[4]   values32,
6437         uint256     cancelAmount
6438     )
6439         external
6440         cancelLoanOfferingStateControl
6441         nonReentrant
6442         returns (uint256)
6443     {
6444         return LoanImpl.cancelLoanOfferingImpl(
6445             state,
6446             addresses,
6447             values256,
6448             values32,
6449             cancelAmount
6450         );
6451     }
6452 
6453     /**
6454      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6455      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6456      * must implement the LoanOwner interface.
6457      *
6458      * @param  positionId  Unique ID of the position
6459      * @param  who         New owner of the loan
6460      */
6461     function transferLoan(
6462         bytes32 positionId,
6463         address who
6464     )
6465         external
6466         nonReentrant
6467     {
6468         TransferImpl.transferLoanImpl(
6469             state,
6470             positionId,
6471             who);
6472     }
6473 
6474     /**
6475      * Transfer ownership of a position to a new address. This new address will be entitled to all
6476      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6477      * the PositionOwner interface.
6478      *
6479      * @param  positionId  Unique ID of the position
6480      * @param  who         New owner of the position
6481      */
6482     function transferPosition(
6483         bytes32 positionId,
6484         address who
6485     )
6486         external
6487         nonReentrant
6488     {
6489         TransferImpl.transferPositionImpl(
6490             state,
6491             positionId,
6492             who);
6493     }
6494 
6495     // ============ Public Constant Functions ============
6496 
6497     /**
6498      * Gets the address of the Vault contract that holds and accounts for tokens.
6499      *
6500      * @return  The address of the Vault contract
6501      */
6502     function getVaultAddress()
6503         external
6504         view
6505         returns (address)
6506     {
6507         return state.VAULT;
6508     }
6509 
6510     /**
6511      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6512      * make loans or open/close positions.
6513      *
6514      * @return  The address of the TokenProxy contract
6515      */
6516     function getTokenProxyAddress()
6517         external
6518         view
6519         returns (address)
6520     {
6521         return state.TOKEN_PROXY;
6522     }
6523 }
6524 
6525 // File: contracts/margin/interfaces/OnlyMargin.sol
6526 
6527 /**
6528  * @title OnlyMargin
6529  * @author dYdX
6530  *
6531  * Contract to store the address of the main Margin contract and trust only that address to call
6532  * certain functions.
6533  */
6534 contract OnlyMargin {
6535 
6536     // ============ Constants ============
6537 
6538     // Address of the known and trusted Margin contract on the blockchain
6539     address public DYDX_MARGIN;
6540 
6541     // ============ Constructor ============
6542 
6543     constructor(
6544         address margin
6545     )
6546         public
6547     {
6548         DYDX_MARGIN = margin;
6549     }
6550 
6551     // ============ Modifiers ============
6552 
6553     modifier onlyMargin()
6554     {
6555         require(
6556             msg.sender == DYDX_MARGIN,
6557             "OnlyMargin#onlyMargin: Only Margin can call"
6558         );
6559 
6560         _;
6561     }
6562 }
6563 
6564 // File: contracts/margin/external/lib/LoanOfferingParser.sol
6565 
6566 /**
6567  * @title LoanOfferingParser
6568  * @author dYdX
6569  *
6570  * Contract for LoanOfferingVerifiers to parse arguments
6571  */
6572 contract LoanOfferingParser {
6573 
6574     // ============ Parsing Functions ============
6575 
6576     function parseLoanOffering(
6577         address[9] addresses,
6578         uint256[7] values256,
6579         uint32[4] values32,
6580         bytes signature
6581     )
6582         internal
6583         pure
6584         returns (MarginCommon.LoanOffering memory)
6585     {
6586         MarginCommon.LoanOffering memory loanOffering;
6587 
6588         fillLoanOfferingAddresses(loanOffering, addresses);
6589         fillLoanOfferingValues256(loanOffering, values256);
6590         fillLoanOfferingValues32(loanOffering, values32);
6591         loanOffering.signature = signature;
6592 
6593         return loanOffering;
6594     }
6595 
6596     function fillLoanOfferingAddresses(
6597         MarginCommon.LoanOffering memory loanOffering,
6598         address[9] addresses
6599     )
6600         private
6601         pure
6602     {
6603         loanOffering.owedToken = addresses[0];
6604         loanOffering.heldToken = addresses[1];
6605         loanOffering.payer = addresses[2];
6606         loanOffering.owner = addresses[3];
6607         loanOffering.taker = addresses[4];
6608         loanOffering.positionOwner = addresses[5];
6609         loanOffering.feeRecipient = addresses[6];
6610         loanOffering.lenderFeeToken = addresses[7];
6611         loanOffering.takerFeeToken = addresses[8];
6612     }
6613 
6614     function fillLoanOfferingValues256(
6615         MarginCommon.LoanOffering memory loanOffering,
6616         uint256[7] values256
6617     )
6618         private
6619         pure
6620     {
6621         loanOffering.rates.maxAmount = values256[0];
6622         loanOffering.rates.minAmount = values256[1];
6623         loanOffering.rates.minHeldToken = values256[2];
6624         loanOffering.rates.lenderFee = values256[3];
6625         loanOffering.rates.takerFee = values256[4];
6626         loanOffering.expirationTimestamp = values256[5];
6627         loanOffering.salt = values256[6];
6628     }
6629 
6630     function fillLoanOfferingValues32(
6631         MarginCommon.LoanOffering memory loanOffering,
6632         uint32[4] values32
6633     )
6634         private
6635         pure
6636     {
6637         loanOffering.callTimeLimit = values32[0];
6638         loanOffering.maxDuration = values32[1];
6639         loanOffering.rates.interestRate = values32[2];
6640         loanOffering.rates.interestPeriod = values32[3];
6641     }
6642 }
6643 
6644 // File: contracts/margin/external/lib/MarginHelper.sol
6645 
6646 /**
6647  * @title MarginHelper
6648  * @author dYdX
6649  *
6650  * This library contains helper functions for interacting with Margin
6651  */
6652 library MarginHelper {
6653     function getPosition(
6654         address DYDX_MARGIN,
6655         bytes32 positionId
6656     )
6657         internal
6658         view
6659         returns (MarginCommon.Position memory)
6660     {
6661         (
6662             address[4] memory addresses,
6663             uint256[2] memory values256,
6664             uint32[6]  memory values32
6665         ) = Margin(DYDX_MARGIN).getPosition(positionId);
6666 
6667         return MarginCommon.Position({
6668             owedToken: addresses[0],
6669             heldToken: addresses[1],
6670             lender: addresses[2],
6671             owner: addresses[3],
6672             principal: values256[0],
6673             requiredDeposit: values256[1],
6674             callTimeLimit: values32[0],
6675             startTimestamp: values32[1],
6676             callTimestamp: values32[2],
6677             maxDuration: values32[3],
6678             interestRate: values32[4],
6679             interestPeriod: values32[5]
6680         });
6681     }
6682 }
6683 
6684 // File: contracts/margin/external/BucketLender/BucketLender.sol
6685 
6686 /* solium-disable-next-line max-len*/
6687 
6688 /**
6689  * @title BucketLender
6690  * @author dYdX
6691  *
6692  * On-chain shared lender that allows anyone to deposit tokens into this contract to be used to
6693  * lend tokens for a particular margin position.
6694  *
6695  * - Each bucket has three variables:
6696  *   - Available Amount
6697  *     - The available amount of tokens that the bucket has to lend out
6698  *   - Outstanding Principal
6699  *     - The amount of principal that the bucket is responsible for in the margin position
6700  *   - Weight
6701  *     - Used to keep track of each account's weighted ownership within a bucket
6702  *     - Relative weight between buckets is meaningless
6703  *     - Only accounts' relative weight within a bucket matters
6704  *
6705  * - Token Deposits:
6706  *   - Go into a particular bucket, determined by time since the start of the position
6707  *     - If the position has not started: bucket = 0
6708  *     - If the position has started:     bucket = ceiling(time_since_start / BUCKET_TIME)
6709  *     - This is always the highest bucket; no higher bucket yet exists
6710  *   - Increase the bucket's Available Amount
6711  *   - Increase the bucket's weight and the account's weight in that bucket
6712  *
6713  * - Token Withdrawals:
6714  *   - Can be from any bucket with available amount
6715  *   - Decrease the bucket's Available Amount
6716  *   - Decrease the bucket's weight and the account's weight in that bucket
6717  *
6718  * - Increasing the Position (Lending):
6719  *   - The lowest buckets with Available Amount are used first
6720  *   - Decreases Available Amount
6721  *   - Increases Outstanding Principal
6722  *
6723  * - Decreasing the Position (Being Paid-Back)
6724  *   - The highest buckets with Outstanding Principal are paid back first
6725  *   - Decreases Outstanding Principal
6726  *   - Increases Available Amount
6727  *
6728  *
6729  * - Over time, this gives highest interest rates to earlier buckets, but disallows withdrawals from
6730  *   those buckets for a longer period of time.
6731  * - Deposits in the same bucket earn the same interest rate.
6732  * - Lenders can withdraw their funds at any time if they are not being lent (and are therefore not
6733  *   making the maximum interest).
6734  * - The highest bucket with Outstanding Principal is always less-than-or-equal-to the lowest bucket
6735      with Available Amount
6736  */
6737 contract BucketLender is
6738     Ownable,
6739     OnlyMargin,
6740     LoanOwner,
6741     IncreaseLoanDelegator,
6742     MarginCallDelegator,
6743     CancelMarginCallDelegator,
6744     ForceRecoverCollateralDelegator,
6745     LoanOfferingParser,
6746     LoanOfferingVerifier,
6747     ReentrancyGuard
6748 {
6749     using SafeMath for uint256;
6750     using TokenInteract for address;
6751 
6752     // ============ Events ============
6753 
6754     event Deposit(
6755         address indexed beneficiary,
6756         uint256 bucket,
6757         uint256 amount,
6758         uint256 weight
6759     );
6760 
6761     event Withdraw(
6762         address indexed withdrawer,
6763         uint256 bucket,
6764         uint256 weight,
6765         uint256 owedTokenWithdrawn,
6766         uint256 heldTokenWithdrawn
6767     );
6768 
6769     event PrincipalIncreased(
6770         uint256 principalTotal,
6771         uint256 bucketNumber,
6772         uint256 principalForBucket,
6773         uint256 amount
6774     );
6775 
6776     event PrincipalDecreased(
6777         uint256 principalTotal,
6778         uint256 bucketNumber,
6779         uint256 principalForBucket,
6780         uint256 amount
6781     );
6782 
6783     event AvailableIncreased(
6784         uint256 availableTotal,
6785         uint256 bucketNumber,
6786         uint256 availableForBucket,
6787         uint256 amount
6788     );
6789 
6790     event AvailableDecreased(
6791         uint256 availableTotal,
6792         uint256 bucketNumber,
6793         uint256 availableForBucket,
6794         uint256 amount
6795     );
6796 
6797     // ============ State Variables ============
6798 
6799     /**
6800      * Available Amount is the amount of tokens that is available to be lent by each bucket.
6801      * These tokens are also available to be withdrawn by the accounts that have weight in the
6802      * bucket.
6803      */
6804     // Available Amount for each bucket
6805     mapping(uint256 => uint256) public availableForBucket;
6806 
6807     // Total Available Amount
6808     uint256 public availableTotal;
6809 
6810     /**
6811      * Outstanding Principal is the share of the margin position's principal that each bucket
6812      * is responsible for. That is, each bucket with Outstanding Principal is owed
6813      * (Outstanding Principal)*E^(RT) owedTokens in repayment.
6814      */
6815     // Outstanding Principal for each bucket
6816     mapping(uint256 => uint256) public principalForBucket;
6817 
6818     // Total Outstanding Principal
6819     uint256 public principalTotal;
6820 
6821     /**
6822      * Weight determines an account's proportional share of a bucket. Relative weights have no
6823      * meaning if they are not for the same bucket. Likewise, the relative weight of two buckets has
6824      * no meaning. However, the relative weight of two accounts within the same bucket is equal to
6825      * the accounts' shares in the bucket and are therefore proportional to the payout that they
6826      * should expect from withdrawing from that bucket.
6827      */
6828     // Weight for each account in each bucket
6829     mapping(uint256 => mapping(address => uint256)) public weightForBucketForAccount;
6830 
6831     // Total Weight for each bucket
6832     mapping(uint256 => uint256) public weightForBucket;
6833 
6834     /**
6835      * The critical bucket is:
6836      * - Greater-than-or-equal-to The highest bucket with Outstanding Principal
6837      * - Less-than-or-equal-to the lowest bucket with Available Amount
6838      *
6839      * It is equal to both of these values in most cases except in an edge cases where the two
6840      * buckets are different. This value is cached to find such a bucket faster than looping through
6841      * all possible buckets.
6842      */
6843     uint256 public criticalBucket = 0;
6844 
6845     /**
6846      * Latest cached value for totalOwedTokenRepaidToLender.
6847      * This number updates on the dYdX Margin base protocol whenever the position is
6848      * partially-closed, but this contract is not notified at that time. Therefore, it is updated
6849      * upon increasing the position or when depositing/withdrawing
6850      */
6851     uint256 public cachedRepaidAmount = 0;
6852 
6853     // True if the position was closed from force-recovering the collateral
6854     bool public wasForceClosed = false;
6855 
6856     // ============ Constants ============
6857 
6858     // Unique ID of the position
6859     bytes32 public POSITION_ID;
6860 
6861     // Address of the token held in the position as collateral
6862     address public HELD_TOKEN;
6863 
6864     // Address of the token being lent
6865     address public OWED_TOKEN;
6866 
6867     // Time between new buckets
6868     uint32 public BUCKET_TIME;
6869 
6870     // Interest rate of the position
6871     uint32 public INTEREST_RATE;
6872 
6873     // Interest period of the position
6874     uint32 public INTEREST_PERIOD;
6875 
6876     // Maximum duration of the position
6877     uint32 public MAX_DURATION;
6878 
6879     // Margin-call time-limit of the position
6880     uint32 public CALL_TIMELIMIT;
6881 
6882     // (NUMERATOR/DENOMINATOR) denotes the minimum collateralization ratio of the position
6883     uint32 public MIN_HELD_TOKEN_NUMERATOR;
6884     uint32 public MIN_HELD_TOKEN_DENOMINATOR;
6885 
6886     // Accounts that are permitted to margin-call positions (or cancel the margin call)
6887     mapping(address => bool) public TRUSTED_MARGIN_CALLERS;
6888 
6889     // Accounts that are permitted to withdraw on behalf of any address
6890     mapping(address => bool) public TRUSTED_WITHDRAWERS;
6891 
6892     // ============ Constructor ============
6893 
6894     constructor(
6895         address margin,
6896         bytes32 positionId,
6897         address heldToken,
6898         address owedToken,
6899         uint32[7] parameters,
6900         address[] trustedMarginCallers,
6901         address[] trustedWithdrawers
6902     )
6903         public
6904         OnlyMargin(margin)
6905     {
6906         POSITION_ID = positionId;
6907         HELD_TOKEN = heldToken;
6908         OWED_TOKEN = owedToken;
6909 
6910         require(
6911             parameters[0] != 0,
6912             "BucketLender#constructor: BUCKET_TIME cannot be zero"
6913         );
6914         BUCKET_TIME = parameters[0];
6915         INTEREST_RATE = parameters[1];
6916         INTEREST_PERIOD = parameters[2];
6917         MAX_DURATION = parameters[3];
6918         CALL_TIMELIMIT = parameters[4];
6919         MIN_HELD_TOKEN_NUMERATOR = parameters[5];
6920         MIN_HELD_TOKEN_DENOMINATOR = parameters[6];
6921 
6922         // Initialize TRUSTED_MARGIN_CALLERS and TRUSTED_WITHDRAWERS
6923         uint256 i = 0;
6924         for (i = 0; i < trustedMarginCallers.length; i++) {
6925             TRUSTED_MARGIN_CALLERS[trustedMarginCallers[i]] = true;
6926         }
6927         for (i = 0; i < trustedWithdrawers.length; i++) {
6928             TRUSTED_WITHDRAWERS[trustedWithdrawers[i]] = true;
6929         }
6930 
6931         // Set maximum allowance on proxy
6932         OWED_TOKEN.approve(
6933             Margin(margin).getTokenProxyAddress(),
6934             MathHelpers.maxUint256()
6935         );
6936     }
6937 
6938     // ============ Modifiers ============
6939 
6940     modifier onlyPosition(bytes32 positionId) {
6941         require(
6942             POSITION_ID == positionId,
6943             "BucketLender#onlyPosition: Incorrect position"
6944         );
6945         _;
6946     }
6947 
6948     // ============ Margin-Only State-Changing Functions ============
6949 
6950     /**
6951      * Function a smart contract must implement to be able to consent to a loan. The loan offering
6952      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
6953      * position.
6954      *
6955      * @param  addresses    Loan offering addresses
6956      * @param  values256    Loan offering uint256s
6957      * @param  values32     Loan offering uint32s
6958      * @param  positionId   Unique ID of the position
6959      * @param  signature    Arbitrary bytes
6960      * @return              This address to accept, a different address to ask that contract
6961      */
6962     function verifyLoanOffering(
6963         address[9] addresses,
6964         uint256[7] values256,
6965         uint32[4] values32,
6966         bytes32 positionId,
6967         bytes signature
6968     )
6969         external
6970         onlyMargin
6971         nonReentrant
6972         onlyPosition(positionId)
6973         returns (address)
6974     {
6975         require(
6976             Margin(DYDX_MARGIN).containsPosition(POSITION_ID),
6977             "BucketLender#verifyLoanOffering: This contract should not open a new position"
6978         );
6979 
6980         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
6981             addresses,
6982             values256,
6983             values32,
6984             signature
6985         );
6986 
6987         // CHECK ADDRESSES
6988         assert(loanOffering.owedToken == OWED_TOKEN);
6989         assert(loanOffering.heldToken == HELD_TOKEN);
6990         assert(loanOffering.payer == address(this));
6991         assert(loanOffering.owner == address(this));
6992         require(
6993             loanOffering.taker == address(0),
6994             "BucketLender#verifyLoanOffering: loanOffering.taker is non-zero"
6995         );
6996         require(
6997             loanOffering.feeRecipient == address(0),
6998             "BucketLender#verifyLoanOffering: loanOffering.feeRecipient is non-zero"
6999         );
7000         require(
7001             loanOffering.positionOwner == address(0),
7002             "BucketLender#verifyLoanOffering: loanOffering.positionOwner is non-zero"
7003         );
7004         require(
7005             loanOffering.lenderFeeToken == address(0),
7006             "BucketLender#verifyLoanOffering: loanOffering.lenderFeeToken is non-zero"
7007         );
7008         require(
7009             loanOffering.takerFeeToken == address(0),
7010             "BucketLender#verifyLoanOffering: loanOffering.takerFeeToken is non-zero"
7011         );
7012 
7013         // CHECK VALUES256
7014         require(
7015             loanOffering.rates.maxAmount == MathHelpers.maxUint256(),
7016             "BucketLender#verifyLoanOffering: loanOffering.maxAmount is incorrect"
7017         );
7018         require(
7019             loanOffering.rates.minAmount == 0,
7020             "BucketLender#verifyLoanOffering: loanOffering.minAmount is non-zero"
7021         );
7022         require(
7023             loanOffering.rates.minHeldToken == 0,
7024             "BucketLender#verifyLoanOffering: loanOffering.minHeldToken is non-zero"
7025         );
7026         require(
7027             loanOffering.rates.lenderFee == 0,
7028             "BucketLender#verifyLoanOffering: loanOffering.lenderFee is non-zero"
7029         );
7030         require(
7031             loanOffering.rates.takerFee == 0,
7032             "BucketLender#verifyLoanOffering: loanOffering.takerFee is non-zero"
7033         );
7034         require(
7035             loanOffering.expirationTimestamp == MathHelpers.maxUint256(),
7036             "BucketLender#verifyLoanOffering: expirationTimestamp is incorrect"
7037         );
7038         require(
7039             loanOffering.salt == 0,
7040             "BucketLender#verifyLoanOffering: loanOffering.salt is non-zero"
7041         );
7042 
7043         // CHECK VALUES32
7044         require(
7045             loanOffering.callTimeLimit == MathHelpers.maxUint32(),
7046             "BucketLender#verifyLoanOffering: loanOffering.callTimelimit is incorrect"
7047         );
7048         require(
7049             loanOffering.maxDuration == MathHelpers.maxUint32(),
7050             "BucketLender#verifyLoanOffering: loanOffering.maxDuration is incorrect"
7051         );
7052         assert(loanOffering.rates.interestRate == INTEREST_RATE);
7053         assert(loanOffering.rates.interestPeriod == INTEREST_PERIOD);
7054 
7055         // no need to require anything about loanOffering.signature
7056 
7057         return address(this);
7058     }
7059 
7060     /**
7061      * Called by the Margin contract when anyone transfers ownership of a loan to this contract.
7062      * This function initializes this contract and returns this address to indicate to Margin
7063      * that it is willing to take ownership of the loan.
7064      *
7065      * @param  from        Address of the previous owner
7066      * @param  positionId  Unique ID of the position
7067      * @return             This address on success, throw otherwise
7068      */
7069     function receiveLoanOwnership(
7070         address from,
7071         bytes32 positionId
7072     )
7073         external
7074         onlyMargin
7075         nonReentrant
7076         onlyPosition(positionId)
7077         returns (address)
7078     {
7079         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
7080         uint256 initialPrincipal = position.principal;
7081         uint256 minHeldToken = MathHelpers.getPartialAmount(
7082             uint256(MIN_HELD_TOKEN_NUMERATOR),
7083             uint256(MIN_HELD_TOKEN_DENOMINATOR),
7084             initialPrincipal
7085         );
7086 
7087         assert(initialPrincipal > 0);
7088         assert(principalTotal == 0);
7089         assert(from != address(this)); // position must be opened without lending from this position
7090 
7091         require(
7092             position.owedToken == OWED_TOKEN,
7093             "BucketLender#receiveLoanOwnership: Position owedToken mismatch"
7094         );
7095         require(
7096             position.heldToken == HELD_TOKEN,
7097             "BucketLender#receiveLoanOwnership: Position heldToken mismatch"
7098         );
7099         require(
7100             position.maxDuration == MAX_DURATION,
7101             "BucketLender#receiveLoanOwnership: Position maxDuration mismatch"
7102         );
7103         require(
7104             position.callTimeLimit == CALL_TIMELIMIT,
7105             "BucketLender#receiveLoanOwnership: Position callTimeLimit mismatch"
7106         );
7107         require(
7108             position.interestRate == INTEREST_RATE,
7109             "BucketLender#receiveLoanOwnership: Position interestRate mismatch"
7110         );
7111         require(
7112             position.interestPeriod == INTEREST_PERIOD,
7113             "BucketLender#receiveLoanOwnership: Position interestPeriod mismatch"
7114         );
7115         require(
7116             Margin(DYDX_MARGIN).getPositionBalance(POSITION_ID) >= minHeldToken,
7117             "BucketLender#receiveLoanOwnership: Not enough heldToken as collateral"
7118         );
7119 
7120         // set relevant constants
7121         principalForBucket[0] = initialPrincipal;
7122         principalTotal = initialPrincipal;
7123         weightForBucket[0] = weightForBucket[0].add(initialPrincipal);
7124         weightForBucketForAccount[0][from] =
7125             weightForBucketForAccount[0][from].add(initialPrincipal);
7126 
7127         return address(this);
7128     }
7129 
7130     /**
7131      * Called by Margin when additional value is added onto the position this contract
7132      * is lending for. Balance is added to the address that loaned the additional tokens.
7133      *
7134      * @param  payer           Address that loaned the additional tokens
7135      * @param  positionId      Unique ID of the position
7136      * @param  principalAdded  Amount that was added to the position
7137      * @param  lentAmount      Amount of owedToken lent
7138      * @return                 This address to accept, a different address to ask that contract
7139      */
7140     function increaseLoanOnBehalfOf(
7141         address payer,
7142         bytes32 positionId,
7143         uint256 principalAdded,
7144         uint256 lentAmount
7145     )
7146         external
7147         onlyMargin
7148         nonReentrant
7149         onlyPosition(positionId)
7150         returns (address)
7151     {
7152         Margin margin = Margin(DYDX_MARGIN);
7153 
7154         require(
7155             payer == address(this),
7156             "BucketLender#increaseLoanOnBehalfOf: Other lenders cannot lend for this position"
7157         );
7158         require(
7159             !margin.isPositionCalled(POSITION_ID),
7160             "BucketLender#increaseLoanOnBehalfOf: No lending while the position is margin-called"
7161         );
7162 
7163         // This function is only called after the state has been updated in the base protocol;
7164         // thus, the principal in the base protocol will equal the principal after the increase
7165         uint256 principalAfterIncrease = margin.getPositionPrincipal(POSITION_ID);
7166         uint256 principalBeforeIncrease = principalAfterIncrease.sub(principalAdded);
7167 
7168         // principalTotal was the principal after the previous increase
7169         accountForClose(principalTotal.sub(principalBeforeIncrease));
7170 
7171         accountForIncrease(principalAdded, lentAmount);
7172 
7173         assert(principalTotal == principalAfterIncrease);
7174 
7175         return address(this);
7176     }
7177 
7178     /**
7179      * Function a contract must implement in order to let other addresses call marginCall().
7180      *
7181      * @param  caller         Address of the caller of the marginCall function
7182      * @param  positionId     Unique ID of the position
7183      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
7184      * @return                This address to accept, a different address to ask that contract
7185      */
7186     function marginCallOnBehalfOf(
7187         address caller,
7188         bytes32 positionId,
7189         uint256 depositAmount
7190     )
7191         external
7192         onlyMargin
7193         nonReentrant
7194         onlyPosition(positionId)
7195         returns (address)
7196     {
7197         require(
7198             TRUSTED_MARGIN_CALLERS[caller],
7199             "BucketLender#marginCallOnBehalfOf: Margin-caller must be trusted"
7200         );
7201         require(
7202             depositAmount == 0, // prevents depositing from canceling the margin-call
7203             "BucketLender#marginCallOnBehalfOf: Deposit amount must be zero"
7204         );
7205 
7206         return address(this);
7207     }
7208 
7209     /**
7210      * Function a contract must implement in order to let other addresses call cancelMarginCall().
7211      *
7212      * @param  canceler    Address of the caller of the cancelMarginCall function
7213      * @param  positionId  Unique ID of the position
7214      * @return             This address to accept, a different address to ask that contract
7215      */
7216     function cancelMarginCallOnBehalfOf(
7217         address canceler,
7218         bytes32 positionId
7219     )
7220         external
7221         onlyMargin
7222         nonReentrant
7223         onlyPosition(positionId)
7224         returns (address)
7225     {
7226         require(
7227             TRUSTED_MARGIN_CALLERS[canceler],
7228             "BucketLender#cancelMarginCallOnBehalfOf: Margin-call-canceler must be trusted"
7229         );
7230 
7231         return address(this);
7232     }
7233 
7234     /**
7235      * Function a contract must implement in order to let other addresses call
7236      * forceRecoverCollateral().
7237      *
7238      *  param  recoverer   Address of the caller of the forceRecoverCollateral() function
7239      * @param  positionId  Unique ID of the position
7240      * @param  recipient   Address to send the recovered tokens to
7241      * @return             This address to accept, a different address to ask that contract
7242      */
7243     function forceRecoverCollateralOnBehalfOf(
7244         address /* recoverer */,
7245         bytes32 positionId,
7246         address recipient
7247     )
7248         external
7249         onlyMargin
7250         nonReentrant
7251         onlyPosition(positionId)
7252         returns (address)
7253     {
7254         return forceRecoverCollateralInternal(recipient);
7255     }
7256 
7257     // ============ Public State-Changing Functions ============
7258 
7259     /**
7260      * Allow anyone to recalculate the Outstanding Principal and Available Amount for the buckets if
7261      * part of the position has been closed since the last position increase.
7262      */
7263     function rebalanceBuckets()
7264         external
7265         nonReentrant
7266     {
7267         rebalanceBucketsInternal();
7268     }
7269 
7270     /**
7271      * Allows users to deposit owedToken into this contract. Allowance must be set on this contract
7272      * for "token" in at least the amount "amount".
7273      *
7274      * @param  beneficiary  The account that will be entitled to this depoit
7275      * @param  amount       The amount of owedToken to deposit
7276      * @return              The bucket number that was deposited into
7277      */
7278     function deposit(
7279         address beneficiary,
7280         uint256 amount
7281     )
7282         external
7283         nonReentrant
7284         returns (uint256)
7285     {
7286         Margin margin = Margin(DYDX_MARGIN);
7287         bytes32 positionId = POSITION_ID;
7288 
7289         require(
7290             beneficiary != address(0),
7291             "BucketLender#deposit: Beneficiary cannot be the zero address"
7292         );
7293         require(
7294             amount != 0,
7295             "BucketLender#deposit: Cannot deposit zero tokens"
7296         );
7297         require(
7298             !margin.isPositionClosed(positionId),
7299             "BucketLender#deposit: Cannot deposit after the position is closed"
7300         );
7301         require(
7302             !margin.isPositionCalled(positionId),
7303             "BucketLender#deposit: Cannot deposit while the position is margin-called"
7304         );
7305 
7306         rebalanceBucketsInternal();
7307 
7308         OWED_TOKEN.transferFrom(
7309             msg.sender,
7310             address(this),
7311             amount
7312         );
7313 
7314         uint256 bucket = getCurrentBucket();
7315 
7316         uint256 effectiveAmount = availableForBucket[bucket].add(getBucketOwedAmount(bucket));
7317 
7318         uint256 weightToAdd = 0;
7319         if (effectiveAmount == 0) {
7320             weightToAdd = amount; // first deposit in bucket
7321         } else {
7322             weightToAdd = MathHelpers.getPartialAmount(
7323                 amount,
7324                 effectiveAmount,
7325                 weightForBucket[bucket]
7326             );
7327         }
7328 
7329         require(
7330             weightToAdd != 0,
7331             "BucketLender#deposit: Cannot deposit for zero weight"
7332         );
7333 
7334         // update state
7335         updateAvailable(bucket, amount, true);
7336         weightForBucketForAccount[bucket][beneficiary] =
7337             weightForBucketForAccount[bucket][beneficiary].add(weightToAdd);
7338         weightForBucket[bucket] = weightForBucket[bucket].add(weightToAdd);
7339 
7340         emit Deposit(
7341             beneficiary,
7342             bucket,
7343             amount,
7344             weightToAdd
7345         );
7346 
7347         return bucket;
7348     }
7349 
7350     /**
7351      * Allows users to withdraw their lent funds. An account can withdraw its weighted share of the
7352      * bucket.
7353      *
7354      * While the position is open, a bucket's share is equal to:
7355      *   Owed Token: (Available Amount) + (Outstanding Principal) * (1 + interest)
7356      *   Held Token: 0
7357      *
7358      * After the position is closed, a bucket's share is equal to:
7359      *   Owed Token: (Available Amount)
7360      *   Held Token: (Held Token Balance) * (Outstanding Principal) / (Total Outstanding Principal)
7361      *
7362      * @param  buckets      The bucket numbers to withdraw from
7363      * @param  maxWeights   The maximum weight to withdraw from each bucket. The amount of tokens
7364      *                      withdrawn will be at least this amount, but not necessarily more.
7365      *                      Withdrawing the same weight from different buckets does not necessarily
7366      *                      return the same amounts from those buckets. In order to withdraw as many
7367      *                      tokens as possible, use the maximum uint256.
7368      * @param  onBehalfOf   The address to withdraw on behalf of
7369      * @return              1) The number of owedTokens withdrawn
7370      *                      2) The number of heldTokens withdrawn
7371      */
7372     function withdraw(
7373         uint256[] buckets,
7374         uint256[] maxWeights,
7375         address onBehalfOf
7376     )
7377         external
7378         nonReentrant
7379         returns (uint256, uint256)
7380     {
7381         require(
7382             buckets.length == maxWeights.length,
7383             "BucketLender#withdraw: The lengths of the input arrays must match"
7384         );
7385         if (onBehalfOf != msg.sender) {
7386             require(
7387                 TRUSTED_WITHDRAWERS[msg.sender],
7388                 "BucketLender#withdraw: Only trusted withdrawers can withdraw on behalf of others"
7389             );
7390         }
7391 
7392         rebalanceBucketsInternal();
7393 
7394         // decide if some bucket is unable to be withdrawn from (is locked)
7395         // the zero value represents no-lock
7396         uint256 lockedBucket = 0;
7397         if (
7398             Margin(DYDX_MARGIN).containsPosition(POSITION_ID) &&
7399             criticalBucket == getCurrentBucket()
7400         ) {
7401             lockedBucket = criticalBucket;
7402         }
7403 
7404         uint256[2] memory results; // [0] = totalOwedToken, [1] = totalHeldToken
7405 
7406         uint256 maxHeldToken = 0;
7407         if (wasForceClosed) {
7408             maxHeldToken = HELD_TOKEN.balanceOf(address(this));
7409         }
7410 
7411         for (uint256 i = 0; i < buckets.length; i++) {
7412             uint256 bucket = buckets[i];
7413 
7414             // prevent withdrawing from the current bucket if it is also the critical bucket
7415             if ((bucket != 0) && (bucket == lockedBucket)) {
7416                 continue;
7417             }
7418 
7419             (uint256 owedTokenForBucket, uint256 heldTokenForBucket) = withdrawSingleBucket(
7420                 onBehalfOf,
7421                 bucket,
7422                 maxWeights[i],
7423                 maxHeldToken
7424             );
7425 
7426             results[0] = results[0].add(owedTokenForBucket);
7427             results[1] = results[1].add(heldTokenForBucket);
7428         }
7429 
7430         // Transfer share of owedToken
7431         OWED_TOKEN.transfer(msg.sender, results[0]);
7432         HELD_TOKEN.transfer(msg.sender, results[1]);
7433 
7434         return (results[0], results[1]);
7435     }
7436 
7437     /**
7438      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
7439      * including (but not limited-to) token airdrops. Any tokens moved to this contract by calling
7440      * deposit() will be accounted for and will not be withdrawable by this function.
7441      *
7442      * @param  token  ERC20 token address
7443      * @param  to     Address to transfer tokens to
7444      * @return        Amount of tokens withdrawn
7445      */
7446     function withdrawExcessToken(
7447         address token,
7448         address to
7449     )
7450         external
7451         onlyOwner
7452         returns (uint256)
7453     {
7454         rebalanceBucketsInternal();
7455 
7456         uint256 amount = token.balanceOf(address(this));
7457 
7458         if (token == OWED_TOKEN) {
7459             amount = amount.sub(availableTotal);
7460         } else if (token == HELD_TOKEN) {
7461             require(
7462                 !wasForceClosed,
7463                 "BucketLender#withdrawExcessToken: heldToken cannot be withdrawn if force-closed"
7464             );
7465         }
7466 
7467         token.transfer(to, amount);
7468         return amount;
7469     }
7470 
7471     // ============ Public Getter Functions ============
7472 
7473     /**
7474      * Get the current bucket number that funds will be deposited into. This is also the highest
7475      * bucket so far.
7476      *
7477      * @return The highest bucket and the one that funds will be deposited into
7478      */
7479     function getCurrentBucket()
7480         public
7481         view
7482         returns (uint256)
7483     {
7484         // load variables from storage;
7485         Margin margin = Margin(DYDX_MARGIN);
7486         bytes32 positionId = POSITION_ID;
7487         uint32 bucketTime = BUCKET_TIME;
7488 
7489         assert(!margin.isPositionClosed(positionId));
7490 
7491         // if position not created, allow deposits in the first bucket
7492         if (!margin.containsPosition(positionId)) {
7493             return 0;
7494         }
7495 
7496         // return the number of BUCKET_TIME periods elapsed since the position start, rounded-up
7497         uint256 startTimestamp = margin.getPositionStartTimestamp(positionId);
7498         return block.timestamp.sub(startTimestamp).div(bucketTime).add(1);
7499     }
7500 
7501     /**
7502      * Gets the outstanding amount of owedToken owed to a bucket. This is the principal amount of
7503      * the bucket multiplied by the interest accrued in the position. If the position is closed,
7504      * then any outstanding principal will never be repaid in the form of owedToken.
7505      *
7506      * @param  bucket  The bucket number
7507      * @return         The amount of owedToken that this bucket expects to be paid-back if the posi
7508      */
7509     function getBucketOwedAmount(
7510         uint256 bucket
7511     )
7512         public
7513         view
7514         returns (uint256)
7515     {
7516         // if the position is completely closed, then the outstanding principal will never be repaid
7517         if (Margin(DYDX_MARGIN).isPositionClosed(POSITION_ID)) {
7518             return 0;
7519         }
7520 
7521         uint256 lentPrincipal = principalForBucket[bucket];
7522 
7523         // the bucket has no outstanding principal
7524         if (lentPrincipal == 0) {
7525             return 0;
7526         }
7527 
7528         // get the total amount of owedToken that would be paid back at this time
7529         uint256 owedAmount = Margin(DYDX_MARGIN).getPositionOwedAmountAtTime(
7530             POSITION_ID,
7531             principalTotal,
7532             uint32(block.timestamp)
7533         );
7534 
7535         // return the bucket's share
7536         return MathHelpers.getPartialAmount(
7537             lentPrincipal,
7538             principalTotal,
7539             owedAmount
7540         );
7541     }
7542 
7543     // ============ Internal Functions ============
7544 
7545     function forceRecoverCollateralInternal(
7546         address recipient
7547     )
7548         internal
7549         returns (address)
7550     {
7551         require(
7552             recipient == address(this),
7553             "BucketLender#forceRecoverCollateralOnBehalfOf: Recipient must be this contract"
7554         );
7555 
7556         rebalanceBucketsInternal();
7557 
7558         wasForceClosed = true;
7559 
7560         return address(this);
7561     }
7562 
7563     // ============ Private Helper Functions ============
7564 
7565     /**
7566      * Recalculates the Outstanding Principal and Available Amount for the buckets. Only changes the
7567      * state if part of the position has been closed since the last position increase.
7568      */
7569     function rebalanceBucketsInternal()
7570         private
7571     {
7572         // if force-closed, don't update the outstanding principal values; they are needed to repay
7573         // lenders with heldToken
7574         if (wasForceClosed) {
7575             return;
7576         }
7577 
7578         uint256 marginPrincipal = Margin(DYDX_MARGIN).getPositionPrincipal(POSITION_ID);
7579 
7580         accountForClose(principalTotal.sub(marginPrincipal));
7581 
7582         assert(principalTotal == marginPrincipal);
7583     }
7584 
7585     /**
7586      * Updates the state variables at any time. Only does anything after the position has been
7587      * closed or partially-closed since the last time this function was called.
7588      *
7589      * - Increases the available amount in the highest buckets with outstanding principal
7590      * - Decreases the principal amount in those buckets
7591      *
7592      * @param  principalRemoved  Amount of principal closed since the last update
7593      */
7594     function accountForClose(
7595         uint256 principalRemoved
7596     )
7597         private
7598     {
7599         if (principalRemoved == 0) {
7600             return;
7601         }
7602 
7603         uint256 newRepaidAmount = Margin(DYDX_MARGIN).getTotalOwedTokenRepaidToLender(POSITION_ID);
7604         assert(newRepaidAmount.sub(cachedRepaidAmount) >= principalRemoved);
7605 
7606         uint256 principalToSub = principalRemoved;
7607         uint256 availableToAdd = newRepaidAmount.sub(cachedRepaidAmount);
7608         uint256 criticalBucketTemp = criticalBucket;
7609 
7610         // loop over buckets in reverse order starting with the critical bucket
7611         for (
7612             uint256 bucket = criticalBucketTemp;
7613             principalToSub > 0;
7614             bucket--
7615         ) {
7616             assert(bucket <= criticalBucketTemp); // no underflow on bucket
7617 
7618             uint256 principalTemp = Math.min256(principalToSub, principalForBucket[bucket]);
7619             if (principalTemp == 0) {
7620                 continue;
7621             }
7622             uint256 availableTemp = MathHelpers.getPartialAmount(
7623                 principalTemp,
7624                 principalToSub,
7625                 availableToAdd
7626             );
7627 
7628             updateAvailable(bucket, availableTemp, true);
7629             updatePrincipal(bucket, principalTemp, false);
7630 
7631             principalToSub = principalToSub.sub(principalTemp);
7632             availableToAdd = availableToAdd.sub(availableTemp);
7633 
7634             criticalBucketTemp = bucket;
7635         }
7636 
7637         assert(principalToSub == 0);
7638         assert(availableToAdd == 0);
7639 
7640         setCriticalBucket(criticalBucketTemp);
7641 
7642         cachedRepaidAmount = newRepaidAmount;
7643     }
7644 
7645     /**
7646      * Updates the state variables when a position is increased.
7647      *
7648      * - Decreases the available amount in the lowest buckets with available token
7649      * - Increases the principal amount in those buckets
7650      *
7651      * @param  principalAdded  Amount of principal added to the position
7652      * @param  lentAmount      Amount of owedToken lent
7653      */
7654     function accountForIncrease(
7655         uint256 principalAdded,
7656         uint256 lentAmount
7657     )
7658         private
7659     {
7660         require(
7661             lentAmount <= availableTotal,
7662             "BucketLender#accountForIncrease: No lending not-accounted-for funds"
7663         );
7664 
7665         uint256 principalToAdd = principalAdded;
7666         uint256 availableToSub = lentAmount;
7667         uint256 criticalBucketTemp;
7668 
7669         // loop over buckets in order starting from the critical bucket
7670         uint256 lastBucket = getCurrentBucket();
7671         for (
7672             uint256 bucket = criticalBucket;
7673             principalToAdd > 0;
7674             bucket++
7675         ) {
7676             assert(bucket <= lastBucket); // should never go past the last bucket
7677 
7678             uint256 availableTemp = Math.min256(availableToSub, availableForBucket[bucket]);
7679             if (availableTemp == 0) {
7680                 continue;
7681             }
7682             uint256 principalTemp = MathHelpers.getPartialAmount(
7683                 availableTemp,
7684                 availableToSub,
7685                 principalToAdd
7686             );
7687 
7688             updateAvailable(bucket, availableTemp, false);
7689             updatePrincipal(bucket, principalTemp, true);
7690 
7691             principalToAdd = principalToAdd.sub(principalTemp);
7692             availableToSub = availableToSub.sub(availableTemp);
7693 
7694             criticalBucketTemp = bucket;
7695         }
7696 
7697         assert(principalToAdd == 0);
7698         assert(availableToSub == 0);
7699 
7700         setCriticalBucket(criticalBucketTemp);
7701     }
7702 
7703     /**
7704      * Withdraw
7705      *
7706      * @param  onBehalfOf    The account for which to withdraw for
7707      * @param  bucket        The bucket number to withdraw from
7708      * @param  maxWeight     The maximum weight to withdraw
7709      * @param  maxHeldToken  The total amount of heldToken that has been force-recovered
7710      * @return               1) The number of owedTokens withdrawn
7711      *                       2) The number of heldTokens withdrawn
7712      */
7713     function withdrawSingleBucket(
7714         address onBehalfOf,
7715         uint256 bucket,
7716         uint256 maxWeight,
7717         uint256 maxHeldToken
7718     )
7719         private
7720         returns (uint256, uint256)
7721     {
7722         // calculate the user's share
7723         uint256 bucketWeight = weightForBucket[bucket];
7724         if (bucketWeight == 0) {
7725             return (0, 0);
7726         }
7727 
7728         uint256 userWeight = weightForBucketForAccount[bucket][onBehalfOf];
7729         uint256 weightToWithdraw = Math.min256(maxWeight, userWeight);
7730         if (weightToWithdraw == 0) {
7731             return (0, 0);
7732         }
7733 
7734         // update state
7735         weightForBucket[bucket] = weightForBucket[bucket].sub(weightToWithdraw);
7736         weightForBucketForAccount[bucket][onBehalfOf] = userWeight.sub(weightToWithdraw);
7737 
7738         // calculate for owedToken
7739         uint256 owedTokenToWithdraw = withdrawOwedToken(
7740             bucket,
7741             weightToWithdraw,
7742             bucketWeight
7743         );
7744 
7745         // calculate for heldToken
7746         uint256 heldTokenToWithdraw = withdrawHeldToken(
7747             bucket,
7748             weightToWithdraw,
7749             bucketWeight,
7750             maxHeldToken
7751         );
7752 
7753         emit Withdraw(
7754             onBehalfOf,
7755             bucket,
7756             weightToWithdraw,
7757             owedTokenToWithdraw,
7758             heldTokenToWithdraw
7759         );
7760 
7761         return (owedTokenToWithdraw, heldTokenToWithdraw);
7762     }
7763 
7764     /**
7765      * Helper function to withdraw earned owedToken from this contract.
7766      *
7767      * @param  bucket        The bucket number to withdraw from
7768      * @param  userWeight    The amount of weight the user is using to withdraw
7769      * @param  bucketWeight  The total weight of the bucket
7770      * @return               The amount of owedToken being withdrawn
7771      */
7772     function withdrawOwedToken(
7773         uint256 bucket,
7774         uint256 userWeight,
7775         uint256 bucketWeight
7776     )
7777         private
7778         returns (uint256)
7779     {
7780         // amount to return for the bucket
7781         uint256 owedTokenToWithdraw = MathHelpers.getPartialAmount(
7782             userWeight,
7783             bucketWeight,
7784             availableForBucket[bucket].add(getBucketOwedAmount(bucket))
7785         );
7786 
7787         // check that there is enough token to give back
7788         require(
7789             owedTokenToWithdraw <= availableForBucket[bucket],
7790             "BucketLender#withdrawOwedToken: There must be enough available owedToken"
7791         );
7792 
7793         // update amounts
7794         updateAvailable(bucket, owedTokenToWithdraw, false);
7795 
7796         return owedTokenToWithdraw;
7797     }
7798 
7799     /**
7800      * Helper function to withdraw heldToken from this contract.
7801      *
7802      * @param  bucket        The bucket number to withdraw from
7803      * @param  userWeight    The amount of weight the user is using to withdraw
7804      * @param  bucketWeight  The total weight of the bucket
7805      * @param  maxHeldToken  The total amount of heldToken available to withdraw
7806      * @return               The amount of heldToken being withdrawn
7807      */
7808     function withdrawHeldToken(
7809         uint256 bucket,
7810         uint256 userWeight,
7811         uint256 bucketWeight,
7812         uint256 maxHeldToken
7813     )
7814         private
7815         returns (uint256)
7816     {
7817         if (maxHeldToken == 0) {
7818             return 0;
7819         }
7820 
7821         // user's principal for the bucket
7822         uint256 principalForBucketForAccount = MathHelpers.getPartialAmount(
7823             userWeight,
7824             bucketWeight,
7825             principalForBucket[bucket]
7826         );
7827 
7828         uint256 heldTokenToWithdraw = MathHelpers.getPartialAmount(
7829             principalForBucketForAccount,
7830             principalTotal,
7831             maxHeldToken
7832         );
7833 
7834         updatePrincipal(bucket, principalForBucketForAccount, false);
7835 
7836         return heldTokenToWithdraw;
7837     }
7838 
7839     // ============ Setter Functions ============
7840 
7841     /**
7842      * Changes the critical bucket variable
7843      *
7844      * @param  bucket  The value to set criticalBucket to
7845      */
7846     function setCriticalBucket(
7847         uint256 bucket
7848     )
7849         private
7850     {
7851         // don't spend the gas to sstore unless we need to change the value
7852         if (criticalBucket == bucket) {
7853             return;
7854         }
7855 
7856         criticalBucket = bucket;
7857     }
7858 
7859     /**
7860      * Changes the available owedToken amount. This changes both the variable to track the total
7861      * amount as well as the variable to track a particular bucket.
7862      *
7863      * @param  bucket    The bucket number
7864      * @param  amount    The amount to change the available amount by
7865      * @param  increase  True if positive change, false if negative change
7866      */
7867     function updateAvailable(
7868         uint256 bucket,
7869         uint256 amount,
7870         bool increase
7871     )
7872         private
7873     {
7874         if (amount == 0) {
7875             return;
7876         }
7877 
7878         uint256 newTotal;
7879         uint256 newForBucket;
7880 
7881         if (increase) {
7882             newTotal = availableTotal.add(amount);
7883             newForBucket = availableForBucket[bucket].add(amount);
7884             emit AvailableIncreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7885         } else {
7886             newTotal = availableTotal.sub(amount);
7887             newForBucket = availableForBucket[bucket].sub(amount);
7888             emit AvailableDecreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7889         }
7890 
7891         availableTotal = newTotal;
7892         availableForBucket[bucket] = newForBucket;
7893     }
7894 
7895     /**
7896      * Changes the principal amount. This changes both the variable to track the total
7897      * amount as well as the variable to track a particular bucket.
7898      *
7899      * @param  bucket    The bucket number
7900      * @param  amount    The amount to change the principal amount by
7901      * @param  increase  True if positive change, false if negative change
7902      */
7903     function updatePrincipal(
7904         uint256 bucket,
7905         uint256 amount,
7906         bool increase
7907     )
7908         private
7909     {
7910         if (amount == 0) {
7911             return;
7912         }
7913 
7914         uint256 newTotal;
7915         uint256 newForBucket;
7916 
7917         if (increase) {
7918             newTotal = principalTotal.add(amount);
7919             newForBucket = principalForBucket[bucket].add(amount);
7920             emit PrincipalIncreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7921         } else {
7922             newTotal = principalTotal.sub(amount);
7923             newForBucket = principalForBucket[bucket].sub(amount);
7924             emit PrincipalDecreased(newTotal, bucket, newForBucket, amount); // solium-disable-line
7925         }
7926 
7927         principalTotal = newTotal;
7928         principalForBucket[bucket] = newForBucket;
7929     }
7930 }
7931 
7932 // File: contracts/lib/AdvancedTokenInteract.sol
7933 
7934 /**
7935  * @title AdvancedTokenInteract
7936  * @author dYdX
7937  *
7938  * This library contains advanced functions for interacting with ERC20 tokens
7939  */
7940 library AdvancedTokenInteract {
7941     using TokenInteract for address;
7942 
7943     /**
7944      * Checks if the spender has some amount of allowance. If it doesn't, then set allowance at
7945      * the maximum value.
7946      *
7947      * @param  token    Address of the ERC20 token
7948      * @param  spender  Argument of the allowance function
7949      * @param  amount   The minimum amount of allownce the the spender should be guaranteed
7950      */
7951     function ensureAllowance(
7952         address token,
7953         address spender,
7954         uint256 amount
7955     )
7956         internal
7957     {
7958         if (token.allowance(address(this), spender) < amount) {
7959             token.approve(spender, MathHelpers.maxUint256());
7960         }
7961     }
7962 }
7963 
7964 // File: contracts/margin/external/BucketLender/BucketLenderProxy.sol
7965 
7966 /**
7967  * @title BucketLenderProxy
7968  * @author dYdX
7969  *
7970  * TokenProxy for BucketLender contracts
7971  */
7972 contract BucketLenderProxy
7973 {
7974     using TokenInteract for address;
7975     using AdvancedTokenInteract for address;
7976 
7977     // ============ Constants ============
7978 
7979     // Address of the WETH token
7980     address public WETH;
7981 
7982     // ============ Constructor ============
7983 
7984     constructor(
7985         address weth
7986     )
7987         public
7988     {
7989         WETH = weth;
7990     }
7991 
7992     // ============ Public Functions ============
7993 
7994     /**
7995      * Fallback function. Disallows ETH to be sent to this contract without data except when
7996      * unwrapping WETH.
7997      */
7998     function ()
7999         external
8000         payable
8001     {
8002         require( // coverage-disable-line
8003             msg.sender == WETH,
8004             "BucketLenderProxy#fallback: Cannot recieve ETH directly unless unwrapping WETH"
8005         );
8006     }
8007 
8008     /**
8009      * Send ETH directly to this contract, convert it to WETH, and sent it to a BucketLender
8010      *
8011      * @param  bucketLender  The address of the BucketLender contract to deposit into
8012      * @return               The bucket number that was deposited into
8013      */
8014     function depositEth(
8015         address bucketLender
8016     )
8017         external
8018         payable
8019         returns (uint256)
8020     {
8021         address weth = WETH;
8022 
8023         require(
8024             weth == BucketLender(bucketLender).OWED_TOKEN(),
8025             "BucketLenderProxy#depositEth: BucketLender does not take WETH"
8026         );
8027 
8028         WETH9(weth).deposit.value(msg.value)();
8029 
8030         return depositInternal(
8031             bucketLender,
8032             weth,
8033             msg.value
8034         );
8035     }
8036 
8037     /**
8038      * Deposits tokens from msg.sender into a BucketLender
8039      *
8040      * @param  bucketLender  The address of the BucketLender contract to deposit into
8041      * @param  amount        The amount of token to deposit
8042      * @return               The bucket number that was deposited into
8043      */
8044     function deposit(
8045         address bucketLender,
8046         uint256 amount
8047     )
8048         external
8049         returns (uint256)
8050     {
8051         address token = BucketLender(bucketLender).OWED_TOKEN();
8052         token.transferFrom(msg.sender, address(this), amount);
8053 
8054         return depositInternal(
8055             bucketLender,
8056             token,
8057             amount
8058         );
8059     }
8060 
8061     /**
8062      * Withdraw tokens from a BucketLender
8063      *
8064      * @param  bucketLender  The address of the BucketLender contract to withdraw from
8065      * @param  buckets       The buckets to withdraw from
8066      * @param  maxWeights    The maximum weight to withdraw from each bucket
8067      * @return               Values corresponding to:
8068      *                         [0]  = The number of owedTokens withdrawn
8069      *                         [1]  = The number of heldTokens withdrawn
8070      */
8071     function withdraw(
8072         address bucketLender,
8073         uint256[] buckets,
8074         uint256[] maxWeights
8075     )
8076         external
8077         returns (uint256, uint256)
8078     {
8079         address owedToken = BucketLender(bucketLender).OWED_TOKEN();
8080         address heldToken = BucketLender(bucketLender).HELD_TOKEN();
8081 
8082         (
8083             uint256 owedTokenAmount,
8084             uint256 heldTokenAmount
8085         ) = BucketLender(bucketLender).withdraw(
8086             buckets,
8087             maxWeights,
8088             msg.sender
8089         );
8090 
8091         transferInternal(owedToken, msg.sender, owedTokenAmount);
8092         transferInternal(heldToken, msg.sender, heldTokenAmount);
8093 
8094         return (owedTokenAmount, heldTokenAmount);
8095     }
8096 
8097     /**
8098      * Reinvest tokens by withdrawing them from one BucketLender and depositing them into another
8099      *
8100      * @param  withdrawFrom  The address of the BucketLender contract to withdraw from
8101      * @param  depositInto   The address of the BucketLender contract to deposit into
8102      * @param  buckets       The buckets to withdraw from
8103      * @param  maxWeights    The maximum weight to withdraw from each bucket
8104      * @return               Values corresponding to:
8105      *                         [0]  = The bucket number that was deposited into
8106      *                         [1]  = The number of owedTokens reinvested
8107      *                         [2]  = The number of heldTokens withdrawn
8108      */
8109     function rollover(
8110         address withdrawFrom,
8111         address depositInto,
8112         uint256[] buckets,
8113         uint256[] maxWeights
8114     )
8115         external
8116         returns (uint256, uint256, uint256)
8117     {
8118         address owedToken = BucketLender(depositInto).OWED_TOKEN();
8119 
8120         // the owedTokens of the two BucketLenders must be the same
8121         require (
8122             owedToken == BucketLender(withdrawFrom).OWED_TOKEN(),
8123             "BucketLenderTokenProxy#rollover: Token mismatch"
8124         );
8125 
8126         // withdraw from the first BucketLender
8127         (
8128             uint256 owedTokenAmount,
8129             uint256 heldTokenAmount
8130         ) = BucketLender(withdrawFrom).withdraw(
8131             buckets,
8132             maxWeights,
8133             msg.sender
8134         );
8135 
8136         // reinvest any owedToken into the second BucketLender
8137         uint256 bucket = depositInternal(
8138             depositInto,
8139             owedToken,
8140             owedTokenAmount
8141         );
8142 
8143         // return any heldToken to the msg.sender
8144         address heldToken = BucketLender(withdrawFrom).HELD_TOKEN();
8145         transferInternal(heldToken, msg.sender, heldTokenAmount);
8146 
8147         return (bucket, owedTokenAmount, heldTokenAmount);
8148     }
8149 
8150     // ============ Private Functions ============
8151 
8152     function depositInternal(
8153         address bucketLender,
8154         address token,
8155         uint256 amount
8156     )
8157         private
8158         returns (uint256)
8159     {
8160         token.ensureAllowance(bucketLender, amount);
8161         return BucketLender(bucketLender).deposit(msg.sender, amount);
8162     }
8163 
8164     function transferInternal(
8165         address token,
8166         address recipient,
8167         uint256 amount
8168     )
8169         private
8170     {
8171         address weth = WETH;
8172         if (token == weth) {
8173             if (amount != 0) {
8174                 WETH9(weth).withdraw(amount);
8175                 msg.sender.transfer(amount);
8176             }
8177         } else {
8178             token.transfer(recipient, amount);
8179         }
8180     }
8181 }