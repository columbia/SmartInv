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
143 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
144 
145 /**
146  * @title ERC20Basic
147  * @dev Simpler version of ERC20 interface
148  * See https://github.com/ethereum/EIPs/issues/179
149  */
150 contract ERC20Basic {
151   function totalSupply() public view returns (uint256);
152   function balanceOf(address _who) public view returns (uint256);
153   function transfer(address _to, uint256 _value) public returns (bool);
154   event Transfer(address indexed from, address indexed to, uint256 value);
155 }
156 
157 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
158 
159 /**
160  * @title Basic token
161  * @dev Basic version of StandardToken, with no allowances.
162  */
163 contract BasicToken is ERC20Basic {
164   using SafeMath for uint256;
165 
166   mapping(address => uint256) internal balances;
167 
168   uint256 internal totalSupply_;
169 
170   /**
171   * @dev Total number of tokens in existence
172   */
173   function totalSupply() public view returns (uint256) {
174     return totalSupply_;
175   }
176 
177   /**
178   * @dev Transfer token for a specified address
179   * @param _to The address to transfer to.
180   * @param _value The amount to be transferred.
181   */
182   function transfer(address _to, uint256 _value) public returns (bool) {
183     require(_value <= balances[msg.sender]);
184     require(_to != address(0));
185 
186     balances[msg.sender] = balances[msg.sender].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     emit Transfer(msg.sender, _to, _value);
189     return true;
190   }
191 
192   /**
193   * @dev Gets the balance of the specified address.
194   * @param _owner The address to query the the balance of.
195   * @return An uint256 representing the amount owned by the passed address.
196   */
197   function balanceOf(address _owner) public view returns (uint256) {
198     return balances[_owner];
199   }
200 
201 }
202 
203 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
204 
205 /**
206  * @title ERC20 interface
207  * @dev see https://github.com/ethereum/EIPs/issues/20
208  */
209 contract ERC20 is ERC20Basic {
210   function allowance(address _owner, address _spender)
211     public view returns (uint256);
212 
213   function transferFrom(address _from, address _to, uint256 _value)
214     public returns (bool);
215 
216   function approve(address _spender, uint256 _value) public returns (bool);
217   event Approval(
218     address indexed owner,
219     address indexed spender,
220     uint256 value
221   );
222 }
223 
224 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
225 
226 /**
227  * @title Standard ERC20 token
228  *
229  * @dev Implementation of the basic standard token.
230  * https://github.com/ethereum/EIPs/issues/20
231  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
232  */
233 contract StandardToken is ERC20, BasicToken {
234 
235   mapping (address => mapping (address => uint256)) internal allowed;
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param _from address The address which you want to send tokens from
240    * @param _to address The address which you want to transfer to
241    * @param _value uint256 the amount of tokens to be transferred
242    */
243   function transferFrom(
244     address _from,
245     address _to,
246     uint256 _value
247   )
248     public
249     returns (bool)
250   {
251     require(_value <= balances[_from]);
252     require(_value <= allowed[_from][msg.sender]);
253     require(_to != address(0));
254 
255     balances[_from] = balances[_from].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
258     emit Transfer(_from, _to, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     allowed[msg.sender][_spender] = _value;
273     emit Approval(msg.sender, _spender, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens that an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint256 specifying the amount of tokens still available for the spender.
282    */
283   function allowance(
284     address _owner,
285     address _spender
286    )
287     public
288     view
289     returns (uint256)
290   {
291     return allowed[_owner][_spender];
292   }
293 
294   /**
295    * @dev Increase the amount of tokens that an owner allowed to a spender.
296    * approve should be called when allowed[_spender] == 0. To increment
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _addedValue The amount of tokens to increase the allowance by.
302    */
303   function increaseApproval(
304     address _spender,
305     uint256 _addedValue
306   )
307     public
308     returns (bool)
309   {
310     allowed[msg.sender][_spender] = (
311       allowed[msg.sender][_spender].add(_addedValue));
312     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316   /**
317    * @dev Decrease the amount of tokens that an owner allowed to a spender.
318    * approve should be called when allowed[_spender] == 0. To decrement
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param _spender The address which will spend the funds.
323    * @param _subtractedValue The amount of tokens to decrease the allowance by.
324    */
325   function decreaseApproval(
326     address _spender,
327     uint256 _subtractedValue
328   )
329     public
330     returns (bool)
331   {
332     uint256 oldValue = allowed[msg.sender][_spender];
333     if (_subtractedValue >= oldValue) {
334       allowed[msg.sender][_spender] = 0;
335     } else {
336       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
337     }
338     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
339     return true;
340   }
341 
342 }
343 
344 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
345 
346 /**
347  * @title Ownable
348  * @dev The Ownable contract has an owner address, and provides basic authorization control
349  * functions, this simplifies the implementation of "user permissions".
350  */
351 contract Ownable {
352   address public owner;
353 
354   event OwnershipRenounced(address indexed previousOwner);
355   event OwnershipTransferred(
356     address indexed previousOwner,
357     address indexed newOwner
358   );
359 
360   /**
361    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
362    * account.
363    */
364   constructor() public {
365     owner = msg.sender;
366   }
367 
368   /**
369    * @dev Throws if called by any account other than the owner.
370    */
371   modifier onlyOwner() {
372     require(msg.sender == owner);
373     _;
374   }
375 
376   /**
377    * @dev Allows the current owner to relinquish control of the contract.
378    * @notice Renouncing to ownership will leave the contract without an owner.
379    * It will not be possible to call the functions with the `onlyOwner`
380    * modifier anymore.
381    */
382   function renounceOwnership() public onlyOwner {
383     emit OwnershipRenounced(owner);
384     owner = address(0);
385   }
386 
387   /**
388    * @dev Allows the current owner to transfer control of the contract to a newOwner.
389    * @param _newOwner The address to transfer ownership to.
390    */
391   function transferOwnership(address _newOwner) public onlyOwner {
392     _transferOwnership(_newOwner);
393   }
394 
395   /**
396    * @dev Transfers control of the contract to a newOwner.
397    * @param _newOwner The address to transfer ownership to.
398    */
399   function _transferOwnership(address _newOwner) internal {
400     require(_newOwner != address(0));
401     emit OwnershipTransferred(owner, _newOwner);
402     owner = _newOwner;
403   }
404 }
405 
406 // File: contracts/lib/AccessControlledBase.sol
407 
408 /**
409  * @title AccessControlledBase
410  * @author dYdX
411  *
412  * Base functionality for access control. Requires an implementation to
413  * provide a way to grant and optionally revoke access
414  */
415 contract AccessControlledBase {
416     // ============ State Variables ============
417 
418     mapping (address => bool) public authorized;
419 
420     // ============ Events ============
421 
422     event AccessGranted(
423         address who
424     );
425 
426     event AccessRevoked(
427         address who
428     );
429 
430     // ============ Modifiers ============
431 
432     modifier requiresAuthorization() {
433         require(
434             authorized[msg.sender],
435             "AccessControlledBase#requiresAuthorization: Sender not authorized"
436         );
437         _;
438     }
439 }
440 
441 // File: contracts/lib/StaticAccessControlled.sol
442 
443 /**
444  * @title StaticAccessControlled
445  * @author dYdX
446  *
447  * Allows for functions to be access controled
448  * Permissions cannot be changed after a grace period
449  */
450 contract StaticAccessControlled is AccessControlledBase, Ownable {
451     using SafeMath for uint256;
452 
453     // ============ State Variables ============
454 
455     // Timestamp after which no additional access can be granted
456     uint256 public GRACE_PERIOD_EXPIRATION;
457 
458     // ============ Constructor ============
459 
460     constructor(
461         uint256 gracePeriod
462     )
463         public
464         Ownable()
465     {
466         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
467     }
468 
469     // ============ Owner-Only State-Changing Functions ============
470 
471     function grantAccess(
472         address who
473     )
474         external
475         onlyOwner
476     {
477         require(
478             block.timestamp < GRACE_PERIOD_EXPIRATION,
479             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
480         );
481 
482         emit AccessGranted(who);
483         authorized[who] = true;
484     }
485 }
486 
487 // File: contracts/lib/GeneralERC20.sol
488 
489 /**
490  * @title GeneralERC20
491  * @author dYdX
492  *
493  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
494  * that we dont automatically revert when calling non-compliant tokens that have no return value for
495  * transfer(), transferFrom(), or approve().
496  */
497 interface GeneralERC20 {
498     function totalSupply(
499     )
500         external
501         view
502         returns (uint256);
503 
504     function balanceOf(
505         address who
506     )
507         external
508         view
509         returns (uint256);
510 
511     function allowance(
512         address owner,
513         address spender
514     )
515         external
516         view
517         returns (uint256);
518 
519     function transfer(
520         address to,
521         uint256 value
522     )
523         external;
524 
525     function transferFrom(
526         address from,
527         address to,
528         uint256 value
529     )
530         external;
531 
532     function approve(
533         address spender,
534         uint256 value
535     )
536         external;
537 }
538 
539 // File: contracts/lib/TokenInteract.sol
540 
541 /**
542  * @title TokenInteract
543  * @author dYdX
544  *
545  * This library contains basic functions for interacting with ERC20 tokens
546  */
547 library TokenInteract {
548     function balanceOf(
549         address token,
550         address owner
551     )
552         internal
553         view
554         returns (uint256)
555     {
556         return GeneralERC20(token).balanceOf(owner);
557     }
558 
559     function allowance(
560         address token,
561         address owner,
562         address spender
563     )
564         internal
565         view
566         returns (uint256)
567     {
568         return GeneralERC20(token).allowance(owner, spender);
569     }
570 
571     function approve(
572         address token,
573         address spender,
574         uint256 amount
575     )
576         internal
577     {
578         GeneralERC20(token).approve(spender, amount);
579 
580         require(
581             checkSuccess(),
582             "TokenInteract#approve: Approval failed"
583         );
584     }
585 
586     function transfer(
587         address token,
588         address to,
589         uint256 amount
590     )
591         internal
592     {
593         address from = address(this);
594         if (
595             amount == 0
596             || from == to
597         ) {
598             return;
599         }
600 
601         GeneralERC20(token).transfer(to, amount);
602 
603         require(
604             checkSuccess(),
605             "TokenInteract#transfer: Transfer failed"
606         );
607     }
608 
609     function transferFrom(
610         address token,
611         address from,
612         address to,
613         uint256 amount
614     )
615         internal
616     {
617         if (
618             amount == 0
619             || from == to
620         ) {
621             return;
622         }
623 
624         GeneralERC20(token).transferFrom(from, to, amount);
625 
626         require(
627             checkSuccess(),
628             "TokenInteract#transferFrom: TransferFrom failed"
629         );
630     }
631 
632     // ============ Private Helper-Functions ============
633 
634     /**
635      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
636      * function returned 0 bytes or 32 bytes that are not all-zero.
637      */
638     function checkSuccess(
639     )
640         private
641         pure
642         returns (bool)
643     {
644         uint256 returnValue = 0;
645 
646         /* solium-disable-next-line security/no-inline-assembly */
647         assembly {
648             // check number of bytes returned from last function call
649             switch returndatasize
650 
651             // no bytes returned: assume success
652             case 0x0 {
653                 returnValue := 1
654             }
655 
656             // 32 bytes returned: check if non-zero
657             case 0x20 {
658                 // copy 32 bytes into scratch space
659                 returndatacopy(0x0, 0x0, 0x20)
660 
661                 // load those bytes into returnValue
662                 returnValue := mload(0x0)
663             }
664 
665             // not sure what was returned: dont mark as success
666             default { }
667         }
668 
669         return returnValue != 0;
670     }
671 }
672 
673 // File: contracts/margin/TokenProxy.sol
674 
675 /**
676  * @title TokenProxy
677  * @author dYdX
678  *
679  * Used to transfer tokens between addresses which have set allowance on this contract.
680  */
681 contract TokenProxy is StaticAccessControlled {
682     using SafeMath for uint256;
683 
684     // ============ Constructor ============
685 
686     constructor(
687         uint256 gracePeriod
688     )
689         public
690         StaticAccessControlled(gracePeriod)
691     {}
692 
693     // ============ Authorized-Only State Changing Functions ============
694 
695     /**
696      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
697      *
698      * @param  token  The address of the ERC20 token
699      * @param  from   The address to transfer token from
700      * @param  to     The address to transfer tokens to
701      * @param  value  The number of tokens to transfer
702      */
703     function transferTokens(
704         address token,
705         address from,
706         address to,
707         uint256 value
708     )
709         external
710         requiresAuthorization
711     {
712         TokenInteract.transferFrom(
713             token,
714             from,
715             to,
716             value
717         );
718     }
719 
720     // ============ Public Constant Functions ============
721 
722     /**
723      * Getter function to get the amount of token that the proxy is able to move for a particular
724      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
725      *
726      * @param  who    The owner of the tokens
727      * @param  token  The address of the ERC20 token
728      * @return        The number of tokens able to be moved by the proxy from the address specified
729      */
730     function available(
731         address who,
732         address token
733     )
734         external
735         view
736         returns (uint256)
737     {
738         return Math.min256(
739             TokenInteract.allowance(token, who, address(this)),
740             TokenInteract.balanceOf(token, who)
741         );
742     }
743 }
744 
745 // File: contracts/margin/Vault.sol
746 
747 /**
748  * @title Vault
749  * @author dYdX
750  *
751  * Holds and transfers tokens in vaults denominated by id
752  *
753  * Vault only supports ERC20 tokens, and will not accept any tokens that require
754  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
755  */
756 contract Vault is StaticAccessControlled
757 {
758     using SafeMath for uint256;
759 
760     // ============ Events ============
761 
762     event ExcessTokensWithdrawn(
763         address indexed token,
764         address indexed to,
765         address caller
766     );
767 
768     // ============ State Variables ============
769 
770     // Address of the TokenProxy contract. Used for moving tokens.
771     address public TOKEN_PROXY;
772 
773     // Map from vault ID to map from token address to amount of that token attributed to the
774     // particular vault ID.
775     mapping (bytes32 => mapping (address => uint256)) public balances;
776 
777     // Map from token address to total amount of that token attributed to some account.
778     mapping (address => uint256) public totalBalances;
779 
780     // ============ Constructor ============
781 
782     constructor(
783         address proxy,
784         uint256 gracePeriod
785     )
786         public
787         StaticAccessControlled(gracePeriod)
788     {
789         TOKEN_PROXY = proxy;
790     }
791 
792     // ============ Owner-Only State-Changing Functions ============
793 
794     /**
795      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
796      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
797      * will be accounted for and will not be withdrawable by this function.
798      *
799      * @param  token  ERC20 token address
800      * @param  to     Address to transfer tokens to
801      * @return        Amount of tokens withdrawn
802      */
803     function withdrawExcessToken(
804         address token,
805         address to
806     )
807         external
808         onlyOwner
809         returns (uint256)
810     {
811         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
812         uint256 accountedBalance = totalBalances[token];
813         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
814 
815         require(
816             withdrawableBalance != 0,
817             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
818         );
819 
820         TokenInteract.transfer(token, to, withdrawableBalance);
821 
822         emit ExcessTokensWithdrawn(token, to, msg.sender);
823 
824         return withdrawableBalance;
825     }
826 
827     // ============ Authorized-Only State-Changing Functions ============
828 
829     /**
830      * Transfers tokens from an address (that has approved the proxy) to the vault.
831      *
832      * @param  id      The vault which will receive the tokens
833      * @param  token   ERC20 token address
834      * @param  from    Address from which the tokens will be taken
835      * @param  amount  Number of the token to be sent
836      */
837     function transferToVault(
838         bytes32 id,
839         address token,
840         address from,
841         uint256 amount
842     )
843         external
844         requiresAuthorization
845     {
846         // First send tokens to this contract
847         TokenProxy(TOKEN_PROXY).transferTokens(
848             token,
849             from,
850             address(this),
851             amount
852         );
853 
854         // Then increment balances
855         balances[id][token] = balances[id][token].add(amount);
856         totalBalances[token] = totalBalances[token].add(amount);
857 
858         // This should always be true. If not, something is very wrong
859         assert(totalBalances[token] >= balances[id][token]);
860 
861         validateBalance(token);
862     }
863 
864     /**
865      * Transfers a certain amount of funds to an address.
866      *
867      * @param  id      The vault from which to send the tokens
868      * @param  token   ERC20 token address
869      * @param  to      Address to transfer tokens to
870      * @param  amount  Number of the token to be sent
871      */
872     function transferFromVault(
873         bytes32 id,
874         address token,
875         address to,
876         uint256 amount
877     )
878         external
879         requiresAuthorization
880     {
881         // Next line also asserts that (balances[id][token] >= amount);
882         balances[id][token] = balances[id][token].sub(amount);
883 
884         // Next line also asserts that (totalBalances[token] >= amount);
885         totalBalances[token] = totalBalances[token].sub(amount);
886 
887         // This should always be true. If not, something is very wrong
888         assert(totalBalances[token] >= balances[id][token]);
889 
890         // Do the sending
891         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
892 
893         // Final validation
894         validateBalance(token);
895     }
896 
897     // ============ Private Helper-Functions ============
898 
899     /**
900      * Verifies that this contract is in control of at least as many tokens as accounted for
901      *
902      * @param  token  Address of ERC20 token
903      */
904     function validateBalance(
905         address token
906     )
907         private
908         view
909     {
910         // The actual balance could be greater than totalBalances[token] because anyone
911         // can send tokens to the contract's address which cannot be accounted for
912         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
913     }
914 }
915 
916 // File: contracts/lib/ReentrancyGuard.sol
917 
918 /**
919  * @title ReentrancyGuard
920  * @author dYdX
921  *
922  * Optimized version of the well-known ReentrancyGuard contract
923  */
924 contract ReentrancyGuard {
925     uint256 private _guardCounter = 1;
926 
927     modifier nonReentrant() {
928         uint256 localCounter = _guardCounter + 1;
929         _guardCounter = localCounter;
930         _;
931         require(
932             _guardCounter == localCounter,
933             "Reentrancy check failure"
934         );
935     }
936 }
937 
938 // File: openzeppelin-solidity/contracts/AddressUtils.sol
939 
940 /**
941  * Utility library of inline functions on addresses
942  */
943 library AddressUtils {
944 
945   /**
946    * Returns whether the target address is a contract
947    * @dev This function will return false if invoked during the constructor of a contract,
948    * as the code is not actually created until after the constructor finishes.
949    * @param _addr address to check
950    * @return whether the target address is a contract
951    */
952   function isContract(address _addr) internal view returns (bool) {
953     uint256 size;
954     // XXX Currently there is no better way to check if there is a contract in an address
955     // than to check the size of the code at that address.
956     // See https://ethereum.stackexchange.com/a/14016/36603
957     // for more details about how this works.
958     // TODO Check this again before the Serenity release, because all addresses will be
959     // contracts then.
960     // solium-disable-next-line security/no-inline-assembly
961     assembly { size := extcodesize(_addr) }
962     return size > 0;
963   }
964 
965 }
966 
967 // File: contracts/lib/Fraction.sol
968 
969 /**
970  * @title Fraction
971  * @author dYdX
972  *
973  * This library contains implementations for fraction structs.
974  */
975 library Fraction {
976     struct Fraction128 {
977         uint128 num;
978         uint128 den;
979     }
980 }
981 
982 // File: contracts/lib/FractionMath.sol
983 
984 /**
985  * @title FractionMath
986  * @author dYdX
987  *
988  * This library contains safe math functions for manipulating fractions.
989  */
990 library FractionMath {
991     using SafeMath for uint256;
992     using SafeMath for uint128;
993 
994     /**
995      * Returns a Fraction128 that is equal to a + b
996      *
997      * @param  a  The first Fraction128
998      * @param  b  The second Fraction128
999      * @return    The result (sum)
1000      */
1001     function add(
1002         Fraction.Fraction128 memory a,
1003         Fraction.Fraction128 memory b
1004     )
1005         internal
1006         pure
1007         returns (Fraction.Fraction128 memory)
1008     {
1009         uint256 left = a.num.mul(b.den);
1010         uint256 right = b.num.mul(a.den);
1011         uint256 denominator = a.den.mul(b.den);
1012 
1013         // if left + right overflows, prevent overflow
1014         if (left + right < left) {
1015             left = left.div(2);
1016             right = right.div(2);
1017             denominator = denominator.div(2);
1018         }
1019 
1020         return bound(left.add(right), denominator);
1021     }
1022 
1023     /**
1024      * Returns a Fraction128 that is equal to a - (1/2)^d
1025      *
1026      * @param  a  The Fraction128
1027      * @param  d  The power of (1/2)
1028      * @return    The result
1029      */
1030     function sub1Over(
1031         Fraction.Fraction128 memory a,
1032         uint128 d
1033     )
1034         internal
1035         pure
1036         returns (Fraction.Fraction128 memory)
1037     {
1038         if (a.den % d == 0) {
1039             return bound(
1040                 a.num.sub(a.den.div(d)),
1041                 a.den
1042             );
1043         }
1044         return bound(
1045             a.num.mul(d).sub(a.den),
1046             a.den.mul(d)
1047         );
1048     }
1049 
1050     /**
1051      * Returns a Fraction128 that is equal to a / d
1052      *
1053      * @param  a  The first Fraction128
1054      * @param  d  The divisor
1055      * @return    The result (quotient)
1056      */
1057     function div(
1058         Fraction.Fraction128 memory a,
1059         uint128 d
1060     )
1061         internal
1062         pure
1063         returns (Fraction.Fraction128 memory)
1064     {
1065         if (a.num % d == 0) {
1066             return bound(
1067                 a.num.div(d),
1068                 a.den
1069             );
1070         }
1071         return bound(
1072             a.num,
1073             a.den.mul(d)
1074         );
1075     }
1076 
1077     /**
1078      * Returns a Fraction128 that is equal to a * b.
1079      *
1080      * @param  a  The first Fraction128
1081      * @param  b  The second Fraction128
1082      * @return    The result (product)
1083      */
1084     function mul(
1085         Fraction.Fraction128 memory a,
1086         Fraction.Fraction128 memory b
1087     )
1088         internal
1089         pure
1090         returns (Fraction.Fraction128 memory)
1091     {
1092         return bound(
1093             a.num.mul(b.num),
1094             a.den.mul(b.den)
1095         );
1096     }
1097 
1098     /**
1099      * Returns a fraction from two uint256's. Fits them into uint128 if necessary.
1100      *
1101      * @param  num  The numerator
1102      * @param  den  The denominator
1103      * @return      The Fraction128 that matches num/den most closely
1104      */
1105     /* solium-disable-next-line security/no-assign-params */
1106     function bound(
1107         uint256 num,
1108         uint256 den
1109     )
1110         internal
1111         pure
1112         returns (Fraction.Fraction128 memory)
1113     {
1114         uint256 max = num > den ? num : den;
1115         uint256 first128Bits = (max >> 128);
1116         if (first128Bits != 0) {
1117             first128Bits += 1;
1118             num /= first128Bits;
1119             den /= first128Bits;
1120         }
1121 
1122         assert(den != 0); // coverage-enable-line
1123         assert(den < 2**128);
1124         assert(num < 2**128);
1125 
1126         return Fraction.Fraction128({
1127             num: uint128(num),
1128             den: uint128(den)
1129         });
1130     }
1131 
1132     /**
1133      * Returns an in-memory copy of a Fraction128
1134      *
1135      * @param  a  The Fraction128 to copy
1136      * @return    A copy of the Fraction128
1137      */
1138     function copy(
1139         Fraction.Fraction128 memory a
1140     )
1141         internal
1142         pure
1143         returns (Fraction.Fraction128 memory)
1144     {
1145         validate(a);
1146         return Fraction.Fraction128({ num: a.num, den: a.den });
1147     }
1148 
1149     // ============ Private Helper-Functions ============
1150 
1151     /**
1152      * Asserts that a Fraction128 is valid (i.e. the denominator is non-zero)
1153      *
1154      * @param  a  The Fraction128 to validate
1155      */
1156     function validate(
1157         Fraction.Fraction128 memory a
1158     )
1159         private
1160         pure
1161     {
1162         assert(a.den != 0); // coverage-enable-line
1163     }
1164 }
1165 
1166 // File: contracts/lib/Exponent.sol
1167 
1168 /**
1169  * @title Exponent
1170  * @author dYdX
1171  *
1172  * This library contains an implementation for calculating e^X for arbitrary fraction X
1173  */
1174 library Exponent {
1175     using SafeMath for uint256;
1176     using FractionMath for Fraction.Fraction128;
1177 
1178     // ============ Constants ============
1179 
1180     // 2**128 - 1
1181     uint128 constant public MAX_NUMERATOR = 340282366920938463463374607431768211455;
1182 
1183     // Number of precomputed integers, X, for E^((1/2)^X)
1184     uint256 constant public MAX_PRECOMPUTE_PRECISION = 32;
1185 
1186     // Number of precomputed integers, X, for E^X
1187     uint256 constant public NUM_PRECOMPUTED_INTEGERS = 32;
1188 
1189     // ============ Public Implementation Functions ============
1190 
1191     /**
1192      * Returns e^X for any fraction X
1193      *
1194      * @param  X                    The exponent
1195      * @param  precomputePrecision  Accuracy of precomputed terms
1196      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1197      * @return                      e^X
1198      */
1199     function exp(
1200         Fraction.Fraction128 memory X,
1201         uint256 precomputePrecision,
1202         uint256 maclaurinPrecision
1203     )
1204         internal
1205         pure
1206         returns (Fraction.Fraction128 memory)
1207     {
1208         require(
1209             precomputePrecision <= MAX_PRECOMPUTE_PRECISION,
1210             "Exponent#exp: Precompute precision over maximum"
1211         );
1212 
1213         Fraction.Fraction128 memory Xcopy = X.copy();
1214         if (Xcopy.num == 0) { // e^0 = 1
1215             return ONE();
1216         }
1217 
1218         // get the integer value of the fraction (example: 9/4 is 2.25 so has integerValue of 2)
1219         uint256 integerX = uint256(Xcopy.num).div(Xcopy.den);
1220 
1221         // if X is less than 1, then just calculate X
1222         if (integerX == 0) {
1223             return expHybrid(Xcopy, precomputePrecision, maclaurinPrecision);
1224         }
1225 
1226         // get e^integerX
1227         Fraction.Fraction128 memory expOfInt =
1228             getPrecomputedEToThe(integerX % NUM_PRECOMPUTED_INTEGERS);
1229         while (integerX >= NUM_PRECOMPUTED_INTEGERS) {
1230             expOfInt = expOfInt.mul(getPrecomputedEToThe(NUM_PRECOMPUTED_INTEGERS));
1231             integerX -= NUM_PRECOMPUTED_INTEGERS;
1232         }
1233 
1234         // multiply e^integerX by e^decimalX
1235         Fraction.Fraction128 memory decimalX = Fraction.Fraction128({
1236             num: Xcopy.num % Xcopy.den,
1237             den: Xcopy.den
1238         });
1239         return expHybrid(decimalX, precomputePrecision, maclaurinPrecision).mul(expOfInt);
1240     }
1241 
1242     /**
1243      * Returns e^X for any X < 1. Multiplies precomputed values to get close to the real value, then
1244      * Maclaurin Series approximation to reduce error.
1245      *
1246      * @param  X                    Exponent
1247      * @param  precomputePrecision  Accuracy of precomputed terms
1248      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1249      * @return                      e^X
1250      */
1251     function expHybrid(
1252         Fraction.Fraction128 memory X,
1253         uint256 precomputePrecision,
1254         uint256 maclaurinPrecision
1255     )
1256         internal
1257         pure
1258         returns (Fraction.Fraction128 memory)
1259     {
1260         assert(precomputePrecision <= MAX_PRECOMPUTE_PRECISION);
1261         assert(X.num < X.den);
1262         // will also throw if precomputePrecision is larger than the array length in getDenominator
1263 
1264         Fraction.Fraction128 memory Xtemp = X.copy();
1265         if (Xtemp.num == 0) { // e^0 = 1
1266             return ONE();
1267         }
1268 
1269         Fraction.Fraction128 memory result = ONE();
1270 
1271         uint256 d = 1; // 2^i
1272         for (uint256 i = 1; i <= precomputePrecision; i++) {
1273             d *= 2;
1274 
1275             // if Fraction > 1/d, subtract 1/d and multiply result by precomputed e^(1/d)
1276             if (d.mul(Xtemp.num) >= Xtemp.den) {
1277                 Xtemp = Xtemp.sub1Over(uint128(d));
1278                 result = result.mul(getPrecomputedEToTheHalfToThe(i));
1279             }
1280         }
1281         return result.mul(expMaclaurin(Xtemp, maclaurinPrecision));
1282     }
1283 
1284     /**
1285      * Returns e^X for any X, using Maclaurin Series approximation
1286      *
1287      * e^X = SUM(X^n / n!) for n >= 0
1288      * e^X = 1 + X/1! + X^2/2! + X^3/3! ...
1289      *
1290      * @param  X           Exponent
1291      * @param  precision   Accuracy of Maclaurin terms
1292      * @return             e^X
1293      */
1294     function expMaclaurin(
1295         Fraction.Fraction128 memory X,
1296         uint256 precision
1297     )
1298         internal
1299         pure
1300         returns (Fraction.Fraction128 memory)
1301     {
1302         Fraction.Fraction128 memory Xcopy = X.copy();
1303         if (Xcopy.num == 0) { // e^0 = 1
1304             return ONE();
1305         }
1306 
1307         Fraction.Fraction128 memory result = ONE();
1308         Fraction.Fraction128 memory Xtemp = ONE();
1309         for (uint256 i = 1; i <= precision; i++) {
1310             Xtemp = Xtemp.mul(Xcopy.div(uint128(i)));
1311             result = result.add(Xtemp);
1312         }
1313         return result;
1314     }
1315 
1316     /**
1317      * Returns a fraction roughly equaling E^((1/2)^x) for integer x
1318      */
1319     function getPrecomputedEToTheHalfToThe(
1320         uint256 x
1321     )
1322         internal
1323         pure
1324         returns (Fraction.Fraction128 memory)
1325     {
1326         assert(x <= MAX_PRECOMPUTE_PRECISION);
1327 
1328         uint128 denominator = [
1329             125182886983370532117250726298150828301,
1330             206391688497133195273760705512282642279,
1331             265012173823417992016237332255925138361,
1332             300298134811882980317033350418940119802,
1333             319665700530617779809390163992561606014,
1334             329812979126047300897653247035862915816,
1335             335006777809430963166468914297166288162,
1336             337634268532609249517744113622081347950,
1337             338955731696479810470146282672867036734,
1338             339618401537809365075354109784799900812,
1339             339950222128463181389559457827561204959,
1340             340116253979683015278260491021941090650,
1341             340199300311581465057079429423749235412,
1342             340240831081268226777032180141478221816,
1343             340261598367316729254995498374473399540,
1344             340271982485676106947851156443492415142,
1345             340277174663693808406010255284800906112,
1346             340279770782412691177936847400746725466,
1347             340281068849199706686796915841848278311,
1348             340281717884450116236033378667952410919,
1349             340282042402539547492367191008339680733,
1350             340282204661700319870089970029119685699,
1351             340282285791309720262481214385569134454,
1352             340282326356121674011576912006427792656,
1353             340282346638529464274601981200276914173,
1354             340282356779733812753265346086924801364,
1355             340282361850336100329388676752133324799,
1356             340282364385637272451648746721404212564,
1357             340282365653287865596328444437856608255,
1358             340282366287113163939555716675618384724,
1359             340282366604025813553891209601455838559,
1360             340282366762482138471739420386372790954,
1361             340282366841710300958333641874363209044
1362         ][x];
1363         return Fraction.Fraction128({
1364             num: MAX_NUMERATOR,
1365             den: denominator
1366         });
1367     }
1368 
1369     /**
1370      * Returns a fraction roughly equaling E^(x) for integer x
1371      */
1372     function getPrecomputedEToThe(
1373         uint256 x
1374     )
1375         internal
1376         pure
1377         returns (Fraction.Fraction128 memory)
1378     {
1379         assert(x <= NUM_PRECOMPUTED_INTEGERS);
1380 
1381         uint128 denominator = [
1382             340282366920938463463374607431768211455,
1383             125182886983370532117250726298150828301,
1384             46052210507670172419625860892627118820,
1385             16941661466271327126146327822211253888,
1386             6232488952727653950957829210887653621,
1387             2292804553036637136093891217529878878,
1388             843475657686456657683449904934172134,
1389             310297353591408453462393329342695980,
1390             114152017036184782947077973323212575,
1391             41994180235864621538772677139808695,
1392             15448795557622704876497742989562086,
1393             5683294276510101335127414470015662,
1394             2090767122455392675095471286328463,
1395             769150240628514374138961856925097,
1396             282954560699298259527814398449860,
1397             104093165666968799599694528310221,
1398             38293735615330848145349245349513,
1399             14087478058534870382224480725096,
1400             5182493555688763339001418388912,
1401             1906532833141383353974257736699,
1402             701374233231058797338605168652,
1403             258021160973090761055471434334,
1404             94920680509187392077350434438,
1405             34919366901332874995585576427,
1406             12846117181722897538509298435,
1407             4725822410035083116489797150,
1408             1738532907279185132707372378,
1409             639570514388029575350057932,
1410             235284843422800231081973821,
1411             86556456714490055457751527,
1412             31842340925906738090071268,
1413             11714142585413118080082437,
1414             4309392228124372433711936
1415         ][x];
1416         return Fraction.Fraction128({
1417             num: MAX_NUMERATOR,
1418             den: denominator
1419         });
1420     }
1421 
1422     // ============ Private Helper-Functions ============
1423 
1424     function ONE()
1425         private
1426         pure
1427         returns (Fraction.Fraction128 memory)
1428     {
1429         return Fraction.Fraction128({ num: 1, den: 1 });
1430     }
1431 }
1432 
1433 // File: contracts/lib/MathHelpers.sol
1434 
1435 /**
1436  * @title MathHelpers
1437  * @author dYdX
1438  *
1439  * This library helps with common math functions in Solidity
1440  */
1441 library MathHelpers {
1442     using SafeMath for uint256;
1443 
1444     /**
1445      * Calculates partial value given a numerator and denominator.
1446      *
1447      * @param  numerator    Numerator
1448      * @param  denominator  Denominator
1449      * @param  target       Value to calculate partial of
1450      * @return              target * numerator / denominator
1451      */
1452     function getPartialAmount(
1453         uint256 numerator,
1454         uint256 denominator,
1455         uint256 target
1456     )
1457         internal
1458         pure
1459         returns (uint256)
1460     {
1461         return numerator.mul(target).div(denominator);
1462     }
1463 
1464     /**
1465      * Calculates partial value given a numerator and denominator, rounded up.
1466      *
1467      * @param  numerator    Numerator
1468      * @param  denominator  Denominator
1469      * @param  target       Value to calculate partial of
1470      * @return              Rounded-up result of target * numerator / denominator
1471      */
1472     function getPartialAmountRoundedUp(
1473         uint256 numerator,
1474         uint256 denominator,
1475         uint256 target
1476     )
1477         internal
1478         pure
1479         returns (uint256)
1480     {
1481         return divisionRoundedUp(numerator.mul(target), denominator);
1482     }
1483 
1484     /**
1485      * Calculates division given a numerator and denominator, rounded up.
1486      *
1487      * @param  numerator    Numerator.
1488      * @param  denominator  Denominator.
1489      * @return              Rounded-up result of numerator / denominator
1490      */
1491     function divisionRoundedUp(
1492         uint256 numerator,
1493         uint256 denominator
1494     )
1495         internal
1496         pure
1497         returns (uint256)
1498     {
1499         assert(denominator != 0); // coverage-enable-line
1500         if (numerator == 0) {
1501             return 0;
1502         }
1503         return numerator.sub(1).div(denominator).add(1);
1504     }
1505 
1506     /**
1507      * Calculates and returns the maximum value for a uint256 in solidity
1508      *
1509      * @return  The maximum value for uint256
1510      */
1511     function maxUint256(
1512     )
1513         internal
1514         pure
1515         returns (uint256)
1516     {
1517         return 2 ** 256 - 1;
1518     }
1519 
1520     /**
1521      * Calculates and returns the maximum value for a uint256 in solidity
1522      *
1523      * @return  The maximum value for uint256
1524      */
1525     function maxUint32(
1526     )
1527         internal
1528         pure
1529         returns (uint32)
1530     {
1531         return 2 ** 32 - 1;
1532     }
1533 
1534     /**
1535      * Returns the number of bits in a uint256. That is, the lowest number, x, such that n >> x == 0
1536      *
1537      * @param  n  The uint256 to get the number of bits in
1538      * @return    The number of bits in n
1539      */
1540     function getNumBits(
1541         uint256 n
1542     )
1543         internal
1544         pure
1545         returns (uint256)
1546     {
1547         uint256 first = 0;
1548         uint256 last = 256;
1549         while (first < last) {
1550             uint256 check = (first + last) / 2;
1551             if ((n >> check) == 0) {
1552                 last = check;
1553             } else {
1554                 first = check + 1;
1555             }
1556         }
1557         assert(first <= 256);
1558         return first;
1559     }
1560 }
1561 
1562 // File: contracts/margin/impl/InterestImpl.sol
1563 
1564 /**
1565  * @title InterestImpl
1566  * @author dYdX
1567  *
1568  * A library that calculates continuously compounded interest for principal, time period, and
1569  * interest rate.
1570  */
1571 library InterestImpl {
1572     using SafeMath for uint256;
1573     using FractionMath for Fraction.Fraction128;
1574 
1575     // ============ Constants ============
1576 
1577     uint256 constant DEFAULT_PRECOMPUTE_PRECISION = 11;
1578 
1579     uint256 constant DEFAULT_MACLAURIN_PRECISION = 5;
1580 
1581     uint256 constant MAXIMUM_EXPONENT = 80;
1582 
1583     uint128 constant E_TO_MAXIUMUM_EXPONENT = 55406223843935100525711733958316613;
1584 
1585     // ============ Public Implementation Functions ============
1586 
1587     /**
1588      * Returns total tokens owed after accruing interest. Continuously compounding and accurate to
1589      * roughly 10^18 decimal places. Continuously compounding interest follows the formula:
1590      * I = P * e^(R*T)
1591      *
1592      * @param  principal           Principal of the interest calculation
1593      * @param  interestRate        Annual nominal interest percentage times 10**6.
1594      *                             (example: 5% = 5e6)
1595      * @param  secondsOfInterest   Number of seconds that interest has been accruing
1596      * @return                     Total amount of tokens owed. Greater than tokenAmount.
1597      */
1598     function getCompoundedInterest(
1599         uint256 principal,
1600         uint256 interestRate,
1601         uint256 secondsOfInterest
1602     )
1603         public
1604         pure
1605         returns (uint256)
1606     {
1607         uint256 numerator = interestRate.mul(secondsOfInterest);
1608         uint128 denominator = (10**8) * (365 * 1 days);
1609 
1610         // interestRate and secondsOfInterest should both be uint32
1611         assert(numerator < 2**128);
1612 
1613         // fraction representing (Rate * Time)
1614         Fraction.Fraction128 memory rt = Fraction.Fraction128({
1615             num: uint128(numerator),
1616             den: denominator
1617         });
1618 
1619         // calculate e^(RT)
1620         Fraction.Fraction128 memory eToRT;
1621         if (numerator.div(denominator) >= MAXIMUM_EXPONENT) {
1622             // degenerate case: cap calculation
1623             eToRT = Fraction.Fraction128({
1624                 num: E_TO_MAXIUMUM_EXPONENT,
1625                 den: 1
1626             });
1627         } else {
1628             // normal case: calculate e^(RT)
1629             eToRT = Exponent.exp(
1630                 rt,
1631                 DEFAULT_PRECOMPUTE_PRECISION,
1632                 DEFAULT_MACLAURIN_PRECISION
1633             );
1634         }
1635 
1636         // e^X for positive X should be greater-than or equal to 1
1637         assert(eToRT.num >= eToRT.den);
1638 
1639         return safeMultiplyUint256ByFraction(principal, eToRT);
1640     }
1641 
1642     // ============ Private Helper-Functions ============
1643 
1644     /**
1645      * Returns n * f, trying to prevent overflow as much as possible. Assumes that the numerator
1646      * and denominator of f are less than 2**128.
1647      */
1648     function safeMultiplyUint256ByFraction(
1649         uint256 n,
1650         Fraction.Fraction128 memory f
1651     )
1652         private
1653         pure
1654         returns (uint256)
1655     {
1656         uint256 term1 = n.div(2 ** 128); // first 128 bits
1657         uint256 term2 = n % (2 ** 128); // second 128 bits
1658 
1659         // uncommon scenario, requires n >= 2**128. calculates term1 = term1 * f
1660         if (term1 > 0) {
1661             term1 = term1.mul(f.num);
1662             uint256 numBits = MathHelpers.getNumBits(term1);
1663 
1664             // reduce rounding error by shifting all the way to the left before dividing
1665             term1 = MathHelpers.divisionRoundedUp(
1666                 term1 << (uint256(256).sub(numBits)),
1667                 f.den);
1668 
1669             // continue shifting or reduce shifting to get the right number
1670             if (numBits > 128) {
1671                 term1 = term1 << (numBits.sub(128));
1672             } else if (numBits < 128) {
1673                 term1 = term1 >> (uint256(128).sub(numBits));
1674             }
1675         }
1676 
1677         // calculates term2 = term2 * f
1678         term2 = MathHelpers.getPartialAmountRoundedUp(
1679             f.num,
1680             f.den,
1681             term2
1682         );
1683 
1684         return term1.add(term2);
1685     }
1686 }
1687 
1688 // File: contracts/margin/impl/MarginState.sol
1689 
1690 /**
1691  * @title MarginState
1692  * @author dYdX
1693  *
1694  * Contains state for the Margin contract. Also used by libraries that implement Margin functions.
1695  */
1696 library MarginState {
1697     struct State {
1698         // Address of the Vault contract
1699         address VAULT;
1700 
1701         // Address of the TokenProxy contract
1702         address TOKEN_PROXY;
1703 
1704         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1705         // already been filled.
1706         mapping (bytes32 => uint256) loanFills;
1707 
1708         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1709         // already been canceled.
1710         mapping (bytes32 => uint256) loanCancels;
1711 
1712         // Mapping from positionId -> Position, which stores all the open margin positions.
1713         mapping (bytes32 => MarginCommon.Position) positions;
1714 
1715         // Mapping from positionId -> bool, which stores whether the position has previously been
1716         // open, but is now closed.
1717         mapping (bytes32 => bool) closedPositions;
1718 
1719         // Mapping from positionId -> uint256, which stores the total amount of owedToken that has
1720         // ever been repaid to the lender for each position. Does not reset.
1721         mapping (bytes32 => uint256) totalOwedTokenRepaidToLender;
1722     }
1723 }
1724 
1725 // File: contracts/margin/interfaces/lender/LoanOwner.sol
1726 
1727 /**
1728  * @title LoanOwner
1729  * @author dYdX
1730  *
1731  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
1732  *
1733  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1734  *       to these functions
1735  */
1736 interface LoanOwner {
1737 
1738     // ============ Public Interface functions ============
1739 
1740     /**
1741      * Function a contract must implement in order to receive ownership of a loan sell via the
1742      * transferLoan function or the atomic-assign to the "owner" field in a loan offering.
1743      *
1744      * @param  from        Address of the previous owner
1745      * @param  positionId  Unique ID of the position
1746      * @return             This address to keep ownership, a different address to pass-on ownership
1747      */
1748     function receiveLoanOwnership(
1749         address from,
1750         bytes32 positionId
1751     )
1752         external
1753         /* onlyMargin */
1754         returns (address);
1755 }
1756 
1757 // File: contracts/margin/interfaces/owner/PositionOwner.sol
1758 
1759 /**
1760  * @title PositionOwner
1761  * @author dYdX
1762  *
1763  * Interface that smart contracts must implement in order to own position on behalf of other
1764  * accounts
1765  *
1766  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1767  *       to these functions
1768  */
1769 interface PositionOwner {
1770 
1771     // ============ Public Interface functions ============
1772 
1773     /**
1774      * Function a contract must implement in order to receive ownership of a position via the
1775      * transferPosition function or the atomic-assign to the "owner" field when opening a position.
1776      *
1777      * @param  from        Address of the previous owner
1778      * @param  positionId  Unique ID of the position
1779      * @return             This address to keep ownership, a different address to pass-on ownership
1780      */
1781     function receivePositionOwnership(
1782         address from,
1783         bytes32 positionId
1784     )
1785         external
1786         /* onlyMargin */
1787         returns (address);
1788 }
1789 
1790 // File: contracts/margin/impl/TransferInternal.sol
1791 
1792 /**
1793  * @title TransferInternal
1794  * @author dYdX
1795  *
1796  * This library contains the implementation for transferring ownership of loans and positions.
1797  */
1798 library TransferInternal {
1799 
1800     // ============ Events ============
1801 
1802     /**
1803      * Ownership of a loan was transferred to a new address
1804      */
1805     event LoanTransferred(
1806         bytes32 indexed positionId,
1807         address indexed from,
1808         address indexed to
1809     );
1810 
1811     /**
1812      * Ownership of a postion was transferred to a new address
1813      */
1814     event PositionTransferred(
1815         bytes32 indexed positionId,
1816         address indexed from,
1817         address indexed to
1818     );
1819 
1820     // ============ Internal Implementation Functions ============
1821 
1822     /**
1823      * Returns either the address of the new loan owner, or the address to which they wish to
1824      * pass ownership of the loan. This function does not actually set the state of the position
1825      *
1826      * @param  positionId  The Unique ID of the position
1827      * @param  oldOwner    The previous owner of the loan
1828      * @param  newOwner    The intended owner of the loan
1829      * @return             The address that the intended owner wishes to assign the loan to (may be
1830      *                     the same as the intended owner).
1831      */
1832     function grantLoanOwnership(
1833         bytes32 positionId,
1834         address oldOwner,
1835         address newOwner
1836     )
1837         internal
1838         returns (address)
1839     {
1840         // log event except upon position creation
1841         if (oldOwner != address(0)) {
1842             emit LoanTransferred(positionId, oldOwner, newOwner);
1843         }
1844 
1845         if (AddressUtils.isContract(newOwner)) {
1846             address nextOwner =
1847                 LoanOwner(newOwner).receiveLoanOwnership(oldOwner, positionId);
1848             if (nextOwner != newOwner) {
1849                 return grantLoanOwnership(positionId, newOwner, nextOwner);
1850             }
1851         }
1852 
1853         require(
1854             newOwner != address(0),
1855             "TransferInternal#grantLoanOwnership: New owner did not consent to owning loan"
1856         );
1857 
1858         return newOwner;
1859     }
1860 
1861     /**
1862      * Returns either the address of the new position owner, or the address to which they wish to
1863      * pass ownership of the position. This function does not actually set the state of the position
1864      *
1865      * @param  positionId  The Unique ID of the position
1866      * @param  oldOwner    The previous owner of the position
1867      * @param  newOwner    The intended owner of the position
1868      * @return             The address that the intended owner wishes to assign the position to (may
1869      *                     be the same as the intended owner).
1870      */
1871     function grantPositionOwnership(
1872         bytes32 positionId,
1873         address oldOwner,
1874         address newOwner
1875     )
1876         internal
1877         returns (address)
1878     {
1879         // log event except upon position creation
1880         if (oldOwner != address(0)) {
1881             emit PositionTransferred(positionId, oldOwner, newOwner);
1882         }
1883 
1884         if (AddressUtils.isContract(newOwner)) {
1885             address nextOwner =
1886                 PositionOwner(newOwner).receivePositionOwnership(oldOwner, positionId);
1887             if (nextOwner != newOwner) {
1888                 return grantPositionOwnership(positionId, newOwner, nextOwner);
1889             }
1890         }
1891 
1892         require(
1893             newOwner != address(0),
1894             "TransferInternal#grantPositionOwnership: New owner did not consent to owning position"
1895         );
1896 
1897         return newOwner;
1898     }
1899 }
1900 
1901 // File: contracts/lib/TimestampHelper.sol
1902 
1903 /**
1904  * @title TimestampHelper
1905  * @author dYdX
1906  *
1907  * Helper to get block timestamps in other formats
1908  */
1909 library TimestampHelper {
1910     function getBlockTimestamp32()
1911         internal
1912         view
1913         returns (uint32)
1914     {
1915         // Should not still be in-use in the year 2106
1916         assert(uint256(uint32(block.timestamp)) == block.timestamp);
1917 
1918         assert(block.timestamp > 0);
1919 
1920         return uint32(block.timestamp);
1921     }
1922 }
1923 
1924 // File: contracts/margin/impl/MarginCommon.sol
1925 
1926 /**
1927  * @title MarginCommon
1928  * @author dYdX
1929  *
1930  * This library contains common functions for implementations of public facing Margin functions
1931  */
1932 library MarginCommon {
1933     using SafeMath for uint256;
1934 
1935     // ============ Structs ============
1936 
1937     struct Position {
1938         address owedToken;       // Immutable
1939         address heldToken;       // Immutable
1940         address lender;
1941         address owner;
1942         uint256 principal;
1943         uint256 requiredDeposit;
1944         uint32  callTimeLimit;   // Immutable
1945         uint32  startTimestamp;  // Immutable, cannot be 0
1946         uint32  callTimestamp;
1947         uint32  maxDuration;     // Immutable
1948         uint32  interestRate;    // Immutable
1949         uint32  interestPeriod;  // Immutable
1950     }
1951 
1952     struct LoanOffering {
1953         address   owedToken;
1954         address   heldToken;
1955         address   payer;
1956         address   owner;
1957         address   taker;
1958         address   positionOwner;
1959         address   feeRecipient;
1960         address   lenderFeeToken;
1961         address   takerFeeToken;
1962         LoanRates rates;
1963         uint256   expirationTimestamp;
1964         uint32    callTimeLimit;
1965         uint32    maxDuration;
1966         uint256   salt;
1967         bytes32   loanHash;
1968         bytes     signature;
1969     }
1970 
1971     struct LoanRates {
1972         uint256 maxAmount;
1973         uint256 minAmount;
1974         uint256 minHeldToken;
1975         uint256 lenderFee;
1976         uint256 takerFee;
1977         uint32  interestRate;
1978         uint32  interestPeriod;
1979     }
1980 
1981     // ============ Internal Implementation Functions ============
1982 
1983     function storeNewPosition(
1984         MarginState.State storage state,
1985         bytes32 positionId,
1986         Position memory position,
1987         address loanPayer
1988     )
1989         internal
1990     {
1991         assert(!positionHasExisted(state, positionId));
1992         assert(position.owedToken != address(0));
1993         assert(position.heldToken != address(0));
1994         assert(position.owedToken != position.heldToken);
1995         assert(position.owner != address(0));
1996         assert(position.lender != address(0));
1997         assert(position.maxDuration != 0);
1998         assert(position.interestPeriod <= position.maxDuration);
1999         assert(position.callTimestamp == 0);
2000         assert(position.requiredDeposit == 0);
2001 
2002         state.positions[positionId].owedToken = position.owedToken;
2003         state.positions[positionId].heldToken = position.heldToken;
2004         state.positions[positionId].principal = position.principal;
2005         state.positions[positionId].callTimeLimit = position.callTimeLimit;
2006         state.positions[positionId].startTimestamp = TimestampHelper.getBlockTimestamp32();
2007         state.positions[positionId].maxDuration = position.maxDuration;
2008         state.positions[positionId].interestRate = position.interestRate;
2009         state.positions[positionId].interestPeriod = position.interestPeriod;
2010 
2011         state.positions[positionId].owner = TransferInternal.grantPositionOwnership(
2012             positionId,
2013             (position.owner != msg.sender) ? msg.sender : address(0),
2014             position.owner
2015         );
2016 
2017         state.positions[positionId].lender = TransferInternal.grantLoanOwnership(
2018             positionId,
2019             (position.lender != loanPayer) ? loanPayer : address(0),
2020             position.lender
2021         );
2022     }
2023 
2024     function getPositionIdFromNonce(
2025         uint256 nonce
2026     )
2027         internal
2028         view
2029         returns (bytes32)
2030     {
2031         return keccak256(abi.encodePacked(msg.sender, nonce));
2032     }
2033 
2034     function getUnavailableLoanOfferingAmountImpl(
2035         MarginState.State storage state,
2036         bytes32 loanHash
2037     )
2038         internal
2039         view
2040         returns (uint256)
2041     {
2042         return state.loanFills[loanHash].add(state.loanCancels[loanHash]);
2043     }
2044 
2045     function cleanupPosition(
2046         MarginState.State storage state,
2047         bytes32 positionId
2048     )
2049         internal
2050     {
2051         delete state.positions[positionId];
2052         state.closedPositions[positionId] = true;
2053     }
2054 
2055     function calculateOwedAmount(
2056         Position storage position,
2057         uint256 closeAmount,
2058         uint256 endTimestamp
2059     )
2060         internal
2061         view
2062         returns (uint256)
2063     {
2064         uint256 timeElapsed = calculateEffectiveTimeElapsed(position, endTimestamp);
2065 
2066         return InterestImpl.getCompoundedInterest(
2067             closeAmount,
2068             position.interestRate,
2069             timeElapsed
2070         );
2071     }
2072 
2073     /**
2074      * Calculates time elapsed rounded up to the nearest interestPeriod
2075      */
2076     function calculateEffectiveTimeElapsed(
2077         Position storage position,
2078         uint256 timestamp
2079     )
2080         internal
2081         view
2082         returns (uint256)
2083     {
2084         uint256 elapsed = timestamp.sub(position.startTimestamp);
2085 
2086         // round up to interestPeriod
2087         uint256 period = position.interestPeriod;
2088         if (period > 1) {
2089             elapsed = MathHelpers.divisionRoundedUp(elapsed, period).mul(period);
2090         }
2091 
2092         // bound by maxDuration
2093         return Math.min256(
2094             elapsed,
2095             position.maxDuration
2096         );
2097     }
2098 
2099     function calculateLenderAmountForIncreasePosition(
2100         Position storage position,
2101         uint256 principalToAdd,
2102         uint256 endTimestamp
2103     )
2104         internal
2105         view
2106         returns (uint256)
2107     {
2108         uint256 timeElapsed = calculateEffectiveTimeElapsedForNewLender(position, endTimestamp);
2109 
2110         return InterestImpl.getCompoundedInterest(
2111             principalToAdd,
2112             position.interestRate,
2113             timeElapsed
2114         );
2115     }
2116 
2117     function getLoanOfferingHash(
2118         LoanOffering loanOffering
2119     )
2120         internal
2121         view
2122         returns (bytes32)
2123     {
2124         return keccak256(
2125             abi.encodePacked(
2126                 address(this),
2127                 loanOffering.owedToken,
2128                 loanOffering.heldToken,
2129                 loanOffering.payer,
2130                 loanOffering.owner,
2131                 loanOffering.taker,
2132                 loanOffering.positionOwner,
2133                 loanOffering.feeRecipient,
2134                 loanOffering.lenderFeeToken,
2135                 loanOffering.takerFeeToken,
2136                 getValuesHash(loanOffering)
2137             )
2138         );
2139     }
2140 
2141     function getPositionBalanceImpl(
2142         MarginState.State storage state,
2143         bytes32 positionId
2144     )
2145         internal
2146         view
2147         returns(uint256)
2148     {
2149         return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
2150     }
2151 
2152     function containsPositionImpl(
2153         MarginState.State storage state,
2154         bytes32 positionId
2155     )
2156         internal
2157         view
2158         returns (bool)
2159     {
2160         return state.positions[positionId].startTimestamp != 0;
2161     }
2162 
2163     function positionHasExisted(
2164         MarginState.State storage state,
2165         bytes32 positionId
2166     )
2167         internal
2168         view
2169         returns (bool)
2170     {
2171         return containsPositionImpl(state, positionId) || state.closedPositions[positionId];
2172     }
2173 
2174     function getPositionFromStorage(
2175         MarginState.State storage state,
2176         bytes32 positionId
2177     )
2178         internal
2179         view
2180         returns (Position storage)
2181     {
2182         Position storage position = state.positions[positionId];
2183 
2184         require(
2185             position.startTimestamp != 0,
2186             "MarginCommon#getPositionFromStorage: The position does not exist"
2187         );
2188 
2189         return position;
2190     }
2191 
2192     // ============ Private Helper-Functions ============
2193 
2194     /**
2195      * Calculates time elapsed rounded down to the nearest interestPeriod
2196      */
2197     function calculateEffectiveTimeElapsedForNewLender(
2198         Position storage position,
2199         uint256 timestamp
2200     )
2201         private
2202         view
2203         returns (uint256)
2204     {
2205         uint256 elapsed = timestamp.sub(position.startTimestamp);
2206 
2207         // round down to interestPeriod
2208         uint256 period = position.interestPeriod;
2209         if (period > 1) {
2210             elapsed = elapsed.div(period).mul(period);
2211         }
2212 
2213         // bound by maxDuration
2214         return Math.min256(
2215             elapsed,
2216             position.maxDuration
2217         );
2218     }
2219 
2220     function getValuesHash(
2221         LoanOffering loanOffering
2222     )
2223         private
2224         pure
2225         returns (bytes32)
2226     {
2227         return keccak256(
2228             abi.encodePacked(
2229                 loanOffering.rates.maxAmount,
2230                 loanOffering.rates.minAmount,
2231                 loanOffering.rates.minHeldToken,
2232                 loanOffering.rates.lenderFee,
2233                 loanOffering.rates.takerFee,
2234                 loanOffering.expirationTimestamp,
2235                 loanOffering.salt,
2236                 loanOffering.callTimeLimit,
2237                 loanOffering.maxDuration,
2238                 loanOffering.rates.interestRate,
2239                 loanOffering.rates.interestPeriod
2240             )
2241         );
2242     }
2243 }
2244 
2245 // File: contracts/margin/interfaces/PayoutRecipient.sol
2246 
2247 /**
2248  * @title PayoutRecipient
2249  * @author dYdX
2250  *
2251  * Interface that smart contracts must implement in order to be the payoutRecipient in a
2252  * closePosition transaction.
2253  *
2254  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2255  *       to these functions
2256  */
2257 interface PayoutRecipient {
2258 
2259     // ============ Public Interface functions ============
2260 
2261     /**
2262      * Function a contract must implement in order to receive payout from being the payoutRecipient
2263      * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.
2264      *
2265      * @param  positionId         Unique ID of the position
2266      * @param  closeAmount        Amount of the position that was closed
2267      * @param  closer             Address of the account or contract that closed the position
2268      * @param  positionOwner      Address of the owner of the position
2269      * @param  heldToken          Address of the ERC20 heldToken
2270      * @param  payout             Number of tokens received from the payout
2271      * @param  totalHeldToken     Total amount of heldToken removed from vault during close
2272      * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken
2273      * @return                    True if approved by the receiver
2274      */
2275     function receiveClosePositionPayout(
2276         bytes32 positionId,
2277         uint256 closeAmount,
2278         address closer,
2279         address positionOwner,
2280         address heldToken,
2281         uint256 payout,
2282         uint256 totalHeldToken,
2283         bool    payoutInHeldToken
2284     )
2285         external
2286         /* onlyMargin */
2287         returns (bool);
2288 }
2289 
2290 // File: contracts/margin/interfaces/lender/CloseLoanDelegator.sol
2291 
2292 /**
2293  * @title CloseLoanDelegator
2294  * @author dYdX
2295  *
2296  * Interface that smart contracts must implement in order to let other addresses close a loan
2297  * owned by the smart contract.
2298  *
2299  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2300  *       to these functions
2301  */
2302 interface CloseLoanDelegator {
2303 
2304     // ============ Public Interface functions ============
2305 
2306     /**
2307      * Function a contract must implement in order to let other addresses call
2308      * closeWithoutCounterparty().
2309      *
2310      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2311      * either revert the entire transaction or that (at most) the specified amount of the loan was
2312      * successfully closed.
2313      *
2314      * @param  closer           Address of the caller of closeWithoutCounterparty()
2315      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2316      * @param  positionId       Unique ID of the position
2317      * @param  requestedAmount  Requested principal amount of the loan to close
2318      * @return                  1) This address to accept, a different address to ask that contract
2319      *                          2) The maximum amount that this contract is allowing
2320      */
2321     function closeLoanOnBehalfOf(
2322         address closer,
2323         address payoutRecipient,
2324         bytes32 positionId,
2325         uint256 requestedAmount
2326     )
2327         external
2328         /* onlyMargin */
2329         returns (address, uint256);
2330 }
2331 
2332 // File: contracts/margin/interfaces/owner/ClosePositionDelegator.sol
2333 
2334 /**
2335  * @title ClosePositionDelegator
2336  * @author dYdX
2337  *
2338  * Interface that smart contracts must implement in order to let other addresses close a position
2339  * owned by the smart contract, allowing more complex logic to control positions.
2340  *
2341  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2342  *       to these functions
2343  */
2344 interface ClosePositionDelegator {
2345 
2346     // ============ Public Interface functions ============
2347 
2348     /**
2349      * Function a contract must implement in order to let other addresses call closePosition().
2350      *
2351      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2352      * either revert the entire transaction or that (at-most) the specified amount of the position
2353      * was successfully closed.
2354      *
2355      * @param  closer           Address of the caller of the closePosition() function
2356      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2357      * @param  positionId       Unique ID of the position
2358      * @param  requestedAmount  Requested principal amount of the position to close
2359      * @return                  1) This address to accept, a different address to ask that contract
2360      *                          2) The maximum amount that this contract is allowing
2361      */
2362     function closeOnBehalfOf(
2363         address closer,
2364         address payoutRecipient,
2365         bytes32 positionId,
2366         uint256 requestedAmount
2367     )
2368         external
2369         /* onlyMargin */
2370         returns (address, uint256);
2371 }
2372 
2373 // File: contracts/margin/impl/ClosePositionShared.sol
2374 
2375 /**
2376  * @title ClosePositionShared
2377  * @author dYdX
2378  *
2379  * This library contains shared functionality between ClosePositionImpl and
2380  * CloseWithoutCounterpartyImpl
2381  */
2382 library ClosePositionShared {
2383     using SafeMath for uint256;
2384 
2385     // ============ Structs ============
2386 
2387     struct CloseTx {
2388         bytes32 positionId;
2389         uint256 originalPrincipal;
2390         uint256 closeAmount;
2391         uint256 owedTokenOwed;
2392         uint256 startingHeldTokenBalance;
2393         uint256 availableHeldToken;
2394         address payoutRecipient;
2395         address owedToken;
2396         address heldToken;
2397         address positionOwner;
2398         address positionLender;
2399         address exchangeWrapper;
2400         bool    payoutInHeldToken;
2401     }
2402 
2403     // ============ Internal Implementation Functions ============
2404 
2405     function closePositionStateUpdate(
2406         MarginState.State storage state,
2407         CloseTx memory transaction
2408     )
2409         internal
2410     {
2411         // Delete the position, or just decrease the principal
2412         if (transaction.closeAmount == transaction.originalPrincipal) {
2413             MarginCommon.cleanupPosition(state, transaction.positionId);
2414         } else {
2415             assert(
2416                 transaction.originalPrincipal == state.positions[transaction.positionId].principal
2417             );
2418             state.positions[transaction.positionId].principal =
2419                 transaction.originalPrincipal.sub(transaction.closeAmount);
2420         }
2421     }
2422 
2423     function sendTokensToPayoutRecipient(
2424         MarginState.State storage state,
2425         ClosePositionShared.CloseTx memory transaction,
2426         uint256 buybackCostInHeldToken,
2427         uint256 receivedOwedToken
2428     )
2429         internal
2430         returns (uint256)
2431     {
2432         uint256 payout;
2433 
2434         if (transaction.payoutInHeldToken) {
2435             // Send remaining heldToken to payoutRecipient
2436             payout = transaction.availableHeldToken.sub(buybackCostInHeldToken);
2437 
2438             Vault(state.VAULT).transferFromVault(
2439                 transaction.positionId,
2440                 transaction.heldToken,
2441                 transaction.payoutRecipient,
2442                 payout
2443             );
2444         } else {
2445             assert(transaction.exchangeWrapper != address(0));
2446 
2447             payout = receivedOwedToken.sub(transaction.owedTokenOwed);
2448 
2449             TokenProxy(state.TOKEN_PROXY).transferTokens(
2450                 transaction.owedToken,
2451                 transaction.exchangeWrapper,
2452                 transaction.payoutRecipient,
2453                 payout
2454             );
2455         }
2456 
2457         if (AddressUtils.isContract(transaction.payoutRecipient)) {
2458             require(
2459                 PayoutRecipient(transaction.payoutRecipient).receiveClosePositionPayout(
2460                     transaction.positionId,
2461                     transaction.closeAmount,
2462                     msg.sender,
2463                     transaction.positionOwner,
2464                     transaction.heldToken,
2465                     payout,
2466                     transaction.availableHeldToken,
2467                     transaction.payoutInHeldToken
2468                 ),
2469                 "ClosePositionShared#sendTokensToPayoutRecipient: Payout recipient does not consent"
2470             );
2471         }
2472 
2473         // The ending heldToken balance of the vault should be the starting heldToken balance
2474         // minus the available heldToken amount
2475         assert(
2476             MarginCommon.getPositionBalanceImpl(state, transaction.positionId)
2477             == transaction.startingHeldTokenBalance.sub(transaction.availableHeldToken)
2478         );
2479 
2480         return payout;
2481     }
2482 
2483     function createCloseTx(
2484         MarginState.State storage state,
2485         bytes32 positionId,
2486         uint256 requestedAmount,
2487         address payoutRecipient,
2488         address exchangeWrapper,
2489         bool payoutInHeldToken,
2490         bool isWithoutCounterparty
2491     )
2492         internal
2493         returns (CloseTx memory)
2494     {
2495         // Validate
2496         require(
2497             payoutRecipient != address(0),
2498             "ClosePositionShared#createCloseTx: Payout recipient cannot be 0"
2499         );
2500         require(
2501             requestedAmount > 0,
2502             "ClosePositionShared#createCloseTx: Requested close amount cannot be 0"
2503         );
2504 
2505         MarginCommon.Position storage position =
2506             MarginCommon.getPositionFromStorage(state, positionId);
2507 
2508         uint256 closeAmount = getApprovedAmount(
2509             position,
2510             positionId,
2511             requestedAmount,
2512             payoutRecipient,
2513             isWithoutCounterparty
2514         );
2515 
2516         return parseCloseTx(
2517             state,
2518             position,
2519             positionId,
2520             closeAmount,
2521             payoutRecipient,
2522             exchangeWrapper,
2523             payoutInHeldToken,
2524             isWithoutCounterparty
2525         );
2526     }
2527 
2528     // ============ Private Helper-Functions ============
2529 
2530     function getApprovedAmount(
2531         MarginCommon.Position storage position,
2532         bytes32 positionId,
2533         uint256 requestedAmount,
2534         address payoutRecipient,
2535         bool requireLenderApproval
2536     )
2537         private
2538         returns (uint256)
2539     {
2540         // Ensure enough principal
2541         uint256 allowedAmount = Math.min256(requestedAmount, position.principal);
2542 
2543         // Ensure owner consent
2544         allowedAmount = closePositionOnBehalfOfRecurse(
2545             position.owner,
2546             msg.sender,
2547             payoutRecipient,
2548             positionId,
2549             allowedAmount
2550         );
2551 
2552         // Ensure lender consent
2553         if (requireLenderApproval) {
2554             allowedAmount = closeLoanOnBehalfOfRecurse(
2555                 position.lender,
2556                 msg.sender,
2557                 payoutRecipient,
2558                 positionId,
2559                 allowedAmount
2560             );
2561         }
2562 
2563         assert(allowedAmount > 0);
2564         assert(allowedAmount <= position.principal);
2565         assert(allowedAmount <= requestedAmount);
2566 
2567         return allowedAmount;
2568     }
2569 
2570     function closePositionOnBehalfOfRecurse(
2571         address contractAddr,
2572         address closer,
2573         address payoutRecipient,
2574         bytes32 positionId,
2575         uint256 closeAmount
2576     )
2577         private
2578         returns (uint256)
2579     {
2580         // no need to ask for permission
2581         if (closer == contractAddr) {
2582             return closeAmount;
2583         }
2584 
2585         (
2586             address newContractAddr,
2587             uint256 newCloseAmount
2588         ) = ClosePositionDelegator(contractAddr).closeOnBehalfOf(
2589             closer,
2590             payoutRecipient,
2591             positionId,
2592             closeAmount
2593         );
2594 
2595         require(
2596             newCloseAmount <= closeAmount,
2597             "ClosePositionShared#closePositionRecurse: newCloseAmount is greater than closeAmount"
2598         );
2599         require(
2600             newCloseAmount > 0,
2601             "ClosePositionShared#closePositionRecurse: newCloseAmount is zero"
2602         );
2603 
2604         if (newContractAddr != contractAddr) {
2605             closePositionOnBehalfOfRecurse(
2606                 newContractAddr,
2607                 closer,
2608                 payoutRecipient,
2609                 positionId,
2610                 newCloseAmount
2611             );
2612         }
2613 
2614         return newCloseAmount;
2615     }
2616 
2617     function closeLoanOnBehalfOfRecurse(
2618         address contractAddr,
2619         address closer,
2620         address payoutRecipient,
2621         bytes32 positionId,
2622         uint256 closeAmount
2623     )
2624         private
2625         returns (uint256)
2626     {
2627         // no need to ask for permission
2628         if (closer == contractAddr) {
2629             return closeAmount;
2630         }
2631 
2632         (
2633             address newContractAddr,
2634             uint256 newCloseAmount
2635         ) = CloseLoanDelegator(contractAddr).closeLoanOnBehalfOf(
2636                 closer,
2637                 payoutRecipient,
2638                 positionId,
2639                 closeAmount
2640             );
2641 
2642         require(
2643             newCloseAmount <= closeAmount,
2644             "ClosePositionShared#closeLoanRecurse: newCloseAmount is greater than closeAmount"
2645         );
2646         require(
2647             newCloseAmount > 0,
2648             "ClosePositionShared#closeLoanRecurse: newCloseAmount is zero"
2649         );
2650 
2651         if (newContractAddr != contractAddr) {
2652             closeLoanOnBehalfOfRecurse(
2653                 newContractAddr,
2654                 closer,
2655                 payoutRecipient,
2656                 positionId,
2657                 newCloseAmount
2658             );
2659         }
2660 
2661         return newCloseAmount;
2662     }
2663 
2664     // ============ Parsing Functions ============
2665 
2666     function parseCloseTx(
2667         MarginState.State storage state,
2668         MarginCommon.Position storage position,
2669         bytes32 positionId,
2670         uint256 closeAmount,
2671         address payoutRecipient,
2672         address exchangeWrapper,
2673         bool payoutInHeldToken,
2674         bool isWithoutCounterparty
2675     )
2676         private
2677         view
2678         returns (CloseTx memory)
2679     {
2680         uint256 startingHeldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
2681 
2682         uint256 availableHeldToken = MathHelpers.getPartialAmount(
2683             closeAmount,
2684             position.principal,
2685             startingHeldTokenBalance
2686         );
2687         uint256 owedTokenOwed = 0;
2688 
2689         if (!isWithoutCounterparty) {
2690             owedTokenOwed = MarginCommon.calculateOwedAmount(
2691                 position,
2692                 closeAmount,
2693                 block.timestamp
2694             );
2695         }
2696 
2697         return CloseTx({
2698             positionId: positionId,
2699             originalPrincipal: position.principal,
2700             closeAmount: closeAmount,
2701             owedTokenOwed: owedTokenOwed,
2702             startingHeldTokenBalance: startingHeldTokenBalance,
2703             availableHeldToken: availableHeldToken,
2704             payoutRecipient: payoutRecipient,
2705             owedToken: position.owedToken,
2706             heldToken: position.heldToken,
2707             positionOwner: position.owner,
2708             positionLender: position.lender,
2709             exchangeWrapper: exchangeWrapper,
2710             payoutInHeldToken: payoutInHeldToken
2711         });
2712     }
2713 }
2714 
2715 // File: contracts/margin/interfaces/ExchangeWrapper.sol
2716 
2717 /**
2718  * @title ExchangeWrapper
2719  * @author dYdX
2720  *
2721  * Contract interface that Exchange Wrapper smart contracts must implement in order to interface
2722  * with other smart contracts through a common interface.
2723  */
2724 interface ExchangeWrapper {
2725 
2726     // ============ Public Functions ============
2727 
2728     /**
2729      * Exchange some amount of takerToken for makerToken.
2730      *
2731      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
2732      *                              cannot always be trusted as it is set at the discretion of the
2733      *                              msg.sender)
2734      * @param  receiver             Address to set allowance on once the trade has completed
2735      * @param  makerToken           Address of makerToken, the token to receive
2736      * @param  takerToken           Address of takerToken, the token to pay
2737      * @param  requestedFillAmount  Amount of takerToken being paid
2738      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
2739      * @return                      The amount of makerToken received
2740      */
2741     function exchange(
2742         address tradeOriginator,
2743         address receiver,
2744         address makerToken,
2745         address takerToken,
2746         uint256 requestedFillAmount,
2747         bytes orderData
2748     )
2749         external
2750         returns (uint256);
2751 
2752     /**
2753      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
2754      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
2755      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
2756      * than desiredMakerToken
2757      *
2758      * @param  makerToken         Address of makerToken, the token to receive
2759      * @param  takerToken         Address of takerToken, the token to pay
2760      * @param  desiredMakerToken  Amount of makerToken requested
2761      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
2762      * @return                    Amount of takerToken the needed to complete the transaction
2763      */
2764     function getExchangeCost(
2765         address makerToken,
2766         address takerToken,
2767         uint256 desiredMakerToken,
2768         bytes orderData
2769     )
2770         external
2771         view
2772         returns (uint256);
2773 }
2774 
2775 // File: contracts/margin/impl/ClosePositionImpl.sol
2776 
2777 /**
2778  * @title ClosePositionImpl
2779  * @author dYdX
2780  *
2781  * This library contains the implementation for the closePosition function of Margin
2782  */
2783 library ClosePositionImpl {
2784     using SafeMath for uint256;
2785 
2786     // ============ Events ============
2787 
2788     /**
2789      * A position was closed or partially closed
2790      */
2791     event PositionClosed(
2792         bytes32 indexed positionId,
2793         address indexed closer,
2794         address indexed payoutRecipient,
2795         uint256 closeAmount,
2796         uint256 remainingAmount,
2797         uint256 owedTokenPaidToLender,
2798         uint256 payoutAmount,
2799         uint256 buybackCostInHeldToken,
2800         bool    payoutInHeldToken
2801     );
2802 
2803     // ============ Public Implementation Functions ============
2804 
2805     function closePositionImpl(
2806         MarginState.State storage state,
2807         bytes32 positionId,
2808         uint256 requestedCloseAmount,
2809         address payoutRecipient,
2810         address exchangeWrapper,
2811         bool payoutInHeldToken,
2812         bytes memory orderData
2813     )
2814         public
2815         returns (uint256, uint256, uint256)
2816     {
2817         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2818             state,
2819             positionId,
2820             requestedCloseAmount,
2821             payoutRecipient,
2822             exchangeWrapper,
2823             payoutInHeldToken,
2824             false
2825         );
2826 
2827         (
2828             uint256 buybackCostInHeldToken,
2829             uint256 receivedOwedToken
2830         ) = returnOwedTokensToLender(
2831             state,
2832             transaction,
2833             orderData
2834         );
2835 
2836         uint256 payout = ClosePositionShared.sendTokensToPayoutRecipient(
2837             state,
2838             transaction,
2839             buybackCostInHeldToken,
2840             receivedOwedToken
2841         );
2842 
2843         ClosePositionShared.closePositionStateUpdate(state, transaction);
2844 
2845         logEventOnClose(
2846             transaction,
2847             buybackCostInHeldToken,
2848             payout
2849         );
2850 
2851         return (
2852             transaction.closeAmount,
2853             payout,
2854             transaction.owedTokenOwed
2855         );
2856     }
2857 
2858     // ============ Private Helper-Functions ============
2859 
2860     function returnOwedTokensToLender(
2861         MarginState.State storage state,
2862         ClosePositionShared.CloseTx memory transaction,
2863         bytes memory orderData
2864     )
2865         private
2866         returns (uint256, uint256)
2867     {
2868         uint256 buybackCostInHeldToken = 0;
2869         uint256 receivedOwedToken = 0;
2870         uint256 lenderOwedToken = transaction.owedTokenOwed;
2871 
2872         // Setting exchangeWrapper to 0x000... indicates owedToken should be taken directly
2873         // from msg.sender
2874         if (transaction.exchangeWrapper == address(0)) {
2875             require(
2876                 transaction.payoutInHeldToken,
2877                 "ClosePositionImpl#returnOwedTokensToLender: Cannot payout in owedToken"
2878             );
2879 
2880             // No DEX Order; send owedTokens directly from the closer to the lender
2881             TokenProxy(state.TOKEN_PROXY).transferTokens(
2882                 transaction.owedToken,
2883                 msg.sender,
2884                 transaction.positionLender,
2885                 lenderOwedToken
2886             );
2887         } else {
2888             // Buy back owedTokens using DEX Order and send to lender
2889             (buybackCostInHeldToken, receivedOwedToken) = buyBackOwedToken(
2890                 state,
2891                 transaction,
2892                 orderData
2893             );
2894 
2895             // If no owedToken needed for payout: give lender all owedToken, even if more than owed
2896             if (transaction.payoutInHeldToken) {
2897                 assert(receivedOwedToken >= lenderOwedToken);
2898                 lenderOwedToken = receivedOwedToken;
2899             }
2900 
2901             // Transfer owedToken from the exchange wrapper to the lender
2902             TokenProxy(state.TOKEN_PROXY).transferTokens(
2903                 transaction.owedToken,
2904                 transaction.exchangeWrapper,
2905                 transaction.positionLender,
2906                 lenderOwedToken
2907             );
2908         }
2909 
2910         state.totalOwedTokenRepaidToLender[transaction.positionId] =
2911             state.totalOwedTokenRepaidToLender[transaction.positionId].add(lenderOwedToken);
2912 
2913         return (buybackCostInHeldToken, receivedOwedToken);
2914     }
2915 
2916     function buyBackOwedToken(
2917         MarginState.State storage state,
2918         ClosePositionShared.CloseTx transaction,
2919         bytes memory orderData
2920     )
2921         private
2922         returns (uint256, uint256)
2923     {
2924         // Ask the exchange wrapper the cost in heldToken to buy back the close
2925         // amount of owedToken
2926         uint256 buybackCostInHeldToken;
2927 
2928         if (transaction.payoutInHeldToken) {
2929             buybackCostInHeldToken = ExchangeWrapper(transaction.exchangeWrapper)
2930                 .getExchangeCost(
2931                     transaction.owedToken,
2932                     transaction.heldToken,
2933                     transaction.owedTokenOwed,
2934                     orderData
2935                 );
2936 
2937             // Require enough available heldToken to pay for the buyback
2938             require(
2939                 buybackCostInHeldToken <= transaction.availableHeldToken,
2940                 "ClosePositionImpl#buyBackOwedToken: Not enough available heldToken"
2941             );
2942         } else {
2943             buybackCostInHeldToken = transaction.availableHeldToken;
2944         }
2945 
2946         // Send the requisite heldToken to do the buyback from vault to exchange wrapper
2947         Vault(state.VAULT).transferFromVault(
2948             transaction.positionId,
2949             transaction.heldToken,
2950             transaction.exchangeWrapper,
2951             buybackCostInHeldToken
2952         );
2953 
2954         // Trade the heldToken for the owedToken
2955         uint256 receivedOwedToken = ExchangeWrapper(transaction.exchangeWrapper).exchange(
2956             msg.sender,
2957             state.TOKEN_PROXY,
2958             transaction.owedToken,
2959             transaction.heldToken,
2960             buybackCostInHeldToken,
2961             orderData
2962         );
2963 
2964         require(
2965             receivedOwedToken >= transaction.owedTokenOwed,
2966             "ClosePositionImpl#buyBackOwedToken: Did not receive enough owedToken"
2967         );
2968 
2969         return (buybackCostInHeldToken, receivedOwedToken);
2970     }
2971 
2972     function logEventOnClose(
2973         ClosePositionShared.CloseTx transaction,
2974         uint256 buybackCostInHeldToken,
2975         uint256 payout
2976     )
2977         private
2978     {
2979         emit PositionClosed(
2980             transaction.positionId,
2981             msg.sender,
2982             transaction.payoutRecipient,
2983             transaction.closeAmount,
2984             transaction.originalPrincipal.sub(transaction.closeAmount),
2985             transaction.owedTokenOwed,
2986             payout,
2987             buybackCostInHeldToken,
2988             transaction.payoutInHeldToken
2989         );
2990     }
2991 
2992 }
2993 
2994 // File: contracts/margin/impl/CloseWithoutCounterpartyImpl.sol
2995 
2996 /**
2997  * @title CloseWithoutCounterpartyImpl
2998  * @author dYdX
2999  *
3000  * This library contains the implementation for the closeWithoutCounterpartyImpl function of
3001  * Margin
3002  */
3003 library CloseWithoutCounterpartyImpl {
3004     using SafeMath for uint256;
3005 
3006     // ============ Events ============
3007 
3008     /**
3009      * A position was closed or partially closed
3010      */
3011     event PositionClosed(
3012         bytes32 indexed positionId,
3013         address indexed closer,
3014         address indexed payoutRecipient,
3015         uint256 closeAmount,
3016         uint256 remainingAmount,
3017         uint256 owedTokenPaidToLender,
3018         uint256 payoutAmount,
3019         uint256 buybackCostInHeldToken,
3020         bool payoutInHeldToken
3021     );
3022 
3023     // ============ Public Implementation Functions ============
3024 
3025     function closeWithoutCounterpartyImpl(
3026         MarginState.State storage state,
3027         bytes32 positionId,
3028         uint256 requestedCloseAmount,
3029         address payoutRecipient
3030     )
3031         public
3032         returns (uint256, uint256)
3033     {
3034         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
3035             state,
3036             positionId,
3037             requestedCloseAmount,
3038             payoutRecipient,
3039             address(0),
3040             true,
3041             true
3042         );
3043 
3044         uint256 heldTokenPayout = ClosePositionShared.sendTokensToPayoutRecipient(
3045             state,
3046             transaction,
3047             0, // No buyback cost
3048             0  // Did not receive any owedToken
3049         );
3050 
3051         ClosePositionShared.closePositionStateUpdate(state, transaction);
3052 
3053         logEventOnCloseWithoutCounterparty(transaction);
3054 
3055         return (
3056             transaction.closeAmount,
3057             heldTokenPayout
3058         );
3059     }
3060 
3061     // ============ Private Helper-Functions ============
3062 
3063     function logEventOnCloseWithoutCounterparty(
3064         ClosePositionShared.CloseTx transaction
3065     )
3066         private
3067     {
3068         emit PositionClosed(
3069             transaction.positionId,
3070             msg.sender,
3071             transaction.payoutRecipient,
3072             transaction.closeAmount,
3073             transaction.originalPrincipal.sub(transaction.closeAmount),
3074             0,
3075             transaction.availableHeldToken,
3076             0,
3077             true
3078         );
3079     }
3080 }
3081 
3082 // File: contracts/margin/interfaces/owner/DepositCollateralDelegator.sol
3083 
3084 /**
3085  * @title DepositCollateralDelegator
3086  * @author dYdX
3087  *
3088  * Interface that smart contracts must implement in order to let other addresses deposit heldTokens
3089  * into a position owned by the smart contract.
3090  *
3091  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3092  *       to these functions
3093  */
3094 interface DepositCollateralDelegator {
3095 
3096     // ============ Public Interface functions ============
3097 
3098     /**
3099      * Function a contract must implement in order to let other addresses call depositCollateral().
3100      *
3101      * @param  depositor   Address of the caller of the depositCollateral() function
3102      * @param  positionId  Unique ID of the position
3103      * @param  amount      Requested deposit amount
3104      * @return             This address to accept, a different address to ask that contract
3105      */
3106     function depositCollateralOnBehalfOf(
3107         address depositor,
3108         bytes32 positionId,
3109         uint256 amount
3110     )
3111         external
3112         /* onlyMargin */
3113         returns (address);
3114 }
3115 
3116 // File: contracts/margin/impl/DepositCollateralImpl.sol
3117 
3118 /**
3119  * @title DepositCollateralImpl
3120  * @author dYdX
3121  *
3122  * This library contains the implementation for the deposit function of Margin
3123  */
3124 library DepositCollateralImpl {
3125     using SafeMath for uint256;
3126 
3127     // ============ Events ============
3128 
3129     /**
3130      * Additional collateral for a position was posted by the owner
3131      */
3132     event AdditionalCollateralDeposited(
3133         bytes32 indexed positionId,
3134         uint256 amount,
3135         address depositor
3136     );
3137 
3138     /**
3139      * A margin call was canceled
3140      */
3141     event MarginCallCanceled(
3142         bytes32 indexed positionId,
3143         address indexed lender,
3144         address indexed owner,
3145         uint256 depositAmount
3146     );
3147 
3148     // ============ Public Implementation Functions ============
3149 
3150     function depositCollateralImpl(
3151         MarginState.State storage state,
3152         bytes32 positionId,
3153         uint256 depositAmount
3154     )
3155         public
3156     {
3157         MarginCommon.Position storage position =
3158             MarginCommon.getPositionFromStorage(state, positionId);
3159 
3160         require(
3161             depositAmount > 0,
3162             "DepositCollateralImpl#depositCollateralImpl: Deposit amount cannot be 0"
3163         );
3164 
3165         // Ensure owner consent
3166         depositCollateralOnBehalfOfRecurse(
3167             position.owner,
3168             msg.sender,
3169             positionId,
3170             depositAmount
3171         );
3172 
3173         Vault(state.VAULT).transferToVault(
3174             positionId,
3175             position.heldToken,
3176             msg.sender,
3177             depositAmount
3178         );
3179 
3180         // cancel margin call if applicable
3181         bool marginCallCanceled = false;
3182         uint256 requiredDeposit = position.requiredDeposit;
3183         if (position.callTimestamp > 0 && requiredDeposit > 0) {
3184             if (depositAmount >= requiredDeposit) {
3185                 position.requiredDeposit = 0;
3186                 position.callTimestamp = 0;
3187                 marginCallCanceled = true;
3188             } else {
3189                 position.requiredDeposit = position.requiredDeposit.sub(depositAmount);
3190             }
3191         }
3192 
3193         emit AdditionalCollateralDeposited(
3194             positionId,
3195             depositAmount,
3196             msg.sender
3197         );
3198 
3199         if (marginCallCanceled) {
3200             emit MarginCallCanceled(
3201                 positionId,
3202                 position.lender,
3203                 msg.sender,
3204                 depositAmount
3205             );
3206         }
3207     }
3208 
3209     // ============ Private Helper-Functions ============
3210 
3211     function depositCollateralOnBehalfOfRecurse(
3212         address contractAddr,
3213         address depositor,
3214         bytes32 positionId,
3215         uint256 amount
3216     )
3217         private
3218     {
3219         // no need to ask for permission
3220         if (depositor == contractAddr) {
3221             return;
3222         }
3223 
3224         address newContractAddr =
3225             DepositCollateralDelegator(contractAddr).depositCollateralOnBehalfOf(
3226                 depositor,
3227                 positionId,
3228                 amount
3229             );
3230 
3231         // if not equal, recurse
3232         if (newContractAddr != contractAddr) {
3233             depositCollateralOnBehalfOfRecurse(
3234                 newContractAddr,
3235                 depositor,
3236                 positionId,
3237                 amount
3238             );
3239         }
3240     }
3241 }
3242 
3243 // File: contracts/margin/interfaces/lender/ForceRecoverCollateralDelegator.sol
3244 
3245 /**
3246  * @title ForceRecoverCollateralDelegator
3247  * @author dYdX
3248  *
3249  * Interface that smart contracts must implement in order to let other addresses
3250  * forceRecoverCollateral() a loan owned by the smart contract.
3251  *
3252  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3253  *       to these functions
3254  */
3255 interface ForceRecoverCollateralDelegator {
3256 
3257     // ============ Public Interface functions ============
3258 
3259     /**
3260      * Function a contract must implement in order to let other addresses call
3261      * forceRecoverCollateral().
3262      *
3263      * NOTE: If not returning zero address (or not reverting), this contract must assume that Margin
3264      * will either revert the entire transaction or that the collateral was forcibly recovered.
3265      *
3266      * @param  recoverer   Address of the caller of the forceRecoverCollateral() function
3267      * @param  positionId  Unique ID of the position
3268      * @param  recipient   Address to send the recovered tokens to
3269      * @return             This address to accept, a different address to ask that contract
3270      */
3271     function forceRecoverCollateralOnBehalfOf(
3272         address recoverer,
3273         bytes32 positionId,
3274         address recipient
3275     )
3276         external
3277         /* onlyMargin */
3278         returns (address);
3279 }
3280 
3281 // File: contracts/margin/impl/ForceRecoverCollateralImpl.sol
3282 
3283 /* solium-disable-next-line max-len*/
3284 
3285 /**
3286  * @title ForceRecoverCollateralImpl
3287  * @author dYdX
3288  *
3289  * This library contains the implementation for the forceRecoverCollateral function of Margin
3290  */
3291 library ForceRecoverCollateralImpl {
3292     using SafeMath for uint256;
3293 
3294     // ============ Events ============
3295 
3296     /**
3297      * Collateral for a position was forcibly recovered
3298      */
3299     event CollateralForceRecovered(
3300         bytes32 indexed positionId,
3301         address indexed recipient,
3302         uint256 amount
3303     );
3304 
3305     // ============ Public Implementation Functions ============
3306 
3307     function forceRecoverCollateralImpl(
3308         MarginState.State storage state,
3309         bytes32 positionId,
3310         address recipient
3311     )
3312         public
3313         returns (uint256)
3314     {
3315         MarginCommon.Position storage position =
3316             MarginCommon.getPositionFromStorage(state, positionId);
3317 
3318         // Can only force recover after either:
3319         // 1) The loan was called and the call period has elapsed
3320         // 2) The maxDuration of the position has elapsed
3321         require( /* solium-disable-next-line */
3322             (
3323                 position.callTimestamp > 0
3324                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3325             ) || (
3326                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3327             ),
3328             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3329         );
3330 
3331         // Ensure lender consent
3332         forceRecoverCollateralOnBehalfOfRecurse(
3333             position.lender,
3334             msg.sender,
3335             positionId,
3336             recipient
3337         );
3338 
3339         // Send the tokens
3340         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3341         Vault(state.VAULT).transferFromVault(
3342             positionId,
3343             position.heldToken,
3344             recipient,
3345             heldTokenRecovered
3346         );
3347 
3348         // Delete the position
3349         // NOTE: Since position is a storage pointer, this will also set all fields on
3350         //       the position variable to 0
3351         MarginCommon.cleanupPosition(
3352             state,
3353             positionId
3354         );
3355 
3356         // Log an event
3357         emit CollateralForceRecovered(
3358             positionId,
3359             recipient,
3360             heldTokenRecovered
3361         );
3362 
3363         return heldTokenRecovered;
3364     }
3365 
3366     // ============ Private Helper-Functions ============
3367 
3368     function forceRecoverCollateralOnBehalfOfRecurse(
3369         address contractAddr,
3370         address recoverer,
3371         bytes32 positionId,
3372         address recipient
3373     )
3374         private
3375     {
3376         // no need to ask for permission
3377         if (recoverer == contractAddr) {
3378             return;
3379         }
3380 
3381         address newContractAddr =
3382             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3383                 recoverer,
3384                 positionId,
3385                 recipient
3386             );
3387 
3388         if (newContractAddr != contractAddr) {
3389             forceRecoverCollateralOnBehalfOfRecurse(
3390                 newContractAddr,
3391                 recoverer,
3392                 positionId,
3393                 recipient
3394             );
3395         }
3396     }
3397 }
3398 
3399 // File: contracts/lib/TypedSignature.sol
3400 
3401 /**
3402  * @title TypedSignature
3403  * @author dYdX
3404  *
3405  * Allows for ecrecovery of signed hashes with three different prepended messages:
3406  * 1) ""
3407  * 2) "\x19Ethereum Signed Message:\n32"
3408  * 3) "\x19Ethereum Signed Message:\n\x20"
3409  */
3410 library TypedSignature {
3411 
3412     // Solidity does not offer guarantees about enum values, so we define them explicitly
3413     uint8 private constant SIGTYPE_INVALID = 0;
3414     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3415     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3416     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3417 
3418     // prepended message with the length of the signed hash in hexadecimal
3419     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3420 
3421     // prepended message with the length of the signed hash in decimal
3422     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3423 
3424     /**
3425      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3426      *
3427      * @param  hash               Hash that was signed (does not include prepended message)
3428      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3429      * @return                    address of the signer of the hash
3430      */
3431     function recover(
3432         bytes32 hash,
3433         bytes signatureWithType
3434     )
3435         internal
3436         pure
3437         returns (address)
3438     {
3439         require(
3440             signatureWithType.length == 66,
3441             "SignatureValidator#validateSignature: invalid signature length"
3442         );
3443 
3444         uint8 sigType = uint8(signatureWithType[0]);
3445 
3446         require(
3447             sigType > uint8(SIGTYPE_INVALID),
3448             "SignatureValidator#validateSignature: invalid signature type"
3449         );
3450         require(
3451             sigType < uint8(SIGTYPE_UNSUPPORTED),
3452             "SignatureValidator#validateSignature: unsupported signature type"
3453         );
3454 
3455         uint8 v = uint8(signatureWithType[1]);
3456         bytes32 r;
3457         bytes32 s;
3458 
3459         /* solium-disable-next-line security/no-inline-assembly */
3460         assembly {
3461             r := mload(add(signatureWithType, 34))
3462             s := mload(add(signatureWithType, 66))
3463         }
3464 
3465         bytes32 signedHash;
3466         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3467             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3468         } else {
3469             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3470             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3471         }
3472 
3473         return ecrecover(
3474             signedHash,
3475             v,
3476             r,
3477             s
3478         );
3479     }
3480 }
3481 
3482 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3483 
3484 /**
3485  * @title LoanOfferingVerifier
3486  * @author dYdX
3487  *
3488  * Interface that smart contracts must implement to be able to make off-chain generated
3489  * loan offerings.
3490  *
3491  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3492  *       to these functions
3493  */
3494 interface LoanOfferingVerifier {
3495 
3496     /**
3497      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3498      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3499      * position.
3500      *
3501      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3502      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3503      * state on a loan.
3504      *
3505      * @param  addresses    Array of addresses:
3506      *
3507      *  [0] = owedToken
3508      *  [1] = heldToken
3509      *  [2] = loan payer
3510      *  [3] = loan owner
3511      *  [4] = loan taker
3512      *  [5] = loan positionOwner
3513      *  [6] = loan fee recipient
3514      *  [7] = loan lender fee token
3515      *  [8] = loan taker fee token
3516      *
3517      * @param  values256    Values corresponding to:
3518      *
3519      *  [0] = loan maximum amount
3520      *  [1] = loan minimum amount
3521      *  [2] = loan minimum heldToken
3522      *  [3] = loan lender fee
3523      *  [4] = loan taker fee
3524      *  [5] = loan expiration timestamp (in seconds)
3525      *  [6] = loan salt
3526      *
3527      * @param  values32     Values corresponding to:
3528      *
3529      *  [0] = loan call time limit (in seconds)
3530      *  [1] = loan maxDuration (in seconds)
3531      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3532      *  [3] = loan interest update period (in seconds)
3533      *
3534      * @param  positionId   Unique ID of the position
3535      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3536      * @return              This address to accept, a different address to ask that contract
3537      */
3538     function verifyLoanOffering(
3539         address[9] addresses,
3540         uint256[7] values256,
3541         uint32[4] values32,
3542         bytes32 positionId,
3543         bytes signature
3544     )
3545         external
3546         /* onlyMargin */
3547         returns (address);
3548 }
3549 
3550 // File: contracts/margin/impl/BorrowShared.sol
3551 
3552 /**
3553  * @title BorrowShared
3554  * @author dYdX
3555  *
3556  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3557  * Both use a Loan Offering and a DEX Order to open or increase a position.
3558  */
3559 library BorrowShared {
3560     using SafeMath for uint256;
3561 
3562     // ============ Structs ============
3563 
3564     struct Tx {
3565         bytes32 positionId;
3566         address owner;
3567         uint256 principal;
3568         uint256 lenderAmount;
3569         MarginCommon.LoanOffering loanOffering;
3570         address exchangeWrapper;
3571         bool depositInHeldToken;
3572         uint256 depositAmount;
3573         uint256 collateralAmount;
3574         uint256 heldTokenFromSell;
3575     }
3576 
3577     // ============ Internal Implementation Functions ============
3578 
3579     /**
3580      * Validate the transaction before exchanging heldToken for owedToken
3581      */
3582     function validateTxPreSell(
3583         MarginState.State storage state,
3584         Tx memory transaction
3585     )
3586         internal
3587     {
3588         assert(transaction.lenderAmount >= transaction.principal);
3589 
3590         require(
3591             transaction.principal > 0,
3592             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3593         );
3594 
3595         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3596         if (transaction.loanOffering.taker != address(0)) {
3597             require(
3598                 msg.sender == transaction.loanOffering.taker,
3599                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3600             );
3601         }
3602 
3603         // If the positionOwner is 0x0 then any address can be set as the position owner.
3604         // Otherwise only the specified positionOwner can be set as the position owner.
3605         if (transaction.loanOffering.positionOwner != address(0)) {
3606             require(
3607                 transaction.owner == transaction.loanOffering.positionOwner,
3608                 "BorrowShared#validateTxPreSell: Invalid position owner"
3609             );
3610         }
3611 
3612         // Require the loan offering to be approved by the payer
3613         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3614             getConsentFromSmartContractLender(transaction);
3615         } else {
3616             require(
3617                 transaction.loanOffering.payer == TypedSignature.recover(
3618                     transaction.loanOffering.loanHash,
3619                     transaction.loanOffering.signature
3620                 ),
3621                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3622             );
3623         }
3624 
3625         // Validate the amount is <= than max and >= min
3626         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3627             state,
3628             transaction.loanOffering.loanHash
3629         );
3630         require(
3631             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3632             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3633         );
3634 
3635         require(
3636             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3637             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3638         );
3639 
3640         require(
3641             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3642             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3643         );
3644 
3645         require(
3646             transaction.owner != address(0),
3647             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3648         );
3649 
3650         require(
3651             transaction.loanOffering.owner != address(0),
3652             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3653         );
3654 
3655         require(
3656             transaction.loanOffering.expirationTimestamp > block.timestamp,
3657             "BorrowShared#validateTxPreSell: Loan offering is expired"
3658         );
3659 
3660         require(
3661             transaction.loanOffering.maxDuration > 0,
3662             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3663         );
3664 
3665         require(
3666             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3667             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3668         );
3669 
3670         // The minimum heldToken is validated after executing the sell
3671         // Position and loan ownership is validated in TransferInternal
3672     }
3673 
3674     /**
3675      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3676      * how much of the loan was used.
3677      */
3678     function doPostSell(
3679         MarginState.State storage state,
3680         Tx memory transaction
3681     )
3682         internal
3683     {
3684         validateTxPostSell(transaction);
3685 
3686         // Transfer feeTokens from trader and lender
3687         transferLoanFees(state, transaction);
3688 
3689         // Update global amounts for the loan
3690         state.loanFills[transaction.loanOffering.loanHash] =
3691             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3692     }
3693 
3694     /**
3695      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3696      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3697      * maxHeldTokenToBuy of heldTokens at most.
3698      */
3699     function doSell(
3700         MarginState.State storage state,
3701         Tx transaction,
3702         bytes orderData,
3703         uint256 maxHeldTokenToBuy
3704     )
3705         internal
3706         returns (uint256)
3707     {
3708         // Move owedTokens from lender to exchange wrapper
3709         pullOwedTokensFromLender(state, transaction);
3710 
3711         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3712         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3713         uint256 sellAmount = transaction.depositInHeldToken ?
3714             transaction.lenderAmount :
3715             transaction.lenderAmount.add(transaction.depositAmount);
3716 
3717         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3718         uint256 heldTokenFromSell = Math.min256(
3719             maxHeldTokenToBuy,
3720             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3721                 msg.sender,
3722                 state.TOKEN_PROXY,
3723                 transaction.loanOffering.heldToken,
3724                 transaction.loanOffering.owedToken,
3725                 sellAmount,
3726                 orderData
3727             )
3728         );
3729 
3730         // Move the tokens to the vault
3731         Vault(state.VAULT).transferToVault(
3732             transaction.positionId,
3733             transaction.loanOffering.heldToken,
3734             transaction.exchangeWrapper,
3735             heldTokenFromSell
3736         );
3737 
3738         // Update collateral amount
3739         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3740 
3741         return heldTokenFromSell;
3742     }
3743 
3744     /**
3745      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3746      * be sold for heldToken.
3747      */
3748     function doDepositOwedToken(
3749         MarginState.State storage state,
3750         Tx transaction
3751     )
3752         internal
3753     {
3754         TokenProxy(state.TOKEN_PROXY).transferTokens(
3755             transaction.loanOffering.owedToken,
3756             msg.sender,
3757             transaction.exchangeWrapper,
3758             transaction.depositAmount
3759         );
3760     }
3761 
3762     /**
3763      * Take the heldToken deposit from the trader and move it to the vault.
3764      */
3765     function doDepositHeldToken(
3766         MarginState.State storage state,
3767         Tx transaction
3768     )
3769         internal
3770     {
3771         Vault(state.VAULT).transferToVault(
3772             transaction.positionId,
3773             transaction.loanOffering.heldToken,
3774             msg.sender,
3775             transaction.depositAmount
3776         );
3777 
3778         // Update collateral amount
3779         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3780     }
3781 
3782     // ============ Private Helper-Functions ============
3783 
3784     function validateTxPostSell(
3785         Tx transaction
3786     )
3787         private
3788         pure
3789     {
3790         uint256 expectedCollateral = transaction.depositInHeldToken ?
3791             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3792             transaction.heldTokenFromSell;
3793         assert(transaction.collateralAmount == expectedCollateral);
3794 
3795         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3796             transaction.lenderAmount,
3797             transaction.loanOffering.rates.maxAmount,
3798             transaction.loanOffering.rates.minHeldToken
3799         );
3800         require(
3801             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3802             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3803         );
3804     }
3805 
3806     function getConsentFromSmartContractLender(
3807         Tx transaction
3808     )
3809         private
3810     {
3811         verifyLoanOfferingRecurse(
3812             transaction.loanOffering.payer,
3813             getLoanOfferingAddresses(transaction),
3814             getLoanOfferingValues256(transaction),
3815             getLoanOfferingValues32(transaction),
3816             transaction.positionId,
3817             transaction.loanOffering.signature
3818         );
3819     }
3820 
3821     function verifyLoanOfferingRecurse(
3822         address contractAddr,
3823         address[9] addresses,
3824         uint256[7] values256,
3825         uint32[4] values32,
3826         bytes32 positionId,
3827         bytes signature
3828     )
3829         private
3830     {
3831         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3832             addresses,
3833             values256,
3834             values32,
3835             positionId,
3836             signature
3837         );
3838 
3839         if (newContractAddr != contractAddr) {
3840             verifyLoanOfferingRecurse(
3841                 newContractAddr,
3842                 addresses,
3843                 values256,
3844                 values32,
3845                 positionId,
3846                 signature
3847             );
3848         }
3849     }
3850 
3851     function pullOwedTokensFromLender(
3852         MarginState.State storage state,
3853         Tx transaction
3854     )
3855         private
3856     {
3857         // Transfer owedToken to the exchange wrapper
3858         TokenProxy(state.TOKEN_PROXY).transferTokens(
3859             transaction.loanOffering.owedToken,
3860             transaction.loanOffering.payer,
3861             transaction.exchangeWrapper,
3862             transaction.lenderAmount
3863         );
3864     }
3865 
3866     function transferLoanFees(
3867         MarginState.State storage state,
3868         Tx transaction
3869     )
3870         private
3871     {
3872         // 0 fee address indicates no fees
3873         if (transaction.loanOffering.feeRecipient == address(0)) {
3874             return;
3875         }
3876 
3877         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3878 
3879         uint256 lenderFee = MathHelpers.getPartialAmount(
3880             transaction.lenderAmount,
3881             transaction.loanOffering.rates.maxAmount,
3882             transaction.loanOffering.rates.lenderFee
3883         );
3884         uint256 takerFee = MathHelpers.getPartialAmount(
3885             transaction.lenderAmount,
3886             transaction.loanOffering.rates.maxAmount,
3887             transaction.loanOffering.rates.takerFee
3888         );
3889 
3890         if (lenderFee > 0) {
3891             proxy.transferTokens(
3892                 transaction.loanOffering.lenderFeeToken,
3893                 transaction.loanOffering.payer,
3894                 transaction.loanOffering.feeRecipient,
3895                 lenderFee
3896             );
3897         }
3898 
3899         if (takerFee > 0) {
3900             proxy.transferTokens(
3901                 transaction.loanOffering.takerFeeToken,
3902                 msg.sender,
3903                 transaction.loanOffering.feeRecipient,
3904                 takerFee
3905             );
3906         }
3907     }
3908 
3909     function getLoanOfferingAddresses(
3910         Tx transaction
3911     )
3912         private
3913         pure
3914         returns (address[9])
3915     {
3916         return [
3917             transaction.loanOffering.owedToken,
3918             transaction.loanOffering.heldToken,
3919             transaction.loanOffering.payer,
3920             transaction.loanOffering.owner,
3921             transaction.loanOffering.taker,
3922             transaction.loanOffering.positionOwner,
3923             transaction.loanOffering.feeRecipient,
3924             transaction.loanOffering.lenderFeeToken,
3925             transaction.loanOffering.takerFeeToken
3926         ];
3927     }
3928 
3929     function getLoanOfferingValues256(
3930         Tx transaction
3931     )
3932         private
3933         pure
3934         returns (uint256[7])
3935     {
3936         return [
3937             transaction.loanOffering.rates.maxAmount,
3938             transaction.loanOffering.rates.minAmount,
3939             transaction.loanOffering.rates.minHeldToken,
3940             transaction.loanOffering.rates.lenderFee,
3941             transaction.loanOffering.rates.takerFee,
3942             transaction.loanOffering.expirationTimestamp,
3943             transaction.loanOffering.salt
3944         ];
3945     }
3946 
3947     function getLoanOfferingValues32(
3948         Tx transaction
3949     )
3950         private
3951         pure
3952         returns (uint32[4])
3953     {
3954         return [
3955             transaction.loanOffering.callTimeLimit,
3956             transaction.loanOffering.maxDuration,
3957             transaction.loanOffering.rates.interestRate,
3958             transaction.loanOffering.rates.interestPeriod
3959         ];
3960     }
3961 }
3962 
3963 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3964 
3965 /**
3966  * @title IncreaseLoanDelegator
3967  * @author dYdX
3968  *
3969  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3970  *
3971  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3972  *       to these functions
3973  */
3974 interface IncreaseLoanDelegator {
3975 
3976     // ============ Public Interface functions ============
3977 
3978     /**
3979      * Function a contract must implement in order to allow additional value to be added onto
3980      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3981      *
3982      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3983      * either revert the entire transaction or that the loan size was successfully increased.
3984      *
3985      * @param  payer           Lender adding additional funds to the position
3986      * @param  positionId      Unique ID of the position
3987      * @param  principalAdded  Principal amount to be added to the position
3988      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
3989      *                         zero if increaseWithoutCounterparty() is used).
3990      * @return                 This address to accept, a different address to ask that contract
3991      */
3992     function increaseLoanOnBehalfOf(
3993         address payer,
3994         bytes32 positionId,
3995         uint256 principalAdded,
3996         uint256 lentAmount
3997     )
3998         external
3999         /* onlyMargin */
4000         returns (address);
4001 }
4002 
4003 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
4004 
4005 /**
4006  * @title IncreasePositionDelegator
4007  * @author dYdX
4008  *
4009  * Interface that smart contracts must implement in order to own position on behalf of other
4010  * accounts
4011  *
4012  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4013  *       to these functions
4014  */
4015 interface IncreasePositionDelegator {
4016 
4017     // ============ Public Interface functions ============
4018 
4019     /**
4020      * Function a contract must implement in order to allow additional value to be added onto
4021      * an owned position. Margin will call this on the owner of a position during increasePosition()
4022      *
4023      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4024      * either revert the entire transaction or that the position size was successfully increased.
4025      *
4026      * @param  trader          Address initiating the addition of funds to the position
4027      * @param  positionId      Unique ID of the position
4028      * @param  principalAdded  Amount of principal to be added to the position
4029      * @return                 This address to accept, a different address to ask that contract
4030      */
4031     function increasePositionOnBehalfOf(
4032         address trader,
4033         bytes32 positionId,
4034         uint256 principalAdded
4035     )
4036         external
4037         /* onlyMargin */
4038         returns (address);
4039 }
4040 
4041 // File: contracts/margin/impl/IncreasePositionImpl.sol
4042 
4043 /**
4044  * @title IncreasePositionImpl
4045  * @author dYdX
4046  *
4047  * This library contains the implementation for the increasePosition function of Margin
4048  */
4049 library IncreasePositionImpl {
4050     using SafeMath for uint256;
4051 
4052     // ============ Events ============
4053 
4054     /*
4055      * A position was increased
4056      */
4057     event PositionIncreased(
4058         bytes32 indexed positionId,
4059         address indexed trader,
4060         address indexed lender,
4061         address positionOwner,
4062         address loanOwner,
4063         bytes32 loanHash,
4064         address loanFeeRecipient,
4065         uint256 amountBorrowed,
4066         uint256 principalAdded,
4067         uint256 heldTokenFromSell,
4068         uint256 depositAmount,
4069         bool    depositInHeldToken
4070     );
4071 
4072     // ============ Public Implementation Functions ============
4073 
4074     function increasePositionImpl(
4075         MarginState.State storage state,
4076         bytes32 positionId,
4077         address[7] addresses,
4078         uint256[8] values256,
4079         uint32[2] values32,
4080         bool depositInHeldToken,
4081         bytes signature,
4082         bytes orderData
4083     )
4084         public
4085         returns (uint256)
4086     {
4087         // Also ensures that the position exists
4088         MarginCommon.Position storage position =
4089             MarginCommon.getPositionFromStorage(state, positionId);
4090 
4091         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
4092             position,
4093             positionId,
4094             addresses,
4095             values256,
4096             values32,
4097             depositInHeldToken,
4098             signature
4099         );
4100 
4101         validateIncrease(state, transaction, position);
4102 
4103         doBorrowAndSell(state, transaction, orderData);
4104 
4105         updateState(
4106             position,
4107             transaction.positionId,
4108             transaction.principal,
4109             transaction.lenderAmount,
4110             transaction.loanOffering.payer
4111         );
4112 
4113         // LOG EVENT
4114         recordPositionIncreased(transaction, position);
4115 
4116         return transaction.lenderAmount;
4117     }
4118 
4119     function increaseWithoutCounterpartyImpl(
4120         MarginState.State storage state,
4121         bytes32 positionId,
4122         uint256 principalToAdd
4123     )
4124         public
4125         returns (uint256)
4126     {
4127         MarginCommon.Position storage position =
4128             MarginCommon.getPositionFromStorage(state, positionId);
4129 
4130         // Disallow adding 0 principal
4131         require(
4132             principalToAdd > 0,
4133             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
4134         );
4135 
4136         // Disallow additions after maximum duration
4137         require(
4138             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
4139             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
4140         );
4141 
4142         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
4143             state,
4144             position,
4145             positionId,
4146             principalToAdd
4147         );
4148 
4149         Vault(state.VAULT).transferToVault(
4150             positionId,
4151             position.heldToken,
4152             msg.sender,
4153             heldTokenAmount
4154         );
4155 
4156         updateState(
4157             position,
4158             positionId,
4159             principalToAdd,
4160             0, // lent amount
4161             msg.sender
4162         );
4163 
4164         emit PositionIncreased(
4165             positionId,
4166             msg.sender,
4167             msg.sender,
4168             position.owner,
4169             position.lender,
4170             "",
4171             address(0),
4172             0,
4173             principalToAdd,
4174             0,
4175             heldTokenAmount,
4176             true
4177         );
4178 
4179         return heldTokenAmount;
4180     }
4181 
4182     // ============ Private Helper-Functions ============
4183 
4184     function doBorrowAndSell(
4185         MarginState.State storage state,
4186         BorrowShared.Tx memory transaction,
4187         bytes orderData
4188     )
4189         private
4190     {
4191         // Calculate the number of heldTokens to add
4192         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
4193             state,
4194             state.positions[transaction.positionId],
4195             transaction.positionId,
4196             transaction.principal
4197         );
4198 
4199         // Do pre-exchange validations
4200         BorrowShared.validateTxPreSell(state, transaction);
4201 
4202         // Calculate and deposit owedToken
4203         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
4204         if (!transaction.depositInHeldToken) {
4205             transaction.depositAmount =
4206                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
4207             BorrowShared.doDepositOwedToken(state, transaction);
4208             maxHeldTokenFromSell = collateralToAdd;
4209         }
4210 
4211         // Sell owedToken for heldToken using the exchange wrapper
4212         transaction.heldTokenFromSell = BorrowShared.doSell(
4213             state,
4214             transaction,
4215             orderData,
4216             maxHeldTokenFromSell
4217         );
4218 
4219         // Calculate and deposit heldToken
4220         if (transaction.depositInHeldToken) {
4221             require(
4222                 transaction.heldTokenFromSell <= collateralToAdd,
4223                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
4224             );
4225             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
4226             BorrowShared.doDepositHeldToken(state, transaction);
4227         }
4228 
4229         // Make sure the actual added collateral is what is expected
4230         assert(transaction.collateralAmount == collateralToAdd);
4231 
4232         // Do post-exchange validations
4233         BorrowShared.doPostSell(state, transaction);
4234     }
4235 
4236     function getOwedTokenDeposit(
4237         BorrowShared.Tx transaction,
4238         uint256 collateralToAdd,
4239         bytes orderData
4240     )
4241         private
4242         view
4243         returns (uint256)
4244     {
4245         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
4246             transaction.loanOffering.heldToken,
4247             transaction.loanOffering.owedToken,
4248             collateralToAdd,
4249             orderData
4250         );
4251 
4252         require(
4253             transaction.lenderAmount <= totalOwedToken,
4254             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4255         );
4256 
4257         return totalOwedToken.sub(transaction.lenderAmount);
4258     }
4259 
4260     function validateIncrease(
4261         MarginState.State storage state,
4262         BorrowShared.Tx transaction,
4263         MarginCommon.Position storage position
4264     )
4265         private
4266         view
4267     {
4268         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4269 
4270         require(
4271             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4272             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4273         );
4274 
4275         // require the position to end no later than the loanOffering's maximum acceptable end time
4276         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4277         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4278         require(
4279             positionEndTimestamp <= offeringEndTimestamp,
4280             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4281         );
4282 
4283         require(
4284             block.timestamp < positionEndTimestamp,
4285             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4286         );
4287     }
4288 
4289     function getCollateralNeededForAddedPrincipal(
4290         MarginState.State storage state,
4291         MarginCommon.Position storage position,
4292         bytes32 positionId,
4293         uint256 principalToAdd
4294     )
4295         private
4296         view
4297         returns (uint256)
4298     {
4299         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4300 
4301         return MathHelpers.getPartialAmountRoundedUp(
4302             principalToAdd,
4303             position.principal,
4304             heldTokenBalance
4305         );
4306     }
4307 
4308     function updateState(
4309         MarginCommon.Position storage position,
4310         bytes32 positionId,
4311         uint256 principalAdded,
4312         uint256 owedTokenLent,
4313         address loanPayer
4314     )
4315         private
4316     {
4317         position.principal = position.principal.add(principalAdded);
4318 
4319         address owner = position.owner;
4320         address lender = position.lender;
4321 
4322         // Ensure owner consent
4323         increasePositionOnBehalfOfRecurse(
4324             owner,
4325             msg.sender,
4326             positionId,
4327             principalAdded
4328         );
4329 
4330         // Ensure lender consent
4331         increaseLoanOnBehalfOfRecurse(
4332             lender,
4333             loanPayer,
4334             positionId,
4335             principalAdded,
4336             owedTokenLent
4337         );
4338     }
4339 
4340     function increasePositionOnBehalfOfRecurse(
4341         address contractAddr,
4342         address trader,
4343         bytes32 positionId,
4344         uint256 principalAdded
4345     )
4346         private
4347     {
4348         // Assume owner approval if not a smart contract and they increased their own position
4349         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4350             return;
4351         }
4352 
4353         address newContractAddr =
4354             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4355                 trader,
4356                 positionId,
4357                 principalAdded
4358             );
4359 
4360         if (newContractAddr != contractAddr) {
4361             increasePositionOnBehalfOfRecurse(
4362                 newContractAddr,
4363                 trader,
4364                 positionId,
4365                 principalAdded
4366             );
4367         }
4368     }
4369 
4370     function increaseLoanOnBehalfOfRecurse(
4371         address contractAddr,
4372         address payer,
4373         bytes32 positionId,
4374         uint256 principalAdded,
4375         uint256 amountLent
4376     )
4377         private
4378     {
4379         // Assume lender approval if not a smart contract and they increased their own loan
4380         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4381             return;
4382         }
4383 
4384         address newContractAddr =
4385             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4386                 payer,
4387                 positionId,
4388                 principalAdded,
4389                 amountLent
4390             );
4391 
4392         if (newContractAddr != contractAddr) {
4393             increaseLoanOnBehalfOfRecurse(
4394                 newContractAddr,
4395                 payer,
4396                 positionId,
4397                 principalAdded,
4398                 amountLent
4399             );
4400         }
4401     }
4402 
4403     function recordPositionIncreased(
4404         BorrowShared.Tx transaction,
4405         MarginCommon.Position storage position
4406     )
4407         private
4408     {
4409         emit PositionIncreased(
4410             transaction.positionId,
4411             msg.sender,
4412             transaction.loanOffering.payer,
4413             position.owner,
4414             position.lender,
4415             transaction.loanOffering.loanHash,
4416             transaction.loanOffering.feeRecipient,
4417             transaction.lenderAmount,
4418             transaction.principal,
4419             transaction.heldTokenFromSell,
4420             transaction.depositAmount,
4421             transaction.depositInHeldToken
4422         );
4423     }
4424 
4425     // ============ Parsing Functions ============
4426 
4427     function parseIncreasePositionTx(
4428         MarginCommon.Position storage position,
4429         bytes32 positionId,
4430         address[7] addresses,
4431         uint256[8] values256,
4432         uint32[2] values32,
4433         bool depositInHeldToken,
4434         bytes signature
4435     )
4436         private
4437         view
4438         returns (BorrowShared.Tx memory)
4439     {
4440         uint256 principal = values256[7];
4441 
4442         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4443             position,
4444             principal,
4445             block.timestamp
4446         );
4447         assert(lenderAmount >= principal);
4448 
4449         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4450             positionId: positionId,
4451             owner: position.owner,
4452             principal: principal,
4453             lenderAmount: lenderAmount,
4454             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4455                 position,
4456                 addresses,
4457                 values256,
4458                 values32,
4459                 signature
4460             ),
4461             exchangeWrapper: addresses[6],
4462             depositInHeldToken: depositInHeldToken,
4463             depositAmount: 0, // set later
4464             collateralAmount: 0, // set later
4465             heldTokenFromSell: 0 // set later
4466         });
4467 
4468         return transaction;
4469     }
4470 
4471     function parseLoanOfferingFromIncreasePositionTx(
4472         MarginCommon.Position storage position,
4473         address[7] addresses,
4474         uint256[8] values256,
4475         uint32[2] values32,
4476         bytes signature
4477     )
4478         private
4479         view
4480         returns (MarginCommon.LoanOffering memory)
4481     {
4482         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4483             owedToken: position.owedToken,
4484             heldToken: position.heldToken,
4485             payer: addresses[0],
4486             owner: position.lender,
4487             taker: addresses[1],
4488             positionOwner: addresses[2],
4489             feeRecipient: addresses[3],
4490             lenderFeeToken: addresses[4],
4491             takerFeeToken: addresses[5],
4492             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4493             expirationTimestamp: values256[5],
4494             callTimeLimit: values32[0],
4495             maxDuration: values32[1],
4496             salt: values256[6],
4497             loanHash: 0,
4498             signature: signature
4499         });
4500 
4501         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4502 
4503         return loanOffering;
4504     }
4505 
4506     function parseLoanOfferingRatesFromIncreasePositionTx(
4507         MarginCommon.Position storage position,
4508         uint256[8] values256
4509     )
4510         private
4511         view
4512         returns (MarginCommon.LoanRates memory)
4513     {
4514         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4515             maxAmount: values256[0],
4516             minAmount: values256[1],
4517             minHeldToken: values256[2],
4518             lenderFee: values256[3],
4519             takerFee: values256[4],
4520             interestRate: position.interestRate,
4521             interestPeriod: position.interestPeriod
4522         });
4523 
4524         return rates;
4525     }
4526 }
4527 
4528 // File: contracts/margin/impl/MarginStorage.sol
4529 
4530 /**
4531  * @title MarginStorage
4532  * @author dYdX
4533  *
4534  * This contract serves as the storage for the entire state of MarginStorage
4535  */
4536 contract MarginStorage {
4537 
4538     MarginState.State state;
4539 
4540 }
4541 
4542 // File: contracts/margin/impl/LoanGetters.sol
4543 
4544 /**
4545  * @title LoanGetters
4546  * @author dYdX
4547  *
4548  * A collection of public constant getter functions that allows reading of the state of any loan
4549  * offering stored in the dYdX protocol.
4550  */
4551 contract LoanGetters is MarginStorage {
4552 
4553     // ============ Public Constant Functions ============
4554 
4555     /**
4556      * Gets the principal amount of a loan offering that is no longer available.
4557      *
4558      * @param  loanHash  Unique hash of the loan offering
4559      * @return           The total unavailable amount of the loan offering, which is equal to the
4560      *                   filled amount plus the canceled amount.
4561      */
4562     function getLoanUnavailableAmount(
4563         bytes32 loanHash
4564     )
4565         external
4566         view
4567         returns (uint256)
4568     {
4569         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4570     }
4571 
4572     /**
4573      * Gets the total amount of owed token lent for a loan.
4574      *
4575      * @param  loanHash  Unique hash of the loan offering
4576      * @return           The total filled amount of the loan offering.
4577      */
4578     function getLoanFilledAmount(
4579         bytes32 loanHash
4580     )
4581         external
4582         view
4583         returns (uint256)
4584     {
4585         return state.loanFills[loanHash];
4586     }
4587 
4588     /**
4589      * Gets the amount of a loan offering that has been canceled.
4590      *
4591      * @param  loanHash  Unique hash of the loan offering
4592      * @return           The total canceled amount of the loan offering.
4593      */
4594     function getLoanCanceledAmount(
4595         bytes32 loanHash
4596     )
4597         external
4598         view
4599         returns (uint256)
4600     {
4601         return state.loanCancels[loanHash];
4602     }
4603 }
4604 
4605 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4606 
4607 /**
4608  * @title CancelMarginCallDelegator
4609  * @author dYdX
4610  *
4611  * Interface that smart contracts must implement in order to let other addresses cancel a
4612  * margin-call for a loan owned by the smart contract.
4613  *
4614  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4615  *       to these functions
4616  */
4617 interface CancelMarginCallDelegator {
4618 
4619     // ============ Public Interface functions ============
4620 
4621     /**
4622      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4623      *
4624      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4625      * either revert the entire transaction or that the margin-call was successfully canceled.
4626      *
4627      * @param  canceler    Address of the caller of the cancelMarginCall function
4628      * @param  positionId  Unique ID of the position
4629      * @return             This address to accept, a different address to ask that contract
4630      */
4631     function cancelMarginCallOnBehalfOf(
4632         address canceler,
4633         bytes32 positionId
4634     )
4635         external
4636         /* onlyMargin */
4637         returns (address);
4638 }
4639 
4640 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4641 
4642 /**
4643  * @title MarginCallDelegator
4644  * @author dYdX
4645  *
4646  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4647  * owned by the smart contract.
4648  *
4649  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4650  *       to these functions
4651  */
4652 interface MarginCallDelegator {
4653 
4654     // ============ Public Interface functions ============
4655 
4656     /**
4657      * Function a contract must implement in order to let other addresses call marginCall().
4658      *
4659      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4660      * either revert the entire transaction or that the loan was successfully margin-called.
4661      *
4662      * @param  caller         Address of the caller of the marginCall function
4663      * @param  positionId     Unique ID of the position
4664      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4665      * @return                This address to accept, a different address to ask that contract
4666      */
4667     function marginCallOnBehalfOf(
4668         address caller,
4669         bytes32 positionId,
4670         uint256 depositAmount
4671     )
4672         external
4673         /* onlyMargin */
4674         returns (address);
4675 }
4676 
4677 // File: contracts/margin/impl/LoanImpl.sol
4678 
4679 /**
4680  * @title LoanImpl
4681  * @author dYdX
4682  *
4683  * This library contains the implementation for the following functions of Margin:
4684  *
4685  *      - marginCall
4686  *      - cancelMarginCallImpl
4687  *      - cancelLoanOffering
4688  */
4689 library LoanImpl {
4690     using SafeMath for uint256;
4691 
4692     // ============ Events ============
4693 
4694     /**
4695      * A position was margin-called
4696      */
4697     event MarginCallInitiated(
4698         bytes32 indexed positionId,
4699         address indexed lender,
4700         address indexed owner,
4701         uint256 requiredDeposit
4702     );
4703 
4704     /**
4705      * A margin call was canceled
4706      */
4707     event MarginCallCanceled(
4708         bytes32 indexed positionId,
4709         address indexed lender,
4710         address indexed owner,
4711         uint256 depositAmount
4712     );
4713 
4714     /**
4715      * A loan offering was canceled before it was used. Any amount less than the
4716      * total for the loan offering can be canceled.
4717      */
4718     event LoanOfferingCanceled(
4719         bytes32 indexed loanHash,
4720         address indexed payer,
4721         address indexed feeRecipient,
4722         uint256 cancelAmount
4723     );
4724 
4725     // ============ Public Implementation Functions ============
4726 
4727     function marginCallImpl(
4728         MarginState.State storage state,
4729         bytes32 positionId,
4730         uint256 requiredDeposit
4731     )
4732         public
4733     {
4734         MarginCommon.Position storage position =
4735             MarginCommon.getPositionFromStorage(state, positionId);
4736 
4737         require(
4738             position.callTimestamp == 0,
4739             "LoanImpl#marginCallImpl: The position has already been margin-called"
4740         );
4741 
4742         // Ensure lender consent
4743         marginCallOnBehalfOfRecurse(
4744             position.lender,
4745             msg.sender,
4746             positionId,
4747             requiredDeposit
4748         );
4749 
4750         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4751         position.requiredDeposit = requiredDeposit;
4752 
4753         emit MarginCallInitiated(
4754             positionId,
4755             position.lender,
4756             position.owner,
4757             requiredDeposit
4758         );
4759     }
4760 
4761     function cancelMarginCallImpl(
4762         MarginState.State storage state,
4763         bytes32 positionId
4764     )
4765         public
4766     {
4767         MarginCommon.Position storage position =
4768             MarginCommon.getPositionFromStorage(state, positionId);
4769 
4770         require(
4771             position.callTimestamp > 0,
4772             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4773         );
4774 
4775         // Ensure lender consent
4776         cancelMarginCallOnBehalfOfRecurse(
4777             position.lender,
4778             msg.sender,
4779             positionId
4780         );
4781 
4782         state.positions[positionId].callTimestamp = 0;
4783         state.positions[positionId].requiredDeposit = 0;
4784 
4785         emit MarginCallCanceled(
4786             positionId,
4787             position.lender,
4788             position.owner,
4789             0
4790         );
4791     }
4792 
4793     function cancelLoanOfferingImpl(
4794         MarginState.State storage state,
4795         address[9] addresses,
4796         uint256[7] values256,
4797         uint32[4]  values32,
4798         uint256    cancelAmount
4799     )
4800         public
4801         returns (uint256)
4802     {
4803         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4804             addresses,
4805             values256,
4806             values32
4807         );
4808 
4809         require(
4810             msg.sender == loanOffering.payer,
4811             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4812         );
4813         require(
4814             loanOffering.expirationTimestamp > block.timestamp,
4815             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4816         );
4817 
4818         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4819             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4820         );
4821         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4822 
4823         // If the loan was already fully canceled, then just return 0 amount was canceled
4824         if (amountToCancel == 0) {
4825             return 0;
4826         }
4827 
4828         state.loanCancels[loanOffering.loanHash] =
4829             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4830 
4831         emit LoanOfferingCanceled(
4832             loanOffering.loanHash,
4833             loanOffering.payer,
4834             loanOffering.feeRecipient,
4835             amountToCancel
4836         );
4837 
4838         return amountToCancel;
4839     }
4840 
4841     // ============ Private Helper-Functions ============
4842 
4843     function marginCallOnBehalfOfRecurse(
4844         address contractAddr,
4845         address who,
4846         bytes32 positionId,
4847         uint256 requiredDeposit
4848     )
4849         private
4850     {
4851         // no need to ask for permission
4852         if (who == contractAddr) {
4853             return;
4854         }
4855 
4856         address newContractAddr =
4857             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4858                 msg.sender,
4859                 positionId,
4860                 requiredDeposit
4861             );
4862 
4863         if (newContractAddr != contractAddr) {
4864             marginCallOnBehalfOfRecurse(
4865                 newContractAddr,
4866                 who,
4867                 positionId,
4868                 requiredDeposit
4869             );
4870         }
4871     }
4872 
4873     function cancelMarginCallOnBehalfOfRecurse(
4874         address contractAddr,
4875         address who,
4876         bytes32 positionId
4877     )
4878         private
4879     {
4880         // no need to ask for permission
4881         if (who == contractAddr) {
4882             return;
4883         }
4884 
4885         address newContractAddr =
4886             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4887                 msg.sender,
4888                 positionId
4889             );
4890 
4891         if (newContractAddr != contractAddr) {
4892             cancelMarginCallOnBehalfOfRecurse(
4893                 newContractAddr,
4894                 who,
4895                 positionId
4896             );
4897         }
4898     }
4899 
4900     // ============ Parsing Functions ============
4901 
4902     function parseLoanOffering(
4903         address[9] addresses,
4904         uint256[7] values256,
4905         uint32[4]  values32
4906     )
4907         private
4908         view
4909         returns (MarginCommon.LoanOffering memory)
4910     {
4911         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4912             owedToken: addresses[0],
4913             heldToken: addresses[1],
4914             payer: addresses[2],
4915             owner: addresses[3],
4916             taker: addresses[4],
4917             positionOwner: addresses[5],
4918             feeRecipient: addresses[6],
4919             lenderFeeToken: addresses[7],
4920             takerFeeToken: addresses[8],
4921             rates: parseLoanOfferRates(values256, values32),
4922             expirationTimestamp: values256[5],
4923             callTimeLimit: values32[0],
4924             maxDuration: values32[1],
4925             salt: values256[6],
4926             loanHash: 0,
4927             signature: new bytes(0)
4928         });
4929 
4930         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4931 
4932         return loanOffering;
4933     }
4934 
4935     function parseLoanOfferRates(
4936         uint256[7] values256,
4937         uint32[4] values32
4938     )
4939         private
4940         pure
4941         returns (MarginCommon.LoanRates memory)
4942     {
4943         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4944             maxAmount: values256[0],
4945             minAmount: values256[1],
4946             minHeldToken: values256[2],
4947             interestRate: values32[2],
4948             lenderFee: values256[3],
4949             takerFee: values256[4],
4950             interestPeriod: values32[3]
4951         });
4952 
4953         return rates;
4954     }
4955 }
4956 
4957 // File: contracts/margin/impl/MarginAdmin.sol
4958 
4959 /**
4960  * @title MarginAdmin
4961  * @author dYdX
4962  *
4963  * Contains admin functions for the Margin contract
4964  * The owner can put Margin into various close-only modes, which will disallow new position creation
4965  */
4966 contract MarginAdmin is Ownable {
4967     // ============ Enums ============
4968 
4969     // All functionality enabled
4970     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4971 
4972     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4973     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4974     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4975 
4976     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4977     // forceRecoverCollateral)
4978     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4979 
4980     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4981     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4982 
4983     // This operation state (and any higher) is invalid
4984     uint8 private constant OPERATION_STATE_INVALID = 4;
4985 
4986     // ============ Events ============
4987 
4988     /**
4989      * Event indicating the operation state has changed
4990      */
4991     event OperationStateChanged(
4992         uint8 from,
4993         uint8 to
4994     );
4995 
4996     // ============ State Variables ============
4997 
4998     uint8 public operationState;
4999 
5000     // ============ Constructor ============
5001 
5002     constructor()
5003         public
5004         Ownable()
5005     {
5006         operationState = OPERATION_STATE_OPERATIONAL;
5007     }
5008 
5009     // ============ Modifiers ============
5010 
5011     modifier onlyWhileOperational() {
5012         require(
5013             operationState == OPERATION_STATE_OPERATIONAL,
5014             "MarginAdmin#onlyWhileOperational: Can only call while operational"
5015         );
5016         _;
5017     }
5018 
5019     modifier cancelLoanOfferingStateControl() {
5020         require(
5021             operationState == OPERATION_STATE_OPERATIONAL
5022             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
5023             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
5024         );
5025         _;
5026     }
5027 
5028     modifier closePositionStateControl() {
5029         require(
5030             operationState == OPERATION_STATE_OPERATIONAL
5031             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
5032             || operationState == OPERATION_STATE_CLOSE_ONLY,
5033             "MarginAdmin#closePositionStateControl: Invalid operation state"
5034         );
5035         _;
5036     }
5037 
5038     modifier closePositionDirectlyStateControl() {
5039         _;
5040     }
5041 
5042     // ============ Owner-Only State-Changing Functions ============
5043 
5044     function setOperationState(
5045         uint8 newState
5046     )
5047         external
5048         onlyOwner
5049     {
5050         require(
5051             newState < OPERATION_STATE_INVALID,
5052             "MarginAdmin#setOperationState: newState is not a valid operation state"
5053         );
5054 
5055         if (newState != operationState) {
5056             emit OperationStateChanged(
5057                 operationState,
5058                 newState
5059             );
5060             operationState = newState;
5061         }
5062     }
5063 }
5064 
5065 // File: contracts/margin/impl/MarginEvents.sol
5066 
5067 /**
5068  * @title MarginEvents
5069  * @author dYdX
5070  *
5071  * Contains events for the Margin contract.
5072  *
5073  * NOTE: Any Margin function libraries that use events will need to both define the event here
5074  *       and copy the event into the library itself as libraries don't support sharing events
5075  */
5076 contract MarginEvents {
5077     // ============ Events ============
5078 
5079     /**
5080      * A position was opened
5081      */
5082     event PositionOpened(
5083         bytes32 indexed positionId,
5084         address indexed trader,
5085         address indexed lender,
5086         bytes32 loanHash,
5087         address owedToken,
5088         address heldToken,
5089         address loanFeeRecipient,
5090         uint256 principal,
5091         uint256 heldTokenFromSell,
5092         uint256 depositAmount,
5093         uint256 interestRate,
5094         uint32  callTimeLimit,
5095         uint32  maxDuration,
5096         bool    depositInHeldToken
5097     );
5098 
5099     /*
5100      * A position was increased
5101      */
5102     event PositionIncreased(
5103         bytes32 indexed positionId,
5104         address indexed trader,
5105         address indexed lender,
5106         address positionOwner,
5107         address loanOwner,
5108         bytes32 loanHash,
5109         address loanFeeRecipient,
5110         uint256 amountBorrowed,
5111         uint256 principalAdded,
5112         uint256 heldTokenFromSell,
5113         uint256 depositAmount,
5114         bool    depositInHeldToken
5115     );
5116 
5117     /**
5118      * A position was closed or partially closed
5119      */
5120     event PositionClosed(
5121         bytes32 indexed positionId,
5122         address indexed closer,
5123         address indexed payoutRecipient,
5124         uint256 closeAmount,
5125         uint256 remainingAmount,
5126         uint256 owedTokenPaidToLender,
5127         uint256 payoutAmount,
5128         uint256 buybackCostInHeldToken,
5129         bool payoutInHeldToken
5130     );
5131 
5132     /**
5133      * Collateral for a position was forcibly recovered
5134      */
5135     event CollateralForceRecovered(
5136         bytes32 indexed positionId,
5137         address indexed recipient,
5138         uint256 amount
5139     );
5140 
5141     /**
5142      * A position was margin-called
5143      */
5144     event MarginCallInitiated(
5145         bytes32 indexed positionId,
5146         address indexed lender,
5147         address indexed owner,
5148         uint256 requiredDeposit
5149     );
5150 
5151     /**
5152      * A margin call was canceled
5153      */
5154     event MarginCallCanceled(
5155         bytes32 indexed positionId,
5156         address indexed lender,
5157         address indexed owner,
5158         uint256 depositAmount
5159     );
5160 
5161     /**
5162      * A loan offering was canceled before it was used. Any amount less than the
5163      * total for the loan offering can be canceled.
5164      */
5165     event LoanOfferingCanceled(
5166         bytes32 indexed loanHash,
5167         address indexed payer,
5168         address indexed feeRecipient,
5169         uint256 cancelAmount
5170     );
5171 
5172     /**
5173      * Additional collateral for a position was posted by the owner
5174      */
5175     event AdditionalCollateralDeposited(
5176         bytes32 indexed positionId,
5177         uint256 amount,
5178         address depositor
5179     );
5180 
5181     /**
5182      * Ownership of a loan was transferred to a new address
5183      */
5184     event LoanTransferred(
5185         bytes32 indexed positionId,
5186         address indexed from,
5187         address indexed to
5188     );
5189 
5190     /**
5191      * Ownership of a position was transferred to a new address
5192      */
5193     event PositionTransferred(
5194         bytes32 indexed positionId,
5195         address indexed from,
5196         address indexed to
5197     );
5198 }
5199 
5200 // File: contracts/margin/impl/OpenPositionImpl.sol
5201 
5202 /**
5203  * @title OpenPositionImpl
5204  * @author dYdX
5205  *
5206  * This library contains the implementation for the openPosition function of Margin
5207  */
5208 library OpenPositionImpl {
5209     using SafeMath for uint256;
5210 
5211     // ============ Events ============
5212 
5213     /**
5214      * A position was opened
5215      */
5216     event PositionOpened(
5217         bytes32 indexed positionId,
5218         address indexed trader,
5219         address indexed lender,
5220         bytes32 loanHash,
5221         address owedToken,
5222         address heldToken,
5223         address loanFeeRecipient,
5224         uint256 principal,
5225         uint256 heldTokenFromSell,
5226         uint256 depositAmount,
5227         uint256 interestRate,
5228         uint32  callTimeLimit,
5229         uint32  maxDuration,
5230         bool    depositInHeldToken
5231     );
5232 
5233     // ============ Public Implementation Functions ============
5234 
5235     function openPositionImpl(
5236         MarginState.State storage state,
5237         address[11] addresses,
5238         uint256[10] values256,
5239         uint32[4] values32,
5240         bool depositInHeldToken,
5241         bytes signature,
5242         bytes orderData
5243     )
5244         public
5245         returns (bytes32)
5246     {
5247         BorrowShared.Tx memory transaction = parseOpenTx(
5248             addresses,
5249             values256,
5250             values32,
5251             depositInHeldToken,
5252             signature
5253         );
5254 
5255         require(
5256             !MarginCommon.positionHasExisted(state, transaction.positionId),
5257             "OpenPositionImpl#openPositionImpl: positionId already exists"
5258         );
5259 
5260         doBorrowAndSell(state, transaction, orderData);
5261 
5262         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5263         recordPositionOpened(
5264             transaction
5265         );
5266 
5267         doStoreNewPosition(
5268             state,
5269             transaction
5270         );
5271 
5272         return transaction.positionId;
5273     }
5274 
5275     // ============ Private Helper-Functions ============
5276 
5277     function doBorrowAndSell(
5278         MarginState.State storage state,
5279         BorrowShared.Tx memory transaction,
5280         bytes orderData
5281     )
5282         private
5283     {
5284         BorrowShared.validateTxPreSell(state, transaction);
5285 
5286         if (transaction.depositInHeldToken) {
5287             BorrowShared.doDepositHeldToken(state, transaction);
5288         } else {
5289             BorrowShared.doDepositOwedToken(state, transaction);
5290         }
5291 
5292         transaction.heldTokenFromSell = BorrowShared.doSell(
5293             state,
5294             transaction,
5295             orderData,
5296             MathHelpers.maxUint256()
5297         );
5298 
5299         BorrowShared.doPostSell(state, transaction);
5300     }
5301 
5302     function doStoreNewPosition(
5303         MarginState.State storage state,
5304         BorrowShared.Tx memory transaction
5305     )
5306         private
5307     {
5308         MarginCommon.storeNewPosition(
5309             state,
5310             transaction.positionId,
5311             MarginCommon.Position({
5312                 owedToken: transaction.loanOffering.owedToken,
5313                 heldToken: transaction.loanOffering.heldToken,
5314                 lender: transaction.loanOffering.owner,
5315                 owner: transaction.owner,
5316                 principal: transaction.principal,
5317                 requiredDeposit: 0,
5318                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5319                 startTimestamp: 0,
5320                 callTimestamp: 0,
5321                 maxDuration: transaction.loanOffering.maxDuration,
5322                 interestRate: transaction.loanOffering.rates.interestRate,
5323                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5324             }),
5325             transaction.loanOffering.payer
5326         );
5327     }
5328 
5329     function recordPositionOpened(
5330         BorrowShared.Tx transaction
5331     )
5332         private
5333     {
5334         emit PositionOpened(
5335             transaction.positionId,
5336             msg.sender,
5337             transaction.loanOffering.payer,
5338             transaction.loanOffering.loanHash,
5339             transaction.loanOffering.owedToken,
5340             transaction.loanOffering.heldToken,
5341             transaction.loanOffering.feeRecipient,
5342             transaction.principal,
5343             transaction.heldTokenFromSell,
5344             transaction.depositAmount,
5345             transaction.loanOffering.rates.interestRate,
5346             transaction.loanOffering.callTimeLimit,
5347             transaction.loanOffering.maxDuration,
5348             transaction.depositInHeldToken
5349         );
5350     }
5351 
5352     // ============ Parsing Functions ============
5353 
5354     function parseOpenTx(
5355         address[11] addresses,
5356         uint256[10] values256,
5357         uint32[4] values32,
5358         bool depositInHeldToken,
5359         bytes signature
5360     )
5361         private
5362         view
5363         returns (BorrowShared.Tx memory)
5364     {
5365         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5366             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5367             owner: addresses[0],
5368             principal: values256[7],
5369             lenderAmount: values256[7],
5370             loanOffering: parseLoanOffering(
5371                 addresses,
5372                 values256,
5373                 values32,
5374                 signature
5375             ),
5376             exchangeWrapper: addresses[10],
5377             depositInHeldToken: depositInHeldToken,
5378             depositAmount: values256[8],
5379             collateralAmount: 0, // set later
5380             heldTokenFromSell: 0 // set later
5381         });
5382 
5383         return transaction;
5384     }
5385 
5386     function parseLoanOffering(
5387         address[11] addresses,
5388         uint256[10] values256,
5389         uint32[4]   values32,
5390         bytes       signature
5391     )
5392         private
5393         view
5394         returns (MarginCommon.LoanOffering memory)
5395     {
5396         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5397             owedToken: addresses[1],
5398             heldToken: addresses[2],
5399             payer: addresses[3],
5400             owner: addresses[4],
5401             taker: addresses[5],
5402             positionOwner: addresses[6],
5403             feeRecipient: addresses[7],
5404             lenderFeeToken: addresses[8],
5405             takerFeeToken: addresses[9],
5406             rates: parseLoanOfferRates(values256, values32),
5407             expirationTimestamp: values256[5],
5408             callTimeLimit: values32[0],
5409             maxDuration: values32[1],
5410             salt: values256[6],
5411             loanHash: 0,
5412             signature: signature
5413         });
5414 
5415         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5416 
5417         return loanOffering;
5418     }
5419 
5420     function parseLoanOfferRates(
5421         uint256[10] values256,
5422         uint32[4] values32
5423     )
5424         private
5425         pure
5426         returns (MarginCommon.LoanRates memory)
5427     {
5428         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5429             maxAmount: values256[0],
5430             minAmount: values256[1],
5431             minHeldToken: values256[2],
5432             lenderFee: values256[3],
5433             takerFee: values256[4],
5434             interestRate: values32[2],
5435             interestPeriod: values32[3]
5436         });
5437 
5438         return rates;
5439     }
5440 }
5441 
5442 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5443 
5444 /**
5445  * @title OpenWithoutCounterpartyImpl
5446  * @author dYdX
5447  *
5448  * This library contains the implementation for the openWithoutCounterparty
5449  * function of Margin
5450  */
5451 library OpenWithoutCounterpartyImpl {
5452 
5453     // ============ Structs ============
5454 
5455     struct Tx {
5456         bytes32 positionId;
5457         address positionOwner;
5458         address owedToken;
5459         address heldToken;
5460         address loanOwner;
5461         uint256 principal;
5462         uint256 deposit;
5463         uint32 callTimeLimit;
5464         uint32 maxDuration;
5465         uint32 interestRate;
5466         uint32 interestPeriod;
5467     }
5468 
5469     // ============ Events ============
5470 
5471     /**
5472      * A position was opened
5473      */
5474     event PositionOpened(
5475         bytes32 indexed positionId,
5476         address indexed trader,
5477         address indexed lender,
5478         bytes32 loanHash,
5479         address owedToken,
5480         address heldToken,
5481         address loanFeeRecipient,
5482         uint256 principal,
5483         uint256 heldTokenFromSell,
5484         uint256 depositAmount,
5485         uint256 interestRate,
5486         uint32  callTimeLimit,
5487         uint32  maxDuration,
5488         bool    depositInHeldToken
5489     );
5490 
5491     // ============ Public Implementation Functions ============
5492 
5493     function openWithoutCounterpartyImpl(
5494         MarginState.State storage state,
5495         address[4] addresses,
5496         uint256[3] values256,
5497         uint32[4]  values32
5498     )
5499         public
5500         returns (bytes32)
5501     {
5502         Tx memory openTx = parseTx(
5503             addresses,
5504             values256,
5505             values32
5506         );
5507 
5508         validate(
5509             state,
5510             openTx
5511         );
5512 
5513         Vault(state.VAULT).transferToVault(
5514             openTx.positionId,
5515             openTx.heldToken,
5516             msg.sender,
5517             openTx.deposit
5518         );
5519 
5520         recordPositionOpened(
5521             openTx
5522         );
5523 
5524         doStoreNewPosition(
5525             state,
5526             openTx
5527         );
5528 
5529         return openTx.positionId;
5530     }
5531 
5532     // ============ Private Helper-Functions ============
5533 
5534     function doStoreNewPosition(
5535         MarginState.State storage state,
5536         Tx memory openTx
5537     )
5538         private
5539     {
5540         MarginCommon.storeNewPosition(
5541             state,
5542             openTx.positionId,
5543             MarginCommon.Position({
5544                 owedToken: openTx.owedToken,
5545                 heldToken: openTx.heldToken,
5546                 lender: openTx.loanOwner,
5547                 owner: openTx.positionOwner,
5548                 principal: openTx.principal,
5549                 requiredDeposit: 0,
5550                 callTimeLimit: openTx.callTimeLimit,
5551                 startTimestamp: 0,
5552                 callTimestamp: 0,
5553                 maxDuration: openTx.maxDuration,
5554                 interestRate: openTx.interestRate,
5555                 interestPeriod: openTx.interestPeriod
5556             }),
5557             msg.sender
5558         );
5559     }
5560 
5561     function validate(
5562         MarginState.State storage state,
5563         Tx memory openTx
5564     )
5565         private
5566         view
5567     {
5568         require(
5569             !MarginCommon.positionHasExisted(state, openTx.positionId),
5570             "openWithoutCounterpartyImpl#validate: positionId already exists"
5571         );
5572 
5573         require(
5574             openTx.principal > 0,
5575             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5576         );
5577 
5578         require(
5579             openTx.owedToken != address(0),
5580             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5581         );
5582 
5583         require(
5584             openTx.owedToken != openTx.heldToken,
5585             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5586         );
5587 
5588         require(
5589             openTx.positionOwner != address(0),
5590             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5591         );
5592 
5593         require(
5594             openTx.loanOwner != address(0),
5595             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5596         );
5597 
5598         require(
5599             openTx.maxDuration > 0,
5600             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5601         );
5602 
5603         require(
5604             openTx.interestPeriod <= openTx.maxDuration,
5605             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5606         );
5607     }
5608 
5609     function recordPositionOpened(
5610         Tx memory openTx
5611     )
5612         private
5613     {
5614         emit PositionOpened(
5615             openTx.positionId,
5616             msg.sender,
5617             msg.sender,
5618             bytes32(0),
5619             openTx.owedToken,
5620             openTx.heldToken,
5621             address(0),
5622             openTx.principal,
5623             0,
5624             openTx.deposit,
5625             openTx.interestRate,
5626             openTx.callTimeLimit,
5627             openTx.maxDuration,
5628             true
5629         );
5630     }
5631 
5632     // ============ Parsing Functions ============
5633 
5634     function parseTx(
5635         address[4] addresses,
5636         uint256[3] values256,
5637         uint32[4]  values32
5638     )
5639         private
5640         view
5641         returns (Tx memory)
5642     {
5643         Tx memory openTx = Tx({
5644             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5645             positionOwner: addresses[0],
5646             owedToken: addresses[1],
5647             heldToken: addresses[2],
5648             loanOwner: addresses[3],
5649             principal: values256[0],
5650             deposit: values256[1],
5651             callTimeLimit: values32[0],
5652             maxDuration: values32[1],
5653             interestRate: values32[2],
5654             interestPeriod: values32[3]
5655         });
5656 
5657         return openTx;
5658     }
5659 }
5660 
5661 // File: contracts/margin/impl/PositionGetters.sol
5662 
5663 /**
5664  * @title PositionGetters
5665  * @author dYdX
5666  *
5667  * A collection of public constant getter functions that allows reading of the state of any position
5668  * stored in the dYdX protocol.
5669  */
5670 contract PositionGetters is MarginStorage {
5671     using SafeMath for uint256;
5672 
5673     // ============ Public Constant Functions ============
5674 
5675     /**
5676      * Gets if a position is currently open.
5677      *
5678      * @param  positionId  Unique ID of the position
5679      * @return             True if the position is exists and is open
5680      */
5681     function containsPosition(
5682         bytes32 positionId
5683     )
5684         external
5685         view
5686         returns (bool)
5687     {
5688         return MarginCommon.containsPositionImpl(state, positionId);
5689     }
5690 
5691     /**
5692      * Gets if a position is currently margin-called.
5693      *
5694      * @param  positionId  Unique ID of the position
5695      * @return             True if the position is margin-called
5696      */
5697     function isPositionCalled(
5698         bytes32 positionId
5699     )
5700         external
5701         view
5702         returns (bool)
5703     {
5704         return (state.positions[positionId].callTimestamp > 0);
5705     }
5706 
5707     /**
5708      * Gets if a position was previously open and is now closed.
5709      *
5710      * @param  positionId  Unique ID of the position
5711      * @return             True if the position is now closed
5712      */
5713     function isPositionClosed(
5714         bytes32 positionId
5715     )
5716         external
5717         view
5718         returns (bool)
5719     {
5720         return state.closedPositions[positionId];
5721     }
5722 
5723     /**
5724      * Gets the total amount of owedToken ever repaid to the lender for a position.
5725      *
5726      * @param  positionId  Unique ID of the position
5727      * @return             Total amount of owedToken ever repaid
5728      */
5729     function getTotalOwedTokenRepaidToLender(
5730         bytes32 positionId
5731     )
5732         external
5733         view
5734         returns (uint256)
5735     {
5736         return state.totalOwedTokenRepaidToLender[positionId];
5737     }
5738 
5739     /**
5740      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5741      *
5742      * @param  positionId  Unique ID of the position
5743      * @return             The amount of heldToken
5744      */
5745     function getPositionBalance(
5746         bytes32 positionId
5747     )
5748         external
5749         view
5750         returns (uint256)
5751     {
5752         return MarginCommon.getPositionBalanceImpl(state, positionId);
5753     }
5754 
5755     /**
5756      * Gets the time until the interest fee charged for the position will increase.
5757      * Returns 1 if the interest fee increases every second.
5758      * Returns 0 if the interest fee will never increase again.
5759      *
5760      * @param  positionId  Unique ID of the position
5761      * @return             The number of seconds until the interest fee will increase
5762      */
5763     function getTimeUntilInterestIncrease(
5764         bytes32 positionId
5765     )
5766         external
5767         view
5768         returns (uint256)
5769     {
5770         MarginCommon.Position storage position =
5771             MarginCommon.getPositionFromStorage(state, positionId);
5772 
5773         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5774             position,
5775             block.timestamp
5776         );
5777 
5778         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5779         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5780             return 0;
5781         } else {
5782             // nextStep is the final second at which the calculated interest fee is the same as it
5783             // is currently, so add 1 to get the correct value
5784             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5785         }
5786     }
5787 
5788     /**
5789      * Gets the amount of owedTokens currently needed to close the position completely, including
5790      * interest fees.
5791      *
5792      * @param  positionId  Unique ID of the position
5793      * @return             The number of owedTokens
5794      */
5795     function getPositionOwedAmount(
5796         bytes32 positionId
5797     )
5798         external
5799         view
5800         returns (uint256)
5801     {
5802         MarginCommon.Position storage position =
5803             MarginCommon.getPositionFromStorage(state, positionId);
5804 
5805         return MarginCommon.calculateOwedAmount(
5806             position,
5807             position.principal,
5808             block.timestamp
5809         );
5810     }
5811 
5812     /**
5813      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5814      * given time, including interest fees.
5815      *
5816      * @param  positionId         Unique ID of the position
5817      * @param  principalToClose   Amount of principal being closed
5818      * @param  timestamp          Block timestamp in seconds of close
5819      * @return                    The number of owedTokens owed
5820      */
5821     function getPositionOwedAmountAtTime(
5822         bytes32 positionId,
5823         uint256 principalToClose,
5824         uint32  timestamp
5825     )
5826         external
5827         view
5828         returns (uint256)
5829     {
5830         MarginCommon.Position storage position =
5831             MarginCommon.getPositionFromStorage(state, positionId);
5832 
5833         require(
5834             timestamp >= position.startTimestamp,
5835             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5836         );
5837 
5838         return MarginCommon.calculateOwedAmount(
5839             position,
5840             principalToClose,
5841             timestamp
5842         );
5843     }
5844 
5845     /**
5846      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5847      * amount to the position at a given time.
5848      *
5849      * @param  positionId      Unique ID of the position
5850      * @param  principalToAdd  Amount being added to principal
5851      * @param  timestamp       Block timestamp in seconds of addition
5852      * @return                 The number of owedTokens that will be borrowed
5853      */
5854     function getLenderAmountForIncreasePositionAtTime(
5855         bytes32 positionId,
5856         uint256 principalToAdd,
5857         uint32  timestamp
5858     )
5859         external
5860         view
5861         returns (uint256)
5862     {
5863         MarginCommon.Position storage position =
5864             MarginCommon.getPositionFromStorage(state, positionId);
5865 
5866         require(
5867             timestamp >= position.startTimestamp,
5868             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5869         );
5870 
5871         return MarginCommon.calculateLenderAmountForIncreasePosition(
5872             position,
5873             principalToAdd,
5874             timestamp
5875         );
5876     }
5877 
5878     // ============ All Properties ============
5879 
5880     /**
5881      * Get a Position by id. This does not validate the position exists. If the position does not
5882      * exist, all 0's will be returned.
5883      *
5884      * @param  positionId  Unique ID of the position
5885      * @return             Addresses corresponding to:
5886      *
5887      *                     [0] = owedToken
5888      *                     [1] = heldToken
5889      *                     [2] = lender
5890      *                     [3] = owner
5891      *
5892      *                     Values corresponding to:
5893      *
5894      *                     [0] = principal
5895      *                     [1] = requiredDeposit
5896      *
5897      *                     Values corresponding to:
5898      *
5899      *                     [0] = callTimeLimit
5900      *                     [1] = startTimestamp
5901      *                     [2] = callTimestamp
5902      *                     [3] = maxDuration
5903      *                     [4] = interestRate
5904      *                     [5] = interestPeriod
5905      */
5906     function getPosition(
5907         bytes32 positionId
5908     )
5909         external
5910         view
5911         returns (
5912             address[4],
5913             uint256[2],
5914             uint32[6]
5915         )
5916     {
5917         MarginCommon.Position storage position = state.positions[positionId];
5918 
5919         return (
5920             [
5921                 position.owedToken,
5922                 position.heldToken,
5923                 position.lender,
5924                 position.owner
5925             ],
5926             [
5927                 position.principal,
5928                 position.requiredDeposit
5929             ],
5930             [
5931                 position.callTimeLimit,
5932                 position.startTimestamp,
5933                 position.callTimestamp,
5934                 position.maxDuration,
5935                 position.interestRate,
5936                 position.interestPeriod
5937             ]
5938         );
5939     }
5940 
5941     // ============ Individual Properties ============
5942 
5943     function getPositionLender(
5944         bytes32 positionId
5945     )
5946         external
5947         view
5948         returns (address)
5949     {
5950         return state.positions[positionId].lender;
5951     }
5952 
5953     function getPositionOwner(
5954         bytes32 positionId
5955     )
5956         external
5957         view
5958         returns (address)
5959     {
5960         return state.positions[positionId].owner;
5961     }
5962 
5963     function getPositionHeldToken(
5964         bytes32 positionId
5965     )
5966         external
5967         view
5968         returns (address)
5969     {
5970         return state.positions[positionId].heldToken;
5971     }
5972 
5973     function getPositionOwedToken(
5974         bytes32 positionId
5975     )
5976         external
5977         view
5978         returns (address)
5979     {
5980         return state.positions[positionId].owedToken;
5981     }
5982 
5983     function getPositionPrincipal(
5984         bytes32 positionId
5985     )
5986         external
5987         view
5988         returns (uint256)
5989     {
5990         return state.positions[positionId].principal;
5991     }
5992 
5993     function getPositionInterestRate(
5994         bytes32 positionId
5995     )
5996         external
5997         view
5998         returns (uint256)
5999     {
6000         return state.positions[positionId].interestRate;
6001     }
6002 
6003     function getPositionRequiredDeposit(
6004         bytes32 positionId
6005     )
6006         external
6007         view
6008         returns (uint256)
6009     {
6010         return state.positions[positionId].requiredDeposit;
6011     }
6012 
6013     function getPositionStartTimestamp(
6014         bytes32 positionId
6015     )
6016         external
6017         view
6018         returns (uint32)
6019     {
6020         return state.positions[positionId].startTimestamp;
6021     }
6022 
6023     function getPositionCallTimestamp(
6024         bytes32 positionId
6025     )
6026         external
6027         view
6028         returns (uint32)
6029     {
6030         return state.positions[positionId].callTimestamp;
6031     }
6032 
6033     function getPositionCallTimeLimit(
6034         bytes32 positionId
6035     )
6036         external
6037         view
6038         returns (uint32)
6039     {
6040         return state.positions[positionId].callTimeLimit;
6041     }
6042 
6043     function getPositionMaxDuration(
6044         bytes32 positionId
6045     )
6046         external
6047         view
6048         returns (uint32)
6049     {
6050         return state.positions[positionId].maxDuration;
6051     }
6052 
6053     function getPositioninterestPeriod(
6054         bytes32 positionId
6055     )
6056         external
6057         view
6058         returns (uint32)
6059     {
6060         return state.positions[positionId].interestPeriod;
6061     }
6062 }
6063 
6064 // File: contracts/margin/impl/TransferImpl.sol
6065 
6066 /**
6067  * @title TransferImpl
6068  * @author dYdX
6069  *
6070  * This library contains the implementation for the transferPosition and transferLoan functions of
6071  * Margin
6072  */
6073 library TransferImpl {
6074 
6075     // ============ Public Implementation Functions ============
6076 
6077     function transferLoanImpl(
6078         MarginState.State storage state,
6079         bytes32 positionId,
6080         address newLender
6081     )
6082         public
6083     {
6084         require(
6085             MarginCommon.containsPositionImpl(state, positionId),
6086             "TransferImpl#transferLoanImpl: Position does not exist"
6087         );
6088 
6089         address originalLender = state.positions[positionId].lender;
6090 
6091         require(
6092             msg.sender == originalLender,
6093             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
6094         );
6095         require(
6096             newLender != originalLender,
6097             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
6098         );
6099 
6100         // Doesn't change the state of positionId; figures out the final owner of loan.
6101         // That is, newLender may pass ownership to a different address.
6102         address finalLender = TransferInternal.grantLoanOwnership(
6103             positionId,
6104             originalLender,
6105             newLender);
6106 
6107         require(
6108             finalLender != originalLender,
6109             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
6110         );
6111 
6112         // Set state only after resolving the new owner (to reduce the number of storage calls)
6113         state.positions[positionId].lender = finalLender;
6114     }
6115 
6116     function transferPositionImpl(
6117         MarginState.State storage state,
6118         bytes32 positionId,
6119         address newOwner
6120     )
6121         public
6122     {
6123         require(
6124             MarginCommon.containsPositionImpl(state, positionId),
6125             "TransferImpl#transferPositionImpl: Position does not exist"
6126         );
6127 
6128         address originalOwner = state.positions[positionId].owner;
6129 
6130         require(
6131             msg.sender == originalOwner,
6132             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
6133         );
6134         require(
6135             newOwner != originalOwner,
6136             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
6137         );
6138 
6139         // Doesn't change the state of positionId; figures out the final owner of position.
6140         // That is, newOwner may pass ownership to a different address.
6141         address finalOwner = TransferInternal.grantPositionOwnership(
6142             positionId,
6143             originalOwner,
6144             newOwner);
6145 
6146         require(
6147             finalOwner != originalOwner,
6148             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
6149         );
6150 
6151         // Set state only after resolving the new owner (to reduce the number of storage calls)
6152         state.positions[positionId].owner = finalOwner;
6153     }
6154 }
6155 
6156 // File: contracts/margin/Margin.sol
6157 
6158 /**
6159  * @title Margin
6160  * @author dYdX
6161  *
6162  * This contract is used to facilitate margin trading as per the dYdX protocol
6163  */
6164 contract Margin is
6165     ReentrancyGuard,
6166     MarginStorage,
6167     MarginEvents,
6168     MarginAdmin,
6169     LoanGetters,
6170     PositionGetters
6171 {
6172 
6173     using SafeMath for uint256;
6174 
6175     // ============ Constructor ============
6176 
6177     constructor(
6178         address vault,
6179         address proxy
6180     )
6181         public
6182         MarginAdmin()
6183     {
6184         state = MarginState.State({
6185             VAULT: vault,
6186             TOKEN_PROXY: proxy
6187         });
6188     }
6189 
6190     // ============ Public State Changing Functions ============
6191 
6192     /**
6193      * Open a margin position. Called by the margin trader who must provide both a
6194      * signed loan offering as well as a DEX Order with which to sell the owedToken.
6195      *
6196      * @param  addresses           Addresses corresponding to:
6197      *
6198      *  [0]  = position owner
6199      *  [1]  = owedToken
6200      *  [2]  = heldToken
6201      *  [3]  = loan payer
6202      *  [4]  = loan owner
6203      *  [5]  = loan taker
6204      *  [6]  = loan position owner
6205      *  [7]  = loan fee recipient
6206      *  [8]  = loan lender fee token
6207      *  [9]  = loan taker fee token
6208      *  [10]  = exchange wrapper address
6209      *
6210      * @param  values256           Values corresponding to:
6211      *
6212      *  [0]  = loan maximum amount
6213      *  [1]  = loan minimum amount
6214      *  [2]  = loan minimum heldToken
6215      *  [3]  = loan lender fee
6216      *  [4]  = loan taker fee
6217      *  [5]  = loan expiration timestamp (in seconds)
6218      *  [6]  = loan salt
6219      *  [7]  = position amount of principal
6220      *  [8]  = deposit amount
6221      *  [9]  = nonce (used to calculate positionId)
6222      *
6223      * @param  values32            Values corresponding to:
6224      *
6225      *  [0] = loan call time limit (in seconds)
6226      *  [1] = loan maxDuration (in seconds)
6227      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6228      *  [3] = loan interest update period (in seconds)
6229      *
6230      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6231      *                             False if the margin deposit will be in owedToken
6232      *                             and then sold along with the owedToken borrowed from the lender
6233      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6234      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6235      *                             is a smart contract, these are arbitrary bytes that the contract
6236      *                             will recieve when choosing whether to approve the loan.
6237      * @param  order               Order object to be passed to the exchange wrapper
6238      * @return                     Unique ID for the new position
6239      */
6240     function openPosition(
6241         address[11] addresses,
6242         uint256[10] values256,
6243         uint32[4]   values32,
6244         bool        depositInHeldToken,
6245         bytes       signature,
6246         bytes       order
6247     )
6248         external
6249         onlyWhileOperational
6250         nonReentrant
6251         returns (bytes32)
6252     {
6253         return OpenPositionImpl.openPositionImpl(
6254             state,
6255             addresses,
6256             values256,
6257             values32,
6258             depositInHeldToken,
6259             signature,
6260             order
6261         );
6262     }
6263 
6264     /**
6265      * Open a margin position without a counterparty. The caller will serve as both the
6266      * lender and the position owner
6267      *
6268      * @param  addresses    Addresses corresponding to:
6269      *
6270      *  [0]  = position owner
6271      *  [1]  = owedToken
6272      *  [2]  = heldToken
6273      *  [3]  = loan owner
6274      *
6275      * @param  values256    Values corresponding to:
6276      *
6277      *  [0]  = principal
6278      *  [1]  = deposit amount
6279      *  [2]  = nonce (used to calculate positionId)
6280      *
6281      * @param  values32     Values corresponding to:
6282      *
6283      *  [0] = call time limit (in seconds)
6284      *  [1] = maxDuration (in seconds)
6285      *  [2] = interest rate (annual nominal percentage times 10**6)
6286      *  [3] = interest update period (in seconds)
6287      *
6288      * @return              Unique ID for the new position
6289      */
6290     function openWithoutCounterparty(
6291         address[4] addresses,
6292         uint256[3] values256,
6293         uint32[4]  values32
6294     )
6295         external
6296         onlyWhileOperational
6297         nonReentrant
6298         returns (bytes32)
6299     {
6300         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6301             state,
6302             addresses,
6303             values256,
6304             values32
6305         );
6306     }
6307 
6308     /**
6309      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6310      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6311      * principal added, as it will incorporate interest already earned by the position so far.
6312      *
6313      * @param  positionId          Unique ID of the position
6314      * @param  addresses           Addresses corresponding to:
6315      *
6316      *  [0]  = loan payer
6317      *  [1]  = loan taker
6318      *  [2]  = loan position owner
6319      *  [3]  = loan fee recipient
6320      *  [4]  = loan lender fee token
6321      *  [5]  = loan taker fee token
6322      *  [6]  = exchange wrapper address
6323      *
6324      * @param  values256           Values corresponding to:
6325      *
6326      *  [0]  = loan maximum amount
6327      *  [1]  = loan minimum amount
6328      *  [2]  = loan minimum heldToken
6329      *  [3]  = loan lender fee
6330      *  [4]  = loan taker fee
6331      *  [5]  = loan expiration timestamp (in seconds)
6332      *  [6]  = loan salt
6333      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6334      *                                                           will be >= this amount)
6335      *
6336      * @param  values32            Values corresponding to:
6337      *
6338      *  [0] = loan call time limit (in seconds)
6339      *  [1] = loan maxDuration (in seconds)
6340      *
6341      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6342      *                             False if the margin deposit will be pulled in owedToken
6343      *                             and then sold along with the owedToken borrowed from the lender
6344      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6345      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6346      *                             is a smart contract, these are arbitrary bytes that the contract
6347      *                             will recieve when choosing whether to approve the loan.
6348      * @param  order               Order object to be passed to the exchange wrapper
6349      * @return                     Amount of owedTokens pulled from the lender
6350      */
6351     function increasePosition(
6352         bytes32    positionId,
6353         address[7] addresses,
6354         uint256[8] values256,
6355         uint32[2]  values32,
6356         bool       depositInHeldToken,
6357         bytes      signature,
6358         bytes      order
6359     )
6360         external
6361         onlyWhileOperational
6362         nonReentrant
6363         returns (uint256)
6364     {
6365         return IncreasePositionImpl.increasePositionImpl(
6366             state,
6367             positionId,
6368             addresses,
6369             values256,
6370             values32,
6371             depositInHeldToken,
6372             signature,
6373             order
6374         );
6375     }
6376 
6377     /**
6378      * Increase a position directly by putting up heldToken. The caller will serve as both the
6379      * lender and the position owner
6380      *
6381      * @param  positionId      Unique ID of the position
6382      * @param  principalToAdd  Principal amount to add to the position
6383      * @return                 Amount of heldToken pulled from the msg.sender
6384      */
6385     function increaseWithoutCounterparty(
6386         bytes32 positionId,
6387         uint256 principalToAdd
6388     )
6389         external
6390         onlyWhileOperational
6391         nonReentrant
6392         returns (uint256)
6393     {
6394         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6395             state,
6396             positionId,
6397             principalToAdd
6398         );
6399     }
6400 
6401     /**
6402      * Close a position. May be called by the owner or with the approval of the owner. May provide
6403      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6404      * is sent the resulting payout.
6405      *
6406      * @param  positionId            Unique ID of the position
6407      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6408      *                               closed is also bounded by:
6409      *                               1) The principal of the position
6410      *                               2) The amount allowed by the owner if closer != owner
6411      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6412      * @param  exchangeWrapper       Address of the exchange wrapper
6413      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6414      *                               False to pay out the payoutRecipient in owedToken
6415      * @param  order                 Order object to be passed to the exchange wrapper
6416      * @return                       Values corresponding to:
6417      *                               1) Principal of position closed
6418      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6419      *                                  owedToken otherwise) received by the payoutRecipient
6420      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6421      */
6422     function closePosition(
6423         bytes32 positionId,
6424         uint256 requestedCloseAmount,
6425         address payoutRecipient,
6426         address exchangeWrapper,
6427         bool    payoutInHeldToken,
6428         bytes   order
6429     )
6430         external
6431         closePositionStateControl
6432         nonReentrant
6433         returns (uint256, uint256, uint256)
6434     {
6435         return ClosePositionImpl.closePositionImpl(
6436             state,
6437             positionId,
6438             requestedCloseAmount,
6439             payoutRecipient,
6440             exchangeWrapper,
6441             payoutInHeldToken,
6442             order
6443         );
6444     }
6445 
6446     /**
6447      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6448      *
6449      * @param  positionId            Unique ID of the position
6450      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6451      *                               closed is also bounded by:
6452      *                               1) The principal of the position
6453      *                               2) The amount allowed by the owner if closer != owner
6454      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6455      * @return                       Values corresponding to:
6456      *                               1) Principal amount of position closed
6457      *                               2) Amount of heldToken received by the payoutRecipient
6458      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6459      */
6460     function closePositionDirectly(
6461         bytes32 positionId,
6462         uint256 requestedCloseAmount,
6463         address payoutRecipient
6464     )
6465         external
6466         closePositionDirectlyStateControl
6467         nonReentrant
6468         returns (uint256, uint256, uint256)
6469     {
6470         return ClosePositionImpl.closePositionImpl(
6471             state,
6472             positionId,
6473             requestedCloseAmount,
6474             payoutRecipient,
6475             address(0),
6476             true,
6477             new bytes(0)
6478         );
6479     }
6480 
6481     /**
6482      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6483      * Must be approved by both the position owner and lender.
6484      *
6485      * @param  positionId            Unique ID of the position
6486      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6487      *                               closed is also bounded by:
6488      *                               1) The principal of the position
6489      *                               2) The amount allowed by the owner if closer != owner
6490      *                               3) The amount allowed by the lender if closer != lender
6491      * @return                       Values corresponding to:
6492      *                               1) Principal amount of position closed
6493      *                               2) Amount of heldToken received by the msg.sender
6494      */
6495     function closeWithoutCounterparty(
6496         bytes32 positionId,
6497         uint256 requestedCloseAmount,
6498         address payoutRecipient
6499     )
6500         external
6501         closePositionStateControl
6502         nonReentrant
6503         returns (uint256, uint256)
6504     {
6505         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6506             state,
6507             positionId,
6508             requestedCloseAmount,
6509             payoutRecipient
6510         );
6511     }
6512 
6513     /**
6514      * Margin-call a position. Only callable with the approval of the position lender. After the
6515      * call, the position owner will have time equal to the callTimeLimit of the position to close
6516      * the position. If the owner does not close the position, the lender can recover the collateral
6517      * in the position.
6518      *
6519      * @param  positionId       Unique ID of the position
6520      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6521      *                          the margin-call. Passing in 0 means the margin call cannot be
6522      *                          canceled by depositing
6523      */
6524     function marginCall(
6525         bytes32 positionId,
6526         uint256 requiredDeposit
6527     )
6528         external
6529         nonReentrant
6530     {
6531         LoanImpl.marginCallImpl(
6532             state,
6533             positionId,
6534             requiredDeposit
6535         );
6536     }
6537 
6538     /**
6539      * Cancel a margin-call. Only callable with the approval of the position lender.
6540      *
6541      * @param  positionId  Unique ID of the position
6542      */
6543     function cancelMarginCall(
6544         bytes32 positionId
6545     )
6546         external
6547         onlyWhileOperational
6548         nonReentrant
6549     {
6550         LoanImpl.cancelMarginCallImpl(state, positionId);
6551     }
6552 
6553     /**
6554      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6555      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6556      * but remains unclosed. Only callable with the approval of the position lender.
6557      *
6558      * @param  positionId  Unique ID of the position
6559      * @param  recipient   Address to send the recovered tokens to
6560      * @return             Amount of heldToken recovered
6561      */
6562     function forceRecoverCollateral(
6563         bytes32 positionId,
6564         address recipient
6565     )
6566         external
6567         nonReentrant
6568         returns (uint256)
6569     {
6570         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6571             state,
6572             positionId,
6573             recipient
6574         );
6575     }
6576 
6577     /**
6578      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6579      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6580      *
6581      * @param  positionId       Unique ID of the position
6582      * @param  depositAmount    Additional amount in heldToken to deposit
6583      */
6584     function depositCollateral(
6585         bytes32 positionId,
6586         uint256 depositAmount
6587     )
6588         external
6589         onlyWhileOperational
6590         nonReentrant
6591     {
6592         DepositCollateralImpl.depositCollateralImpl(
6593             state,
6594             positionId,
6595             depositAmount
6596         );
6597     }
6598 
6599     /**
6600      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6601      *
6602      * @param  addresses     Array of addresses:
6603      *
6604      *  [0] = owedToken
6605      *  [1] = heldToken
6606      *  [2] = loan payer
6607      *  [3] = loan owner
6608      *  [4] = loan taker
6609      *  [5] = loan position owner
6610      *  [6] = loan fee recipient
6611      *  [7] = loan lender fee token
6612      *  [8] = loan taker fee token
6613      *
6614      * @param  values256     Values corresponding to:
6615      *
6616      *  [0] = loan maximum amount
6617      *  [1] = loan minimum amount
6618      *  [2] = loan minimum heldToken
6619      *  [3] = loan lender fee
6620      *  [4] = loan taker fee
6621      *  [5] = loan expiration timestamp (in seconds)
6622      *  [6] = loan salt
6623      *
6624      * @param  values32      Values corresponding to:
6625      *
6626      *  [0] = loan call time limit (in seconds)
6627      *  [1] = loan maxDuration (in seconds)
6628      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6629      *  [3] = loan interest update period (in seconds)
6630      *
6631      * @param  cancelAmount  Amount to cancel
6632      * @return               Amount that was canceled
6633      */
6634     function cancelLoanOffering(
6635         address[9] addresses,
6636         uint256[7]  values256,
6637         uint32[4]   values32,
6638         uint256     cancelAmount
6639     )
6640         external
6641         cancelLoanOfferingStateControl
6642         nonReentrant
6643         returns (uint256)
6644     {
6645         return LoanImpl.cancelLoanOfferingImpl(
6646             state,
6647             addresses,
6648             values256,
6649             values32,
6650             cancelAmount
6651         );
6652     }
6653 
6654     /**
6655      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6656      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6657      * must implement the LoanOwner interface.
6658      *
6659      * @param  positionId  Unique ID of the position
6660      * @param  who         New owner of the loan
6661      */
6662     function transferLoan(
6663         bytes32 positionId,
6664         address who
6665     )
6666         external
6667         nonReentrant
6668     {
6669         TransferImpl.transferLoanImpl(
6670             state,
6671             positionId,
6672             who);
6673     }
6674 
6675     /**
6676      * Transfer ownership of a position to a new address. This new address will be entitled to all
6677      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6678      * the PositionOwner interface.
6679      *
6680      * @param  positionId  Unique ID of the position
6681      * @param  who         New owner of the position
6682      */
6683     function transferPosition(
6684         bytes32 positionId,
6685         address who
6686     )
6687         external
6688         nonReentrant
6689     {
6690         TransferImpl.transferPositionImpl(
6691             state,
6692             positionId,
6693             who);
6694     }
6695 
6696     // ============ Public Constant Functions ============
6697 
6698     /**
6699      * Gets the address of the Vault contract that holds and accounts for tokens.
6700      *
6701      * @return  The address of the Vault contract
6702      */
6703     function getVaultAddress()
6704         external
6705         view
6706         returns (address)
6707     {
6708         return state.VAULT;
6709     }
6710 
6711     /**
6712      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6713      * make loans or open/close positions.
6714      *
6715      * @return  The address of the TokenProxy contract
6716      */
6717     function getTokenProxyAddress()
6718         external
6719         view
6720         returns (address)
6721     {
6722         return state.TOKEN_PROXY;
6723     }
6724 }
6725 
6726 // File: contracts/margin/interfaces/OnlyMargin.sol
6727 
6728 /**
6729  * @title OnlyMargin
6730  * @author dYdX
6731  *
6732  * Contract to store the address of the main Margin contract and trust only that address to call
6733  * certain functions.
6734  */
6735 contract OnlyMargin {
6736 
6737     // ============ Constants ============
6738 
6739     // Address of the known and trusted Margin contract on the blockchain
6740     address public DYDX_MARGIN;
6741 
6742     // ============ Constructor ============
6743 
6744     constructor(
6745         address margin
6746     )
6747         public
6748     {
6749         DYDX_MARGIN = margin;
6750     }
6751 
6752     // ============ Modifiers ============
6753 
6754     modifier onlyMargin()
6755     {
6756         require(
6757             msg.sender == DYDX_MARGIN,
6758             "OnlyMargin#onlyMargin: Only Margin can call"
6759         );
6760 
6761         _;
6762     }
6763 }
6764 
6765 // File: contracts/margin/external/interfaces/PositionCustodian.sol
6766 
6767 /**
6768  * @title PositionCustodian
6769  * @author dYdX
6770  *
6771  * Interface to interact with other second-layer contracts. For contracts that own positions as a
6772  * proxy for other addresses.
6773  */
6774 interface PositionCustodian {
6775 
6776     /**
6777      * Function that is intended to be called by external contracts to see where to pay any fees or
6778      * tokens as a result of closing a position on behalf of another contract.
6779      *
6780      * @param  positionId   Unique ID of the position
6781      * @return              Address of the true owner of the position
6782      */
6783     function getPositionDeedHolder(
6784         bytes32 positionId
6785     )
6786         external
6787         view
6788         returns (address);
6789 }
6790 
6791 // File: contracts/margin/external/lib/MarginHelper.sol
6792 
6793 /**
6794  * @title MarginHelper
6795  * @author dYdX
6796  *
6797  * This library contains helper functions for interacting with Margin
6798  */
6799 library MarginHelper {
6800     function getPosition(
6801         address DYDX_MARGIN,
6802         bytes32 positionId
6803     )
6804         internal
6805         view
6806         returns (MarginCommon.Position memory)
6807     {
6808         (
6809             address[4] memory addresses,
6810             uint256[2] memory values256,
6811             uint32[6]  memory values32
6812         ) = Margin(DYDX_MARGIN).getPosition(positionId);
6813 
6814         return MarginCommon.Position({
6815             owedToken: addresses[0],
6816             heldToken: addresses[1],
6817             lender: addresses[2],
6818             owner: addresses[3],
6819             principal: values256[0],
6820             requiredDeposit: values256[1],
6821             callTimeLimit: values32[0],
6822             startTimestamp: values32[1],
6823             callTimestamp: values32[2],
6824             maxDuration: values32[3],
6825             interestRate: values32[4],
6826             interestPeriod: values32[5]
6827         });
6828     }
6829 }
6830 
6831 // File: contracts/margin/external/ERC20/ERC20Position.sol
6832 
6833 /**
6834  * @title ERC20Position
6835  * @author dYdX
6836  *
6837  * Shared code for ERC20Short and ERC20Long
6838  */
6839 contract ERC20Position is
6840     ReentrancyGuard,
6841     StandardToken,
6842     OnlyMargin,
6843     PositionOwner,
6844     IncreasePositionDelegator,
6845     ClosePositionDelegator,
6846     PositionCustodian
6847 {
6848     using SafeMath for uint256;
6849 
6850     // ============ Enums ============
6851 
6852     enum State {
6853         UNINITIALIZED,
6854         OPEN,
6855         CLOSED
6856     }
6857 
6858     // ============ Events ============
6859 
6860     /**
6861      * This ERC20 was successfully initialized
6862      */
6863     event Initialized(
6864         bytes32 positionId,
6865         uint256 initialSupply
6866     );
6867 
6868     /**
6869      * The position was completely closed by a trusted third-party and tokens can be withdrawn
6870      */
6871     event ClosedByTrustedParty(
6872         address closer,
6873         uint256 tokenAmount,
6874         address payoutRecipient
6875     );
6876 
6877     /**
6878      * The position was completely closed and tokens can be withdrawn
6879      */
6880     event CompletelyClosed();
6881 
6882     /**
6883      * A user burned tokens to withdraw heldTokens from this contract after the position was closed
6884      */
6885     event Withdraw(
6886         address indexed redeemer,
6887         uint256 tokensRedeemed,
6888         uint256 heldTokenPayout
6889     );
6890 
6891     /**
6892      * A user burned tokens in order to partially close the position
6893      */
6894     event Close(
6895         address indexed redeemer,
6896         uint256 closeAmount
6897     );
6898 
6899     // ============ State Variables ============
6900 
6901     // All tokens will initially be allocated to this address
6902     address public INITIAL_TOKEN_HOLDER;
6903 
6904     // Unique ID of the position this contract is tokenizing
6905     bytes32 public POSITION_ID;
6906 
6907     // Recipients that will fairly verify and redistribute funds from closing the position
6908     mapping (address => bool) public TRUSTED_RECIPIENTS;
6909 
6910     // Withdrawers that will fairly withdraw funds after the position has been closed
6911     mapping (address => bool) public TRUSTED_WITHDRAWERS;
6912 
6913     // Current State of this contract. See State enum
6914     State public state;
6915 
6916     // Address of the position's heldToken. Cached for convenience and lower-cost withdrawals
6917     address public heldToken;
6918 
6919     // Position has been closed using a trusted recipient
6920     bool public closedUsingTrustedRecipient;
6921 
6922     // ============ Modifiers ============
6923 
6924     modifier onlyPosition(bytes32 positionId) {
6925         require(
6926             POSITION_ID == positionId,
6927             "ERC20Position#onlyPosition: Incorrect position"
6928         );
6929         _;
6930     }
6931 
6932     modifier onlyState(State specificState) {
6933         require(
6934             state == specificState,
6935             "ERC20Position#onlyState: Incorrect State"
6936         );
6937         _;
6938     }
6939 
6940     // ============ Constructor ============
6941 
6942     constructor(
6943         bytes32 positionId,
6944         address margin,
6945         address initialTokenHolder,
6946         address[] trustedRecipients,
6947         address[] trustedWithdrawers
6948     )
6949         public
6950         OnlyMargin(margin)
6951     {
6952         POSITION_ID = positionId;
6953         state = State.UNINITIALIZED;
6954         INITIAL_TOKEN_HOLDER = initialTokenHolder;
6955         closedUsingTrustedRecipient = false;
6956 
6957         uint256 i;
6958         for (i = 0; i < trustedRecipients.length; i++) {
6959             TRUSTED_RECIPIENTS[trustedRecipients[i]] = true;
6960         }
6961         for (i = 0; i < trustedWithdrawers.length; i++) {
6962             TRUSTED_WITHDRAWERS[trustedWithdrawers[i]] = true;
6963         }
6964     }
6965 
6966     // ============ Margin-Only Functions ============
6967 
6968     /**
6969      * Called by Margin when anyone transfers ownership of a position to this contract.
6970      * This function initializes the tokenization of the position given and returns this address to
6971      * indicate to Margin that it is willing to take ownership of the position.
6972      *
6973      *  param  (unused)
6974      * @param  positionId  Unique ID of the position
6975      * @return             This address on success, throw otherwise
6976      */
6977     function receivePositionOwnership(
6978         address /* from */,
6979         bytes32 positionId
6980     )
6981         external
6982         onlyMargin
6983         nonReentrant
6984         onlyState(State.UNINITIALIZED)
6985         onlyPosition(positionId)
6986         returns (address)
6987     {
6988         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
6989         assert(position.principal > 0);
6990 
6991         // set relevant constants
6992         state = State.OPEN;
6993         heldToken = position.heldToken;
6994 
6995         uint256 tokenAmount = getTokenAmountOnAdd(position.principal);
6996 
6997         emit Initialized(POSITION_ID, tokenAmount);
6998 
6999         mint(INITIAL_TOKEN_HOLDER, tokenAmount);
7000 
7001         return address(this); // returning own address retains ownership of position
7002     }
7003 
7004     /**
7005      * Called by Margin when additional value is added onto the position this contract
7006      * owns. Tokens are minted and assigned to the address that added the value.
7007      *
7008      * @param  trader          Address that added the value to the position
7009      * @param  positionId      Unique ID of the position
7010      * @param  principalAdded  Amount that was added to the position
7011      * @return                 This address on success, throw otherwise
7012      */
7013     function increasePositionOnBehalfOf(
7014         address trader,
7015         bytes32 positionId,
7016         uint256 principalAdded
7017     )
7018         external
7019         onlyMargin
7020         nonReentrant
7021         onlyState(State.OPEN)
7022         onlyPosition(positionId)
7023         returns (address)
7024     {
7025         require(
7026             !Margin(DYDX_MARGIN).isPositionCalled(POSITION_ID),
7027             "ERC20Position#increasePositionOnBehalfOf: Position is margin-called"
7028         );
7029         require(
7030             !closedUsingTrustedRecipient,
7031             "ERC20Position#increasePositionOnBehalfOf: Position closed using trusted recipient"
7032         );
7033 
7034         uint256 tokenAmount = getTokenAmountOnAdd(principalAdded);
7035 
7036         mint(trader, tokenAmount);
7037 
7038         return address(this);
7039     }
7040 
7041     /**
7042      * Called by Margin when an owner of this token is attempting to close some of the
7043      * position. Implementation is required per PositionOwner contract in order to be used by
7044      * Margin to approve closing parts of a position.
7045      *
7046      * @param  closer           Address of the caller of the close function
7047      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
7048      * @param  positionId       Unique ID of the position
7049      * @param  requestedAmount  Amount (in principal) of the position being closed
7050      * @return                  1) This address to accept, a different address to ask that contract
7051      *                          2) The maximum amount that this contract is allowing
7052      */
7053     function closeOnBehalfOf(
7054         address closer,
7055         address payoutRecipient,
7056         bytes32 positionId,
7057         uint256 requestedAmount
7058     )
7059         external
7060         onlyMargin
7061         nonReentrant
7062         onlyState(State.OPEN)
7063         onlyPosition(positionId)
7064         returns (address, uint256)
7065     {
7066         uint256 positionPrincipal = Margin(DYDX_MARGIN).getPositionPrincipal(positionId);
7067 
7068         assert(requestedAmount <= positionPrincipal);
7069 
7070         uint256 allowedAmount;
7071         if (TRUSTED_RECIPIENTS[payoutRecipient]) {
7072             allowedAmount = closeUsingTrustedRecipient(
7073                 closer,
7074                 payoutRecipient,
7075                 requestedAmount
7076             );
7077         } else {
7078             allowedAmount = close(
7079                 closer,
7080                 requestedAmount,
7081                 positionPrincipal
7082             );
7083         }
7084 
7085         assert(allowedAmount > 0);
7086         assert(allowedAmount <= requestedAmount);
7087 
7088         if (allowedAmount == positionPrincipal) {
7089             state = State.CLOSED;
7090             emit CompletelyClosed();
7091         }
7092 
7093         return (address(this), allowedAmount);
7094     }
7095 
7096     // ============ Public State Changing Functions ============
7097 
7098     /**
7099      * Withdraw heldTokens from this contract for any of the position that was closed via external
7100      * means (such as an auction-closing mechanism)
7101      *
7102      * NOTE: It is possible that this contract could be sent heldToken by external sources
7103      * other than from the Margin contract. In this case the payout for token holders
7104      * would be greater than just that from the normal payout. This is fine because
7105      * nobody has incentive to send this contract extra funds, and if they do then it's
7106      * also fine just to let the token holders have it.
7107      *
7108      * NOTE: If there are significant rounding errors, then it is possible that withdrawing later is
7109      * more advantageous. An "attack" could involve withdrawing for others before withdrawing for
7110      * yourself. Likely, rounding error will be small enough to not properly incentivize people to
7111      * carry out such an attack.
7112      *
7113      * @param  onBehalfOf  Address of the account to withdraw for
7114      * @return             The amount of heldToken withdrawn
7115      */
7116     function withdraw(
7117         address onBehalfOf
7118     )
7119         external
7120         nonReentrant
7121         returns (uint256)
7122     {
7123         setStateClosedIfClosed();
7124         require(
7125             state == State.CLOSED,
7126             "ERC20Position#withdraw: Position has not yet been closed"
7127         );
7128 
7129         if (msg.sender != onBehalfOf) {
7130             require(
7131                 TRUSTED_WITHDRAWERS[msg.sender],
7132                 "ERC20Position#withdraw: Only trusted withdrawers can withdraw on behalf of others"
7133             );
7134         }
7135 
7136         return withdrawImpl(msg.sender, onBehalfOf);
7137     }
7138 
7139     // ============ Public Constant Functions ============
7140 
7141     /**
7142      * ERC20 decimals function. Returns the same number of decimals as the position's owedToken
7143      *
7144      * @return  The number of decimal places, or revert if the baseToken has no such function.
7145      */
7146     function decimals()
7147         external
7148         view
7149         returns (uint8);
7150 
7151     /**
7152      * ERC20 symbol function.
7153      *
7154      * @return  The symbol of the Margin Token
7155      */
7156     function symbol()
7157         external
7158         view
7159         returns (string);
7160 
7161     /**
7162      * Implements PositionCustodian functionality. Called by external contracts to see where to pay
7163      * tokens as a result of closing a position on behalf of this contract
7164      *
7165      * @param  positionId  Unique ID of the position
7166      * @return             Address of this contract. Indicates funds should be sent to this contract
7167      */
7168     function getPositionDeedHolder(
7169         bytes32 positionId
7170     )
7171         external
7172         view
7173         onlyPosition(positionId)
7174         returns (address)
7175     {
7176         // Claim ownership of deed and allow token holders to withdraw funds from this contract
7177         return address(this);
7178     }
7179 
7180     // ============ Internal Helper-Functions ============
7181 
7182     /**
7183      * Tokens are not burned when a trusted recipient is used, but we require the position to be
7184      * completely closed. All token holders are then entitled to the heldTokens in the contract
7185      */
7186     function closeUsingTrustedRecipient(
7187         address closer,
7188         address payoutRecipient,
7189         uint256 requestedAmount
7190     )
7191         internal
7192         returns (uint256)
7193     {
7194         assert(requestedAmount > 0);
7195 
7196         // remember that a trusted recipient was used
7197         if (!closedUsingTrustedRecipient) {
7198             closedUsingTrustedRecipient = true;
7199         }
7200 
7201         emit ClosedByTrustedParty(closer, requestedAmount, payoutRecipient);
7202 
7203         return requestedAmount;
7204     }
7205 
7206     // ============ Private Helper-Functions ============
7207 
7208     function withdrawImpl(
7209         address receiver,
7210         address onBehalfOf
7211     )
7212         private
7213         returns (uint256)
7214     {
7215         uint256 value = balanceOf(onBehalfOf);
7216 
7217         if (value == 0) {
7218             return 0;
7219         }
7220 
7221         uint256 heldTokenBalance = TokenInteract.balanceOf(heldToken, address(this));
7222 
7223         // NOTE the payout must be calculated before decrementing the totalSupply below
7224         uint256 heldTokenPayout = MathHelpers.getPartialAmount(
7225             value,
7226             totalSupply_,
7227             heldTokenBalance
7228         );
7229 
7230         // Destroy the margin tokens
7231         burn(onBehalfOf, value);
7232         emit Withdraw(onBehalfOf, value, heldTokenPayout);
7233 
7234         // Send the redeemer their proportion of heldToken
7235         TokenInteract.transfer(heldToken, receiver, heldTokenPayout);
7236 
7237         return heldTokenPayout;
7238     }
7239 
7240     function setStateClosedIfClosed(
7241     )
7242         private
7243     {
7244         // If in OPEN state, but the position is closed, set to CLOSED state
7245         if (state == State.OPEN && Margin(DYDX_MARGIN).isPositionClosed(POSITION_ID)) {
7246             state = State.CLOSED;
7247             emit CompletelyClosed();
7248         }
7249     }
7250 
7251     function close(
7252         address closer,
7253         uint256 requestedAmount,
7254         uint256 positionPrincipal
7255     )
7256         private
7257         returns (uint256)
7258     {
7259         uint256 balance = balances[closer];
7260 
7261         (
7262             uint256 tokenAmount,
7263             uint256 allowedCloseAmount
7264         ) = getCloseAmounts(
7265             requestedAmount,
7266             balance,
7267             positionPrincipal
7268         );
7269 
7270         require(
7271             tokenAmount > 0 && allowedCloseAmount > 0,
7272             "ERC20Position#close: Cannot close 0 amount"
7273         );
7274 
7275         assert(allowedCloseAmount <= requestedAmount);
7276 
7277         burn(closer, tokenAmount);
7278 
7279         emit Close(closer, tokenAmount);
7280 
7281         return allowedCloseAmount;
7282     }
7283 
7284     function burn(
7285         address from,
7286         uint256 amount
7287     )
7288         private
7289     {
7290         assert(from != address(0));
7291         totalSupply_ = totalSupply_.sub(amount);
7292         balances[from] = balances[from].sub(amount);
7293         emit Transfer(from, address(0), amount);
7294     }
7295 
7296     function mint(
7297         address to,
7298         uint256 amount
7299     )
7300         private
7301     {
7302         assert(to != address(0));
7303         totalSupply_ = totalSupply_.add(amount);
7304         balances[to] = balances[to].add(amount);
7305         emit Transfer(address(0), to, amount);
7306     }
7307 
7308     // ============ Private Abstract Functions ============
7309 
7310     function getTokenAmountOnAdd(
7311         uint256 principalAdded
7312     )
7313         internal
7314         view
7315         returns (uint256);
7316 
7317     function getCloseAmounts(
7318         uint256 requestedCloseAmount,
7319         uint256 balance,
7320         uint256 positionPrincipal
7321     )
7322         private
7323         view
7324         returns (
7325             uint256 /* tokenAmount */,
7326             uint256 /* allowedCloseAmount */
7327         );
7328 }
7329 
7330 // File: contracts/margin/external/ERC20/ERC20PositionWithdrawerV2.sol
7331 
7332 /**
7333  * @title ERC20PositionWithdrawerV2
7334  * @author dYdX
7335  *
7336  * Proxy contract to withdraw from an ERC20Position and exchange the withdrawn tokens on a DEX, or
7337  * to unwrap WETH to ETH.
7338  */
7339 contract ERC20PositionWithdrawerV2
7340 {
7341     using TokenInteract for address;
7342 
7343     // ============ Constants ============
7344 
7345     address public WETH;
7346 
7347     // ============ Constructor ============
7348 
7349     constructor(
7350         address weth
7351     )
7352         public
7353     {
7354         WETH = weth;
7355     }
7356 
7357     // ============ Public Functions ============
7358 
7359     /**
7360      * Fallback function. Disallows ether to be sent to this contract without data except when
7361      * unwrapping WETH.
7362      */
7363     function ()
7364         external
7365         payable
7366     {
7367         require( // coverage-disable-line
7368             msg.sender == WETH,
7369             "PayableMarginMinter#fallback: Cannot recieve ETH directly unless unwrapping WETH"
7370         );
7371     }
7372 
7373     /**
7374      * After a Margin Position (that backs a ERC20 Margin Token) is closed, the remaining Margin
7375      * Token holders are able to withdraw the Margin Position's heldToken from the Margin Token
7376      * contract. This function allows a holder to atomically withdraw the token and trade it for a
7377      * different ERC20 before returning the funds to the holder.
7378      *
7379      * @param  erc20Position    The address of the ERC20Position contract to withdraw from
7380      * @param  returnedToken    The address of the token that is returned to the token holder
7381      * @param  exchangeWrapper  The address of the ExchangeWrapper
7382      * @param  orderData        Arbitrary bytes data for any information to pass to the exchange
7383      * @return                  [1] The number of tokens withdrawn
7384      *                          [2] The number of tokens returned to the user
7385      */
7386     function withdraw(
7387         address erc20Position,
7388         address returnedToken,
7389         address exchangeWrapper,
7390         bytes orderData
7391     )
7392         external
7393         returns (uint256, uint256)
7394     {
7395         // withdraw tokens
7396         uint256 tokensWithdrawn = ERC20Position(erc20Position).withdraw(msg.sender);
7397         if (tokensWithdrawn == 0) {
7398             return (0, 0);
7399         }
7400 
7401         // do the exchange
7402         address withdrawnToken = ERC20Position(erc20Position).heldToken();
7403         withdrawnToken.transfer(exchangeWrapper, tokensWithdrawn);
7404         uint256 tokensReturned = ExchangeWrapper(exchangeWrapper).exchange(
7405             msg.sender,
7406             address(this),
7407             returnedToken,
7408             withdrawnToken,
7409             tokensWithdrawn,
7410             orderData
7411         );
7412 
7413         // return returnedToken back to msg.sender
7414         if (returnedToken == WETH) {
7415             // take the WETH back, withdraw into ETH, and send to the msg.sender
7416             returnedToken.transferFrom(exchangeWrapper, address(this), tokensReturned);
7417             WETH9(returnedToken).withdraw(tokensReturned);
7418             msg.sender.transfer(tokensReturned);
7419         } else {
7420             // send the tokens directly to the msg.sender
7421             returnedToken.transferFrom(exchangeWrapper, msg.sender, tokensReturned);
7422         }
7423 
7424         return (tokensWithdrawn, tokensReturned);
7425     }
7426 
7427     /**
7428      * Withdraw WETH tokens from a position, unwrap the tokens, and send back to the trader
7429      *
7430      * @param  erc20Position  The address of the ERC20Position contract to withdraw from
7431      * @return                The amount of ETH withdrawn
7432      */
7433     function withdrawAsEth(
7434         address erc20Position
7435     )
7436         external
7437         returns (uint256)
7438     {
7439         // verify that WETH will be withdrawn
7440         address token = ERC20Position(erc20Position).heldToken();
7441         require(
7442             token == WETH,
7443             "ERC20PositionWithdrawer#withdrawAsEth: Withdrawn token must be WETH"
7444         );
7445 
7446         // withdraw tokens
7447         uint256 amount = ERC20Position(erc20Position).withdraw(msg.sender);
7448         WETH9(token).withdraw(amount);
7449         msg.sender.transfer(amount);
7450 
7451         return amount;
7452     }
7453 }