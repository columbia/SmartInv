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
74 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
75 
76 /**
77  * @title Ownable
78  * @dev The Ownable contract has an owner address, and provides basic authorization control
79  * functions, this simplifies the implementation of "user permissions".
80  */
81 contract Ownable {
82   address public owner;
83 
84   event OwnershipRenounced(address indexed previousOwner);
85   event OwnershipTransferred(
86     address indexed previousOwner,
87     address indexed newOwner
88   );
89 
90   /**
91    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92    * account.
93    */
94   constructor() public {
95     owner = msg.sender;
96   }
97 
98   /**
99    * @dev Throws if called by any account other than the owner.
100    */
101   modifier onlyOwner() {
102     require(msg.sender == owner);
103     _;
104   }
105 
106   /**
107    * @dev Allows the current owner to relinquish control of the contract.
108    * @notice Renouncing to ownership will leave the contract without an owner.
109    * It will not be possible to call the functions with the `onlyOwner`
110    * modifier anymore.
111    */
112   function renounceOwnership() public onlyOwner {
113     emit OwnershipRenounced(owner);
114     owner = address(0);
115   }
116 
117   /**
118    * @dev Allows the current owner to transfer control of the contract to a newOwner.
119    * @param _newOwner The address to transfer ownership to.
120    */
121   function transferOwnership(address _newOwner) public onlyOwner {
122     _transferOwnership(_newOwner);
123   }
124 
125   /**
126    * @dev Transfers control of the contract to a newOwner.
127    * @param _newOwner The address to transfer ownership to.
128    */
129   function _transferOwnership(address _newOwner) internal {
130     require(_newOwner != address(0));
131     emit OwnershipTransferred(owner, _newOwner);
132     owner = _newOwner;
133   }
134 }
135 
136 // File: openzeppelin-solidity/contracts/math/Math.sol
137 
138 /**
139  * @title Math
140  * @dev Assorted math operations
141  */
142 library Math {
143   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
144     return _a >= _b ? _a : _b;
145   }
146 
147   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
148     return _a < _b ? _a : _b;
149   }
150 
151   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
152     return _a >= _b ? _a : _b;
153   }
154 
155   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
156     return _a < _b ? _a : _b;
157   }
158 }
159 
160 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
161 
162 /**
163  * @title ERC20Basic
164  * @dev Simpler version of ERC20 interface
165  * See https://github.com/ethereum/EIPs/issues/179
166  */
167 contract ERC20Basic {
168   function totalSupply() public view returns (uint256);
169   function balanceOf(address _who) public view returns (uint256);
170   function transfer(address _to, uint256 _value) public returns (bool);
171   event Transfer(address indexed from, address indexed to, uint256 value);
172 }
173 
174 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
175 
176 /**
177  * @title Basic token
178  * @dev Basic version of StandardToken, with no allowances.
179  */
180 contract BasicToken is ERC20Basic {
181   using SafeMath for uint256;
182 
183   mapping(address => uint256) internal balances;
184 
185   uint256 internal totalSupply_;
186 
187   /**
188   * @dev Total number of tokens in existence
189   */
190   function totalSupply() public view returns (uint256) {
191     return totalSupply_;
192   }
193 
194   /**
195   * @dev Transfer token for a specified address
196   * @param _to The address to transfer to.
197   * @param _value The amount to be transferred.
198   */
199   function transfer(address _to, uint256 _value) public returns (bool) {
200     require(_value <= balances[msg.sender]);
201     require(_to != address(0));
202 
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     emit Transfer(msg.sender, _to, _value);
206     return true;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public view returns (uint256) {
215     return balances[_owner];
216   }
217 
218 }
219 
220 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
221 
222 /**
223  * @title ERC20 interface
224  * @dev see https://github.com/ethereum/EIPs/issues/20
225  */
226 contract ERC20 is ERC20Basic {
227   function allowance(address _owner, address _spender)
228     public view returns (uint256);
229 
230   function transferFrom(address _from, address _to, uint256 _value)
231     public returns (bool);
232 
233   function approve(address _spender, uint256 _value) public returns (bool);
234   event Approval(
235     address indexed owner,
236     address indexed spender,
237     uint256 value
238   );
239 }
240 
241 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
242 
243 /**
244  * @title Standard ERC20 token
245  *
246  * @dev Implementation of the basic standard token.
247  * https://github.com/ethereum/EIPs/issues/20
248  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
249  */
250 contract StandardToken is ERC20, BasicToken {
251 
252   mapping (address => mapping (address => uint256)) internal allowed;
253 
254   /**
255    * @dev Transfer tokens from one address to another
256    * @param _from address The address which you want to send tokens from
257    * @param _to address The address which you want to transfer to
258    * @param _value uint256 the amount of tokens to be transferred
259    */
260   function transferFrom(
261     address _from,
262     address _to,
263     uint256 _value
264   )
265     public
266     returns (bool)
267   {
268     require(_value <= balances[_from]);
269     require(_value <= allowed[_from][msg.sender]);
270     require(_to != address(0));
271 
272     balances[_from] = balances[_from].sub(_value);
273     balances[_to] = balances[_to].add(_value);
274     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
275     emit Transfer(_from, _to, _value);
276     return true;
277   }
278 
279   /**
280    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
281    * Beware that changing an allowance with this method brings the risk that someone may use both the old
282    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
283    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
284    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
285    * @param _spender The address which will spend the funds.
286    * @param _value The amount of tokens to be spent.
287    */
288   function approve(address _spender, uint256 _value) public returns (bool) {
289     allowed[msg.sender][_spender] = _value;
290     emit Approval(msg.sender, _spender, _value);
291     return true;
292   }
293 
294   /**
295    * @dev Function to check the amount of tokens that an owner allowed to a spender.
296    * @param _owner address The address which owns the funds.
297    * @param _spender address The address which will spend the funds.
298    * @return A uint256 specifying the amount of tokens still available for the spender.
299    */
300   function allowance(
301     address _owner,
302     address _spender
303    )
304     public
305     view
306     returns (uint256)
307   {
308     return allowed[_owner][_spender];
309   }
310 
311   /**
312    * @dev Increase the amount of tokens that an owner allowed to a spender.
313    * approve should be called when allowed[_spender] == 0. To increment
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(
321     address _spender,
322     uint256 _addedValue
323   )
324     public
325     returns (bool)
326   {
327     allowed[msg.sender][_spender] = (
328       allowed[msg.sender][_spender].add(_addedValue));
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333   /**
334    * @dev Decrease the amount of tokens that an owner allowed to a spender.
335    * approve should be called when allowed[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(
343     address _spender,
344     uint256 _subtractedValue
345   )
346     public
347     returns (bool)
348   {
349     uint256 oldValue = allowed[msg.sender][_spender];
350     if (_subtractedValue >= oldValue) {
351       allowed[msg.sender][_spender] = 0;
352     } else {
353       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
354     }
355     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356     return true;
357   }
358 
359 }
360 
361 // File: contracts/lib/AccessControlledBase.sol
362 
363 /**
364  * @title AccessControlledBase
365  * @author dYdX
366  *
367  * Base functionality for access control. Requires an implementation to
368  * provide a way to grant and optionally revoke access
369  */
370 contract AccessControlledBase {
371     // ============ State Variables ============
372 
373     mapping (address => bool) public authorized;
374 
375     // ============ Events ============
376 
377     event AccessGranted(
378         address who
379     );
380 
381     event AccessRevoked(
382         address who
383     );
384 
385     // ============ Modifiers ============
386 
387     modifier requiresAuthorization() {
388         require(
389             authorized[msg.sender],
390             "AccessControlledBase#requiresAuthorization: Sender not authorized"
391         );
392         _;
393     }
394 }
395 
396 // File: contracts/lib/StaticAccessControlled.sol
397 
398 /**
399  * @title StaticAccessControlled
400  * @author dYdX
401  *
402  * Allows for functions to be access controled
403  * Permissions cannot be changed after a grace period
404  */
405 contract StaticAccessControlled is AccessControlledBase, Ownable {
406     using SafeMath for uint256;
407 
408     // ============ State Variables ============
409 
410     // Timestamp after which no additional access can be granted
411     uint256 public GRACE_PERIOD_EXPIRATION;
412 
413     // ============ Constructor ============
414 
415     constructor(
416         uint256 gracePeriod
417     )
418         public
419         Ownable()
420     {
421         GRACE_PERIOD_EXPIRATION = block.timestamp.add(gracePeriod);
422     }
423 
424     // ============ Owner-Only State-Changing Functions ============
425 
426     function grantAccess(
427         address who
428     )
429         external
430         onlyOwner
431     {
432         require(
433             block.timestamp < GRACE_PERIOD_EXPIRATION,
434             "StaticAccessControlled#grantAccess: Cannot grant access after grace period"
435         );
436 
437         emit AccessGranted(who);
438         authorized[who] = true;
439     }
440 }
441 
442 // File: contracts/lib/GeneralERC20.sol
443 
444 /**
445  * @title GeneralERC20
446  * @author dYdX
447  *
448  * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so
449  * that we dont automatically revert when calling non-compliant tokens that have no return value for
450  * transfer(), transferFrom(), or approve().
451  */
452 interface GeneralERC20 {
453     function totalSupply(
454     )
455         external
456         view
457         returns (uint256);
458 
459     function balanceOf(
460         address who
461     )
462         external
463         view
464         returns (uint256);
465 
466     function allowance(
467         address owner,
468         address spender
469     )
470         external
471         view
472         returns (uint256);
473 
474     function transfer(
475         address to,
476         uint256 value
477     )
478         external;
479 
480     function transferFrom(
481         address from,
482         address to,
483         uint256 value
484     )
485         external;
486 
487     function approve(
488         address spender,
489         uint256 value
490     )
491         external;
492 }
493 
494 // File: contracts/lib/TokenInteract.sol
495 
496 /**
497  * @title TokenInteract
498  * @author dYdX
499  *
500  * This library contains basic functions for interacting with ERC20 tokens
501  */
502 library TokenInteract {
503     function balanceOf(
504         address token,
505         address owner
506     )
507         internal
508         view
509         returns (uint256)
510     {
511         return GeneralERC20(token).balanceOf(owner);
512     }
513 
514     function allowance(
515         address token,
516         address owner,
517         address spender
518     )
519         internal
520         view
521         returns (uint256)
522     {
523         return GeneralERC20(token).allowance(owner, spender);
524     }
525 
526     function approve(
527         address token,
528         address spender,
529         uint256 amount
530     )
531         internal
532     {
533         GeneralERC20(token).approve(spender, amount);
534 
535         require(
536             checkSuccess(),
537             "TokenInteract#approve: Approval failed"
538         );
539     }
540 
541     function transfer(
542         address token,
543         address to,
544         uint256 amount
545     )
546         internal
547     {
548         address from = address(this);
549         if (
550             amount == 0
551             || from == to
552         ) {
553             return;
554         }
555 
556         GeneralERC20(token).transfer(to, amount);
557 
558         require(
559             checkSuccess(),
560             "TokenInteract#transfer: Transfer failed"
561         );
562     }
563 
564     function transferFrom(
565         address token,
566         address from,
567         address to,
568         uint256 amount
569     )
570         internal
571     {
572         if (
573             amount == 0
574             || from == to
575         ) {
576             return;
577         }
578 
579         GeneralERC20(token).transferFrom(from, to, amount);
580 
581         require(
582             checkSuccess(),
583             "TokenInteract#transferFrom: TransferFrom failed"
584         );
585     }
586 
587     // ============ Private Helper-Functions ============
588 
589     /**
590      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
591      * function returned 0 bytes or 32 bytes that are not all-zero.
592      */
593     function checkSuccess(
594     )
595         private
596         pure
597         returns (bool)
598     {
599         uint256 returnValue = 0;
600 
601         /* solium-disable-next-line security/no-inline-assembly */
602         assembly {
603             // check number of bytes returned from last function call
604             switch returndatasize
605 
606             // no bytes returned: assume success
607             case 0x0 {
608                 returnValue := 1
609             }
610 
611             // 32 bytes returned: check if non-zero
612             case 0x20 {
613                 // copy 32 bytes into scratch space
614                 returndatacopy(0x0, 0x0, 0x20)
615 
616                 // load those bytes into returnValue
617                 returnValue := mload(0x0)
618             }
619 
620             // not sure what was returned: dont mark as success
621             default { }
622         }
623 
624         return returnValue != 0;
625     }
626 }
627 
628 // File: contracts/margin/TokenProxy.sol
629 
630 /**
631  * @title TokenProxy
632  * @author dYdX
633  *
634  * Used to transfer tokens between addresses which have set allowance on this contract.
635  */
636 contract TokenProxy is StaticAccessControlled {
637     using SafeMath for uint256;
638 
639     // ============ Constructor ============
640 
641     constructor(
642         uint256 gracePeriod
643     )
644         public
645         StaticAccessControlled(gracePeriod)
646     {}
647 
648     // ============ Authorized-Only State Changing Functions ============
649 
650     /**
651      * Transfers tokens from an address (that has set allowance on the proxy) to another address.
652      *
653      * @param  token  The address of the ERC20 token
654      * @param  from   The address to transfer token from
655      * @param  to     The address to transfer tokens to
656      * @param  value  The number of tokens to transfer
657      */
658     function transferTokens(
659         address token,
660         address from,
661         address to,
662         uint256 value
663     )
664         external
665         requiresAuthorization
666     {
667         TokenInteract.transferFrom(
668             token,
669             from,
670             to,
671             value
672         );
673     }
674 
675     // ============ Public Constant Functions ============
676 
677     /**
678      * Getter function to get the amount of token that the proxy is able to move for a particular
679      * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
680      *
681      * @param  who    The owner of the tokens
682      * @param  token  The address of the ERC20 token
683      * @return        The number of tokens able to be moved by the proxy from the address specified
684      */
685     function available(
686         address who,
687         address token
688     )
689         external
690         view
691         returns (uint256)
692     {
693         return Math.min256(
694             TokenInteract.allowance(token, who, address(this)),
695             TokenInteract.balanceOf(token, who)
696         );
697     }
698 }
699 
700 // File: contracts/margin/Vault.sol
701 
702 /**
703  * @title Vault
704  * @author dYdX
705  *
706  * Holds and transfers tokens in vaults denominated by id
707  *
708  * Vault only supports ERC20 tokens, and will not accept any tokens that require
709  * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
710  */
711 contract Vault is StaticAccessControlled
712 {
713     using SafeMath for uint256;
714 
715     // ============ Events ============
716 
717     event ExcessTokensWithdrawn(
718         address indexed token,
719         address indexed to,
720         address caller
721     );
722 
723     // ============ State Variables ============
724 
725     // Address of the TokenProxy contract. Used for moving tokens.
726     address public TOKEN_PROXY;
727 
728     // Map from vault ID to map from token address to amount of that token attributed to the
729     // particular vault ID.
730     mapping (bytes32 => mapping (address => uint256)) public balances;
731 
732     // Map from token address to total amount of that token attributed to some account.
733     mapping (address => uint256) public totalBalances;
734 
735     // ============ Constructor ============
736 
737     constructor(
738         address proxy,
739         uint256 gracePeriod
740     )
741         public
742         StaticAccessControlled(gracePeriod)
743     {
744         TOKEN_PROXY = proxy;
745     }
746 
747     // ============ Owner-Only State-Changing Functions ============
748 
749     /**
750      * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
751      * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
752      * will be accounted for and will not be withdrawable by this function.
753      *
754      * @param  token  ERC20 token address
755      * @param  to     Address to transfer tokens to
756      * @return        Amount of tokens withdrawn
757      */
758     function withdrawExcessToken(
759         address token,
760         address to
761     )
762         external
763         onlyOwner
764         returns (uint256)
765     {
766         uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
767         uint256 accountedBalance = totalBalances[token];
768         uint256 withdrawableBalance = actualBalance.sub(accountedBalance);
769 
770         require(
771             withdrawableBalance != 0,
772             "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
773         );
774 
775         TokenInteract.transfer(token, to, withdrawableBalance);
776 
777         emit ExcessTokensWithdrawn(token, to, msg.sender);
778 
779         return withdrawableBalance;
780     }
781 
782     // ============ Authorized-Only State-Changing Functions ============
783 
784     /**
785      * Transfers tokens from an address (that has approved the proxy) to the vault.
786      *
787      * @param  id      The vault which will receive the tokens
788      * @param  token   ERC20 token address
789      * @param  from    Address from which the tokens will be taken
790      * @param  amount  Number of the token to be sent
791      */
792     function transferToVault(
793         bytes32 id,
794         address token,
795         address from,
796         uint256 amount
797     )
798         external
799         requiresAuthorization
800     {
801         // First send tokens to this contract
802         TokenProxy(TOKEN_PROXY).transferTokens(
803             token,
804             from,
805             address(this),
806             amount
807         );
808 
809         // Then increment balances
810         balances[id][token] = balances[id][token].add(amount);
811         totalBalances[token] = totalBalances[token].add(amount);
812 
813         // This should always be true. If not, something is very wrong
814         assert(totalBalances[token] >= balances[id][token]);
815 
816         validateBalance(token);
817     }
818 
819     /**
820      * Transfers a certain amount of funds to an address.
821      *
822      * @param  id      The vault from which to send the tokens
823      * @param  token   ERC20 token address
824      * @param  to      Address to transfer tokens to
825      * @param  amount  Number of the token to be sent
826      */
827     function transferFromVault(
828         bytes32 id,
829         address token,
830         address to,
831         uint256 amount
832     )
833         external
834         requiresAuthorization
835     {
836         // Next line also asserts that (balances[id][token] >= amount);
837         balances[id][token] = balances[id][token].sub(amount);
838 
839         // Next line also asserts that (totalBalances[token] >= amount);
840         totalBalances[token] = totalBalances[token].sub(amount);
841 
842         // This should always be true. If not, something is very wrong
843         assert(totalBalances[token] >= balances[id][token]);
844 
845         // Do the sending
846         TokenInteract.transfer(token, to, amount); // asserts transfer succeeded
847 
848         // Final validation
849         validateBalance(token);
850     }
851 
852     // ============ Private Helper-Functions ============
853 
854     /**
855      * Verifies that this contract is in control of at least as many tokens as accounted for
856      *
857      * @param  token  Address of ERC20 token
858      */
859     function validateBalance(
860         address token
861     )
862         private
863         view
864     {
865         // The actual balance could be greater than totalBalances[token] because anyone
866         // can send tokens to the contract's address which cannot be accounted for
867         assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
868     }
869 }
870 
871 // File: contracts/lib/ReentrancyGuard.sol
872 
873 /**
874  * @title ReentrancyGuard
875  * @author dYdX
876  *
877  * Optimized version of the well-known ReentrancyGuard contract
878  */
879 contract ReentrancyGuard {
880     uint256 private _guardCounter = 1;
881 
882     modifier nonReentrant() {
883         uint256 localCounter = _guardCounter + 1;
884         _guardCounter = localCounter;
885         _;
886         require(
887             _guardCounter == localCounter,
888             "Reentrancy check failure"
889         );
890     }
891 }
892 
893 // File: openzeppelin-solidity/contracts/AddressUtils.sol
894 
895 /**
896  * Utility library of inline functions on addresses
897  */
898 library AddressUtils {
899 
900   /**
901    * Returns whether the target address is a contract
902    * @dev This function will return false if invoked during the constructor of a contract,
903    * as the code is not actually created until after the constructor finishes.
904    * @param _addr address to check
905    * @return whether the target address is a contract
906    */
907   function isContract(address _addr) internal view returns (bool) {
908     uint256 size;
909     // XXX Currently there is no better way to check if there is a contract in an address
910     // than to check the size of the code at that address.
911     // See https://ethereum.stackexchange.com/a/14016/36603
912     // for more details about how this works.
913     // TODO Check this again before the Serenity release, because all addresses will be
914     // contracts then.
915     // solium-disable-next-line security/no-inline-assembly
916     assembly { size := extcodesize(_addr) }
917     return size > 0;
918   }
919 
920 }
921 
922 // File: contracts/lib/Fraction.sol
923 
924 /**
925  * @title Fraction
926  * @author dYdX
927  *
928  * This library contains implementations for fraction structs.
929  */
930 library Fraction {
931     struct Fraction128 {
932         uint128 num;
933         uint128 den;
934     }
935 }
936 
937 // File: contracts/lib/FractionMath.sol
938 
939 /**
940  * @title FractionMath
941  * @author dYdX
942  *
943  * This library contains safe math functions for manipulating fractions.
944  */
945 library FractionMath {
946     using SafeMath for uint256;
947     using SafeMath for uint128;
948 
949     /**
950      * Returns a Fraction128 that is equal to a + b
951      *
952      * @param  a  The first Fraction128
953      * @param  b  The second Fraction128
954      * @return    The result (sum)
955      */
956     function add(
957         Fraction.Fraction128 memory a,
958         Fraction.Fraction128 memory b
959     )
960         internal
961         pure
962         returns (Fraction.Fraction128 memory)
963     {
964         uint256 left = a.num.mul(b.den);
965         uint256 right = b.num.mul(a.den);
966         uint256 denominator = a.den.mul(b.den);
967 
968         // if left + right overflows, prevent overflow
969         if (left + right < left) {
970             left = left.div(2);
971             right = right.div(2);
972             denominator = denominator.div(2);
973         }
974 
975         return bound(left.add(right), denominator);
976     }
977 
978     /**
979      * Returns a Fraction128 that is equal to a - (1/2)^d
980      *
981      * @param  a  The Fraction128
982      * @param  d  The power of (1/2)
983      * @return    The result
984      */
985     function sub1Over(
986         Fraction.Fraction128 memory a,
987         uint128 d
988     )
989         internal
990         pure
991         returns (Fraction.Fraction128 memory)
992     {
993         if (a.den % d == 0) {
994             return bound(
995                 a.num.sub(a.den.div(d)),
996                 a.den
997             );
998         }
999         return bound(
1000             a.num.mul(d).sub(a.den),
1001             a.den.mul(d)
1002         );
1003     }
1004 
1005     /**
1006      * Returns a Fraction128 that is equal to a / d
1007      *
1008      * @param  a  The first Fraction128
1009      * @param  d  The divisor
1010      * @return    The result (quotient)
1011      */
1012     function div(
1013         Fraction.Fraction128 memory a,
1014         uint128 d
1015     )
1016         internal
1017         pure
1018         returns (Fraction.Fraction128 memory)
1019     {
1020         if (a.num % d == 0) {
1021             return bound(
1022                 a.num.div(d),
1023                 a.den
1024             );
1025         }
1026         return bound(
1027             a.num,
1028             a.den.mul(d)
1029         );
1030     }
1031 
1032     /**
1033      * Returns a Fraction128 that is equal to a * b.
1034      *
1035      * @param  a  The first Fraction128
1036      * @param  b  The second Fraction128
1037      * @return    The result (product)
1038      */
1039     function mul(
1040         Fraction.Fraction128 memory a,
1041         Fraction.Fraction128 memory b
1042     )
1043         internal
1044         pure
1045         returns (Fraction.Fraction128 memory)
1046     {
1047         return bound(
1048             a.num.mul(b.num),
1049             a.den.mul(b.den)
1050         );
1051     }
1052 
1053     /**
1054      * Returns a fraction from two uint256's. Fits them into uint128 if necessary.
1055      *
1056      * @param  num  The numerator
1057      * @param  den  The denominator
1058      * @return      The Fraction128 that matches num/den most closely
1059      */
1060     /* solium-disable-next-line security/no-assign-params */
1061     function bound(
1062         uint256 num,
1063         uint256 den
1064     )
1065         internal
1066         pure
1067         returns (Fraction.Fraction128 memory)
1068     {
1069         uint256 max = num > den ? num : den;
1070         uint256 first128Bits = (max >> 128);
1071         if (first128Bits != 0) {
1072             first128Bits += 1;
1073             num /= first128Bits;
1074             den /= first128Bits;
1075         }
1076 
1077         assert(den != 0); // coverage-enable-line
1078         assert(den < 2**128);
1079         assert(num < 2**128);
1080 
1081         return Fraction.Fraction128({
1082             num: uint128(num),
1083             den: uint128(den)
1084         });
1085     }
1086 
1087     /**
1088      * Returns an in-memory copy of a Fraction128
1089      *
1090      * @param  a  The Fraction128 to copy
1091      * @return    A copy of the Fraction128
1092      */
1093     function copy(
1094         Fraction.Fraction128 memory a
1095     )
1096         internal
1097         pure
1098         returns (Fraction.Fraction128 memory)
1099     {
1100         validate(a);
1101         return Fraction.Fraction128({ num: a.num, den: a.den });
1102     }
1103 
1104     // ============ Private Helper-Functions ============
1105 
1106     /**
1107      * Asserts that a Fraction128 is valid (i.e. the denominator is non-zero)
1108      *
1109      * @param  a  The Fraction128 to validate
1110      */
1111     function validate(
1112         Fraction.Fraction128 memory a
1113     )
1114         private
1115         pure
1116     {
1117         assert(a.den != 0); // coverage-enable-line
1118     }
1119 }
1120 
1121 // File: contracts/lib/Exponent.sol
1122 
1123 /**
1124  * @title Exponent
1125  * @author dYdX
1126  *
1127  * This library contains an implementation for calculating e^X for arbitrary fraction X
1128  */
1129 library Exponent {
1130     using SafeMath for uint256;
1131     using FractionMath for Fraction.Fraction128;
1132 
1133     // ============ Constants ============
1134 
1135     // 2**128 - 1
1136     uint128 constant public MAX_NUMERATOR = 340282366920938463463374607431768211455;
1137 
1138     // Number of precomputed integers, X, for E^((1/2)^X)
1139     uint256 constant public MAX_PRECOMPUTE_PRECISION = 32;
1140 
1141     // Number of precomputed integers, X, for E^X
1142     uint256 constant public NUM_PRECOMPUTED_INTEGERS = 32;
1143 
1144     // ============ Public Implementation Functions ============
1145 
1146     /**
1147      * Returns e^X for any fraction X
1148      *
1149      * @param  X                    The exponent
1150      * @param  precomputePrecision  Accuracy of precomputed terms
1151      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1152      * @return                      e^X
1153      */
1154     function exp(
1155         Fraction.Fraction128 memory X,
1156         uint256 precomputePrecision,
1157         uint256 maclaurinPrecision
1158     )
1159         internal
1160         pure
1161         returns (Fraction.Fraction128 memory)
1162     {
1163         require(
1164             precomputePrecision <= MAX_PRECOMPUTE_PRECISION,
1165             "Exponent#exp: Precompute precision over maximum"
1166         );
1167 
1168         Fraction.Fraction128 memory Xcopy = X.copy();
1169         if (Xcopy.num == 0) { // e^0 = 1
1170             return ONE();
1171         }
1172 
1173         // get the integer value of the fraction (example: 9/4 is 2.25 so has integerValue of 2)
1174         uint256 integerX = uint256(Xcopy.num).div(Xcopy.den);
1175 
1176         // if X is less than 1, then just calculate X
1177         if (integerX == 0) {
1178             return expHybrid(Xcopy, precomputePrecision, maclaurinPrecision);
1179         }
1180 
1181         // get e^integerX
1182         Fraction.Fraction128 memory expOfInt =
1183             getPrecomputedEToThe(integerX % NUM_PRECOMPUTED_INTEGERS);
1184         while (integerX >= NUM_PRECOMPUTED_INTEGERS) {
1185             expOfInt = expOfInt.mul(getPrecomputedEToThe(NUM_PRECOMPUTED_INTEGERS));
1186             integerX -= NUM_PRECOMPUTED_INTEGERS;
1187         }
1188 
1189         // multiply e^integerX by e^decimalX
1190         Fraction.Fraction128 memory decimalX = Fraction.Fraction128({
1191             num: Xcopy.num % Xcopy.den,
1192             den: Xcopy.den
1193         });
1194         return expHybrid(decimalX, precomputePrecision, maclaurinPrecision).mul(expOfInt);
1195     }
1196 
1197     /**
1198      * Returns e^X for any X < 1. Multiplies precomputed values to get close to the real value, then
1199      * Maclaurin Series approximation to reduce error.
1200      *
1201      * @param  X                    Exponent
1202      * @param  precomputePrecision  Accuracy of precomputed terms
1203      * @param  maclaurinPrecision   Accuracy of Maclaurin terms
1204      * @return                      e^X
1205      */
1206     function expHybrid(
1207         Fraction.Fraction128 memory X,
1208         uint256 precomputePrecision,
1209         uint256 maclaurinPrecision
1210     )
1211         internal
1212         pure
1213         returns (Fraction.Fraction128 memory)
1214     {
1215         assert(precomputePrecision <= MAX_PRECOMPUTE_PRECISION);
1216         assert(X.num < X.den);
1217         // will also throw if precomputePrecision is larger than the array length in getDenominator
1218 
1219         Fraction.Fraction128 memory Xtemp = X.copy();
1220         if (Xtemp.num == 0) { // e^0 = 1
1221             return ONE();
1222         }
1223 
1224         Fraction.Fraction128 memory result = ONE();
1225 
1226         uint256 d = 1; // 2^i
1227         for (uint256 i = 1; i <= precomputePrecision; i++) {
1228             d *= 2;
1229 
1230             // if Fraction > 1/d, subtract 1/d and multiply result by precomputed e^(1/d)
1231             if (d.mul(Xtemp.num) >= Xtemp.den) {
1232                 Xtemp = Xtemp.sub1Over(uint128(d));
1233                 result = result.mul(getPrecomputedEToTheHalfToThe(i));
1234             }
1235         }
1236         return result.mul(expMaclaurin(Xtemp, maclaurinPrecision));
1237     }
1238 
1239     /**
1240      * Returns e^X for any X, using Maclaurin Series approximation
1241      *
1242      * e^X = SUM(X^n / n!) for n >= 0
1243      * e^X = 1 + X/1! + X^2/2! + X^3/3! ...
1244      *
1245      * @param  X           Exponent
1246      * @param  precision   Accuracy of Maclaurin terms
1247      * @return             e^X
1248      */
1249     function expMaclaurin(
1250         Fraction.Fraction128 memory X,
1251         uint256 precision
1252     )
1253         internal
1254         pure
1255         returns (Fraction.Fraction128 memory)
1256     {
1257         Fraction.Fraction128 memory Xcopy = X.copy();
1258         if (Xcopy.num == 0) { // e^0 = 1
1259             return ONE();
1260         }
1261 
1262         Fraction.Fraction128 memory result = ONE();
1263         Fraction.Fraction128 memory Xtemp = ONE();
1264         for (uint256 i = 1; i <= precision; i++) {
1265             Xtemp = Xtemp.mul(Xcopy.div(uint128(i)));
1266             result = result.add(Xtemp);
1267         }
1268         return result;
1269     }
1270 
1271     /**
1272      * Returns a fraction roughly equaling E^((1/2)^x) for integer x
1273      */
1274     function getPrecomputedEToTheHalfToThe(
1275         uint256 x
1276     )
1277         internal
1278         pure
1279         returns (Fraction.Fraction128 memory)
1280     {
1281         assert(x <= MAX_PRECOMPUTE_PRECISION);
1282 
1283         uint128 denominator = [
1284             125182886983370532117250726298150828301,
1285             206391688497133195273760705512282642279,
1286             265012173823417992016237332255925138361,
1287             300298134811882980317033350418940119802,
1288             319665700530617779809390163992561606014,
1289             329812979126047300897653247035862915816,
1290             335006777809430963166468914297166288162,
1291             337634268532609249517744113622081347950,
1292             338955731696479810470146282672867036734,
1293             339618401537809365075354109784799900812,
1294             339950222128463181389559457827561204959,
1295             340116253979683015278260491021941090650,
1296             340199300311581465057079429423749235412,
1297             340240831081268226777032180141478221816,
1298             340261598367316729254995498374473399540,
1299             340271982485676106947851156443492415142,
1300             340277174663693808406010255284800906112,
1301             340279770782412691177936847400746725466,
1302             340281068849199706686796915841848278311,
1303             340281717884450116236033378667952410919,
1304             340282042402539547492367191008339680733,
1305             340282204661700319870089970029119685699,
1306             340282285791309720262481214385569134454,
1307             340282326356121674011576912006427792656,
1308             340282346638529464274601981200276914173,
1309             340282356779733812753265346086924801364,
1310             340282361850336100329388676752133324799,
1311             340282364385637272451648746721404212564,
1312             340282365653287865596328444437856608255,
1313             340282366287113163939555716675618384724,
1314             340282366604025813553891209601455838559,
1315             340282366762482138471739420386372790954,
1316             340282366841710300958333641874363209044
1317         ][x];
1318         return Fraction.Fraction128({
1319             num: MAX_NUMERATOR,
1320             den: denominator
1321         });
1322     }
1323 
1324     /**
1325      * Returns a fraction roughly equaling E^(x) for integer x
1326      */
1327     function getPrecomputedEToThe(
1328         uint256 x
1329     )
1330         internal
1331         pure
1332         returns (Fraction.Fraction128 memory)
1333     {
1334         assert(x <= NUM_PRECOMPUTED_INTEGERS);
1335 
1336         uint128 denominator = [
1337             340282366920938463463374607431768211455,
1338             125182886983370532117250726298150828301,
1339             46052210507670172419625860892627118820,
1340             16941661466271327126146327822211253888,
1341             6232488952727653950957829210887653621,
1342             2292804553036637136093891217529878878,
1343             843475657686456657683449904934172134,
1344             310297353591408453462393329342695980,
1345             114152017036184782947077973323212575,
1346             41994180235864621538772677139808695,
1347             15448795557622704876497742989562086,
1348             5683294276510101335127414470015662,
1349             2090767122455392675095471286328463,
1350             769150240628514374138961856925097,
1351             282954560699298259527814398449860,
1352             104093165666968799599694528310221,
1353             38293735615330848145349245349513,
1354             14087478058534870382224480725096,
1355             5182493555688763339001418388912,
1356             1906532833141383353974257736699,
1357             701374233231058797338605168652,
1358             258021160973090761055471434334,
1359             94920680509187392077350434438,
1360             34919366901332874995585576427,
1361             12846117181722897538509298435,
1362             4725822410035083116489797150,
1363             1738532907279185132707372378,
1364             639570514388029575350057932,
1365             235284843422800231081973821,
1366             86556456714490055457751527,
1367             31842340925906738090071268,
1368             11714142585413118080082437,
1369             4309392228124372433711936
1370         ][x];
1371         return Fraction.Fraction128({
1372             num: MAX_NUMERATOR,
1373             den: denominator
1374         });
1375     }
1376 
1377     // ============ Private Helper-Functions ============
1378 
1379     function ONE()
1380         private
1381         pure
1382         returns (Fraction.Fraction128 memory)
1383     {
1384         return Fraction.Fraction128({ num: 1, den: 1 });
1385     }
1386 }
1387 
1388 // File: contracts/lib/MathHelpers.sol
1389 
1390 /**
1391  * @title MathHelpers
1392  * @author dYdX
1393  *
1394  * This library helps with common math functions in Solidity
1395  */
1396 library MathHelpers {
1397     using SafeMath for uint256;
1398 
1399     /**
1400      * Calculates partial value given a numerator and denominator.
1401      *
1402      * @param  numerator    Numerator
1403      * @param  denominator  Denominator
1404      * @param  target       Value to calculate partial of
1405      * @return              target * numerator / denominator
1406      */
1407     function getPartialAmount(
1408         uint256 numerator,
1409         uint256 denominator,
1410         uint256 target
1411     )
1412         internal
1413         pure
1414         returns (uint256)
1415     {
1416         return numerator.mul(target).div(denominator);
1417     }
1418 
1419     /**
1420      * Calculates partial value given a numerator and denominator, rounded up.
1421      *
1422      * @param  numerator    Numerator
1423      * @param  denominator  Denominator
1424      * @param  target       Value to calculate partial of
1425      * @return              Rounded-up result of target * numerator / denominator
1426      */
1427     function getPartialAmountRoundedUp(
1428         uint256 numerator,
1429         uint256 denominator,
1430         uint256 target
1431     )
1432         internal
1433         pure
1434         returns (uint256)
1435     {
1436         return divisionRoundedUp(numerator.mul(target), denominator);
1437     }
1438 
1439     /**
1440      * Calculates division given a numerator and denominator, rounded up.
1441      *
1442      * @param  numerator    Numerator.
1443      * @param  denominator  Denominator.
1444      * @return              Rounded-up result of numerator / denominator
1445      */
1446     function divisionRoundedUp(
1447         uint256 numerator,
1448         uint256 denominator
1449     )
1450         internal
1451         pure
1452         returns (uint256)
1453     {
1454         assert(denominator != 0); // coverage-enable-line
1455         if (numerator == 0) {
1456             return 0;
1457         }
1458         return numerator.sub(1).div(denominator).add(1);
1459     }
1460 
1461     /**
1462      * Calculates and returns the maximum value for a uint256 in solidity
1463      *
1464      * @return  The maximum value for uint256
1465      */
1466     function maxUint256(
1467     )
1468         internal
1469         pure
1470         returns (uint256)
1471     {
1472         return 2 ** 256 - 1;
1473     }
1474 
1475     /**
1476      * Calculates and returns the maximum value for a uint256 in solidity
1477      *
1478      * @return  The maximum value for uint256
1479      */
1480     function maxUint32(
1481     )
1482         internal
1483         pure
1484         returns (uint32)
1485     {
1486         return 2 ** 32 - 1;
1487     }
1488 
1489     /**
1490      * Returns the number of bits in a uint256. That is, the lowest number, x, such that n >> x == 0
1491      *
1492      * @param  n  The uint256 to get the number of bits in
1493      * @return    The number of bits in n
1494      */
1495     function getNumBits(
1496         uint256 n
1497     )
1498         internal
1499         pure
1500         returns (uint256)
1501     {
1502         uint256 first = 0;
1503         uint256 last = 256;
1504         while (first < last) {
1505             uint256 check = (first + last) / 2;
1506             if ((n >> check) == 0) {
1507                 last = check;
1508             } else {
1509                 first = check + 1;
1510             }
1511         }
1512         assert(first <= 256);
1513         return first;
1514     }
1515 }
1516 
1517 // File: contracts/margin/impl/InterestImpl.sol
1518 
1519 /**
1520  * @title InterestImpl
1521  * @author dYdX
1522  *
1523  * A library that calculates continuously compounded interest for principal, time period, and
1524  * interest rate.
1525  */
1526 library InterestImpl {
1527     using SafeMath for uint256;
1528     using FractionMath for Fraction.Fraction128;
1529 
1530     // ============ Constants ============
1531 
1532     uint256 constant DEFAULT_PRECOMPUTE_PRECISION = 11;
1533 
1534     uint256 constant DEFAULT_MACLAURIN_PRECISION = 5;
1535 
1536     uint256 constant MAXIMUM_EXPONENT = 80;
1537 
1538     uint128 constant E_TO_MAXIUMUM_EXPONENT = 55406223843935100525711733958316613;
1539 
1540     // ============ Public Implementation Functions ============
1541 
1542     /**
1543      * Returns total tokens owed after accruing interest. Continuously compounding and accurate to
1544      * roughly 10^18 decimal places. Continuously compounding interest follows the formula:
1545      * I = P * e^(R*T)
1546      *
1547      * @param  principal           Principal of the interest calculation
1548      * @param  interestRate        Annual nominal interest percentage times 10**6.
1549      *                             (example: 5% = 5e6)
1550      * @param  secondsOfInterest   Number of seconds that interest has been accruing
1551      * @return                     Total amount of tokens owed. Greater than tokenAmount.
1552      */
1553     function getCompoundedInterest(
1554         uint256 principal,
1555         uint256 interestRate,
1556         uint256 secondsOfInterest
1557     )
1558         public
1559         pure
1560         returns (uint256)
1561     {
1562         uint256 numerator = interestRate.mul(secondsOfInterest);
1563         uint128 denominator = (10**8) * (365 * 1 days);
1564 
1565         // interestRate and secondsOfInterest should both be uint32
1566         assert(numerator < 2**128);
1567 
1568         // fraction representing (Rate * Time)
1569         Fraction.Fraction128 memory rt = Fraction.Fraction128({
1570             num: uint128(numerator),
1571             den: denominator
1572         });
1573 
1574         // calculate e^(RT)
1575         Fraction.Fraction128 memory eToRT;
1576         if (numerator.div(denominator) >= MAXIMUM_EXPONENT) {
1577             // degenerate case: cap calculation
1578             eToRT = Fraction.Fraction128({
1579                 num: E_TO_MAXIUMUM_EXPONENT,
1580                 den: 1
1581             });
1582         } else {
1583             // normal case: calculate e^(RT)
1584             eToRT = Exponent.exp(
1585                 rt,
1586                 DEFAULT_PRECOMPUTE_PRECISION,
1587                 DEFAULT_MACLAURIN_PRECISION
1588             );
1589         }
1590 
1591         // e^X for positive X should be greater-than or equal to 1
1592         assert(eToRT.num >= eToRT.den);
1593 
1594         return safeMultiplyUint256ByFraction(principal, eToRT);
1595     }
1596 
1597     // ============ Private Helper-Functions ============
1598 
1599     /**
1600      * Returns n * f, trying to prevent overflow as much as possible. Assumes that the numerator
1601      * and denominator of f are less than 2**128.
1602      */
1603     function safeMultiplyUint256ByFraction(
1604         uint256 n,
1605         Fraction.Fraction128 memory f
1606     )
1607         private
1608         pure
1609         returns (uint256)
1610     {
1611         uint256 term1 = n.div(2 ** 128); // first 128 bits
1612         uint256 term2 = n % (2 ** 128); // second 128 bits
1613 
1614         // uncommon scenario, requires n >= 2**128. calculates term1 = term1 * f
1615         if (term1 > 0) {
1616             term1 = term1.mul(f.num);
1617             uint256 numBits = MathHelpers.getNumBits(term1);
1618 
1619             // reduce rounding error by shifting all the way to the left before dividing
1620             term1 = MathHelpers.divisionRoundedUp(
1621                 term1 << (uint256(256).sub(numBits)),
1622                 f.den);
1623 
1624             // continue shifting or reduce shifting to get the right number
1625             if (numBits > 128) {
1626                 term1 = term1 << (numBits.sub(128));
1627             } else if (numBits < 128) {
1628                 term1 = term1 >> (uint256(128).sub(numBits));
1629             }
1630         }
1631 
1632         // calculates term2 = term2 * f
1633         term2 = MathHelpers.getPartialAmountRoundedUp(
1634             f.num,
1635             f.den,
1636             term2
1637         );
1638 
1639         return term1.add(term2);
1640     }
1641 }
1642 
1643 // File: contracts/margin/impl/MarginState.sol
1644 
1645 /**
1646  * @title MarginState
1647  * @author dYdX
1648  *
1649  * Contains state for the Margin contract. Also used by libraries that implement Margin functions.
1650  */
1651 library MarginState {
1652     struct State {
1653         // Address of the Vault contract
1654         address VAULT;
1655 
1656         // Address of the TokenProxy contract
1657         address TOKEN_PROXY;
1658 
1659         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1660         // already been filled.
1661         mapping (bytes32 => uint256) loanFills;
1662 
1663         // Mapping from loanHash -> amount, which stores the amount of a loan which has
1664         // already been canceled.
1665         mapping (bytes32 => uint256) loanCancels;
1666 
1667         // Mapping from positionId -> Position, which stores all the open margin positions.
1668         mapping (bytes32 => MarginCommon.Position) positions;
1669 
1670         // Mapping from positionId -> bool, which stores whether the position has previously been
1671         // open, but is now closed.
1672         mapping (bytes32 => bool) closedPositions;
1673 
1674         // Mapping from positionId -> uint256, which stores the total amount of owedToken that has
1675         // ever been repaid to the lender for each position. Does not reset.
1676         mapping (bytes32 => uint256) totalOwedTokenRepaidToLender;
1677     }
1678 }
1679 
1680 // File: contracts/margin/interfaces/lender/LoanOwner.sol
1681 
1682 /**
1683  * @title LoanOwner
1684  * @author dYdX
1685  *
1686  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
1687  *
1688  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1689  *       to these functions
1690  */
1691 interface LoanOwner {
1692 
1693     // ============ Public Interface functions ============
1694 
1695     /**
1696      * Function a contract must implement in order to receive ownership of a loan sell via the
1697      * transferLoan function or the atomic-assign to the "owner" field in a loan offering.
1698      *
1699      * @param  from        Address of the previous owner
1700      * @param  positionId  Unique ID of the position
1701      * @return             This address to keep ownership, a different address to pass-on ownership
1702      */
1703     function receiveLoanOwnership(
1704         address from,
1705         bytes32 positionId
1706     )
1707         external
1708         /* onlyMargin */
1709         returns (address);
1710 }
1711 
1712 // File: contracts/margin/interfaces/owner/PositionOwner.sol
1713 
1714 /**
1715  * @title PositionOwner
1716  * @author dYdX
1717  *
1718  * Interface that smart contracts must implement in order to own position on behalf of other
1719  * accounts
1720  *
1721  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
1722  *       to these functions
1723  */
1724 interface PositionOwner {
1725 
1726     // ============ Public Interface functions ============
1727 
1728     /**
1729      * Function a contract must implement in order to receive ownership of a position via the
1730      * transferPosition function or the atomic-assign to the "owner" field when opening a position.
1731      *
1732      * @param  from        Address of the previous owner
1733      * @param  positionId  Unique ID of the position
1734      * @return             This address to keep ownership, a different address to pass-on ownership
1735      */
1736     function receivePositionOwnership(
1737         address from,
1738         bytes32 positionId
1739     )
1740         external
1741         /* onlyMargin */
1742         returns (address);
1743 }
1744 
1745 // File: contracts/margin/impl/TransferInternal.sol
1746 
1747 /**
1748  * @title TransferInternal
1749  * @author dYdX
1750  *
1751  * This library contains the implementation for transferring ownership of loans and positions.
1752  */
1753 library TransferInternal {
1754 
1755     // ============ Events ============
1756 
1757     /**
1758      * Ownership of a loan was transferred to a new address
1759      */
1760     event LoanTransferred(
1761         bytes32 indexed positionId,
1762         address indexed from,
1763         address indexed to
1764     );
1765 
1766     /**
1767      * Ownership of a postion was transferred to a new address
1768      */
1769     event PositionTransferred(
1770         bytes32 indexed positionId,
1771         address indexed from,
1772         address indexed to
1773     );
1774 
1775     // ============ Internal Implementation Functions ============
1776 
1777     /**
1778      * Returns either the address of the new loan owner, or the address to which they wish to
1779      * pass ownership of the loan. This function does not actually set the state of the position
1780      *
1781      * @param  positionId  The Unique ID of the position
1782      * @param  oldOwner    The previous owner of the loan
1783      * @param  newOwner    The intended owner of the loan
1784      * @return             The address that the intended owner wishes to assign the loan to (may be
1785      *                     the same as the intended owner).
1786      */
1787     function grantLoanOwnership(
1788         bytes32 positionId,
1789         address oldOwner,
1790         address newOwner
1791     )
1792         internal
1793         returns (address)
1794     {
1795         // log event except upon position creation
1796         if (oldOwner != address(0)) {
1797             emit LoanTransferred(positionId, oldOwner, newOwner);
1798         }
1799 
1800         if (AddressUtils.isContract(newOwner)) {
1801             address nextOwner =
1802                 LoanOwner(newOwner).receiveLoanOwnership(oldOwner, positionId);
1803             if (nextOwner != newOwner) {
1804                 return grantLoanOwnership(positionId, newOwner, nextOwner);
1805             }
1806         }
1807 
1808         require(
1809             newOwner != address(0),
1810             "TransferInternal#grantLoanOwnership: New owner did not consent to owning loan"
1811         );
1812 
1813         return newOwner;
1814     }
1815 
1816     /**
1817      * Returns either the address of the new position owner, or the address to which they wish to
1818      * pass ownership of the position. This function does not actually set the state of the position
1819      *
1820      * @param  positionId  The Unique ID of the position
1821      * @param  oldOwner    The previous owner of the position
1822      * @param  newOwner    The intended owner of the position
1823      * @return             The address that the intended owner wishes to assign the position to (may
1824      *                     be the same as the intended owner).
1825      */
1826     function grantPositionOwnership(
1827         bytes32 positionId,
1828         address oldOwner,
1829         address newOwner
1830     )
1831         internal
1832         returns (address)
1833     {
1834         // log event except upon position creation
1835         if (oldOwner != address(0)) {
1836             emit PositionTransferred(positionId, oldOwner, newOwner);
1837         }
1838 
1839         if (AddressUtils.isContract(newOwner)) {
1840             address nextOwner =
1841                 PositionOwner(newOwner).receivePositionOwnership(oldOwner, positionId);
1842             if (nextOwner != newOwner) {
1843                 return grantPositionOwnership(positionId, newOwner, nextOwner);
1844             }
1845         }
1846 
1847         require(
1848             newOwner != address(0),
1849             "TransferInternal#grantPositionOwnership: New owner did not consent to owning position"
1850         );
1851 
1852         return newOwner;
1853     }
1854 }
1855 
1856 // File: contracts/lib/TimestampHelper.sol
1857 
1858 /**
1859  * @title TimestampHelper
1860  * @author dYdX
1861  *
1862  * Helper to get block timestamps in other formats
1863  */
1864 library TimestampHelper {
1865     function getBlockTimestamp32()
1866         internal
1867         view
1868         returns (uint32)
1869     {
1870         // Should not still be in-use in the year 2106
1871         assert(uint256(uint32(block.timestamp)) == block.timestamp);
1872 
1873         assert(block.timestamp > 0);
1874 
1875         return uint32(block.timestamp);
1876     }
1877 }
1878 
1879 // File: contracts/margin/impl/MarginCommon.sol
1880 
1881 /**
1882  * @title MarginCommon
1883  * @author dYdX
1884  *
1885  * This library contains common functions for implementations of public facing Margin functions
1886  */
1887 library MarginCommon {
1888     using SafeMath for uint256;
1889 
1890     // ============ Structs ============
1891 
1892     struct Position {
1893         address owedToken;       // Immutable
1894         address heldToken;       // Immutable
1895         address lender;
1896         address owner;
1897         uint256 principal;
1898         uint256 requiredDeposit;
1899         uint32  callTimeLimit;   // Immutable
1900         uint32  startTimestamp;  // Immutable, cannot be 0
1901         uint32  callTimestamp;
1902         uint32  maxDuration;     // Immutable
1903         uint32  interestRate;    // Immutable
1904         uint32  interestPeriod;  // Immutable
1905     }
1906 
1907     struct LoanOffering {
1908         address   owedToken;
1909         address   heldToken;
1910         address   payer;
1911         address   owner;
1912         address   taker;
1913         address   positionOwner;
1914         address   feeRecipient;
1915         address   lenderFeeToken;
1916         address   takerFeeToken;
1917         LoanRates rates;
1918         uint256   expirationTimestamp;
1919         uint32    callTimeLimit;
1920         uint32    maxDuration;
1921         uint256   salt;
1922         bytes32   loanHash;
1923         bytes     signature;
1924     }
1925 
1926     struct LoanRates {
1927         uint256 maxAmount;
1928         uint256 minAmount;
1929         uint256 minHeldToken;
1930         uint256 lenderFee;
1931         uint256 takerFee;
1932         uint32  interestRate;
1933         uint32  interestPeriod;
1934     }
1935 
1936     // ============ Internal Implementation Functions ============
1937 
1938     function storeNewPosition(
1939         MarginState.State storage state,
1940         bytes32 positionId,
1941         Position memory position,
1942         address loanPayer
1943     )
1944         internal
1945     {
1946         assert(!positionHasExisted(state, positionId));
1947         assert(position.owedToken != address(0));
1948         assert(position.heldToken != address(0));
1949         assert(position.owedToken != position.heldToken);
1950         assert(position.owner != address(0));
1951         assert(position.lender != address(0));
1952         assert(position.maxDuration != 0);
1953         assert(position.interestPeriod <= position.maxDuration);
1954         assert(position.callTimestamp == 0);
1955         assert(position.requiredDeposit == 0);
1956 
1957         state.positions[positionId].owedToken = position.owedToken;
1958         state.positions[positionId].heldToken = position.heldToken;
1959         state.positions[positionId].principal = position.principal;
1960         state.positions[positionId].callTimeLimit = position.callTimeLimit;
1961         state.positions[positionId].startTimestamp = TimestampHelper.getBlockTimestamp32();
1962         state.positions[positionId].maxDuration = position.maxDuration;
1963         state.positions[positionId].interestRate = position.interestRate;
1964         state.positions[positionId].interestPeriod = position.interestPeriod;
1965 
1966         state.positions[positionId].owner = TransferInternal.grantPositionOwnership(
1967             positionId,
1968             (position.owner != msg.sender) ? msg.sender : address(0),
1969             position.owner
1970         );
1971 
1972         state.positions[positionId].lender = TransferInternal.grantLoanOwnership(
1973             positionId,
1974             (position.lender != loanPayer) ? loanPayer : address(0),
1975             position.lender
1976         );
1977     }
1978 
1979     function getPositionIdFromNonce(
1980         uint256 nonce
1981     )
1982         internal
1983         view
1984         returns (bytes32)
1985     {
1986         return keccak256(abi.encodePacked(msg.sender, nonce));
1987     }
1988 
1989     function getUnavailableLoanOfferingAmountImpl(
1990         MarginState.State storage state,
1991         bytes32 loanHash
1992     )
1993         internal
1994         view
1995         returns (uint256)
1996     {
1997         return state.loanFills[loanHash].add(state.loanCancels[loanHash]);
1998     }
1999 
2000     function cleanupPosition(
2001         MarginState.State storage state,
2002         bytes32 positionId
2003     )
2004         internal
2005     {
2006         delete state.positions[positionId];
2007         state.closedPositions[positionId] = true;
2008     }
2009 
2010     function calculateOwedAmount(
2011         Position storage position,
2012         uint256 closeAmount,
2013         uint256 endTimestamp
2014     )
2015         internal
2016         view
2017         returns (uint256)
2018     {
2019         uint256 timeElapsed = calculateEffectiveTimeElapsed(position, endTimestamp);
2020 
2021         return InterestImpl.getCompoundedInterest(
2022             closeAmount,
2023             position.interestRate,
2024             timeElapsed
2025         );
2026     }
2027 
2028     /**
2029      * Calculates time elapsed rounded up to the nearest interestPeriod
2030      */
2031     function calculateEffectiveTimeElapsed(
2032         Position storage position,
2033         uint256 timestamp
2034     )
2035         internal
2036         view
2037         returns (uint256)
2038     {
2039         uint256 elapsed = timestamp.sub(position.startTimestamp);
2040 
2041         // round up to interestPeriod
2042         uint256 period = position.interestPeriod;
2043         if (period > 1) {
2044             elapsed = MathHelpers.divisionRoundedUp(elapsed, period).mul(period);
2045         }
2046 
2047         // bound by maxDuration
2048         return Math.min256(
2049             elapsed,
2050             position.maxDuration
2051         );
2052     }
2053 
2054     function calculateLenderAmountForIncreasePosition(
2055         Position storage position,
2056         uint256 principalToAdd,
2057         uint256 endTimestamp
2058     )
2059         internal
2060         view
2061         returns (uint256)
2062     {
2063         uint256 timeElapsed = calculateEffectiveTimeElapsedForNewLender(position, endTimestamp);
2064 
2065         return InterestImpl.getCompoundedInterest(
2066             principalToAdd,
2067             position.interestRate,
2068             timeElapsed
2069         );
2070     }
2071 
2072     function getLoanOfferingHash(
2073         LoanOffering loanOffering
2074     )
2075         internal
2076         view
2077         returns (bytes32)
2078     {
2079         return keccak256(
2080             abi.encodePacked(
2081                 address(this),
2082                 loanOffering.owedToken,
2083                 loanOffering.heldToken,
2084                 loanOffering.payer,
2085                 loanOffering.owner,
2086                 loanOffering.taker,
2087                 loanOffering.positionOwner,
2088                 loanOffering.feeRecipient,
2089                 loanOffering.lenderFeeToken,
2090                 loanOffering.takerFeeToken,
2091                 getValuesHash(loanOffering)
2092             )
2093         );
2094     }
2095 
2096     function getPositionBalanceImpl(
2097         MarginState.State storage state,
2098         bytes32 positionId
2099     )
2100         internal
2101         view
2102         returns(uint256)
2103     {
2104         return Vault(state.VAULT).balances(positionId, state.positions[positionId].heldToken);
2105     }
2106 
2107     function containsPositionImpl(
2108         MarginState.State storage state,
2109         bytes32 positionId
2110     )
2111         internal
2112         view
2113         returns (bool)
2114     {
2115         return state.positions[positionId].startTimestamp != 0;
2116     }
2117 
2118     function positionHasExisted(
2119         MarginState.State storage state,
2120         bytes32 positionId
2121     )
2122         internal
2123         view
2124         returns (bool)
2125     {
2126         return containsPositionImpl(state, positionId) || state.closedPositions[positionId];
2127     }
2128 
2129     function getPositionFromStorage(
2130         MarginState.State storage state,
2131         bytes32 positionId
2132     )
2133         internal
2134         view
2135         returns (Position storage)
2136     {
2137         Position storage position = state.positions[positionId];
2138 
2139         require(
2140             position.startTimestamp != 0,
2141             "MarginCommon#getPositionFromStorage: The position does not exist"
2142         );
2143 
2144         return position;
2145     }
2146 
2147     // ============ Private Helper-Functions ============
2148 
2149     /**
2150      * Calculates time elapsed rounded down to the nearest interestPeriod
2151      */
2152     function calculateEffectiveTimeElapsedForNewLender(
2153         Position storage position,
2154         uint256 timestamp
2155     )
2156         private
2157         view
2158         returns (uint256)
2159     {
2160         uint256 elapsed = timestamp.sub(position.startTimestamp);
2161 
2162         // round down to interestPeriod
2163         uint256 period = position.interestPeriod;
2164         if (period > 1) {
2165             elapsed = elapsed.div(period).mul(period);
2166         }
2167 
2168         // bound by maxDuration
2169         return Math.min256(
2170             elapsed,
2171             position.maxDuration
2172         );
2173     }
2174 
2175     function getValuesHash(
2176         LoanOffering loanOffering
2177     )
2178         private
2179         pure
2180         returns (bytes32)
2181     {
2182         return keccak256(
2183             abi.encodePacked(
2184                 loanOffering.rates.maxAmount,
2185                 loanOffering.rates.minAmount,
2186                 loanOffering.rates.minHeldToken,
2187                 loanOffering.rates.lenderFee,
2188                 loanOffering.rates.takerFee,
2189                 loanOffering.expirationTimestamp,
2190                 loanOffering.salt,
2191                 loanOffering.callTimeLimit,
2192                 loanOffering.maxDuration,
2193                 loanOffering.rates.interestRate,
2194                 loanOffering.rates.interestPeriod
2195             )
2196         );
2197     }
2198 }
2199 
2200 // File: contracts/margin/interfaces/PayoutRecipient.sol
2201 
2202 /**
2203  * @title PayoutRecipient
2204  * @author dYdX
2205  *
2206  * Interface that smart contracts must implement in order to be the payoutRecipient in a
2207  * closePosition transaction.
2208  *
2209  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2210  *       to these functions
2211  */
2212 interface PayoutRecipient {
2213 
2214     // ============ Public Interface functions ============
2215 
2216     /**
2217      * Function a contract must implement in order to receive payout from being the payoutRecipient
2218      * in a closePosition transaction. May redistribute any payout as necessary. Throws on error.
2219      *
2220      * @param  positionId         Unique ID of the position
2221      * @param  closeAmount        Amount of the position that was closed
2222      * @param  closer             Address of the account or contract that closed the position
2223      * @param  positionOwner      Address of the owner of the position
2224      * @param  heldToken          Address of the ERC20 heldToken
2225      * @param  payout             Number of tokens received from the payout
2226      * @param  totalHeldToken     Total amount of heldToken removed from vault during close
2227      * @param  payoutInHeldToken  True if payout is in heldToken, false if in owedToken
2228      * @return                    True if approved by the receiver
2229      */
2230     function receiveClosePositionPayout(
2231         bytes32 positionId,
2232         uint256 closeAmount,
2233         address closer,
2234         address positionOwner,
2235         address heldToken,
2236         uint256 payout,
2237         uint256 totalHeldToken,
2238         bool    payoutInHeldToken
2239     )
2240         external
2241         /* onlyMargin */
2242         returns (bool);
2243 }
2244 
2245 // File: contracts/margin/interfaces/lender/CloseLoanDelegator.sol
2246 
2247 /**
2248  * @title CloseLoanDelegator
2249  * @author dYdX
2250  *
2251  * Interface that smart contracts must implement in order to let other addresses close a loan
2252  * owned by the smart contract.
2253  *
2254  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2255  *       to these functions
2256  */
2257 interface CloseLoanDelegator {
2258 
2259     // ============ Public Interface functions ============
2260 
2261     /**
2262      * Function a contract must implement in order to let other addresses call
2263      * closeWithoutCounterparty().
2264      *
2265      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2266      * either revert the entire transaction or that (at most) the specified amount of the loan was
2267      * successfully closed.
2268      *
2269      * @param  closer           Address of the caller of closeWithoutCounterparty()
2270      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2271      * @param  positionId       Unique ID of the position
2272      * @param  requestedAmount  Requested principal amount of the loan to close
2273      * @return                  1) This address to accept, a different address to ask that contract
2274      *                          2) The maximum amount that this contract is allowing
2275      */
2276     function closeLoanOnBehalfOf(
2277         address closer,
2278         address payoutRecipient,
2279         bytes32 positionId,
2280         uint256 requestedAmount
2281     )
2282         external
2283         /* onlyMargin */
2284         returns (address, uint256);
2285 }
2286 
2287 // File: contracts/margin/interfaces/owner/ClosePositionDelegator.sol
2288 
2289 /**
2290  * @title ClosePositionDelegator
2291  * @author dYdX
2292  *
2293  * Interface that smart contracts must implement in order to let other addresses close a position
2294  * owned by the smart contract, allowing more complex logic to control positions.
2295  *
2296  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
2297  *       to these functions
2298  */
2299 interface ClosePositionDelegator {
2300 
2301     // ============ Public Interface functions ============
2302 
2303     /**
2304      * Function a contract must implement in order to let other addresses call closePosition().
2305      *
2306      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
2307      * either revert the entire transaction or that (at-most) the specified amount of the position
2308      * was successfully closed.
2309      *
2310      * @param  closer           Address of the caller of the closePosition() function
2311      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
2312      * @param  positionId       Unique ID of the position
2313      * @param  requestedAmount  Requested principal amount of the position to close
2314      * @return                  1) This address to accept, a different address to ask that contract
2315      *                          2) The maximum amount that this contract is allowing
2316      */
2317     function closeOnBehalfOf(
2318         address closer,
2319         address payoutRecipient,
2320         bytes32 positionId,
2321         uint256 requestedAmount
2322     )
2323         external
2324         /* onlyMargin */
2325         returns (address, uint256);
2326 }
2327 
2328 // File: contracts/margin/impl/ClosePositionShared.sol
2329 
2330 /**
2331  * @title ClosePositionShared
2332  * @author dYdX
2333  *
2334  * This library contains shared functionality between ClosePositionImpl and
2335  * CloseWithoutCounterpartyImpl
2336  */
2337 library ClosePositionShared {
2338     using SafeMath for uint256;
2339 
2340     // ============ Structs ============
2341 
2342     struct CloseTx {
2343         bytes32 positionId;
2344         uint256 originalPrincipal;
2345         uint256 closeAmount;
2346         uint256 owedTokenOwed;
2347         uint256 startingHeldTokenBalance;
2348         uint256 availableHeldToken;
2349         address payoutRecipient;
2350         address owedToken;
2351         address heldToken;
2352         address positionOwner;
2353         address positionLender;
2354         address exchangeWrapper;
2355         bool    payoutInHeldToken;
2356     }
2357 
2358     // ============ Internal Implementation Functions ============
2359 
2360     function closePositionStateUpdate(
2361         MarginState.State storage state,
2362         CloseTx memory transaction
2363     )
2364         internal
2365     {
2366         // Delete the position, or just decrease the principal
2367         if (transaction.closeAmount == transaction.originalPrincipal) {
2368             MarginCommon.cleanupPosition(state, transaction.positionId);
2369         } else {
2370             assert(
2371                 transaction.originalPrincipal == state.positions[transaction.positionId].principal
2372             );
2373             state.positions[transaction.positionId].principal =
2374                 transaction.originalPrincipal.sub(transaction.closeAmount);
2375         }
2376     }
2377 
2378     function sendTokensToPayoutRecipient(
2379         MarginState.State storage state,
2380         ClosePositionShared.CloseTx memory transaction,
2381         uint256 buybackCostInHeldToken,
2382         uint256 receivedOwedToken
2383     )
2384         internal
2385         returns (uint256)
2386     {
2387         uint256 payout;
2388 
2389         if (transaction.payoutInHeldToken) {
2390             // Send remaining heldToken to payoutRecipient
2391             payout = transaction.availableHeldToken.sub(buybackCostInHeldToken);
2392 
2393             Vault(state.VAULT).transferFromVault(
2394                 transaction.positionId,
2395                 transaction.heldToken,
2396                 transaction.payoutRecipient,
2397                 payout
2398             );
2399         } else {
2400             assert(transaction.exchangeWrapper != address(0));
2401 
2402             payout = receivedOwedToken.sub(transaction.owedTokenOwed);
2403 
2404             TokenProxy(state.TOKEN_PROXY).transferTokens(
2405                 transaction.owedToken,
2406                 transaction.exchangeWrapper,
2407                 transaction.payoutRecipient,
2408                 payout
2409             );
2410         }
2411 
2412         if (AddressUtils.isContract(transaction.payoutRecipient)) {
2413             require(
2414                 PayoutRecipient(transaction.payoutRecipient).receiveClosePositionPayout(
2415                     transaction.positionId,
2416                     transaction.closeAmount,
2417                     msg.sender,
2418                     transaction.positionOwner,
2419                     transaction.heldToken,
2420                     payout,
2421                     transaction.availableHeldToken,
2422                     transaction.payoutInHeldToken
2423                 ),
2424                 "ClosePositionShared#sendTokensToPayoutRecipient: Payout recipient does not consent"
2425             );
2426         }
2427 
2428         // The ending heldToken balance of the vault should be the starting heldToken balance
2429         // minus the available heldToken amount
2430         assert(
2431             MarginCommon.getPositionBalanceImpl(state, transaction.positionId)
2432             == transaction.startingHeldTokenBalance.sub(transaction.availableHeldToken)
2433         );
2434 
2435         return payout;
2436     }
2437 
2438     function createCloseTx(
2439         MarginState.State storage state,
2440         bytes32 positionId,
2441         uint256 requestedAmount,
2442         address payoutRecipient,
2443         address exchangeWrapper,
2444         bool payoutInHeldToken,
2445         bool isWithoutCounterparty
2446     )
2447         internal
2448         returns (CloseTx memory)
2449     {
2450         // Validate
2451         require(
2452             payoutRecipient != address(0),
2453             "ClosePositionShared#createCloseTx: Payout recipient cannot be 0"
2454         );
2455         require(
2456             requestedAmount > 0,
2457             "ClosePositionShared#createCloseTx: Requested close amount cannot be 0"
2458         );
2459 
2460         MarginCommon.Position storage position =
2461             MarginCommon.getPositionFromStorage(state, positionId);
2462 
2463         uint256 closeAmount = getApprovedAmount(
2464             position,
2465             positionId,
2466             requestedAmount,
2467             payoutRecipient,
2468             isWithoutCounterparty
2469         );
2470 
2471         return parseCloseTx(
2472             state,
2473             position,
2474             positionId,
2475             closeAmount,
2476             payoutRecipient,
2477             exchangeWrapper,
2478             payoutInHeldToken,
2479             isWithoutCounterparty
2480         );
2481     }
2482 
2483     // ============ Private Helper-Functions ============
2484 
2485     function getApprovedAmount(
2486         MarginCommon.Position storage position,
2487         bytes32 positionId,
2488         uint256 requestedAmount,
2489         address payoutRecipient,
2490         bool requireLenderApproval
2491     )
2492         private
2493         returns (uint256)
2494     {
2495         // Ensure enough principal
2496         uint256 allowedAmount = Math.min256(requestedAmount, position.principal);
2497 
2498         // Ensure owner consent
2499         allowedAmount = closePositionOnBehalfOfRecurse(
2500             position.owner,
2501             msg.sender,
2502             payoutRecipient,
2503             positionId,
2504             allowedAmount
2505         );
2506 
2507         // Ensure lender consent
2508         if (requireLenderApproval) {
2509             allowedAmount = closeLoanOnBehalfOfRecurse(
2510                 position.lender,
2511                 msg.sender,
2512                 payoutRecipient,
2513                 positionId,
2514                 allowedAmount
2515             );
2516         }
2517 
2518         assert(allowedAmount > 0);
2519         assert(allowedAmount <= position.principal);
2520         assert(allowedAmount <= requestedAmount);
2521 
2522         return allowedAmount;
2523     }
2524 
2525     function closePositionOnBehalfOfRecurse(
2526         address contractAddr,
2527         address closer,
2528         address payoutRecipient,
2529         bytes32 positionId,
2530         uint256 closeAmount
2531     )
2532         private
2533         returns (uint256)
2534     {
2535         // no need to ask for permission
2536         if (closer == contractAddr) {
2537             return closeAmount;
2538         }
2539 
2540         (
2541             address newContractAddr,
2542             uint256 newCloseAmount
2543         ) = ClosePositionDelegator(contractAddr).closeOnBehalfOf(
2544             closer,
2545             payoutRecipient,
2546             positionId,
2547             closeAmount
2548         );
2549 
2550         require(
2551             newCloseAmount <= closeAmount,
2552             "ClosePositionShared#closePositionRecurse: newCloseAmount is greater than closeAmount"
2553         );
2554         require(
2555             newCloseAmount > 0,
2556             "ClosePositionShared#closePositionRecurse: newCloseAmount is zero"
2557         );
2558 
2559         if (newContractAddr != contractAddr) {
2560             closePositionOnBehalfOfRecurse(
2561                 newContractAddr,
2562                 closer,
2563                 payoutRecipient,
2564                 positionId,
2565                 newCloseAmount
2566             );
2567         }
2568 
2569         return newCloseAmount;
2570     }
2571 
2572     function closeLoanOnBehalfOfRecurse(
2573         address contractAddr,
2574         address closer,
2575         address payoutRecipient,
2576         bytes32 positionId,
2577         uint256 closeAmount
2578     )
2579         private
2580         returns (uint256)
2581     {
2582         // no need to ask for permission
2583         if (closer == contractAddr) {
2584             return closeAmount;
2585         }
2586 
2587         (
2588             address newContractAddr,
2589             uint256 newCloseAmount
2590         ) = CloseLoanDelegator(contractAddr).closeLoanOnBehalfOf(
2591                 closer,
2592                 payoutRecipient,
2593                 positionId,
2594                 closeAmount
2595             );
2596 
2597         require(
2598             newCloseAmount <= closeAmount,
2599             "ClosePositionShared#closeLoanRecurse: newCloseAmount is greater than closeAmount"
2600         );
2601         require(
2602             newCloseAmount > 0,
2603             "ClosePositionShared#closeLoanRecurse: newCloseAmount is zero"
2604         );
2605 
2606         if (newContractAddr != contractAddr) {
2607             closeLoanOnBehalfOfRecurse(
2608                 newContractAddr,
2609                 closer,
2610                 payoutRecipient,
2611                 positionId,
2612                 newCloseAmount
2613             );
2614         }
2615 
2616         return newCloseAmount;
2617     }
2618 
2619     // ============ Parsing Functions ============
2620 
2621     function parseCloseTx(
2622         MarginState.State storage state,
2623         MarginCommon.Position storage position,
2624         bytes32 positionId,
2625         uint256 closeAmount,
2626         address payoutRecipient,
2627         address exchangeWrapper,
2628         bool payoutInHeldToken,
2629         bool isWithoutCounterparty
2630     )
2631         private
2632         view
2633         returns (CloseTx memory)
2634     {
2635         uint256 startingHeldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
2636 
2637         uint256 availableHeldToken = MathHelpers.getPartialAmount(
2638             closeAmount,
2639             position.principal,
2640             startingHeldTokenBalance
2641         );
2642         uint256 owedTokenOwed = 0;
2643 
2644         if (!isWithoutCounterparty) {
2645             owedTokenOwed = MarginCommon.calculateOwedAmount(
2646                 position,
2647                 closeAmount,
2648                 block.timestamp
2649             );
2650         }
2651 
2652         return CloseTx({
2653             positionId: positionId,
2654             originalPrincipal: position.principal,
2655             closeAmount: closeAmount,
2656             owedTokenOwed: owedTokenOwed,
2657             startingHeldTokenBalance: startingHeldTokenBalance,
2658             availableHeldToken: availableHeldToken,
2659             payoutRecipient: payoutRecipient,
2660             owedToken: position.owedToken,
2661             heldToken: position.heldToken,
2662             positionOwner: position.owner,
2663             positionLender: position.lender,
2664             exchangeWrapper: exchangeWrapper,
2665             payoutInHeldToken: payoutInHeldToken
2666         });
2667     }
2668 }
2669 
2670 // File: contracts/margin/interfaces/ExchangeWrapper.sol
2671 
2672 /**
2673  * @title ExchangeWrapper
2674  * @author dYdX
2675  *
2676  * Contract interface that Exchange Wrapper smart contracts must implement in order to interface
2677  * with other smart contracts through a common interface.
2678  */
2679 interface ExchangeWrapper {
2680 
2681     // ============ Public Functions ============
2682 
2683     /**
2684      * Exchange some amount of takerToken for makerToken.
2685      *
2686      * @param  tradeOriginator      Address of the initiator of the trade (however, this value
2687      *                              cannot always be trusted as it is set at the discretion of the
2688      *                              msg.sender)
2689      * @param  receiver             Address to set allowance on once the trade has completed
2690      * @param  makerToken           Address of makerToken, the token to receive
2691      * @param  takerToken           Address of takerToken, the token to pay
2692      * @param  requestedFillAmount  Amount of takerToken being paid
2693      * @param  orderData            Arbitrary bytes data for any information to pass to the exchange
2694      * @return                      The amount of makerToken received
2695      */
2696     function exchange(
2697         address tradeOriginator,
2698         address receiver,
2699         address makerToken,
2700         address takerToken,
2701         uint256 requestedFillAmount,
2702         bytes orderData
2703     )
2704         external
2705         returns (uint256);
2706 
2707     /**
2708      * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.
2709      * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide
2710      * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater
2711      * than desiredMakerToken
2712      *
2713      * @param  makerToken         Address of makerToken, the token to receive
2714      * @param  takerToken         Address of takerToken, the token to pay
2715      * @param  desiredMakerToken  Amount of makerToken requested
2716      * @param  orderData          Arbitrary bytes data for any information to pass to the exchange
2717      * @return                    Amount of takerToken the needed to complete the transaction
2718      */
2719     function getExchangeCost(
2720         address makerToken,
2721         address takerToken,
2722         uint256 desiredMakerToken,
2723         bytes orderData
2724     )
2725         external
2726         view
2727         returns (uint256);
2728 }
2729 
2730 // File: contracts/margin/impl/ClosePositionImpl.sol
2731 
2732 /**
2733  * @title ClosePositionImpl
2734  * @author dYdX
2735  *
2736  * This library contains the implementation for the closePosition function of Margin
2737  */
2738 library ClosePositionImpl {
2739     using SafeMath for uint256;
2740 
2741     // ============ Events ============
2742 
2743     /**
2744      * A position was closed or partially closed
2745      */
2746     event PositionClosed(
2747         bytes32 indexed positionId,
2748         address indexed closer,
2749         address indexed payoutRecipient,
2750         uint256 closeAmount,
2751         uint256 remainingAmount,
2752         uint256 owedTokenPaidToLender,
2753         uint256 payoutAmount,
2754         uint256 buybackCostInHeldToken,
2755         bool    payoutInHeldToken
2756     );
2757 
2758     // ============ Public Implementation Functions ============
2759 
2760     function closePositionImpl(
2761         MarginState.State storage state,
2762         bytes32 positionId,
2763         uint256 requestedCloseAmount,
2764         address payoutRecipient,
2765         address exchangeWrapper,
2766         bool payoutInHeldToken,
2767         bytes memory orderData
2768     )
2769         public
2770         returns (uint256, uint256, uint256)
2771     {
2772         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2773             state,
2774             positionId,
2775             requestedCloseAmount,
2776             payoutRecipient,
2777             exchangeWrapper,
2778             payoutInHeldToken,
2779             false
2780         );
2781 
2782         (
2783             uint256 buybackCostInHeldToken,
2784             uint256 receivedOwedToken
2785         ) = returnOwedTokensToLender(
2786             state,
2787             transaction,
2788             orderData
2789         );
2790 
2791         uint256 payout = ClosePositionShared.sendTokensToPayoutRecipient(
2792             state,
2793             transaction,
2794             buybackCostInHeldToken,
2795             receivedOwedToken
2796         );
2797 
2798         ClosePositionShared.closePositionStateUpdate(state, transaction);
2799 
2800         logEventOnClose(
2801             transaction,
2802             buybackCostInHeldToken,
2803             payout
2804         );
2805 
2806         return (
2807             transaction.closeAmount,
2808             payout,
2809             transaction.owedTokenOwed
2810         );
2811     }
2812 
2813     // ============ Private Helper-Functions ============
2814 
2815     function returnOwedTokensToLender(
2816         MarginState.State storage state,
2817         ClosePositionShared.CloseTx memory transaction,
2818         bytes memory orderData
2819     )
2820         private
2821         returns (uint256, uint256)
2822     {
2823         uint256 buybackCostInHeldToken = 0;
2824         uint256 receivedOwedToken = 0;
2825         uint256 lenderOwedToken = transaction.owedTokenOwed;
2826 
2827         // Setting exchangeWrapper to 0x000... indicates owedToken should be taken directly
2828         // from msg.sender
2829         if (transaction.exchangeWrapper == address(0)) {
2830             require(
2831                 transaction.payoutInHeldToken,
2832                 "ClosePositionImpl#returnOwedTokensToLender: Cannot payout in owedToken"
2833             );
2834 
2835             // No DEX Order; send owedTokens directly from the closer to the lender
2836             TokenProxy(state.TOKEN_PROXY).transferTokens(
2837                 transaction.owedToken,
2838                 msg.sender,
2839                 transaction.positionLender,
2840                 lenderOwedToken
2841             );
2842         } else {
2843             // Buy back owedTokens using DEX Order and send to lender
2844             (buybackCostInHeldToken, receivedOwedToken) = buyBackOwedToken(
2845                 state,
2846                 transaction,
2847                 orderData
2848             );
2849 
2850             // If no owedToken needed for payout: give lender all owedToken, even if more than owed
2851             if (transaction.payoutInHeldToken) {
2852                 assert(receivedOwedToken >= lenderOwedToken);
2853                 lenderOwedToken = receivedOwedToken;
2854             }
2855 
2856             // Transfer owedToken from the exchange wrapper to the lender
2857             TokenProxy(state.TOKEN_PROXY).transferTokens(
2858                 transaction.owedToken,
2859                 transaction.exchangeWrapper,
2860                 transaction.positionLender,
2861                 lenderOwedToken
2862             );
2863         }
2864 
2865         state.totalOwedTokenRepaidToLender[transaction.positionId] =
2866             state.totalOwedTokenRepaidToLender[transaction.positionId].add(lenderOwedToken);
2867 
2868         return (buybackCostInHeldToken, receivedOwedToken);
2869     }
2870 
2871     function buyBackOwedToken(
2872         MarginState.State storage state,
2873         ClosePositionShared.CloseTx transaction,
2874         bytes memory orderData
2875     )
2876         private
2877         returns (uint256, uint256)
2878     {
2879         // Ask the exchange wrapper the cost in heldToken to buy back the close
2880         // amount of owedToken
2881         uint256 buybackCostInHeldToken;
2882 
2883         if (transaction.payoutInHeldToken) {
2884             buybackCostInHeldToken = ExchangeWrapper(transaction.exchangeWrapper)
2885                 .getExchangeCost(
2886                     transaction.owedToken,
2887                     transaction.heldToken,
2888                     transaction.owedTokenOwed,
2889                     orderData
2890                 );
2891 
2892             // Require enough available heldToken to pay for the buyback
2893             require(
2894                 buybackCostInHeldToken <= transaction.availableHeldToken,
2895                 "ClosePositionImpl#buyBackOwedToken: Not enough available heldToken"
2896             );
2897         } else {
2898             buybackCostInHeldToken = transaction.availableHeldToken;
2899         }
2900 
2901         // Send the requisite heldToken to do the buyback from vault to exchange wrapper
2902         Vault(state.VAULT).transferFromVault(
2903             transaction.positionId,
2904             transaction.heldToken,
2905             transaction.exchangeWrapper,
2906             buybackCostInHeldToken
2907         );
2908 
2909         // Trade the heldToken for the owedToken
2910         uint256 receivedOwedToken = ExchangeWrapper(transaction.exchangeWrapper).exchange(
2911             msg.sender,
2912             state.TOKEN_PROXY,
2913             transaction.owedToken,
2914             transaction.heldToken,
2915             buybackCostInHeldToken,
2916             orderData
2917         );
2918 
2919         require(
2920             receivedOwedToken >= transaction.owedTokenOwed,
2921             "ClosePositionImpl#buyBackOwedToken: Did not receive enough owedToken"
2922         );
2923 
2924         return (buybackCostInHeldToken, receivedOwedToken);
2925     }
2926 
2927     function logEventOnClose(
2928         ClosePositionShared.CloseTx transaction,
2929         uint256 buybackCostInHeldToken,
2930         uint256 payout
2931     )
2932         private
2933     {
2934         emit PositionClosed(
2935             transaction.positionId,
2936             msg.sender,
2937             transaction.payoutRecipient,
2938             transaction.closeAmount,
2939             transaction.originalPrincipal.sub(transaction.closeAmount),
2940             transaction.owedTokenOwed,
2941             payout,
2942             buybackCostInHeldToken,
2943             transaction.payoutInHeldToken
2944         );
2945     }
2946 
2947 }
2948 
2949 // File: contracts/margin/impl/CloseWithoutCounterpartyImpl.sol
2950 
2951 /**
2952  * @title CloseWithoutCounterpartyImpl
2953  * @author dYdX
2954  *
2955  * This library contains the implementation for the closeWithoutCounterpartyImpl function of
2956  * Margin
2957  */
2958 library CloseWithoutCounterpartyImpl {
2959     using SafeMath for uint256;
2960 
2961     // ============ Events ============
2962 
2963     /**
2964      * A position was closed or partially closed
2965      */
2966     event PositionClosed(
2967         bytes32 indexed positionId,
2968         address indexed closer,
2969         address indexed payoutRecipient,
2970         uint256 closeAmount,
2971         uint256 remainingAmount,
2972         uint256 owedTokenPaidToLender,
2973         uint256 payoutAmount,
2974         uint256 buybackCostInHeldToken,
2975         bool payoutInHeldToken
2976     );
2977 
2978     // ============ Public Implementation Functions ============
2979 
2980     function closeWithoutCounterpartyImpl(
2981         MarginState.State storage state,
2982         bytes32 positionId,
2983         uint256 requestedCloseAmount,
2984         address payoutRecipient
2985     )
2986         public
2987         returns (uint256, uint256)
2988     {
2989         ClosePositionShared.CloseTx memory transaction = ClosePositionShared.createCloseTx(
2990             state,
2991             positionId,
2992             requestedCloseAmount,
2993             payoutRecipient,
2994             address(0),
2995             true,
2996             true
2997         );
2998 
2999         uint256 heldTokenPayout = ClosePositionShared.sendTokensToPayoutRecipient(
3000             state,
3001             transaction,
3002             0, // No buyback cost
3003             0  // Did not receive any owedToken
3004         );
3005 
3006         ClosePositionShared.closePositionStateUpdate(state, transaction);
3007 
3008         logEventOnCloseWithoutCounterparty(transaction);
3009 
3010         return (
3011             transaction.closeAmount,
3012             heldTokenPayout
3013         );
3014     }
3015 
3016     // ============ Private Helper-Functions ============
3017 
3018     function logEventOnCloseWithoutCounterparty(
3019         ClosePositionShared.CloseTx transaction
3020     )
3021         private
3022     {
3023         emit PositionClosed(
3024             transaction.positionId,
3025             msg.sender,
3026             transaction.payoutRecipient,
3027             transaction.closeAmount,
3028             transaction.originalPrincipal.sub(transaction.closeAmount),
3029             0,
3030             transaction.availableHeldToken,
3031             0,
3032             true
3033         );
3034     }
3035 }
3036 
3037 // File: contracts/margin/interfaces/owner/DepositCollateralDelegator.sol
3038 
3039 /**
3040  * @title DepositCollateralDelegator
3041  * @author dYdX
3042  *
3043  * Interface that smart contracts must implement in order to let other addresses deposit heldTokens
3044  * into a position owned by the smart contract.
3045  *
3046  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3047  *       to these functions
3048  */
3049 interface DepositCollateralDelegator {
3050 
3051     // ============ Public Interface functions ============
3052 
3053     /**
3054      * Function a contract must implement in order to let other addresses call depositCollateral().
3055      *
3056      * @param  depositor   Address of the caller of the depositCollateral() function
3057      * @param  positionId  Unique ID of the position
3058      * @param  amount      Requested deposit amount
3059      * @return             This address to accept, a different address to ask that contract
3060      */
3061     function depositCollateralOnBehalfOf(
3062         address depositor,
3063         bytes32 positionId,
3064         uint256 amount
3065     )
3066         external
3067         /* onlyMargin */
3068         returns (address);
3069 }
3070 
3071 // File: contracts/margin/impl/DepositCollateralImpl.sol
3072 
3073 /**
3074  * @title DepositCollateralImpl
3075  * @author dYdX
3076  *
3077  * This library contains the implementation for the deposit function of Margin
3078  */
3079 library DepositCollateralImpl {
3080     using SafeMath for uint256;
3081 
3082     // ============ Events ============
3083 
3084     /**
3085      * Additional collateral for a position was posted by the owner
3086      */
3087     event AdditionalCollateralDeposited(
3088         bytes32 indexed positionId,
3089         uint256 amount,
3090         address depositor
3091     );
3092 
3093     /**
3094      * A margin call was canceled
3095      */
3096     event MarginCallCanceled(
3097         bytes32 indexed positionId,
3098         address indexed lender,
3099         address indexed owner,
3100         uint256 depositAmount
3101     );
3102 
3103     // ============ Public Implementation Functions ============
3104 
3105     function depositCollateralImpl(
3106         MarginState.State storage state,
3107         bytes32 positionId,
3108         uint256 depositAmount
3109     )
3110         public
3111     {
3112         MarginCommon.Position storage position =
3113             MarginCommon.getPositionFromStorage(state, positionId);
3114 
3115         require(
3116             depositAmount > 0,
3117             "DepositCollateralImpl#depositCollateralImpl: Deposit amount cannot be 0"
3118         );
3119 
3120         // Ensure owner consent
3121         depositCollateralOnBehalfOfRecurse(
3122             position.owner,
3123             msg.sender,
3124             positionId,
3125             depositAmount
3126         );
3127 
3128         Vault(state.VAULT).transferToVault(
3129             positionId,
3130             position.heldToken,
3131             msg.sender,
3132             depositAmount
3133         );
3134 
3135         // cancel margin call if applicable
3136         bool marginCallCanceled = false;
3137         uint256 requiredDeposit = position.requiredDeposit;
3138         if (position.callTimestamp > 0 && requiredDeposit > 0) {
3139             if (depositAmount >= requiredDeposit) {
3140                 position.requiredDeposit = 0;
3141                 position.callTimestamp = 0;
3142                 marginCallCanceled = true;
3143             } else {
3144                 position.requiredDeposit = position.requiredDeposit.sub(depositAmount);
3145             }
3146         }
3147 
3148         emit AdditionalCollateralDeposited(
3149             positionId,
3150             depositAmount,
3151             msg.sender
3152         );
3153 
3154         if (marginCallCanceled) {
3155             emit MarginCallCanceled(
3156                 positionId,
3157                 position.lender,
3158                 msg.sender,
3159                 depositAmount
3160             );
3161         }
3162     }
3163 
3164     // ============ Private Helper-Functions ============
3165 
3166     function depositCollateralOnBehalfOfRecurse(
3167         address contractAddr,
3168         address depositor,
3169         bytes32 positionId,
3170         uint256 amount
3171     )
3172         private
3173     {
3174         // no need to ask for permission
3175         if (depositor == contractAddr) {
3176             return;
3177         }
3178 
3179         address newContractAddr =
3180             DepositCollateralDelegator(contractAddr).depositCollateralOnBehalfOf(
3181                 depositor,
3182                 positionId,
3183                 amount
3184             );
3185 
3186         // if not equal, recurse
3187         if (newContractAddr != contractAddr) {
3188             depositCollateralOnBehalfOfRecurse(
3189                 newContractAddr,
3190                 depositor,
3191                 positionId,
3192                 amount
3193             );
3194         }
3195     }
3196 }
3197 
3198 // File: contracts/margin/interfaces/lender/ForceRecoverCollateralDelegator.sol
3199 
3200 /**
3201  * @title ForceRecoverCollateralDelegator
3202  * @author dYdX
3203  *
3204  * Interface that smart contracts must implement in order to let other addresses
3205  * forceRecoverCollateral() a loan owned by the smart contract.
3206  *
3207  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3208  *       to these functions
3209  */
3210 interface ForceRecoverCollateralDelegator {
3211 
3212     // ============ Public Interface functions ============
3213 
3214     /**
3215      * Function a contract must implement in order to let other addresses call
3216      * forceRecoverCollateral().
3217      *
3218      * NOTE: If not returning zero address (or not reverting), this contract must assume that Margin
3219      * will either revert the entire transaction or that the collateral was forcibly recovered.
3220      *
3221      * @param  recoverer   Address of the caller of the forceRecoverCollateral() function
3222      * @param  positionId  Unique ID of the position
3223      * @param  recipient   Address to send the recovered tokens to
3224      * @return             This address to accept, a different address to ask that contract
3225      */
3226     function forceRecoverCollateralOnBehalfOf(
3227         address recoverer,
3228         bytes32 positionId,
3229         address recipient
3230     )
3231         external
3232         /* onlyMargin */
3233         returns (address);
3234 }
3235 
3236 // File: contracts/margin/impl/ForceRecoverCollateralImpl.sol
3237 
3238 /* solium-disable-next-line max-len*/
3239 
3240 /**
3241  * @title ForceRecoverCollateralImpl
3242  * @author dYdX
3243  *
3244  * This library contains the implementation for the forceRecoverCollateral function of Margin
3245  */
3246 library ForceRecoverCollateralImpl {
3247     using SafeMath for uint256;
3248 
3249     // ============ Events ============
3250 
3251     /**
3252      * Collateral for a position was forcibly recovered
3253      */
3254     event CollateralForceRecovered(
3255         bytes32 indexed positionId,
3256         address indexed recipient,
3257         uint256 amount
3258     );
3259 
3260     // ============ Public Implementation Functions ============
3261 
3262     function forceRecoverCollateralImpl(
3263         MarginState.State storage state,
3264         bytes32 positionId,
3265         address recipient
3266     )
3267         public
3268         returns (uint256)
3269     {
3270         MarginCommon.Position storage position =
3271             MarginCommon.getPositionFromStorage(state, positionId);
3272 
3273         // Can only force recover after either:
3274         // 1) The loan was called and the call period has elapsed
3275         // 2) The maxDuration of the position has elapsed
3276         require( /* solium-disable-next-line */
3277             (
3278                 position.callTimestamp > 0
3279                 && block.timestamp >= uint256(position.callTimestamp).add(position.callTimeLimit)
3280             ) || (
3281                 block.timestamp >= uint256(position.startTimestamp).add(position.maxDuration)
3282             ),
3283             "ForceRecoverCollateralImpl#forceRecoverCollateralImpl: Cannot recover yet"
3284         );
3285 
3286         // Ensure lender consent
3287         forceRecoverCollateralOnBehalfOfRecurse(
3288             position.lender,
3289             msg.sender,
3290             positionId,
3291             recipient
3292         );
3293 
3294         // Send the tokens
3295         uint256 heldTokenRecovered = MarginCommon.getPositionBalanceImpl(state, positionId);
3296         Vault(state.VAULT).transferFromVault(
3297             positionId,
3298             position.heldToken,
3299             recipient,
3300             heldTokenRecovered
3301         );
3302 
3303         // Delete the position
3304         // NOTE: Since position is a storage pointer, this will also set all fields on
3305         //       the position variable to 0
3306         MarginCommon.cleanupPosition(
3307             state,
3308             positionId
3309         );
3310 
3311         // Log an event
3312         emit CollateralForceRecovered(
3313             positionId,
3314             recipient,
3315             heldTokenRecovered
3316         );
3317 
3318         return heldTokenRecovered;
3319     }
3320 
3321     // ============ Private Helper-Functions ============
3322 
3323     function forceRecoverCollateralOnBehalfOfRecurse(
3324         address contractAddr,
3325         address recoverer,
3326         bytes32 positionId,
3327         address recipient
3328     )
3329         private
3330     {
3331         // no need to ask for permission
3332         if (recoverer == contractAddr) {
3333             return;
3334         }
3335 
3336         address newContractAddr =
3337             ForceRecoverCollateralDelegator(contractAddr).forceRecoverCollateralOnBehalfOf(
3338                 recoverer,
3339                 positionId,
3340                 recipient
3341             );
3342 
3343         if (newContractAddr != contractAddr) {
3344             forceRecoverCollateralOnBehalfOfRecurse(
3345                 newContractAddr,
3346                 recoverer,
3347                 positionId,
3348                 recipient
3349             );
3350         }
3351     }
3352 }
3353 
3354 // File: contracts/lib/TypedSignature.sol
3355 
3356 /**
3357  * @title TypedSignature
3358  * @author dYdX
3359  *
3360  * Allows for ecrecovery of signed hashes with three different prepended messages:
3361  * 1) ""
3362  * 2) "\x19Ethereum Signed Message:\n32"
3363  * 3) "\x19Ethereum Signed Message:\n\x20"
3364  */
3365 library TypedSignature {
3366 
3367     // Solidity does not offer guarantees about enum values, so we define them explicitly
3368     uint8 private constant SIGTYPE_INVALID = 0;
3369     uint8 private constant SIGTYPE_ECRECOVER_DEC = 1;
3370     uint8 private constant SIGTYPE_ECRECOVER_HEX = 2;
3371     uint8 private constant SIGTYPE_UNSUPPORTED = 3;
3372 
3373     // prepended message with the length of the signed hash in hexadecimal
3374     bytes constant private PREPEND_HEX = "\x19Ethereum Signed Message:\n\x20";
3375 
3376     // prepended message with the length of the signed hash in decimal
3377     bytes constant private PREPEND_DEC = "\x19Ethereum Signed Message:\n32";
3378 
3379     /**
3380      * Gives the address of the signer of a hash. Allows for three common prepended strings.
3381      *
3382      * @param  hash               Hash that was signed (does not include prepended message)
3383      * @param  signatureWithType  Type and ECDSA signature with structure: {1:type}{1:v}{32:r}{32:s}
3384      * @return                    address of the signer of the hash
3385      */
3386     function recover(
3387         bytes32 hash,
3388         bytes signatureWithType
3389     )
3390         internal
3391         pure
3392         returns (address)
3393     {
3394         require(
3395             signatureWithType.length == 66,
3396             "SignatureValidator#validateSignature: invalid signature length"
3397         );
3398 
3399         uint8 sigType = uint8(signatureWithType[0]);
3400 
3401         require(
3402             sigType > uint8(SIGTYPE_INVALID),
3403             "SignatureValidator#validateSignature: invalid signature type"
3404         );
3405         require(
3406             sigType < uint8(SIGTYPE_UNSUPPORTED),
3407             "SignatureValidator#validateSignature: unsupported signature type"
3408         );
3409 
3410         uint8 v = uint8(signatureWithType[1]);
3411         bytes32 r;
3412         bytes32 s;
3413 
3414         /* solium-disable-next-line security/no-inline-assembly */
3415         assembly {
3416             r := mload(add(signatureWithType, 34))
3417             s := mload(add(signatureWithType, 66))
3418         }
3419 
3420         bytes32 signedHash;
3421         if (sigType == SIGTYPE_ECRECOVER_DEC) {
3422             signedHash = keccak256(abi.encodePacked(PREPEND_DEC, hash));
3423         } else {
3424             assert(sigType == SIGTYPE_ECRECOVER_HEX);
3425             signedHash = keccak256(abi.encodePacked(PREPEND_HEX, hash));
3426         }
3427 
3428         return ecrecover(
3429             signedHash,
3430             v,
3431             r,
3432             s
3433         );
3434     }
3435 }
3436 
3437 // File: contracts/margin/interfaces/LoanOfferingVerifier.sol
3438 
3439 /**
3440  * @title LoanOfferingVerifier
3441  * @author dYdX
3442  *
3443  * Interface that smart contracts must implement to be able to make off-chain generated
3444  * loan offerings.
3445  *
3446  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3447  *       to these functions
3448  */
3449 interface LoanOfferingVerifier {
3450 
3451     /**
3452      * Function a smart contract must implement to be able to consent to a loan. The loan offering
3453      * will be generated off-chain. The "loan owner" address will own the loan-side of the resulting
3454      * position.
3455      *
3456      * If true is returned, and no errors are thrown by the Margin contract, the loan will have
3457      * occurred. This means that verifyLoanOffering can also be used to update internal contract
3458      * state on a loan.
3459      *
3460      * @param  addresses    Array of addresses:
3461      *
3462      *  [0] = owedToken
3463      *  [1] = heldToken
3464      *  [2] = loan payer
3465      *  [3] = loan owner
3466      *  [4] = loan taker
3467      *  [5] = loan positionOwner
3468      *  [6] = loan fee recipient
3469      *  [7] = loan lender fee token
3470      *  [8] = loan taker fee token
3471      *
3472      * @param  values256    Values corresponding to:
3473      *
3474      *  [0] = loan maximum amount
3475      *  [1] = loan minimum amount
3476      *  [2] = loan minimum heldToken
3477      *  [3] = loan lender fee
3478      *  [4] = loan taker fee
3479      *  [5] = loan expiration timestamp (in seconds)
3480      *  [6] = loan salt
3481      *
3482      * @param  values32     Values corresponding to:
3483      *
3484      *  [0] = loan call time limit (in seconds)
3485      *  [1] = loan maxDuration (in seconds)
3486      *  [2] = loan interest rate (annual nominal percentage times 10**6)
3487      *  [3] = loan interest update period (in seconds)
3488      *
3489      * @param  positionId   Unique ID of the position
3490      * @param  signature    Arbitrary bytes; may or may not be an ECDSA signature
3491      * @return              This address to accept, a different address to ask that contract
3492      */
3493     function verifyLoanOffering(
3494         address[9] addresses,
3495         uint256[7] values256,
3496         uint32[4] values32,
3497         bytes32 positionId,
3498         bytes signature
3499     )
3500         external
3501         /* onlyMargin */
3502         returns (address);
3503 }
3504 
3505 // File: contracts/margin/impl/BorrowShared.sol
3506 
3507 /**
3508  * @title BorrowShared
3509  * @author dYdX
3510  *
3511  * This library contains shared functionality between OpenPositionImpl and IncreasePositionImpl.
3512  * Both use a Loan Offering and a DEX Order to open or increase a position.
3513  */
3514 library BorrowShared {
3515     using SafeMath for uint256;
3516 
3517     // ============ Structs ============
3518 
3519     struct Tx {
3520         bytes32 positionId;
3521         address owner;
3522         uint256 principal;
3523         uint256 lenderAmount;
3524         MarginCommon.LoanOffering loanOffering;
3525         address exchangeWrapper;
3526         bool depositInHeldToken;
3527         uint256 depositAmount;
3528         uint256 collateralAmount;
3529         uint256 heldTokenFromSell;
3530     }
3531 
3532     // ============ Internal Implementation Functions ============
3533 
3534     /**
3535      * Validate the transaction before exchanging heldToken for owedToken
3536      */
3537     function validateTxPreSell(
3538         MarginState.State storage state,
3539         Tx memory transaction
3540     )
3541         internal
3542     {
3543         assert(transaction.lenderAmount >= transaction.principal);
3544 
3545         require(
3546             transaction.principal > 0,
3547             "BorrowShared#validateTxPreSell: Positions with 0 principal are not allowed"
3548         );
3549 
3550         // If the taker is 0x0 then any address can take it. Otherwise only the taker can use it.
3551         if (transaction.loanOffering.taker != address(0)) {
3552             require(
3553                 msg.sender == transaction.loanOffering.taker,
3554                 "BorrowShared#validateTxPreSell: Invalid loan offering taker"
3555             );
3556         }
3557 
3558         // If the positionOwner is 0x0 then any address can be set as the position owner.
3559         // Otherwise only the specified positionOwner can be set as the position owner.
3560         if (transaction.loanOffering.positionOwner != address(0)) {
3561             require(
3562                 transaction.owner == transaction.loanOffering.positionOwner,
3563                 "BorrowShared#validateTxPreSell: Invalid position owner"
3564             );
3565         }
3566 
3567         // Require the loan offering to be approved by the payer
3568         if (AddressUtils.isContract(transaction.loanOffering.payer)) {
3569             getConsentFromSmartContractLender(transaction);
3570         } else {
3571             require(
3572                 transaction.loanOffering.payer == TypedSignature.recover(
3573                     transaction.loanOffering.loanHash,
3574                     transaction.loanOffering.signature
3575                 ),
3576                 "BorrowShared#validateTxPreSell: Invalid loan offering signature"
3577             );
3578         }
3579 
3580         // Validate the amount is <= than max and >= min
3581         uint256 unavailable = MarginCommon.getUnavailableLoanOfferingAmountImpl(
3582             state,
3583             transaction.loanOffering.loanHash
3584         );
3585         require(
3586             transaction.lenderAmount.add(unavailable) <= transaction.loanOffering.rates.maxAmount,
3587             "BorrowShared#validateTxPreSell: Loan offering does not have enough available"
3588         );
3589 
3590         require(
3591             transaction.lenderAmount >= transaction.loanOffering.rates.minAmount,
3592             "BorrowShared#validateTxPreSell: Lender amount is below loan offering minimum amount"
3593         );
3594 
3595         require(
3596             transaction.loanOffering.owedToken != transaction.loanOffering.heldToken,
3597             "BorrowShared#validateTxPreSell: owedToken cannot be equal to heldToken"
3598         );
3599 
3600         require(
3601             transaction.owner != address(0),
3602             "BorrowShared#validateTxPreSell: Position owner cannot be 0"
3603         );
3604 
3605         require(
3606             transaction.loanOffering.owner != address(0),
3607             "BorrowShared#validateTxPreSell: Loan owner cannot be 0"
3608         );
3609 
3610         require(
3611             transaction.loanOffering.expirationTimestamp > block.timestamp,
3612             "BorrowShared#validateTxPreSell: Loan offering is expired"
3613         );
3614 
3615         require(
3616             transaction.loanOffering.maxDuration > 0,
3617             "BorrowShared#validateTxPreSell: Loan offering has 0 maximum duration"
3618         );
3619 
3620         require(
3621             transaction.loanOffering.rates.interestPeriod <= transaction.loanOffering.maxDuration,
3622             "BorrowShared#validateTxPreSell: Loan offering interestPeriod > maxDuration"
3623         );
3624 
3625         // The minimum heldToken is validated after executing the sell
3626         // Position and loan ownership is validated in TransferInternal
3627     }
3628 
3629     /**
3630      * Validate the transaction after exchanging heldToken for owedToken, pay out fees, and store
3631      * how much of the loan was used.
3632      */
3633     function doPostSell(
3634         MarginState.State storage state,
3635         Tx memory transaction
3636     )
3637         internal
3638     {
3639         validateTxPostSell(transaction);
3640 
3641         // Transfer feeTokens from trader and lender
3642         transferLoanFees(state, transaction);
3643 
3644         // Update global amounts for the loan
3645         state.loanFills[transaction.loanOffering.loanHash] =
3646             state.loanFills[transaction.loanOffering.loanHash].add(transaction.lenderAmount);
3647     }
3648 
3649     /**
3650      * Sells the owedToken from the lender (and from the deposit if in owedToken) using the
3651      * exchangeWrapper, then puts the resulting heldToken into the vault. Only trades for
3652      * maxHeldTokenToBuy of heldTokens at most.
3653      */
3654     function doSell(
3655         MarginState.State storage state,
3656         Tx transaction,
3657         bytes orderData,
3658         uint256 maxHeldTokenToBuy
3659     )
3660         internal
3661         returns (uint256)
3662     {
3663         // Move owedTokens from lender to exchange wrapper
3664         pullOwedTokensFromLender(state, transaction);
3665 
3666         // Sell just the lender's owedToken (if trader deposit is in heldToken)
3667         // Otherwise sell both the lender's owedToken and the trader's deposit in owedToken
3668         uint256 sellAmount = transaction.depositInHeldToken ?
3669             transaction.lenderAmount :
3670             transaction.lenderAmount.add(transaction.depositAmount);
3671 
3672         // Do the trade, taking only the maxHeldTokenToBuy if more is returned
3673         uint256 heldTokenFromSell = Math.min256(
3674             maxHeldTokenToBuy,
3675             ExchangeWrapper(transaction.exchangeWrapper).exchange(
3676                 msg.sender,
3677                 state.TOKEN_PROXY,
3678                 transaction.loanOffering.heldToken,
3679                 transaction.loanOffering.owedToken,
3680                 sellAmount,
3681                 orderData
3682             )
3683         );
3684 
3685         // Move the tokens to the vault
3686         Vault(state.VAULT).transferToVault(
3687             transaction.positionId,
3688             transaction.loanOffering.heldToken,
3689             transaction.exchangeWrapper,
3690             heldTokenFromSell
3691         );
3692 
3693         // Update collateral amount
3694         transaction.collateralAmount = transaction.collateralAmount.add(heldTokenFromSell);
3695 
3696         return heldTokenFromSell;
3697     }
3698 
3699     /**
3700      * Take the owedToken deposit from the trader and give it to the exchange wrapper so that it can
3701      * be sold for heldToken.
3702      */
3703     function doDepositOwedToken(
3704         MarginState.State storage state,
3705         Tx transaction
3706     )
3707         internal
3708     {
3709         TokenProxy(state.TOKEN_PROXY).transferTokens(
3710             transaction.loanOffering.owedToken,
3711             msg.sender,
3712             transaction.exchangeWrapper,
3713             transaction.depositAmount
3714         );
3715     }
3716 
3717     /**
3718      * Take the heldToken deposit from the trader and move it to the vault.
3719      */
3720     function doDepositHeldToken(
3721         MarginState.State storage state,
3722         Tx transaction
3723     )
3724         internal
3725     {
3726         Vault(state.VAULT).transferToVault(
3727             transaction.positionId,
3728             transaction.loanOffering.heldToken,
3729             msg.sender,
3730             transaction.depositAmount
3731         );
3732 
3733         // Update collateral amount
3734         transaction.collateralAmount = transaction.collateralAmount.add(transaction.depositAmount);
3735     }
3736 
3737     // ============ Private Helper-Functions ============
3738 
3739     function validateTxPostSell(
3740         Tx transaction
3741     )
3742         private
3743         pure
3744     {
3745         uint256 expectedCollateral = transaction.depositInHeldToken ?
3746             transaction.heldTokenFromSell.add(transaction.depositAmount) :
3747             transaction.heldTokenFromSell;
3748         assert(transaction.collateralAmount == expectedCollateral);
3749 
3750         uint256 loanOfferingMinimumHeldToken = MathHelpers.getPartialAmountRoundedUp(
3751             transaction.lenderAmount,
3752             transaction.loanOffering.rates.maxAmount,
3753             transaction.loanOffering.rates.minHeldToken
3754         );
3755         require(
3756             transaction.collateralAmount >= loanOfferingMinimumHeldToken,
3757             "BorrowShared#validateTxPostSell: Loan offering minimum held token not met"
3758         );
3759     }
3760 
3761     function getConsentFromSmartContractLender(
3762         Tx transaction
3763     )
3764         private
3765     {
3766         verifyLoanOfferingRecurse(
3767             transaction.loanOffering.payer,
3768             getLoanOfferingAddresses(transaction),
3769             getLoanOfferingValues256(transaction),
3770             getLoanOfferingValues32(transaction),
3771             transaction.positionId,
3772             transaction.loanOffering.signature
3773         );
3774     }
3775 
3776     function verifyLoanOfferingRecurse(
3777         address contractAddr,
3778         address[9] addresses,
3779         uint256[7] values256,
3780         uint32[4] values32,
3781         bytes32 positionId,
3782         bytes signature
3783     )
3784         private
3785     {
3786         address newContractAddr = LoanOfferingVerifier(contractAddr).verifyLoanOffering(
3787             addresses,
3788             values256,
3789             values32,
3790             positionId,
3791             signature
3792         );
3793 
3794         if (newContractAddr != contractAddr) {
3795             verifyLoanOfferingRecurse(
3796                 newContractAddr,
3797                 addresses,
3798                 values256,
3799                 values32,
3800                 positionId,
3801                 signature
3802             );
3803         }
3804     }
3805 
3806     function pullOwedTokensFromLender(
3807         MarginState.State storage state,
3808         Tx transaction
3809     )
3810         private
3811     {
3812         // Transfer owedToken to the exchange wrapper
3813         TokenProxy(state.TOKEN_PROXY).transferTokens(
3814             transaction.loanOffering.owedToken,
3815             transaction.loanOffering.payer,
3816             transaction.exchangeWrapper,
3817             transaction.lenderAmount
3818         );
3819     }
3820 
3821     function transferLoanFees(
3822         MarginState.State storage state,
3823         Tx transaction
3824     )
3825         private
3826     {
3827         // 0 fee address indicates no fees
3828         if (transaction.loanOffering.feeRecipient == address(0)) {
3829             return;
3830         }
3831 
3832         TokenProxy proxy = TokenProxy(state.TOKEN_PROXY);
3833 
3834         uint256 lenderFee = MathHelpers.getPartialAmount(
3835             transaction.lenderAmount,
3836             transaction.loanOffering.rates.maxAmount,
3837             transaction.loanOffering.rates.lenderFee
3838         );
3839         uint256 takerFee = MathHelpers.getPartialAmount(
3840             transaction.lenderAmount,
3841             transaction.loanOffering.rates.maxAmount,
3842             transaction.loanOffering.rates.takerFee
3843         );
3844 
3845         if (lenderFee > 0) {
3846             proxy.transferTokens(
3847                 transaction.loanOffering.lenderFeeToken,
3848                 transaction.loanOffering.payer,
3849                 transaction.loanOffering.feeRecipient,
3850                 lenderFee
3851             );
3852         }
3853 
3854         if (takerFee > 0) {
3855             proxy.transferTokens(
3856                 transaction.loanOffering.takerFeeToken,
3857                 msg.sender,
3858                 transaction.loanOffering.feeRecipient,
3859                 takerFee
3860             );
3861         }
3862     }
3863 
3864     function getLoanOfferingAddresses(
3865         Tx transaction
3866     )
3867         private
3868         pure
3869         returns (address[9])
3870     {
3871         return [
3872             transaction.loanOffering.owedToken,
3873             transaction.loanOffering.heldToken,
3874             transaction.loanOffering.payer,
3875             transaction.loanOffering.owner,
3876             transaction.loanOffering.taker,
3877             transaction.loanOffering.positionOwner,
3878             transaction.loanOffering.feeRecipient,
3879             transaction.loanOffering.lenderFeeToken,
3880             transaction.loanOffering.takerFeeToken
3881         ];
3882     }
3883 
3884     function getLoanOfferingValues256(
3885         Tx transaction
3886     )
3887         private
3888         pure
3889         returns (uint256[7])
3890     {
3891         return [
3892             transaction.loanOffering.rates.maxAmount,
3893             transaction.loanOffering.rates.minAmount,
3894             transaction.loanOffering.rates.minHeldToken,
3895             transaction.loanOffering.rates.lenderFee,
3896             transaction.loanOffering.rates.takerFee,
3897             transaction.loanOffering.expirationTimestamp,
3898             transaction.loanOffering.salt
3899         ];
3900     }
3901 
3902     function getLoanOfferingValues32(
3903         Tx transaction
3904     )
3905         private
3906         pure
3907         returns (uint32[4])
3908     {
3909         return [
3910             transaction.loanOffering.callTimeLimit,
3911             transaction.loanOffering.maxDuration,
3912             transaction.loanOffering.rates.interestRate,
3913             transaction.loanOffering.rates.interestPeriod
3914         ];
3915     }
3916 }
3917 
3918 // File: contracts/margin/interfaces/lender/IncreaseLoanDelegator.sol
3919 
3920 /**
3921  * @title IncreaseLoanDelegator
3922  * @author dYdX
3923  *
3924  * Interface that smart contracts must implement in order to own loans on behalf of other accounts.
3925  *
3926  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3927  *       to these functions
3928  */
3929 interface IncreaseLoanDelegator {
3930 
3931     // ============ Public Interface functions ============
3932 
3933     /**
3934      * Function a contract must implement in order to allow additional value to be added onto
3935      * an owned loan. Margin will call this on the owner of a loan during increasePosition().
3936      *
3937      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3938      * either revert the entire transaction or that the loan size was successfully increased.
3939      *
3940      * @param  payer           Lender adding additional funds to the position
3941      * @param  positionId      Unique ID of the position
3942      * @param  principalAdded  Principal amount to be added to the position
3943      * @param  lentAmount      Amount of owedToken lent by the lender (principal plus interest, or
3944      *                         zero if increaseWithoutCounterparty() is used).
3945      * @return                 This address to accept, a different address to ask that contract
3946      */
3947     function increaseLoanOnBehalfOf(
3948         address payer,
3949         bytes32 positionId,
3950         uint256 principalAdded,
3951         uint256 lentAmount
3952     )
3953         external
3954         /* onlyMargin */
3955         returns (address);
3956 }
3957 
3958 // File: contracts/margin/interfaces/owner/IncreasePositionDelegator.sol
3959 
3960 /**
3961  * @title IncreasePositionDelegator
3962  * @author dYdX
3963  *
3964  * Interface that smart contracts must implement in order to own position on behalf of other
3965  * accounts
3966  *
3967  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
3968  *       to these functions
3969  */
3970 interface IncreasePositionDelegator {
3971 
3972     // ============ Public Interface functions ============
3973 
3974     /**
3975      * Function a contract must implement in order to allow additional value to be added onto
3976      * an owned position. Margin will call this on the owner of a position during increasePosition()
3977      *
3978      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
3979      * either revert the entire transaction or that the position size was successfully increased.
3980      *
3981      * @param  trader          Address initiating the addition of funds to the position
3982      * @param  positionId      Unique ID of the position
3983      * @param  principalAdded  Amount of principal to be added to the position
3984      * @return                 This address to accept, a different address to ask that contract
3985      */
3986     function increasePositionOnBehalfOf(
3987         address trader,
3988         bytes32 positionId,
3989         uint256 principalAdded
3990     )
3991         external
3992         /* onlyMargin */
3993         returns (address);
3994 }
3995 
3996 // File: contracts/margin/impl/IncreasePositionImpl.sol
3997 
3998 /**
3999  * @title IncreasePositionImpl
4000  * @author dYdX
4001  *
4002  * This library contains the implementation for the increasePosition function of Margin
4003  */
4004 library IncreasePositionImpl {
4005     using SafeMath for uint256;
4006 
4007     // ============ Events ============
4008 
4009     /*
4010      * A position was increased
4011      */
4012     event PositionIncreased(
4013         bytes32 indexed positionId,
4014         address indexed trader,
4015         address indexed lender,
4016         address positionOwner,
4017         address loanOwner,
4018         bytes32 loanHash,
4019         address loanFeeRecipient,
4020         uint256 amountBorrowed,
4021         uint256 principalAdded,
4022         uint256 heldTokenFromSell,
4023         uint256 depositAmount,
4024         bool    depositInHeldToken
4025     );
4026 
4027     // ============ Public Implementation Functions ============
4028 
4029     function increasePositionImpl(
4030         MarginState.State storage state,
4031         bytes32 positionId,
4032         address[7] addresses,
4033         uint256[8] values256,
4034         uint32[2] values32,
4035         bool depositInHeldToken,
4036         bytes signature,
4037         bytes orderData
4038     )
4039         public
4040         returns (uint256)
4041     {
4042         // Also ensures that the position exists
4043         MarginCommon.Position storage position =
4044             MarginCommon.getPositionFromStorage(state, positionId);
4045 
4046         BorrowShared.Tx memory transaction = parseIncreasePositionTx(
4047             position,
4048             positionId,
4049             addresses,
4050             values256,
4051             values32,
4052             depositInHeldToken,
4053             signature
4054         );
4055 
4056         validateIncrease(state, transaction, position);
4057 
4058         doBorrowAndSell(state, transaction, orderData);
4059 
4060         updateState(
4061             position,
4062             transaction.positionId,
4063             transaction.principal,
4064             transaction.lenderAmount,
4065             transaction.loanOffering.payer
4066         );
4067 
4068         // LOG EVENT
4069         recordPositionIncreased(transaction, position);
4070 
4071         return transaction.lenderAmount;
4072     }
4073 
4074     function increaseWithoutCounterpartyImpl(
4075         MarginState.State storage state,
4076         bytes32 positionId,
4077         uint256 principalToAdd
4078     )
4079         public
4080         returns (uint256)
4081     {
4082         MarginCommon.Position storage position =
4083             MarginCommon.getPositionFromStorage(state, positionId);
4084 
4085         // Disallow adding 0 principal
4086         require(
4087             principalToAdd > 0,
4088             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot add 0 principal"
4089         );
4090 
4091         // Disallow additions after maximum duration
4092         require(
4093             block.timestamp < uint256(position.startTimestamp).add(position.maxDuration),
4094             "IncreasePositionImpl#increaseWithoutCounterpartyImpl: Cannot increase after maxDuration"
4095         );
4096 
4097         uint256 heldTokenAmount = getCollateralNeededForAddedPrincipal(
4098             state,
4099             position,
4100             positionId,
4101             principalToAdd
4102         );
4103 
4104         Vault(state.VAULT).transferToVault(
4105             positionId,
4106             position.heldToken,
4107             msg.sender,
4108             heldTokenAmount
4109         );
4110 
4111         updateState(
4112             position,
4113             positionId,
4114             principalToAdd,
4115             0, // lent amount
4116             msg.sender
4117         );
4118 
4119         emit PositionIncreased(
4120             positionId,
4121             msg.sender,
4122             msg.sender,
4123             position.owner,
4124             position.lender,
4125             "",
4126             address(0),
4127             0,
4128             principalToAdd,
4129             0,
4130             heldTokenAmount,
4131             true
4132         );
4133 
4134         return heldTokenAmount;
4135     }
4136 
4137     // ============ Private Helper-Functions ============
4138 
4139     function doBorrowAndSell(
4140         MarginState.State storage state,
4141         BorrowShared.Tx memory transaction,
4142         bytes orderData
4143     )
4144         private
4145     {
4146         // Calculate the number of heldTokens to add
4147         uint256 collateralToAdd = getCollateralNeededForAddedPrincipal(
4148             state,
4149             state.positions[transaction.positionId],
4150             transaction.positionId,
4151             transaction.principal
4152         );
4153 
4154         // Do pre-exchange validations
4155         BorrowShared.validateTxPreSell(state, transaction);
4156 
4157         // Calculate and deposit owedToken
4158         uint256 maxHeldTokenFromSell = MathHelpers.maxUint256();
4159         if (!transaction.depositInHeldToken) {
4160             transaction.depositAmount =
4161                 getOwedTokenDeposit(transaction, collateralToAdd, orderData);
4162             BorrowShared.doDepositOwedToken(state, transaction);
4163             maxHeldTokenFromSell = collateralToAdd;
4164         }
4165 
4166         // Sell owedToken for heldToken using the exchange wrapper
4167         transaction.heldTokenFromSell = BorrowShared.doSell(
4168             state,
4169             transaction,
4170             orderData,
4171             maxHeldTokenFromSell
4172         );
4173 
4174         // Calculate and deposit heldToken
4175         if (transaction.depositInHeldToken) {
4176             require(
4177                 transaction.heldTokenFromSell <= collateralToAdd,
4178                 "IncreasePositionImpl#doBorrowAndSell: DEX order gives too much heldToken"
4179             );
4180             transaction.depositAmount = collateralToAdd.sub(transaction.heldTokenFromSell);
4181             BorrowShared.doDepositHeldToken(state, transaction);
4182         }
4183 
4184         // Make sure the actual added collateral is what is expected
4185         assert(transaction.collateralAmount == collateralToAdd);
4186 
4187         // Do post-exchange validations
4188         BorrowShared.doPostSell(state, transaction);
4189     }
4190 
4191     function getOwedTokenDeposit(
4192         BorrowShared.Tx transaction,
4193         uint256 collateralToAdd,
4194         bytes orderData
4195     )
4196         private
4197         view
4198         returns (uint256)
4199     {
4200         uint256 totalOwedToken = ExchangeWrapper(transaction.exchangeWrapper).getExchangeCost(
4201             transaction.loanOffering.heldToken,
4202             transaction.loanOffering.owedToken,
4203             collateralToAdd,
4204             orderData
4205         );
4206 
4207         require(
4208             transaction.lenderAmount <= totalOwedToken,
4209             "IncreasePositionImpl#getOwedTokenDeposit: Lender amount is more than required"
4210         );
4211 
4212         return totalOwedToken.sub(transaction.lenderAmount);
4213     }
4214 
4215     function validateIncrease(
4216         MarginState.State storage state,
4217         BorrowShared.Tx transaction,
4218         MarginCommon.Position storage position
4219     )
4220         private
4221         view
4222     {
4223         assert(MarginCommon.containsPositionImpl(state, transaction.positionId));
4224 
4225         require(
4226             position.callTimeLimit <= transaction.loanOffering.callTimeLimit,
4227             "IncreasePositionImpl#validateIncrease: Loan callTimeLimit is less than the position"
4228         );
4229 
4230         // require the position to end no later than the loanOffering's maximum acceptable end time
4231         uint256 positionEndTimestamp = uint256(position.startTimestamp).add(position.maxDuration);
4232         uint256 offeringEndTimestamp = block.timestamp.add(transaction.loanOffering.maxDuration);
4233         require(
4234             positionEndTimestamp <= offeringEndTimestamp,
4235             "IncreasePositionImpl#validateIncrease: Loan end timestamp is less than the position"
4236         );
4237 
4238         require(
4239             block.timestamp < positionEndTimestamp,
4240             "IncreasePositionImpl#validateIncrease: Position has passed its maximum duration"
4241         );
4242     }
4243 
4244     function getCollateralNeededForAddedPrincipal(
4245         MarginState.State storage state,
4246         MarginCommon.Position storage position,
4247         bytes32 positionId,
4248         uint256 principalToAdd
4249     )
4250         private
4251         view
4252         returns (uint256)
4253     {
4254         uint256 heldTokenBalance = MarginCommon.getPositionBalanceImpl(state, positionId);
4255 
4256         return MathHelpers.getPartialAmountRoundedUp(
4257             principalToAdd,
4258             position.principal,
4259             heldTokenBalance
4260         );
4261     }
4262 
4263     function updateState(
4264         MarginCommon.Position storage position,
4265         bytes32 positionId,
4266         uint256 principalAdded,
4267         uint256 owedTokenLent,
4268         address loanPayer
4269     )
4270         private
4271     {
4272         position.principal = position.principal.add(principalAdded);
4273 
4274         address owner = position.owner;
4275         address lender = position.lender;
4276 
4277         // Ensure owner consent
4278         increasePositionOnBehalfOfRecurse(
4279             owner,
4280             msg.sender,
4281             positionId,
4282             principalAdded
4283         );
4284 
4285         // Ensure lender consent
4286         increaseLoanOnBehalfOfRecurse(
4287             lender,
4288             loanPayer,
4289             positionId,
4290             principalAdded,
4291             owedTokenLent
4292         );
4293     }
4294 
4295     function increasePositionOnBehalfOfRecurse(
4296         address contractAddr,
4297         address trader,
4298         bytes32 positionId,
4299         uint256 principalAdded
4300     )
4301         private
4302     {
4303         // Assume owner approval if not a smart contract and they increased their own position
4304         if (trader == contractAddr && !AddressUtils.isContract(contractAddr)) {
4305             return;
4306         }
4307 
4308         address newContractAddr =
4309             IncreasePositionDelegator(contractAddr).increasePositionOnBehalfOf(
4310                 trader,
4311                 positionId,
4312                 principalAdded
4313             );
4314 
4315         if (newContractAddr != contractAddr) {
4316             increasePositionOnBehalfOfRecurse(
4317                 newContractAddr,
4318                 trader,
4319                 positionId,
4320                 principalAdded
4321             );
4322         }
4323     }
4324 
4325     function increaseLoanOnBehalfOfRecurse(
4326         address contractAddr,
4327         address payer,
4328         bytes32 positionId,
4329         uint256 principalAdded,
4330         uint256 amountLent
4331     )
4332         private
4333     {
4334         // Assume lender approval if not a smart contract and they increased their own loan
4335         if (payer == contractAddr && !AddressUtils.isContract(contractAddr)) {
4336             return;
4337         }
4338 
4339         address newContractAddr =
4340             IncreaseLoanDelegator(contractAddr).increaseLoanOnBehalfOf(
4341                 payer,
4342                 positionId,
4343                 principalAdded,
4344                 amountLent
4345             );
4346 
4347         if (newContractAddr != contractAddr) {
4348             increaseLoanOnBehalfOfRecurse(
4349                 newContractAddr,
4350                 payer,
4351                 positionId,
4352                 principalAdded,
4353                 amountLent
4354             );
4355         }
4356     }
4357 
4358     function recordPositionIncreased(
4359         BorrowShared.Tx transaction,
4360         MarginCommon.Position storage position
4361     )
4362         private
4363     {
4364         emit PositionIncreased(
4365             transaction.positionId,
4366             msg.sender,
4367             transaction.loanOffering.payer,
4368             position.owner,
4369             position.lender,
4370             transaction.loanOffering.loanHash,
4371             transaction.loanOffering.feeRecipient,
4372             transaction.lenderAmount,
4373             transaction.principal,
4374             transaction.heldTokenFromSell,
4375             transaction.depositAmount,
4376             transaction.depositInHeldToken
4377         );
4378     }
4379 
4380     // ============ Parsing Functions ============
4381 
4382     function parseIncreasePositionTx(
4383         MarginCommon.Position storage position,
4384         bytes32 positionId,
4385         address[7] addresses,
4386         uint256[8] values256,
4387         uint32[2] values32,
4388         bool depositInHeldToken,
4389         bytes signature
4390     )
4391         private
4392         view
4393         returns (BorrowShared.Tx memory)
4394     {
4395         uint256 principal = values256[7];
4396 
4397         uint256 lenderAmount = MarginCommon.calculateLenderAmountForIncreasePosition(
4398             position,
4399             principal,
4400             block.timestamp
4401         );
4402         assert(lenderAmount >= principal);
4403 
4404         BorrowShared.Tx memory transaction = BorrowShared.Tx({
4405             positionId: positionId,
4406             owner: position.owner,
4407             principal: principal,
4408             lenderAmount: lenderAmount,
4409             loanOffering: parseLoanOfferingFromIncreasePositionTx(
4410                 position,
4411                 addresses,
4412                 values256,
4413                 values32,
4414                 signature
4415             ),
4416             exchangeWrapper: addresses[6],
4417             depositInHeldToken: depositInHeldToken,
4418             depositAmount: 0, // set later
4419             collateralAmount: 0, // set later
4420             heldTokenFromSell: 0 // set later
4421         });
4422 
4423         return transaction;
4424     }
4425 
4426     function parseLoanOfferingFromIncreasePositionTx(
4427         MarginCommon.Position storage position,
4428         address[7] addresses,
4429         uint256[8] values256,
4430         uint32[2] values32,
4431         bytes signature
4432     )
4433         private
4434         view
4435         returns (MarginCommon.LoanOffering memory)
4436     {
4437         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4438             owedToken: position.owedToken,
4439             heldToken: position.heldToken,
4440             payer: addresses[0],
4441             owner: position.lender,
4442             taker: addresses[1],
4443             positionOwner: addresses[2],
4444             feeRecipient: addresses[3],
4445             lenderFeeToken: addresses[4],
4446             takerFeeToken: addresses[5],
4447             rates: parseLoanOfferingRatesFromIncreasePositionTx(position, values256),
4448             expirationTimestamp: values256[5],
4449             callTimeLimit: values32[0],
4450             maxDuration: values32[1],
4451             salt: values256[6],
4452             loanHash: 0,
4453             signature: signature
4454         });
4455 
4456         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4457 
4458         return loanOffering;
4459     }
4460 
4461     function parseLoanOfferingRatesFromIncreasePositionTx(
4462         MarginCommon.Position storage position,
4463         uint256[8] values256
4464     )
4465         private
4466         view
4467         returns (MarginCommon.LoanRates memory)
4468     {
4469         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4470             maxAmount: values256[0],
4471             minAmount: values256[1],
4472             minHeldToken: values256[2],
4473             lenderFee: values256[3],
4474             takerFee: values256[4],
4475             interestRate: position.interestRate,
4476             interestPeriod: position.interestPeriod
4477         });
4478 
4479         return rates;
4480     }
4481 }
4482 
4483 // File: contracts/margin/impl/MarginStorage.sol
4484 
4485 /**
4486  * @title MarginStorage
4487  * @author dYdX
4488  *
4489  * This contract serves as the storage for the entire state of MarginStorage
4490  */
4491 contract MarginStorage {
4492 
4493     MarginState.State state;
4494 
4495 }
4496 
4497 // File: contracts/margin/impl/LoanGetters.sol
4498 
4499 /**
4500  * @title LoanGetters
4501  * @author dYdX
4502  *
4503  * A collection of public constant getter functions that allows reading of the state of any loan
4504  * offering stored in the dYdX protocol.
4505  */
4506 contract LoanGetters is MarginStorage {
4507 
4508     // ============ Public Constant Functions ============
4509 
4510     /**
4511      * Gets the principal amount of a loan offering that is no longer available.
4512      *
4513      * @param  loanHash  Unique hash of the loan offering
4514      * @return           The total unavailable amount of the loan offering, which is equal to the
4515      *                   filled amount plus the canceled amount.
4516      */
4517     function getLoanUnavailableAmount(
4518         bytes32 loanHash
4519     )
4520         external
4521         view
4522         returns (uint256)
4523     {
4524         return MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanHash);
4525     }
4526 
4527     /**
4528      * Gets the total amount of owed token lent for a loan.
4529      *
4530      * @param  loanHash  Unique hash of the loan offering
4531      * @return           The total filled amount of the loan offering.
4532      */
4533     function getLoanFilledAmount(
4534         bytes32 loanHash
4535     )
4536         external
4537         view
4538         returns (uint256)
4539     {
4540         return state.loanFills[loanHash];
4541     }
4542 
4543     /**
4544      * Gets the amount of a loan offering that has been canceled.
4545      *
4546      * @param  loanHash  Unique hash of the loan offering
4547      * @return           The total canceled amount of the loan offering.
4548      */
4549     function getLoanCanceledAmount(
4550         bytes32 loanHash
4551     )
4552         external
4553         view
4554         returns (uint256)
4555     {
4556         return state.loanCancels[loanHash];
4557     }
4558 }
4559 
4560 // File: contracts/margin/interfaces/lender/CancelMarginCallDelegator.sol
4561 
4562 /**
4563  * @title CancelMarginCallDelegator
4564  * @author dYdX
4565  *
4566  * Interface that smart contracts must implement in order to let other addresses cancel a
4567  * margin-call for a loan owned by the smart contract.
4568  *
4569  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4570  *       to these functions
4571  */
4572 interface CancelMarginCallDelegator {
4573 
4574     // ============ Public Interface functions ============
4575 
4576     /**
4577      * Function a contract must implement in order to let other addresses call cancelMarginCall().
4578      *
4579      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4580      * either revert the entire transaction or that the margin-call was successfully canceled.
4581      *
4582      * @param  canceler    Address of the caller of the cancelMarginCall function
4583      * @param  positionId  Unique ID of the position
4584      * @return             This address to accept, a different address to ask that contract
4585      */
4586     function cancelMarginCallOnBehalfOf(
4587         address canceler,
4588         bytes32 positionId
4589     )
4590         external
4591         /* onlyMargin */
4592         returns (address);
4593 }
4594 
4595 // File: contracts/margin/interfaces/lender/MarginCallDelegator.sol
4596 
4597 /**
4598  * @title MarginCallDelegator
4599  * @author dYdX
4600  *
4601  * Interface that smart contracts must implement in order to let other addresses margin-call a loan
4602  * owned by the smart contract.
4603  *
4604  * NOTE: Any contract implementing this interface should also use OnlyMargin to control access
4605  *       to these functions
4606  */
4607 interface MarginCallDelegator {
4608 
4609     // ============ Public Interface functions ============
4610 
4611     /**
4612      * Function a contract must implement in order to let other addresses call marginCall().
4613      *
4614      * NOTE: If not returning zero (or not reverting), this contract must assume that Margin will
4615      * either revert the entire transaction or that the loan was successfully margin-called.
4616      *
4617      * @param  caller         Address of the caller of the marginCall function
4618      * @param  positionId     Unique ID of the position
4619      * @param  depositAmount  Amount of heldToken deposit that will be required to cancel the call
4620      * @return                This address to accept, a different address to ask that contract
4621      */
4622     function marginCallOnBehalfOf(
4623         address caller,
4624         bytes32 positionId,
4625         uint256 depositAmount
4626     )
4627         external
4628         /* onlyMargin */
4629         returns (address);
4630 }
4631 
4632 // File: contracts/margin/impl/LoanImpl.sol
4633 
4634 /**
4635  * @title LoanImpl
4636  * @author dYdX
4637  *
4638  * This library contains the implementation for the following functions of Margin:
4639  *
4640  *      - marginCall
4641  *      - cancelMarginCallImpl
4642  *      - cancelLoanOffering
4643  */
4644 library LoanImpl {
4645     using SafeMath for uint256;
4646 
4647     // ============ Events ============
4648 
4649     /**
4650      * A position was margin-called
4651      */
4652     event MarginCallInitiated(
4653         bytes32 indexed positionId,
4654         address indexed lender,
4655         address indexed owner,
4656         uint256 requiredDeposit
4657     );
4658 
4659     /**
4660      * A margin call was canceled
4661      */
4662     event MarginCallCanceled(
4663         bytes32 indexed positionId,
4664         address indexed lender,
4665         address indexed owner,
4666         uint256 depositAmount
4667     );
4668 
4669     /**
4670      * A loan offering was canceled before it was used. Any amount less than the
4671      * total for the loan offering can be canceled.
4672      */
4673     event LoanOfferingCanceled(
4674         bytes32 indexed loanHash,
4675         address indexed payer,
4676         address indexed feeRecipient,
4677         uint256 cancelAmount
4678     );
4679 
4680     // ============ Public Implementation Functions ============
4681 
4682     function marginCallImpl(
4683         MarginState.State storage state,
4684         bytes32 positionId,
4685         uint256 requiredDeposit
4686     )
4687         public
4688     {
4689         MarginCommon.Position storage position =
4690             MarginCommon.getPositionFromStorage(state, positionId);
4691 
4692         require(
4693             position.callTimestamp == 0,
4694             "LoanImpl#marginCallImpl: The position has already been margin-called"
4695         );
4696 
4697         // Ensure lender consent
4698         marginCallOnBehalfOfRecurse(
4699             position.lender,
4700             msg.sender,
4701             positionId,
4702             requiredDeposit
4703         );
4704 
4705         position.callTimestamp = TimestampHelper.getBlockTimestamp32();
4706         position.requiredDeposit = requiredDeposit;
4707 
4708         emit MarginCallInitiated(
4709             positionId,
4710             position.lender,
4711             position.owner,
4712             requiredDeposit
4713         );
4714     }
4715 
4716     function cancelMarginCallImpl(
4717         MarginState.State storage state,
4718         bytes32 positionId
4719     )
4720         public
4721     {
4722         MarginCommon.Position storage position =
4723             MarginCommon.getPositionFromStorage(state, positionId);
4724 
4725         require(
4726             position.callTimestamp > 0,
4727             "LoanImpl#cancelMarginCallImpl: Position has not been margin-called"
4728         );
4729 
4730         // Ensure lender consent
4731         cancelMarginCallOnBehalfOfRecurse(
4732             position.lender,
4733             msg.sender,
4734             positionId
4735         );
4736 
4737         state.positions[positionId].callTimestamp = 0;
4738         state.positions[positionId].requiredDeposit = 0;
4739 
4740         emit MarginCallCanceled(
4741             positionId,
4742             position.lender,
4743             position.owner,
4744             0
4745         );
4746     }
4747 
4748     function cancelLoanOfferingImpl(
4749         MarginState.State storage state,
4750         address[9] addresses,
4751         uint256[7] values256,
4752         uint32[4]  values32,
4753         uint256    cancelAmount
4754     )
4755         public
4756         returns (uint256)
4757     {
4758         MarginCommon.LoanOffering memory loanOffering = parseLoanOffering(
4759             addresses,
4760             values256,
4761             values32
4762         );
4763 
4764         require(
4765             msg.sender == loanOffering.payer,
4766             "LoanImpl#cancelLoanOfferingImpl: Only loan offering payer can cancel"
4767         );
4768         require(
4769             loanOffering.expirationTimestamp > block.timestamp,
4770             "LoanImpl#cancelLoanOfferingImpl: Loan offering has already expired"
4771         );
4772 
4773         uint256 remainingAmount = loanOffering.rates.maxAmount.sub(
4774             MarginCommon.getUnavailableLoanOfferingAmountImpl(state, loanOffering.loanHash)
4775         );
4776         uint256 amountToCancel = Math.min256(remainingAmount, cancelAmount);
4777 
4778         // If the loan was already fully canceled, then just return 0 amount was canceled
4779         if (amountToCancel == 0) {
4780             return 0;
4781         }
4782 
4783         state.loanCancels[loanOffering.loanHash] =
4784             state.loanCancels[loanOffering.loanHash].add(amountToCancel);
4785 
4786         emit LoanOfferingCanceled(
4787             loanOffering.loanHash,
4788             loanOffering.payer,
4789             loanOffering.feeRecipient,
4790             amountToCancel
4791         );
4792 
4793         return amountToCancel;
4794     }
4795 
4796     // ============ Private Helper-Functions ============
4797 
4798     function marginCallOnBehalfOfRecurse(
4799         address contractAddr,
4800         address who,
4801         bytes32 positionId,
4802         uint256 requiredDeposit
4803     )
4804         private
4805     {
4806         // no need to ask for permission
4807         if (who == contractAddr) {
4808             return;
4809         }
4810 
4811         address newContractAddr =
4812             MarginCallDelegator(contractAddr).marginCallOnBehalfOf(
4813                 msg.sender,
4814                 positionId,
4815                 requiredDeposit
4816             );
4817 
4818         if (newContractAddr != contractAddr) {
4819             marginCallOnBehalfOfRecurse(
4820                 newContractAddr,
4821                 who,
4822                 positionId,
4823                 requiredDeposit
4824             );
4825         }
4826     }
4827 
4828     function cancelMarginCallOnBehalfOfRecurse(
4829         address contractAddr,
4830         address who,
4831         bytes32 positionId
4832     )
4833         private
4834     {
4835         // no need to ask for permission
4836         if (who == contractAddr) {
4837             return;
4838         }
4839 
4840         address newContractAddr =
4841             CancelMarginCallDelegator(contractAddr).cancelMarginCallOnBehalfOf(
4842                 msg.sender,
4843                 positionId
4844             );
4845 
4846         if (newContractAddr != contractAddr) {
4847             cancelMarginCallOnBehalfOfRecurse(
4848                 newContractAddr,
4849                 who,
4850                 positionId
4851             );
4852         }
4853     }
4854 
4855     // ============ Parsing Functions ============
4856 
4857     function parseLoanOffering(
4858         address[9] addresses,
4859         uint256[7] values256,
4860         uint32[4]  values32
4861     )
4862         private
4863         view
4864         returns (MarginCommon.LoanOffering memory)
4865     {
4866         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
4867             owedToken: addresses[0],
4868             heldToken: addresses[1],
4869             payer: addresses[2],
4870             owner: addresses[3],
4871             taker: addresses[4],
4872             positionOwner: addresses[5],
4873             feeRecipient: addresses[6],
4874             lenderFeeToken: addresses[7],
4875             takerFeeToken: addresses[8],
4876             rates: parseLoanOfferRates(values256, values32),
4877             expirationTimestamp: values256[5],
4878             callTimeLimit: values32[0],
4879             maxDuration: values32[1],
4880             salt: values256[6],
4881             loanHash: 0,
4882             signature: new bytes(0)
4883         });
4884 
4885         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
4886 
4887         return loanOffering;
4888     }
4889 
4890     function parseLoanOfferRates(
4891         uint256[7] values256,
4892         uint32[4] values32
4893     )
4894         private
4895         pure
4896         returns (MarginCommon.LoanRates memory)
4897     {
4898         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
4899             maxAmount: values256[0],
4900             minAmount: values256[1],
4901             minHeldToken: values256[2],
4902             interestRate: values32[2],
4903             lenderFee: values256[3],
4904             takerFee: values256[4],
4905             interestPeriod: values32[3]
4906         });
4907 
4908         return rates;
4909     }
4910 }
4911 
4912 // File: contracts/margin/impl/MarginAdmin.sol
4913 
4914 /**
4915  * @title MarginAdmin
4916  * @author dYdX
4917  *
4918  * Contains admin functions for the Margin contract
4919  * The owner can put Margin into various close-only modes, which will disallow new position creation
4920  */
4921 contract MarginAdmin is Ownable {
4922     // ============ Enums ============
4923 
4924     // All functionality enabled
4925     uint8 private constant OPERATION_STATE_OPERATIONAL = 0;
4926 
4927     // Only closing functions + cancelLoanOffering allowed (marginCall, closePosition,
4928     // cancelLoanOffering, closePositionDirectly, forceRecoverCollateral)
4929     uint8 private constant OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY = 1;
4930 
4931     // Only closing functions allowed (marginCall, closePosition, closePositionDirectly,
4932     // forceRecoverCollateral)
4933     uint8 private constant OPERATION_STATE_CLOSE_ONLY = 2;
4934 
4935     // Only closing functions allowed (marginCall, closePositionDirectly, forceRecoverCollateral)
4936     uint8 private constant OPERATION_STATE_CLOSE_DIRECTLY_ONLY = 3;
4937 
4938     // This operation state (and any higher) is invalid
4939     uint8 private constant OPERATION_STATE_INVALID = 4;
4940 
4941     // ============ Events ============
4942 
4943     /**
4944      * Event indicating the operation state has changed
4945      */
4946     event OperationStateChanged(
4947         uint8 from,
4948         uint8 to
4949     );
4950 
4951     // ============ State Variables ============
4952 
4953     uint8 public operationState;
4954 
4955     // ============ Constructor ============
4956 
4957     constructor()
4958         public
4959         Ownable()
4960     {
4961         operationState = OPERATION_STATE_OPERATIONAL;
4962     }
4963 
4964     // ============ Modifiers ============
4965 
4966     modifier onlyWhileOperational() {
4967         require(
4968             operationState == OPERATION_STATE_OPERATIONAL,
4969             "MarginAdmin#onlyWhileOperational: Can only call while operational"
4970         );
4971         _;
4972     }
4973 
4974     modifier cancelLoanOfferingStateControl() {
4975         require(
4976             operationState == OPERATION_STATE_OPERATIONAL
4977             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY,
4978             "MarginAdmin#cancelLoanOfferingStateControl: Invalid operation state"
4979         );
4980         _;
4981     }
4982 
4983     modifier closePositionStateControl() {
4984         require(
4985             operationState == OPERATION_STATE_OPERATIONAL
4986             || operationState == OPERATION_STATE_CLOSE_AND_CANCEL_LOAN_ONLY
4987             || operationState == OPERATION_STATE_CLOSE_ONLY,
4988             "MarginAdmin#closePositionStateControl: Invalid operation state"
4989         );
4990         _;
4991     }
4992 
4993     modifier closePositionDirectlyStateControl() {
4994         _;
4995     }
4996 
4997     // ============ Owner-Only State-Changing Functions ============
4998 
4999     function setOperationState(
5000         uint8 newState
5001     )
5002         external
5003         onlyOwner
5004     {
5005         require(
5006             newState < OPERATION_STATE_INVALID,
5007             "MarginAdmin#setOperationState: newState is not a valid operation state"
5008         );
5009 
5010         if (newState != operationState) {
5011             emit OperationStateChanged(
5012                 operationState,
5013                 newState
5014             );
5015             operationState = newState;
5016         }
5017     }
5018 }
5019 
5020 // File: contracts/margin/impl/MarginEvents.sol
5021 
5022 /**
5023  * @title MarginEvents
5024  * @author dYdX
5025  *
5026  * Contains events for the Margin contract.
5027  *
5028  * NOTE: Any Margin function libraries that use events will need to both define the event here
5029  *       and copy the event into the library itself as libraries don't support sharing events
5030  */
5031 contract MarginEvents {
5032     // ============ Events ============
5033 
5034     /**
5035      * A position was opened
5036      */
5037     event PositionOpened(
5038         bytes32 indexed positionId,
5039         address indexed trader,
5040         address indexed lender,
5041         bytes32 loanHash,
5042         address owedToken,
5043         address heldToken,
5044         address loanFeeRecipient,
5045         uint256 principal,
5046         uint256 heldTokenFromSell,
5047         uint256 depositAmount,
5048         uint256 interestRate,
5049         uint32  callTimeLimit,
5050         uint32  maxDuration,
5051         bool    depositInHeldToken
5052     );
5053 
5054     /*
5055      * A position was increased
5056      */
5057     event PositionIncreased(
5058         bytes32 indexed positionId,
5059         address indexed trader,
5060         address indexed lender,
5061         address positionOwner,
5062         address loanOwner,
5063         bytes32 loanHash,
5064         address loanFeeRecipient,
5065         uint256 amountBorrowed,
5066         uint256 principalAdded,
5067         uint256 heldTokenFromSell,
5068         uint256 depositAmount,
5069         bool    depositInHeldToken
5070     );
5071 
5072     /**
5073      * A position was closed or partially closed
5074      */
5075     event PositionClosed(
5076         bytes32 indexed positionId,
5077         address indexed closer,
5078         address indexed payoutRecipient,
5079         uint256 closeAmount,
5080         uint256 remainingAmount,
5081         uint256 owedTokenPaidToLender,
5082         uint256 payoutAmount,
5083         uint256 buybackCostInHeldToken,
5084         bool payoutInHeldToken
5085     );
5086 
5087     /**
5088      * Collateral for a position was forcibly recovered
5089      */
5090     event CollateralForceRecovered(
5091         bytes32 indexed positionId,
5092         address indexed recipient,
5093         uint256 amount
5094     );
5095 
5096     /**
5097      * A position was margin-called
5098      */
5099     event MarginCallInitiated(
5100         bytes32 indexed positionId,
5101         address indexed lender,
5102         address indexed owner,
5103         uint256 requiredDeposit
5104     );
5105 
5106     /**
5107      * A margin call was canceled
5108      */
5109     event MarginCallCanceled(
5110         bytes32 indexed positionId,
5111         address indexed lender,
5112         address indexed owner,
5113         uint256 depositAmount
5114     );
5115 
5116     /**
5117      * A loan offering was canceled before it was used. Any amount less than the
5118      * total for the loan offering can be canceled.
5119      */
5120     event LoanOfferingCanceled(
5121         bytes32 indexed loanHash,
5122         address indexed payer,
5123         address indexed feeRecipient,
5124         uint256 cancelAmount
5125     );
5126 
5127     /**
5128      * Additional collateral for a position was posted by the owner
5129      */
5130     event AdditionalCollateralDeposited(
5131         bytes32 indexed positionId,
5132         uint256 amount,
5133         address depositor
5134     );
5135 
5136     /**
5137      * Ownership of a loan was transferred to a new address
5138      */
5139     event LoanTransferred(
5140         bytes32 indexed positionId,
5141         address indexed from,
5142         address indexed to
5143     );
5144 
5145     /**
5146      * Ownership of a position was transferred to a new address
5147      */
5148     event PositionTransferred(
5149         bytes32 indexed positionId,
5150         address indexed from,
5151         address indexed to
5152     );
5153 }
5154 
5155 // File: contracts/margin/impl/OpenPositionImpl.sol
5156 
5157 /**
5158  * @title OpenPositionImpl
5159  * @author dYdX
5160  *
5161  * This library contains the implementation for the openPosition function of Margin
5162  */
5163 library OpenPositionImpl {
5164     using SafeMath for uint256;
5165 
5166     // ============ Events ============
5167 
5168     /**
5169      * A position was opened
5170      */
5171     event PositionOpened(
5172         bytes32 indexed positionId,
5173         address indexed trader,
5174         address indexed lender,
5175         bytes32 loanHash,
5176         address owedToken,
5177         address heldToken,
5178         address loanFeeRecipient,
5179         uint256 principal,
5180         uint256 heldTokenFromSell,
5181         uint256 depositAmount,
5182         uint256 interestRate,
5183         uint32  callTimeLimit,
5184         uint32  maxDuration,
5185         bool    depositInHeldToken
5186     );
5187 
5188     // ============ Public Implementation Functions ============
5189 
5190     function openPositionImpl(
5191         MarginState.State storage state,
5192         address[11] addresses,
5193         uint256[10] values256,
5194         uint32[4] values32,
5195         bool depositInHeldToken,
5196         bytes signature,
5197         bytes orderData
5198     )
5199         public
5200         returns (bytes32)
5201     {
5202         BorrowShared.Tx memory transaction = parseOpenTx(
5203             addresses,
5204             values256,
5205             values32,
5206             depositInHeldToken,
5207             signature
5208         );
5209 
5210         require(
5211             !MarginCommon.positionHasExisted(state, transaction.positionId),
5212             "OpenPositionImpl#openPositionImpl: positionId already exists"
5213         );
5214 
5215         doBorrowAndSell(state, transaction, orderData);
5216 
5217         // Before doStoreNewPosition() so that PositionOpened event is before Transferred events
5218         recordPositionOpened(
5219             transaction
5220         );
5221 
5222         doStoreNewPosition(
5223             state,
5224             transaction
5225         );
5226 
5227         return transaction.positionId;
5228     }
5229 
5230     // ============ Private Helper-Functions ============
5231 
5232     function doBorrowAndSell(
5233         MarginState.State storage state,
5234         BorrowShared.Tx memory transaction,
5235         bytes orderData
5236     )
5237         private
5238     {
5239         BorrowShared.validateTxPreSell(state, transaction);
5240 
5241         if (transaction.depositInHeldToken) {
5242             BorrowShared.doDepositHeldToken(state, transaction);
5243         } else {
5244             BorrowShared.doDepositOwedToken(state, transaction);
5245         }
5246 
5247         transaction.heldTokenFromSell = BorrowShared.doSell(
5248             state,
5249             transaction,
5250             orderData,
5251             MathHelpers.maxUint256()
5252         );
5253 
5254         BorrowShared.doPostSell(state, transaction);
5255     }
5256 
5257     function doStoreNewPosition(
5258         MarginState.State storage state,
5259         BorrowShared.Tx memory transaction
5260     )
5261         private
5262     {
5263         MarginCommon.storeNewPosition(
5264             state,
5265             transaction.positionId,
5266             MarginCommon.Position({
5267                 owedToken: transaction.loanOffering.owedToken,
5268                 heldToken: transaction.loanOffering.heldToken,
5269                 lender: transaction.loanOffering.owner,
5270                 owner: transaction.owner,
5271                 principal: transaction.principal,
5272                 requiredDeposit: 0,
5273                 callTimeLimit: transaction.loanOffering.callTimeLimit,
5274                 startTimestamp: 0,
5275                 callTimestamp: 0,
5276                 maxDuration: transaction.loanOffering.maxDuration,
5277                 interestRate: transaction.loanOffering.rates.interestRate,
5278                 interestPeriod: transaction.loanOffering.rates.interestPeriod
5279             }),
5280             transaction.loanOffering.payer
5281         );
5282     }
5283 
5284     function recordPositionOpened(
5285         BorrowShared.Tx transaction
5286     )
5287         private
5288     {
5289         emit PositionOpened(
5290             transaction.positionId,
5291             msg.sender,
5292             transaction.loanOffering.payer,
5293             transaction.loanOffering.loanHash,
5294             transaction.loanOffering.owedToken,
5295             transaction.loanOffering.heldToken,
5296             transaction.loanOffering.feeRecipient,
5297             transaction.principal,
5298             transaction.heldTokenFromSell,
5299             transaction.depositAmount,
5300             transaction.loanOffering.rates.interestRate,
5301             transaction.loanOffering.callTimeLimit,
5302             transaction.loanOffering.maxDuration,
5303             transaction.depositInHeldToken
5304         );
5305     }
5306 
5307     // ============ Parsing Functions ============
5308 
5309     function parseOpenTx(
5310         address[11] addresses,
5311         uint256[10] values256,
5312         uint32[4] values32,
5313         bool depositInHeldToken,
5314         bytes signature
5315     )
5316         private
5317         view
5318         returns (BorrowShared.Tx memory)
5319     {
5320         BorrowShared.Tx memory transaction = BorrowShared.Tx({
5321             positionId: MarginCommon.getPositionIdFromNonce(values256[9]),
5322             owner: addresses[0],
5323             principal: values256[7],
5324             lenderAmount: values256[7],
5325             loanOffering: parseLoanOffering(
5326                 addresses,
5327                 values256,
5328                 values32,
5329                 signature
5330             ),
5331             exchangeWrapper: addresses[10],
5332             depositInHeldToken: depositInHeldToken,
5333             depositAmount: values256[8],
5334             collateralAmount: 0, // set later
5335             heldTokenFromSell: 0 // set later
5336         });
5337 
5338         return transaction;
5339     }
5340 
5341     function parseLoanOffering(
5342         address[11] addresses,
5343         uint256[10] values256,
5344         uint32[4]   values32,
5345         bytes       signature
5346     )
5347         private
5348         view
5349         returns (MarginCommon.LoanOffering memory)
5350     {
5351         MarginCommon.LoanOffering memory loanOffering = MarginCommon.LoanOffering({
5352             owedToken: addresses[1],
5353             heldToken: addresses[2],
5354             payer: addresses[3],
5355             owner: addresses[4],
5356             taker: addresses[5],
5357             positionOwner: addresses[6],
5358             feeRecipient: addresses[7],
5359             lenderFeeToken: addresses[8],
5360             takerFeeToken: addresses[9],
5361             rates: parseLoanOfferRates(values256, values32),
5362             expirationTimestamp: values256[5],
5363             callTimeLimit: values32[0],
5364             maxDuration: values32[1],
5365             salt: values256[6],
5366             loanHash: 0,
5367             signature: signature
5368         });
5369 
5370         loanOffering.loanHash = MarginCommon.getLoanOfferingHash(loanOffering);
5371 
5372         return loanOffering;
5373     }
5374 
5375     function parseLoanOfferRates(
5376         uint256[10] values256,
5377         uint32[4] values32
5378     )
5379         private
5380         pure
5381         returns (MarginCommon.LoanRates memory)
5382     {
5383         MarginCommon.LoanRates memory rates = MarginCommon.LoanRates({
5384             maxAmount: values256[0],
5385             minAmount: values256[1],
5386             minHeldToken: values256[2],
5387             lenderFee: values256[3],
5388             takerFee: values256[4],
5389             interestRate: values32[2],
5390             interestPeriod: values32[3]
5391         });
5392 
5393         return rates;
5394     }
5395 }
5396 
5397 // File: contracts/margin/impl/OpenWithoutCounterpartyImpl.sol
5398 
5399 /**
5400  * @title OpenWithoutCounterpartyImpl
5401  * @author dYdX
5402  *
5403  * This library contains the implementation for the openWithoutCounterparty
5404  * function of Margin
5405  */
5406 library OpenWithoutCounterpartyImpl {
5407 
5408     // ============ Structs ============
5409 
5410     struct Tx {
5411         bytes32 positionId;
5412         address positionOwner;
5413         address owedToken;
5414         address heldToken;
5415         address loanOwner;
5416         uint256 principal;
5417         uint256 deposit;
5418         uint32 callTimeLimit;
5419         uint32 maxDuration;
5420         uint32 interestRate;
5421         uint32 interestPeriod;
5422     }
5423 
5424     // ============ Events ============
5425 
5426     /**
5427      * A position was opened
5428      */
5429     event PositionOpened(
5430         bytes32 indexed positionId,
5431         address indexed trader,
5432         address indexed lender,
5433         bytes32 loanHash,
5434         address owedToken,
5435         address heldToken,
5436         address loanFeeRecipient,
5437         uint256 principal,
5438         uint256 heldTokenFromSell,
5439         uint256 depositAmount,
5440         uint256 interestRate,
5441         uint32  callTimeLimit,
5442         uint32  maxDuration,
5443         bool    depositInHeldToken
5444     );
5445 
5446     // ============ Public Implementation Functions ============
5447 
5448     function openWithoutCounterpartyImpl(
5449         MarginState.State storage state,
5450         address[4] addresses,
5451         uint256[3] values256,
5452         uint32[4]  values32
5453     )
5454         public
5455         returns (bytes32)
5456     {
5457         Tx memory openTx = parseTx(
5458             addresses,
5459             values256,
5460             values32
5461         );
5462 
5463         validate(
5464             state,
5465             openTx
5466         );
5467 
5468         Vault(state.VAULT).transferToVault(
5469             openTx.positionId,
5470             openTx.heldToken,
5471             msg.sender,
5472             openTx.deposit
5473         );
5474 
5475         recordPositionOpened(
5476             openTx
5477         );
5478 
5479         doStoreNewPosition(
5480             state,
5481             openTx
5482         );
5483 
5484         return openTx.positionId;
5485     }
5486 
5487     // ============ Private Helper-Functions ============
5488 
5489     function doStoreNewPosition(
5490         MarginState.State storage state,
5491         Tx memory openTx
5492     )
5493         private
5494     {
5495         MarginCommon.storeNewPosition(
5496             state,
5497             openTx.positionId,
5498             MarginCommon.Position({
5499                 owedToken: openTx.owedToken,
5500                 heldToken: openTx.heldToken,
5501                 lender: openTx.loanOwner,
5502                 owner: openTx.positionOwner,
5503                 principal: openTx.principal,
5504                 requiredDeposit: 0,
5505                 callTimeLimit: openTx.callTimeLimit,
5506                 startTimestamp: 0,
5507                 callTimestamp: 0,
5508                 maxDuration: openTx.maxDuration,
5509                 interestRate: openTx.interestRate,
5510                 interestPeriod: openTx.interestPeriod
5511             }),
5512             msg.sender
5513         );
5514     }
5515 
5516     function validate(
5517         MarginState.State storage state,
5518         Tx memory openTx
5519     )
5520         private
5521         view
5522     {
5523         require(
5524             !MarginCommon.positionHasExisted(state, openTx.positionId),
5525             "openWithoutCounterpartyImpl#validate: positionId already exists"
5526         );
5527 
5528         require(
5529             openTx.principal > 0,
5530             "openWithoutCounterpartyImpl#validate: principal cannot be 0"
5531         );
5532 
5533         require(
5534             openTx.owedToken != address(0),
5535             "openWithoutCounterpartyImpl#validate: owedToken cannot be 0"
5536         );
5537 
5538         require(
5539             openTx.owedToken != openTx.heldToken,
5540             "openWithoutCounterpartyImpl#validate: owedToken cannot be equal to heldToken"
5541         );
5542 
5543         require(
5544             openTx.positionOwner != address(0),
5545             "openWithoutCounterpartyImpl#validate: positionOwner cannot be 0"
5546         );
5547 
5548         require(
5549             openTx.loanOwner != address(0),
5550             "openWithoutCounterpartyImpl#validate: loanOwner cannot be 0"
5551         );
5552 
5553         require(
5554             openTx.maxDuration > 0,
5555             "openWithoutCounterpartyImpl#validate: maxDuration cannot be 0"
5556         );
5557 
5558         require(
5559             openTx.interestPeriod <= openTx.maxDuration,
5560             "openWithoutCounterpartyImpl#validate: interestPeriod must be <= maxDuration"
5561         );
5562     }
5563 
5564     function recordPositionOpened(
5565         Tx memory openTx
5566     )
5567         private
5568     {
5569         emit PositionOpened(
5570             openTx.positionId,
5571             msg.sender,
5572             msg.sender,
5573             bytes32(0),
5574             openTx.owedToken,
5575             openTx.heldToken,
5576             address(0),
5577             openTx.principal,
5578             0,
5579             openTx.deposit,
5580             openTx.interestRate,
5581             openTx.callTimeLimit,
5582             openTx.maxDuration,
5583             true
5584         );
5585     }
5586 
5587     // ============ Parsing Functions ============
5588 
5589     function parseTx(
5590         address[4] addresses,
5591         uint256[3] values256,
5592         uint32[4]  values32
5593     )
5594         private
5595         view
5596         returns (Tx memory)
5597     {
5598         Tx memory openTx = Tx({
5599             positionId: MarginCommon.getPositionIdFromNonce(values256[2]),
5600             positionOwner: addresses[0],
5601             owedToken: addresses[1],
5602             heldToken: addresses[2],
5603             loanOwner: addresses[3],
5604             principal: values256[0],
5605             deposit: values256[1],
5606             callTimeLimit: values32[0],
5607             maxDuration: values32[1],
5608             interestRate: values32[2],
5609             interestPeriod: values32[3]
5610         });
5611 
5612         return openTx;
5613     }
5614 }
5615 
5616 // File: contracts/margin/impl/PositionGetters.sol
5617 
5618 /**
5619  * @title PositionGetters
5620  * @author dYdX
5621  *
5622  * A collection of public constant getter functions that allows reading of the state of any position
5623  * stored in the dYdX protocol.
5624  */
5625 contract PositionGetters is MarginStorage {
5626     using SafeMath for uint256;
5627 
5628     // ============ Public Constant Functions ============
5629 
5630     /**
5631      * Gets if a position is currently open.
5632      *
5633      * @param  positionId  Unique ID of the position
5634      * @return             True if the position is exists and is open
5635      */
5636     function containsPosition(
5637         bytes32 positionId
5638     )
5639         external
5640         view
5641         returns (bool)
5642     {
5643         return MarginCommon.containsPositionImpl(state, positionId);
5644     }
5645 
5646     /**
5647      * Gets if a position is currently margin-called.
5648      *
5649      * @param  positionId  Unique ID of the position
5650      * @return             True if the position is margin-called
5651      */
5652     function isPositionCalled(
5653         bytes32 positionId
5654     )
5655         external
5656         view
5657         returns (bool)
5658     {
5659         return (state.positions[positionId].callTimestamp > 0);
5660     }
5661 
5662     /**
5663      * Gets if a position was previously open and is now closed.
5664      *
5665      * @param  positionId  Unique ID of the position
5666      * @return             True if the position is now closed
5667      */
5668     function isPositionClosed(
5669         bytes32 positionId
5670     )
5671         external
5672         view
5673         returns (bool)
5674     {
5675         return state.closedPositions[positionId];
5676     }
5677 
5678     /**
5679      * Gets the total amount of owedToken ever repaid to the lender for a position.
5680      *
5681      * @param  positionId  Unique ID of the position
5682      * @return             Total amount of owedToken ever repaid
5683      */
5684     function getTotalOwedTokenRepaidToLender(
5685         bytes32 positionId
5686     )
5687         external
5688         view
5689         returns (uint256)
5690     {
5691         return state.totalOwedTokenRepaidToLender[positionId];
5692     }
5693 
5694     /**
5695      * Gets the amount of heldToken currently locked up in Vault for a particular position.
5696      *
5697      * @param  positionId  Unique ID of the position
5698      * @return             The amount of heldToken
5699      */
5700     function getPositionBalance(
5701         bytes32 positionId
5702     )
5703         external
5704         view
5705         returns (uint256)
5706     {
5707         return MarginCommon.getPositionBalanceImpl(state, positionId);
5708     }
5709 
5710     /**
5711      * Gets the time until the interest fee charged for the position will increase.
5712      * Returns 1 if the interest fee increases every second.
5713      * Returns 0 if the interest fee will never increase again.
5714      *
5715      * @param  positionId  Unique ID of the position
5716      * @return             The number of seconds until the interest fee will increase
5717      */
5718     function getTimeUntilInterestIncrease(
5719         bytes32 positionId
5720     )
5721         external
5722         view
5723         returns (uint256)
5724     {
5725         MarginCommon.Position storage position =
5726             MarginCommon.getPositionFromStorage(state, positionId);
5727 
5728         uint256 effectiveTimeElapsed = MarginCommon.calculateEffectiveTimeElapsed(
5729             position,
5730             block.timestamp
5731         );
5732 
5733         uint256 absoluteTimeElapsed = block.timestamp.sub(position.startTimestamp);
5734         if (absoluteTimeElapsed > effectiveTimeElapsed) { // past maxDuration
5735             return 0;
5736         } else {
5737             // nextStep is the final second at which the calculated interest fee is the same as it
5738             // is currently, so add 1 to get the correct value
5739             return effectiveTimeElapsed.add(1).sub(absoluteTimeElapsed);
5740         }
5741     }
5742 
5743     /**
5744      * Gets the amount of owedTokens currently needed to close the position completely, including
5745      * interest fees.
5746      *
5747      * @param  positionId  Unique ID of the position
5748      * @return             The number of owedTokens
5749      */
5750     function getPositionOwedAmount(
5751         bytes32 positionId
5752     )
5753         external
5754         view
5755         returns (uint256)
5756     {
5757         MarginCommon.Position storage position =
5758             MarginCommon.getPositionFromStorage(state, positionId);
5759 
5760         return MarginCommon.calculateOwedAmount(
5761             position,
5762             position.principal,
5763             block.timestamp
5764         );
5765     }
5766 
5767     /**
5768      * Gets the amount of owedTokens needed to close a given principal amount of the position at a
5769      * given time, including interest fees.
5770      *
5771      * @param  positionId         Unique ID of the position
5772      * @param  principalToClose   Amount of principal being closed
5773      * @param  timestamp          Block timestamp in seconds of close
5774      * @return                    The number of owedTokens owed
5775      */
5776     function getPositionOwedAmountAtTime(
5777         bytes32 positionId,
5778         uint256 principalToClose,
5779         uint32  timestamp
5780     )
5781         external
5782         view
5783         returns (uint256)
5784     {
5785         MarginCommon.Position storage position =
5786             MarginCommon.getPositionFromStorage(state, positionId);
5787 
5788         require(
5789             timestamp >= position.startTimestamp,
5790             "PositionGetters#getPositionOwedAmountAtTime: Requested time before position started"
5791         );
5792 
5793         return MarginCommon.calculateOwedAmount(
5794             position,
5795             principalToClose,
5796             timestamp
5797         );
5798     }
5799 
5800     /**
5801      * Gets the amount of owedTokens that can be borrowed from a lender to add a given principal
5802      * amount to the position at a given time.
5803      *
5804      * @param  positionId      Unique ID of the position
5805      * @param  principalToAdd  Amount being added to principal
5806      * @param  timestamp       Block timestamp in seconds of addition
5807      * @return                 The number of owedTokens that will be borrowed
5808      */
5809     function getLenderAmountForIncreasePositionAtTime(
5810         bytes32 positionId,
5811         uint256 principalToAdd,
5812         uint32  timestamp
5813     )
5814         external
5815         view
5816         returns (uint256)
5817     {
5818         MarginCommon.Position storage position =
5819             MarginCommon.getPositionFromStorage(state, positionId);
5820 
5821         require(
5822             timestamp >= position.startTimestamp,
5823             "PositionGetters#getLenderAmountForIncreasePositionAtTime: timestamp < position start"
5824         );
5825 
5826         return MarginCommon.calculateLenderAmountForIncreasePosition(
5827             position,
5828             principalToAdd,
5829             timestamp
5830         );
5831     }
5832 
5833     // ============ All Properties ============
5834 
5835     /**
5836      * Get a Position by id. This does not validate the position exists. If the position does not
5837      * exist, all 0's will be returned.
5838      *
5839      * @param  positionId  Unique ID of the position
5840      * @return             Addresses corresponding to:
5841      *
5842      *                     [0] = owedToken
5843      *                     [1] = heldToken
5844      *                     [2] = lender
5845      *                     [3] = owner
5846      *
5847      *                     Values corresponding to:
5848      *
5849      *                     [0] = principal
5850      *                     [1] = requiredDeposit
5851      *
5852      *                     Values corresponding to:
5853      *
5854      *                     [0] = callTimeLimit
5855      *                     [1] = startTimestamp
5856      *                     [2] = callTimestamp
5857      *                     [3] = maxDuration
5858      *                     [4] = interestRate
5859      *                     [5] = interestPeriod
5860      */
5861     function getPosition(
5862         bytes32 positionId
5863     )
5864         external
5865         view
5866         returns (
5867             address[4],
5868             uint256[2],
5869             uint32[6]
5870         )
5871     {
5872         MarginCommon.Position storage position = state.positions[positionId];
5873 
5874         return (
5875             [
5876                 position.owedToken,
5877                 position.heldToken,
5878                 position.lender,
5879                 position.owner
5880             ],
5881             [
5882                 position.principal,
5883                 position.requiredDeposit
5884             ],
5885             [
5886                 position.callTimeLimit,
5887                 position.startTimestamp,
5888                 position.callTimestamp,
5889                 position.maxDuration,
5890                 position.interestRate,
5891                 position.interestPeriod
5892             ]
5893         );
5894     }
5895 
5896     // ============ Individual Properties ============
5897 
5898     function getPositionLender(
5899         bytes32 positionId
5900     )
5901         external
5902         view
5903         returns (address)
5904     {
5905         return state.positions[positionId].lender;
5906     }
5907 
5908     function getPositionOwner(
5909         bytes32 positionId
5910     )
5911         external
5912         view
5913         returns (address)
5914     {
5915         return state.positions[positionId].owner;
5916     }
5917 
5918     function getPositionHeldToken(
5919         bytes32 positionId
5920     )
5921         external
5922         view
5923         returns (address)
5924     {
5925         return state.positions[positionId].heldToken;
5926     }
5927 
5928     function getPositionOwedToken(
5929         bytes32 positionId
5930     )
5931         external
5932         view
5933         returns (address)
5934     {
5935         return state.positions[positionId].owedToken;
5936     }
5937 
5938     function getPositionPrincipal(
5939         bytes32 positionId
5940     )
5941         external
5942         view
5943         returns (uint256)
5944     {
5945         return state.positions[positionId].principal;
5946     }
5947 
5948     function getPositionInterestRate(
5949         bytes32 positionId
5950     )
5951         external
5952         view
5953         returns (uint256)
5954     {
5955         return state.positions[positionId].interestRate;
5956     }
5957 
5958     function getPositionRequiredDeposit(
5959         bytes32 positionId
5960     )
5961         external
5962         view
5963         returns (uint256)
5964     {
5965         return state.positions[positionId].requiredDeposit;
5966     }
5967 
5968     function getPositionStartTimestamp(
5969         bytes32 positionId
5970     )
5971         external
5972         view
5973         returns (uint32)
5974     {
5975         return state.positions[positionId].startTimestamp;
5976     }
5977 
5978     function getPositionCallTimestamp(
5979         bytes32 positionId
5980     )
5981         external
5982         view
5983         returns (uint32)
5984     {
5985         return state.positions[positionId].callTimestamp;
5986     }
5987 
5988     function getPositionCallTimeLimit(
5989         bytes32 positionId
5990     )
5991         external
5992         view
5993         returns (uint32)
5994     {
5995         return state.positions[positionId].callTimeLimit;
5996     }
5997 
5998     function getPositionMaxDuration(
5999         bytes32 positionId
6000     )
6001         external
6002         view
6003         returns (uint32)
6004     {
6005         return state.positions[positionId].maxDuration;
6006     }
6007 
6008     function getPositioninterestPeriod(
6009         bytes32 positionId
6010     )
6011         external
6012         view
6013         returns (uint32)
6014     {
6015         return state.positions[positionId].interestPeriod;
6016     }
6017 }
6018 
6019 // File: contracts/margin/impl/TransferImpl.sol
6020 
6021 /**
6022  * @title TransferImpl
6023  * @author dYdX
6024  *
6025  * This library contains the implementation for the transferPosition and transferLoan functions of
6026  * Margin
6027  */
6028 library TransferImpl {
6029 
6030     // ============ Public Implementation Functions ============
6031 
6032     function transferLoanImpl(
6033         MarginState.State storage state,
6034         bytes32 positionId,
6035         address newLender
6036     )
6037         public
6038     {
6039         require(
6040             MarginCommon.containsPositionImpl(state, positionId),
6041             "TransferImpl#transferLoanImpl: Position does not exist"
6042         );
6043 
6044         address originalLender = state.positions[positionId].lender;
6045 
6046         require(
6047             msg.sender == originalLender,
6048             "TransferImpl#transferLoanImpl: Only lender can transfer ownership"
6049         );
6050         require(
6051             newLender != originalLender,
6052             "TransferImpl#transferLoanImpl: Cannot transfer ownership to self"
6053         );
6054 
6055         // Doesn't change the state of positionId; figures out the final owner of loan.
6056         // That is, newLender may pass ownership to a different address.
6057         address finalLender = TransferInternal.grantLoanOwnership(
6058             positionId,
6059             originalLender,
6060             newLender);
6061 
6062         require(
6063             finalLender != originalLender,
6064             "TransferImpl#transferLoanImpl: Cannot ultimately transfer ownership to self"
6065         );
6066 
6067         // Set state only after resolving the new owner (to reduce the number of storage calls)
6068         state.positions[positionId].lender = finalLender;
6069     }
6070 
6071     function transferPositionImpl(
6072         MarginState.State storage state,
6073         bytes32 positionId,
6074         address newOwner
6075     )
6076         public
6077     {
6078         require(
6079             MarginCommon.containsPositionImpl(state, positionId),
6080             "TransferImpl#transferPositionImpl: Position does not exist"
6081         );
6082 
6083         address originalOwner = state.positions[positionId].owner;
6084 
6085         require(
6086             msg.sender == originalOwner,
6087             "TransferImpl#transferPositionImpl: Only position owner can transfer ownership"
6088         );
6089         require(
6090             newOwner != originalOwner,
6091             "TransferImpl#transferPositionImpl: Cannot transfer ownership to self"
6092         );
6093 
6094         // Doesn't change the state of positionId; figures out the final owner of position.
6095         // That is, newOwner may pass ownership to a different address.
6096         address finalOwner = TransferInternal.grantPositionOwnership(
6097             positionId,
6098             originalOwner,
6099             newOwner);
6100 
6101         require(
6102             finalOwner != originalOwner,
6103             "TransferImpl#transferPositionImpl: Cannot ultimately transfer ownership to self"
6104         );
6105 
6106         // Set state only after resolving the new owner (to reduce the number of storage calls)
6107         state.positions[positionId].owner = finalOwner;
6108     }
6109 }
6110 
6111 // File: contracts/margin/Margin.sol
6112 
6113 /**
6114  * @title Margin
6115  * @author dYdX
6116  *
6117  * This contract is used to facilitate margin trading as per the dYdX protocol
6118  */
6119 contract Margin is
6120     ReentrancyGuard,
6121     MarginStorage,
6122     MarginEvents,
6123     MarginAdmin,
6124     LoanGetters,
6125     PositionGetters
6126 {
6127 
6128     using SafeMath for uint256;
6129 
6130     // ============ Constructor ============
6131 
6132     constructor(
6133         address vault,
6134         address proxy
6135     )
6136         public
6137         MarginAdmin()
6138     {
6139         state = MarginState.State({
6140             VAULT: vault,
6141             TOKEN_PROXY: proxy
6142         });
6143     }
6144 
6145     // ============ Public State Changing Functions ============
6146 
6147     /**
6148      * Open a margin position. Called by the margin trader who must provide both a
6149      * signed loan offering as well as a DEX Order with which to sell the owedToken.
6150      *
6151      * @param  addresses           Addresses corresponding to:
6152      *
6153      *  [0]  = position owner
6154      *  [1]  = owedToken
6155      *  [2]  = heldToken
6156      *  [3]  = loan payer
6157      *  [4]  = loan owner
6158      *  [5]  = loan taker
6159      *  [6]  = loan position owner
6160      *  [7]  = loan fee recipient
6161      *  [8]  = loan lender fee token
6162      *  [9]  = loan taker fee token
6163      *  [10]  = exchange wrapper address
6164      *
6165      * @param  values256           Values corresponding to:
6166      *
6167      *  [0]  = loan maximum amount
6168      *  [1]  = loan minimum amount
6169      *  [2]  = loan minimum heldToken
6170      *  [3]  = loan lender fee
6171      *  [4]  = loan taker fee
6172      *  [5]  = loan expiration timestamp (in seconds)
6173      *  [6]  = loan salt
6174      *  [7]  = position amount of principal
6175      *  [8]  = deposit amount
6176      *  [9]  = nonce (used to calculate positionId)
6177      *
6178      * @param  values32            Values corresponding to:
6179      *
6180      *  [0] = loan call time limit (in seconds)
6181      *  [1] = loan maxDuration (in seconds)
6182      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6183      *  [3] = loan interest update period (in seconds)
6184      *
6185      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6186      *                             False if the margin deposit will be in owedToken
6187      *                             and then sold along with the owedToken borrowed from the lender
6188      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6189      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6190      *                             is a smart contract, these are arbitrary bytes that the contract
6191      *                             will recieve when choosing whether to approve the loan.
6192      * @param  order               Order object to be passed to the exchange wrapper
6193      * @return                     Unique ID for the new position
6194      */
6195     function openPosition(
6196         address[11] addresses,
6197         uint256[10] values256,
6198         uint32[4]   values32,
6199         bool        depositInHeldToken,
6200         bytes       signature,
6201         bytes       order
6202     )
6203         external
6204         onlyWhileOperational
6205         nonReentrant
6206         returns (bytes32)
6207     {
6208         return OpenPositionImpl.openPositionImpl(
6209             state,
6210             addresses,
6211             values256,
6212             values32,
6213             depositInHeldToken,
6214             signature,
6215             order
6216         );
6217     }
6218 
6219     /**
6220      * Open a margin position without a counterparty. The caller will serve as both the
6221      * lender and the position owner
6222      *
6223      * @param  addresses    Addresses corresponding to:
6224      *
6225      *  [0]  = position owner
6226      *  [1]  = owedToken
6227      *  [2]  = heldToken
6228      *  [3]  = loan owner
6229      *
6230      * @param  values256    Values corresponding to:
6231      *
6232      *  [0]  = principal
6233      *  [1]  = deposit amount
6234      *  [2]  = nonce (used to calculate positionId)
6235      *
6236      * @param  values32     Values corresponding to:
6237      *
6238      *  [0] = call time limit (in seconds)
6239      *  [1] = maxDuration (in seconds)
6240      *  [2] = interest rate (annual nominal percentage times 10**6)
6241      *  [3] = interest update period (in seconds)
6242      *
6243      * @return              Unique ID for the new position
6244      */
6245     function openWithoutCounterparty(
6246         address[4] addresses,
6247         uint256[3] values256,
6248         uint32[4]  values32
6249     )
6250         external
6251         onlyWhileOperational
6252         nonReentrant
6253         returns (bytes32)
6254     {
6255         return OpenWithoutCounterpartyImpl.openWithoutCounterpartyImpl(
6256             state,
6257             addresses,
6258             values256,
6259             values32
6260         );
6261     }
6262 
6263     /**
6264      * Increase the size of a position. Funds will be borrowed from the loan payer and sold as per
6265      * the position. The amount of owedToken borrowed from the lender will be >= the amount of
6266      * principal added, as it will incorporate interest already earned by the position so far.
6267      *
6268      * @param  positionId          Unique ID of the position
6269      * @param  addresses           Addresses corresponding to:
6270      *
6271      *  [0]  = loan payer
6272      *  [1]  = loan taker
6273      *  [2]  = loan position owner
6274      *  [3]  = loan fee recipient
6275      *  [4]  = loan lender fee token
6276      *  [5]  = loan taker fee token
6277      *  [6]  = exchange wrapper address
6278      *
6279      * @param  values256           Values corresponding to:
6280      *
6281      *  [0]  = loan maximum amount
6282      *  [1]  = loan minimum amount
6283      *  [2]  = loan minimum heldToken
6284      *  [3]  = loan lender fee
6285      *  [4]  = loan taker fee
6286      *  [5]  = loan expiration timestamp (in seconds)
6287      *  [6]  = loan salt
6288      *  [7]  = amount of principal to add to the position (NOTE: the amount pulled from the lender
6289      *                                                           will be >= this amount)
6290      *
6291      * @param  values32            Values corresponding to:
6292      *
6293      *  [0] = loan call time limit (in seconds)
6294      *  [1] = loan maxDuration (in seconds)
6295      *
6296      * @param  depositInHeldToken  True if the trader wishes to pay the margin deposit in heldToken.
6297      *                             False if the margin deposit will be pulled in owedToken
6298      *                             and then sold along with the owedToken borrowed from the lender
6299      * @param  signature           If loan payer is an account, then this must be the tightly-packed
6300      *                             ECDSA V/R/S parameters from signing the loan hash. If loan payer
6301      *                             is a smart contract, these are arbitrary bytes that the contract
6302      *                             will recieve when choosing whether to approve the loan.
6303      * @param  order               Order object to be passed to the exchange wrapper
6304      * @return                     Amount of owedTokens pulled from the lender
6305      */
6306     function increasePosition(
6307         bytes32    positionId,
6308         address[7] addresses,
6309         uint256[8] values256,
6310         uint32[2]  values32,
6311         bool       depositInHeldToken,
6312         bytes      signature,
6313         bytes      order
6314     )
6315         external
6316         onlyWhileOperational
6317         nonReentrant
6318         returns (uint256)
6319     {
6320         return IncreasePositionImpl.increasePositionImpl(
6321             state,
6322             positionId,
6323             addresses,
6324             values256,
6325             values32,
6326             depositInHeldToken,
6327             signature,
6328             order
6329         );
6330     }
6331 
6332     /**
6333      * Increase a position directly by putting up heldToken. The caller will serve as both the
6334      * lender and the position owner
6335      *
6336      * @param  positionId      Unique ID of the position
6337      * @param  principalToAdd  Principal amount to add to the position
6338      * @return                 Amount of heldToken pulled from the msg.sender
6339      */
6340     function increaseWithoutCounterparty(
6341         bytes32 positionId,
6342         uint256 principalToAdd
6343     )
6344         external
6345         onlyWhileOperational
6346         nonReentrant
6347         returns (uint256)
6348     {
6349         return IncreasePositionImpl.increaseWithoutCounterpartyImpl(
6350             state,
6351             positionId,
6352             principalToAdd
6353         );
6354     }
6355 
6356     /**
6357      * Close a position. May be called by the owner or with the approval of the owner. May provide
6358      * an order and exchangeWrapper to facilitate the closing of the position. The payoutRecipient
6359      * is sent the resulting payout.
6360      *
6361      * @param  positionId            Unique ID of the position
6362      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6363      *                               closed is also bounded by:
6364      *                               1) The principal of the position
6365      *                               2) The amount allowed by the owner if closer != owner
6366      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6367      * @param  exchangeWrapper       Address of the exchange wrapper
6368      * @param  payoutInHeldToken     True to pay out the payoutRecipient in heldToken,
6369      *                               False to pay out the payoutRecipient in owedToken
6370      * @param  order                 Order object to be passed to the exchange wrapper
6371      * @return                       Values corresponding to:
6372      *                               1) Principal of position closed
6373      *                               2) Amount of tokens (heldToken if payoutInHeldtoken is true,
6374      *                                  owedToken otherwise) received by the payoutRecipient
6375      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6376      */
6377     function closePosition(
6378         bytes32 positionId,
6379         uint256 requestedCloseAmount,
6380         address payoutRecipient,
6381         address exchangeWrapper,
6382         bool    payoutInHeldToken,
6383         bytes   order
6384     )
6385         external
6386         closePositionStateControl
6387         nonReentrant
6388         returns (uint256, uint256, uint256)
6389     {
6390         return ClosePositionImpl.closePositionImpl(
6391             state,
6392             positionId,
6393             requestedCloseAmount,
6394             payoutRecipient,
6395             exchangeWrapper,
6396             payoutInHeldToken,
6397             order
6398         );
6399     }
6400 
6401     /**
6402      * Helper to close a position by paying owedToken directly rather than using an exchangeWrapper.
6403      *
6404      * @param  positionId            Unique ID of the position
6405      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6406      *                               closed is also bounded by:
6407      *                               1) The principal of the position
6408      *                               2) The amount allowed by the owner if closer != owner
6409      * @param  payoutRecipient       Address of the recipient of tokens paid out from closing
6410      * @return                       Values corresponding to:
6411      *                               1) Principal amount of position closed
6412      *                               2) Amount of heldToken received by the payoutRecipient
6413      *                               3) Amount of owedToken paid (incl. interest fee) to the lender
6414      */
6415     function closePositionDirectly(
6416         bytes32 positionId,
6417         uint256 requestedCloseAmount,
6418         address payoutRecipient
6419     )
6420         external
6421         closePositionDirectlyStateControl
6422         nonReentrant
6423         returns (uint256, uint256, uint256)
6424     {
6425         return ClosePositionImpl.closePositionImpl(
6426             state,
6427             positionId,
6428             requestedCloseAmount,
6429             payoutRecipient,
6430             address(0),
6431             true,
6432             new bytes(0)
6433         );
6434     }
6435 
6436     /**
6437      * Reduce the size of a position and withdraw a proportional amount of heldToken from the vault.
6438      * Must be approved by both the position owner and lender.
6439      *
6440      * @param  positionId            Unique ID of the position
6441      * @param  requestedCloseAmount  Principal amount of the position to close. The actual amount
6442      *                               closed is also bounded by:
6443      *                               1) The principal of the position
6444      *                               2) The amount allowed by the owner if closer != owner
6445      *                               3) The amount allowed by the lender if closer != lender
6446      * @return                       Values corresponding to:
6447      *                               1) Principal amount of position closed
6448      *                               2) Amount of heldToken received by the msg.sender
6449      */
6450     function closeWithoutCounterparty(
6451         bytes32 positionId,
6452         uint256 requestedCloseAmount,
6453         address payoutRecipient
6454     )
6455         external
6456         closePositionStateControl
6457         nonReentrant
6458         returns (uint256, uint256)
6459     {
6460         return CloseWithoutCounterpartyImpl.closeWithoutCounterpartyImpl(
6461             state,
6462             positionId,
6463             requestedCloseAmount,
6464             payoutRecipient
6465         );
6466     }
6467 
6468     /**
6469      * Margin-call a position. Only callable with the approval of the position lender. After the
6470      * call, the position owner will have time equal to the callTimeLimit of the position to close
6471      * the position. If the owner does not close the position, the lender can recover the collateral
6472      * in the position.
6473      *
6474      * @param  positionId       Unique ID of the position
6475      * @param  requiredDeposit  Amount of deposit the position owner will have to put up to cancel
6476      *                          the margin-call. Passing in 0 means the margin call cannot be
6477      *                          canceled by depositing
6478      */
6479     function marginCall(
6480         bytes32 positionId,
6481         uint256 requiredDeposit
6482     )
6483         external
6484         nonReentrant
6485     {
6486         LoanImpl.marginCallImpl(
6487             state,
6488             positionId,
6489             requiredDeposit
6490         );
6491     }
6492 
6493     /**
6494      * Cancel a margin-call. Only callable with the approval of the position lender.
6495      *
6496      * @param  positionId  Unique ID of the position
6497      */
6498     function cancelMarginCall(
6499         bytes32 positionId
6500     )
6501         external
6502         onlyWhileOperational
6503         nonReentrant
6504     {
6505         LoanImpl.cancelMarginCallImpl(state, positionId);
6506     }
6507 
6508     /**
6509      * Used to recover the heldTokens held as collateral. Is callable after the maximum duration of
6510      * the loan has expired or the loan has been margin-called for the duration of the callTimeLimit
6511      * but remains unclosed. Only callable with the approval of the position lender.
6512      *
6513      * @param  positionId  Unique ID of the position
6514      * @param  recipient   Address to send the recovered tokens to
6515      * @return             Amount of heldToken recovered
6516      */
6517     function forceRecoverCollateral(
6518         bytes32 positionId,
6519         address recipient
6520     )
6521         external
6522         nonReentrant
6523         returns (uint256)
6524     {
6525         return ForceRecoverCollateralImpl.forceRecoverCollateralImpl(
6526             state,
6527             positionId,
6528             recipient
6529         );
6530     }
6531 
6532     /**
6533      * Deposit additional heldToken as collateral for a position. Cancels margin-call if:
6534      * 0 < position.requiredDeposit < depositAmount. Only callable by the position owner.
6535      *
6536      * @param  positionId       Unique ID of the position
6537      * @param  depositAmount    Additional amount in heldToken to deposit
6538      */
6539     function depositCollateral(
6540         bytes32 positionId,
6541         uint256 depositAmount
6542     )
6543         external
6544         onlyWhileOperational
6545         nonReentrant
6546     {
6547         DepositCollateralImpl.depositCollateralImpl(
6548             state,
6549             positionId,
6550             depositAmount
6551         );
6552     }
6553 
6554     /**
6555      * Cancel an amount of a loan offering. Only callable by the loan offering's payer.
6556      *
6557      * @param  addresses     Array of addresses:
6558      *
6559      *  [0] = owedToken
6560      *  [1] = heldToken
6561      *  [2] = loan payer
6562      *  [3] = loan owner
6563      *  [4] = loan taker
6564      *  [5] = loan position owner
6565      *  [6] = loan fee recipient
6566      *  [7] = loan lender fee token
6567      *  [8] = loan taker fee token
6568      *
6569      * @param  values256     Values corresponding to:
6570      *
6571      *  [0] = loan maximum amount
6572      *  [1] = loan minimum amount
6573      *  [2] = loan minimum heldToken
6574      *  [3] = loan lender fee
6575      *  [4] = loan taker fee
6576      *  [5] = loan expiration timestamp (in seconds)
6577      *  [6] = loan salt
6578      *
6579      * @param  values32      Values corresponding to:
6580      *
6581      *  [0] = loan call time limit (in seconds)
6582      *  [1] = loan maxDuration (in seconds)
6583      *  [2] = loan interest rate (annual nominal percentage times 10**6)
6584      *  [3] = loan interest update period (in seconds)
6585      *
6586      * @param  cancelAmount  Amount to cancel
6587      * @return               Amount that was canceled
6588      */
6589     function cancelLoanOffering(
6590         address[9] addresses,
6591         uint256[7]  values256,
6592         uint32[4]   values32,
6593         uint256     cancelAmount
6594     )
6595         external
6596         cancelLoanOfferingStateControl
6597         nonReentrant
6598         returns (uint256)
6599     {
6600         return LoanImpl.cancelLoanOfferingImpl(
6601             state,
6602             addresses,
6603             values256,
6604             values32,
6605             cancelAmount
6606         );
6607     }
6608 
6609     /**
6610      * Transfer ownership of a loan to a new address. This new address will be entitled to all
6611      * payouts for this loan. Only callable by the lender for a position. If "who" is a contract, it
6612      * must implement the LoanOwner interface.
6613      *
6614      * @param  positionId  Unique ID of the position
6615      * @param  who         New owner of the loan
6616      */
6617     function transferLoan(
6618         bytes32 positionId,
6619         address who
6620     )
6621         external
6622         nonReentrant
6623     {
6624         TransferImpl.transferLoanImpl(
6625             state,
6626             positionId,
6627             who);
6628     }
6629 
6630     /**
6631      * Transfer ownership of a position to a new address. This new address will be entitled to all
6632      * payouts. Only callable by the owner of a position. If "who" is a contract, it must implement
6633      * the PositionOwner interface.
6634      *
6635      * @param  positionId  Unique ID of the position
6636      * @param  who         New owner of the position
6637      */
6638     function transferPosition(
6639         bytes32 positionId,
6640         address who
6641     )
6642         external
6643         nonReentrant
6644     {
6645         TransferImpl.transferPositionImpl(
6646             state,
6647             positionId,
6648             who);
6649     }
6650 
6651     // ============ Public Constant Functions ============
6652 
6653     /**
6654      * Gets the address of the Vault contract that holds and accounts for tokens.
6655      *
6656      * @return  The address of the Vault contract
6657      */
6658     function getVaultAddress()
6659         external
6660         view
6661         returns (address)
6662     {
6663         return state.VAULT;
6664     }
6665 
6666     /**
6667      * Gets the address of the TokenProxy contract that accounts must set allowance on in order to
6668      * make loans or open/close positions.
6669      *
6670      * @return  The address of the TokenProxy contract
6671      */
6672     function getTokenProxyAddress()
6673         external
6674         view
6675         returns (address)
6676     {
6677         return state.TOKEN_PROXY;
6678     }
6679 }
6680 
6681 // File: contracts/margin/interfaces/OnlyMargin.sol
6682 
6683 /**
6684  * @title OnlyMargin
6685  * @author dYdX
6686  *
6687  * Contract to store the address of the main Margin contract and trust only that address to call
6688  * certain functions.
6689  */
6690 contract OnlyMargin {
6691 
6692     // ============ Constants ============
6693 
6694     // Address of the known and trusted Margin contract on the blockchain
6695     address public DYDX_MARGIN;
6696 
6697     // ============ Constructor ============
6698 
6699     constructor(
6700         address margin
6701     )
6702         public
6703     {
6704         DYDX_MARGIN = margin;
6705     }
6706 
6707     // ============ Modifiers ============
6708 
6709     modifier onlyMargin()
6710     {
6711         require(
6712             msg.sender == DYDX_MARGIN,
6713             "OnlyMargin#onlyMargin: Only Margin can call"
6714         );
6715 
6716         _;
6717     }
6718 }
6719 
6720 // File: contracts/margin/external/interfaces/PositionCustodian.sol
6721 
6722 /**
6723  * @title PositionCustodian
6724  * @author dYdX
6725  *
6726  * Interface to interact with other second-layer contracts. For contracts that own positions as a
6727  * proxy for other addresses.
6728  */
6729 interface PositionCustodian {
6730 
6731     /**
6732      * Function that is intended to be called by external contracts to see where to pay any fees or
6733      * tokens as a result of closing a position on behalf of another contract.
6734      *
6735      * @param  positionId   Unique ID of the position
6736      * @return              Address of the true owner of the position
6737      */
6738     function getPositionDeedHolder(
6739         bytes32 positionId
6740     )
6741         external
6742         view
6743         returns (address);
6744 }
6745 
6746 // File: contracts/margin/external/lib/MarginHelper.sol
6747 
6748 /**
6749  * @title MarginHelper
6750  * @author dYdX
6751  *
6752  * This library contains helper functions for interacting with Margin
6753  */
6754 library MarginHelper {
6755     function getPosition(
6756         address DYDX_MARGIN,
6757         bytes32 positionId
6758     )
6759         internal
6760         view
6761         returns (MarginCommon.Position memory)
6762     {
6763         (
6764             address[4] memory addresses,
6765             uint256[2] memory values256,
6766             uint32[6]  memory values32
6767         ) = Margin(DYDX_MARGIN).getPosition(positionId);
6768 
6769         return MarginCommon.Position({
6770             owedToken: addresses[0],
6771             heldToken: addresses[1],
6772             lender: addresses[2],
6773             owner: addresses[3],
6774             principal: values256[0],
6775             requiredDeposit: values256[1],
6776             callTimeLimit: values32[0],
6777             startTimestamp: values32[1],
6778             callTimestamp: values32[2],
6779             maxDuration: values32[3],
6780             interestRate: values32[4],
6781             interestPeriod: values32[5]
6782         });
6783     }
6784 }
6785 
6786 // File: contracts/margin/external/ERC20/ERC20Position.sol
6787 
6788 /**
6789  * @title ERC20Position
6790  * @author dYdX
6791  *
6792  * Shared code for ERC20Short and ERC20Long
6793  */
6794 contract ERC20Position is
6795     ReentrancyGuard,
6796     StandardToken,
6797     OnlyMargin,
6798     PositionOwner,
6799     IncreasePositionDelegator,
6800     ClosePositionDelegator,
6801     PositionCustodian
6802 {
6803     using SafeMath for uint256;
6804 
6805     // ============ Enums ============
6806 
6807     enum State {
6808         UNINITIALIZED,
6809         OPEN,
6810         CLOSED
6811     }
6812 
6813     // ============ Events ============
6814 
6815     /**
6816      * This ERC20 was successfully initialized
6817      */
6818     event Initialized(
6819         bytes32 positionId,
6820         uint256 initialSupply
6821     );
6822 
6823     /**
6824      * The position was completely closed by a trusted third-party and tokens can be withdrawn
6825      */
6826     event ClosedByTrustedParty(
6827         address closer,
6828         uint256 tokenAmount,
6829         address payoutRecipient
6830     );
6831 
6832     /**
6833      * The position was completely closed and tokens can be withdrawn
6834      */
6835     event CompletelyClosed();
6836 
6837     /**
6838      * A user burned tokens to withdraw heldTokens from this contract after the position was closed
6839      */
6840     event Withdraw(
6841         address indexed redeemer,
6842         uint256 tokensRedeemed,
6843         uint256 heldTokenPayout
6844     );
6845 
6846     /**
6847      * A user burned tokens in order to partially close the position
6848      */
6849     event Close(
6850         address indexed redeemer,
6851         uint256 closeAmount
6852     );
6853 
6854     // ============ State Variables ============
6855 
6856     // All tokens will initially be allocated to this address
6857     address public INITIAL_TOKEN_HOLDER;
6858 
6859     // Unique ID of the position this contract is tokenizing
6860     bytes32 public POSITION_ID;
6861 
6862     // Recipients that will fairly verify and redistribute funds from closing the position
6863     mapping (address => bool) public TRUSTED_RECIPIENTS;
6864 
6865     // Withdrawers that will fairly withdraw funds after the position has been closed
6866     mapping (address => bool) public TRUSTED_WITHDRAWERS;
6867 
6868     // Current State of this contract. See State enum
6869     State public state;
6870 
6871     // Address of the position's heldToken. Cached for convenience and lower-cost withdrawals
6872     address public heldToken;
6873 
6874     // Position has been closed using a trusted recipient
6875     bool public closedUsingTrustedRecipient;
6876 
6877     // ============ Modifiers ============
6878 
6879     modifier onlyPosition(bytes32 positionId) {
6880         require(
6881             POSITION_ID == positionId,
6882             "ERC20Position#onlyPosition: Incorrect position"
6883         );
6884         _;
6885     }
6886 
6887     modifier onlyState(State specificState) {
6888         require(
6889             state == specificState,
6890             "ERC20Position#onlyState: Incorrect State"
6891         );
6892         _;
6893     }
6894 
6895     // ============ Constructor ============
6896 
6897     constructor(
6898         bytes32 positionId,
6899         address margin,
6900         address initialTokenHolder,
6901         address[] trustedRecipients,
6902         address[] trustedWithdrawers
6903     )
6904         public
6905         OnlyMargin(margin)
6906     {
6907         POSITION_ID = positionId;
6908         state = State.UNINITIALIZED;
6909         INITIAL_TOKEN_HOLDER = initialTokenHolder;
6910         closedUsingTrustedRecipient = false;
6911 
6912         uint256 i;
6913         for (i = 0; i < trustedRecipients.length; i++) {
6914             TRUSTED_RECIPIENTS[trustedRecipients[i]] = true;
6915         }
6916         for (i = 0; i < trustedWithdrawers.length; i++) {
6917             TRUSTED_WITHDRAWERS[trustedWithdrawers[i]] = true;
6918         }
6919     }
6920 
6921     // ============ Margin-Only Functions ============
6922 
6923     /**
6924      * Called by Margin when anyone transfers ownership of a position to this contract.
6925      * This function initializes the tokenization of the position given and returns this address to
6926      * indicate to Margin that it is willing to take ownership of the position.
6927      *
6928      *  param  (unused)
6929      * @param  positionId  Unique ID of the position
6930      * @return             This address on success, throw otherwise
6931      */
6932     function receivePositionOwnership(
6933         address /* from */,
6934         bytes32 positionId
6935     )
6936         external
6937         onlyMargin
6938         nonReentrant
6939         onlyState(State.UNINITIALIZED)
6940         onlyPosition(positionId)
6941         returns (address)
6942     {
6943         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
6944         assert(position.principal > 0);
6945 
6946         // set relevant constants
6947         state = State.OPEN;
6948         heldToken = position.heldToken;
6949 
6950         uint256 tokenAmount = getTokenAmountOnAdd(position.principal);
6951 
6952         emit Initialized(POSITION_ID, tokenAmount);
6953 
6954         mint(INITIAL_TOKEN_HOLDER, tokenAmount);
6955 
6956         return address(this); // returning own address retains ownership of position
6957     }
6958 
6959     /**
6960      * Called by Margin when additional value is added onto the position this contract
6961      * owns. Tokens are minted and assigned to the address that added the value.
6962      *
6963      * @param  trader          Address that added the value to the position
6964      * @param  positionId      Unique ID of the position
6965      * @param  principalAdded  Amount that was added to the position
6966      * @return                 This address on success, throw otherwise
6967      */
6968     function increasePositionOnBehalfOf(
6969         address trader,
6970         bytes32 positionId,
6971         uint256 principalAdded
6972     )
6973         external
6974         onlyMargin
6975         nonReentrant
6976         onlyState(State.OPEN)
6977         onlyPosition(positionId)
6978         returns (address)
6979     {
6980         require(
6981             !Margin(DYDX_MARGIN).isPositionCalled(POSITION_ID),
6982             "ERC20Position#increasePositionOnBehalfOf: Position is margin-called"
6983         );
6984         require(
6985             !closedUsingTrustedRecipient,
6986             "ERC20Position#increasePositionOnBehalfOf: Position closed using trusted recipient"
6987         );
6988 
6989         uint256 tokenAmount = getTokenAmountOnAdd(principalAdded);
6990 
6991         mint(trader, tokenAmount);
6992 
6993         return address(this);
6994     }
6995 
6996     /**
6997      * Called by Margin when an owner of this token is attempting to close some of the
6998      * position. Implementation is required per PositionOwner contract in order to be used by
6999      * Margin to approve closing parts of a position.
7000      *
7001      * @param  closer           Address of the caller of the close function
7002      * @param  payoutRecipient  Address of the recipient of tokens paid out from closing
7003      * @param  positionId       Unique ID of the position
7004      * @param  requestedAmount  Amount (in principal) of the position being closed
7005      * @return                  1) This address to accept, a different address to ask that contract
7006      *                          2) The maximum amount that this contract is allowing
7007      */
7008     function closeOnBehalfOf(
7009         address closer,
7010         address payoutRecipient,
7011         bytes32 positionId,
7012         uint256 requestedAmount
7013     )
7014         external
7015         onlyMargin
7016         nonReentrant
7017         onlyState(State.OPEN)
7018         onlyPosition(positionId)
7019         returns (address, uint256)
7020     {
7021         uint256 positionPrincipal = Margin(DYDX_MARGIN).getPositionPrincipal(positionId);
7022 
7023         assert(requestedAmount <= positionPrincipal);
7024 
7025         uint256 allowedAmount;
7026         if (TRUSTED_RECIPIENTS[payoutRecipient]) {
7027             allowedAmount = closeUsingTrustedRecipient(
7028                 closer,
7029                 payoutRecipient,
7030                 requestedAmount
7031             );
7032         } else {
7033             allowedAmount = close(
7034                 closer,
7035                 requestedAmount,
7036                 positionPrincipal
7037             );
7038         }
7039 
7040         assert(allowedAmount > 0);
7041         assert(allowedAmount <= requestedAmount);
7042 
7043         if (allowedAmount == positionPrincipal) {
7044             state = State.CLOSED;
7045             emit CompletelyClosed();
7046         }
7047 
7048         return (address(this), allowedAmount);
7049     }
7050 
7051     // ============ Public State Changing Functions ============
7052 
7053     /**
7054      * Withdraw heldTokens from this contract for any of the position that was closed via external
7055      * means (such as an auction-closing mechanism)
7056      *
7057      * NOTE: It is possible that this contract could be sent heldToken by external sources
7058      * other than from the Margin contract. In this case the payout for token holders
7059      * would be greater than just that from the normal payout. This is fine because
7060      * nobody has incentive to send this contract extra funds, and if they do then it's
7061      * also fine just to let the token holders have it.
7062      *
7063      * NOTE: If there are significant rounding errors, then it is possible that withdrawing later is
7064      * more advantageous. An "attack" could involve withdrawing for others before withdrawing for
7065      * yourself. Likely, rounding error will be small enough to not properly incentivize people to
7066      * carry out such an attack.
7067      *
7068      * @param  onBehalfOf  Address of the account to withdraw for
7069      * @return             The amount of heldToken withdrawn
7070      */
7071     function withdraw(
7072         address onBehalfOf
7073     )
7074         external
7075         nonReentrant
7076         returns (uint256)
7077     {
7078         setStateClosedIfClosed();
7079         require(
7080             state == State.CLOSED,
7081             "ERC20Position#withdraw: Position has not yet been closed"
7082         );
7083 
7084         if (msg.sender != onBehalfOf) {
7085             require(
7086                 TRUSTED_WITHDRAWERS[msg.sender],
7087                 "ERC20Position#withdraw: Only trusted withdrawers can withdraw on behalf of others"
7088             );
7089         }
7090 
7091         return withdrawImpl(msg.sender, onBehalfOf);
7092     }
7093 
7094     // ============ Public Constant Functions ============
7095 
7096     /**
7097      * ERC20 decimals function. Returns the same number of decimals as the position's owedToken
7098      *
7099      * @return  The number of decimal places, or revert if the baseToken has no such function.
7100      */
7101     function decimals()
7102         external
7103         view
7104         returns (uint8);
7105 
7106     /**
7107      * ERC20 symbol function.
7108      *
7109      * @return  The symbol of the Margin Token
7110      */
7111     function symbol()
7112         external
7113         view
7114         returns (string);
7115 
7116     /**
7117      * Implements PositionCustodian functionality. Called by external contracts to see where to pay
7118      * tokens as a result of closing a position on behalf of this contract
7119      *
7120      * @param  positionId  Unique ID of the position
7121      * @return             Address of this contract. Indicates funds should be sent to this contract
7122      */
7123     function getPositionDeedHolder(
7124         bytes32 positionId
7125     )
7126         external
7127         view
7128         onlyPosition(positionId)
7129         returns (address)
7130     {
7131         // Claim ownership of deed and allow token holders to withdraw funds from this contract
7132         return address(this);
7133     }
7134 
7135     // ============ Internal Helper-Functions ============
7136 
7137     /**
7138      * Tokens are not burned when a trusted recipient is used, but we require the position to be
7139      * completely closed. All token holders are then entitled to the heldTokens in the contract
7140      */
7141     function closeUsingTrustedRecipient(
7142         address closer,
7143         address payoutRecipient,
7144         uint256 requestedAmount
7145     )
7146         internal
7147         returns (uint256)
7148     {
7149         assert(requestedAmount > 0);
7150 
7151         // remember that a trusted recipient was used
7152         if (!closedUsingTrustedRecipient) {
7153             closedUsingTrustedRecipient = true;
7154         }
7155 
7156         emit ClosedByTrustedParty(closer, requestedAmount, payoutRecipient);
7157 
7158         return requestedAmount;
7159     }
7160 
7161     // ============ Private Helper-Functions ============
7162 
7163     function withdrawImpl(
7164         address receiver,
7165         address onBehalfOf
7166     )
7167         private
7168         returns (uint256)
7169     {
7170         uint256 value = balanceOf(onBehalfOf);
7171 
7172         if (value == 0) {
7173             return 0;
7174         }
7175 
7176         uint256 heldTokenBalance = TokenInteract.balanceOf(heldToken, address(this));
7177 
7178         // NOTE the payout must be calculated before decrementing the totalSupply below
7179         uint256 heldTokenPayout = MathHelpers.getPartialAmount(
7180             value,
7181             totalSupply_,
7182             heldTokenBalance
7183         );
7184 
7185         // Destroy the margin tokens
7186         burn(onBehalfOf, value);
7187         emit Withdraw(onBehalfOf, value, heldTokenPayout);
7188 
7189         // Send the redeemer their proportion of heldToken
7190         TokenInteract.transfer(heldToken, receiver, heldTokenPayout);
7191 
7192         return heldTokenPayout;
7193     }
7194 
7195     function setStateClosedIfClosed(
7196     )
7197         private
7198     {
7199         // If in OPEN state, but the position is closed, set to CLOSED state
7200         if (state == State.OPEN && Margin(DYDX_MARGIN).isPositionClosed(POSITION_ID)) {
7201             state = State.CLOSED;
7202             emit CompletelyClosed();
7203         }
7204     }
7205 
7206     function close(
7207         address closer,
7208         uint256 requestedAmount,
7209         uint256 positionPrincipal
7210     )
7211         private
7212         returns (uint256)
7213     {
7214         uint256 balance = balances[closer];
7215 
7216         (
7217             uint256 tokenAmount,
7218             uint256 allowedCloseAmount
7219         ) = getCloseAmounts(
7220             requestedAmount,
7221             balance,
7222             positionPrincipal
7223         );
7224 
7225         require(
7226             tokenAmount > 0 && allowedCloseAmount > 0,
7227             "ERC20Position#close: Cannot close 0 amount"
7228         );
7229 
7230         assert(allowedCloseAmount <= requestedAmount);
7231 
7232         burn(closer, tokenAmount);
7233 
7234         emit Close(closer, tokenAmount);
7235 
7236         return allowedCloseAmount;
7237     }
7238 
7239     function burn(
7240         address from,
7241         uint256 amount
7242     )
7243         private
7244     {
7245         assert(from != address(0));
7246         totalSupply_ = totalSupply_.sub(amount);
7247         balances[from] = balances[from].sub(amount);
7248         emit Transfer(from, address(0), amount);
7249     }
7250 
7251     function mint(
7252         address to,
7253         uint256 amount
7254     )
7255         private
7256     {
7257         assert(to != address(0));
7258         totalSupply_ = totalSupply_.add(amount);
7259         balances[to] = balances[to].add(amount);
7260         emit Transfer(address(0), to, amount);
7261     }
7262 
7263     // ============ Private Abstract Functions ============
7264 
7265     function getTokenAmountOnAdd(
7266         uint256 principalAdded
7267     )
7268         internal
7269         view
7270         returns (uint256);
7271 
7272     function getCloseAmounts(
7273         uint256 requestedCloseAmount,
7274         uint256 balance,
7275         uint256 positionPrincipal
7276     )
7277         private
7278         view
7279         returns (
7280             uint256 /* tokenAmount */,
7281             uint256 /* allowedCloseAmount */
7282         );
7283 }
7284 
7285 // File: contracts/margin/external/ERC20/ERC20CappedPosition.sol
7286 
7287 /**
7288  * @title ERC20CappedPosition
7289  * @author dYdX
7290  *
7291  * ERC20 Position with a limit on the number of tokens that can be minted, and a restriction on
7292  * which addreses can close the position after it is force-recoverable.
7293  */
7294 contract ERC20CappedPosition is
7295     ERC20Position,
7296     Ownable
7297 {
7298     using SafeMath for uint256;
7299 
7300     // ============ Events ============
7301 
7302     event TokenCapSet(
7303         uint256 tokenCap
7304     );
7305 
7306     event TrustedCloserSet(
7307         address closer,
7308         bool allowed
7309     );
7310 
7311     // ============ State Variables ============
7312 
7313     mapping(address => bool) public TRUSTED_LATE_CLOSERS;
7314 
7315     uint256 public tokenCap;
7316 
7317     // ============ Constructor ============
7318 
7319     constructor(
7320         address[] trustedLateClosers,
7321         uint256 cap
7322     )
7323         public
7324         Ownable()
7325     {
7326         for (uint256 i = 0; i < trustedLateClosers.length; i++) {
7327             TRUSTED_LATE_CLOSERS[trustedLateClosers[i]] = true;
7328         }
7329         tokenCap = cap;
7330     }
7331 
7332     // ============ Owner-Only Functions ============
7333 
7334     function setTokenCap(
7335         uint256 newCap
7336     )
7337         external
7338         onlyOwner
7339     {
7340         // We do not need to require that the tokenCap is >= totalSupply_ because the cap is only
7341         // checked when increasing the position. It does not prevent any other functionality
7342         tokenCap = newCap;
7343         emit TokenCapSet(newCap);
7344     }
7345 
7346     function setTrustedLateCloser(
7347         address closer,
7348         bool allowed
7349     )
7350         external
7351         onlyOwner
7352     {
7353         TRUSTED_LATE_CLOSERS[closer] = allowed;
7354         emit TrustedCloserSet(closer, allowed);
7355     }
7356 
7357     // ============ Internal Overriding Functions ============
7358 
7359     // overrides the function in ERC20Position
7360     function closeUsingTrustedRecipient(
7361         address closer,
7362         address payoutRecipient,
7363         uint256 requestedAmount
7364     )
7365         internal
7366         returns (uint256)
7367     {
7368         MarginCommon.Position memory position = MarginHelper.getPosition(DYDX_MARGIN, POSITION_ID);
7369 
7370         bool afterEnd =
7371             block.timestamp > uint256(position.startTimestamp).add(position.maxDuration);
7372         bool afterCall =
7373             position.callTimestamp > 0 &&
7374             block.timestamp > uint256(position.callTimestamp).add(position.callTimeLimit);
7375 
7376         if (afterCall || afterEnd) {
7377             require (
7378                 TRUSTED_LATE_CLOSERS[closer],
7379                 "ERC20CappedPosition#closeUsingTrustedRecipient: closer not in TRUSTED_LATE_CLOSERS"
7380             );
7381         }
7382 
7383         return super.closeUsingTrustedRecipient(closer, payoutRecipient, requestedAmount);
7384     }
7385 }
7386 
7387 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
7388 
7389 /**
7390  * @title DetailedERC20 token
7391  * @dev The decimals are only for visualization purposes.
7392  * All the operations are done using the smallest and indivisible token unit,
7393  * just as on Ethereum all the operations are done in wei.
7394  */
7395 contract DetailedERC20 is ERC20 {
7396   string public name;
7397   string public symbol;
7398   uint8 public decimals;
7399 
7400   constructor(string _name, string _symbol, uint8 _decimals) public {
7401     name = _name;
7402     symbol = _symbol;
7403     decimals = _decimals;
7404   }
7405 }
7406 
7407 // File: contracts/lib/StringHelpers.sol
7408 
7409 /**
7410  * @title StringHelpers
7411  * @author dYdX
7412  *
7413  * This library helps with string manipulation in Solidity
7414  */
7415 library StringHelpers {
7416 
7417     /**
7418      * Concatenates two byte arrays and return the result
7419      *
7420      * @param  stringA  The string that goes first
7421      * @param  stringB  The string that goes second
7422      * @return          The two strings concatenated
7423      */
7424     function strcat(
7425         bytes stringA,
7426         bytes stringB
7427     )
7428         internal
7429         pure
7430         returns (bytes)
7431     {
7432         uint256 lengthA = stringA.length;
7433         uint256 lengthB = stringB.length;
7434         bytes memory result = new bytes(lengthA + lengthB);
7435 
7436         uint256 i = 0;
7437         for (i = 0; i < lengthA; i++) {
7438             result[i] = stringA[i];
7439         }
7440         for (i = 0; i < lengthB; i++) {
7441             result[lengthA + i] = stringB[i];
7442         }
7443         return result;
7444     }
7445 
7446     /**
7447      * Translates a bytes32 to an ascii hexadecimal representation starting with "0x"
7448      *
7449      * @param  input  The bytes to convert to hexadecimal
7450      * @return        A representation of the bytes in ascii hexadecimal
7451      */
7452     function bytes32ToHex(
7453         bytes32 input
7454     )
7455         internal
7456         pure
7457         returns (bytes)
7458     {
7459         uint256 number = uint256(input);
7460         bytes memory numberAsString = new bytes(66); // "0x" and then 2 chars per byte
7461         numberAsString[0] = byte(48);  // '0'
7462         numberAsString[1] = byte(120); // 'x'
7463 
7464         for (uint256 n = 0; n < 32; n++) {
7465             uint256 nthByte = number / uint256(uint256(2) ** uint256(248 - 8 * n));
7466 
7467             // 1 byte to 2 hexadecimal numbers
7468             uint8 hex1 = uint8(nthByte) / uint8(16);
7469             uint8 hex2 = uint8(nthByte) % uint8(16);
7470 
7471             // 87 is ascii for '0', 48 is ascii for 'a'
7472             hex1 += (hex1 > 9) ? 87 : 48; // shift into proper ascii value
7473             hex2 += (hex2 > 9) ? 87 : 48; // shift into proper ascii value
7474             numberAsString[2 * n + 2] = byte(hex1);
7475             numberAsString[2 * n + 3] = byte(hex2);
7476         }
7477         return numberAsString;
7478     }
7479 }
7480 
7481 // File: contracts/margin/external/ERC20/ERC20Long.sol
7482 
7483 /**
7484  * @title ERC20Long
7485  * @author dYdX
7486  *
7487  * Contract used to tokenize leveraged long positions and allow them to be used as ERC20-compliant
7488  * tokens. Holding the tokens allows the holder to close a piece of the position, or be
7489  * entitled to some amount of heldTokens after settlement.
7490  *
7491  * The total supply of leveraged long tokens is always exactly equal to the number of heldTokens
7492  * held in collateral in the backing position
7493  */
7494 contract ERC20Long is ERC20Position {
7495     constructor(
7496         bytes32 positionId,
7497         address margin,
7498         address initialTokenHolder,
7499         address[] trustedRecipients,
7500         address[] trustedWithdrawers
7501     )
7502         public
7503         ERC20Position(
7504             positionId,
7505             margin,
7506             initialTokenHolder,
7507             trustedRecipients,
7508             trustedWithdrawers
7509         )
7510     {}
7511 
7512     // ============ Public Constant Functions ============
7513 
7514     function decimals()
7515         external
7516         view
7517         returns (uint8)
7518     {
7519         return DetailedERC20(heldToken).decimals();
7520     }
7521 
7522     function symbol()
7523         external
7524         view
7525         returns (string)
7526     {
7527         if (state == State.UNINITIALIZED) {
7528             return "L[UNINITIALIZED]";
7529         }
7530         return string(
7531             StringHelpers.strcat(
7532                 "L",
7533                 bytes(DetailedERC20(heldToken).symbol())
7534             )
7535         );
7536     }
7537 
7538     function name()
7539         external
7540         view
7541         returns (string)
7542     {
7543         if (state == State.UNINITIALIZED) {
7544             return "dYdX Leveraged Long Token [UNINITIALIZED]";
7545         }
7546         return string(
7547             StringHelpers.strcat(
7548                 "dYdX Leveraged Long Token ",
7549                 StringHelpers.bytes32ToHex(POSITION_ID)
7550             )
7551         );
7552     }
7553 
7554     // ============ Private Functions ============
7555 
7556     function getTokenAmountOnAdd(
7557         uint256 /* principalAdded */
7558     )
7559         internal
7560         view
7561         returns (uint256)
7562     {
7563         // total supply should always equal position balance, except after closing with trusted
7564         // recipient, in which case this function cannot be called.
7565 
7566         uint256 positionBalance = Margin(DYDX_MARGIN).getPositionBalance(POSITION_ID);
7567         return positionBalance.sub(totalSupply_);
7568     }
7569 
7570     function getCloseAmounts(
7571         uint256 requestedCloseAmount,
7572         uint256 balance,
7573         uint256 positionPrincipal
7574     )
7575         private
7576         view
7577         returns (
7578             uint256 /* tokenAmount */,
7579             uint256 /* allowedCloseAmount */
7580         )
7581     {
7582         uint256 positionBalance = Margin(DYDX_MARGIN).getPositionBalance(POSITION_ID);
7583 
7584         uint256 requestedTokenAmount = MathHelpers.getPartialAmount(
7585             requestedCloseAmount,
7586             positionPrincipal,
7587             positionBalance
7588         );
7589 
7590         // if user has enough tokens, allow the close to occur
7591         if (requestedTokenAmount <= balance) {
7592             return (requestedTokenAmount, requestedCloseAmount);
7593         }
7594 
7595         // The maximum amount of principal able to be closed without using more heldTokens
7596         // than balance
7597         uint256 allowedCloseAmount = MathHelpers.getPartialAmount(
7598             balance,
7599             positionBalance,
7600             positionPrincipal
7601         );
7602 
7603         // the new close amount should not be higher than what was requested
7604         assert(allowedCloseAmount < requestedCloseAmount);
7605 
7606         uint256 allowedTokenAmount = MathHelpers.getPartialAmount(
7607             allowedCloseAmount,
7608             positionPrincipal,
7609             positionBalance
7610         );
7611 
7612         return (allowedTokenAmount, allowedCloseAmount);
7613     }
7614 }
7615 
7616 // File: contracts/margin/external/ERC20/ERC20CappedLong.sol
7617 
7618 /**
7619  * @title ERC20CappedLong
7620  * @author dYdX
7621  *
7622  * ERC20Long with a limit on the number of tokens that can be minted, and a restriction on
7623  * which addreses can close the position after it is force-recoverable.
7624  */
7625 contract ERC20CappedLong is
7626     ERC20Long,
7627     ERC20CappedPosition
7628 {
7629     using SafeMath for uint256;
7630 
7631     // ============ Constructor ============
7632 
7633     constructor(
7634         bytes32 positionId,
7635         address margin,
7636         address initialTokenHolder,
7637         address[] trustedRecipients,
7638         address[] trustedWithdrawers,
7639         address[] trustedLateClosers,
7640         uint256 cap
7641     )
7642         public
7643         ERC20Long(
7644             positionId,
7645             margin,
7646             initialTokenHolder,
7647             trustedRecipients,
7648             trustedWithdrawers
7649         )
7650         ERC20CappedPosition(
7651             trustedLateClosers,
7652             cap
7653         )
7654     {
7655     }
7656 
7657     // ============ Internal Overriding Functions ============
7658 
7659     function getTokenAmountOnAdd(
7660         uint256 principalAdded
7661     )
7662         internal
7663         view
7664         returns (uint256)
7665     {
7666         uint256 tokenAmount = super.getTokenAmountOnAdd(principalAdded);
7667 
7668         require(
7669             totalSupply_.add(tokenAmount) <= tokenCap,
7670             "ERC20CappedLong#getTokenAmountOnAdd: Adding tokenAmount would exceed cap"
7671         );
7672 
7673         return tokenAmount;
7674     }
7675 }